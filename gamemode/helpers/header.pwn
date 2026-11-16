

#include "helpers/data.pwn"
#include "helpers/chat.pwn"
#include "helpers/ask.pwn"


IsPlayerHelper ( playerid ) {

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR ) {

		return true ; 
	}

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] ) {

		return true ;
	}

	return false ;
}

SendHelperMessage(text[], color = -1) {

	if ( color == -1 ) {

		color = RGBA_DARKER(Server [ E_SERVER_HELPER_HEX ]);
	}

	foreach(new helperid: Player) {

		if ( ! IsPlayerLogged ( helperid ) ) {

			continue ;
		}

		/*
		if ( PlayerVar [ helperid ] [ E_PLAYER_ADMIN_WARNS_TOGGLED ] ) {
			continue ;
		}
		*/

		if (Account[helperid][E_ACCOUNT_SETTINGS_HELPER_MSG]) continue;

		if ( IsPlayerHelper ( helperid ) || Account [ helperid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {

			ZMsg_SendClientMessage(helperid, color, text ) ;
		}

		else continue ;
	}

	return true ;
}

SendHelperCmdWarn(playerid, text[])
{
	new string[144];
	AddLogEntry(playerid, LOG_TYPE_ADMIN, text);

	if (GetPlayerAdminLevel(playerid))
	{
		SendAdminCmd(playerid, text);
		//format(string, sizeof(string), "[AdmCmd] (%d) %s has %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text);
		//SendAdminMessage(string);
		return;
	}

	format(string, sizeof(string), "[HlpCmd] (%d) %s has %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text);
	
	foreach(new i: Player) 
	{
		if (GetPlayerHelperLevel(i))
		{
			ZMsg_SendClientMessage(i, 0x79bab3FF, string);
		}
	}
}

SendAdvHelperMsg(text[], bool:log=true) 
{
	foreach(new playerid: Player) 
	{
		if (IsPlayerLogged(playerid) && GetPlayerHelperLevel(playerid) >= HELPER_LVL_ADVANCED)
		{
			ZMsg_SendClientMessage(playerid, 0x79bab3FF, text);
		}
	}

	if (log) DCC_SendAdminLogMessage(text);
}

CMD:answer ( playerid, params [] ) {

	//if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {
	if ( ! IsPlayerHelper ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new userid, answer [ 144 ] ;

	if ( sscanf ( params, "k<player>s[144]", userid, answer ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/answer [id] [answer]") ;
	}

	if ( ! IsPlayerConnected ( userid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player isn't connected!") ;
	}

	new string [ 256 ] ;

	format ( string, sizeof ( string ), "[Answer]{DEDEDE} (%d) %s replied: %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), answer ) ; 
	ZMsg_SendClientMessage(userid, RGBA_DARKER ( Server [ E_SERVER_HELPER_HEX ] ), string ) ;
	
	format ( string, sizeof ( string ), "[Answer] (%d) %s replies to (%d) %s: %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), userid, SOLS_PlayerName(userid, PLAYER_NAME_STYLE_CHARACTER), answer) ; 
	SendHelperMessage( string ) ;

	return true ;
}

CMD:ans(playerid, params[])
{
	return cmd_answer(playerid, params);
}

CMD:helperduty (playerid, params[]){

	if ( GetPlayerHelperLevel(playerid) < HELPER_LVL_SENIOR )
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

    new string[64];

	if(!PlayerVar[playerid][E_PLAYER_HELPER_DUTY]){

		inline HelperConfirm(pid, dialogid, response, listitem, string:inputtext[]) {
	    	#pragma unused pid, dialogid, listitem, inputtext

			if ( ! response ) {

	    		return false ;
			}

			if ( response ) {

				PlayerVar [ playerid ] [ E_PLAYER_HELPER_DUTY ] = true ;
				TextDrawShowForPlayer(playerid, E_HELPER_DUTY_TEXT );

				UpdatePlayerNamesForOthers ( playerid ) ;

				format ( string, sizeof ( string ), "(%d) %s has gone on helper duty.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY) ) ;
				SendAdminMessage(string);
				
				AddLogEntry(playerid, LOG_TYPE_ADMIN, "has gone on helper duty.");

				return true ;
			}
		}

		new confirmstring [ 1024 ] ;

		format ( confirmstring, sizeof ( confirmstring ), "{DEDEDE}You're now on {AEC77D}Helper Duty{DEDEDE}, an exemption from roleplay so you can perform your duties properly.\nDon't mistake this as an admin privilege.");

		Dialog_ShowCallback ( playerid, using inline HelperConfirm, DIALOG_STYLE_MSGBOX, "{AEC77D}HELPER DUTY CONFIRMATION{DEDEDE}", confirmstring, "Continue", "Exit" );

	} else if(PlayerVar[playerid][E_PLAYER_HELPER_DUTY]) {

		PlayerVar [ playerid ] [ E_PLAYER_HELPER_DUTY ] = false ;
		TextDrawHideForPlayer(playerid, E_HELPER_DUTY_TEXT );

		UpdatePlayerNamesForOthers ( playerid ) ;

		format ( string, sizeof ( string ), "(%d) %s has gone off helper duty.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY) ) ;
		SendAdminMessage(string);

		AddLogEntry(playerid, LOG_TYPE_ADMIN, "has gone off helper duty.");

	}

	return true;

}

CMD:hduty(playerid, params[])
{
	return cmd_helperduty(playerid, params);
}