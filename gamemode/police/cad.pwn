//------------------------------------------------------------------------------
// Simple Computer Aided Dispatch style unit organization for PD - WIP!!!
// Written by Sporky (www.github.com/sporkyspork) for SOLS

#include <YSI_Coding\y_hooks>

#define MAX_CAD_UNITS 55
#define MAX_PLAYERS_PER_UNIT 2

enum E_CAD_PLAYER_VARS
{
    E_CAD_PLAYER_UNIT,
    bool:E_CAD_PLAYER_HUD,
    bool:E_CAD_PLAYER_HINT,
    bool:E_CAD_PLAYER_AIR_LABELS,
}

new CADPlayer [ MAX_PLAYERS ] [ E_CAD_PLAYER_VARS ] ;


// 1, 13, 17, 26, 32, 43, 57, 74, 89
// 40, 30, 20, 10

/*
static Divisions[][] = 
{
    "Patrol",
    "Traffic",
    "CRASH",
    "Metro",
    "Air"
}
*/

#define MAX_CAD_UNIT_TYPES 28

static enum CAD_DIVISION_TYPES
{
    CAD_DIVISION_NONE = 0,
    CAD_DIVISION_PATROL,
    CAD_DIVISION_MOTOR,
    CAD_DIVISION_TRAFFIC,
    CAD_DIVISION_AIR,
    CAD_DIVISION_SWAT,
    CAD_DIVISION_CRASH,
    CAD_DIVISION_DET,
    CAD_DIVISION_SD,
    CAD_DIVISION_SD_PATROL,
    CAD_DIVISION_SD_AIR,
    CAD_DIVISION_FD,
    CAD_DIVISION_FD_FIRE,
    CAD_DIVISION_FD_EMS,
    CAD_DIVISION_FD_AIR
}

enum E_CAD_UNIT_TYPE_VARS
{
    E_CAD_UNIT_TYPE_NAME[16],
    E_CAD_UNIT_TYPE_LETTER[5],
    CAD_DIVISION_TYPES:E_CAD_UNIT_TYPE_DIVISION,
    E_CAD_UNIT_TYPE_NUM_PLAYERS
}

static enum CAD_UNIT_TYPES
{
    CAD_UNIT_TYPE_NONE = 0,
    CAD_UNIT_TYPE_ADAM,
    CAD_UNIT_TYPE_LINCOLN,
    CAD_UNIT_TYPE_MARY,
    CAD_UNIT_TYPE_EDWARD,
    CAD_UNIT_TYPE_DAVID,
    CAD_UNIT_TYPE_AIR,
    CAD_UNIT_TYPE_CRASH,
    CAD_UNIT_TYPE_DET,
    CAD_UNIT_TYPE_SD_CHARLIE,
    CAD_UNIT_TYPE_SD_LINCOLN,
    CAD_UNIT_TYPE_SD_SAM,
    CAD_UNIT_TYPE_SD_KING,
    CAD_UNIT_TYPE_SD_ADAM,
    CAD_UNIT_TYPE_SD_AIR,
    CAD_UNIT_TYPE_SD_EDWARD,
    CAD_UNIT_TYPE_SD_GEORGE,
    CAD_UNIT_TYPE_FD_ENGINE,
    CAD_UNIT_TYPE_FD_TRUCK,
    CAD_UNIT_TYPE_FD_RESCUE,
    CAD_UNIT_TYPE_FD_BATTALION,
    CAD_UNIT_TYPE_FD_COMMAND,
    CAD_UNIT_TYPE_FD_USAR,
    CAD_UNIT_TYPE_FD_AIR,
    CAD_UNIT_TYPE_FD_ARSON,
    CAD_UNIT_TYPE_FD_EMS,
    CAD_UNIT_TYPE_FD_SQUAD,
    CAD_UNIT_TYPE_FD_PIO
} 

