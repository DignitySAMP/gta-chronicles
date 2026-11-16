CMD:propcollect(playerid, params[]) {

	return cmd_propertycollect(playerid, params);
}
CMD:propertycollect(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return true ;
    }

	new property_enum_id = Property_GetClosestEntity( playerid ) ;

	if ( property_enum_id == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property.");
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_STATIC ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't collect from a static property.");
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own this property.");
	}


	SendServerMessage ( playerid, COLOR_PROPERTY, "Property", "A3A3A3", sprintf("You've withdrawn $%s from your property's safe.", IntegerWithDelimiter ( Property [ property_enum_id ] [ E_PROPERTY_COLLECT ] ) ) );

	GivePlayerCash ( playerid, Property [ property_enum_id ] [ E_PROPERTY_COLLECT ]  ) ;

	new old_till_value = Property [ property_enum_id ] [ E_PROPERTY_COLLECT ] ;
	Property [ property_enum_id ] [ E_PROPERTY_COLLECT ] = 0 ; 

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_collect = 0 WHERE property_id = %d",
		Property [ property_enum_id ] [ E_PROPERTY_ID ] ) ;
	
	mysql_tquery(mysql, query);

	query [ 0 ] = EOS ;


	format ( query, sizeof ( query ), "Player \"%s\" has withdrawn %d from their property till (new value: %d)", 
		TEMP_ReturnPlayerName(playerid), old_till_value, Property [ property_enum_id ] [ E_PROPERTY_COLLECT ]
	) ;
	WriteLog ( playerid, "property/collect", query);
	WriteLog ( playerid, "property", query);

	return true ;	
}

CMD:spoofbuy(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new type ;

	if ( sscanf ( params, "i", type ) ) {

		return SendClientMessage(playerid, -1, "/spoofbuy [type]" ) ;
	}

	
	OnPlayerPropertyBuy ( playerid, type, INVALID_PROPERTY_ID ) ;

	return true ;
}


IsPlayerNearSpecificBuyPoint(playerid, type=E_BUY_TYPE_NONE, Float: range=5.0) {
	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(playerid, range, Property [ i ] [ E_PROPERTY_BUY_POS_X ], Property [ i ] [ E_PROPERTY_BUY_POS_Y ], Property [ i ] [ E_PROPERTY_BUY_POS_Z ] ) ) {

			if ( GetPlayerVirtualWorld(playerid ) == Property [ i ] [ E_PROPERTY_BUY_POS_VW ] && GetPlayerInterior(playerid) == Property [ i ] [ E_PROPERTY_BUY_POS_INT ] ) {

				if ( Property [ i ] [ E_PROPERTY_BUY_TYPE ] == type ) {

					return Property [ i ] [ E_PROPERTY_ID ] ;
				} 

				else continue ;
			}

			else continue ;
		}

		else continue ;	
	}

	return INVALID_PROPERTY_ID ;
}
IsPlayerNearSpecificProperty(playerid, type=E_BUY_TYPE_NONE, Float: range=5.0) {
	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(playerid, range, Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], Property [ i ] [ E_PROPERTY_EXT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(playerid ) == Property [ i ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior(playerid) == Property [ i ] [ E_PROPERTY_EXT_INT ] ) {

				if ( Property [ i ] [ E_PROPERTY_BUY_TYPE ] == type ) {

					return Property [ i ] [ E_PROPERTY_ID ] ;
				} 

				else continue ;
			}

			else continue ;
		}

		else continue ;	
	}

	return INVALID_PROPERTY_ID ;
}

CMD:buy(playerid) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return true ;
    }

	for_loop(new i, j = sizeof ( BuyPoint ); i < j ; i ++ ) {

		if ( IsPlayerInRangeOfPoint(playerid, 5.0, BuyPoint [ i ] [ E_BUY_POS_X ], BuyPoint [ i ] [ E_BUY_POS_Y ], BuyPoint [ i ] [ E_BUY_POS_Z ] ) ) {

			OnPlayerPropertyBuy ( playerid, BuyPoint [ i ] [ E_BUY_TYPE ], INVALID_PROPERTY_ID ) ;

			return true ;
		}

		else continue ;
	}

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(playerid, 5.0, Property [ i ] [ E_PROPERTY_BUY_POS_X ], Property [ i ] [ E_PROPERTY_BUY_POS_Y ], Property [ i ] [ E_PROPERTY_BUY_POS_Z ] ) ) {

			if ( GetPlayerVirtualWorld(playerid ) == Property [ i ] [ E_PROPERTY_BUY_POS_VW ] && GetPlayerInterior(playerid) == Property [ i ] [ E_PROPERTY_BUY_POS_INT ] ) {

				if ( Property [ i ] [ E_PROPERTY_BUY_TYPE ] != E_BUY_TYPE_NONE ) {

					OnPlayerPropertyBuy(playerid, Property [ i ] [ E_PROPERTY_BUY_TYPE ], i  );

					break ;
				} 

				else continue ;
			}

			else continue ;
		}

		else continue ;	
	}

	return true ;
}

