
GetPlayerHelperLevel ( playerid ) 
{
	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR ) {

		return HELPER_LVL_ADVANCED ; 
	}

	return Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ];
}

CMD:omakehelper(playerid, params[]) 
{
	if (!IsHelperAdmin(playerid)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new master_acc[32], rank[32], level = -1, query[128];
	if ( sscanf  (params, "s[32]s[32]", master_acc, rank ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/omakehelper [account name] [none / trial / helper / senior]" );
	}

	if ( strlen ( master_acc ) < 0 || strlen ( master_acc ) > MAX_PLAYER_NAME ) 
	{
		format ( query, sizeof ( query ), "Master account name can't be shorter than 0 or longer than %d.", MAX_PLAYER_NAME ) ;
		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3", query ) ;
	}

	if (!strcmp(rank, "none", true)) level = 0;
	else if (!strcmp(rank, "trial", true)) level = HELPER_LVL_NORMAL;
	else if (!strcmp(rank, "helper", true)) level = HELPER_LVL_SENIOR;
	else if (!strcmp(rank, "senior", true)) level = HELPER_LVL_ADVANCED;

	if (level == -1)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/omakehelper [account name] [none / trial / helper / senior]" );
	}

	inline UpdateHelperLevel()
	{
		new affected = cache_affected_rows(mysql);
		if (!affected) return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3",  "Error: wrong account name or helper level is already that value.");

		if (level == HELPER_LVL_SENIOR) format(query, sizeof(query), "[HelperCmd]: (%d) %s has made %s a helper.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), master_acc);
		else if (level == HELPER_LVL_ADVANCED) format(query, sizeof(query), "[HelperCmd]: (%d) %s has made %s a senior helper.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), master_acc);
		else if (level == HELPER_LVL_NORMAL) format(query, sizeof(query), "[HelperCmd]: (%d) %s has made %s a trial helper.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), master_acc);
		else format(query, sizeof(query), "[HelperCmd]: (%d) %s has removed %s from being a helper.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), master_acc);

		SendHelperMessage(query);
		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Offline set %s helper rank to %d", master_acc, level));
		return true;
	}

	mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `account_supporter` = %d WHERE `account_name` = '%e'", level, master_acc);
	mysql_tquery_inline(mysql, query, using inline UpdateHelperLevel, "");
	return true ;
}

CMD:makehelper(playerid, params[]) 
{
	if (!IsHelperAdmin(playerid)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, level, string[128], rank_name[16];

	if ( sscanf  (params, "k<player>d", targetid, level ) || level < 0 || level > HELPER_LVL_ADVANCED ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/makehelper [player] [level]" );
	}

	if ( ! IsPlayerConnected(targetid) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." );
	}

	if (level == 0)
	{
		if (!Account[targetid][E_PLAYER_ACCOUNT_SUPPORTER]) 
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player isn't a helper." );
		} 

		Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = 0 ;
		PlayerVar [ targetid ] [ E_PLAYER_HELPER_DUTY ] = false;

		UpdatePlayerNamesForOthers ( targetid ) ;
		format ( string, sizeof ( string ), "[HelperCmd]: (%d) %s has removed (%d) %s's helper rank.", playerid, ReturnPlayerNameData ( playerid ), targetid, ReturnPlayerNameData ( targetid ) ) ;
	}
	else
	{
		Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = level ;
		GetHelperRankName( level, rank_name, 32 ) ;
		format ( string, sizeof ( string ), "[HelperCmd]: (%d) %s has set (%d) %s to %s.", playerid, ReturnPlayerNameData ( playerid ), targetid, ReturnPlayerNameData ( targetid ), rank_name) ;
	}

	SendHelperMessage ( string );

	string [ 0 ] = EOS ;

	mysql_format ( mysql, string, sizeof ( string ), "UPDATE accounts SET account_supporter = %d WHERE account_id = %d",
		Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ], Account [ targetid ] [ E_PLAYER_ACCOUNT_ID ] ) ;

	mysql_tquery(mysql, string);

	return true ;
} 

CMD:helpers(playerid, params[]) {

	new count, string[128], rank_name[32], rank_color[16];

	SendClientMessage(playerid, COLOR_HELPER, "__________________ Online Helpers __________________") ;

	foreach(new targetid: Player) 
	{
		if (IsPlayerHelper ( targetid ) && !Account [ targetid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] && !Account [targetid][E_PLAYER_ACCOUNT_STAFFLEVEL]) {

			count ++ ;

			rank_name [ 0 ] = EOS ;
			GetHelperRankName( Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ], rank_name, 32 ) ;
			GetHelperRankColor(Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ], rank_color, 16) ;

			if ( ! PlayerVar [ targetid ] [ E_PLAYER_HELPER_DUTY ] ) 
			{
				if (Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] == HELPER_LVL_ADVANCED)
				{
					format ( string, sizeof ( string ), "» %s%s{DEDEDE} | %s (ID: %d) | Answers: %d | Requests: %d", rank_color, rank_name, Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ],  Account [ targetid ] [ E_PLAYER_ACCOUNT_REPORTS_DONE ]  );
				}
				else
				{
					format ( string, sizeof ( string ), "» %s%s{DEDEDE} | %s (ID: %d) | Answers: %d", rank_color, rank_name, Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ]  );
				}

				if (HasAnyAdminRole(targetid)) format(string, sizeof(string), "%s | Roles: %s", string, PrintAdminRoles(targetid));
				SendClientMessage(playerid, 0xa6a492FF,string );
				
			}

			else if ( PlayerVar [ targetid ] [ E_PLAYER_HELPER_DUTY ] ) 
			{
				if (Account [ targetid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] == HELPER_LVL_ADVANCED)
				{
					format ( string, sizeof ( string ), "» %s%s{DEDEDE} | %s (ID: %d) | Answers: %d | Requests: %d", rank_color, rank_name, Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ], Account [ targetid ] [ E_PLAYER_ACCOUNT_REPORTS_DONE ]  );
				}
				else
				{
					format ( string, sizeof ( string ), "» %s%s{DEDEDE} | %s (ID: %d) | Answers: %d", rank_color, rank_name, Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ]  );
				}

				if (HasAnyAdminRole(targetid)) format(string, sizeof(string), "%s | Roles: %s", string, PrintAdminRoles(targetid));
				SendClientMessage(playerid, 0x54acd2FF, string);
			}

			else continue ;
		}
	} 


	if ( ! count ) 
	{
		foreach(new targetid: Player) 
		{
			if (Character[targetid][E_CHARACTER_ADMIN_HIDE]) continue;

			if (Account [targetid][E_PLAYER_ACCOUNT_STAFFLEVEL] > 0 && !Account [ targetid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ]) 
			{
				format ( string, sizeof ( string ), "» {72B065}Admin{DEDEDE} | %s (ID: %d) | Answers: %d | Requests: %d",
				Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ], Account [ targetid ] [ E_PLAYER_ACCOUNT_REPORTS_DONE ]  );
				SendClientMessage(playerid, COLOR_HELPER,string );

				count ++ ;
			}
		} 
	}

	if( !count ) {
		SendClientMessage(playerid, COLOR_GRAD0, "None");
	}

	SendClientMessage(playerid, COLOR_GRAD1, "Consult an inquiry with our helper team first, before reaching out to other staff. " ) ;
	SendClientMessage(playerid, COLOR_GRAD1, "To view a list of admins, use /admins." ) ;

	return true ;
}


GetHelperRankName(rank, rank_name[], len = sizeof ( rank_name ) ) {

	rank_name [ 0 ] = EOS ;

	switch ( rank ) {

		case 1:		strcat ( rank_name, "Trial Helper", len ) ;
		case 2: 	strcat ( rank_name, "Helper", len);
		case 3: 	strcat ( rank_name, "Senior Helper", len);
		default: strcat ( rank_name, "Regular", len ) ;
	}
}

GetHelperRankColor(rank, rank_color[], len = sizeof ( rank_color ) ) {

	rank_color [ 0 ] = EOS ;

	switch ( rank ) {

		case 1:		strcat ( rank_color, "{9FE6A0}", len ) ;
		case 2:		strcat ( rank_color, "{72B065}", len ) ;
		case 3:		strcat ( rank_color, "{59c9bd}", len ) ;
		default: strcat ( rank_color, "{FFFFF}", len ) ;
	}
}
