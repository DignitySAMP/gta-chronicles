
static StartPlayerCall(playerid, number, from_number = 0)
{
	PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] = Character[playerid][E_CHARACTER_PHONE_NUMBER];
	if (from_number) PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] = from_number;

	if ( ! PlayerVar [ playerid ] [ player_viewphone ]  ) 
	{
		cmd_ph(playerid, "");
	}

	if (number >= 1)
	{
		if (number == 911 || number == 666 || number == 311 || number == 726 || number == 732 || number == 111)
		{
			Phone_OnPlayerCallStaticNumber(playerid, number);
			return 1;
		}

		foreach(new target: Player) 
		{
			if ( Character [ target ] [ E_CHARACTER_PHONE_NUMBER ] == number ) 
			{
				Phone_OnPlayerReceiveAlert(target, playerid, PHONE_ALERT_CALL ) ;
				return 1;
			} 
		}
	}

	return 0;
}

CMD:fcall(playerid, params[])
{
	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) 
	{
		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You don't have a phone! Head to an electronics store to buy one!" ) ;
		return true ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) 
	{
		return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your phone is turned off!" ) ;
	}

	new number;
	if ( sscanf ( params, "d", number ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/fcall [number]" ) ;
	}

	new from = 0;

	if (IsPlayerInPoliceFaction(playerid, true) || IsPlayerInMedicFaction(playerid, true)) from = 911;
	else if (IsPlayerInNewsFaction(playerid, true)) from = 726;
	else if (IsPlayerInGovFaction(playerid, true)) from = 311;
	else if (IsPlayerInSecurityFaction(playerid, true)) from = 732;
	else if (IsPlayerInTaxiFaction(playerid, true)) from = 111;

	if (!from)
	{
		return SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You're not on duty in a faction which can make telephone calls.");
	}

	if (StartPlayerCall(playerid, number, from))
	{
		// Good, do nothing
	}
	else
	{	
		SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", number));
	}

	return true;
}

CMD:call(playerid, params[]) 
{
	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) 
	{
		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You don't have a phone! Head to an electronics store to buy one!" ) ;
		return true ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) 
	{
		return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your phone is turned off!" ) ;
	}

	new input[64];
	if (sscanf(params, "s[64]", input)) 
	{
		SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/call [number]");
		SendServerMessage(playerid, COLOR_ERROR, "City Services", "A3A3A3", "Emergency: 911, Non-Emergency: 311");
		return SendServerMessage(playerid, COLOR_ERROR, "Hotlines", "A3A3A3", "SAN: 726, Chuff Security: 732, Taxi: 111");
	}

	if ( IsNumeric ( input ) ) 
	{
		new number = strval ( input ) ;

		if ( number == Character[playerid][E_CHARACTER_PHONE_NUMBER] )
		{
			return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", number));
		}

		if (StartPlayerCall(playerid, number, Character[playerid][E_CHARACTER_PHONE_NUMBER]))
		{
			// Good, do nothing
		}
		else
		{	
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", number));
		}
	}

	else if ( ! IsNumeric ( input ) ) 
	{
		//Phone_ViewPhonebook_SQL(playerid,.view=false);
		PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] = Character[playerid][E_CHARACTER_PHONE_NUMBER];
		CallRemoteNumberFromPhonebook(playerid, input);
	}

	
	return true ;
}

CMD:h(playerid) {

	return cmd_hangup(playerid);
}

CMD:hangup(playerid) {
	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] ) {

		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You've hung up. Your recipient hasn't received your message!" ) ;
	}

	PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] <= 0  && PlayerVar [ playerid ] [ player_phonecalling ] == INVALID_PLAYER_ID ) {
		for_loop(new i, j = 3; i < j ; i ++ ) {

			PlayerTextDrawHide(playerid, ptd_ph_popup[playerid][i]);
		}
	}

	else {

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = true ;
	}

	return true ;
}

CMD:pickup(playerid) {

	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] || ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) {
		return true ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] != 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = true ;
	}

	else if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] == 0 ) {

		if ( PlayerVar [ playerid ] [ player_phonecalling ] == INVALID_PLAYER_ID ) {

			Phone_ViewDialMenu ( playerid ) ;
		}

		else SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You're already in a call with someone." ) ;
	}

	else SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Make sure to cancel the alert in your phone before continuing." ) ;

	return true ;
}

CMD:p(playerid) { 
	return cmd_pickup(playerid);
}

CMD:phlow(playerid, params[])
{
	new text[128], string[144];

	if (sscanf(params, "s[128]", text))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/phlow [text]" ) ;
	}

	new targetid = PlayerVar [ playerid ] [ player_phonecalling ];

	if (targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid))
	{
		format(string, sizeof(string), "%s says (phone) [low]: %s", SOLS_PlayerName(playerid), text);
		ZMsg_SendClientMessage(targetid, COLOR_YELLOW, string);
		ProxDetectorNameTag(playerid, 5.0, 0xDEDEDEFF, text, " says (phone) [low]:", 0, true, false);
		return true;
	}

	return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Error", "A3A3A3", "You're not on a call with another player." ) ;
}

