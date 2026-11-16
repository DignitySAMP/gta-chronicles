enum {
	E_PROP_NONE,

	E_PROP_WHITE_BOX_CLOSED = 1,
	E_PROP_WHITE_BOX_OPEN,

	E_PROP_GREEN_BOX_CLOSED,
	E_PROP_GREEN_BOX_OPEN,

	E_PROP_RED_BOX_CLOSED,
	E_PROP_RED_BOX_OPEN,

	E_PROP_BLUE_BOX_CLOSED,
	E_PROP_BLUE_BOX_OPEN,

	BURGERSHOT_MENU_HEALTHY, //2354
	BURGERSHOT_MENU_LOW, // 2213
	BURGERSHOT_MENU_MED, // 2214
	BURGERSHOT_MENU_HIGH, //2212

	CLUCKINBELL_MENU_HEALTHY, // 2353
	CLUCKINBELL_MENU_LOW, // 2215
	CLUCKINBELL_MENU_MED, // 2216
	CLUCKINBELL_MENU_HIGH, // 2217

	PIZZASTACK_MENU_HEALTHY, // 2355
	PIZZASTACK_MENU_LOW, // 2218
	PIZZASTACK_MENU_MED, // 2219
	PIZZASTACK_MENU_HIGH, // 2220

	DONUTS_MENU_LOW, // 2221
	DONUTS_MENU_MED, // 2222
	DONUTS_MENU_HIGH, // 2223
} ;

enum {
	E_INTERACT_TYPE_FOOD, 
	E_INTERACT_TYPE_DRINK
}

enum E_PROP_ITEM_DATA {

	E_PROP_ITEM_CONST,
	E_PROP_ITEM_DESC [ 32],
	E_PROP_ITEM_MODELID,
	E_PROP_ITEM_EFFECT,
	Float: E_PROP_ITEM_MODIFIER
} ;

enum {

	E_PROP_EFFECT_NONE,
	E_PROP_EFFECT_EAT,
	E_PROP_EFFECT_DRINK
} ;

enum {

	E_PROP_ITEM_NONE,
	E_PROP_ITEM_BOTTLE_YELLOW,
	E_PROP_ITEM_BOTTLE_WHITE,
	E_PROP_ITEM_BOTTLE_GREEN,
	E_PROP_ITEM_BOTTLE_BROWN,
	E_PROP_ITEM_BOTTLE_WHISKY,
	E_PROP_ITEM_BOTTLE_FLASK,

	E_PROP_ITEM_BOTTLE_VODKA,
	E_PROP_ITEM_BOTTLE_CORK,
	E_PROP_ITEM_BOTTLE_RED_WINE,
	E_PROP_ITEM_BOTTLE_WHITE_WINE,

	E_PROP_ITEM_DRINK_COFFEE,
	E_PROP_ITEM_DRINK_BEER_GLASS,
	E_PROP_ITEM_DRINK_WINE_GLASS,
	E_PROP_ITEM_DRINK_MIX_GLASS,
	E_PROP_ITEM_DRINK_SPRUNK_GLASS,
	E_PROP_ITEM_DRINK_SPRUNK_CAN,
	E_PROP_ITEM_DRINK_ECOLA_CAN,
	E_PROP_ITEM_DRINK_SODA_CUP,

	E_PROP_ITEM_FOOD_PIZZA_SLICE,
	E_PROP_ITEM_FOOD_BURGER,
	E_PROP_ITEM_FOOD_CLUCK_WRAP,
	E_PROP_ITEM_FOOD_CAKE_VANILLA,
	E_PROP_ITEM_FOOD_CAKE_CHOCOLATE,
	E_PROP_ITEM_FOOD_CAKE_CREAM,
	E_PROP_ITEM_FOOD_CHICKEN_LEG,
	E_PROP_ITEM_FOOD_STEAK
}

