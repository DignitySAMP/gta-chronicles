OnLoadTextdraws() {

	LoadFaderTextdraw () ;
	TutorialGUI_CreateStatic();
	ClassBrowser_LoadStaticDraws(); 
	mBrowser_LoadStaticDraws();
	GUI_LoadLockpickGUI();
	GUI_LoadHotwireGUI();

    pns_menu = CreateMenu("Pay'n'Spray", 1, 31.0, 180.0, 178.00);
    AddMenuItem(pns_menu, 0, "Respray Exterior");
    AddMenuItem(pns_menu, 0, "Respray Interior");
    AddMenuItem(pns_menu, 0, "Repair Bodywork");
    AddMenuItem(pns_menu, 0, "Repair Engine");
    AddMenuItem(pns_menu, 0, "Change Paintjob");
    AddMenuItem(pns_menu, 0, "Remove Paintjob");

}

OnLoadPlayerTextdraws(playerid) {

	LoadDownloadTD(playerid);
	mBrowser_LoadPlayerDraws(playerid);
	TutorialGUI_CreatePlayer(playerid);

	GUI_LoadLockpickPlayerGUI(playerid);
	GUI_LoadHotwirePlayerGUI(playerid);

	LoadMinigameHelpBox(playerid) ;

	GUI_LoadSpectatorPanel(playerid)  ;
	//GUI_LoadDirectionLabels(playerid) ;

	//Vehicle_LoadPlayerGUI(playerid) ;

	#if !defined PHONE_V2_DEV
	Phone_LoadPlayerDraws ( playerid ); 
	#endif

	house_info_box[playerid] = CreatePlayerTextDraw(playerid, 330.0000, 395.0000, "_");
	PlayerTextDrawFont(playerid, house_info_box[playerid], 1);
	PlayerTextDrawLetterSize(playerid, house_info_box[playerid], 0.2500, 1.0000);
	PlayerTextDrawAlignment(playerid, house_info_box[playerid], 2);
	PlayerTextDrawColor(playerid, house_info_box[playerid], -1);
	PlayerTextDrawSetShadow(playerid, house_info_box[playerid], 0);
	PlayerTextDrawSetOutline(playerid, house_info_box[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, house_info_box[playerid], 255);
	PlayerTextDrawSetProportional(playerid, house_info_box[playerid], 1);
	PlayerTextDrawTextSize(playerid, house_info_box[playerid], 0.0000, 500.0000);

	ClassBrowser_LoadPlayerDraws(playerid); 
}

OnDestroyPlayerTextdraws(playerid) {

	DestroyDownloadTD(playerid);
	TutorialGUI_DestroyPlayer(playerid);
	mBrowser_DestroyPlayerDraws(playerid);

	GUI_DestroyLockpickPlayerGUI(playerid) ;
	GUI_DestroyHotwirePlayerGUI(playerid) ;

	DestroyMinigameHelpBox ( playerid ) ;

	GUI_DestroySpectatorPanel ( playerid ) ;
	//GUI_DestroyDirectionLabels(playerid) ;

	//Vehicle_DestroyPlayerOldGUI(playerid) ;	

	#if !defined PHONE_V2_DEV
	Phone_DestroyPlayedDraws(playerid) ;
	#endif

	PlayerTextDrawDestroy(playerid, house_info_box[playerid] );

	ClassBrowser_DestroyPlayerDraws(playerid) ;	

	TextDrawHideForPlayer(playerid, gBlindfoldTD);
	TextDrawHideForPlayer(playerid, E_ADMIN_DUTY_TEXT );
}