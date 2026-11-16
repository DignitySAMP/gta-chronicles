static SendPlayerChatText(playerid, text[], bool:fromcmd=false, bool:forcephone=false)
{
	if (!IsPlayerSpawned ( playerid ) ) 
	{
		SendClientMessage(playerid, COLOR_ERROR, "You must be spawned before you can use the chat.");
		return 0 ;
	}
	
	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0 ) {
		
		SendClientMessage(playerid, COLOR_ERROR, "You are dead and can't speak. Use /acceptdeath to continue.");
		return 0 ;
	}

    if ( PlayerVar [ playerid ] [ E_PLAYER_LOGOUT_TICK ] ) {

    	SendClientMessage(playerid, COLOR_YELLOW, "You can't use local chat while your /logout timer is ticking." ) ;
        return 0 ;
    }

	new vehicleid = GetPlayerVehicleID(playerid);
	new string[256];

	if (vehicleid && IsPlayerInAnyVehicle(playerid) && IsWindowedVehicle(vehicleid) && Vehicle_GetEnumID(vehicleid) != -1)
	{
		new veh_enum_id = Vehicle_GetEnumID(GetPlayerVehicleID(playerid));
		
		if ( veh_enum_id != INVALID_VEHICLE_ID ) {
			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {// up

				foreach(new targetid: Player) 
				{
					if ( GetPlayerVehicleID(targetid) == GetPlayerVehicleID ( playerid ) ) {

						if ( GetPlayerNametagPreference(targetid) == 1 ) {

							if (forcephone || (!fromcmd && PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID )) {
								format ( string, sizeof ( string ), "(Windows Closed) %s says (phone): %s", ReturnPlayerNameData(playerid, .charname=true ), text ) ;
							}

							else format ( string, sizeof ( string ), "(Windows Closed) %s says: %s", ReturnPlayerNameData(playerid, .charname=true), text ) ;
						}

						else if ( GetPlayerNametagPreference(targetid)  == 2 ) {

							if (forcephone || (!fromcmd && PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID  )) {
								format ( string, sizeof ( string ), "(Windows Closed) %s{DEDEDE} says (phone): %s", ReturnPlayerNameDataHex(playerid), text ) ;
							}

							else format ( string, sizeof ( string ), "(Windows Closed) %s{DEDEDE} says: %s", ReturnPlayerNameDataHex(playerid), text ) ;
						}

						ZMsg_SendClientMessage(targetid, 0xDEDEDEFF, string);
					}
				}
			}
			
			else if ( ! Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {// down

				if (!forcephone && (fromcmd || PlayerVar [ playerid ] [ player_phonecalling ] == INVALID_PLAYER_ID )) {

    				ProxDetectorNameTag(playerid, 15.0, 0xDEDEDEFF, text, " says:", 2, .invert_action=false, .customcolor=true) ;  
    			}

    			else {

    				ProxDetectorNameTag(playerid, 15.0, 0xDEDEDEFF, text, " says (phone):", 2, .invert_action=false, .customcolor=true) ;  
    			}
			}

			if ( PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID && !fromcmd ) {

				new targetid = PlayerVar [ playerid ] [ player_phonecalling ] ;

				if ( GetPlayerNametagPreference(targetid) == 1 ) {

					format ( string, sizeof ( string ), "%s says (phone): %s", ReturnPlayerNameData ( playerid, .charname=true ), text ) ;
				}

				else if ( GetPlayerNametagPreference(targetid)  == 2 ) {

					format ( string, sizeof ( string ), "%s{FFFF00} says (phone): %s", ReturnPlayerNameDataHex(playerid, true), text ) ;
				}

				ZMsg_SendClientMessage(targetid, COLOR_YELLOW, string);
			}
		}
	}

	else {

		if (forcephone || (!fromcmd && PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID )) {

			if (PlayerVar [ playerid ] [ player_phonecalling ] != INVALID_PLAYER_ID)
			{
				new targetid = PlayerVar [ playerid ] [ player_phonecalling ] ;

				if ( GetPlayerNametagPreference(targetid) == 1 ) {

					format ( string, sizeof ( string ), "%s says (phone): %s", ReturnPlayerNameData ( playerid, .charname=true ), text ) ;
				}

				else if ( GetPlayerNametagPreference(targetid)  == 2 ) {

					format ( string, sizeof ( string ), "%s{FFFF00} says (phone): %s", ReturnPlayerNameDataHex(playerid, true), text ) ;
				}

				ZMsg_SendClientMessage(targetid, COLOR_YELLOW, string);
			}
			

			if ( GetPlayerVirtualWorld(playerid) == 0 ) {
				ProxDetectorNameTag(playerid, 15.0, 0xDEDEDEFF, text, " says (phone):", 0, true, false ) ;
			}

			else ProxDetectorNameTag(playerid, 10.0, 0xDEDEDEFF, text, " says (phone):", 0, true, false ) ;
		}

		else 
		{
			new Float:range = 15.0;

			// Make arrested people quieter cause honestly fuck the spam
			// if ( Character [ playerid ] [ E_CHARACTER_ARREST_TIME ] ) range = 7.5;

			// Make interiors a bit quieter too
			if ( GetPlayerVirtualWorld(playerid) != 0 ) range = 10.0;
			
			ProxDetectorNameTag(playerid, range, 0xDEDEDEFF, text, " says:", 0, true, false ) ;
			PlayChatAnimation(playerid, text);
		}

		// ProxDetector ( playerid,15.0, 0xDEDEDEFF, string ) ;
	}

	return 1;
}

