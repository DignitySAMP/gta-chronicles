//------------------------------------------------------------------------------
// Prison shower script
// Written by Sporky (www.github.com/sporkyspork) for SOLS

// TODO: Add a skin change point to change into shower skins?
// TODO: Make the shower turn off automatically after X minutes
// TODO: Let Control disable the showers

#include <YSI_Coding\y_hooks>
#define SHOWER_MODEL_PD     -25300
#define SHOWER_MODEL_JAIL   -7525  

static CreatingShower[MAX_PLAYERS];

enum E_SHOWER_DATA
{
    E_SHOWER_MODEL,
    Float:E_SHOWER_POS_X,
    Float:E_SHOWER_POS_Y,
    Float:E_SHOWER_POS_Z,
    Float:E_SHOWER_ROT_X,
    Float:E_SHOWER_ROT_Y,
    Float:E_SHOWER_ROT_Z,
    E_SHOWER_OBJ_BASE,
    E_SHOWER_OBJ_PTFX,
    E_SHOWER_OBJ_SOUND,
    STREAMER_TAG_3D_TEXT_LABEL E_SHOWER_LABEL,
    Float:E_SHOWER_LABEL_POS[3],
    bool:E_SHOWER_ON
}

static enum E_SHOWER_MODEL_DATA
{
    E_SHOWER_MODEL_ID,
    E_SHOWER_MODEL_2DFX_ID,
    Float:E_SHOWER_MODEL_2DFX_POS[3],
    Float:E_SHOWER_MODEL_2DFX_ROT[3]
}

static const ShowerModels[][E_SHOWER_MODEL_DATA] = 
{
    {SHOWER_MODEL_PD, 18676, {-0.0, 1.10, -0.48}, {0.00, 52.50, 270.0} },
    {SHOWER_MODEL_JAIL, 18676, {-0.0, 1.10, -0.48}, {0.00, 52.50, 270.0} }
};

static const Showers[][E_SHOWER_DATA] = 
{
    { SHOWER_MODEL_PD, -11.67, -103.90, 899.25, 0.00, 0.00, 0.00 },
    { SHOWER_MODEL_PD, -9.97, -105.03, 899.25, 0.00, 0.00, 270.0 },
    { SHOWER_MODEL_JAIL, 1792.142, -1528.886, 34.205, 0.000, 0.000, 90.000 },
    { SHOWER_MODEL_JAIL, 1792.142, -1527.306, 34.205, 0.000, 0.000, 90.000 },
    { SHOWER_MODEL_JAIL, 1794.577, -1525.813, 34.205, 0.000, 0.000, 0.000 },
    { SHOWER_MODEL_JAIL, 1797.087, -1525.813, 34.205, 0.000, 0.000, 0.000 },
    { SHOWER_MODEL_JAIL, 1799.546, -1525.813, 34.205, 0.000, 0.000, 0.000 },
    { SHOWER_MODEL_JAIL, 1802.117, -1525.813, 34.205, 0.000, 0.000, 0.000 },
    { SHOWER_MODEL_JAIL, 1804.455, -1528.706, 34.195, 0.000, 0.000, 270.000 },
    { SHOWER_MODEL_JAIL, 1804.455, -1527.165, 34.195, 0.000, 0.000, 270.000 }
};

GetPlayerClosestShower(playerid, Float:radius = 1.25)
{
    new closest = -1;
    new Float:current;
    new Float:last = radius;

    for (new i = 0; i < sizeof(Showers); i ++)
    {
        current = GetPlayerDistanceFromPoint(playerid, Showers[i][E_SHOWER_LABEL_POS][0], Showers[i][E_SHOWER_LABEL_POS][1], Showers[i][E_SHOWER_LABEL_POS][2]);
        if (current < last)
        {
            closest = i;
            last = current;
        }
    }

    return closest;
}

static GetShowerModelIndex(shower)
{
    for (new i = 0; i < sizeof(ShowerModels); i ++)
    {
        if (ShowerModels[i][E_SHOWER_MODEL_ID] == Showers[shower][E_SHOWER_MODEL])
        {
            return i;
        }
    }

    return 0;
}

