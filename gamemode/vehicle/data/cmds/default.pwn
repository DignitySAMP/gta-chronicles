

CMD:carcheck(playerid, params[]) {

	new vehicleid = Vehicle_GetClosestEntity(playerid);
	new veh_enum_id = Vehicle_GetEnumID (vehicleid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any proper vehicle! (couldn't fetch ID)");
	}

	SendClientMessage(playerid, COLOR_VEHICLE, "--------------------- Vehicle Info -----------------------");
	SendClientMessage(playerid, COLOR_ERROR, sprintf("[Vehicle Name]:{DEDEDE} %s", ReturnVehicleName ( vehicleid ) ));


	SendClientMessage(playerid, COLOR_ERROR, sprintf("[Windows]:{DEDEDE} %s", 
		(Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ]) ? ("Up") : ("Down") ) ) ;

	SendClientMessage(playerid, COLOR_ERROR, sprintf("[Doors]:{DEDEDE} %s", 
		(Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ]) ? ("Locked") : ("Unlocked") ) ) ;

	new driver_id = GetVehicleDriver ( vehicleid ) ;

	if ( driver_id != INVALID_PLAYER_ID ) {

		SendClientMessage(playerid, COLOR_ERROR, sprintf("[Seatbelt (Driver)]:{DEDEDE} %s", 
			(PlayerVar [ driver_id ] [ player_hasseatbelton ]) ? ("On") : ("Off") ) ) ;
	}

	else SendClientMessage ( playerid, COLOR_ERROR, "[Seatbelt (Driver)]:{DEDEDE} No Driver");

	SendClientMessage(playerid, COLOR_HINT,  sprintf("[License Plate]:{DEDEDE} %s", Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ]));

	SendClientMessage(playerid, COLOR_VEHICLE, "--------------------------------------------------------------");

	if (Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED ])
	{
		new year, month, day, hour, minute, second, date[64];
		stamp2datetime(Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_UNTIL], year, month, day, hour, minute, second, 1);
		format(date, sizeof(date), "%d/%d/%d - %d:%d:%d", day, month, year, hour, minute, second);

		SendClientMessage(playerid, COLOR_YELLOW, 
			sprintf("[Impound]{DEDEDE} [Until: %s] [Cost: $%s] [By: %s] [Reason: %s]", 
			date, IntegerWithDelimiter(Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST]), Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_BY], Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_REASON])
		);
	}

	if (GetPlayerAdminLevel(playerid))
	{
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("[Admin]{DEDEDE} [Vehicle ID: %d] [SQL ID: %d] [Owner Character ID: %d]",
			Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] ));
	}

	return true ;
}

CMD:toolkit(playerid) 
{
	if ( ! PlayerVar [ playerid ] [ E_PLAYER_HAS_TOOLKIT ] ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a toolkit! Buy one from a Hardware Store.");
	}

	new vehicleid = Vehicle_GetClosestEntity(playerid, 5.0);
	new veh_enum_id = Vehicle_GetEnumID(vehicleid);

	if (vehicleid == INVALID_VEHICLE_ID || veh_enum_id == -1) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if (IsAircraft(vehicleid) || !IsEngineVehicle(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You can't use a toolkit on an aircraft or a vehicle without an engine.");
	}

	new Float: health ;
	GetVehicleHealth(vehicleid, health);

	if (health > 300 || GetEngineStatus(vehicleid)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "You can only use a toolkit on a damaged vehicle that won't start.");
	}

	if (IsACar(vehicleid) && !GetHoodStatus(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "The hood must be open before you can use a toolkit on this vehicle.");
	}

	Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] = 400;
	PlayerVar [ playerid ] [ E_PLAYER_HAS_TOOLKIT ] = false;
	SOLS_SetVehicleHealth(vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ]);

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query), "UPDATE vehicles SET vehicle_health = '%f' WHERE vehicle_sqlid = %d",
		Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] );

	mysql_tquery(mysql, query);

	ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s uses a toolkit to restart the engine of the %s.", SOLS_PlayerName(playerid), ReturnVehicleName (vehicleid)));
	SendServerMessage(playerid, COLOR_BLUE, "Toolkit", "A3A3A3", "Your toolkit has been used up.");
	return true;
}

