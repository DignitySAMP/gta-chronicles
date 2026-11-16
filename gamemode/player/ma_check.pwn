CheckDoubleConnection(playerid) {

	if ( ! IsPlayerConnected ( playerid ) ) {

		return true ;
	}

	if (GetPlayerAdminLevel(playerid) >= 6) return true;

	foreach(new i: Player) {

		if ( ! strcmp ( ReturnPlayerName ( playerid ), Account [ i ] [ E_PLAYER_ACCOUNT_NAME ], true) && IsPlayerLogged ( i ) ) {

			SendAdminWarning ( sprintf("%s tried to connect onto (%d) %s's master account (%s).", ReturnIP ( playerid ), i, ReturnPlayerNameData ( i), Account [ i ] [ E_PLAYER_ACCOUNT_NAME ]) ) ;
			SendClientMessage ( playerid, COLOR_YELLOW, "Someone is already connected on this master account. Try again later or contact a moderator on Discord." ) ;
			KickPlayer ( playerid ) ;
		}

		if ( ! strcmp (ReturnIP ( playerid ), ReturnIP ( i ), true ) && IsPlayerLogged (i) && GetPlayerAdminLevel(i) < 6 ) {
			SendAdminWarning ( sprintf("(ID %d) is connecting with IP %s. It is already in use by (%d) %s (%s).", 
				playerid, ReturnIP ( playerid ), i, ReturnPlayerNameData ( i ), ReturnIP ( i )) ) ;
			continue ;
		}

		else continue ;
	}
	return true ;
}