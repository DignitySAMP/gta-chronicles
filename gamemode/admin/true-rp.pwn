CMD:carrespawn(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new endpid, vid, name[MAX_PLAYER_NAME+1];

    if (sscanf(params, "k<player>", endpid) == 0)
    {
		vid = GetPlayerVehicleID(endpid) ;

        if (IsPlayerConnected(endpid))
        {

            GetPlayerName(endpid, name, sizeof(name));
			if (vid != 0)
			{
				SOLS_SetVehicleToRespawn(vid, "/carrespawn");

			    if (endpid != playerid)
			    {
			        new msgto[41];
				    format(msgto, sizeof(msgto), "Your car has been respawned by an admin.");
					SendClientMessage(endpid, 0xFFFFFFFF, msgto);
				}

				SendAdminCmd(playerid, sprintf("respawned a \"%s\" (%d)", ReturnVehicleName(vid), vid));
	    	}
	    	else
			{
   				new msg[MAX_PLAYER_NAME+33];
			    format(msg, sizeof(msg), "%s is not in any vehicle.", name);
				SendClientMessage(playerid, COLOR_RED, msg);
			}
    	}
    	else SendClientMessage(playerid, COLOR_RED, "Invalid player ID");
	}
	else
	{
		vid = GetPlayerVehicleID(playerid) ;
        GetPlayerName(playerid, name, sizeof(name));
		if (vid != 0)
		{
			SOLS_SetVehicleToRespawn(vid, "/carrespawn");
			SendAdminCmd(playerid, sprintf("respawned a \"%s\" (%d)", ReturnVehicleName(vid), vid));
    	}
    	else SendClientMessage(playerid, COLOR_RED,"Usage: /carrespawn [playerid]");
	}

	return true ;
}

CMD:carflip(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	if ( IsPlayerInAnyVehicle(playerid)) 
	{
		new vid = GetPlayerVehicleID(playerid);

		new Float: angle;

		GetVehicleZAngle(vid, angle);
		SetVehicleZAngle(vid, angle);

	   	SendAdminCmd(playerid, sprintf("flipped a \"%s\" (%d)", ReturnVehicleName(vid), vid));
	}

	return 1;
}

CMD:carslap(playerid, params[])
{
	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_ADVANCED)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new endpid, vid, Float:x, Float:y, Float:z;

    if (sscanf(params, "k<player>", endpid) == 0)
    {
        if (IsPlayerConnected(endpid))
        {
			vid = GetPlayerVehicleID(endpid);

			if (vid != 0)
			{
				GetVehiclePos(vid, x, y, z);
				SetVehiclePos(vid, x, y, z+5);

				new
					name[MAX_PLAYER_NAME+1],
					msgfrom[MAX_PLAYER_NAME+24];
			    GetPlayerName(endpid, name, sizeof(name));
				format(msgfrom, sizeof(msgfrom), "%s has been car slapped.", name);
			    SendClientMessage(playerid, 0xFFFFFFFF, msgfrom);

			    if (endpid != playerid)
				{
				    new msgto[34];
				    format(msgto, sizeof(msgto), "You were car slapped by an admin.");
					SendClientMessage(endpid, 0xFFFFFFFF, msgto);
				}
			   	
		   		SendHelperCmdWarn(playerid, sprintf("car slapped (%d) %s (Car %d)", endpid, ReturnPlayerNameData(endpid), vid));
	    	}
	    	else
			{
			    new name[MAX_PLAYER_NAME+1], msg[MAX_PLAYER_NAME+33];
			    GetPlayerName(endpid, name, sizeof(name));
			    format(msg, sizeof(msg), "{FFFFFF}%s is not in any vehicle.", name);
				SendClientMessage(playerid, COLOR_RED,msg);
			}
    	}
    	else SendClientMessage(playerid, COLOR_RED,"Invalid player ID");
	}
	else
	{
    	vid = GetPlayerVehicleID(playerid) ;

	    if (vid != 0)
		{
			GetVehiclePos(vid, x, y, z);
			SetVehiclePos(vid, x, y, z+5);

			SendHelperCmdWarn(playerid, sprintf("car slapped themselves (Car %d)", vid));
    	}
	    else SendClientMessage(playerid, COLOR_RED,"Usage: /carslap [playerid]");
	}
	return 1;
}

CMD:slapcar(playerid, params[])
{
	return cmd_carslap(playerid, params);
}

CMD:setcarhp(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_SENIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new vehicleid, hp;
	if (sscanf(params, "dd", vehicleid, hp) || vehicleid < 1 || !IsValidVehicle(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_RED,"Usage: /setcarhp [vehicle id] [health]");
	}

	if (hp < 250) SOLS_SetVehicleCanExplode(vehicleid, true);
	else SOLS_SetVehicleCanExplode(vehicleid, false);	

	SOLS_SetVehicleHealth(vehicleid, hp);
	return true;
}

