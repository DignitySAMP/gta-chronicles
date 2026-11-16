
timer Phone_ConnectPlayer[1000](playerid, fromplayerid) {

	if ( ! IsPlayerConnected ( playerid ) || ! IsPlayerConnected ( fromplayerid ) || PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] || PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] ) {

		PlayerVar [ playerid ] [ player_phonecalling ] = INVALID_PLAYER_ID ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		PlayerVar [ fromplayerid ] [ player_phonecalling ] = INVALID_PLAYER_ID ;
		PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
		PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(fromplayerid, 0, 0.0, 0.0, 0.0);

		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The line died down." ) ;
		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The line died down." ) ;


		ApplyAnimation(fromplayerid,"PED", "phone_out", 4.1, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid,"PED", "phone_out", 4.1, 0, 0, 0, 0, 0);

		PlayerTextDrawHide(fromplayerid, ptd_ph_design[playerid] [ 9 ] ) ;
		PlayerTextDrawColor(fromplayerid, ptd_ph_design[playerid][9], 0xFFFFFFFF);

		if ( PlayerVar [ fromplayerid ] [ player_viewphone ] ) {
			PlayerTextDrawShow(fromplayerid, ptd_ph_design[playerid] [ 9 ] ) ;
		}

		PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ 9 ] ) ;
		PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], 0xFFFFFFFF);

		if (  PlayerVar [ playerid ] [ player_viewphone ] ) {
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ 9 ] ) ;
		}

		for_loop(new i, j = 3 ; i < j ; i ++ ) {
			PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ i ] ) ;
			PlayerTextDrawHide(fromplayerid, ptd_ph_popup[playerid] [ i ] ) ;
		}

		return true ;
	}

	defer Phone_ConnectPlayer(playerid, fromplayerid);
	return true ;

}

static const DispatcherNames[11][16] = {"Monica", "Jacqueline", "Janette", "Kaitlin", "Shenelle", "Brandi", "Rosalia", "Carlos", "Andrea", "Jason", "Marcus" };

Phone_OnPlayerCallStaticNumber(playerid, number) {

	// !!!!!!!!!!!!! THIS MAKES THE PHONE POP UP INCASE HIDDEN SO THERE'S NO OVERLAP !!!!!!!!!!!!!
	if ( !PlayerVar [ playerid ] [ player_viewphone ] ) {
			
		for_loop ( new i = 5, j = 13; i < j ; i ++ ) {

			PlayerTextDrawShow(playerid, ptd_ph_design[playerid][i]);
		}

		cmd_phone(playerid,"");
	}

	cmd_phanim(playerid);
	SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "To cancel animation, do /sa. To re-do it, use /ph(one)anim." ) ;


	PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = number ;

	PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "Requesting Connection");
	PlayerTextDrawColor(playerid, ptd_ph_popup[playerid][1], PHONE_COLOUR_OK);

	PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 2 ], sprintf("%d", PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ]));

	for_loop(new i, j = 3 ; i < j ; i ++ ) {
		PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ i ] ) ;
		PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ i ] ) ;
	}


	switch ( number ) {

		case 726: // SAN
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): San Andreas Network hotline, Karen speaking.  Can I take a message?");
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Type your message now.") ;
		}

		case 111: // TAXI
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Taxi Dispatcher says (phone): Where do you need us to send a cab and what's your destination?");
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Type your reply now.") ;
		}

		case 732: // SEC
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): Chuff Security Headquarters, Ken speaking.  Can I take a message?");
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Type your message now.") ;
		}

		case 311:
		{
			new dispatcher = random(sizeof(DispatcherNames));
			SendClientMessage(playerid, COLOR_YELLOW, sprintf("Line Operator says (phone): 3-1-1 Non Emergency, %s speaking.  Which department is your call for?", DispatcherNames[dispatcher]));
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Type \"Police\", \"Fire\" or \"City Services\".") ;
		}

		case 911: {
			new dispatcher = random(sizeof(DispatcherNames));
			SendClientMessage(playerid, COLOR_YELLOW, sprintf("Line Operator says (phone): 9-1-1 Emergency, %s speaking.  Which emergency service do you require?", DispatcherNames[dispatcher]));
			SendServerMessage(playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Type \"Police\", \"Fire\" or \"Medical\".") ;
		}

		case 666: {
			SendClientMessage(playerid, COLOR_YELLOW, "A voice says (phone): Hello, welcome to the V-Rock hotel in Las Venturas, how may I assist you?");
		}

		default: {

			SendClientMessage(playerid, COLOR_ERROR, "You've tried to dial a static number however it failed to connect.");

			for_loop(new i, j = 3 ; i < j ; i ++ ) {
				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ i ] ) ;
			}	


			PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;	
		}
	}




	return true ;
}


