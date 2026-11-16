#define FILTERSCRIPT

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <strlib>
#include <streamer>
#include "YSI\y_dialog"
#include "YSI\y_inline"
#include "YSI\y_timers"

#include <Pawn.RakNet>

#define GetDynamicObjectModel(%0) Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

static enum E_PLAYER_NAME_STYLE
{
    PLAYER_NAME_STYLE_ROLEPLAY,   // RP name (so char name replaced with spaces, but uses mask if masked)
    PLAYER_NAME_STYLE_CHARACTER,  // Char name replaced by spaces, ignores mask
    PLAYER_NAME_STYLE_ACCOUNT,    // Account name
    PLAYER_NAME_STYLE_LEGACY,     // Old shit like Account (F. Last)
    PLAYER_NAME_STYLE_DEFAULT     // Wrapper for default GetPlayerName
}

stock SOLS_PlayerName(playerid, E_PLAYER_NAME_STYLE:namestyle = PLAYER_NAME_STYLE_ROLEPLAY)
{
    new returned_name[64];

    if (!Character[playerid][E_CHARACTER_NAME_CACHED_AT])
    {
        UpdatePlayerNameCache(playerid);
    }

    switch (namestyle)
    {
        case PLAYER_NAME_STYLE_ROLEPLAY:
        {
            format(returned_name, sizeof(returned_name), Character[playerid][E_CHARACTER_NAME_MASK]);
        }
        case PLAYER_NAME_STYLE_CHARACTER:
        {
            format(returned_name, sizeof(returned_name), Character[playerid][E_CHARACTER_NAME_RP]);
        }
        case PLAYER_NAME_STYLE_ACCOUNT:
        {
            format(returned_name, sizeof(returned_name), Account[playerid][E_PLAYER_ACCOUNT_NAME]);
        }
        case PLAYER_NAME_STYLE_LEGACY:
        {
            format(returned_name, sizeof(returned_name), "%s (%s)", Character[playerid][E_CHARACTER_NAME_RP], Account[playerid][E_PLAYER_ACCOUNT_NAME]);
        }
        default:
        {
            GetPlayerName(playerid, returned_name, sizeof(returned_name));
        }
    }

    return returned_name;
}

stock SendServerMessage(playerid, color, sm[], sm2[], msg[])
{
	return SendClientMessage(playerid, -1, msg);
}

ShowPlayerFooter(playerid, message[])
{
    CallRemoteFunction("SOLS_ShowPlayerSubtitle", "dsd", playerid, message, 4000);
    //CallRemoteFunction("ShowPlayerMessageText", "ds", playerid, message);
}

GetDynObjRelativePos(objectid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rx, Float:ry, Float:rz;
    GetDynamicObjectRot(objectid, rx, ry, rz);
    rz = 360 - rz;    // Making the object rotation compatible with pawns sin/cos
    GetDynamicObjectPos(objectid, x, y, z);
    x = floatsin(rz,degrees) * yoff + floatcos(rz,degrees) * xoff + x;
    y = floatcos(rz,degrees) * yoff - floatsin(rz,degrees) * xoff + y;
    z = zoff + z;
}

stock GetRelativePosXYZA(Float:x, Float:y, Float:z, Float:a, &Float:outx, &Float:outy, &Float:outz, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rz = a;
    //rz = 360 - rz;    // Making the object rotation compatible with pawns sin/cos
    outx = floatsin(rz,degrees) * yoff + floatcos(rz,degrees) * xoff + x;
    outy = floatcos(rz,degrees) * yoff - floatsin(rz,degrees) * xoff + y;
    outz = zoff + z;
}

#define COLOR_RED -1
#define KEY_AIM KEY_HANDBRAKE

// PRESSED(keys)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


/////////////////////////////////////////////////
// All the rest is done here:
#include "../gamemode/prison/wip/header.pwn"
