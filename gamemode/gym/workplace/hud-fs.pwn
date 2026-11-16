#include <a_samp>
#include <foreach>
#include <progress2>
#include <zcmd>
#include <YSI\y_timers>


new Text:E_GYM_PROGRESS_GUI = Text: INVALID_TEXT_DRAW ;
new PlayerText:E_GYM_PROGRESS_PGUI[MAX_PLAYERS][3] = { PlayerText: INVALID_TEXT_DRAW, ... };

new Text:E_GYM_STATS_GUI[8] = Text: INVALID_TEXT_DRAW ;
new PlayerBar: E_GYM_STATS_GUI_BAR[MAX_PLAYERS][5] = { PlayerBar: INVALID_PLAYER_BAR_ID, ... };

public OnFilterScriptInit() {


	AddSimpleModel(-1, 1337, -30000, "sprite_model.dff", "gymbar.txd");
	LoadGymStatsGUI() ;
	LoadGymProgressGUI();

	foreach(new playerid: Player) {

		LoadGymProgressPGUI(playerid);
		LoadGymStatsPGUI(playerid);
	}

	return true ;	
}
public OnFilterScriptExit () {

	TextDrawDestroy ( E_GYM_PROGRESS_GUI ) ;

	for ( new i, j = sizeof ( E_GYM_STATS_GUI ); i < j ; i ++ ) {
		TextDrawDestroy ( E_GYM_STATS_GUI[i] ) ;
	}

	foreach(new playerid: Player) {

		DestroyGymProgressPGUI(playerid);
		DestroyGymStatsPGUI(playerid);
	}
	return true ;
}

new popupProgress [ MAX_PLAYERS ] ;
new popupStage [ MAX_PLAYERS ] ;

CMD:pop(playerid) {

	TextDrawShowForPlayer ( playerid, E_GYM_PROGRESS_GUI ) ;

	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][0] ); 
	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][1] ); 
	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][2] ); 

	popupStage [ playerid ] = true ;
	popupProgress [ playerid ] = 0 ;

	defer PlayerGainExample(playerid);

	return true ;
}

timer PlayerGainExample[250](playerid) {

	if ( popupStage [ playerid ] ) {


		switch ( popupProgress [ playerid ] ) {

			case 0:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:0");
			case 1:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:1");
			case 2:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:2");
			case 3:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:3");
			case 4:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:4");
			case 5:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:5");
			case 6:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:6");
			case 7:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:7");
			case 8:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:8");
			case 9:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:9");
			case 10:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:10");
			case 11:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:11");
			case 12:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:12");
			case 13:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:13");
			case 14:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:14");
			case 15:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:15");
			case 16:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:16");
			case 17:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:17");
			case 18:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:18");
			case 19:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:19");
			case 20:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:20");
			case 21:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:21");
			case 22:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:22");
			case 23:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:23");
			case 24:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:24");
			case 25:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:25");
				
			default: {
				popupProgress [ playerid ] = 0 ;
				popupStage [ playerid ] = false ;
			}
		}


		popupProgress [ playerid ] ++ ;
	}

	else if ( ! popupStage [ playerid ] ) {
		switch ( popupProgress [ playerid ] ) {
			case 25:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-0");
			case 24:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-1");
			case 23:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-2");
			case 22:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-3");
			case 21:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-4");
			case 20:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-5");
			case 19:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-6");
			case 18:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-7");
			case 17:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-8");
			case 16:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-9");
			case 15:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-10");
			case 14:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-11");
			case 13:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-12");
			case 12:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-13");
			case 11:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-14");
			case 10:	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-15");
			case 9:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-16");
			case 8:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-17");
			case 7:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-18");
			case 6:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-19");
			case 5:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-20");
			case 4:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-21");
			case 3:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-22");
			case 2:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-23");
			case 1:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-24");
			case 0:		PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-25");
				
			default: {
				popupProgress [ playerid ] = 0 ;
				popupStage [ playerid ] = true ;
			}
		}
		popupProgress [ playerid ] ++ ;
	}

	defer PlayerGainExample(playerid);
}