Phone_OnPlayerReceiveAlert(playerid, fromplayerid, type) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] ) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You can't reach the recipient." ) ;

		return true ;
	}

	/*
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_SPECTATING && type == PHONE_ALERT_CALL) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The number you're trying to call is currently occupied. Try again later." ) ;

		return true ;
	}
	*/

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] ) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The number you're trying to call is currently occupied. Try again later." ) ;

		return true ;
	}

	if ( PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID ) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The number you're trying to call is currently occupied. Try again later." ) ;

		return true ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] || !IsPlayerConnected(playerid) ) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You can't reach the recipient." ) ;

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		return true ;
	}

	if (!PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER])
	{
		PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER] = Character[fromplayerid][E_CHARACTER_PHONE_NUMBER];
	}

	PlayerVar[playerid][E_PLAYER_PHONE_MISSED_CALL_NR] = PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER];


	// !!!!!!!!!!!!! THIS MAKES THE PHONE POP UP INCASE HIDDEN SO THERE'S NO OVERLAP !!!!!!!!!!!!!
	if ( !PlayerVar [ playerid ] [ player_viewphone ] && GetPlayerState ( playerid ) != PLAYER_STATE_SPECTATING ) 
	{		
		Phone_ForceShowPhone(playerid);
	}

	if ( !PlayerVar [ fromplayerid ] [ player_viewphone ] ) {
		
		Phone_ForceShowPhone(fromplayerid);
	}
	// !!!!!!!!!!!!! THIS MAKES THE PHONE POP UP INCASE HIDDEN SO THERE'S NO OVERLAP !!!!!!!!!!!!!

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] != 0 ) {
		// Player is already calling the timer for alerts. Let's not make it overflow.

		switch ( type ) {

			case PHONE_ALERT_SMS: {
				PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ 8 ] ) ;
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);
				PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ 8 ] ) ;

				SendServerMessage( playerid, PHONE_COLOUR_MED, "Phone", "A3A3A3", "You've received a text message whilst your phone was ringing." ) ;
			}

			case PHONE_ALERT_CALL: 	{

				SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The number you're trying to call is currently occupied. Try again later." ) ;
			}
		}

		return true ;	
	}

	switch ( type ) {

		case PHONE_ALERT_SMS: 	{
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 10 ;
			PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "New Text Message");
			PlayerTextDrawColor(playerid, ptd_ph_popup[playerid][1], PHONE_COLOUR_MED);

			PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ 8 ] ) ;
			PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ 8 ] ) ;

			PlayerTextDrawSetString(fromplayerid, ptd_ph_popup[playerid] [ 1 ], "Text Message Sent");
			PlayerTextDrawColor(fromplayerid, ptd_ph_popup[playerid][1], PHONE_COLOUR_OK);

			PlayerTextDrawHide(fromplayerid, ptd_ph_design[playerid] [ 8 ] ) ;
			PlayerTextDrawColor(fromplayerid, ptd_ph_design[playerid][8], 0xFFFFFFFF);
			PlayerTextDrawShow(fromplayerid, ptd_ph_design[playerid] [ 8 ] ) ;

		}

		case PHONE_ALERT_CALL: 	{ 
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 25 ;
			PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "Incoming Call From");
			PlayerTextDrawColor(playerid, ptd_ph_popup[playerid][1], PHONE_COLOUR_MED);


			PlayerTextDrawHide(playerid, ptd_ph_design[playerid] [ 9 ] ) ;
			PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_MED);
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid] [ 9 ] ) ;

			///////

			cmd_phanim(fromplayerid);
			SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "To cancel animation, do /sa. To re-do it, use /ph(one)anim." ) ;


			PlayerTextDrawSetString(fromplayerid, ptd_ph_popup[playerid] [ 1 ], "Requesting Connection");
			PlayerTextDrawColor(fromplayerid, ptd_ph_popup[playerid][1], PHONE_COLOUR_OK);


			PlayerTextDrawHide(fromplayerid, ptd_ph_design[playerid] [ 9 ] ) ;
			PlayerTextDrawColor(fromplayerid, ptd_ph_design[playerid][9], PHONE_COLOUR_MED);
			PlayerTextDrawShow(fromplayerid, ptd_ph_design[playerid] [ 9 ] ) ;

		}
	}

	defer Phone_FlashAlert(playerid, type, 0, fromplayerid);

	PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 2 ], sprintf("%d", PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER]));
	PlayerTextDrawSetString(fromplayerid, ptd_ph_popup[playerid] [ 2 ], sprintf("%d", Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ]));

	for_loop(new i, j = 3 ; i < j ; i ++ ) {
		PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ i ] ) ;
		PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ i ] ) ;
		PlayerTextDrawHide(fromplayerid, ptd_ph_popup[playerid] [ i ] ) ;
		PlayerTextDrawShow(fromplayerid, ptd_ph_popup[playerid] [ i ] ) ;
	}

	return true ;
}

