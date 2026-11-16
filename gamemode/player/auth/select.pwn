new Text:gui_class_browser_td[4] = Text: INVALID_TEXT_DRAW ;
new PlayerText:gui_class_browser_ptd[MAX_PLAYERS][4] ={ PlayerText: INVALID_TEXT_DRAW, ...} ;
new Text: gui_class_browser_td_new[4] = Text: INVALID_TEXT_DRAW ;

enum E_CLASS_SELECTION_DATA {

	E_PLAYER_CLASS_SEL_ACTOR_ID,
	E_PLAYER_CLASS_SEL_CHARID,
	bool: E_PLAYER_CLASS_SEL_IN_MENU
} ;

new PlayerClassSelection [ MAX_PLAYERS ] [ E_CLASS_SELECTION_DATA ];

new HEIGHT_FIX = 1500 ;  // fixed surrounding maps / models being visible

// Includes the good ole' dialogs!
#include "player/auth/select_menus.pwn"

CreateLoginScreen() {

    CreateObject(LOGIN_TR_BASE,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_BITS,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_INTBITS,           -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_MAIN,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_STUDIOLIGHTSET,    -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
	CreateObject(LOGIN_TR_ALPHAS,            -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    
}

ClassBrowser_DestroyPlayerDraws(playerid) {

	for(new i,j=4;i <j; i ++ ) {

		PlayerTextDrawDestroy(playerid,gui_class_browser_ptd[playerid][i]);
	}

	if ( IsValidDynamicActor( PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] ) ) {

		DestroyDynamicActor(PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] ) ;
	}

	PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] = 0 ;

	return true ;
}

Select_StartCharacterSelection(playerid, characterid) {

	for(new i,j=sizeof(gui_class_browser_td);i <j; i ++ ) {

		TextDrawHideForPlayer(playerid, gui_class_browser_td[i]);
	}
	for(new i,j=sizeof(gui_class_browser_td_new);i <j; i ++ ) {

		TextDrawHideForPlayer(playerid, gui_class_browser_td_new[i]);
	}
	for(new i,j=4;i <j; i ++ ) {

		PlayerTextDrawHide(playerid,gui_class_browser_ptd[playerid][i]);
	}

	PlayerClassSelection[playerid][E_PLAYER_CLASS_SEL_IN_MENU ] = true ;

	CancelSelectTextDraw(playerid);

    SetPlayerCameraPos(playerid, -2300.9243,2789.3237,65.9877+HEIGHT_FIX);
    SetPlayerCameraLookAt(playerid, -2310.9771,2785.6252,64.9877+HEIGHT_FIX);

    defer OnLoginScreenCameraSequence(playerid, characterid);

	return true ;
}

timer OnLoginScreenCameraSequence[1000](playerid, characterid) {

    new const MOVE_TIME = 5000 ;

    InterpolateCameraPos(playerid, -2300.9243,2789.3237,65.9877+HEIGHT_FIX,-2307.6440,2786.9509,64.9877+HEIGHT_FIX, MOVE_TIME, CAMERA_MOVE ) ;
    InterpolateCameraLookAt(playerid,-2310.9771,2785.6252,64.9877+HEIGHT_FIX, -2311.2983,2785.4297,65.4473+HEIGHT_FIX, MOVE_TIME, CAMERA_MOVE);

	defer LoginScreen_UpdateGUI(playerid, characterid);
	defer LoginScreen_DelayActorAnim[5500](playerid, characterid);

	SetPlayerInterior(playerid, 1);

    return true ;
}

