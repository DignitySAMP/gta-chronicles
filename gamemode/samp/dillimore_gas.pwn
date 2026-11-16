//------------------------------------------------------------------------------
// This script creates the edited Dillimore Gas Station Building objects and removes the existing GTASA building objects.
// By Matite in March 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    // Remove default GTASA Dillimore Gas Station Building exterior, interior and LOD map objects for the player
	RemoveBuildingForPlayer(playerid, 12853, 666.711, -565.133, 17.3359, 250.0); 	// Building exterior
	RemoveBuildingForPlayer(playerid, 12854, 666.492, -571.18, 17.3125, 250.0); 	// Building interior
	RemoveBuildingForPlayer(playerid, 13245, 666.711, -565.133, 17.3359, 250.0); 	// LOD
}

static CreateMapObjects()
{
    // Create the Dillimore Gas Station exterior object
    new DillimoreGasObject1 = CreateDynamicObject(19876, 666.711, -565.133, 17.3359, 0, 0, 0, -1, 0, -1, 600.0, 600.0);

    // Display information in the Server Console
    printf("  |--  Dillimore Gas Station exterior object created: %d", DillimoreGasObject1);

    // Create the Dillimore Gas Station interior object
    new DillimoreGasObject2 = CreateDynamicObject(19877, 666.492, -571.18, 17.3125, 0, 0, 0, -1, 0, -1, 600.0, 600.0);

    // Display information in the Server Console
    printf("  |--  Dillimore Gas Station interior object created: %d", DillimoreGasObject2);
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

CMD:dgs(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle
    SetPlayerPos(playerid, 658.37, -573.90, 16.8);
    SetPlayerFacingAngle(playerid, 280);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~Dillimore Gas Station!", 3000, 3);

    // Exit here
    return 1;
}