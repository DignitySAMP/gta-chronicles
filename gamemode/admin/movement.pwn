CMD:fw ( playerid, params [] ) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float:amount;

	if ( sscanf ( params, "F(2.0)", amount ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/fw [amount] (negative to go backwards, default is 2.0)") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;
	GetXYInFrontOfPlayer(playerid, x, y, amount);

	SetPlayerPos ( playerid, x, y, z ) ;

	new string [ 64 ] ;

	format ( string, sizeof ( string ),"%s warped themselves forward (/fw).", ReturnPlayerNameData ( playerid ) );
	WriteLog ( playerid, "admin/tp", string );
	WriteLog ( playerid, "admin/all", string  );

	return true ;
}

CMD:up ( playerid, params [] ) 
{
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED )
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float:amount;

	if ( sscanf ( params, "F(2.0)", amount ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/up [amount] (negative to go down, default is 2.0)") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;
	SetPlayerPos ( playerid, x, y, z + amount ) ;

	AddLogEntry(playerid, LOG_TYPE_ADMIN, "warped themselves up (/up).");

	return true ;
}

CMD:dn ( playerid, params [] ) 
{
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED )
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float:amount;

	if ( sscanf ( params, "F(2.0)", amount ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/dn [amount] (negative to go up, default is 2.0)") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;
	SetPlayerPos ( playerid, x, y, z - amount ) ;
	
	AddLogEntry(playerid, LOG_TYPE_ADMIN, "warped themselves down (/dn).");

	return true ;
}

CMD:goto(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_SENIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/goto [targetid]") ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player isn't connected.") ;
	}

	if (GetPlayerState(targetid) == PLAYER_STATE_SPECTATING && Account [ targetid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] >= ADMIN_LVL_JUNIOR)
	{
		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "This admin is spectating someone, you can't teleport to them." );
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( targetid, x, y, z ) ;

	new int = GetPlayerInterior(targetid );
	new vw = GetPlayerVirtualWorld(targetid ) ;

	if ( IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER ) {

		SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z ) ;
		SetPlayerInterior ( playerid, int ) ;
		SetPlayerVirtualWorld(playerid, vw ) ;

		foreach(new passenger: Player) {

			if ( GetPlayerVehicleID(passenger) == GetPlayerVehicleID ( playerid ) ) {

				SetPlayerInterior ( passenger, int ) ;
				SetPlayerVirtualWorld(passenger, vw ) ;	
			}
		}

		LinkVehicleToInterior(GetPlayerVehicleID(playerid), int ) ;
	}

	else {

		SetPlayerInterior ( playerid, int ) ;
		SetPlayerVirtualWorld ( playerid, vw ) ;
		SOLS_SetPlayerPos ( playerid, x, y, z, false ) ;
	}

	new string [ 96 ] ;

	format ( string, sizeof ( string ),"%s (%d) has teleported to you.", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(targetid, COLOR_YELLOW, string ) ;

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
	{
		SendHelperCmdWarn(playerid, sprintf("teleported to (%d) %s", targetid, ReturnPlayerNameData(targetid)));
	}

	UpdatePlayerNamesForPlayer ( playerid );
	UpdatePlayerNamesForOthers ( playerid );

	return true ;
}

CMD:bring(playerid, params[]) {

	return cmd_gethere(playerid, params);
}
CMD:gethere(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_SENIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/gethere [targetid]") ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player isn't connected.") ;
	}

	if ( targetid != playerid && GetPlayerAdminLevel ( targetid ) && GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't use this on admins of equal or higher rank.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	new int = GetPlayerInterior(playerid );
	new vw = GetPlayerVirtualWorld(playerid ) ;

	if ( IsPlayerInAnyVehicle(targetid) && GetPlayerState(targetid) == PLAYER_STATE_DRIVER ) {

		SetVehiclePos(GetPlayerVehicleID(targetid), x, y, z ) ;
		SetPlayerInterior ( targetid, int ) ;
		SetPlayerVirtualWorld(targetid, vw ) ;

		foreach(new passenger: Player) {

			if ( GetPlayerVehicleID(passenger) == GetPlayerVehicleID ( targetid ) ) {

				SetPlayerInterior ( passenger, int ) ;
				SetPlayerVirtualWorld(passenger, vw ) ;	
			}
		}

		LinkVehicleToInterior(GetPlayerVehicleID(targetid), int ) ;
	}

	else 
	{
		SetPlayerInterior ( targetid, int ) ;
		SetPlayerVirtualWorld ( targetid, vw ) ;
		SOLS_SetPlayerPos ( targetid, x, y, z ) ;
	}

	new string [ 96 ] ;

	UpdatePlayerNamesForPlayer ( targetid );
	UpdatePlayerNamesForOthers ( targetid );

	format ( string, sizeof ( string ),"%s (%d) has teleported you to their location.", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(targetid, COLOR_YELLOW,string ) ;

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
	{
		SendHelperCmdWarn(playerid, sprintf("teleported (%d) %s to them", targetid, ReturnPlayerNameData(targetid)));
	}

	Minigame_ResetVariables(targetid);

	return true ;
}

CMD:freeze(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/freeze [targetid]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected.");
	}

	if ( targetid != playerid && GetPlayerAdminLevel ( targetid ) && GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't use this on admins of equal or higher rank.") ;
	}

	TogglePlayerControllable(targetid, false);

	new query [ 96 ] ;
	format ( query, sizeof ( query ),"You've been frozen by %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(targetid, COLOR_YELLOW,query ) ;

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) SendHelperCmdWarn(playerid, sprintf("froze (%d) %s", targetid, ReturnPlayerNameData(targetid)));
	else SendAdminCmd(playerid, sprintf("froze (%d) %s", targetid, ReturnPlayerNameData(targetid)));

	return true ;
}
CMD:unfreeze(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/unfreeze [targetid]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected.");
	}


	TogglePlayerControllable(targetid, true);

	new query [ 96 ] ;
	format ( query, sizeof ( query ),"You've been un-frozen by %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(targetid, COLOR_YELLOW,query ) ;

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) SendHelperCmdWarn(playerid, sprintf("un-frozen (%d) %s", targetid, ReturnPlayerNameData(targetid)));
	else SendAdminCmd(playerid, sprintf("un-froze (%d) %s", targetid, ReturnPlayerNameData(targetid)));

	return true ;
}