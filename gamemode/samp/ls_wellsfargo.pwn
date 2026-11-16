//------------------------------------------------------------------------------
// This script creates the edited LS Wells Fargo Building object and removes the existing GTASA building object.
// By Matite in March 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    RemoveBuildingForPlayer(playerid, 4007, 1421.38, -1477.6, 42.2031, 250.0); 	// Building
	RemoveBuildingForPlayer(playerid, 4009, 1421.38, -1477.6, 42.2031, 250.0); 	// LOD
}

static CreateMapObjects()
{
    // Create the LSWellsFargoObject1 object
    new LSWellsFargoObject1 = CreateObject(19879, 1421.38, -1477.6, 42.2031, 0, 0, 0, 900.0);
    printf("  |--  LS Wells Fargo Building object created: %d", LSWellsFargoObject1);
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

CMD:lswf(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle
    SetPlayerPos(playerid, 1448.43, -1468.28, 13.82);
    SetPlayerFacingAngle(playerid, 92);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~LS Wells Fargo!", 3000, 3);

    // Exit here
    return 1;
}