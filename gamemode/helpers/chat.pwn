CMD:helperchat(playerid, params[]) 
{
	if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {
		if ( ! IsPlayerHelper ( playerid ) ) {

			return SendServerMessage ( playerid, COLOUR_HELPER, "Helper", "A3A3A3", "You need to be a helper in order to be able to do this!" ) ;
		}
	}
	
	if (Account[playerid][E_ACCOUNT_SETTINGS_HELPER_MSG]) return SendServerMessage(playerid, COLOUR_HELPER, "Error", "A3A3A3", "You've disabled helper messages/chat in settings.");

	new text [ 128 ] ;

	if ( sscanf ( params, "s[128]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/h(elper)c(hat) [text]" ) ;
		return true ;
	}
	

	new string[144];
	new rank_name[32];

	if (Account[playerid][E_PLAYER_ACCOUNT_CONTRIBUTOR]) GetContributorRankName(Account[playerid][E_PLAYER_ACCOUNT_CONTRIBUTOR], rank_name, 32);
	else if (GetPlayerAdminLevel(playerid)) GetAdminRankName(Account[playerid][E_PLAYER_ACCOUNT_STAFFLEVEL], rank_name, 32);
	else if (GetPlayerHelperLevel(playerid)) GetHelperRankName(Account[playerid][E_PLAYER_ACCOUNT_SUPPORTER], rank_name, 32);
	
	format(string, sizeof (string), "{[ [HELPER] (%d) %s %s: %s ]}", playerid, rank_name, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text);
	SendHelperMessage(string, Server[E_SERVER_HELPER_HEX]);
	WriteLog(playerid, "helper/chat", string);

	return true ;
}

CMD:hc(playerid, params[]) {

	return cmd_helperchat(playerid, params);
}
