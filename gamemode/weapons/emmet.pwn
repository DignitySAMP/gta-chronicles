#include <YSI_Coding\y_hooks>

new emmet ;
new emmet_gun_obj ;

enum {
	// Pistols
	E_EMMET_ANIM_1H_START,
	E_EMMET_ANIM_1H_OUT,
	E_EMMET_ANIM_1H_RET,

	// Large
	E_EMMET_ANIM_2H_START,
	E_EMMET_ANIM_2H_OUT,
	E_EMMET_ANIM_2H_RET,

	// Armour
	E_EMMET_ANIM_AR_START,
	E_EMMET_ANIM_AR_OUT,
	E_EMMET_ANIM_AR_RET
} ;


enum E_EMMET_GUN_DATA { 

	EMMET_GUN_ID, // index of array from custom gun list
	EMMET_GUN_MODEL,
	EMMET_HOURS_NEEDED,
	EMMET_GUN_AMMO,
	EMMET_GUN_COST
} ;
 
new EmmetShop [ ] [ E_EMMET_GUN_DATA ] = {

	{ 1, 	331, 	6,		1, 		1250 },		// brass knuckle
	{ 2, 	333, 	6,		1,		425 },		// gold club
	/*{ 3, 	334, 	0,		1,		200 },		// nitestick */
	{ 5, 	336, 	6,		1, 		500 },		// bat
	{ 6, 	337, 	6,		1, 		425 },		// shovel
	{ 7, 	338, 	6,		1, 		425 },		// poolstick
	{ 10,	326, 	6,		1, 		400 },		// cane
	{ 11, 	365, 	2,		16000, 	350 }/*,		// spraycan
	{ 64, 	346, 	8,		34, 	        }		// glock 19*/

} ;

#define MAX_EMMET_COLTS 10
#define EMMET_COLT_BASE_COST 4250
#define EMMET_COLT_COST_INC  750 // (price goes up by 500 each purchase)
#define EMMET_COLT_NAME "Emmet's Colt"
#define EMMET_COLT_AMMO 34 // (2 clips)
#define EMMET_COLT_LISTITEM 7
#define EMMET_KNIFE_LISTITEM 8
#define EMMET_RARE_LISTITEM 9
#define EMMET_COLT_HOURS 8
#define EMMET_COLT_GUNID 64
#define EMMET_COLT_REPLENISH 21600 // (6 hours)
#define EMMET_KNIFE_COST	800

static enum E_EMMET_COLT_DATA
{
	E_COLT_BOUGHT_AT,
	E_COLT_BOUGHT_BY,
	E_COLT_BOUGHT_BY_NAME[32]
}

static EmmetColts[MAX_EMMET_COLTS][E_EMMET_COLT_DATA];

enum E_EMMET_RARE_GUN_DATA {

	E_EMMET_RARE_GUNID,
	E_EMMET_RARE_AMMO_MAX,
	E_EMMET_RARE_PROBABILITY,
	E_EMMET_RARE_COST_PER_AMMO,
} ;

new EmmetRareGuns [ ] [ E_EMMET_RARE_GUN_DATA ] = {

	{ 18, 20, 60, 50 }, // sw1991 silenced (silenced)
	{ 22, 20, 50, 70 }, // s&w model 29 (deagle)
	{ 27, 50, 40, 90 }, // mac-11 (uzi)
	{ 30, 50, 30, 105 }, // skorpion (tec 9)
	{ 53, 5, 20, 125 }  // ithaca 37 (sawn off)
}, EmmetRareGun, EmmetRareGunAmmo, EmmetRareGunCost, EmmetRareGunCooldown ;


#if !defined EMMET_PICKUP_MODEL
	#define EMMET_PICKUP_MODEL (346)
#endif
#if !defined EMMET_MAP_ICON
	#define EMMET_MAP_ICON (37)
#endif

// checks every 5 mins now
task Emmet_ColtTimer[300000]() 
{
	new now = gettime();

	for (new i = 0; i < MAX_EMMET_COLTS; i ++)
	{
		if (EmmetColts[i][E_COLT_BOUGHT_AT] == 0) continue;
		
		if ((now - EmmetColts[i][E_COLT_BOUGHT_AT]) > EMMET_COLT_REPLENISH)
		{
			// 6 hours has passed.  
			EmmetColts[i][E_COLT_BOUGHT_AT] = 0;
			EmmetColts[i][E_COLT_BOUGHT_BY] = 0;
		}
	}

	return 1;
}


