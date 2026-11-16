//------------------------------------------------------------------------------
// Prison Doors System
// Written by Sporky (www.github.com/sporkyspork) for SOLS

// TODO: Let prisoners open their own cell door
// TODO: Let control override this ^ for lockdowns etc
// TODO: Better support for the gates between sectors

#include <YSI_Coding\y_hooks>

#define PENDOOR1_MODEL -7507
#define PENDOOR2_MODEL -7508
#define PENDOOR3_MODEL -7509
#define GATEDOOR_MODEL -7522
#define PENDOOR_SPEED 0.01
#define GATE_SPEED 1.0

enum
{
    PRISON_DOOR_TYPE_CELL,
    PRISON_DOOR_TYPE_GATE
}

enum
{
    PRISON_DOOR_GROUP_A_POD,
    PRISON_DOOR_GROUP_B_POD,
    PRISON_DOOR_GROUP_SEC_1,
    PRISON_DOOR_GROUP_SEC_2,
    PRISON_DOOR_GROUP_SHU,
    PRISON_DOOR_GROUP_LOBBY
}

enum E_PRISON_DOOR_DATA
{
    E_PRISON_DOOR_NAME[32],
    E_PRISON_DOOR_MODEL,
    E_PRISON_DOOR_TYPE,
    E_PRISON_DOOR_GROUP,
    Float:E_PRISON_DOOR_POS_X,
    Float:E_PRISON_DOOR_POS_Y,
    Float:E_PRISON_DOOR_POS_Z,
    Float:E_PRISON_DOOR_ROT_X,
    Float:E_PRISON_DOOR_ROT_Y,
    Float:E_PRISON_DOOR_ROT_Z,
    bool:E_PRISON_DOOR_POS_RELATIVE,
    bool:E_PRISON_DOOR_OPEN,
    STREAMER_TAG_OBJECT E_PRISON_DOOR_OBJECT,
    STREAMER_TAG_3D_TEXT_LABEL E_PRISON_DOOR_LABEL,
    bool:E_PRISON_DOOR_IS_OPEN
}

