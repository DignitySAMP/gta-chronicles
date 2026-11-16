CMD:sc(playerid, params[]) {

	return cmd_strawmanchat(playerid, params);
}

CMD:strawmanchat(playerid, params[]) {

	if ( GetPlayerAdminLevel(playerid) == 0 ) {
		if ( ! Character [ playerid ] [ E_CHARACTER_STRAWMAN ] ) {

			return SendClientMessage ( playerid, COLOR_ERROR, "You're not a strawman!");
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] ) {
		return SendClientMessage ( playerid, COLOR_ERROR, "You have toggled this chat. To reenable it, use /togd(onator)c(hat).");
	}
	if ( ! Server [ E_SERVER_SC_ENABLED ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Strawman Chat is currently disabled." ) ;
	}
	
	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		SendClientMessage(playerid, COLOR_ERROR, "/strawmanchat [text]" ) ;
		SendClientMessage(playerid, COLOR_YELLOW, "To toggle, use /togstrawman.");

		return true ;
	}

	if ( strlen ( text ) < 0 || strlen ( text ) > 144 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Text can't be less than 0 characters or more than 144 characters." ) ;
	}

	new string [ 256 ] ;

	if ( Character [ playerid ] [ E_CHARACTER_STRAWMAN ] && GetPlayerAdminLevel(playerid) == 0) {

		format ( string, sizeof ( string ), "(( (%d) Strawman %s: %s ))",  playerid, ReturnPlayerNameData ( playerid ), text ) ;
	}

	else if ( GetPlayerAdminLevel(playerid) != 0 ) {
		format ( string, sizeof ( string ), "(( (%d) Admin %s: %s ))",  playerid, ReturnPlayerNameData ( playerid ), text ) ;
	}

	SendStrawmanMessage(string);

	string[0]=EOS;
	format(string, sizeof(string), "[STRAWMAN CHAT] %s: %s", ReturnPlayerNameData ( playerid ), text );
	AddLogEntry(playerid, LOG_TYPE_OOC, string); // Make new log type for strawmen


	return true ;
}

// player
CMD:togstrawman(playerid, params[]) {

	if ( GetPlayerAdminLevel(playerid) == 0 ) {
		if ( ! Character [ playerid ] [ E_CHARACTER_STRAWMAN ]) {

			return SendClientMessage ( playerid, COLOR_ERROR, "You're not a strawman!");
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] ) {

		SendClientMessage ( playerid, COLOR_STRAWMAN, "You've enabled the strawman chat. To use it, use /s(trawman)c(hat)." ) ;
		PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] = false ;
	}
	else if ( !PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] ) {

		SendClientMessage ( playerid, COLOR_STRAWMAN, "You've hidden the strawman chat. You won't be able to see strawman messages anymore." ) ;
		PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] = true ;
	}


	return true ;
}

// Admin
CMD:nostrawman(playerid, params[]) {

	if ( ! IsPlayerManager ( playerid ) ) {

		return false ;
	}

	new string [ 256 ] ;

	if ( ! Server [ E_SERVER_SC_ENABLED ] ) {

		format ( string, sizeof ( string ), "[!!!] [AdmWarn] %s has enabled Strawman Chat.", ReturnPlayerNameData ( playerid )) ;
		Server [ E_SERVER_SC_ENABLED ] = true ;
	}

	else if ( Server [ E_SERVER_SC_ENABLED ] ) {

		format ( string, sizeof ( string ), "[!!!] [AdmWarn] %s has disabled Strawman Chat.", ReturnPlayerNameData ( playerid )) ;
		Server [ E_SERVER_SC_ENABLED ] = false ;
	}

	SendAdminMessage(string) ;

	format ( string, sizeof ( string), "((  Administrator %s has toggled the strawman chat. ))", ReturnPlayerNameData ( playerid ) ) ;

	SendStrawmanMessage(string);

	WriteLog ( playerid, "chat/ooc", string );

	return true ;
}

SendStrawmanMessage(text[]) {

	foreach(new strawmanid: Player) {

		if ( ! IsPlayerLogged ( strawmanid ) ) {

			continue ;
		}

		if ( PlayerVar [ strawmanid ] [ E_PLAYER_TOGGLE_STRAWMAN ] ) {
			continue ;
		}

		else if ( Character [ strawmanid ] [ E_CHARACTER_STRAWMAN ] || Account [ strawmanid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] > 0 ) {

			ZMsg_SendClientMessage(strawmanid, COLOR_STRAWMAN, text);
		}
	}
}