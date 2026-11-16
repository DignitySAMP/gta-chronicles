//------------------------------------------------------------------------------
// Useable fire truck fire hose with custom models and particles
// By Spooky (www.github.com/sporkyspork) for GTA Chronicles (www.gta-chronicles.com)


#include <YSI_Coding\y_hooks>
//#include <3DTryg>

#define HOSE_MODEL_PATH "sporky/firehose"

#define HOSE_LINE_L_MODEL -25240
#define HOSE_LINE_R_MODEL -25241
#define HOSE_SEG_MODEL -25242
#define HOSE_END_MODEL -25243
#define HOSE_END_MODEL_BIG -25244

#define MAX_HOSE_SEGMENTS	50
#define HOSE_SEG_LENGTH		2.0
#define MAX_HOSES			4

#define ENGINE_OFFSET_X 	0.6
#define ENGINE_OFFSET_Y 	-3.394
#define ENGINE_OFFSET_Z 	0.244

#define LINE_OFFSET_X 		2.099
#define LINE_OFFSET_Y		-1.611
#define LINE_OFFSET_Z		-1.079


static enum E_FIREHOSE
{
	bool:E_FIREHOSE_EXISTS,
	E_FIREHOSE_VEHICLE,
	E_FIREHOSE_LINE_INDEX,
	E_FIREHOSE_PLAYER,
	STREAMER_TAG_OBJECT:E_FIREHOSE_OBJ_BASE,
	STREAMER_TAG_OBJECT:E_FIREHOSE_OBJ_SEGS[MAX_HOSE_SEGMENTS],
	E_FIREHOSE_SEG_INDEX,
	STREAMER_TAG_3D_TEXT_LABEL:E_FIREHOSE_LABEL,
	STREAMER_TAG_3D_TEXT_LABEL:E_FIREHOSE_BASE_LABEL,
	bool:E_FIREHOSE_INITIALIZED,
	bool:E_FIREHOSE_ON,
	bool:E_FIREHOSE_NEEDS_UPDATE
}

static FireHose[MAX_HOSES][E_FIREHOSE];

static AddHoseModels()
{
	AddSimpleModel(-1, 1923, HOSE_LINE_L_MODEL, HOSE_MODEL_PATH"/hoseline_l.dff", HOSE_MODEL_PATH"/firehose.txd");
	AddSimpleModel(-1, 1923, HOSE_LINE_R_MODEL, HOSE_MODEL_PATH"/hoseline_r.dff", HOSE_MODEL_PATH"/firehose.txd");
	AddSimpleModel(-1, 1923, HOSE_SEG_MODEL, HOSE_MODEL_PATH"/hoseseg.dff", HOSE_MODEL_PATH"/firehose.txd");
	AddSimpleModel(-1, 1923, HOSE_END_MODEL, HOSE_MODEL_PATH"/hosenozzle.dff", HOSE_MODEL_PATH"/firehose.txd");
	AddSimpleModel(-1, 1923, HOSE_END_MODEL_BIG, HOSE_MODEL_PATH"/hosenozzle_big.dff", HOSE_MODEL_PATH"/firehose.txd");
}

hook OnGameModeInit()
{
	for (new i = 0; i < MAX_HOSES; i ++)
	{
		FireHose[i][E_FIREHOSE_PLAYER] = INVALID_PLAYER_ID;
	}

	AddHoseModels();
	return 1;
}

