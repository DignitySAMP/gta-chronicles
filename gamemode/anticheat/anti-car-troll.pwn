/*
	Anti Troll System by Jelly23
*/

/*
	Usage: Add OnPlayerTroll(playerid) callback in the gamemode



TommyB — Today at 18:45
Attachment file type: unknown
anti-troll.inc
4.68 KB
this might help you
it has some false positives
but it generally always catches someone actually cheating
Dignity — Today at 18:46
any clue when the false positives occur? i guess when they make a ban appeal XD

TommyB — Today at 18:46
if someone has like
a phone out
and they get into a car
the script loses its mind

TommyB — Today at 18:47
there might be some other instances
i'd alert admins

*/

/*Variables*/
static
	ATV_Timer,
	ATV_Tempo[MAX_PLAYERS],
	ATV_Carro[MAX_PLAYERS],
	ATV_RJack[MAX_PLAYERS];

forward ATV_TrollCheck();
forward OnPlayerTroll(playerid);

public OnGameModeInit()
{
	ATV_Timer = SetTimer("ATV_TrollCheck", 1000, true);
	#if defined JT_OnGameModeInit
	return JT_OnGameModeInit();
	#else
	return 1;
	#endif
}

public OnGameModeExit()
{
	KillTimer(ATV_Timer);
	#if defined JT_OnGameModeExit
	return JT_OnGameModeExit();
	#else
	return 1;
	#endif
}

public ATV_TrollCheck()
{
	foreach(new i: Player)
	{
		if(IsPlayerInAnyVehicle(i))
		{
			if(GetPlayerVehicleID(i) != ATV_Carro[i])
			{
				if(gettime() > ATV_Tempo[i])
				{
					OnPlayerTroll(i);
				}
			}
		}
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(ATV_RJack[playerid])
		{
			OnPlayerTroll(playerid);
		}
	}

	#if defined JT_OnPlayerStateChange
	return JT_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
	return 1;
	#endif
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	ATV_Carro[playerid] = vehicleid;
	if(!ispassenger)
	{
		ATV_RJack[playerid] = 1;
	}
	#if defined JT_OnPlayerEnterVehicle
	return JT_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
	#else
	return 1;
	#endif
}

public OnPlayerUpdate(playerid)
{
	if(ATV_RJack[playerid] == 1 && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE)
	{
		ATV_RJack[playerid] = 0;
		ATV_Tempo[playerid] = gettime()+3;
	}
	#if defined JT_OnPlayerUpdate
	return JT_OnPlayerUpdate(playerid);
	#else
	return 1;
	#endif
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    if(floatround(floatsqroot(vel_x * vel_x + vel_y * vel_y) * 200, floatround_round) > 1100)
	{
		OnPlayerTroll(playerid);
		return 0;
	}
	if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 15)
	{
		return 0;
	}
	#if defined JT_OnUnoccupiedVehicleUpdate
	return JT_OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z);
	#else
	return 1;
	#endif
}

#if defined _ALS_OnPlayerStateChange
#undef OnPlayerStateChange
#else
#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange     JT_OnPlayerStateChange

#if defined JT_OnPlayerStateChange
forward JT_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

#if defined _ALS_OnPlayerEnterVehicle
#undef OnPlayerEnterVehicle
#else
#define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle     JT_OnPlayerEnterVehicle

#if defined JT_OnPlayerEnterVehicle
forward JT_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

#if defined _ALS_OnPlayerUpdate
#undef OnPlayerUpdate
#else
#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate     JT_OnPlayerUpdate

#if defined JT_OnPlayerUpdate
forward JT_OnPlayerUpdate(playerid);
#endif

#if defined _ALS_OnUnoccupiedVehicleUpdate
#undef OnUnoccupiedVehicleUpdate
#else
#define _ALS_OnUnoccupiedVehicleUpdate
#endif
#define OnUnoccupiedVehicleUpdate     JT_OnUnoccupiedVehicleUpdate

#if defined JT_OnUnoccupiedVehicleUpdate
forward JT_OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z);
#endif

#if defined _ALS_OnGameModeInit
#undef OnGameModeInit
#else
#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit     JT_OnGameModeInit

#if defined JT_OnGameModeInit
forward JT_OnGameModeInit();
#endif

#if defined _ALS_OnGameModeExit
#undef OnGameModeExit
#else
#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit     JT_OnGameModeExit

#if defined JT_OnGameModeExit
forward JT_OnGameModeExit();
#endif

JT_ResetPlayer(playerid)
{
	ATV_Tempo[playerid] = 0;
	ATV_Carro[playerid] = 0;
	ATV_RJack[playerid] = 0;
	return 1;
}

stock JT_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
	ATV_Tempo[playerid] = gettime()+3;
	ATV_Carro[playerid] = vehicleid;
	ATV_RJack[playerid] = 0;
	return PutPlayerInVehicle(playerid, vehicleid, seatid);
}

stock JT_RemovePlayerFromVehicle(playerid)
{
	ATV_Tempo[playerid] = gettime()+6;
	ATV_Carro[playerid] = 0;
	ATV_RJack[playerid] = 0;
	return RemovePlayerFromVehicle(playerid);
}

#if defined _ALS_RemovePlayerFromVehicle
#undef RemovePlayerFromVehicle
#else
#define _ALS_RemovePlayerFromVehicle
#endif

#define RemovePlayerFromVehicle JT_RemovePlayerFromVehicle

#if defined _ALS_PutPlayerInVehicle
#undef PutPlayerInVehicle
#else
#define _ALS_PutPlayerInVehicle
#endif

#define PutPlayerInVehicle JT_PutPlayerInVehicle