static const CADUnitTypes[MAX_CAD_UNIT_TYPES][E_CAD_UNIT_TYPE_VARS] = 
{
    {"NONE", "N", CAD_DIVISION_NONE, 0}, //CAD_UNIT_TYPE_NONE
    {"ADAM", "A", CAD_DIVISION_PATROL, 2}, //CAD_UNIT_TYPE_ADAM
    {"LINCOLN", "L", CAD_DIVISION_PATROL, 1}, //CAD_UNIT_TYPE_LINCOLN
    {"MARY", "M", CAD_DIVISION_MOTOR, 1}, //CAD_UNIT_TYPE_MARY
    {"EDWARD", "E", CAD_DIVISION_TRAFFIC, 2}, //CAD_UNIT_TYPE_EDWARD
    {"DAVID", "D", CAD_DIVISION_SWAT, 4}, //CAD_UNIT_TYPE_SWAT
    {"AIR", "H", CAD_DIVISION_AIR, 4}, //CAD_UNIT_TYPE_AIR
    {"CRASH", "C", CAD_DIVISION_CRASH, 2}, //CAD_UNIT_TYPE_CRASH
    {"WILLIAM", "W", CAD_DIVISION_DET, 2}, //CAD_UNIT_TYPE_DET

    {"CHARLIE", "C", CAD_DIVISION_SD, 2}, //CAD_UNIT_TYPE_SD_CHARLIE
    {"LINCOLN", "L", CAD_DIVISION_SD, 2}, //CAD_UNIT_TYPE_SD_LINCOLN
    {"SAM", "S", CAD_DIVISION_SD, 2}, //CAD_UNIT_TYPE_SD_SAM
    {"KING", "K", CAD_DIVISION_SD_PATROL, 1}, //CAD_UNIT_TYPE_SD_KING
    {"ADAM", "A", CAD_DIVISION_SD_PATROL, 2}, //CAD_UNIT_TYPE_SD_ADAM
    {"AERO", "H", CAD_DIVISION_SD_AIR, 4}, //CAD_UNIT_TYPE_AIR
    {"EDWARD", "E", CAD_DIVISION_SD, 2}, //CAD_UNIT_TYPE_SD_EDWARD
    {"GEORGE", "G", CAD_DIVISION_SD, 2}, //CAD_UNIT_TYPE_SD_GEORGE

    {"ENGINE", "E", CAD_DIVISION_FD_FIRE, 2}, // CAD_UNIT_TYPE_FD_ENGINE
    {"TRUCK", "T", CAD_DIVISION_FD_FIRE, 2},  // CAD_UNIT_TYPE_FD_TRUCK
    {"RESCUE", "RA", CAD_DIVISION_FD_EMS, 4}, // CAD_UNIT_TYPE_FD_RESCUE
    {"BATTALION", "BC", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_BATTALION
    {"COMMAND", "CM", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_COMMAND
    {"USAR", "UR", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_USAR
    {"FIRE", "H", CAD_DIVISION_FD_AIR, 4}, // CAD_UNIT_TYPE_FD_AIR
    {"ARSON", "AR", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_ARSON
    {"EMS-OFFICER", "EM", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_EMS
    {"SQUAD", "SQ", CAD_DIVISION_FD, 2}, // CAD_UNIT_TYPE_FD_SQUAD
    {"PIO", "PI", CAD_DIVISION_FD, 2} // CAD_UNIT_TYPE_FD_PIO
};

enum E_CAD_UNIT_VARS
{
    E_CAD_UNIT_FACTION,
    E_CAD_UNIT_NUMBER,
    E_CAD_UNIT_TIER,
    CAD_DIVISION_TYPES:E_CAD_UNIT_DIVISION,
    CAD_UNIT_TYPES:E_CAD_UNIT_TYPE,
    E_CAD_UNIT_SQUAD,
    E_CAD_UNIT_VEHICLE,
    CAD_UNIT_STATUS:E_CAD_UNIT_STATUS,
    E_CAD_UNIT_CUSTOM_STATUS[16],
    E_CAD_UNIT_PLAYERS[MAX_PLAYERS_PER_UNIT],
    E_CAD_UNIT_PLAYER_NAMES[(MAX_PLAYER_NAME + 3) * MAX_PLAYERS_PER_UNIT],
    E_CAD_UNIT_CUSTOM_CALLSIGN[16],
    DynamicText3D:E_CAD_UNIT_LABEL[MAX_PLAYERS]
}

#define FACTION_PD 10
#define FACTION_SD 16
#define FACTION_FD 25

static const CADUnitTemplate[MAX_CAD_UNITS][E_CAD_UNIT_VARS] = 
{
    {0, 0, 0, CAD_DIVISION_NONE, CAD_UNIT_TYPE_NONE}, // dummy

    // PD Units
    {FACTION_PD, 10, 1, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_LINCOLN},
    {FACTION_PD, 20, 2, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_LINCOLN},
    {FACTION_PD, 30, 2, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_LINCOLN},
    {FACTION_PD, 1, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 13, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 17, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 26, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 32, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 43, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},
    {FACTION_PD, 57, 3, CAD_DIVISION_PATROL, CAD_UNIT_TYPE_ADAM},

    {FACTION_PD, 10, 2, CAD_DIVISION_TRAFFIC, CAD_UNIT_TYPE_EDWARD},
    {FACTION_PD, 2, 3, CAD_DIVISION_TRAFFIC, CAD_UNIT_TYPE_EDWARD},
    {FACTION_PD, 15, 3, CAD_DIVISION_TRAFFIC, CAD_UNIT_TYPE_EDWARD},
    {FACTION_PD, 27, 3, CAD_DIVISION_MOTOR, CAD_UNIT_TYPE_MARY},
    {FACTION_PD, 34, 3, CAD_DIVISION_MOTOR, CAD_UNIT_TYPE_MARY},

    {FACTION_PD, 10, 3, CAD_DIVISION_SWAT, CAD_UNIT_TYPE_DAVID, FACTION_SQUAD_SWAT},
    {FACTION_PD, 20, 3, CAD_DIVISION_SWAT, CAD_UNIT_TYPE_DAVID, FACTION_SQUAD_SWAT},

    {FACTION_PD, 10, 2, CAD_DIVISION_DET, CAD_UNIT_TYPE_DET, FACTION_SQUAD_CRASH},
    {FACTION_PD, 55, 3, CAD_DIVISION_DET, CAD_UNIT_TYPE_DET, FACTION_SQUAD_CRASH},
    {FACTION_PD, 74, 3, CAD_DIVISION_DET, CAD_UNIT_TYPE_DET, FACTION_SQUAD_CRASH},

    {FACTION_PD, 1, 3, CAD_DIVISION_AIR, CAD_UNIT_TYPE_AIR},


    // SD Units
    {FACTION_SD, 20, 2, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_LINCOLN},
    {FACTION_SD, 20, 2, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_SAM},
    {FACTION_SD, 21, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 22, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 23, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 24, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 25, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 21, 3, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_EDWARD},
    {FACTION_SD, 22, 3, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_EDWARD},
    {FACTION_SD, 260, 2, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_LINCOLN},
    {FACTION_SD, 260, 2, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_SAM},
    {FACTION_SD, 261, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 262, 3, CAD_DIVISION_SD_PATROL, CAD_UNIT_TYPE_SD_ADAM},
    {FACTION_SD, 261, 3, CAD_DIVISION_SD, CAD_UNIT_TYPE_SD_EDWARD},
    {FACTION_SD, 7, 3, CAD_DIVISION_SD_AIR, CAD_UNIT_TYPE_SD_AIR},

    // FD Units
    {FACTION_FD, 1, 2, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_COMMAND},          // COMMAND 1
    {FACTION_FD, 2, 2, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_COMMAND},          //    
    {FACTION_FD, 1, 2, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_BATTALION},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD_FIRE, CAD_UNIT_TYPE_FD_ENGINE},
    {FACTION_FD, 202, 3, CAD_DIVISION_FD_FIRE, CAD_UNIT_TYPE_FD_ENGINE},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD_FIRE, CAD_UNIT_TYPE_FD_TRUCK},
    {FACTION_FD, 202, 3, CAD_DIVISION_FD_FIRE, CAD_UNIT_TYPE_FD_TRUCK},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD_EMS, CAD_UNIT_TYPE_FD_RESCUE},
    {FACTION_FD, 202, 3, CAD_DIVISION_FD_EMS, CAD_UNIT_TYPE_FD_RESCUE},
    {FACTION_FD, 802, 3, CAD_DIVISION_FD_EMS, CAD_UNIT_TYPE_FD_RESCUE},
    {FACTION_FD, 902, 3, CAD_DIVISION_FD_EMS, CAD_UNIT_TYPE_FD_RESCUE},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_EMS},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_USAR},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_SQUAD},
    {FACTION_FD, 1, 3, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_ARSON},
    {FACTION_FD, 1, 3, CAD_DIVISION_FD, CAD_UNIT_TYPE_FD_PIO},
    {FACTION_FD, 1, 3, CAD_DIVISION_FD_AIR, CAD_UNIT_TYPE_FD_AIR},
    {FACTION_FD, 2, 3, CAD_DIVISION_FD_AIR, CAD_UNIT_TYPE_FD_AIR}
};


