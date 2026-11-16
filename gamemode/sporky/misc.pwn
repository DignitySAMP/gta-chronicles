#include <YSI_Coding\y_hooks>

static const AnimationLibraries[135][32] =
{
    "AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
	"BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
	"BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
	"BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
	"BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
	"CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
	"COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
	"DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
	"DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
	"FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
	"FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
	"GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
	"GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
	"INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
	"KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
	"MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
	"MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
	"PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
	"POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
	"QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
	"ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        "SAMP",
	"SCRATCHING",   "SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",
	"SILENCED",     "SKATE",        "SMOKING",      "SNIPER",       "SNM",
	"SPRAYCAN",     "STRIP",        "SUNBATHE",     "SWAT",         "SWEET",
	"SWIM",         "SWORD",        "TANK",         "TATTOOS",      "TEC",
	"TRAIN",        "TRUCK",        "UZI",          "VAN",          "VENDING",
	"VORTEX",       "WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

CMD:customanim(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

	new lib[32], anim[32], loop, usex, usey, freeze, time;
    if (sscanf(params, "s[32] s[32] D(0)D(0)D(0)D(0)D(0)", lib, anim, loop, usex, usey, freeze, time))
		return SendClientMessage(playerid, -1, "/customanim [library] [name] [loop | 0] [usex | 0] [usey | 0] [freeze | 0] [time | 0]");

	for (new i = 0; i < sizeof(AnimationLibraries); i ++)
	{
	    if (!strcmp(AnimationLibraries[i], lib, true))
	    {
	        ApplyAnimation(playerid, AnimationLibraries[i], anim, 4.1, loop, usex, usey, freeze, time, 1);
	        return 1;
	    }
	}
	
    SendClientMessage(playerid, -1, "Invalid animation library.");
	return 1;
}

CMD:canim(playerid, params[])
{
    return cmd_customanim(playerid, params);
}

CMD:setcustomanim(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_ADVANCED) return 0;

	new targetid, lib[32], anim[32], loop, usex, usey, freeze, time;
    if (sscanf(params, "k<player>s[32] s[32] D(0)D(0)D(0)D(0)D(0)", targetid, lib, anim, loop, usex, usey, freeze, time))
		return SendClientMessage(playerid, -1, "/setcustomanim [player] [library] [name] [loop | 0] [usex | 0] [usey | 0] [freeze | 0] [time | 0]");

    if (!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Invalid player target.");

	for (new i = 0; i < sizeof(AnimationLibraries); i ++)
	{
	    if (!strcmp(AnimationLibraries[i], lib, true))
	    {
	        ApplyAnimation(targetid, AnimationLibraries[i], anim, 4.1, loop, usex, usey, freeze, time, 1);
	        return 1;
	    }
	}
	
    SendClientMessage(playerid, -1, "Invalid animation library.");
	return 1;
}

CMD:setcanim(playerid, params[])
{
    return cmd_setcustomanim(playerid, params);
}

static mallscissors;

CMD:scissors(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_MANAGER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new enabled;

	if ( sscanf ( params, "d", enabled ) ) {

		SendClientMessage(playerid, -1, "/scissors [0 or 1] (0 to drop, 1 to hold)" ) ;
		return true;
	}

	if (mallscissors && IsValidDynamicObject(mallscissors)) DestroyDynamicObject(mallscissors);

	if (!enabled)
	{
		mallscissors = CreateDynamicObject(-25279, 1720.474, -1689.130, 12.880, 81.299, -87.400, -65.600); // Kate_Mercer (-25279)

		foreach(new i: Player)
		{
			if (IsPlayerInRangeOfPoint(i, 50.0, 1720.474, -1689.130, 12.880))
			{
				Streamer_Update(i, STREAMER_TYPE_OBJECT);
			}
		}

		RemovePlayerAttachedObject(playerid, 9);
		return true;
	}

	SetPlayerAttachedObject(playerid, 9, -25279, 6, 0.12, -0.02, 0.13, 1.20, -95.70, -108.39, 1.33, 1.00, 1.00);
	EditAttachedObject(playerid, 9);

	PlayerVar[playerid][E_PLAYER_SPOOFING_ATTACH] = 1;

	return true ;
}

CMD:spoofattach(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL && !IsPlayerInDEAFaction(playerid) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new slot, modelid, bone;

	if ( sscanf ( params, "iii", slot, modelid, bone ) ) {

		SendClientMessage(playerid, -1, "/spoofattach [slot 0 - 9] [modelid] [bone] (model 0 to remove, slot 8 doesn't work)" ) ;
		SendClientMessage(playerid, -1, "Common bones: 1 (Spine), 2 (Head), 5 (L Hand), 6 (R Hand), 7 (R Thigh), 8 (L Thigh), 17 (Neck)" ) ;
		return true;
	}

	if (modelid == 0)
	{
		RemovePlayerAttachedObject(playerid, slot);
		return true;
	}

	SetPlayerAttachedObject(playerid, slot, modelid, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
	EditAttachedObject(playerid, slot);

	PlayerVar[playerid][E_PLAYER_SPOOFING_ATTACH] = 1;

	return true ;
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float: fOffsetY, Float: fOffsetZ, Float: fRotX, Float: fRotY, Float: fRotZ, Float: fScaleX, Float: fScaleY, Float: fScaleZ )
{
	if (PlayerVar[playerid][E_PLAYER_SPOOFING_ATTACH])
	{
		if (response)
		{
			SetPlayerAttachedObject(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ );
			SendClientMessage(playerid, -1, sprintf("SetPlayerAttachedObject(playerid, %d, %d, %d, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f);", index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ));
		}
		else
		{
			RemovePlayerAttachedObject(playerid, index);
		}

		PlayerVar[playerid][E_PLAYER_SPOOFING_ATTACH] = 0;
		return -2; // stop processing OnPlayerEditAttachedObject and return 1
	}

	return 0;
}

// Just some extra stuff that might be helpful atm
static PlayerStates[10][40] = 
{
	"PLAYER_STATE_NONE",
	"PLAYER_STATE_ONFOOT",
	"PLAYER_STATE_DRIVER",
	"PLAYER_STATE_PASSENGER",
	"PLAYER_STATE_EXIT_VEHICLE",
	"PLAYER_STATE_ENTER_VEHICLE_DRIVER",
	"PLAYER_STATE_ENTER_VEHICLE_PASSENGER",
	"PLAYER_STATE_WASTED",
	"PLAYER_STATE_SPAWNED",
	"PLAYER_STATE_SPECTATING"
};

CMD:getstate(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < 4) return 0;

	new targetid, playerstate;
	if (sscanf(params, "k<player>", targetid) || !IsPlayerConnected(targetid))
		return SendClientMessage(playerid, -1, "/getplayerstate [player]");

	playerstate = GetPlayerState(targetid);
    SendClientMessage(playerid, -1, sprintf("%s (%d): %s (%d)", ReturnPlayerNameData(targetid), targetid, PlayerStates[playerstate], playerstate));

	return 1;
}

CMD:getplayerstate(playerid, params[])
{
	return cmd_getstate(playerid, params);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_SPECTATING && GetPlayerAdminLevel(playerid) < 1 && IsPlayerLogged(playerid) && PlayerVar[playerid][E_PLAYER_CHOSE_CHARACTER] && !PlayerVar [ playerid ] [ E_PLAYER_JUST_LOGGED_OUT ])
    {
		if (PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] == INVALID_PLAYER_ID)
		{
			// SendAdminMessage(sprintf("[Anticheat]: (%d) %s may be spectating (previously: %s)", playerid, ReturnPlayerNameData(playerid), PlayerStates[oldstate]));
			AddAntiCheatLog(playerid, AC_DETECTION_MISC_SPEC, "Spectating without being admin");
		}
    }

	if ((newstate != PLAYER_STATE_SPECTATING && newstate != PLAYER_STATE_NONE) && !IsPlayerLogged(playerid))
	{
		// They spawned without logging in
		Kick(playerid);
		SendAdminWarning(sprintf("(%d) %s was kicked for spawning without logging in.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT))); 
	}

	if (newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if (vehicleid && (!IsEngineVehicle(vehicleid) || GetEngineStatus(vehicleid)))
		{
			if (Account[playerid][E_PLAYER_ACCOUNT_VEHBAN])
			{
				SendClientMessage(playerid, COLOR_ERROR, "Your permission to drive vehicles was revoked by an admin.");
				if (IsEngineVehicle(vehicleid)) SetEngineStatus(vehicleid, false);
				else RemovePlayerFromVehicle(playerid);
				
			}
			else if (Account[playerid][E_PLAYER_ACCOUNT_BIKEBAN] && IsABike(GetPlayerVehicleID(playerid)))
			{
				SendClientMessage(playerid, COLOR_ERROR, "Your permission to use bikes was revoked by an admin.");
				if (IsEngineVehicle(vehicleid)) SetEngineStatus(vehicleid, false);
				else RemovePlayerFromVehicle(playerid);
			}
		}		
	}

    return 1;
}

CMD:getdistance(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < 1) return 0;

	new targetid;
    if (sscanf(params, "k<player>", targetid) || !IsPlayerConnected(targetid))
		return SendClientMessage(playerid, -1, "/getdistance [player]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(targetid, x, y, z);

	new Float:distance = GetPlayerDistanceFromPoint(playerid, x, y, z);

	new address[64], zone[64];
	GetCoords2DZone(x, y, zone, sizeof ( zone ));
	GetPlayerAddress(x, y, address );

    SendClientMessage(playerid, -1, sprintf("You are %.02fm away from %s (%d), location: %s, %s.", distance, ReturnPlayerNameData(targetid), targetid, address, zone));

	return 1;
}

CMD:distance(playerid, params[])
{
	return cmd_getdistance(playerid, params);
}

CMD:dist(playerid, params[])
{
	return cmd_getdistance(playerid, params);
}

new Float:g_AwaitingPos[MAX_PLAYERS][3];
new g_AwaitingPosTime[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    g_AwaitingPos[playerid][0] = 0.0;
	g_AwaitingPosTime[playerid] = 0;
    return 1;
}

stock SOLS_SetPosWithFade(playerid, Float:x, Float:y, Float:z, const text[]="")
{
    g_AwaitingPos[playerid][0] = x;
    g_AwaitingPos[playerid][1] = y;
    g_AwaitingPos[playerid][2] = z;
	g_AwaitingPosTime[playerid] = gettime();

	BlackScreen(playerid);
	Streamer_UpdateEx(playerid, x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), STREAMER_TYPE_OBJECT);
    TogglePlayerControllable(playerid, false);
    SetPlayerPos(playerid, x, y, z - 0.3);
		

	if (strlen(text) > 1) UpdateZone(playerid, text);
	else UpdateZone(playerid, "", true, x, y);
	
    return 1;
}

