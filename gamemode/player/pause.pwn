
CMD:afklist ( playerid, params [] ) {

	SendClientMessage(playerid, COLOR_BLUE, "List of all AFK players") ;

	foreach(new i: Player) {

		if ( IsPlayerPaused ( i ) && i != INVALID_PLAYER_ID ) {

			SendClientMessage(playerid, COLOR_GRAD0, sprintf("(%d) %s (paused for %d seconds)", i, SOLS_PlayerName(i, PLAYER_NAME_STYLE_CHARACTER), GetPlayerPausedTime(i) / 1000 ) ) ;
			//SendClientMessage(playerid, COLOR_GRAD0, sprintf("(%d) %s (paused for %d seconds)", i, ReturnPlayerNameData ( i ) ) ) ;
		}

		else continue;
	}

	return true ;
}
/*
public OnPlayerUpdate(playerid) {
	

	new tick = GetTickCount();
	PlayerVar [ playerid ] [ E_PLAYER_LAST_UPDATE ] = tick;

	#if defined pause_OnPlayerUpdate
		return pause_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate pause_OnPlayerUpdate
#if defined pause_OnPlayerUpdate
	forward pause_OnPlayerUpdate(playerid);
#endif



IsPlayerPaused(playerid) {
	return (GetTickCount() - PlayerVar [ playerid ] [ E_PLAYER_LAST_UPDATE ] > 2000);
}
*/