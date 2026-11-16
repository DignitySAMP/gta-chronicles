static SendPlayerLocalOOC(playerid, text[128], bool:islow=false, vehicleid=0)
{
    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) 
	{
    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }

	new string[144];

	if (vehicleid <= 0)
	{
		if (islow)
		{
			if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) format ( string, sizeof ( string ), "(( (%d) {E9971B}%s{A3A3A3} [low]: %s ))",  playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text );
			else if (PlayerVar[playerid][E_PLAYER_IS_MASKED]) format ( string, sizeof ( string ), "(( (%d) %s [low]: %s ))", Character[playerid][E_CHARACTER_MASKID], SOLS_PlayerName(playerid), text ); 
			else format ( string, sizeof ( string ), "(( (%d) %s [low]: %s ))", playerid, SOLS_PlayerName(playerid), text ) ;
		}
		else
		{
			if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) format ( string, sizeof ( string ), "(( (%d) {E9971B}%s{A3A3A3}: %s ))",  playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text );
			else if (PlayerVar[playerid][E_PLAYER_IS_MASKED]) format ( string, sizeof ( string ), "(( (%d) %s: %s ))", Character[playerid][E_CHARACTER_MASKID], SOLS_PlayerName(playerid), text ); 
			else format ( string, sizeof ( string ), "(( (%d) %s: %s ))", playerid, SOLS_PlayerName(playerid), text ) ;
		}

		ProxDetector(playerid, islow ? 10.0 : 20.0, 0xA3A3A3FF, string);
		AddLogEntry(playerid, LOG_TYPE_OOC, sprintf("(( %s ))", text));
	}
	else
	{
		if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) format ( string, sizeof ( string ), "(( [%s] (%d) {E9971B}%s{A3A3A3}: %s ))", ReturnVehicleName(vehicleid), playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), text );
		else if (PlayerVar[playerid][E_PLAYER_IS_MASKED]) format ( string, sizeof ( string ), "(( [%s] (%d) %s: %s ))", ReturnVehicleName(vehicleid), Character[playerid][E_CHARACTER_MASKID], SOLS_PlayerName(playerid), text ); 
		else format ( string, sizeof ( string ), "(( [%s] (%d) %s: %s ))", ReturnVehicleName(vehicleid), playerid, SOLS_PlayerName(playerid), text ) ;

		foreach(new targetid: Player) 
		{
			if (GetPlayerVehicleID(targetid) == vehicleid)
			{
				ZMsg_SendClientMessage ( targetid, 0xA3A3A3FF, string);
			}
		}

		AddLogEntry(playerid, LOG_TYPE_OOC, sprintf("(( [CAR] %s ))", text));
	}

	return true ;
}

CMD:b(playerid, params[]) {

	new text[128], bool:quiet = Character[playerid][E_CHARACTER_ARREST_TIME] > 0;

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/b [text]" ) ;
	}

	SendPlayerLocalOOC(playerid, text, quiet);
	return true;
}

CMD:blow(playerid, params[]) {

	new text[128];

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/blow [text]" ) ;
	}

	SendPlayerLocalOOC(playerid, text, true);
	return true ;
}

CMD:bl(playerid, params[])
{
	return cmd_blow(playerid, params);
}

CMD:carb(playerid, params[]) {

	new text[128];

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/carb [text]" ) ;
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	if (!vehicleid || !IsPlayerInAnyVehicle(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be in a vehicle to use this chat.");
	}

	SendPlayerLocalOOC(playerid, text, false, vehicleid);
	return true ;
}

CMD:cb(playerid, params[])
{
	return cmd_carb(playerid, params);
}

CMD:toggleooc(playerid) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_JUNIOR ) {

		return false ;
	}

	new string [ 256 ] ;

	if ( ! Server [ E_SERVER_OOC_ENABLED ] ) {

		format ( string, sizeof ( string ), "[AdmCmd] %s has enabled the /ooc chat.", ReturnPlayerNameData ( playerid )) ;
		Server [ E_SERVER_OOC_ENABLED ] = true ;
	}

	else if ( Server [ E_SERVER_OOC_ENABLED ] ) {

		format ( string, sizeof ( string ), "[AdmCmd] %s has disabled the /ooc chat.", ReturnPlayerNameData ( playerid )) ;
		Server [ E_SERVER_OOC_ENABLED ] = false ;
	}

	SendClientMessageToAll(COLOR_STAFF, string) ;
	WriteLog ( playerid, "chat/ooc", string );

	return true ;
}