static veh_id, Float:veh_hp;


hook OnPlayerUpdate(playerid)
{
    if (g_AwaitingPosTime[playerid])
	{
        if ((GetPlayerDistanceFromPoint(playerid, g_AwaitingPos[playerid][0], g_AwaitingPos[playerid][1], g_AwaitingPos[playerid][2]) < 0.2) || (gettime() - g_AwaitingPosTime[playerid]) >= 3) 
		{
            //TogglePlayerControllable(playerid, true);
			g_AwaitingPosTime[playerid] = 0;
            g_AwaitingPos[playerid][0] = 0.0;

			//Streamer_UpdateEx(playerid, g_AwaitingPos[playerid][0], g_AwaitingPos[playerid][1], g_AwaitingPos[playerid][2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), STREAMER_TYPE_OBJECT);
			SetCameraBehindPlayer(playerid);
			FadeIn(playerid, true);
        }
    }

	// Temp code to stop cars blowing up
	if (IsPlayerInAnyVehicle(playerid))
	{
		veh_id = GetPlayerVehicleID(playerid);
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && veh_id)
		{
			GetVehicleHealth(veh_id, veh_hp);

			if (veh_hp < 300 && !VehicleVar[veh_id][E_VEHICLE_CAN_EXPLODE])
			{
				veh_hp = 300;

				if (IsEngineVehicle(veh_id) && GetEngineStatus(veh_id))
				{
					SetEngineStatus(veh_id, false);
					ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** The engine of the %s shuts off with a bang.", ReturnVehicleName ( veh_id )));
					ShowPlayerSubtitle( playerid, "~r~Your vehicle has been totalled!", .showtime = 5000 ) ;

					new Float:x, Float:y, Float:z, Float:ox, Float:oy, Float:oz;
					if (GetEnginePos(veh_id, x, y, z))
					{
						if (VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] && IsValidDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]))
						{
							DestroyDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]);
						}

						z = z - 1.0;
						GetVehicleRelativePos(veh_id, ox, oy, oz, x, y, z);
						VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] = CreateDynamicObject(18680, ox, oy, oz, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT], veh_id, x, y, z, 0.0, 0.0, 0.0);

						defer DeleteVehicleFlame(veh_id);
					}
				}

				new veh_enum_id = Vehicle_GetEnumID(veh_id);
				if (veh_enum_id != -1)
				{
					SOLS_SetVehicleHealth(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], veh_hp);
		    		Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] = veh_hp;
				}
			}
		}
	}

    return 1;
}

