#include <a_samp>
#include <zcmd>
#include <YSI\y_timers>
#include <sprintf>
#include <sscanf2>

new E_ATTACH_INDEX_MISC = 0 ;
new E_ATTACH_INDEX_MINIGAME= 1 ;
enum {

	E_ATTACH_MAX_BONES = 18,
	E_ATTACH_BONE_SPINE = 1,
	E_ATTACH_BONE_HEAD,
	E_ATTACH_BONE_UPPER_ARM_L,
	E_ATTACH_BONE_UPPER_ARM_R,
	E_ATTACH_BONE_HAND_L,
	E_ATTACH_BONE_HAND_R,
	E_ATTACH_BONE_THIGH_L,
	E_ATTACH_BONE_THIGH_R,
	E_ATTACH_BONE_FOOT_L,
	E_ATTACH_BONE_FOOT_R,
	E_ATTACH_BONE_CALF_R,
	E_ATTACH_BONE_CALF_L,
	E_ATTACH_BONE_FOREARM_L,
	E_ATTACH_BONE_FOREARM_R,
	E_ATTACH_BONE_SHOULDER_L, // clavicle
	E_ATTACH_BONE_SHOULDER_R, // clavicle
	E_ATTACH_BONE_NECK,
	E_ATTACH_BONE_JAW,
}

CMD:attach(playerid, params[]) {
	SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MISC, -29993,E_ATTACH_BONE_HAND_R, 0.051001, 0.037000, -0.000999, -3.499976, 63.500053, -3.400005, 1.000000, 1.000000, 1.258999 ) ;
	SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MINIGAME, 18706,E_ATTACH_BONE_HAND_R, -1.334998, -0.005000, -0.679999, -3.499975, 63.500053, -3.400005, 1.000000, 1.000000, 1.258998 ) ;

   	ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 1, 1);
}

#define COLOR_RED	-1
SendServerMessage(playerid, color, title[], hex[], string[]) {
	#pragma unused hex, title

	return SendClientMessage(playerid, color, string);
}
AnimationCheck(playerid){

	#pragma unused playerid
	return true ;
}

public OnFilterScriptInit(){

	AddSimpleModel(-1, 1337, -29993, "dignity/champagne_bottle.dff", "dignity/champagne_bottle.txd");
}


public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{

	if ( response ) {

		printf("%d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f",

			index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ
		);
	}

	return true ;
}






CMD:puke(playerid, params[]) {

	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 1, 0, 1);
	defer AnimatedAnim_Puke(playerid);

	return true ;
}

timer AnimatedAnim_Puke[3750](playerid) {

	if ( GetPlayerAnimationIndex(playerid) == 539 ) {
    	SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MISC, 18722,E_ATTACH_BONE_HEAD, 0.0, 1.75, 0.0, 90.0, 0.0, 0.0,  1.000000, 1.000000, 1.000000 ) ;
    	defer AnimatedAnim_Clear(playerid);
    }	

    return true ;
}

new PlayerBottleAnimation [ MAX_PLAYERS ] ;
CMD:shakebottle(playerid, params[]) {
	SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MISC, -29993,E_ATTACH_BONE_HAND_R, 0.051001, 0.037000, -0.000999, -3.499976, 63.500053, -3.400005, 1.000000, 1.000000, 1.258999 ) ;
	SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MINIGAME, 18706,E_ATTACH_BONE_HAND_R, -1.334998, -0.005000, -0.679999, -3.499975, 63.500053, -3.400005, 1.000000, 1.000000, 1.258998 ) ;

   	ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 1, 1);
   	SendClientMessage(playerid, -1, sprintf("%d", GetPlayerAnimationIndex(playerid)));

   	PlayerBottleAnimation [ playerid ] = 0 ;
   	defer AnimatedAnim_Bottle(playerid);
   	return true ;
}

timer AnimatedAnim_Bottle[750](playerid) {

   	SendClientMessage(playerid, -1, sprintf("%d", GetPlayerAnimationIndex(playerid)));

   	switch ( GetPlayerAnimationIndex(playerid) ) {

   		case 1189, 1224, 1274: {
			if ( PlayerBottleAnimation [ playerid ] ++ >= 60 ) {

				RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC);
				RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MINIGAME);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
				return true ;
			}
		}

		default: {
			RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC);
			RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MINIGAME);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);

			return true ;
		}
	}

	

	defer AnimatedAnim_Bottle(playerid);

	return true ;
}

CMD:exhale(playerid, params[]) {


	new type, time;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/exhale [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");


	switch (type) {
		case 1: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 		4.1, 0, 0, 0, 1, 0, 1), time = 3500;
		case 2: ApplyAnimation(playerid, "GANGS", "smkcig_prtl_F", 		4.1, 0, 0, 0, 1, 0, 1), time = 3800;
		case 3: ApplyAnimation(playerid, "PED", "pass_Smoke_in_car", 	4.1, 0, 0, 0, 1, 0, 1), time = 2000;
		case 4: ApplyAnimation(playerid, "PED", "smoke_in_car", 		4.1, 0, 0, 0, 1, 0, 1), time = 2000;
	}

	SendClientMessage(playerid, -1, sprintf("%d", GetPlayerAnimationIndex(playerid) ) ) ;
	defer AnimatedAnim_Exhale[time](playerid);

	return true ;
}

timer AnimatedAnim_Exhale[3500](playerid) {

	switch ( GetPlayerAnimationIndex(playerid)) {

		case 1245, 609, 610, 1212: {
			SetPlayerAttachedObject ( playerid, E_ATTACH_INDEX_MISC, 18677,E_ATTACH_BONE_HEAD, 0.0, 1.75, 0.0, 90.0, 0.0, 0.0, 1.000000, 1.000000, 1.000000 ) ;
			defer AnimatedAnim_Clear(playerid);
		}
	}

	return true ;
}

timer AnimatedAnim_Clear[3000](playerid) {

	RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC);
}
