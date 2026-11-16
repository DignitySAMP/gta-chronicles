new const VehicleColoursTableRGBA[256][7] = {
    // The existing colours from San Andreas
    "000000", "F5F5F5", "2A77A1", "840410", "263739", "86446E", "D78E10", "4C75B7", "BDBEC6", "5E7072",
    "46597A", "656A79", "5D7E8D", "58595A", "D6DAD6", "9CA1A3", "335F3F", "730E1A", "7B0A2A", "9F9D94",
    "3B4E78", "732E3E", "691E3B", "96918C", "515459", "3F3E45", "A5A9A7", "635C5A", "3D4A68", "979592",
    "421F21", "5F272B", "8494AB", "767B7C", "646464", "5A5752", "252527", "2D3A35", "93A396", "6D7A88",
    "221918", "6F675F", "7C1C2A", "5F0A15", "193826", "5D1B20", "9D9872", "7A7560", "989586", "ADB0B0",
    "848988", "304F45", "4D6268", "162248", "272F4B", "7D6256", "9EA4AB", "9C8D71", "6D1822", "4E6881",
    "9C9C98", "917347", "661C26", "949D9F", "A4A7A5", "8E8C46", "341A1E", "6A7A8C", "AAAD8E", "AB988F",
    "851F2E", "6F8297", "585853", "9AA790", "601A23", "20202C", "A4A096", "AA9D84", "78222B", "0E316D",
    "722A3F", "7B715E", "741D28", "1E2E32", "4D322F", "7C1B44", "2E5B20", "395A83", "6D2837", "A7A28F",
    "AFB1B1", "364155", "6D6C6E", "0F6A89", "204B6B", "2B3E57", "9B9F9D", "6C8495", "4D8495", "AE9B7F",
    "406C8F", "1F253B", "AB9276", "134573", "96816C", "64686A", "105082", "A19983", "385694", "525661",
    "7F6956", "8C929A", "596E87", "473532", "44624F", "730A27", "223457", "640D1B", "A3ADC6", "695853",
    "9B8B80", "620B1C", "5B5D5E", "624428", "731827", "1B376D", "EC6AAE", "000000",
    // SA-MP extended colours (0.3x)
    "177517", "210606", "125478", "452A0D", "571E1E", "010701", "25225A", "2C89AA", "8A4DBD", "35963A",
    "B7B7B7", "464C8D", "84888C", "817867", "817A26", "6A506F", "583E6F", "8CB972", "824F78", "6D276A",
    "1E1D13", "1E1306", "1F2518", "2C4531", "1E4C99", "2E5F43", "1E9948", "1E9999", "999976", "7C8499",
    "992E1E", "2C1E08", "142407", "993E4D", "1E4C99", "198181", "1A292A", "16616F", "1B6687", "6C3F99",
    "481A0E", "7A7399", "746D99", "53387E", "222407", "3E190C", "46210E", "991E1E", "8D4C8D", "805B80",
    "7B3E7E", "3C1737", "733517", "781818", "83341A", "8E2F1C", "7E3E53", "7C6D7C", "020C02", "072407",
    "163012", "16301B", "642B4F", "368452", "999590", "818D96", "99991E", "7F994C", "839292", "788222",
    "2B3C99", "3A3A0B", "8A794E", "0E1F49", "15371C", "15273A", "375775", "060820", "071326", "20394B",
    "2C5089", "15426C", "103250", "241663", "692015", "8C8D94", "516013", "090F02", "8C573A", "52888E",
    "995C52", "99581E", "993A63", "998F4E", "99311E", "0D1842", "521E1E", "42420D", "4C991E", "082A1D",
    "96821D", "197F19", "3B141F", "745217", "893F8D", "7E1A6C", "0B370B", "27450D", "071F24", "784573",
    "8A653A", "732617", "319490", "56941D", "59163D", "1B8A2F", "38160B", "041804", "355D8E", "2E3F5B",
    "561A28", "4E0E27", "706C67", "3B3E42", "2E2D33", "7B7E7D", "4A4442", "28344E"
};

enum VehicleData {

	E_VEHICLE_SQLID,
	E_VEHICLE_ID,
	E_VEHICLE_MODELID,

