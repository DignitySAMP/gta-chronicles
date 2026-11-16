#define PLASTICBIN_OBJ -25181

#define FBI_INT_X (FBI_BUILD_X + 19.014)
#define FBI_INT_Y (FBI_BUILD_Y + 0.0000)
#define FBI_INT_Z (FBI_BUILD_Z + 1.2860)

#define FBI_MODELS_PATH "fbi"

// Increase this if the chairs etc aren't visible but 50 should be good
#define FBI_MISC_STREAM_DIST    50.0

#include <YSI_Coding\y_hooks>

static enum E_AUTO_DOOR
{
	Float:E_AUTO_DOOR_X,
	Float:E_AUTO_DOOR_Y,
	Float:E_AUTO_DOOR_Z,
	Float:E_AUTO_DOOR_A,
	bool:E_AUTO_DOOR_RELATIVE,
	E_AUTO_DOOR_OBJ[3],
	E_AUTO_DOOR_AREA,
	bool:E_AUTO_DOOR_OPEN,
	E_AUTO_DOOR_NEARBY,
	Float:E_AUTO_DOOR_O_X[2],
	Float:E_AUTO_DOOR_O_Y[2],
	Float:E_AUTO_DOOR_O_Z[2]
}

#define FBI_AUTO_DOOR_DELTA 0.75

static FBIAutoDoors[][E_AUTO_DOOR] =
{
    { -17.337, -0.012, 0.011, 0.0 },
    { -19.785, 4.357, 0.011, 90.0 },
    { -19.785, -4.390, 0.011, -90.0 },
    { -8.664, 10.781, 29.539, 90.0, true },
    { -8.664, -10.319, 29.539, -90.0, true }
};

static GetDoorRelativePos(door, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    rot = FBIAutoDoors[door][E_AUTO_DOOR_A];
    x = FBIAutoDoors[door][E_AUTO_DOOR_X];
    y = FBIAutoDoors[door][E_AUTO_DOOR_Y];
    z = FBIAutoDoors[door][E_AUTO_DOOR_Z];
    
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}

static SetFBIAutoDoor(door, bool:open)
{
	new i = door;
	
	if (open)
	{
	    MoveDynamicObject(FBIAutoDoors[i][E_AUTO_DOOR_OBJ][0], FBIAutoDoors[i][E_AUTO_DOOR_O_X][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][0], FBI_AUTO_DOOR_DELTA);
        MoveDynamicObject(FBIAutoDoors[i][E_AUTO_DOOR_OBJ][1], FBIAutoDoors[i][E_AUTO_DOOR_O_X][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][1], FBI_AUTO_DOOR_DELTA);
	}
	else
	{
	    MoveDynamicObject(FBIAutoDoors[i][E_AUTO_DOOR_OBJ][0], FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], FBI_AUTO_DOOR_DELTA);
        MoveDynamicObject(FBIAutoDoors[i][E_AUTO_DOOR_OBJ][1], FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], FBI_AUTO_DOOR_DELTA);
        FBIAutoDoors[i][E_AUTO_DOOR_NEARBY] = 0;
	}

	FBIAutoDoors[door][E_AUTO_DOOR_OPEN] = open;
}

