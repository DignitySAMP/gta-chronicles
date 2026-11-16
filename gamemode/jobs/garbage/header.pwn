#include "jobs/garbage/data.pwn"
#include "jobs/garbage/native.pwn"


Garbage_CheckVehicleRange(playerid) {

	if ( ! IsPlayerInAnyVehicle(playerid) && IsValidVehicle ( PlayerVar [ playerid ] [ E_PLAYER_GARBAGEJOB_VEHICLE ] ) ) {
		new vehicleid = Vehicle_GetClosestEntity(playerid, 50.0);
		new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

		if ( veh_enum_id != -1 ) {

			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] == PlayerVar [ playerid ] [ E_PLAYER_GARBAGEJOB_VEHICLE ] ) {

				return true ;
			}
		}

		GameTextForPlayer(playerid, "~r~Mission Failed~n~~w~You're too far away from the garbage car.", 5000, 6);
		GarbageJob_CancelData(playerid) ;
	}

	return true ;
}