LoadGymProgressPGUI(playerid) {

	E_GYM_PROGRESS_PGUI[playerid][0] = CreatePlayerTextDraw(playerid, 43.5000, 171.5000, "Muscle");
	PlayerTextDrawFont(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 0.4000, 1.5000);
	PlayerTextDrawAlignment(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 2);
	PlayerTextDrawColor(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 0xDEDEDEFF);
	PlayerTextDrawSetShadow(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 255);
	PlayerTextDrawSetProportional(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 1);
	PlayerTextDrawTextSize(playerid, E_GYM_PROGRESS_PGUI[playerid][0], 0.0000, 0.0000);

	E_GYM_PROGRESS_PGUI[playerid][1] = CreatePlayerTextDraw(playerid, 71.0000, 173.5000, "mdl-30000:15");
	PlayerTextDrawFont(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 0.5000, 1.0000);
	PlayerTextDrawColor(playerid, E_GYM_PROGRESS_PGUI[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 255);
	PlayerTextDrawSetProportional(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 1);
	PlayerTextDrawTextSize(playerid, E_GYM_PROGRESS_PGUI[playerid][1], 75.0000, 12.5000);

	E_GYM_PROGRESS_PGUI[playerid][2] = CreatePlayerTextDraw(playerid, 155.5000, 171.0000, "+");
	PlayerTextDrawFont(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 0.5000, 1.7500);
	PlayerTextDrawAlignment(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 2);
	PlayerTextDrawColor(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 0xDEDEDEFF);
	PlayerTextDrawSetShadow(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 255);
	PlayerTextDrawSetProportional(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 1);
	PlayerTextDrawTextSize(playerid, E_GYM_PROGRESS_PGUI[playerid][2], 0.0000, 0.0000);

	return true ;
}

DestroyGymProgressPGUI(playerid) {
	
	PlayerTextDrawDestroy ( playerid, E_GYM_PROGRESS_PGUI[playerid][0] ) ;
	PlayerTextDrawDestroy ( playerid, E_GYM_PROGRESS_PGUI[playerid][1] ) ;
	PlayerTextDrawDestroy ( playerid, E_GYM_PROGRESS_PGUI[playerid][2] ) ;

	return true ;
}

LoadGymProgressGUI() {
	E_GYM_PROGRESS_GUI = TextDrawCreate(19.5000, 170.0000, "_");
	TextDrawFont(E_GYM_PROGRESS_GUI, 1);
	TextDrawLetterSize(E_GYM_PROGRESS_GUI, 0.5000, 2.5000);
	TextDrawColor(E_GYM_PROGRESS_GUI, 170);
	TextDrawSetShadow(E_GYM_PROGRESS_GUI, 0);
	TextDrawSetOutline(E_GYM_PROGRESS_GUI, 0);
	TextDrawBackgroundColor(E_GYM_PROGRESS_GUI, 255);
	TextDrawSetProportional(E_GYM_PROGRESS_GUI, 1);
	TextDrawUseBox(E_GYM_PROGRESS_GUI, 1);
	TextDrawBoxColor(E_GYM_PROGRESS_GUI, 170);
	TextDrawTextSize(E_GYM_PROGRESS_GUI, 165.0000, 0.0000);

	return true ;
}

public OnPlayerKeyStateChange ( playerid, newkeys, oldkeys ) {

	if ( newkeys & KEY_SPRINT && newkeys & KEY_CROUCH ) {

		for ( new i, j = sizeof ( E_GYM_STATS_GUI ); i < j ; i ++ ) {
			TextDrawShowForPlayer ( playerid, E_GYM_STATS_GUI[i] ) ;
		}

		SetPlayerProgressBarValue ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 0 ], 35 ); // Muscle
		ShowPlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 0 ] );
		SetPlayerProgressBarValue ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 1 ], 45 ); // Weight
		ShowPlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 1 ] );
		SetPlayerProgressBarValue ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 2 ], 50 ); // Hunger
		ShowPlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 2 ] );
		SetPlayerProgressBarValue ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 3 ], 60 ); // Thirst
		ShowPlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 3 ] );
		SetPlayerProgressBarValue ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 4 ], 75 ); // Energy
		ShowPlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 4 ] );

		SendClientMessage ( playerid, 0xDEDEDEFF, "Use ESC to hide the hud." ) ;
		SelectTextDraw(playerid, 0x00000000);
	}

	return true ;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {

	#warning Only call this when the hud is shown (make a boolean)
	if ( clickedid == Text: INVALID_TEXT_DRAW ) {
		for ( new i, j = sizeof ( E_GYM_STATS_GUI ); i < j ; i ++ ) {
			TextDrawHideForPlayer ( playerid, E_GYM_STATS_GUI[i] ) ;
		}
	
		HidePlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 0 ] );
		HidePlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 1 ] );
		HidePlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 2 ] );
		HidePlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 3 ] );
		HidePlayerProgressBar ( playerid, E_GYM_STATS_GUI_BAR [playerid] [ 4 ] );
	}

	return true ;
}


LoadGymStatsPGUI(playerid) {

  	E_GYM_STATS_GUI_BAR [playerid] [ 0 ] = CreatePlayerProgressBar(playerid, 70.000000, 350.000000, 65.500000, 5.199999, 0xDEDEDEFF, 100.0000, 0);
    E_GYM_STATS_GUI_BAR [playerid] [ 1 ] = CreatePlayerProgressBar(playerid, 70.000000, 361.000000, 65.500000, 5.199999, 0xDEDEDEFF, 100.0000, 0);
    E_GYM_STATS_GUI_BAR [playerid] [ 2 ] = CreatePlayerProgressBar(playerid, 70.000000, 372.000000, 65.500000, 5.199999, 0xDEDEDEFF, 100.0000, 0);
    E_GYM_STATS_GUI_BAR [playerid] [ 3 ] = CreatePlayerProgressBar(playerid, 70.000000, 383.000000, 65.500000, 5.199999, 0xDEDEDEFF, 100.0000, 0);
    E_GYM_STATS_GUI_BAR [playerid] [ 4 ] = CreatePlayerProgressBar(playerid, 70.000000, 394.000000, 65.500000, 5.199999, 0xDEDEDEFF, 100.0000, 0);
}

