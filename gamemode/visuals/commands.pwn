
CMD:tognicks(playerid) {

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_NICKS_TOGGLED ] ) {
		PlayerVar [ playerid ] [ E_PLAYER_NICKS_TOGGLED ] = true ;
		SendClientMessage(playerid, COLOR_INFO, "You've disabled player nicknames." ) ;

		UpdatePlayerNamesForPlayer ( playerid ) ;
	}

	else if ( PlayerVar [ playerid ] [ E_PLAYER_NICKS_TOGGLED ] ) {
		PlayerVar [ playerid ] [ E_PLAYER_NICKS_TOGGLED ] = false ;
		SendClientMessage(playerid, COLOR_INFO, "You've enabled player nicknames." ) ;

		UpdatePlayerNamesForPlayer ( playerid ) ;
	}

	return true ;
}

CMD:tn(playerid) {

	return cmd_tognicks(playerid);
}


CMD:blindfold(playerid, params[]) {

    if ( PlayerVar [ playerid ] [ E_PLAYER_BLINDFOLDED ] ) {

        PlayerVar [ playerid ] [ E_PLAYER_BLINDFOLDED ] = false ;
        TextDrawHideForPlayer(playerid, gBlindfoldTD);
    }

    else if ( ! PlayerVar [ playerid ] [ E_PLAYER_BLINDFOLDED ] ) {

        PlayerVar [ playerid ] [ E_PLAYER_BLINDFOLDED ] = true ;
        TextDrawShowForPlayer(playerid, gBlindfoldTD);
    }

    return true ;
}