	E_VEHICLE_TYPE, // if type = faction, owner = factionid. if player, owner = player db id
	E_VEHICLE_JOBID, // 0: none, 1: dockw
	E_VEHICLE_OWNER,
	E_VEHICLE_COLOR_A,
	E_VEHICLE_COLOR_B,

	Float:E_VEHICLE_MILEAGE_X,
	Float:E_VEHICLE_MILEAGE_Y,
	Float:E_VEHICLE_MILEAGE_Z,
	E_VEHICLE_MILEAGE,
	Float:E_VEHICLE_MILEAGE_TEMP,

	E_VEHICLE_IS_SPAWNED,
	Float: E_VEHICLE_POS_X,
	Float: E_VEHICLE_POS_Y,
	Float: E_VEHICLE_POS_Z,
	Float: E_VEHICLE_POS_A,

	E_VEHICLE_LICENSE [ 16 ],
	E_VEHICLE_STATION,

	E_VEHICLE_SIREN,

	E_VEHICLE_ENGINE,
	E_VEHICLE_DOORS,
	E_VEHICLE_FUEL,
	E_VEHICLE_FUEL_TICK,
	E_VEHICLE_WINDOW,

	E_VEHICLE_TRUNK_WEP [ 10 ],
	E_VEHICLE_TRUNK_AMMO [ 10 ],

	E_VEHICLE_TRUNK_DRUGS_TYPE [ 10 ],
	E_VEHICLE_TRUNK_DRUGS_PARAM [ 10 ],
	E_VEHICLE_TRUNK_DRUGS_CONTAINER [ 10 ],
	Float: E_VEHICLE_TRUNK_DRUGS_AMOUNT [ 10 ],

	E_VEHICLE_NOS,
	E_VEHICLE_NEON [ 2 ],

	E_VEHICLE_PAINTJOB,
	Float: E_VEHICLE_HEALTH, 
	E_VEHICLE_DMG_PANELS,
	E_VEHICLE_DMG_DOORS,
	E_VEHICLE_DMG_LIGHTS,
	E_VEHICLE_DMG_TIRES,

	DynamicText3D: E_VEHICLE_LABEL,
	DynamicText3D: E_VEHICLE_CARSIGN,

	E_VEHICLE_PASSENGER, // Cached frontseat passenger - not reset if they leave vehicle so always check they are in it
	E_VEHICLE_DOOR_STATE[4], // For /cardoor

	E_VEHICLE_PARKED_AT, // For /carpark, saved in db

	E_VEHICLE_IMPOUNDED, // For impound
	E_VEHICLE_IMPOUNDED_UNTIL,
	E_VEHICLE_IMPOUND_COST,
	E_VEHICLE_IMPOUND_REASON[64],
	E_VEHICLE_IMPOUNDED_BY[64]
}

new Vehicle [ MAX_VEHICLES ] [ VehicleData ]; //, vehicleCount ; 

enum VehicleVarData {

	E_VEHICLE_VAR_FUEL_INCR,
	Timer: E_VEHICLE_NOS_TICK,

	E_VEHICLE_RECENT_DEATH,
	Float:E_VEHICLE_DEATH_POS[4],
	Float:E_VEHICLE_DEATH_HEALTH,

	E_VEHICLE_TRUCKER_OBJECT [ 64 ],
	E_VEHICLE_TRUCKER_ITEM [ 64 ],
	E_VEHICLE_TRUCKER_MODEL [ 64 ],
	E_VEHICLE_TRUCKER_TRAILER,

    E_VEHICLE_STATION [ 126 ],

	E_VEHICLE_RENTEDBY,
	E_VEHICLE_RENTUNIX,
	E_VEHICLE_FLAME_OBJECT,
	E_VEHICLE_FIRE_OBJECTS[2],
	bool:E_VEHICLE_CAN_EXPLODE,

	E_VEHICLE_SCANNER_CHANNEL,
	bool: E_VEHICLE_LAST_FUEL_TICK,
	DynamicText3D:E_VEHICLE_CAD_LABEL
} ;

new VehicleVar [ MAX_VEHICLES ] [ VehicleVarData ] ;

enum { // veh types