timer LoginScreen_UpdateGUI[5000](playerid, characterid) {

	new string [ 256 ], faction_name [ 64 ] ;

	format ( string, sizeof ( string ), "%s", CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_NAME ] ) ; 
	PlayerTextDrawSetString(playerid, gui_class_browser_ptd[playerid][0], string ) ;

	PlayerTextDrawColor(playerid, gui_class_browser_ptd[playerid][1], Faction_GetHex ( CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_FACTION_ID ] ));


	Faction_GetName ( CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_FACTION_ID ], faction_name, sizeof ( faction_name ) ) ;
	format ( string, sizeof ( string ), "%s", faction_name) ;
	PlayerTextDrawSetString(playerid, gui_class_browser_ptd[playerid][1], faction_name ) ;

	if ( Faction_GetEnumID(CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_FACTION_ID ]) != -1 ) {

		format ( string, sizeof ( string ), "%s ~y~(tier: %d)", 
			CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_FACTION_RANK ], 
			CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_FACTION_TIER ]  
		) ;

		PlayerTextDrawSetString(playerid, gui_class_browser_ptd[playerid][2], string ) ;
	}

	else PlayerTextDrawSetString(playerid, gui_class_browser_ptd[playerid][2], " " ) ;

	format ( string, sizeof ( string ), "Hours Played: ~r~%d", 	CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_HOURS_PLAYED ]  ) ;
	PlayerTextDrawSetString(playerid, gui_class_browser_ptd[playerid][3], string ) ;

	LoginScreen_UpdateActorSkin(playerid, characterid);

	SetPlayerCameraPos(playerid, -2307.6440,2786.9509,64.9877+HEIGHT_FIX);
	SetPlayerCameraLookAt(playerid, -2311.2983,2785.4297,65.4473+HEIGHT_FIX);

	SelectTextDraw(playerid, 0x1F85DEFF);

	for(new i,j=sizeof(gui_class_browser_td);i <j; i ++ ) {

		TextDrawShowForPlayer(playerid, gui_class_browser_td[i]);
	}
	for(new i,j=sizeof(gui_class_browser_td_new);i <j; i ++ ) {

		TextDrawShowForPlayer(playerid, gui_class_browser_td_new[i]);
	}	
	for(new i,j=4;i <j; i ++ ) {

		PlayerTextDrawShow(playerid,gui_class_browser_ptd[playerid][i]);
	}

}

LoginScreen_UpdateActorSkin(playerid, characterid) {

	new index = playerid + 1 ;

    SetPlayerVirtualWorld(playerid, index ) ;
    SetPlayerInterior(playerid, 0);

    Streamer_UpdateEx(playerid, -2311.2983, 2785.4297, 65.4473+HEIGHT_FIX);

	//SendClientMessage(playerid, -1, "Checking actor...");
	if ( IsValidDynamicActor( PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] ) ) {

		//SendClientMessage(playerid, -1, "Destroying actor...");
		DestroyDynamicActor(PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] ) ;
	}

	//SendClientMessage(playerid, -1, "Creating actor...");

	new skinid = CharacterBuffer [ playerid ] [ characterid ] [ E_CHAR_BUFFER_SKIN ] ;

   	PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] = CreateDynamicActor(skinid, 
    	-2311.3125,2785.4443,65.4726+HEIGHT_FIX,180, 1, 100.0, index, 0, playerid);
    ApplyDynamicActorAnimation(PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ],"CLOTHES","null",0.0,0, 0, 0,0,0);
    defer LoginScreen_DelayActorAnim(playerid, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ]);

	//SendClientMessage(playerid, -1, "Created! actor...");

	/*
	SendClientMessage(playerid, -1, sprintf("Actor vw: %d - player vw: %d", 
		GetDynamicActorVirtualWorld(PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ]), 
		GetPlayerVirtualWorld(playerid))
	) ;
	*/

	/*
	SendClientMessage(playerid, -1, sprintf("Actor int: %d - player int: %d", 
		Streamer_GetIntData(STREAMER_TYPE_ACTOR, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ], E_STREAMER_INTERIOR_ID), 
		GetPlayerInterior(playerid)
	)) ;

	SendClientMessage(playerid, -1, sprintf("Actor ID: %d", PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_ACTOR_ID ] )) ;
	*/

    Streamer_Update(playerid, STREAMER_TYPE_ACTOR ) ;

	//SendClientMessage(playerid, -1, "Streaming actor...");
	return true ;
}

timer LoginScreen_DelayActorAnim[150](playerid, actorid) {

 	ApplyDynamicActorAnimation(actorid, "CLOTHES", "CLO_POSE_LOOP",  4.1, 1, 1, 1, 1, 0);
	
	if(!IsDynamicActorStreamedIn(actorid, playerid)) {

		defer LoginScreen_DelayActorAnim[500](playerid, actorid) ;
	}

	return true ;
}


