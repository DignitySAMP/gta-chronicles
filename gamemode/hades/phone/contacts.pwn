enum E_CONTACT_DATA {

	E_CONTACT_SQLID,
	E_CONTACT_OWNER,
	E_CONTACT_NUMBER,
	E_CONTACT_DESC[64]
}  ; 

enum {

	MAX_PLAYER_CONTACTS = 100,
	INVALID_PLAYER_CONTACT = -1
}

new Contact [ MAX_PLAYER_CONTACTS*MAX_PLAYERS ] [ E_CONTACT_DATA ] ;
new Iterator: Contacts<MAX_PLAYER_CONTACTS*MAX_PLAYERS>;

Contacts_LoadEntries() {

	for(new i, j = (MAX_PLAYER_CONTACTS*MAX_PLAYERS); i < j ; i ++ ) {
		Contact [ i ] [ E_CONTACT_SQLID ] = INVALID_PLAYER_CONTACT ;
		Contact [ i ] [ E_CONTACT_OWNER ] = INVALID_PLAYER_ID ;

		Contact [ i ] [ E_CONTACT_NUMBER ] = -1 ;
		Contact [ i ] [ E_CONTACT_DESC ] [ 0 ] = EOS ;
	}

	inline Contacts_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for ( new i; i < rows; i ++ ) {

				Contact [ i ] [ E_CONTACT_SQLID ] = cache_get_field_int (i, "phone_contact_sqlid");
				Contact [ i ] [ E_CONTACT_OWNER ]  = cache_get_field_int (i, "phone_contact_owner");
				Contact [ i ] [ E_CONTACT_NUMBER ] = cache_get_field_int (i, "phone_contact_number");

				cache_get_field_content ( i, "phone_contact_desc", Contact[ i ] [ E_CONTACT_DESC ], mysql ) ;
			
				Iter_Add(Contacts, i);
			}

			printf(" * [CONTACTS] Loaded %d contacts.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM phone_contacts", using inline Contacts_OnDataLoad, "" ) ;

}

Contact_GetSavedName(fornumber, savednumber, name[], len=sizeof(name)) {

	new bool: match = false ;

	foreach(new contact_id: Contacts ) {

		if ( Contact [ contact_id ] [ E_CONTACT_OWNER ] == fornumber ) {

			if ( Contact [ contact_id ] [ E_CONTACT_NUMBER ] == savednumber ) {

				format ( name, len, "%s", Contact [ contact_id ] [ E_CONTACT_DESC ] ) ;
				match = true ;
				
				break ;
			}
		}
	}

	if(!match) {

		format ( name, len, "Unknown" ) ;
	}
}

CMD:contacts(playerid, params[]) {

	inline PhoneBookList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		if(response){
			switch ( listitem ) {

				case 0: {

					inline PhoneBookList_Chc(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
						#pragma unused dialogidx, pidx, inputtextx
						if(!responsex) {
							return cmd_contacts(playerid, params);
						}
						else if(responsex) {
							switch(listitemx) {
								case 0:	Contacts_ViewEntries(playerid, 0) ;
								case 1:	Contacts_ViewEntries(playerid, 1) ;
								case 2:	Contacts_ViewEntries(playerid, 2) ;
							}
						}
					}
					Dialog_ShowCallback ( playerid, using inline PhoneBookList_Chc, DIALOG_STYLE_LIST, "Phonebook", "Online\nOffline\nAll", "Continue", "Close" );

				}
				case 1: Contacts_AddContact(playerid) ;
			}
		}
	}

	Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_LIST, "Phonebook", "View Contacts\nAdd Contacts", "Continue", "Close" );

	return true ;
}

