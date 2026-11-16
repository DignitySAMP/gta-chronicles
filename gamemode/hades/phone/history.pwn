
enum {

	E_PHONE_LOG_NONE = 0,
	E_PHONE_LOG_SMS,
	E_PHONE_LOG_CALL,
	E_PHONE_LOG_VOICEMAIL
}

enum {
	E_PHONE_LOG_STATUS_UNREAD = 0,
	E_PHONE_LOG_STATUS_READ,
}

enum {
	MAX_PHONE_LOGS = 64,
	INVALID_PHONE_LOG = -1
} ;

enum E_PHONE_LOGS {

	E_PHONE_LOG_SQLID,
	E_PHONE_LOG_TYPE,
	E_PHONE_LOG_STATUS,
	E_PHONE_LOG_SENDER,
	E_PHONE_LOG_RECIPIENT,
	E_PHONE_LOG_DATA[144],
	E_PHONE_LOG_UNIX // only keep logs for 30 days
	// If logs are full, tell player to make some space.
} ;


new PhoneLog [ MAX_PHONE_LOGS * MAX_PLAYERS] [ E_PHONE_LOGS ] ;
new Iterator:PhoneLogs<MAX_PHONE_LOGS>;

PhoneLog_LoadEntries() {

	for ( new i, j = sizeof(PhoneLog); i < j ; i ++ ) {

		PhoneLog [ i ] [ E_PHONE_LOG_SQLID ] = INVALID_PHONE_LOG ;
		PhoneLog [ i ] [ E_PHONE_LOG_TYPE ] = E_PHONE_LOG_NONE ;
		PhoneLog [ i ] [ E_PHONE_LOG_STATUS ] = E_PHONE_LOG_STATUS_UNREAD ;
		PhoneLog [ i ] [ E_PHONE_LOG_SENDER ] = INVALID_PHONE_LOG ;
		PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ] = INVALID_PHONE_LOG ;
		PhoneLog [ i ] [ E_PHONE_LOG_DATA ] [ 0 ] = EOS ;
		PhoneLog [ i ] [ E_PHONE_LOG_UNIX ] = 0 ;
	}

	printf(" * [PHONE HISTORY] Loading phone logs." ) ;

	inline PhoneLogs_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for ( new i; i < rows; i ++ ) {
				PhoneLog [ i ] [ E_PHONE_LOG_UNIX ] = cache_get_field_int (i, "phone_log_unix");
			
				if ( PhoneLog [ i ] [ E_PHONE_LOG_UNIX ] + 2678400 < gettime() ) {

					// The unix has been exceeded. Don't load it to preserve log space.
					continue ;
				}

				PhoneLog [ i ] [ E_PHONE_LOG_SQLID ] =  cache_get_field_int (i, "phone_log_sqlid");
				PhoneLog [ i ] [ E_PHONE_LOG_TYPE ] = cache_get_field_int (i, "phone_log_type");
				PhoneLog [ i ] [ E_PHONE_LOG_STATUS ] = cache_get_field_int (i, "phone_log_status");
				PhoneLog [ i ] [ E_PHONE_LOG_SENDER ] = cache_get_field_int (i, "phone_log_sender");
				PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ] = cache_get_field_int (i, "phone_log_recipient");

				cache_get_field_content ( i, "phone_log_data", PhoneLog [ i ] [ E_PHONE_LOG_DATA ] [ 0 ], mysql ) ;


				Iter_Add(PhoneLogs, i);
			}

			printf(" * [PHONE HISTORY] Loaded %d phone logs.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM phone_logs", using inline PhoneLogs_OnDataLoad, "" ) ;
}

PhoneLog_AddEntry(playerid, type, status, sender, recipient, data[]=""){

	new index = Iter_Free(PhoneLogs ) ;


	if(playerid != INVALID_PLAYER_ID ) {

		if(index == ITER_NONE ) {
			return SendClientMessage(playerid, COLOR_RED, "Your phone storage is full! Your last action has not been stored in history!");		
		}
	}

	PhoneLog [ index ] [E_PHONE_LOG_TYPE ] = type ;
	PhoneLog [ index ] [E_PHONE_LOG_STATUS ] = status ;

	PhoneLog [ index ] [E_PHONE_LOG_SENDER ] = sender ;
	PhoneLog [ index ] [E_PHONE_LOG_RECIPIENT ] = recipient ;

	format(PhoneLog [ index ] [E_PHONE_LOG_DATA ], 144, "%s", data ) ;
	PhoneLog [ index ] [E_PHONE_LOG_UNIX ] = gettime() + 2629743 ;

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO phone_logs \
		(phone_log_type, phone_log_status, phone_log_sender, phone_log_recipient, phone_log_data, phone_log_unix)\
	 VALUES (%d, %d, %d, %d, '%e', %d)",
	 	PhoneLog [ index ] [E_PHONE_LOG_TYPE ],
		PhoneLog [ index ] [E_PHONE_LOG_STATUS ],
		PhoneLog [ index ] [E_PHONE_LOG_SENDER ] ,
		PhoneLog [ index ] [E_PHONE_LOG_RECIPIENT ],
		PhoneLog [ index ] [E_PHONE_LOG_DATA ],
		PhoneLog [ index ] [E_PHONE_LOG_UNIX ]
	);

	print(query);

	inline PhoneLog_OnDatabaseInsert() {

		PhoneLog [ index ] [ E_PHONE_LOG_SQLID ] = cache_insert_id ();

		printf(" * [PHONE HISTORY] Created log (%d) with ID %d.", index, PhoneLog [ index ] [ E_PHONE_LOG_SQLID ] ) ;

		Iter_Add(PhoneLogs, index );
	}

	mysql_tquery_inline(mysql, query, using inline PhoneLog_OnDatabaseInsert, "");
}

