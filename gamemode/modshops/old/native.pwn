
ModShop_OnPlayerDisconnect(playerid) {

	if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ] != Menu:0)
	{
//		HideMenuForPlayer(pmodshopmenu[playerid], playerid);
		DestroyMenu(PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ]);
		PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ] = Menu:0;
	}

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ] != Menu:0)
		{ 
			HideMenuForPlayer(PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ], playerid);
			DestroyMenu(PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ]);
			PlayerModshopData [playerid] [ E_PLAYER_MODSHOP_MENU ] = Menu:0;
		}
	}
	
	#if defined mod_OnPlayerStateChange
		return mod_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange mod_OnPlayerStateChange
#if defined mod_OnPlayerStateChange
	forward mod_OnPlayerStateChange(playerid, newstate, oldstate);
#endif