CMD:sms(playerid, params[]) {

	if ( ! Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) {

		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You don't have a phone! Head to an electronics store to buy one!" ) ;

		return true ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] ) {

		return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your phone is turned off!" ) ;
	}

	new sms_target[16], sms_text [ 128 ], count = 0 ;

	if ( sscanf ( params, "s[16] s[128]", sms_target, sms_text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/sms [recipient] [text]" ) ;
	}
	
	if ( strlen ( sms_text ) < 3 || strlen ( sms_text ) > 64 ) 
	{
		return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your SMS text can't be less than 3 or more than 64 characters." ) ;
	}

	PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] = Character [playerid][E_CHARACTER_PHONE_NUMBER];

	if ( ! IsNumeric ( sms_target ) ) 
	{
		SMSRemoteNumberFromPhonebook(playerid, sms_target, sms_text);
		return true;
	}

	new number = strval ( sms_target ) ;

	if ( number < 1 || number == Character[playerid][E_CHARACTER_PHONE_NUMBER] ) {
		return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", number)) ;
	}

	if (number == 726)
	{
		// SAN Hotline, new.
		if (PlayerVar [ playerid ] [ E_PLAYER_HOTLINE_COOLDOWN ] && (gettime() - PlayerVar [ playerid ] [ E_PLAYER_HOTLINE_COOLDOWN ]) < 60)
		{
			return SendServerMessage ( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("You must wait %d seconds before sending another message to the hotline.", 60 - (gettime() - PlayerVar [ playerid ] [ E_PLAYER_HOTLINE_COOLDOWN ])) ) ;
		}

		foreach(new i: Player) 
		{
			if (IsPlayerInNewsFaction(i, true))
			{
				SendClientMessage(i, COLOR_FACTION, sprintf("[Received SAN (7-2-6) Hotline SMS]: From %d", Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) ) ;
				ZMsg_SendClientMessage(i, COLOR_FACTION, sprintf("[SMS Message]: %s", sms_text ) ) ;
			}
		}

		ProxDetectorAutoMe(playerid, 20.0, "sends a message on their phone.");
		SendClientMessage(playerid, COLOR_FACTION, sprintf("[SMS] to SAN (726): %s", sms_text));

		PlayerVar [ playerid ] [ E_PLAYER_HOTLINE_COOLDOWN ] = gettime();
		return true;
	}

	foreach(new target: Player) 
	{
		if ( Character [ target ] [ E_CHARACTER_PHONE_NUMBER ] == number ) 
		{
			ProxDetectorAutoMe(playerid, 20.0, "sends a message on their phone.");
			SendClientMessage(playerid, 0xDEC61FFF, sprintf("[SMS] to %d: %s", number, sms_text));
			SMS_SendMessage(target, playerid, sms_text ) ;
			Phone_OnPlayerReceiveAlert(target, playerid, PHONE_ALERT_SMS ) ;
			count ++ ;
			break ;
		} 
		else continue ;
	}

	if ( ! count ) 
	{
		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", number)) ;
		return true ;
	}

	return true ;
}

Phone_ViewDialMenu ( playerid ) {
	inline phone_phbook_menu(pid, dialogid, response, listitem, string: inputtext[]) {
 		#pragma unused pid, dialogid, response, listitem, inputtext

		switch ( listitem ) {

			case 0: { // call number

				if ( response ) 
				{
				
					/*
					inline phone_enter_dial(pidx, dialogidx, responsex, listitemx, string: inputtextx[]) {
 						#pragma unused pidx, dialogidx, responsex, listitemx, inputtextx

						if ( ! responsex ) {
							Phone_ViewDialMenu ( playerid ) ;
							return true ;
						}

						if ( responsex ) {

							if ( ! CheckInputtextCrash ( playerid, inputtextx )) {

								return true ;
							}		

							new number = strval(inputtextx ) ;

							if ( Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] == number ) {

								return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You can't call yourself, dummy!") ;
							}

							if ( strlen ( inputtextx ) <= 1 || strval ( inputtextx) == 0 ) {

								return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You've entered an invalid number!") ;
							}

							switch ( number ) {

								case 911, 666: {

									Phone_OnPlayerCallStaticNumber(playerid, number);
								}
								
								default: {
									new count ;

									foreach(new target: Player) {
										if ( GetPlayerState ( playerid ) == PLAYER_STATE_SPECTATING ) {

											continue ;
										}
										
										if ( Character [ target ] [ E_CHARACTER_PHONE_NUMBER ] == number ) {

											Phone_OnPlayerReceiveAlert(target, playerid, PHONE_ALERT_CALL ) ;
											count ++ ;
											break ;
										} 
										else continue ;
									}

									if ( ! count ) {
										SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number \"%d\" can't be reached.", strval(inputtextx))) ;
										return true ;
									}
								}
							}
						}
					}

					Dialog_ShowCallback ( playerid, using inline phone_enter_dial, DIALOG_STYLE_INPUT, sprintf("{DEDEDE}Phonebook [{5CC44F}Credit: %d{DEDEDE}]", Character [ playerid ] [ E_CHARACTER_PHONE_CREDIT ]), "Enter the number of the person you want to call.", "Proceed", "Back" ) ;
				}
				*/

					return SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Sorry, you need to use /call instead now.");
				}
			}


			case 1: 
			{
				if ( response ) {
					SMS_DisplayMenu(playerid) ;	
				}
			}

			case 2: { // add contact
				Phone_Phonebook_Add ( playerid ) ;
			}

			case 3: { // view phonebook

				if ( response ) {
					Phone_ViewPhonebook_SQL ( playerid ) ;
				}
			}
		}
	}
	Dialog_ShowCallback ( playerid, using inline phone_phbook_menu, DIALOG_STYLE_LIST, sprintf("{DEDEDE}Phonebook [{5CC44F}Credit: %d{DEDEDE}]", Character [ playerid ] [ E_CHARACTER_PHONE_CREDIT ]), "Dial Number\nSend Message\nAdd Contact\nPhonebook", "Proceed", "Close" ) ;

	return true ;
}