	E_VEHICLE_TYPE_INVALID = -1,
	E_VEHICLE_TYPE_DEFAULT = 0, // no lock, no engine, usable by anyone
	E_VEHICLE_TYPE_RENTAL,
	E_VEHICLE_TYPE_DMV,
	E_VEHICLE_TYPE_PLAYER,
	E_VEHICLE_TYPE_FACTION,
	E_VEHICLE_TYPE_JOB,
	E_VEHICLE_TYPE_GROUP,
}

enum { // veh job ids
	E_VEHICLE_JOB_NONE = 0,
	E_VEHICLE_JOB_DOCKWORKER,
	E_VEHICLE_JOB_GARBAGEJOB,
}

Vehicle_ClearRuntimeVariables(vehicle_enum_id)
{
	if ( vehicle_enum_id == -1 ) return ;

	new var_clear[VehicleVarData];
	var_clear[E_VEHICLE_RENTEDBY] = INVALID_PLAYER_ID;
	var_clear[E_VEHICLE_FLAME_OBJECT] = VehicleVar[vehicle_enum_id][E_VEHICLE_FLAME_OBJECT];
	var_clear[E_VEHICLE_FIRE_OBJECTS][0] = VehicleVar[vehicle_enum_id][E_VEHICLE_FIRE_OBJECTS][0];
	var_clear[E_VEHICLE_FIRE_OBJECTS][1] = VehicleVar[vehicle_enum_id][E_VEHICLE_FIRE_OBJECTS][1];
	var_clear[E_VEHICLE_CAN_EXPLODE] = VehicleVar[vehicle_enum_id][E_VEHICLE_CAN_EXPLODE];
	var_clear[E_VEHICLE_SCANNER_CHANNEL] = VehicleVar[vehicle_enum_id][E_VEHICLE_SCANNER_CHANNEL];
	VehicleVar[vehicle_enum_id] = var_clear;
}



Vehicle_CreateEntity ( playerid, veh_model, veh_type, veh_owner, Float: veh_pos_x, Float: veh_pos_y, Float: veh_pos_z, Float: veh_pos_a, veh_color_a, veh_color_b, veh_siren = false, veh_job = E_VEHICLE_JOB_NONE ) {
	#pragma unused veh_siren

	new veh_enum_id = 0 ;

	Vehicle_ResetSlot(veh_enum_id) ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] 		= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_MODELID ] 		= veh_model ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] 			= veh_type ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] 		= veh_owner ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_JOBID ]			= veh_job ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_SIREN ]			= false ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ] 		= veh_color_a ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ] 		= veh_color_b ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_IS_SPAWNED ]	= false ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ] 		= veh_pos_x ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] 		= veh_pos_y ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] 		= veh_pos_z ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ] 		= veh_pos_a ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_STATION ]		= -1 ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_ENGINE ]		= false ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ]			= false ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]			= 100 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ]		= true ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_PAINTJOB ] = 3 ;
 
	Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ]		= 1000.0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ] 	= 0 ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_PARKED_AT ] = 0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED ] = 0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ] [ 0 ] = EOS ;
	strcat ( Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ], sprintf("SA-%d", random(1001) + random (5999) + Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) );
	
	new query [ 1024 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO vehicles (vehicle_modelid, vehicle_type, vehicle_jobid, vehicle_owner, vehicle_color_a, vehicle_color_b, vehicle_pos_x, vehicle_pos_y, vehicle_pos_z, vehicle_pos_a, vehicle_license, vehicle_fuel, vehicle_health, vehicle_dmg_panels, vehicle_dmg_doors, vehicle_dmg_lights, vehicle_dmg_tires, vehicle_paintjob, vehicle_siren) VALUES (%d, %d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%e', %d, '1000.0', 0, 0, 0, 0, 3, 0)",
		Vehicle [ veh_enum_id ] [ E_VEHICLE_MODELID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ], Vehicle [ veh_enum_id ] [ E_VEHICLE_JOBID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ],
		 Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ], Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]  ) ;

	Vehicle_ResetSlot(veh_enum_id) ;

	inline Vehicle_OnDatabaseInsert() {

		new sqlid = cache_insert_id ();
		printf(" * [VEHICLE] Created vehicle with ID %d.",
			sqlid ) ;

		SendServerMessage(playerid, COLOR_BLUE, "Vehicle", "A3A3A3", sprintf("To spawn your car, use /carspawn %d.", sqlid ) ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Vehicle_OnDatabaseInsert, "");


	return true ;
}


