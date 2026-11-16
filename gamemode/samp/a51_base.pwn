//------------------------------------------------------------------------------
// This script removes the existing GTASA Area 51 (69) land section, fence and buildings. 
// It then replaces the land section and buildings with the new enterable versions.
// By Matite in March 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

static RemoveBuildingsForPlayer(playerid)
{
    // Remove default GTASA Area 51 (69) land and buildings for the player
	RemoveBuildingForPlayer(playerid, 16203, 199.344, 1943.79, 18.2031, 250.0); 	// Land
	RemoveBuildingForPlayer(playerid, 16590, 199.344, 1943.79, 18.2031, 250.0); 	// Land LOD
	RemoveBuildingForPlayer(playerid, 16323, 199.336, 1943.88, 18.2031, 250.0); 	// Buildings
    RemoveBuildingForPlayer(playerid, 16619, 199.336, 1943.88, 18.2031, 250.0); 	// Buildings LOD
    RemoveBuildingForPlayer(playerid, 1697, 228.797, 1835.34, 23.2344, 250.0); 		// Solar Panels (they poke through the roof inside)
    RemoveBuildingForPlayer(playerid, 16094, 191.141, 1870.04, 21.4766, 250.0); 	// Outer Fence
}

static CreateMapObjects()
{
    // Create the A51 Land object
    new A51LandObject = CreateObject(11692, 199.344, 1943.79, 18.2031, 0, 0, 0, 900.0);

    // Display information in the Server Console
    printf("  |--  Area 51 (69) Land object created: %d", A51LandObject);
    
    // Create the A51 Fence object
    new A51Fence = CreateDynamicObject(19312, 191.141, 1870.04, 21.4766, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    
    // Display information in the Server Console
    printf("  |--  Area 51 (69) Fence object created: %d", A51Fence);
    
    // Create the A51 Building objects
    new A51Buildings[7];
    A51Buildings[0] = CreateDynamicObject(19905, 206.798950, 1931.643432, 16.450595, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[1] = CreateDynamicObject(19905, 188.208908, 1835.033569, 16.450595, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[2] = CreateDynamicObject(19905, 230.378875, 1835.033569, 16.450595, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[3] = CreateDynamicObject(19907, 142.013977, 1902.538085, 17.633581, 0, 0, 270.0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[4] = CreateDynamicObject(19907, 146.854003, 1846.008056, 16.533580, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[5] = CreateDynamicObject(19909, 137.900390, 1875.024291, 16.836734, 0, 0, 270.0, -1, 0, -1, 600.0, 600.0);
    A51Buildings[6] = CreateDynamicObject(19909, 118.170387, 1875.184326, 16.846735, 0, 0, 0, -1, 0, -1, 600.0, 600.0);
    
    // Display information in the Server Console
    printf("  |--  Area 51 (69) Building objects created (%d)", sizeof(A51Buildings));
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

CMD:a51(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior (outside)
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle (outside the northern gate)
    SetPlayerPos(playerid, 135.20, 1948.51, 19.74);
    SetPlayerFacingAngle(playerid, 180);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~Area 51 (69) Base!", 3000, 3);

    // Exit here
    return 1;
}