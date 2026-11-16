//------------------------------------------------------------------------------
// Basic "soundproofed" rooms
// Written by Sporky (www.github.com/sporkyspork) for SOLS

#include <YSI_Coding\y_hooks>
// #include <streamer>

static enum E_SOUNDROOM_INFO
{
    E_SOUNDROOM_NAME[32],
    Float:E_SOUNDROOM_MIN_POS[3],
    Float:E_SOUNDROOM_MAX_POS[3],
    E_SOUNDROOM_WORLD,
    E_SOUNDROOM_INT,
    bool:E_SOUNDROOM_BLOCK_AMBIENCE,
    bool:E_SOUNDROOM_BLOCK_WEATHER,
    bool:E_SOUNDROOM_BLOCK_OUTSIDE,
    E_SOUNDROOM_AREA
}



static SoundRooms[][E_SOUNDROOM_INFO] = 
{
    //{ "LSPD Interview A",   {-25.8552, -98.2604, 898.0},        {-22.1471, -94.8114, 901.0},        -1, 6 },
    //{ "LSPD Interview B",   {-25.8519, -102.9057, 898.0},       {-22.1482, -99.4122, 901.0},        -1, 6 },

    { "LSPD Interview A",   {-25.1265,-97.9588,898.0},          {-21.3836,-94.6555,901.0},           -1, 6 },
    { "LSPD Interview B",   {-25.1252,-109.5385,898.0},         {-21.4221,-106.491,901.0},          -1, 6 },
    { "LSPD Conference",    {-20.4113,-98.6746,902.0},          {-7.9110,-91.5466,905.0},           -1, 6 },
    { "LSPD Staff Office",  {-25.0422,-107.8356,902.0},         {-20.0638,-102.8965,905.0},         -1, 6 },
    { "LSPD Cmdr Office",   {-19.0629,-107.6580,902.0},         {-13.9201,-103.3159,905.0},         -1, 6 },
    { "LSPD Capt Office",   {-13.1840,-107.7681,902.0},         {-7.9193,-102.9192,905.0},          -1, 6 },
    { "DEA Office",         {2846.650, -1477.650, 28.00},       {2864.750, -1463.850, 31.00},       -1, -1, true, true},
    { "Kate's' House",      {772.5348, -1438.1696,22.34},       {785.9879,-1420.7964,23.89},        -1, -1, true, true},
    { "Fire Station 2",     {1814.5760,-1450.2264,13.1646},     {1836.1934,-1423.2555,20.3968},     -1, -1, false, true},
    { "Train Tunnel Room",  {1696.1735,-1943.3596,14.3125},     {1707.6576,-1935.2407,14.3125},     -1, -1, false, false},
    { "FBI Ground Floor",   {964.8749, -1546.7500, 10.1646},    {1000.8983,-1514.4829,20.3968},     -1, -1, false, true},
    { "FBI Fourth Floor",   {963.6171, -1555.8281, 41.8359},    {1002.6171,-1504.8281,46.8359},     -1, -1, true, true},
    { "Los Santos City Hall", {1417.8441,-1824.2045,12.5469},   {1550.3822,-1773.9792,63.7894},     -1, -1, true, true},
    { "Idlewood Pizza Stack", {2101.7000,-1808.5933, 12.0},     {2116.2661, -1790.0835, 15.0},      -1, -1, false, true},
    { "SANN Office Interior", {1756.845, -1681.279, 29.84},     {1804.331, -1625.049, 37.373},      -1, -1, true, true},
    { "Classified",           {1346.6847, -1663.4382, 12.0},     {1358.6351, -1631.2738, 15.0},      -1, -1, true, true},
    { "Taxi Depot",           {2028.8861, -1839.4550, 12.0},     {2055.1108, -1822.6234, 16.0},      -1, -1, false, true},
    { "Beach House",        {164.90, -1768.80, 9.88},           {176.33, -1759.52, 13.55},        -1, -1, true, true, true}
};

static enum E_SOUNDROOM_PVARS
{
    E_PLAYER_SOUNDROOM_CURRENT,
    E_PLAYER_SOUNDROOM_WEATHER,
    bool:E_PLAYER_SOUDNROOM_AMBIENCE
}

new SoundRoomPlayer [ MAX_PLAYERS ] [ E_SOUNDROOM_PVARS ] ;

hook OnPlayerConnect(playerid)
{
 	new var_clear[E_SOUNDROOM_PVARS];
	SoundRoomPlayer[playerid] = var_clear;
}

