CMD:slap(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/slap [targetid]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected.");
	}

	if ( targetid != playerid && GetPlayerAdminLevel ( targetid ) && GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't use this on admins of equal or higher rank.") ;
	}

  	new Float:x, Float:y, Float:z;

	GetPlayerPos ( targetid, x, y, z ) ;
	SetPlayerPos ( targetid, x, y, z + 4 ) ;

	PlayerPlaySound ( targetid, 1190, x, y, z ) ;
	
	AddLogEntry(targetid, LOG_TYPE_ADMIN, sprintf("Was slapped by %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY)));

	new query [ 128 ] ;
	format ( query, sizeof ( query ),"You've been slapped by %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(targetid, COLOR_YELLOW,query ) ;

	SendHelperCmdWarn(playerid, sprintf("slapped (%d) %s", targetid, ReturnPlayerNameData(targetid)));

	GPS_ClearCheckpoint(targetid);
	return true ;
}

CMD:setinterior(playerid, params[]) {

	return cmd_setint(playerid, params);
}
CMD:setint(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, interior ;

	if ( sscanf ( params, "k<player>i", targetid, interior ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setint(erior) [targetid] [interior]");
	}

	if ( ! IsPlayerConnected(targetid) ) {
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");
	}	

	if ( targetid != playerid && GetPlayerAdminLevel ( targetid ) && GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't use this on admins of equal or higher rank.") ;
	}

	SetPlayerInterior(targetid, interior);

	new string[128];
	if (!GetPlayerAdminLevel(playerid))
	{
		format(string, sizeof(string), "%s (%d) has set your interior to %d", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid, interior);
		SendClientMessage(targetid, COLOR_YELLOW, string);
	}

	SendHelperCmdWarn(playerid, sprintf("set the interior of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), interior));
	return true ;
}

CMD:setvirtualworld(playerid, params[]) {

	return cmd_setvw(playerid, params);
}
CMD:setvw(playerid, params[]) {
	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, virtualworld ;

	if ( sscanf ( params, "k<player>i",targetid, virtualworld ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setv(irtual)w(orld) [targetid] [virtualworld]");
	}

	if ( ! IsPlayerConnected(targetid) ) {
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");
	}	

	if ( targetid != playerid && GetPlayerAdminLevel ( targetid ) && GetPlayerAdminLevel ( targetid ) >= GetPlayerAdminLevel ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't use this on admins of equal or higher rank.") ;
	}

	SetPlayerVirtualWorld(targetid, virtualworld);

	new string[128];
	if (!GetPlayerAdminLevel(playerid))
	{
		format(string, sizeof(string), "%s (%d) has set your virtual world to %d", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid, virtualworld);
		SendClientMessage(targetid, COLOR_YELLOW, string);
	}

	SendHelperCmdWarn(playerid, sprintf("set the virtual world of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), virtualworld));

	return true ;
}


CMD:gotoxyz ( playerid, params [] ) {
	
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z, interior, virtualworld ;

	if ( sscanf ( params, "fffI(0)I(0)", x, y, z, interior, virtualworld ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/gotoxyz [x coord] [y coord] [z coord] [optional:interior] [optional:virtualworld]" )  ;
	}

	SOLS_SetPlayerPos ( playerid, x, y, z ) ;

	SetPlayerInterior ( playerid, interior ) ;
	SetPlayerVirtualWorld ( playerid, virtualworld ) ;

	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Teleported to %.02f, %.02f, %.02f, interior: %d, world: %d", x, y, z, interior, virtualworld));
	return true ;
}

CMD:gotopos ( playerid, params [] ) {
	return cmd_gotoxyz(playerid, params);
}


CMD:getcoordinates(playerid, params[]) {
	
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}


	new Float: x, Float: y, Float: z ;
	GetPlayerPos(playerid, x, y, z ) ;

	new Float: angle ;
	GetPlayerFacingAngle(playerid, angle ) ;

	new interior = GetPlayerInterior(playerid), virtualworld = GetPlayerVirtualWorld(playerid) ;

	SendClientMessage(playerid, COLOR_INFO, "Your current coordinates:" ) ;
	SendClientMessage(playerid, 0xDEDEDEFF, sprintf(" x(%f) y(%f) z(%f) a(%f)", x, y, z, angle ) ) ;
	SendClientMessage(playerid, 0xA3A3A3FF, sprintf(" int(%d) world (%d)", interior, virtualworld ) ) ;

	return true ;
}

/*
CMD:ahide(playerid, params[]){

	if(GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;

	if(PlayerVar[playerid][E_PLAYER_ADMIN_HIDDEN]) {

		SendServerMessage ( playerid, COLOR_ERROR, "Admin Hide", "A3A3A3", "You are no longer admin hidden.") ;
		PlayerVar[playerid][E_PLAYER_ADMIN_HIDDEN] = false;

	} else {

		SendServerMessage ( playerid, COLOR_ERROR, "Admin Hide", "A3A3A3", "You have just hidden yourself as an admin. You are no longer shown on /admins. ") ;
		//SendServerMessage ( playerid, COLOR_ERROR, "Admin Hide", "A3A3A3", "If you want to be hidden from /id aswell, go on admin duty.") ;

		PlayerVar[playerid][E_PLAYER_ADMIN_HIDDEN] = true;
	}

	return true;
}
*/