new PropItem [ ] [ E_PROP_ITEM_DATA ] = {

	{ E_PROP_ITEM_NONE , "None", 0, E_PROP_EFFECT_NONE, 0.0 },

	// Bottles
	{  E_PROP_ITEM_BOTTLE_YELLOW, "Yellow Bottle", 1544, E_PROP_EFFECT_DRINK, 4.0  }, // corona
	{  E_PROP_ITEM_BOTTLE_WHITE, "White Bottle", 1484, E_PROP_EFFECT_DRINK, 4.0 }, // fleischberg

	{  E_PROP_ITEM_BOTTLE_GREEN, "Green Bottle", 1486, E_PROP_EFFECT_DRINK, 4.0 }, // malt liquor
	{  E_PROP_ITEM_BOTTLE_BROWN, "Brown Bottle", 1543, E_PROP_EFFECT_DRINK, 4.0 }, // pissch

	{  E_PROP_ITEM_BOTTLE_WHISKY, "Whisky Bottle", 19820, E_PROP_EFFECT_DRINK, 6.0 }, // whisky
	{  E_PROP_ITEM_BOTTLE_FLASK, "Whisky Flask", 19823, E_PROP_EFFECT_DRINK, 6.0 }, // whisky

	{  E_PROP_ITEM_BOTTLE_VODKA, "Vodka Bottle", 19821, E_PROP_EFFECT_DRINK,  5.0 }, // vodka
	{  E_PROP_ITEM_BOTTLE_CORK, "Beer Cork Bottle", 1950, E_PROP_EFFECT_DRINK, 5.0 }, // 40oz

	{  E_PROP_ITEM_BOTTLE_RED_WINE, "Red Wine Bottle", 19822, E_PROP_EFFECT_DRINK, 4.0 }, // wine
	{ E_PROP_ITEM_BOTTLE_WHITE_WINE , "White Wine Bottle", 19824, E_PROP_EFFECT_DRINK, 4.0 }, // wine


	// Cups / Glasses
	{  E_PROP_ITEM_DRINK_COFFEE, "Coffee", 19835, E_PROP_EFFECT_DRINK, 3.5 },

	{  E_PROP_ITEM_DRINK_BEER_GLASS, "Beer Glass", 1666, E_PROP_EFFECT_DRINK, 4.0 },
	{  E_PROP_ITEM_DRINK_WINE_GLASS, "Wine Glass", 19818, E_PROP_EFFECT_DRINK, 4.0 },
	{  E_PROP_ITEM_DRINK_MIX_GLASS, "Cocktail Glass", 19819, E_PROP_EFFECT_DRINK, 5.0 },

	{  E_PROP_ITEM_DRINK_SPRUNK_GLASS, "Sprunk Glass", 1666, E_PROP_EFFECT_DRINK, 2.0 },
	{  E_PROP_ITEM_DRINK_SPRUNK_CAN, "Sprunk Can", -24997, E_PROP_EFFECT_DRINK, 2.0 }, // make it so all vending machines sell these
	{  E_PROP_ITEM_DRINK_ECOLA_CAN, "E-Cola Can", -24995, E_PROP_EFFECT_DRINK, 2.0 }, // make it so all vending machines sell these
	{  E_PROP_ITEM_DRINK_SODA_CUP, "Soda Cup", 2647, E_PROP_EFFECT_DRINK, 2.0 },
	
	// remove all vending machines & recreate custom ones


	{  E_PROP_ITEM_FOOD_PIZZA_SLICE, "Pizza Slice", 2702, E_PROP_EFFECT_EAT, 12.5 },
	{  E_PROP_ITEM_FOOD_BURGER, "Burger", 2703, E_PROP_EFFECT_EAT, 12.5 },
	{  E_PROP_ITEM_FOOD_CLUCK_WRAP, "Cluckin' Wrap", 2769, E_PROP_EFFECT_EAT, 12.5 },

	// For donut menus
	{ E_PROP_ITEM_FOOD_CAKE_VANILLA, "Vanilla Cake", 11740, E_PROP_EFFECT_EAT, 12.5 },
	{ E_PROP_ITEM_FOOD_CAKE_CHOCOLATE, "Chocolate Cake", 11741, E_PROP_EFFECT_EAT, 12.5 },
	{ E_PROP_ITEM_FOOD_CAKE_CREAM, "Cream Cake", 11739, E_PROP_EFFECT_EAT, 12.5 },

	{ E_PROP_ITEM_FOOD_CHICKEN_LEG, "Chicken Leg", 19847, E_PROP_EFFECT_EAT, 12.5 },
	{ E_PROP_ITEM_FOOD_STEAK, "Steak", 19882, E_PROP_EFFECT_EAT, 12.5 }
} ;

