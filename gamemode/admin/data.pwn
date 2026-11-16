#if defined _inc_data
	#undef _inc_data
#endif
enum { // admin ranks
	ADMIN_LVL_NONE,
	ADMIN_LVL_JUNIOR = 1,
	ADMIN_LVL_GENERAL,
	ADMIN_LVL_SENIOR,
	ADMIN_LVL_ADVANCED,
	ADMIN_LVL_MANAGER,
	ADMIN_LVL_DEVELOPER
} ;

GetAdminRankName(rank, rank_name[], len = sizeof ( rank_name ) ) {

	rank_name [ 0 ] = EOS ;

	switch ( rank ) {

		case ADMIN_LVL_JUNIOR:		strcat ( rank_name, "Junior Admin", len ) ;
		case ADMIN_LVL_GENERAL:		strcat ( rank_name, "General Admin", len ) ;
		case ADMIN_LVL_SENIOR:		strcat ( rank_name, "Senior Admin", len ) ;
		case ADMIN_LVL_ADVANCED:	strcat ( rank_name, "Advanced Admin", len ) ;
		case ADMIN_LVL_MANAGER:		strcat ( rank_name, "Lead Admin", len ) ;
		case ADMIN_LVL_DEVELOPER:	strcat ( rank_name, "Manager", len ) ;
		default: strcat ( rank_name, "Regular", len ) ;
	}
}

GetAdminRankColor(rank, rank_color[], len = sizeof ( rank_color ) ) {

	rank_color [ 0 ] = EOS ;

	switch ( rank ) {

		case ADMIN_LVL_JUNIOR:		strcat ( rank_color, "{ffc069}", len ) ;
		case ADMIN_LVL_GENERAL:		strcat ( rank_color, "{f4a442}", len ) ;
		case ADMIN_LVL_SENIOR:		strcat ( rank_color, "{f58840}", len ) ;
		case ADMIN_LVL_ADVANCED:	strcat ( rank_color, "{d47d44}", len ) ;
		case ADMIN_LVL_MANAGER:		strcat ( rank_color, "{a45d5d}", len ) ;
		case ADMIN_LVL_DEVELOPER:	strcat ( rank_color, "{a45d5d}", len ) ;
		default: strcat ( rank_color, "{FFFFF}", len ) ;
	}
}

#define RGBA_DARKER(%0) (((%0 & 0x7E7E7E00) >> 1) | (%0 & 0x80808000))

SendAdminCmd(playerid, text[], bool:priority = false, rank = 1, bool:log=false)
{
	new color = RGBA_DARKER(COLOR_INFO);
	new string[144];

	format(string, sizeof(string), "[AdmCmd]: You %s.", text);
	SendClientMessage(playerid, COLOR_INFO, string);

	format(string, sizeof(string), "[AdmCmd]: (%d) %s %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text);
	foreach(new adminid: Player) 
	{
		if (adminid == playerid) continue;
		if (GetPlayerAdminLevel(adminid) >= rank && IsPlayerLogged(adminid))
		{
			if (priority || !Account[adminid][E_ACCOUNT_SETTINGS_ADMIN_CMD])
			{
				SendClientMessage(adminid, color, string);
			}
		}
	}

	if (log) DCC_SendAdminLogMessage(string);

	text[0] = toupper(text[0]);
	AddLogEntry(playerid, LOG_TYPE_ADMIN, text);
}

SendAdminMessage(text[], bool:priority = false, rank = 1, bool:log=false, color = 0)
{
	if (color == 0) color = RGBA_DARKER(Server[E_SERVER_ADMIN_HEX]);

	foreach(new adminid: Player) 
	{
		if (GetPlayerAdminLevel(adminid) >= rank && IsPlayerLogged(adminid))
		{
			if (priority || !Account[adminid][E_ACCOUNT_SETTINGS_ADMIN_MSG])
			{
				ZMsg_SendClientMessage(adminid, color, text);
			}
		}
	}

	if (log) DCC_SendAdminLogMessage(text);
}

SendAdminWarning(text[], bool:priority = false, rank = 1, bool:log=false, color = 0)
{
	if (color == 0) color = RGBA_DARKER(Server[E_SERVER_ADMIN_HEX]);

	foreach(new adminid: Player) 
	{
		if (GetPlayerAdminLevel(adminid) >= rank && IsPlayerLogged(adminid))
		{
			if (priority || !Account[adminid][E_ACCOUNT_SETTINGS_ADMIN_WRN])
			{
				ZMsg_SendClientMessage(adminid, color, text);
			}
		}
	}

	if (log) DCC_SendAdminLogMessage(text);
}

SendManagerChat(text[])
{
	return SendManagerMessage(text, true, 0x0088FFFF);
}

SendManagerMessage(text[], bool:nohide = false, color = 0x235F94FF) {

	foreach(new playerid: Player) {
		if ( Character [ playerid ] [ E_CHARACTER_ID ] == -1 ) {

			continue ;
		}

		if ( ! IsPlayerLogged ( playerid ) ) {

			continue ;
		}

		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] <= 0 ) {
			continue ;
		}
		
		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] >= ADMIN_LVL_MANAGER && (nohide || !PlayerVar [ playerid ] [ E_PLAYER_MANAGER_WARNS_TOGGLED ])) 
		{
			ZMsg_SendClientMessage(playerid, color, text);
		}

		else continue ;
	}


    WriteLog ( -1, "manager/log", text );
	return 1;
}