static CreateHose(playerid, vehicleid, lineindex)
{
    new id = -1, text[128];

    for (new i = 0; i < MAX_HOSES; i ++)
    {
	    if (FireHose[i][E_FIREHOSE_EXISTS]) continue;

        id = i;
		break;
    }

    if (id >= 0)
    {
		DeleteHose(id);

		FireHose[id][E_FIREHOSE_LINE_INDEX] = lineindex;
        FireHose[id][E_FIREHOSE_EXISTS] = true;   
		FireHose[id][E_FIREHOSE_VEHICLE] = vehicleid; 
		FireHose[id][E_FIREHOSE_PLAYER] = playerid; 
		FireHose[id][E_FIREHOSE_INITIALIZED] = false; 
		FireHose[id][E_FIREHOSE_ON] = false;
		FireHose[id][E_FIREHOSE_NEEDS_UPDATE] = false;

		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid, x, y, z);

		new modelid = lineindex == 0 ? HOSE_LINE_L_MODEL : HOSE_LINE_R_MODEL;
		new Float:offsetx = lineindex == 0 ? -ENGINE_OFFSET_X : ENGINE_OFFSET_X;

		FireHose[id][E_FIREHOSE_OBJ_BASE] = CreateDynamicObject(modelid, x, y, z, 0.0, 0.0, 0.0, -1, -1, -1, 200.0, 200.0, -1, 1); // Priority: 1
		AttachDynamicObjectToVehicle(FireHose[id][E_FIREHOSE_OBJ_BASE], vehicleid, offsetx, ENGINE_OFFSET_Y, ENGINE_OFFSET_Z, 0.0, 0.0, 0.0);

		format(text, sizeof(text), "[Fire Hose %d]{DEDEDE}\nType {c4a656}/firehose {DEDEDE}to disconnect.", id + 1);
        FireHose[id][E_FIREHOSE_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, offsetx, ENGINE_OFFSET_Y - 0.1, ENGINE_OFFSET_Z + 0.1, 7.5, INVALID_PLAYER_ID, vehicleid, 1);

		/*
		format(text, sizeof(text), "{DEDEDE}Press {c4a656}~k~~GROUP_CONTROL_BWD~ {DEDEDE}to connect the hose.", id + 1);

		offsetx = LINE_OFFSET_X;
		if (FireHose[id][E_FIREHOSE_LINE_INDEX] == 0) offsetx = -LINE_OFFSET_X;

		GetVehicleRelativePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z, offsetx, LINE_OFFSET_Y, LINE_OFFSET_Z);
        FireHose[id][E_FIREHOSE_BASE_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, offsetx, LINE_OFFSET_Y, LINE_OFFSET_Z + 0.1, 7.5, INVALID_PLAYER_ID, vehicleid, 1);
		*/

        foreach(new i: Player)
        {
            if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
            {
                Streamer_Update(i);
            }
        }

		ShowPlayerFooter(playerid, "Press ~y~~k~~GROUP_CONTROL_BWD~~w~ to use the hose.");
    }

    return id;
}

static DeleteHose(id)
{
	if (FireHose[id][E_FIREHOSE_OBJ_BASE] != -1 && IsValidDynamicObject(FireHose[id][E_FIREHOSE_OBJ_BASE]))
	{
		DestroyDynamicObject(FireHose[id][E_FIREHOSE_OBJ_BASE]);
	}

	FireHose[id][E_FIREHOSE_OBJ_BASE] = -1;

	for (new i = 0; i < MAX_HOSE_SEGMENTS; i ++)
	{
		if (FireHose[id][E_FIREHOSE_OBJ_SEGS][i] != -1 && IsValidDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][i]))
		{
			DestroyDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][i]);
		}

		FireHose[id][E_FIREHOSE_OBJ_SEGS][i] = -1;
	}

	if (IsValidDynamic3DTextLabel(FireHose[id][E_FIREHOSE_BASE_LABEL]))
	{
		DestroyDynamic3DTextLabel(FireHose[id][E_FIREHOSE_BASE_LABEL]);
	}

	if (IsValidDynamic3DTextLabel(FireHose[id][E_FIREHOSE_LABEL]))
	{
		DestroyDynamic3DTextLabel(FireHose[id][E_FIREHOSE_LABEL]);
	}

	new playerid = FireHose[id][E_FIREHOSE_PLAYER];
	if (IsPlayerConnected(playerid))
	{
		PlayerVar[playerid][E_PLAYER_USING_HOSE] = false;
		UpdatePlayerFirehose(playerid);
	}

	FireHose[id][E_FIREHOSE_PLAYER] = INVALID_PLAYER_ID;
	FireHose[id][E_FIREHOSE_EXISTS] = false;
}

