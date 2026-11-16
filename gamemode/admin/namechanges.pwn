static ncdlgstr[1024];

static enum
{
	NC_TYPE_CHARACTER,
	NC_TYPE_ACCOUNT
}

#define NAMECHANGE_COST	10000
#define MAX_NAMECHANGE_COST 100000
#define NAMECHANGE_SURCHARGE 2500
#define NAMECHANGE_SURCHARGE_LEVEL 10

static PlayerNameChange(playerid, nctype, adminid = INVALID_PLAYER_ID, error[] = EOS)
{
	inline PlayerNameChangeDlg(pid, dialogid, response, listitem, string:inputtext[]) 
	{
        #pragma unused pid, dialogid, inputtext, listitem

		if (!response)
		{
			if (adminid != INVALID_PLAYER_ID)
			{
				// it's not optional, punk
				return PlayerNameChange(playerid, nctype, adminid);
			}

			return cmd_namechange(playerid);
		}

		if (response)
		{
			new costt = PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_COST ];

			if (costt && GetPlayerCash(playerid) < costt && !IsPlayerInDEAFaction(playerid))
			{
				return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", sprintf("You need $%s in cash to do this.", IntegerWithDelimiter(costt)) ) ;
			}

			if (strlen(inputtext) < 3 || strlen(inputtext) >= MAX_PLAYER_NAME)
			{
				return PlayerNameChange(playerid, nctype, adminid, sprintf("Your new name must be between 3 and %d characters.", MAX_PLAYER_NAME));
			}

			new name[MAX_PLAYER_NAME], query[256];
			format(name, MAX_PLAYER_NAME, "%s", inputtext);

			if (nctype == NC_TYPE_CHARACTER && !IsRPNameRegex(name)) return PlayerNameChange(playerid, nctype, adminid, "You must enter a valid roleplay name (Firstname_Lastname), try again.");
			else if (nctype == NC_TYPE_ACCOUNT && !IsAccountNameRegex(name)) return PlayerNameChange(playerid, nctype, adminid, "The new name contained invalid characters, try again.");

			if (nctype == NC_TYPE_CHARACTER)
			{
				inline CheckIfCharacterExists() 
				{
					new rows, fields;
					cache_get_data ( rows, fields, mysql ) ;

					if (rows) return PlayerNameChange(playerid, nctype, adminid, "Sorry, this name is already in use by someone else.");

					PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_REQUEST ]  = 1;
					format ( PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_NAME ], MAX_PLAYER_NAME, "%s", name ) ;

					format ( query, sizeof ( query ),"[NAMECHANGE] (%d) %s (%s) has requested a namechange for their CHARACTER to \"%s\".", playerid, Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], Character [ playerid ] [ E_CHARACTER_NAME ], name);
					SendAdvHelperMsg(query ) ;

					format ( query, sizeof ( query ),"To accept or deny the namechange, type {59BD93}/processnc %d [accept/deny]", playerid );
					SendAdvHelperMsg(query ) ;
				}

				mysql_format ( mysql, query, sizeof ( query ), "SELECT player_name FROM characters WHERE player_name = '%e'", name ) ;
				mysql_tquery_inline(mysql, query, using inline CheckIfCharacterExists, "");
			}
			else if (nctype == NC_TYPE_ACCOUNT)
			{
				inline CheckIfMasterAccountExists() 
				{
					new rows, fields;
					cache_get_data ( rows, fields, mysql ) ;

					if (rows) return PlayerNameChange(playerid, nctype, adminid, "Sorry, this name is already in use by someone else.");

					PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_REQUEST ]  = 2;
					format ( PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_NAME ], MAX_PLAYER_NAME, "%s", name ) ;

					format ( query, sizeof ( query ),"[NAMECHANGE] (%d) %s (%s) has requested a namechange for their ACCOUNT to \"%s\".", playerid, Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], Character [ playerid ] [ E_CHARACTER_NAME ], name);
					SendAdvHelperMsg(query ) ;
					
					format ( query, sizeof ( query ),"To accept or deny the namechange, type {59BD93}/processnc %d [accept/deny]", playerid );
					SendAdvHelperMsg(query ) ;
				}

				mysql_format ( mysql, query, sizeof ( query ), "SELECT account_name FROM accounts WHERE account_name = '%e'", name ) ;
				mysql_tquery_inline(mysql, query, using inline CheckIfMasterAccountExists, "");
			}
		}
	}

	new cost = NAMECHANGE_COST;

	if (Character[playerid][E_CHARACTER_LEVEL] > NAMECHANGE_SURCHARGE_LEVEL)
	{
		cost += (NAMECHANGE_SURCHARGE * (Character[playerid][E_CHARACTER_LEVEL] - NAMECHANGE_SURCHARGE_LEVEL));
	}

	if (adminid != INVALID_PLAYER_ID || IsPlayerInDEAFaction(playerid)) cost = 0;
	else if (cost > MAX_NAMECHANGE_COST) cost = MAX_NAMECHANGE_COST;

	PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_COST ] = cost;

	if (adminid != INVALID_PLAYER_ID)
	{
		if (nctype == NC_TYPE_CHARACTER) format(ncdlgstr, sizeof(ncdlgstr), "{FFFFFF}(%d) %s has requested you to change the name of your {AA3333}player character{FFFFFF}.", adminid, ReturnPlayerNameData(adminid));
		else if (nctype == NC_TYPE_ACCOUNT) format(ncdlgstr, sizeof(ncdlgstr), "{FFFFFF}(%d) %s has requested you to change the name of your {AA3333}master account{FFFFFF}.", adminid, ReturnPlayerNameData(adminid));
		format(ncdlgstr, sizeof(ncdlgstr), "%s\n{ADBEE6}Reason: %s", ncdlgstr, PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_REASON]);
		
		if (strlen(error))
		{
			format(ncdlgstr, sizeof(ncdlgstr), "%s\n\n{FF0000}%s", ncdlgstr, error);
		}

		strcat(ncdlgstr, "\n\n{FFFFFF}Please enter a new name and press {AA3333}OK{FFFFFF} to continue.");
		strcat(ncdlgstr, "\n{ADBEE6}You will not be charged any money for this name change.");
		Dialog_ShowCallback ( playerid, using inline PlayerNameChangeDlg, DIALOG_STYLE_INPUT, "Namechange Request", ncdlgstr, "OK" );
	}
	else
	{
		if (nctype == NC_TYPE_CHARACTER)
		{
			format(ncdlgstr, sizeof(ncdlgstr), "{FFFFFF}You are about to change the name of your {AA3333}player character{FFFFFF}.");
			strcat(ncdlgstr, "\n\n{ADBEE6}You will keep your character's stats, but all attributes will be reset.");
			strcat(ncdlgstr, "\n{ADBEE6}This is equivalent to a character-kill, you cannot go back to your old name.");
		} 
		else if (nctype == NC_TYPE_ACCOUNT) format(ncdlgstr, sizeof(ncdlgstr), "{FFFFFF}You are about to change the name of your {AA3333}master account{FFFFFF}.");

		if (HasGunLicense(playerid) && nctype == NC_TYPE_CHARACTER) strcat(ncdlgstr, "\n{FFFF00}This character has a gun license. You will lose it if you namechange.");
		
		if (strlen(error))
		{
			format(ncdlgstr, sizeof(ncdlgstr), "%s\n\n{FF0000}%s", ncdlgstr, error);
		}

		strcat(ncdlgstr, "\n\n{FFFFFF}Please enter a new name and press {AA3333}OK{FFFFFF} to continue.");

		if (!PlayerVar[playerid][E_PLAYER_NAMECHANGE_COST]) format(ncdlgstr, sizeof(ncdlgstr), "%s\n{ADBEE6}You will not be charged any money for this name change.", ncdlgstr);
		else
		{
			format(ncdlgstr, sizeof(ncdlgstr), "%s\n\n{FFFF00}You'll be charged a total of $%s for this namechange:", ncdlgstr, IntegerWithDelimiter(PlayerVar[playerid][E_PLAYER_NAMECHANGE_COST]));
			format(ncdlgstr, sizeof(ncdlgstr), "%s\n{ADBEE6}- Base service fee of $%s.", ncdlgstr, IntegerWithDelimiter(NAMECHANGE_COST));
			if (PlayerVar[playerid][E_PLAYER_NAMECHANGE_COST] > NAMECHANGE_COST) format(ncdlgstr, sizeof(ncdlgstr), "%s\n- Extra $%s per Level above %d (Max $%s).", ncdlgstr, IntegerWithDelimiter(NAMECHANGE_SURCHARGE), NAMECHANGE_SURCHARGE_LEVEL, IntegerWithDelimiter(MAX_NAMECHANGE_COST));
		} 

		if (nctype == NC_TYPE_CHARACTER) Dialog_ShowCallback ( playerid, using inline PlayerNameChangeDlg, DIALOG_STYLE_INPUT, "Character Namechange Service", ncdlgstr, "OK", "Back" );
		else Dialog_ShowCallback ( playerid, using inline PlayerNameChangeDlg, DIALOG_STYLE_INPUT, "Account Namechange Service", ncdlgstr, "OK", "Back" );
	}

	return true;
}

