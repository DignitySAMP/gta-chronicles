//------------------------------------------------------------------------------
// Loudspeaker/Tannoy PA System
// Written by Sporky (www.github.com/sporkyspork) for SOLS

#include <YSI_Coding\y_hooks>
#define TANNOY_MODEL -7528

// TODO: Make this like /m but for the prison, basically
// Msgs can be broadcasted from Control using these tannoy speakers

enum E_TANNOY_DATA
{
    Float:E_TANNOY_POS_X,
    Float:E_TANNOY_POS_Y,
    Float:E_TANNOY_POS_Z,
    Float:E_TANNOY_POS_A,
    E_TANNOY_NAME[32],
    E_TANNOY_GROUP,
    Float:E_TANNOY_RANGE,
    STREAMER_TAG_AREA E_TANNOY_ZONE,
    STREAMER_TAG_3D_TEXT_LABEL E_TANNOY_LABEL,
    STREAMER_TAG_OBJECT E_TANNOY_OBJECT
}

static const Tannoy[][E_TANNOY_DATA] = 
{
    { 1789.885, -1556.137, 37.135, 180.0, "187 Pod" },
    { 1780.841, -1537.481, 36.185, 0.000, "S1 Hallway" },
    { 1750.668, -1561.304, 35.925, 0.000, "Entrance"   },
    { 1780.817, -1582.041, 36.671, 0.000, "S2 Hallway" },
    { 1784.504, -1578.681, 31.150, 180.0, "Confinement" },
    { 1785.793, -1575.978, 35.437, 0.000, "Staff Quarters" }
};

hook OnPrisonLoad()
{
    // Add models
    AddSimpleModel(-1, 1923, TANNOY_MODEL, "twin/int/tannoy.dff", "twin/int/tannoy.txd");    
    new Float:x, Float:y, Float:z, text[64];

    
    for (new i = 0; i < sizeof(Tannoy); i ++)
    {
        Tannoy[i][E_TANNOY_OBJECT] = CreateDynamicObject(TANNOY_MODEL, Tannoy[i][E_TANNOY_POS_X], Tannoy[i][E_TANNOY_POS_Y], Tannoy[i][E_TANNOY_POS_Z], 0.0, 0.0, Tannoy[i][E_TANNOY_POS_A]);
        GetDynObjRelativePos(Tannoy[i][E_TANNOY_OBJECT], x, y, z, 0.0, 0.0, -0.25);

        format(text, sizeof(text), "[PA Speaker]{DEDEDE}\n%s", Tannoy[i][E_TANNOY_NAME]);
        Tannoy[i][E_TANNOY_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    }
    
    print("Prison: Loaded Tannoy");
    return 1;
}

hook OnPlayerPrisonUpdate(playerid)
{
    // Hide/unhide depending on whether they are in the interior or not

    for (new i = 0; i < sizeof(Tannoy); i ++)
    {
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, Tannoy[i][E_TANNOY_OBJECT], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, Tannoy[i][E_TANNOY_LABEL], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
    }

    return 1;
}