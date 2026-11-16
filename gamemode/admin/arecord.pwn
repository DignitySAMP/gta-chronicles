
enum {

	ARECORD_TYPE_KICK,
	ARECORD_TYPE_AJAIL,
	ARECORD_TYPE_BAN
}

enum adminRecordData {

	record_id,
	E_ADMIN_RECORD_ACCOUNT_ID,

	record_type,
	record_reason [ 64 ],
	record_time,
	record_admin,
	record_date [ 36 ]

} ;

#define MAX_ARECORD_CHARGES	( 100 )	
new AdminRecord [ MAX_PLAYERS ] [ MAX_ARECORD_CHARGES ] [ adminRecordData ] ;

SetAdminRecord ( accountid, adminid, type, reason[], time, date[] ) {

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO admin_record (account_id, record_type, record_reason, record_time, record_admin, record_date) VALUES (%d, %d, '%e', %d, %d, '%e')", accountid, type, reason, time, adminid, date ) ;
	mysql_tquery ( mysql, query ) ;

	return true ;
}

new PlayerLastARecPage [ MAX_PLAYERS ] ;
CMD:adminrecord(playerid, params[] ) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		Init_AdminRecord ( playerid, playerid ) ;

	}
	else if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR ) {

		new targetid ;

		if ( sscanf ( params, "k<player>", targetid ) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/adminrecord [targetid]") ;
		}

		if ( ! IsPlayerConnected ( targetid ) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.") ;
		}

		Init_AdminRecord ( targetid, playerid ) ;
	}


	return true ;
}

Init_AdminRecord ( playerid, forplayerid ) {

	new query [ 1024 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM `admin_record` WHERE account_id='%d' ORDER BY record_id DESC LIMIT 10", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] );
	mysql_tquery ( mysql, query, "LoadAdminRecord", "ii", playerid, forplayerid ) ;

	SendClientMessage(forplayerid, COLOR_SERVER, "Loading admin record, one moment..." ); 


	return true ;
}

forward LoadAdminRecord ( playerid, forplayerid ) ;
public LoadAdminRecord ( playerid, forplayerid ) {
	new rows, fields ;

	cache_get_data ( rows, fields, mysql ) ;

	if ( rows ) {

		for_loop ( new i; i < rows; i ++ ) {

			AdminRecord [ playerid ] [ i ] [ record_id ] 		= cache_get_field_int ( i, "record_id" ) ;
			AdminRecord [ playerid ] [ i ] [ E_ADMIN_RECORD_ACCOUNT_ID ] 		= cache_get_field_int ( i, "account_id" ) ;

			AdminRecord [ playerid ] [ i ] [ record_type ] 		= cache_get_field_int ( i, "record_type" ) ;

			cache_get_field_content ( i, "record_reason", 	AdminRecord [ playerid ] [ i ][ record_reason ], mysql, 64 ) ;

			AdminRecord [ playerid ] [ i ] [ record_time ] 		= cache_get_field_int ( i, "record_time" ) ;
			AdminRecord [ playerid ] [ i ] [ record_admin ] 	= cache_get_field_int ( i, "record_admin" ) ;

			cache_get_field_content ( i, "record_date", 	AdminRecord [ playerid ] [ i ] [ record_date ], 	mysql, 36 ) ;
		}

		defer AdminRecordDelay(playerid, forplayerid);
    }

    else if ( ! rows ) {

    	SendClientMessage ( forplayerid, COLOR_YELLOW, "This player does not have an admin record.");
    }

    return true ;
}


timer AdminRecordDelay[1000](playerid, forplayerid) {

	PlayerLastARecPage [ forplayerid ] = 1 ;
	return ShowAdminRecord ( playerid, forplayerid) ;
}


static AdminRecordDlgStr[2048];

RevokeRecord(playerid, forplayerid, recordid)
{
	inline AdminRecordRemove(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, dialogid, inputtext, listitem, response

		if (response && GetPlayerAdminLevel(forplayerid) >= ADMIN_LVL_SENIOR && recordid) 
		{
			new query[128];
			mysql_format ( mysql, query, sizeof ( query ), "DELETE FROM `admin_record` WHERE record_id = %d", recordid);

			inline Record_OnRevoke() 
			{
				if (!cache_affected_rows(mysql)) return SendServerMessage(forplayerid, COLOR_ERROR, "Error", "A3A3A3", "There was an error removing this record (it might already be revoked)");
				SendAdminMessage(sprintf("(%d) %s has removed Admin Record #%d of (%d) %s", forplayerid, SOLS_PlayerName(forplayerid, PLAYER_NAME_STYLE_ACCOUNT), recordid, playerid, ReturnPlayerNameData(playerid)));
				AddLogEntry(forplayerid, LOG_TYPE_ADMIN, sprintf("Revoked Admin Record %d of %s", recordid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT)));
			}

			mysql_tquery_inline(mysql, query, using inline Record_OnRevoke, "");
		}
		else if (!response)
		{
			ShowAdminRecord(playerid, forplayerid);
		}
	}

	
	format(AdminRecordDlgStr, sizeof ( AdminRecordDlgStr ), "You are about to revoke Admin Record #%d for %s\nPress OK to continue.", recordid, ReturnPlayerNameData(playerid));
	Dialog_ShowCallback ( forplayerid, using inline AdminRecordRemove, DIALOG_STYLE_MSGBOX, "Admin Record", AdminRecordDlgStr, "OK", "Back" );
	return true;
}