timer Phone_FlashAlert[500](playerid, type, index, fromplayerid) {

	if ( type == PHONE_ALERT_SMS ) {

		if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_CHECKED_INBOX ] ) {
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_CHECKED_INBOX ] = false ;

			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
			PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

			PlayerTextDrawHide(playerid, ptd_ph_design[playerid][8]);
			PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], 0xDEDEDEFF);
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid][8]);

			for_loop(new i, j = 3; i < j ; i ++ ) {

				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid][i]);
			}

			return true ;
		} 
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ]) {

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
		cmd_phanim(playerid);

		switch ( type ) {
			case PHONE_ALERT_SMS: SendClientMessage(playerid, -1, "To view your messages, click the envelope icon.");
			case PHONE_ALERT_CALL: {

				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ 1 ]);
				PlayerTextDrawColor(playerid, ptd_ph_popup[playerid] [ 1 ], PHONE_COLOUR_OK);
				PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "Call connected with");

				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ 2 ]);
				PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 2 ], sprintf("%d", PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;


				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_OK);

 				if ( PlayerVar [ playerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ 1 ]);
					PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ 2 ]);
					PlayerTextDrawShow(playerid, ptd_ph_design[playerid][9]);
				}

				SendClientMessage(playerid, -1, "You have picked up.");
				SendClientMessage(fromplayerid, -1, "They have picked up.");

				///////////


				PlayerTextDrawHide(fromplayerid, ptd_ph_popup[playerid] [ 1 ]);
				PlayerTextDrawColor(fromplayerid, ptd_ph_popup[playerid] [ 1 ], PHONE_COLOUR_OK);
				PlayerTextDrawSetString(fromplayerid, ptd_ph_popup[playerid] [ 1 ], "Call connected with");

				PlayerTextDrawHide(fromplayerid, ptd_ph_popup[playerid] [ 2 ]);
				PlayerTextDrawSetString(fromplayerid, ptd_ph_popup[playerid] [ 2 ], sprintf("%d", Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] ) ) ;

				PlayerTextDrawHide(fromplayerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(fromplayerid, ptd_ph_design[playerid][9], PHONE_COLOUR_OK);

 				if ( PlayerVar [ fromplayerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(fromplayerid, ptd_ph_popup[playerid] [ 1 ]);
					PlayerTextDrawShow(fromplayerid, ptd_ph_popup[playerid] [ 2 ]);
					PlayerTextDrawShow(fromplayerid, ptd_ph_design[playerid][9]);	
				}

				PlayerVar [ playerid ] [ player_phonecalling ] = fromplayerid ;
				PlayerVar [ fromplayerid ] [ player_phonecalling ] = playerid ;

				cmd_phanim(fromplayerid);

				defer Phone_ConnectPlayer(playerid, fromplayerid) ;
			}
		}

		return true ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] || !IsPlayerConnected(playerid) ) {

		SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You can't reach the recipient." ) ;

		PlayerVar [ playerid ] [ player_phonecalling ] = INVALID_PLAYER_ID ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		return true ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;


		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		switch ( type ) {
			case PHONE_ALERT_SMS: {

				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][8]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);
				PlayerTextDrawShow(playerid, ptd_ph_design[playerid][8]);

				SendServerMessage( playerid, PHONE_COLOUR_OK, "Phone", "A3A3A3", "You've muted your phone." ) ;
			}
			case PHONE_ALERT_CALL: {
				
				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_MED);
				PlayerTextDrawShow(playerid, ptd_ph_design[playerid][9]);

				SendServerMessage( playerid, PHONE_COLOUR_OK, "Phone", "A3A3A3", "You've declined the call." ) ;
				SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your recipient has declined the call." ) ;
			}
		}

		for_loop(new i, j = 3; i < j ; i ++ ) {

			PlayerTextDrawHide(playerid, ptd_ph_popup[playerid][i]);
		}

		return true ;
	}

	if ( ! IsPlayerConnected(fromplayerid) ) {

		SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The line went dead." ) ;

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		switch ( type ) {

			case PHONE_ALERT_SMS: {
				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][8]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);
				PlayerTextDrawShow(playerid, ptd_ph_design[playerid][8]);
			}

			case PHONE_ALERT_CALL: {
				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ 1 ]);
				PlayerTextDrawColor(playerid, ptd_ph_popup[playerid] [ 1 ], PHONE_COLOUR_BAD);
				PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "Missed Call From");
				PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ 1 ]);

				//PlayerVar [ playerid ] [ E_PLAYER_PHONE_MISSED_CALL_NR ] = PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER] ;

				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_BAD);
				PlayerTextDrawShow(playerid, ptd_ph_design[playerid][9]);
			}
		}

		return true ;
	}

	if ( -- PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] <= 0 ) {

		PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
		PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

		switch ( type ) {


			case PHONE_ALERT_SMS: {

				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][8]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);

 				if ( PlayerVar [ playerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(playerid, ptd_ph_design[playerid][8]);
				}
			}

			case PHONE_ALERT_CALL: {

				PlayerTextDrawHide(playerid, ptd_ph_popup[playerid] [ 1 ]);
				PlayerTextDrawColor(playerid, ptd_ph_popup[playerid] [ 1 ], PHONE_COLOUR_BAD);
				PlayerTextDrawSetString(playerid, ptd_ph_popup[playerid] [ 1 ], "Missed Call From");

				if ( PlayerVar [ playerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(playerid, ptd_ph_popup[playerid] [ 1 ]);
				}

				// PlayerVar [ playerid ] [ E_PLAYER_PHONE_MISSED_CALL_NR ] = PlayerVar[fromplayerid][E_PLAYER_PHONE_CALL_NUMBER] ;

				for_loop(new i, j = 3; i < j ; i ++ ) {

					PlayerTextDrawHide(fromplayerid, ptd_ph_popup[playerid][i]);
				}

				SendServerMessage( fromplayerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The number you tried to call didn't pick up in time." ) ;

				PlayerTextDrawHide(fromplayerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(fromplayerid, ptd_ph_design[playerid][9], 0xDEDEDEFF);

 				if ( PlayerVar [ fromplayerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(fromplayerid, ptd_ph_design[playerid][9]);
				}


				PlayerTextDrawHide(playerid, ptd_ph_design[playerid][9]);
				PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_BAD);

				if ( PlayerVar [ playerid ] [ player_viewphone ] ) {
					PlayerTextDrawShow(playerid, ptd_ph_design[playerid][9]);
				}
			}
		}

		return true ;
	}

	switch ( type ) {

		case PHONE_ALERT_SMS: {

			PlayerTextDrawHide(playerid, ptd_ph_design[playerid][8]);
			switch ( index ) {
				case 0: PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], 0xFFFFFFFF);
				case 1: PlayerTextDrawColor(playerid, ptd_ph_design[playerid][8], PHONE_COLOUR_MED);
			}
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid][8]);
		}
		case PHONE_ALERT_CALL: {
			PlayerTextDrawHide(playerid, ptd_ph_design[playerid][9]);
			switch ( index ) {
				case 0: PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], 0xFFFFFFFF);
				case 1: PlayerTextDrawColor(playerid, ptd_ph_design[playerid][9], PHONE_COLOUR_MED);
			}
			PlayerTextDrawShow(playerid, ptd_ph_design[playerid][9]);
		}
	}

	switch ( type ) {

		case PHONE_ALERT_SMS: {

			PlayerPlaySound(playerid, 40405, 0.0, 0.0, 0.0);
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
		}

		case PHONE_ALERT_CALL: {

			if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] ++ >= 4 ) {

				PlayerPlaySound(playerid, 20600, 0.0, 0.0, 0.0);

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
			}


			if ( PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] ++ >= 4 ) {

				//SendClientMessage(fromplayerid, -1, "Playing dial tone.");
				PlayerPlaySound(fromplayerid, 3600 , 0.0, 0.0, 0.0);

				PlayerVar [ fromplayerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
			}

		}
	}

	if ( index ++ >= 1) {


		index = 0 ;
	}

	defer Phone_FlashAlert(playerid, type, index, fromplayerid ) ;

	return true ;
}
