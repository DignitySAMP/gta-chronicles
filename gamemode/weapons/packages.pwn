
#if !defined BLACK_MARKET_POS_X
	#define BLACK_MARKET_POS_X (2285.4258)
#endif

#if !defined BLACK_MARKET_POS_Y
	#define BLACK_MARKET_POS_Y (-2493.1038)
#endif

#if !defined BLACK_MARKET_POS_Z
	#define BLACK_MARKET_POS_Z ( 10.8762 )
#endif


GunPackage_LoadEntities() {

	CreateDynamicPickup(2061, 1, BLACK_MARKET_POS_X, BLACK_MARKET_POS_Y, BLACK_MARKET_POS_Z);
	CreateDynamicMapIcon(BLACK_MARKET_POS_X, BLACK_MARKET_POS_Y, BLACK_MARKET_POS_Z, 37, 0xFFFFFFFF);
	CreateDynamic3DTextLabel("[Black Market]\n{DEDEDE}Available Commands: /finalizeg(un)p(ackage)", COLOR_GD, BLACK_MARKET_POS_X, BLACK_MARKET_POS_Y, BLACK_MARKET_POS_Z, 15.0);
}


CMD:gunpackages(playerid, params[]) {

	SendClientMessage(playerid, COLOR_GD, "[Weapon Packages]" ) ;

	new gun_name [ 32 ] ;
	for ( new i, j = 10 ; i < j ; i ++ ) {

		if ( ! Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] ) {
			continue ;
		}

		Weapon_GetGunName ( Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ], gun_name, sizeof ( gun_name )) ; 

		SendClientMessage(playerid, 0xDEDEDEFF, sprintf("[Slot %d] [(%d) %s] [%d ammo]", 
			i, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ], gun_name, 
			Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ i ] 
		)) ;
	}

	SendClientMessage(playerid, COLOR_YELLOW, "To pass a package use /passg(un)p(ackage). To finalize, use /finalizeg(un)p(ackage)." ) ;

	return true ;
}


CMD:passgp(playerid, params[]) {

	return cmd_passgunpackage(playerid, params);
}
CMD:passgunpackage(playerid, params[]) {

	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	new target, slot ;

	if ( sscanf ( params, "k<player>i", target, slot ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "/passg(un)p(ackage) [target] [slot]");
	}
	if ( ! IsPlayerConnected ( target ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "Target isn't connected.");
	}

	if ( slot < 0 || slot > 9 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "Slot can't be less than 0 or more than 9.");
	}

	if ( ! Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "This slot is empty - you have no gun stored!");
	}

	new index = -1 ;

	for ( new i, j = 10 ; i < j ; i ++ ) {

		if ( ! Character [ target ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] ) {

			index = i ;
			break;
		}

		else continue ;
	}

	if ( index == -1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Gun Factory", "DEDEDE", "Your target has no empty gun slots left." ) ;
	}

	new idx = Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] ;

	Character [ target ] [ E_CHARACTER_GUN_PACKAGE ] [ index ] 		= Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] ; 
	Character [ target ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ index ] = Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ] ;

	Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] = 0 ;
	Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ] = 0 ;

	new query [ 256 ] ;

	// Player related saving
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_gun_package_%d = %d, player_gun_package_%d_ammo = %d WHERE player_id = %d",
		slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ], slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ], Character [ playerid ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, query);

	query [ 0 ] = EOS ;

	// Target related saving
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_gun_package_%d = %d, player_gun_package_%d_ammo = %d WHERE player_id = %d",
		index, Character [ target ] [ E_CHARACTER_GUN_PACKAGE ] [ index ], 
		index, Character [ target ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ index ], 
		Character [ target ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, query);

	query [ 0 ] = EOS ;

	new gun_name [ 32 ] ;
	Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name ) );

	format ( query, sizeof ( query ), "* %s passes their %s to %s.", ReturnPlayerNameData ( playerid ), gun_name,  ReturnPlayerNameData ( target ) ) ;
	ProxDetector ( playerid,15.0, COLOR_ACTION, query ) ;

	return true ;
}

CMD:finalizegp(playerid, params[]) {

	return cmd_finalizegunpackage(playerid, params);
}

CMD:finalizegunpackage(playerid, params[]) {

	if ( IsPlayerInRangeOfPoint(playerid, 5.0, BLACK_MARKET_POS_X, BLACK_MARKET_POS_Y, BLACK_MARKET_POS_Z)) {

		new slot ;

		if ( sscanf ( params, "i", slot ) ){

			SendClientMessage(playerid, COLOR_ERROR, "Warning: this will spawn the gun in your hand. Make sure your gun slot is empty." ) ;
			return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "/finalizeg(un)p(ackage) [slot]");
		}

		if ( slot < 0 || slot > 9 ) {
			return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "Slot can't be less than 0 or more than 9.");
		}

		if ( ! CanPlayerDoGunCMD(playerid) ) {

			return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
		}

		if ( ! CanPlayerUseGuns(playerid, 8) ) {
			return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command until you have 8 playing hours." );
		}

		if ( ! Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] ) {
			return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "This slot is empty - you have no gun stored!");
		}

		new idx = Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] ;
		new ammo = Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ] ;

		Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] = 0 ;
		Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ] = 0 ;

		new query [ 256 ] ;

		// Player related saving
		mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_gun_package_%d = %d, player_gun_package_%d_ammo = %d WHERE player_id = %d",
			slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ], slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ], Character [ playerid ] [ E_CHARACTER_ID ]
		) ;

		mysql_tquery(mysql, query);


		// Setting ammo here to 0 should not allow players to stack old ammo with current one
		GiveCustomWeapon(playerid, idx, ammo ) ;
		SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(idx), ammo ) ;

		new gun_name [ 64 ] ;
		Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name )) ; 

		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've finalised a %s. It has been spawned in your hand.", gun_name )) ;
	}

	else return SendServerMessage ( playerid, COLOR_ERROR, "Gun Dealer", "DEDEDE", "You're not at the black market." ) ;

	return true ;
}