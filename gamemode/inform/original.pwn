enum {
	E_PLAYER_INFORM_TEXT,
	E_PLAYER_INFORM_BOX

} ;

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

	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = false ;
	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = false ;

	return true ;
}

DestroyInformGUI(playerid) {

	PlayerTextDrawDestroy(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
	PlayerTextDrawDestroy(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);

	return true ;
}

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

PreemptHideInformTextdraw(playerid) {

	PlayerVar [ playerid ] [ E_PLAYER_SKIP_INFORM_TD ] = true ;
	PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_TEXT [ playerid ]);
	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_TEXT ] = false ;
	PlayerTextDrawHide(playerid, E_PLAYER_INFORM_GUI_BOX [ playerid ]);
	PlayerVar [ playerid ] [ E_PLAYER_INFORM_TD_SHOWN ] [ E_PLAYER_INFORM_BOX ] = false ;
	PlayerPlaySound(playerid, 0, 0, 0, 0);
}

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