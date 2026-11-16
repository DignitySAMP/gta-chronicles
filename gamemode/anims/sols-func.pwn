/*
AnimationPartial(playerid, animlib[], animname[], Float: speed, loop, lockx, locky, freeze, time, forcesync = 1 )
{

	ApplyAnimation(playerid, animlib, animname, speed, loop, lockx, locky, freeze, time, forcesync);
	//PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] = 1;
}
*/

AnimationLoop(playerid, animlib[], animname[], Float: speed, loop, lockx, locky, freeze, time, forcesync = 1 ) {

	ApplyAnimation(playerid, animlib, animname, speed, loop, lockx, locky, freeze, time, forcesync );

    PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] = 1;
	
	return true ;
}

AnimationCheck ( playerid, bool:checkCuffs=false ) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_BRAWL_STOPANIM_ABUSE ] )
	{
		// Stops people doing anims for 3s after being damaged
		if ( gettime () < (PlayerVar [ playerid ] [ E_PLAYER_BRAWL_STOPANIM_ABUSE ] - 2) ) 
		{
			return false;
		}
	}
	 
	if ( IsPlayerIncapacitated ( playerid, !checkCuffs ) ) 
	{
		return false ;
	}

	return true ;
}

// TODO: when cleanup anims - reorganize this

#include <YSI_Coding\y_hooks>

hook OnPlayerDeath(playerid, killerid, reason)
{
	// if they die whilst performing a looping anim, we should reset the state
	if (PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ]) 
	{
        PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] = 0;
	}

	return 1;
}

/*
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}
*/
