enum {
	E_PLAYER_INFORM_NONE = -1,
	E_PLAYER_INFORM_TEXT,
	E_PLAYER_INFORM_BOX

} ;

enum E_PLAYER_INFORM_DATA {


	E_PLAYER_INFORM_TYPE,
	E_PLAYER_INFORM_STRING [ 256 ],
	E_PLAYER_INFORM_TIME
} ;

#if !defined MAX_QUEUED_INFORM
	#define MAX_QUEUED_INFORM	( 10 )
#endif

new PlayerInform [ MAX_PLAYERS ] [ MAX_QUEUED_INFORM ] [ 2 ] [ E_PLAYER_INFORM_DATA ] ;

new PlayerInformVisible [ MAX_PLAYERS ] [ 2 ] ; // stores ID of queue whic his visible now

SetupInformTable ( playerid ) {

	for ( new i, j = MAX_QUEUED_INFORM; i < j ; i ++ ) {

		for ( new type, x = 2; type < x ; type ++ ) {
			PlayerInform [ playerid ] [ i ] [ type ] [ E_PLAYER_INFORM_TYPE ] = E_PLAYER_INFORM_NONE ;
		}
	}

	for ( new type, x = 2; type < x ; type ++ ) {
		PlayerInformVisible [ playerid ] [ type ]= E_PLAYER_INFORM_NONE ;
	}
}
GetInformTableIndex ( playerid, type ) {

	for ( new i, j = MAX_QUEUED_INFORM; i < j ; i ++ ) {

		if ( PlayerInform [ playerid ] [ i ] [ type ][ E_PLAYER_INFORM_TYPE ] == E_PLAYER_INFORM_NONE ) {

			return i ;
			
		}

		else continue ;
	}

	return E_PLAYER_INFORM_NONE ;
}


new PlayerText: E_PLAYER_INFORM_GUI_TEXT [ MAX_PLAYERS ] = PlayerText: INVALID_TEXT_DRAW ;
new PlayerText: E_PLAYER_INFORM_GUI_BOX[ MAX_PLAYERS ] = PlayerText: INVALID_TEXT_DRAW ;

LoadInformGUI(playerid) {
 
	E_PLAYER_INFORM_GUI_TEXT [ playerid ] = CreatePlayerTextDraw(0, 360.0, 341.0, "_");
	PlayerTextDrawAlignment(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 2);
	PlayerTextDrawBackgroundColor(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 255);
	PlayerTextDrawFont(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 1);
	PlayerTextDrawLetterSize(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 0.55, 2.1);
	PlayerTextDrawColor(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], -1);
	PlayerTextDrawSetOutline(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 0);
	PlayerTextDrawSetProportional(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 1);
	PlayerTextDrawSetShadow(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 2);
	PlayerTextDrawSetSelectable(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], 0);

	E_PLAYER_INFORM_GUI_BOX [ playerid ] = CreatePlayerTextDraw(playerid, 31.000000, 148.000000, ".");
	PlayerTextDrawBackgroundColor(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 255);
	PlayerTextDrawFont(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 1);
	PlayerTextDrawLetterSize(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 0.539999, 2.299998);
	PlayerTextDrawColor(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], -1195458049);
	PlayerTextDrawSetOutline(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 0);
	PlayerTextDrawSetProportional(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 1);
	PlayerTextDrawSetShadow(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 0);
	PlayerTextDrawUseBox(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 1);
	PlayerTextDrawBoxColor(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 200);
	PlayerTextDrawTextSize(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 235.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], 0);

	SetupInformTable ( playerid ) ;

	return true ;
}

DestroyInformGUI(playerid) {

	PlayerTextDrawDestroy(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
	PlayerTextDrawDestroy(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);

	return true ;
}

InformPlayer ( playerid, type, time, string [], len = sizeof ( string ) ) {	// Time is seconds!

	// Orden the array so the new one is ALWAYS last!
	SortDeepArray(PlayerInform, 1);	// 0 = playerid, 1 = index, 2 = type, 3 = enum

	new index = GetInformTableIndex ( playerid, type ) ;

	if ( index == E_PLAYER_INFORM_NONE ) {

		// Too many boxes queued! Cancel!
		return true ;
	}


	PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TYPE ] = type ;
	format ( PlayerInform [ playerid ] [ index ] [ type ]  E_PLAYER_INFORM_STRING ] , len, "%s", string) ;
	PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TIME ] = time ;

	return true ;
}

