#include <YSI_Coding\y_hooks>

#define TWIN_INT_X  1770.946
#define TWIN_INT_Y  -1556.291
#define TWIN_INT_Z  32.382
#define TWIN_INT_RZ 180.0

static PrisonIntObjects[15];
static LastPrisonIntObject = 0;

static PRISON_BASE_ZONE;
static SECT2_ZONE;
static SECT1_ZONE;
static B07_CELL_ZONE;

static TWIN_EXT_OBJ;

static TWIN_INT_SECT1;
static TWIN_INT_SECT2;
static TWIN_INT_SHU;
static TWIN_INT_YARD;
static TWIN_INT_PROPS_S2;
static TWIN_INT_PROPS_S1;

// Eventually move these settings
enum E_PRISON_SETTING
{
    bool:E_PRISON_SETTING_SHOWERS = 1,
    bool:E_PRISON_SETTING_LOCKDOWN
}

static PrisonSetting[E_PRISON_SETTING];

forward GetPrisonSetting(E_PRISON_SETTING:setting);
public GetPrisonSetting(E_PRISON_SETTING:setting)
{
    return PrisonSetting[setting];
}

forward SetPrisonSetting(E_PRISON_SETTING:setting, value);
public SetPrisonSetting(E_PRISON_SETTING:setting, value)
{
    PrisonSetting[setting] = value;
}

enum E_PLAYER_PRISON
{
    bool:E_PLAYER_PRISON_INSIDE,
    E_PLAYER_PRISON_SECTOR
}

new PlayerPrisonVar[MAX_PLAYERS][E_PLAYER_PRISON];

forward IsPlayerInsidePrison(playerid);
public IsPlayerInsidePrison(playerid)
{
    return PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE];
}

static enum E_PRISON_SCRIPT_AREAS
{
    PRISON_AREA_BASE = 1,
    PRISON_AREA_B07,
    PRISON_AREA_EXCLUDE_1,
    PRISON_AREA_EXCLUDE_2,
    PRISON_AREA_ELEVATOR,
    PRISON_AREA_SECTOR2
}

static enum E_PRISON_AREA
{
    E_PRISON_AREA_NAME[32],
    Float:E_PRISON_AREA_MIN_X,
    Float:E_PRISON_AREA_MIN_Y,
    Float:E_PRISON_AREA_MIN_Z,
    Float:E_PRISON_AREA_MAX_X,
    Float:E_PRISON_AREA_MAX_Y,
    Float:E_PRISON_AREA_MAX_Z,
    E_PRISON_SCRIPT_AREAS:E_PRISON_AREA_SCRIPT_ID,
    STREAMER_TAG_AREA E_PRISON_AREA_AREA
}

static PrisonAreas[][E_PRISON_AREA] = 
{
    { "Prison Interior", -48.0, -49.0, -5.0, 32.0, 41.0, 11.0, PRISON_AREA_BASE },
    { "Cell B07", -28.959, 12.134, 4.468, -24.12, 18.662, 8.868, PRISON_AREA_B07 },
    { "Sec 2 Exclusion", -35.5, -2.773, -4.897, 29.873, 39.137, 9.023, PRISON_AREA_EXCLUDE_2, },
    { "Sec 1 Exclusion", -31.012, -47.061, -0.33, 29.873, -2.459, 9.023, PRISON_AREA_EXCLUDE_1 },
    { "Elevator Lobby", 20.612, -21.957, -0.33, 29.051, 29.745, 9.023, PRISON_AREA_ELEVATOR },
    { "Sector 2", -17.574, -8.096, -0.33, 20.338, 38.674, 9.023, PRISON_AREA_SECTOR2 },

    { "Medical Ward", 1767.7415, -1593.4253, 33.0, 1785.3210, -1584.9172, 38.0 },
    { "Control Room", 1782.3527, -1564.6868, 37.0, 1789.2810, -1549.0000, 39.0 }
};

static RefreshPrison(playerid)
{
    CallLocalFunction("OnPlayerPrisonUpdate", "d", playerid);
}

static IsPlayerInPrisonArea(playerid, E_PRISON_SCRIPT_AREAS:area)
{
    if (IsPlayerInAnyDynamicArea(playerid))
    {
        for (new i = 0; i < sizeof(PrisonAreas); i ++)
        {
            if (PrisonAreas[i][E_PRISON_AREA_SCRIPT_ID] != area) continue;
            return IsPlayerInDynamicArea(playerid, PrisonAreas[i][E_PRISON_AREA_AREA]);
        }
    }
    
    return 0;
}

