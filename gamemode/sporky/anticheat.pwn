//------------------------------------------------------------------------------
// Temporary basic cheating mitigations
// Written by Sporky (www.github.com/sporkyspork) for Singleplayer RP (www.stretzofls.com)

#include <YSI_Coding\y_hooks>
#define AC_MAX_VEH_ENTER_TIME  1

// NEW WIP Anticheat Stuff

enum AC_DETECTION_TYPE
{
    AC_DETECTION_PLY_ARMOR = 1,
    AC_DETECTION_PLY_JETPACK,
    AC_DETECTION_PLY_WARP,
    AC_DETECTION_VEH_JACK,
    AC_DETECTION_VEH_WARP,
    AC_DETECTION_VEH_REPAIR,
    AC_DETECTION_WEP_UNVERIFIED,
    AC_DETECTION_WEP_AMMO,
    AC_DETECTION_WEP_SPOOFED,
    AC_DETECTION_MISC_STRING,
    AC_DETECTION_MISC_PM,
    AC_DETECTION_MISC_SPEC
}

static enum E_AC_DETECTION_DATA
{
    AC_DETECTION_TYPE:E_AC_DETECTION_TYPE_ID,
    E_AC_DETECTION_NAME[64],
    E_AC_DETECTION_COOLDOWN
}

static const AntiCheatDetections[][E_AC_DETECTION_DATA] = 
{
    { AC_DETECTION_PLY_ARMOR, "Armour Cheats", 60 },
    { AC_DETECTION_PLY_JETPACK, "Jetpack Cheat", 60 },
    { AC_DETECTION_PLY_WARP, "Teleport/Warp", 60 },
    { AC_DETECTION_VEH_JACK, "Jacking Occupied Vehicle", 0 },
    { AC_DETECTION_VEH_WARP, "Vehicle Warp Cheats", 60 },
    { AC_DETECTION_VEH_REPAIR, "Vehicle Repair Cheats", 60 },
    { AC_DETECTION_WEP_UNVERIFIED, "Weapon while Unverified", 60 },
    { AC_DETECTION_WEP_AMMO, "Weapon Ammo Cheats", 60 },
    { AC_DETECTION_WEP_SPOOFED, "Hacked/Spoofed Weapon", 30 },
    { AC_DETECTION_MISC_STRING, "String Buffer Exploit", 60 },
    { AC_DETECTION_MISC_PM, "PM Spamming", 60 },
    { AC_DETECTION_MISC_SPEC, "Spectate Cheats", 60 }
};

static AntiCheatEnumIdFromType(AC_DETECTION_TYPE:type)
{
    // We can just return -1 here for now since they are ordered nicely
    return _:type - 1;
}

static enum E_PLAYER_AC_DATA
{
    E_AC_ENTERED_VEHICLE,
    E_AC_LAST_VEHICLE,
    E_AC_LAST_VEHICLE_TIME,
    E_AC_JACKING_VEHICLE,
    E_AC_JACKING_PLAYER,
    E_AC_JACKED_VEHICLE,
    E_AC_JACKED_PLAYER,
    E_AC_DETECTION[AC_DETECTION_TYPE]
}

static PlayerAntiCheatVar[MAX_PLAYERS][E_PLAYER_AC_DATA];
static acstr[144];

static SendAntiCheatMessage(text[]) 
{
	foreach(new playerid: Player) 
    {
        if (IsPlayerPlaying(playerid) && GetPlayerAdminLevel(playerid))
        {
            ZMsg_SendClientMessage(playerid, 0xFFD54FFF, text);
        }
	}

    print(text);
}

// New WIP anticheat logging (to reduce spam)
AddAntiCheatLog(playerid, AC_DETECTION_TYPE:type, desc[] = "")
{
    if (!type)
    {
        printf("[error] Invalid anticheat type: %d", _:type);
        return 0;
    }

    new enum_id = AntiCheatEnumIdFromType(type);
    new now = gettime();

    if (PlayerAntiCheatVar[playerid][E_AC_DETECTION][type] && AntiCheatDetections[enum_id][E_AC_DETECTION_COOLDOWN])
    {
        // If this particular detection has a cooldown, then check the cooldown
        if (now - PlayerAntiCheatVar[playerid][E_AC_DETECTION][type] < AntiCheatDetections[enum_id][E_AC_DETECTION_COOLDOWN])
        {
            printf("Skipping detection (%d: %s) for (%d) %s", _:type, AntiCheatDetections[enum_id][E_AC_DETECTION_NAME], playerid, TEMP_ReturnPlayerName(playerid));
            return 0;
        }
    }

    new title[128];
    format(title, sizeof(title), "(%d) %s detected for %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), AntiCheatDetections[enum_id][E_AC_DETECTION_NAME]);

    if (strlen(desc))
    {
        format(acstr, sizeof(acstr), "[AntiCheat]: %s: \"%s\"", title, desc);
        AddLogEntry(playerid, LOG_TYPE_ANTICHEAT, sprintf("%s (%s)", AntiCheatDetections[enum_id][E_AC_DETECTION_NAME], desc));
        DCC_SendAntiCheatMessage(title, desc);
    } 
    else
    {
        format(acstr, sizeof(acstr), "[AntiCheat]: %s", title);
        AddLogEntry(playerid, LOG_TYPE_ANTICHEAT, AntiCheatDetections[enum_id][E_AC_DETECTION_NAME]);
        DCC_SendAntiCheatMessage(title, "_No additional information_");
    }
    
    SendAntiCheatMessage(acstr);
    PlayerAntiCheatVar[playerid][E_AC_DETECTION][type] = now;
    return 1;
}

forward AC_PutPlayerInVehicle(playerid, vehicleid, seatid);
public AC_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
    // printf("put player: %d in vehicle: %d, seat: %d", playerid, vehicleid, seatid); // debug print
    PlayerAntiCheatVar[playerid][E_AC_ENTERED_VEHICLE] = vehicleid;
    PutPlayerInVehicle(playerid, vehicleid, seatid);
    return 1;
}
 
