enum RadioChannelData {
	radioch_name [ 32 ],
	radioch_url [ 128 ]
} ;


new RadioChannels [ ] [ RadioChannelData ] = {

 	{ "[SOLS] Radio Los Santos",			"http://tachyon.shoutca.st:8136/stream"},
 	{ "[SOLS] Playback FM",					"http://pollux.shoutca.st:8527/stream"},
 	{ "[SOLS] Los Oldies",					"http://pollux.shoutca.st:8242/stream"},
	{ "[HIPHOP] BIG FM - Oldschool Rap", 	"http://streams.bigfm.de/bigfm-oldschool-128-mp3" },
	{ "[HIPHOP] All Compton Rap",			"http://149.56.147.197:8716" },
	{ "[HIPHOP] 181.fm - Hiphop", 			"http://relay.181.fm:8068/" },
	{ "[HIPHOP] 90s90s Hiphop",				"http://streams.90s90s.de/hiphop/mp3-192/radiode/"},
	{ "[HIPHOP] One Hip Hop", 				"http://listen.one.hiphop/live.mp3" },
 	{ "[CLUB] Deep House Lounge", 			"http://198.15.94.34:8006/stream" },
 	{ "[CLUB] Puls FM", 					"http://tuner.pulsfm.de" },
 	{ "[CLUB] Gay / Dance FM", 				"http://icepool.silvacast.com/GAYFM.mp3" },
 	{ "[ROCK/COUNTY] 57 Chevy Radio", 		"https://listen1.outpostradio.com/chevy" },
 	{ "[ROCK/COUNTY] 181.fm - Rock 40", 	"http://mp3uplink.duplexfx.com:8028/" },
	{ "[ROCK/COUNTY] 181.fm - Highway", 	"http://mp3uplink.duplexfx.com:8018/" },
 	{ "[CLASSIC] Venice Classic Radio", 	"http://174.36.206.197:8000"  }
 	//{ "[RUSSIAN] Radio Blatnyak",			"https://pub0202.101.ru:8443/stream/personal/aacp/64/675938"}
} ;

CMD:boomboxlisten(playerid, params[]) {

	new index ;

	if ( sscanf ( params, "i", index ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "/boomboxlisten [boombox-id]" ) ;
	}

	new boombox_id = Boombox_GetNearestEntity(playerid);

	if ( boombox_id != index ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near this boombox." ) ;
	}

	if ( strlen ( Boombox [ boombox_id ] [ E_BOOMBOX_STATION ] ) < 3  ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "This boombox isn't playing any music!" ) ;
	}

	SOLS_StopAudioStreamForPlayer(playerid);

	SOLS_PlayAudioStreamForPlayer(playerid, Boombox [ boombox_id ] [ E_BOOMBOX_STATION ], 
		Boombox [ boombox_id ] [ E_BOOMBOX_POS_X ], Boombox [ boombox_id ] [ E_BOOMBOX_POS_Y ], 
		Boombox [ boombox_id ] [ E_BOOMBOX_POS_Z ], BOOMBOX_RADIUS, true 
	) ; 

	PlayerVar [ playerid ] [ E_PLAYER_LISTENING_BOOMBOX ] = boombox_id ;
	SendServerMessage ( playerid, COLOR_INFO, "Boombox", "DEDEDE", sprintf("You've tuned to boombox %d. You're listening to \"%s\".",
		boombox_id,
		Boombox [ boombox_id ] [ E_BOOMBOX_STATION ]
	) ) ;

	return true ;
}

