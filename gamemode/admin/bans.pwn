CMD:kick(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target, reason [ 64 ] ;

	if ( sscanf ( params, "k<player>s[64]", target, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/kick [target] [reason]") ;
	}


	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Error", "A3A3A3", "Selected player doesn't exist, they might be offline.");
	}

	if ( GetPlayerAdminLevel ( target ) >= GetPlayerAdminLevel ( playerid ) ) 
	{
		new str[144] ;
		format ( str, sizeof ( str ), "[!!!] [AdmWarn] (%d) %s attempted to kick (%d) %s.", playerid, ReturnPlayerNameData ( playerid ), target, ReturnPlayerNameData ( target ) ) ;
		SendAdminWarning(str, true) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't kick admins of equal or higher rank.") ;
	}

	SetAdminRecord ( Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], ARECORD_TYPE_KICK, reason, 0, ReturnDateTime () ) ;

	new query [ 256 ] ;

	format ( query, sizeof ( query ), "[AdmCmd]: %s was kicked by %s. Reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_CHARACTER), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
	//SendAdminMessage(query) ;
	ZMsg_SendClientMessageToAll(COLOR_RED, query);
	DCC_SendAdminPunishmentMessage(query);

	//WriteLog ( playerid, "admin/kick", query);
	//WriteLog ( playerid, "admin/all", query);

	AddLogEntry(target, LOG_TYPE_ADMIN, sprintf("Was kicked by %s, reason: %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason));
	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Kicked %s, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), reason));

	KickPlayer(target);
	return true ;
}