static UpdateShower(shower)
{
    new i = shower, model = GetShowerModelIndex(shower);
    new Float:x =   Showers[i][E_SHOWER_POS_X]; 
    new Float:y =   Showers[i][E_SHOWER_POS_Y];
    new Float:z =   Showers[i][E_SHOWER_POS_Z]; 
    new Float:rx =  Showers[i][E_SHOWER_ROT_X];
    new Float:ry =  Showers[i][E_SHOWER_ROT_Y]; 
    new Float:rz =  Showers[i][E_SHOWER_ROT_Z];

    if (IsValidDynamicObject(Showers[i][E_SHOWER_OBJ_PTFX])) DestroyDynamicObject(Showers[i][E_SHOWER_OBJ_PTFX]);
    if (IsValidDynamicObject(Showers[i][E_SHOWER_OBJ_SOUND])) DestroyDynamicObject(Showers[i][E_SHOWER_OBJ_SOUND]);

    if (Showers[shower][E_SHOWER_ON])
    {
        GetDynObjRelativePos(Showers[i][E_SHOWER_OBJ_BASE], x, y, z, ShowerModels[model][E_SHOWER_MODEL_2DFX_POS][0], ShowerModels[model][E_SHOWER_MODEL_2DFX_POS][1], ShowerModels[model][E_SHOWER_MODEL_2DFX_POS][2]);
        Showers[i][E_SHOWER_OBJ_PTFX] = CreateDynamicObject(ShowerModels[model][E_SHOWER_MODEL_2DFX_ID], x, y, z, rx + ShowerModels[model][E_SHOWER_MODEL_2DFX_ROT][0], ry + ShowerModels[model][E_SHOWER_MODEL_2DFX_ROT][1], rz + ShowerModels[model][E_SHOWER_MODEL_2DFX_ROT][2]);
        
        GetDynObjRelativePos(Showers[i][E_SHOWER_OBJ_BASE], x, y, z, 0.0, -0.5, -9.0);
        Showers[i][E_SHOWER_OBJ_SOUND] = CreateDynamicObject(18739, x, y, z, 0.0, 0.0, 0.0);
    }

    if (IsValidDynamic3DTextLabel(Showers[i][E_SHOWER_LABEL])) DestroyDynamic3DTextLabel(Showers[i][E_SHOWER_LABEL]);
    if (Showers[shower][E_SHOWER_ON]) Showers[i][E_SHOWER_LABEL] = CreateDynamic3DTextLabel("[Shower]{DEDEDE}\nPress {c4a656}~k~~GROUP_CONTROL_BWD~ {DEDEDE}to turn off.", 0x3479E3FF, Showers[i][E_SHOWER_LABEL_POS][0], Showers[i][E_SHOWER_LABEL_POS][1], Showers[i][E_SHOWER_LABEL_POS][2], 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
    else Showers[i][E_SHOWER_LABEL] = CreateDynamic3DTextLabel("[Shower]{DEDEDE}\nPress {c4a656}~k~~GROUP_CONTROL_BWD~ {DEDEDE}to turn on.", 0x3479E3FF, Showers[i][E_SHOWER_LABEL_POS][0], Showers[i][E_SHOWER_LABEL_POS][1], Showers[i][E_SHOWER_LABEL_POS][2], 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
}


// ----------------------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
    CreatingShower[playerid] = 0;
    return 1;
}

// Hook of OnPrisonLoad for shower
hook OnPrisonLoad()
{
    // Add models
    AddSimpleModel(-1, 1923, SHOWER_MODEL_PD, "twin/int/pdshower.dff", "twin/int/pdshower.txd");
    AddSimpleModel(-1, 1923, SHOWER_MODEL_JAIL, "twin/int/jailshower.dff", "twin/int/jailshower.txd");
    
    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    for (new i = 0; i < sizeof(Showers); i ++)
    {
        x = Showers[i][E_SHOWER_POS_X];
        y = Showers[i][E_SHOWER_POS_Y];
        z = Showers[i][E_SHOWER_POS_Z];
        rx = Showers[i][E_SHOWER_ROT_X];
        ry = Showers[i][E_SHOWER_ROT_Y];
        rz = Showers[i][E_SHOWER_ROT_Z];

        Showers[i][E_SHOWER_OBJ_BASE] = CreateDynamicObject(Showers[i][E_SHOWER_MODEL], x, y, z, rx, ry, rz);
        GetDynObjRelativePos(Showers[i][E_SHOWER_OBJ_BASE], Showers[i][E_SHOWER_LABEL_POS][0], Showers[i][E_SHOWER_LABEL_POS][1], Showers[i][E_SHOWER_LABEL_POS][2], 0.0, -0.01, -0.45);
        UpdateShower(i);
    }

    // Enable showers by default
    SetPrisonSetting(E_PRISON_SETTING_SHOWERS, true);
    return 1;
}

hook OnPlayerPrisonUpdate(playerid)
{
    // Hide/unhide depending on whether they are in the interior or not

    for (new i = 0; i < sizeof(Showers); i ++)
    {
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, Showers[i][E_SHOWER_OBJ_BASE], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, Showers[i][E_SHOWER_OBJ_PTFX], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, Showers[i][E_SHOWER_OBJ_SOUND], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, Showers[i][E_SHOWER_LABEL], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
    }

    return 1;
}

hook OnPrisonControlSelected(playerid, E_CONTROL_OPTION_IDX:option)
{  
    if (option == E_CONTROL_OPTION_SHOWER)
    {
        // Toggle on/off the showers.
        SetPrisonSetting(E_PRISON_SETTING_SHOWERS, !GetPrisonSetting(E_PRISON_SETTING_SHOWERS));

        if (!GetPrisonSetting(E_PRISON_SETTING_SHOWERS))
        {
            new affected = 0;

            // If off, actually stop them all too
            for (new i = 0; i < sizeof(Showers); i ++)
            {
                if (Showers[i][E_SHOWER_ON])
                {
                    Showers[i][E_SHOWER_ON] = false;
                    UpdateShower(i);

                    affected ++;
                }
            }

            // Send a streamer update too, but only if necessary
            if (affected)
            {
                foreach (new i:Player)
                {
                    if (IsPlayerInsidePrison(i))
                    {
                        Streamer_Update(i);
                    }
                }
            }
        }
    }
    
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED(KEY_CTRL_BACK))
    {
        if (!GetPrisonSetting(E_PRISON_SETTING_SHOWERS))
        {
            PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
            ShowPlayerFooter(playerid, "~r~The showers are currently disabled by the control room.");
            return 1;
        }

        new closest = GetPlayerClosestShower(playerid);
        if (closest >= 0)
        {   
            Showers[closest][E_SHOWER_ON] = !Showers[closest][E_SHOWER_ON];
            UpdateShower(closest);
            Streamer_Update(playerid);
        }
    }

	return 1;
}



