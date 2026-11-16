/*
CMD:cradd(playerid, params[]) {

    if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new targetid, desc [ 128 ] ;

	if ( sscanf ( params, "k<player>s[128]", targetid, desc ) ) {

		return SendClientMessage(playerid, -1, "/c(riminal)r(ecord)add [playerid] [description]" ) ;
	}

	if ( strlen ( desc ) <= 0 || strlen ( desc ) > 128 ) {

		return SendClientMessage(playerid, -1, "Criminal record description can't be empty or longer than 128 characters." ) ;
	}

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof(query), "INSERT INTO criminalrecords(record_desc, record_date, record_holder, record_officer) VALUES ('%e', %d, '%e', '%e')",
		desc, gettime(), Character [ targetid ] [ E_CHARACTER_NAME ], Character [ playerid ] [ E_CHARACTER_NAME ] );

	mysql_tquery(mysql, query) ;

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has charged (%d) %s with \"%s\" }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), targetid, ReturnPlayerNameData ( targetid, 0, true ), desc
	), faction_enum_id, false ) ;

	if (IsPlayerNearPlayer(playerid, targetid, 25.0))
	{
		SendClientMessage(targetid, COLOR_ERROR, sprintf("(%d) %s %s charged you with: %s.", playerid, Character[playerid][E_CHARACTER_FACTIONRANK], ReturnPlayerNameData(playerid, 0, true), desc));
	}

 	return true ;
}

CMD:criminalrecordadd(playerid, params[]) {

	return cmd_cradd(playerid, params);
}
*/

enum E_CRIM_RECORD_BUFFER {
	E_CRIM_RECORD_ID,
	E_CRIM_RECORD_TIME,

	E_CRIM_RECORD_DESC[128],
	E_CRIM_RECORD_HOLDER[MAX_PLAYER_NAME],
	E_CRIM_RECORD_OFFICER[MAX_PLAYER_NAME]
}

#if !defined MAX_CRIMINAL_RECORDS
	#define MAX_CRIMINAL_RECORDS (150)
#endif 

#if !defined INVALID_CRIMINAL_RECORD_ID
	#define INVALID_CRIMINAL_RECORD_ID (-1)
#endif 

new CriminalRecordBuffer[MAX_PLAYERS][150][E_CRIM_RECORD_BUFFER];
static bool:ShowRecordAlert = false;

/*
CMD:viewcrimes(playerid, params[]) {
    
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new rpname[MAX_PLAYER_NAME] ;

	if ( sscanf ( params, "s[24]", rpname ) ) {

		return SendClientMessage(playerid, -1, "/viewcrimes [firstname_lastname]" ) ;
	}

	if ( strlen ( rpname ) <= 0 || strlen ( rpname ) > MAX_PLAYER_NAME ) {

		return SendClientMessage(playerid, -1, "Criminal record holder name can't be empty or longer than 24 characters." ) ;
	}


	ShowRecordAlert = true;
	CriminalRecord_FetchData(playerid, rpname);

	return true ;
}

CMD:criminalrecordview(playerid, params[]) {

	return cmd_viewcrimes(playerid, params);
}

CMD:viewrecord(playerid, params[]) {

	return cmd_viewcrimes(playerid, params);
}

CMD:viewcharges(playerid, params[]) {

	return cmd_viewcrimes(playerid, params);
}

CMD:crview(playerid, params[]) {

	return cmd_viewcrimes(playerid, params);
}
*/


