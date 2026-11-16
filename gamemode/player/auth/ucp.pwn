CheckUCPStatus(playerid) {

	new query [ 512 ] ;
	
	inline UCPStatusChecker() {
		new rows, fields ;

		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			SendUCPMessage(playerid) ;
			KickPlayer(playerid);
			return true ;
		}

	    else if ( rows ) {

			for_loop ( new i, p = rows; i < p; i ++ ) {
	    		if(cache_get_field_int ( i, "ucp_app_status" ) == 1 ) {
					BanChecker ( playerid ) ;	
					break ;
				}

				else {
					SendUCPMessage(playerid) ;
					KickPlayer(playerid);
					return true ;
				}
			}
	    } 
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM ucp_applications WHERE ucp_account_id = '%d'", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
	mysql_tquery_inline ( mysql, query, using inline UCPStatusChecker, "" ) ;

	return true ;
}


SendUCPMessage(playerid) {
	SendClientMessage(playerid, 0xD1B68DFF, "===={DBB275}===={D5A04E}===={DE921F}===={DEDEDE} [{C87900} UCP {DEDEDE}] {DE921F}===={D5A04E}===={DBB275}===={D1B68D}====" ) ;
	SendClientMessage(playerid, 0xDEDEDEFF, " ");
	SendClientMessage(playerid, 0xDEDEDEFF, "As of early April 2022, we are no longer allowing free registrations on our server.");
	SendClientMessage(playerid, 0xDEDEDEFF, " ");
	ZMsg_SendClientMessage(playerid, 0xDEDEDEFF, "To play, please create a master account at {C87900}https://play.gta-chronicles.com/{DEDEDE} and do our application.");
	ZMsg_SendClientMessage(playerid, 0xDEDEDEFF, "Applications are evaluated by staff and within 24 to 48 hours and will help get you established on the server.");
	ZMsg_SendClientMessage(playerid, 0xDEDEDEFF, "Before you submit your application, read our rules at {C87900}https://gta-chronicles.com/misc/rules/{DEDEDE}.");
	ZMsg_SendClientMessage(playerid, 0xDEDEDEFF, "For questions, visit our Discord at {C87900}https://gta-chronicles.com/discord/{DEDEDE}. For support, visit {C87900}https://support.gta-chronicles.com{DEDEDE}.");
	SendClientMessage(playerid, 0xDEDEDEFF, " ");
	SendClientMessage(playerid, 0xD1B68DFF, "===={DBB275}===={D5A04E}===={DE921F}===={C87900}======={DE921F}===={D5A04E}===={DBB275}===={D1B68D}====" ) ;
}