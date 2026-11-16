enum E_PAYPHONE_DATA {

	E_PAYPHONE_SQLID,
	E_PAYPHONE_NUMBER,
	Float: E_PAYPHONE_POS_X,
	Float: E_PAYPHONE_POS_Y,
	Float: E_PAYPHONE_POS_Z,
	Float: E_PAYPHONE_FACING,
	E_PAYPHONE_WORLDID,
	E_PAYPHONE_INTERIORID,


	E_PAYPHONE_OBJECT,
	E_PAYPHONE_AREAID
} ;

enum {

	MAX_PAYPHONES = 100,
	INVALID_PAYPHONE_ID = -1
}

new Payphone [ MAX_PAYPHONES ] [ E_PAYPHONE_DATA ] ;
new Iterator:Payphones<MAX_PAYPHONES>;

CMD:payphonenumber(playerid, params[]) {

	if(!Payphone_IsPlayerNearPayphone ( playerid ) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near a payphone!");
	}

	new nearest_id = Payphone_GetNearestEntity(playerid) ;
	SendClientMessage(playerid, COLOR_YELLOW, sprintf("The number of this payphone is 1-800-%d.", Payphone [ nearest_id ] [ E_PAYPHONE_NUMBER ] ) ) ;

	return true ;
}

CMD:payphone(playerid, params[]) {

	new option [ 32 ] ;

	if ( sscanf ( params, "s[32]", option ) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "/payphone [create, delete, move, rot]" ) ;
	}

	new Float: x, Float: y, Float: z, Float: angle ;
	GetPlayerPos(playerid, x, y, z ) ;

	GetPlayerFacingAngle(playerid, angle);

	new nearest_id = Payphone_GetNearestEntity(playerid) , query [ 256 ] ;

	if(!strcmp(option, "create", true )) {
		GetXYInFrontOfPlayer(playerid, x, y, 1.0 ) ;

		Payphone_Create(x, y, z, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid) ) ;
	}
	else if(!strcmp(option, "delete", true )) {


		if(!Payphone_IsPlayerNearPayphone ( playerid ) ) {

			return SendClientMessage(playerid, COLOR_ERROR, "You're not near a payphone!");
		}

		if ( IsValidDynamicObject (Payphone [ nearest_id ] [ E_PAYPHONE_OBJECT ] ) ) {

			DestroyDynamicObject( Payphone [ nearest_id ] [ E_PAYPHONE_OBJECT ] ) ;
			Payphone [ nearest_id ] [ E_PAYPHONE_OBJECT ] = INVALID_STREAMER_ID ;
		}


		if ( IsValidDynamicArea( Payphone [ nearest_id ] [ E_PAYPHONE_AREAID ] )) {

			DestroyDynamicArea( Payphone [ nearest_id ] [ E_PAYPHONE_AREAID ] ) ;
			Payphone [ nearest_id ] [ E_PAYPHONE_AREAID ] = INVALID_STREAMER_ID ;
		}

		Iter_Remove(Payphones, nearest_id ) ;
		Payphone [ nearest_id ] [ E_PAYPHONE_SQLID ] = INVALID_PAYPHONE_ID ;

		mysql_format ( mysql, query, sizeof ( query ), "DELETE FROM payphones WHERE payphone_sqlid = %d", Payphone [ nearest_id ] [ E_PAYPHONE_SQLID ] ) ;
		mysql_tquery(mysql, query);

		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've deleted payphone ID %d.", nearest_id) ) ;
	}
	else if(!strcmp(option, "move", true )) {
		
		if(!Payphone_IsPlayerNearPayphone ( playerid ) ) {

			return SendClientMessage(playerid, COLOR_ERROR, "You're not near a payphone!");
		}

		GetXYInFrontOfPlayer(playerid, x, y, 2.5 ) ;

		Payphone [ nearest_id ] [ E_PAYPHONE_POS_X ] 		= x ;
		Payphone [ nearest_id ] [ E_PAYPHONE_POS_Y ] 		= y ;
		Payphone [ nearest_id ] [ E_PAYPHONE_POS_Z ] 		= z ;

		Payphone [ nearest_id ] [ E_PAYPHONE_WORLDID ]		= GetPlayerVirtualWorld(playerid) ;
		Payphone [ nearest_id ] [ E_PAYPHONE_INTERIORID]	= GetPlayerInterior(playerid) ;

		query[0]=EOS;
		mysql_format(mysql, query, sizeof ( query ), "UPDATE payphones SET payphone_pos_x = '%f', payphone_pos_y = '%f', payphone_pos_z = '%f', payphone_worldid = %d, payphone_interiorid = %d WHERE payphone_sqlid = %d",
			Payphone [ nearest_id ] [ E_PAYPHONE_POS_X ],
			Payphone [ nearest_id ] [ E_PAYPHONE_POS_Y ],
			Payphone [ nearest_id ] [ E_PAYPHONE_POS_Z ],
			Payphone [ nearest_id ] [ E_PAYPHONE_WORLDID ],
			Payphone [ nearest_id ] [ E_PAYPHONE_INTERIORID],
			Payphone [ nearest_id ] [ E_PAYPHONE_SQLID ]
		) ;

		mysql_tquery(mysql, query);

		Payphone_SetupVisuals(nearest_id);

		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've moved payphone ID %d to your location.", nearest_id) ) ;
	}
	else if(!strcmp(option, "rot", true )) {
		
		if(!Payphone_IsPlayerNearPayphone ( playerid ) ) {

			return SendClientMessage(playerid, COLOR_ERROR, "You're not near a payphone!");
		}

		Payphone [ nearest_id ] [ E_PAYPHONE_FACING ] 		= angle ;

		query[0]=EOS;
		mysql_format(mysql, query, sizeof ( query ), "UPDATE payphones SET payphone_facing = '%f' WHERE payphone_sqlid = %d",
			Payphone [ nearest_id ] [ E_PAYPHONE_FACING],
			Payphone [ nearest_id ] [ E_PAYPHONE_SQLID ]
		) ;

		mysql_tquery(mysql, query);

		Payphone_SetupVisuals(nearest_id);
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've rotated payphone ID %d to your facing angle.", nearest_id )) ;
	}

	return true ;
}

