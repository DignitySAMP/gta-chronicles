//------------------------------------------------------------------------------
// Hunting Eagle Incorporated Building/Interior (DEA Front Company)
// Based on and edit of East Beach Jewllery Store by Ryhes
// Created by Sporky (www.github.com/sporkyspork) for Singleplayer Roleplay (www.stretzofls.com)

#include <YSI_Coding\y_hooks>
#include <zcmd>

#define MODELS_PATH "sporky/eagle"

static enum
{
    EAGLE_JEWEL_BUILD = -3500,
    EAGLE_JEWEL_INT,
    EAGLE_JEWEL_GARAGE,
    EAGLE_LOBBY,
    EAGLE_BITS,
    EAGLE_DOOR_L,
    EAGLE_DOOR_R,
    EAGLE_ROOM,
    EAGLE_FLOOR,
    EAGLE_OFF_MAIN,
    EAGLE_OFF_FLOOR,
    EAGLE_OFF_REFLECT,
    EAGLE_OFF_FURN,
    EAGLE_OFF_GLASS,
    EAGLE_OFF_LIGHTS,
    EAGLE_LIFT,
    EAGLE_LIFT_L,
    EAGLE_LIFT_R
}

hook OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 17584, 2846.0469, -1453.3281, 24.7969, 0.25);
    RemoveBuildingForPlayer(playerid, 1261, 2855.7188, -1470.1250, 44.5000, 0.25);
    RemoveBuildingForPlayer(playerid, 1267, 2855.7188, -1470.1250, 44.5000, 0.25);
    RemoveBuildingForPlayer(playerid, 17585, 2765.0859, -1454.4375, 29.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 17918, 2840.9141, -1404.6953, 45.6797, 0.25);
    RemoveBuildingForPlayer(playerid, 17553, 2846.0469, -1453.3281, 24.7969, 0.25);
    return 1;
}