static CADUnit[MAX_CAD_UNITS][E_CAD_UNIT_VARS];

static bool:IsPlayerInCADFaction(playerid, bool:onduty=false)
{
    if (onduty && !PlayerVar[playerid][E_PLAYER_FACTION_DUTY]) return false;

    new fid = Character[playerid][E_CHARACTER_FACTIONID];
    return fid == FACTION_FD || fid == FACTION_PD || fid == FACTION_SD;
}

static LoadCADUnits(factionid = 0)
{
    for (new i = 0; i < MAX_PLAYERS; i ++)
	{
		if (!IsPlayerConnected(i)) continue;
        if (factionid && Character[i][E_CHARACTER_FACTIONID] != factionid) continue;
		ClearVars(i);
	}

    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        if (factionid && CADUnit[i][E_CAD_UNIT_FACTION] != factionid) continue;
        CADUnit[i] = CADUnitTemplate[i];
    }
}

static ResetCADUnit(unit)
{
    SendCADMessage(sprintf("%s was disbanded by The System.", PrintCADUnitCallsign(unit)), CADUnit[unit][E_CAD_UNIT_FACTION]);
    
    for (new targetid = 0; targetid < MAX_PLAYERS; targetid ++)
    {
        if (IsValidDynamic3DTextLabel(CADUnit[unit][E_CAD_UNIT_LABEL][targetid]))
        {
            DestroyDynamic3DTextLabel(CADUnit[unit][E_CAD_UNIT_LABEL][targetid]);
        }

        CADUnit[unit][E_CAD_UNIT_LABEL][targetid] = DynamicText3D:INVALID_STREAMER_ID;
    }
    
    CADUnit[unit] = CADUnitTemplate[unit];

    for (new i = 0; i < MAX_PLAYERS; i ++)
	{
		if (!IsPlayerConnected(i)) continue;
        if (CADPlayer[i][E_CAD_PLAYER_UNIT] == unit)
        {
            CADPlayer[i][E_CAD_PLAYER_UNIT] = 0;
        }
	}
}

// Not really used atm
enum CAD_UNIT_STATUS
{
    CAD_UNIT_STATUS_NONE,
    CAD_UNIT_STATUS_DEFAULT,
    CAD_UNIT_STATUS_CUSTOM
}

static ClearVars(playerid)
{
 	new cvar_clear[E_CAD_PLAYER_VARS];
	CADPlayer[playerid] = cvar_clear;
}

static CadDlgStr[2048];
static CadStr[144];

#define COLOR_CAD 0xAEEA00FF

static SendCADMessage(msg[], factionid = 0)
{
    format(CadStr, sizeof(CadStr), "[CAD] %s", msg);
    for (new i = 0; i < MAX_PLAYERS; i ++)
	{
		if (!IsPlayerConnected(i)) continue;
        if (!IsPlayerInFaction(i, factionid, true)) continue;

        SendClientMessage(i, COLOR_CAD, CadStr);
	}
}

hook OnPlayerConnect(playerid)
{
    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        if (IsValidDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]))
        {
            DestroyDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]);
        }

        CADUnit[i][E_CAD_UNIT_LABEL][playerid] = DynamicText3D:INVALID_STREAMER_ID;
    }

	ClearVars(playerid);
    return 1;
}

//hook OnPlayerDisconnect(playerid, reason)
hook SOLS_OnCloseConnection(playerid, reason)
{
	new unit = GetPlayerCADUnit(playerid);

    if (unit)
    {
        SetPlayerCADUnit(playerid, 0, false);
    }

    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        if (IsValidDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]))
        {
            DestroyDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]);
        }

        CADUnit[i][E_CAD_UNIT_LABEL][playerid] = DynamicText3D:INVALID_STREAMER_ID;
    }

    return 1;
}

hook SOLS_OnDutyStateChange(playerid)
{
    if (IsPlayerInCADFaction(playerid))
    {
        new unit = GetPlayerCADUnit(playerid);
        if (unit)
        {
            SetPlayerCADUnit(playerid, 0, false);
        }
    }

    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if (IsPlayerInCADFaction(playerid, true))
        {
            PrintCadReminders(playerid);
        }

        if (!CADPlayer[playerid][E_CAD_PLAYER_AIR_LABELS] && (IsPlayerInCADFaction(playerid, true) || PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if (vehicleid && IsAircraft(vehicleid))
            {
                CADPlayer[playerid][E_CAD_PLAYER_AIR_LABELS] = true;
                UpdatePlayerCarsigns(playerid);
            }
        }
    }
    else
    {
        if (CADPlayer[playerid][E_CAD_PLAYER_AIR_LABELS])
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if (!vehicleid || !IsAircraft(vehicleid))
            {
                CADPlayer[playerid][E_CAD_PLAYER_AIR_LABELS] = false;
                UpdatePlayerCarsigns(playerid);
            }
        }
    }

    

    return 1;
}