Emmet_LoadEntities() {

	//Emmet_RareGunHandler ();

	emmet = CreateDynamicActor(6, 2443.7744, -1965.3563, 13.5469, 192.5807, true, 100.0, 0, 0 );
	ApplyActorAnimation(emmet,"WEAPONS","null",0.0,0,0,0,0 ,0);

	emmet_gun_obj = CreateDynamicObject(2039, 2443.7314, -1966.4616, 13.5981,-96.7, 0.0, -52.6999 );


	CreateDynamic3DTextLabel("[Emmet]\n{DEDEDE}Available commands: /emmet",
		COLOR_GREEN, 2444.4036,-1967.1267,13.5469, 15.0 
	);

	CreateDynamicPickup(EMMET_PICKUP_MODEL, 1,  2444.4036,-1967.1267,13.5469 ) ;
	CreateDynamicMapIcon(2444.4036,-1967.1267,13.5469, EMMET_MAP_ICON, 0 );

	print(" * [EMMET] Loaded emmet's shop.") ;

	return true ;
}

Emmet_GetCostAndStock(&colt_cost, &colt_stock)
{
	colt_cost = EMMET_COLT_BASE_COST;
	colt_stock = 0;
	
	for (new i = 0; i < MAX_EMMET_COLTS; i ++)
	{
		if (EmmetColts[i][E_COLT_BOUGHT_AT] > 0) continue;
		colt_stock ++;
	}

	// Increment the cost by the total lost stock * the increment
	colt_cost += (MAX_EMMET_COLTS - colt_stock) * EMMET_COLT_COST_INC;
}

CMD:debugemmet(playerid)
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_SENIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new colt_cost, colt_stock;
	Emmet_GetCostAndStock(colt_cost, colt_stock);

	SendClientMessage(playerid, COLOR_YELLOW, sprintf("Current colt cost: $%s, current stock: %d", IntegerWithDelimiter(colt_cost), colt_stock));

	new debug_dlg[2048];
	format(debug_dlg, 2048, "Colt \t Player \t Lease (Seconds)\n" ) ;
	

	for (new i = 0; i < MAX_EMMET_COLTS; i ++)
	{
		if (!EmmetColts[i][E_COLT_BOUGHT_AT] || !EmmetColts[i][E_COLT_BOUGHT_BY]) continue;
		format(debug_dlg, sizeof(debug_dlg), "%s%d \t %s \t %d\n", debug_dlg, i, EmmetColts[i][E_COLT_BOUGHT_BY_NAME], (EmmetColts[i][E_COLT_BOUGHT_AT] + EMMET_COLT_REPLENISH) - gettime()) ;
	}

	inline EmmetDebug(pid, dialogid, response, listitem, string:inputtext[]) { 

       #pragma unused inputtext, dialogid, pid, response, listitem

	}

	Dialog_ShowCallback(playerid, using inline EmmetDebug, DIALOG_STYLE_TABLIST_HEADERS, "Emmet's Debug", debug_dlg, "OK", ""); 
	return true;
}

/*
task Emmet_RareGunHandler[30000]() {

	if ( EmmetRareGunCooldown < gettime () && EmmetRareGun != -1) {

		EmmetRareGunCooldown  = gettime () + 21600 ;// 6 hours ;

		new random_index = random ( sizeof ( EmmetRareGuns ) ) ;

		EmmetRareGun = EmmetRareGuns [ random_index ] [ E_EMMET_RARE_GUNID ] ;
		EmmetRareGunAmmo = 1 + random (EmmetRareGuns [ random_index ] [ E_EMMET_RARE_AMMO_MAX ] ) ;
		EmmetRareGunCost = EmmetRareGunAmmo * EmmetRareGuns [ random_index ] [ E_EMMET_RARE_COST_PER_AMMO ] ;
	}
}
*/