CriminalRecord_FetchData(playerid, rpname[]) {
	new query [ 256 ] ;

	for_loop(new i, j = MAX_CRIMINAL_RECORDS; i < j ; i ++ ) {

		CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_ID] = INVALID_CRIMINAL_RECORD_ID ;
	}

	mysql_format(mysql, query, sizeof(query), "SELECT * FROM criminalrecords WHERE record_holder LIKE '%e'", rpname );

	inline Record_FetchEntries() {

		new rows, fields;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) { 

				CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_ID] = cache_get_field_int (i, "record_id");
				CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_TIME] = cache_get_field_int (i, "record_date");

				cache_get_field_content ( i, "record_desc", CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_DESC], mysql, 128 ) ;
				cache_get_field_content ( i, "record_holder", CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_HOLDER], mysql, MAX_PLAYER_NAME ) ;
				cache_get_field_content ( i, "record_officer", CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_OFFICER], mysql, MAX_PLAYER_NAME ) ;

				printf("Loaded criminal record ID %d (sql %d), time %d, desc %s, holder %s, officer %s", i,

					CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_ID],
					CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_TIME],
					CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_DESC],
					CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_HOLDER],
					CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_OFFICER]
				);


				CriminalRecord_ViewDialog(playerid);
			}

		}
		else
		{
			return SendClientMessage(playerid, 0xDEDEDEFF, "No criminal record found for this person.");
		}
	}

	mysql_tquery_inline(mysql, query, using inline Record_FetchEntries, "");

	if (ShowRecordAlert)
	{
		new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
		new faction_enum_id = Faction_GetEnumID( factionid ); 

		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s ran a criminal records check on \"%s\" }", Faction[faction_enum_id][E_FACTION_ABBREV], playerid, ReturnPlayerNameData(playerid, 0, true), rpname), faction_enum_id, false ) ;
	}
	
	ShowRecordAlert = false;

	return true ;
}

CriminalRecord_ViewDialog(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] = 1 ;
	}

	// Pagination stuff
	new MAX_ITEMS_ON_PAGE = 10, string [ 1024 ], buffer[128], bool: nextpage ;
    new resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;


	new year, month, day, hour, minute, second ;

	strcat(string, "Index \t Date Added \t Officer\n" ) ;

    for_loop ( new i = resultcount; i < MAX_CRIMINAL_RECORDS; i ++ ) {
    	if ( CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_ID] == INVALID_CRIMINAL_RECORD_ID ) {

    		continue ;
    	}

		resultcount ++ ;

        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] ) {


			stamp2datetime(CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_TIME], year, month, day, hour, minute, second, 1 ) ;
			format ( buffer, sizeof ( buffer ), "%s the %d%s of %s, %d", date_dayName(day, month, year), day, date_dayOrdinal (day), date_getMonth(month), year ) ;

			format(string, sizeof(string), "%s[ID: %d] \t [%s] \t [ %s]\n", string, 
				CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_ID], 
				buffer,
				CriminalRecordBuffer [playerid] [i] [E_CRIM_RECORD_OFFICER]); 
        }

     	if ( resultcount >= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] ) {

            nextpage = true;
            break;
        }
	}

	new pages = floatround ( resultcount / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1 ;

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	inline criminal_record_list(pid, dialogid, response, listitem, string: inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;

		if ( ! response ) {

			if ( PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] -- ;
			}
		}

		if ( response ) {

			if ( listitem >= MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] ++ ;
				return CriminalRecord_ViewDialog ( playerid ) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {

				if ( ! response ) {
					CriminalRecord_ViewDialog ( playerid ) ;
				}

				else if ( response ) {


					stamp2datetime(CriminalRecordBuffer [playerid] [selection] [E_CRIM_RECORD_TIME], year, month, day, hour, minute, second, 1 ) ;
					format ( buffer, sizeof ( buffer ), "%s the %d%s of %s, %d", date_dayName(day, month, year), day, date_dayOrdinal (day), date_getMonth(month), year ) ;

					SendClientMessage(playerid, -1, sprintf("ID: %d, Time: %s, Officer: %s",
						CriminalRecordBuffer [playerid] [selection] [E_CRIM_RECORD_ID], 
						buffer,
						CriminalRecordBuffer [playerid] [selection] [E_CRIM_RECORD_OFFICER]
					));
					SendClientMessage(playerid, -1, sprintf("Description: %s",
						CriminalRecordBuffer [playerid] [selection] [E_CRIM_RECORD_DESC]
					));
				}

 				return true ;
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ] > 1 ) {
		Dialog_ShowCallback ( playerid, using inline criminal_record_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Criminal Record: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ], pages), string, "Select", "Previous" ) ;
	}

	else Dialog_ShowCallback ( playerid, using inline criminal_record_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Criminal Record: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_CRIM_RECORD_PAGE ], pages), string, "Select", "Close" ) ;

	return true ;
}