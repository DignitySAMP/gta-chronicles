#include "phone/data.pwn"
#include "phone/gui.pwn"
#include "phone/custom.pwn"
#include "phone/connect.pwn"
#include "phone/func.pwn"

#include "phone/sub/book.pwn"
#include "phone/sub/sms.pwn"


CMD:phone(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) 
	{
		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You don't have a phone! Head to an electronics store to buy one!" ) ;
		return true ;
	}

	if (!PlayerVar [ playerid ] [ player_viewphone ])
	{
		Phone_ForceShowPhone(playerid);
		PlayerVar [ playerid ] [ player_viewphone ] = true;
	}
	else
	{
		Phone_ForceHidePhone(playerid);
		PlayerVar [ playerid ] [ player_viewphone ] = false;
	}

	if ( PlayerVar [ playerid ] [ player_viewphone ] ) 
	{
		// Show phone object
		new colour = Character [ playerid ] [ E_CHARACTER_PHONE_COLOUR ]  ;

		if ( colour >= sizeof ( Phone_Colours ) ) 
		{
			colour = sizeof ( Phone_Colours ) - 1 ;
		}

		new vehicleid = GetPlayerVehicleID(playerid);
		if (!PlayerVar[playerid][player_hasseatbelton] || !vehicleid || !IsABike(vehicleid))
		{
			SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM, Phone_Colours [ colour ] [ E_PH_DATA_MODEL ], E_ATTACH_BONE_HAND_R, 0.1,0.0,-0.02,95.0,-180.0,0.0,1.0,1.0,1.0);
		}
		
		SelectTextDraw(playerid, PHONE_COLOUR_OK);
		ProxDetectorAutoMe(playerid, 15.0, "takes out their cellphone.");
		SendServerMessage(playerid, PHONE_COLOUR_OK, "Phone", "A3A3A3", "TIP: Type \"/pc\" to (re-)display the mouse cursor.");
	}
	else 
	{
		// Hide phone object
		new vehicleid = GetPlayerVehicleID(playerid);
		if (!PlayerVar[playerid][player_hasseatbelton] || !vehicleid || !IsABike(vehicleid))
		{
			RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM ) ;
		}

		CancelSelectTextDraw(playerid);
		ProxDetectorAutoMe(playerid, 15.0, "puts away their cellphone.");
	}

	return true ;
}

Phone_ForceShowPhone(playerid) 
{
	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] || PlayerVar [ playerid ] [ player_viewphone ]) 
	{
		return false;
	}

	Phone_FixBuggedBackground(playerid); // Temp mitigation for previous issue

	new background = Character [ playerid ] [ E_CHARACTER_PHONE_BACKGROUND ] ;
	new colour = Character [ playerid ] [ E_CHARACTER_PHONE_COLOUR ]  ;

	if ( colour >= sizeof ( Phone_Colours ) ) 
	{
		colour = sizeof ( Phone_Colours ) - 1 ;
	}

	PlayerTextDrawSetString(playerid, ptd_ph_design[playerid][5], Phone_Backgrounds [ background ] [ E_PH_DATA_TXD ]);
	PlayerTextDrawSetString(playerid, ptd_ph_design[playerid][0], Phone_Colours [ colour ] [ E_PH_DATA_TXD ]);

	for_loop ( new i, j = 13; i < j ; i ++ ) 
	{
		PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ i ] ) ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) 
	{
		for_loop ( new i = 0, j = 5; i < j ; i ++ ) 
		{
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ i ] ) ;
		}

		PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ 12 ] ) ;
	}
	else if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) 
	{
		for_loop ( new i, j = 13; i < j ; i ++ ) 
		{
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ i ] ) ;
		}	
	}

	PlayerVar [ playerid ] [ player_viewphone ] = true ;
	return true ;
}

Phone_ForceHidePhone(playerid) 
{
	for_loop (new i, j = 13; i < j ; i ++ ) {
		PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ i ] ) ;
	}

	for_loop (new i, j = 3; i < j ; i ++ ) {
		PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ i ] ) ;
	}

	CancelSelectTextDraw(playerid) ;
	RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM ) ;

	PlayerVar [ playerid ] [ player_viewphone ] = false ;

	return true ;
}

CMD:ph(playerid, params[]) {

	return cmd_phone(playerid,"");
}

CMD:pc(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	SelectTextDraw(playerid, PHONE_COLOUR_OK);
	return true ;
}

CMD:phoneanim(playerid) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	//ApplyAnimation(playerid,"PED", "phone_out", 4.1, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid,"PED", "phone_in", 4.1, 0, 0, 0, 1, 1);
	defer Phone_FinalizeCallAnimation(playerid);
	return true ;
}

CMD:phanim(playerid) {

	return cmd_phoneanim(playerid);
}

timer Phone_FinalizeCallAnimation[1250](playerid) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return true ;
    }

	ApplyAnimation(playerid,"PED", "phone_talk", 4.1, true, 0, 0, 1, 1);

	return true ;
}

stock Phone_IsNumberConnected ( number ) {

	foreach(new playerid: Player) {

		if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == number ) {

			return playerid ;
		}

		else continue ;
	}

	return INVALID_PLAYER_ID ; 
}
