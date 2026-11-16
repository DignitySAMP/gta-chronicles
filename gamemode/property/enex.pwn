enum E_STATIC_BUY_POSITIONS {

	Float: E_BUY_POS_X,
	Float: E_BUY_POS_Y,
	Float: E_BUY_POS_Z,
	E_BUY_TYPE,
	E_BUY_MAPICON,
	E_BUY_PICKUP_MODEL
} ;

new BuyPoint [ ] [ E_STATIC_BUY_POSITIONS ] = {

	//{ 1840.8417,-1844.8712,13.5912, E_BUY_TYPE_GENERAL, 			true }, // unity
	{ 2414.4395, 	-1504.0961, 	23.9969, E_BUY_TYPE_FOOD_CLUCKINBELL, 	true },
	{ 1034.7678,	-1348.2057,		13.7301, E_BUY_TYPE_FOOD_DONUTS, 		true }, 
	{ 2106.4382,	-1797.7552,		13.5729, E_BUY_TYPE_FOOD_PIZZASTACK, 	true },  
	{ 2393.3416, 	-1905.6464, 	13.5541, E_BUY_TYPE_FOOD_CLUCKINBELL, 	true },
	{ 2858.9163,	-1465.9064,		10.9452, E_BUY_TYPE_JEWELRY,			true }, // jewelry EAST beach
	//{ 1684.2207,	-1183.5659,		23.9794, E_BUY_TYPE_JEWELRY,			true } , // mulholland buypoint
	//{ 1608.8463,	-1831.5997,		13.6299, E_BUY_TYPE_RESTAURANT, 		true }, // mexico_restaurant
	//{ 1918.9559,	-1804.7881,		13.5574, E_BUY_TYPE_LIQUOR, 			true }, // enex_liquorstore
	{ 1539.2136,	-1503.9666,		13.5904, E_BUY_TYPE_RESTAURANT,			true }, // chinatown restaurant
	{ 1508.2358,	-1487.9713,		13.5559, E_BUY_TYPE_LIQUOR,				true }, // chinatown liquor
	{ 1924.2190,	-1771.4872,		13.5781, E_BUY_TYPE_GENERAL, 			true }, // enex_idle_buy
	{ 2427.9097,	-1744.8375,		13.6750, E_BUY_TYPE_GENERAL, 			true }, // enex_buypoint_ganton

	{ 1859.6959,	-1670.7086,		13.4221, E_BUY_TYPE_FOOD_BURGERSHOT,		true },// alhambra  enex_burgershot
	{ 1860.1350,	-1699.6982,		13.6450, E_BUY_TYPE_GENERAL,				true },// alhambra  24/7_enex
	{ 1901.2614,	-1701.5897,		13.5963, E_BUY_TYPE_LIQUOR,				true }, //  alhambra liquor_enex

	{ 2729.9673,	-2024.3129,		9.6557, E_BUY_TYPE_BARBERSHOP,				true },	 // seville_barbershop_enex
	{ 2727.1809,	-2034.8020,		13.6484, E_BUY_TYPE_GENERAL,			true },	 // seville_247_buypoint

	// Drivethrus 
	{ 2108.5146, 	-1813.3501, 	13.3932, E_BUY_TYPE_FOOD_PIZZASTACK, 	false },  // idle pizza
	{ 2409.3032,	-1487.8939,		23.4782, E_BUY_TYPE_FOOD_CLUCKINBELL, 	false }, // cluck_drivethru_els
	{ 2377.5679,	-1909.2240,		13.0324, E_BUY_TYPE_FOOD_CLUCKINBELL, 	false }, // cluck_drivethru_willowfield

	{ 1858.3068,	-1659.9426,		13.4727, E_BUY_TYPE_FOOD_BURGERSHOT,	false }, // alhambra burgershot
	{ 2065.4507,	-1792.4159,		9.5914, E_BUY_TYPE_BARBERSHOP,			true },

	// Mall
	{ 1703.5681, -1704.3676, 13.3752, E_BUY_TYPE_AMMUNATION, true },
	{ 1736.1013, -1700.9686, 13.5392, E_BUY_TYPE_GENERAL, true },
	{ 1738.0686, -1655.4475, 13.5205, E_BUY_TYPE_FOOD_DONUTS, false },
	{ 1721.3969, -1617.3173, 20.2998, E_BUY_TYPE_CLOTHING_CUSTOM, true, 1275 },
	{ 1707.2611, -1661.5721, 20.1712, E_BUY_TYPE_MUSIC, true, 1962 },
	{ 1704.3291, -1686.8612, 20.1881, E_BUY_TYPE_RESTAURANT, false, 1666 },
	{ 1739.3351, -1688.5635, 20.1729, E_BUY_TYPE_ELECTRONIC, true, 1277 },
	{ 1705.1145, -1648.6371, 13.5276, E_BUY_TYPE_FOOD_PIZZASTACK, false, 2881 },
	{ 1703.9689, -1685.7186, 13.2598, E_BUY_TYPE_HARDWARE, true },
	{ 1736.2285, -1703.0347, 20.1783, E_BUY_TYPE_BARBERSHOP, false }
 
} ;