static const PrisonDoor[][E_PRISON_DOOR_DATA] = 
{
    { "A01", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -40.789, -21.415, 4.651, 0.000, 0.000, -50.0, true },
    { "A02", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -17.523, 4.651, 0.000, 0.000, -90.0, true },
    { "A03", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -13.595, 4.651, 0.000, 0.000, -90.0, true },
    { "A04", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -9.668, 4.651, 0.000, 0.000, 270.0, true },
    { "A05", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -5.740, 4.651, 0.000, 0.000, 270.0, true },
    { "A06", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -1.812, 4.651, 0.000, 0.000, 270.0, true },
    { "A07", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -40.789, -21.415, 0.199, 0.000, 0.000, -50.0, true },
    { "A08", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -17.523, 0.199, 0.000, 0.000, 270.0, true },
    { "A09", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -13.595, 0.199, 0.000, 0.000, 270.0, true },
    { "A10", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -9.668, 0.199, 0.000, 0.000, 270.0, true },
    { "A11", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -5.740, 0.199, 0.000, 0.000, 270.0, true },
    { "A12", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_A_POD, -41.105, -1.812, 0.199, 0.000, 0.000, 270.0, true },

    { "B01", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -25.041, 14.42, 0.199, 0.000, 0.000, -170.0, true },
    { "B02", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -28.789, 13.408, 0.199, 0.000, 0.000, -130.0, true },
    { "B03", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -31.313, 10.399, 0.199, 0.000, 0.000, -130.0, true },
    { "B04", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -33.838, 7.390, 0.199, 0.000, 0.000, -130.0, true },
    { "B05", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -36.363, 4.382, 0.199, 0.000, 0.000, -130.0, true },
    { "B06", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -38.887, 1.373, 0.199, 0.000, 0.000, -130.0, true },
    { "B07", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -25.041, 14.42, 4.651, 0.000, 0.000, -170.0, true },
    { "B08", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -28.789, 13.408, 4.651, 0.000, 0.000, -130.0, true },
    { "B09", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -31.313, 10.399, 4.651, 0.000, 0.000, -130.0, true },
    { "B10", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -33.838, 7.390, 4.651, 0.000, 0.000, -130.0, true },
    { "B11", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -36.363, 4.382, 4.651, 0.000, 0.000, -130.0, true },
    { "B12", PENDOOR1_MODEL, PRISON_DOOR_TYPE_CELL, PRISON_DOOR_GROUP_B_POD, -38.887, 1.373, 4.651, 0.000, 0.000, -130.0, true },

    { "S1 / 187 Pod", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SEC_1, -17.229, -19.735, 0.199, 0.0, 0.0, 180.0, true, true },
    { "S1 / Inmate Hallway", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_LOBBY, -10.387, -19.735, 0.199, 0.0, 0.0, 180.0, true, true },
    { "S2 / Inmate Hallway", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_LOBBY, 15.009, -19.735, 0.199, 0.0, 0.0, 180.0, true, false },
    { "S2 / Elevators", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_LOBBY, 20.692, -19.735, 0.199, 0.0, 0.0, 180.0, true, false },
    { "S2 / Elevators", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_LOBBY, 20.601, 27.122, 0.199, 0.0, 0.0, 0.0, true, false },
    { "S2 / Staff Hallway", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SEC_2, 14.714, 27.122, 0.199, 0.0, 0.0, 0.0, true, false },
    { "S2 / Staff Hallway", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SEC_2, -10.318, 26.114, 0.199, 0.0, 0.0, 0.0, true, false },
    { "S1 / Staff Hallway", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SEC_2, -17.286, 26.114, 0.199, 0.0, 0.0, 0.0, true, false },
    { "S1 / Confinement", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SHU, -23.320, 22.747, 0.199, 0.0, 0.0, 0.0, true, false },
    { "S1 / 187 Pod", GATEDOOR_MODEL, PRISON_DOOR_TYPE_GATE, PRISON_DOOR_GROUP_SEC_1, -19.097, 14.679, 0.199, 0.0, 0.0, 270.0, true, false }
};

static OpenDoor(door)
{
    if (!PrisonDoor[door][E_PRISON_DOOR_IS_OPEN])
    {
        if (PrisonDoor[door][E_PRISON_DOOR_TYPE] == PRISON_DOOR_TYPE_GATE)
        {
            new Float:x, Float:y, Float:z;
            GetDynObjRelativePos(PrisonDoor[door][E_PRISON_DOOR_OBJECT], x, y, z, 0.0, 2.0, 0.0);
            MoveDynamicObject(PrisonDoor[door][E_PRISON_DOOR_OBJECT], x, y, z, GATE_SPEED);
        } 
        else MoveDynamicObject(PrisonDoor[door][E_PRISON_DOOR_OBJECT], PrisonDoor[door][E_PRISON_DOOR_POS_X] - 0.01, PrisonDoor[door][E_PRISON_DOOR_POS_Y] + 0.01, PrisonDoor[door][E_PRISON_DOOR_POS_Z], PENDOOR_SPEED, 0.0, 0.0, PrisonDoor[door][E_PRISON_DOOR_ROT_Z] - 85.0);
        
        PrisonDoor[door][E_PRISON_DOOR_IS_OPEN] = true;

        foreach (new playerid : Player)
        {
            if (!IsPlayerConnected(playerid)) continue;
            PlayerPlaySound(playerid, 6002, PrisonDoor[door][E_PRISON_DOOR_POS_X], PrisonDoor[door][E_PRISON_DOOR_POS_Y], PrisonDoor[door][E_PRISON_DOOR_POS_Z]);
        }
    }

    return 1;
}

