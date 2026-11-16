//------------------------------------------------------------------------------
// This script creates the new LS Apartments 1 building object, removes the existing GTASA building object and adds the new car park object.
// By Matite in February 2015, adapted for GTAC:RP by Spooky.
// Uses edit of original object by Spooky

#include <YSI_Coding\y_hooks>

#define GROUND_Z_COORD      (20.879316)
#define X_ELEVATOR_POS      (1181.622924)
#define Y_ELEVATOR_POS      (-1180.554687)

#define LSAPT1_MODEL (-5510)

static Float:FloorZOffsets[11] =
{
    0.0, 		// Car Park
    13.604544,	// Ground Floor
    18.808519,	// First Floor = 13.604544 + 5.203975
    24.012494,  // Second Floor = 18.808519 + 5.203975
    29.216469,  // Third Floor = 24.012494 + 5.203975
    34.420444,  // Fourth Floor = 29.216469 + 5.203975
    39.624419,  // Fifth Floor = 34.420444 + 5.203975
    44.828394,  // Sixth Floor = 39.624419 + 5.203975
    50.032369,  // Seventh Floor = 44.828394 + 5.203975
    55.236344,  // Eighth Floor = 50.032369 + 5.203975
    60.440319   // Ninth Floor = 55.236344 + 5.203975
};

static Obj_Elevator, Obj_FloorDoors[11][2];

static Float:GetDoorsZCoordForFloor(floorid)
{
    // Return Z height value
	return (GROUND_Z_COORD + FloorZOffsets[floorid]);
}

static RemoveBuildingsForPlayer(playerid)
{
    RemoveBuildingForPlayer(playerid, 5766, 1160.96, -1180.58, 70.4141, 250.0); // Awning shadows
	RemoveBuildingForPlayer(playerid, 5767, 1160.96, -1180.58, 70.4141, 250.0); // Building
	RemoveBuildingForPlayer(playerid, 5964, 1160.96, -1180.58, 70.4141, 250.0); // LOD
}

static CreateMapObjects()
{
    // Create the LS Apartments 1 Building object
    new LSApartments1Object = CreateObject(LSAPT1_MODEL, 1160.96, -1180.58, 70.4141, 0, 0, 0, 900.0);

    // Display information in the Server Console
    printf("  |--  LS Apartments 1 Building object created: %d", LSApartments1Object);
    
    // Create the LS Apartments 1 Car Park object
    new LSApartments1CPObject = CreateObject(19798, 1160.96, -1180.58, 20.4141, 0, 0, 0);

    // Display information in the Server Console
    printf("  |--  LS Apartments 1 Car Park object created: %d", LSApartments1CPObject);


    // Just create the elevator to fill the void at the bottom.
    Obj_Elevator = CreateDynamicObject(18755, X_ELEVATOR_POS, Y_ELEVATOR_POS, GROUND_Z_COORD, 0.000000, 0.000000, 0.000000, -1, 0, -1, 300.0, 300.0);
    printf("LS Apartments 1 Elevator Object created: %d", Obj_Elevator);

    // And then the floor door objects to stop people falling down the elevator shaft
	for (new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    Obj_FloorDoors[i][0] = CreateDynamicObject(18757, X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(i) + 0.05, 0.000000, 0.000000, 0.000000);
		Obj_FloorDoors[i][1] = CreateDynamicObject(18756, X_ELEVATOR_POS - 0.245, Y_ELEVATOR_POS, GetDoorsZCoordForFloor(i) + 0.05, 0.000000, 0.000000, 0.000000);
    }
}

hook OnPlayerConnect(playerid)
{
    RemoveBuildingsForPlayer(playerid);
    return 1;
}

hook OnGameModeInit()
{
    AddSimpleModel(-1, 19595, LSAPT1_MODEL, "samp/captower.dff", "samp/LSAppartments1.txd");
    CreateMapObjects();
    return 1;
}

CMD:lsa(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    // Set the interior
    SetPlayerInterior(playerid, 0);

    // Set player position and facing angle
    SetPlayerPos(playerid, 1131.07 + random(3), -1180.72 + random(2), 33.32);
    SetPlayerFacingAngle(playerid, 270);

    // Fix camera position after teleporting
    SetCameraBehindPlayer(playerid);

    // Send a gametext message to the player
    GameTextForPlayer(playerid, "~b~~h~LS Apartments 1!", 3000, 3);

    // Exit here
    return 1;
}

#undef GROUND_Z_COORD
#undef X_ELEVATOR_POS
#undef Y_ELEVATOR_POS