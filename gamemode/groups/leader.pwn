
CMD:groupmotd(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}


	new input [ 128 ] ;

	if ( sscanf ( params, "s[128]", input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)m(otd) [text]");
	}

	if ( strlen ( input ) > sizeof ( input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Your text can't be longer than %d characters.", sizeof ( input )));
	}

	new query [ 256 ] ;

	format ( Group [ group_enum_id ] [ E_GROUP_DATA_MOTD ], 128, "%s", input ) ;
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE groups SET group_data_motd = '%e' WHERE group_data_sqlid = %d",
		Group [ group_enum_id ] [ E_GROUP_DATA_MOTD ], Group [ group_enum_id ] [ E_GROUP_DATA_SQLID ] 
	) ;
	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	format(query, sizeof(query), "(( (%d) %s has changed the MOTD to \"%s\" ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), Group [ group_enum_id ] [ E_GROUP_DATA_MOTD ]
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}

CMD:gmotd(playerid, params[]) return cmd_groupmotd(playerid, params);
 

CMD:groupsettier(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}


	new targetid, tier ;

	if ( sscanf ( params, "ui", targetid, tier ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/g(roup)(set)tier [targetid / part of name] [tier]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ targetid ] [ E_CHARACTER_GROUPID ] != Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same group as you are!");
	}

	if ( tier < 1 || tier > 3 ) {
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Tier can't be less than 0, or more than 3!");
		SendClientMessage(playerid, COLOR_YELLOW, "Tier 3: Member, Tier 2: Command, Tier 1: Leader");
		return true ;
	}

	if ( Character [ targetid ] [ E_CHARACTER_GROUPTIER ] < Character [ playerid ] [ E_CHARACTER_GROUPTIER ] || tier < Character [ playerid ] [ E_CHARACTER_GROUPTIER ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't set a tier that's more privileged than your own.");
	}

	Character [ targetid ] [ E_CHARACTER_GROUPTIER ] = tier ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_grouptier = %d WHERE player_id = %d",
		Character [ targetid ] [ E_CHARACTER_GROUPTIER ], Character [ targetid ] [ E_CHARACTER_ID ]
	) ;
	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	format(query, sizeof(query), "(( (%d) %s has changed (%d) %s's tier to %d ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), targetid, SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_CHARACTER), tier
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}
CMD:gsettier(playerid, params[]) return cmd_groupsettier(playerid, params);
CMD:gtier(playerid, params[]) return cmd_groupsettier(playerid, params);
CMD:grouptier(playerid, params[]) return cmd_groupsettier(playerid, params);
 
CMD:groupinvite(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	new targetid ;

	if ( sscanf ( params, "u", targetid ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/g(roup)invite [targetid / part of name]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ targetid ] [ E_CHARACTER_GROUPID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target is already in a group!");
	}

	Character [ targetid ] [ E_CHARACTER_GROUPID ] = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;
	Character [ targetid ] [ E_CHARACTER_GROUPTIER ] = 3 ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_groupid = %d, player_grouptier = %d WHERE player_id = %d",
		Character [ targetid ] [ E_CHARACTER_GROUPID ], Character [ targetid ] [ E_CHARACTER_GROUPTIER ], Character [ targetid ] [ E_CHARACTER_ID ]
	) ;
	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	format(query, sizeof(query), "(( (%d) %s has invited (%d) %s to the group. ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), targetid, SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_CHARACTER)
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}

CMD:ginvite(playerid, params[]) return cmd_groupinvite(playerid, params);
  
CMD:groupuninvite(playerid, params[]) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	new targetid ;

	if ( sscanf ( params, "u", targetid ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/g(roup)uninvite [targetid / part of name]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ targetid ] [ E_CHARACTER_GROUPID ] != Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same group as you are!");
	}

	if ( Character [ targetid ] [ E_CHARACTER_GROUPTIER ] < Character [ playerid ] [ E_CHARACTER_GROUPTIER ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't change the tier of someone who has more privileges than you.");
	}

	Character [ targetid ] [ E_CHARACTER_GROUPID ] = 0 ;
	Character [ targetid ] [ E_CHARACTER_GROUPTIER ] = 3 ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_groupid = %d, player_grouptier = %d WHERE player_id = %d",
		Character [ targetid ] [ E_CHARACTER_GROUPID ], Character [ targetid ] [ E_CHARACTER_GROUPTIER ], Character [ targetid ] [ E_CHARACTER_ID ]
	) ;
	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	format(query, sizeof(query), "(( (%d) %s has uninvited (%d) %s from the group. ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), targetid, SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_CHARACTER)
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}

CMD:guninvite(playerid, params[]) return cmd_groupuninvite(playerid, params);
  

CMD:gouninvite(playerid, params[]) {


	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	new offid ;

	if ( sscanf ( params, "i", offid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)ouninvite [offline-id] - use /g(roup)off(line)");
	}

	foreach(new idx: Player) 
	{
		if (Character[idx][E_CHARACTER_ID] == offid) 
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player is online.");
		}
	}

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_groupid = 0, player_grouptier = 3 WHERE player_groupid = %d AND player_id = %d AND player_grouptier >= %d ", 
		Character [ playerid ] [ E_CHARACTER_GROUPID ], offid, Character [ playerid ] [ E_CHARACTER_GROUPTIER ]
	) ;

	mysql_tquery(mysql, query);

	SendServerMessage ( playerid, COLOR_BLUE, "Faction", "A3A3A3", "If the offline ID you entered was correct, the player should be removed. Use /g(roup)off(line) to check.");

	return true ;
}

CMD:groupouninvite(playerid, params[]) {
	return cmd_gouninvite(playerid, params);
}

CMD:grouptogchat(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	Group [ group_enum_id ] [ E_GROUP_DATA_CHAT ] = !Group [ group_enum_id ] [ E_GROUP_DATA_CHAT ] ;

	new query [ 256 ] ;

	switch ( Group [ group_enum_id ] [ E_GROUP_DATA_CHAT ] ) {

		case false : {
			format(query, sizeof(query), "(( (%d) %s has disabled the group chat. ))",  
				playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)
			);
		}

		case true: {
			format(query, sizeof(query), "(( (%d) %s has enabled the group chat. ))",  
				playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)
			);
		}
	}

	Group_SendMessage(group_enum_id, query, true, true);

	query [ 0 ] = EOS ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE groups SET group_data_chat = %d WHERE group_data_sqlid = %d",
		Group [ group_enum_id ] [ E_GROUP_DATA_CHAT ], Group [ group_enum_id ] [ E_GROUP_DATA_SQLID ] ) ;

	mysql_tquery ( mysql, query ) ;
	return true ;
}

CMD:gtogchat(playerid, params[]) return cmd_grouptogchat(playerid, params);
 