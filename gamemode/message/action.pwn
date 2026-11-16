static SendPlayerMeAction(playerid, text[128], bool:islow=false)
{

    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) {

    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }

	ProxDetectorNameTag(playerid, islow ? 15.0 : 30.0, islow ? COLOR_ACTION_LOW : COLOR_ACTION, text, "", 1,  .customcolor=false, .invert_action=false, .low=islow ) ;
	return true ;
}

static SendPlayerDoAction(playerid, text[128], bool:islow=false)
{

    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) {

    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }

	ProxDetectorNameTag(playerid, islow ? 15.0 : 30.0, islow ? COLOR_ACTION_LOW : COLOR_ACTION, text, "", 1, .customcolor=false, .invert_action=true, .low=islow ) ;
	return true ;
}

CMD:me(playerid, params[]) {

	new text[128], bool:quiet = Character[playerid][E_CHARACTER_ARREST_TIME] > 0;

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/me [text]" ) ;
	}

	SendPlayerMeAction(playerid, text, quiet);
	return true ;
}

CMD:melow(playerid, params[]) {

	new text[128];

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/melow [text]" ) ;
	}

	SendPlayerMeAction(playerid, text, true);
	return true ;
}

CMD:mel(playerid, params[]) 
{
	return cmd_melow(playerid, params);
}

CMD:do(playerid, params[]) {

	new text[128], bool:quiet = Character[playerid][E_CHARACTER_ARREST_TIME] > 0;

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/do [text]" ) ;
	}

	SendPlayerDoAction(playerid, text, quiet);
	return true ;
}

CMD:ado(playerid, params[])
{
	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float:radius, text[128], string[144];
	if ( sscanf ( params, "fs[128]", radius, text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/ado [radius] [text]" ) ;
	}

	format(string, sizeof(string), "* %s", text);
	ProxDetector(playerid, radius, COLOR_PURPLE, string);
	return true;
}

CMD:dolow(playerid, params[]) {

	new text[128];

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/dolow [text]" ) ;
	}

	SendPlayerDoAction(playerid, text, true);
	return true ;
}

CMD:dol(playerid, params[]) 
{
	return cmd_dolow(playerid, params);
}

/*

CMD:my(playerid, params[]) {

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/my [text]" ) ;
	}

    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) {

    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }
    
    ProxDetectorNameTag(playerid, 30.0, COLOR_ACTION, text, "'s", 1, .customcolor=false, .invert_action=false ) ;

	//WriteLog ( playerid, "chat/local", string );
	return true ;
}

CMD:mylow(playerid, params[]) {

	new text [ 128 ] ;

	if ( sscanf ( params, "s[128]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/mylow [text]" ) ;
	}

    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) {

    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }
    
    ProxDetectorNameTag(playerid, 15.0, COLOR_ACTION, text, "'s", 1, .customcolor=false, .invert_action=false ) ;

	//WriteLog ( playerid, "chat/local", string );
	return true ;
}

CMD:myl(playerid, params[]) 
{
	return cmd_mylow(playerid, params);
}

*/

/*
CMD:attempt(playerid, params[]) {

	new text [ 144 ], string [256] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/attempt [text]" ) ;
		return SendClientMessage(playerid, COLOR_YELLOW, "Will return: \"{ff6347}NAME{FFFF00} attempts to {ff6347}INPUT{FFFF00} and succeeds/fails\".");
	}

	switch ( random ( 100 ) ) {
		case 0 .. 50:  format ( string, sizeof ( string ), "attempts to %s and succeeds.", text ) ;
		default: {
			format ( string, sizeof ( string ), "attempts to %s and fails.", text ) ;
		}
	}

    ProxDetectorNameTag(playerid, 20.0, COLOR_ACTION, string, "", 1,  .customcolor=false, .invert_action=false ) ;

	return true ;
}
*/