task CAD_AutoReminders[300000]()
{
    for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if (IsPlayerConnected(i) && IsPlayerInPoliceFaction(i))
        {
            PrintCadReminders(i);
        }
    }
}

PrintCadReminders(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if (IsFactionVehicle(vehicleid, Character[playerid][E_CHARACTER_FACTIONID]))
    {
        new unit = GetPlayerCADUnit(playerid);

        if (!PlayerVar[playerid][E_PLAYER_FACTION_DUTY])
        {
            SendClientMessage(playerid, 0xFFFF00AA, "[CAD] You must be on duty to operate the CAD.");
        }
        else if (unit && GetCADUnitVehicle(unit) != vehicleid)
        {
            SendClientMessage(playerid, 0xFFFF00AA, "[CAD] This vehicle isn't assigned to you on the CAD. You can use \"/cad update\" to assign it.");
        }
        else if (!unit)
        {
            SendClientMessage(playerid, 0xFFFF00AA, "[CAD] You haven't set your callsign or vehicle on the CAD. Use \"/cad units\" to do this.");
        }
    }
}

hook OnGameModeInit()
{
    LoadCADUnits();

    for (new i = 0; i < MAX_PLAYERS; i ++)
	{
		if (!IsPlayerConnected(i)) continue;
		ClearVars(i);
	}

    return 1;
}

static PrintCADUnitCallsign(unit, bool:short=false)
{
    new callsign[16];

    if (CADUnit[unit][E_CAD_UNIT_CUSTOM_CALLSIGN] && strlen(CADUnit[unit][E_CAD_UNIT_CUSTOM_CALLSIGN]))
    {
        format(callsign, 16, "%s", CADUnit[unit][E_CAD_UNIT_CUSTOM_CALLSIGN]);
        return callsign;
    }

    if (CADUnit[unit][E_CAD_UNIT_FACTION] == FACTION_PD)
    {
        switch (CADUnit[unit][E_CAD_UNIT_TYPE])
        {
            case CAD_UNIT_TYPE_EDWARD, CAD_UNIT_TYPE_MARY:
            {
                // Override for PD Traffic
                if (!short) format(callsign, sizeof(callsign), "%d-%s-%d", 24, CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);
                else format(callsign, sizeof(callsign), "%d%s%d", 24, CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_LETTER], CADUnit[unit][E_CAD_UNIT_NUMBER]);
            }
            case CAD_UNIT_TYPE_AIR:
            {
                // Override for air
                if (!short) format(callsign, sizeof(callsign), "%s-%d", CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);
                else format(callsign, sizeof(callsign), "%s%d", CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);   
            }
            case CAD_UNIT_TYPE_DAVID:
            {
                // Override for swat
                if (!short) format(callsign, sizeof(callsign), "%s-%d-%s", "R", CADUnit[unit][E_CAD_UNIT_NUMBER], CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME]);
                else format(callsign, sizeof(callsign), "%s%d%s", "R", CADUnit[unit][E_CAD_UNIT_NUMBER], CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_LETTER]);
            }
            case CAD_UNIT_TYPE_CRASH:
            {
                // Override for crash
                if (!short) format(callsign, sizeof(callsign), "%d-%s-%d", 1, CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);
                else format(callsign, sizeof(callsign), "%s%d", CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);   
            }
            default:
            {
                if (!short) format(callsign, sizeof(callsign), "%d-%s-%d", 1, CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);
                else format(callsign, sizeof(callsign), "%d%s%d", 1, CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_LETTER], CADUnit[unit][E_CAD_UNIT_NUMBER]);
            }
        }
    }
    else if (CADUnit[unit][E_CAD_UNIT_FACTION] == FACTION_SD)
    {
        switch (CADUnit[unit][E_CAD_UNIT_TYPE])
        {
            case CAD_UNIT_TYPE_SD_AIR:
            {
                // Override for air
                format(callsign, sizeof(callsign), "%d-%s", CADUnit[unit][E_CAD_UNIT_NUMBER], CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME]);
            }
            default:
            {
                if (!short) format(callsign, sizeof(callsign), "%d-%s", CADUnit[unit][E_CAD_UNIT_NUMBER], CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME]);
                else format(callsign, sizeof(callsign), "%d%s", CADUnit[unit][E_CAD_UNIT_NUMBER], CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_LETTER]);
            }
        }
    }
    else if (CADUnit[unit][E_CAD_UNIT_FACTION] == FACTION_FD)
    {
        switch (CADUnit[unit][E_CAD_UNIT_TYPE])
        {
            default:
            {
                if (!short) format(callsign, sizeof(callsign), "%s-%d", CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_NAME], CADUnit[unit][E_CAD_UNIT_NUMBER]);
                else format(callsign, sizeof(callsign), "%s%d", CADUnitTypes[_:CADUnit[unit][E_CAD_UNIT_TYPE]][E_CAD_UNIT_TYPE_LETTER], CADUnit[unit][E_CAD_UNIT_NUMBER]);
            }
        }
    }

    /*
    new count = GetCADUnitMemberCount(unit);
    format(callsign, sizeof(callsign), "%d-%s-%d", 1, GetCADUnitTypeName(utype), CADUnit[unit][E_CAD_UNIT_NUMBER]);

    for (new i = 0; i < sizeof(CADUnitTypes); i ++)
    {
        if (CADUnitTypes[i][E_CAD_UNIT_TYPE_DIVISION] == CADUnit[unit][E_CAD_UNIT_DIVISION] && count == CADUnitTypes[i][E_CAD_UNIT_TYPE_NUM_PLAYERS])
        {
            format(callsign, sizeof(callsign), "%d-%s-%d", 1, GetCADUnitTypeName(i), CADUnit[unit][E_CAD_UNIT_NUMBER]);
            break;
        }
    }
    */

    return callsign;
}

