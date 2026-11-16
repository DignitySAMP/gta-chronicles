CMD:unrentvehicle(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new vehicleid = GetPlayerVehicleID ( playerid ) ;
	new veh_enum_id = Vehicle_GetEnumID (vehicleid);

	if ( ! IsPlayerInAnyVehicle(playerid) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "You're not in a vehicle.");
		return true ;
	}

	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "The passed ID isn't valid. Vehicle may not be set up.");
	}
	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] != E_VEHICLE_TYPE_RENTAL ) {

		SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "This vehicle isn't rentable.");
		return true ;
	}				

	if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] != playerid ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You have not rented this vehicle!");
	}

	SendServerMessage ( playerid, COLOR_INFO, "Info", "A3A3A3", "You have unrented the vehicle. Thanks for keeping the server clean! Half the rent price refunded!");
	GivePlayerCash ( playerid, SERVER_VEH_RENT_FEE / 2 )  ;

	ProxDetectorVehicle( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], 15.0, COLOR_VEHICLE, sprintf(" * The rental %s has been respawned.", ReturnVehicleName ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) ) ) ;
	SOLS_SetVehicleToRespawn( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], "rental respawn" ) ;

	VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] = INVALID_PLAYER_ID ;
	VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTUNIX ] = 0 ;	


    SetEngineStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], false);

	return true ;
}

CMD:rentvehicle(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID ( playerid ) ;
	new veh_enum_id = Vehicle_GetEnumID (vehicleid);

	if ( ! IsPlayerInAnyVehicle(playerid) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "You're not in a vehicle.");
		return true ;
	}

	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "The passed ID isn't valid. Vehicle may not be set up.");
	}

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] != E_VEHICLE_TYPE_RENTAL ) {

		SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "This vehicle isn't rentable.");
		return true ;
	}

	if ( GetPlayerCash ( playerid) < SERVER_VEH_RENT_FEE ) {

		SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", sprintf("You don't have enough money for this action. You need at least $%d.", SERVER_VEH_RENT_FEE ));
		return true ;
	}


	for_loop (new i,j = sizeof ( Vehicle ); i < j; i ++ ) {


		if ( VehicleVar [ i ] [ E_VEHICLE_RENTEDBY ] == playerid ) {

			SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "You've already rented a vehicle. Use /unrentvehicle first.");
			return true ;
		}
	}

	if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] != INVALID_PLAYER_ID ) {

		if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] != playerid ) {

			SendServerMessage ( playerid, COLOR_ERROR, "ERROR", "A3A3A3", "This vehicle is already rented to someone else.");
			return true ;	
		}
	}

	else if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] == INVALID_PLAYER_ID ) {

		TakePlayerCash ( playerid, SERVER_VEH_RENT_FEE ) ;

		VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] = playerid ;
		VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTUNIX ] = gettime() + 1800 ;
		SendClientMessage(playerid, COLOR_INFO, 
			sprintf("You have rented this %s. It will be unrented in 30 minutes. Use /unrentvehicle to get back part of the fee!",  
				ReturnVehicleName ( vehicleid ) 
			)
		) ;

	}

	return true ;
}

// Called for /engine, /carlock. Make it so onplayerdisconnect also resets shit.
// Make a task that runs every second (like player_hooks) and put this under it.
Rental_CheckForExpiration(veh_enum_id) {

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_RENTAL ) {
		if ( ! IsValidVehicle ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) ) {

			return true ;
		}

		if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] != INVALID_PLAYER_ID ) {
			if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTUNIX ] < gettime() ) {

				if ( IsVehicleOccupied ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) ) {

					return true ;
				}

				if ( IsPlayerConnected ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] ) ) {

					SendClientMessage ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ], COLOR_RED, "The vehicle you have rented has expired. It has been respawned.");
				}	

				ProxDetectorVehicle( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], 15.0, COLOR_VEHICLE, sprintf(" * The rental %s has been respawned.", ReturnVehicleName ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) ) ) ;
				SOLS_SetVehicleToRespawn( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], "rental expire" ) ;

				VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] = INVALID_PLAYER_ID ;
				VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTUNIX ] = 0 ;	

    			SetEngineStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], false);
			}
		}
	}

	return true ;
}

public OnPlayerDisconnect(playerid, reason) {
	for ( new veh_enum_id, j = sizeof ( Vehicle ); veh_enum_id < j ; veh_enum_id ++ ) {


		if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_RENTAL ) {
			if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] == playerid ) {
				ProxDetectorVehicle( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], 15.0, COLOR_VEHICLE, sprintf(" * The rental %s has been respawned.", ReturnVehicleName ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) ) ) ;
				SOLS_SetVehicleToRespawn( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], "rental disconnect" ) ;

				VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] = INVALID_PLAYER_ID ;
				VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTUNIX ] = 0 ;	

    			SetEngineStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], false);
			}
		}
	}

	#if defined rental_OnPlayerDisconnect
		return rental_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect rental_OnPlayerDisconnect
#if defined rental_OnPlayerDisconnect
	forward rental_OnPlayerDisconnect(playerid, reason);
#endif