hook OnPlayerText(playerid, text[]) {


	new string [ 144 ], services[64] ;
	// TODO: move this to a hook of OnPlayerText somewhere
	if ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] ) 
	{
		switch ( PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] ) {

			case 311: 
			{
				// Non emergency call service selection

				if (!strcmp(text, "Police", true) || !strcmp(text, "Police Department", true))
				{
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 1; // police
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 312; // next call stage
				}
				else if (!strcmp(text, "Fire", true) || !strcmp(text, "Fire Department", true)  || !strcmp(text, "Medical", true) || !strcmp(text, "EMS", true) || !strcmp(text, "Medic", true) || !strcmp(text, "Paramedics", true))
				{
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 2; // fire/ems
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 312; // next call stage
				}
				else if (!strcmp(text, "City Services", true) || !strcmp(text, "Government", true))
				{
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 3; // government
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 312; // next call stage
				}
				else
				{	
					SendClientMessage(playerid, COLOR_YELLOW, "Line Operator says (phone): Sorry, I don't understand.  Which department do you wish to contact?");
					SendServerMessage(playerid, 0xE83A2BFF, "Phone", "A3A3A3", "Type \"Police\", \"Fire\" or \"City Services\".") ;
					return Y_HOOKS_BREAK_RETURN_0;
				}

				text[0] = toupper(text[0]);
				SendPlayerChatText(playerid, text, false, true);
				SendClientMessage(playerid, COLOR_YELLOW, "Line Operator says (phone): Thank you, please leave your message now.");
				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 312:
			{
				SendPlayerChatText(playerid, text, false, true);

				// Non emergency call description
				if (strlen(text) < 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "Line Operator says (phone): Sorry, I didn't hear you.  Please leave your message again.");
					return Y_HOOKS_BREAK_RETURN_0;
				}

				new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
				GetPlayerPos ( playerid, x, y, z ) ;
				
				if (GetPlayerVirtualWorld(playerid) > 0)
				{
					// They are probably in a property, so use the exterior of that if they are
					new property = Property_GetInside(playerid);
					if (property != INVALID_PROPERTY_ID)
					{
						x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
						y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
						z = Property [ property ] [ E_PROPERTY_EXT_Z ];
					}
				}

				GetCoords2DZone(x, y, zone, sizeof ( zone ));
				GetPlayerAddress(x, y, address );

				Server [ E_SERVER_LAST_911_POS_X ] = x ;
				Server [ E_SERVER_LAST_911_POS_Y ] = y ;
				Server [ E_SERVER_LAST_911_POS_Z ] = z ;
				Server [ E_SERVER_LAST_911_TYPE ] = 0;

				format ( string, sizeof ( string ), "[Message]: %s", text ) ;

				new color = COLOR_FACTION; // police color
				if (PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY] == 2) color = COLOR_FIRE;

				foreach(new policeid: Player) 
				{
					if ( Character [ policeid ] [ E_CHARACTER_FACTIONID ] ) 
					{
						new faction_enum_id = Faction_GetEnumID(Character [ policeid ] [ E_CHARACTER_FACTIONID ] ); 

						if ( faction_enum_id != INVALID_FACTION_ID ) 
						{
							if (CanFactionAcceptEmergency(faction_enum_id, PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY])) 
							{
								SendClientMessage(policeid, color, sprintf("[311 Non-Emergency Call]: From: %d (Location: %s, %s)", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER], address, zone ) ) ;
								ZMsg_SendClientMessage(policeid, color, string);
								SendClientMessage(policeid, color, sprintf("To accept this call, type \"/acc(eptcall) %d\".", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
							}
						}
					}
				}


				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				SendClientMessage(playerid, COLOR_YELLOW, "Line Operator says (phone): Thank you.  Your chosen department has been notified of your call.");
				SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );

				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 726:
			{
				SendPlayerChatText(playerid, text, false, true);

				// SAN Hotline
				if (strlen(text) < 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): Sorry, I didn't hear you.  Please leave your message again.");
					return Y_HOOKS_BREAK_RETURN_0;
				}

				new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
				GetPlayerPos ( playerid, x, y, z ) ;
				
				if (GetPlayerVirtualWorld(playerid) > 0)
				{
					// They are probably in a property, so use the exterior of that if they are
					new property = Property_GetInside(playerid);
					if (property != INVALID_PROPERTY_ID)
					{
						x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
						y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
						z = Property [ property ] [ E_PROPERTY_EXT_Z ];
					}
				}

				GetCoords2DZone(x, y, zone, sizeof ( zone ));
				GetPlayerAddress(x, y, address );
				new color = COLOR_FACTION;

				foreach(new i: Player) 
				{
					if (IsPlayerInNewsFaction(i))
					{
						SendClientMessage(i, color, sprintf("[Secretary Forwards SAN (7-2-6) Hotline Call]: From %d", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
						SendClientMessage(i, color, sprintf("[Call Location]: %s, %s", address, zone ) ) ;
						ZMsg_SendClientMessage(i, color, sprintf("[Message]: %s", text ) ) ;
					}
				}


				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): Thank you, your message has been passed on to the news desk.");
				SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );
				
				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 732:
			{
				SendPlayerChatText(playerid, text, false, true);

				// Security Hotline
				if (strlen(text) < 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): Sorry, I didn't hear you.  Please leave your message again.");
					return Y_HOOKS_BREAK_RETURN_0;
				}

				new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
				GetPlayerPos ( playerid, x, y, z ) ;
				
				if (GetPlayerVirtualWorld(playerid) > 0)
				{
					// They are probably in a property, so use the exterior of that if they are
					new property = Property_GetInside(playerid);
					if (property != INVALID_PROPERTY_ID)
					{
						x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
						y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
						z = Property [ property ] [ E_PROPERTY_EXT_Z ];
					}
				}

				GetCoords2DZone(x, y, zone, sizeof ( zone ));
				GetPlayerAddress(x, y, address );
				new color = COLOR_FACTION;

				foreach(new i: Player) 
				{
					if (IsPlayerInSecurityFaction(i))
					{
						SendClientMessage(i, color, sprintf("[Secretary Forwards SEC (7-3-2) Hotline Call]: From %d", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
						SendClientMessage(i, color, sprintf("[Call Location]: %s, %s", address, zone ) ) ;
						ZMsg_SendClientMessage(i, color, sprintf("[Message]: %s", text ) ) ;
					}
				}

				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				SendClientMessage(playerid, COLOR_YELLOW, "Secretary says (phone): Thank you, your message has been passed on to our security dispatch.");
				SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );
				
				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 111:
			{
				SendPlayerChatText(playerid, text, false, true);

				// Taxi Hotline
				if (strlen(text) < 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "Taxi Dispatcher says (phone): Sorry, I didn't hear you, try again.");
					return Y_HOOKS_BREAK_RETURN_0;
				}

				new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
				GetPlayerPos ( playerid, x, y, z ) ;
				
				if (GetPlayerVirtualWorld(playerid) > 0)
				{
					// They are probably in a property, so use the exterior of that if they are
					new property = Property_GetInside(playerid);
					if (property != INVALID_PROPERTY_ID)
					{
						x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
						y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
						z = Property [ property ] [ E_PROPERTY_EXT_Z ];
					}
				}

				GetCoords2DZone(x, y, zone, sizeof ( zone ));
				GetPlayerAddress(x, y, address );
				new color = COLOR_FACTION;

				foreach(new i: Player) 
				{
					if (IsPlayerInTaxiFaction(i))
					{
						SendClientMessage(i, color, sprintf("[Dispatcher Forwards CAB (1-1-1) Hotline Call]: From %d", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
						SendClientMessage(i, color, sprintf("[Call Location]: %s, %s", address, zone ) ) ;
						ZMsg_SendClientMessage(i, color, sprintf("[Message]: %s", text ) ) ;
						SendClientMessage(i, COLOR_YELLOW, sprintf("To accept this call, type \"/acc(eptcall) %d\".", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER]));
					}
				}

				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 4; // taxi

				SendClientMessage(playerid, COLOR_YELLOW, "Taxi Dispatcher says (phone): Thank you, your request has been passed to our drivers.");
				SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );
				
				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 911: 
			{
				// Emergency call service selection
				text[0] = toupper(text[0]);
				SendPlayerChatText(playerid, text, false, true);
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 0;

				if (!strcmp(text, "Police", true))
				{
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 1; // police
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 912; // next call stage
				}
				else if (!strcmp(text, "Fire", true) || !strcmp(text, "Medical", true) || !strcmp(text, "EMS", true) || !strcmp(text, "Medic", true) || !strcmp(text, "Paramedics", true))
				{
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] = 2; // fire/ems
					PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 912; // next call stage
				}

				if (PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ])
				{
					SendClientMessage(playerid, COLOR_YELLOW, "911 Dispatcher says (phone): And, what is your emergency?");
				}
				else
				{	
					SendClientMessage(playerid, COLOR_YELLOW, "911 Dispatcher says (phone): Sorry, I don't understand.  Which emergency service do you require?");
					SendServerMessage(playerid, 0xE83A2BFF, "Phone", "A3A3A3", "Type \"Police\", \"Fire\" or \"Medical\".") ;
				}

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 912:
			{
				SendPlayerChatText(playerid, text, false, true);

				// Emergency call description
				if (strlen(text) < 4)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "911 Dispatcher says (phone): Sorry, I didn't hear you.  What is your emergency?");
					return Y_HOOKS_BREAK_RETURN_0;
				}

				new address [ 64 ], zone [ 64 ], Float: x, Float: y, Float: z  ;
				GetPlayerPos ( playerid, x, y, z ) ;
				
				if (GetPlayerVirtualWorld(playerid) > 0)
				{
					// They are probably in a property, so use the exterior of that if they are
					new property = Property_GetInside(playerid);
					if (property != INVALID_PROPERTY_ID)
					{
						x = Property [ property ] [ E_PROPERTY_EXT_X ]; 
						y = Property [ property ] [ E_PROPERTY_EXT_Y ]; 
						z = Property [ property ] [ E_PROPERTY_EXT_Z ];
					}
				}

				GetCoords2DZone(x, y, zone, sizeof ( zone ));
				GetPlayerAddress(x, y, address );

				Server [ E_SERVER_LAST_911_POS_X ] = x ;
				Server [ E_SERVER_LAST_911_POS_Y ] = y ;
				Server [ E_SERVER_LAST_911_POS_Z ] = z ;
				Server [ E_SERVER_LAST_911_TYPE ] = 0;
				Server [ E_SERVER_LAST_911_NUMBER ] = PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER];

				if (IsPlayerInMallArea(playerid)) Server [ E_SERVER_LAST_911_TYPE ] = 1;
				
				format ( string, sizeof ( string ), "[Emergency]: %s", text ) ;
				format ( services, sizeof ( services ), "[Services Requested]: %s", PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY] == 1 ? "Police" : "Fire / EMS" ) ;

				new color = COLOR_FACTION; // police color
				if (PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY] == 2) color = COLOR_FIRE;

				foreach(new policeid: Player) 
				{
					if ( Character [ policeid ] [ E_CHARACTER_FACTIONID ] ) 
					{
						new faction_enum_id = Faction_GetEnumID(Character [ policeid ] [ E_CHARACTER_FACTIONID ] ); 

						if ( faction_enum_id != INVALID_FACTION_ID ) 
						{
							if (IsPlayerInPoliceFaction(policeid) || IsPlayerInMedicFaction(policeid) || (Server[E_SERVER_LAST_911_TYPE] == 1 && IsPlayerInSecurityFaction(policeid, true))) 
							{
								SendClientMessage(policeid, color, sprintf("[Dispatch Forwards 9-1-1 Call]: From %d", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
								SendClientMessage(policeid, color, sprintf("[Location]: %s, %s", address, zone ) ) ;
								ZMsg_SendClientMessage(policeid, color, services);
								ZMsg_SendClientMessage(policeid, color, string);

								if (CanFactionAcceptEmergency(faction_enum_id, PlayerVar[playerid][E_PLAYER_PHONE_EMERGENCY])) 
								{
									SendClientMessage(policeid, COLOR_YELLOW, sprintf("To accept this call, type \"/acc(eptcall) %d\".", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER]));
								}
							}
							else if (Has911Scanner(policeid))
							{
								SendClientMessage(policeid, color, sprintf("[Scanner Receives 9-1-1 Call]: From %d", PlayerVar[playerid][E_PLAYER_PHONE_CALL_NUMBER] ) ) ;
								SendClientMessage(policeid, color, sprintf("[Location]: %s, %s", address, zone ) ) ;
								ZMsg_SendClientMessage(policeid, color, services);
								ZMsg_SendClientMessage(policeid, color, string);
							}
						}
					}
				}

				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				if (PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] == 1)
				{	
					SendClientMessage(playerid, COLOR_YELLOW, "911 Dispatcher says (phone): Thank you, the police have been notified of your location.");
				}	
				else if (PlayerVar [ playerid ] [ E_PLAYER_PHONE_EMERGENCY ] == 2)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "911 Dispatcher says (phone): Thank you, the fire and medical services have been notified of your location.");
				}
				
				SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );
				
				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}

			case 666: {

    			SendPlayerChatText(playerid, text, false, true);

				if ( strfind(text, "book a room", true ) != -1 ) {

					SendClientMessage(playerid, COLOR_YELLOW, "A muffled voice says (phone): Splendid, sir. One of our employees will be in touch.");

					Contract_StoreNewData(playerid, Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ]) ;
				}

				else {

					SendClientMessage(playerid, COLOR_YELLOW, "A muffled voice says (phone): I'm sorry sir, but through this line you are only able to book a room.");
					SendClientMessage(playerid, COLOR_ACTION, "** The line has been disconnected." );
				}

				#if !defined PHONE_V2_DEV
				Phone_HideCallTextDraws(playerid);
				#endif
				PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATIC_CALL ] = 0 ;

				cmd_phone(playerid,"");
				cmd_stopanim(playerid, "");

				return Y_HOOKS_BREAK_RETURN_0;
			}
		}
	}

	return Y_HOOKS_CONTINUE_RETURN_1 ;
}

