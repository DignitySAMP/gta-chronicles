// ------------------------------------------------------------------------------
// Fixes a LOD trailer in the desert

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    // Remove default GTASA Kylie's Barn object for the player
	RemoveBuildingForPlayer(playerid, 3343, -640.4766, 2717.1953, 71.2656, 0.25);
}

static CreateMapObjects()
{
    // Create the new one
    CreateDynamicObject(3168, -640.50, 2717.20, 71.27,   0.00, 0.00, 41.58, -1, 0, -1, 300.0, 300.0);
}

hook OnPlayerConnect(playerid)
{
    RemoveBuildingsForPlayer(playerid);
    return 1;
}

hook OnGameModeInit()
{
    CreateMapObjects();
    return 1;
}