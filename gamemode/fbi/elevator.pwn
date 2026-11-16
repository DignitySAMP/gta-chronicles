// Original elevator code by Zamaroht in 2010


// -----------------------------------------------------------------------------
// Includes
// --------
#include <YSI_Coding\y_hooks>


// -----------------------------------------------------------------------------
// Defines
// -------

// Elevator Offsets
#define FBI_ELEV_X (FBI_BUILD_X - 14.486)
#define FBI_ELEV_Y (FBI_BUILD_Y + 2.801)
#define FBI_ELEV_Z (FBI_BUILD_Z)
#define FBI_ELEV_RZ 180.0

// Movement speed of the elevator
#define FBI_ELEVATOR_SPEED      (5.0)

// Movement speed of the doors
#define FBI_DOORS_SPEED         (4.0)

// Time in ms that the elevator will wait in each floor before continuing with the queue...
// be sure to give enough time for doors to open
#define FBI_ELEVATOR_WAIT_TIME  (5000)  

// Position defines
#define FBI_DOOR_MOVE (1.71)
#define FBI_DOOR_OFFSET (0.21)

#define FBI_USE_LABEL_X 1.7
#define FBI_USE_LABEL_Y 1.85
#define FBI_USE_LABEL_Z -0.35

#define FBI_FLOOR_LABEL_X 2.2
#define FBI_FLOOR_LABEL_Y -2.8
#define FBI_FLOOR_LABEL_Z -0.35

// Elevator state defines
#define FBI_ELEVATOR_STATE_IDLE     (0)
#define FBI_ELEVATOR_STATE_WAITING  (1)
#define FBI_ELEVATOR_STATE_MOVING   (2)

// Invalid floor define
#define FBI_INVALID_FLOOR           (-1)

// -----------------------------------------------------------------------------
// Constants
// ---------

#define FBI_MAX_FLOORS 2

// Elevator floor names for the 3D text labels
static FloorNames[FBI_MAX_FLOORS][] =
{
	"1. Main Lobby",
	"4. Federal Bureau of Investigation"
};

// Elevator floor Z heights
static Float:FloorPositions[FBI_MAX_FLOORS] =
{
    3.186, // Lobby
	31.434 // Floor 4
};

// ------------------------------------------------------------------------------
// Variables
// ---------

// Stores the created object numbers of the elevator, the elevator doors and
// the elevator floor doors so they can be destroyed when the filterscript
// is unloaded
static Obj_Elevator, Obj_ElevatorDoors[2], Obj_FloorDoors[FBI_MAX_FLOORS][2];
	
// Stores a reference to the 3D text labels used on each floor and inside the
// elevator itself so they can be detroyed when the filterscript is unloaded
static DynamicText3D:Label_Elevator, DynamicText3D:Label_Floors[FBI_MAX_FLOORS];

// Stores the current state of the elevator (ie ELEVATOR_STATE_IDLE,
// ELEVATOR_STATE_WAITING or ELEVATOR_STATE_MOVING)
static ElevatorState;

// Stores the current floor the elevator is on or heading to... if the value is
// ELEVATOR_STATE_IDLE or ELEVATOR_STATE_WAITING this is the current floor. If
// the value is ELEVATOR_STATE_MOVING then it is the floor it's moving to
static ElevatorFloor;  

// Stores the elevator queue for each floor
static ElevatorQueue[FBI_MAX_FLOORS];

// Stores who requested the floor for the elevator queue...
// FloorRequestedBy[floor_id] = playerid;  (stores who requested which floor)
static	FloorRequestedBy[FBI_MAX_FLOORS];

// Used for a timer that makes the elevator move faster after players start
// surfing the object
static ElevatorBoostTimer;

// ------------------------------------------------------------------------------
// Function Forwards
// -----------------

// Public:
forward CallElevator(playerid, floorid, bool:showmsg);    // You can use INVALID_PLAYER_ID too.
forward ShowElevatorDialog(playerid);
forward Elevator_Boost(floorid);
forward Elevator_TurnToIdle();