Vehicle_CreateEntity_Spawn ( playerid, veh_model, veh_type, veh_owner, Float: veh_pos_x, Float: veh_pos_y, Float: veh_pos_z, Float: veh_pos_a, veh_color_a, veh_color_b, veh_siren = false, veh_job = E_VEHICLE_JOB_NONE ) {
	#pragma unused veh_siren

	new veh_enum_id = SOLS_CreateVehicle(	veh_model, veh_pos_x, veh_pos_y, veh_pos_z, veh_pos_a, veh_color_a, veh_color_b, -1 ) ;

	if (  veh_enum_id == INVALID_VEHICLE_ID ) {

		return print("* [VEHICLE] No free enum IDs left - [Vehicle_CreateEntity] failed!!");
	}

	//new veh_enum_id = vehicleCount ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] 		= veh_enum_id ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] 		= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_MODELID ] 		= veh_model ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] 			= veh_type ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] 		= veh_owner ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_JOBID ]			= veh_job ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_SIREN ]			= false ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ] 		= veh_color_a ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ] 		= veh_color_b ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ] 		= veh_pos_x ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] 		= veh_pos_y ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] 		= veh_pos_z ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ] 		= veh_pos_a ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_STATION ]		= -1 ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_ENGINE ]		= false ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ]			= false ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]			= 100 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_WINDOW ]		= true ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_PAINTJOB ] = 3 ;
 
	Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ]		= 1000.0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_PANELS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_DOORS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_LIGHTS ] 	= 0 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_DMG_TIRES ] 	= 0 ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_PARKED_AT ] = 0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED ] = 0;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ] [ 0 ] = EOS ;
	strcat ( Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ], sprintf("SA-%d", random(1001) + random (5999) + Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ) );
	
	new query [ 1024 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO vehicles (vehicle_modelid, vehicle_type, vehicle_jobid, vehicle_owner, vehicle_color_a, vehicle_color_b, vehicle_pos_x, vehicle_pos_y, vehicle_pos_z, vehicle_pos_a, vehicle_license, vehicle_fuel, vehicle_health, vehicle_dmg_panels, vehicle_dmg_doors, vehicle_dmg_lights, vehicle_dmg_tires, vehicle_paintjob, vehicle_siren) VALUES (%d, %d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%e', %d, '1000.0', 0, 0, 0, 0, 3, 0)",
		Vehicle [ veh_enum_id ] [ E_VEHICLE_MODELID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ], Vehicle [ veh_enum_id ] [ E_VEHICLE_JOBID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ],
		 Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] , Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ], Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ]  ) ;

	inline Vehicle_OnDatabaseInsert() {

		Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] = cache_insert_id ();
		printf(" * [VEHICLE] Created vehicle (%d) with ID %d.", 
			veh_enum_id, Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ] ) ;

		Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] = 1000 ;
		SOLS_SetVehicleHealth ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_HEALTH ] ); 

		SetVehicleNumberPlate(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ] ) ;

		SetEngineStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_ENGINE ]);
		SetDoorStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ]);

		Vehicle [ veh_enum_id ] [ E_VEHICLE_IS_SPAWNED ] = true ;
		ChangeVehiclePaintjob(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_PAINTJOB ] ) ;
		Tune_ApplyComponents(playerid, veh_enum_id );
		Vehicle_ClearRuntimeVariables(veh_enum_id);
		Vehicle_ClearTruckerVariables(veh_enum_id);
		Scanner_Reset(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ]);

		JT_PutPlayerInVehicle(playerid, Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] , 0);
		Vehicle_SetDoorsEngineStatus(veh_enum_id ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Vehicle_OnDatabaseInsert, "");

	printf(" * [VEHICLE] Created entity ID %d (veh: %d) [type %d] at %0.2f, %0.2f, %0.2f", veh_enum_id, 
		Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ], veh_pos_x, veh_pos_y, veh_pos_z ) ;


	return Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ;
}

