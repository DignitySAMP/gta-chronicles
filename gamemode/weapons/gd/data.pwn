enum E_GD_FACTORY_DATA {

	E_GD_FACT_ID,

	E_GD_FACT_WOOD,
	E_GD_FACT_METAL,
	E_GD_FACT_PARTS,

	E_GD_FACT_SLOT_TYPE 	[ 5 ],
	E_GD_FACT_SLOT_WOOD 	[ 5 ],
	E_GD_FACT_SLOT_METAL 	[ 5 ],
	E_GD_FACT_SLOT_PARTS 	[ 5 ],
	E_GD_FACT_SLOT_UNIX 	[ 5 ], // store unix time stamp of finished!

	E_GD_FACT_AMMO_TYPE 	[ 5 ],
	E_GD_FACT_AMMO_AMOUNT 	[ 5 ],
	E_GD_FACT_AMMO_PARTS 	[ 5 ],
	E_GD_FACT_AMMO_METAL 	[ 5 ],
	E_GD_FACT_AMMO_UNIX 	[ 5 ],

} ;

#if !defined GD_FACT_INVALID_ID
	#define GD_FACT_INVALID_ID	-1
#endif

#define MAX_FACTORIES	( 2 )
new GD_Factory [ MAX_FACTORIES ] [ E_GD_FACTORY_DATA ] ;


GD_Factory_FetchData () {

	new factory_clear [ E_GD_FACTORY_DATA ]  ;
	GD_Factory [ 0 ]  = factory_clear ;
	GD_Factory [ 1 ]  = factory_clear ;

	for_loop ( new i, j = 5; i < j ; i ++ ) {
		GD_Factory [ 0 ] [ E_GD_FACT_SLOT_TYPE ] [ i ] = -1 ;
		GD_Factory [ 1 ] [ E_GD_FACT_SLOT_TYPE ] [ i ] = -1 ;


		GD_Factory [ 0 ] [ E_GD_FACT_AMMO_TYPE ] [ i ] = -1 ;
		GD_Factory [ 1 ] [ E_GD_FACT_AMMO_TYPE ] [ i ] = -1 ;
	}

	print(" * [GD_Factory] Loading all weapons in construction...");

	inline GDFactory_OnDataLoad() {

		new rows, fields, query [ 1024 ] ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO gd_factory \
				(factory,wood, metal, parts, slot_0_type, slot_0_wood, slot_0_metal, slot_0_parts, \
				slot_1_type, slot_1_wood, slot_1_metal, slot_1_parts, slot_2_type, slot_2_wood, \
				slot_2_metal, slot_2_parts, slot_3_type, slot_3_wood, slot_3_metal, slot_3_parts, \
				slot_4_type, slot_4_wood, slot_4_metal, slot_4_parts, ammo_0_type,\
				ammo_0_amount, ammo_0_parts, ammo_0_metal, ammo_0_unix, ammo_1_type, ammo_1_amount, \
				ammo_1_parts, ammo_1_metal, ammo_1_unix, ammo_2_type, ammo_2_amount, ammo_2_parts, \
				ammo_2_metal, ammo_2_unix, ammo_3_type, ammo_3_amount, ammo_3_parts, ammo_3_metal, \
				ammo_3_unix, ammo_4_type, ammo_4_amount, ammo_4_parts, ammo_4_metal, ammo_4_unix) \
			VALUES ( 0, 150, 150, 150, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, \
			-1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0 )" );

			mysql_tquery(mysql, query);
			query[0] = EOS ;

			mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO gd_factory \
				(factory, wood, metal, parts, slot_0_type, slot_0_wood, slot_0_metal, slot_0_parts, \
				slot_1_type, slot_1_wood, slot_1_metal, slot_1_parts, slot_2_type, slot_2_wood, \
				slot_2_metal, slot_2_parts, slot_3_type, slot_3_wood, slot_3_metal, slot_3_parts, \
				slot_4_type, slot_4_wood, slot_4_metal, slot_4_parts, ammo_0_type,\
				ammo_0_amount, ammo_0_parts, ammo_0_metal, ammo_0_unix, ammo_1_type, ammo_1_amount, \
				ammo_1_parts, ammo_1_metal, ammo_1_unix, ammo_2_type, ammo_2_amount, ammo_2_parts, \
				ammo_2_metal, ammo_2_unix, ammo_3_type, ammo_3_amount, ammo_3_parts, ammo_3_metal, \
				ammo_3_unix, ammo_4_type, ammo_4_amount, ammo_4_parts, ammo_4_metal, ammo_4_unix) \
			VALUES ( 1, 150, 150, 150, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, \
			-1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0 )" );

			mysql_tquery(mysql, query);
		}

		if ( rows ) {

			for_loop ( new x, y = 2; x < y && x < rows ; x ++ ) {
				GD_Factory [ x ] [ E_GD_FACT_ID ] 						= cache_get_field_int ( x, "factory" ) ;
				
				GD_Factory [ x ] [ E_GD_FACT_WOOD ] 					= cache_get_field_int ( x, "wood" ) ;
				GD_Factory [ x ] [ E_GD_FACT_METAL ] 					= cache_get_field_int ( x, "metal" ) ; 
				GD_Factory [ x ] [ E_GD_FACT_PARTS ] 					= cache_get_field_int ( x, "parts" ) ;

				for_loop ( new i, j = 5 ; i < j ; i ++ ) {

					format ( query, sizeof ( query ), "slot_%d_type", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_SLOT_TYPE ] [ i ]  	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "slot_%d_wood", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_SLOT_WOOD ] [ i ]  	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "slot_%d_metal", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_SLOT_METAL ] [ i ]  	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "slot_%d_parts", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_SLOT_PARTS ] [ i ]  	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "slot_%d_unix", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_SLOT_UNIX ] [ i ]   	= cache_get_field_int ( x, query ) ;


					format ( query, sizeof ( query ), "ammo_%d_type", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_AMMO_TYPE ] [ i ] 		= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "ammo_%d_amount", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_AMMO_AMOUNT] [ i ] 	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "ammo_%d_parts", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_AMMO_PARTS ] [ i ] 	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "ammo_%d_metal", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_AMMO_METAL ] [ i ] 	= cache_get_field_int ( x, query ) ;
					format ( query, sizeof ( query ), "ammo_%d_unix", i ) ;
					GD_Factory [ x ] [ E_GD_FACT_AMMO_UNIX ] [ i ]	 	= cache_get_field_int ( x, query ) ;
				}
			}

			printf(" * [GD_Factory] Loaded %d weapons in construction.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM gd_factory", using inline GDFactory_OnDataLoad, "" ) ;

	return true ;
}

GD_Data_GetFreeSlot (factory) {

	for_loop ( new i, j = 5 ; i < j ; i ++ ) {

		if ( GD_Factory [factory] [ E_GD_FACT_SLOT_TYPE ] [ i ] == -1 ) {

			return i ;
		}
	}

	return -1 ;
}

GD_Data_GetFreeAmmoSlot (factory) {

	for_loop ( new i, j = 5 ; i < j ; i ++ ) {

		if ( GD_Factory [factory] [ E_GD_FACT_AMMO_TYPE ] [ i ] == -1 ) {

			return i ;
		}
	}

	return -1 ;
}