GetPropItemName(type, name [], len = sizeof ( name ) ) {

	format ( name, len, "%s", PropItem [ type ] [ E_PROP_ITEM_DESC ] ) ;
}

GetPropItemEffect ( type ) {

	return PropItem [ type ] [ E_PROP_ITEM_EFFECT ];
}

OnPlayerBuyFood(playerid, type, constant) 
{
	switch ( constant ) 
	{
		case CLUCKINBELL_MENU_LOW, CLUCKINBELL_MENU_MED, CLUCKINBELL_MENU_HIGH, PIZZASTACK_MENU_HEALTHY, CLUCKINBELL_MENU_HEALTHY, BURGERSHOT_MENU_HEALTHY:
		{  
			SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC, 2769, 6, 0.02, 0.04, 0.01, 86.50, -0.60, -111.30, 1.00, 1.00, 1.00);
			ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, false, 0, 0, 0, 0, 1);
		}
		case PIZZASTACK_MENU_LOW, PIZZASTACK_MENU_MED, PIZZASTACK_MENU_HIGH:
		{
			SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC, 2702, 6, 0.03, 0.10, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
			ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, false, 0, 0, 0, 0, 1);
		}
		case BURGERSHOT_MENU_LOW, BURGERSHOT_MENU_MED, BURGERSHOT_MENU_HIGH:
		{
			SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,2703,6,0.093999,0.037999,0.015999,0.000000,0.000000,53.400005,1.000000,0.654999,1.000000);
			ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, 0, 0, 0, 0, 1);
		}
		case DONUTS_MENU_LOW, DONUTS_MENU_MED, DONUTS_MENU_HIGH: 
		{
			SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC, 11740, 6, 0.07, 0.07, 0.00, -6.69, 84.39, 0.00, 0.54, 0.50, 0.74);
			ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, 0, 0, 0, 0, 1);
		}

		case E_PROP_WHITE_BOX_CLOSED: 	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,1544,6,0.085999,0.032000,-0.164000,0.000000,0.000000,0.000000,0.878999,0.880999,0.766999);
		case E_PROP_WHITE_BOX_OPEN: 	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,1484,6,0.019999,0.004999,-0.005000,0.000000,37.199981,0.000000,1.000000,1.000000,1.000000);
		case E_PROP_GREEN_BOX_CLOSED:	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,1486,6,0.094999,0.028000,-0.063999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000); 
		case E_PROP_GREEN_BOX_OPEN: 	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,1950,6,0.077999,0.035999,-0.015000,0.000000,9.899999,2.499994,0.636000,0.596000,0.656000);
		case E_PROP_RED_BOX_CLOSED: 	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,19823,6,0.081999,0.041000,-0.287999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
		case E_PROP_RED_BOX_OPEN: 		SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,1543,6,0.076999,0.034000,-0.176000,0.000000,0.000000,0.000000,1.000000,1.000000,0.882999);
		case E_PROP_BLUE_BOX_CLOSED:	SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,19822,6,0.094999,0.035000,-0.404999,0.000000,0.000000,0.000000,0.838999,0.810999,0.948000);
		case E_PROP_BLUE_BOX_OPEN: 		SetPlayerAttachedObject(playerid,E_ATTACH_INDEX_MISC,19821,6,0.096999,0.035000,-0.285000,0.000000,0.000000,0.000000,0.763000,0.611000,0.631999);
	}

	new propidx = -1;
	new Float: heal_amount = 5.0;

	if (type == E_INTERACT_TYPE_DRINK)
	{
		if (IsPlayerMale(playerid))
		{
			ApplyAnim(playerid, "GANGS", "drnkbr_prtl", 4.1, true, 0, 0, 1, 1, 1);
		}
		else
		{
			ApplyAnim(playerid, "GANGS", "drnkbr_prtl_F", 4.1, true, 0, 0, 1, 1, 1);
		}

		for (new i = 0; i < sizeof(PropItem); i ++)
		{
			if (PropItem[i][E_PROP_ITEM_CONST] == constant)
			{
				propidx = i;
				break;
			}
		}

		if (propidx >= 0)
		{
			if (PropItem[propidx][E_PROP_ITEM_MODELID] == -24997 || PropItem[propidx][E_PROP_ITEM_MODELID] == -24995)
			{
				SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC, PropItem[propidx][E_PROP_ITEM_MODELID], 6, 0.01, 0.05, 0.00, 0.00, 177.50, -157.90, 1.00, 1.00, 1.00);
			}
			else
			{
				SetPlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC, PropItem[propidx][E_PROP_ITEM_MODELID], 6, 0.01, 0.07, 0.01, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
			}			
		}

		Gym_AppendPlayerNeeds(playerid, E_GYM_STAT_THIRST, 3+random(4));
	}
	else if (type == E_INTERACT_TYPE_FOOD)
	{
		switch ( constant ) 
		{
			case CLUCKINBELL_MENU_HEALTHY, PIZZASTACK_MENU_HEALTHY, BURGERSHOT_MENU_HEALTHY: {
				
				Gym_AppendPlayerNeeds ( playerid, E_GYM_STAT_HUNGER, 1+random(3));
				heal_amount = 25.0 ;
			}
			case CLUCKINBELL_MENU_LOW, PIZZASTACK_MENU_LOW , BURGERSHOT_MENU_LOW, DONUTS_MENU_LOW: {
				
				Gym_AppendPlayerNeeds ( playerid, E_GYM_STAT_HUNGER, 2+random(3));
				heal_amount = 35.0 ;
			}
			case CLUCKINBELL_MENU_MED, PIZZASTACK_MENU_MED, BURGERSHOT_MENU_MED, DONUTS_MENU_MED: {
				
				Gym_AppendPlayerNeeds ( playerid, E_GYM_STAT_HUNGER, 3+random(4));
				heal_amount = 50.0 ;
			}
			case CLUCKINBELL_MENU_HIGH, PIZZASTACK_MENU_HIGH, BURGERSHOT_MENU_HIGH, DONUTS_MENU_HIGH: {
				
				Gym_AppendPlayerNeeds ( playerid, E_GYM_STAT_HUNGER, 4+random(5));
				heal_amount = 75.0 ;
			}
		}
	}
	
	new Float: heal = GetCharacterHealth ( playerid ) ;

	heal += heal_amount ;

	if ( heal > 100.0 ) 
	{
		// SendClientMessage(playerid, COLOR_YELLOW, "You have healed to full health." ) ;
		heal = 100.0 ;
	}

	SetCharacterHealth ( playerid, heal ) ;
	defer PropUse_ClearUseAnim(playerid);

	return true ;
}

timer PropUse_ClearUseAnim[3500](playerid ) {
	

	cmd_stopanim(playerid, "");
	RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_MISC ) ;


	return true ;
}

CMD:myprops(playerid, params[]) {

	SendClientMessage(playerid, COLOR_YELLOW, "This is now deprecated. Use /hold for food options." ) ;

	return true ;
}
CMD:dropprop(playerid, params[]) {

	SendClientMessage(playerid, COLOR_YELLOW, "This is now deprecated. Use /hold for food options." ) ;

	return true ;
}