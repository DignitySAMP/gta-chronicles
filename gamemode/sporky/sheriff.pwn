//------------------------------------------------------------------------------
// Very Basic Sheriff Station
// Dillimore
// Created by Sporky (www.github.com/sporkyspork) for Singleplayer Roleplay (www.stretzofls.com)

#include <YSI_Coding\y_hooks>
#define MODELS_PATH "sporky/sheriff"

static enum
{
    SD_TEMP_BUILD = -3550,
    SD_TEMP_GATE = -3551
}

static CreateSheriff()
{
    // Static object to stop cars falling
	CreateObject(SD_TEMP_BUILD, 622.95, -577.06, 21.81, 0.00, 0.00, 0.00, 400.0);
}

hook OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 13250, 622.9453, -577.0625, 21.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 12855, 622.9453, -577.0625, 21.8125, 0.25);
    return 1;
}

hook OnGameModeInit()
{
    AddSimpleModel(-1, 1923, SD_TEMP_BUILD, MODELS_PATH"/sw_copshop.dff", MODELS_PATH"/sw_copshop.txd");
    AddSimpleModel(-1, 1923, SD_TEMP_GATE, MODELS_PATH"/sw_copgate.dff", MODELS_PATH"/sw_copshop.txd");
    
    CreateSheriff();
    return 1;
}

#undef MODELS_PATH

