#include <YSI_Coding\y_hooks>

//------------------------------------------------------------------------------
// Adds "Hogan's Alley" killhouse from GTA Vice City
// Converted to GTAC:RP by Ryhes and Spooky

#define HOGAN_X 200.0
#define HOGAN_Y -200.0
#define HOGAN_Z 900.0

#define HOGAN_SPAWN_X 210.4671
#define HOGAN_SPAWN_Y -218.8558
#define HOGAN_SPAWN_Z 894.8125
#define HOGAN_SPAWN_A 0.0

#define HOGAN_INT 1
#define HOGAN_WORLD -1
#define HOGAN_SD 300.0


static STREAMER_TAG_AREA:HOGANS_AREA;

static enum E_HOGAN_RESPAWN_POINT
{
	Float:E_HOGAN_RESPAWN_POINT_X,
	Float:E_HOGAN_RESPAWN_POINT_Y,
	Float:E_HOGAN_RESPAWN_POINT_Z,
	Float:E_HOGAN_RESPAWN_POINT_A
}

static const HoganRespawnPoint[][E_HOGAN_RESPAWN_POINT] =
{
	{ 193.1555,-191.3766,894.8125,135.1106 },
	{ 195.4976,-181.0983,894.8125, 29.8294 },
	{ 213.5285,-194.4431,894.8188,178.5393 },
	{ 186.0925,-172.7752,894.8125,227.2320 },
	{ 204.7197,-192.1935,894.8125,178.6888 }
};

static AddModels()
{
	// Models for "Hogan's Alley"
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, VC_HOGANS_ALLEY, "vc/hogans_alley.dff", "vc/hogans_alley.txd");
}

static CreateObjects()
{
	HOGANS_AREA = CreateDynamicSphere(HOGAN_X, HOGAN_Y, HOGAN_Z, 125.0, HOGAN_WORLD, HOGAN_INT);
	CreateDynamicObject(VC_HOGANS_ALLEY, HOGAN_X, HOGAN_Y, HOGAN_Z, 0.000000, 0.000000, 0.000000, HOGAN_WORLD, HOGAN_INT, -1, HOGAN_SD, HOGAN_SD);
}

SetPlayerInHogansAlley(playerid, bool:isrespawn=false)
{
	SetPlayerInterior(playerid, HOGAN_INT);
	SetCharacterHealth(playerid, 100.0);

	if (isrespawn)
	{
		new i = random(sizeof(HoganRespawnPoint));
		SOLS_SetPosWithFade(playerid, HoganRespawnPoint[i][E_HOGAN_RESPAWN_POINT_X], HoganRespawnPoint[i][E_HOGAN_RESPAWN_POINT_Y], HoganRespawnPoint[i][E_HOGAN_RESPAWN_POINT_Z], "Hogan's Alley");
		SetPlayerFacingAngle(playerid, HoganRespawnPoint[i][E_HOGAN_RESPAWN_POINT_A]);
	}
	else
	{	
    	SOLS_SetPosWithFade(playerid, HOGAN_SPAWN_X, HOGAN_SPAWN_Y, HOGAN_SPAWN_Z, "Hogan's Alley");
    	SetPlayerFacingAngle(playerid, 0.0);
	}

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);
}

IsPlayerInHogansAlley(playerid)
{
	return PlayerVar[playerid][E_PLAYER_IN_HOGANS_ALLEY] && IsPlayerInDynamicArea(playerid, HOGANS_AREA);
}

hook OnGameModeInit()
{
	AddModels();
	CreateObjects();

	printf("  |--  Created \"Hogan's Alley\" from GTA Vice City, converted by Ryhes.");
	return 1;
}

hook OnPlayerConnect(playerid)
{
	// idk, something soon
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (areaid == HOGANS_AREA)
	{
		SendClientMessage(playerid, COLOR_INFO, "You are no longer in \"Hogan's Alley\" and can now die normally again.");
		PlayerVar[playerid][E_PLAYER_IN_HOGANS_ALLEY] = false;
	}

	return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (areaid == HOGANS_AREA)
	{
		SendClientMessage(playerid, COLOR_INFO, "You are now in \"Hogan's Alley\", you will be respawned here if you die.");
		PlayerVar[playerid][E_PLAYER_IN_HOGANS_ALLEY] = true;
	}
    
    return 1;
}

CMD:hogansalley(playerid)
{
	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;
	
	SetPlayerInHogansAlley(playerid);
    return 1;
}