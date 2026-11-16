
CMD:grouponline(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching groupid enumerator ID! Contact a DEV.");
	}

	new tier;

	SendClientMessage(playerid, COLOR_BLUE, sprintf("Online members of group (%d) %s.", groupid, Group [ group_enum_id ] [ E_GROUP_DATA_NAME ] )) ;

	foreach(new idx: Player )  {
		if (Character [ idx ] [ E_CHARACTER_GROUPID ] == groupid || playerid == idx) {

			tier = Character [ idx ] [ E_CHARACTER_GROUPTIER ];

			SendClientMessage(playerid, COLOR_FACTION_GREEN, sprintf("ONLINE: (ID %d)  %s (%s) | Tier: %d", idx, ReturnPlayerNameData ( idx, 0, true ), Account[idx][E_PLAYER_ACCOUNT_NAME], tier ) );
		}
	}

	return true ;
}

CMD:gonline(playerid, params[]) return cmd_grouponline(playerid, params);
CMD:gon(playerid, params[]) return cmd_grouponline(playerid, params);
CMD:groupon(playerid, params[]) return cmd_grouponline(playerid, params);

CMD:groupoffline(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching groupid enumerator ID! Contact a DEV.");
	}

	new query [ 512 ];

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `player_id`, `player_name`, `account_name`, `player_grouptier` FROM `characters` JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `player_groupid` = '%d'",
		groupid
	) ; 

	SendClientMessage(playerid, COLOR_BLUE, sprintf("Offline members of group (%d) %s.", groupid, Group [ group_enum_id ] [ E_GROUP_DATA_NAME ] )) ;

	new player_id, player_off_name [ MAX_PLAYER_NAME ], group_tier, player_acc[32];

	inline OnOfflineMemberCheck() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) 
		{
			for_loop ( new i; i < rows; i ++ ) { 

				player_id = cache_get_field_int (i, "player_id");
				

				if ( Player_IsPlayerConnected ( player_id ) ) {

					continue ;
				}

				cache_get_field_content ( i, "player_name", player_off_name, mysql, MAX_PLAYER_NAME ) ;
				cache_get_field_content ( i, "account_name", player_acc, mysql, 32 ) ;
				group_tier = cache_get_field_int (i, "player_grouptier");

				SendClientMessage(playerid, COLOR_FACTION_RED, sprintf("OFFLINE: (%d) %s (%s) | Tier: %d", player_id, player_off_name, player_acc, group_tier));
			}	
		}
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineMemberCheck, "");

	return true ;
}

CMD:goffline(playerid, params[]) return cmd_groupoffline(playerid, params);
CMD:goff(playerid, params[]) return cmd_groupoffline(playerid, params);
CMD:groupoff(playerid, params[]) return cmd_groupoffline(playerid, params);


CMD:groupquit(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching groupid enumerator ID! Contact a DEV.");
	}


	Group_SendMessage(group_enum_id, sprintf("{ (%d) %s has left the group. }", playerid, ReturnPlayerNameData ( playerid ) ));

	Character [ playerid ] [ E_CHARACTER_GROUPID] = 0 ;
	Character [ playerid ] [ E_CHARACTER_GROUPTIER ] = 3 ;

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof ( query ), 
		"UPDATE characters SET player_groupid = 0, player_grouptier = 3 WHERE player_id = %d", 
		Character [ playerid ] [ E_CHARACTER_ID ] 
	) ;

	mysql_tquery(mysql, query);

	SendClientMessage(playerid, 0xA3A3A3FF, "You've left your group.");

	return true ;
}

CMD:gquit(playerid, params[]) return cmd_groupquit(playerid, params);
 

CMD:grouphidechat(playerid, params[]) {

	return cmd_nogroup(playerid, params);
}

CMD:ghidechat(playerid, params[]) return cmd_grouphidechat(playerid, params);
CMD:ghide(playerid, params[]) return cmd_grouphidechat(playerid, params);
 

static GrpActivityStr[4096];
CMD:groupactivity(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching groupid enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new option[6], days = 0;
	sscanf(params, "s[6]", option);

	if (strlen(option))
	{
		if (!strcmp(option, "day", true)) days = 1;
		else if (!strcmp(option, "week", true)) days = 7;
		else if (!strcmp(option, "month", true)) days = 30;
	}

	if (!days)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)activity [day/week/month]");
	}

	new query[512];
	mysql_format(mysql, query, sizeof(query), "SELECT `characters`.`player_name` AS `Name`, `characters`.`player_grouptier` AS `Tier`, (SUM(`e_session_time`)/60) AS `Hours` FROM `characters` LEFT JOIN `sessions` ON `characters`.`player_id` = `sessions`.`e_session_char` AND `sessions`.`e_session_unix_store` > UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL %d DAY)) WHERE `characters`.`player_groupid` = %d GROUP BY `characters`.`player_name` ORDER BY SUM(`e_session_time`) DESC LIMIT 100", days, groupid);

	inline Activity_OnList() 
	{
		new rows, fields, Float:hours, tier, player_name_display[32];
		cache_get_data (rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "There is no group activity for this timeframe.") ;
		}

		format(GrpActivityStr, sizeof(GrpActivityStr), "Player\tTier\tTotal Hours");

		for_loop ( new i, p = rows; i < p; i ++ ) 
		{
			//cache_get_field_content(i, "Name", player_name);
			cache_get_field_content(i, "Name", player_name_display);
			strreplace(player_name_display, "_", " ");
			tier = cache_get_field_content_int(i, "Tier");
			hours = cache_get_field_content_float(i, "Hours");

			format(GrpActivityStr, sizeof(GrpActivityStr), "%s\n%s\t%d\t%.02f", GrpActivityStr, player_name_display, tier, hours);
		}

		inline DlgActivityList(pid, dialogid, response, listitem, string:inputtext[]) 
    	{
			#pragma unused pid, dialogid, inputtext, listitem

			if (response)
			{
				// Do nothing
			}
		}

		Dialog_ShowCallback(playerid, using inline DlgActivityList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("%s Activity (Last %d days)", Group[group_enum_id][E_GROUP_DATA_NAME], days), GrpActivityStr, "Back");
	}

	mysql_tquery_inline(mysql, query, using inline Activity_OnList, "");
	return 1;
}
CMD:gactivity(playerid, params[]) return cmd_groupactivity(playerid, params);