CMD:carhp(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new endpid = INVALID_PLAYER_ID, vid, hp = -1;

    sscanf(params, "k<player>d", endpid, hp);
	if (endpid == INVALID_PLAYER_ID)
	{
		sscanf(params, "d", hp);
	}

	if (hp > 999) hp = 999;

	if (hp >= 0)
	{
		if (endpid == INVALID_PLAYER_ID) endpid = playerid;
		vid = GetPlayerVehicleID(endpid);
		if (!vid) return SendServerMessage (playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("(%d) %s is not in a vehicle.", endpid, ReturnPlayerNameData(endpid, 0, true))) ;
    
    	if (hp < 250) SOLS_SetVehicleCanExplode(vid, true);		
		SOLS_SetVehicleHealth(vid, hp);

		SendAdminCmd(playerid, sprintf("set the health of a \"%s\" (%d) to %d", ReturnVehicleName(vid), vid, hp));
		return 1;
	}

	SendClientMessage(playerid, COLOR_RED,"Usage: /carhp [playerid] [health]");
	return 1;
}

CMD:carfix(playerid, params[])
{
	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_ADVANCED)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new endpid, vid, string [ 128 ], name[MAX_PLAYER_NAME+1];

    if (sscanf(params, "k<player>", endpid) == 0)
    {
    	vid = GetPlayerVehicleID(endpid);

        if (IsPlayerConnected(endpid))
        {

            GetPlayerName(endpid, name, sizeof(name));
			if (vid != 0)
			{
				
				SOLS_RepairVehicle(vid);

			   	format ( string, sizeof ( string ), "[AdminCmd]: (%d) %s has fixed car %d.", 
			   		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), vid ) ;
			   	
				if (GetPlayerAdminLevel(playerid))
				{
					SendAdminCmd(playerid, sprintf("fixed the vehicle of (%d) %s (VID: %d)", endpid, ReturnPlayerNameData(endpid), vid));
				}
				else
				{
					SendAdvHelperMsg(string);
				}
			   	
			    if (endpid != playerid)
			    {
			        new msgto[64];
				    format(msgto, sizeof(msgto), "Your car has been fixed by (%d) %s.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT));
					SendClientMessage(endpid, COLOR_YELLOW, msgto);
				}
	    	}
	    	else
			{
   				new msg[MAX_PLAYER_NAME+33];
			    format(msg, sizeof(msg), "%s is not in any vehicle.", name);
				SendClientMessage(playerid, COLOR_RED, msg);
			}
    	}
    	else SendClientMessage(playerid, COLOR_RED, "Invalid player ID");
	}
	else
	{
		vid = GetPlayerVehicleID(playerid) ;
        GetPlayerName(playerid, name, sizeof(name));
		if (vid != 0)
		{
		   	format ( string, sizeof ( string ), "[AdminCmd]: (%d) %s has fixed their own car (%d).", 
		   		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), vid ) ;
		   	
		   	if (GetPlayerAdminLevel(playerid))
			{
				SendAdminCmd(playerid, sprintf("fixed their own vehicle (VID: %d)", vid));
			}
			else
			{
				SendAdvHelperMsg(string);
			}

			SOLS_RepairVehicle(vid);
    	}
    	else SendClientMessage(playerid, COLOR_RED,"Usage: /carfix [playerid]");
	}

	return 1;
}

CMD:fixcar(playerid, params[])
{
	return cmd_carfix(playerid, params);
}

CMD:mark(playerid, params[]) 
{
	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_SENIOR)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid, x, y, z);

	SetPVarFloat(playerid, "markX", x), SetPVarFloat(playerid, "markY", y), SetPVarFloat(playerid, "markZ", z);
	SetPVarInt(playerid, "markINT", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "markWORLD", GetPlayerVirtualWorld(playerid));

	new string [ 96 ] ;

	format ( string, sizeof ( string ), "Marked position set to %0.3f, %0.3f, %0.3f (Interior: %d, World: %d).", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid) );
	SendClientMessage(playerid, -1, string);

	return true ;
}

CMD:gotomark(playerid, params[]) 
{
	if (GetPlayerHelperLevel(playerid) < HELPER_LVL_SENIOR)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new Float:final_x, Float:final_y, Float:final_z, int, world;

	final_x = GetPVarFloat(playerid,"markX");
	final_y = GetPVarFloat(playerid,"markY");
	final_z = GetPVarFloat(playerid,"markZ");
    int = GetPVarInt(playerid, "markINT"); 
	world = GetPVarInt(playerid, "markWORLD");

	if (floatround(final_x) == 0 && floatround(final_y) == 0)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a marked position.") ;
	}

	SetPlayerInterior(playerid, int);
	SetPlayerVirtualWorld(playerid, world);
	
	if ( ! IsPlayerInAnyVehicle(playerid)) 
	{
    	SOLS_SetPosWithFade(playerid, final_x, final_y, final_z, "Marked Position");
    }
    else 
	{
    	SetVehiclePos(GetPlayerVehicleID(playerid), final_x, final_y, final_z) ;  	
    }

	new string [ 128 ] ;

	format ( string, sizeof ( string ), "You've teleported to your marked position at, %.3f, %.3f, %.3f.", final_x, final_y, final_z ) ;
	SendClientMessage(playerid, -1, string);

   	format ( string, sizeof ( string ), "[AdminCmd]: (%d) %s has teleported to their marked position.", 
   		playerid, ReturnPlayerNameData ( playerid ) ) ;
   	
   	SendAdvHelperMsg(string) ;
	return true ;
}