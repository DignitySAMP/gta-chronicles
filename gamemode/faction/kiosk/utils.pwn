Kiosk_GetClosestEntity(playerid) {


	for_loop ( new i, j = sizeof ( Kiosk ); i < j ; i ++ ) {

		if ( Kiosk [ i ] [ E_KIOSK_ID ] != INVALID_KIOSK_ID ) {

			if ( IsPlayerInRangeOfPoint(playerid, 2.0, Kiosk [ i ] [ E_KIOSK_POS_X ], Kiosk [ i ] [ E_KIOSK_POS_Y ], Kiosk [ i ] [ E_KIOSK_POS_Z ] ) 
				&& Kiosk [ i ] [ E_KIOSK_POS_INT ] == GetPlayerInterior ( playerid ) && Kiosk [ i ] [ E_KIOSK_POS_VW ] == GetPlayerVirtualWorld ( playerid ) ) {

				return i ;
			}

			else continue ;
		}

		else continue ;
	}

	return INVALID_KIOSK_ID ;
}