#if defined _ALS_PutPlayerInVehicle
  #undef PutPlayerInVehicle
#else
    #define _ALS_PutPlayerInVehicle
#endif

#define PutPlayerInVehicle AC_PutPlayerInVehicle

hook OnPlayerConnect(playerid)
{
    new ac_clear[E_PLAYER_AC_DATA];
    PlayerAntiCheatVar[playerid] = ac_clear;

    return 1;
}

timer AntiCarJackUnfreeze[500](playerid)
{
    TogglePlayerControllable(playerid, 1);
    return true;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    PlayerAntiCheatVar[playerid][E_AC_ENTERED_VEHICLE] = vehicleid;
    PlayerAntiCheatVar[playerid][E_AC_JACKING_VEHICLE] = 0;
    PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER] = INVALID_PLAYER_ID;

    if (!ispassenger)
    {
        foreach (new i: Player) 
        {
            if (GetPlayerState(i) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(i) == vehicleid)
            {
                // So someone is entering a vehicle that already has a driver...
                PlayerAntiCheatVar[playerid][E_AC_JACKING_VEHICLE] = vehicleid;
                PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER] = i;

                // ClearAnimations(playerid, 1);


                //TogglePlayerControllable(playerid, 0);
                //defer AntiCarJackUnfreeze(playerid);
                break;

                /*
                
                break;
                */
            }
        }
    }

    return 1;
}

hook OnPlayerUpdate(playerid)
{
    // if (GetPlayerAdminLevel(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);

    if (vehicleid && vehicleid != PlayerAntiCheatVar[playerid][E_AC_ENTERED_VEHICLE])
    {
        // If they enter a car without OnPlayerEnterVehicle, allow it but send a warning.
        PlayerAntiCheatVar[playerid][E_AC_ENTERED_VEHICLE] = vehicleid;
        AddAntiCheatLog(playerid, AC_DETECTION_VEH_WARP, sprintf("may have warped into vehicle %d", vehicleid));
        WarpAnticheatTrigger(playerid);
    }

    if (vehicleid != PlayerAntiCheatVar[playerid][E_AC_LAST_VEHICLE])
    {
        if (vehicleid && PlayerAntiCheatVar[playerid][E_AC_JACKING_VEHICLE] == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && playerid != PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER])
        {
            // This here is purely for car jacking (not cheating, but trolls/noobs)
            if (!CanPlayerUseGuns(playerid, 8))
            {
                // Kick level 1s that carjack
                format(acstr, sizeof(acstr), "[AdmWarn]: (%d) %s has been kicked for car jacking.", playerid, ReturnPlayerNameData(playerid));
                ProxDetector(playerid, 30.0, COLOR_ORANGE, acstr);
                SendAdminWarning(acstr);
                KickPlayer(playerid);  
            }
            else
            {
                // Just send admin warning
                // format(acstr, sizeof(acstr), "[AntiCheat]: (%d) %s may have just jacked (%d) %s from a %s (VID: %d).", playerid, ReturnPlayerNameData(playerid), PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER], ReturnPlayerNameData(PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER]), ReturnVehicleName(vehicleid), vehicleid);
                // SendAdminMessage(acstr);
            }

            AddLogEntry(playerid, LOG_TYPE_GAME, sprintf("Jacked %s (%d) from a %s (%d)", ReturnPlayerNameData(PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER]), PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER], ReturnVehicleName(vehicleid), vehicleid));
            AddLogEntry(PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER], LOG_TYPE_GAME, sprintf("Was jacked from a %s (%d) by %s (%d)", ReturnVehicleName(vehicleid), vehicleid, ReturnPlayerNameData(playerid), playerid));
            
            //AddAntiCheatLog(playerid, AC_DETECTION_VEH_JACK, sprintf("Jacked %s (%d) from a %s (%d)", SOLS_PlayerName(PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER]), PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER], ReturnVehicleName(vehicleid), vehicleid));

            PlayerAntiCheatVar[playerid][E_AC_JACKING_VEHICLE] = 0;
            PlayerAntiCheatVar[playerid][E_AC_JACKING_PLAYER] = INVALID_PLAYER_ID;
        }

        PlayerAntiCheatVar[playerid][E_AC_LAST_VEHICLE] = vehicleid;
    }
     


    /*
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
    {
        if (vehicleid != AnticheatPlayer[playerid][E_AC_LAST_VEHICLE])
        {
            if (vehicleid && AnticheatPlayer[playerid][E_AC_LAST_VEHICLE_TIME] && ((gettime() - AnticheatPlayer[playerid][E_AC_LAST_VEHICLE_TIME]) < AC_MAX_VEH_ENTER_TIME))
            {
                // They are switching vehicles too quickly
                format(acstr, sizeof(acstr), "[Anticheat]: (%d) %s may be teleporting between cars.", playerid, ReturnPlayerNameData(playerid));
                SendAdminMessage(acstr);
            }

            AnticheatPlayer[playerid][E_AC_LAST_VEHICLE_TIME] = gettime();
            AnticheatPlayer[playerid][E_AC_LAST_VEHICLE] = vehicleid;
        }
    }
    */

    return 1;
}