static GetCADUnitMemberCount(unit)
{
    new count = 0;

    for (new i = 0; i < MAX_PLAYERS; i ++)
    {
        if (!IsPlayerConnected(i)) continue;

        if (GetPlayerCADUnit(i) == unit)
        {
            count ++;
        }
    }

    return count;
}

CAD_GetPlayerUnit(playerid)
{
    return GetPlayerCADUnit(playerid);
}

CAD_PrintPlayerUnit(playerid, bool:short=false)
{
    // return PrintCADUnitCallsign(GetPlayerCADUnit(playerid));

    new callsign[16], unit = GetPlayerCADUnit(playerid);
    format(callsign, sizeof(callsign), "%s", PrintCADUnitCallsign(unit, short));
    return callsign;
}

static GetPlayerCADUnit(playerid)
{
    return CADPlayer[playerid][E_CAD_PLAYER_UNIT];
}

static SetPlayerCADUnit(playerid, unit, bool:notify=false)
{
    new oldunit = CADPlayer[playerid][E_CAD_PLAYER_UNIT];
    new count = 0;

    if (unit)
    { 
        count = GetCADUnitMemberCount(unit);
    }

    CADPlayer[playerid][E_CAD_PLAYER_UNIT] = unit;

    if (unit)
    {
        UpdateCADUnit(unit);
    }         

    if (notify)
    {
        if (unit)
        {
            if (count)
            {
                SendCADMessage(sprintf("%s (%d) joined %s", ReturnPlayerNameData(playerid, 0, true), playerid, PrintCADUnitCallsign(unit)), CADUnit[unit][E_CAD_UNIT_FACTION]);
            }
            else
            {
                SendCADMessage(sprintf("%s (%d) formed %s with a \"%s\" (VID: %d)", ReturnPlayerNameData(playerid, 0, true), playerid, PrintCADUnitCallsign(unit), ReturnVehicleName(GetCADUnitVehicle(unit)), GetCADUnitVehicle(unit)), CADUnit[unit][E_CAD_UNIT_FACTION]);
            }
        }
        else if (CADUnit[oldunit][E_CAD_UNIT_TYPE])
        {
            SendCADMessage(sprintf("%s (%d) left %s", ReturnPlayerNameData(playerid, 0, true), playerid, PrintCADUnitCallsign(oldunit)), CADUnit[oldunit][E_CAD_UNIT_FACTION]);
        }
    }

    if (!CADPlayer[playerid][E_CAD_PLAYER_HINT])
    {
        SendClientMessage(playerid, 0xFFFF00AA, "[CAD] Tip: you can now use \"/cad labels\" to toggle text labels on all CAD vehicles :]");
        CADPlayer[playerid][E_CAD_PLAYER_HINT] = true;
    }

    if (oldunit) UpdateCADUnit(oldunit);
}

static UpdateCADUnit(unit)
{
    new count = 0;

    for (new i = 0; i < MAX_PLAYERS_PER_UNIT; i ++)
    {
        CADUnit[unit][E_CAD_UNIT_PLAYERS][i] = INVALID_PLAYER_ID;
    }

    for (new i = 0; i < MAX_PLAYERS; i ++)
    {
        if (!IsPlayerConnected(i)) continue;

        if (GetPlayerCADUnit(i) == unit)
        {
            CADUnit[unit][E_CAD_UNIT_PLAYERS][count] = i;
            count ++;
        }
    }

    if (count == 0)
    {
        // Needs disbanded
        ResetCADUnit(unit);
        return true;
    }

    CADUnit[unit][E_CAD_UNIT_PLAYER_NAMES][0] = EOS;
    new temp_player;

    for (new i = 0; i < MAX_PLAYERS_PER_UNIT; i ++)
    {
        temp_player = CADUnit[unit][E_CAD_UNIT_PLAYERS][i];
        if (!IsPlayerConnected(temp_player)) continue;

        strcat(CADUnit[unit][E_CAD_UNIT_PLAYER_NAMES], ReturnPlayerNameData(temp_player, 0, true));
        
        if (i + 1 < count)
        {
            strcat(CADUnit[unit][E_CAD_UNIT_PLAYER_NAMES], ", ");
        }
    }

    new CAD_UNIT_TYPES:utype = CADUnit[unit][E_CAD_UNIT_TYPE];

    if (utype == CAD_UNIT_TYPE_SD_KING || utype == CAD_UNIT_TYPE_SD_ADAM || utype == CAD_UNIT_TYPE_LINCOLN || utype == CAD_UNIT_TYPE_ADAM)
    {
        for (new i = 0; i < sizeof(CADUnitTypes); i ++)
        {
            if (CADUnitTypes[i][E_CAD_UNIT_TYPE_DIVISION] == CADUnit[unit][E_CAD_UNIT_DIVISION] && count == CADUnitTypes[i][E_CAD_UNIT_TYPE_NUM_PLAYERS])
            {
                CADUnit[unit][E_CAD_UNIT_TYPE] = CAD_UNIT_TYPES:i;
                break;
            }
        }
    }

    UpdateUnitCarsign(unit);
    return true;
}

SetPlayerCADStatus(playerid, CAD_UNIT_STATUS:status, text[]=EOS, bool:notify=false)
{
    #pragma unused SetPlayerCADStatus
    new unit = GetPlayerCADUnit(playerid);
    if (unit) SetCADUnitStatus(unit, status, playerid, text, notify);
}