Vehicle_SetDoorsEngineStatus(index ) {

	new i = index ;

	switch ( Vehicle [ i ] [ E_VEHICLE_TYPE ] ) {
		case E_VEHICLE_TYPE_INVALID: {

			SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
			SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], true );
		}
		case E_VEHICLE_TYPE_DEFAULT: {

			SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
			SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], true );
		}
		case E_VEHICLE_TYPE_FACTION: {

			SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
			SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], true );
		}

		case E_VEHICLE_TYPE_JOB: {

			SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
			SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
		}

		default: {

			SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], Vehicle [ i ] [ E_VEHICLE_ENGINE ]);
			SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], Vehicle [ i ] [ E_VEHICLE_DOORS ]);	
		}
	}

	if (  Vehicle [ i ] [ E_VEHICLE_MODELID ] == 481 || Vehicle [ i ] [ E_VEHICLE_MODELID ] == 509 || Vehicle [ i ] [ E_VEHICLE_MODELID ] == 510 ) {

		Vehicle [ i ] [ E_VEHICLE_TYPE ] = E_VEHICLE_TYPE_DEFAULT ;
		SetEngineStatus(Vehicle [ i ] [ E_VEHICLE_ID ], true );
		SetDoorStatus(Vehicle [ i ] [ E_VEHICLE_ID ], false );
	}
}

Vehicle_ResetSlot(slot) {

	new blank [ VehicleData ] ;

	Vehicle [ slot ] = blank ;

	Vehicle [ slot ] [ E_VEHICLE_SQLID ] = -1 ;
	Vehicle [ slot ] [ E_VEHICLE_ID ] = INVALID_VEHICLE_ID ;
}

Vehicle_SaveState ( slot ) {

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_dmg_panels = %d, vehicle_dmg_doors = %d, vehicle_dmg_lights = %d, vehicle_dmg_tires = %d, vehicle_health = '%f' WHERE vehicle_sqlid = %d",
		Vehicle [ slot ] [ E_VEHICLE_DMG_PANELS ], Vehicle [ slot ] [ E_VEHICLE_DMG_DOORS ], Vehicle [ slot ] [ E_VEHICLE_DMG_LIGHTS ], Vehicle [ slot ] [ E_VEHICLE_DMG_TIRES ],
		Vehicle [ slot ] [ E_VEHICLE_HEALTH ], Vehicle [ slot ] [ E_VEHICLE_SQLID ] ) ;

	mysql_tquery ( mysql, query ) ;
}

Vehicle_FetchSlot ( sql_id, bool:keep = false ) {

	Vehicle_ResetSlot ( 0 ) ;

	new slot = Vehicle_GetEnumIDFromSQLID ( sql_id ) ;

	if ( slot != -1 ) {

		return slot ;
	}

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "SELECT *,UNIX_TIMESTAMP(`vehicle_impounded_until`) AS `vehicle_impounded_until_unix` FROM `vehicles` WHERE `vehicle_sqlid` = %d", sql_id ) ;

	new Cache:vehicle_row = mysql_query ( mysql, query ) ;

	if ( ! cache_num_rows ( ) ) {

		cache_delete ( vehicle_row ) ;

		return -1 ;
	}

	Vehicle_LoadFromRow ( 0, 0 ) ;

	cache_delete ( vehicle_row ) ;

	if ( keep ) {

		Vehicle [ 0 ] [ E_VEHICLE_SQLID ] = -1 ;
	}

	return 0 ;
}

Vehicle_Recreate ( slot, vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren = 0 ) {

	new saved [ VehicleData ], saved_var [ VehicleVarData ] ;

	saved = Vehicle [ slot ] ;
	saved_var = VehicleVar [ slot ] ;

	new vehicleid = SOLS_CreateVehicle ( vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren ) ;

	if ( vehicleid == INVALID_VEHICLE_ID ) {

		Vehicle [ slot ] = saved ;
		Vehicle [ slot ] [ E_VEHICLE_ID ] = INVALID_VEHICLE_ID ;

		return slot ;
	}

	if ( vehicleid != slot ) {

		Vehicle_ResetSlot ( slot ) ;
	}

	Vehicle [ vehicleid ] = saved ;
	VehicleVar [ vehicleid ] = saved_var ;
	Vehicle [ vehicleid ] [ E_VEHICLE_ID ] = vehicleid ;

	return vehicleid ;
}