Property_SetupBuyPoints() {


	new label [ 256 ], icon ;

	for_loop(new i, j = sizeof ( BuyPoint ); i < j ; i ++ ) {

		switch ( BuyPoint [ i ] [ E_BUY_TYPE ] ) {

			case E_BUY_TYPE_GENERAL: {

				format(label, sizeof(label), "[General Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 17 ;
			}
			
			case E_BUY_TYPE_LIQUOR: {

				format(label, sizeof(label), "[Liquor Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 49 ;
			}			
			case E_BUY_TYPE_JEWELRY: {

				format(label, sizeof(label), "[Jewelry Store]{DEDEDE}\nAvailable Commands: None\nView the Attach Points to access this shop.");
				icon = 33 ;
			}

			case E_BUY_TYPE_CLOTHING: {

				format(label, sizeof(label), "[Clothing Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 45 ;
			}		
				
			case E_BUY_TYPE_ELECTRONIC: {

				format(label, sizeof(label), "[Electronic Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 35 ;
			}
	
			case E_BUY_TYPE_RESTAURANT: {
				format(label, sizeof(label), "[Restaurant]{DEDEDE}\nAvailable Commands: /buy");
				icon = 50 ;	
			}

			case E_BUY_TYPE_FOOD_CLUCKINBELL: {

				format(label, sizeof(label), "[Cluckin' Bell]{DEDEDE}\nAvailable Commands: /buy");
				icon = 14 ;
			}

			case E_BUY_TYPE_FOOD_PIZZASTACK: {

				format(label, sizeof(label), "[Pizza Stack]{DEDEDE}\nAvailable Commands: /buy");
				icon = 29 ;
			}

			case E_BUY_TYPE_FOOD_BURGERSHOT: {

				format(label, sizeof(label), "[Burger Shot]{DEDEDE}\nAvailable Commands: /buy");
				icon = 10 ;
			}
			case E_BUY_TYPE_FOOD_DONUTS: {

				format(label, sizeof(label), "[Coffee Shop]{DEDEDE}\nAvailable Commands: /buy");
				icon = 16 ;
			}

			case E_BUY_TYPE_BARBERSHOP: {


				format(label, sizeof(label), "[Barbershop]{DEDEDE}\nAvailable Commands: None\nView the Attach Points to access this shop.");
				icon = 7 ;
			}

			case E_BUY_TYPE_AMMUNATION: {

				format(label, sizeof(label), "[Ammu-Nation]{DEDEDE}\nAvailable Commands: /buy");
				icon = 6 ;
			}

			case E_BUY_TYPE_HARDWARE: {

				format(label, sizeof(label), "[Hardware Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 11 ;
			}

			case E_BUY_TYPE_MUSIC: {

				format(label, sizeof(label), "[Music Shop]{DEDEDE}\nAvailable Commands: /buy");
				icon = 48 ;
			}

			case E_BUY_TYPE_CLOTHING_CUSTOM: {

				format(label, sizeof(label), "[Exclusive Clothing Store]{DEDEDE}\nAvailable Commands: /buy");
				icon = 45 ;
			}


			default: {

				format(label, sizeof(label), "[Undefined]{DEDEDE}\nAvailable Commands: none");
			}
		}

		CreateDynamic3DTextLabel(label, COLOR_PROPERTY, 
			BuyPoint [ i ] [ E_BUY_POS_X ], BuyPoint [ i ] [ E_BUY_POS_Y ], BuyPoint [ i ] [ E_BUY_POS_Z ], 
			10.0, .testlos = 1
		) ;

		if ( BuyPoint [ i ] [ E_BUY_MAPICON ] ) {
			CreateDynamicMapIcon(BuyPoint [ i ] [ E_BUY_POS_X ], BuyPoint [ i ] [ E_BUY_POS_Y ], BuyPoint [ i ] [ E_BUY_POS_Z ], icon, 0xFFFFFFFF, -1, -1, -1, 20.0 ) ;
		}

		//new pickup_model = PropertyType_GetPickup(BuyPoint [ i ] [ E_BUY_TYPE ]);
		new pickup_model = BuyPoint [ i ] [ E_BUY_PICKUP_MODEL ];
		if (pickup_model)
		{
			CreateDynamicPickup(pickup_model, 1, BuyPoint [ i ] [ E_BUY_POS_X ], BuyPoint [ i ] [ E_BUY_POS_Y ], BuyPoint [ i ] [ E_BUY_POS_Z ], .streamdistance = 50.0);
		}

		
	}

	return true ;
}