// --------------------------------------------------------------
// Dev stuff down here
#warning "Remove shower dev code before building final prison"

CMD:createshower(playerid)
{
    if (CreatingShower[playerid]) return 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new shower = CreateDynamicObject(SHOWER_MODEL_PD, x, y, z, 0.0, 0.0, 0.0);
    EditDynamicObject(playerid, shower);
    CreatingShower[playerid] = 1;

    print("Prison: Loaded Shower");
    return 1;
}

/*
hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz) 
{
    if (!CreatingShower[playerid]) return 0;

    if (response == EDIT_RESPONSE_FINAL)
    {
        if (CreatingShower[playerid] == 1)
        {
            // Shower
            printf("{%d, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f},", GetDynamicObjectModel(objectid), x, y, z, rx, ry, rz);
            new particle = CreateDynamicObject(18676, x, y, z, rx, ry, rz);
            EditDynamicObject(playerid, particle);
            CreatingShower[playerid] = 2;
        }
        else
        {
            // Particle
            printf("{%d, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f},", GetDynamicObjectModel(objectid), x, y, z, rx, ry, rz);
            CreatingShower[playerid] = 0;
        }
    }
    else if (response == EDIT_RESPONSE_CANCEL)
    {
        DestroyDynamicObject(objectid);
        CreatingShower[playerid] = 0;
    }

    return 1;
}
*/	

/*
hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz) 
{
    if (!CreatingShower[playerid]) return 0;

    if (response == EDIT_RESPONSE_FINAL)
    {
        if (CreatingShower[playerid] == 1)
        {
            // Shower
            printf("{%d, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f},", GetDynamicObjectModel(objectid), x, y, z, rx, ry, rz);
            CreatingShower[playerid] = 0;
        }
    }
    else if (response == EDIT_RESPONSE_CANCEL)
    {
        DestroyDynamicObject(objectid);
        CreatingShower[playerid] = 0;
    }

    return 1;
}
*/