CMD:neon(playerid, params[]) {

	if ( !IsPlayerAdmin(playerid)) {

		return false ;
	}

	new vehicleid = GetPlayerVehicleID(playerid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not in any vehicle!");
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );


	new color ;

	if ( sscanf ( params, "i", color ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/neon [color]");
		SendClientMessage(playerid, COLOR_GRAD0, "0: None - 1: pink - 2: yellow - 3: green - 4: red - 5: white - 6: blue");
		return true ;
	}

	if ( color < 0 || color > 6 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Color can't be less than 0 or more than 5.");
	}

	new objectid ;

	switch ( color ) {

		case 0: {

			if ( IsValidDynamicObject ( Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 0 ]) ) {

				SOLS_DestroyObject(Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 0 ], "Vehicle/Neon", true ) ;
			}
			if ( IsValidDynamicObject ( Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 1 ]) ) {
				
				SOLS_DestroyObject(Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 1 ], "Vehicle/Neon", true ) ;
			}

	 		SendServerMessage ( playerid, COLOR_VEHICLE, "Neon", "A3A3A3", "Neon removed!");
	
			return true ;
		}

		case 1: objectid = 18651 ;
		case 2: objectid = 18650 ;
		case 3: objectid = 18649 ;
		case 4: objectid = 18657 ;
		case 5: objectid = 18652 ;
		case 6: objectid = 18648 ;
	}

	Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 0 ] = CreateDynamicObject(objectid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	AttachDynamicObjectToVehicle(Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 0 ], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);

	Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 1 ] = CreateDynamicObject(objectid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	AttachDynamicObjectToVehicle(Vehicle [ veh_enum_id ] [ E_VEHICLE_NEON ] [ 1 ], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);

	SendServerMessage ( playerid, COLOR_VEHICLE, "Neon", "A3A3A3", "Neon attached!");    

	return true ;      
}


CMD:cws(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:window(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:windows(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:rollwindow(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:rollwindows(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:carwindows(playerid, params[]) return cmd_carwindow(playerid, params);
CMD:carwindow(playerid,params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID(playerid) ;
	new veh_enum_id = Vehicle_GetEnumID (vehicleid);
	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any proper vehicle! (couldn't fetch ID)");
	}
	if (!IsWindowedVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "You are not in any vehicle with windows.");

    if(sscanf(params, "d", params[0]))
    {
        SendClientMessage(playerid,-1,"/(car/roll)window(s) [0, 1-2-3-4]");
        SendClientMessage(playerid,-1,"0 - All | 1 - Driver window | 2 - Passenger window | 3 - Rear-left window | 4 - Rear-right window");
        return 1;
    }
    if(params[0] > 4 || params[0] < 0) return SendClientMessage(playerid,-1,"0 - All | 1 - Driver window | 2 - Passenger window | 3 - Rear-left window | 4 - Rear-right window");
    new driver, passenger, backleft, backright;
    GetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
    switch(params[0])
    {
    	case 0: {

    		if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {

    			Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] = false ;
    			driver = 0, passenger = 0, backleft = 0, backright = 0 ;
    		}

    		else { 
    			driver = 1, passenger = 1, backleft = 1, backright = 1 ;
    			Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] = true ;
    		}
    	}
        case 1: driver = !driver ? (1) : (0);
        case 2: passenger = !passenger ? (1) : (0);
        case 3: backleft = !backleft ? (1) : (0);
        case 4: backright = !backright ? (1) : (0);
    }
	switch(params[0])
	{
		case 0: {
			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] ) {
				//ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds up the windows of the %s.", ReturnPlayerNameData (  playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
				ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls up the windows of the %s.", ReturnVehicleName ( vehicleid )), true);
			}

			//else ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds down the windows of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
			else ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls down the windows of the %s.", ReturnVehicleName ( vehicleid )), true);
		}

		case 1: { 
			if ( driver ) {

				//ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds up the front-left window of the %s.", ReturnPlayerNameData (  playerid, 0, true  ), ReturnVehicleName ( vehicleid ) ) );
				ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls up the front-left window of the %s.", ReturnVehicleName ( vehicleid )), true);
        	}

        	//else ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds down the front-left window of the %s.", ReturnPlayerNameData (  playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
			else ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls down the front-left window of the %s.", ReturnVehicleName ( vehicleid )), true);
        }

        case 2: { 
        	if ( passenger ) {
        		//ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds up the front-right window of the %s.", ReturnPlayerNameData (  playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
				ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls up the front-right window of the %s.", ReturnVehicleName ( vehicleid )), true);
        	}

        	//else ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds down the front-right window of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
			else ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls down the front-right window of the %s.", ReturnVehicleName ( vehicleid )), true);
        }

        case 3: { 
        	if ( backleft ) {
        		//ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds up the rear-left window of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
				ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls up the back-left window of the %s.", ReturnVehicleName ( vehicleid )), true);
        	}

        	//else ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds down the rear-left window of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
			else ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls down the back-left window of the %s.", ReturnVehicleName ( vehicleid )), true);
        }

        case 4: { 
	    	if ( backright ) {
	     	   	//	ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds up the rear-right window of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
				ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls up the back-right window of the %s.", ReturnVehicleName ( vehicleid )), true);
			}

			//else ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s winds down the rear-right window of the %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnVehicleName ( vehicleid ) ) );
			else ProxDetectorAutoMe(playerid, 30.0, sprintf("rolls down the back-right window of the %s.", ReturnVehicleName ( vehicleid )), true);
		}
	}

	if ( driver == 0 || passenger == 0 || backleft == 0 || backright == 0 ) {

		Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] = false ;
	}

	else if ( driver == 1 && passenger == 1 && backleft == 1 && backright == 1 ) {

		Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ] = true ;
	}

    SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), driver, passenger, backleft, backright);
    //Vehicle_OnPlayerUpdateGUI(playerid, vehicleid);
    return 1;
}


