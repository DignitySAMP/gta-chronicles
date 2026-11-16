//------------------------------------------------------------------------------
// This script creates the new SF Building 1 object and removes the existing GTASA building object.
// By Matite in February 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    RemoveBuildingForPlayer(playerid, 9510, -2719.02, 861.211, 72.1562, 250.0); // Building
    RemoveBuildingForPlayer(playerid, 9671, -2719.02, 861.211, 72.1562, 250.0); // LOD
    RemoveBuildingForPlayer(playerid, 715, -2693.24, 852.60, 71.74, 8.0); // Tree (casts a shadow inside)
}

static CreateMapObjects()
{
    // Create the SF Building 1 Land object
    new SFBuilding1Object1 = CreateDynamicObject(19600, -2719.02, 861.211, 72.1562, 0, 0, 0, -1, 0, -1, 600.0);
    printf("  |--  SF Building 1 Land object created: %d", SFBuilding1Object1);

    // Create the SF Building 1 Outside object
    new SFBuilding1Object2 = CreateDynamicObject(19598, -2719.02, 861.211, 72.1562, 0, 0, 0, -1, 0, -1, 600.0);
    printf("  |--  SF Building 1 Outside object created: %d", SFBuilding1Object2);
    
    // Create the SF Building 1 Inside object
    new SFBuilding1Object3 = CreateDynamicObject(19599, -2719.02, 861.211, 72.1562, 0, 0, 0, -1, 0, -1, 600.0);
    printf("  |--  SF Building 1 Inside object created: %d", SFBuilding1Object3);
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

CMD:sfb(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle
    SetPlayerPos(playerid, -2706.56, 870.91 + random(2), 71.86);
    SetPlayerFacingAngle(playerid, 180);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~SF Building!", 3000, 3);

    // Exit here
    return 1;
}