static CloseDoor(door)
{
    if (PrisonDoor[door][E_PRISON_DOOR_IS_OPEN])
    {
        if (PrisonDoor[door][E_PRISON_DOOR_TYPE] == PRISON_DOOR_TYPE_GATE)
        {
            MoveDynamicObject(PrisonDoor[door][E_PRISON_DOOR_OBJECT], PrisonDoor[door][E_PRISON_DOOR_POS_X], PrisonDoor[door][E_PRISON_DOOR_POS_Y], PrisonDoor[door][E_PRISON_DOOR_POS_Z], GATE_SPEED);
        }
        else MoveDynamicObject(PrisonDoor[door][E_PRISON_DOOR_OBJECT], PrisonDoor[door][E_PRISON_DOOR_POS_X], PrisonDoor[door][E_PRISON_DOOR_POS_Y], PrisonDoor[door][E_PRISON_DOOR_POS_Z], PENDOOR_SPEED, 0.0, 0.0, PrisonDoor[door][E_PRISON_DOOR_ROT_Z]);
        
        PrisonDoor[door][E_PRISON_DOOR_IS_OPEN] = false;

        foreach (new playerid : Player)
        {
            if (!IsPlayerConnected(playerid)) continue;
            PlayerPlaySound(playerid, 6002, PrisonDoor[door][E_PRISON_DOOR_POS_X], PrisonDoor[door][E_PRISON_DOOR_POS_Y], PrisonDoor[door][E_PRISON_DOOR_POS_Z]);
        }
    }
}

static ToggleDoorGroup(door_group)
{
    // Assume we want to open
    new bool:open = true;

    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        if (PrisonDoor[i][E_PRISON_DOOR_GROUP] != door_group) continue;

        if (PrisonDoor[i][E_PRISON_DOOR_IS_OPEN])
        {
            // If any doors are already open, we should close instead
            open = false;
            break;
        }
    }

    SetPrisonDoorsByGroup(door_group, open);
}

forward SetPrisonDoorsByType(door_type, open);
public SetPrisonDoorsByType(door_type, open)
{
    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        if (PrisonDoor[i][E_PRISON_DOOR_TYPE] == door_type)
        {
            if (open) OpenDoor(i);
            else CloseDoor(i);
        }
    }
}

forward SetPrisonDoorsByGroup(door_group, open);
public SetPrisonDoorsByGroup(door_group, open)
{
    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        if (PrisonDoor[i][E_PRISON_DOOR_GROUP] == door_group)
        {
            if (open) OpenDoor(i);
            else CloseDoor(i);
        }
    }
}

forward SetPrisonDoorByName(name[16], open);
public SetPrisonDoorByName(name[16], open)
{
    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        if (!strcmp(PrisonDoor[i][E_PRISON_DOOR_NAME], name, true))
        {
            if (open) OpenDoor(i);
            else CloseDoor(i);
        }
    }
}

static DoorDlgStr[2048];

forward ShowPrisonDoorDlg(playerid);
public ShowPrisonDoorDlg(playerid)
{
    DoorDlgStr[0] = EOS;
    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        format(DoorDlgStr, sizeof(DoorDlgStr), "%s%s\n", DoorDlgStr, PrisonDoor[i][E_PRISON_DOOR_NAME]);
    }

    inline DlgPrisonDoor(pid, dialogid, response, listitem, string:inputtext[]) 
    {
        #pragma unused pid, dialogid, inputtext, listitem
        
        if (response)
        {
            if (!PrisonDoor[listitem][E_PRISON_DOOR_IS_OPEN]) OpenDoor(listitem);
            else CloseDoor(listitem);
        }
    }

    Dialog_ShowCallback ( playerid, using inline DlgPrisonDoor, DIALOG_STYLE_LIST, "Select Door to Open/Close", DoorDlgStr, "Select", "Back" );
    return 1;
}