CMD:helmet(playerid, params[]) {

	return cmd_seatbelt(playerid, params);
}

CMD:sb(playerid, params[]) {

	return cmd_seatbelt(playerid, params);
}

CMD:seatbelt(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID ( playerid ) ;

	if ( ! vehicleid ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not in a vehicle!");
	}

	new specifier [ 32] ;
	PlayerVar [ playerid ] [ player_hashelmet ] = false ;

	switch ( PlayerVar [ playerid ] [ player_hasseatbelton ] ) {

		case false: {

			if ( IsABike ( vehicleid ) ) {

			    format ( specifier, sizeof ( specifier ), "helmet" ) ;
			    SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM, 18645, 2, 0.101, -0.0, 0.0, 5.50, 84.60, 83.7, 1, 1, 1);
				PlayerVar [ playerid ] [ player_hashelmet ] = true ;
			}

			else format ( specifier, sizeof ( specifier ), "seatbelt" ) ;
			PlayerVar [ playerid ] [ player_hasseatbelton ] = true ;


			//format ( string, sizeof ( string ), "** %s has put their %s on.", ReturnPlayerNameData( playerid, 0, true ), specifier ) ;
			ProxDetectorAutoMe(playerid, 30.0, sprintf("puts their %s on.", specifier), true);
		}

		case true : {
			if ( IsABike ( vehicleid ) ) {

			    format ( specifier, sizeof ( specifier ), "helmet" ) ;
				RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM);
			}

			else format ( specifier, sizeof ( specifier ), "seatbelt" ) ;
			
			PlayerVar [ playerid ] [ player_hasseatbelton ] = false ;

			//format ( string, sizeof ( string ), "** %s has taken their %s off.", ReturnPlayerNameData( playerid, 0, true ), specifier ) ;
			ProxDetectorAutoMe(playerid, 30.0, sprintf("takes their %s off.", specifier), true);
		}
	}

	//ProxDetector(playerid, 30.0, COLOR_PURPLE, string );

	//Vehicle_OnPlayerUpdateGUI(playerid, vehicleid) ;
	return true ;
}

CMD:cl(playerid, params[]) {

	return cmd_carlights(playerid, params);
}

CMD:carlights(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID ( playerid ) ;

	if ( ! vehicleid ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not in a vehicle!");
	}

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "You can't do this as you're not the driver.");

	switch (GetLightStatus(vehicleid))
	{
	    case false:
	    {
	        SetLightStatus(vehicleid, true);
	        //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s flicks a switch, turning the lights of the %s on.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
			ProxDetectorAutoMe(playerid, 30.0, sprintf("switches on the lights of the %s.", ReturnVehicleName ( vehicleid )));
		}
		case true:
		{
		    SetLightStatus(vehicleid, false);
		    //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s flicks a switch, turning the lights of the %s off.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
			ProxDetectorAutoMe(playerid, 30.0, sprintf("turns off lights of the %s.", ReturnVehicleName ( vehicleid )));
		}
	}

	return true ;
}