static SetCADUnitStatus(unit, CAD_UNIT_STATUS:status, playerid=INVALID_PLAYER_ID, customstatus[]=EOS, bool:notify=false)
{
    CADUnit[unit][E_CAD_UNIT_STATUS] = status;
    format(CADUnit[unit][E_CAD_UNIT_CUSTOM_STATUS], 16, "%s", customstatus);
    
    if (notify)
    {
        if (playerid != INVALID_PLAYER_ID)
        {
            SendCADMessage(sprintf("%s (%d) updated their status (%s) to: %s", ReturnPlayerNameData(playerid, 0, true), playerid, PrintCADUnitCallsign(unit), PrintCADUnitStatus(unit)), CADUnit[unit][E_CAD_UNIT_FACTION]);
        }
        else
        {
            SendCADMessage(sprintf("The System updated status of %s to: %s", PrintCADUnitCallsign(unit), PrintCADUnitStatus(unit)), CADUnit[unit][E_CAD_UNIT_FACTION]);
        }
    }
}

static SetCADUnitCallsign(unit, playerid=INVALID_PLAYER_ID, customstatus[]=EOS, bool:notify=false)
{
    if (notify)
    {
        if (playerid != INVALID_PLAYER_ID)
        {
            SendCADMessage(sprintf("%s (%d) changed their callsign to: %s", ReturnPlayerNameData(playerid, 0, true), playerid, customstatus), CADUnit[unit][E_CAD_UNIT_FACTION]);
        }
        else
        {
            SendCADMessage(sprintf("The System changed callsign of %s to: %s", PrintCADUnitCallsign(unit), customstatus), CADUnit[unit][E_CAD_UNIT_FACTION]);
        }
    }

    format(CADUnit[unit][E_CAD_UNIT_CUSTOM_CALLSIGN], 16, "%s", customstatus);
}


static SetCADUnitVehicle(unit, vehicle, bool:notify=false)
{
    CADUnit[unit][E_CAD_UNIT_VEHICLE] = vehicle;
    
    if (notify)
    {
        
    }
}

static GetCADUnitVehicle(unit)
{
    return CADUnit[unit][E_CAD_UNIT_VEHICLE];
}


static PrintCADUnitOfficers(unit)
{
    new officers[128] = "None";

    if (CADUnit[unit][E_CAD_UNIT_TYPE])
    {
        format(officers, sizeof(officers), "%s", CADUnit[unit][E_CAD_UNIT_PLAYER_NAMES]);
    }

    return officers;
}

static PrintCADUnitStatus(unit)
{
    new status[16] = "None";

    if (CADUnit[unit][E_CAD_UNIT_TYPE] && CADUnit[unit][E_CAD_UNIT_CUSTOM_STATUS])
    {
        format(status, sizeof(status), "%s", CADUnit[unit][E_CAD_UNIT_CUSTOM_STATUS]);
    }

    return status;
}

static PrintCADUnitVehicle(unit)
{
    new vehicle[128] = "None";
    new vehicleid = GetCADUnitVehicle(unit);
    new Float:x, Float:y, Float:z, zone[64];

    if (vehicleid)
    {
        GetVehiclePos(vehicleid, x, y, z);
        GetCoords2DZone(x, y, zone, sizeof(zone));
        format(vehicle, sizeof(vehicle), "%s (%d: %s)", ReturnVehicleName(vehicleid), vehicleid, zone);
    }

    return vehicle;
}

static ShowCADUnitsDlg(playerid)
{
    format(CadDlgStr, sizeof(CadDlgStr), "Unit\tStatus\tVehicle (ID: Location)\tMembers");
    new map[MAX_CAD_UNITS], index = 0;

    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        if (!CADUnit[i][E_CAD_UNIT_TYPE]) continue;
        if (CADUnit[i][E_CAD_UNIT_FACTION] != Character[playerid][E_CHARACTER_FACTIONID]) continue;

        if (GetCADUnitMemberCount(i))
        {
            strcat(CadDlgStr, sprintf("\n%s\t%s\t%s\t%s", PrintCADUnitCallsign(i), PrintCADUnitStatus(i), PrintCADUnitVehicle(i), PrintCADUnitOfficers(i)));
        }
        else
        {
            strcat(CadDlgStr, sprintf("\n{9E9E9E}%s\t{9E9E9E}%s\t{9E9E9E}%s\t{9E9E9E}%s", PrintCADUnitCallsign(i), "None", "None (N/A: None)", "None"));
        }

        map[index] = i;
        index ++;
    }

    inline DlgCadUnits(pid, dialogid, response, listitem, string:inputtext[]) 
    {
        #pragma unused pid, dialogid, inputtext, listitem
        
        if (response)
        {
            new unit = map[listitem];

            if (!CADUnit[unit][E_CAD_UNIT_TYPE]) 
                return ShowCADUnitsDlg(pid);

            new current = GetPlayerCADUnit(pid);

            if (unit != current)
            {
                CAD_PlayerJoinUnit(pid, unit);
            }
            else
            {
                CAD_PlayerLeaveUnit(pid);
            }
        }
    }


    Dialog_ShowCallback ( playerid, using inline DlgCadUnits, DIALOG_STYLE_TABLIST_HEADERS, "CAD Units", CadDlgStr, "Select", "Close" );

    return 1;
}

static CAD_PlayerJoinUnit(playerid, unit)
{
    if (!IsPlayerInCADFaction(playerid, true))
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be an on duty in a compatible faction to use the CAD.");

    new vehicleid = GetPlayerVehicleID(playerid);
    new unitveh = GetCADUnitVehicle(unit);
    new current = GetPlayerCADUnit(playerid);

    if (!vehicleid) return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in a vehicle to join a CAD unit.");
    if (current) return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must leave your current CAD unit first (\"/cad leave\")");

    if (!unit || unit >= MAX_CAD_UNITS || !CADUnit[unit][E_CAD_UNIT_TYPE])
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "Invalid CAD unit.");

    if (current == unit)
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "Use \"/cad leave\" instead.");
    }
    
    if (unitveh && unitveh != vehicleid)
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in the vehicle assigned to this unit to join it.");
    }

    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        if (!CADUnit[i][E_CAD_UNIT_TYPE] || i == unit) continue;
        if (GetCADUnitVehicle(i) == vehicleid)
        {
            return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", sprintf("This vehicle is already assigned to %s, you cannot form a new unit with it.", PrintCADUnitCallsign(i)));
        }
    }

    if (!unitveh && !IsFactionVehicle(vehicleid, Character[playerid][E_CHARACTER_FACTIONID]))
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in a faction vehicle to form a CAD unit.");
    }

    new count = GetCADUnitMemberCount(unit);

    if (count + 1 > MAX_PLAYERS_PER_UNIT)
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "This unit is full.");
    }

    if (!count && CADUnit[unit][E_CAD_UNIT_TIER] < Character[playerid][E_CHARACTER_FACTIONTIER])
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", sprintf("You must be Tier %d to form this unit by yourself.", CADUnit[unit][E_CAD_UNIT_TIER]));
    }

    if (!count && CADUnit[unit][E_CAD_UNIT_SQUAD] && Character[playerid][E_CHARACTER_FACTION_SQUAD] != CADUnit[unit][E_CAD_UNIT_SQUAD])
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You're not in the correct faction squad to form this unit." );
    }


    SetCADUnitVehicle(unit, vehicleid);
    SetPlayerCADUnit(playerid, unit, true);

    return true;
}