public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	// gui_class_browser_td[3] // spawn

	if ( PlayerClassSelection[playerid][E_PLAYER_CLASS_SEL_IN_MENU ] ) {

		if ( Server [ E_SERVER_TEXTDRAW_TICK ] >= gettime () ) {
			
			return SendClientMessage(playerid, COLOR_RED, sprintf("To reduce server overload, please wait %d seconds.", (gettime() - Server [ E_SERVER_TEXTDRAW_TICK ] ) )) ;
		}

		else {

			Server [ E_SERVER_TEXTDRAW_TICK ] = gettime () + 2;
		}

		if ( clickedid == Text: INVALID_TEXT_DRAW ) {

			SelectTextDraw(playerid, 0xDEDEDEFF );
		}

		else if ( clickedid == gui_class_browser_td[1] ) { // left

			if ( PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] <= 0 ) {
				PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] = GetCharacterCount(playerid) ;
			}

			PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] -- ;

			//SendClientMessage(playerid, -1, "Left");
			LoginScreen_UpdateGUI(playerid, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ]);

			return true ;
		}

		else if ( clickedid == gui_class_browser_td[2] ) { // right

			PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] ++ ;

			if ( PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] >= GetCharacterCount(playerid) ) {
				PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] = 0 ;
			}

			//SendClientMessage(playerid, -1, "Right");
			LoginScreen_UpdateGUI(playerid, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ]);

			return true ;
		}

		else if ( clickedid == gui_class_browser_td[0] ) { // switch (menu)
			Character_ShowCharMenu(playerid );
			return true ;
		}
		else if ( clickedid == gui_class_browser_td[3] ) { // spawn


			PlayerClassSelection[playerid][E_PLAYER_CLASS_SEL_IN_MENU ] = false ;
			Character_SpawnPlayer(playerid, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] );
			return true ;
		}


		else if ( clickedid == gui_class_browser_td_new[0] ) { // create
			ClassBrowser_HideTextDraws(playerid);
			return Account_CharacterCreation ( playerid ) ;
		}

		else if ( clickedid == gui_class_browser_td_new[1] ) { // select

			Character_ShowCharMenu(playerid );
			return true ;
		}
	}
	
	#if defined select_OnPlayerClickTextDraw
		return select_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif

#define OnPlayerClickTextDraw select_OnPlayerClickTextDraw
#if defined select_OnPlayerClickTextDraw
	forward select_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif


ClassBrowser_HideTextDraws(playerid) {

	CancelSelectTextDraw(playerid);

	for(new i,j=sizeof(gui_class_browser_td);i <j; i ++ ) {

		TextDrawHideForPlayer(playerid, gui_class_browser_td[i]);
	}
	for(new i,j=sizeof(gui_class_browser_td_new);i <j; i ++ ) {

		TextDrawHideForPlayer(playerid, gui_class_browser_td_new[i]);
	}
	for(new i,j=4;i <j; i ++ ) {

		PlayerTextDrawHide(playerid,gui_class_browser_ptd[playerid][i]);
	}
}