Payphone_IsPlayerNearPayphone(playerid) {

	new nearest_id = Payphone_GetNearestEntity ( playerid );

	if ( nearest_id == INVALID_PAYPHONE_ID ) {
		return false ;
	}

	if ( GetPlayerDistanceFromPoint(playerid, Payphone [ nearest_id ] [ E_PAYPHONE_POS_X ], Payphone [ nearest_id ] [ E_PAYPHONE_POS_Y ], Payphone [ nearest_id ] [ E_PAYPHONE_POS_Z ] ) < 5.0 ) {
		if ( GetPlayerVirtualWorld ( playerid ) == Payphone [ nearest_id ] [ E_PAYPHONE_WORLDID ] && GetPlayerInterior(playerid) == Payphone [ nearest_id ] [ E_PAYPHONE_INTERIORID ] ) {

			return true ;
		}
	}

	return false ;
}

Payphone_GetNearestEntity(playerid) {

	new Float: curdist, Float: olddist = 9999.9, nearest_id = INVALID_PAYPHONE_ID ;

	foreach(new payphone_id: Payphones) {

		if ( Payphone [ payphone_id ] [ E_PAYPHONE_SQLID ] != INVALID_PAYPHONE_ID ) {
			if ( GetPlayerVirtualWorld ( playerid ) == Payphone [ payphone_id ] [ E_PAYPHONE_WORLDID ] && GetPlayerInterior(playerid) == Payphone [ payphone_id ] [ E_PAYPHONE_INTERIORID ] ) {

				curdist = GetPlayerDistanceFromPoint(playerid, Payphone [ payphone_id ] [ E_PAYPHONE_POS_X ], Payphone [ payphone_id ] [ E_PAYPHONE_POS_Y ], Payphone [ payphone_id ] [ E_PAYPHONE_POS_Z ] ) ;

				if ( curdist < olddist ) {

					olddist = curdist ;
					nearest_id = payphone_id ;
				}
			}
		}
	}

	return nearest_id ;
}


