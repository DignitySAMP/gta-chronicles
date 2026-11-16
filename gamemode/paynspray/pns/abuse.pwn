public OnPlayerUpdate(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new Float:vHealth, vehicleid = GetPlayerVehicleID(playerid);
		GetVehicleHealth(vehicleid, vHealth);

		if(vHealth == 1000)
		{
			SOLS_SetVehicleHealth(vehicleid, 999);
			if ( IsPlayerNearPayNSpray(playerid) ) {
				CallRemoteFunction("OnVehicleRespray", "iiii", playerid, vehicleid, -1, -1);
				return 1;
			}

			else AddAntiCheatLog(playerid, AC_DETECTION_VEH_REPAIR, sprintf("vehicle %d had 1000 health (max is 999)", vehicleid));
			return 1;
		}
	}

	#if defined pnsbug_OnPlayerUpdate
		return pnsbug_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate pnsbug_OnPlayerUpdate
#if defined pnsbug_OnPlayerUpdate
	forward pnsbug_OnPlayerUpdate(playerid);
#endif

IsPlayerNearPayNSpray(playerid) {

	for(new i = sizeof(E_PNS_LOCATIONS) - 1; i != -1; --i) {
        if(IsPlayerInRangeOfPoint(playerid, 15.0, E_PNS_LOCATIONS [ i ] [ E_PNS_POS_X ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Y ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Z ])) {

			return true;
		}
	}

	return false ;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) {

   	if ( !IsPlayerNearPayNSpray(playerid) ) {
		new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

		if ( veh_enum_id == -1 ) {

			return true ;
		}


	    new Float: health ;
	   	GetVehicleHealth(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], health);

	   	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] > health + 1 ) {

		    new panels, doors, lights, tires;
		    GetVehicleDamageStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], panels, doors, lights, tires);

		   	if ( health <= 300 ) {

		   		health = 300 ;
		   	}

		    Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ]    = panels ;
		    Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ]     = doors ;
		    Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ]    = lights ;
		    Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ]     = tires ;

		    SOLS_SetVehicleHealth(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], health);
		    Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] = health ;

		    
		    // Reducing lag!
		    
		    //new query [ 512 ] ;
		    //mysql_format(mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_dmg_panels = %d, vehicle_dmg_doors = %d, vehicle_dmg_lights = %d, vehicle_dmg_tires = %d, vehicle_health = '%f', vehicle_pos_x = '%f', vehicle_pos_y = '%f', vehicle_pos_z = '%f', vehicle_pos_a = '%f' WHERE vehicle_sqlid = %d",
		    //    Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ],
		    
		    //    Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], 
		    //    Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ], 
		    //    Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID] 
		    //) ;

		    //mysql_tquery ( mysql, query ) ;

			//UpdateVehicleDamageStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ], 
			//	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ], 
			//	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ] 
			//);
		}
	}

    return 1;
}