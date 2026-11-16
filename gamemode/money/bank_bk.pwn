enum E_BANK_DATA {

	E_BANK_SQLID,
	Float: E_BANK_POS_X,
	Float: E_BANK_POS_Y,
	Float: E_BANK_POS_Z,

	E_BANK_VW,

	E_BANK_MAPICON,
	E_BANK_PICKUP,
	DynamicText3D: E_BANK_LABEL
} ;

#if !defined MAX_BANKS
	#define MAX_BANKS 25 
#endif

#if !defined INVALID_BANK_ID
	#define INVALID_BANK_ID -1
#endif

#if !defined BANK_MAP_ICON
	#define BANK_MAP_ICON	52
#endif

#if !defined BANK_PICKUP_MODEL
	#define BANK_PICKUP_MODEL 1274
#endif

#if !defined BANK_INTERACT_POINT_X
	#define BANK_INTERACT_POINT_X	(2850.3521)
#endif
#if !defined BANK_INTERACT_POINT_Y
	#define BANK_INTERACT_POINT_Y	(-1418.0033)
#endif
#if !defined BANK_INTERACT_POINT_Z
	#define BANK_INTERACT_POINT_Z	(45.2449)
#endif

new Bank [ MAX_BANKS ] [ E_BANK_DATA ] ;

CMD:bankcreate(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Bank_CreateEntity(x, y, z ) ;

	return true ;
}

Bank_IsNearPoint(playerid) {

	if ( GetPlayerInterior(playerid) != 1 ) {

		return false ;
	}

	if ( IsPlayerInRangeOfPoint(playerid, 3.5, BANK_INTERACT_POINT_X, BANK_INTERACT_POINT_Y, BANK_INTERACT_POINT_Z)) {

		return true ;
	}

	return false ;
}

Bank_Enter(playerid) {

	new bank_enum_id = Bank_GetClosestEntity(playerid) ;

	if ( bank_enum_id == INVALID_BANK_ID ) {

		return true ;
	}

	switch ( random ( 2 ) ) {

		case 1: {

			SOLS_SetPlayerPos(playerid, 2859.3066,-1419.7129,45.2611);
			SetPlayerFacingAngle(playerid, 93.8737);
		}

		default: {

			SOLS_SetPlayerPos(playerid, 2859.5342,-1416.6113,45.2611 );
			SetPlayerFacingAngle(playerid, 87.6069 );
		}
	}

	SetPlayerVirtualWorld(playerid, Bank [ bank_enum_id ] [ E_BANK_VW ] ) ;
	SetPlayerInterior(playerid, 1);

	return true ;
}

Bank_Exit(playerid) {

	if ( IsPlayerInRangeOfPoint(playerid, 4.5, 2859.3066,-1419.7129,45.2611 ) || 
		IsPlayerInRangeOfPoint(playerid, 4.5, 2859.5342,-1416.6113,45.2611  )) {

		for_loop ( new i, j = sizeof ( Bank ); i < j ; i ++ ) {

			if ( GetPlayerVirtualWorld(playerid) == Bank [ i ] [ E_BANK_VW ] ) {

				SetPlayerPos( playerid, Bank [ i ] [ E_BANK_POS_X ], Bank [ i ] [ E_BANK_POS_Y ], Bank [ i ] [ E_BANK_POS_Z ]) ;
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				break ;
			}

			else continue ;
		}
	}

	return true ;
}

Bank_GetClosestEntity(playerid) {

	for_loop ( new i, j = sizeof ( Bank ); i < j ; i ++ ) {

		if ( IsPlayerInRangeOfPoint(playerid, 4.5, 
			Bank [ i ] [ E_BANK_POS_X ],
			Bank [ i ] [ E_BANK_POS_Y ],
			Bank [ i ] [ E_BANK_POS_Z ]
		) ) {

			return i ;
		}
	}

	return INVALID_BANK_ID ;
}

