enum E_GANGZONE_DATA {

	E_GANGZONE_SQLID,

	Float: E_GANGZONE_MIN_X,
	Float: E_GANGZONE_MIN_Y,

	Float: E_GANGZONE_MAX_X,
	Float: E_GANGZONE_MAX_Y,
	
	E_GANGZONE_FACTION,
	E_GANGZONE_CONTESTED,

	E_GANGZONE_ZONEID,
	E_GANGZONE_AREAID
} ;

#if !defined MAX_GANG_ZONES
	#define MAX_GANG_ZONES 1024 // samp default
#endif

#if !defined INVALID_GANGZONE_ID
	#define INVALID_GANGZONE_ID 	-1
#endif

new GangZone [ MAX_GANG_ZONES ] [ E_GANGZONE_DATA ] ;

GangZone_LoadEntities() {

	for ( new i, j = sizeof ( GangZone ); i < j ; i ++ ) {

		GangZone [ i ] [ E_GANGZONE_SQLID ] = INVALID_GANGZONE_ID ;
	}

	print(" * [GANGZONE] Loading all gangzones...");

	inline GangZone_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for ( new i; i < rows; i ++ ) { 

				GangZone [ i ] [ E_GANGZONE_SQLID ]			= cache_get_field_int (i, "gz_sqlid");

				GangZone [ i ] [ E_GANGZONE_MIN_X ] 		= cache_get_field_float (i, "gz_min_x");
				GangZone [ i ] [ E_GANGZONE_MIN_Y ] 		= cache_get_field_float (i, "gz_min_y");
				GangZone [ i ] [ E_GANGZONE_MAX_X ] 		= cache_get_field_float (i, "gz_max_x");
				GangZone [ i ] [ E_GANGZONE_MAX_Y ] 		= cache_get_field_float (i, "gz_max_y");
				
				GangZone [ i ] [ E_GANGZONE_FACTION ] 		= cache_get_field_int (i, "gz_faction");
				GangZone [ i ] [ E_GANGZONE_CONTESTED ] 	= cache_get_field_int (i, "gz_contested");

				SOLS_GangZoneCreate( GangZone [ i ] [ E_GANGZONE_ZONEID ], GangZone [ i ] [ E_GANGZONE_AREAID ],

					GangZone [ i ] [ E_GANGZONE_MIN_X ],
					GangZone [ i ] [ E_GANGZONE_MIN_Y ],
					GangZone [ i ] [ E_GANGZONE_MAX_X ],
					GangZone [ i ] [ E_GANGZONE_MAX_Y ]
				);

				GangZoneShowForAll(GangZone [ i ] [ E_GANGZONE_ZONEID ], GangZone_GetColour(GangZone [ i ] [ E_GANGZONE_FACTION ])) ;
			

				if ( GangZone [ i ] [ E_GANGZONE_CONTESTED ] ) {

					GangZoneFlashForAll(GangZone [ i ] [ E_GANGZONE_ZONEID ], 0xBA2920AA ) ;
				}
			}

			printf(" * [GANGZONE] Loaded %d gangzones.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM gangzones", using inline GangZone_OnDataLoad, "" ) ;

	return true ;
}

SOLS_GangZoneCreate( &gz_id, &area_id, Float: minx, Float: miny, Float: maxx, Float: maxy ) {

	gz_id = GangZoneCreate(
		minx, miny, maxx, maxy
	);

	area_id = CreateDynamicRectangle(minx, miny, maxx, maxy);
}

GetPlayerGangZone(playerid) {
    new Float:X1, Float:Y1, Float:Z1;
    GetPlayerPos(playerid, X1, Y1, Z1);

	for ( new i, j = sizeof ( GangZone ); i < j ; i ++ ) {


    	if(X1 > GangZone [ i ] [ E_GANGZONE_MIN_X ] && X1 < GangZone [ i ] [ E_GANGZONE_MAX_X ] && 
    		Y1 > GangZone [ i ] [ E_GANGZONE_MIN_Y ] && Y1 < GangZone [ i ] [ E_GANGZONE_MAX_Y ]) {

    		return i ;
    	}	
	}

	return INVALID_GANG_ZONE ;
}

bool: GangZone_IsPlayerInArea(playerid, index) {

	if ( IsPlayerInDynamicArea(playerid, GangZone [ index ] [ E_GANGZONE_AREAID ] ) ) {

		return true ;
	}

	return false ;
}

GangZone_GetColour(factionid) {

	switch ( factionid ) {

		case -1: {
			
			return 0xFFFFFF00 ;
		}
		case 0: {
			
			return 0x999999AA ;
		}

		default: {

			// Get faction hex here !

			new faction_enum_id = Faction_GetEnumID ( factionid ) ;

			if ( faction_enum_id == -1 ) {

				return 0x999999AA ;
			}

			new color = Faction [ faction_enum_id ] [ E_FACTION_HEXCOLOR ] ;
			new final_color = (((color) & 0xFFFFFF00) | ((99) & 0xFF)) ;

			return final_color ;
		}
	}

	return 0xFFFFFF00 ;
}