ShowAdminRecord(playerid, forplayerid) 
{
	new map[MAX_ARECORD_CHARGES];

	inline AdminRecordList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext, listitem, response

		if (response && GetPlayerAdminLevel(forplayerid) < ADMIN_LVL_SENIOR) 
		{
			ShowAdminRecord(playerid, forplayerid);
			return SendClientMessage(forplayerid, COLOR_YELLOW, "For a more detailed version, view the admin UCP.");
		}
		else if (response)
		{
			new i = map[listitem];
			RevokeRecord(playerid, forplayerid, AdminRecord [ playerid ] [ i ] [ record_id ]);
		}
	}

	new reason [ 20 ], temp [ 64 ], title [ 64 ], count = 0;

    format(AdminRecordDlgStr, sizeof ( AdminRecordDlgStr ), "Record ID\tType\tDate\tDescription\n");

	for_loop ( new i ; i < MAX_ARECORD_CHARGES; i ++ ) {

		if ( AdminRecord [ playerid ] [ i ] [ record_id ] != -1 && AdminRecord [ playerid ] [ i ] [ E_ADMIN_RECORD_ACCOUNT_ID ] == Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {

			switch ( AdminRecord [ playerid ] [ i ] [ record_type ] ) {

				case ARECORD_TYPE_KICK : 	format ( reason, sizeof ( reason ), "Kick" ) ;
				case ARECORD_TYPE_AJAIL : 	format ( reason, sizeof ( reason ), "Admin-jail" ) ;
				case ARECORD_TYPE_BAN : 	format ( reason, sizeof ( reason ), "Account Ban" ) ;
			}

			format ( temp, sizeof ( temp ), "%s", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;

			if ( strlen ( AdminRecord [ playerid ] [ i ] [ record_reason ] ) > 50  ) {

				format ( temp, sizeof ( temp ), "%.50s...", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;
			}

			format ( AdminRecordDlgStr, sizeof ( AdminRecordDlgStr ), "%s%d\t%s\t%s\t%s\n", AdminRecordDlgStr, AdminRecord [ playerid ] [ i ] [ record_id ], reason, AdminRecord [ playerid ] [ i ] [ record_date ], temp ) ;

			map[count] = i;
			count ++;
		}
	}

	format ( title, sizeof ( title ), "(%d) %s's admin record", playerid, ReturnPlayerNameData ( playerid )) ;

	if (GetPlayerAdminLevel(forplayerid) < ADMIN_LVL_SENIOR)
	{
 		Dialog_ShowCallback ( forplayerid, using inline AdminRecordList, DIALOG_STYLE_TABLIST_HEADERS, title, AdminRecordDlgStr, "Back" );
	}
	else
	{
		Dialog_ShowCallback ( forplayerid, using inline AdminRecordList, DIALOG_STYLE_TABLIST_HEADERS, title, AdminRecordDlgStr, "Remove", "Back" );
	}

 	return true ;
}

/*
ShowAdminRecord ( playerid, forplayerid ) {

	new MAX_ITEMS_ON_PAGE = 20, string [ 2048 ], bool: nextpage, reason [ 64 ], temp [ 32 ] ;

    new pages = floatround ( GetPlayerPenaltyCount(playerid) / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1, 
    	resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ forplayerid ] ) - MAX_ITEMS_ON_PAGE ) ;

    strcat(string, "Record ID \t Record Type\t Record Date\t Record Reason\n");

    for_loop ( new i = resultcount; i < GetPlayerPenaltyCount(playerid); i ++ ) {

    	if ( AdminRecord [ playerid ] [ i ] [ E_ADMIN_RECORD_ACCOUNT_ID ] == Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {
	        resultcount ++;

	        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ forplayerid ] ) {

	        	switch ( AdminRecord [ playerid ] [ i ] [ record_type ] ) {

	        		case ARECORD_TYPE_KICK : 	format ( reason, sizeof ( reason ), "Kick" ) ;
					case ARECORD_TYPE_AJAIL : 	format ( reason, sizeof ( reason ), "Admin-jail" ) ;
					case ARECORD_TYPE_BAN : 	format ( reason, sizeof ( reason ), "Account Ban" ) ;
	        	}


	        	format ( temp, sizeof ( temp ), "[Reason: %s]", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;

	        	if ( strlen ( AdminRecord [ playerid ] [ i ] [ record_reason ] ) > 12  ) {

	        		format ( temp, sizeof ( temp ), "[Reason: %.12s...]", AdminRecord [ playerid ] [ i ] [ record_reason ] ) ;
	        	}

	           	format ( string, sizeof ( string ), "%s[ID %d]\t[Type: %s]\t[Date: %s]\t%s\n", string, AdminRecord [ playerid ] [ i ] [ record_id ], reason, AdminRecord [ playerid ] [ i ] [ record_date ], temp ) ;
	
	        }

	        if ( resultcount > MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ forplayerid ] ) {

	            nextpage = true ;
	            break ;
	        }
	    }

	    else continue ;
    }

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	inline AdminRecordList(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		if ( ! response ) {

			if ( PlayerLastARecPage [ forplayerid ] > 1 ) {

				PlayerLastARecPage [ forplayerid ]  -- ;
				return ShowAdminRecord ( playerid, forplayerid ) ;
			}
		}

		if ( response ) {

			if ( listitem == MAX_ITEMS_ON_PAGE) {

				PlayerLastARecPage [ forplayerid ] ++ ;
				return ShowAdminRecord ( playerid, forplayerid ) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {

				new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerLastARecPage [ forplayerid ] ) - MAX_ITEMS_ON_PAGE ) + listitem;

 				PlayerPlaySound ( playerid, 1085, 0.0, 0.0, 0.0 ) ;

				inline AdminRecord_View(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
					#pragma unused pidx, dialogidx, listitemx, inputtextx

					if ( ! responsex ) {

						return false ;
					}

					else if ( responsex ) {

						//return cmd_adminrecord(playerid);
						return ShowAdminRecord ( playerid, forplayerid ) ;
					}
				}

				SendClientMessage(forplayerid, COLOR_SERVER, "[ADMIN RECORD PARSE DATA]");

	           	format ( string, sizeof ( string ), "[ID %d]\t[Type: %s]\t[Date: %s]\t[Admin ID: %d]\n", 
	           		AdminRecord [ playerid ] [ selection ] [ record_id ], reason, AdminRecord [ playerid ] [ selection ] [ record_date ], AdminRecord [ playerid ] [ selection ] [ record_admin ] ) ;

	           	SendClientMessage(forplayerid, COLOR_GRAD1, string ) ;

				format ( string, sizeof ( string ), "[Reason: %s]\n", AdminRecord [ playerid ] [ selection ] [ record_reason ]  ) ;

	           	SendClientMessage(forplayerid, COLOR_GRAD1, string ) ;
			}
		}
	}

	new title [ 36 ] ;
	
	format ( title, sizeof ( title ), "Admin Record: Page %d of %d", PlayerLastARecPage [ forplayerid ], pages) ;

	if ( PlayerLastARecPage [ forplayerid ] > 1 ) {
   		Dialog_ShowCallback ( forplayerid, using inline AdminRecordList, DIALOG_STYLE_TABLIST_HEADERS, title, string, "View", "Previous" );
   	}
   	else Dialog_ShowCallback ( forplayerid, using inline AdminRecordList, DIALOG_STYLE_TABLIST_HEADERS, title, string, "View", "Close" );
 
   	return true ;
}
*/


GetPlayerPenaltyCount (playerid) {

	new count ;

	for_loop ( new i ; i < MAX_ARECORD_CHARGES; i ++ ) {

		if ( AdminRecord [ playerid ] [ i ] [ record_id ] != -1 && AdminRecord [ playerid ] [ i ] [ E_ADMIN_RECORD_ACCOUNT_ID ] == Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {

			count ++ ;
		}

		else continue ;
	}

	return count ;
}