#define COLOR_STRAWMAN	(0x8D3F3FFF)

CMD:makestrawman(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_MANAGER ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
    }

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid )) {

		return SendClientMessage(playerid, COLOR_RED, "/makestrawman [targetid / part of name]");
	} 

	if ( ! IsPlayerConnected(targetid) ) {

		return SendClientMessage(playerid, COLOR_RED, "Target isn't connected.");
	}

	new query [ 256 ] ;

	if ( Character [ targetid ] [ E_CHARACTER_STRAWMAN ] ) {

		Character [ targetid ] [ E_CHARACTER_STRAWMAN ] = false ;
		format ( query, sizeof ( query ), "(%d) %s has removed (%d) %s's strawman status.", playerid, ReturnPlayerNameData ( playerid ), targetid, ReturnPlayerNameData ( targetid ) ) ;
		SendClientMessage(targetid, COLOR_STRAWMAN, sprintf("Your strawman status has been revoked by (%d) %s.", playerid, ReturnPlayerNameData ( playerid ))) ;
	}

	else {

		Character [ targetid ] [ E_CHARACTER_STRAWMAN ] = true ;
		format ( query, sizeof ( query ), "(%d) %s has made (%d) %s a strawman.", playerid, ReturnPlayerNameData ( playerid ), targetid, ReturnPlayerNameData ( targetid )) ;
		SendClientMessage(targetid, COLOR_STRAWMAN, sprintf("You've been made a strawman by (%d) %s.", playerid, ReturnPlayerNameData ( playerid )));
	}

	WriteLog ( playerid, "admin/all", query);

	query [ 0 ] = EOS ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_strawman = %d WHERE player_id = %d", 
		Character [ targetid ] [ E_CHARACTER_STRAWMAN ], Character [ targetid ] [ E_CHARACTER_ID ] );

	mysql_tquery(mysql, query);

	// Strawmen automatically get removed & their strawmen assets LOCKED if they haven't logged in for more than a week
	// (You can only use strawmen commands as a strawmen!)

	return true ;
}

CMD:viewstrawmen(playerid, params[]) {

	// shows last online, last time supplied, last gun sold (pull from "logs".)
}