static CAD_PlayerLeaveUnit(playerid)
{
    new current = GetPlayerCADUnit(playerid);

    if (!current) return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You are not in a CAD unit.");
    SetPlayerCADUnit(playerid, 0, true);

    return true;
}

CMD:setcadstatus(playerid, params[])
{
    if (!IsPlayerInCADFaction(playerid, true))
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be an on duty in a compatible faction to use the CAD.");

    new giveplayerid, status[128];

    if (sscanf(params, "k<player>s[128]", giveplayerid, status) || !strlen(status) || !IsPlayerConnected(giveplayerid))
	    return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/setcadstatus [player] [status]");

    if ( Character [ giveplayerid ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

    new current = GetPlayerCADUnit(giveplayerid);
    if (!current || !CADUnit[current][E_CAD_UNIT_TYPE])
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "The player must be assigned to a CAD unit to do this.");
    }

    SetCADUnitStatus(current, CAD_UNIT_STATUS_CUSTOM, INVALID_PLAYER_ID, status, true);
    return true;
}

CMD:cad(playerid, params[])
{
    new action[8], option[128];
	sscanf(params, "s[8] S(none)[128]", action, option);

    if (strlen(action))
    {
        // Secretly, this is a public command
        if (!strcmp(action, "labels", true))
        {
            if (strlen(option))
            {
                if (!strcmp(option, "off", true))
                {
                    SendClientMessage(playerid, 0xFFFF00AA, "[CAD] Labels disabled: you will no longer see CAD vehicle text labels.");
                    PlayerVar[playerid][E_PLAYER_CAD_LABELS] = 0;
                    UpdatePlayerCarsigns(playerid);
                    return true;
                }
                else if (!strcmp(option, "short", true))
                {
                    SendClientMessage(playerid, 0xFFFF00AA, "[CAD] Labels updated: now showing short-form text labels on all CAD vehicles.");
                    PlayerVar[playerid][E_PLAYER_CAD_LABELS] = 1;
                    UpdatePlayerCarsigns(playerid);
                    return true;
                }
                else if (!strcmp(option, "long", true))
                {
                    SendClientMessage(playerid, 0xFFFF00AA, "[CAD] Labels updated: now showing long-form text labels on all CAD vehicles.");
                    PlayerVar[playerid][E_PLAYER_CAD_LABELS] = 2;
                    UpdatePlayerCarsigns(playerid);
                    return true;
                }
            }

            return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/cad [labels] [off/short/long]");
        }

        // The rest are restricted
        if (!IsPlayerInCADFaction(playerid))
        {
            return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in a compatible faction to use this CAD feature.");
        }

        if (!strcmp(action, "leave", true))
        {
            CAD_PlayerLeaveUnit(playerid);
            return true;
        }
        else if (!strcmp(action, "status", true))
        {
            if (strlen(option) < 3 || strlen(option) > 16 || !strcmp(option, "none"))
            {
                return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/cad [status] [text] (3-16 characters)");
            }

            new current = GetPlayerCADUnit(playerid);

            if (!current || !CADUnit[current][E_CAD_UNIT_TYPE])
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be assigned to a CAD unit to do this.");
            }

            new vehicleid = GetPlayerVehicleID(playerid);
            if (!vehicleid || vehicleid != GetCADUnitVehicle(current))
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in the vehicle assigned to your unit.");
            }

            SetCADUnitStatus(current, CAD_UNIT_STATUS_CUSTOM, playerid, option, true);
            return true;
        }
        else if (!strcmp(action, "callsign", true))
        {
            if (strlen(option) < 3 || strlen(option) > 16 || !strcmp(option, "none"))
            {
                return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/cad [callsign] [text] (3-16 characters)");
            }

            new current = GetPlayerCADUnit(playerid);

            if (!current || !CADUnit[current][E_CAD_UNIT_TYPE])
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be assigned to a CAD unit to do this.");
            }

            new vehicleid = GetPlayerVehicleID(playerid);
            if (!vehicleid || vehicleid != GetCADUnitVehicle(current))
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in the vehicle assigned to your unit.");
            }

            SetCADUnitCallsign(current, playerid, option, true);
            return true;
        }
        else if (!strcmp(action, "update", true))
        {
            new current = GetPlayerCADUnit(playerid);
            if (!current || !CADUnit[current][E_CAD_UNIT_TYPE])
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be assigned to a CAD unit to do this.");
            }

            new vehicleid = GetPlayerVehicleID(playerid);
            if (!vehicleid)
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in a vehicle to update your CAD unit.");
            }

            new currentveh = GetCADUnitVehicle(current);
            inline DlgCadUpdate(pid, dialogid, response, listitem, string:inputtext[]) 
            {
                #pragma unused pid, dialogid, inputtext, listitem
                
                if (response)
                {
                    vehicleid = GetPlayerVehicleID(pid);
                    if (vehicleid)
                    {
                        SetCADUnitVehicle(current, vehicleid, true);
                        UpdateCADUnit(current);
                        SendCADMessage(sprintf("%s (%d) updated the assigned vehicle of %s to a \"%s\" (VID: %d)", ReturnPlayerNameData(pid, 0, true), pid, PrintCADUnitCallsign(current), ReturnVehicleName(vehicleid), vehicleid), Character[playerid][E_CHARACTER_FACTIONID]);
                    }
                }
            }

            format(CadDlgStr, sizeof(CadDlgStr), "You're about to update the assigned vehicle of %s to a \"%s\" (VID: %d)\nOnly do this if you can no longer access the currently assigned vehicle (VID: %d).", PrintCADUnitCallsign(current), ReturnVehicleName(vehicleid), vehicleid, currentveh);

            Dialog_ShowCallback ( playerid, using inline DlgCadUpdate, DIALOG_STYLE_MSGBOX, "Update CAD Vehicle", CadDlgStr, "OK", "Back" );
            return true;
        }
        else if (!strcmp(action, "reload", true))
        {
            return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "Temporarily disabled due to bugs.");

            if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2)
            {
                return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be Tier 2 to reload the CAD.");
            } 

            inline DlgCadReload(pid, dialogid, response, listitem, string:inputtext[]) 
            {
                #pragma unused pid, dialogid, inputtext, listitem
                
                if (response)
                {
                    LoadCADUnits(Character[playerid][E_CHARACTER_FACTIONID]);
                    SendCADMessage(sprintf("%s (%d) reloaded the CAD system - all units were reset.", ReturnPlayerNameData(pid, 0, true), pid), Character[playerid][E_CHARACTER_FACTIONID]);
                    UpdateAllCarsigns();
                }
            }

            format(CadDlgStr, sizeof(CadDlgStr), "You're about to reload and reset the CAD system\nAll units for your faction will be reset to default.");
            Dialog_ShowCallback ( playerid, using inline DlgCadReload, DIALOG_STYLE_MSGBOX, "Reboot CAD", CadDlgStr, "OK", "Back" );
            return true;
        }
        else if (!strcmp(action, "units", true) || !strcmp(action, "view", true))
        {
            ShowCADUnitsDlg(playerid);
            return true;
        }
        else if (!strcmp(action, "hud", true))
        {
            ToggleCADHud(playerid);
            return true;
        }
    }

    return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/cad [units/leave/status/update/labels/reload/hud]");
}