Vehicle_LoadFromRow(slot, i) {

	Vehicle [ slot ] [ E_VEHICLE_SQLID ]		= cache_get_field_int (i, "vehicle_sqlid");

	//vehicleCount ++ ;

	Vehicle [ slot ] [ E_VEHICLE_MODELID ] 	= cache_get_field_int (i, "vehicle_modelid");
	Vehicle [ slot ] [ E_VEHICLE_TYPE ] 		= cache_get_field_int (i, "vehicle_type");
	Vehicle [ slot ] [ E_VEHICLE_OWNER ] 		= cache_get_field_int (i, "vehicle_owner");

	Vehicle [ slot ] [ E_VEHICLE_JOBID ]		= cache_get_field_int (i, "vehicle_jobid");

	Vehicle [ slot ] [ E_VEHICLE_COLOR_A ] 	= cache_get_field_int (i, "vehicle_color_a");
	Vehicle [ slot ] [ E_VEHICLE_COLOR_B ] 	= cache_get_field_int (i, "vehicle_color_b");
	Vehicle [ slot ] [ E_VEHICLE_MILEAGE ] 	= cache_get_field_int (i, "vehicle_mileage");


	Vehicle [ slot ] [ E_VEHICLE_POS_X ] 		= cache_get_field_float ( i, "vehicle_pos_x") ;
	Vehicle [ slot ] [ E_VEHICLE_POS_Y ] 		= cache_get_field_float ( i, "vehicle_pos_y") ;
	Vehicle [ slot ] [ E_VEHICLE_POS_Z ] 		= cache_get_field_float ( i, "vehicle_pos_z") ;
	Vehicle [ slot ] [ E_VEHICLE_POS_A ] 		= cache_get_field_float ( i, "vehicle_pos_a") ;

	Vehicle [ slot ] [ E_VEHICLE_SIREN ]		= cache_get_field_int (i, "vehicle_siren");
	Vehicle [ slot ] [ E_VEHICLE_FUEL ]		= cache_get_field_int (i, "vehicle_fuel");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 0 ]		= cache_get_field_int (i, "vehicle_trunk_wep_1");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 0 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_1");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 1 ]		= cache_get_field_int (i, "vehicle_trunk_wep_2");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 1 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_2");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 2 ]		= cache_get_field_int (i, "vehicle_trunk_wep_3");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 2 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_3");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 3 ]		= cache_get_field_int (i, "vehicle_trunk_wep_4");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 3 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_4");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 4 ]		= cache_get_field_int (i, "vehicle_trunk_wep_5");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 4 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_5");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 5 ]		= cache_get_field_int (i, "vehicle_trunk_wep_6");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 5 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_6");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 6 ]		= cache_get_field_int (i, "vehicle_trunk_wep_7");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 6 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_7");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 7 ]		= cache_get_field_int (i, "vehicle_trunk_wep_8");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 7 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_8");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 8 ]		= cache_get_field_int (i, "vehicle_trunk_wep_9");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 8 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_9");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_WEP ] [ 9 ]		= cache_get_field_int (i, "vehicle_trunk_wep_10");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_AMMO ] [ 9 ]	= cache_get_field_int (i, "vehicle_trunk_ammo_10");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 0 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_1");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 0 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_1");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 0 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_1");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 0 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_1");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 1 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_2");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 1 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_2");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 1 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_2");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 1 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_2");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 2 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_3");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 2 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_3");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 2 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_3");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 2 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_3");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 3 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_4");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 3 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_4");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 3 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_4");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 3 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_4");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 4 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_5");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 4 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_5");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 4 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_5");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 4 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_5");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 5 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_6");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 5 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_6");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 5 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_6");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 5 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_6");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 6 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_7");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 6 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_7");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 6 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_7");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 6 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_7");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 7 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_8");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 7 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_8");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 7 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_8");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 7 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_8");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 8 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_9");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 8 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_9");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 8 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_9");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 8 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_9");

	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_TYPE ] [ 9 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_type_10");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_PARAM ] [ 9 ]			= cache_get_field_int (i, "vehicle_trunk_drugs_param_10");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_CONTAINER ] [ 9 ]		= cache_get_field_int (i, "vehicle_trunk_drugs_cont_10");
	Vehicle [ slot ] [ E_VEHICLE_TRUNK_DRUGS_AMOUNT ] [ 9 ]		= cache_get_field_float (i, "vehicle_trunk_drugs_amount_10");

	Vehicle [ slot ] [ E_VEHICLE_PAINTJOB ]		= cache_get_field_int (i, "vehicle_paintjob");

	Vehicle [ slot ] [ E_VEHICLE_HEALTH ] 		= cache_get_field_float ( i, "vehicle_health") ;

	Vehicle [ slot ] [ E_VEHICLE_DMG_PANELS ] = cache_get_field_int (i, "vehicle_dmg_panels");
	Vehicle [ slot ] [ E_VEHICLE_DMG_DOORS ] = cache_get_field_int (i, "vehicle_dmg_doors");
	Vehicle [ slot ] [ E_VEHICLE_DMG_LIGHTS ] = cache_get_field_int (i, "vehicle_dmg_lights");
	Vehicle [ slot ] [ E_VEHICLE_DMG_TIRES ] = cache_get_field_int (i, "vehicle_dmg_tires");

	Vehicle [ slot ] [ E_VEHICLE_STATION ]		= -1 ;

	Vehicle [ slot ] [ E_VEHICLE_ENGINE ]		= false ;
	Vehicle [ slot ] [ E_VEHICLE_DOORS ]		= cache_get_field_int (i, "vehicle_doors");
	Vehicle [ slot ] [ E_VEHICLE_WINDOW ]		= true ;

	Vehicle [ slot ] [ E_VEHICLE_PARKED_AT ]		= cache_get_field_int (i, "vehicle_parked_at");

	Vehicle [ slot ] [ E_VEHICLE_IMPOUNDED ]		= cache_get_field_int (i, "vehicle_impounded");
	Vehicle [ slot ] [ E_VEHICLE_IMPOUNDED_UNTIL ]		= cache_get_field_int (i, "vehicle_impounded_until_unix");
	Vehicle [ slot ] [ E_VEHICLE_IMPOUND_COST ]		= cache_get_field_int (i, "vehicle_impound_cost");

	cache_get_field_content ( i, "vehicle_impounded_by", Vehicle [ slot ] [ E_VEHICLE_IMPOUNDED_BY ] , mysql, 64 ) ;
	cache_get_field_content ( i, "vehicle_impound_reason", Vehicle [ slot ] [ E_VEHICLE_IMPOUND_REASON ] , mysql, 64 ) ;

	cache_get_field_content ( i, "vehicle_license", Vehicle [ slot ] [ E_VEHICLE_LICENSE ] , mysql, 16 ) ;
}