Payphone_Create(Float: payphone_pos_x, Float: payphone_pos_y, Float: payphone_pos_z, Float: payphone_angle, payphone_vw, payphone_int ) {

	new payphone_id = Iter_Free(Payphones);

	Payphone [ payphone_id ] [ E_PAYPHONE_POS_X ] = payphone_pos_x ;
	Payphone [ payphone_id ] [ E_PAYPHONE_POS_Y ] = payphone_pos_y ;
	Payphone [ payphone_id ] [ E_PAYPHONE_POS_Z ] = payphone_pos_z ;
	Payphone [ payphone_id ] [ E_PAYPHONE_FACING ] = payphone_angle ;

	Payphone [ payphone_id ] [ E_PAYPHONE_WORLDID ]		= payphone_vw ;
	Payphone [ payphone_id ] [ E_PAYPHONE_INTERIORID]	= payphone_int ;

	Payphone_GenerateRandomDigits(Payphone [ payphone_id ] [ E_PAYPHONE_NUMBER ]);

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO payphones(payphone_pos_x, payphone_pos_y, payphone_pos_z, payphone_facing, payphone_number) VALUES ('%f', '%f', '%f', '%f', %d)",

		Payphone [ payphone_id ] [ E_PAYPHONE_POS_X ],
		Payphone [ payphone_id ] [ E_PAYPHONE_POS_Y ],
		Payphone [ payphone_id ] [ E_PAYPHONE_POS_Z ],
		Payphone [ payphone_id ] [ E_PAYPHONE_FACING ],
		Payphone [ payphone_id ] [ E_PAYPHONE_NUMBER ] 
	);

	inline Group_OnDatabaseInsert() {

		Payphone [ payphone_id ] [ E_PAYPHONE_SQLID ] = cache_insert_id ();
		printf(" * [Payphones] Created payphone (%d) with ID %d.", 
			payphone_id, Payphone [ payphone_id ] [ E_PAYPHONE_SQLID ] ) ;
		Iter_Add(Payphones, payphone_id);

		Payphone_SetupVisuals(payphone_id);

		return payphone_id ;
	}

	mysql_tquery_inline(mysql, query, using inline Group_OnDatabaseInsert, "");

	return INVALID_PAYPHONE_ID ;
}

Payphone_SetupVisuals(enum_id) {

	if ( IsValidDynamicObject (Payphone [ enum_id ] [ E_PAYPHONE_OBJECT ] ) ) {

		DestroyDynamicObject( Payphone [ enum_id ] [ E_PAYPHONE_OBJECT ] ) ;
		Payphone [ enum_id ] [ E_PAYPHONE_OBJECT ] = INVALID_STREAMER_ID ;
	}


	if ( IsValidDynamicArea( Payphone [ enum_id ] [ E_PAYPHONE_AREAID ] )) {

		DestroyDynamicArea( Payphone [ enum_id ] [ E_PAYPHONE_AREAID ] ) ;
		Payphone [ enum_id ] [ E_PAYPHONE_AREAID ] = INVALID_STREAMER_ID ;
	}

	Payphone [ enum_id ] [ E_PAYPHONE_OBJECT ] = CreateDynamicObject(1216, 
		Payphone [ enum_id ] [ E_PAYPHONE_POS_X ], Payphone [ enum_id ] [ E_PAYPHONE_POS_Y ], Payphone [ enum_id ] [ E_PAYPHONE_POS_Z ], 
		0.0, 0.0, Payphone [ enum_id ] [ E_PAYPHONE_FACING ], Payphone [ enum_id ] [ E_PAYPHONE_WORLDID ], Payphone [ enum_id ] [ E_PAYPHONE_INTERIORID]
	);

	Payphone [ enum_id ] [ E_PAYPHONE_AREAID ] = CreateDynamicCircle(Payphone [ enum_id ] [ E_PAYPHONE_POS_X ], 
		Payphone [ enum_id ] [ E_PAYPHONE_POS_Y ], 2.5, Payphone [ enum_id ] [ E_PAYPHONE_WORLDID ], 
		Payphone [ enum_id ] [ E_PAYPHONE_INTERIORID]
	);

	return true ;
}

