#define KIOSK_MAX_GUNS 		( 5 )

enum KioskData {

	E_KIOSK_ID,
	E_KIOSK_NAME	[ 256 ],

	E_KIOSK_FACTION,

	Float: E_KIOSK_POS_X,
	Float: E_KIOSK_POS_Y,
	Float: E_KIOSK_POS_Z,

	E_KIOSK_POS_INT,
	E_KIOSK_POS_VW,

	E_KIOSK_WEAPON [ KIOSK_MAX_GUNS ],
	E_KIOSK_WEAPONAMMO [ KIOSK_MAX_GUNS ],

	DynamicText3D: E_KIOSK_LABEL,
	E_KIOSK_SQUAD

} ;

#define MAX_KIOSKS			( 25 )
#define INVALID_KIOSK_ID	( -1 )
#define MAX_KIOSK_NAME		( 256 )

new Kiosk [ MAX_KIOSKS ] [ KioskData ] ;

public OnGameModeInit() {

	for_loop ( new i, j = sizeof ( Kiosk ); i < j ; i++ ) {

		Kiosk [ i ] [ E_KIOSK_ID] = INVALID_KIOSK_ID ;
	}
	
	#if defined kiosk_OnGameModeInit
		return kiosk_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit kiosk_OnGameModeInit
#if defined kiosk_OnGameModeInit
	forward kiosk_OnGameModeInit();
#endif

Kiosk_Create(name[MAX_KIOSK_NAME], Float: coord_x, Float: coord_y, Float: coord_z, coord_int, coord_vw ) {

	new kiosk_id = Kiosk_GetFreeID (); 

	if ( kiosk_id == INVALID_KIOSK_ID ) {

		print(" * [KIOSK] KIOSK_Create hit INVALID_KIOSK_ID, most likely because no ID is free.");
		return true ;
	} 

	Kiosk [ kiosk_id ] [ E_KIOSK_NAME ] [ 0 ] 		= EOS ;
	strcat(Kiosk [ kiosk_id ] [ E_KIOSK_NAME ], name ) ;

	Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ]			= INVALID_FACTION_ID ;

	Kiosk [ kiosk_id ] [ E_KIOSK_POS_X ]			= coord_x ;
	Kiosk [ kiosk_id ] [ E_KIOSK_POS_Y ]			= coord_y ;
	Kiosk [ kiosk_id ] [ E_KIOSK_POS_Z ]			= coord_z ;

	Kiosk [ kiosk_id ] [ E_KIOSK_POS_INT ]			= coord_int ;
	Kiosk [ kiosk_id ] [ E_KIOSK_POS_VW ]			= coord_vw ;

	// No need to set weapons because starting ID = 0

	new query [ 512 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO kiosks (kiosk_name, kiosk_faction, kiosk_pos_x, kiosk_pos_y, kiosk_pos_z, kiosk_pos_int, kiosk_pos_vw) VALUES ('%e', %d, '%f', '%f', '%f', %d, %d)",
		Kiosk [ kiosk_id ] [ E_KIOSK_NAME ], Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_X ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_Y ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_Z ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_INT ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_VW ]
	) ; 

	inline Kiosk_OnDatabaseInsert() {

		Kiosk [ kiosk_id ] [ E_KIOSK_ID ] = cache_insert_id ();

		printf(" * [KIOSK] Created kiosk (%d) with ID %d.", 
			kiosk_id, Kiosk [ kiosk_id ] [ E_KIOSK_ID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Kiosk_OnDatabaseInsert, "");
	
	Kiosk_UpdateLabels (kiosk_id); 

	return true ;
}

Kiosk_LoadEntities() {

	print(" * [KIOSK] Loading all kiosks...");

	inline Kiosk_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) {

				Kiosk [ i ] [ E_KIOSK_ID ] = cache_get_field_int (i, "kiosk_id");

				cache_get_field_content ( i, "kiosk_name", Kiosk [ i ] [ E_KIOSK_NAME ], mysql, MAX_PLAYER_NAME ) ;


				Kiosk [ i ] [ E_KIOSK_FACTION ] = cache_get_field_int (i, "kiosk_faction");
				Kiosk [ i ] [ E_KIOSK_SQUAD ] = cache_get_field_int (i, "kiosk_squad");

				Kiosk [ i ] [ E_KIOSK_POS_X ] = cache_get_field_float ( i, "kiosk_pos_x");
				Kiosk [ i ] [ E_KIOSK_POS_Y ] = cache_get_field_float ( i, "kiosk_pos_y");
				Kiosk [ i ] [ E_KIOSK_POS_Z ] = cache_get_field_float ( i, "kiosk_pos_z");

				Kiosk [ i ] [ E_KIOSK_POS_INT ] = cache_get_field_int (i, "kiosk_pos_int");
				Kiosk [ i ] [ E_KIOSK_POS_VW ] = cache_get_field_int (i, "kiosk_pos_vw");

				Kiosk [ i ] [ E_KIOSK_WEAPON ] [ 0 ] = cache_get_field_int (i, "kiosk_weapon1");
				Kiosk [ i ] [ E_KIOSK_WEAPONAMMO ] [ 0 ] = cache_get_field_int (i, "kiosk_weapon1ammo");

				Kiosk [ i ] [ E_KIOSK_WEAPON ] [ 1 ] = cache_get_field_int (i, "kiosk_weapon2");
				Kiosk [ i ] [ E_KIOSK_WEAPONAMMO ] [ 1 ] = cache_get_field_int (i, "kiosk_weapon2ammo");

				Kiosk [ i ] [ E_KIOSK_WEAPON ] [ 2 ] = cache_get_field_int (i, "kiosk_weapon3");
				Kiosk [ i ] [ E_KIOSK_WEAPONAMMO ] [ 2 ] = cache_get_field_int (i, "kiosk_weapon3ammo");

				Kiosk [ i ] [ E_KIOSK_WEAPON ] [ 3 ] = cache_get_field_int (i, "kiosk_weapon4");
				Kiosk [ i ] [ E_KIOSK_WEAPONAMMO ] [ 3 ] = cache_get_field_int (i, "kiosk_weapon4ammo");

				Kiosk [ i ] [ E_KIOSK_WEAPON ] [ 4 ] = cache_get_field_int (i, "kiosk_weapon5");
				Kiosk [ i ] [ E_KIOSK_WEAPONAMMO ] [ 4 ] = cache_get_field_int (i, "kiosk_weapon5ammo");

				Kiosk_UpdateLabels ( i ) ;
			}

			printf(" * [KIOSK] Loaded %d kiosks.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM kiosks", using inline Kiosk_OnDataLoad, "" ) ;

	return true ;
}

