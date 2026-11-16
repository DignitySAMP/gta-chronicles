enum {

	E_VENDING_CAN_ECOLA_BIG 			= -24994,
	E_VENDING_CAN_ECOLA_SMALL 			= -24995,
	E_VENDING_CAN_SPRUNK_BIG			= -24996,
	E_VENDING_CAN_SPRUNK_SMALL 			= -24997,

	E_VENDING_MACHINE_ECOLA 			= -24998,
	E_VENDING_MACHINE_SPRUNK 			= -24999
} ;

public OnGameModeInit(){
	
	AddSimpleModel(-1, 1337, E_VENDING_CAN_ECOLA_BIG, 	"vending/can_ecola_big.dff", 	"vending/can_ecola_big.txd");
	AddSimpleModel(-1, 1337, E_VENDING_CAN_ECOLA_SMALL, 	"vending/can_ecola_small.dff", 	"vending/can_ecola_small.txd");
	AddSimpleModel(-1, 1337, E_VENDING_CAN_SPRUNK_BIG, 	"vending/can_sprunk_big.dff", 	"vending/can_sprunk_big.txd");
	AddSimpleModel(-1, 1337, E_VENDING_CAN_SPRUNK_SMALL, 	"vending/can_sprunk_small.dff", "vending/can_sprunk_small.txd");
	AddSimpleModel(-1, 1337, E_VENDING_MACHINE_ECOLA, 	"vending/machine_ecola.dff", 	"vending/machine_ecola.txd");
	AddSimpleModel(-1, 1337, E_VENDING_MACHINE_SPRUNK, 	"vending/machine_sprunk.dff", 	"vending/machine_sprunk.txd");

 	CreateVendingMachines();

	#if defined vending_OnGameModeInit
		return vending_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit vending_OnGameModeInit
#if defined vending_OnGameModeInit
	forward vending_OnGameModeInit();
#endif

public OnPlayerConnect(playerid) {
	
	RemoveDefaultVendingMachines(playerid);

	if ( IsValidDynamicObject( g_PlayerVendingProp [ playerid ] ) ) {
		DestroyDynamicObject( g_PlayerVendingProp [ playerid ]);
		g_PlayerVendingProp [ playerid ] = INVALID_STREAMER_ID ;
	}
	g_PlayerVendingModel [ playerid ] = 0 ;

	#if defined vending_OnPlayerConnect
		return vending_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect vending_OnPlayerConnect
#if defined vending_OnPlayerConnect
	forward vending_OnPlayerConnect(playerid);
#endif
