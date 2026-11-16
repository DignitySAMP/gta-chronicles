CMD:admin911(playerid, params[])
{
	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL) return SendServerMessage (playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.");

	new service[10], call_text[100], ph_number, random_number[12], string[144], services[40];
    if (sscanf(params, "s[10] ds[100]", service, ph_number, call_text)) return SendClientMessage(playerid, -1, "/admin911 [police/fire] [ph number (0 for random)] [call text]");

	if (!strcmp(service, "Police", true))
	{
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 1; // police
	}
	else if (!strcmp(service, "Fire", true))
	{
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 2; // fire/ems
	}
	else
	{	
		SendClientMessage(playerid, -1, "Service must be \"police\" or \"fire\"");
		return 0;
	}

	if (ph_number) format(random_number, sizeof(random_number), "%d", ph_number);
	else
	{
		format(random_number, sizeof(random_number), "16%d%d%d%d", random(9),random(9),random(9),random(9));
		ph_number = strval(random_number);
	}

	PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] = ph_number; 
	
	new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
	GetPlayerPos ( playerid, x, y, z ) ;
	
	if (GetPlayerVirtualWorld(playerid) > 0)
	{
		// They are probably in a property, so use the exterior of that if they are
		new property = Property_GetInside(playerid);
		if (property != INVALID_PROPERTY_ID)
		{
			x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
			y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
			z = Property [ property ] [ E_PROPERTY_EXT_Z ];
		}
	}

	GetCoords2DZone(x, y, zone, sizeof ( zone ));
	GetPlayerAddress(x, y, address );

	Server [ E_SERVER_LAST_911_POS_X ] = x ;
	Server [ E_SERVER_LAST_911_POS_Y ] = y ;
	Server [ E_SERVER_LAST_911_POS_Z ] = z ;
	Server [ E_SERVER_LAST_911_TYPE ] = 0;
	Server [ E_SERVER_LAST_911_NUMBER ] = PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER];

	format ( string, sizeof ( string ), "[Emergency]: %s", call_text ) ;
	format ( services, sizeof ( services ), "[Services Requested]: %s", PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY] == 1 ? "Police" : "Fire / EMS" ) ;

	new color = COLOR_FACTION; // police color
	if (PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY] == 2) color = COLOR_FIRE;
	if (IsPlayerInMallArea(playerid)) Server [ E_SERVER_LAST_911_TYPE ] = 1;

	foreach(new policeid: Player) 
	{
		if (policeid == playerid || IsPlayerInPoliceFaction(policeid) || IsPlayerInMedicFaction(policeid) || (Server[E_SERVER_LAST_911_TYPE] == 1 && IsPlayerInSecurityFaction(policeid, true))) 
		{
			new faction_enum_id = Faction_GetEnumID(Character [ policeid ] [ E_CHARACTER_FACTIONID ] ); 

			SendClientMessage(policeid, color, sprintf("[Dispatch Forwards 9-1-1 Call]: From %s", random_number ) ) ;
			SendClientMessage(policeid, color, sprintf("[Location]: %s, %s", address, zone ) ) ;
			ZMsg_SendClientMessage(policeid, color, services);
			ZMsg_SendClientMessage(policeid, color, string);

			if (CanFactionAcceptEmergency(faction_enum_id, PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY])) 
			{
				SendClientMessage(policeid, COLOR_YELLOW, sprintf("To accept this call, type \"/acc(eptcall) %d\".", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER]));
			}
		}
		else if (Has911Scanner(policeid))
		{
			SendClientMessage(policeid, color, sprintf("[Scanner Receives 9-1-1 Call]: From %s", random_number ) ) ;
			SendClientMessage(policeid, color, sprintf("[Location]: %s, %s", address, zone ) ) ;
			ZMsg_SendClientMessage(policeid, color, services);
			ZMsg_SendClientMessage(policeid, color, string);
		}
	}

	return 1;
}

CMD:lastrobbery(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (!IsPlayerInPoliceFaction(playerid) && !IsPlayerInMedicFaction(playerid) && !IsPlayerInSecurityFaction(playerid, true) && !IsPlayerInDEAFaction(playerid)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in an emergency services faction.");
	}

	if (IsPlayerInSecurityFaction(playerid) && Server [ E_SERVER_LAST_911_TYPE ] != 1)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't track this call.");
	}

	DisablePlayerCheckpoint(playerid);
    GPS_MarkLocation ( playerid, "The last ~r~911 call~w~ has been ~b~marked~w~!", E_GPS_COLOR_SCRIPT, Server [ E_SERVER_LAST_911_POS_X ], Server [ E_SERVER_LAST_911_POS_Y ], Server [ E_SERVER_LAST_911_POS_Z ] ) ;
    //SendClientMessage(playerid, COLOR_INFO, "Last 911 call has been marked on your minimap!");

	return true ;
}

