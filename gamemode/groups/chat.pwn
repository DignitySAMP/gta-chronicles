CMD:groupchat(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( ! Group [ group_enum_id ] [ E_GROUP_DATA_CHAT ] && Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This group's chat is disabled.");
	}


	new input [ 128 ] ;

	if ( sscanf ( params, "s[128]", input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)c(hat) [text]");
	}

	if ( strlen ( input ) > sizeof ( input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Your text can't be longer than %d characters.", sizeof ( input )));
	}

	new string[144];

	format(string, sizeof(string), "(( [GROUP] (%d) %s: %s ))",  playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), input);
	Group_SendMessage(group_enum_id, string, true);
	SendAdminListen(playerid, string);

	format ( string, sizeof ( string ), "(( [GROUP %d(%d)] %s ))",

		group_enum_id, Character [ playerid ] [ E_CHARACTER_GROUPID ], input
	);

	AddLogEntry(playerid, LOG_TYPE_OOC, string);

	return true ;
}
CMD:gchat(playerid, params[]) return cmd_groupchat(playerid, params);
CMD:gc(playerid, params[]) return cmd_groupchat(playerid, params);
CMD:groupc(playerid, params[]) return cmd_groupchat(playerid, params);

Group_SendMessage(groupid, message[], split=false, ping=false) {

	new color = Group [ groupid ] [ E_GROUP_DATA_HEX ] ;

	foreach(new playerid: Player) {

		if ( Character [ playerid ] [ E_CHARACTER_ID ] == -1 ) {

			continue ;
		}

		if ( ! IsPlayerLogged ( playerid ) ) {

			continue ;
		}

		if ( Character [ playerid ] [ E_CHARACTER_GROUPID ] <= 0 ) {
			continue ;
		}
		
		if ( PlayerVar [ playerid ] [ E_PLAYER_HIDING_GROUP ]) {

			continue ;
		}

		if ( Character [ playerid ] [ E_CHARACTER_GROUPID ] == Group [ groupid ] [ E_GROUP_DATA_SQLID ] ) 
		{
			if ( split ) ZMsg_SendClientMessage(playerid, color, message);
			else SendClientMessage(playerid, color, message);

			if ( ping ) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			continue ;
		}

		else continue ;
	}

	return true ;
}


#warning Link this to pager (CanPlayerUsePager) check for news faction or GROUP with Company type.