CMD:emmet(playerid) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    


    if ( ! IsPlayerInRangeOfPoint(playerid, 2.5, 2443.7744, -1965.3563, 13.5469 ) ) {

    	return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "You're not near Emmet's!");
    }

    if ( IsPlayerInAnyVehicle(playerid)) {
    	return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "You can't be in a vehicle!");
    }
	
	new string [ 128 * sizeof ( EmmetShop) ], gunname [ 24 ] ;

	strcat(string, "Weapon \t Ammo \t Cost \tStock\n" ) ;

	for_loop ( new i, j = sizeof ( EmmetShop ); i < j ; i ++ ) {
		Weapon_GetGunName(EmmetShop [ i ] [ EMMET_GUN_ID ], gunname, sizeof ( gunname ) ) ;

		format(string, sizeof(string), "%s%s \t %d \t $%s \t N/A\n",string, gunname, EmmetShop [ i ] [ EMMET_GUN_AMMO ], IntegerWithDelimiter(EmmetShop [ i ] [ EMMET_GUN_COST ]) ) ;
	}

	// Manually adding the Colt here for now
	// Work out the remaining stock.
	new colt_cost, colt_stock;
	Emmet_GetCostAndStock(colt_cost, colt_stock);


	new rare_gun_name [ 32 ] ;

	if ( EmmetRareGun != -1 ) {
		format ( rare_gun_name, sizeof ( rare_gun_name ), "%s", Weapon [ EmmetRareGun ] [ E_WEAPON_DESC ] ) ;
	}

	else format ( rare_gun_name, sizeof ( rare_gun_name ), "Out of stock" ) ;

	format(string, sizeof(string), "%s{366cd9}[RARE]{DEDEDE} %s \t %d \t $%s \t %d\n", string, EMMET_COLT_NAME, EMMET_COLT_AMMO, IntegerWithDelimiter(colt_cost), colt_stock) ;
	//format(string, sizeof(string), "%s{366cd9}[TIER 1]{DEDEDE} Knife \t 1 \t $%s \t N/A\n", string, IntegerWithDelimiter(EMMET_KNIFE_COST)) ;
	//format(string, sizeof(string), "%s{c91414}[RARE]{DEDEDE}  %s \t %d \t $%s \t 1\n", string, rare_gun_name, EmmetRareGunAmmo, IntegerWithDelimiter(EmmetRareGunCost)) ;

	//SendClientMessage(playerid, COLOR_YELLOW, "Warning: stacking ammo is NOT possible!");
  	
	  
	inline EmmetPurchase(pid, dialogid, response, listitem, string:inputtext[]) { 

       #pragma unused inputtext, dialogid, pid

		if ( response ) 
		{
			if (listitem == EMMET_COLT_LISTITEM)
			{
				if (colt_stock < 1)
				{
					SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "This item is currently out of stock, check again soon." );
					Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);
					return cmd_emmet(playerid);
				} 

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] ) 
				{
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS ) );
				}
			}
			else if(listitem==EMMET_KNIFE_LISTITEM) 
			{
				/*
				if (GetPlayerFactionType(playerid) != 1) // FACTION_TYPE_CRIMINAL
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}

				if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 ) {

					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Only tier 1 can buy this weapon!");
				}

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] ) {

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS ) );
				}
				*/
			}
			else if(listitem==EMMET_RARE_LISTITEM) 
			{
				/*
				if (GetPlayerFactionType(playerid) != 1) // FACTION_TYPE_CRIMINAL
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] ) {

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS ) );
				}

				if(EmmetRareGun == -1) {

					EmmetRareGun = -1 ;
					EmmetRareGunAmmo = 0 ;
					EmmetRareGunCost = 0 ;

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "Emmet doesn't have any rare weapons in stock currently. Check back again later!" );
				}
				*/
			}
			else
			{
				if ( EmmetShop [ listitem ] [ EMMET_HOURS_NEEDED ] > Character [ playerid ] [ E_CHARACTER_HOURS ] ) {

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EmmetShop [ listitem ] [ EMMET_HOURS_NEEDED ] ) );
				}

				if (  EmmetShop [ listitem ] [ EMMET_GUN_COST ] > GetPlayerCash ( playerid ) ) {

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough money to buy this! You need at least $%s.", IntegerWithDelimiter( EmmetShop [ listitem ] [ EMMET_GUN_COST ] ) ) );
				}
			}


			Emmet_PerformAnimation ( playerid, E_EMMET_ANIM_1H_START, 0, listitem, 		true);
		}

		else if ( ! response ) {

			Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_OUT, 1, -1, false);
			return true ;
		}
	}  
	  
	  
	  
	  
	  
	Dialog_ShowCallback(playerid, using inline EmmetPurchase, DIALOG_STYLE_TABLIST_HEADERS, "Emmet's Stock", string, "Select", "Close"); 

 	return true ;
}