CMD:shout(playerid, params[]) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0 ) {
		
		SendClientMessage(playerid, COLOR_ERROR, "You are dead and can't shout. Use /acceptdeath to continue.");
		return 1 ;
	}

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/shout [text]" ) ;
	}

	new Float:range = 30.0;

	if ( Character [ playerid ] [ E_CHARACTER_ARREST_TIME ] ) 
	{
		// Might help to stop the irritation of prisoners shouting for now
		range = 15.0;
	}

    ProxDetectorNameTag(playerid, range, -1, text, " shouts:", 0, true, false ) ;

	new string [ 256 ] ;
	format ( string, sizeof ( string ), "%s shouts: %s", ReturnPlayerNameData ( playerid, 0, true ), text ) ;
	SendMoleMessage(playerid, string);
	
	//WriteLog ( playerid, "chat/local", string );

	// NEW LOGGING: Log this as a LOG_TYPE_CHAT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_CHAT, sprintf("Shouts: %s", text));

	return true ;
}
CMD:s(playerid, params[]) {

	return cmd_shout(playerid, params);
}

CMD:low(playerid, params[]) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0 ) {
		
		SendClientMessage(playerid, COLOR_ERROR, "You are dead and can't speak. Use /acceptdeath to continue.");
		return 1 ;
	}

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/low [text]" ) ;
	}
	
	new string [ 256 ] ;

	format ( string, sizeof ( string ), "%s says [low]: %s", ReturnPlayerNameData ( playerid, 0, true ), text ) ;
	//WriteLog ( playerid, "chat/local", string );


	if ( IsPlayerInAnyVehicle(playerid) && IsWindowedVehicle(GetPlayerVehicleID(playerid)) && Vehicle_GetEnumID(GetPlayerVehicleID(playerid)) != -1 ) {
		new veh_enum_id = Vehicle_GetEnumID (GetPlayerVehicleID(playerid));

		if ( veh_enum_id != INVALID_VEHICLE_ID ) {
			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {// up

				strins(string, "(Windows Closed) ", 0);

				foreach(new targetid: Player) {

					if ( GetPlayerVehicleID(targetid) == GetPlayerVehicleID ( playerid ) ) {

						ZMsg_SendClientMessage(targetid, 0xDEDEDEFF, string);
					}
				}
			}
			
			else if ( ! Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {// down

				//strins(string, "(Windows Open) ", 0);
				//ProxDetector ( playerid,5.0, 0xDEDEDEFF, string, 1.6, false ) ;
    			ProxDetectorNameTag(playerid, 5.0, -1, text, " says [low]:", 2, true, false ) ;
			}
		}
	}

	else {

    	ProxDetectorNameTag(playerid, 5.0, -1, text, " says [low]:", 0, true, false ) ;
	}

	PlayChatAnimation(playerid, text) ;
	SendMoleMessage(playerid, string);

	// NEW LOGGING: Log this as a LOG_TYPE_CHAT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_CHAT, sprintf("[low]: %s", text));

	return true ;
}