CMD:units(playerid, params[])
{
    if (!IsPlayerInCADFaction(playerid))
        return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You must be in a compatible faction to use the CAD.");

    ShowCADUnitsDlg(playerid);
    return true;
}

ToggleCADHud(playerid)
{
    SendClientMessage(playerid, COLOR_INFO, "Coming soon.");
    // CallRemoteFunction("OnCadHudToggled", "d", playerid);
    return true;
}

UpdatePlayerCarsign(playerid, i)
{
    new Float:sX, Float:sY, Float:sZ, text[16];
    new vehid = GetCADUnitVehicle(i);
        
    if (vehid)
    {
        GetVehicleModelInfo(GetVehicleModel(vehid), VEHICLE_MODEL_INFO_SIZE, sX, sY, sZ);
        
        if (PlayerVar[playerid][E_PLAYER_CAD_LABELS] == 1) format(text, sizeof(text), "%s", PrintCADUnitCallsign(i, true));
        else if (PlayerVar[playerid][E_PLAYER_CAD_LABELS] == 2) format(text, sizeof(text), "%s", PrintCADUnitCallsign(i));
    }
    
    if (IsValidDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]))
    {
        DestroyDynamic3DTextLabel(CADUnit[i][E_CAD_UNIT_LABEL][playerid]);
    }

    if (CADUnit[i][E_CAD_UNIT_TYPE] && vehid && PlayerVar[playerid][E_PLAYER_CAD_LABELS])
    {   
        new color = 0xDDDFDCFF;
        if (CADUnit[i][E_CAD_UNIT_FACTION] == FACTION_PD) color = 0xBDBDDEFF;
        else if (CADUnit[i][E_CAD_UNIT_FACTION] == FACTION_FD) color = 0xDEBDC2FF;
        else if (CADUnit[i][E_CAD_UNIT_FACTION] == FACTION_SD) color = 0xDED9BDFF;

        
        if (CADPlayer[playerid][E_CAD_PLAYER_AIR_LABELS])
        {
            CADUnit[i][E_CAD_UNIT_LABEL][playerid] = CreateDynamic3DTextLabel(text, color, 0.0, (-sY + 1.6) / 2.0, -0.2, 300.0, INVALID_PLAYER_ID, vehid, 1, -1, -1, playerid, -1);
        }
        else
        {
            CADUnit[i][E_CAD_UNIT_LABEL][playerid] = CreateDynamic3DTextLabel(text, color, 0.0, (-sY + 1.6) / 2.0, -0.2, 25.0, INVALID_PLAYER_ID, vehid, 1, -1, -1, playerid, 25);
        }
    }
    else
    {
        CADUnit[i][E_CAD_UNIT_LABEL][playerid] = DynamicText3D:INVALID_STREAMER_ID;
    }

    if (GetPlayerVehicleID(playerid) == vehid)
    {
        Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
    }   
}

UpdatePlayerCarsigns(playerid)
{
    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        UpdatePlayerCarsign(playerid, i);
    }
}

UpdateUnitCarsign(i)
{
    for (new targetid = 0; targetid < MAX_PLAYERS; targetid ++)
    {
        UpdatePlayerCarsign(targetid, i);
    }
}

UpdateAllCarsigns()
{
    for (new i = 0; i < MAX_CAD_UNITS; i ++)
    {
        UpdateUnitCarsign(i);
    }
}

CMD:resetcadlabels(playerid)
{
    if (IsPlayerAdmin(playerid))
    {
        UpdateAllCarsigns();
        return 1;
    }

    return 0;
}