ClassBrowser_LoadStaticDraws() {
	gui_class_browser_td[0] = TextDrawCreate(328.5000, 346.5000, "Switch Character");
	TextDrawFont(gui_class_browser_td[0], 1);
	TextDrawLetterSize(gui_class_browser_td[0], 0.3499, 1.5000);
	TextDrawAlignment(gui_class_browser_td[0], 2);
	TextDrawColor(gui_class_browser_td[0], -1);
	TextDrawSetShadow(gui_class_browser_td[0], 0);
	TextDrawSetOutline(gui_class_browser_td[0], 1);
	TextDrawBackgroundColor(gui_class_browser_td[0], 255);
	TextDrawSetProportional(gui_class_browser_td[0], 1);
	TextDrawTextSize(gui_class_browser_td[0], 12.5000, 105.000);
	TextDrawSetSelectable(gui_class_browser_td[0], 1);

	gui_class_browser_td[1] = TextDrawCreate(259.5000, 347.0000, "LD_BEAT:LEFT");
	TextDrawFont(gui_class_browser_td[1], 4);
	TextDrawLetterSize(gui_class_browser_td[1], 0.4499, 1.5000);
	TextDrawAlignment(gui_class_browser_td[1], 2);
	TextDrawColor(gui_class_browser_td[1], -1);
	TextDrawSetShadow(gui_class_browser_td[1], 0);
	TextDrawSetOutline(gui_class_browser_td[1], 1);
	TextDrawBackgroundColor(gui_class_browser_td[1], 255);
	TextDrawSetProportional(gui_class_browser_td[1], 1);
	TextDrawTextSize(gui_class_browser_td[1], 15.0000, 15.0000);
	TextDrawSetSelectable(gui_class_browser_td[1], 1);

	gui_class_browser_td[2] = TextDrawCreate(381.5000, 347.0000, "LD_BEAT:RIGHT");
	TextDrawFont(gui_class_browser_td[2], 4);
	TextDrawLetterSize(gui_class_browser_td[2], 0.4499, 1.5000);
	TextDrawAlignment(gui_class_browser_td[2], 2);
	TextDrawColor(gui_class_browser_td[2], -1);
	TextDrawSetShadow(gui_class_browser_td[2], 0);
	TextDrawSetOutline(gui_class_browser_td[2], 1);
	TextDrawBackgroundColor(gui_class_browser_td[2], 255);
	TextDrawSetProportional(gui_class_browser_td[2], 1);
	TextDrawTextSize(gui_class_browser_td[2], 15.0000, 15.0000);
	TextDrawSetSelectable(gui_class_browser_td[2], 1);

	gui_class_browser_td[3] = TextDrawCreate(328.5, 370.0000, "Spawn");
	TextDrawFont(gui_class_browser_td[3], 0);
	TextDrawLetterSize(gui_class_browser_td[3], 0.7500, 2.5000);
	TextDrawAlignment(gui_class_browser_td[3], 2);
	TextDrawColor(gui_class_browser_td[3], 0xDBBF49FF);
	TextDrawSetShadow(gui_class_browser_td[3], 0);
	TextDrawSetOutline(gui_class_browser_td[3], 1);
	TextDrawBackgroundColor(gui_class_browser_td[3], 255);
	TextDrawSetProportional(gui_class_browser_td[3], 1);
	TextDrawTextSize(gui_class_browser_td[3], 25.000, 75.0000);
	TextDrawSetSelectable(gui_class_browser_td[3], 1);

	gui_class_browser_td_new[0] = TextDrawCreate(215.5000, 293.5000, "mdl-29996:charcreate");
	TextDrawFont(gui_class_browser_td_new[0], 4);
	TextDrawLetterSize(gui_class_browser_td_new[0], 0.5000, 1.0000);
	TextDrawColor(gui_class_browser_td_new[0], -1);
	TextDrawSetShadow(gui_class_browser_td_new[0], 0);
	TextDrawSetOutline(gui_class_browser_td_new[0], 0);
	TextDrawBackgroundColor(gui_class_browser_td_new[0], 255);
	TextDrawSetProportional(gui_class_browser_td_new[0], 1);
	TextDrawTextSize(gui_class_browser_td_new[0], 32.0000, 20.0000);
	TextDrawSetSelectable(gui_class_browser_td_new[0], 1);

	gui_class_browser_td_new[1] = TextDrawCreate(215.0000, 323.5000, "mdl-29996:charselect");
	TextDrawFont(gui_class_browser_td_new[1], 4);
	TextDrawLetterSize(gui_class_browser_td_new[1], 0.5000, 1.0000);
	TextDrawColor(gui_class_browser_td_new[1],  -1);
	TextDrawSetShadow(gui_class_browser_td_new[1], 0);
	TextDrawSetOutline(gui_class_browser_td_new[1], 0);
	TextDrawBackgroundColor(gui_class_browser_td_new[1], 255);
	TextDrawSetProportional(gui_class_browser_td_new[1], 1);
	TextDrawTextSize(gui_class_browser_td_new[1], 32.0000, 20.0000);
	TextDrawSetSelectable(gui_class_browser_td_new[1], 1);

	gui_class_browser_td_new[2] = TextDrawCreate(215.5000, 311.5000, "~y~create");
	TextDrawFont(gui_class_browser_td_new[2], 1);
	TextDrawLetterSize(gui_class_browser_td_new[2], 0.2500, 1.0000);
	TextDrawColor(gui_class_browser_td_new[2], -1);
	TextDrawSetShadow(gui_class_browser_td_new[2], 0);
	TextDrawSetOutline(gui_class_browser_td_new[2], 1);
	TextDrawBackgroundColor(gui_class_browser_td_new[2], 255);
	TextDrawSetProportional(gui_class_browser_td_new[2], 1);
	TextDrawTextSize(gui_class_browser_td_new[2], 32.0000, 20.0000);

	gui_class_browser_td_new[3] = TextDrawCreate(215.5000, 342.0000, "~y~select");
	TextDrawFont(gui_class_browser_td_new[3], 1);
	TextDrawLetterSize(gui_class_browser_td_new[3], 0.2500, 1.0000);
	TextDrawColor(gui_class_browser_td_new[3], -1);
	TextDrawSetShadow(gui_class_browser_td_new[3], 0);
	TextDrawSetOutline(gui_class_browser_td_new[3], 1);
	TextDrawBackgroundColor(gui_class_browser_td_new[3], 255);
	TextDrawSetProportional(gui_class_browser_td_new[3], 1);
	TextDrawTextSize(gui_class_browser_td_new[3], 32.0000, 20.0000);


	return 1;
}

