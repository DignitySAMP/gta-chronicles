enum {
	E_GPS_COLOR_DEFAULT = 0x9E1A1AFF, // red
	E_GPS_COLOR_SCRIPT = 0x2D3E77FF, // blue
	E_GPS_COLOR_JOB = 0x318635FF // green
} ;

#include "gps/data.pwn"

GPS_OnPlayerDisconnect ( playerid ) {

	if ( IsValidDynamicArea( PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] ) ) {

		DestroyDynamicArea( PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] ) ;
		PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] = -1 ;
	}

	return true ;
}


public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid) {

	if ( areaid == PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] ) 
	{
		ShowPlayerSubtitle(playerid, "You have reached your destination.", .showtime = 6000 );

		ChopShop_VerifyPointLocation(playerid);
		// NewspaperJob_EnterCP(playerid);

		//ForcePlayerEndLastRoute(playerid) ;
		RemovePlayerMapIcon(playerid, 0);
		DestroyDynamicArea(PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ]);
		PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] = -1 ;
	}
	
	#if defined gps_OnPlayerEnterDynamicArea
		return gps_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea gps_OnPlayerEnterDynamicArea
#if defined gps_OnPlayerEnterDynamicArea
	forward gps_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

GPS_MarkLocation(playerid, string[], color, Float: x, Float: y, Float: z ) {

	RemovePlayerMapIcon(playerid, 0);
	SetPlayerMapIcon(playerid, 0, x, y, z, 0, color, MAPICON_GLOBAL ) ;

	if (IsValidDynamicArea(PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ]))
	{
		DestroyDynamicArea(PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ]);
	}
	
	PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] = CreateDynamicCircle(x, y, 5.0, -1, -1, playerid);
	//GPS_SetPlayerCheckpoint(playerid, x, y, z) ;

	if (strlen(string)) ShowPlayerSubtitle(playerid, string, .showtime = 6000 ) ;
}

GPS_ClearCheckpoint(playerid)
{
	//ForcePlayerEndLastRoute(playerid) ;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);

	if ( IsValidDynamicArea( PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] ) ) {

		DestroyDynamicArea( PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] ) ;
		PlayerVar [ playerid ] [ E_PLAYER_GPS_AREA ] = -1 ;
	}

	RemovePlayerMapIcon(playerid, 0);
}

CMD:clearcp(playerid) 
{
	GPS_ClearCheckpoint(playerid);
	SendClientMessage(playerid, -1, "Removed all visible synced checkpoints. Your GPS has also been reset.");

	return true ;
}

CMD:nocp(playerid) return cmd_clearcp(playerid);
CMD:cleargps(playerid) return cmd_clearcp(playerid);