static CreatePrisonIntObject(model, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 400.0, Float:drawdistance = 400.0)
{
    #pragma unused rz

    new base = PrisonIntObjects[0];

    if (base)
    {
        GetDynObjRelativePos(base, x, y, z, x, y, z);
    }

    new obj = CreateDynamicObject(model, x, y, z, rx, ry, TWIN_INT_RZ, worldid, interiorid, playerid, streamdistance, drawdistance);
    
    PrisonIntObjects[LastPrisonIntObject] = obj;

    if (!base)
    {
        new Float:x2, Float:y2, Float:z2;
        new Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz;

        for (new i = 0; i < sizeof(PrisonAreas); i ++)
        {
            minx = PrisonAreas[i][E_PRISON_AREA_MIN_X];
            miny = PrisonAreas[i][E_PRISON_AREA_MIN_Y];
            minz = PrisonAreas[i][E_PRISON_AREA_MIN_Z];

            maxx = PrisonAreas[i][E_PRISON_AREA_MAX_X];
            maxy = PrisonAreas[i][E_PRISON_AREA_MAX_Y];
            maxz = PrisonAreas[i][E_PRISON_AREA_MAX_Z];

            if (minx < 1000) // assuming that's a relative position
            {
                GetDynObjRelativePos(obj, x, y, z, PrisonAreas[i][E_PRISON_AREA_MIN_X], PrisonAreas[i][E_PRISON_AREA_MIN_Y], PrisonAreas[i][E_PRISON_AREA_MIN_Z]); 
                GetDynObjRelativePos(obj, x2, y2, z2, PrisonAreas[i][E_PRISON_AREA_MAX_X], PrisonAreas[i][E_PRISON_AREA_MAX_Y], PrisonAreas[i][E_PRISON_AREA_MAX_Z]);

                minx = x < x2 ? x : x2;
                miny = y < y2 ? y : y2;
                minz = z < z2 ? z : z2;

                maxx = x2 < x ? x : x2;
                maxy = y2 < y ? y : y2;
                maxz = z2 < z ? z : z2;
            }
            
            PrisonAreas[i][E_PRISON_AREA_AREA] = CreateDynamicCuboid(minx, miny, minz, maxx, maxy, maxz);
            printf("Created prison area %s: MIN: %.02f, %.02f, %.02f  MAX: %.02f, %.02f, %.02f", PrisonAreas[i][E_PRISON_AREA_NAME], minx, miny, minz, maxx, maxy, maxz);
        }
    }

    LastPrisonIntObject ++;
    return obj;
}   

static RemoveBuildings(playerid)
{
    RemoveBuildingForPlayer(playerid, 3999, 1785.9766, -1564.8594, 25.2500, 0.25);
    RemoveBuildingForPlayer(playerid, 4079, 1785.9766, -1564.8594, 25.2500, 0.25);
}

forward OnPlayerPrisonUpdate(playerid);
public OnPlayerPrisonUpdate(playerid)
{
    for (new i = 0; i < sizeof(PrisonIntObjects); i ++)
    {
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, PrisonIntObjects[i], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
    }

    Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_EXT_OBJ, !PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);

    if (PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE] && GetPVarInt(playerid, "CCTV") != 1)
    {
        new sec2 = IsPlayerInPrisonArea(playerid, PRISON_AREA_EXCLUDE_2);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_SECT2, sec2);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_PROPS_S2, sec2);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_SHU, sec2);

        new b07 = IsPlayerInPrisonArea(playerid, PRISON_AREA_B07);
        
        if (sec2)
        {
            Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_SHU, !b07);
            Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_SECT2, !b07);
            Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_PROPS_S2, !b07);
        }

        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_YARD, !b07);

        new sec1 = IsPlayerInPrisonArea(playerid, PRISON_AREA_EXCLUDE_1);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_SECT1, sec1);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, TWIN_INT_PROPS_S1, sec1);

        if (IsPlayerInPrisonArea(playerid, PRISON_AREA_SECTOR2) && PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] != 2)
        {
            SendClientMessage(playerid, -1, "You are now in Sector 2");
            PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] = 2;
        }
        else if (IsPlayerInPrisonArea(playerid, PRISON_AREA_ELEVATOR) && PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] != 3)
        {
            SendClientMessage(playerid, -1, "You are now in the Lobby between Sectors");
            PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] = 3;
        }
        else if (PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] != 1)
        {
            SendClientMessage(playerid, -1, "You are now in Sector 1");
            PlayerPrisonVar[playerid][E_PLAYER_PRISON_SECTOR] = 1;
        }
    }

    return 1;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