Payphone_LoadEntities() {

	print(" * [PAYPHONES] Loading all payphones...");

	for(new i, j = MAX_PAYPHONES; i < j ; i ++ ) {

		Payphone [ i ] [ E_PAYPHONE_SQLID ] = INVALID_PAYPHONE_ID ;
	}

	inline Payphone_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for ( new i; i < rows; i ++ ) {

				Payphone [ i ] [ E_PAYPHONE_SQLID] 			= cache_get_field_int (i, "payphone_sqlid");
				Payphone [ i ] [ E_PAYPHONE_NUMBER ]		= cache_get_field_int (i, "payphone_number"); 

				Payphone [ i ] [ E_PAYPHONE_POS_X ] 		= cache_get_field_float (i, "payphone_pos_x");
				Payphone [ i ] [ E_PAYPHONE_POS_Y ] 		= cache_get_field_float (i, "payphone_pos_y");
				Payphone [ i ] [ E_PAYPHONE_POS_Z ] 		= cache_get_field_float (i, "payphone_pos_z");
				Payphone [ i ] [ E_PAYPHONE_FACING ] 		= cache_get_field_float (i, "payphone_facing");

				Payphone [ i ] [ E_PAYPHONE_WORLDID ]		= cache_get_field_int (i, "payphone_worldid"); 
				Payphone [ i ] [ E_PAYPHONE_INTERIORID]		= cache_get_field_int (i, "payphone_interiorid"); 

				printf("* [PAYPHONE] Loading payphone ID %d", Payphone [ i ] [ E_PAYPHONE_SQLID]  ) ;

				Payphone_SetupVisuals(i);
				Iter_Add(Payphones, i);
			}

			printf(" * [PAYPHONES] Loaded %d payphones.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM payphones", using inline Payphone_OnDataLoad, "" ) ;

}

Payphone_GenerateRandomDigits(&number){
	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), 
		"SELECT FLOOR(RAND() * 99999) AS random_num FROM payphones\
		WHERE \"random_num\" NOT IN ( SELECT payphone_number FROM payphones)\
		LIMIT 1;"
	) ;

	inline GenerateRandomNumber() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			number = cache_get_field_content_int ( 0, "random_num", mysql ) ;
		}
	}

	mysql_tquery_inline(mysql, query, using inline GenerateRandomNumber, "");

}

#include <YSI\y_hooks>

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA areaid) {
	
	foreach(new payphone_id: Payphones) {

		if ( Payphone [ payphone_id ] [ E_PAYPHONE_AREAID ] == areaid ) {
			ShowPlayerInfoMessage(playerid, "Use ~r~/call~w~ to use this payphone. It will cost ~r~$5~w~.", .height=285.0, .width = 200.0);
		}
	}

	return Y_HOOKS_CONTINUE_RETURN_1 ;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA areaid) {
		
	foreach(new payphone_id: Payphones) {

		if ( Payphone [ payphone_id ] [ E_PAYPHONE_AREAID ] == areaid ) {

			HidePlayerInfoMessage(playerid);
		}
	}

	return Y_HOOKS_CONTINUE_RETURN_1 ;
}