CMD:forcenamechange ( playerid, params [] ) 
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, option[10], reason[64];

	if ( sscanf ( params, "rs[10]s[64]", targetid, option, reason ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Syntax", "DEDEDE", "/force(ame)c(hange) [player id] [character/account] [reason]" ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) )
	{
		return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", "Target isn't connected." ) ;
	}

	if ( GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) )
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "DEDEDE", "You can't force admins of equal or higher rank." ) ;
	}

	if ( PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REQUEST ] )
	{
		return SendServerMessage ( playerid, COLOR_RED, "Syntax", "DEDEDE", "This player already has a pending namechange." ) ;
	}

	PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ] = 0;
	format(PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REASON], 100, "%s", reason);
	new string [ 128 ] ;

	if ( ! strcmp ( option, "character", true ) )
	{
		format ( string, sizeof ( string ), "[ADMIN] (%d) %s forced (%d) %s to change character name: %s", playerid, ReturnPlayerNameData(playerid), targetid, ReturnPlayerNameData(targetid), reason);
		SendAdminMessage ( string, true );
		PlayerNameChange(targetid, NC_TYPE_CHARACTER, playerid);
	} 
	else if ( ! strcmp ( option, "account", true ))
	{
		format ( string, sizeof ( string ), "[ADMIN] (%d) %s forced (%d) %s to change account name: %s", playerid, ReturnPlayerNameData(playerid), targetid, ReturnPlayerNameData(targetid), reason);
		SendAdminMessage ( string, true );
		PlayerNameChange(targetid, NC_TYPE_ACCOUNT, playerid);
		
	}

	return true;
}

