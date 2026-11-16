#include "vehicle/data/cmds/owner.pwn"
#include "vehicle/data/cmds/default.pwn"
#include "vehicle/data/cmds/admin.pwn"
#include "vehicle/data/cmds/storage.pwn"

// New, cleaner /carlock by Spooky
CMD:carlock(playerid, params[]) 
{
	if (IsPlayerIncapacitated(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this.");
	}

	new vehicleid = INVALID_VEHICLE_ID;

	if (IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
	else vehicleid = GetClosestVehicleEx(playerid, 7.5);

	if (!vehicleid || vehicleid == INVALID_VEHICLE_ID) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle.");
	}

	SOLS_PlayerLockCar(playerid, vehicleid, true);
	return true ;
}

// New by Spooky: call this when the script wants to lock a car (pass vehicle id by samp id)
SOLS_SetCarLocked(vehicleid, bool:locked)
{
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );
	if (vehicleid == INVALID_VEHICLE_ID  || veh_enum_id == -1) return; // invalid id

	Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ] = locked ;
	SetDoorStatus ( vehicleid, locked );

	new query [ 128 ] ;
	mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET vehicle_doors = %d WHERE vehicle_sqlid = %d", Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ]);
	mysql_tquery(mysql, query);

	/*
	if ( GetVehicleDriver ( vehicleid ) == playerid ) {
		Vehicle_OnPlayerUpdateGUI(playerid, vehicleid);
	}
	*/

	ClearAlarmData ( vehicleid ) ;	
}

// New by Spooky: call this for when a player wants to lock a car (pass vehicle id as samp id)
SOLS_PlayerLockCar(playerid, vehicleid, bool:feedback=true)
{
	if (IsPlayerIncapacitated(playerid)) 
	{
        if (feedback) SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." );
		return false;
    }

	if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		SendClientMessage(playerid, COLOR_ERROR, "You can only lock or unlock a vehicle from within as the driver.");
		return false;
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );
	if (vehicleid == INVALID_VEHICLE_ID  || veh_enum_id == -1) 
	{
		if (feedback) SendClientMessage(playerid, COLOR_ERROR, "You're not near any proper vehicle! (couldn't fetch ID)");
		return false;
	}

	if (GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510) 
	{
        if (feedback) SendServerMessage(playerid, COLOR_ERROR, "Uh Oh!", "A3A3A3", "This vehicle does not have a door lock!");
		return false;
    }

	new bool:access = false;
	if (Vehicle[veh_enum_id][E_VEHICLE_TYPE] == E_VEHICLE_TYPE_PLAYER) access = Vehicle[veh_enum_id][E_VEHICLE_OWNER] == Character[playerid][E_CHARACTER_ID] || HasCarDuplicateKey(playerid, veh_enum_id);
	else if (Vehicle[veh_enum_id][E_VEHICLE_TYPE] == E_VEHICLE_TYPE_FACTION) access = Vehicle[veh_enum_id][E_VEHICLE_OWNER] == Character[playerid][E_CHARACTER_FACTIONID];
	else if (Vehicle[veh_enum_id][E_VEHICLE_TYPE] == E_VEHICLE_TYPE_GROUP) access = Vehicle[veh_enum_id][E_VEHICLE_OWNER] == Character[playerid][E_CHARACTER_GROUPID];

	if (!access)
	{
		if (GetPlayerVehicleID(playerid) == vehicleid)
		{
			// Allow them to lock/unlock from the inside as the driver, even without keys.
		}
		else if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
		{
			SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to do this.");
		} 
		else
		{
			if (feedback)
			{
				if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR) SendClientMessage(playerid, -1, "You don't have the keys for this vehicle, but can go on admin duty to use it.");
				else SendClientMessage(playerid, COLOR_ERROR, "You don't have the keys to this vehicle.");
			}

			return false;
		}
	}

	new locked = GetDoorStatus(vehicleid);

	if (locked)
	{
		ProxDetectorAutoMe(playerid, 30.0, sprintf("has unlocked the %s.", ReturnVehicleName ( vehicleid )), true);
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Unlocked a %s (VID: %d, SQL: %d)", ReturnVehicleName ( vehicleid ), vehicleid, Vehicle[veh_enum_id][E_VEHICLE_SQLID]));
		SOLS_SetCarLocked(vehicleid, false);
	}
	else
	{
		ProxDetectorAutoMe(playerid, 30.0, sprintf("has locked the %s.", ReturnVehicleName ( vehicleid )), true);
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Locked a %s (VID: %d, SQL: %d)", ReturnVehicleName ( vehicleid ), vehicleid, Vehicle[veh_enum_id][E_VEHICLE_SQLID]));
		SOLS_SetCarLocked(vehicleid, true);
	}

	VehiclePlaySound(vehicleid, 24600);
	return true;
}