static UpdateFBIAutoDoor(door)
{
    FBIAutoDoors[door][E_AUTO_DOOR_NEARBY] = 0;

    foreach(new playerid: Player)
    {
        if (IsPlayerInDynamicArea(playerid, FBIAutoDoors[door][E_AUTO_DOOR_AREA]) && IsPlayerInDEAFaction(playerid))
        {
            FBIAutoDoors[door][E_AUTO_DOOR_NEARBY] ++;
        }
    }

    if (FBIAutoDoors[door][E_AUTO_DOOR_NEARBY] > 0 && !FBIAutoDoors[door][E_AUTO_DOOR_OPEN])
    {
        SetFBIAutoDoor(door, true);
    }
	else if (FBIAutoDoors[door][E_AUTO_DOOR_NEARBY] <= 0 && FBIAutoDoors[door][E_AUTO_DOOR_OPEN])
    {
        SetFBIAutoDoor(door, false);
    }
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
    if (!IsPlayerInDEAFaction(playerid)) return 1;

    for (new i = 0; i < sizeof(FBIAutoDoors); i ++)
    {
        if (FBIAutoDoors[i][E_AUTO_DOOR_AREA] == areaid)
        {
            UpdateFBIAutoDoor(i);
            break;
        }
    }

    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
    for (new i = 0; i < sizeof(FBIAutoDoors); i ++)
    {
        if (FBIAutoDoors[i][E_AUTO_DOOR_AREA] == areaid)
        {
            UpdateFBIAutoDoor(i);
            break;
        }
    }

    return 1;
}

//hook OnPlayerDisconnect(playerid, reason)
hook SOLS_OnCloseConnection(playerid, reason)
{
    for (new i = 0; i < sizeof(FBIAutoDoors); i ++)
    {
		if (IsPlayerInDynamicArea(playerid, FBIAutoDoors[i][E_AUTO_DOOR_AREA]) && IsPlayerInDEAFaction(playerid))
        {
            FBIAutoDoors[i][E_AUTO_DOOR_NEARBY] --;
        }

        if (FBIAutoDoors[i][E_AUTO_DOOR_NEARBY] <= 0 && FBIAutoDoors[i][E_AUTO_DOOR_OPEN])
        {
            SetFBIAutoDoor(i, false);
        }
    }

    return 1;
}

