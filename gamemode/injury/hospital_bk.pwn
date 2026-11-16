enum E_HOSPITAL_DATA {

	E_HOSPITAL_NAME [ 32 ],
	Float: E_HOSPITAL_POS_X,
	Float: E_HOSPITAL_POS_Y,
	Float: E_HOSPITAL_POS_Z
}

new Hospital [ ] [ E_HOSPITAL_DATA ] = {

	{ "County General Hospital", 2036.4144,-1403.5132,17.2828 },
	{ "All Saints General Hospital", 1221.5454,-1427.2352,13.3735  }
} ;

Injury_LoadEntities() {
	CreateDynamic3DTextLabel(sprintf("[Hospital Booth]\n{DEDEDE}Available Commands: /surgery\nWarning: Surgery may cost up to $250!" ), COLOR_RED, 
		-1303.1973,-572.7416,14.2180,
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,-1, -1, -1 );

	// Surgery point to remove arm/leg dmg & refill hp
	for_loop ( new i, j = sizeof ( Hospital ); i < j ; i ++ ) {

		CreateDynamic3DTextLabel(sprintf("[%s]\n{DEDEDE}Available Commands: /enter", Hospital [ i ] [ E_HOSPITAL_NAME ]), COLOR_RED, 
			Hospital [ i ] [ E_HOSPITAL_POS_X ], Hospital [ i ] [ E_HOSPITAL_POS_Y ], Hospital [ i ] [ E_HOSPITAL_POS_Z ],
			15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1 );

		CreateDynamicPickup(1240, 1, Hospital [ i ] [ E_HOSPITAL_POS_X ], Hospital [ i ] [ E_HOSPITAL_POS_Y ], Hospital [ i ] [ E_HOSPITAL_POS_Z ] );
		CreateDynamicMapIcon(Hospital [ i ] [ E_HOSPITAL_POS_X ], Hospital [ i ] [ E_HOSPITAL_POS_Y ], Hospital [ i ] [ E_HOSPITAL_POS_Z ], 22, 0, -1, -1, -1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL );
	}
}

Hospital_Enter(playerid) {

	new idx = IsPlayerNearHospital(playerid) ;

	if ( idx == -1 ) {

		return false ;
	}

	SetPlayerVirtualWorld(playerid, idx + 1) ;
	SOLS_SetPlayerPos ( playerid, -1292.1708, -569.1397, 14.2180 ) ;

	return true ;
}

Hospital_Exit(playerid) {

	new idx = GetPlayerVirtualWorld(playerid) ;

	switch ( idx ) {

		case 1: {
			SOLS_SetPlayerPos(playerid, Hospital [ 0 ] [ E_HOSPITAL_POS_X ], Hospital [ 0 ] [ E_HOSPITAL_POS_Y ], Hospital [ 0 ] [ E_HOSPITAL_POS_Z ] ) ;
			SetPlayerVirtualWorld(playerid, 0);
		}

		case 2:	{
			SOLS_SetPlayerPos(playerid, Hospital [ 1 ] [ E_HOSPITAL_POS_X ], Hospital [ 1 ] [ E_HOSPITAL_POS_Y ], Hospital [ 1 ] [ E_HOSPITAL_POS_Z ] ) ;
			SetPlayerVirtualWorld(playerid, 0);
		}

		default: {
			return true ;
		}
	}

	return true ;
}

IsPlayerNearHospital(playerid) {

	for_loop ( new i, j = sizeof ( Hospital ); i < j ; i ++ ) {

		if ( IsPlayerInRangeOfPoint(playerid, 5.0, Hospital [ i ] [ E_HOSPITAL_POS_X ], Hospital [ i ] [ E_HOSPITAL_POS_Y ], Hospital [ i ] [ E_HOSPITAL_POS_Z ] ) ) {

			return i ;
		}
	}

	return -1 ;
}