CMD:lights(playerid, params[])
{
	return cmd_carlights(playerid, params);
}


CMD:cartrunkrange(playerid, params[]) {

	new Float: range ;

	if ( sscanf ( params, "f", range ) ) {

		return SendClientMessage(playerid, -1, "/cartrunkrange[trunk-radius]" ) ;
	}

	new vehicleid = INVALID_VEHICLE_ID;

	if ( ! IsPlayerInAnyVehicle(playerid) ) {
		vehicleid = GetClosestVehicleEx(playerid, 7.5);
	}

	else vehicleid = GetPlayerVehicleID(playerid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if (IsAircraft(vehicleid) || IsABoat(vehicleid) || IsABike(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle doesn't have a trunk!");
	}

	new Float: x, Float: y, Float: z ;
	GetPosBehindVehicle ( vehicleid, x, y, z );

	if ( IsPlayerInRangeOfPoint(playerid, range, x, y, z ) || GetPlayerVehicleID(playerid) == vehicleid ) {

		return SendClientMessage(playerid, -1, sprintf("Found vehicle %d at trunk range %0.3f", vehicleid, range ) ) ;
	}

	return SendClientMessage(playerid, -1, "None found." ) ;
}


CMD:cartrunk(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
	new vehicleid = INVALID_VEHICLE_ID;

	if ( ! IsPlayerInAnyVehicle(playerid) ) {
		vehicleid = GetClosestVehicleEx(playerid, 7.5);
	}

	else vehicleid = GetPlayerVehicleID(playerid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if (IsAircraft(vehicleid) || IsABoat(vehicleid) || IsABike(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle doesn't have a trunk!");
	}

	new Float: x, Float: y, Float: z ;
	GetPosBehindVehicle ( vehicleid, x, y, z );

	new Float: range = 2.5 ;

	if ( IsPlayerInRangeOfPoint(playerid, range, x, y, z ) || GetPlayerVehicleID(playerid) == vehicleid ) {

		switch (GetTrunkStatus ( vehicleid )) {
		    case false: {

				if ( GetDoorStatus ( vehicleid ) ) {

					return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is locked.");
				}

				new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

				if (IsGovFactionVehicle(vehicleid) && Vehicle[veh_enum_id][E_VEHICLE_OWNER] != Character[playerid][E_CHARACTER_FACTIONID] && !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) 
				{
					return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is faction restricted.");
				}

				SendServerMessage ( playerid, COLOR_BLUE, "Car Trunk", "A3A3A3", "Available commands: /cartrunkstoregun (/ctsgun), /cartrunktakegun (/cttgun), /cartrunkcheck (/cartrunkshow)");
				SendClientMessage ( playerid, COLOR_BLUE, "New:{A3A3A3} /cartrunkstoredrug (/ctsdrug), /cartrunktakedrug (/cttdrug)");

		        SetTrunkStatus(vehicleid, true);
		        //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s pops the trunk of the %s open.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
				ProxDetectorAutoMe(playerid, 30.0, sprintf("pops open the trunk of the %s.", ReturnVehicleName ( vehicleid )));
			}
			case true:
			{
			    SetTrunkStatus(vehicleid, false);
			    //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s slams the trunk of the %s shut.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
				ProxDetectorAutoMe(playerid, 30.0, sprintf("pushes the trunk of the %s closed.", ReturnVehicleName ( vehicleid )));
			}
		}
	}

	else return SendClientMessage(playerid, COLOR_ERROR, "Not near trunk!");

	return true ;
}

CMD:trunk(playerid, params[])
{
	return cmd_cartrunk(playerid, params);
}

CMD:boot(playerid, params[])
{
	return cmd_cartrunk(playerid, params);
}

/*
CMD:cartrunk(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = INVALID_VEHICLE_ID;

	if ( ! IsPlayerInAnyVehicle(playerid) ) {

		vehicleid = Vehicle_GetClosestEntity(playerid, 5.0 );
	}

	else vehicleid = GetPlayerVehicleID(playerid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if ( IsABike(vehicleid) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle doesn't have a trunk!");
	}

	new Float: x, Float: y, Float: z ;
	GetPosBehindVehicle ( vehicleid, x, y, z );

	if ( IsPlayerInRangeOfPoint(playerid, 1.5, x, y, z ) || GetPlayerVehicleID(playerid) == vehicleid ) {

		switch (GetTrunkStatus ( vehicleid )) {
		    case false: {

				if ( GetDoorStatus ( vehicleid ) ) {

					return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is locked.");
				}

				SendServerMessage ( playerid, COLOR_BLUE, "Car Trunk", "A3A3A3", "Available commands: /cartrunkstoregun (/ctsgun), /cartrunktakegun (/cttgun), /cartrunkcheck (/cartrunkshow)");

		        SetTrunkStatus(vehicleid, true);
		        ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s pops the %s's trunk open.", ReturnPlayerNameData(playerid), ReturnVehicleName ( vehicleid )));
			}
			case true:
			{
			    SetTrunkStatus(vehicleid, false);
			    ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s slams the %s's trunk shut.", ReturnPlayerNameData(playerid), ReturnVehicleName ( vehicleid )));
			}
		}
	}

	else SendClientMessage(playerid, COLOR_ERROR, "Not near trunk!");

	return true ;
}*/
CMD:carhood(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new vehicleid = Vehicle_GetClosestEntity(playerid);

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if (IsAircraft(vehicleid) || IsABoat(vehicleid) || IsABike(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle doesn't have a hood!");
	}

	new Float: x, Float: y, Float: z ;
	GetPosInfrontVehicle ( vehicleid, x, y, z );

	if ( IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z ) ) {

		switch (GetHoodStatus ( vehicleid )) {
		    case false: {

				if ( GetDoorStatus ( vehicleid ) ) {

					return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is locked.");
				}

				new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

				if (IsGovFactionVehicle(vehicleid) && Vehicle[veh_enum_id][E_VEHICLE_OWNER] != Character[playerid][E_CHARACTER_FACTIONID] && !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) 
				{
					return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is faction restricted.");
				}

		        SetHoodStatus(vehicleid, true);
		        //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s pops the hood of the %s open.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
				ProxDetectorAutoMe(playerid, 30.0, sprintf("pops open the hood of the %s.", ReturnVehicleName ( vehicleid )));
			}
			case true:
			{
			    SetHoodStatus(vehicleid, false);
			    //ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s slams the hood of the %s shut.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
				ProxDetectorAutoMe(playerid, 30.0, sprintf("pushes the hood of the %s closed.", ReturnVehicleName ( vehicleid )));
			}
		}
	}

	else SendClientMessage(playerid, COLOR_ERROR, "Not near hood!");

	return true ;
}

CMD:hood(playerid, params[])
{
	return cmd_carhood(playerid, params);
}

CMD:bonnet(playerid, params[])
{
	return cmd_carhood(playerid, params);
}

CMD:carattach(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if( !IsPlayerInAnyVehicle(playerid) )
	{
	    SendClientMessage(playerid, COLOR_ERROR, "You're not in a tow truck.") ;
	    return 1;
	}

	new Float:Px,Float:Py,Float:Pz;
	GetPlayerPos(playerid,Px,Py,Pz);
	new Float:vX,Float:vY,Float:vZ;

	if ( GetVehicleModel( GetPlayerVehicleID( playerid ) ) != 525 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle isn't powerful enough to tow other cars. Get inside a towtruck.");
	}	

	new veh_enum_id ;

	for_loop ( new i, j = sizeof ( Vehicle ); i < j ; i ++ ) {

		if ( ! IsValidVehicle ( i ) ) {

			continue ;
		}

		GetVehiclePos(i,vX,vY,vZ);

		if ( ( floatabs ( Px - vX ) < 7.0 ) && ( floatabs ( Py - vY ) < 7.0 ) && ( floatabs ( Pz - vZ ) < 7.0 ) && ( i != GetPlayerVehicleID ( playerid ) ) ) {

			veh_enum_id = Vehicle_GetEnumID(i) ;

			if ( veh_enum_id == -1 ) {

				SendClientMessage(playerid, COLOR_ERROR, "You can't attach this car (invalid enum ID).");
				return true ;
			}

			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] == i ) {

				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] != E_VEHICLE_TYPE_PLAYER ) {

					SendClientMessage(playerid, COLOR_ERROR, "You can only attach player vehicles.") ;
					return true ;
				}

				if ( IsVehicleOccupied (  Vehicle [ veh_enum_id] [ E_VEHICLE_ID ] ) ) {
					SendClientMessage(playerid, COLOR_ERROR, "This vehicle is occupied. You can only attach unoccupied vehicles.") ;
					return true ;
				}

				if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) {

					SetDoorStatus ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ] );
					DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
					SendClientMessage(playerid,COLOR_YELLOW,"Car untowed!");
					return true ;
				}

				else {
					AttachTrailerToVehicle(i,GetPlayerVehicleID(playerid));
					SendClientMessage(playerid,COLOR_YELLOW,"You've towed a car!");
					SendAdminWarning(sprintf("[AdmWarn]: (%d) %s has attached vehicle ID %d to their car.", playerid, ReturnPlayerNameData(playerid), i ) );
					SetDoorStatus ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], true );

					return true ;
				}
			}
		}
	}

	SendClientMessage(playerid, COLOR_ERROR, "You're not near any valid vehicle.") ;

	return 1;
}