Store:Music_Store(playerid, response, itemid, modelid, price, amount, itemname[]) 
{
    if (!response) return true;

    if (GetPlayerCash(playerid) < price) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
    
   	new string [ 256 ] ;
    format(string, sizeof(string), "You've bought a %s for $%s.", itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Music Shop", "DEDEDE", string ) ;
	
	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) 
	{
    	case 0: {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Music Store", "DEDEDE", "To use a boombox use /boombox. Position it, click save and use /setstation." ) ;
    		PlayerVar [ playerid ] [ player_hasboombox ] = 1 ; // Boombox red
    	}
    	case 1: {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Music Store", "DEDEDE", "To use a boombox use /boombox. Position it, click save and use /setstation." ) ;
    		PlayerVar [ playerid ] [ player_hasboombox ] = 2 ; // Boombox grey
    	}
    	case 2: {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Music Store", "DEDEDE", "To use a boombox use /boombox. Position it, click save and use /setstation." ) ;
    		PlayerVar [ playerid ] [ player_hasboombox ] = 3 ; // Boombox black
    	}
    }

	format(string, sizeof(string), "Bought %dx %s from a Music Store for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

Store:Hardware_Store(playerid, response, itemid, modelid, price, amount, itemname[]) 
{
    if (!response) return true;

    if (GetPlayerCash(playerid) < price) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
    
   	new string [ 256 ] ;
    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Hardware Store", "DEDEDE", string ) ;
	
	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) 
	{
    	case 0: {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Hardware Store", "DEDEDE", "To use a toolkit, type \"/toolkit\" - note this item does not save if you quit." ) ;
    		PlayerVar [ playerid ] [ E_PLAYER_HAS_TOOLKIT ] = true ;// Tool Kit
    	}
    	case 1: {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Hardware Store", "DEDEDE", "To use a gas can, type \"/gascan\" - note this item does not save if you quit." ) ;
    		PlayerVar [ playerid ] [ E_PLAYER_HAS_GASCAN ] = true ;// Gas can
    	}
		case 2: 
		{
    		GiveCustomWeapon(playerid, 6, 1); // Shovel
			SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(6), 1);
    	}
		case 3: 
		{
    		GiveCustomWeapon(playerid, 11, 999 ) ; // Spraycan
			SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(11), 999);
    	}
		case 4: 
		{
    		SendServerMessage ( playerid, COLOR_PROPERTY, "Hardware Store", "DEDEDE", "To tie someone up, type \"/tieup\" - note this item does not save if you quit." ) ;
    		PlayerVar [ playerid ] [ E_PLAYER_ROPES ] ++ ;// Ropes
    	}
    }

	format(string, sizeof(string), "Bought %dx %s from a Hardware Store for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

static enum
{
	AMMU_ITEM_TYPE_GUN,
	AMMU_ITEM_TYPE_AMMO
}

static enum E_AMMU_ITEM
{
	E_AMMU_ITEM_TYPE,
	E_AMMU_ITEM_ID,
	E_AMMU_ITEM_AMOUNT,
	E_AMMU_ITEM_COST,
	E_AMMU_ITEM_DESC[128]
}

/*
static const AmmuItems[][E_AMMU_ITEM] = 
{
	{AMMU_ITEM_TYPE_GUN, 13, 17, 4250, "Pistol in 19x9mm Parabellum - requires a firearms permit"},
	{AMMU_ITEM_TYPE_GUN, 20, 7, 9000, "Premium Handgun in 7.62×39mm - requires a firearms permit"},
	{AMMU_ITEM_TYPE_GUN, 23, 7, 11500, "Big Bore Revolver in .44 Magnum - requires a firearms permit"},
	{AMMU_ITEM_TYPE_GUN, 55, 1, 9750, "Hunting Rifle in .30-06 Springfield - requires a firearms permit"},
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_A, 17, 2700, "Pistol Ammunition - requires a firearms permit"},
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_I, 7, 3000, "Premium Handgun Ammunition - requires a firearms permit"},
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_C, 7, 2880, "Revolver Ammunition - requires a firearms permit"},
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_D, 1, 175, "Rifle Ammunition - requires a firearms permit"}
};
*/

static const AmmuItems[][E_AMMU_ITEM] = 
{
	{AMMU_ITEM_TYPE_GUN, 72, 17, 4250, "Budget Pistol"},						// Colt45 "Kel-Tec P11" (with 17 ammo) for $4250
	{AMMU_ITEM_TYPE_GUN, 73, 7, 9000, "Premium Handgun"},						// Deagle "Ruger P90" (with 7 ammo) for $9000
	{AMMU_ITEM_TYPE_GUN, 23, 7, 11500, "Big Bore Revolver"},					// Deagle "Ruger Blackhawk" (with 7 ammo) for $11500
	{AMMU_ITEM_TYPE_GUN, 55, 5, 9750, "Hunting Rifle"},							// Country Rifle "Springfield M1903" (with 5 ammo) for $9750
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_A, 17, 2700, "Pistol Ammunition"},			// 9x19mm Parabellum Ammo (Glock 17/P-11) x 17 for $2700
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_B, 7, 3000, "Premium Handgun Ammunition"},	// .45 ACP (Ruger P90) Ammo x 7 for $3000
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_C, 7, 2880, "Revolver Ammunition"},			// .44 Magnum (Ruger Blackhawk) Ammo x 7 for $2800
	{AMMU_ITEM_TYPE_AMMO, AMMO_TYPE_D, 5, 900, "Rifle Ammunition"}				// .30-06 Springfield Ammo (Springfield M1903) x 5 for $900
};


