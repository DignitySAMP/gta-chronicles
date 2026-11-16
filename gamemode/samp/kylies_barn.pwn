// ------------------------------------------------------------------------------
// This script creates the repaired Kylie's Barn Building object and removes
// the existing GTASA barn object (normally this object has some collision
// bugs that prevent the player from moving about inside it).
// By Matite in March 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    // Remove default GTASA Kylie's Barn object for the player
	RemoveBuildingForPlayer(playerid, 14871, 286.188, 307.609, 1002.01, 250.0); 	// Barn
}

static CreateMapObjects()
{
    // Create Kylie's Barn repaired object
    new KyliesBarnObject1 = CreateDynamicObject(19881, 286.188, 307.609, 1002.01, 0, 0, 0, -1, 3, -1, 300.0);
    printf("  |--  Kylie's Barn object created: %d", KyliesBarnObject1);
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

CMD:kb(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior
    SetPlayerInterior(playerid, 3);

    // Set player position and facing angle
    SOLS_SetPosWithFade(playerid, 292.03, 309.82, 999.55);
    SetPlayerFacingAngle(playerid, 88);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~Kylie's Barn!", 3000, 3);

    // Exit here
    return 1;
}