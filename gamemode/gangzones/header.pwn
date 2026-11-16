#include "gangzones/data.pwn"


GangZone_ShowForPlayer(playerid) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_GZES ] ) {
		for(new i, j = sizeof ( GangZone ); i < j ; i ++ ) {
			if ( GangZone [ i ] [ E_GANGZONE_SQLID ] == INVALID_GANGZONE_ID ) continue ;
			GangZoneShowForPlayer(playerid, GangZone [ i ] [ E_GANGZONE_ZONEID ], GangZone_GetColour(GangZone [ i ] [ E_GANGZONE_FACTION ])) ;
		
			if ( GangZone [ i ] [ E_GANGZONE_CONTESTED ] ) {

				GangZoneFlashForPlayer(playerid, GangZone [ i ] [ E_GANGZONE_ZONEID ], 0xBA2920AA ) ;
			}
		}
	}

	else {
		GangZone_HideForPlayer(playerid) ;
	}

	return true ;
}
GangZone_HideForPlayer(playerid) {

	for(new i, j = sizeof ( GangZone ); i < j ; i ++ ) {
		if ( GangZone [ i ] [ E_GANGZONE_SQLID ] == INVALID_GANGZONE_ID ) continue ;
	
		if ( GangZone [ i ] [ E_GANGZONE_CONTESTED ] ) {

			GangZoneStopFlashForPlayer(playerid, GangZone [ i ] [ E_GANGZONE_ZONEID ]) ;
		}
		
		GangZoneHideForPlayer(playerid, GangZone [ i ] [ E_GANGZONE_ZONEID ]) ;
	}


	return true ;
}

CMD:gangzoneassign(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new index ;

	if ( sscanf  (params, "i", index ) ) {
		// 0: None, 999: Unofficial

		SendClientMessage(playerid, -1, "/gangzoneassign [faction]" ) ;
		SendClientMessage(playerid, -1, "DEBUG: -1: None, 0: Unofficial (See /factions for rest)" ) ;

		return true ;
	}

	new gz_id = GetPlayerGangZone(playerid) ;

	if ( gz_id == INVALID_GANG_ZONE ) {

		return SendClientMessage(playerid, -1, "You're not in a gangzone!" ) ;
	}

	if ( !GangZone_IsPlayerInArea(playerid, gz_id) ) {

		return SendClientMessage(playerid, -1, sprintf("Tried to match gangzone %d with enum, but returned -1 (invalid).", gz_id ) ) ;
	}


	GangZone [ gz_id ] [ E_GANGZONE_FACTION ] = index ;

	GangZoneHideForAll( GangZone [ gz_id ] [ E_GANGZONE_ZONEID ] ) ;
	GangZoneShowForAll( GangZone [ gz_id ] [ E_GANGZONE_ZONEID ], GangZone_GetColour(index) ) ;

	new query [ 128 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gangzones SET gz_faction = %d WHERE gz_sqlid = %d", 

		GangZone [ gz_id ] [ E_GANGZONE_FACTION ], GangZone [ gz_id ] [ E_GANGZONE_SQLID ]
	) ;

	mysql_tquery(mysql, query);


	return true ;
}


CMD:gangzonecontest(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	// on/off

	new gz_id = GetPlayerGangZone(playerid) ;

	if ( gz_id == INVALID_GANG_ZONE ) {

		return SendClientMessage(playerid, -1, "You're not in a gangzone!" ) ;
	}

	if ( !GangZone_IsPlayerInArea(playerid, gz_id) ) {

		return SendClientMessage(playerid, -1, sprintf("Tried to match gangzone %d with enum, but returned -1 (invalid).", gz_id ) ) ;
	}

	switch ( GangZone [ gz_id ] [ E_GANGZONE_CONTESTED ] ) {

		case true: {

			GangZone [ gz_id ] [ E_GANGZONE_CONTESTED ] = false ;
			GangZoneStopFlashForAll( GangZone [ gz_id ] [ E_GANGZONE_ZONEID ] );

			SendClientMessage(playerid, -1, sprintf("You've removed zone %d's contested state.", GetPlayerGangZone(playerid)));
		}

		case false: {

			GangZone [ gz_id ] [ E_GANGZONE_CONTESTED ] = true ;
			GangZoneFlashForAll( GangZone [ gz_id ] [ E_GANGZONE_ZONEID ], 0xBA2920AA);

			SendClientMessage(playerid, -1, sprintf("You've set zone %d to be contested.", GetPlayerGangZone(playerid)));
		}
	}

	new query [ 128 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gangzones SET gz_contested = %d WHERE gz_sqlid = %d", 

		GangZone [ gz_id ] [ E_GANGZONE_CONTESTED ], GangZone [ gz_id ] [ E_GANGZONE_SQLID ]
	) ;

	mysql_tquery(mysql, query);


	return true ;
}

CMD:gangzoneid(playerid) {
	new gz_id = GetPlayerGangZone(playerid) ;

	if ( gz_id == INVALID_GANG_ZONE ) {

		return SendClientMessage(playerid, -1, "You're not in a gangzone!" ) ;
	}

	if ( !GangZone_IsPlayerInArea(playerid, gz_id) ) {

		return SendClientMessage(playerid, -1, sprintf("Tried to match gangzone %d with enum, but returned -1 (invalid).", gz_id ) ) ;
	}


	SendClientMessage(playerid, -1, sprintf("Zone: %d (sql %d)", gz_id, GangZone [ gz_id ] [ E_GANGZONE_SQLID ] ));

	return true ;
}
