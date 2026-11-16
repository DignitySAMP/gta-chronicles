
// This is a tick that's ongoing (see player hooks).
OnPlayerRefuelCar(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] ) {
		if ( IsPlayerInAnyVehicle ( playerid ) && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) {
			new fuelid = Fuel_GetNearestPump(playerid, 10.0);

			if ( fuelid != INVALID_FUEL_STATION_ID ) {

				new vehicleid = GetPlayerVehicleID(playerid);
				new veh_enum_id = Vehicle_GetEnumID ( vehicleid );	

				if ( veh_enum_id == -1 ) {

					PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] = false ;
					return ;
				}

				if ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] + 2 > GetPlayerCash ( playerid ) ) {

					PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] = false ;
					return ;
				}

				Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]  ++ ;
				PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] += 2 ;

				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] >= 100 ) {

					Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] = 100 ;
					PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] = false ;
				}

				PlayerTextDrawSetString(playerid, fuel_player_gui[playerid][7], 
					sprintf("~b~%d '/.~n~~g~$%s__", Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] ,
					IntegerWithDelimiter(PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ])
				));
					

				PlayerTextDrawShow(playerid, fuel_player_gui[playerid][7]);
				Fuel_UpdateExtraFiller(playerid, Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]);
			}
		}
	}

	else if ( !  PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] ) {

		if ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) {

			if ( IsPlayerInAnyVehicle ( playerid ) && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) {
				new fuelid = Fuel_GetNearestPump(playerid, 10.0);

				if ( fuelid != INVALID_FUEL_STATION_ID && FuelStation_LinkSQLIDToEnum( FuelPump [ fuelid ] [ E_FUEL_PUMP_MANAGER_ID ] ) != INVALID_FUEL_MANAGER_ID ) {
					new station_idx =  FuelStation_LinkSQLIDToEnum( FuelPump [ fuelid ] [ E_FUEL_PUMP_MANAGER_ID ] ), query [ 256 ] ;

					// Subtracting 30% of the total from the full value for end gain.
					new cost_after_taxes = PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] - ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] / 100 * 30 );

					// This didn't work because station_idx was previously E_PUMP_MANAGER_ID (sql).
					FuelStation [ station_idx ] [ E_FUEL_STATION_INCOME ] += cost_after_taxes ;

					mysql_format(mysql, query, sizeof ( query ), "UPDATE fuelmanager SET fuelmanager_income = %d WHERE fuelmanager_id = %d",
						FuelStation [ station_idx ] [ E_FUEL_STATION_INCOME ], FuelStation [ station_idx ] [ E_FUEL_STATION_ID ] 
					) ;

					mysql_tquery(mysql, query);
				}
			}
			Fuel_OnHidePlayerGui_Extra(playerid);

			ShowPlayerInfoMessage(playerid, sprintf("You have paid ~g~$%s~w~ for your vehicle's fuel.", 
				IntegerWithDelimiter(PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ])), .height=285.0, .width = 200.0, .showtime = 6000);
			
			TakePlayerCash ( playerid, PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) ;
			PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ]  = 0 ;				
		}
	}

}

Fuel_OnPlayerExitCar(playerid) {
	if ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) {

		if ( IsPlayerInAnyVehicle ( playerid ) && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) {
			new fuelid = Fuel_GetNearestPump(playerid, 10.0);

			if ( fuelid != INVALID_FUEL_STATION_ID && FuelStation_LinkSQLIDToEnum( FuelPump [ fuelid ] [ E_FUEL_PUMP_MANAGER_ID ] ) != INVALID_FUEL_MANAGER_ID ) {
				new station_idx =  FuelStation_LinkSQLIDToEnum( FuelPump [ fuelid ] [ E_FUEL_PUMP_MANAGER_ID ] ), query [ 256 ] ;

				// Subtracting 30% of the total from the full value for end gain.
				new cost_after_taxes = PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] - ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] / 100 * 30 );

				// This didn't work because station_idx was previously E_PUMP_MANAGER_ID (sql).
				FuelStation [ station_idx ] [ E_FUEL_STATION_INCOME ] += cost_after_taxes ;

				mysql_format(mysql, query, sizeof ( query ), "UPDATE fuelmanager SET fuelmanager_income = %d WHERE fuelmanager_id = %d",
					FuelStation [ station_idx ] [ E_FUEL_STATION_INCOME ], FuelStation [ station_idx ] [ E_FUEL_STATION_ID ] 
				) ;

				mysql_tquery(mysql, query);
			}
		}

		Fuel_OnHidePlayerGui_Extra(playerid);
		ShowPlayerInfoMessage(playerid, sprintf("You have paid ~g~$%s~w~ for your vehicle's fuel.", 
			IntegerWithDelimiter(PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ])), .height=285.0, .width = 200.0, .showtime = 6000);
		
		TakePlayerCash ( playerid, PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) ;
		PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ]  = 0 ;				
	}
}

