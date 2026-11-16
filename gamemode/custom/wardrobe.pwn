
enum {

	E_WARDROBE_ENTER = 0,
	E_WARDROBE_EXIT
}

enum E_PLAYER_CLOTHING_STOREDATA {

	E_PLAYER_CLOTHING_TUTORIAL,
	E_PLAYER_CLOTHING_STORE_TYPE,
	E_PLAYER_CLOTHING_STORE_OLDVW,

	bool: E_PLAYER_CLOTHING_STORE_CONFIRM,

	Menu: E_PLAYER_CLOTHING_STORE_MENU,
	E_PLAYER_CLOTHING_STORE_CP
} ;

new E_PLAYER_CLOTHING_STORE [ MAX_PLAYERS ] [ E_PLAYER_CLOTHING_STOREDATA ] ;

enum E_SELECTION_DATA {

	E_SELECTION_STATUS,
	E_SELECTION_OBJECT,
	Float: E_SELECTION_ROTATION,
	Timer: E_SELECTION_TIMER
}

new E_SELECTION_VAR [ MAX_PLAYERS ] [ E_SELECTION_DATA ] ;

public OnPlayerDisconnect(playerid, reason) {

	E_SELECTION_VAR [ playerid ] [ E_SELECTION_STATUS ] = 0 ;

	if ( IsValidDynamicObject( E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ] ) ) {

		DestroyDynamicObject(E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ]);
		E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ] = -1 ;
	}

	E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] = 0 ;
	stop E_SELECTION_VAR [ playerid ] [ E_SELECTION_TIMER ] ;

	#if defined cl_wb_OnPlayerDisconnect
		return cl_wb_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect cl_wb_OnPlayerDisconnect
#if defined cl_wb_OnPlayerDisconnect
	forward cl_wb_OnPlayerDisconnect(playerid, reason);
#endif


ClothingStore_SetupParameters(playerid) {
	if ( IsValidDynamicCP(E_PLAYER_CLOTHING_STORE [ playerid ] [ E_PLAYER_CLOTHING_STORE_CP ])) {

		DestroyDynamicCP( E_PLAYER_CLOTHING_STORE [ playerid ] [ E_PLAYER_CLOTHING_STORE_CP ] ) ;
		E_PLAYER_CLOTHING_STORE [ playerid ] [ E_PLAYER_CLOTHING_STORE_CP ] = -1 ;
	}

	E_PLAYER_CLOTHING_STORE [ playerid ] [ E_PLAYER_CLOTHING_STORE_CP ] = CreateDynamicCP( 
		258.0889, -39.7527, 1001.6426, 1.0, -1, -1, playerid
	);

	SetPlayerPos(playerid, 254.5016, -41.6267, 1001.6547);
	SetPlayerFacingAngle(playerid, 270);
	SetPlayerInterior(playerid, 14);
	UpdateZone(playerid, "Wardrobe");


	return true ;
}


Clothing_SetWardrobePosition(playerid ) {

	SetPlayerVirtualWorld(playerid, playerid ) ;

	TogglePlayerControllable(playerid, false);

	SetPlayerInterior(playerid, 14);

	SetPlayerPos(playerid, 258.0889, -39.7527, 1001.6426);
	SetPlayerFacingAngle(playerid, 90);

	SetPlayerCameraPos(playerid, 256.0844, -42.2395, 1002.5934);
	SetPlayerCameraLookAt(playerid, 256.8381, -41.5845, 1002.5043);

	if ( IsValidDynamicObject( E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ] ) ) {

		DestroyDynamicObject(E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ]);
	}

	E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ] = CreateDynamicObject(1567, 257.39081, -39.12209, 1000.88922,   0.00000, 0.00000, 0.00000, .playerid = playerid );
	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	
	ClothingStore_EnterWardrobe(playerid);
	return true ;
}


timer Binco_SetupTimer[250](playerid) {


	E_SELECTION_VAR [ playerid ] [ E_SELECTION_STATUS ] = 0 ;
	E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] = 0 ;

	stop E_SELECTION_VAR [ playerid ] [ E_SELECTION_TIMER ] ;
	E_SELECTION_VAR [ playerid ] [ E_SELECTION_TIMER ] = repeat BINCO_DOOR_IN[50](playerid);
}


timer BINCO_DOOR_IN[50](playerid) {

	switch ( E_SELECTION_VAR [ playerid ] [ E_SELECTION_STATUS ] ) {

		case 0: {

			if ( E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] <= 60.0 ) {

				E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] += 2.5 ;
			}

			else E_SELECTION_VAR [ playerid ] [ E_SELECTION_STATUS ] ++ ;
		}

		case 1: {

			if ( E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] >= -10.00 ) {

				E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] -= 2.5 ;
			}
			else E_SELECTION_VAR [ playerid ] [ E_SELECTION_STATUS ] ++ ;
		}

		case 2: {
			if ( E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] < 0.0 ) {

				E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] += 2.5 ;
			}

			else {

				E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ] = 0.0 ;
				stop E_SELECTION_VAR [ playerid ] [ E_SELECTION_TIMER ] ;
			}
		}
	}

	SetDynamicObjectRot(E_SELECTION_VAR [ playerid ] [ E_SELECTION_OBJECT ], 0.0, 0.0, E_SELECTION_VAR [ playerid ] [ E_SELECTION_ROTATION ]);
	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

	return true ;
}



ClothingStore_EnterWardrobe(playerid) {

	ApplyAnimation(playerid, "CLOTHES", "CLO_IN", 4.1, 0, 0, 0, 1, 0, 1);
	defer Binco_SetupTimer(playerid);
}

ClothingStore_ExitWardrobe(playerid) {

	// Make it so a audio file "it was a pleasure sir" etc plays like in
	// https://youtu.be/KHBs7iA6JRU?t=197

	// Find a way to fix the 1s flash where the player is put to their starting position!

	ApplyAnimation(playerid, "CLOTHES", "CLO_OUT", 4.1, 0, 0, 0, 1, 0, 1);
	defer Binco_SetupTimer(playerid);
}