hook OnPrisonLoad()
{
    // Add models
    AddSimpleModel(-1, 1493, PENDOOR1_MODEL, "twin/int/pendoor1.dff", "twin/int/pendoors.txd");
    AddSimpleModel(-1, 1493, PENDOOR2_MODEL, "twin/int/pendoor2.dff", "twin/int/pendoors.txd");
    AddSimpleModel(-1, 1493, PENDOOR3_MODEL, "twin/int/pendoor3.dff", "twin/int/pendoors.txd");
    AddSimpleModel(-1, 1493, GATEDOOR_MODEL, "twin/int/ttp_gate.dff", "twin/int/ttp_gate.txd");

    new Float:x, Float:y, Float:z, text[64];
    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        if (PrisonDoor[i][E_PRISON_DOOR_POS_RELATIVE])
        {
            GetRelativePosXYZA(TWIN_INT_X, TWIN_INT_Y, TWIN_INT_Z, TWIN_INT_RZ, PrisonDoor[i][E_PRISON_DOOR_POS_X], PrisonDoor[i][E_PRISON_DOOR_POS_Y], PrisonDoor[i][E_PRISON_DOOR_POS_Z], PrisonDoor[i][E_PRISON_DOOR_POS_X], PrisonDoor[i][E_PRISON_DOOR_POS_Y], PrisonDoor[i][E_PRISON_DOOR_POS_Z]);
            PrisonDoor[i][E_PRISON_DOOR_ROT_Z] = TWIN_INT_RZ + PrisonDoor[i][E_PRISON_DOOR_ROT_Z];
        }

        PrisonDoor[i][E_PRISON_DOOR_OBJECT] = CreateDynamicObject(PrisonDoor[i][E_PRISON_DOOR_MODEL], PrisonDoor[i][E_PRISON_DOOR_POS_X], PrisonDoor[i][E_PRISON_DOOR_POS_Y], PrisonDoor[i][E_PRISON_DOOR_POS_Z], 0.0, 0.0, PrisonDoor[i][E_PRISON_DOOR_ROT_Z]);
        GetDynObjRelativePos(PrisonDoor[i][E_PRISON_DOOR_OBJECT], x, y, z, 0.7, 0.1, 1.1);

        if (PrisonDoor[i][E_PRISON_DOOR_GROUP] == PRISON_DOOR_GROUP_A_POD) format(text, sizeof(text), "[A Pod]{DEDEDE}\n%s", PrisonDoor[i][E_PRISON_DOOR_NAME]);
        else if (PrisonDoor[i][E_PRISON_DOOR_GROUP] == PRISON_DOOR_GROUP_B_POD) format(text, sizeof(text), "[B Pod]{DEDEDE}\n%s", PrisonDoor[i][E_PRISON_DOOR_NAME]);
        else format(text, sizeof(text), "[Gate]{DEDEDE}\n%s", PrisonDoor[i][E_PRISON_DOOR_NAME]);
        PrisonDoor[i][E_PRISON_DOOR_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

        if (PrisonDoor[i][E_PRISON_DOOR_OPEN])
        {
            OpenDoor(i);
        }
    }
    
    print("Prison: Loaded Doors");
    return 1;
}

hook OnPlayerPrisonUpdate(playerid)
{
    // Hide/unhide depending on whether they are in the interior or not

    for (new i = 0; i < sizeof(PrisonDoor); i ++)
    {
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, PrisonDoor[i][E_PRISON_DOOR_OBJECT], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, PrisonDoor[i][E_PRISON_DOOR_LABEL], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
    }

    return 1;
}

hook OnPrisonControlSelected(playerid, E_CONTROL_OPTION_IDX:option)
{  
    switch (option)
    {
        case E_CONTROL_OPTION_A_POD:
        {
            ToggleDoorGroup(PRISON_DOOR_GROUP_A_POD);
        }
        case E_CONTROL_OPTION_B_POD:
        {
            ToggleDoorGroup(PRISON_DOOR_GROUP_B_POD);
        }
        case E_CONTROL_OPTION_CELL:
        {
            ShowPrisonDoorDlg(playerid);
            return -2; // stop processing OnPrisonControlSelected immediately and return 1 (prevents the menu being shown again)
        }
    }

    return 1;
}