ClassBrowser_LoadPlayerDraws(playerid) {

	gui_class_browser_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 328.0000, 288.5000, "Addison Barrington");
	PlayerTextDrawFont(playerid, gui_class_browser_ptd[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, gui_class_browser_ptd[playerid][0], 0.3499, 1.5000);
	PlayerTextDrawAlignment(playerid, gui_class_browser_ptd[playerid][0], 2);
	PlayerTextDrawColor(playerid, gui_class_browser_ptd[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, gui_class_browser_ptd[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, gui_class_browser_ptd[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, gui_class_browser_ptd[playerid][0], 255);
	PlayerTextDrawSetProportional(playerid, gui_class_browser_ptd[playerid][0], 1);
	PlayerTextDrawTextSize(playerid, gui_class_browser_ptd[playerid][0], 0.0000, 500.0000);

	gui_class_browser_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 329.0000, 320.5000, "Rollin' Heights Ballaz");
	PlayerTextDrawFont(playerid, gui_class_browser_ptd[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, gui_class_browser_ptd[playerid][1], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, gui_class_browser_ptd[playerid][1], 2);
	PlayerTextDrawColor(playerid, gui_class_browser_ptd[playerid][1], -1811885057);
	PlayerTextDrawSetShadow(playerid, gui_class_browser_ptd[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, gui_class_browser_ptd[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, gui_class_browser_ptd[playerid][1], 255);
	PlayerTextDrawSetProportional(playerid, gui_class_browser_ptd[playerid][1], 1);
	PlayerTextDrawTextSize(playerid, gui_class_browser_ptd[playerid][1], 0.0000, 500.0000);

	gui_class_browser_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 330.0000, 331.0000, "Shotcaller ~y~(tier: 1)");
	PlayerTextDrawFont(playerid, gui_class_browser_ptd[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, gui_class_browser_ptd[playerid][2], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, gui_class_browser_ptd[playerid][2], 2);
	PlayerTextDrawColor(playerid, gui_class_browser_ptd[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, gui_class_browser_ptd[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, gui_class_browser_ptd[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, gui_class_browser_ptd[playerid][2], 255);
	PlayerTextDrawSetProportional(playerid, gui_class_browser_ptd[playerid][2], 1);
	PlayerTextDrawTextSize(playerid, gui_class_browser_ptd[playerid][2], 0.0000, 500.0000);

	gui_class_browser_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 329.5000, 304.0000, "Hours Played: ~r~154");
	PlayerTextDrawFont(playerid, gui_class_browser_ptd[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, gui_class_browser_ptd[playerid][3], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, gui_class_browser_ptd[playerid][3], 2);
	PlayerTextDrawColor(playerid, gui_class_browser_ptd[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, gui_class_browser_ptd[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, gui_class_browser_ptd[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, gui_class_browser_ptd[playerid][3], 255);
	PlayerTextDrawSetProportional(playerid, gui_class_browser_ptd[playerid][3], 1);
	PlayerTextDrawTextSize(playerid, gui_class_browser_ptd[playerid][3], 0.0000, 500.0000);

	return 1;
}

