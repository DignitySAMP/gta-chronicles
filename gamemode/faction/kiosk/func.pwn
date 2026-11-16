CMD:kt(playerid, params[]) {
	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

    if ( ! PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty and can't do this." ) ;
    }

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new kiosk_id = Kiosk_GetClosestEntity ( playerid )  ;

	if ( kiosk_id == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a kiosk!" ) ;
	}

	new faction_id = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID ( faction_id ) ;
	new kiosk_faction_id = Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ] ;

	if ( Kiosk [ kiosk_id ] [ E_KIOSK_SQUAD ] != 0 ) {
		if ( Kiosk [ kiosk_id ] [ E_KIOSK_SQUAD ] != Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ] ) {

			if ( Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ] != 3 ) {

				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Your squad does not have access to this kiosk." ) ;
			}
		}
	}

	if ( faction_id != kiosk_faction_id ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the right faction!" ) ;
	}

	new gun_cost ;

	new string [ 512 + 1 ] ;
	new gun_name [ 64 ] ;

	inline KioskList(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, inputtext

		new weapon = Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ listitem ] ;
		new ammo = Kiosk [ kiosk_id ] [ E_KIOSK_WEAPONAMMO ] [ listitem ] ;

		gun_cost = Kiosk_GetGunPrice( weapon ) ;

		if ( ! response ) {

			return true ;
		}

		if ( Faction_GetBankMoney ( faction_enum_id ) < gun_cost ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Your faction needs at least $%s - it currently has $%s.",
				IntegerWithDelimiter( gun_cost ), IntegerWithDelimiter(Faction_GetBankMoney ( faction_enum_id ) ))) ;
		}

		Faction_TakeBankMoney(faction_enum_id, ( Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ listitem ] * 10 ));

		//GivePlayerWeapon(playerid, weapon, ammo ) ;
		GiveCustomWeapon(playerid, weapon, ammo ) ;
		Weapon_GetGunName ( Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ listitem ], gun_name, sizeof ( gun_name ) ) ;

		Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has taken a %s with %d ammo from the kiosk. }",

			Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid ), gun_name, ammo
		), faction_enum_id, false ) ;

		return true ;
	}

	string [ 0 ] = EOS ;

	strcat(string, "Slot\t Name\t Ammo \t Cost");

	new count;

	for_loop ( new i; i < KIOSK_MAX_GUNS; i ++ ) {

		if ( Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ i ] == 0 ) {

			continue ;
		}

		gun_cost = Kiosk_GetGunPrice(  Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ i ] ) ;
		Weapon_GetGunName ( Kiosk [ kiosk_id ] [ E_KIOSK_WEAPON ] [ i ], gun_name, sizeof ( gun_name ) ) ;

		strcat(string, sprintf("\n%d\t %s\t %d \t $%s", i, gun_name, Kiosk [ kiosk_id ] [ E_KIOSK_WEAPONAMMO ] [ i ], IntegerWithDelimiter( gun_cost )) );

		count ++ ;
	}

	if ( count ) {

		Dialog_ShowCallback ( playerid, using inline KioskList, DIALOG_STYLE_TABLIST_HEADERS, "Kiosk", string, "Select", "Cancel" ) ;

	}

	else SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This kiosk doesn't have any guns in it!" ) ;

	return true ;
}

CMD:kiosktake(playerid, params[]) {

	return cmd_kt(playerid, params);
}

CMD:kr(playerid, params[]) {

	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new kiosk_id = Kiosk_GetClosestEntity ( playerid )  ;

	if ( kiosk_id == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a kiosk!" ) ;
	}

	new faction_id = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID ( faction_id ) ;
	new kiosk_faction_id = Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ] ;

	if ( faction_id != kiosk_faction_id ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the right faction!" ) ;
	}

	new gunid = GetPlayerCustomWeapon(playerid) ;

	if ( gunid == -1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're trying to store an invalid (-1) weapon. Equip the weapon you wish to store!" ) ;
	}

	if ( gunid > 0 ) {


		new gun_cost = Kiosk_GetGunPrice(gunid) ;
		new ammo = SOLS_GetPlayerAmmo ( playerid ) ;
		new gun_name [ 64 ] ;


		Weapon_GetGunName ( gunid, gun_name, sizeof ( gun_name ) ) ;

		if ( SOLS_GetPlayerAmmo ( playerid ) > 50 ) {
			Faction_AddBankMoney(faction_enum_id, gun_cost );
		}

		else Faction_AddBankMoney(faction_enum_id, gun_cost / 2 );

		RemovePlayerCustomWeapon(playerid, gunid ) ;
		// AC_RemovePlayerWeapon ( playerid, AC_GetPlayerWeapon ( playerid ) ) ;

		Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has returned a %s with %d ammo to the kiosk. }",

			Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid ), gun_name, ammo
		), faction_enum_id, false ) ;
	}

	else SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a weapon to return!" ) ;

	return true ;
}

CMD:kioskreturn(playerid, params[]) {

	return cmd_kr(playerid, params);
}

CMD:kev(playerid, params[]) {

	return cmd_kevlar(playerid, params);
}

CMD:kevlar(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new kiosk_id = Kiosk_GetClosestEntity ( playerid )  ;

	if ( kiosk_id == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a kiosk!" ) ;
	}

	new faction_id = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID ( faction_id ) ;
	new kiosk_faction_id = Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ] ;

	if ( faction_id != kiosk_faction_id ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the right faction!" ) ;
	}

	SetCharacterHealth(playerid, 100);
	SetCharacterArmour (playerid, 100);

	Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has taken kevlar from the kiosk. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
	), faction_enum_id, false ) ;

	return true ;
}

Kiosk_GetGunPrice(weapon) {
	new gun_cost ;

	switch ( weapon ) {
		case 1 .. 8: 	gun_cost = 25 ;
		case 9:	 		gun_cost = 50 ;
		case 10 .. 15: 	gun_cost = 20 ;
		case 16 .. 18: 	gun_cost = 125 ;
		case 22 .. 23: 	gun_cost = 150 ;
		case 24: 		gun_cost = 250 ;
		case 25: 		gun_cost = 300 ;
		case 26: 		gun_cost = 325 ;
		case 27: 		gun_cost = 350 ;
		case 28: 		gun_cost = 250 ;
		case 29:		gun_cost = 275 ;
		case 30: 		gun_cost = 500 ;
		case 31: 		gun_cost = 750 ;
		case 32: 		gun_cost = 225 ;
		case 33: 		gun_cost = 800 ;
		case 34: 		gun_cost = 1000 ;
		default: {
			gun_cost = 25 ;
		}
	}

	return gun_cost ;
}