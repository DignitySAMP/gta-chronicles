enum e_PLAYER_DATA {
	e_PLAYER_FLAGS:e_bFlags,
	Float:e_fPacket
};

enum e_PLAYER_FLAGS (<<= 1) {
	e_bUpdate = 1,
	e_bPaused
};


enum _:e_PLAYER_TICK_ENUM {
	e_PLAYER_TICK,
	e_PLAYER_LAST_UPDATE,
	e_PLAYER_LAST_SHOT,
	e_PLAYER_LAST_JUMP,
};
static s_aPlayerInfo[MAX_PLAYERS][e_PLAYER_DATA],
	s_aPlayerTickInfo[MAX_PLAYERS][e_PLAYER_TICK_ENUM] ;

forward OnPlayerPause(playerid);
forward OnPlayerResume(playerid, time);

public OnPlayerUpdate(playerid)
{
	if(!Callback_GetFlag(playerid, e_bUpdate))
	{
		Callback_SetFlag(playerid, e_bUpdate, true);
	}

	s_aPlayerTickInfo[playerid][e_PLAYER_LAST_UPDATE] = GetConnectedTime(playerid);

	
	#if defined paused_OnPlayerUpdate
		return paused_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate paused_OnPlayerUpdate
#if defined paused_OnPlayerUpdate
	forward paused_OnPlayerUpdate(playerid);
#endif

public OnGameModeInit()
{
 	SetTimer("Callback_TabCheck", 600, true);

	#if defined paused_OnGameModeInit
		return paused_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit paused_OnGameModeInit
#if defined paused_OnGameModeInit
	forward paused_OnGameModeInit();
#endif

public OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < e_PLAYER_TICK_ENUM; i ++)
	{
		s_aPlayerTickInfo[playerid][i] = 0;
	}

	s_aPlayerInfo[playerid][e_bFlags] = e_PLAYER_FLAGS:0;
	
	#if defined paused_OnPlayerDisconnect
		return paused_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect paused_OnPlayerDisconnect
#if defined paused_OnPlayerDisconnect
	forward paused_OnPlayerDisconnect(playerid, reason);
#endif

forward Callback_TabCheck();
public Callback_TabCheck()
{
	for(new i = 0, l = GetPlayerPoolSize(); i <= l; i ++)
	{
	    switch(GetPlayerState(i))
	    {
	        case PLAYER_STATE_ONFOOT, PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:
	        {
				if(Callback_GetFlag(i, e_bUpdate))
				{
					if(Callback_GetFlag(i, e_bPaused))
  					{
						CallLocalFunction("OnPlayerResume", "ii", i, GetConnectedTime(i) - s_aPlayerTickInfo[i][e_PLAYER_TICK]);
					}

		            Callback_SetFlag(i, e_bUpdate, false);
		            Callback_SetFlag(i, e_bPaused, false);
				}

				if(!Callback_GetFlag(i, e_bPaused) && (GetConnectedTime(i) - s_aPlayerTickInfo[i][e_PLAYER_LAST_UPDATE]) >= 4000)
				{
				    CallLocalFunction("OnPlayerPause", "i", i);

					s_aPlayerTickInfo[i][e_PLAYER_TICK] = GetConnectedTime(i);

					Callback_SetFlag(i, e_bPaused, true);
				}
			}
		}
	}
}

stock IsPlayerPaused(playerid)
{
	return Callback_GetFlag(playerid, e_bPaused);
}
stock GetPlayerPausedTime(playerid)
{
	return (GetConnectedTime(playerid) - s_aPlayerTickInfo[playerid][e_PLAYER_TICK]);
}
stock GetConnectedTime(playerid)
{
	return NetStats_GetConnectedTime(playerid);
}


stock static Callback_GetFlag(playerid, e_PLAYER_FLAGS:flag)
{
	return s_aPlayerInfo[playerid][e_bFlags] & flag;
}

stock static Callback_SetFlag(playerid, e_PLAYER_FLAGS:flag, status)
{
	if(status)
		return s_aPlayerInfo[playerid][e_bFlags] |= flag;
	else
	    return s_aPlayerInfo[playerid][e_bFlags] &= ~flag;
}