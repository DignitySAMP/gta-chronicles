#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <strlib>
#include <zcmd>

#undef MAX_OBJECTS
#define MAX_OBJECTS 	100000
#define GetDynamicObjectModel(%0) Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

CMD:rconfurni(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return SendClientMessage(playerid, -1, "You're not an admin.");
	}

	SendClientMessage(playerid, -1, "/r_nearobj - shows nearby objects (unlimited radius)");
	SendClientMessage(playerid, -1, "/r_searchmodel - shows object id for model & dist");
	SendClientMessage(playerid, -1, "/r_delobj - deletes obj by ID");


	return true ;
}

CMD:r_nearobj(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return SendClientMessage(playerid, -1, "You're not an admin.");
	}

	new Float: radius;

	if ( sscanf ( params, "f", radius ) ) {

		return SendClientMessage(playerid, -1, "/r_nearobj [radius]" ) ;
	}
	if(radius<0 || radius>150) {

		return SendClientMessage(playerid, -1, "No less than 0 or more than 150 (radius!)");
	}

	new Float: distance ;
	new Float: x, Float: y, Float: z ;
	new vw;
	
	new items[10];
	GetPlayerPos(playerid, x, y, z);
	Streamer_GetNearbyItems(x, y, z, STREAMER_TYPE_OBJECT, items, 10, radius, GetPlayerVirtualWorld(playerid));

	for(new i, j = 10; i < j ; i ++ )
	{
		if(IsValidDynamicObject(items[i]) )
		{
            GetDynamicObjectPos(items[i], x, y, z);
            distance = GetPlayerDistanceFromPoint(playerid, x, y, z );
			SendClientMessage(playerid, -1, sprintf("%d (model %d) distance %0.3f", items[i], GetDynamicObjectModel(items[i]), distance));
		}
	}

	return true ;
}

CMD:r_searchmodel(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return SendClientMessage(playerid, -1, "You're not an admin.");
	}

	new modelid, Float: radius;

	if ( sscanf ( params, "if", modelid, radius ) ) {

		return SendClientMessage(playerid, -1, "/r_searchmodel [modelid] [radius]" ) ;
	}

	if(radius<0 || radius>150) {

		return SendClientMessage(playerid, -1, "No less than 0 or more than 150 (radius!)");
	}

	new Float: distance ;
	new Float: x, Float: y, Float: z ;

	for(new i,j = MAX_OBJECTS; i < j ; i ++ ) {

		if(IsValidDynamicObject(i) && GetDynamicObjectModel(i) == modelid) {


			GetDynamicObjectPos(i, x, y, z);
			distance = GetPlayerDistanceFromPoint(playerid, x, y, z ) ;
			if(distance <= radius) SendClientMessage(playerid, -1, sprintf("%d (model %d) distance %0.3f", i, GetDynamicObjectModel(i), distance));
		}
	}

	return true ;
}

CMD:r_delobj(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return SendClientMessage(playerid, -1, "You're not an admin.");
	}

	new objid;
	if ( sscanf ( params, "i", objid ) ) {

		return SendClientMessage(playerid, -1, "/r_delobj [objectid]" ) ;
	}

	if(!IsValidDynamicObject(objid)) {

		return SendClientMessage(playerid, -1, "This isn't a valid object.");
	}

	new modelid = GetDynamicObjectModel(objid);

	DestroyDynamicObject(objid);
	SendClientMessage(playerid, -1, sprintf("You've destroyed object ID %d with model %d.", objid, modelid ) ) ;

	return true ;
}
