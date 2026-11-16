//#include "gps/gps.inc"
//#include "gps/gps_gangzone.pwn"
//#include "gps/func.pwn"


enum E_GPS_DATA {

	E_GPS_DESC [ 64 ],
	Float: E_GPS_POS_X,
	Float: E_GPS_POS_Y,
	Float: E_GPS_POS_Z,

	E_GPS_JURISDICTION
} ;

new GPS [ ] [ E_GPS_DATA ] = {
	{"Central Community Police Station", 	1544.9873,-1675.1959,13.5595, true }, // this is the original pershing sq
	{"County General Hospital", 		2036.3203,-1403.9027,16.9238, true },
	//{"All Saints General Hospital", 	1219.9885,-1427.1046,13.0201, true }, // this is the custom reyo one
	{"All Saints General Hospital", 	1172.9635,-1323.3898,15.3983, true },
	{"Twin Towers Correctional Facility",	1798.1439,-1578.7405,14.0917, true },
	{"Los Santos City Hall",			1481.0544,-1771.2614,18.7958, true },
	{"Los Santos Fire Department", 		1839.5597,-1431.1117,13.5625, true },
	{"San Andreas Network Studios", 	1798.3241,-1653.7074,14.4879, true },
	//{"Los Santos Sheriff's Department", 627.2641,-571.7688,17.9120, true }, // dillimore
	{"East LS Community Police Station", 2467.9399,-1541.9700,24.3416, true }, // EAST LS
	{"Ronald Reagan Federal Plaza", 	1018.8617,-1534.7828,13.0861, true }, // this is the custom mapped one

	{"Rockford Plaza Mall", 			1721.4644, -1667.3977, 20.1651, true },
	//{"Department of Motor Vehicles", 	1278.1628,-1546.9424,13.2105, true }, // replaced by city hall :D
	{"Realty Listings", 				1742.9880, -1456.2135, 13.5225, true }, // for /listings
	{"Impound Lot", 					1088.3052,-1748.8958,13.4066, true },
	{"Vehicle Scrapyard", 				2317.305,-2305.8811,13.1446, true },
	{"Ocean Docks - Dockworker Job", 	2753.4329,-2453.7937,13.6432, true },
	{"Ocean Docks - Garbageman Job",	2247.1138,-2672.9709,13.5565, true },
	//{"Emmet's Hardware Stall", 			2444.7598,-1967.8073,13.1944, true },

	{"Budget Dealership", 				1867.8229,-1777.1138,13.6049, true },
	{"Muscle Dealership", 				2050.3438,-1901.6233,13.5469, true },
	{"Sports Dealership", 				1359.7362,-1854.9513,13.5642, true },
	{"Utility Dealership", 				2420.1533,-2089.4521,13.0789, true },
	{"Aircraft Dealership", 			1957.5844,-2183.7864,13.5469, true },
	{"Bike Dealership", 				691.93600,-1572.1674,14.2422, true },
	{"Boat Dealership", 				723.1155, -1495.1814, 1.9343, true },

	{ "Transfender LS", 				1041.354, -1022.302, 31.127 , true},
	{ "Transfender SF", 				-1935.847, 242.876, 33.561, true},
	{ "Transfender LV", 				2386.662, 1047.172, 9.812, true},
	{ "Loco-Low", 						2644.877, -2042.556, 12.607 , true},
	{ "WheelArch", 						-2719.670, 217.481, 3.585 , true},
	{ "Chop Shop", 						1640.6498, -2148.9124, 13.5688, true},

	{"Isla De Cedros, Mexico",					16140.1563,-16078.8125,2.8110, false },
	{"Gym: East Los Santos", 			LS_GYM_EXT_X, LS_GYM_EXT_Y, LS_GYM_EXT_Z, true},
	{"Gym: South Los Santos", 			LV_GYM_EXT_X, LV_GYM_EXT_Y, LV_GYM_EXT_Z, true},
	{"Gym: West Los Santos", 			BEACH_GYM_EXT_X, BEACH_GYM_EXT_Y, BEACH_GYM_EXT_Z, true},
	{"Gym: Central Los Santos", 		GANTON_GYM_EXT_X, GANTON_GYM_EXT_Y, GANTON_GYM_EXT_Z, true},

	{"Pay 'N' Spray: Willowfield", 2334.9880, -1991.6436, 13.5587, true},
	{"Pay 'N' Spray: Pershing Square", 1296.8934, -1865.5447, 13.5972, true},
	{"Pay 'N' Spray: Rodeo", 207.11590, -1446.4102, 13.1596, true},
	{"Pay 'N' Spray: Glen Park", 1833.8820, -1398.2865, 13.4297, true}

//	{"Gym: South Los Santos", 			BEACH_GYM_EXT_X, BEACH_GYM_EXT_Y, BEACH_GYM_EXT_Z, true}

} ;
 