Store:Gun_Store(playerid, response, itemid, modelid, price, amount, itemname[]) 
{
    if (!response) return true;

	if (!HasActiveGunLicense(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You do not posses a valid firearms license." ) ;
    }

    if (GetPlayerCash(playerid) < price) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
    
	new string [ 128 ] ;
	
	if (AmmuItems[itemid][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_GUN)
	{
		if (amount != 1) return SendServerMessage(playerid, COLOR_ERROR, "Error", "DEDEDE", "You can only buy one of this weapon.");
		if (!CanPlayerUseGuns(playerid, 8, -1)) return SendServerMessage(playerid, COLOR_ERROR, "Error", "DEDEDE", "You need eight playing hours to buy a gun.");

		amount = AmmuItems[itemid][E_AMMU_ITEM_AMOUNT];
		GiveCustomWeapon(playerid, AmmuItems[itemid][E_AMMU_ITEM_ID], amount);
		SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(AmmuItems[itemid][E_AMMU_ITEM_ID]), amount);

		format(string, sizeof(string), "You've bought a %s for $%s. To view your weapons, type \"/myguns\".", itemname, IntegerWithDelimiter(price));
	}
	else if (AmmuItems[itemid][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_AMMO)
	{
		new total = AmmuItems[itemid][E_AMMU_ITEM_AMOUNT] * amount;
		format(string, sizeof(string), "You've bought %dx of %s (%d total ammo) for $%s.", amount, itemname, total, IntegerWithDelimiter(price));

		if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_A) Character [ playerid ] [ E_CHARACTER_AMMO_A ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_B) Character [ playerid ] [ E_CHARACTER_AMMO_B ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_C) Character [ playerid ] [ E_CHARACTER_AMMO_C ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_D) Character [ playerid ] [ E_CHARACTER_AMMO_D ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_F) Character [ playerid ] [ E_CHARACTER_AMMO_F ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_G) Character [ playerid ] [ E_CHARACTER_AMMO_G ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_H) Character [ playerid ] [ E_CHARACTER_AMMO_H ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_I) Character [ playerid ] [ E_CHARACTER_AMMO_I ] += total;
		else if (AmmuItems[itemid][E_AMMU_ITEM_ID] == AMMO_TYPE_J) Character [ playerid ] [ E_CHARACTER_AMMO_J ] += total;
	}
   
	SendServerMessage ( playerid, COLOR_PROPERTY, "Ammu-Nation", "DEDEDE", string ) ;

	if (AmmuItems[itemid][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_GUN)
	{
		SendClientMessage(playerid, COLOR_RED, "Note that using firearms in the mall is against the server rules.");
	}

	if (AmmuItems[itemid][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_AMMO)
	{
		SendServerMessage ( playerid, COLOR_PROPERTY, "Ammu-Nation", "DEDEDE", "To view your ammo, type \"/myammo\", to (re)load, type \"/reload\"." );
	}

	format(string, sizeof(string), "Bought %dx %s from Ammu-Nation for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

	TakePlayerCash(playerid, price); 
	Property_AddMoneyToTill(playerid, price, .margin=true); 
    return true;
}

ShowPlayerClothesShop(playerid)
{
	ModelBrowser_ClearData(playerid);

	new name [ 64 ] ;

	for ( new i, j = 311 ; i < j ; i ++ ) {

		if ( ! IsValidSkin ( i ) ) {

			continue ;
		}

		switch ( i ) 
		{
			case // significant story/restricted char
				0, 16, 61, 71, 86, 149, 155, 167, 205, 209, 264, 265, 266, 267, 269, 
				270, 271, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 
				285, 286, 287, 288, 300, 301, 302, 306, 307, 308, 309, 310, 311: {
				continue ;
			}
		}

		if (Character[playerid][E_CHARACTER_ATTRIB_SEX] != E_ATTRIBUTE_SEX_MALE && GetSkinGender(i) == SKIN_GENDER_MALE) continue;
		else if (Character[playerid][E_CHARACTER_ATTRIB_SEX] != E_ATTRIBUTE_SEX_FEMALE && GetSkinGender(i) == SKIN_GENDER_FEMALE) continue;

		GetSkinName(i, name, sizeof ( name ) ) ;
		ModelBrowser_AddData(playerid, i, name ) ;
	}

	ModelBrowser_SetupTiles(playerid, "Clothing Store", "clothing_list" );
}

ShowPlayerCustomClothesShop(playerid, prop_enum_id)
{
	if (!PlayerVar[playerid][E_PLAYER_TRYING_SKIN])
	{
		new property_id = INVALID_PROPERTY_ID;
		if (prop_enum_id != INVALID_PROPERTY_ID) property_id = Property[prop_enum_id][E_PROPERTY_ID];
		
		// Used in model browser response
		PlayerVar[playerid][E_PLAYER_BIZ_MENU_SQL_ID] = property_id;
		GetPlayerPos(playerid, PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][0], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][1], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][2]);

		inline GetCustomSkins() 
		{
			new rows, fields;
			cache_get_data(rows, fields, mysql);

			if (!rows)
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "DEDEDE", "There are no items in stock." );
			}

			if ( rows ) 
			{
				new skinid, cost, name[32], baseid;
				ModelBrowser_ClearData(playerid);

				for_loop ( new i; i < rows; i ++ ) 
				{ 
					//dbid = cache_get_field_int (i, "buyable_skin_id");
					//propid = cache_get_field_int (i, "buyable_skin_propertyid");
					skinid = cache_get_field_int (i, "buyable_skin_skinid");
					cost = cache_get_field_int (i, "buyable_skin_cost");
					
					if (prop_enum_id == INVALID_PROPERTY_ID)
					{
						// Filter out opposite gender skins for PUBLIC, but not for private biz shops (so the owner can still see them, etc.)
						baseid = SOLS_GetPlayerBaseSkinID(skinid); // very loopy, sadly
						if (Character[playerid][E_CHARACTER_ATTRIB_SEX] != E_ATTRIBUTE_SEX_MALE && GetSkinGender(baseid) == SKIN_GENDER_MALE) continue;
						else if (Character[playerid][E_CHARACTER_ATTRIB_SEX] != E_ATTRIBUTE_SEX_FEMALE && GetSkinGender(baseid) == SKIN_GENDER_FEMALE) continue;
					}

					format(name, sizeof(name), "$%s", IntegerWithDelimiter(cost));
					ModelBrowser_AddData(playerid, skinid, name);
				}

				ModelBrowser_SetupTiles(playerid, "Clothing Store", "cstm_clothing_list");
			}
		}

		new query [ 128 ] ;
		mysql_format(mysql, query, sizeof(query), "SELECT * FROM buyable_skins WHERE buyable_skin_propertyid = %d", property_id);
		mysql_tquery_inline(mysql, query, using inline GetCustomSkins, "" );
	}

	return 1;
}