GetPlayerAdminLevel ( playerid ) {

	if ( IsPlayerAdmin ( playerid ) ) {

		return ADMIN_LVL_DEVELOPER ;
	}

	return Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] ; 
}

IsPlayerManager ( playerid ) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] >= ADMIN_LVL_MANAGER ) {

		return true ;
	}

	else return false ;
}

CMD:a(playerid, params[]) {
	if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {
		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] <= ADMIN_LVL_NONE ) {

			return false ;
		}
	}

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/a(chat) [text]" ) ;
		return true ;
	}

	new string[144];
	new rank_name[32];

	if (Account[playerid][E_PLAYER_ACCOUNT_CONTRIBUTOR]) GetContributorRankName(Account[playerid][E_PLAYER_ACCOUNT_CONTRIBUTOR], rank_name, 32);
	else if (GetPlayerAdminLevel(playerid)) GetAdminRankName(Account[playerid][E_PLAYER_ACCOUNT_STAFFLEVEL], rank_name, 32);
	else return true;
	
	if (Account[playerid][E_PLAYER_ACCOUNT_ID] == 16341) format(string, sizeof (string), "{[ [ADMIN] (%d) %s %s: %s ]}", playerid, rank_name, "Connector", text);
	else if (Account[playerid][E_PLAYER_ACCOUNT_ID] == 16524) format(string, sizeof (string), "{[ [ADMIN] (%d) %s %s: %s ]}", playerid, rank_name, "Kinkography", text);
	else format(string, sizeof (string), "{[ [ADMIN] (%d) %s %s: %s ]}", playerid, rank_name, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text);

	SendAdminMessage(string, true, 1, false, Server[E_SERVER_ADMIN_HEX]);
	return true ;
}
CMD:achat(playerid, params[]) {

	return cmd_a(playerid, params);
}

forward SOLS_OnAdmDutyChange(playerid);
public SOLS_OnAdmDutyChange(playerid)
{
	// Hook this
	// printf("SOLS_OnAdmDutyChange: %d", playerid);
	return 1;
}

CMD:aduty(playerid, params[]) {

	return cmd_adminduty(playerid, params);
}