CMD:tow(playerid, params[]) return cmd_carattach(playerid, params);

forward SOLS_OnVehicleDoorUsed(playerid, vehicleid, seat);
public SOLS_OnVehicleDoorUsed(playerid, vehicleid, seat)
{
	// Hookable
	return true;
}

CMD:cardoor(playerid, params[]) 
{
	if ( IsPlayerIncapacitated(playerid) )  return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;

	new vehicleid = INVALID_VEHICLE_ID;
	new seat = -1, newstate = -1;
	// new lf, rf, lr, rr;

	if ( ! IsPlayerInAnyVehicle(playerid) ) {
		vehicleid = GetClosestVehicleEx(playerid, 5.0);
	}

	else vehicleid = GetPlayerVehicleID(playerid);

	if (vehicleid == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	if (!IsACar(vehicleid) || !DoesVehicleHaveDoors(vehicleid)) return SendClientMessage(playerid, COLOR_ERROR, "This vehicle doesn't have doors.");
	if (GetDoorStatus ( vehicleid ) ) return SendClientMessage(playerid, COLOR_ERROR, "The vehicle doors are locked.");

	new veh_enum_id = Vehicle_GetEnumID (vehicleid);
	if ( veh_enum_id == -1 ) return SendClientMessage(playerid, COLOR_ERROR, "You're not near any proper vehicle! (couldn't fetch ID)");

	if (GetPlayerVehicleID(playerid) == vehicleid)
	{
		seat = GetPlayerVehicleSeat(playerid);
	} 
	else
	{
		seat = GetVehicleClosestSeatToPlayer(vehicleid, playerid);
	}
		
	if (!strcmp(params, "open", true))
	{
		newstate = VEHICLE_PARAMS_ON;
	}
	else if (!strcmp(params, "close", true))
	{
		newstate = VEHICLE_PARAMS_OFF;
	}
	else if (params[0] != 1)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/cardoor [open/close]");
	}

	if (seat != -1 && seat < 4)
	{
		new oldstate = IsVehicleDoorOpen(vehicleid, seat, false, veh_enum_id);
		if (newstate == -1) newstate = (oldstate == VEHICLE_PARAMS_ON ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON);
		SetVehicleDoorOpen(vehicleid, seat, newstate, veh_enum_id);

        if (newstate == VEHICLE_PARAMS_ON)
	    {
	    	//ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s opens the door of the %s.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
			ProxDetectorAutoMe(playerid, 30.0, sprintf("opens the door of the %s.", ReturnVehicleName ( vehicleid )));
	    }
	    else
	    {
	        //ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s closes the door of the %s.", ReturnPlayerNameData( playerid, 0, true ), ReturnVehicleName ( vehicleid )));
			ProxDetectorAutoMe(playerid, 30.0, sprintf("closes the door of the %s.", ReturnVehicleName ( vehicleid )));
	    }

		Vehicle[veh_enum_id][E_VEHICLE_DOOR_STATE][seat] = newstate;
		CallLocalFunction("SOLS_OnVehicleDoorUsed", "ddd", playerid, vehicleid, seat);
	}

	return true ;
}

