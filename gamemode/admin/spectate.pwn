SpectateTick(playerid, targetid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] == INVALID_PLAYER_ID ) {

		return true ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] != targetid ) {

		return true ;
	}

	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {

		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_JUNIOR ) {

			return true ;
		}

		if ( targetid == INVALID_PLAYER_ID ) {

			return true ;
		}

		UpdateSpectatorPanel(playerid, targetid) ;

		if ( GetPlayerInterior ( playerid ) != GetPlayerInterior ( targetid ) ) {

			SetPlayerInterior ( playerid, GetPlayerInterior ( targetid ) ) ;
		}
		
		if ( GetPlayerVirtualWorld ( playerid ) != GetPlayerVirtualWorld ( targetid ) ) {

			SetPlayerVirtualWorld ( playerid, GetPlayerVirtualWorld ( targetid ) ) ;
		}

		if ( IsPlayerInAnyVehicle(targetid)) {
			if ( PlayerVar [ playerid ] [ E_PLAYER_SPEC_VEH ] != GetPlayerVehicleID(targetid) ) {

				PlayerVar [ playerid ] [ E_PLAYER_SPEC_VEH ] = GetPlayerVehicleID(targetid) ;
				PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
				PlayerVar [ playerid ] [ E_PLAYER_SPEC_RESYNC ] = false ;
			}
		}

		else {
			if ( ! PlayerVar [ playerid ] [ E_PLAYER_SPEC_RESYNC ] ) {
				PlayerSpectatePlayer(playerid, targetid);
				PlayerVar [ playerid ] [ E_PLAYER_SPEC_VEH ] = INVALID_VEHICLE_ID ;
				PlayerVar [ playerid ] [ E_PLAYER_SPEC_RESYNC ] = true ;
			}
		}


		//if ( ++ PlayerVar [ playerid ] [ E_PLAYER_SPEC_TAG_RESYNC ] >= 30 ) {
    	//	UpdatePlayerNamesForPlayer ( playerid );
    	//	PlayerVar [ playerid ] [ E_PLAYER_SPEC_TAG_RESYNC ] = 0 ;
    	//}
	}

	else {

 		PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);

	    PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = INVALID_PLAYER_ID ;
	  	PlayerVar [ playerid ] [ E_PLAYER_SPEC_RESYNC ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_SPEC_VEH ] = INVALID_VEHICLE_ID ;

	 	TogglePlayerSpectating(playerid, false);

	 	Spectate_RefundAdminGuns(playerid);

		for_loop ( new i, j = 5; i < j ; i ++ ) {

			PlayerTextDrawHide(playerid,  gui_spec_label [ playerid ] [ i ] ) ;
		}

		SetPlayerInterior ( playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_INT ] ) ;
	    SetPlayerVirtualWorld( playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_VW ] ) ;
	    SOLS_SetPosWithFade ( playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_X ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Y ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Z ] ) ;

    	UpdatePlayerNamesForPlayer ( playerid );
		UpdatePlayerNamesForOthers ( playerid );

		return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You are no longer in spectator mode for some reason (target might have quit), resetting your state." );
	}

	return true ;
}

CMD:setspec(playerid, params[])
{
	if (GetPlayerAdminLevel(playerid) <= ADMIN_LVL_SENIOR)
	{
		return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You don't have access to this." );
	}

	new userid, targetid;
	if (sscanf(params, "k<player>k<player>", userid, targetid)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/setspec [player] [target player]" );
	}

	if (!IsPlayerConnected(userid) || !IsPlayerConnected(targetid)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You have specified an invalid player." );
	}

	SOLS_PlayerSpecPlayer(userid, targetid);
	new string[144];

	format ( string, sizeof ( string ), "{[ (%d) %s made (%d) %s spectate (%d) %s ]}", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), userid, ReturnPlayerNameData(userid), targetid, ReturnPlayerNameData(targetid) );
	SendManagerMessage(string) ;

	format ( string, sizeof ( string ), "{[ Admin %s (%d) made you spectate %s (%d), type \"/spec off\" to stop. ]}", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid, SOLS_PlayerName(targetid), targetid );
	SendClientMessage(userid, COLOR_SECURITY, string);

	return true;
}