Contacts_ViewEntries(playerid, type=3) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] = 1 ;
	}

	new MAX_ITEMS_ON_PAGE = 10, string [ 512 ], bool: nextpage ;

    new resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;

	format ( string, sizeof ( string ), "Number \t Description\n" ) ;

	new results [ MAX_PLAYER_CONTACTS ], results_incr ;

	#warning Add "share contact" which is print but sent to targetid!
    for_loop ( new i = resultcount; i < sizeof(Contact); i ++ ) {

    	if ( Contact [ i ] [ E_CONTACT_SQLID ] == INVALID_PLAYER_CONTACT ) {
    		continue ;
    	}
		
		if ( Contact [ i ] [ E_CONTACT_OWNER ] != Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) {
			continue ;
		}

		resultcount ++ ;

	    if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ) {

	    	switch(type){

	    		case 0: { // online
	    			foreach(new targetid: Player) {

	    				if ( Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] == Contact [ i ] [ E_CONTACT_NUMBER ] ) {
							format ( string, sizeof ( string ), "%s%d \t %s\n", string, Contact [ i ] [ E_CONTACT_NUMBER ], Contact [ i ] [ E_CONTACT_DESC ]  ) ;
		   					results [ results_incr ] = Contact [ i ] [ E_CONTACT_SQLID ] ;
		   					results_incr++;
	    				}
	    			}
	    		}
	    		case 1: { // offline
	    			foreach(new targetid: Player) {

	    				if ( Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] == Contact [ i ] [ E_CONTACT_NUMBER ] ) {
	    					continue ;
	    				}

	    				else {
							format ( string, sizeof ( string ), "%s%d \t %s\n", string, Contact [ i ] [ E_CONTACT_NUMBER ], Contact [ i ] [ E_CONTACT_DESC ]  ) ;
		   					results [ results_incr ] = Contact [ i ] [ E_CONTACT_SQLID ] ;
		   					results_incr++;
	    				}
	    			}
	    		}
	    		case 2: { // all
					format ( string, sizeof ( string ), "%s%d \t %s\n", string, Contact [ i ] [ E_CONTACT_NUMBER ], Contact [ i ] [ E_CONTACT_DESC ]  ) ;
   					results [ results_incr ] = Contact [ i ] [ E_CONTACT_SQLID ] ;
   					results_incr++;
	    		}
	    	}

	   	}

     	if ( resultcount > MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ) {

            nextpage = true;
            break;
        }
	}

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	inline PhoneBookList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		if ( ! response ) {

			if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] -- ;
				return Contacts_ViewEntries(playerid, type) ;
			}
		}

		else if ( response ) {

			if ( listitem == MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ++ ;
				return Contacts_ViewEntries ( playerid, type ) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {

				new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;
 				new index = Contacts_GetNumberBySQLID(results [ selection ] ) ;


	       		printf("Selection %d, index %d, SQLID %d", selection, results [ selection ], index ) ;

 				if ( index == INVALID_PLAYER_CONTACT ) {

 					return SendClientMessage(playerid, COLOR_ERROR, "Something went wrong. The stored contact seems to be invalid.");
 				}

 				inline PhoneBook_Menu(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
					#pragma unused pidx, dialogidx, inputtextx

 					if(!responsex) {
 						return Contacts_ViewEntries(playerid, type); 
 					}
 					else if(responsex){
 						PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

 						switch(listitemx) {
 							case 0: {

				 				SendClientMessage(playerid, COLOR_YELLOW, sprintf("Contact ID: %d - Phone Number: %d - Description: %s", 
				 					Contact [ index ] [ E_CONTACT_SQLID ], Contact [ index ] [ E_CONTACT_NUMBER ], Contact [ index ] [ E_CONTACT_DESC ] 
				 				)) ;
 							}

 							case 1: Contacts_EditContact(playerid, Contact [ index ] [ E_CONTACT_SQLID ] );
 							case 2: Contacts_RemoveContact(playerid, Contact [ index ] [ E_CONTACT_SQLID ]);
 						}
 					}
 				}

 				Dialog_ShowCallback ( playerid, using inline PhoneBook_Menu, DIALOG_STYLE_LIST, "Phonebook: Modify Contact", "Print\nEdit\nRemove", "Continue", "Back" );


 				return true ;
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] > 1 ) {
   	
    	switch(type){

    		case 0: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (Online): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ), string, "Continue", "Previous" );
    		case 1: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (Offline): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ), string, "Continue", "Previous" );
    		case 2: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (All): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ]), string, "Continue", "Previous" );
 
    	}

  	}

	else {

    	switch(type){

    		case 0: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (Online): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ), string, "Continue", "Close" );
    		case 1: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (Offline): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ] ), string, "Continue", "Close" );
    		case 2: Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Contacts (All): Page %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_PHONEBOOK_PAGE ]), string, "Continue", "Close" );
    	}
    }

	return true ;
}