CMD:adminduty(playerid, params[]) {
	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] <= ADMIN_LVL_NONE ) {

		return false ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_ADMIN_DUTY ] ) {
		PlayerVar [ playerid ] [ E_PLAYER_ADMIN_DUTY ] = true ;
		TextDrawShowForPlayer(playerid, E_ADMIN_DUTY_TEXT );

		/*if ( IsValidDynamic3DTextLabel(PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] ) ) {

			DestroyDynamic3DTextLabel(PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] );
		}

		new Float: height = 0.5 ;

		switch ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] ) {

			case ADMIN_LVL_NONE: return true ;
			case ADMIN_LVL_JUNIOR .. ADMIN_LVL_GENERAL : {

				PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] = CreateDynamic3DTextLabel("(( Out of Character ))\n{[ Administrator on Duty ]}", 0xDBB275FF,
					0.0, 0.0, height, 15, playerid, INVALID_VEHICLE_ID, true, -1,  -1, -1, 15.0);
			}
			case ADMIN_LVL_ADVANCED: {

				PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] = CreateDynamic3DTextLabel("(( Out of Character ))\n{[ Lead Admin on Duty ]}", 0xD5A04EFF,
					0.0, 0.0, height, 15, playerid, INVALID_VEHICLE_ID, true, -1,  -1, -1, 15.0);
			}
			case ADMIN_LVL_MANAGER: {

				PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] = CreateDynamic3DTextLabel("(( Out of Character ))\n{[ Manager on Duty ]}", 0xd84b1cFF,
					0.0, 0.0, height, 15, playerid, INVALID_VEHICLE_ID, true, -1,  -1, -1, 15.0);
			}

			case ADMIN_LVL_DEVELOPER: {

				PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] = CreateDynamic3DTextLabel("(( Out of Character ))\n{[ Developer on Duty ]}", 0xFE7F12FF,
					0.0, 0.0, height, 15, playerid, INVALID_VEHICLE_ID, true, -1,  -1, -1, 15.0);		
			}
		}*/

		UpdatePlayerNamesForOthers ( playerid ) ;
		AddLogEntry(playerid, LOG_TYPE_ADMIN, "Went on admin duty");
	}

	else if ( PlayerVar [ playerid ] [ E_PLAYER_ADMIN_DUTY ] ) {
		PlayerVar [ playerid ] [ E_PLAYER_ADMIN_DUTY ] = false ;
		TextDrawHideForPlayer(playerid, E_ADMIN_DUTY_TEXT );

		/*if ( IsValidDynamic3DTextLabel(PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] ) ) {

			DestroyDynamic3DTextLabel(PlayerVar [ playerid ] [ E_PLAYER_ADMIN_LABEL ] );
		}*/

		UpdatePlayerNamesForOthers ( playerid ) ;
		AddLogEntry(playerid, LOG_TYPE_ADMIN, "Turned off admin duty");
	}

	CallLocalFunction("SOLS_OnAdmDutyChange", "d", playerid);

	return true ;
}


CMD:man(playerid, params[]) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/a(chat) [text]" ) ;
		return true ;
	}

	
	new string [ 256 ], rank_name [ 32 ] ;

	GetAdminRankName ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ], rank_name, 32 ) ;

	format ( string, sizeof ( string ), "{[ [MANAGER] (%d) %s: %s ]}", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text ) ;
	SendManagerChat(string) ;

	return true ;
}

CMD:togman(playerid) {

	if ( GetPlayerAdminLevel(playerid) < ADMIN_LVL_MANAGER )
		return SendClientMessage ( playerid, COLOR_ERROR, "Only managers can use this command." ) ;

	if ( PlayerVar [ playerid ] [ E_PLAYER_MANAGER_WARNS_TOGGLED ] ) 
	{
		PlayerVar [ playerid ] [ E_PLAYER_MANAGER_WARNS_TOGGLED ] = false ;
		SendClientMessage ( playerid, COLOR_BLUE, "You've re-enabled manager warnings for you.");
	}
	else 
	{
		PlayerVar [ playerid ] [ E_PLAYER_MANAGER_WARNS_TOGGLED ] = true ;
		SendClientMessage ( playerid, COLOR_BLUE, "You've temporarily disabled manager warnings for you.");
	}

	return true ;
}