hook OnPlayerUpdate(playerid)
{
	if (!PlayerVar[playerid][E_PLAYER_USING_HOSE])
	{
		return 1;
	}

	new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];
	new vehicleid = FireHose[id][E_FIREHOSE_VEHICLE];

	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	new Keys, ud, lr;

	new current = FireHose[id][E_FIREHOSE_SEG_INDEX];
	new previous = current - 1;
	new next = current + 1;

	new Float:offsetx = LINE_OFFSET_X;
	if (FireHose[id][E_FIREHOSE_LINE_INDEX] == 0) offsetx = -LINE_OFFSET_X;

	GetVehiclePos(vehicleid, x, y, z);
	if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 25.0 + (MAX_HOSE_SEGMENTS * HOSE_SEG_LENGTH))
	{
		DeleteHose(id);
		return 1;
		// They went too far away
	}

	if (FireHose[id][E_FIREHOSE_INITIALIZED])
	{
		GetPlayerKeys(playerid, Keys, ud, lr);
		new special = GetPlayerSpecialAction(playerid);

		if (special != PlayerVar[playerid][E_PLAYER_HOSE_ACTION] || !PlayerVar[playerid][E_PLAYER_HOSE_UPDATED_AT] || gettime() - PlayerVar[playerid][E_PLAYER_HOSE_UPDATED_AT] > 10)
		{
			UpdatePlayerFirehose(playerid);
			PlayerVar[playerid][E_PLAYER_HOSE_UPDATED_AT] = gettime();
		}

		if (ud || lr)
		{
			PlayerVar[playerid][E_PLAYER_HOSE_SYNCED] = false;
		}
		else
		{
			if (!PlayerVar[playerid][E_PLAYER_HOSE_SYNCED])
			{
				ResyncPlayerToHose(playerid);
				UpdatePlayerFirehose(playerid);
				PlayerVar[playerid][E_PLAYER_HOSE_SYNCED] = true;
			}
		}

		PlayerVar[playerid][E_PLAYER_HOSE_ACTION] = special;
		SetPlayerArmedWeapon(playerid, 0);
	}

	if (FireHose[id][E_FIREHOSE_INITIALIZED])
	{
		if (previous >= 0) GetDynamicObjectPos(FireHose[id][E_FIREHOSE_OBJ_SEGS][previous], x, y, z);
		else GetVehicleRelativePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z, offsetx, LINE_OFFSET_Y, LINE_OFFSET_Z);
		new Float:dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

		new Float:newx, Float:newy, Float:newz;
		GetDynamicObjectPos(FireHose[id][E_FIREHOSE_OBJ_SEGS][current], x, y, z);
		GetDynamicObjectRot(FireHose[id][E_FIREHOSE_OBJ_SEGS][current], rx, ry, rz);
		GetPointInFront3D(x, y, z, rx, rz, HOSE_SEG_LENGTH, newx, newy, newz);
		new Float:nextdist = GetPlayerDistanceFromPoint(playerid, newx, newy, newz);

		new Float:maxi = HOSE_SEG_LENGTH;
		if ((current + 1) >= MAX_HOSE_SEGMENTS) maxi += 0.5;

		if (nextdist >= maxi && nextdist < dist)
		{
			// Add a new one
			if ((current + 1) >= MAX_HOSE_SEGMENTS)
			{
				ResyncPlayerToHose(playerid, true);
				ShowPlayerFooter(playerid, "~r~The maximum hose length was reached.", 3000);
				return 1;
			}

			if (GetPlayerDistanceFromPoint(playerid, newx, newy, newz) >= HOSE_SEG_LENGTH)
			{
				new Float:px, Float:py, Float:pz;
				// GetPlayerPos(playerid, px, py, pz);
				GetPlayerRelativePos(playerid, px, py, pz, 0.2, -0.5, 0.0);

				rz = GetAngleBetweenPoints(x, y, px, py);
				rx = GetUpAngleBetweenPoints(x, y, z, px, py, pz - 0.843);
				//rx = GetUpAngleBetweenPoints(x, y, z, px, py, pz);

				if (FireHose[id][E_FIREHOSE_OBJ_SEGS][next] != -1 && IsValidDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][next]))
				{
					DestroyDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][next]);
				}

				FireHose[id][E_FIREHOSE_OBJ_SEGS][next] = CreateDynamicObject(HOSE_SEG_MODEL, newx, newy, newz, rx, 0.0, -rz, -1, -1, -1, 200.0, 200.0, -1, -1); // Priority: -1
				// FireHose[id][E_FIREHOSE_OBJ_LABELS][FireHose[id][E_FIREHOSE_SEG_INDEX]] = CreateDynamic3DTextLabel("x", -1, px, py, pz, 15.0);

				FireHose[id][E_FIREHOSE_SEG_INDEX] = next;
				FireHose[id][E_FIREHOSE_NEEDS_UPDATE] = true;
				ApplyAnimation(playerid, "CHAINSAW", "csaw_part", 0.1, false, false, false, true, 1, true);
			}
		}
		else if (dist < HOSE_SEG_LENGTH)
		{
			if (previous < 1)
			{
				DeleteHose(id);
				return 1;
			}

			// Delete the previous one (current)
			if (FireHose[id][E_FIREHOSE_OBJ_SEGS][current] != -1 && IsValidDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][current]))
			{
				DestroyDynamicObject(FireHose[id][E_FIREHOSE_OBJ_SEGS][current]);
			}

			FireHose[id][E_FIREHOSE_OBJ_SEGS][current] = -1;
			FireHose[id][E_FIREHOSE_SEG_INDEX] = previous;
			ApplyAnimation(playerid, "CHAINSAW", "csaw_part", 0.1, false, false, false, true, 1, true);
		}
	}
	else
	{
		GetVehicleRelativePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z, offsetx, (LINE_OFFSET_Y + HOSE_SEG_LENGTH), LINE_OFFSET_Z);

		if (GetPlayerDistanceToPoint2D(playerid, x, y) < 0.5)
		{
			new Float:facing, Float:px, Float:py, Float:pz;

			GetVehicleRelativePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z, offsetx, LINE_OFFSET_Y, LINE_OFFSET_Z);
			GetPlayerRelativePos(playerid, px, py, pz, 0.2, 0.5, 0.0);
			facing = GetAngleBetweenPoints(x, y, px, py);

			FireHose[id][E_FIREHOSE_OBJ_SEGS][0] = CreateDynamicObject(HOSE_SEG_MODEL, x, y, z, 0.0, 0.0, -facing, -1, -1, -1, 200.0, 200.0, -1, -1); // Priority: -1
			FireHose[id][E_FIREHOSE_INITIALIZED] = true;
			FireHose[id][E_FIREHOSE_SEG_INDEX] = 0;

			UpdatePlayerFirehose(playerid);
		}
	}

	return 1;
}