Contacts_EditContact(playerid, sqlid) {

	new index = Contacts_GetNumberBySQLID(sqlid),  query [ 256 ] ;

	if ( index == INVALID_PLAYER_CONTACT ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Something went wrong. The stored contact seems to be invalid.");
	}

	inline PhoneBookList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext, listitem

		if ( response ) {

			if(!IsNumeric(inputtext)) {

				SendClientMessage(playerid, COLOR_ERROR, "The number you enter must be numeric! Make sure to only enter digits." ) ;
				return true ;
			}

			inline PhoneBookList_Edit(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {

				#pragma unused pidx, dialogidx, listitemx

				if(!responsex) {
					Contacts_ViewEntries(playerid);
					return true ;
				}

				else if ( responsex ) {

					SendClientMessage(playerid, COLOR_YELLOW, sprintf("Old contact: %d - %s", Contact [ index ] [ E_CONTACT_NUMBER ], Contact [ index ] [ E_CONTACT_DESC ] ));

					Contact [ index ] [ E_CONTACT_NUMBER ] = strval(inputtext) ;
					format ( Contact [ index ] [ E_CONTACT_DESC ], 64, "%s", inputtextx);


					SendClientMessage(playerid, COLOR_YELLOW, sprintf("New contact: %d - %s", Contact [ index ] [ E_CONTACT_NUMBER ], Contact [ index ] [ E_CONTACT_DESC ] ));

					mysql_format(mysql, query, sizeof ( query ), 
						"UPDATE phone_contacts SET phone_contact_number = %d, phone_contact_desc = '%e' WHERE phone_contact_sqlid = %d",
						Contact [ index ] [ E_CONTACT_NUMBER ], Contact [ index ] [ E_CONTACT_DESC ], Contact [ index ] [ E_CONTACT_SQLID ]
					);

					mysql_tquery(mysql, query );
				}
			}

			Dialog_ShowCallback ( playerid, using inline PhoneBookList_Edit, DIALOG_STYLE_INPUT, "Phonebook", 
				sprintf("Enter the new description of this contact.\n\nPrevious: %s", Contact [ index ] [ E_CONTACT_DESC ]), "Continue", "Close" );
		}
	}

	Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_INPUT, "Phonebook", 
		sprintf("Enter the new phone number of this contact.\n\nPrevious: %d", Contact [ index ] [ E_CONTACT_NUMBER ]), "Continue", "Close" );

	return true ;
}

Contacts_AddContact(playerid) {

	inline PhoneBookList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext, listitem

		if ( response ) {

			if(!IsNumeric(inputtext)) {

				SendClientMessage(playerid, COLOR_ERROR, "The number you enter must be numeric! Make sure to only enter digits." ) ;
				return true ;
			}

			inline PhoneBookList_Add(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {

				#pragma unused pidx, dialogidx, listitemx

				if(!responsex) {
					Contacts_AddContact(playerid);
					return true ;
				}

				else if ( responsex ) {
					Contacts_SaveEntry(playerid, strval(inputtext), inputtextx);
					return true ;
				}
			}

			Dialog_ShowCallback ( playerid, using inline PhoneBookList_Add, DIALOG_STYLE_INPUT, "Phonebook", "Enter the name you wish to assign.", "Continue", "Close" );
		}
	}

	Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_INPUT, "Phonebook", "Enter the number you wish to save.", "Continue", "Close" );

	return true ;
}

Contacts_RemoveContact(playerid, sqlid) {

	new index = Contacts_GetNumberBySQLID(sqlid),  query [ 256 ] ;

	if ( index == INVALID_PLAYER_CONTACT ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Something went wrong. The stored contact seems to be invalid.");
	}

	inline PhoneBookList_Delete(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext, listitem

		if(!response) {
			Contacts_ViewEntries(playerid);
			return true ;
		}

		if ( response ) {

			query[0]=EOS;

			SendClientMessage(playerid, COLOR_YELLOW, sprintf("You have deleted your contact with ID %d:", Contact [ index ] [ E_CONTACT_SQLID ] ));
			SendClientMessage(playerid, COLOR_YELLOW, sprintf("Number: %d (%s)", Contact [ index ] [ E_CONTACT_NUMBER ], Contact[ index ] [ E_CONTACT_DESC ] ));

			mysql_format(mysql, query, sizeof ( query ), "DELETE FROM phone_contacts WHERE phone_contact_sqlid = %d", Contact [ index ] [ E_CONTACT_SQLID ] ) ;
			mysql_tquery(mysql, query);

			Contact [ index ] [ E_CONTACT_SQLID ] = INVALID_PLAYER_CONTACT ;
			Contact [ index ] [ E_CONTACT_OWNER ]  = 0 ;
			Contact [ index ] [ E_CONTACT_NUMBER ] = 0 ;

			Contact[ index ] [ E_CONTACT_DESC ] [ 0 ] = EOS ;

			Iter_Remove(Contacts, index);

			return true ;
		}
	}

	format ( query, sizeof ( query ), "Are you sure you wish to delete the following contact:\n\n%d (%s)\n\nThis action is irreversible.", Contact [ index ] [ E_CONTACT_NUMBER ],  Contact [ index ] [ E_CONTACT_DESC ] ) ;
	Dialog_ShowCallback ( playerid, using inline PhoneBookList_Delete, DIALOG_STYLE_MSGBOX, "Phonebook", query, "Delete", "Cancel" );

	return true ;
}