Bank_CreateEntity(Float: bank_pos_x, Float: bank_pos_y,Float: bank_pos_z ) {

	new bank_enum_id = Bank_GetFreeID();

	if ( bank_enum_id == INVALID_BANK_ID ) {

		return printf(" * [BANK] Bank_CreateEntity() returned INVALID_BANK_ID (%d). Either all slots are filled or enum isn't set up.",
			INVALID_BANK_ID ) ;
	}

	Bank [ bank_enum_id ] [ E_BANK_POS_X ] = bank_pos_x ;
	Bank [ bank_enum_id ] [ E_BANK_POS_Y ] = bank_pos_y ;
	Bank [ bank_enum_id ] [ E_BANK_POS_Z ] = bank_pos_z ;

	Bank [ bank_enum_id ] [ E_BANK_VW ] = bank_enum_id + 1 ;


	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO banks (bank_pos_x, bank_pos_y, bank_pos_z, bank_vw) VALUES ('%f', '%f', '%f', %d)",
		Bank [ bank_enum_id ] [ E_BANK_POS_X ], Bank [ bank_enum_id ] [ E_BANK_POS_Y ], Bank [ bank_enum_id ] [ E_BANK_POS_Z ], Bank [ bank_enum_id ] [ E_BANK_VW ]
	 ) ;

	inline Bank_OnDatabaseInsert() {

		Bank [ bank_enum_id ] [ E_BANK_SQLID ] = cache_insert_id ();
		printf(" * [BANK] Created bank (%d) with ID %d.", 
			bank_enum_id, Bank [ bank_enum_id ] [ E_BANK_SQLID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Bank_OnDatabaseInsert, "");

	if ( IsValidDynamicMapIcon(Bank [ bank_enum_id ] [ E_BANK_MAPICON ] ) ) {

		DestroyDynamicMapIcon(Bank [ bank_enum_id ] [ E_BANK_MAPICON ] ) ;
	}
	if ( IsValidDynamicPickup(Bank [ bank_enum_id ] [ E_BANK_PICKUP ] ) ) {

		DestroyDynamicPickup(Bank [ bank_enum_id ] [ E_BANK_PICKUP ] ) ;
	}

	if ( IsValidDynamic3DTextLabel(Bank [ bank_enum_id ] [ E_BANK_LABEL ] ) ) {

		DestroyDynamic3DTextLabel(Bank [ bank_enum_id ] [ E_BANK_LABEL ] ) ;
	}

	Bank [ bank_enum_id ] [ E_BANK_MAPICON ] = CreateDynamicMapIcon(Bank [ bank_enum_id ] [ E_BANK_POS_X ], 
		Bank [ bank_enum_id ] [ E_BANK_POS_Y ], Bank [ bank_enum_id ] [ E_BANK_POS_Z ], BANK_MAP_ICON, 0, -1, -1, 
		-1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL
	);

	Bank [ bank_enum_id ] [ E_BANK_PICKUP ] = CreateDynamicPickup(BANK_PICKUP_MODEL, 1, Bank [ bank_enum_id ] [ E_BANK_POS_X ], 
		Bank [ bank_enum_id ] [ E_BANK_POS_Y ], Bank [ bank_enum_id ] [ E_BANK_POS_Z ] );


    new address_name [ 64 ] ;
    GetCoords2DZone (Bank [ bank_enum_id ] [ E_BANK_POS_X ], Bank [ bank_enum_id ] [ E_BANK_POS_Y ], address_name, sizeof ( address_name) );

	Bank [ bank_enum_id ] [ E_BANK_LABEL ] = CreateDynamic3DTextLabel(sprintf("[Bank of %s]\n{DEDEDE}Available Commands: /deposit, /withdraw", address_name), COLOR_BLUE,  
		Bank [ bank_enum_id ] [ E_BANK_POS_X ], Bank [ bank_enum_id ] [ E_BANK_POS_Y ], Bank [ bank_enum_id ] [ E_BANK_POS_Z ], 15.0
	) ;

	return true ;
}

Bank_GetFreeID() {

	for_loop ( new i, j = sizeof ( Bank ); i < j ; i ++ ) {

		if ( Bank [ i ] [ E_BANK_SQLID ] == INVALID_BANK_ID ) {

			return i ;
		}

		else continue ;
	}

	return INVALID_BANK_ID ;
}



Bank_LoadEntities() {

	for_loop ( new i, j = sizeof ( Bank ); i < j; i ++ ) {

		Bank [ i ] [ E_BANK_SQLID ] = INVALID_BANK_ID ;
	}

	CreateDynamic3DTextLabel("[Bank Till]\n{DEDEDE}Available Commands: /deposit, /withdraw, /balance", COLOR_BLUE,
		BANK_INTERACT_POINT_X, BANK_INTERACT_POINT_Y, BANK_INTERACT_POINT_Z,
	15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 1, -1 );

	CreateDynamicPickup(1274, 1, BANK_INTERACT_POINT_X, BANK_INTERACT_POINT_Y, BANK_INTERACT_POINT_Z,  -1, 1) ;

	print(" * [BANK] Loading all banks...");

	inline Bank_OnDataLoad() {

		new rows, fields, address_name [ 64 ] ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) { 

				Bank [ i ] [ E_BANK_SQLID ] = cache_get_field_int (i, "bank_sqlid");
				Bank [ i ] [ E_BANK_POS_X ] = cache_get_field_float (i, "bank_pos_x");
				Bank [ i ] [ E_BANK_POS_Y ] = cache_get_field_float (i, "bank_pos_y");
				Bank [ i ] [ E_BANK_POS_Z ] = cache_get_field_float (i, "bank_pos_z");

				Bank [ i ] [ E_BANK_VW ] = cache_get_field_int (i, "bank_vw");

				if ( IsValidDynamicMapIcon(Bank [ i ] [ E_BANK_MAPICON ] ) ) {

					DestroyDynamicMapIcon(Bank [ i ] [ E_BANK_MAPICON ] ) ;
				}
				if ( IsValidDynamicPickup(Bank [ i ] [ E_BANK_PICKUP ] ) ) {

					DestroyDynamicPickup(Bank [ i ] [ E_BANK_PICKUP ] ) ;
				}

				if ( IsValidDynamic3DTextLabel(Bank [ i ] [ E_BANK_LABEL ] ) ) {

					DestroyDynamic3DTextLabel(Bank [ i ] [ E_BANK_LABEL ] ) ;
				}

				Bank [ i ] [ E_BANK_MAPICON ] = CreateDynamicMapIcon(Bank [ i ] [ E_BANK_POS_X ], 
					Bank [ i ] [ E_BANK_POS_Y ], Bank [ i ] [ E_BANK_POS_Z ], BANK_MAP_ICON, 0, -1, -1, 
					-1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL
				);

				Bank [ i ] [ E_BANK_PICKUP ] = CreateDynamicPickup(BANK_PICKUP_MODEL, 1, Bank [ i ] [ E_BANK_POS_X ], 
					Bank [ i ] [ E_BANK_POS_Y ], Bank [ i ] [ E_BANK_POS_Z ] );

			    GetCoords2DZone (Bank [ i ] [ E_BANK_POS_X ], Bank [ i ] [ E_BANK_POS_Y ], address_name, sizeof ( address_name) );

				Bank [ i ] [ E_BANK_LABEL ] = CreateDynamic3DTextLabel(sprintf("[Bank of %s]\n{DEDEDE}Available Commands: /deposit, /withdraw", address_name), COLOR_BLUE,  
					Bank [ i ] [ E_BANK_POS_X ], Bank [ i ] [ E_BANK_POS_Y ], Bank [ i ] [ E_BANK_POS_Z ], 15.0
				) ;

			}

			printf(" * [BANKS] Loaded %d banks.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM banks", using inline Bank_OnDataLoad, "" ) ;

	return true ;
}