Emmet_PerformAnimation(playerid, type, choice, listitem, confirm) {

	switch ( type ) {

		case E_EMMET_ANIM_1H_START: {
			switch ( choice ) {

				case 1: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_1H_Ret", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation( playerid, E_EMMET_ANIM_1H_OUT, listitem, confirm ) ;
				}
				default: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_1H_Lift", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation(playerid, E_EMMET_ANIM_1H_RET, listitem, confirm ) ;
				}
			}
		}

		case E_EMMET_ANIM_2H_START: { // big

			switch ( choice ) {

				case 1: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_2H_Ret", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation( playerid, E_EMMET_ANIM_2H_OUT, listitem, confirm ) ;
				}
				default: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_2H_Lift", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation(playerid, E_EMMET_ANIM_2H_RET, listitem, confirm ) ;
				}
			}
		}

		case E_EMMET_ANIM_AR_START: { // ar

			switch ( choice ) {

				case 1: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_Ar_Ret", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation(playerid,  E_EMMET_ANIM_AR_OUT, listitem, confirm ) ;
				}
				default: {
					ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_Ar_Lift", 4.1, 0, 0, 0, 1, 0);
					defer Emmet_FinishAnimation(playerid, E_EMMET_ANIM_AR_RET, listitem, confirm ) ;
				}
			}
		}


	}
	

	return true ;
}