stock GetClosestFirehosePoint(playerid, &vehicleid, &lineindex)
{
	new Float:hlx, Float:hly, Float:hlz;
	new Float:hrx, Float:hry, Float:hrz;
	new Float:hldist, Float:hrdist;

    new Float:x, Float:y, Float:z, world = GetPlayerVirtualWorld(playerid);
	new Float:current, Float:last = 2.5; // 2.5 radius for fire hoses

	vehicleid = INVALID_VEHICLE_ID;
	new current_index = 0;

	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
	{
		if (GetVehicleModel(i) != 407) continue;
		if (GetVehicleVirtualWorld(i) != world) continue;
		
		GetVehiclePos(i, x, y, z);
		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 7.5) continue;

		GetVehicleRelativePos(i, hlx, hly, hlz, -ENGINE_OFFSET_X, ENGINE_OFFSET_Y, ENGINE_OFFSET_Z);
		GetVehicleRelativePos(i, hrx, hry, hrz, ENGINE_OFFSET_X, ENGINE_OFFSET_Y, ENGINE_OFFSET_Z);

		hldist = GetPlayerDistanceFromPoint(playerid, hlx, hly, hlz);
		hrdist = GetPlayerDistanceFromPoint(playerid, hrx, hry, hrz);
		
		if (hldist < hrdist)
		{
			current_index = 0;
			current = hldist;
		}
		else
		{
			current_index = 1;
			current = hrdist;
		}

		if (current < last)
		{
			vehicleid = i;
			lineindex = current_index;
			last = current;
		}
	}
}