Vehicle_LoadEntities() {

	for_loop ( new i, j = sizeof ( Vehicle ); i < j ; i ++ ) {

		Vehicle [ i ] [ E_VEHICLE_SQLID ] = -1 ;

		VehicleVar [ i ] [ E_VEHICLE_RENTEDBY ] = INVALID_PLAYER_ID ;
	}

	print(" * [VEHICLE] Loading all vehicles...");

	inline Vehicle_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows && i < MAX_VEHICLES; i ++ ) {

				new vehicleid = SOLS_CreateVehicle(cache_get_field_int (i, "vehicle_modelid"), cache_get_field_float ( i, "vehicle_pos_x"), cache_get_field_float ( i, "vehicle_pos_y"), cache_get_field_float ( i, "vehicle_pos_z"),
					cache_get_field_float ( i, "vehicle_pos_a"), cache_get_field_int (i, "vehicle_color_a"), cache_get_field_int (i, "vehicle_color_b"), 0, cache_get_field_int (i, "vehicle_siren")) ;

				if (vehicleid == INVALID_VEHICLE_ID)
				{
					printf("VEH ERROR: tried to create invalid vehicle with SQL ID: %d, model: %d", cache_get_field_int (i, "vehicle_sqlid"), cache_get_field_int (i, "vehicle_modelid"));
					continue;
				}

				Vehicle_LoadFromRow(vehicleid, i);

				Vehicle [ vehicleid ] [ E_VEHICLE_ID ] = vehicleid ;

				SetVehicleNumberPlate(vehicleid, Vehicle [ vehicleid ] [ E_VEHICLE_LICENSE ] ) ;

				Vehicle_SetDoorsEngineStatus(vehicleid);

				Tune_ApplyComponents(-1, vehicleid ) ;

				if ( Vehicle [ vehicleid ] [ E_VEHICLE_HEALTH ] <= 250.0 ) {

					SOLS_SetVehicleHealth ( vehicleid, 300 );
				}

				else SOLS_SetVehicleHealth(vehicleid, Vehicle [ vehicleid ] [ E_VEHICLE_HEALTH ] );

				ChangeVehiclePaintjob(vehicleid, Vehicle [ vehicleid ] [ E_VEHICLE_PAINTJOB ] ) ;

				Vehicle_ClearTruckerVariables(vehicleid);
				Vehicle_ClearRuntimeVariables(vehicleid);
				Vehicle_RefundEmmetColt(vehicleid);
				
				
				VehicleVar [ vehicleid ] [ E_VEHICLE_RENTEDBY ] = INVALID_PLAYER_ID ;

				//Vehicle_Refund ( vehicleid ) ;
			}


			printf(" * [VEHICLE] Loaded %d vehicles.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT *,UNIX_TIMESTAMP(`vehicle_impounded_until`) AS `vehicle_impounded_until_unix` FROM `vehicles` WHERE `vehicle_type` != 3", using inline Vehicle_OnDataLoad, "" ) ;

	return true ;
}