static Timer:testTimer;

CMD:carobject(playerid, params[])
{
	if (!GetPlayerAdminLevel(playerid)) return false;

	veh_id = GetPlayerVehicleID(playerid);
	if (!veh_id || !IsPlayerInAnyVehicle(playerid)) return false;

	new modelid, Float:x, Float:y, Float:z, Float:rz;
	if (sscanf(params, "dfffF(0)", modelid, x, y, z, rz))
	{
		return SendClientMessage(playerid, -1, "/carobject [model] [x] [y] [z] [rz]");
	}

	if (VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] || IsValidDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]))
	{
		DestroyDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]);
		VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] = 0;
	}

	new Float:ox, Float:oy, Float:oz;
	GetVehicleRelativePos(veh_id, ox, oy, oz, x, y, z);

	VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] = CreateDynamicObject(modelid, ox, oy, oz, 0.0, 0.0, 0.0);
	AttachDynamicObjectToVehicle(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT], veh_id, x, y, z, 0.0, 0.0, rz);
	SendClientMessage(playerid, -1, sprintf("Attached model %d to your vehicle at %.02f, %.02f, %.02f, %.02f", modelid, x, y, z, rz));

	return true;
}

CMD:testcarfire(playerid, params[])
{
	if (!GetPlayerAdminLevel(playerid)) return false;

	new modelid, Float:zoff;
	if (sscanf(params, "dF(0)", modelid, zoff))
	{
		return SendClientMessage(playerid, -1, "/testcarfire [model] [z off]");
	}

	veh_id = GetPlayerVehicleID(playerid);

	if (VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT])
	{
		DestroyDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]);
		VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] = 0;
		return true;
	}

	new Float:x, Float:y, Float:z, Float:ox, Float:oy, Float:oz;
	if (GetEnginePos(veh_id, x, y, z))
	{
		if (VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] && IsValidDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]))
		{
			DestroyDynamicObject(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT]);
		}

		GetVehicleRelativePos(veh_id, ox, oy, oz, x, y, z);
		VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT] = CreateDynamicObject(modelid, ox, oy, oz, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(VehicleVar[veh_id][E_VEHICLE_FLAME_OBJECT], veh_id, x, y, z + zoff, 0.0, 0.0, 0.0);
		SendClientMessage(playerid, -1, sprintf("%.02f, %.02f, %.02f", x, y, z));

		//testTimer = defer DeleteVehicleFlames(veh_id);
	}

	return true;
}