CMD:vehiclename(playerid, params[]) {

	new vehicleid = GetPlayerVehicleID ( playerid ) ;

	if (!vehicleid){
		return SendClientMessage(playerid, COLOR_ERROR, "You're not in a vehicle!");
	}

    new modelid = GetVehicleModel(vehicleid);

	new string[64];
	format(string, sizeof(string), "Current Vehicle:{DEDEDE} %s [%d]", ReturnVehicleName(vehicleid), modelid);
	SendClientMessage ( playerid, COLOR_HINT, string ) ; 

	return true;

}


CMD:mydups(playerid, params[]) {

	SendClientMessage(playerid, -1, "Your Duplicate Keys:");

	if(Character [ playerid ] [ E_CHARACTER_VEH_DUP ] == -1) {
		SendClientMessage(playerid, -1, "{3F88C5}Vehicle {DEDEDE}| None");
	} else {
		SendClientMessage(playerid, -1, sprintf("{3F88C5}Vehicle {DEDEDE}| %d", Character [ playerid ] [ E_CHARACTER_VEH_DUP ] ));
	}


	if(Character [ playerid ] [ E_CHARACTER_PROP_DUP ] == -1) {
		SendClientMessage(playerid, -1, "{DDB967}Property {DEDEDE}| None");
	} else {
		SendClientMessage(playerid, -1, sprintf("{DDB967}Property {DEDEDE}| %d", Character [ playerid ] [ E_CHARACTER_PROP_DUP ] ));
	}

	return true;
}

