enum E_PNS_DATA {

	Float: E_PNS_POS_X,
	Float: E_PNS_POS_Y,
	Float: E_PNS_POS_Z
} ;

new E_PNS_LOCATIONS [ ] [ E_PNS_DATA ] = {

	{ 1296.8934, -1865.5447, 13.5972 }, // Pershing Square PNS
	{ 207.11590, -1446.4102, 13.1596 }, // Rodeo PNS
	{ 1833.8820, -1398.2865, 13.4297 },  // Glen Park PNS
	{ 2334.9880, -1991.6436, 13.5587 }  // Willowfield PNS

// Singleplayer synced:
//	{ 488.1379, 	-1736.0763, 	11.1361 }, 
//	{ 2069.3032, 	-1831.6302, 	13.5469 }, 
//	{ 1025.0696, 	-1027.0427, 	32.2115 }, 
//	{ 720.0503, 	-460.8181, 		16.3359 }, 
//	{ -1904.2681, 	280.9200, 		41.0469 }, 
//	{ -1786.7745, 	1211.7026, 		25.1250 }, 
//	{ -2425.4919, 	1024.0526, 		50.3977 }, 
//	{ 1972.2549, 	2162.6399, 		11.0703 }, 
//	{ 2393.7703, 	1491.3065, 		10.8203 }, 
//	{ -100.2000,	1116.6593, 		19.7417 }, 
//	{ -1420.3933, 	2585.1287, 		55.8433 }
}, E_PNS_CP [ sizeof ( E_PNS_LOCATIONS ) ] ;

PNS_LoadEntities() {

	for ( new i, j =sizeof ( E_PNS_LOCATIONS ); i < j ; i ++ ) {

		E_PNS_CP [ i ] = CreateDynamicCP(E_PNS_LOCATIONS [ i ] [ E_PNS_POS_X ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Y ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Z ], 5.0, -1, -1, -1, 10.0 );
		CreateDynamicMapIcon(E_PNS_LOCATIONS [ i ] [ E_PNS_POS_X ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Y ], E_PNS_LOCATIONS [ i ] [ E_PNS_POS_Z ], 63, -1);
	}

	foreach(new playerid: Player) {

		TogglePlayerControllable(playerid, true);
	}

	return true ;
}

public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {

	for ( new i, j =sizeof ( E_PNS_LOCATIONS ); i < j ; i ++ ) {

		if ( checkpointid == E_PNS_CP [ i ] ) {

			if ( ! IsPlayerInAnyVehicle(playerid)) {

				GameTextForPlayer(playerid, "~n~~n~~n~~w~You must be in a vehicle to use this service, dummy!", 2000, 4);
				return true ;
			}

			if ( IsPlayerInAnyVehicle(playerid)) {

				if ( GetPlayerState(playerid) == PLAYER_STATE_DRIVER ) {
					PlayerVar [ playerid ] [ E_PLAYER_USING_PNS ] = true ;
					TogglePlayerControllable(playerid, false);
					ShowMenuForPlayer(pns_menu, playerid);
				}
			}

			return true ;
		}

		else continue ;
	}

	#if defined pns_OnPlayerEnterDynamicCP
		return pns_OnPlayerEnterDynamicCP(playerid, checkpointid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicCP
	#undef OnPlayerEnterDynamicCP
#else
	#define _ALS_OnPlayerEnterDynamicCP
#endif

#define OnPlayerEnterDynamicCP pns_OnPlayerEnterDynamicCP
#if defined pns_OnPlayerEnterDynamicCP
	forward pns_OnPlayerEnterDynamicCP(playerid, checkpointid);
#endif

public OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
	
	for ( new i, j =sizeof ( E_PNS_LOCATIONS ); i < j ; i ++ ) {

		if ( checkpointid == E_PNS_CP [ i ] ) {

			PlayerVar [ playerid ] [ E_PLAYER_USING_PNS ] = false ;
			TogglePlayerControllable(playerid, true);
			HideMenuForPlayer(pns_menu, playerid);
		}
	}

	#if defined pns_OnPlayerLeaveDynamicCP
		return pns_OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicCP
	#undef OnPlayerLeaveDynamicCP
#else
	#define _ALS_OnPlayerLeaveDynamicCP
#endif

#define OnPlayerLeaveDynamicCP pns_OnPlayerLeaveDynamicCP
#if defined pns_OnPlayerLeaveDynamicCP
	forward pns_OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid);
#endif