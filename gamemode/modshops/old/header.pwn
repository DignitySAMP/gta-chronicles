

#include "modshops/data.pwn"
#include "modshops/comp.pwn"
#include "modshops/comp_raw.pwn"
#include "modshops/native.pwn"
#include "modshops/menu.pwn"
#include "modshops/checkpoint.pwn"
#include "modshops/utils.pwn"
#include "modshops/save.pwn"


ModShops_LoadEntities() {

	modshopcps[MS_TYPE_TRANSFENDER_LS]	= CreateDynamicCP(1041.354, -1022.302, 31.127 + 1.0, 4.5, -1, -1, -1, 15.0);
	modshopcps[MS_TYPE_TRANSFENDER_SF] 	= CreateDynamicCP(-1935.847, 242.876, 33.561 + 1.0, 4.5, -1, -1, -1, 15.0);
	modshopcps[MS_TYPE_TRANSFENDER_LV] 	= CreateDynamicCP(2386.662, 1047.172, 9.812 + 1.0, 4.5, -1, -1, -1, 15.0);
	modshopcps[MS_TYPE_LOCOLOW] 		= CreateDynamicCP(2644.877, -2042.556, 12.607 + 1.0, 4.5, -1, -1, -1, 15.0);
	modshopcps[MS_TYPE_WHEELARCH] 		= CreateDynamicCP(-2719.670, 217.481, 3.585 + 1.0, 4.5, -1, -1, -1, 15.0);

	CreateDynamicMapIcon(1041.354, -1022.302, 31.127, 27, -1 );
	CreateDynamicMapIcon(-1935.847, 242.876, 33.561 , 27, -1 );
	CreateDynamicMapIcon(2386.662, 1047.172, 9.812, 27, -1 );
	CreateDynamicMapIcon(2644.877, -2042.556, 12.607, 27, -1 );
	CreateDynamicMapIcon(-2719.670, 217.481, 3.585, 27, -1 );

	return 1;
}

ModShop_SetPlayerVariables(playerid) {

	PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] = MS_TYPE_NONE;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	new modelid = GetVehicleModel(vehicleid);
	if (modelid == 0) return 0;
	if (vehiclevalidmods[modelid-400][0] == 0) return 0;
	for (new c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
	{
		if (vehiclevalidmods[modelid-400][c] == componentid) return 1;
	}
	return 0;
}


//OnVehicleRespray2, OnVehiclePaintjob2 <- make these save alo

public OnVehiclePaintjob2(playerid, vehicleid, paintjobid);
public OnVehiclePaintjob2(playerid, vehicleid, paintjobid) {

	new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

	if ( veh_enum_id == -1 ) {

		return true ;
	}

    Vehicle [ veh_enum_id ] [ E_VEHICLE_PAINTJOB ] = paintjobid ;

    new query [ 256 ] ;
    mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET vehicle_paintjob = %d WHERE vehicle_sqlid = %d",
        Vehicle [ veh_enum_id ] [ E_VEHICLE_PAINTJOB ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ]
    );
    mysql_tquery(mysql, query);

    return true ;
}

public OnVehicleRespray2(playerid, vehicleid, color1, color2);
public OnVehicleRespray2(playerid, vehicleid, color1, color2) {

	new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

	if ( veh_enum_id == -1 ) {

		return true ;
	}

    Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ] = color1 ;
    Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ] = color2 ;

    new query [ 256 ] ;
    mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET vehicle_color_a = %d, vehicle_color_b = %d WHERE vehicle_sqlid = %d",
        Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ]
    );

    mysql_tquery(mysql, query);

	return true ;
}

forward OnVehicleMod2(playerid, vehicleid, componentid);
public OnVehicleMod2(playerid, vehicleid, componentid) {



	new bool: illegal_mod_found = false, illegal_mod_refund ;
	switch ( componentid) {

		case 1008: { // 5x nos
			illegal_mod_found = true ;
			illegal_mod_refund = 500 ;
		}
		case 1009: { // 2x nos
			illegal_mod_found = true ;
			illegal_mod_refund = 200 ;
		}
		case 1010: { // 10x nos
			illegal_mod_found = true ;
			illegal_mod_refund = 1000 ;
		}
		case 1086: { // bass boost aka XM radio

		}
	}

	if ( illegal_mod_found ) {

		SendServerMessage ( playerid, COLOR_GREEN, "Modshop", "DEDEDE", "You've tried installing a disabled modification. It's been removed." ) ;
		RemoveVehicleComponent(vehicleid, componentid);
		GivePlayerMoney(playerid, illegal_mod_refund ) ;

		return 0 ;
	}

	Tune_AddVehicleComponent(playerid, vehicleid, componentid);

	return true ;
}