CMD:givecarkey(playerid, params[]){ return cmd_vdup(playerid, params); }
CMD:givekey(playerid, params[]){ return cmd_vdup(playerid, params); }
CMD:vkey(playerid, params[]){ return cmd_vdup(playerid, params); }
CMD:vdup(playerid, params[]){

	if(IsPlayerIncapacitated(playerid))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't use this command right now.");
	
	new target;

	if(sscanf(params, "k<player>", target)) {
		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/vdup [playerid]");
		return SendServerMessage ( playerid, COLOR_ERROR, "Warning", "A3A3A3", "Duplicate keys are saved. Use /changelock to revoke a key.");
	}

	if(!IsPlayerConnected(target))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target is not connected.");

	if(!IsPlayerNearPlayer(playerid, target, 10.0))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be closer to your taget to give them the keys.");

	if(playerid == target)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You already have keys to your own vehicle.");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be in a vehicle to duplicate it's keys.");

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if(veh_enum_id == -1)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can only duplicate keys to vehicles you own!");

	if(Vehicle[veh_enum_id][E_VEHICLE_TYPE] != E_VEHICLE_TYPE_PLAYER || Vehicle[veh_enum_id][E_VEHICLE_OWNER] != Character[playerid][E_CHARACTER_ID])
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can only duplicate keys to vehicles you own!");

	if ( Character[target][E_CHARACTER_VEH_DUP] != -1 )
	 	return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player already has too many duplicate keys.");

	SendServerMessage ( playerid, COLOR_SECURITY, "Keys", "A3A3A3", sprintf("You have given %s a pair of keys to your %s.", SOLS_PlayerName(target), ReturnVehicleName(vehicleid)));
	SendServerMessage ( target, COLOR_SECURITY, "Keys", "A3A3A3", sprintf("%s has given your a pair of keys to their %s.", SOLS_PlayerName(playerid), ReturnVehicleName(vehicleid)));

	GiveVehicleKey(target, veh_enum_id);

	return true;
}

GiveVehicleKey(playerid, carid){

	new query[256];

	Character [ playerid ] [ E_CHARACTER_VEH_DUP ] = Vehicle [carid] [E_VEHICLE_SQLID];

	format(query, sizeof(query), "UPDATE characters SET player_vehdup = %d WHERE player_id = %d", Character [ playerid ] [ E_CHARACTER_VEH_DUP ], Character [ playerid ] [ E_CHARACTER_ID ] );
	mysql_tquery(mysql, query);

	return true;
}


HasCarDuplicateKey(playerid, carid){

	if( Character [playerid] [E_CHARACTER_VEH_DUP] == Vehicle [carid] [E_VEHICLE_SQLID])
		return true;

	return false;
}