Kiosk_UpdateLabels ( kiosk_id ) {

	if ( ! IsValidDynamic3DTextLabel( Kiosk [ kiosk_id ] [ E_KIOSK_LABEL ] ) ) {
 
		Kiosk [ kiosk_id ] [ E_KIOSK_LABEL ] = CreateDynamic3DTextLabel(sprintf("[%d] [%s]\n{DEDEDE}Commands: /kt, /kr, /kev(lar), /duty", kiosk_id, Kiosk [ kiosk_id ] [ E_KIOSK_NAME ]),  
			0x1F8FDEFF, Kiosk [ kiosk_id ] [ E_KIOSK_POS_X ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_Y ],  Kiosk [ kiosk_id ] [ E_KIOSK_POS_Z ], 15.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Kiosk [ kiosk_id ] [ E_KIOSK_POS_VW ], Kiosk [ kiosk_id ] [ E_KIOSK_POS_INT] );	
	}

	UpdateDynamic3DTextLabelText(Kiosk [ kiosk_id ] [ E_KIOSK_LABEL ], 0x1F8FDEFF, sprintf("[%d] [%s]\n{DEDEDE}Commands: /kt, /kr, /kev(lar), /duty", kiosk_id, Kiosk [ kiosk_id ] [ E_KIOSK_NAME ] ) );

	return true ;
}


Kiosk_GetFreeID () {

	for_loop ( new i, j = sizeof ( Kiosk ); i < j ; i ++ ) {

		if ( Kiosk [ i ] [ E_KIOSK_ID ] == INVALID_KIOSK_ID ) {

			return i ;
		}

		else continue ;
	}

	return INVALID_KIOSK_ID ; 
}