forward OnPrisonLoad();
public OnPrisonLoad()
{
	// Hook this in the other includes.
	return 1;
}

// When this eventually moves to the gamemode, all you need to do is change it to hook OnGameModeInit instead.
public OnFilterScriptInit()
{
	CallLocalFunction("OnPrisonLoad", "", "");
	print("Loaded Prison");
	return 1;
}

// When this eventually moves to the gamemode, all you need to do is change it to hook OnGameModeExit instead.
public OnFilterScriptExit()
{
	print("Unloaded Prison");
	return 1;
}


// Hook of OnPrisonLoad for the header (which handles the main stuff atm like exterior/interior but not subsystems like CCTV or Doors)
hook OnPrisonLoad()
{
    #pragma warning disable 204

    // Add models
    AddSimpleModel(-1,  8674, -7510, "twin/int/ttp_alphas.dff", "twin/int/ttp_alphas.txd");
    AddSimpleModel(-1, 19379, -7511, "twin/int/ttp_cellprops.dff", "twin/int/ttp_cellprops.txd");

    AddSimpleModel(-1, 19379, -7512, "twin/int/ttp_struct_main.dff", "twin/int/ttp_structure.txd");
    AddSimpleModel(-1, 19379, -7513, "twin/int/ttp_struct_sect1.dff", "twin/int/ttp_structure.txd");
    AddSimpleModel(-1, 19379, -7514, "twin/int/ttp_struct_sect2.dff", "twin/int/ttp_structure.txd");
    AddSimpleModel(-1, 19379, -7515, "twin/int/ttp_struct_shu.dff", "twin/int/ttp_structure.txd");
    AddSimpleModel(-1, 19379, -7516, "twin/int/ttp_struct_yard.dff", "twin/int/ttp_structure.txd");

    AddSimpleModel(-1, 19379, -7517, "twin/int/ttp_props1_main.dff", "twin/int/ttp_props1.txd");
    AddSimpleModel(-1, 19379, -7518, "twin/int/ttp_props_sect1.dff", "twin/int/ttp_props1.txd");
    AddSimpleModel(-1, 19379, -7519, "twin/int/ttp_props2_main.dff", "twin/int/ttp_props2.txd");
    AddSimpleModel(-1, 19379, -7520, "twin/int/ttp_props_sect2.dff", "twin/int/ttp_props2.txd");

    AddSimpleModel(-1, 8674, -7521, "twin/int/ttp_gates.dff", "twin/int/ttp_gate.txd");

    /*
    AddCharModel(263, 20300, "prison_skins/fem/white.dff", "prison_skins/fem/white.txd" ) ;
    AddCharModel(69, 20301, "prison_skins/fem/black.dff", "prison_skins/fem/black.txd" ) ;
    AddCharModel(56, 20302, "prison_skins/fem/asian.dff", "prison_skins/fem/asian.txd" ) ;
    AddCharModel(233, 20303, "prison_skins/fem/mixed.dff", "prison_skins/fem/mixed.txd" ) ;
    AddCharModel(41, 20304, "prison_skins/fem/hispanic.dff", "prison_skins/fem/hispanic.txd" ) ;
    */

    // Interior
    new base = CreatePrisonIntObject(-7512, TWIN_INT_X, TWIN_INT_Y, TWIN_INT_Z, 0.0000, 0.0000, TWIN_INT_RZ, -1, -1, -1, 300.00, 300.00); //ttp_struct_main
    TWIN_INT_SECT1 = CreatePrisonIntObject(-7513, 2.095, -24.645, 2.429, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_struct_sect1
    TWIN_INT_SECT2 = CreatePrisonIntObject(-7514, 2.040, 21.236, 1.949, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_struct_sect2
    TWIN_INT_SHU = CreatePrisonIntObject(-7515, -24.083, 22.42, 0.289, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_struct_shu
    TWIN_INT_YARD = CreatePrisonIntObject(-7516, -0.46, 26.471, 3.243, 0.0000, 0.0000, 0.0000, -1, -1, -1, 75.00, 75.00); //ttp_struct_yard
    
    new alphas = CreatePrisonIntObject(-7510, 0.0, 0.0, 0.0, 0.0000, 0.0000, 0.0000, -1, -1, -1, 300.00, 300.00); //ttp_alphas
	new cellprops = CreatePrisonIntObject(-7511, -35.5762, -3.6083, 6.3009, 0.0000, 0.0000, 0.0000, -1, -1, -1, 75.00, 75.00); //ttp_cellprops
	
    new props1 = CreatePrisonIntObject(-7517, -3.8472, -10.6694, 2.3030, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_props1_main
    TWIN_INT_PROPS_S1 = CreatePrisonIntObject(-7518, 3.25, -24.63, 2.215, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_props_sect1

	new props2 = CreatePrisonIntObject(-7519, -14.2421, -0.1604, 5.7779, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_props2_main
    TWIN_INT_PROPS_S2 = CreatePrisonIntObject(-7520, 5.849, 20.909, 2.135, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ttp_props_sect2

    new gates = CreatePrisonIntObject(-7521, -19.586, 14.657, 0.199,   0.00, 0.00, 0.00, -1, -1, -1, 100.00, 100.00);  

    // Exterior
    TWIN_EXT_OBJ = CreateDynamicObject(4079, 1785.98, -1564.86, 25.25,   0.00, 0.00, -4.98, -1, 0, -1, 600.00, 600.00);  

    // Remove buildings for connected players (only needed if loading as a fs and already ig)
    foreach (new i:Player)
    {
        RemoveBuildings(i);
        RefreshPrison(i);
    }

    return 1;
}

hook OnPlayerConnect(playerid)
{
    // Clear player prison vars
    new pvar_clear[E_PLAYER_PRISON];
    PlayerPrisonVar[playerid] = pvar_clear;

    // Do other stuff
    RemoveBuildings(playerid);
    RefreshPrison(playerid);
    return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA areaid)
{
    new index = -1;

    for (new i = 0; i < sizeof(PrisonAreas); i ++)
    {
        if (PrisonAreas[i][E_PRISON_AREA_AREA] == areaid)
        {
            index = i;
            break;
        }
    }

    if (index == -1) return 1;

    if (PrisonAreas[index][E_PRISON_AREA_SCRIPT_ID] == PRISON_AREA_BASE)
    {
        PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE] = true;
        PlayerPlaySound(playerid, 1, 0.0, 0.0, 0.0);
    }

    RefreshPrison(playerid);
    ShowPlayerFooter(playerid, sprintf("You entered Area %d: \"%s\".", index, PrisonAreas[index][E_PRISON_AREA_NAME]));

    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA areaid)
{
    new index = -1;

    for (new i = 0; i < sizeof(PrisonAreas); i ++)
    {
        if (PrisonAreas[i][E_PRISON_AREA_AREA] == areaid)
        {
            index = i;
            break;
        }
    }

    if (index == -1) return 1;

    if (PrisonAreas[index][E_PRISON_AREA_SCRIPT_ID] == PRISON_AREA_BASE)
    {
        PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE] = false;
        PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
    }

    RefreshPrison(playerid);
    ShowPlayerFooter(playerid, sprintf("You left Area %d: \"%s\".", index, PrisonAreas[index][E_PRISON_AREA_NAME]));

    return 1;
}

CMD:togtwinobj(playerid, params[])
{
    new objectid, toggle;

	if (sscanf(params, "dd", objectid, toggle) || (toggle != 0 && toggle != 1)) 
    {
        return SendClientMessage(playerid, -1, "/togtwinobj [model id] [0/1]");
	}

    for (new i = 0; i < sizeof(PrisonIntObjects); i ++)
    {
        if (GetDynamicObjectModel(PrisonIntObjects[i]) == objectid)
        {
            Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, PrisonIntObjects[i], toggle);
            SendClientMessage(playerid, -1, sprintf("Toggled dynobj %d: %s", PrisonIntObjects[i], toggle ? "on" : "off"));
            return true;
        }   
    }

    SendClientMessage(playerid, -1, "Failed to find prison object with that model.");
    return true;
}

CMD:gotoprison(playerid)
{
    SetPlayerPos(playerid, TWIN_INT_X, TWIN_INT_Y, TWIN_INT_Z);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE] = true;
    RefreshPrison(playerid);
    return true;
}

// All the other prison shit is done separately.
#include "../gamemode/prison/wip/control.pwn"
#include "../gamemode/prison/wip/shower.pwn"
#include "../gamemode/prison/wip/cctv.pwn"
#include "../gamemode/prison/wip/tannoy.pwn"
#include "../gamemode/prison/wip/doors.pwn"
#include "../gamemode/prison/wip/raknet.pwn"