timer Emmet_FinishAnimation[1000](playerid, index, listitem, confirm) {

	new gun_name [ 64 ] ;
	new string [ 512 ] ;

	switch ( index ) {

		case E_EMMET_ANIM_1H_OUT: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_1H_Lift_End", 4.1, 0, 0, 0, 1, 0);
		case E_EMMET_ANIM_1H_RET: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_1H_Ret_S", 4.1, 0, 0, 0, 1, 0);
		case E_EMMET_ANIM_2H_OUT: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_2H_Lift_End", 4.1, 0, 0, 0, 1, 0);
		case E_EMMET_ANIM_2H_RET: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_2H_Ret_S", 4.1, 0, 0, 0, 1, 0);
		case E_EMMET_ANIM_AR_OUT: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_Ar_Lift_End", 4.1, 0, 0, 0, 1, 0);
		case E_EMMET_ANIM_AR_RET: ApplyDynamicActorAnimation(emmet, "WEAPONS", "SHP_Ar_Ret_S", 4.1, 0, 0, 0, 1, 0);
	}

	if ( listitem == EMMET_COLT_LISTITEM)
	{
		// Work out the extra cost
		new colt_cost, colt_stock, colt_extra;
		Emmet_GetCostAndStock(colt_cost, colt_stock);
		new colt_base = colt_cost;
		
		if (colt_stock < 1)
		{
			SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "This item is currently out of stock, check again soon." );
			Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);
			return cmd_emmet(playerid);
		} 

		for (new i = 0; i < MAX_EMMET_COLTS; i ++)
		{
			if (EmmetColts[i][E_COLT_BOUGHT_BY] != Character[playerid][E_CHARACTER_ID]) continue;
			colt_extra ++;
		}
 
		// Multiply the market rate by current stock owned by this player
		if (colt_extra > 0) colt_cost = colt_cost * (colt_extra + 1);

		format ( string, sizeof ( string ), "Please confirm your purchase\n\n%s with %d ammo\nFor the price of $%s.\n\nYou will need %d playing hours.",
		EMMET_COLT_NAME, EMMET_COLT_AMMO, IntegerWithDelimiter ( colt_cost  ), EMMET_COLT_HOURS ) ;

		if (colt_extra > 0)
		{
			format ( string, sizeof ( string ), "%s\n\n(Emmet is charging you %dx the current market rate of $%s as you recently bought %d %s from him)", string, colt_extra + 1, IntegerWithDelimiter ( colt_base  ), colt_extra, colt_extra == 1 ? "Colt" : "Colts" ) ;
		}

		inline EmmetPurchaseColt_Conf(pid, dialogid, response, listitemEx, string:inputtext[]) { 

	       #pragma unused inputtext, dialogid, pid, listitemEx

			if ( ! response ) {

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);
				cmd_emmet(playerid);
				return true ;
			}

			else if ( response ) 
			{
				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS) );

				if ( colt_cost > GetPlayerCash ( playerid ) )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough money to buy this! You need $%s.", IntegerWithDelimiter( colt_cost ) ) );
			
				if (IsPlayerInAnyGovFaction(playerid))
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}

				/*
				if (GetPlayerFactionType(playerid) != 1) // FACTION_TYPE_CRIMINAL
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}
				*/

				new colt = -1;

				for (new j = 0; j < MAX_EMMET_COLTS; j ++)
				{
					if (EmmetColts[j][E_COLT_BOUGHT_AT]) continue;
					colt = j;
				}

				if (colt == -1) return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", "Something went wrong, please try again.");

				EmmetColts[colt][E_COLT_BOUGHT_AT] = gettime();
				EmmetColts[colt][E_COLT_BOUGHT_BY] = Character[playerid][E_CHARACTER_ID];
				format(EmmetColts[colt][E_COLT_BOUGHT_BY_NAME], 32, "%s", Character[playerid][E_CHARACTER_NAME]);

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				SendClientMessage(playerid, -1, sprintf("You've purchased a %s with %d ammo from Emmet costing $%s.", EMMET_COLT_NAME, EMMET_COLT_AMMO, IntegerWithDelimiter( colt_cost )));

				TakePlayerCash(playerid, colt_cost) ;


				GiveCustomWeapon(playerid, EMMET_COLT_GUNID, EMMET_COLT_AMMO ) ;
				SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(EMMET_COLT_GUNID), EMMET_COLT_AMMO ) ;

				AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought an %s with %d ammo from Emmet costing $%s.", EMMET_COLT_NAME, EMMET_COLT_AMMO, IntegerWithDelimiter( colt_cost )));

				if ( SOLS_GetPlayerAmmo ( playerid ) >= 1500 ) {

					SendClientMessage(playerid, -1, "Warning: Hoarding ammo is a bannable offence. You may get banned for ammo hacking!");
				}

				return true ;
			}

		}

	  	return Dialog_ShowCallback(playerid, using inline EmmetPurchaseColt_Conf, DIALOG_STYLE_MSGBOX, "Emmet's Stock", string, "Buy", "Back"); 
	}

	else if ( listitem == EMMET_KNIFE_LISTITEM ) {

		format ( string, sizeof ( string ), "Please confirm your purchase\n\nKnife with 1 ammo\nFor the price of $%s.\n\nYou will need %d playing hours.",
			IntegerWithDelimiter ( EMMET_KNIFE_COST  ), EMMET_COLT_HOURS ) ;


		inline EmmetPurchaseColt_Conf(pid, dialogid, response, listitemEx, string:inputtext[]) { 

	       #pragma unused inputtext, dialogid, pid, listitemEx

			if ( ! response ) {

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);
				cmd_emmet(playerid);
				return true ;
			}

			else if ( response ) 
			{
				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS) );

				if ( EMMET_KNIFE_COST > GetPlayerCash ( playerid ) )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough money to buy this! You need $%s.", IntegerWithDelimiter( EMMET_KNIFE_COST ) ) );
			
				if (GetPlayerFactionType(playerid) != 1) // FACTION_TYPE_CRIMINAL
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}

				if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1  ) {

					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Only tier 1 can buy this weapon!");
				}

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				SendClientMessage(playerid, -1, sprintf("You've purchased a Knife with 1 ammo from Emmet costing $%s.", IntegerWithDelimiter( EMMET_KNIFE_COST )));

				TakePlayerCash(playerid, EMMET_KNIFE_COST) ;


				GiveCustomWeapon(playerid, 4, 1 ) ;
				SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(4), 1 ) ;

				AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought a Knife with 1 ammo from Emmet costing $%s.", IntegerWithDelimiter ( EMMET_KNIFE_COST )));

				if ( SOLS_GetPlayerAmmo ( playerid ) >= 1500 ) {

					SendClientMessage(playerid, -1, "Warning: Hoarding ammo is a bannable offence. You may get banned for ammo hacking!");
				}

				return true ;
			}

		}

	  	return Dialog_ShowCallback(playerid, using inline EmmetPurchaseColt_Conf, DIALOG_STYLE_MSGBOX, "Emmet's Stock", string, "Buy", "Back"); 
	}

	else if ( listitem == EMMET_RARE_LISTITEM ) {
		new rare_gun_name[64];

		if ( EmmetRareGun ) {
			format(rare_gun_name, 64, "%s", Weapon [ EmmetRareGun ] [ E_WEAPON_DESC ] );
		}

		else format ( rare_gun_name, 64, "Invalid");

		format ( string, sizeof ( string ), "Please confirm your purchase\n\n%s with %d ammo\nFor the price of $%s.\n\nYou will need %d playing hours.",
			rare_gun_name, EmmetRareGunAmmo, IntegerWithDelimiter ( EmmetRareGunCost  ), EMMET_COLT_HOURS ) ;

		inline EmmetPurchaseColt_Conf(pid, dialogid, response, listitemEx, string:inputtext[]) { 

	       #pragma unused inputtext, dialogid, pid, listitemEx

			if ( ! response ) {

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);
				cmd_emmet(playerid);
				return true ;
			}

			else if ( response ) 
			{
				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				if ( EMMET_COLT_HOURS > Character [ playerid ] [ E_CHARACTER_HOURS ] )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EMMET_COLT_HOURS) );

				if ( EmmetRareGunCost > GetPlayerCash ( playerid ) )
					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough money to buy this! You need $%s.", IntegerWithDelimiter( EMMET_KNIFE_COST ) ) );


				if (GetPlayerFactionType(playerid) != 1) // FACTION_TYPE_CRIMINAL
				{
					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can use Emmet.");
				}

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				SendClientMessage(playerid, -1, sprintf("You've purchased a %s with %d ammo from Emmet costing $%s.", rare_gun_name, EmmetRareGunAmmo, IntegerWithDelimiter( EmmetRareGunCost )));

				TakePlayerCash(playerid, EmmetRareGunCost) ;

				GiveCustomWeapon(playerid, EmmetRareGun, EmmetRareGunAmmo ) ;
				SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(EmmetRareGun), EmmetRareGunAmmo ) ;

				AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought an %s with %d ammo from Emmet costing $%s.", rare_gun_name, EmmetRareGunAmmo, IntegerWithDelimiter( EmmetRareGunCost )));

				EmmetRareGunCooldown  = gettime () + 21600 ; // 6 hours ;

				EmmetRareGun = -1 ;
				EmmetRareGunAmmo = 0 ;
				EmmetRareGunCost = 0 ; 

				if ( SOLS_GetPlayerAmmo ( playerid ) >= 1500 ) {

					SendClientMessage(playerid, -1, "Warning: Hoarding ammo is a bannable offence. You may get banned for ammo hacking!");
				}

				return true ;
			}

		}

	  	return Dialog_ShowCallback(playerid, using inline EmmetPurchaseColt_Conf, DIALOG_STYLE_MSGBOX, "Emmet's Stock", string, "Buy", "Back"); 
	}

	if ( listitem < 0 || listitem >= sizeof ( EmmetShop ) ) {

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, emmet_gun_obj, E_STREAMER_MODEL_ID, 2039 );
		confirm = false ;
	}

	else {

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, emmet_gun_obj, E_STREAMER_MODEL_ID, EmmetShop [ listitem ] [ EMMET_GUN_MODEL ] );
	}

	new Float: x, Float: y, Float: z ;

	foreach(new nearestid: Player ) {

		GetDynamicActorPos(emmet, x, y, z);

		if ( IsPlayerInRangeOfPoint(nearestid, 10.0, x, y, z) ) {

			Streamer_Update(nearestid, STREAMER_TYPE_OBJECT ) ;
		}

		else continue ;
	}

	if ( confirm ) {

		if ( listitem < 0 || listitem > sizeof ( EmmetShop ) ) {

			SendClientMessage(playerid, -1, "Tried to confirm purchase, but the weapon passed to the menu was invalid. Try again." ) ;

			return true ;
		}

		inline EmmetPurchase_Conf(pid, dialogid, response, listitemEx, string:inputtext[]) { 

	       #pragma unused inputtext, dialogid, pid, listitemEx

			if ( ! response ) {

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				cmd_emmet(playerid);

				return true ;
			}

			else if ( response ) {

				Emmet_PerformAnimation(playerid, E_EMMET_ANIM_1H_START, 1, -1, false);

				if ( Character [ playerid ] [ E_CHARACTER_HOURS ] < EmmetShop [ listitem ] [ EMMET_HOURS_NEEDED ] ) {

					return SendServerMessage(playerid, COLOR_ERROR, "Emmet", "A3A3A3", sprintf("You don't have enough playing hours to buy this! You need at least %d.", EmmetShop [ listitem ] [ EMMET_HOURS_NEEDED ]) );
				}


				Weapon_GetGunName (EmmetShop [ listitem ] [ EMMET_GUN_ID], gun_name, sizeof ( gun_name ) ) ;

				SendClientMessage(playerid, -1, sprintf("You've purchased a %s with %d ammo from Emmet costing $%s.",
					gun_name, EmmetShop [ listitem ] [ EMMET_GUN_AMMO], IntegerWithDelimiter ( EmmetShop [ listitem ] [ EMMET_GUN_COST ] ) )) ;

				TakePlayerCash(playerid, EmmetShop [ listitem ] [ EMMET_GUN_COST ] ) ;


				new idx = EmmetShop [ listitem ] [ EMMET_GUN_ID] ;
				GiveCustomWeapon(playerid, EmmetShop [ listitem ] [ EMMET_GUN_ID], EmmetShop [ listitem ] [ EMMET_GUN_AMMO] ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], EmmetShop [ listitem ] [ EMMET_GUN_AMMO] ) ;

				AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought an %s with %d ammo from Emmet costing $%s.", gun_name, EmmetShop [ listitem ] [ EMMET_GUN_AMMO], IntegerWithDelimiter ( EmmetShop [ listitem ] [ EMMET_GUN_COST ] )));


				if ( SOLS_GetPlayerAmmo ( playerid ) >= 1500 ) {

					SendClientMessage(playerid, -1, "Warning: Hoarding ammo is a bannable offence. You may get banned for ammo hacking!");
				}

				return true ;
			}

		}

		string[0]=EOS;
		Weapon_GetGunName (EmmetShop [ listitem ] [ EMMET_GUN_ID], gun_name, sizeof ( gun_name ) ) ;

		format ( string, sizeof ( string ), "Please confirm your purchase\n\n%s with %d ammo\nFor the price of $%s.\n\nYou will need %d playing hours.",
		gun_name, EmmetShop [ listitem ] [ EMMET_GUN_AMMO], IntegerWithDelimiter ( EmmetShop [ listitem ] [ EMMET_GUN_COST]  ), EmmetShop [ listitem ] [ EMMET_HOURS_NEEDED ] ) ;

	  	Dialog_ShowCallback(playerid, using inline EmmetPurchase_Conf, DIALOG_STYLE_MSGBOX, "Emmet's Stock", string, "Buy", "Back"); 
 	}

	return true ;
}
/*
CMD:emmetraregun(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	if ( EmmetRareGun == -1 ) {
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("Time left until next emmet rare guns refill: %d seconds.",

			EmmetRareGunCooldown - gettime()
		));
	}

	else SendClientMessage ( playerid, COLOR_GREEN, "Emmet currently has rare guns in stock!");

	return true ;
}

CMD:emmetforcerespawn(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new str[256] ;
	format ( str, sizeof ( str ), "[!!!] [AdmWarn] (%d) %s has given Emmet some rare shooters to hustle, chea my nig.", playerid, ReturnPlayerNameData ( playerid ) ) ;
	SendAdminMessage(str) ;

	EmmetRareGunCooldown  = gettime () + 21600 ;// 6 hours ;

	new random_index = random ( sizeof ( EmmetRareGuns ) ) ;

	EmmetRareGun = EmmetRareGuns [ random_index ] [ E_EMMET_RARE_GUNID ] ;
	EmmetRareGunAmmo = 1 + random (EmmetRareGuns [ random_index ] [ E_EMMET_RARE_AMMO_MAX ] ) ;
	EmmetRareGunCost = EmmetRareGunAmmo * EmmetRareGuns [ random_index ] [ E_EMMET_RARE_COST_PER_AMMO ] ;

	return true ;
}
*/