CMD:makeadmin(playerid, params[]) {


	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	new user, adminlvl, string [ 256 ] ;

	if ( sscanf ( params, "k<player>i", user, adminlvl ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/makeadmin [player] [level]" ) ;
		return true ;
	}

	if ( ! IsPlayerConnected(user)) {
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
		return true ;	
	}

	if ( ! IsPlayerAdmin(playerid) ) {
		if ( adminlvl < ADMIN_LVL_NONE || adminlvl > ADMIN_LVL_DEVELOPER ) {

			format ( string, sizeof ( string ), "Level can't be less than 0 or higher than %d.", ADMIN_LVL_DEVELOPER ) ;
			SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", string );
			return true ;
		}
	}
	
	new rank_name [ 32 ] ;

	Account [ user ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = adminlvl ;


	GetAdminRankName ( Account [ user ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ], rank_name, 32 ) ;

	format ( string, sizeof ( string ), "{[ %s (%d) has promoted %s (%d) to %s. ]}",  ReturnPlayerNameData ( playerid ), playerid,
		ReturnPlayerNameData ( user ), user, rank_name ) ;

	SendAdminMessage(string, true);

	WriteLog ( playerid, "admin/makeadmin", string );
	WriteLog ( playerid, "admin/all", string );

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, sizeof(string), "UPDATE accounts SET account_stafflevel = %d WHERE account_id = %d", 

		Account [ user ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ], Account [ user ] [ E_PLAYER_ACCOUNT_ID ] ) ;

	mysql_tquery(mysql, string);

	return true ;
}

CMD:adminhex(playerid, params[]) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	new input ;

	if ( sscanf  (params, "h", input ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/adminhex [hex] (Default: 0xde6e1fFF)" ) ;
		return true ;
	}

	Server [ E_SERVER_ADMIN_HEX ] = input ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE server SET server_admin_hex = %d", Server [ E_SERVER_ADMIN_HEX ] ) ;
	mysql_tquery(mysql, query);

	SendClientMessage(playerid, Server [ E_SERVER_ADMIN_HEX ], "Admin chat colour changed! " ) ;

	return true ;
}

CMD:registrations(playerid, params[]) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	if(!Server [ E_SERVER_REGISTRATION_UCP ]) {

		SendAdminMessage(sprintf("[UCP] %s( %d) has disallowed ingame registrations.", ReturnPlayerNameData ( playerid ), playerid ), true) ;
		SendClientMessage(playerid, COLOR_YELLOW, "You have disallowed ingame registrations." ) ;
	
		Server [ E_SERVER_REGISTRATION_UCP ] = true ;
	}

	else if(Server [ E_SERVER_REGISTRATION_UCP ]) {

		SendAdminMessage(sprintf("[UCP] %s( %d) has allowed ingame registrations.", ReturnPlayerNameData ( playerid ), playerid ), true) ;
		SendClientMessage(playerid, COLOR_YELLOW, "You have allowed ingame registrations." ) ;

		Server [ E_SERVER_REGISTRATION_UCP ] = false ;
	}

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE server SET registration_ucp = %d", Server [ E_SERVER_REGISTRATION_UCP ] ) ;
	mysql_tquery(mysql, query);

	return true ;
}

CMD:helperhex(playerid, params[]) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	new input ;

	if ( sscanf  (params, "h", input ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/helperhex [hex] (Default: 0xAEC77DFF)" ) ;
		return true ;
	}

	Server [ E_SERVER_HELPER_HEX ] = input ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE server SET server_helper_hex = %d", Server [ E_SERVER_HELPER_HEX ] ) ;
	mysql_tquery(mysql, query);

	SendClientMessage(playerid, Server [ E_SERVER_HELPER_HEX ], "Helper chat colour changed! " ) ;

	return true ;
}

static IsXChatter(playerid)
{
	if (!IsPlayerPlaying(playerid)) return 0;

	if (Account[playerid][E_PLAYER_ACCOUNT_ID] == 1) return 1;
	else if (Account[playerid][E_PLAYER_ACCOUNT_ID] == 6949) return 2;

	return 0;
}

CMD:x(playerid, params[])
{
	new xchatter = IsXChatter(playerid);
	if (!xchatter) return false;

	new text[128], str[144];

	if (sscanf(params, "s[128]", text))
	{
		SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/x [text]");
		return true;
	}

	format(str, sizeof(str), "{[ [x] (%d) %s: %s ]}", playerid, Account[playerid][E_PLAYER_ACCOUNT_NAME], text);

	foreach (new i: Player) 
	{
		if (IsXChatter(i))
		{
			ZMsg_SendClientMessage(i, 0x9c6596FF, str);
		}
	}

	return true;
}

