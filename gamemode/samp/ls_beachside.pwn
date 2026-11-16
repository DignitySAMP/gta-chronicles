//------------------------------------------------------------------------------
// This script creates the new LS BeachSide building object, removes the existing GTASA building object and adds the new car park object.
// By Matite in February 2015, adapted for GTAC:RP by Spooky.

#include <YSI_Coding\y_hooks>

#define GROUND_Z_COORD      (18.755348)     // (33.825077)
#define X_ELEVATOR_POS      (287.942413)
#define Y_ELEVATOR_POS      (-1609.341064)

static Float:FloorZOffsets[14] =
{
    0.0, 		// Car Park
    15.069729,  // Ground Floor
    29.130733,	// First Floor
    33.630733,  // Second Floor = 29.130733 + 4.5
    38.130733,  // Third Floor = 33.630733 + 4.5
    42.630733,  // Fourth Floor = 38.130733 + 4.5
    47.130733,  // Fifth Floor = 42.630733 + 4.5
    51.630733,  // Sixth Floor = 47.130733 + 4.5
    56.130733,  // Seventh Floor = 51.630733 + 4.5
    60.630733,  // Eighth Floor = 56.130733 + 4.5
    65.130733,  // Ninth Floor = 60.630733 + 4.5
    69.630733,  // Tenth Floor = 65.130733 + 4.5
    74.130733,  // Eleventh Floor = 69.630733 + 4.5
    78.630733,  // Twelfth Floor = 74.130733 + 4.5
};

static Obj_Elevator, Obj_FloorDoors[14][2];

static Float:GetDoorsZCoordForFloor(floorid)
{
    // Return Z height value
	return (GROUND_Z_COORD + FloorZOffsets[floorid]);
}

static RemoveBuildingsForPlayer(playerid)
{
    // Remove the lamp post at the underground car park entrance
    RemoveBuildingForPlayer(playerid, 1226, 265.481, -1581.1, 32.9311, 5.0);
    
    // Remove the night lights object (must be removed to also remove any
    // occulsion zones inside the building)
    RemoveBuildingForPlayer(playerid, 6518, 280.297, -1606.2, 72.3984, 250.0);
}

static CreateMapObjects()
{
    // Just create the elevator to fill the at the bottom.
    Obj_Elevator = CreateDynamicObject(18755, X_ELEVATOR_POS, Y_ELEVATOR_POS, GROUND_Z_COORD, 0.000000, 0.000000, 80.000000, -1, 0, -1, 300.0, 300.0);
    printf("LS BeachSide Elevator Object created: %d", Obj_Elevator);

    // And then the floor door objects to stop people falling down the elevator shaft
	for (new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    Obj_FloorDoors[i][0] = CreateDynamicObject(18757, X_ELEVATOR_POS, Y_ELEVATOR_POS - 0.245, GetDoorsZCoordForFloor(i) + 0.05, 0.000000, 0.000000, 80.000000);
		Obj_FloorDoors[i][1] = CreateDynamicObject(18756, X_ELEVATOR_POS, Y_ELEVATOR_POS - 0.245, GetDoorsZCoordForFloor(i) + 0.05, 0.000000, 0.000000, 80.000000);
    }
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

CMD:lsb(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

     // Set the interior
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle
    SetPlayerPos(playerid, 289.81 + random(2), -1630.65 + random(2), 34.32);
    SetPlayerFacingAngle(playerid, 10);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~LS BeachSide!", 3000, 3);

    // Exit here
    return 1;
}

#undef GROUND_Z_COORD
#undef X_ELEVATOR_POS
#undef Y_ELEVATOR_POS