#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <strlib>
#include <streamer>
#include "YSI\y_dialog"
#include "YSI\y_inline"

enum PlayerVars
{
	bool:E_PLAYER_USING_HOSE,
	E_PLAYER_HOSE_INDEX,
	E_PLAYER_HOSE_UPDATED_AT,
	E_PLAYER_HOSE_ACTION,
	bool:E_PLAYER_HOSE_SYNCED
}

new PlayerVar[MAX_PLAYERS][PlayerVars];

ReturnPlayerNameData(playerid, x=0, y=0)
{
	new string[24];
	GetPlayerName(playerid,string,24);
	new str[24];
	strmid(str,string,0,strlen(string),24);
	for(new i = 0; i < MAX_PLAYER_NAME; i++)
	{
		if (str[i] == '_') str[i] = ' ';
	}
	return str;
}

Float:GetPlayerDistanceToPoint2D(playerid, Float:x, Float:y) {
	new Float:x2, Float:y2;

	if (GetPlayerPos(playerid, x2, y2, Float:playerid)) {
		return VectorSize(x - x2, y - y2, 0);
	}

	return FLOAT_NAN;
}

Float:GetPointDistanceToPoint(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2 = FLOAT_NAN, Float:z2 = FLOAT_NAN) {
	if (_:y2 == _:FLOAT_NAN) {
		return VectorSize(x1 - z1, y1 - x2, 0.0);
	}

	return VectorSize(x1 - x2, y1 - y2, z1 - z2);
}

Float:GetAngleBetweenPoints(Float:X1,Float:Y1,Float:X2,Float:Y2)
{
	new Float:angle=atan2(X2-X1,Y2-Y1);
	if(angle>360)angle-=360;
	if(angle<0)angle+=360;
	return angle;
}

Float:GetUpAngleBetweenPoints(Float:X1,Float:Y1,Float:Z1,Float:X2,Float:Y2,Float:Z2)
{
	new Float:angle=atan2(Z2 - Z1, GetPointDistanceToPoint(X2, Y2, X1, Y1));
	if(angle>360)angle-=360;
	if(angle<0)angle+=360;
	return angle;
}

stock GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;    // Making the vehicle rotation compatible with pawns sin/cos
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}

GetDynObjRelativePos(objectid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rx, Float:ry, Float:rz;
    GetDynamicObjectRot(objectid, rx, ry, rz);
    rz = 360 - rz;    // Making the vehicle rotation compatible with pawns sin/cos
    GetDynamicObjectPos(objectid, x, y, z);
    x = floatsin(rz,degrees) * yoff + floatcos(rz,degrees) * xoff + x;
    y = floatcos(rz,degrees) * yoff - floatsin(rz,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}

stock GetClosestVehicleEx(playerid, Float: distance = 10.0)
{
    new v = -1;
    new Float:dis = 99999.99;
    for_loop (new i=1;i<MAsX_VEHICLES;i++){
        if ( IsValidVehicle ( i ) ) {
            new Float:x,Float:y,Float:z;
            GetVehiclePos(i,x,y,z);
            new Float:dis2 = GetPlayerDistanceFromPoint(playerid,x,y,z);
            if(dis2 < dis && i != GetPlayerVehicleID(playerid) && GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(i))
            {
                dis = dis2;
                v = i;
            }
        }
    }

    if ( dis > distance ) {
        v = INVALID_VEHICLE_ID ;
    }

    return v;
}

stock GetPlayerRelativePos(playerid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetPlayerFacingAngle(playerid, rot);
    rot = 360 - rot;    // Making the ped rotation compatible with pawns sin/cos
    GetPlayerPos(playerid, x, y, z);
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}


bool:IsPlayerInMedicFaction(playerid, bool:onduty=false)
{
	return true;
}

SendServerMessage(playerid, color, sm[], sm2[], msg[])
{
	return SendClientMessage(playerid, -1, msg);
}

ShowPlayerFooter(playerid, message[], time=4000)
{
    CallRemoteFunction("SOLS_ShowPlayerSubtitle", "dsd", playerid, message, time);
    return 1;
}

#define COLOR_RED -1
#define COLOR_ERROR -1
#define KEY_AIM KEY_HANDBRAKE

// PRESSED(keys)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


/////////////////////////////////////////////////
#include "../gamemode/sporky/firehose.pwn"


public OnFilterScriptInit()
{
    AddHoseModels();
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}


