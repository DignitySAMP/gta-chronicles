#include "anticheat/ac_detect.pwn"
#include "anticheat/anti_bot.pwn"
#include "anticheat/anti-car-troll.pwn"


CheckInputtextCrash(playerid, inputtext[]) {

	/*
		This is deprecated. Update YSI or find a better dialog include.

		'%' crashes the server on input.

	*/

	
	if (strfind(inputtext, "%", true) != -1 || strfind(inputtext, "#", true) != -1) 
	{
		//SendAdminMessage(sprintf("[AntiCheat]: (%d) %s might have used a string buffer overflow exploit.", playerid, ReturnPlayerNameData(playerid)));	
		printf("[EXPLOIT] (%d) %s: (inputtext: %s)", playerid, ReturnPlayerName(playerid), inputtext);

		AddAntiCheatLog(playerid, AC_DETECTION_MISC_STRING, "bad symbol in input text");
		return 0;
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[] ) 
{
	if (listitem == -1) // listitem should be -1 if it's a INPUT dialog
	{
		if (strfind(inputtext, "%", true) != -1 || strfind(inputtext, "#", true) != -1) 
		{
			// Prevent the dialog being processed?
			return 1;
		}

		// printf("OnDialogResponse: pid: %d, id: %d, response: %d, list: %d, text: %s", playerid, dialogid, response, listitem, inputtext);
	}
	
    return 0;
}


// Thanks to TommyB
OnPlayerTroll(playerid) {


	// SendAdminMessage(sprintf("[ANTICHEAT CRITICAL]: (%d) %s might be car warping.", playerid, ReturnPlayerName(playerid)), .color=0xFFBE00FF);
	AddAntiCheatLog(playerid, AC_DETECTION_VEH_WARP, "Possibly car warping");

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNBAN ] ) {

		return false ;
	}

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNACCESS ] ) {

		return true ;
	}

	if ( Character [ playerid ] [ E_CHARACTER_HOURS] > 8 ) {

		return true ;
	}

	// False positive (detected by using /detain, Exyze, 13/12/21)
	if(GetPVarInt(playerid, "CUFFED") == 1) {

		return true ;
	}

	PlayerVar [ playerid ] [ E_PLAYER_WARP_AC ] ++ ;

	if (PlayerVar [ playerid ] [ E_PLAYER_WARP_AC ] >= 2) {

		SendAdminWarning(sprintf("[ANTICHEAT]: (%d) %s might be car warping. Checking false positive, slapping!", playerid, ReturnPlayerName(playerid)), .color=0xFF0000FF);

		JT_RemovePlayerFromVehicle(playerid);

		new Float: x, Float: y, Float: z ;
		GetPlayerPos ( playerid, x, y, z ) ;
		SetPlayerPos ( playerid, x, y, z + 4 ) ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_WARP_AC ] >= 3) {

		SendAdminWarning(sprintf("[ANTICHEAT CRITICAL]: (%d) %s might be car warping.", playerid, ReturnPlayerName(playerid)), true, .color=0xFF0000FF);

		Kick(playerid);
	}


	return true ;
}