CMD:setstation(playerid) {
	new boombox_id = Boombox_GetNearestEntity(playerid);

	if ( boombox_id != INVALID_BOOMBOX_ID || IsPlayerInAnyVehicle(playerid)) {

		if ( ! IsPlayerInAnyVehicle ( playerid ) && Boombox [ boombox_id ] [ E_BOOMBOX_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) {

			return SendClientMessage(playerid, -1, "You're not near a boombox that you own." ) ;
		}

		inline SetStation_Intro(pid, dialogid, response, listitem, string:inputtext[]) {

			#pragma unused pid, dialogid, inputtext

			if ( response ) {
				switch ( listitem ) {

					case 0: { // Official channels

						Boombox_ShowOfficialChannels(playerid) ;
					}

					case 1: { // Custom

						Boombox_EnterCustomChannel(playerid) ;
					}

					case 2: { // Turn off

						Boombox_DisconnectForPlayer	(playerid);
					}
				}
			}
		}

		Dialog_ShowCallback ( playerid, using inline SetStation_Intro, DIALOG_STYLE_LIST, "Set Radio Station", "Official Channels\nEnter Custom URL\nTurn Radio Off", "Select", "Close" );

	}

	else SendClientMessage(playerid, -1, "You're not near a boombox or in a vehicle." ) ;

	return true ;
}


Boombox_ShowOfficialChannels(playerid) {

	new string [ 512 ] ;

	inline SetStation_Menu(pid, dialogid, response, listitem, string: inputtext[]) {

		#pragma unused pid, dialogid, inputtext 

		if ( ! response ) {

			return cmd_setstation(playerid);
		}

		if ( response ) {

			new boombox_id = Boombox_GetNearestEntity(playerid);

			if ( boombox_id != INVALID_BOOMBOX_ID && !IsPlayerInAnyVehicle ( playerid )) {

				format(Boombox [ boombox_id ] [ E_BOOMBOX_STATION ], 128, "%s", RadioChannels [ listitem ] [ radioch_url ] ) ;

				foreach ( new targetid: Player) {

					Boombox_SyncForPlayer( targetid ) ;
				} 

				SendClientMessage(playerid, -1, sprintf("You've changed boombox ID %d's channel to \"%s\".",  Boombox [ boombox_id ] [ E_BOOMBOX_ID ], RadioChannels [ listitem ] [ radioch_name ]  )) ;
				ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has changed the boombox's channel to \"%s\".", SOS_PlayerName(playerid), RadioChannels [ listitem ] [ radioch_name ] ) ) ;
			}

			else {

				Vehicle_BB_ShowOfficialChannels(playerid, listitem) ;
			}
		}
	}
	for ( new i, j = sizeof ( RadioChannels ); i < j ; i ++ ) {

		format ( string, sizeof ( string ), "%s%s\n", string, RadioChannels [ i ] [ radioch_name ] ) ;
	}

	Dialog_ShowCallback ( playerid, using inline SetStation_Menu, DIALOG_STYLE_LIST, "Set Radio Station",string, "Select", "Back" );

	return true ;
}

Boombox_EnterCustomChannel(playerid) {


	inline SetStation_Menu(pid, dialogid, response, listitem, string: inputtext[]) {

		#pragma unused pid, dialogid, listitem 

		if ( ! response ) {

			return cmd_setstation(playerid);
		}

		if ( response ) {

			if ( strlen ( inputtext ) < 5 ) {

				SendClientMessage(playerid, -1, "Enter a proper channel name! Can't be less than 5 characters. ") ;
				Boombox_EnterCustomChannel(playerid) ;

				return true ;
			}

			if ( ! CheckInputtextCrash ( playerid, inputtext )) {

				return true ;
			}		

			new boombox_id = Boombox_GetNearestEntity(playerid);

			if ( boombox_id != INVALID_BOOMBOX_ID && !IsPlayerInAnyVehicle ( playerid )) {

				format(Boombox [ boombox_id ] [ E_BOOMBOX_STATION ], 128, "%s", inputtext ) ;

				foreach ( new targetid: Player) {

					Boombox_SyncForPlayer( targetid, boombox_id ) ;
				} 

				SendClientMessage(playerid, -1, sprintf("You've changed boombox ID %d's channel to \"%s\".", Boombox [ boombox_id ] [ E_BOOMBOX_ID ], inputtext )) ;
				ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has changed the boombox's channel to a custom url.", SOLS_PlayerName(playerid) ) ) ;
			}
			else {
				Vehicle_BB_EnterCustomChannel(playerid, inputtext);
			}

		}
	}

	Dialog_ShowCallback ( playerid, using inline SetStation_Menu, DIALOG_STYLE_INPUT, "Set Radio Station: Custom", 
		"{DEDEDE}Enter a custom audio stream below.\n\nValid formats are mp3 and ogg/vorbis.\nA link to a .pls (playlist) file will play that playlist.\n\nAbusing this feature will result in punishment.", "Select", "Back" );

	return true ;
}

Boombox_DisconnectForPlayer(playerid) {

	new boombox_id = Boombox_GetNearestEntity(playerid);

	if ( boombox_id != INVALID_BOOMBOX_ID ) {
		Boombox [ boombox_id ] [ E_BOOMBOX_STATION ] [ 0 ] = EOS ;
		ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has turned the boombox OFF.", SOLS_PlayerName(playerid) ) ) ;

		foreach(new targetid: Player) {
			if ( IsPlayerInAnyDynamicArea ( targetid ) ) {

				for ( new i, j = sizeof ( Boombox ); i < j ; i ++ ) {

					if ( Boombox [ i ] [ E_BOOMBOX_ID ] != INVALID_BOOMBOX_ID ) {

						if ( IsPlayerInDynamicArea(targetid, Boombox [ i ] [ E_BOOMBOX_AREAID ] ) ) {

							if ( IsPlayerInAnyVehicle(targetid) && !Vehicle_BB_VehicleRadioPlaying ( targetid )) {
							
								if ( PlayerVar [ targetid ] [ E_PLAYER_LISTENING_BOOMBOX ] == i ) {

									SOLS_StopAudioStreamForPlayer(targetid);
									PlayerVar [ targetid ] [ E_PLAYER_LISTENING_BOOMBOX ] = INVALID_BOOMBOX_ID ;

									//Boombox_SyncForPlayer(targetid, i ) ;
								}

								else continue ;
							}
							
							else continue ;
						}

						else continue ;
					}

					else continue ;
				}
			}
		}
	}

	else {

		if ( IsPlayerInAnyVehicle(playerid) )  {

			Vehicle_BB_DisconnectForPlayer(playerid);
		}
	}

	return true ;
}

Boombox_SyncForPlayer(playerid, boombox_id=INVALID_BOOMBOX_ID) {

	if ( IsPlayerListeningToAudioStream(playerid) && IsPlayerSpawned ( playerid ) && IsPlayerLogged ( playerid )  ) {

		if ( boombox_id != INVALID_BOOMBOX_ID ) {
			SendClientMessage(playerid, COLOR_YELLOW, sprintf("An audio stream is overlapping. To listen to the new stream, use /b(oom)b(ox)listen %d.", boombox_id )) ;
		}

		else {
			SendClientMessage(playerid, COLOR_YELLOW, "An audio stream is overlapping. To listen to the new stream, use /b(oom)b(ox)listen [id]." ) ;
		}

		return true ;
	}

	//new vehicleid, veh_enum_id ;

	if ( IsPlayerInAnyDynamicArea ( playerid ) ) {

		if (  Vehicle_BB_VehicleRadioPlaying ( playerid ) ) {

			return true ;
		}

		for ( new i, j = sizeof ( Boombox ); i < j ; i ++ ) {

			if ( Boombox [ i ] [ E_BOOMBOX_ID ] != INVALID_BOOMBOX_ID ) {

				if ( IsPlayerInDynamicArea(playerid, Boombox [ i ] [ E_BOOMBOX_AREAID ] ) ) {
					if ( strlen ( Boombox [ i ] [ E_BOOMBOX_STATION ] ) >= 3  ) {

						if ( PlayerVar [ playerid ] [ E_PLAYER_LISTENING_BOOMBOX ] == INVALID_BOOMBOX_ID ) {

							SOLS_StopAudioStreamForPlayer(playerid);

							SOLS_PlayAudioStreamForPlayer(playerid, Boombox [ i ] [ E_BOOMBOX_STATION ], 
								Boombox [ i ] [ E_BOOMBOX_POS_X ], Boombox [ i ] [ E_BOOMBOX_POS_Y ], 
								Boombox [ i ] [ E_BOOMBOX_POS_Z ], BOOMBOX_RADIUS, true 
							) ; 

							PlayerVar [ playerid ] [ E_PLAYER_LISTENING_BOOMBOX ] = i ;

							return true ;
						}

						else continue ;
					}

					else continue ;
				}

				else continue ;
			}

			else continue ;
		}
	}

	return true ;
}

// For use in hooked modules:

Boombox_GetRadioChannelName(id) {
	return RadioChannels [ id ] [ radioch_name ] ;
}