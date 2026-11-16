stock GetDynObjRelativePos(objectid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
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

stock Float:GetPlayerDistanceToPoint2D(playerid, Float:x, Float:y) {
	new Float:x2, Float:y2;

	if (GetPlayerPos(playerid, x2, y2, Float:playerid)) {
		return VectorSize(x - x2, y - y2, 0);
	}

	return FLOAT_NAN;
}

stock Float:GetPointDistanceToPoint(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2 = FLOAT_NAN, Float:z2 = FLOAT_NAN) {
	if (_:y2 == _:FLOAT_NAN) {
		return VectorSize(x1 - z1, y1 - x2, 0.0);
	}

	return VectorSize(x1 - x2, y1 - y2, z1 - z2);
}

stock Float:GetAngleBetweenPoints(Float:X1,Float:Y1,Float:X2,Float:Y2)
{
	new Float:angle=atan2(X2-X1,Y2-Y1);
	if(angle>360)angle-=360;
	if(angle<0)angle+=360;
	return angle;
}

stock Float:GetUpAngleBetweenPoints(Float:X1,Float:Y1,Float:Z1,Float:X2,Float:Y2,Float:Z2)
{
	new Float:angle=atan2(Z2 - Z1, GetPointDistanceToPoint(X2, Y2, X1, Y1));
	if(angle>360)angle-=360;
	if(angle<0)angle+=360;
	return angle;
}

stock ShowPlayerFooter(playerid, message[], time=4000)
{
    CallLocalFunction("SOLS_ShowPlayerSubtitle", "dsd", playerid, message, time);
	return 1;
}

stock HidePlayerFooter(playerid)
{
    HidePlayerSubtitle(playerid);
    //CallRemoteFunction("HidePlayerMessageText", "d", playerid);
}

IsPlayerInMetroTraining(playerid)
{
    return GetPlayerInterior(playerid) == 7 && GetPlayerVirtualWorld(playerid) == 6003;
}



// -----------------------------------------------------------
// Can use these in filterscripts

forward SOLS_GetPlayerFactionType(playerid);
public SOLS_GetPlayerFactionType(playerid)
{
    return GetPlayerFactionType(playerid);
}

forward SOLS_GetPlayerFactionId(playerid);
public SOLS_GetPlayerFactionId(playerid)
{
    return Character[playerid][E_CHARACTER_FACTIONID];
}

forward SOLS_GetPlayerFactionDuty(playerid);
public SOLS_GetPlayerFactionDuty(playerid)
{
    return PlayerVar[playerid][E_PLAYER_FACTION_DUTY];
}

forward SOLS_GetPlayerAdminLevel(playerid);
public SOLS_GetPlayerAdminLevel(playerid)
{
    return GetPlayerAdminLevel(playerid);
}

forward SOLS_GetPlayerVarValue(playerid, index);
public SOLS_GetPlayerVarValue(playerid, index)
{
    return PlayerVar[playerid][PlayerVars:index];
}

forward SOLS_GetCharacterValue(playerid, index);
public SOLS_GetCharacterValue(playerid, index)
{
    return Character[playerid][E_PLAYER_CHARACTER_DATA:index];
}

forward SOLS_SetPlayerKevlarMod(playerid, Float:modifier);
public SOLS_SetPlayerKevlarMod(playerid, Float:modifier)
{
    PlayerVar[playerid][E_PLAYER_KEVLAR_MODIFIER] = modifier;
    return 1;
}

forward SOLS_SetPlayerArmor(playerid, Float:armor);
public SOLS_SetPlayerArmor(playerid, Float:armor)
{
    SetCharacterArmour(playerid, armor);
    return 1;
}

forward SOLS_SetPlayerHealth(playerid, Float:health);
public SOLS_SetPlayerHealth(playerid, Float:health)
{
    SetCharacterHealth(playerid, health);
    return 1;
}

forward SOLS_GiveCustomWeapon(playerid, weaponid, ammo);
public SOLS_GiveCustomWeapon(playerid, weaponid, ammo)
{
    GiveCustomWeapon(playerid, weaponid, ammo);
    return 1;
}

forward SOLS_GetPlayerName(playerid);
public SOLS_GetPlayerName(playerid)
{
    SetPVarString(playerid, "pname", SOLS_PlayerName(playerid));
}