OnPlayerPropertyBuy ( playerid, type, property_enum_id ) 
{
	// property_id = enum
	// ^ this /was/ a lie :sob:
	// it now ACTUALLY uses the enum id

	// For the actual shop menu, use the shop plugin.

	new property_id = INVALID_PROPERTY_ID;

	if (property_enum_id != INVALID_PROPERTY_ID)
	{
		property_id = Property[property_enum_id][E_PROPERTY_ID];
	}
	PlayerVar [ playerid ] [ E_PLAYER_BIZ_MENU ] = property_id;

	switch ( type ) {

		case E_BUY_TYPE_MUSIC:
		{
			MenuStore_AddItem(playerid, 0, 2226, "Boombox: Red", 450, "A portable radio allowing you to stream music.", 0.0, true, 1, 0.0, 0.0, 180.0, 1.0);
			MenuStore_AddItem(playerid, 1, 2103, "Boombox: Grey", 390, "A portable radio allowing you to stream music.", 0.0, true, 1, 0.0, 0.0, 180.0, 1.0);
			MenuStore_AddItem(playerid, 2, 2102, "Boombox: Black", 375, "A portable radio allowing you to stream music.", 0.0, true, 1, 0.0, 0.0, 180.0, 1.0);

			MenuStore_Show(playerid, Music_Store, "Music");
		}

		case E_BUY_TYPE_HARDWARE:
		{
			MenuStore_AddItem(playerid, 0, 19921, "Toolkit", 425, "Allows you to kickstart a broken vehicle~n~~r~~h~(one time use - does NOT save)", 0.0, true, 1, 0.0, 0.0, 0.0, 1.5);
			MenuStore_AddItem(playerid, 1, 19621, "Gascan", 200, "Allows you to refuel an empty vehicle~n~~r~~h~(one time use - does NOT save)", 0.0, true, 1, -45.0, 45.0, 0.0, 1.0);
			// MenuStore_AddItem(playerid, 2, 3027, "Lockpick", 90, "Useful for when you forget your car keys", 0.0, true, 1, -45.0, 45.0, 0.0, 1.5);
			MenuStore_AddItem(playerid, 2, SP_GetWeaponModel(WEAPON_SHOVEL), "Shovel", 170, "Hurts if you get hit over the head with it", 0.0, true, 1, -45.0, 45.0, 0.0, 1.5);
			MenuStore_AddItem(playerid, 3, SP_GetWeaponModel(WEAPON_SPRAYCAN), "Spraycan", 300, "A can of spray-on paint for easy decorating", 0.0, true, 1, 0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 4, -25276, "Rope", 100, "Strong rope for tying things up with~n~~r~~h~(one time use - does NOT save)", 0.0, true, 1, -45.0, 45.0, 0.0, 1.0);

			MenuStore_Show(playerid, Hardware_Store, "Hardware");
		}

		case E_BUY_TYPE_AMMUNATION:
		{
			new desc[144], ammo_name[32], idx;

			for (new i = 0; i < sizeof(AmmuItems); i ++)
			{
				idx = AmmuItems[i][E_AMMU_ITEM_ID];

				if (AmmuItems[i][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_GUN)
				{
					Weapon_GetAmmoName(idx, ammo_name, sizeof(ammo_name));
					format(desc, sizeof(desc), "%s~n~(%s)", AmmuItems[i][E_AMMU_ITEM_DESC], ammo_name);
					strcat(desc, "~n~~r~~h~Requires a firearms permit.");

					MenuStore_AddItem(playerid, i, SP_GetWeaponModel(Weapon [ idx ] [ E_WEAPON_GUNID ]), Weapon [ idx ] [ E_WEAPON_DESC ], AmmuItems[i][E_AMMU_ITEM_COST], desc, 0.0, true, 1, 0.0, 0.0, 180.0, 1.0);
				}
				else if (AmmuItems[i][E_AMMU_ITEM_TYPE] == AMMU_ITEM_TYPE_AMMO)
				{
					if (AmmuItems[i][E_AMMU_ITEM_AMOUNT] == 1) format(desc, sizeof(desc), "%dx %s round.", AmmuItems[i][E_AMMU_ITEM_AMOUNT], Ammo [ idx ] [ E_AMMO_DESC ]);
					else format(desc, sizeof(desc), "%dx %s rounds.", AmmuItems[i][E_AMMU_ITEM_AMOUNT], Ammo [ idx ] [ E_AMMO_DESC ]);

					strcat(desc, "~n~~r~~h~Requires a firearms permit.");
					MenuStore_AddItem(playerid, i, 2061, Ammo [ idx ] [ E_AMMO_DESC ], AmmuItems[i][E_AMMU_ITEM_COST], desc, 0.0, true, 1, -45.0, 45.0, 0.0, 1.5);
				}
			}

			MenuStore_Show(playerid, Gun_Store, "Ammu-Nation");
		}

		case E_BUY_TYPE_GENERAL: 
		{
			MenuStore_AddItem(playerid, 0, 19621, "Fuel Can", 300, "Allows you to refuel an empty vehicle~n~~r~~h~(one time use - does NOT save)", 0.0, true, 1, -45.0, 45.0, 0.0, 1.5);
			MenuStore_AddItem(playerid, 1, -24997, "Can of Sprunk", 50, "A can of Sprunk that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);
			MenuStore_AddItem(playerid, 2, -24995, "Can of E-Cola", 50, "A can of E-Cola that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);
			MenuStore_AddItem(playerid, 3, 11704, "Mask", 900, "A mask to conceal your identity.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 4, 19914, "Baseball Bat", 500, "For playing America's favorite game.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 5, 3054, "Ziploc Bag", 40, 	"Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 6, 1950, "Pill Bottle", 50, 	"Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 7, 2663, "Takeaway Bag", 55, 	"Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 8, 19569, "Milk Carton", 70, 	"Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 9, 19835, "Plastic Cup", 60, 	"Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;
			MenuStore_AddItem(playerid, 10, 11748, "Plastic Foil (Brick)", 100, "Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;

			MenuStore_Show(playerid, General_Store, "General Store");

			return true ;
		}

		case E_BUY_TYPE_LIQUOR: {
			MenuStore_AddItem(playerid, 0, 1544, "Crate of Corona", 75, "Gives you a placable 6pack crate with Corona bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 1, 1484, "Crate of Fleischberg", 75, "Gives you a placable 6pack crate with Fleischberg bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);

			MenuStore_AddItem(playerid, 2, 1486, "Crate of Malt Liquour", 75, "Gives you a placable 6pack crate with Malt Liquour bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 3, 1950, "Crate of 40oz", 75, "Gives you a placable 6pack crate with 40oz bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);

			MenuStore_AddItem(playerid, 4, 19820, "Crate of Whisky", 75, "Gives you a placable 6pack crate with Whisky bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 5, 1543, "Crate of Pissch", 75, "Gives you a placable 6pack crate with Pisch bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);

			MenuStore_AddItem(playerid, 6, 19822, "Crate of Wine", 75, "Gives you a placable 6pack crate with Wine bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 7, 19821, "Crate of Vodka", 75, "Gives you a placable 6pack crate with Vodka bottles", 0.0, true, 1,  0.0, 0.0, 0.0, 1.0);
			
			MenuStore_Show(playerid, Liquor_Store, "Liquor Store");
		}

		case E_BUY_TYPE_CLOTHING: {

			ShowPlayerClothesShop(playerid);

		/*
		 	inline ClothingStorePop(pid, dialogid, response, listitem, string:inputtext[]) {

		 		if ( response ) {

			        #pragma unused pid, dialogid, listitem, inputtext

			 		new skinid = strval(inputtext ) ;

			 		if ( skinid < 1 || ! IsValidSkin ( skinid ) ) {

			 			SendClientMessage(playerid, COLOR_RED, "The skin ID you entered is invalid!");
			 			return OnPlayerPropertyBuy ( playerid, type, property_id ) ;
			 		}

			 		if ( GetSkinGang ( skinid ) == SKIN_GANG_NONE && GetSkinGroup ( skinid ) != SKIN_GROUP_MISSION ) {

				 		if ( GetPlayerCash(playerid) < 5 ) {

				 			return SendClientMessage(playerid, COLOR_RED, "You need at least $5 to do this!");
				 		}

				 		TakePlayerCash(playerid, 5);
				 		SetPlayerSkinEx(playerid, skinid ) ;
				 	}

				 	else return SendClientMessage(playerid, COLOR_RED, "You can not select mission skins or gang skins here!");
			 	}
		 	}

			Dialog_ShowCallback(playerid, using inline ClothingStorePop, DIALOG_STYLE_INPUT, "Clothing Store", "Enter the skin ID you wish to use.\n\nFor a list of all skins go to\nhttp://wiki.sa-mp.com/wiki/Skins:All\n\nA skin costs $5.", "Proceed", "Cancel");

			*/
		}

		case E_BUY_TYPE_ELECTRONIC: {

			MenuStore_AddItem(playerid, 0, 18868, "Black Phone",  250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 1, 18866, "Blue Phone",  250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 2, 18871, "Green Phone",  250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 3, 18869, "Purple Phone", 250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 4, 18873, "Yellow Phone", 250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 5, 18874, "White Phone",  250, "A mobile device that allows you to make calls and send messages to people.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			// ALWAYS add items AFTER the phones, or the array with phone colors will mess up!!!!!!!!!!
			MenuStore_AddItem(playerid, 6, 18875, "Pager",  100, "A two-way pager for sending and receiving simple text messages on a set channel.", 0.0, true, 1, 90.0, 180.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 7, 19623, "Camera", 200, "A handheld, disposable camera to take pictures with.", 0.0, true, 1, 0.0, 0.0, 0, 1.0 ) ;

			MenuStore_Show(playerid, Electronic_Store, "Electronic Store");
		}

		case E_BUY_TYPE_RESTAURANT: {
			MenuStore_AddItem(playerid, 0, 2214, "Medium Burger Menu",  125, "A medium burger meal that replenishes hunger.", 			0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 1, 2219, "Medium Pizza Menu",  125, "A medium pizza meal that replenishes hunger.", 			0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 2, 2216, "Medium Chicken Menu",  125, "A medium chicken meal that replenishes hunger.", 		0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 3, 2355, "Healthy Menu",  125, "A healthy meal that replenishes hunger.", 						0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 4, 1667, "Glass of Wine", 100, "A glass of wine that replenishes thirst", 						0.0, true, 1, 0.0, 0.0, 50.0, 0.75);
			MenuStore_AddItem(playerid, 5, 1666, "Glass of Sprunk", 50, "A glass of Sprunk that replenishes thirst", 					0.0, true, 1, 0.0, 0.0, 50.0, 0.75);
			MenuStore_AddItem(playerid, 6, 19835, "Cup of Coffee", 75, "A cup of coffee that replenishes thirst", 						0.0, true, 1, 0.0, 0.0, 50.0, 0.75);
			
			MenuStore_Show(playerid, Restaurant_Store, "Restaurant");	
		}

		case E_BUY_TYPE_FOOD_CLUCKINBELL: {
			//MenuStore_AddItem(playerid, 0, 2768, "Single Burger",  	5, "Heals you for 15 health.", 0.0, true, 1, 0.0, 0.0, 90.0, 1.0);
			//MenuStore_AddItem(playerid, 1, 2769, "Single Wrap",  	5, "Heals you for 15 health.", 0.0, true, 1, 0.0, 0.0, 90.0, 1.0);
			MenuStore_AddItem(playerid, 0, 2353, "Healthy Menu",  	75, "Spawns a menu where you can take 3 items from.", 		0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 1, 2215, "Small Menu",  	75, "Spawns a menu where you can take 4 items from.", 		0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 2, 2216, "Medium Menu",  	100, "Spawns a menu where you can take 5 items from.", 		0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 3, 2217, "Large Menu",  	150, "Spawns a menu where you can take 6 items from.", 		0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 4, 2768, "Empty Burger Carton",  15, "Useful for storing stuff.", 	0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 5, 2769, "Empty Wrapped Foil",  10, "Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 90.0, 1.0);
			MenuStore_AddItem(playerid, 6, -24997, "Can of Sprunk", 25, "A can of Sprunk that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);
			MenuStore_AddItem(playerid, 7, -24995, "Can of E-Cola", 25, "A can of E-Cola that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);

			MenuStore_Show(playerid, Clucking_Bell_Store, "Cluckin' Bell");
		}

		case E_BUY_TYPE_FOOD_PIZZASTACK: {
			//MenuStore_AddItem(playerid, 0, 19580, "Single Pizza",  	5, "Heals you for 15 health.", 0.0, 	true, 1, 0.0, 0.0, 90.0, 1.0);
			MenuStore_AddItem(playerid, 0, 2355, "Healthy Menu",  	75, "Spawns a menu where you can take 3 items from.", 0.0,    true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 1, 2218, "Small Menu",  	75, "Spawns a menu where you can take 4 items from.", 0.0,    true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 2, 2219, "Medium Menu",  	100, "Spawns a menu where you can take 5 items from.", 0.0,    true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 3, 2220, "Large Menu",  	150, "Spawns a menu where you can take 6 items from.", 0.0,  true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 4, 19571, "Empty Pizza Box",  15, "Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 0.0, 1.0);
			MenuStore_AddItem(playerid, 5, -24997, "Can of Sprunk", 25, "A can of Sprunk that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);
			MenuStore_AddItem(playerid, 6, -24995, "Can of E-Cola", 25, "A can of E-Cola that replenishes thirst", 				0.0, true, 1, 180.0, 0.0, 45.0, 0.75);

			MenuStore_Show(playerid, Pizza_Stack_Store, "Pizza Stack");
		}

		case E_BUY_TYPE_FOOD_BURGERSHOT: {
			//MenuStore_AddItem(playerid, 0, 2703, "Single Burger",  	5, "Heals you for 15 health.", 0.0, true, 1, 0.0, 0.0, 90.0, 1.0);
			MenuStore_AddItem(playerid, 0, 2354, "Healthy Menu",  	75, "Spawns a menu where you can take 3 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 1, 2213, "Small Menu",  	75, "Spawns a menu where you can take 4 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 2, 2214, "Medium Menu",  	100, "Spawns a menu where you can take 5 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 3, 2212, "Large Menu",  	150, "Spawns a menu where you can take 6 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 4, 19811, "Empty Burger Carton",  15, "Useful for storing stuff.", 0.0, true, 1, 0.0, 0.0, 90.0, 1.0);
			MenuStore_AddItem(playerid, 5, 2647, "Cup of Soda", 20, "A cup of fountain soda that replenishes thirst", 				0.0, true, 1, 0.0, 0.0, 50.0, 0.75);

			MenuStore_Show(playerid, Burger_Shot_Store, "Burger Shot");
		}
		case E_BUY_TYPE_FOOD_DONUTS: {
			MenuStore_AddItem(playerid, 0, 2221, "Small Menu",  	100, "Spawns a menu where you can take 4 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 1, 2222, "Medium Menu",  	150, "Spawns a menu where you can take 5 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 2, 2223, "Large Menu",  	200, "Spawns a menu where you can take 6 items from.", 0.0, true, 1, -210.0, 170.0, 0.0, 0.75);
			MenuStore_AddItem(playerid, 3, 19835, "Cup of Coffee", 	75,  "A cup of coffee that replenishes thirst", 	   0.0, true, 1,  0.0, 0.0, 50.0, 0.75);

			MenuStore_Show(playerid, Rusty_Donuts_Store, "Coffee Shop");
		}

		case E_BUY_TYPE_CLOTHING_CUSTOM: 
		{
			if (PlayerVar[playerid][E_PLAYER_TRYING_SKIN])
			{
				new skin = PlayerVar[playerid][E_PLAYER_TRYING_SKIN];

				inline DlgBuyCustomClothes(pid, dialogid, response, listitem, string:inputtext[])
				{
					#pragma unused pid, dialogid, listitem, inputtext
					PlayerVar[playerid][E_PLAYER_TRYING_SKIN] = 0;

					if ( response ) 
					{
						inline OnBuyCustomSkin() 
						{
							new rows, fields;
							cache_get_data(rows, fields, mysql);

							if (!rows)
							{
								SetPlayerSkin(playerid, Character[playerid][E_CHARACTER_SKINID]);
								return SendServerMessage(playerid, COLOR_ERROR, "Error", "DEDEDE", "Sorry, there was a problem buying this skin." );
							}

							new cost;
							cost = cache_get_field_int (0, "buyable_skin_cost");

							if ( GetPlayerCash ( playerid ) < cost ) 
							{
								SetPlayerSkin(playerid, Character[playerid][E_CHARACTER_SKINID]);
								return SendClientMessage(playerid, COLOR_RED, sprintf("You don't have $%s to purchase this outfit.", IntegerWithDelimiter(cost)));
							}

							TakePlayerCash(playerid, cost);
							SetPlayerSkinEx(playerid, skin, true);
							Property_AddMoneyToTill(playerid, cost);

							SendClientMessage(playerid, COLOR_INFO, sprintf("You've bought the outfit for $%s!", IntegerWithDelimiter(cost)));
							AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought Skin %d from a Clothes Store (%d) for $%s", skin, property_id, IntegerWithDelimiter(cost)));
						}

						new query [ 128 ] ;
						mysql_format(mysql, query, sizeof(query), "SELECT * FROM buyable_skins WHERE buyable_skin_skinid = %d AND buyable_skin_propertyid = %d", skin, property_id);
						mysql_tquery_inline(mysql, query, using inline OnBuyCustomSkin, "" );
					}
					else
					{
						SetPlayerSkin(playerid, Character[playerid][E_CHARACTER_SKINID]);
						cmd_buy(playerid);
					}
				}
				
				Dialog_ShowCallback(playerid, using inline DlgBuyCustomClothes, DIALOG_STYLE_MSGBOX, "Changing Room", sprintf("{FFFFFF}Press {8D8DFF}Buy{FFFFFF} to buy this outfit for %s.", PlayerVar[playerid][E_PLAYER_TRYING_SKIN_NAME]), "Buy", "Back");
				return true;
			}

			inline DlgCustomClothes(pid, dialogid, response, listitem, string:inputtext[])
			{
		 		if ( response ) 
				{
			        #pragma unused pid, dialogid, listitem, inputtext
					
					if (listitem == 0)
					{
						// Show normal game skins
						ShowPlayerClothesShop(playerid);
					}
					else if (listitem == 1)
					{
						// Show custom skins for this property
						ShowPlayerCustomClothesShop(playerid, property_enum_id);
					}
			 	}
		 	}

			Dialog_ShowCallback(playerid, using inline DlgCustomClothes, DIALOG_STYLE_LIST, "Select a Category", "Standard Clothes\nExclusive Clothes", "Select", "Back");
		}
	}

	return true ;
}
// Called under MenuStore_Close in menustore.inc
MenuStore_OnMenuClose (playerid) {

	PlayerVar [ playerid ] [ E_PLAYER_BIZ_MENU ] = INVALID_PROPERTY_ID ;

	return true; 
}

TryingSkin_Tick(playerid)
{
	if (PlayerVar[playerid][E_PLAYER_TRYING_SKIN])
	{
		if (GetPlayerDistanceFromPoint(playerid, PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][0], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][1], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][2]) > 3.0)
		{
			ShowPlayerSubtitle(playerid, "~r~You left the changing room without making a purchase.", .showtime = 3000);
			SetPlayerSkin(playerid, Character[playerid][E_CHARACTER_SKINID]);
			PlayerVar[playerid][E_PLAYER_TRYING_SKIN] = 0;
		}
	}
}

mBrowser:cstm_clothing_list(playerid, response, row, model, name[]) 
{
	if ( ! response ) 
	{
		return true ;
	}

	/*
	inline DlgTryCustomClothes(pid, dialogid, dresponse, listitem, string:inputtext[])
	{
		if ( dresponse ) 
		{
			#pragma unused pid, dialogid, listitem, inputtext
			// Nothing here
		}
	}
	*/

	PlayerVar[playerid][E_PLAYER_TRYING_SKIN] = model;
	format(PlayerVar[playerid][E_PLAYER_TRYING_SKIN_NAME], 32, name);
	
	GetPlayerPos(playerid, PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][0], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][1], PlayerVar[playerid][E_PLAYER_TRYING_SKIN_POS][2]);
	SetPlayerSkin(playerid, model);

	ShowPlayerSubtitle(playerid, "You are now trying on new clothes, type ~y~/buy~w~ again to continue.", .showtime = 5000);

	//Dialog_ShowCallback(playerid, using inline DlgTryCustomClothes, DIALOG_STYLE_MSGBOX, "Changing Room", "You are now trying on the new outfit.\n{FFFFFF}Once finished, type {8D8DFF}/buy{FFFFFF} again to continue.", "OK");
	return true ;
}



mBrowser:clothing_list(playerid, response, row, model, name[]) {

	if ( ! response ) {

		return true ;
	}

	else if ( response ) {
		if ( GetPlayerCash ( playerid ) < 100 ) {

			return SendClientMessage(playerid, COLOR_RED, "You need at least $100 to buy a skin!");
		}

		TakePlayerCash(playerid, 59 );
		SetPlayerSkinEx(playerid, model, true);
		Property_AddMoneyToTill(playerid, 100, .margin=true ) ; 
		SendClientMessage(playerid, COLOR_INFO, sprintf("You've bought the \"%s\" skin for $100!", name ) ) ;
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Bought Skin %d from a Clothes Store for $100", model));
	}

	return true ;
}


Property_AddMoneyToTill(playerid, amount, margin=false) {

	new prop_enum_id = PlayerVar [ playerid ] [ E_PLAYER_BIZ_MENU ] ;

	for ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == prop_enum_id ) {

			prop_enum_id = i ;
		}

		else continue ;
	}

	if ( prop_enum_id == -1 ) {

		return false ;
	}

	/*
	// 50% margin
	if ( margin ) {
		margin = amount * 5 ;
	}

	else {
		margin = amount ;
	}
*/

	Property [ prop_enum_id ] [ E_PROPERTY_COLLECT ] += amount ;

	new query [ 96 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_collect = %d WHERE property_id = %d", 

		Property [ prop_enum_id ] [ E_PROPERTY_COLLECT ], Property [ prop_enum_id ] [ E_PROPERTY_ID ]
	) ;

	mysql_tquery(mysql, query);

	return margin ;
}

Store:Restaurant_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {
 	if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Restaurant", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) 
	{
    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, BURGERSHOT_MENU_MED);
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_MED);
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, CLUCKINBELL_MENU_MED);
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_HEALTHY);
    	case 4: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_WINE_GLASS ) ; // 
    	case 5: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_SPRUNK_GLASS ) ; // 
		case 6: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_COFFEE ) ; // 
    }

	format(string, sizeof(string), "Bought %dx %s from a Restaurant for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

Store:Clucking_Bell_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {
 	if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Cluckin' Bell", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) 
	{
    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, CLUCKINBELL_MENU_HEALTHY);
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, CLUCKINBELL_MENU_LOW);
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, CLUCKINBELL_MENU_MED);
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, CLUCKINBELL_MENU_HIGH);
    	case 4: Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_BURGER_CARTON ) ;
    	case 5: Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_WRAPPED_FOIL ) ; 
    	case 6: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_SPRUNK_CAN ) ; // 
		case 7: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_ECOLA_CAN ) ; //     	
    }

	format(string, sizeof(string), "Bought %dx %s from a Cluckin Bell for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

Store:Pizza_Stack_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {
 	if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Pizza Stack", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) {

    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_HEALTHY);
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_LOW);
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_MED);
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, PIZZASTACK_MENU_HIGH);
    	case 4:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_PIZZA_BOX ) ;
    	case 5: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_SPRUNK_CAN ) ; // 
		case 6: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_ECOLA_CAN ) ; //  
    }

	format(string, sizeof(string), "Bought %dx %s from a Pizza Stack for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}
Store:Burger_Shot_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {
 	if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Burger Shot", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) {

    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, BURGERSHOT_MENU_HEALTHY);
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, BURGERSHOT_MENU_LOW);
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, BURGERSHOT_MENU_MED);
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, BURGERSHOT_MENU_HIGH);
    	case 4: Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_BURGER_CARTON ) ;
    	case 5: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_SODA_CUP ) ; // 
    }

	format(string, sizeof(string), "Bought %dx %s from a Burger Shot for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

Store:Rusty_Donuts_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {
 	if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Rusty's Donuts", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) {

    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, DONUTS_MENU_LOW);
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, DONUTS_MENU_MED);
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_FOOD, DONUTS_MENU_HIGH);
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_COFFEE ) ; // 
    }

	format(string, sizeof(string), "Bought %dx %s from a Coffee Shop for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}

Store:General_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {

    if(!response) {
        return true;
    }

    if ( itemid == 3) {
    	// Buying a mask without having proper levels... cancel it here to avoid charge.

		if ( Character [ playerid ] [ E_CHARACTER_HOURS ] < 8 ) {

			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You need at least 8 playing hours before you can use a /mask.");
		}
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
    
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "General Store", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) {

    	case 0:
		 {
    		SendServerMessage ( playerid, COLOR_PROPERTY, "General Store", "DEDEDE", "To use a gas can, type \"/gascan\" - note this item does not save if you quit." ) ;
    		PlayerVar [ playerid ] [ E_PLAYER_HAS_GASCAN ] = true ;// Gas can
    	}

		case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_SPRUNK_CAN ) ;
		case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_ITEM_DRINK_ECOLA_CAN ) ; 

    	case 3: { // mask

    		Character [ playerid ] [ E_CHARACTER_MASKID ] = CalculateMaskID(playerid)  ;
    		SendServerMessage ( playerid, COLOR_PROPERTY, "General Store", "DEDEDE", sprintf("Your new mask ID is %d. To put it on, use /mask.", Character [ playerid ] [ E_CHARACTER_MASKID ] ) ) ;

    		new query [ 256 ] ;

    		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_maskid = %d WHERE player_id = %d", 

    			Character [ playerid ] [ E_CHARACTER_MASKID ], 
    			Character [ playerid ] [ E_CHARACTER_ID ] ) ;

    		mysql_tquery(mysql, query);
    	}

		case 4:  GiveCustomWeapon(playerid, 5, 1); // baseball bat
    	case 5:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_ZIPLOC_BAG ) ;
    	case 6:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_PILL_BOTTLE ) ; 
    	case 7:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_TAKEAWAY_BAG ) ;
    	case 8:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_MILK_CARTON ) ;
    	case 9:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_PLASTIC_CUP ) ; 
    	case 10:  Drugs_IncreasePlayerContainer ( playerid, E_DRUG_PACKAGE_BRICK ) ; 
    }

	format(string, sizeof(string), "Bought %dx %s from a 24/7 for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}


Store:Liquor_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {

    if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
   	new string [ 256 ] ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s.", amount, itemname, IntegerWithDelimiter(price));
	SendServerMessage ( playerid, COLOR_PROPERTY, "Liquor Store", "DEDEDE", string ) ;

	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ; 

    switch ( itemid ) {

    	// crates
    	case 0: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_WHITE_BOX_CLOSED ) ;
    	case 1: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_WHITE_BOX_OPEN ) ;
    	case 2: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_GREEN_BOX_CLOSED ) ;
    	case 3: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_GREEN_BOX_OPEN ) ;
    	case 4: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_RED_BOX_CLOSED ) ;
    	case 5: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_RED_BOX_OPEN ) ;
    	case 6: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_BLUE_BOX_CLOSED ) ;
    	case 7: OnPlayerBuyFood(playerid, E_INTERACT_TYPE_DRINK, E_PROP_BLUE_BOX_OPEN ) ;
    }

	format(string, sizeof(string), "Bought %dx %s from a Liquor Store for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

    return true;
}