// ------------------------------------------------------------------------------
// Callbacks
// ---------

hook OnGameModeInit()
{
    // Display information in the Server Console
	print("\n");
	print("  |---------------------------------------------------");
	print("  |--- FBI Elevator Loaded");
	print("  |---------------------------------------------------");

    // Reset the elevator queue
	ResetElevatorQueue();

	// Create the elevator object, the elevator doors and the floor doors
	Elevator_Initialize();

	// Exit here
	return 1;
}

hook OnDynamicObjectMoved(STREAMER_TAG_OBJECT:objectid)
{
	// Create variables
    new Float:x, Float:y, Float:z;
    new Float:dx, Float:dy, Float:dz;
    
    // Loop
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    // Check if the object that moved was one of the elevator floor doors
		if(objectid == Obj_FloorDoors[i][0])
		{
		    GetDynamicObjectPos(Obj_FloorDoors[i][0], x, y, z);
		    GetDoorsXYZCoordForFloor(i, dx, dy, dz);

            // Some floor doors have shut, move the elevator to next floor in queue:
            if (x > dx - 0.5)
		    {
				if (ElevatorQueue[0] >= 0) Elevator_MoveToFloor(ElevatorQueue[0]);
				RemoveFirstQueueFloor();
			}
		}
	}

	if(objectid == Obj_Elevator)   // The elevator reached the specified floor.
	{
	    KillTimer(ElevatorBoostTimer);  // Kills the timer, in case the elevator reached the floor before boost.

	    FloorRequestedBy[ElevatorFloor] = INVALID_PLAYER_ID;

	    Elevator_OpenDoors();
	    Floor_OpenDoors(ElevatorFloor);

	    GetDynamicObjectPos(Obj_Elevator, x, y, z);

	    Label_Elevator	= CreateDynamic3DTextLabel("[Elevator]\n{DEDEDE}Press {FFFF00}~k~~VEHICLE_ENTER_EXIT~ {DEDEDE}to use.", 0x3479E3FF, x + FBI_USE_LABEL_X, y + FBI_USE_LABEL_Y, z + FBI_USE_LABEL_Z, 4.0, .testlos=1);

	    ElevatorState 	= FBI_ELEVATOR_STATE_WAITING;
	    SetTimer("Elevator_TurnToIdle", FBI_ELEVATOR_WAIT_TIME, 0);
	}

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Check if the player is not in a vehicle and pressed the conversation yes key (Y by default)
	if (newkeys & KEY_SECONDARY_ATTACK)
	{
        if (IsPlayerInAnyVehicle(playerid)) return 0;
        
        new Float:player_pos[3];
	    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);

        new Float:elev_pos[3];
	    GetDynamicObjectPos(Obj_Elevator, elev_pos[0], elev_pos[1], elev_pos[2]);

        // First check if they are inside the elevator itself
        if (player_pos[1] > (elev_pos[1] - 1.8) && player_pos[1] < (elev_pos[1] + 1.8) && player_pos[0] < (elev_pos[0] + 1.8) && player_pos[0] > (elev_pos[0] - 1.8))
	    {
	        // The player is using the button inside the elevator        
	        // Show the elevator dialog to the player
	        ShowElevatorDialog(playerid);
            return 1;
	    }

        // Next check if they are at one of the floors
        for (new i = 0; i < FBI_MAX_FLOORS; i ++)
        {
            GetDoorsXYZCoordForFloor(i, elev_pos[0], elev_pos[1], elev_pos[2]);
            if (IsPlayerInRangeOfPoint(playerid, 3.0, elev_pos[0] + FBI_FLOOR_LABEL_X, elev_pos[1] + FBI_FLOOR_LABEL_Y, elev_pos[2] + FBI_FLOOR_LABEL_Z))
            {
                CallElevator(playerid, i, true);
                return 1;
            }
        }
    }

    return 1;
}

// ------------------------ Functions ------------------------

static PlaySoundForPlayersInRange(soundid, Float:range, Float:x, Float:y, Float:z)
{
    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, range, x, y, z))
	    {
		    PlayerPlaySound(i, soundid, x, y, z);
	    }
    }
}