Contacts_GetNumberBySQLID(sqlid ) {

	foreach(new contact_id: Contacts) {

		if ( Contact [ contact_id ] [ E_CONTACT_SQLID ] == sqlid ) {

			return contact_id ;
		}
	}

	return INVALID_PLAYER_CONTACT ;
}


Contacts_SaveEntry(playerid, number, desc[]) {

	new index = Iter_Free(Contacts);

	Contact [ index ] [ E_CONTACT_OWNER ] = Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ;
	Contact [ index ] [ E_CONTACT_NUMBER ] = number ;
	format ( Contact[ index ] [ E_CONTACT_DESC ], 64, "%s", desc);

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO phone_contacts (phone_contact_owner, phone_contact_number, phone_contact_desc) VALUES (%d, %d, '%e')",
		Contact [ index ] [ E_CONTACT_OWNER ],
		Contact [ index ] [ E_CONTACT_NUMBER ],
		Contact [ index ] [ E_CONTACT_DESC ]	
	);

	print(query);

	inline Contact_OnDatabaseInsert() {

		Contact [ index ] [ E_CONTACT_SQLID ] = cache_insert_id ();

		printf(" * [CONTACTS] Created contact (%d) with ID %d.", index, Contact [ index ] [ E_CONTACT_SQLID ] ) ;

		Iter_Add(Contacts, index );
	}

	mysql_tquery_inline(mysql, query, using inline Contact_OnDatabaseInsert, "");

	Contacts_EditContact(playerid, Contact [ index ] [ E_CONTACT_SQLID ]);

	return true ;
}

Contacts_MatchEntries_Number(playerid, input[]) {

	if ( ! IsNumeric ( input ) ) {

		foreach(new contact_id: Contacts) {
			if ( Contact [ contact_id ] [ E_CONTACT_OWNER ] ==Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) {
				if(strfind(Contact[ contact_id ] [ E_CONTACT_DESC ], input, true) != -1) {

		        	return Contact[ contact_id ] [ E_CONTACT_NUMBER ] ;
		        }
		    }
		}
	}

	return strval(input) ;
}

Contacts_MatchEntries(playerid, input[]) {
	// Checks input as in contact name or phone number for use in /call, /sms and returns the owner ID.

	if ( IsNumeric ( input ) ) {

		foreach(new targetid: Player) {

			if ( Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] == strval ( input ) ) {
				return targetid ;
			}
		}
	}

	else {

		new matches, result ;

		foreach(new contact_id: Contacts) {
			if ( Contact [ contact_id ] [ E_CONTACT_OWNER ] ==Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) {
				if(strfind(Contact[ contact_id ] [ E_CONTACT_DESC ], input, true) != -1) {

		        	result = Contact[ contact_id ] [ E_CONTACT_NUMBER ] ;
		        	matches ++ ;
		        }
		    }
		}

		if ( matches <= 0 ) {
			SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("Tried reaching contact with name \"%s\", but they don't exist.", input)) ;		
			return -2 ;
		}
		else if ( matches > 1 ) {
			SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("Found multiple contacts with prefix \"%s\", be more specific!", input)) ;		
			return -2 ;
		}
		else if ( matches == 1 ) {

			matches = 0 ;

			foreach(new contact_id: Contacts) {

				if ( Contact [ contact_id ] [ E_CONTACT_OWNER ] == Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) {
					if ( Contact [ contact_id ] [ E_CONTACT_NUMBER ] == result ) {
						foreach(new targetid: Player) {

							if ( Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] == result ) {
								return targetid ;
							}
						}
					} 
					else continue ;
				}
			}

			return INVALID_PLAYER_ID ;
		}
	}

	return INVALID_PLAYER_ID ;
}