hook OnGameModeInit()
{
    // FENCE (DEFAULT OBJ)
    CreateDynamicObject(6970, 936.3250, -1530.8116, 14.9083, 0.0000, 0.0000, 180.0000, -1, -1, -1, 200.0, 200.0); //vgsNbnkmsh

    // EXTERIOR

    AddSimpleModel(-1, 1923, -5400,   FBI_MODELS_PATH"/fbibuilding.dff",     FBI_MODELS_PATH"/fbibuilding.txd" ) ;
    CreateDynamicObject(-5400, FBI_BUILD_X, FBI_BUILD_Y, FBI_BUILD_Z, 0.0000, 0.0000, 0.0000, -1, -1, -1, 900.0, 900.0); //fbibuilding

    AddSimpleModel(-1, 1923, -5401,   FBI_MODELS_PATH"/fbiground.dff",     FBI_MODELS_PATH"/fbibuilding.txd" ) ;
    CreateObject(-5401, FBI_BUILD_X, FBI_BUILD_Y, FBI_BUILD_Z, 0.0000, 0.0000, 0.0000, 300.0); //fbiground STATIC CREATE OBJECT TO STOP CARS FALLING

    AddSimpleModel(-1, 1923, -5402,   FBI_MODELS_PATH"/fbiflags.dff",     FBI_MODELS_PATH"/fbibuilding.txd" ) ;
    AddSimpleModel(-1, 4192, -5403,   FBI_MODELS_PATH"/fbiflags_alpha.dff",     FBI_MODELS_PATH"/fbibuilding.txd" ) ;
    CreateDynamicObject(-5402, FBI_BUILD_X + 44.551, FBI_BUILD_Y + 13.417, FBI_BUILD_Z + 0.13, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.0, 200.0); //fbiflags
    CreateDynamicObject(-5403, FBI_BUILD_X + 44.551, FBI_BUILD_Y + 13.417, FBI_BUILD_Z + 0.13, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.0, 200.0); //fbiflags_alpha

    AddSimpleModel(-1, 1523, -5404, FBI_MODELS_PATH"/fedbldgdoor.dff", FBI_MODELS_PATH"/fedbldgdoor.txd" );
    CreateDynamicObject(-5404, FBI_BUILD_X + 19.776, FBI_BUILD_Y - 3.624, FBI_BUILD_Z + 1.286, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.0, 200.0); //fedbldgdoor
	CreateDynamicObject(-5404, FBI_BUILD_X + 19.776, FBI_BUILD_Y - 2.148, FBI_BUILD_Z + 1.286, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.0, 200.0); //fedbldgdoor
	CreateDynamicObject(-5404, FBI_BUILD_X + 19.776, FBI_BUILD_Y - 0.653, FBI_BUILD_Z + 1.286, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.0, 200.0); //fedbldgdoor
	CreateDynamicObject(-5404, FBI_BUILD_X + 19.776, FBI_BUILD_Y + 0.841, FBI_BUILD_Z + 1.286, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.0, 200.0); //fedbldgdoor
	CreateDynamicObject(-5404, FBI_BUILD_X + 19.776, FBI_BUILD_Y + 2.336, FBI_BUILD_Z + 1.286, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.0, 200.0); //fedbldgdoor

    // GARAGE
    
    AddSimpleModel(-1, 1923, -5440, FBI_MODELS_PATH"/fbigarage.dff", FBI_MODELS_PATH"/fbigarage.txd");
    AddSimpleModel(-1, 19325, -5441, FBI_MODELS_PATH"/fbigaragewin.dff", FBI_MODELS_PATH"/fbigarage.txd");
    CreateDynamicObject(-5440, FBI_BUILD_X - 22.499, FBI_BUILD_Y - 9.311, FBI_BUILD_Z + 0.727, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.0, 200.0); //fbigarage
    CreateDynamicObject(-5441, FBI_BUILD_X - 11.348, FBI_BUILD_Y - 9.572, FBI_BUILD_Z + 2.492, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.0, 50.0); //fbigaragewin

    // CHANGING ROOM
    
    AddSimpleModel(-1, 1923, -5442, FBI_MODELS_PATH"/fbichanging.dff", FBI_MODELS_PATH"/fbigarage.txd");
    AddSimpleModel(-1, 1923, -5443, FBI_MODELS_PATH"/fbichangingbits.dff", FBI_MODELS_PATH"/fbigarage.txd");
    AddSimpleModel(-1, 1499, -5444, FBI_MODELS_PATH"/fbitoiletdoor.dff", FBI_MODELS_PATH"/fbigarage.txd");
    CreateDynamicObject(-5442, FBI_BUILD_X - 8.511, FBI_BUILD_Y + 10.776, FBI_BUILD_Z + 2.848, 0.0000, 0.0000, 0.0000, -1, -1, -1, 100.0, 100.0); //fbichanging
    CreateDynamicObject(-5443, FBI_BUILD_X - 8.511, FBI_BUILD_Y + 10.776, FBI_BUILD_Z + 2.848, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.0, 50.0); //fbichanging_bits
    CreateDynamicObject(-5444, FBI_BUILD_X - 11.807, FBI_BUILD_Y + 13.162, FBI_BUILD_Z + 1.540, 0.0000, 0.0000, 0.0000, -1, -1, -1, 25.0, 25.0); //fbitoiletdoor
    CreateDynamicObject(-5444, FBI_BUILD_X - 13.807, FBI_BUILD_Y + 13.162, FBI_BUILD_Z + 1.540, 0.0000, 0.0000, 0.0000, -1, -1, -1, 25.0, 25.0); //fbitoiletdoor

    // LOBBY

    AddSimpleModel(-1, 1923, -5405, FBI_MODELS_PATH"/fbilobbymain.dff", FBI_MODELS_PATH"/fbimain.txd");
    AddSimpleModel(-1, 19325, -5406, FBI_MODELS_PATH"/fbilobbywin.dff", FBI_MODELS_PATH"/fbimain.txd");
    AddSimpleModel(-1, 1923, -5407, FBI_MODELS_PATH"/fbilobbybits.dff", FBI_MODELS_PATH"/fbimain.txd");
    
    AddSimpleModel(-1, 19325, -5408, FBI_MODELS_PATH"/fbidoorslide.dff", FBI_MODELS_PATH"/fbimain.txd");
    AddSimpleModel(-1, 19325, -5409, FBI_MODELS_PATH"/fbidoorslideL.dff", FBI_MODELS_PATH"/fbimain.txd");
    AddSimpleModel(-1, 19325, -5410, FBI_MODELS_PATH"/fbidoorslideR.dff", FBI_MODELS_PATH"/fbimain.txd");
    AddSimpleModel(-1, 1923, -5431, FBI_MODELS_PATH"/fbilobbyfurn.dff", FBI_MODELS_PATH"/fbiprops.txd");
 	
	CreateDynamicObject(-5405, FBI_INT_X, FBI_INT_Y, FBI_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 175.0, 175.0); // Spooky (-5107)
	CreateDynamicObject(-5406, FBI_INT_X - 4.305, FBI_INT_Y, FBI_INT_Z + 1.725, 0.000, 0.000, 0.000, -1, -1, -1, 75.0, 75.0); // Spooky (-5107)
	CreateDynamicObject(-5407, FBI_INT_X - 14.129, FBI_INT_Y, FBI_INT_Z + 0.415, 0.000, 0.000, 0.000, -1, -1, -1, 75.0, 75.0); // Spooky (-5107)
	CreateDynamicObject(-5431, FBI_INT_X - 4.828, FBI_INT_Y - 0.034, FBI_INT_Z + 1.133, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbilobbyfurn
    CreateDynamicObject(-5429, FBI_BUILD_X - 12.184, FBI_BUILD_Y + 0.011, FBI_BUILD_Z + 3.808, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbielevbits

    // FOURTH FLOOR INTERIOR
    
	AddSimpleModel(-1, 1923, -5411, FBI_MODELS_PATH"/fbiup_main.dff", FBI_MODELS_PATH"/fbimain.txd");
	AddSimpleModel(-1, 19325, -5412, FBI_MODELS_PATH"/fbiup_win.dff", FBI_MODELS_PATH"/fbimain.txd");
	AddSimpleModel(-1, 1923, -5413, FBI_MODELS_PATH"/fbiup_bits.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5414, FBI_MODELS_PATH"/fbiconftable.dff", FBI_MODELS_PATH"/fbiprops.txd");
	
	AddSimpleModel(-1, 1923, -5415, FBI_MODELS_PATH"/binder1.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5416, FBI_MODELS_PATH"/binder2.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5417, FBI_MODELS_PATH"/deabits.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5418, FBI_MODELS_PATH"/fbiupcornerbit.dff", FBI_MODELS_PATH"/fbiprops.txd");
	
	AddSimpleModel(-1, 1923, -5419, FBI_MODELS_PATH"/fbipartition.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5420, FBI_MODELS_PATH"/fbilongunit.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5421, FBI_MODELS_PATH"/fbiufodesk.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5422, FBI_MODELS_PATH"/fbiufoposters.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5423, FBI_MODELS_PATH"/fbiufodesk2.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5424, FBI_MODELS_PATH"/fbilongunit2.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5425, FBI_MODELS_PATH"/fbiroundtable.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5426, FBI_MODELS_PATH"/fbiwhiteboard.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5427, FBI_MODELS_PATH"/fbiwanted.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5428, FBI_MODELS_PATH"/fbistorage.dff", FBI_MODELS_PATH"/fbiprops.txd");
	AddSimpleModel(-1, 1923, -5429, FBI_MODELS_PATH"/fbielevbits.dff", FBI_MODELS_PATH"/fbiprops.txd");
	
	AddSimpleModel(-1, 1923, -5430, FBI_MODELS_PATH"/fbiup_lights.dff", FBI_MODELS_PATH"/fbimain.txd");
	
	
	CreateDynamicObject(-5429, FBI_BUILD_X - 12.184, FBI_BUILD_Y + 0.011, FBI_BUILD_Z + 32.063, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbielevbits
	CreateDynamicObject(-5430, FBI_BUILD_X + 0.126, FBI_BUILD_Y + 0.296, FBI_BUILD_Z + 33.793, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbiuplights
	
	CreateDynamicObject(-5411, FBI_BUILD_X, FBI_BUILD_Y, FBI_BUILD_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.0, 150.0); //fbiup_main
	CreateDynamicObject(-5412, FBI_BUILD_X, FBI_BUILD_Y, FBI_BUILD_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.0, 100.0); //fbiup_win
	CreateDynamicObject(-5413, FBI_BUILD_X + 5.866, FBI_BUILD_Y + 0.3, FBI_BUILD_Z + 31.403, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbiup_bits
	CreateDynamicObject(-5414, FBI_BUILD_X + 0.123, FBI_BUILD_Y + 0.282, FBI_BUILD_Z + 29.545, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbiconftable
    CreateDynamicObject(-5417, FBI_BUILD_X - 11.776, FBI_BUILD_Y + 21.071, FBI_BUILD_Z + 30.538, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //deabits
    CreateDynamicObject(-5418, FBI_BUILD_X + 14.909, FBI_BUILD_Y - 20.223, FBI_BUILD_Z + 30.903, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.0, 50.0); //fbiupcornerbit
    
	// 4th Floor Furnishings
	CreateDynamicObject(1998, 980.379, -1507.432, 42.385, 0.000, 0.000, 179.800, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(2008, 981.388, -1508.441, 42.375, 0.000, 0.000, 89.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1998, 986.023, -1508.434, 42.374, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(2008, 984.995, -1507.421, 42.374, 0.000, 0.000, -89.931, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1806, 984.489, -1508.319, 42.384, 0.000, 0.000, -86.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 987.213, -1508.653, 42.384, 0.000, 0.000, 30.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 982.517, -1507.436, 42.384, 0.000, 0.000, 100.799, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 979.247, -1507.184, 42.384, 0.000, 0.000, -166.800, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(-5415, 985.983, -1508.604, 43.184, 0.000, 0.000, 99.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5415, 986.984, -1506.055, 43.504, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
    CreateDynamicObject(1998, 976.470, -1507.410, 42.375, 0.000, 0.000, 179.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(1806, 975.469, -1507.184, 42.374, 0.000, 0.000, -167.199, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(-5416, 986.501, -1506.056, 43.504, 0.000, 0.000, 7.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5416, 976.587, -1507.239, 43.184, 0.000, 0.000, -34.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5416, 971.057, -1506.076, 43.494, 0.000, 0.000, 16.200, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5415, 971.559, -1506.033, 43.494, 0.000, 0.000, -4.700, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 970.852, -1508.349, 44.214, 0.000, 0.000, 95.399, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(2186, 971.468, -1506.877, 42.374, 0.000, 0.000, -0.100, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2186)
	CreateDynamicObject(2613, 973.344, -1505.729, 42.374, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2613)
	CreateDynamicObject(-5415, 973.315, -1512.565, 43.294, 0.000, 0.000, -179.200, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 971.601, -1512.574, 43.304, 0.000, 0.000, -175.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(1998, 999.308, -1518.693, 42.384, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(2008, 1000.336, -1516.656, 42.384, 0.000, 0.000, -180.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1806, 999.276, -1516.121, 42.374, 0.000, 0.000, -161.300, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 1000.411, -1519.021, 42.374, 0.000, 0.000, 22.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(2200, 999.043, -1513.352, 42.354, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2200)
	CreateDynamicObject(2613, 1001.522, -1512.758, 42.384, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2613)
	CreateDynamicObject(-5416, 1000.510, -1513.473, 44.244, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5415, 1002.010, -1513.663, 43.504, 0.000, 0.000, -67.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5415, 1000.438, -1516.797, 43.184, 0.000, 0.000, -137.500, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(2164, 997.222, -1513.240, 42.364, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2164)
	CreateDynamicObject(-5415, 996.938, -1513.404, 44.204, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 997.284, -1513.390, 44.214, 0.000, 0.000, 12.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(1998, 999.621, -1543.317, 42.374, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(2008, 998.594, -1542.304, 42.374, 0.000, 0.000, -89.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1998, 1000.657, -1547.013, 42.374, 0.000, 0.000, 90.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(2008, 998.602, -1546.033, 42.354, 0.000, 0.000, -89.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1806, 997.377, -1546.814, 42.364, 0.000, 0.000, -83.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 997.430, -1543.118, 42.364, 0.000, 0.000, -92.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 1000.732, -1543.410, 42.364, 0.000, 0.000, 15.300, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 1000.924, -1545.864, 42.364, 0.000, 0.000, 102.400, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(-5415, 1002.000, -1547.413, 43.494, 0.000, 0.000, -91.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 1002.016, -1546.928, 43.494, 0.000, 0.000, -86.500, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5416, 1002.002, -1542.608, 43.504, 0.000, 0.000, -74.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5415, 1001.972, -1542.276, 43.504, 0.000, 0.000, -90.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5415, 1001.991, -1541.702, 43.504, 0.000, 0.000, -82.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(19805, 996.869, -1547.939, 44.234, 0.000, 0.000, 179.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (19805)
	CreateDynamicObject(2008, 989.558, -1552.627, 42.384, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2008)
	CreateDynamicObject(1998, 990.563, -1551.596, 42.374, 0.000, 0.000, 89.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1998)
	CreateDynamicObject(1806, 990.721, -1550.529, 42.374, 0.000, 0.000, 110.999, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 990.287, -1553.873, 42.374, 0.000, 0.000, -7.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
    CreateDynamicObject(-5415, 988.652, -1555.143, 43.494, 0.000, 0.000, 176.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 989.094, -1555.086, 43.494, 0.000, 0.000, -167.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5419, 980.504, -1512.749, 42.385, 0.000, 0.000, 180.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5419)
	CreateDynamicObject(-5422, 980.478, -1512.716, 43.734, 0.000, 0.000, 180.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5422)
	
	// FBI Conference Chairs
	CreateDynamicObject(1714, 985.329, -1526.949, 42.364, 0.000, 0.000, -85.199, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.429, -1528.135, 42.364, 0.000, 0.000, -85.199, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.524, -1529.282, 42.364, 0.000, 0.000, -86.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.510, -1530.553, 42.364, 0.000, 0.000, -90.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.472, -1531.822, 42.364, 0.000, 0.000, -93.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.390, -1533.008, 42.364, 0.000, 0.000, -94.799, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 985.267, -1534.221, 42.364, 0.000, 0.000, -100.999, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 982.685, -1536.031, 42.364, 0.000, 0.000, 178.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.330, -1534.090, 42.364, 0.000, 0.000, 93.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.232, -1532.853, 42.364, 0.000, 0.000, 93.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.150, -1531.716, 42.364, 0.000, 0.000, 93.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.025, -1530.496, 42.364, 0.000, 0.000, 88.500, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.058, -1529.244, 42.364, 0.000, 0.000, 86.700, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.098, -1528.001, 42.364, 0.000, 0.000, 83.100, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 980.182, -1526.893, 42.364, 0.000, 0.000, 83.100, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	CreateDynamicObject(1714, 982.759, -1524.922, 42.364, 0.000, 0.000, 3.700, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1714)
	
	// UFO Desks
	CreateDynamicObject(-5419, 998.225, -1520.283, 42.364, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5419)
	CreateDynamicObject(-5420, 1001.428, -1525.306, 42.834, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5420)
	CreateDynamicObject(-5421, 998.172, -1521.122, 42.364, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5421)
	CreateDynamicObject(-5422, 998.212, -1520.311, 43.834, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5422)
	CreateDynamicObject(-5419, 998.240, -1530.339, 42.364, 0.000, 0.000, 180.0, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5419)
	CreateDynamicObject(-5421, 998.255, -1529.514, 42.364, 0.000, 0.000, 180.0, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5421)
	CreateDynamicObject(-5422, 998.253, -1530.306, 43.834, 0.000, 0.000, 180.0, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5422)
	
	CreateDynamicObject(1806, 999.172, -1522.142, 42.384, 0.000, 0.000, 14.500, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 997.242, -1522.256, 42.384, 0.000, 0.000, -12.700, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 997.230, -1528.482, 42.384, 0.000, 0.000, -161.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 999.195, -1528.567, 42.384, 0.000, 0.000, 158.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(-5415, 1001.992, -1521.840, 43.494, 0.000, 0.000, -85.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 1001.998, -1522.230, 43.484, 0.000, 0.000, -83.799, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(-5416, 1001.972, -1521.201, 43.504, 0.000, 0.000, -75.199, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(3017, 1001.957, -1528.894, 43.514, 0.000, 0.000, -90.0, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (3017)
	
	CreateDynamicObject(-5420, 1001.438, -1535.847, 42.824, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5420)
	CreateDynamicObject(-5423, 998.121, -1535.857, 43.004, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5423)
	CreateDynamicObject(-5424, 998.232, -1530.987, 43.374, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5424)
	CreateDynamicObject(-5424, 998.248, -1540.725, 43.374, 0.000, 0.000, -179.999, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5424)
	CreateDynamicObject(-5415, 1002.004, -1540.472, 43.494, 0.000, 0.000, -94.900, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5415)
	CreateDynamicObject(-5416, 1001.987, -1540.045, 43.504, 0.000, 0.000, -84.700, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5416)
	CreateDynamicObject(1806, 996.221, -1537.135, 42.374, 0.000, 0.000, -105.800, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 996.120, -1534.078, 42.374, 0.000, 0.000, -103.400, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 1000.197, -1534.337, 42.374, 0.000, 0.000, 92.699, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 1000.089, -1537.582, 42.374, 0.000, 0.000, 74.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	
	// Small Conference
	CreateDynamicObject(-5425, 982.721, -1551.350, 42.754, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5425)
	CreateDynamicObject(-5426, 986.828, -1551.896, 42.364, 0.000, 0.000, 77.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5426)
	CreateDynamicObject(-5420, 982.742, -1554.548, 42.814, 0.000, 0.000, -89.999, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5420)
	CreateDynamicObject(-5424, 977.927, -1551.255, 43.374, 0.000, 0.000, 90.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5424)
	CreateDynamicObject(-5427, 986.802, -1551.814, 44.414, 0.000, 0.000, -101.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5427)
	CreateDynamicObject(1806, 981.875, -1549.147, 42.374, 0.000, 0.000, -179.899, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 984.212, -1549.167, 42.374, 0.000, 0.000, 172.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 983.820, -1553.493, 42.374, 0.000, 0.000, 6.499, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 982.325, -1553.537, 42.374, 0.000, 0.000, -5.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 980.847, -1553.501, 42.374, 0.000, 0.000, -11.600, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	CreateDynamicObject(1806, 979.766, -1549.609, 42.374, 0.000, 0.000, -140.300, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (1806)
	
	// Storage
	CreateDynamicObject(-5428, 973.946, -1551.472, 43.904, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-5428)
	CreateDynamicObject(2167, 972.606, -1550.013, 42.375, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 973.526, -1550.013, 42.375, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 974.447, -1550.013, 42.375, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 975.367, -1550.013, 42.375, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 975.298, -1549.965, 42.365, 0.000, 0.000, -179.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 974.378, -1549.972, 42.365, 0.000, 0.000, -179.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 973.467, -1549.979, 42.365, 0.000, 0.000, -179.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(2167, 972.546, -1549.987, 42.365, 0.000, 0.000, -179.599, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (2167)
	CreateDynamicObject(PLASTICBIN_OBJ, 975.224, -1553.004, 42.904, 0.000, 0.000, 0.000, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-336)
	CreateDynamicObject(PLASTICBIN_OBJ, 974.266, -1552.890, 42.904, 0.000, 0.000, -91.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-336)
	CreateDynamicObject(PLASTICBIN_OBJ, 973.437, -1552.820, 42.904, 0.000, 0.000, 179.299, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-336)
	CreateDynamicObject(PLASTICBIN_OBJ, 972.486, -1552.900, 42.904, 0.000, 0.000, -90.099, -1, 0, -1, FBI_MISC_STREAM_DIST, FBI_MISC_STREAM_DIST); // Spooky (-336)

    for (new i = 0; i < sizeof(FBIAutoDoors); i ++)
 	{
 	    if (FBIAutoDoors[i][E_AUTO_DOOR_RELATIVE])
 	    {
 	      	FBIAutoDoors[i][E_AUTO_DOOR_X] = FBI_BUILD_X + FBIAutoDoors[i][E_AUTO_DOOR_X];
 	    	FBIAutoDoors[i][E_AUTO_DOOR_Y] = FBI_BUILD_Y + FBIAutoDoors[i][E_AUTO_DOOR_Y];
 	    	FBIAutoDoors[i][E_AUTO_DOOR_Z] = FBI_BUILD_Z + FBIAutoDoors[i][E_AUTO_DOOR_Z];
 	    }
 	    else
 	    {
 	      	FBIAutoDoors[i][E_AUTO_DOOR_X] = FBI_INT_X + FBIAutoDoors[i][E_AUTO_DOOR_X];
	 	    FBIAutoDoors[i][E_AUTO_DOOR_Y] = FBI_INT_Y + FBIAutoDoors[i][E_AUTO_DOOR_Y];
	 	    FBIAutoDoors[i][E_AUTO_DOOR_Z] = FBI_INT_Z + FBIAutoDoors[i][E_AUTO_DOOR_Z];
 	    }

 	    FBIAutoDoors[i][E_AUTO_DOOR_OBJ][2] = CreateDynamicObject(-5408, FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], 0.000, 0.000, FBIAutoDoors[i][E_AUTO_DOOR_A]); // Spooky (-5118)
 	   	FBIAutoDoors[i][E_AUTO_DOOR_OBJ][0] = CreateDynamicObject(-5409, FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], 0.000, 0.000, FBIAutoDoors[i][E_AUTO_DOOR_A]); // Spooky (-5118)
		FBIAutoDoors[i][E_AUTO_DOOR_OBJ][1] = CreateDynamicObject(-5410, FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], 0.000, 0.000, FBIAutoDoors[i][E_AUTO_DOOR_A]); // Spooky (-5119)
        
        FBIAutoDoors[i][E_AUTO_DOOR_AREA] = CreateDynamicSphere(FBIAutoDoors[i][E_AUTO_DOOR_X], FBIAutoDoors[i][E_AUTO_DOOR_Y], FBIAutoDoors[i][E_AUTO_DOOR_Z], 2.00);

		if (i == 0)
		{
		    GetDoorRelativePos(i, FBIAutoDoors[i][E_AUTO_DOOR_O_X][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][0], 0.0, -0.95, 0.0);
	        GetDoorRelativePos(i, FBIAutoDoors[i][E_AUTO_DOOR_O_X][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][1], 0.0, 0.95, 0.0);
		}
		else
		{
	        GetDoorRelativePos(i, FBIAutoDoors[i][E_AUTO_DOOR_O_X][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][0], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][0], 0.0, 0.95, 0.0);
	        GetDoorRelativePos(i, FBIAutoDoors[i][E_AUTO_DOOR_O_X][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Y][1], FBIAutoDoors[i][E_AUTO_DOOR_O_Z][1], 0.0, -0.95, 0.0);
	   }
        
		SetFBIAutoDoor(i, false);
	}

    return 1;
}