hook OnGameModeInit()
{
    AddSimpleModel(-1, 1923, EAGLE_JEWEL_BUILD, MODELS_PATH"/eb_jewelry.dff", MODELS_PATH"/eb_jewelry.txd");
    AddSimpleModel(-1, 1923, EAGLE_JEWEL_INT, MODELS_PATH"/eb_jewelry_int.dff", MODELS_PATH"/eb_jewelry_int.txd");
    AddSimpleModel(-1, 1923, EAGLE_JEWEL_GARAGE, MODELS_PATH"/eaglejewel.dff", MODELS_PATH"/eagle.txd");
    AddSimpleModel(-1, 1923, EAGLE_LOBBY, MODELS_PATH"/eaglelobby.dff", MODELS_PATH"/eagle.txd");
    AddSimpleModel(-1, 1923, EAGLE_BITS, MODELS_PATH"/eaglebits.dff", MODELS_PATH"/eagle.txd");
    AddSimpleModel(-1, 1523, EAGLE_DOOR_L, MODELS_PATH"/eagledoor_l.dff", MODELS_PATH"/eagle.txd");
    AddSimpleModel(-1, 1523, EAGLE_DOOR_R, MODELS_PATH"/eagledoor_r.dff", MODELS_PATH"/eagle.txd");
    AddSimpleModel(-1, 1923, EAGLE_ROOM, MODELS_PATH"/eagleroom.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 19325, EAGLE_FLOOR, MODELS_PATH"/eagleroomfloor.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 1923, EAGLE_OFF_MAIN, MODELS_PATH"/eagleupmain.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 19325, EAGLE_OFF_FLOOR, MODELS_PATH"/eagleupfloor.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 1923, EAGLE_OFF_REFLECT, MODELS_PATH"/eagleupreflect.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 1923, EAGLE_OFF_FURN, MODELS_PATH"/eagleupfurn.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 19325, EAGLE_OFF_GLASS, MODELS_PATH"/eagleupglass.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 1923, EAGLE_OFF_LIGHTS, MODELS_PATH"/eagleuplights.dff", MODELS_PATH"/hi_cutlaw2.txd");
    AddSimpleModel(-1, 1923, EAGLE_LIFT, MODELS_PATH"/eaglelift.dff", MODELS_PATH"/eaglelift.txd");
    AddSimpleModel(-1, 1923, EAGLE_LIFT_L, MODELS_PATH"/eagleliftdl.dff", MODELS_PATH"/eaglelift.txd");
    AddSimpleModel(-1, 1923, EAGLE_LIFT_R, MODELS_PATH"/eagleliftdr.dff", MODELS_PATH"/eaglelift.txd");
    CreateEagle();
    return 1;
}

#undef MODELS_PATH

static CreateEagle()
{
	// Base objects:
    // CreateDynamicObject(EAGLE_JEWEL_BUILD, 2846.05, -1453.33, -24.80, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    // CreateDynamicObject(EAGLE_JEWEL_INT, 2846.05, -1453.33, -24.80, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);

    CreateDynamicObject(1337, 2838.212, -1474.327, -11.871, 0.000, 0.000, 0.000, -1, -1, -1, 10.0, 10.0); // Spooky (1337)
    CreateDynamicObject(19377, 2857.50, -1465.932, 9.819, 0.000, -89.999, 0.000); // Kate_Mercer (19377)
    new invisi = CreateDynamicObject(19447, 2833.597, -1473.437, 11.879, 0.000, 0.000, 0.000); // Spooky (19447)
    SetDynamicObjectMaterial(invisi, 0, 18887, "forcefields", "white");

    CreateDynamicObject(EAGLE_LOBBY, 2836.209, -1473.814, 12.661, 0.00, 0.00, 0.00, -1, -1, -1, 100.0, 100.0);
    CreateDynamicObject(EAGLE_BITS, 2836.209, -1473.814, 12.661, 0.00, 0.00, 0.00, -1, -1, -1, 100.0, 100.0);
    CreateDynamicObject(EAGLE_DOOR_L, 2836.824, -1477.902, 10.917, 0.00, 0.00, 0.00, -1, -1, -1, 150.0, 150.0);
    CreateDynamicObject(EAGLE_DOOR_R, 2839.259, -1477.902, 10.917, 0.00, 0.00, 0.00, -1, -1, -1, 150.0, 150.0);

    CreateDynamicObject(EAGLE_ROOM, 2861.733, -1470.087, 28.141, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-3494)
    //CreateDynamicObject(EAGLE_FLOOR, 2861.753, -1470.087, 28.141, 0.000, 0.000, 0.000); // Spooky (-3493)
    CreateDynamicObject(EAGLE_OFF_MAIN, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-3492)
    CreateDynamicObject(EAGLE_OFF_FLOOR, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-3491)

    CreateDynamicObject(EAGLE_OFF_REFLECT, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-3492)
    CreateDynamicObject(EAGLE_OFF_FURN, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-3492)
    CreateDynamicObject(EAGLE_OFF_GLASS, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-3492)
    CreateDynamicObject(EAGLE_OFF_LIGHTS, 2855.356, -1470.510, 29.921, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-3492)

    CreateDynamicObject(EAGLE_JEWEL_BUILD, 2846.05, -1453.33, 24.80, 0.00, 0.00, 0.00, -1, -1, -1, 400.0, 400.0);
    CreateDynamicObject(EAGLE_JEWEL_INT, 2846.05, -1453.33, 24.80, 0.00, 0.00, 0.00, -1, -1, -1, 150.0, 150.0);
    CreateDynamicObject(EAGLE_JEWEL_GARAGE, 2847.493, -1472.948, 12.251, 0.00, 0.00, 0.00, -1, -1, -1, 400.0, 400.0);

    CreateDynamicObject(EAGLE_LIFT, 2836.221, -1470.019, 12.761, 0.00, 0.00, 0.00, -1, -1, -1, 100.0, 100.0);
    CreateDynamicObject(EAGLE_LIFT_L, 2836.221 - 1.125, -1470.019, 12.761, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(EAGLE_LIFT_R, 2836.221 + 1.125, -1470.019, 12.761, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);

    CreateDynamicObject(EAGLE_LIFT, 2853.385, -1464.444, 30.025, 0.00, 0.00, 0.00, -1, -1, -1, 100.0, 100.0);
    CreateDynamicObject(EAGLE_LIFT_L, 2853.385 - 1.125, -1464.444, 30.025, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(EAGLE_LIFT_R, 2853.385 + 1.125, -1464.444, 30.025, 0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
}

CMD:gotoeagle(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;
    else return SetPlayerPos(playerid,  2851.7444, -1483.4712, 11.6593);
}