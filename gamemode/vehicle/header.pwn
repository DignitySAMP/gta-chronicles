#define VEH_FUEL_TICK	( 300000 )

new g_DriveChain[MAX_PLAYERS];

#include "vehicle/data/header.pwn"
#include "vehicle/modules/header.pwn"
#include "vehicle/fuel/header.pwn"

#include "vehicle/gui.pwn"
#include "vehicle/blinker.pwn"

#include "vehicle/slots.pwn"
#include "vehicle/hooked.pwn"

task VehicleConstantTick[60000]() {

	for ( new veh_enum_id, j = sizeof ( Vehicle ); veh_enum_id < j ; veh_enum_id ++ ) {

		Rental_CheckForExpiration(veh_enum_id) ;
		Fuel_UpdateVehicleFuel ( veh_enum_id ) ;
	}
}

public OnGameModeInit() {

	for_loop ( new i, j = sizeof ( Vehicle ); i < j ; i ++ ) {

		Vehicle [ i ] [ E_VEHICLE_ID ] = INVALID_VEHICLE_ID ;
	}

	DMV_Init() ;

	ManualVehicleEngineAndLights() ;
	EnableVehicleFriendlyFire();

	EnableStuntBonusForAll(false);

	#if defined veh_OnGameModeInit
		return veh_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit veh_OnGameModeInit
#if defined veh_OnGameModeInit
	forward veh_OnGameModeInit();
#endif