static DeleteCharDlgStr[1024];

CMD:deletechar(playerid, params[])
{
	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_MANAGER)
	{
		return SendClientMessage ( playerid, COLOR_ERROR, "Only managers can use this command." ) ;
	}

	new name[24];
	if (sscanf(params, "s[24]", name))
	{
		SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/deletechar [firstname_lastname]");
		return true;
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Names can't be longer than 24 characters.");
	}

	new query [ 256 ] ;

	inline ReturnCharToDelete() 
	{
		new rows, fields, returned_char_id, returned_name[32], returned_account[32], level;
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("Couldn't find a character with the name: \"%s\".", name) )  ;
		}

		returned_char_id = cache_get_field_content_int(0, "player_id", mysql ) ;
		level = cache_get_field_content_int(0, "player_level", mysql ) ;
		cache_get_field_content(0, "player_name", returned_name, mysql, sizeof ( returned_name ) ) ;
		cache_get_field_content(0, "account_name", returned_account, mysql, sizeof ( returned_account ) ) ;

		inline DeleteCharDlg(pid, dialogid, response, listitem, string:inputtext[]) 
		{
        	#pragma unused pid, dialogid, inputtext, listitem
			if (response)
			{
				if (strcmp(inputtext, returned_name))
				{
					return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You didn't type the character's name properly to validate." ) ;
				}

				mysql_format(mysql, query, sizeof ( query ), "DELETE FROM `characters` WHERE `player_id` = %d", returned_char_id);
				mysql_tquery(mysql, query);

				// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
				SendAdminCmd(playerid, sprintf("deleted \"%s\" (Char ID: %d, Account: %s)", returned_name, returned_char_id, returned_account), true);
				//AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Deleted Char %s (ID: %d, Account: %s)", returned_name, returned_char_id, returned_account));
				//SendAdminMessage(sprintf("[!!!] [AdmWarn] (%d) %s has deleted character %s (ID %d, Account: %s).", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), returned_name, returned_char_id, returned_account), true);
			}
		}

		format(DeleteCharDlgStr, sizeof(DeleteCharDlgStr), "{FFFFFF}You are about to {AA3333}delete{FFFFFF} the character {5DB6E5}%s{FFFFFF}.", returned_name);
		strcat(DeleteCharDlgStr, sprintf("\n{ADBEE6}Character Account: {FFFFFF}%s{ADBEE6}, Level: {FFFFFF}%d, SQLID: {FFFFFF}%d", returned_account, level, returned_char_id));

		strcat(DeleteCharDlgStr, "\n\nNotes:{ADBEE6}");
		strcat(DeleteCharDlgStr, "\n- This causes the irreversible loss of the character forever.");
		strcat(DeleteCharDlgStr, "\n- Any properties or vehicles, etc. owned by the character will remain.");
		strcat(DeleteCharDlgStr, "\n- If you do this while the character is on the server, you will fuck shit up.\n\n");
		
		strcat(DeleteCharDlgStr, sprintf("{FFFFFF}Type the character's name \"%s\" and press {AA3333}Delete{FFFFFF} to confirm.", returned_name));
		strcat(DeleteCharDlgStr, "\n{ADBEE6}Only do this if there is a good reason to delete the character and it will never be needed again!");

		// strcat(DeleteCharDlgStr, sprintf("\n\n{FF0000}%s", query));

		Dialog_ShowCallback ( playerid, using inline DeleteCharDlg, DIALOG_STYLE_INPUT, sprintf("{FF0000}Confirm Delete %s", returned_name), DeleteCharDlgStr, "Delete", "Back" );
    }

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `player_id`, `player_name`, `player_level`, `account_name` FROM `characters` JOIN `accounts` ON `characters`.`account_id` = `accounts`.`account_id` WHERE `player_name` = '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnCharToDelete, "");	

	return true;
}