CMD:forcenc(playerid, params[])
{
	return cmd_forcenamechange(playerid, params);
}

CMD:namechange ( playerid ) 
{
	if ( PlayerVar [ playerid ] [ E_PLAYER_NAMECHANGE_REQUEST ] != 0 ) 
	{
		return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", "You've already requested a namechange." ) ;
	}

	if (!IsPlayerInRangeOfPoint ( playerid, 5.0, 1481.0460, -1788.5773, 18.7360 ) && !IsPlayerInDEAFaction(playerid)){ // have to use exact coords since IsAtGovDesk() doesn't seem to work
		return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", "You must be at the counter inside City Hall to do this." ) ;
	} else if (IsPlayerInDEAFaction(playerid) && IsAtFrontDesk(playerid) == -1){
		return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", "You must be at the DEA front desk to do this." ) ;
	}

	// Show new namechange menu.
	inline NcTyleDlg(pid, dialogid, response, listitem, string:inputtext[]) 
	{
        #pragma unused pid, dialogid, inputtext, listitem

		if (response)
		{
			if (listitem == NC_TYPE_CHARACTER) PlayerNameChange(playerid, NC_TYPE_CHARACTER);
			else if (listitem == NC_TYPE_ACCOUNT)
			{
				SendClientMessage(playerid, COLOR_ERROR, "Account namechanges are disabled until 2.0, contact an Admin if you /really/ need one.");
				// PlayerNameChange(playerid, NC_TYPE_ACCOUNT);
			} 
		}
	}

	Dialog_ShowCallback ( playerid, using inline NcTyleDlg, DIALOG_STYLE_LIST, "Select an option", "Change Player Character\nChange Master Account", "Select", "Back" );
	return true;
}

