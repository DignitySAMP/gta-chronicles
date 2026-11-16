#warning Hook OnPlayerText for calls (here and in payphones). Completely remove phone code from the "chat" OnPlayerText. Simply check "IsPlayerCalling" there.


CMD:phone(playerid, params[]) {

	new option [ 32 ] ;

	if ( sscanf ( params, "s[32]", option ) ) {

		return SendClientMessage(playerid, -1, "/phone [info, contacts, history, pass]");
	}

	if(!strcmp(option, "info", true)) {
		
	}
	else if(!strcmp(option, "contacts", true)) {
		
   		Contacts_ViewEntries(playerid);
	}
	else if(!strcmp(option, "history", true)) {
		PhoneLog_ViewEntries(playerid);
	}
	else if(!strcmp(option, "pass", true)) {
		
	}

	else return  SendClientMessage(playerid, -1, "/phone [info, contacts, history, pass]");

	return true ;
}