CMD:silentkick(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target, reason [ 64 ] ;

	if ( sscanf ( params, "k<player>s[64]", target, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/silentkick [target] [reason]") ;
	}


	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Error", "A3A3A3", "Selected player doesn't exist, they might be offline.");
	}

	if ( GetPlayerAdminLevel ( target ) >= GetPlayerAdminLevel ( playerid ) ) 
	{
		new str[144] ;
		format ( str, sizeof ( str ), "[!!!] [AdmWarn] (%d) %s attempted to kick (%d) %s.", playerid, ReturnPlayerNameData ( playerid ), target, ReturnPlayerNameData ( target ) ) ;
		SendAdminWarning(str, true) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't kick admins of equal or higher rank.") ;
	}

	SetAdminRecord ( Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], ARECORD_TYPE_KICK, reason, 0, ReturnDateTime () ) ;

	new query [ 144 ] ;

	format ( query, sizeof ( query ), "[AdmCmd]: %s was silent-kicked by %s. Reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_CHARACTER), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
	DCC_SendAdminPunishmentMessage(query);

	AddLogEntry(target, LOG_TYPE_ADMIN, sprintf("Was silent-kicked by %s, reason: %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason));
	SendAdminCmd(playerid, sprintf("silent-kicked %s, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), reason), true);

	KickPlayer(target);
	return true ;
}

CMD:skick(playerid, params[])
{
	return cmd_silentkick(playerid, params);
}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


CMD:offlineban(playerid, params[]) {
	// master-acc
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new master_acc[MAX_PLAYER_NAME], hours, reason [ 64 ], query [ 300 ] ;

	if ( sscanf ( params, "s[24]is[64]", master_acc, hours, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/offlineban [account name] [hours (0=perm)] [reason]") ;
	}

	if ( strlen ( master_acc ) < 0 || strlen ( master_acc ) > MAX_PLAYER_NAME ) {

		format ( query, sizeof ( query ), "Master account name can't be shorter than 0 or longer than %d.", MAX_PLAYER_NAME ) ;
		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3", query ) ;
	}

	if ( hours > 720 || hours < 0 ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You can't temp ban someone for longer than 720 hours (4 weeks). For perm bans use 0.") ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if(hours == 0) {
		hours = 99999;
	}

	query[0]=EOS;
 	new  rows, fields ;

	inline ReturnAccountName() {

		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Database didn't return any account data. Maybe your mistyped the name" )  ;
		}

		if ( rows ) {

			if ( cache_get_field_content_int ( 0, "account_stafflevel", mysql ) >= GetPlayerAdminLevel ( playerid ) ) {

				return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't ban admins of equal or higher rank.") ;
			}

		   	new secs = hours * 3600, unbants, acc_id ;
		    unbants = gettime() + secs;

			acc_id = cache_get_field_content_int ( 0, "account_id", mysql ) ;

			new ip_address[32], acc_name[32];
			cache_get_field_content ( 0, "account_lastip", ip_address, mysql, 32 ) ;
			cache_get_field_content ( 0, "account_name", acc_name, mysql, 32 ) ;

			SendRconCommand(sprintf("banip %s", ip_address));

			SetAdminRecord ( acc_id, Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;

		    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
			acc_id, acc_name, ip_address, Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], reason, gettime(), unbants);

			mysql_tquery(mysql, query);

			if (hours == 99999)
			{
				format ( query, sizeof ( query ), "[AdmCmd]: %s was offline-banned by %s. Reason: %s.", acc_name, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
			}
			else
			{
				format ( query, sizeof ( query ), "[AdmCmd]: %s was offline-banned for %d hours by %s. Reason: %s.", acc_name, hours, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
			}
			
			ZMsg_SendClientMessageToAll(COLOR_RED, query);
			DCC_SendAdminPunishmentMessage(query);


			//WriteLog ( playerid, "admin/ban", query);
			//WriteLog ( playerid, "admin/all", query);

			// AddLogEntry(target, LOG_TYPE_ADMIN, sprintf("Was kicked by %s, reason: %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason));
			AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Offline banned %s, reason: %s", acc_name, reason));
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT account_name, account_id, account_lastip, account_stafflevel FROM accounts WHERE account_name = '%e'", master_acc ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountName, "");


	return true ;
}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

CMD:ban(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target, hours, reason [ 64 ] ;

	if ( sscanf ( params, "k<player>is[64]", target, hours, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/ban [target] [hours (0=perm)] [reason]") ;
	}

	if ( hours > 720 || hours < 0 ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You can't temp ban someone for longer than 720 hours (4 weeks). For perm bans use 0.") ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Error", "A3A3A3", "Selected player doesn't exist, they might be offline.");
	}

	if ( GetPlayerAdminLevel ( target ) >= GetPlayerAdminLevel ( playerid ) ) 
	{
		new str[144] ;
		format ( str, sizeof ( str ), "[!!!] [AdmWarn] (%d) %s attempted to ban (%d) %s.", playerid, ReturnPlayerNameData ( playerid ), target, ReturnPlayerNameData ( target ) ) ;
		SendAdminWarning(str, true) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't ban admins of equal or higher rank.") ;
	}

	if(hours == 0) {
		hours = 99999;
	}

    new secs = hours * 3600 ;
    new unbants = gettime() + secs;

  	new query[300] ;

	if (hours == 99999)
	{
		format ( query, sizeof ( query ), "[AdmCmd]: %s was banned by %s. Reason: %s.", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
	}
	else
	{
		format ( query, sizeof ( query ), "[AdmCmd]: %s was banned for %d hours by %s. Reason: %s.", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), hours, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
	}
	
	ZMsg_SendClientMessageToAll(COLOR_RED, query);
	DCC_SendAdminPunishmentMessage(query);

	//WriteLog ( playerid, "admin/ban", query);
	//WriteLog ( playerid, "admin/all", query);

	AddLogEntry(target, LOG_TYPE_ADMIN, sprintf("Was banned by %s, reason: %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason));
	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Banned %s, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), reason));

    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
		Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ target ] [ E_PLAYER_ACCOUNT_NAME ], ReturnIP ( target ), Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], reason, gettime(), unbants);

	mysql_tquery(mysql, query);

	SetAdminRecord ( Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
	
	inline BanDlg(pid, dialogid, response, listitem, string:inputtext[]) { 
		#pragma unused pid, dialogid, listitem, inputtext

		if (!response) { 
			return true;
		}

		if(response){
			return true;
		}
	}

	new BanDlgStr[1024];

	if(hours == 99999) {
		format(BanDlgStr, sizeof(BanDlgStr), "{dedede}You have been {fc6868}banned{dedede} from the server.");
	} else {
		format(BanDlgStr, sizeof(BanDlgStr), "{dedede}You have been {fc6868}temporarily banned{dedede} from the server.");
	}

	strcat(BanDlgStr, sprintf("\n\n{fc6868}Admin: {fcaeae}%s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY)));
	strcat(BanDlgStr, sprintf("\n{fc6868}Reason: {fcaeae}%s", reason));

	new year, month, day, hour, minute, second;
	stamp2datetime(unbants, year, month, day, hour, minute, second, 1 ) ;

	strcat(BanDlgStr, sprintf("\n{fc6868}Date: {fcaeae}%s", ReturnDateTime()));

	if(hours == 99999) {
		strcat(BanDlgStr, "\n\n{dedede}This ban can be appealed @ {fc6868}forum.gta-chronicles.com{dedede}\nYou may screenshot this message for referral.");
		strcat(BanDlgStr, "\n\n{dedede}Ensure you follow the correct format when submitting your appeal.");
	} else {
		strcat(BanDlgStr, sprintf("\n\n{dedede}This ban will expire automatically in {fc6868}%d hours{dedede}.", hours));
		strcat(BanDlgStr, "\nYou can also appeal it @ {fc6868}forum.gta-chronicles.com{dedede}");
		strcat(BanDlgStr, "\n\n{dedede}You may screenshot this message for referral.");
	}

	Dialog_ShowCallback ( target, using inline BanDlg, DIALOG_STYLE_MSGBOX, "Server Ban Notification", BanDlgStr, "Close" );

	format ( query, sizeof ( query ), "banip %s", ReturnIP ( target ) ) ; 

	SendRconCommand(query);
	KickPlayer ( target ) ;

	return true ;	
}


CMD:silentban(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target, hours, reason [ 64 ] ;

	if ( sscanf ( params, "k<player>is[64]", target, hours, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/silentban [target] [hours (0=perm)] [reason]") ;
	}

	if ( hours > 720 || hours < 0 ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You can't temp ban someone for longer than 720 hours (4 weeks). For perm bans use 0.") ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_RED, "Error", "A3A3A3", "Selected player doesn't exist, they might be offline.");
	}

	if ( GetPlayerAdminLevel ( target ) >= GetPlayerAdminLevel ( playerid ) ) 
	{
		new str[144] ;
		format ( str, sizeof ( str ), "[!!!] [AdmWarn] (%d) %s attempted to ban (%d) %s.", playerid, ReturnPlayerNameData ( playerid ), target, ReturnPlayerNameData ( target ) ) ;
		SendAdminMessage(str, true) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't ban admins of equal or higher rank.") ;
	}

	if(hours == 0) {
		hours = 99999;
	}

    new secs = hours * 3600 ;
    new unbants = gettime() + secs;

  	new query[256] ;

	if (hours == 99999) SendAdminCmd(playerid, sprintf("silent-banned %s, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), reason), true);
	else SendAdminCmd(playerid, sprintf("silent-banned %s for %d hours, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), hours, reason), true);
	
	format ( query, sizeof ( query ), "[AdmCmd]: %s was silent-banned by %s. Reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), reason );
	DCC_SendAdminPunishmentMessage(query);

	//WriteLog ( playerid, "admin/ban", query);
	//WriteLog ( playerid, "admin/all", query);

	AddLogEntry(target, LOG_TYPE_ADMIN, sprintf("Was silent banned by %s, reason: %s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason));
	//AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Silent banned %s, reason: %s", SOLS_PlayerName(target, PLAYER_NAME_STYLE_LEGACY), reason));

    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
		Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ target ] [ E_PLAYER_ACCOUNT_NAME ], ReturnIP ( target ), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), reason, gettime(), unbants);

	mysql_tquery(mysql, query);

	SetAdminRecord ( Account [ target ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], ARECORD_TYPE_BAN, reason, hours, ReturnDateTime () ) ;
	
	format ( query, sizeof ( query ), "banip %s", ReturnIP ( target ) ) ; 

	SendRconCommand(query);
	KickPlayer ( target ) ;

	return true ;	
}



CMD:unban(playerid, params[] ) {
	// master-acc
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new master_acc [ MAX_PLAYER_NAME ], query[256] ;

	if ( sscanf ( params, "s[24]", master_acc) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/unban [master-account-name]") ;
	}

	if ( strlen ( master_acc ) < 0 || strlen( master_acc ) > MAX_PLAYER_NAME ) {

		format ( query, sizeof ( query ), "Master account name can't be shorter than 0 or longer than %d.", MAX_PLAYER_NAME  ) ;
		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3", query )  ;
	}


    new rows, fields ;

	inline ReturnAccountName() {

		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Database didn't return any account data. Maybe your mistyped the name" )  ;
		}

		if ( rows ) {

			new acc_id, last_ip[16], returned_name[32] ;
			acc_id = cache_get_field_content_int ( 0, "account_id", mysql ) ;
			cache_get_field_content ( 0, "account_lastip", last_ip, mysql, 16 ) ;
			cache_get_field_content(0, "account_name", returned_name, mysql, sizeof ( returned_name ) ) ;

			inline CheckUnban() {

				cache_get_data ( rows, fields, mysql ) ;

				if ( ! rows ) {
					format ( query, sizeof ( query ),"(%d) %s doesn't seem to be banned. Did you type the name correctly?", acc_id, returned_name );
					return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  query ) ;
				}

				else if ( rows ) {

				    mysql_format ( mysql, query, sizeof ( query), "DELETE FROM bans WHERE account_id = %d", acc_id ) ;
					mysql_tquery(mysql, query);

					format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has unbanned (%d) %s", 
					 	ReturnPlayerNameData ( playerid ), acc_id, returned_name ) ;

					//SendAdminMessage(query, true) ;
					UnbanIPAddr(last_ip);
					DCC_SendAdminPunishmentMessage(query);

					//WriteLog ( playerid, "admin/ban", query);
					//WriteLog ( playerid, "admin/all", query);

					SendAdminCmd(playerid, sprintf("unbanned (%d) %s", acc_id, returned_name), true);

					//SendClientMessage(playerid, COLOR_YELLOW, "Don't forget to /unbanip their IP address or they won't be able to connect!" ) ;
				}
			}

			mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM bans WHERE account_id = %d", acc_id ) ;
			mysql_tquery_inline(mysql, query, using inline CheckUnban, "");
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT account_name, account_id, account_lastip FROM accounts WHERE account_name = '%e'", master_acc ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountName, "");

	return true ;
}


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

CMD:banip(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new ip [ 16 ], hours, reason[64], query[256] ;

	if ( sscanf ( params, "s[16]is[64]", ip, hours, reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/banip [ip address (including dots)] [hours] [reason]") ;
	}

	foreach(new targetid: Player ) {

		if ( ! strcmp(ip, ReturnIP(targetid), true ) ) {

			// User is online...
			format ( query, sizeof ( query ),"User seems to be connected as ID %d. Use /ban instead.", targetid  ) ;
			return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3", query ) ;
		}	
	}

	if ( hours > 720 || hours < 0 ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You can't temp ban someone for longer than 720 hours (4 weeks). For perm bans use 0.") ;
	}

	if ( strlen ( reason ) > sizeof ( reason ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Reason can't be longer than 64 characters.") ;
	}

	if(hours == 0) {
		hours = 99999;
	}

	inline BanIPStaffCheck() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows && cache_get_field_content_int ( 0, "lvl", mysql ) >= GetPlayerAdminLevel ( playerid ) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You can't ban the IP of admins of equal or higher rank.") ;
		}

    new secs = hours * 3600 ;
    new unbants = gettime() + secs;
    
    mysql_format(mysql, query, sizeof(query), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
		-1, "Unknown", ip, ReturnPlayerNameData(playerid), reason, gettime(), unbants);

	mysql_tquery(mysql, query);

	format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has banned IP %s for %d hours. Reason: %s.", 
 		ReturnPlayerNameData ( playerid ), ip, hours, reason ) ;

	WriteLog ( playerid, "admin/ban", query);
	WriteLog ( playerid, "admin/all", query);

	SendAdminMessage(query, true) ;
	DCC_SendAdminPunishmentMessage(query);

	format ( query, sizeof ( query ), "banip %s", ip ) ; 
	SendRconCommand(query ) ;

		return true ;
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT MAX(account_stafflevel) AS lvl FROM accounts WHERE account_lastip = '%e'", ip ) ;
	mysql_tquery_inline(mysql, query, using inline BanIPStaffCheck, "");

	return true ;
}

UnbanIPAddr(ip[16])
{
	new string [ 128 ] ;
	format ( string, sizeof ( string ), "unbanip %s", ip ) ; 
	SendRconCommand(string ) ;
	SendRconCommand("reloadbans");
}

CMD:unbanip ( playerid, params [] ) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new ip [  16 ];
	new string [ 128 ] ;

	if ( sscanf ( params, "s[16]", ip ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/unbanip [ip]") ;
	}

	UnbanIPAddr(ip);
	format ( string, sizeof ( string ), "[!!!] [AdmWarn] %s has unbanned IP %s.", ReturnPlayerNameData ( playerid ), ip ) ;
	//SendAdminMessage(string, true) ;
	DCC_SendAdminPunishmentMessage(string);

	SendAdminCmd(playerid, sprintf("unbanned IP %s", ip), true);

	//WriteLog ( playerid, "admin/ban", string);
	//WriteLog ( playerid, "admin/all", string);

	return true ;
}

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
BanChecker ( playerid ) {

	new query [ 512 ] ;

	inline BanHandler() {
		new rows, fields ;

		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {
			Account_DisplayCharacters(playerid);
			return true ;
		}

	    else if ( rows ) {

			new unbantimestamp, admin [ MAX_PLAYER_NAME ], reason [ 64 ], date [ 6 ]  ;

			for_loop ( new i, p = rows; i < p; i ++ ) {

				if ( cache_get_field_int ( i, "unban_time" ) <= gettime () ) {

					continue ;
				}

				cache_get_field_content ( i, "ban_admin", admin, mysql, 24 ) ;
				cache_get_field_content ( i, "ban_reason", reason, mysql, 36 ) ;

				unbantimestamp = cache_get_field_int ( i, "unban_time" ) ;
			}

			if ( unbantimestamp > gettime () )  {

			query [ 0 ] = EOS ;

			stamp2datetime ( unbantimestamp,date[0], date[1], date[2], date[3], date[4], date[5], 1 );

			SendClientMessage(playerid, COLOR_RED, "" ) ;
			SendClientMessage(playerid, COLOR_RED, "This account has been temporarily suspended due to a breach of our rules." ) ;
			SendClientMessage(playerid, COLOR_RED, "" ) ;

			format ( query, sizeof ( query ), "You got banned by admin %s for %s.", admin, reason) ;
			SendClientMessage(playerid, COLOR_RED, query );

			format ( query, sizeof ( query ), "You will be unbanned at {DEDEDE}%02d/%02d/%02d %02d:%02d:%02d", date[2], date[1], date[0], date[3], date[4], date[5]) ;
			SendClientMessage(playerid, COLOR_RED, query );
			SendClientMessage(playerid, COLOR_RED, "" ) ;
			SendClientMessage(playerid, COLOR_RED, "Please do not try to evade this ban, as it is only temporary and ban evading results in a permanent ban." ) ;

			format ( query, sizeof ( query ), "If you do not agree with this ban, please appeal the ban on our forums. {DEDEDE}(%s)", SERVER_WEBSITE ) ;
			SendClientMessage(playerid, COLOR_RED,query ) ;
			
			SendClientMessage(playerid, COLOR_RED, "" ) ;

			format ( query, sizeof ( query ), "banip %s", ReturnIP ( playerid ) ) ; 
			SendRconCommand(query ) ;

	    	return KickPlayer ( playerid ) ;
			}

			Account_DisplayCharacters(playerid);
			return true ;
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT unban_time, ban_admin, ban_reason FROM bans WHERE account_id = '%d'", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
	mysql_tquery_inline ( mysql, query, using inline BanHandler, "" ) ;

	return false ;
}