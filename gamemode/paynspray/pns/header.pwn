#include "paynspray/pns/data.pwn"
#include "paynspray/pns/abuse.pwn"


public OnVehicleRespray(playerid, vehicleid, color1, color2) {


	//SendAdminMessage(sprintf("[ANTICHEAT] (%d) %s has repaired their car CLIENTSIDE in a pay and spray! Resetting state.", playerid, ReturnPlayerNameData ( playerid ) )) ;

	new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

	if ( veh_enum_id == -1 ) {

		return true ;
	}

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] <= 250.0 ) {

		SOLS_SetVehicleHealth ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], 300 ); 
	}

	else SOLS_SetVehicleHealth(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] );

	UpdateVehicleDamageStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ], 
		Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ], 
		Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ] );

	//SendClientMessage(playerid, COLOR_YELLOW, "Normal use of the pay and spray is prohibited! Your vehicle damage / health has been restored!" ) ;

	return true ;
}