static UpdatePlayerFirehose(playerid)
{
	if (!PlayerVar[playerid][E_PLAYER_USING_HOSE])
	{
		RemovePlayerAttachedObject(playerid, 7);
		RemovePlayerAttachedObject(playerid, 9);

		ClearAnimations(playerid, 1);
		ApplyAnimation(playerid, "PED", "IDLE_STANCE", 4.0, 0, 0, 0, 0, 1, 1);
		ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 1, 1);
		ApplyAnimation(playerid, "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1, 1);

		PlayerVar[playerid][E_PLAYER_USING_HOSE] = false;
		PlayerVar[playerid][E_PLAYER_HOSE_INDEX] = -1;

		return 0;
	}

	new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];

	ApplyAnimation(playerid, "CHAINSAW", "csaw_part", 4.1, false, false, false, true, 1, true);

	if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	{
		SetPlayerAttachedObject(playerid, 9, HOSE_END_MODEL_BIG, 6, -0.577000,-0.055999,-1.123001,5.000001,-5.590019,-86.790077,1.000000,1.000000,1.000000);
		if (FireHose[id][E_FIREHOSE_ON])
		{
			SetPlayerAttachedObject(playerid, 7, 18687, 6, 0.047, 1.151, -1.062, 36.0, 10.60, -47.40, 1.00, 1.50, 1.00);
			SetPlayerAttachedObject(playerid,8,18747,6,3.681004,2.814002,-1.256997,0.000000,0.000000,-50.799995,0.361000,1.335000,1.000000);
		}
	}	
	else
	{
		RemovePlayerAttachedObject(playerid, 8);
		SetPlayerAttachedObject(playerid, 9, HOSE_END_MODEL, 6, -0.69, -0.17, -0.44, 0.00, -7.19, -89.09, 1.00, 1.00, 1.00);
		if (FireHose[id][E_FIREHOSE_ON]) SetPlayerAttachedObject(playerid, 7, 18687, 6, 0.26, 1.11, -1.07, 36.0, 0.000000, -45.0, 1.00, 3.0, 1.00);
	}

	if (!FireHose[id][E_FIREHOSE_ON])
	{
		RemovePlayerAttachedObject(playerid, 7);
		RemovePlayerAttachedObject(playerid, 8);
	}

	return 1;
}

hook OnPlayerStreamIn(playerid, forplayerid) 
{
    if (PlayerVar[playerid][E_PLAYER_USING_HOSE])
	{
		ApplyAnimation(playerid, "CHAINSAW", "csaw_part", 4.1, false, false, false, true, 1, true);
	}

    return 1;
}

CMD:firehose(playerid, params[])
{
	/*
	new option[12];

	if (sscanf(params, "s[8]", action, option) || !strlen(action))
	    return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/hose [get/put/stop/start]");
	*/

	if (PlayerVar[playerid][E_PLAYER_USING_HOSE])
	{
		DeleteHose(PlayerVar[playerid][E_PLAYER_HOSE_INDEX]);
		return true;
	}

	if (!IsPlayerInMedicFaction(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not authorized to use a fire hose."); 
	}

	if (IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're must be on foot to use a fire hose."); 
	}

	new vehicleid, lineindex;
	GetClosestFirehosePoint(playerid, vehicleid, lineindex);

	if (vehicleid == INVALID_VEHICLE_ID)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a valid fire hose point."); 
	}

	new id = -1;

    for (new i = 0; i < MAX_HOSES; i ++)
    {
		if (FireHose[i][E_FIREHOSE_EXISTS])
		{
			if (FireHose[i][E_FIREHOSE_VEHICLE] == vehicleid && FireHose[i][E_FIREHOSE_LINE_INDEX] == lineindex)
			{
				id = i;
				break;
			}
		}
    }

	if (id == -1)
	{
		// Creating a new hose
		id = CreateHose(playerid, vehicleid, lineindex);
		if (id == -1) return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("The maximum number of hoses (%d) has been reached.", MAX_HOSES)); 

		PlayerVar[playerid][E_PLAYER_USING_HOSE] = true;
		PlayerVar[playerid][E_PLAYER_HOSE_INDEX] = id;

		// Put the player to the hose position
		new Float:x, Float:y, Float:z, Float:rz, Float:zz;
		new Float:offsetx = LINE_OFFSET_X;
		if (FireHose[id][E_FIREHOSE_LINE_INDEX] == 0) offsetx = -LINE_OFFSET_X;

		GetPlayerPos(playerid, x, y, zz);
		GetVehicleZAngle(FireHose[id][E_FIREHOSE_VEHICLE], rz);
		GetVehicleRelativePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z, offsetx, LINE_OFFSET_Y + HOSE_SEG_LENGTH, LINE_OFFSET_Z);
		SetPlayerPos(playerid, x, y, zz);
		SetPlayerFacingAngle(playerid, rz);
	}
	else
	{
		// Just kill it.
		DeleteHose(id);
	}

	return true;
}