CMD:lastalarm(playerid, params[]) {

	return cmd_lastrobbery(playerid, params);
}
CMD:lastburglary(playerid, params[]) {

	return cmd_lastrobbery(playerid, params);
}



Robbery_SendPoliceAlert(actorid, playerid) {

	new Float: x, Float: y, Float: z ;
	GetActorPos(actorid, x, y, z );

	new address [ 64 ], zone [ 64 ], area [ 12 ], city [ 64 ] ;

	GetPlayerAddress(x, y, address) ;
	GetCoords2DZone(x, y, zone, sizeof ( zone ));
	GetPlayerAreaZone(x, y, area ) ;
	GetCoords2DMainZone(x, y, city, sizeof ( city ) ) ;

	Server [ E_SERVER_LAST_911_POS_X ] = x ;
	Server [ E_SERVER_LAST_911_POS_Y ] = y ;
	Server [ E_SERVER_LAST_911_POS_Z ] = z ;
	Server [ E_SERVER_LAST_911_TYPE ] = 0 ;

	new random_number [ 12 ], string [ 256 ] ;
	format ( random_number, sizeof ( random_number ), "16%d - %d%d%d", random(9),random(9),random(9),random(9) ) ;

	foreach(new policeid: Player) 
	{
		if (IsPlayerInPoliceFaction(policeid, true) || IsPlayerInAPFaction(policeid, true)) 
		{
			format ( string, sizeof ( string ), "[Dispatch Forwards Robbery Alarm]: From: %s", random_number )  ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			format ( string, sizeof ( string ), "[Location] %s, %s, %s, %s", address, zone, area, city ) ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			SendClientMessage(policeid, COLOR_FACTION, "[Silent Alarm]: 211 - Robbery in progress at this property.");

			format(string, sizeof(string), "[Suspect]: {C2A2DA}(** description of %s **)", SOLS_PlayerName(playerid));
			SendClientMessage(policeid, COLOR_FACTION, string);

			SendClientMessage(policeid, COLOR_FACTION, "To track this call, type /lastalarm. (Puts GPS blip on map)" ) ;
		}
		else if (Has911Scanner(policeid))
		{	
			format ( string, sizeof ( string ), "[Scanner Receives Robbery Alarm]: From: %s", random_number )  ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			format ( string, sizeof ( string ), "[Location] %s, %s, %s, %s", address, zone, area, city ) ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			SendClientMessage(policeid, COLOR_FACTION, "[Description]: 211 - Robbery in progress at this property.");
		}
	}
}

Alarm_SendPoliceAlert(vehicleid) {

	new Float: x, Float: y, Float: z ;
	GetVehiclePos ( vehicleid, x, y, z ) ;

	new address [ 64 ], zone [ 64 ], area [ 12 ], city [ 64 ] ;

	GetPlayerAddress(x, y, address) ;
	GetCoords2DZone(x, y, zone, sizeof ( zone ));
	GetPlayerAreaZone(x, y, area ) ;
	GetCoords2DMainZone(x, y, city, sizeof ( city ) ) ;

	Server [ E_SERVER_LAST_911_POS_X ] = x ;
	Server [ E_SERVER_LAST_911_POS_Y ] = y ;
	Server [ E_SERVER_LAST_911_POS_Z ] = z ;
	Server [ E_SERVER_LAST_911_TYPE ] = 0 ;

	new random_number [ 12 ], string [ 256 ] ;

	foreach(new policeid: Player)
	{
		if (IsPlayerInPoliceFaction(policeid, true))
		{ 
			format ( random_number, sizeof ( random_number ), "16%d - %d%d%d", random(9),random(9),random(9),random(9) ) ;
			
			format ( string, sizeof ( string ), "[Dispatch Forwards 9-1-1 Call]: From: %s", random_number )  ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			format ( string, sizeof ( string ), "[Location] %s, %s, %s, %s", address, zone, area, city ) ;
			ZMsg_SendClientMessage(policeid, COLOR_FACTION, string);

			SendClientMessage(policeid, COLOR_FACTION, "[Services Requested]: Police");

			ZMsg_SendClientMessage(policeid, COLOR_FACTION, sprintf("[Description]: A car alarm is going off! I-I think it was a %s!", ReturnVehicleName ( vehicleid ) ));
			SendClientMessage(policeid, COLOR_FACTION, "To track this call, type /lastalarm. (Puts GPS blip on map)" ) ;
		}
	}
}