static Elevator_Initialize()
{
    // Create variables
	new string[128], Float:x, Float:y, Float:z;

	// Create the elevator and elevator door objects
	GetElevatorXYZCoordForFloor(0, x, y, z);

	Obj_Elevator 			= CreateDynamicObject(18755, x, y, z, 0.000000, 0.000000, FBI_ELEV_RZ);
	Obj_ElevatorDoors[0] 	= CreateDynamicObject(18757, x, y, z, 0.000000, 0.000000, FBI_ELEV_RZ);
	Obj_ElevatorDoors[1] 	= CreateDynamicObject(18756, x, y, z, 0.000000, 0.000000, FBI_ELEV_RZ);

    // Create the 3D text label for inside the elevator
	Label_Elevator = CreateDynamic3DTextLabel("[Elevator]\n{DEDEDE}Press {FFFF00}~k~~VEHICLE_ENTER_EXIT~ {DEDEDE}to use.", 0x3479E3FF, x + FBI_USE_LABEL_X, y + FBI_USE_LABEL_Y, z + FBI_USE_LABEL_Z, 4.0, .testlos=1);

	// Loop
	for (new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    GetDoorsXYZCoordForFloor(i, x, y, z);
	
	    // Create elevator floor door objects
	    Obj_FloorDoors[i][0] 	= CreateDynamicObject(18757, x, y, z, 0.000000, 0.000000, FBI_ELEV_RZ);
		Obj_FloorDoors[i][1] 	= CreateDynamicObject(18756, x, y, z, 0.000000, 0.000000, FBI_ELEV_RZ);

		// Format string for the floor 3D text label


		format(string, sizeof(string), "[%s]\n{DEDEDE}Press {FFFF00}~k~~VEHICLE_ENTER_EXIT~ {DEDEDE}to call.", FloorNames[i]);

		// Create floor label
		Label_Floors[i] = CreateDynamic3DTextLabel(string, 0x3479E3FF, x + FBI_FLOOR_LABEL_X, y + FBI_FLOOR_LABEL_Y, z + FBI_FLOOR_LABEL_Z, 10.5, .testlos=1);
	}

	// Open the car park floor doors and the elevator doors
	Floor_OpenDoors(0);
	Elevator_OpenDoors();

    // Exit here
	return 1;
}

static Elevator_Destroy()
{
	// Destroys the elevator.

	DestroyDynamicObject(Obj_Elevator);
	DestroyDynamicObject(Obj_ElevatorDoors[0]);
	DestroyDynamicObject(Obj_ElevatorDoors[1]);
	DestroyDynamic3DTextLabel(Label_Elevator);

	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    DestroyDynamicObject(Obj_FloorDoors[i][0]);
		DestroyDynamicObject(Obj_FloorDoors[i][1]);
		DestroyDynamic3DTextLabel(Label_Floors[i]);
	}

	return 1;
}

static Elevator_OpenDoors()
{
	// Opens the elevator's doors.

	new Float:x, Float:y, Float:z;
    GetElevatorXYZCoordForFloor(ElevatorFloor, x, y, z);

	MoveDynamicObject(Obj_ElevatorDoors[0], x, y - FBI_DOOR_MOVE, z, FBI_DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], x, y + FBI_DOOR_MOVE, z, FBI_DOORS_SPEED);
	return 1;
}

static Elevator_CloseDoors()
{
    // Closes the elevator's doors.

    if(ElevatorState == FBI_ELEVATOR_STATE_MOVING)
	    return 0;

    new Float:x, Float:y, Float:z;
    GetElevatorXYZCoordForFloor(ElevatorFloor, x, y, z);

	MoveDynamicObject(Obj_ElevatorDoors[0], x, y, z, FBI_DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], x, y, z, FBI_DOORS_SPEED);
	return 1;
}