CMD:hose(playerid, params[])
{
	return cmd_firehose(playerid, params);
}

/*
static nozzleobj;

CMD:nozzle(playerid, params[])
{
	if (nozzleobj) DestroyObject(nozzleobj);
	new Float:x, Float:y, Float:z;

	if (sscanf(params, "fff", x, y, z)) return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/nozzle x y z");
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	nozzleobj = CreateObject(HOSE_END_MODEL, px, py, pz, 0.0, 0.0, 0.0); // Priority: 1
	AttachObjectToPlayer(nozzleobj, playerid, x, y, z, 0.0, 0.0, 0.0);

	return true;
}
*/

static ResyncPlayerToHose(playerid, bool:noupdate=false)
{
	new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];
	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:zz;

	if (FireHose[id][E_FIREHOSE_INITIALIZED])
	{
		GetPlayerPos(playerid, x, y, zz);
		GetDynObjRelativePos(FireHose[id][E_FIREHOSE_OBJ_SEGS][FireHose[id][E_FIREHOSE_SEG_INDEX]], x, y, z, -0.2, HOSE_SEG_LENGTH + 0.6, 0.0);
		GetDynamicObjectRot(FireHose[id][E_FIREHOSE_OBJ_SEGS][FireHose[id][E_FIREHOSE_SEG_INDEX]], rx, ry, rz);
		SetPlayerPos(playerid, x, y, zz);
		SetPlayerFacingAngle(playerid, rz);
		if (!noupdate) UpdatePlayerFirehose(playerid);
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (PlayerVar[playerid][E_PLAYER_USING_HOSE] && newstate != PLAYER_STATE_ONFOOT)
    {
		new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];
		DeleteHose(id);
    }

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PlayerVar[playerid][E_PLAYER_USING_HOSE] && !(newkeys & KEY_CTRL_BACK) && !(newkeys & KEY_CROUCH) && !(newkeys & KEY_SPRINT) && !(newkeys & KEY_ACTION) && newkeys)
	{
		ClearAnimations(playerid, 1);
		ResyncPlayerToHose(playerid);
		return 1;
	}

    if (PlayerVar[playerid][E_PLAYER_USING_HOSE] && PRESSED(KEY_CTRL_BACK))
    {
		new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];

        if (FireHose[id][E_FIREHOSE_INITIALIZED])
		{
			// Turn on off
			FireHose[id][E_FIREHOSE_ON] = !FireHose[id][E_FIREHOSE_ON];
			UpdatePlayerFirehose(playerid);
		}
		else
		{
			// Disconnect
			DeleteHose(id);
		}
    }

	return 1;
}

//hook OnPlayerDisconnect(playerid, reason)
hook SOLS_OnCloseConnection(playerid, reason)
{
    if (PlayerVar[playerid][E_PLAYER_USING_HOSE])
    {
		new id = PlayerVar[playerid][E_PLAYER_HOSE_INDEX];
		DeleteHose(id);
    }

    return 1;
}

/*
timer UpdateHoseStreamer[2000]()
{
	new Float:x, Float:y, Float:z;

	for (new i = 0; i < MAX_HOSES; i ++)
    {
	    if (!FireHose[i][E_FIREHOSE_EXISTS]) continue;

		if (FireHose[id][E_FIREHOSE_NEEDS_UPDATE])
		{
			GetVehiclePos(FireHose[id][E_FIREHOSE_VEHICLE], x, y, z);

			foreach(new i: Player)
			{
				if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
				{
					Streamer_Update(i, STREAMER_TYPE_OBJECT);
				}
			}

			FireHose[id][E_FIREHOSE_NEEDS_UPDATE] = false;
			break; // Only do it for one hose
		}
	}
}
*/