DestroyGymStatsPGUI(playerid) {
	DestroyPlayerProgressBar(playerid, E_GYM_STATS_GUI_BAR [playerid] [ 0 ]);
	DestroyPlayerProgressBar(playerid, E_GYM_STATS_GUI_BAR [playerid] [ 1 ]);
	DestroyPlayerProgressBar(playerid, E_GYM_STATS_GUI_BAR [playerid] [ 2 ]);
	DestroyPlayerProgressBar(playerid, E_GYM_STATS_GUI_BAR [playerid] [ 3 ]);
	DestroyPlayerProgressBar(playerid, E_GYM_STATS_GUI_BAR [playerid] [ 4 ]);

}

LoadGymStatsGUI() {

	E_GYM_STATS_GUI[0] = TextDrawCreate(10.0000, 334.5000, "_");
	TextDrawFont(E_GYM_STATS_GUI[0], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[0], 0.5000, 9.7500);
	TextDrawColor(E_GYM_STATS_GUI[0], -1);
	TextDrawSetShadow(E_GYM_STATS_GUI[0], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[0], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[0], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[0], 1);
	TextDrawUseBox(E_GYM_STATS_GUI[0], 1);
	TextDrawBoxColor(E_GYM_STATS_GUI[0], 153);
	TextDrawTextSize(E_GYM_STATS_GUI[0], 140.0000, 0.0000);

	E_GYM_STATS_GUI[1] = TextDrawCreate(18.0000, 316.5000, "Stats");
	TextDrawFont(E_GYM_STATS_GUI[1], 0);
	TextDrawLetterSize(E_GYM_STATS_GUI[1], 0.8999, 2.5000);
	TextDrawColor(E_GYM_STATS_GUI[1], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[1], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[1], 2);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[1], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[1], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[1], 0.0000, 0.0000);

	E_GYM_STATS_GUI[2] = TextDrawCreate(16.0000, 344.5000, "Muscle");
	TextDrawFont(E_GYM_STATS_GUI[2], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[2], 0.3499, 1.2500);
	TextDrawColor(E_GYM_STATS_GUI[2], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[2], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[2], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[2], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[2], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[2], 0.0000, 0.0000);

	E_GYM_STATS_GUI[3] = TextDrawCreate(16.0000, 356.5000, "Weight");
	TextDrawFont(E_GYM_STATS_GUI[3], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[3], 0.3499, 1.2500);
	TextDrawColor(E_GYM_STATS_GUI[3], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[3], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[3], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[3], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[3], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[3], 0.0000, 0.0000);

	E_GYM_STATS_GUI[4] = TextDrawCreate(16.0000, 367.5000, "Hunger");
	TextDrawFont(E_GYM_STATS_GUI[4], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[4], 0.3499, 1.2500);
	TextDrawColor(E_GYM_STATS_GUI[4], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[4], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[4], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[4], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[4], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[4], 0.0000, 0.0000);

	E_GYM_STATS_GUI[5] = TextDrawCreate(16.0000, 378.5000, "Thirst");
	TextDrawFont(E_GYM_STATS_GUI[5], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[5], 0.3499, 1.2500);
	TextDrawColor(E_GYM_STATS_GUI[5], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[5], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[5], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[5], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[5], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[5], 0.0000, 0.0000);

	E_GYM_STATS_GUI[6] = TextDrawCreate(16.0000, 389.5000, "Energy");
	TextDrawFont(E_GYM_STATS_GUI[6], 1);
	TextDrawLetterSize(E_GYM_STATS_GUI[6], 0.3499, 1.2500);
	TextDrawColor(E_GYM_STATS_GUI[6], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[6], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[6], 0);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[6], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[6], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[6], 0.0000, 0.0000);

	E_GYM_STATS_GUI[7] = TextDrawCreate(132.7000, 404.5000, "Saturday");
	TextDrawFont(E_GYM_STATS_GUI[7], 3);
	TextDrawLetterSize(E_GYM_STATS_GUI[7], 0.3499, 1.2500);
	TextDrawAlignment(E_GYM_STATS_GUI[7], 3);
	TextDrawColor(E_GYM_STATS_GUI[7], 0xDEDEDEFF);
	TextDrawSetShadow(E_GYM_STATS_GUI[7], 0);
	TextDrawSetOutline(E_GYM_STATS_GUI[7], 1);
	TextDrawBackgroundColor(E_GYM_STATS_GUI[7], 255);
	TextDrawSetProportional(E_GYM_STATS_GUI[7], 1);
	TextDrawTextSize(E_GYM_STATS_GUI[7], 0.0000, 0.0000);

	return 1;
}