CMD:processnamechange ( playerid, params [] ) {

	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_ADVANCED)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, option[7], reason[64] ;

	if ( sscanf ( params, "rs[7]S[64]", targetid, option, reason ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Syntax", "DEDEDE", "/processn(ame)c(hange) [player id] [accept/deny] [reason (if denied)]" ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) || ! PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REQUEST ] ) {

		return SendServerMessage ( playerid, COLOR_RED, "Syntax", "DEDEDE", "This player hasn't requested a namechange." ) ;
	}

	new query [ 200 ];

	if ( ! strcmp ( option, "accept", true ) ) 
	{
		if (PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ] && GetPlayerCash(targetid) < PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ]) 
		{
			return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", "This player doesn't have enough cash for the namechange." ) ;
		}

		if (PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ]) 
		{
			TakePlayerCash ( targetid, PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ] ) ;
		}

		new type = PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REQUEST ] ;

		format ( query, sizeof ( query ),"You've accepted %s (%d)'s namechange.", ReturnPlayerNameData ( targetid ), targetid )  ;
		SendServerMessage ( playerid, COLOR_RED, "Syntax", "DEDEDE", query);

		switch ( type ) 
		{
			case 1: 
			{
				// char
				//format ( query, sizeof ( query ),"[NAMECHANGE: CHAR] %s (%d) has namechanged to %s.", ReturnPlayerNameData ( targetid ), targetid, PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ]);
				//SendClientMessageToAll(COLOR_STAFF, query ) ;

				format ( query, sizeof ( query ),"[NAMECHANGE: CHAR] %s (%d) has namechanged to %s.", ReturnPlayerNameData ( targetid ), targetid, PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ]);
				WriteLog ( targetid, "namechanges", query );

				AddLogEntry(targetid, LOG_TYPE_ADMIN, sprintf("namechanged CHARACTER from \"%s\" to \"%s\" for $%s", Character [ targetid ] [ E_CHARACTER_NAME ], PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ], IntegerWithDelimiter(PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_COST ])));
				format ( Character [ targetid ] [ E_CHARACTER_NAME ], MAX_PLAYER_NAME, "%s",PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ] ) ;

				// Update cached name strings
				UpdatePlayerNameCache(targetid);

				//Player_UpdateNameTag(targetid);
 				UpdatePlayerNamesForOthers ( targetid ) ;

				format ( query, sizeof ( query ),"Your character namechange request was accepted by (%d) %s.", playerid, ReturnPlayerNameData ( playerid ) ) ; 
				SendServerMessage ( targetid, COLOR_RED, "Namechange", "DEDEDE", query);

				if ( HasGunLicense(targetid) ) {

					RemoveGunLicense(targetid);

					format ( query, sizeof ( query ),"You have lost your gun license due to the namechange.") ; 
					SendServerMessage ( targetid, COLOR_RED, "Namechange", "DEDEDE", query);

				}

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_name = '%e' WHERE player_id = %d", PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;
				mysql_tquery ( mysql, query ) ;

				SOLS_ResetPlayerAttributes(targetid);

				SendServerMessage(targetid, COLOR_INFO, "Attributes", "A3A3A3", "Your character attributes were cleared. Type {FFFFFF}/myattributes{A3A3A3} to edit them again.");
				AddLogEntry(targetid, LOG_TYPE_ADMIN, "Had their character attributes reset automatically.");
			}

			case 2: 
			{ 
				// MA
				//format ( query, sizeof ( query ),"[NAMECHANGE: MA] %s (%d) has namechanged to %s.", ReturnPlayerNameData ( targetid ), targetid, PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ]) ;
				//SendClientMessageToAll(COLOR_STAFF, query);

				format ( query, sizeof ( query ),"[NAMECHANGE: MA] %s (%d) has namechanged to %s.", ReturnPlayerNameData ( targetid ), targetid, PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ]);
				AddLogEntry(targetid, LOG_TYPE_ADMIN, sprintf("namechanged ACCOUNT from \"%s\" to \"%s\"", Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ]));
				WriteLog ( targetid, "namechanges",query);

				format ( Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], MAX_PLAYER_NAME, "%s",PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ] ) ;
				//Player_UpdateNameTag(targetid);
				UpdatePlayerNamesForOthers ( targetid ) ;

				format ( query, sizeof ( query ),"Your account namechange request was accepted by (%d) %s.", playerid, ReturnPlayerNameData ( playerid ) ) ; 
				SendServerMessage ( targetid, COLOR_RED, "Namechange", "DEDEDE", query);
				SendClientMessage(targetid, COLOR_RED, "You must use this new name to login with next time.");

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE accounts SET account_name = '%e' WHERE account_id = %d", PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ], Account [ targetid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
				mysql_tquery ( mysql, query ) ;
			}
		}

		PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REQUEST ] = 0;
		PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ] = EOS;

		format ( query, sizeof ( query ),"[NAMECHANGE] (%d) %s has ACCEPTED (%d) %s's namechange request.", 
			playerid, ReturnPlayerNameData ( playerid ),targetid, ReturnPlayerNameData ( targetid ) );
		SendAdminMessage(query, true) ;
	}

	else if ( ! strcmp ( option, "deny" ) ) {

		if ( ! strlen ( reason ) ) {
			format ( query, sizeof ( query ),"%s has denied your namechange request: No reason specified.", ReturnPlayerNameData ( playerid ) ) ;
			SendServerMessage ( targetid, COLOR_RED, "Namechange", "DEDEDE", query );

			format ( query, sizeof ( query ),"You've denied %s's namechange request: No reason specified.", ReturnPlayerNameData ( targetid )  );
			SendServerMessage ( playerid, COLOR_RED, "Namechange", "DEDEDE", query);
		}
		else {
			format ( query, sizeof ( query ),"%s has denied your namechange: %s.", ReturnPlayerNameData ( playerid ), reason ) ; 
			SendServerMessage ( targetid, COLOR_RED, "Namechange", "DEDEDE",query);

			format ( query, sizeof ( query ),"You've denied %s's namechange: %s.", ReturnPlayerNameData ( targetid ), reason  ) ;
			SendServerMessage ( playerid, COLOR_RED, "Namechange", "DEDEDE", query );
		}

		PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_REQUEST ] = 0;
		PlayerVar [ targetid ] [ E_PLAYER_NAMECHANGE_NAME ] = EOS;

		format ( query, sizeof ( query ),"[NAMECHANGE] (%d) %s has DENIED (%d) %s's namechange request.", 
			playerid, ReturnPlayerNameData ( playerid ),targetid, ReturnPlayerNameData ( targetid ) );
		SendAdminMessage(query, true) ;
	}

	return true ;
}

