enum E_PASSPOINT_DATA {

	E_PASSPOINT_SQLID,


	E_PASSPOINT_DESC [ 64 ],
	E_PASSPOINT_COLOR,

	E_PASSPOINT_TYPE,
	E_PASSPOINT_FACTION,
	Float: E_PASSPOINT_RADIUS,

	Float: E_PASSPOINT_POS_X,
	Float: E_PASSPOINT_POS_Y,
	Float: E_PASSPOINT_POS_Z,
	Float: E_PASSPOINT_POS_A,

	E_PASSPOINT_WORLD,
	E_PASSPOINT_INTERIOR,

	Float: E_PASSPOINT_LINKED_X,
	Float: E_PASSPOINT_LINKED_Y,
	Float: E_PASSPOINT_LINKED_Z,
	Float: E_PASSPOINT_LINKED_A,

	E_PASSPOINT_LINKED_WORLD,
	E_PASSPOINT_LINKED_INTERIOR,

	DynamicText3D: E_PASSPOINT_LABEL [ 2 ]
};

#if !defined MAX_PASSPOINTS 
	#define MAX_PASSPOINTS	( 400 )
#endif

#if !defined INVALID_PASSPOINT_ID
	#define INVALID_PASSPOINT_ID	(-1)
#endif

new Passpoint [ MAX_PASSPOINTS ] [ E_PASSPOINT_DATA ] ;

CMD:passpointcreate(playerid, params[]) 
{
	if (!CheckPassPointAdmin(playerid)) return true;

	new Float: x, Float: y, Float: z, Float: a;
	GetPlayerPos(playerid, x, y, z) ;
	GetPlayerFacingAngle(playerid, a) ;
	
	new type ;

	if ( sscanf ( params, "i", type ) ) {

		return SendClientMessage(playerid, -1, "/passpointcreate [type] (0: player, 1: vehicle)");
	}

	PassPoint_Create( playerid, type, x, y, z, a - 180.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid) ) ;
	return true ;
}

CMD:passcreate(playerid, params[])
{
	return cmd_passpointcreate(playerid, params);
}

PassPoint_GetFreeEntity() {

	for_loop ( new i, j = sizeof ( Passpoint ); i < j ; i ++ ) {

		if ( Passpoint [ i ] [ E_PASSPOINT_SQLID ] == INVALID_PASSPOINT_ID ) {

			return i ;	
		}

		else continue ;
	}

	return INVALID_PASSPOINT_ID ;
}

PassPoint_Create(playerid, type, Float: x, Float: y, Float: z, Float: angle, worldid, interiorid ) {

	new idx = PassPoint_GetFreeEntity() ;

	if ( idx == INVALID_PASSPOINT_ID ) {

		printf(" * [PASSPOINTS] Tried to create passpoint at %0.3f, %0.3f, %0.3f with type %d but creation function returned -1.", 
			x, y, z, type 
		);

		return true ;
	}


	Passpoint [ idx ] [ E_PASSPOINT_TYPE ] = type ;
	Passpoint [ idx ] [ E_PASSPOINT_FACTION ] = INVALID_FACTION_ID ;

	format ( Passpoint [ idx ] [ E_PASSPOINT_DESC ], 64, "Unnamed" ) ;
	Passpoint [ idx ] [ E_PASSPOINT_COLOR ] = 0xDEDEDEFF ;
	Passpoint [ idx ] [ E_PASSPOINT_RADIUS ] = 5.0 ;

	Passpoint [ idx ] [ E_PASSPOINT_POS_X ] = x ;
	Passpoint [ idx ] [ E_PASSPOINT_POS_Y ] = y ;
	Passpoint [ idx ] [ E_PASSPOINT_POS_Z ] = z ;
	Passpoint [ idx ] [ E_PASSPOINT_POS_A ] = angle ;

	Passpoint [ idx ] [ E_PASSPOINT_WORLD ] = worldid ;
 	Passpoint [ idx ] [ E_PASSPOINT_INTERIOR ] = interiorid ;
 	Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 0 ] = DynamicText3D: INVALID_3DTEXT_ID ;
 	Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 1 ] = DynamicText3D: INVALID_3DTEXT_ID ;

 	new query [ 512 + 1 ] ;

	mysql_format(mysql, query, sizeof ( query ), 
		"INSERT INTO passpoints( passpoint_desc, passpoint_color, passpoint_type, passpoint_faction, \
		passpoint_pos_x, passpoint_pos_y, passpoint_pos_z, passpoint_pos_a, passpoint_pos_world, passpoint_pos_interior, passpoint_radius) \
		VALUES ('%e', %d, %d, %d, '%f', '%f', '%f', '%f', %d, %d, '5.0')",

		Passpoint [ idx ] [ E_PASSPOINT_DESC ], Passpoint [ idx ] [ E_PASSPOINT_COLOR ], Passpoint [ idx ] [ E_PASSPOINT_TYPE ], 
		Passpoint [ idx ] [ E_PASSPOINT_FACTION ], Passpoint [ idx ] [ E_PASSPOINT_POS_X ], Passpoint [ idx ] [ E_PASSPOINT_POS_Y ],
		Passpoint [ idx ] [ E_PASSPOINT_POS_Z ], Passpoint [ idx ] [ E_PASSPOINT_POS_A ],  Passpoint [ idx ] [ E_PASSPOINT_WORLD ], 
		Passpoint [ idx ] [ E_PASSPOINT_INTERIOR ] 
	) ;

	inline Passpoint_OnDBInsert() {

		Passpoint [ idx ] [ E_PASSPOINT_SQLID ] = cache_insert_id ();
		printf(" * [PASSPOINT] Created passpoint (%d) with ID %d.", 
			idx, Passpoint [ idx ] [ E_PASSPOINT_SQLID ] ) ;
	
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("Passpoint created with ID %d (DATABASE %d). Don't forget to do /passpointradius!",

			idx, Passpoint [ idx ] [ E_PASSPOINT_SQLID ] ) ) ;

		PassPoint_SetupLabel(idx);
	}

	mysql_tquery_inline(mysql, query, using inline Passpoint_OnDBInsert, "");

	return true ;
}