CMD:engine(playerid, params[]) 
{
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

    if ( PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Finish refueling your vehicle before trying to turn on the engine!");
    }

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );
	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any proper vehicle! (couldn't fetch ID)");
	}

	if (!IsEngineVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_ERROR, "You are not in any vehicle.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "You can't do this as you're not the driver.");

	if (Account[playerid][E_PLAYER_ACCOUNT_VEHBAN])
	{
		SendClientMessage(playerid, COLOR_ERROR, "Your permission to drive vehicles was revoked by an admin.");
		return true;
	}
	else if (Account[playerid][E_PLAYER_ACCOUNT_BIKEBAN] && IsABike(vehicleid))
	{
		SendClientMessage(playerid, COLOR_ERROR, "Your permission to use bikes was revoked by an admin.");
		return true;
	}

	if (Vehicle [ veh_enum_id ] [E_VEHICLE_IMPOUNDED] && !PlayerVar [ playerid ] [ E_PLAYER_ADMIN_DUTY ])
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is impounded, type \"/unimpound\" to pay the fee first.");
	}

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {
		switch ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ]) {

			case E_VEHICLE_TYPE_PLAYER: {
				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] && !HasCarDuplicateKey(playerid, veh_enum_id)) {

					return SendClientMessage(playerid, COLOR_ERROR, "You don't have the keys to this vehicle.");
				}
			}

			case E_VEHICLE_TYPE_FACTION: {

				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {

					return SendClientMessage(playerid, COLOR_ERROR, "You don't have the keys to this vehicle.");
				}
			}

			case E_VEHICLE_TYPE_GROUP: {

				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {

					return SendClientMessage(playerid, COLOR_ERROR, "You don't have the keys to this vehicle.");
				}
			}

			case E_VEHICLE_TYPE_RENTAL : {
				/*
				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) {

					return SendClientMessage(playerid, COLOR_ERROR, "You have not rented this vehicle!");
				}*/

				if ( VehicleVar [ veh_enum_id ] [ E_VEHICLE_RENTEDBY ] != playerid ) {

					return SendClientMessage(playerid, COLOR_ERROR, "You have not rented this vehicle!");
				}
			}

			case E_VEHICLE_TYPE_DMV: {

				return SendClientMessage(playerid, COLOR_ERROR, "This is a DMV vehicle. You need to use /taketest!");
			}
			case E_VEHICLE_TYPE_JOB: {

				if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {

					return SendClientMessage(playerid, COLOR_ERROR, "You must do the right command or keystroke to turn this engine on!");
				}
			}
		}	
	}

	else {

		SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to start this vehicle.");
	}

	if (Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] <= 1 && !GetEngineStatus(vehicleid)) 
	{
	    return SendClientMessage(playerid, COLOR_ERROR, "The fuel tank is empty.");
	}

	if (ReturnVehicleHealth(vehicleid) <= 300) {
		if ( ! IsAircraft ( vehicleid ) ) {
	    	return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is totalled and can't be started.");
	    }

	    else {

	    	SendClientMessage(playerid, COLOR_YELLOW, "Your vehicle is in very bad condition (engine damage). Get it fixed before it blows up!");
	    }
	}

	switch (GetEngineStatus(vehicleid))
	{
	    case false:
	    {

	        SetEngineStatus(vehicleid, true);
			if ( g_DriveChain[playerid] != vehicleid ) {
				g_DriveChain[playerid] = vehicleid ;
			defer OnPlayerDrive(playerid, vehicleid) ;
			}
	        ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s twists the key, turning the engine of the %s on.", ReturnPlayerNameData(playerid, 0, true), ReturnVehicleName ( vehicleid )));
		}
		case true:
		{
		    SetEngineStatus(vehicleid, false);
		    ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s twists the key, turning the engine of the %s off.", ReturnPlayerNameData(playerid, 0, true), ReturnVehicleName ( vehicleid )));
		}
	}

	SOLS_UpdateVehiclePermSirens(vehicleid);
	ClearAlarmData ( vehicleid ) ;
	//Vehicle_OnPlayerUpdateGUI(playerid, vehicleid) ;
	ShowVehicleGUI(playerid);
	return 1;
}