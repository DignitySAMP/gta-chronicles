#if !defined MAX_AFK_TIME
#define MAX_AFK_TIME	( 600 )
#endif

stock AFKCheck_Tick ( playerid ) {

/*
	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	if ( PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 0 ] == 0.00 ) {

		PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 0 ] = x ;
		PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 1 ] = y ;
		PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 2 ] = z ;
	}

	if ( x == PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 0 ] && y == PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 1 ] && z == PlayerVar [ playerid ] [ E_PLAYER_AFK_POS ] [ 2 ] ) {



		if ( ++ PlayerVar [ playerid ] [ E_PLAYER_AFK_TIME ] >= MAX_AFK_TIME ) {
			new string [ 512 ], reason [ 36 ]  ;

            format ( string, sizeof ( string ), "[AntiCheat]: (%d) %s has been kicked for afking.", playerid, ReturnPlayerNameData ( playerid )  ) ;

            ProxDetector ( playerid, 45.0, COLOR_ORANGE, string );
            SendAdminMessage(string) ;

            format ( reason, sizeof ( reason ), "Anticheat Detection: AFKing" ) ;
            SetAdminRecord ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], -1337, ARECORD_TYPE_KICK, reason, -1, ReturnDateTime () ) ;

            KickPlayer ( playerid ) ;  

            PlayerVar [ playerid ] [ E_PLAYER_AFK_TIME ] = 0 ;
		}
	}
*/
	if ( IsPlayerPaused ( playerid ) ) {
		if ( GetPlayerAdminLevel ( playerid ) ) {

			return true ;
		}

		if ( ++ PlayerVar [ playerid ] [ E_PLAYER_AFK_TIME ] >= MAX_AFK_TIME ) {
			new string [ 512 ], reason [ 36 ]  ;

            format ( string, sizeof ( string ), "[AntiCheat]: (%d) %s has been kicked for afking.", playerid, ReturnPlayerNameData ( playerid )  ) ;

            ProxDetector ( playerid, 45.0, COLOR_ORANGE, string );
            SendAdminMessage(string) ;

            format ( reason, sizeof ( reason ), "Anticheat Detection: AFKing" ) ;
            SetAdminRecord ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], -1337, ARECORD_TYPE_KICK, reason, -1, ReturnDateTime () ) ;

            KickPlayer ( playerid ) ;  

            PlayerVar [ playerid ] [ E_PLAYER_AFK_TIME ] = 0 ;
		}
	}

	else if ( ! IsPlayerPaused ( playerid ) ) {

		PlayerVar [ playerid ] [ E_PLAYER_AFK_TIME ] = 0 ;
	}

	return true ;
}