timer DeleteVehicleFlame[5000](vehicleid) 
{
	if (VehicleVar[vehicleid][E_VEHICLE_FLAME_OBJECT] && IsValidDynamicObject(VehicleVar[vehicleid][E_VEHICLE_FLAME_OBJECT]))
	{
		DestroyDynamicObject(VehicleVar[vehicleid][E_VEHICLE_FLAME_OBJECT]);
		VehicleVar[vehicleid][E_VEHICLE_FLAME_OBJECT] = 0;
	}

    return true ;
}

// Temp engine offsets
static enum E_ENGINE_OFFSET
{
	E_ENGINE_OFFSET_MODEL,
	Float:E_ENGINE_OFFSET_X,
	Float:E_ENGINE_OFFSET_Y,
	Float:E_ENGINE_OFFSET_Z
}

static const EngineOffsets[][E_ENGINE_OFFSET] = { {400,  0.00, 1.54, -0.04}, {401,  0.00, 1.77, 0.14}, {402,  0.00, 1.47, 0.14}, {403,  0.00, 3.30, 0.40}, {404,  0.00, 1.61, 0.12}, {405,  0.00, 1.72, -0.11}, {406,  -0.01, 4.97, 0.89}, {407,  0.00, 3.95, -0.08}, {408,  0.00, 4.40, -0.16}, {409,  0.00, 2.73, 0.18}, {410,  0.00, 1.55, 0.09}, {411,  0.00, 1.82, 0.09}, {412,  0.00, 1.64, 0.13}, {413,  0.00, 2.16, -0.01}, {414,  0.00, 2.36, 0.19}, {415,  0.00, -1.60, 0.03}, {416,  0.00, 2.54, 0.11}, {417,  0.00, 1.55, 2.32}, {418,  0.00, 2.00, 0.08}, {419,  0.00, 1.53, 0.12}, {420,  0.00, 1.61, 0.22}, {421,  0.00, 2.00, -0.11}, {422,  0.00, 1.71, -0.01}, {423,  0.00, 2.04, 0.24}, {424,  -0.03, -1.60, 0.06}, {426,  0.00, 1.61, 0.18}, {427,  0.00, 2.65, 0.25}, {428,  0.00, 2.36, 0.06}, {429,  0.00, 1.37, 0.21}, {431,  0.00, -5.48, -0.01}, {433,  0.00, 2.98, 0.28}, {434,  -0.06, 1.65, -0.07}, {436,  0.00, 1.88, -0.04}, {437,  0.00, -5.13, -0.85}, {438,  0.00, 1.82, 0.10}, {439,  0.00, 1.54, 0.06}, {440,  0.00, 2.01, -0.08}, {442,  0.00, 1.98, -0.04}, {443,  0.00, 5.17, 0.30}, {444,  0.00, 1.95, 0.97}, {445,  0.00, 1.65, 0.20}, {446,  0.00, -2.70, 0.66}, 
	{448,  0.00, -0.89, -0.22}, {451,  0.00, -1.53, 0.31}, {453,  0.84, 3.42, 1.83}, {454,  0.00, -4.71, 0.00}, {455,  0.07, 3.68, 0.60}, {456,  -0.02, 3.11, 0.39}, {457,  0.00, 0.96, 0.11}, {458,  0.00, 1.81, -0.10}, {459,  0.00, 2.16, -0.01}, {460,  0.00, 2.48, 0.22}, {461,  0.00, 0.00, 0.00}, {462,  0.00, -0.89, -0.22}, {463,  0.00, 0.22, 0.05}, 
	{466,  0.00, 1.62, 0.21}, {467,  0.00, 1.72, 0.21}, {468,  0.00, 0.18, 0.03}, {470,  0.00, 1.48, 0.13}, {472,  -0.44, -3.49, 0.23}, {474,  0.00, 1.62, 0.27}, {475,  0.00, 1.54, 0.15}, {476,  0.46, 2.13, -0.15}, {477,  0.00, 1.55, -0.06}, {478,  0.00, 1.56, 0.07}, {479,  0.02, 1.70, 0.26}, {480,  0.00, 1.30, 0.13}, {482,  0.00, 2.04, -0.09}, {483,  0.00, -2.74, -0.54}, {485,  0.00, 1.21, 0.40}, {486,  0.00, -3.19, 0.61}, {489,  0.00, 1.72, 0.19}, {490,  -0.01, 2.26, 0.21}, {491,  0.00, 1.49, -0.03}, {492,  0.00, 1.64, 0.23}, {493,  0.00, -2.66, 0.92}, {494,  0.00, 1.62, -0.16}, {495,  -0.06, 1.68, 0.19}, {496,  0.00, 1.51, 0.16}, {498,  -0.21, 2.76, 0.42}, {499,  0.00, 1.90, 0.01}, {500,  0.00, 1.43, -0.09}, {502,  0.00, 1.62, -0.13}, {503,  0.00, 1.46, -0.13}, {504,  0.00, 1.62, 0.21}, {505,  0.00, 1.72, 0.19}, {506,  0.00, 1.22, -0.07}, {507,  0.00, 1.78, 0.13}, {508,  0.00, 2.72, 0.03}, {511,  -2.92, 0.52, 0.49}, {513,  0.00, 1.80, 0.01}, {514,  0.00, 3.32, 0.27}, {515,  0.00, 3.83, 0.23}, {516,  0.00, 1.82, 0.00}, {517,  0.00, 1.78, -0.06}, {518,  0.04, 1.81, 0.14}, {519,  1.42, -5.45, 0.39}, {520,  0.77, -2.34, -0.02}, {521,  0.00, 0.11, 0.07}, 
	{522,  0.00, 0.17, 0.05}, {523,  0.00, 0.11, 0.04}, {524,  0.00, 2.85, 0.07}, {525,  0.00, 2.35, 0.37}, {526,  0.00, 1.53, 0.10}, {527,  0.00, 1.73, 0.01}, {528,  0.00, 1.69, 0.01}, {529,  0.03, 1.73, 0.13}, {530,  0.00, -0.96, -0.01}, {531,  -0.01, 0.89, 0.29}, {532,  -0.07, -1.84, 0.43}, {533,  0.53, 1.67, 0.20}, {534,  0.00, 1.86, -0.01}, {535,  0.00, 1.72, 0.12}, {536,  0.00, 1.69, 0.08}, {540,  0.00, 1.80, -0.47}, {541,  0.00, -0.98, 0.45}, {542,  0.00, 1.51, -0.03}, {543,  0.00, 1.58, 0.20}, {544,  0.00, 3.48, 0.18}, {545,  0.00, 0.98, 0.28}, {546,  0.00, 1.75, 0.09}, {547,  0.00, 1.63, -0.01}, {549,  0.00, 1.74, -0.36}, {550,  0.04, 1.87, 0.00}, {551,  0.00, 1.99, -0.01}, {552,  -0.11, 2.26, 0.62}, {553,  3.91, 5.61, -0.89}, {554,  0.01, 1.67, 0.30}, {555,  0.00, 1.53, -0.33}, {557,  0.00, 1.81, 0.84}, {558,  0.00, 1.35, -0.25}, {559,  0.02, 1.51, 0.13}, {560,  0.04, 1.73, 0.07}, {561,  0.09, 1.97, 0.01}, {562,  0.00, 1.92, 0.08}, {563,  1.02, -2.44, 1.23}, {565,  -0.06, 1.73, -0.08}, {566,  0.00, 1.71, 0.26}, {567,  0.00, 1.99, 0.03}, {568,  0.00, -0.98, 0.05}, {571,  0.32, -0.47, -0.14}, {572,  0.00, 0.55, 0.17}, {573,  0.00, 3.14, 0.20}, 
	{574,  0.00, -0.61, 0.03}, {575,  0.00, 1.61, 0.34}, {576,  0.00, 1.59, 0.31}, {578,  0.00, 4.48, -0.53}, {579,  0.00, 1.58, 0.29}, {580,  -0.02, 2.18, 0.26}, {581,  0.00, 0.14, 0.03}, {582,  0.00, 2.08, 0.02}, {583,  0.00, 0.73, 0.51}, {583,  -0.01, 1.47, 0.59}, {585,  0.00, 2.28, 0.20}, {586,  0.00, 0.14, 0.02}, {587,  0.00, 1.46, -0.11}, {588,  0.00, -4.07, -0.14}, {589,  0.00, 1.81, 0.27}, {593,  0.00, 2.45, 0.07}, {595,  0.48, -3.57, 0.30}, {596,  0.00, 1.61, 0.18}, {597,  0.00, 1.61, 0.20}, {598,  0.00, 1.57, 0.26}, {600,  0.00, 1.83, -0.34}, {601,  -0.38, -2.59, 1.00}, {602,  0.00, 1.52, 0.12}, {603,  0.00, 1.60, -0.09}, {604,  0.00, 1.62, 0.21}, {605,  0.00, 1.58, 0.20}, {609,  -0.21, 2.76, 0.42} };

static GetEnginePos(vehicleid, &Float:x, &Float:y, &Float:z)
{
	new model = GetVehicleModel(vehicleid);
	for (new i = 0; i < sizeof(EngineOffsets); i++)
	{
		if (EngineOffsets[i][E_ENGINE_OFFSET_MODEL] != model) continue;

		x = EngineOffsets[i][E_ENGINE_OFFSET_X];
		y = EngineOffsets[i][E_ENGINE_OFFSET_Y];
		z = EngineOffsets[i][E_ENGINE_OFFSET_Z];
		
		return 1;
	}

	return 0;
}

/*
hook OnGameModeInit()
{
	printf("NEW3101_ELS_1 is %d", NEW3101_ELS_1);
	return 1;
}
*/