CMD:ooc(playerid, params[]) {

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/ooc [text]" ) ;
	}

	if ( ! Server [ E_SERVER_OOC_ENABLED ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "OOC is currently disabled." ) ;
	}
	
	new string [ 256 ] ;

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] <= ADMIN_LVL_NONE ) {
		format ( string, sizeof ( string ), "(( [GLOBAL] (%d) %s: %s ))",  playerid, ReturnPlayerNameData ( playerid ), text ) ;
	}
	else format ( string, sizeof ( string ), "(( [GLOBAL] (%d) {E9971B}%s{AAC4E5}: %s ))",  playerid, ReturnPlayerNameData ( playerid ), text ) ;

	foreach(new targetid: Player) {

		if ( ! PlayerVar [ targetid ] [ E_PLAYER_HIDING_OOC ] ) {
			ZMsg_SendClientMessage ( targetid, COLOR_OOC, string);
		}

		else continue ;
	}

	WriteLog ( playerid, "chat/ooc", string );
	SendAdminListen(playerid, string) ;
	return true ;
}

CMD:o(playerid, params[]) {

	return cmd_ooc(playerid, params);
}

CMD:aooc(playerid, params[]) {
	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_GENERAL ) {

		return SendServerMessage( playerid, COLOR_RED, "Warning", "A3A3A3",  "You need to be a general administrator + in order to be able to do this!" );
	}

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/aooc [text]" ) ;
	}

	
	new string [ 256 ] ;

	format ( string, sizeof ( string ), "(( [AOOC] (%d) %s: %s ))",  playerid, ReturnPlayerNameData ( playerid ), text ) ;

	foreach(new targetid: Player) {

		ZMsg_SendClientMessage ( targetid, COLOR_STAFF, string);
	}

	WriteLog ( playerid, "chat/ooc", string );
	return true ;
}

PMSpamBan(playerid)
{
	new hours = 99999; // 10 years
    new secs = hours * 3600 ;
    new unbants = gettime() + secs;
	new reason [ 64 ], string[300];

	format ( string, sizeof ( string ), "[AntiCheat]: (%d) %s has been banned for PM spamming.", playerid, ReturnPlayerNameData ( playerid )  ) ;
	SendAdminWarning(string, true) ;

	format ( reason, sizeof ( reason ), "Anticheat Detection: PM Spamming" ) ;
	SetAdminRecord ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], -1337, ARECORD_TYPE_BAN, reason, -1, ReturnDateTime () ) ;
	
	mysql_format(mysql, string, sizeof(string), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
	Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], ReturnIP ( playerid ), "Anticheat", reason, gettime(), unbants);
	mysql_tquery(mysql, string);

	format ( string, sizeof ( string ),"banip %s", ReturnIP ( playerid ));
	SendRconCommand(string);

	Kick(playerid);
}

static SendPlayerPM(playerid, targetid, text[])
{
	new userid = targetid;
	new string[256];

	GameTextForPlayer(userid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
	PlayerPlaySound(userid, 1085, 0.0, 0.0, 0.0);

	if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
	{
		format ( string, sizeof ( string ), "(( PM from {E9971B}%s (%d):{FFCC22} %s ))", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid, text )  ;
		ZMsg_SendClientMessage(userid, 0xFFCC2299, string);
	}
	else
	{
		format ( string, sizeof ( string ), "(( PM from %s (%d): %s ))", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), playerid, text )  ;
		ZMsg_SendClientMessage(userid, 0xFFCC2299, string);
	}

	if (PlayerVar[userid][E_PLAYER_ADMIN_DUTY])
	{
		format ( string, sizeof ( string ), "(( PM to {E9971B}%s (%d):{FFFF22} %s ))", SOLS_PlayerName(userid, PLAYER_NAME_STYLE_ACCOUNT), userid, text )  ;
		ZMsg_SendClientMessage(playerid, 0xFFFF22AA, string ); 
	}
	else
	{
		format ( string, sizeof ( string ), "(( PM to %s (%d): %s ))", SOLS_PlayerName(userid, PLAYER_NAME_STYLE_CHARACTER), userid, text )  ;
		ZMsg_SendClientMessage(playerid, 0xFFFF22AA, string ); 
	}

	PlayerVar [ userid ] [ E_PLAYER_LAST_PM_SENDER ] = playerid;
	AddLogEntry(playerid, LOG_TYPE_PM, string);

	format ( string, sizeof ( string ), "[PM] %s sends to %s: %s", ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( userid ), text)  ;
	SendAdminListen(playerid, string);
}