CMD:processnc ( playerid, params [] ) return cmd_processnamechange ( playerid, params ) ;

CMD:namechanges ( playerid, params [] ) {

	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_ADVANCED)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}


	new string [ 512 ], buffer[65], count = 0 ;

	strcat ( string, "Name\tType\tNew Name\n" );

	inline DisplayNamechangeRequests(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, response, dialogid, listitem, inputtext

	}

	foreach ( new i : Player ) {

		if (PlayerVar [ i ] [ E_PLAYER_NAMECHANGE_REQUEST ]) {

			format ( buffer, sizeof ( buffer ), "%s \t %s \t %s\n", ReturnPlayerNameData(i), (PlayerVar [ i ] [ E_PLAYER_NAMECHANGE_REQUEST ] == 1) ? ("Character") : ("Master Account"), PlayerVar [ i ] [ E_PLAYER_NAMECHANGE_NAME ] ) ;
			strcat ( string, buffer ) ;
			
			count ++;
		}
		else continue;
	}

	if ( ! count ) {

		return SendServerMessage ( playerid, COLOR_YELLOW, "Namechanges", "DEDEDE", "There are no current namechange requests." ) ;
	}

	Dialog_ShowCallback ( playerid, using inline DisplayNamechangeRequests, DIALOG_STYLE_TABLIST_HEADERS, "Namechange Requests", string, "Continue");

	return true ;
}