CMD:l(playerid, params[])
{
	return cmd_low(playerid, params);
}

IsPlayerDriveBying(playerid) {

	if ( GetPlayerState(playerid) == PLAYER_STATE_PASSENGER ) {

		if ( AC_GetPlayerWeapon ( playerid ) != 0 ) {

			return true ;
		}
	}

	return false ;
}

public OnPlayerText(playerid, text[]) 
{
	if (!IsPlayerSpawned(playerid) || !IsPlayerPlaying(playerid) || PlayerVar[playerid][E_PLAYER_LOGOUT_TICK])
	{
		return 0;
	}

	foreach (new i: Player) 
	{
		if ( ! IsPlayerLogged ( i ) ) 
		{
			continue ;
		}

		if ( Account [ i ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] <= 0 ) 
		{
			continue ;
		}

		if ( PlayerVar [ i ] [ E_PLAYER_IS_SPECTATING ] == playerid ) 
		{
			SendClientMessage(i, 0xDEDEDEFF, sprintf("[SPEC]: (%d) %s said: %s", playerid, ReturnPlayerNameData ( playerid ), text ) ) ;
			continue ;
		}

		else continue ;
	}

	SendPlayerChatText(playerid, text);

	#if defined chat_OnPlayerText
		return chat_OnPlayerText(playerid, text[]);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerText
	#undef OnPlayerText
#else
	#define _ALS_OnPlayerText
#endif

#define OnPlayerText chat_OnPlayerText
#if defined chat_OnPlayerText
	forward chat_OnPlayerText(playerid, text[]);
#endif

CMD:t(playerid, params[])
{
	new text[128];
	
	if (sscanf(params, "s[128]", text))
	    return  SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3",  "/t [text]" );

	SendPlayerChatText(playerid, text, true);
	return true;
}

CMD:setchat(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
    new type;

	if (sscanf(params, "d", type))
	    return  SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3",  "/setchat [1-9] (or 0 to disable)" );

	if (type < 0 || type > 9)
	    return  SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3",  "Type can't be less than 0 or higher than 9." );

	Character [ playerid ] [ E_CHARACTER_CHAT_STYLE ] = type ;

	new query [ 128 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_chatstyle = %d WHERE player_id = %d", 
		Character [ playerid ] [ E_CHARACTER_CHAT_STYLE ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	
	if ( type == 0 ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", "You have removed your chat animation." ) ;
	}

 	SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", sprintf("You've changed your automatic chat animation style to %d.", type ) ) ;

	return 1;
}


CMD:whisper(playerid, params[]) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0 ) {
		
		SendClientMessage(playerid, COLOR_ERROR, "You are dead and can't speak. Use /acceptdeath to continue.");
		return 1 ;
	}

	new userid, text[144];

	if (sscanf(params, "k<player>s[128]", userid, text))
		return SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", "/whisper [id] [text]" ) ;

	if (!IsPlayerConnected(userid))
		return SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", "Player isn't connected." ) ;

	if (  PlayerVar [ userid ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

    if ( userid == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You can't whisper yourself." ) ;
    }

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( userid, x, y, z ) ;

	if ( ! IsPlayerInRangeOfPoint ( playerid, 2.5, x, y, z ) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", "You're not near the player you're trying to whisper!" ) ;
	}
 
	new string [ 384 ] ;

	format ( string, sizeof ( string ), "Whisper to %s: %s", ReturnPlayerNameData(userid, 0, true), text )  ;
	ZMsg_SendClientMessage(playerid, 0xFFFF22AA, string ); 

	// NEW LOGGING: Log this as a LOG_TYPE_CHAT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_CHAT, string);

	format ( string, sizeof ( string ), "%s whispers: %s", ReturnPlayerNameData(playerid, 0, true), text )  ;
	ZMsg_SendClientMessage(userid, 0xFFCC2299, string );
	SendMoleMessage(playerid, string);
	SendAdminListen(playerid, string);

	/*

	ProxDetector ( playerid, 20.0, COLOR_ACTION, sprintf("* %s mutters something to %s.",
		ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData(userid, 0, true )) ) ;

	*/

	ProxDetectorAutoMe(playerid, 15.0, sprintf("mutters something to %s.", ReturnPlayerNameData(userid, 0, true )));

	

	return 1;
}

CMD:w(playerid, params[]){
	return cmd_whisper ( playerid, params ) ;
}

CMD:carwhisper(playerid, params[]) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0 ) {
		
		SendClientMessage(playerid, COLOR_ERROR, "You are dead and can't speak. Use /acceptdeath to continue.");
		return true;
	}

	if ( ! IsPlayerInAnyVehicle(playerid) ) 
	{
		SendClientMessage(playerid, COLOR_ERROR, "You are not in a vehicle.");
		return true;
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	if (!IsWindowedVehicle(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You are not in any vehicle with windows.");
	}

	new text[144], string[256];

	if (sscanf(params, "s[128]", text))
		return SendServerMessage( playerid, COLOR_ERROR, "Chat", "A3A3A3", "/c(ar)w(hisper) [text]" ) ;

	format ( string, sizeof ( string ), "[%s] %s whispers: %s", ReturnVehicleName(vehicleid), ReturnPlayerNameData(playerid, 0, true), text )  ;
	foreach (new userid: Player) 
	{
		if ( GetPlayerVehicleID(userid) == vehicleid) 
		{
			ZMsg_SendClientMessage(userid, 0xD9956499, string );
		}
	}

	SendMoleMessage(playerid, string);
	SendAdminListen(playerid, string);

	/*
	ProxDetector ( playerid, 7.5, COLOR_ACTION, sprintf("* %s mutters something among the vehicle occupants.",
		ReturnPlayerNameData ( playerid, 0, true )) ) ;
	*/

	// NEW LOGGING: Log this as a LOG_TYPE_CHAT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_CHAT, sprintf("[%s] whispers: %s", ReturnVehicleName(vehicleid), text));

	ProxDetectorAutoMe(playerid, 7.5, "mutters something inside the vehicle.");

	return true ;
}

CMD:cw(playerid, params[]){
	return cmd_carwhisper ( playerid, params ) ;
}

PlayChatAnimation(playerid, text[]) 
{
	if (!Character[playerid][E_CHARACTER_CHAT_STYLE] || IsPlayerInMinigame(playerid) || IsPlayerIncapacitated(playerid) || IsPlayerDriveBying(playerid) || IsPlayerInAnyVehicle(playerid) || PlayerVar[playerid][E_PLAYER_LOOPING_ANIM] || PlayerVar[playerid][E_PLAYER_USING_HOSE])
	{
		// Do nothing.
		return true;
	}

	new anim = GetPlayerAnimationIndex(playerid );
	if (anim == 1189 || anim == 1186 || anim == 1275)
	{
		switch ( Character [ playerid ] [ E_CHARACTER_CHAT_STYLE ] ) 
		{
			case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, true, 0, 0, 1, 1);
			case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, true, 0, 0, 1, 1);
			case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, true, 0, 0, 1, 1);
			case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.1, true, 0, 0, 1, 1);
			case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, true, 0, 0, 1, 1);
			case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, true, 0, 0, 1, 1);
			case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, true, 0, 0, 1, 1);
			case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, true, 0, 0, 1, 1);
			case 9: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, true, 0, 0, 1, 1);
		}

		defer ClearChatAnim[1000 + (strlen(text)*60)](playerid, PlayerConnectSerial[playerid]);
	}

	return true;
}


timer ClearChatAnim[1000](playerid, serial) {

	if ( serial != PlayerConnectSerial[playerid] ) return true ;

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return true ;
    }

	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);

	return true ;
}