GPS_ShowServerHotspots(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] = 1 ;
	}

	// Pagination stuff
	new MAX_ITEMS_ON_PAGE = 10, string [ 1024 ], bool: nextpage ;
    new resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;


    strcat(string, "Description\tDistance\n");

    new Float: dist ;

    for_loop ( new i = resultcount, j = sizeof ( GPS ); i < j; i ++ ) {

		resultcount ++ ;

        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] ) {
        	dist = GetPlayerDistanceFromPoint(playerid, GPS [ i ] [ E_GPS_POS_X ], GPS [ i ] [ E_GPS_POS_Y ], GPS [ i ] [ E_GPS_POS_Z ] ) ;

			format(string, sizeof(string), "%s%s\t%0.3f yds\n", string, GPS [ i ] [ E_GPS_DESC ], dist); 
        }

     	if ( resultcount >= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] ) {

            nextpage = true;
            break;
        }
	}

	new pages = floatround ( resultcount / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1 ;

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	inline gps_show_list(pid, dialogid, response, listitem, string: inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;

		if ( ! response ) {

			if ( PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] -- ;
				return GPS_ShowServerHotspots(playerid) ;
			}

			else return true ;
		}

		if ( response ) {

			if ( listitem >= MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] ++ ;
				return GPS_ShowServerHotspots(playerid) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) 
			{

				/*
				DisablePlayerCheckpoint(playerid);

				GPS_MarkLocation ( playerid, "~r~Point of Interest~w~ has been marked on your ~r~minimap~w~.", E_GPS_COLOR_DEFAULT, GPS [ selection ] [ E_GPS_POS_X ], GPS [ selection ] [ E_GPS_POS_Y ], GPS [ selection ] [ E_GPS_POS_Z ] ) ;

				if ( ! GPS [ selection ] [ E_GPS_JURISDICTION ] ) {
					//InformPlayer ( playerid, E_PLAYER_INFORM_BOX, "The location you want to reach is outside of the city of Los Santos's control!", -1, 1083, 6000, "The LSPD has no power here and the area may be crime contested!" ) ;

					//ShowPlayerSubtitle(playerid, "The LSPD has no power here and the area may be crime contested!", .showtime=6000 ) ;
					ShowPlayerInfoMessage(playerid, "The location you want to reach is outside of government control.", .height=167.5, .width=180, .showtime=6000);

				}
				*/

				GPS_ShowHotspot(playerid, selection, GetPlayerHelperLevel(playerid) > 1);

 				return true ;
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ] > 1 ) {
		Dialog_ShowCallback ( playerid, using inline gps_show_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("GPS: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ], pages), string, "Select", "Previous" ) ;
	}

	else Dialog_ShowCallback ( playerid, using inline gps_show_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("GPS: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_GPSLIST_PAGE ], pages), string, "Select", "Back" ) ;

	//SendClientMessage(playerid, COLOR_YELLOW, "To disable your gps use /nocp." ) ;

	return true ;
}

GPS_ShowHotspot(playerid, selection, bool:options=false)
{
	if (!options)
	{
		DisablePlayerCheckpoint(playerid);
		GPS_MarkLocation(playerid, sprintf("~r~%s~w~ has been marked on your ~r~minimap~w~.", GPS[selection][E_GPS_DESC]), E_GPS_COLOR_DEFAULT, GPS [ selection ] [ E_GPS_POS_X ], GPS [ selection ] [ E_GPS_POS_Y ], GPS [ selection ] [ E_GPS_POS_Z ]);
		SendClientMessage(playerid, COLOR_YELLOW, "To disable your gps marker use /cleargps." );

		if ( ! GPS [ selection ] [ E_GPS_JURISDICTION ] ) 
		{
			// ShowPlayerInfoMessage(playerid, "The location you want to reach is outside of government control.", .height=167.5, .width=180, .showtime=5000);
		}

		return true;
	}
	
	inline gps_showhotspot(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, dialogid, inputtext

		if (!response)
		{
			return GPS_ShowServerHotspots(playerid);
		}

		if (listitem == 0)
		{
			// Just do normal gps route
			return GPS_ShowHotspot(playerid, selection, false);
		}
		else
		{
			// Admin teleport
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			SOLS_SetPosWithFade(playerid, GPS [ selection ] [ E_GPS_POS_X ], GPS [ selection ] [ E_GPS_POS_Y ], GPS [ selection ] [ E_GPS_POS_Z ]);

			SendHelperCmdWarn(playerid, sprintf("teleported to %s", GPS[selection][E_GPS_DESC]));
		}
	}

	Dialog_ShowCallback ( playerid, using inline gps_showhotspot, DIALOG_STYLE_LIST, sprintf("GPS: %s", GPS[selection][E_GPS_DESC]), "Mark on minimap\nTeleport to (Admin)", "Select", "Back" ) ;
	return true;
}