ptask OnInformPlayer[1000](playerid, type) {

	new index ; 

	if ( PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT ] == E_PLAYER_INFORM_NONE ) {

		index = PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT ] ;

		SortDeepArray(PlayerInform, 1);		// 0 = playerid, 1 = index, 2 = type, 3 = enum

		// Visible slot is clear! Let's show the next in queue...
		if ( index == E_PLAYER_INFORM_NONE ) {

			for ( new i, j = MAX_QUEUED_INFORM ; i < j ; i ++ ) {

				if ( PlayerInform [ playerid ] [ i ] [ type ] [ E_PLAYER_INFORM_TYPE ] != E_PLAYER_INFORM_NONE ) {


					PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
					PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], PlayerInform [ playerid ] [ i ] [ type ] [ E_PLAYER_INFORM_STRING ]);
					PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
				
				 	PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT ] = i ;

				 	break ;
				}
			}

			return true ;
		}

	 	PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT] = index ;
	}

	else if ( PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT ] != E_PLAYER_INFORM_NONE ) {

		if ( PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TIME ] -- <= 0 ) {
			// Time is up, let's remove the textdraw & clean queue data!

			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
			PlayerInformVisible [ playerid ] [ type ] = E_PLAYER_INFORM_NONE ;

			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TYPE ] = E_PLAYER_INFORM_NONE;
			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TIME ] = 0 ;
			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_STRING ] [ 0 ] = EOS ;
		}
	}

	if ( PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_BOX ] == E_PLAYER_INFORM_NONE ) {

		index = PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_BOX ] ;

		SortDeepArray(PlayerInform, 1);		// 0 = playerid, 1 = index, 2 = type, 3 = enum

		// Visible slot is clear! Let's show the next in queue...
		if ( index == E_PLAYER_INFORM_NONE ) {

			for ( new i, j = MAX_QUEUED_INFORM ; i < j ; i ++ ) {


				PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
				PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], PlayerInform [ playerid ] [ i ] [ type ] [ E_PLAYER_INFORM_STRING ]);
				PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
			
			 	PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_TEXT ] = i ;

			 	break ;
			}

			return true ;
		}
	}

	else if ( PlayerInformVisible [ playerid ] [ E_PLAYER_INFORM_BOX ] != E_PLAYER_INFORM_NONE ) {

		if ( PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TIME ] -- <= 0 ) {
			// Time is up, let's remove the textdraw & clean queue data!

			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
			PlayerInformVisible [ playerid ] [ type ] = E_PLAYER_INFORM_NONE ;

			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TYPE ] = E_PLAYER_INFORM_NONE;
			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_TIME ] = 0 ;
			PlayerInform [ playerid ] [ index ] [ type ] [ E_PLAYER_INFORM_STRING ] [ 0 ] = EOS ;
		}
	}

}

/*
InformPlayer(playerid, type, string [], areaid = -1, soundid = 1083, delay = 0, delaystring[] = "_") {

	PlayerVar [ playerid ] [ E_PLAYER_SKIP_INFORM_TD ] = false ;

	if ( ! IsPlayerConnected(playerid) || ! IsPlayerSpawned ( playerid ) || ! IsPlayerLogged ( playerid ) ) {

		return false ;
	}

	new bool: G_CONFIRM_HIDE_TIMER = false ;

	switch ( type ) {
		case E_PLAYER_INFORM_TEXT : {
 
			if ( ! PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] ) {

				PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
				PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], string);
				PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);

				PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = true ;
				G_CONFIRM_HIDE_TIMER = true ;
			}
		}

		case E_PLAYER_INFORM_BOX : {

			if ( ! PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] ) {

				PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
				PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], string);
				PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);

				PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = true ;
				G_CONFIRM_HIDE_TIMER = true ;
			}
		}
	}

	PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0); 

	// For i.e. when someone gets close to a prop box, make it show a msg with info!
	if ( areaid == -1 ) {

		if ( G_CONFIRM_HIDE_TIMER && !delay) {
			defer HideInformTextdraw(playerid, type ) ;
		}
	}

	if ( delay ) {

		defer DelayInformTextdraw[delay](playerid, type, delaystring, areaid, soundid ) ;
	}


	return true ;
}

timer DelayInformTextdraw[5000](playerid, type, string:string[], areaid, soundid) {

	if ( ! IsPlayerConnected(playerid) || ! IsPlayerSpawned ( playerid ) || ! IsPlayerLogged ( playerid ) ) {

		return false ;
	}

	switch ( type ) {
		case E_PLAYER_INFORM_TEXT : {
 
			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);

			PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ], string);
			PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);

			PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = true ;
		}

		case E_PLAYER_INFORM_BOX : {


			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
			PlayerTextDrawSetString(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ], string);
			PlayerTextDrawShow(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);

			PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = true ;
		}
	}

	PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0); 

	// For i.e. when someone gets close to a prop box, make it show a msg with info!
	if ( areaid == -1 ) {

		stop PlayerVar [ playerid ] [ E_PLAYER_INFORM_TIMER ] ;
		PlayerVar [ playerid ] [ E_PLAYER_INFORM_TIMER ] = defer HideInformTextdraw(playerid, type ) ;
	}

	return true ;
}
*/
/*
PreemptHideInformTextdraw(playerid) {

	PlayerVar [ playerid ] [ E_PLAYER_SKIP_INFORM_TD ] = true ;
	PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = false ;
	PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = false ;
	PlayerPlaySound(playerid, 0, 0, 0, 0);
}
*/
timer HideInformTextdraw[7000](playerid, type) {


	if ( PlayerVar [ playerid ] [ E_PLAYER_SKIP_INFORM_TD ] ) {

		return true ;
	}

	if ( ! IsPlayerConnected(playerid) || ! IsPlayerSpawned ( playerid ) || ! IsPlayerLogged ( playerid ) ) {

		return false ;
	}

	switch ( type ) {
		case E_PLAYER_INFORM_TEXT : {

			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
			PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = false ;
			PlayerPlaySound(playerid, 0, 0, 0, 0);
		}

		case E_PLAYER_INFORM_BOX : {

			PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
			PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = false ;
			PlayerPlaySound(playerid, 0, 0, 0, 0);
		}
	}

	return true ;
}