PhoneLog_GetNumberBySQLID(sqlid ) {

	foreach(new phonelog_id: PhoneLogs) {

		if ( PhoneLog [ phonelog_id ] [ E_PHONE_LOG_SQLID ] == sqlid ) {

			return phonelog_id ;
		}
	}

	return INVALID_PHONE_LOG ;
}


PhoneLog_ViewEntries(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] = 1 ;
	}

	new MAX_ITEMS_ON_PAGE = 10, string [ 512 ], bool: nextpage ;

    new pages = floatround ( sizeof ( PhoneLog ) / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1, 
    	resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;

	format ( string, sizeof ( string ), "{DEDEDE}Status \t Type \t Number \t Expires On\n" ) ;

	new results [ MAX_PLAYER_CONTACTS ], results_incr, status[64], contact_name[64], expiredate[64], date[6]	 ;

    for_loop ( new i = resultcount; i < sizeof(PhoneLog); i ++ ) {

    	if ( PhoneLog [ i ] [ E_PHONE_LOG_SQLID ] == INVALID_PHONE_LOG ) {
    		continue ;
    	}
		
		resultcount ++ ;

	    if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] ) {

			if ( PhoneLog [ i ] [ E_PHONE_LOG_STATUS ] == E_PHONE_LOG_STATUS_UNREAD ) {
				format ( status, sizeof ( status ), "{deab1f}Unread{DEDEDE}" ) ;
			}
			else format ( status, sizeof ( status ), "{666666}Read{DEDEDE}" ) ;

			stamp2datetime ( PhoneLog [ i ] [E_PHONE_LOG_UNIX ], date[0], date[1], date[2], date[3], date[4], date[5], 1 );
			format ( expiredate, sizeof ( expiredate ), "%02d/%02d/%02d %02d:%02d:%02d", date[2], date[1], date[0], date[3], date[4], date[5]) ;

	    	switch ( PhoneLog [ i ] [ E_PHONE_LOG_TYPE ] ) {
	    		case E_PHONE_LOG_SMS: {

	    			if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_SENDER ] ) {

    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Outgoing SMS \t %d (%s) \t %s", string, status, PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name, expiredate ) ;
	    			}
	    			else if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ] ) {
    					
    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Incoming SMS \t %d (%s) \t %s",  string, status, PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name, expiredate ) ;
	    			}
	    		}
				case E_PHONE_LOG_CALL: {
	    			if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_SENDER ] ) {

    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Outgoing Call \t %d (%s) \t %s", string, status, PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name, expiredate ) ;
	    			}
	    			else if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ] ) {
    					
    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Incoming Call \t %d (%s) \t %s",  string, status, PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name, expiredate ) ;
	    			}
				}

				case E_PHONE_LOG_VOICEMAIL: {
	    			if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_SENDER ] ) {

    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Outgoing Voicemail \t %d (%s) \t %s", string, status, PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], contact_name, expiredate ) ;
	    			}
	    			else if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ] ) {
    					
    					Contact_GetSavedName(PhoneLog [ i ] [ E_PHONE_LOG_RECIPIENT ], PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name ) ;
	    				format ( string, sizeof ( string ), "%s%s \t Incoming Voicemail \t %d (%s) \t %s",  string, status, PhoneLog [ i ] [ E_PHONE_LOG_SENDER ], contact_name, expiredate ) ;
	    			}					
				}
	    	}

	   		results [ results_incr ] = PhoneLog [ i ] [ E_PHONE_LOG_SQLID ] ;
	   		results_incr++;
	   	}

     	if ( resultcount > MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] ) {

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

			if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] -- ;
				return PhoneLog_ViewEntries(playerid) ;
			}
		}

		else if ( response ) {

			if ( listitem == MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] ++ ;
				return PhoneLog_ViewEntries ( playerid ) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {

				new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;
 				new index = PhoneLog_GetNumberBySQLID(results [ selection ] ) ;

	       		printf("Selection %d, index %d, SQLID %d", selection, results [ selection ], index ) ;

 				if ( index == INVALID_PHONE_LOG ) {

 					return SendClientMessage(playerid, COLOR_ERROR, "Something went wrong. The stored phone log seems to be invalid.");
 				}

 				inline PhoneLog_Menu(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
					#pragma unused pidx, dialogidx, inputtextx

 					if(!responsex) {
 						return Contacts_ViewEntries(playerid); 
 					}
 					else if(responsex){
 						PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

 						switch(listitemx) {
 							case 0: SendClientMessage(playerid, -1, "Print");
 							case 1: SendClientMessage(playerid, -1, "Remove");
 						}
 					}
 				}

 				Dialog_ShowCallback ( playerid, using inline PhoneLog_Menu, DIALOG_STYLE_LIST, "Phone History: Modify Entry", "Print\nRemove", "Continue", "Back" );


 				return true ;
			}
		}
	}
	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ] > 1 ) {
   		Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Phone History: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ], pages), string, "Continue", "Previous" );
   	}

	else Dialog_ShowCallback ( playerid, using inline PhoneBookList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Phone History: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_HISTORY_PAGE ], pages), string, "Continue", "Close" );

	return true ;
}