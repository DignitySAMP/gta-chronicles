CMD:ame(playerid, params[]) 
{
	new text [ 128 ];

	if ( sscanf ( params, "s[128]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/ame [text]" ) ;
	}
	
	/*
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
	*/

	SetPlayerChatBubble(playerid, sprintf("* %s %s", ReturnPlayerNameData(playerid, 0, true), text), COLOR_ACTION, 20.0, 3000 + (strlen(text) * 100));
	SendClientMessage(playerid, COLOR_ACTION, sprintf("> * %s %s", ReturnPlayerNameData(playerid, 0, true), text));

	// NEW LOGGING: Log this as a LOG_TYPE_ACTION for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_ACTION, sprintf("> * %s", text));
	return true ;
}

CMD:amy(playerid, params[]) 
{
	new text[128], str[144];

	if ( sscanf ( params, "s[128]", text ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/amy [text]" ) ;
	}
	
	format(str, sizeof(str), "* %s's %s", SOLS_PlayerName(playerid), text);

	SetPlayerChatBubble(playerid, str, COLOR_ACTION, 20.0, 3000 + (strlen(text) * 100));
	AddLogEntry(playerid, LOG_TYPE_ACTION, str);
	SendClientMessage(playerid, COLOR_ACTION, sprintf("> %s", str));

	// NEW LOGGING: Log this as a LOG_TYPE_ACTION for sender (playerid)
	
	return true ;
}