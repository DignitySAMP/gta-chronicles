
public OnPlayerEnterDynamicArea(playerid, areaid) {


	if ( GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		for (new i = 0; i < sizeof(sc_VendingMachines); i++) {

			if ( s_VendingMachineArea[i] == areaid ) {

				OnPlayerApproachVending(playerid, i ) ;
				break ;
			}

			else continue ;
		}
	}


	#if defined vend_OnPlayerEnterDynamicArea
		return vend_OnPlayerEnterDynamicArea(playerid, areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea vend_OnPlayerEnterDynamicArea
#if defined vend_OnPlayerEnterDynamicArea
	forward vend_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid) {

	if ( GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		for (new i = 0; i < sizeof(sc_VendingMachines); i++) {

			if ( s_VendingMachineArea[i] == areaid ) {

				OnPlayerLeaveVending(playerid) ;
				break ;
			}

			else continue ;
		}
	}

	#if defined vend_OnPlayerLeaveDynamicArea
		return vend_OnPlayerLeaveDynamicArea(playerid, areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea vend_OnPlayerLeaveDynamicArea
#if defined vend_OnPlayerLeaveDynamicArea
	forward vend_OnPlayerLeaveDynamicArea(playerid, areaid);
#endif