static Floor_OpenDoors(floorid)
{
    // Opens the doors at the specified floor.
    new Float:x, Float:y, Float:z;
    GetDoorsXYZCoordForFloor(floorid, x, y, z);

    MoveDynamicObject(Obj_FloorDoors[floorid][0], x, y - FBI_DOOR_MOVE, z, FBI_DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], x, y + FBI_DOOR_MOVE, z, FBI_DOORS_SPEED);

	PlaySoundForPlayersInRange(6401, 25.0, x, y, z + 5.0);
	return 1;
}

static Floor_CloseDoors(floorid)
{
    // Closes the doors at the specified floor.
    new Float:x, Float:y, Float:z;
    GetDoorsXYZCoordForFloor(floorid, x, y, z);

    MoveDynamicObject(Obj_FloorDoors[floorid][0], x, y, z, FBI_DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], x, y, z, FBI_DOORS_SPEED);
	
	PlaySoundForPlayersInRange(6401, 25.0, x, y, z);
	return 1;
}

static Elevator_MoveToFloor(floorid)
{
	// Moves the elevator to specified floor (doors are meant to be already closed).
	new Float:x, Float:y, Float:z;
    GetElevatorXYZCoordForFloor(floorid, x, y, z);
    y = y + 2.0;

	ElevatorState = FBI_ELEVATOR_STATE_MOVING;
	ElevatorFloor = floorid;

	// Move the elevator slowly, to give time to clients to sync the object surfing. Then, boost it up:
	MoveDynamicObject(Obj_Elevator, x, y, z, 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[0], x, y, z, 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[1], x, y, z, 0.25);
    DestroyDynamic3DTextLabel(Label_Elevator);

	ElevatorBoostTimer = SetTimerEx("Elevator_Boost", 2000, 0, "i", floorid);

	return 1;
}

public Elevator_Boost(floorid)
{
	// Increases the elevator's speed until it reaches 'floorid'
	StopDynamicObject(Obj_Elevator);
	StopDynamicObject(Obj_ElevatorDoors[0]);
	StopDynamicObject(Obj_ElevatorDoors[1]);
	
	new Float:x, Float:y, Float:z;
    GetElevatorXYZCoordForFloor(floorid, x, y, z);
	
	MoveDynamicObject(Obj_Elevator, x, y, z, FBI_ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[0], x, y, z, FBI_ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[1], x, y, z, FBI_ELEVATOR_SPEED);

	return 1;
}

public Elevator_TurnToIdle()
{
	ElevatorState = FBI_ELEVATOR_STATE_IDLE;
	ReadNextFloorInQueue();

	return 1;
}

static RemoveFirstQueueFloor()
{
	// Removes the data in ElevatorQueue[0], and reorders the queue accordingly.

	for(new i; i < sizeof(ElevatorQueue) - 1; i ++)
	    ElevatorQueue[i] = ElevatorQueue[i + 1];

	ElevatorQueue[sizeof(ElevatorQueue) - 1] = FBI_INVALID_FLOOR;

	return 1;
}

static AddFloorToQueue(floorid)
{
 	// Adds 'floorid' at the end of the queue.

	// Scan for the first empty space:
	new slot = -1;
	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    if(ElevatorQueue[i] == FBI_INVALID_FLOOR)
	    {
	        slot = i;
	        break;
	    }
	}

	if(slot != -1)
	{
	    ElevatorQueue[slot] = floorid;

     	// If needed, move the elevator.
	    if(ElevatorState == FBI_ELEVATOR_STATE_IDLE)
	        ReadNextFloorInQueue();

	    return 1;
	}

	return 0;
}

static ResetElevatorQueue()
{
	// Resets the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    ElevatorQueue[i] 	= FBI_INVALID_FLOOR;
	    FloorRequestedBy[i] = INVALID_PLAYER_ID;
	}

	return 1;
}

static IsFloorInQueue(floorid)
{
	// Checks if the specified floor is currently part of the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	    if(ElevatorQueue[i] == floorid)
	        return 1;

	return 0;
}

static ReadNextFloorInQueue()
{
	// Reads the next floor in the queue, closes doors, and goes to it.

	if(ElevatorState != FBI_ELEVATOR_STATE_IDLE || ElevatorQueue[0] == FBI_INVALID_FLOOR)
	    return 0;

	Elevator_CloseDoors();
	Floor_CloseDoors(ElevatorFloor);

	return 1;
}

