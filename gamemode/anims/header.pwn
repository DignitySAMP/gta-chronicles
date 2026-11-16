//#include "anims/anims.pwn"
#include "anims/sols.pwn"
#include "anims/sols-func.pwn"
#include "anims/sols_anims_new.pwn"
#include "anims/old_sync.pwn"
#include "anims/animated.pwn"

CMD:sa(playerid, params[]) {

	return cmd_stopanim(playerid, params);
}
 
CMD:stopanim ( playerid, params [] ) {

	if ( IsPlayerIncapacitated ( playerid, true ) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You don't need to use this command right now." );
	}

	if ( gettime () < PlayerVar [ playerid ] [ E_PLAYER_BRAWL_STOPANIM_ABUSE ] ) 
	{
		/*
		SendAdminMessage(sprintf("[!!!] [AdmWarn] %d %s has abused /s(top)a(nim) within 10 seconds of being damaged (anim abuse).", 
			playerid, ReturnPlayerNameData ( playerid ) )) ;

	    return SendServerMessage( playerid, COLOR_RED, "Anticheat", "DEDEDE", "Don't abuse /s(top)a(nim) in fights." );
		*/

		return 1;
	}

	PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] = 0;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE ) ;

	if (IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid, "PED", "CAR_SIT", 4.0, 0, 0, 0, 0, 1, 1);
		if (GetPVarInt(playerid, "CUFFED") == 1) SOLS_SetPlayerCuffed(playerid, true, false);
		return true;
	}
	else  
	{
		ClearAnimations(playerid, 1);
		ApplyAnimation(playerid, "PED", "IDLE_STANCE", 4.0, 0, 0, 0, 0, 1, 1);
		ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 1, 1);
		ApplyAnimation(playerid, "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1, 1);
	}

	if (GetPVarInt(playerid, "CUFFED") == 1)
	{
		// re-cuff anyone that was cuffed
		SOLS_SetPlayerCuffed(playerid, true, false);
		// Police_OnPlayerCuffResponse(playerid, true);
	}

/*
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE ) ;
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0); // Leave animation
	ClearAnimations(playerid);
*/

	new string [ 45 ] ;

	format ( string, sizeof ( string ), "%s used /stopanim", ReturnPlayerNameData ( playerid ) ) ;
    WriteLog ( playerid, "anims/stopanim", string );

	return true ;
}
ApplyAnim(playerid, animlib[], animname[], Float: fDelta, loop, lockx, locky, freeze, time, forcesync = 0 ) {

	if ( IsPlayerIncapacitated(playerid, true)) {
    
        return true ;
    }

	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync );
 	PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] = 1 ;

	// re-cuff anyone that was cuffed
	if (GetPVarInt(playerid, "CUFFED") == 1) SOLS_SetPlayerCuffed(playerid, true, false);

	return true ;
}


public OnPlayerSpawn(playerid) {
	
	if(PlayerVar [playerid] [ E_PLAYER_ANIM_PRELOADED ] == 0)
	{
	    LoadPlayerAnims(playerid);
	    PlayerVar [playerid] [ E_PLAYER_ANIM_PRELOADED ] = 1;
	}

	#if defined anim_OnPlayerSpawn
		return anim_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn anim_OnPlayerSpawn
#if defined anim_OnPlayerSpawn
	forward anim_OnPlayerSpawn(playerid);
#endif


PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0, 1);
	return true;
}

LoadPlayerAnims(playerid)
{
    PreloadAnimLib(playerid, "PED");
	PreloadAnimLib(playerid, "CARRY");
	PreloadAnimLib(playerid, "SMOKING");
	PreloadAnimLib(playerid, "GANGS");
	PreloadAnimLib(playerid, "CRACK");
	PreloadAnimLib(playerid, "GHANDS");
	PreloadAnimLib(playerid, "GRAVEYARD");
	PreloadAnimLib(playerid, "MISC");
	PreloadAnimLib(playerid, "BEACH");
	PreloadAnimLib(playerid, "KISSING");
	PreloadAnimLib(playerid, "SWEET");
	PreloadAnimLib(playerid, "STRIP");
	PreloadAnimLib(playerid, "FOOD");
	PreloadAnimLib(playerid, "BOMBER");
	PreloadAnimLib(playerid, "GYMNASIUM");
	PreloadAnimLib(playerid, "ROB_BANK");
	PreloadAnimLib(playerid, "CLOTHES");
	return SecondLoad( playerid );
}

SecondLoad( playerid )
{
	PreloadAnimLib(playerid, "CAR");
	PreloadAnimLib(playerid, "DANCING");
	PreloadAnimLib(playerid, "BAR");
	PreloadAnimLib(playerid, "BD_FIRE");
	PreloadAnimLib(playerid, "BASEBALL");
	PreloadAnimLib(playerid, "CAMERA");
	PreloadAnimLib(playerid, "CASINO");
	PreloadAnimLib(playerid, "GHETTO_DB");
	PreloadAnimLib(playerid, "COP_AMBIENT");
	PreloadAnimLib(playerid, "COLT45");
	PreloadAnimLib(playerid, "FIGHT_B");
	PreloadAnimLib(playerid, "FIGHT_C");
	PreloadAnimLib(playerid, "FIGHT_E");
	PreloadAnimLib(playerid, "FAT");
	PreloadAnimLib(playerid, "ON_LOOKERS");
	PreloadAnimLib(playerid, "POLICE");
	PreloadAnimLib(playerid, "PLAYIDLES");
	PreloadAnimLib(playerid, "PAULNMAC");
	PreloadAnimLib(playerid, "PARK");
	PreloadAnimLib(playerid, "SWORD");
	PreloadAnimLib(playerid, "RIOT");
	PreloadAnimLib(playerid, "RAPPING");
	PreloadAnimLib(playerid, "WEAPONS");
	return ThirdLoad_New(playerid);
}

ThirdLoad_New(playerid) {

	PreloadAnimLib(playerid, "LOWRIDER");
	PreloadAnimLib(playerid, "PLAYIDLES");
	PreloadAnimLib(playerid, "CAR_CHAT");
	PreloadAnimLib(playerid, "BENCHPRESS");
	PreloadAnimLib(playerid, "AIRPORT");
	PreloadAnimLib(playerid, "BOX");
	PreloadAnimLib(playerid, "DEALER");
	PreloadAnimLib(playerid, "WUZI");

	return true ;
}