CMD:replypm(playerid, params[])
{
	new text[128];

	if (sscanf(params, "s[128]", text)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/replypm [text]" ) ;
	}

	new recipient = PlayerVar [ playerid ] [ E_PLAYER_LAST_PM_SENDER ];

	if (recipient == INVALID_PLAYER_ID)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Couldn't find a valid message or sender to reply to." );
	}

	if ( PlayerVar [ recipient ] [ E_PLAYER_PM_BLOCKED ] && ! GetPlayerAdminLevel(playerid) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The person you are trying to message is blocking their private messages." ) ;
	}

	SendPlayerPM(playerid, PlayerVar [ playerid ] [ E_PLAYER_LAST_PM_SENDER ], text);
	return true;	
}

CMD:rpm(playerid, params[])
{
	return cmd_replypm(playerid, params);
}

CMD:pm(playerid, params[]) 
{
	new userid, text[144];

	if (sscanf(params, "k<unmaskedplayer>s[128]", userid, text)) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/pm [id] [text]" ) ;
	}

	if (!IsPlayerConnected ( userid ) || !IsPlayerLogged(userid) || !IsPlayerPlaying(userid)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player isn't connected." ) ;
	}

	if (!IsPlayerPlaying(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must spawn as a character first." ) ;
	}

	if (userid == playerid){

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't PM yourself." ) ;
	}

	if ( PlayerVar [ userid ] [ E_PLAYER_PM_BLOCKED ] && ! GetPlayerAdminLevel(playerid) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The person you are trying to message is blocking their private messages." ) ;
	}

	if (PlayerVar[playerid][E_PLAYER_LAST_PM_SENT_AT])
	{
		if (gettime() == PlayerVar[playerid][E_PLAYER_LAST_PM_SENT_AT])
		{
			new isnewb = CanPlayerUseGuns(playerid, 2);
			if (!isnewb)
			{
				format(text, 64, "%s", text);
				SendAdminWarning(sprintf("[AdmWarn] (%d) %s might be PM spamming: %s", playerid, ReturnPlayerNameData(playerid), text));
				PlayerVar[playerid][E_PLAYER_LAST_PM_SENT_AT] = gettime();
				PlayerVar[playerid][E_PLAYER_PM_SPAM_COUNT] ++;

				if (PlayerVar[playerid][E_PLAYER_PM_SPAM_COUNT] >= 3)
				{
					PMSpamBan(playerid);
				}
			}

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Stop spamming and wait before sending another PM." ) ;
		}
	}

	PlayerVar[playerid][E_PLAYER_PM_SPAM_COUNT] = 0;
	PlayerVar[playerid][E_PLAYER_LAST_PM_SENT_AT] = gettime();

	if ( IsPlayerPaused ( userid ) ) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The player you are messaging is AFK. Use /afklist." ) ;
	}

	SendPlayerPM(playerid, userid, text);
	return true;
}

CMD:blockpms ( playerid, params [] ) {

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ]  = true ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Info", "A3A3A3", "You are now blocking your private messages!" ) ;
	}

	else if ( PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ]  = false ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Info", "A3A3A3", "You have unblocked your private messages!" ) ;
	}

	return true ;
}

CMD:blockpm(playerid, params[]) 
{
	return cmd_blockpms(playerid, params);
}