static const HighFuelVehicles[] = 
{
	461,
	468,
	471,
	521,
	522,
	581,
	402,
	411,
	415,
	429,
	451,
	477,
	494,
	502,
	503,
	506,
	541,
	558,
	559,
	565,
	587,
	602,
	603,
	488, // maverick
	488, // news maverick
	497, // pol maverick
	520, // hydra
	563, // raindance
	593, // dodo
	512, // crop duster
	513  // stuntplane
};

IsHighFuelVehicle(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	for (new i = 0, j = sizeof(HighFuelVehicles); i < j; i ++)
	{
		if (HighFuelVehicles[i] == model) return true;
	}

	return false;
}

Fuel_ConsumeVehicleFuel(vehicleid)
{

	new veh_enum_id = Vehicle_GetEnumID(vehicleid);
	if (veh_enum_id == -1 || !IsValidVehicle(vehicleid) || !IsEngineVehicle(vehicleid) || !GetEngineStatus(vehicleid)) return 0;

	new high_fuel = IsHighFuelVehicle(vehicleid);

	// 24/06/22 CopaCabana suggested reducing the time it takes for fuel to go down. 
	// Adds a "skip" every time consume fuel gets triggered.
	if (VehicleVar [ veh_enum_id ] [ E_VEHICLE_LAST_FUEL_TICK ] && !high_fuel) 
	{
		VehicleVar [ veh_enum_id ] [ E_VEHICLE_LAST_FUEL_TICK ] = false ;
		return true ;
	}

	VehicleVar [ veh_enum_id ] [ E_VEHICLE_LAST_FUEL_TICK ] = true ;

	Vehicle[veh_enum_id][E_VEHICLE_FUEL] --;

	if (random(10) == 0 || (high_fuel && random(5) != 0))
	{
		// extra consumption for sports cars etc
		Vehicle[veh_enum_id][E_VEHICLE_FUEL] --;
	}

	if (Vehicle[veh_enum_id][E_VEHICLE_FUEL] <= 0) 
	{
		SetEngineStatus(vehicleid, false);

		foreach(new playerid: Player) 
		{
			if ( IsPlayerInVehicle ( playerid, vehicleid ) && GetVehicleDriver ( vehicleid ) == playerid ) 
			{
				ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** The engine shuts off with a loud bang, and the %s comes to a stop.", ReturnVehicleName ( vehicleid )));
				SendServerMessage(playerid, COLOR_BLUE, "Fuel", "A3A3A3", "You're out of fuel. Find someone to tow your car to a gas station or use a gascan." ) ;
			}
		}
	}
	else if (Vehicle[veh_enum_id][E_VEHICLE_FUEL] <= 5)
	{
		foreach(new playerid: Player) 
		{
			if ( IsPlayerInVehicle ( playerid, vehicleid ) && GetVehicleDriver ( vehicleid ) == playerid ) 
			{
				ShowPlayerSubtitle(playerid, sprintf("~r~Your %s is running very low on fuel.", ReturnVehicleName(vehicleid)), 5000);
			}
		}
	}

	return 1;
}

static fuelquery[256];

Fuel_UpdateVehicleFuel(veh_enum_id) 
{
	new vehicleid = Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ;

	if (veh_enum_id == -1)
	{
		return false;
	}

	if (!IsValidVehicle(vehicleid)) 
	{
		return false ;
	}

	if (!IsEngineVehicle(vehicleid)) 
	{
		return false ;
	}

	if (!GetEngineStatus(vehicleid))
	{
		return false ;
	}

	// Base fuel consumption of 1 per tick (minute), or 1/2 chance if vehicle is idle
	if (random(2) == 0 || GetVehicleSpeedSOLS(vehicleid) > 1.0)
	{
		Fuel_ConsumeVehicleFuel(vehicleid);
	}

	mysql_format(mysql, fuelquery, sizeof ( fuelquery), "UPDATE vehicles SET vehicle_fuel = %d, vehicle_mileage = %d WHERE vehicle_sqlid = %d",
			Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ], Vehicle [ veh_enum_id ] [ E_VEHICLE_MILEAGE ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] );

	mysql_tquery(mysql, fuelquery);

	return true ;
}