Store:Electronic_Store(playerid, response, itemid, modelid, price, amount, itemname[]) {

    if(!response) {
        return true;
    }

    if(GetPlayerCash(playerid) < price) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have enough money!" ) ;
    }
   
	TakePlayerCash ( playerid, price) ; 
	Property_AddMoneyToTill(playerid, price, .margin=true ) ;

	new string [ 256 ] ; 

	format(string, sizeof(string), "Bought %dx %s from a Electronics Store for $%s", amount, itemname, IntegerWithDelimiter(price));
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, string);

	if (itemid == 6)
	{
		// New pager by Sporky
		Character[playerid][E_CHARACTER_PAGER_FREQ] = 9000 + random(1000);
		new Float:frequency = (float(Character[playerid][E_CHARACTER_PAGER_FREQ])+0.05)/10.0;
		format(string, sizeof(string), "You've bought %dx of %s for $%s. Frequency: %.1f MHz.", amount, itemname, IntegerWithDelimiter(price), frequency);

		SendServerMessage ( playerid, COLOR_PROPERTY, "Electronic Store", "DEDEDE", string ) ;
		SendServerMessage ( playerid, COLOR_PROPERTY, "Electronic Store", "DEDEDE", "To send a message use /pg. Use /pagerfreq to change frequency." ) ;
		SendServerMessage ( playerid, COLOR_PROPERTY, "Electronic Store", "DEDEDE", "To hide pager messages use /nopager." ) ;

		string [ 0 ] = EOS ;

		mysql_format(mysql, string, sizeof ( string ), "UPDATE `characters` SET `player_pager_freq` = %d WHERE `player_id` = %d", Character [ playerid ] [ E_CHARACTER_PAGER_FREQ ], Character [ playerid ] [ E_CHARACTER_ID ]) ;
		mysql_tquery(mysql, string);
		return true;
	}

	if (itemid == 7)
	{
		// New camera by Sporky
		GiveCustomWeapon(playerid, 63, 50);
		return true;
	}

	new buffer = 160000 + random (9999) ;

	Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] = buffer ;
	Character [ playerid ] [ E_CHARACTER_PHONE_CREDIT ] = 5 + random ( 25 ) ;

	Character [ playerid ] [ E_CHARACTER_PHONE_COLOUR ] = itemid ;

    format(string, sizeof(string), "You've bought %dx of %s for $%s. Your new number is %d.", 
    	amount, itemname, IntegerWithDelimiter(price), buffer);
	SendServerMessage ( playerid, COLOR_PROPERTY, "Electronic Store", "DEDEDE", string ) ;
	SendServerMessage ( playerid, COLOR_PROPERTY, "Electronic Store", "DEDEDE", "To use the phone use /ph and /pc. Shortcuts: /call, /sms, /inbox, /pickup, /h(angup)" ) ;

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, sizeof ( string ), "UPDATE characters SET player_phnumber = %d, player_phcolour = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ playerid ] [ E_CHARACTER_PHONE_COLOUR ], Character [ playerid ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, string);

    return true;
}