PassPoint_SetupLabel(idx) {

	new string [ 256 ] ;

	format ( string, sizeof ( string ), "[%d] [%s]\n{DEDEDE}Available commands: /pass", idx, Passpoint [ idx ] [ E_PASSPOINT_DESC ] ) ;

	if ( IsValidDynamic3DTextLabel( Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 0 ] ) ) {

		DestroyDynamic3DTextLabel( Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 0 ] ) ;
		Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 0 ]  = DynamicText3D: INVALID_3DTEXT_ID ;
	}

	Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 0 ] = CreateDynamic3DTextLabel(string, Passpoint [ idx ] [ E_PASSPOINT_COLOR ], 
		Passpoint [ idx ] [ E_PASSPOINT_POS_X ], Passpoint [ idx ] [ E_PASSPOINT_POS_Y ], Passpoint [ idx ] [ E_PASSPOINT_POS_Z ],
		Passpoint [ idx ] [ E_PASSPOINT_RADIUS ],  INVALID_PLAYER_ID,  INVALID_VEHICLE_ID, true, Passpoint [ idx ] [ E_PASSPOINT_WORLD ], Passpoint [ idx ] [ E_PASSPOINT_INTERIOR ]
	);

	if ( IsValidDynamic3DTextLabel( Passpoint [ idx ] [ E_PASSPOINT_LABEL ]  [ 1 ]) ) {

		DestroyDynamic3DTextLabel( Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 1 ] ) ;
		Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 1 ]  = DynamicText3D: INVALID_3DTEXT_ID ;
	}

	Passpoint [ idx ] [ E_PASSPOINT_LABEL ] [ 1 ] = CreateDynamic3DTextLabel(string, Passpoint [ idx ] [ E_PASSPOINT_COLOR ], 
		Passpoint [ idx ] [ E_PASSPOINT_LINKED_X ], Passpoint [ idx ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ idx ] [ E_PASSPOINT_LINKED_Z ],
		Passpoint [ idx ] [ E_PASSPOINT_RADIUS ],  INVALID_PLAYER_ID,  INVALID_VEHICLE_ID, true, Passpoint [ idx ] [ E_PASSPOINT_LINKED_WORLD ], 
		Passpoint [ idx ] [ E_PASSPOINT_LINKED_INTERIOR ]
	);

}

PassPoint_LoadEntities() {

	for_loop ( new i, j = sizeof ( Passpoint ); i < j ; i ++ ) {

		Passpoint [ i ] [ E_PASSPOINT_SQLID ] = INVALID_PASSPOINT_ID ;
	}

	print(" * [PASSPOINTS] Loading all passpoints...");

	inline PassPoint_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) { 

				Passpoint [ i ] [ E_PASSPOINT_SQLID ]		= cache_get_field_int (i, "passpoint_sqlid");

				cache_get_field_content ( i, "passpoint_desc", Passpoint [ i ] [ E_PASSPOINT_DESC ], mysql, 64 ) ;
				Passpoint [ i ] [ E_PASSPOINT_COLOR ]		= cache_get_field_int (i, "passpoint_color");

				Passpoint [ i ] [ E_PASSPOINT_TYPE ]		= cache_get_field_int (i, "passpoint_type");
				Passpoint [ i ] [ E_PASSPOINT_FACTION ]		= cache_get_field_int (i, "passpoint_faction");

				Passpoint [ i ] [ E_PASSPOINT_RADIUS ] 		= cache_get_field_float (i, "passpoint_radius");

				Passpoint [ i ] [ E_PASSPOINT_POS_X ] 		= cache_get_field_float (i, "passpoint_pos_x");
				Passpoint [ i ] [ E_PASSPOINT_POS_Y ] 		= cache_get_field_float (i, "passpoint_pos_y");
				Passpoint [ i ] [ E_PASSPOINT_POS_Z ] 		= cache_get_field_float (i, "passpoint_pos_z");
				Passpoint [ i ] [ E_PASSPOINT_POS_A ] 		= cache_get_field_float (i, "passpoint_pos_a");

				Passpoint [ i ] [ E_PASSPOINT_WORLD ]		= cache_get_field_int (i, "passpoint_pos_world");
				Passpoint [ i ] [ E_PASSPOINT_INTERIOR ]	= cache_get_field_int (i, "passpoint_pos_interior");

				Passpoint [ i ] [ E_PASSPOINT_LINKED_X ]	= cache_get_field_float (i, "passpoint_linked_x");
				Passpoint [ i ] [ E_PASSPOINT_LINKED_Y ]	= cache_get_field_float (i, "passpoint_linked_y");
				Passpoint [ i ] [ E_PASSPOINT_LINKED_Z ]	= cache_get_field_float (i, "passpoint_linked_z");
				Passpoint [ i ] [ E_PASSPOINT_LINKED_A ]	= cache_get_field_float (i, "passpoint_linked_a");

				Passpoint [ i ] [ E_PASSPOINT_LINKED_WORLD ]	= cache_get_field_int (i, "passpoint_linked_world");
				Passpoint [ i ] [ E_PASSPOINT_LINKED_INTERIOR ]	= cache_get_field_int (i, "passpoint_linked_interior");

				PassPoint_SetupLabel(i);
			}

			printf(" * [PASSPOINTS] Loaded %d passpoints.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM passpoints", using inline PassPoint_OnDataLoad, "" ) ;

	return true ;
}