static DidPlayerRequestElevator(playerid)
{
	for(new i; i < sizeof(FloorRequestedBy); i ++)
	    if(FloorRequestedBy[i] == playerid)
	        return 1;

	return 0;
}

static GetElevatorXYZCoordForFloor(floorid, &Float:x, &Float:y, &Float:z)
{
    // Return Z height value plus a small offset
    x = FBI_ELEV_X;
    y = FBI_ELEV_Y;
    z = FBI_ELEV_Z + FloorPositions[floorid];
    return 1;
}

static GetDoorsXYZCoordForFloor(floorid, &Float:x, &Float:y, &Float:z)
{
	// Return Z height value plus a small offset
	x = FBI_ELEV_X + FBI_DOOR_OFFSET;
    y = FBI_ELEV_Y;
    z = FBI_ELEV_Z + FloorPositions[floorid];
    return 1;
}

public ShowElevatorDialog(playerid)
{
	new string[256];
	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    if(FloorRequestedBy[i] != INVALID_PLAYER_ID)
	        strcat(string, "{FF0000}");

	    strcat(string, FloorNames[i]);
	    strcat(string, "\n");
	}

	inline DlgElevator(pid, dialogid, response, listitem, string:inputtext[]) 
    {
        #pragma unused pid, dialogid, inputtext, listitem

        if (response)
        {
            if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
                //GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
                ShowPlayerSubtitle(playerid, "~r~This floor is already in the queue.", .showtime = 3000 );
            else if(DidPlayerRequestElevator(playerid))
                //GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
                ShowPlayerSubtitle(playerid, "~r~You already requested the elevator.", .showtime = 3000 );
            else if (ElevatorFloor == listitem)
                ShowPlayerSubtitle(playerid, "~r~This elevator is already on this floor.", .showtime = 3000 );
            else
                CallElevator(playerid, listitem, false);
        }
    }

    Dialog_ShowCallback ( playerid, using inline DlgElevator, DIALOG_STYLE_LIST, "Elevator", string, "Select", "Back" );

	return 1;
}

public CallElevator(playerid, floorid, bool:showmsg)
{
	// Calls the elevator (also used with the elevator dialog).

    // Check if the elevator is not moving (idle or waiting)
    if (ElevatorState != FBI_ELEVATOR_STATE_MOVING)
    {
        // Check if the elevator is already on the floor it was called from
        if (ElevatorFloor == floorid)
        {
            //SendClientMessage(playerid, COLOR_YELLOW, "* The Elevator is already on this floor... walk inside it and press '{FFFFFF}~k~~VEHICLE_ENTER_EXIT~{CCCCCC}'");
            ShowPlayerSubtitle(playerid, "The elevator is already on this floor.~n~Press ~y~~k~~VEHICLE_ENTER_EXIT~ ~w~inside to use it.", .showtime = 4000 );
            return 1;
        }
    }

	if(FloorRequestedBy[floorid] != INVALID_PLAYER_ID || IsFloorInQueue(floorid))
	    return 0;

	FloorRequestedBy[floorid] = playerid;
	AddFloorToQueue(floorid);

    if (showmsg)
    {
        // Check if the elevator is moving
        new strTempString[100];
        if (ElevatorState == FBI_ELEVATOR_STATE_MOVING)
        {
            // Format chat text message
            format(strTempString, sizeof(strTempString), "~y~The elevator has been called~n~.It is currently moving towards ~y~%s~w~.", FloorNames[ElevatorFloor]);
        }
        else
        {
            // Format chat text message
            format(strTempString, sizeof(strTempString), "~y~The elevator has been called.~n~~w~It is currently at ~y~%s~w~.", FloorNames[ElevatorFloor]);
        }

        // Display formatted chat text message to the player
        // SendClientMessage(playerid, COLOR_YELLOW, strTempString);
        ShowPlayerSubtitle(playerid, strTempString, .showtime = 4000 );
    }

	return 1;
}