Vehicle_GetType ( vehicleid ) {

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid ) ;

	if ( veh_enum_id == -1 ) {

		return -1 ;
	}

	return Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] ;
}

Vehicle_GetEnumID ( vehicleid ) {

	if ( vehicleid < 1 || vehicleid >= MAX_VEHICLES || ! IsValidVehicle ( vehicleid ) ) {

		return -1 ;
	}

	if ( Vehicle [ vehicleid ] [ E_VEHICLE_SQLID ] == -1 || Vehicle [ vehicleid ] [ E_VEHICLE_ID ] != vehicleid ) {

		return -1 ;
	}

	return vehicleid ;
}

Vehicle_GetEnumIDFromSQLID ( sql_id ) {

	new index = -1 ;

	for_loop ( new i = 1, j = sizeof ( Vehicle ); i < j; i ++ ) {

		if ( Vehicle [ i ] [ E_VEHICLE_SQLID ] == sql_id && IsValidVehicle ( i ) ) {
			index = i ;
			
			break;
		}

		else continue ;
	}

	return index ;
}


Vehicle_GetClosestEntity(playerid, Float: radius = 5.0) {

    new Float:fPos[3], Float:curdistance, currentVehicle = INVALID_VEHICLE_ID;
    
    for_loop(new v = 0; v < MAX_VEHICLES; v++) {

    	if ( IsValidVehicle ( v ) ) {
	        GetVehiclePos(v, fPos[0], fPos[1], fPos[2]);        
	        curdistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);
	        
	        if(curdistance < radius) {

	            currentVehicle = v;
	            radius = curdistance;
	        }
	    }
    }

    return currentVehicle;
}

/*
Vehicle_GetClosestEntity(playerid, Float: radius = 5.0) {
	new Float: x, Float: y, Float: z ;
	for_loop ( new i; i < MAX_VEHICLES; i ++ ) {

		if ( IsPlayerInRangeOfPoint ( playerid, radius, x, y, z ) ) {

			return i ;
		}

		else continue ;
	}

	return INVALID_VEHICLE_ID ;
}
*/
stock Vehicle_GetClosestEntity_SQL(playerid) {

	new Float: x, Float: y, Float: z ;


	for_loop ( new i; i < MAX_VEHICLES; i ++ ) {
		GetVehiclePos ( i, x, y, z ) ;

		if ( IsPlayerInRangeOfPoint ( playerid, 7.5, x, y, z ) ) {

			return Vehicle [ i ] [ E_VEHICLE_SQLID ] ;
		}

		else continue ;
	}

	return INVALID_VEHICLE_ID ;
}