enum {

	BOOMBOX_MODEL_BLACK = 2102,
	BOOMBOX_MODEL_GREY = 2103,
	BOOMBOX_MODEL_RED = 2226
}

#include "boombox/data.pwn"
#include "boombox/channels.pwn"
#include "boombox/native.pwn"
#include "boombox/claim.pwn"


CMD:boomboxremove(playerid, params[]) {

	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new boombox_id = Boombox_GetNearestEntity(playerid);

	new vehicleid, veh_enum_id ;

	if (boombox_id != INVALID_BOOMBOX_ID ) {

		ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has admin removed a boombox.", ReturnPlayerNameData ( playerid ) ) );
   	 	WriteLog ( playerid, "boombox", sprintf("%s has admin removed a boombox.", ReturnPlayerNameData ( playerid ) ) );

		foreach(new targetid: Player) {
			if ( IsPlayerInAnyDynamicArea ( targetid ) ) {

				if ( Boombox [ boombox_id ] [ E_BOOMBOX_ID ] != INVALID_BOOMBOX_ID ) {

					if ( IsPlayerInDynamicArea(targetid, Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ) {


						if ( PlayerVar [ targetid ] [ E_PLAYER_LISTENING_BOOMBOX ] == boombox_id ) {

							if ( IsPlayerInAnyVehicle(targetid) ) {			
								vehicleid = GetPlayerVehicleID ( targetid );
								veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

								if ( strlen ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_STATION ] ) < 3 ) {

									SOLS_StopAudioStreamForPlayer(targetid);
								}

								else continue ;
							}

							else SOLS_StopAudioStreamForPlayer(targetid);
						}
					}
					else continue ;
				}
				else continue ;

			}
		}


		if ( IsValidDynamicObject ( Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] ) ) {
			DestroyDynamicObject ( Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] ) ;
			Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] = INVALID_STREAMER_ID ;
		}
		
		if ( IsValidDynamic3DTextLabel ( Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] ) ) {

			DestroyDynamic3DTextLabel ( Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] ) ;
			Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] =  DynamicText3D: INVALID_3DTEXT_ID ;
		}		
		if ( IsValidDynamicArea ( Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ) {

			DestroyDynamicArea ( Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ;
			Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] = -1 ;
		}
		Boombox [ boombox_id ] [ E_BOOMBOX_ID ] = INVALID_BOOMBOX_ID ;

		if ( Boombox_ReclaimTimer [ boombox_id ] ) {

			stop Boombox_ReclaimTimer [ boombox_id ] ;
			Boombox_ReclaimTimer [ boombox_id ] = Timer: 0 ;
		}
	}

	return true ;
}

CMD:boombox(playerid, params[]) {

	if ( IsValidDynamicObject( PlayerVar [ playerid ] [ E_PLAYER_PLACING_BOOMBOX ] ) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Finish or cancel placing your boombox first.");
	}
	
	new boombox_id = Boombox_GetNearestEntity(playerid);

	if ( boombox_id != INVALID_BOOMBOX_ID ) {

		if ( Boombox [ boombox_id ] [ E_BOOMBOX_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

			ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has picked up their boombox.", ReturnPlayerNameData ( playerid, 0, true ) ) );
	 		WriteLog ( playerid, "boombox", sprintf("%s has removed their boombox.", ReturnPlayerNameData ( playerid, 0, true ) ) );

	 		new veh_enum_id, vehicleid ;

			foreach(new targetid: Player) {
				if ( IsPlayerInAnyDynamicArea ( targetid ) ) {


					if ( Boombox [ boombox_id ] [ E_BOOMBOX_ID ] != INVALID_BOOMBOX_ID ) {

						if ( IsPlayerInDynamicArea(targetid, Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ) {

							if ( PlayerVar [ targetid ] [ E_PLAYER_LISTENING_BOOMBOX ] == boombox_id ) {
								if ( IsPlayerInAnyVehicle(targetid) ) {		
									
									vehicleid = GetPlayerVehicleID ( targetid );
									veh_enum_id = Vehicle_GetEnumID(vehicleid) ;


									if ( strlen ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_STATION ] ) < 3 ) {

										SOLS_StopAudioStreamForPlayer(targetid);
									}

									else continue ;
								}

								else SOLS_StopAudioStreamForPlayer(targetid);
							}
							else continue ;	
						}
						else continue ;	
					}
					else continue ;

				}
			}

			PlayerVar [ playerid ] [ player_hasboombox ] = Boombox [ boombox_id ] [ E_BOOMBOX_TYPE ] ;
			Boombox [ boombox_id ] [ E_BOOMBOX_ID ] = INVALID_BOOMBOX_ID ;

			if ( IsValidDynamicObject ( Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] ) ) {
				DestroyDynamicObject ( Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] ) ;
				Boombox [ boombox_id ] [ E_BOOMBOX_OBJECTID ] = INVALID_STREAMER_ID ;
			}
			
			if ( IsValidDynamic3DTextLabel ( Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] ) ) {

				DestroyDynamic3DTextLabel ( Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] ) ;
				Boombox [ boombox_id ] [ E_BOOMBOX_LABEL ] =  DynamicText3D: INVALID_3DTEXT_ID ;
			}		
			if ( IsValidDynamicArea ( Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ) {

				DestroyDynamicArea ( Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] ) ;
				Boombox [ boombox_id ] [ E_BOOMBOX_AREAID ] = -1 ;
			}
		}
	}

	else if ( boombox_id == INVALID_BOOMBOX_ID ) {

		new modelid ; 

		new type = PlayerVar [ playerid ] [ player_hasboombox ] ;
		switch ( type ) {

			case 1: modelid = BOOMBOX_MODEL_RED ;
			case 2: modelid = BOOMBOX_MODEL_GREY ;
			case 3: modelid = BOOMBOX_MODEL_BLACK ;
			default: {

				//return SendClientMessage(playerid, COLOR_ERROR, "Invalid type passed! Use /boombox to see available types.");
				return SendClientMessage(playerid, COLOR_ERROR, "You don't have a boombox! Buy one from the Music Store at the Mall!");
			}
		}

		new Float: x, Float: y, Float: z ;
		GetPlayerPos(playerid, x, y, z ) ;
		GetXYInFrontOfPlayer ( playerid, x, y, 5.0 ) ; 

		Boombox_CreateEntity(playerid, modelid, PlayerVar [ playerid ] [ player_hasboombox ], x, y, z ) ;
	}

	return true ;
}