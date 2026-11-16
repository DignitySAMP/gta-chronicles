CMD:agjoin(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new groupid ;

	if ( sscanf ( params, "i", groupid ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/agjoin [sql id] (check /groups or /companies)") ;
		return true ;
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	Character [ playerid ] [ E_CHARACTER_GROUPID ] = groupid ;
	Character [ playerid ] [ E_CHARACTER_GROUPTIER ] = 1 ;

	SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've made yourself the temporary leader of group %d.", groupid ) ) ;

	return true ;
}


CMD:groupcreate(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new type, name[64] ;

	if ( sscanf ( params, "is[64]", type, name ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)create [type] [name]") ;
		SendClientMessage(playerid, COLOR_GRAD0, "Types: 0: OOC chat, 1: Company" ) ;

		return true ;
	}

	if ( strlen ( name ) > 64 || strlen ( name ) < 3 ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Names can't be less than 3 characters or more than 64!") ;

		return true ;
	}

	if(type < 0 || type > 1 ) {
		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Types can't be less than 0(default) or more than 1(company)!") ;

		return true ;
	}


	Group_Create (name, type);

	SendClientMessage(playerid, COLOR_INFO, sprintf("Created group \"%s\" with type %d. Use /groups to get it's ID.", name, type ) ) ;
	SendClientMessage(playerid, COLOR_INFO, "You can set it's name using /g(roup)name. More info in /g(roup)help." ) ;

	return true ;
}

CMD:gcreate(playerid, params[]) return cmd_groupcreate(playerid, params);

CMD:groupname(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new groupid, name [ 64 ] ;

	if ( sscanf (params, "is[64]", groupid, name ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/g(roup)name [sql id] [name] (check /groups or /companies)") ;
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	format ( Group [ group_enum_id ] [ E_GROUP_DATA_NAME ], 64, "%s", name ) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE groups SET group_data_name = '%e' WHERE group_data_sqlid = %d", 
		 Group [ group_enum_id ] [ E_GROUP_DATA_NAME ],  Group [ group_enum_id ] [ E_GROUP_DATA_SQLID ]
	) ;

	mysql_tquery(mysql, query);

	format(query, sizeof(query), "(( Admin (%d) %s has changed the group's name to \"%s\" ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), Group [ group_enum_id ] [ E_GROUP_DATA_NAME ]
	);
	Group_SendMessage(group_enum_id, query, true, true);
	return true ;
}

CMD:gname(playerid, params[]) return cmd_groupname(playerid, params);

CMD:grouptype(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new groupid, type ;

	if ( sscanf (params, "ii", groupid, type ) ) {
		
		SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/g(roup)type [sql id] [type] (check /groups or /companies)") ;
		SendClientMessage(playerid, COLOR_YELLOW, "Possible types: 0) Group, 1) Company" ) ;
		return true ;
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	Group [ group_enum_id ] [ E_GROUP_DATA_TYPE ] = type ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE groups SET group_data_type = %d WHERE group_data_sqlid = %d", 
		 Group [ group_enum_id ] [ E_GROUP_DATA_TYPE ],  Group [ group_enum_id ] [ E_GROUP_DATA_SQLID ]
	) ;

	mysql_tquery(mysql, query);

	new type_name [ 32 ] ;

	switch ( type ) {

		case 1: format (type_name, sizeof ( type_name ), "Company" ) ;
		default: format (type_name, sizeof ( type_name ), "Group" ) ;
	}

	format(query, sizeof(query), "(( Admin (%d) %s has changed the group's type to (%d) %s. ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), type, type_name
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}

CMD:gtype(playerid, params[]) return cmd_grouptype(playerid, params);

CMD:groupcolor(playerid, params[]) { // sets hex

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new groupid, hex ;

	if ( sscanf ( params, "ih", groupid, hex ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)color  [sql id] [hex] (check /groups or /companies)");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	Group [ group_enum_id ] [ E_GROUP_DATA_HEX ] = hex ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE groups SET group_data_hex = %d WHERE group_data_sqlid = %d",
		Group [ group_enum_id ] [ E_GROUP_DATA_HEX ],  Group [ group_enum_id ] [ E_GROUP_DATA_SQLID ] 
	) ;
	mysql_tquery ( mysql, query ) ;

	query[0]=EOS;

	format(query, sizeof(query), "(( Admin (%d) %s has changed the group chat color. ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)
	);
	Group_SendMessage(group_enum_id, query, true, true);
	

	return true ;
}

CMD:gcolor(playerid, params[]) return cmd_groupcolor(playerid, params);