hook OnGameModeInit()
{
    for (new i = 0; i < sizeof(SoundRooms); i ++)
    {
        SoundRooms[i][E_SOUNDROOM_AREA] = CreateDynamicCuboid
        (
            SoundRooms[i][E_SOUNDROOM_MIN_POS][0], SoundRooms[i][E_SOUNDROOM_MIN_POS][1], SoundRooms[i][E_SOUNDROOM_MIN_POS][2], 
            SoundRooms[i][E_SOUNDROOM_MAX_POS][0], SoundRooms[i][E_SOUNDROOM_MAX_POS][1], SoundRooms[i][E_SOUNDROOM_MAX_POS][2], 
            SoundRooms[i][E_SOUNDROOM_WORLD], SoundRooms[i][E_SOUNDROOM_INT]
        );

        // printf("Created DynamicArea \"%s\" with ID %d", SoundRooms[i][E_SOUNDROOM_NAME], SoundRooms[i][E_SOUNDROOM_AREA]);
    }

    return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
    // printf("OnPlayerEnterDynArea(%d, %d)", playerid, areaid);
    CallLocalFunction("OnPlayerSoundRoomUpdate", "d", playerid);


    /*
    for (new i = 0; i < sizeof(SoundRooms); i ++)
    {
        if (SoundRooms[i][E_SOUNDROOM_AREA] == areaid)
        {
            ShowPlayerFooter(playerid, sprintf("You entered ~y~%s", SoundRooms[i][E_SOUNDROOM_NAME]));
            break;
        }   
    }
    */


    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
    // printf("OnPlayerLeaveDynArea(%d, %d)", playerid, areaid);
    CallLocalFunction("OnPlayerSoundRoomUpdate", "d", playerid);


    /*
    for (new i = 0; i < sizeof(SoundRooms); i ++)
    {
        if (SoundRooms[i][E_SOUNDROOM_AREA] == areaid)
        {
            ShowPlayerFooter(playerid, sprintf("You left ~y~%s", SoundRooms[i][E_SOUNDROOM_NAME]));
            break;
        }   
    }
    */


    return 1;
}

SoundRoom_UpdateWeather(playerid, room = -1)
{
    if (room == -1) room = GetPlayerSoundRoom(playerid);
    if (room >= 0 && SoundRooms[room][E_SOUNDROOM_BLOCK_WEATHER] && (Server[E_SERVER_WEATHER] == 8 || Server[E_SERVER_WEATHER] == 16))
    {
        // Override to dull, cloudy weather without rain
        SetPlayerWeather(playerid, 7);
        SoundRoomPlayer[playerid][E_PLAYER_SOUNDROOM_WEATHER] = true;
    }
}

forward OnPlayerSoundRoomUpdate(playerid);
public OnPlayerSoundRoomUpdate(playerid)
{
    new room = GetPlayerSoundRoom(playerid);
    SoundRoomPlayer[playerid][E_PLAYER_SOUNDROOM_CURRENT] = room;
    
    if (room == -1)
    {
        if (SoundRoomPlayer[playerid][E_PLAYER_SOUDNROOM_AMBIENCE])
        {
            // Sound ID 0 can be used additionally to return the game's normal outdoor ambience track.
            PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
            SoundRoomPlayer[playerid][E_PLAYER_SOUDNROOM_AMBIENCE] = false;
        }

        if (SoundRoomPlayer[playerid][E_PLAYER_SOUNDROOM_WEATHER])
        {
            // Change back to server weather
            SetPlayerWeather(playerid, Server[E_SERVER_WEATHER]);
            SoundRoomPlayer[playerid][E_PLAYER_SOUNDROOM_WEATHER] = false;
        }

        return 0;
    } 

    if (SoundRooms[room][E_SOUNDROOM_BLOCK_AMBIENCE] && !SoundRoomPlayer[playerid][E_PLAYER_SOUDNROOM_AMBIENCE])
    {
        // Sound ID 1 can be used to disable the interior 0 (default) ambience track (wind noise).
        // Hint: it can help to create more realistically fake interiors.
        PlayerPlaySound(playerid, 1, 0.0, 0.0, 0.0);
        SoundRoomPlayer[playerid][E_PLAYER_SOUDNROOM_AMBIENCE] = true;
    }

    SoundRoom_UpdateWeather(playerid, room);
    return 1;
}

hook SOLS_OnWeatherChanged(old_weather, new_weather)
{
    if (new_weather == 16 || new_weather == 8)
    {
        foreach(new playerid: Player)
        {
            if (!IsPlayerConnected(playerid)) continue;
            SoundRoom_UpdateWeather(playerid);
        }
    }

    return 1;
}

forward GetPlayerSoundRoomArea(playerid);
public GetPlayerSoundRoomArea(playerid)
{
    for (new i = 0; i < sizeof(SoundRooms); i ++)
    {
        if (IsPlayerInDynamicArea(playerid, SoundRooms[i][E_SOUNDROOM_AREA]))
        {
            return SoundRooms[i][E_SOUNDROOM_AREA];
        }   
    }

    return 0;
}

forward GetPlayerSoundRoom(playerid);
public GetPlayerSoundRoom(playerid)
{
    for (new i = 0; i < sizeof(SoundRooms); i ++)
    {
        if (IsPlayerInDynamicArea(playerid, SoundRooms[i][E_SOUNDROOM_AREA]))
        {
            return i;
        }   
    }

    return -1;
}