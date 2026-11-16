#define COLOR_TAXI          (0xD7A937FF)
#define TAXI_AD_COOLDOWN    2700

static LAST_TAXI_AD_TIME;

CMD:taxiad(playerid)
{
    new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

    if (!IsPlayerInTaxiFaction(playerid, true)) return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty as a taxi driver.");

    if (LAST_TAXI_AD_TIME && (gettime() - LAST_TAXI_AD_TIME) < TAXI_AD_COOLDOWN)
    {
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must wait before sending another taxi ad.");
    }

    new drivers = 0;

    foreach (new i:Player)
    {
        if (IsPlayerInTaxiFaction(i, true))
        {
            drivers ++;
        }
    }

    if (drivers == 1)
    {
        SendClientMessageToAll(COLOR_TAXI, sprintf("[%s] Need a taxi?  Dial our hotline on 1-1-1, Driver %s is now on duty!", Faction[faction_enum_id][E_FACTION_NAME], SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)));
    }
    else
    {
        SendClientMessageToAll(COLOR_TAXI, sprintf("[%s] Need a cab?  Call our hotline now on 1-1-1, we have %d drivers on duty!", Faction[faction_enum_id][E_FACTION_NAME], drivers));
    }

    LAST_TAXI_AD_TIME = gettime();
    
    return true;
}

GetFactionTypeForEmergency(emergency)
{
    if (emergency == 1) return FACTION_TYPE_POLICE;
    else if (emergency == 2) return FACTION_TYPE_EMS;
    else if (emergency == 3) return FACTION_TYPE_GOV;
    else if (emergency == 4) return FACTION_TYPE_TAXI;

    return -1;
}

CanFactionAcceptEmergency(faction_enum_id, emergency)
{
    return Faction[faction_enum_id][E_FACTION_TYPE] == GetFactionTypeForEmergency(emergency);
}

CMD:acceptlastcall(playerid)
{
    new factionid = Character[playerid][E_CHARACTER_FACTIONID];
    new faction_enum_id = Faction_GetEnumID(factionid); 

    if (!factionid || faction_enum_id == INVALID_FACTION_ID) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction.");
    else if (!PlayerVar[playerid][E_PLAYER_FACTION_DUTY]) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty.");    

    if (!Server[E_SERVER_LAST_911_NUMBER])
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There's no last call to accept.");    
    }

    return cmd_acceptcall(playerid, sprintf("%d", Server[E_SERVER_LAST_911_NUMBER]));
}

CMD:alc(playerid)
{
    return cmd_acceptlastcall(playerid);
}

CMD:acceptcall(playerid, params[])
{
    new factionid = Character[playerid][E_CHARACTER_FACTIONID];
    new faction_enum_id = Faction_GetEnumID(factionid); 

    if (!factionid || faction_enum_id == INVALID_FACTION_ID) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction.");
    else if (!PlayerVar[playerid][E_PLAYER_FACTION_DUTY]) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty.");    
    
    // Lets taxi drivers (and also PD, FD, etc.) accept calls
    new phnumber;

	if (sscanf(params, "d", phnumber) || phnumber <= 0)
    {
		return SendClientMessage(playerid, COLOR_ERROR, "/acceptcall [number]" ) ;
	}

    new targetid = INVALID_PLAYER_ID;

    foreach(new i: Player) 
	{
        if (PlayerVar[i][E_PLAYER_PHONE_EMERGENCY] && PlayerVar[i][E_PLAYER_PHONE_CALL_NUMBER] == phnumber && CanFactionAcceptEmergency(faction_enum_id, PlayerVar[i][E_PLAYER_PHONE_EMERGENCY])) 
		{
            targetid = i;
            break;
		} 
	}

    if (targetid == INVALID_PLAYER_ID)
    {
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This call number is invalid or incompatible with your faction.");    
    }

    new emergency = PlayerVar[targetid][E_PLAYER_PHONE_EMERGENCY];
    new string[128], factype = GetFactionTypeForEmergency(emergency);
    new color = Faction[faction_enum_id][E_FACTION_HEXCOLOR];

    if (CAD_GetPlayerUnit(playerid)) format(string, sizeof(string), "[%s] (%d) %s has accepted the call by %d.", CAD_PrintPlayerUnit(playerid), playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), PlayerVar[targetid][E_PLAYER_PHONE_CALL_NUMBER]);
    else format(string, sizeof(string), "[%s] (%d) %s has accepted the call by %d.", Faction[faction_enum_id][E_FACTION_ABBREV], playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), PlayerVar[targetid][E_PLAYER_PHONE_CALL_NUMBER]);
    
    for_loop ( new i, j = sizeof ( Faction ); i < j ; i ++ ) 
    {
        if (Faction[i][E_FACTION_ID] == factionid || Faction_GetType(i) == factype) 
        {
            Faction_SendMessage(Faction[i][E_FACTION_ID], string, i, true, false, color, true);
        }
    }

    if (emergency == 4) AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Accepted a taxi call from %s", SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_LEGACY)));
    else AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Accepted a 911 call from %s", SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_LEGACY)));
    SendClientMessage(targetid, color, sprintf("[%s] Your call has been accepted by %s.", Faction[faction_enum_id][E_FACTION_ABBREV], SOLS_PlayerName(playerid)));

    PlayerVar[targetid][E_PLAYER_PHONE_EMERGENCY] = 0;

    new Float: x, Float: y, Float: z;
    GetPlayerPos(targetid, x, y, z);
    
    if (GetPlayerVirtualWorld(targetid) > 0)
    {
        // They are probably in a property, so use the exterior of that if they are
        new property = Property_GetInside(targetid);
        if (property != INVALID_PROPERTY_ID)
        {
            x = Property[property][E_PROPERTY_EXT_X]; 
            y = Property[property][E_PROPERTY_EXT_Y]; 
            z = Property[property][E_PROPERTY_EXT_Z];
        }
    }

    DisablePlayerCheckpoint(playerid);
    GPS_MarkLocation(playerid, "The call location has been ~b~marked~w~!", E_GPS_COLOR_SCRIPT, x, y, z);

    return true;
}

CMD:acc(playerid, params[])
{
    return cmd_acceptcall(playerid, params);
}