CMD:spectate(playerid, params[]) 
{
	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING || PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] == INVALID_PLAYER_ID) 
		{
			return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You are not spectating any player." );
	    }

	    SOLS_PlayerSpecPlayer(playerid, INVALID_PLAYER_ID);
		return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You are no longer in spectator mode." );
	}

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_JUNIOR || (Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] && Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] <= 2)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You need to be an administrator in order to be able to do this!" );
	}

	new userid;

	if (sscanf(params, "k<player>", userid)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/spectate [playerid/name] - Type \"/spectate off\" to stop spectating." );
	}

	if (!IsPlayerConnected(userid)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You have specified an invalid player." );
	}

	SOLS_PlayerSpecPlayer(playerid, userid);
	new string[144];

	format ( string, sizeof ( string ), "{[ %d %s spectates %d %s ]}", playerid, ReturnPlayerNameData ( playerid ), userid, ReturnPlayerNameData ( userid ) ) ;
	SendManagerMessage(string);

	if ( Player_GetNoteCount(userid)  && IsPlayerLogged(userid))
		return SendServerMessage ( playerid, COLOR_SECURITY, "Notes", "A3A3A3",  sprintf("This player has %d active admin notes. (/notes %d)", Player_GetNoteCount(userid), userid));

	//WriteLog ( playerid, "admin/spec", string );
	//WriteLog ( playerid, "admin/all",string );

	return 1;
}

CMD:spec ( playerid, params [] ) 
{
	return cmd_spectate ( playerid, params ) ;
}

SOLS_PlayerSpecPlayer(playerid, targetid)
{
	if (targetid == INVALID_PLAYER_ID)
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) return;

		PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
		TogglePlayerSpectating(playerid, false);

		if (PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] != INVALID_PLAYER_ID)
		{
			Spectate_RefundAdminGuns(playerid);

			SetPlayerInterior ( playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_INT ] ) ;
	    	SetPlayerVirtualWorld( playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_VW ] ) ;
			SOLS_SetPosWithFade(playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_X ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Y ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Z ]);
		}

		HideSpecTextDraws(playerid);
	    PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = INVALID_PLAYER_ID ;
	  	PlayerVar [ playerid ] [ E_PLAYER_SPEC_RESYNC ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_SPEC_VEH ] = INVALID_VEHICLE_ID ;

		return;
	}
	else if (IsPlayerConnected(targetid))
	{
		PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = targetid ;

		if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) 
		{
			GetPlayerPos(playerid, PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_X ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Y ], PlayerVar [ playerid ] [ E_PLAYER_SPEC_POS_Z ]);

			PlayerVar [ playerid ] [ E_PLAYER_SPEC_INT ] = GetPlayerInterior(playerid);
			PlayerVar [ playerid ] [ E_PLAYER_SPEC_VW ] = GetPlayerVirtualWorld(playerid);

			ShowSpecTextDraws(playerid);
			Spectate_SaveAdminGuns(playerid);
			TogglePlayerSpectating(playerid, 1);
		}

		SetPlayerInterior(playerid, GetPlayerInterior(targetid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
		PlayerSpectatePlayer(playerid, targetid);

		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Spectated %s (%d)", ReturnPlayerNameData ( targetid ), targetid));
	}
}

HideSpecTextDraws(playerid)
{
	for_loop ( new i, j = 5; i < j ; i ++ ) 
	{
		PlayerTextDrawHide(playerid,  gui_spec_label [ playerid ] [ i ] ) ;
	}
}

ShowSpecTextDraws(playerid)
{
	for_loop ( new i, j = 5; i < j ; i ++ ) 
	{
		PlayerTextDrawShow(playerid, gui_spec_label [ playerid ] [ i ] ) ;
	}
}

#include <YSI_Coding\y_hooks>

hook SOLS_OnCloseConnection(playerid, reason)
{
    HideSpecTextDraws(playerid);
    return 1;
}

/*
hook OnPlayerStateChange(playerid, oldstate, newstate)
{
	if (oldstate == PLAYER_STATE_SPECTATING)
    {
        HideSpecTextDraws(playerid);
    }

	return 1;
}
*/

hook OnPlayerConnect(playerid)
{
	PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = INVALID_PLAYER_ID ;
	return 1;
}
