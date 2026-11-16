#include "faction/kiosk/data.pwn"
#include "faction/kiosk/func.pwn"
#include "faction/kiosk/utils.pwn"


CMD:kioskaddgun(playerid, params[]) {

	new id, slot, gun, ammo ;
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	if ( sscanf ( params, "iiii", id, slot, gun, ammo ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/kioskaddgun [kiosk-id] [slot] [gunid] [ammo]" ) ;
		SendClientMessage(playerid, COLOR_YELLOW, "For gun IDs, use /customgunlist." ) ;
		return true ;
	}

	if ( id < 0 || id > MAX_KIOSKS ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( Kiosk [ id ] [ E_KIOSK_ID ] == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( slot < 0 || slot >= 5 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Slot can't be less than 0 or more than 4." ) ;
	}

	Kiosk [ id ] [ E_KIOSK_WEAPON ] [ slot ] = gun ;
	Kiosk [ id ] [ E_KIOSK_WEAPONAMMO ] [ slot ] = ammo ;

	new row [ 16 ] ;

	strcat(row, sprintf("kiosk_weapon%d", slot + 1) ) ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE kiosks SET %s = %d, %sammo = %d WHERE kiosk_id = %d", row, gun, row, ammo, Kiosk [ id ] [ E_KIOSK_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	SendClientMessage(playerid, COLOR_INFO, sprintf("Changed kiosk %d (sql %d)'s weapon slot %d to (%d) %s with %d ammo.",
		id, Kiosk [ id ] [ E_KIOSK_ID ], slot, Kiosk [ id ] [ E_KIOSK_WEAPON ] [ slot ],  Weapon_GetName ( playerid,Kiosk [ id ] [ E_KIOSK_WEAPON ] [ slot ] ), Kiosk [ id ] [ E_KIOSK_WEAPONAMMO ] [ slot ] )) ;

	WriteLog ( playerid, "kiosks", sprintf("%s adds a %d with %d ammo to kiosk ID %d's slot %d", 
		ReturnPlayerNameData ( playerid ), gun, ammo, id, slot) );


	return true ;
}


CMD:kioskremovegun(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new id, slot;

	if ( sscanf ( params, "ii", id, slot ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/kioskremovegun [kiosk-id] [slot]" ) ;
	}

	if ( id < 0 || id > MAX_KIOSKS ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( Kiosk [ id ] [ E_KIOSK_ID ] == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( slot < 0 || slot >= 5 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Slot can't be less than 0 or more than 4." ) ;
	}

	Kiosk [ id ] [ E_KIOSK_WEAPON ] [ slot ] = 0 ;
	Kiosk [ id ] [ E_KIOSK_WEAPONAMMO ] [ slot ] = 0 ;

	new row [ 16 ] ;

	strcat(row, sprintf("kiosk_weapon%d", slot + 1) ) ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE kiosks SET %s = 0, %sammo = 0 WHERE kiosk_id = %d", row, row, Kiosk [ id ] [ E_KIOSK_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	SendClientMessage(playerid, COLOR_INFO, sprintf("Removed kiosk %d (sql %d)'s weapon slot %d.",
		id, Kiosk [ id ] [ E_KIOSK_ID ], slot )) ;

	WriteLog ( playerid, "kiosks", sprintf("%s emptied kiosk ID %d's slot %d", 
		ReturnPlayerNameData ( playerid ), id, slot ) );

	return true ;
}

CMD:kioskcreate(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new name [ MAX_KIOSK_NAME ] ;


	if ( sscanf ( params, "s[256]", name ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/kiosk [name]" ) ;
	}

	if ( strlen ( name ) > sizeof ( name ) || strlen ( name ) <= 0) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Name can't be longer than %d or shorter than 0", sizeof ( name )) ) ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Kiosk_Create(name, x, y, z, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld(playerid) ) ;


	WriteLog ( playerid, "kiosks", sprintf("%s created a kiosk at their location. %s", ReturnPlayerNameData ( playerid ), name ) );

	return true ;
}

CMD:kioskassign(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new kiosk_id, factionid, squad;

	if ( sscanf ( params, "iii", kiosk_id, factionid, squad )) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/kioskassign [kioskid] [factionid] [squad]" ) ;
	}

	if ( kiosk_id < 0 || kiosk_id > MAX_KIOSKS ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( Kiosk [ kiosk_id ] [ E_KIOSK_ID ] == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( factionid < 0 || factionid > MAX_FACTIONS ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Faction ID you entered isn't valid." ) ;
	}


	if ( Faction [ factionid ] [ E_FACTION_ID ] == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}


	Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ] = Faction [ factionid ] [ E_FACTION_ID ] ;
	Kiosk [ kiosk_id ] [ E_KIOSK_SQUAD ] = squad ; 

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE kiosks SET kiosk_faction = %d, kiosk_squad = %d WHERE kiosk_id = %d", 

		Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ], Kiosk [ kiosk_id ] [ E_KIOSK_SQUAD ], Kiosk [ kiosk_id ] [ E_KIOSK_ID ] ) ;

	mysql_tquery ( mysql, query ) ;

	SendClientMessage(playerid, COLOR_BLUE, sprintf("You've set kiosk (%d: %s)'s faction to (%d) %s with squad %d.",
		kiosk_id, Kiosk [ kiosk_id ] [ E_KIOSK_NAME ],
		factionid, Faction_GetAbbreviation ( Faction [ factionid ] [ E_FACTION_NAME ] ), Kiosk [ kiosk_id ] [ E_KIOSK_SQUAD ] ));

	WriteLog ( playerid, "kiosks", sprintf("%s assigns kiosk ID %d to faction %d with squad %d", 
		ReturnPlayerNameData ( playerid ), kiosk_id, factionid, squad ) );

	return true ;

}


CMD:kioskname(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new kiosk_id, kiosk_name[256];

	if ( sscanf ( params, "is[256]", kiosk_id, kiosk_name )) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/kioskname [kioskid] [name]" ) ;
	}

	if ( kiosk_id < 0 || kiosk_id > MAX_KIOSKS ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( Kiosk [ kiosk_id ] [ E_KIOSK_ID ] == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Kiosk ID you entered isn't valid." ) ;
	}

	if ( strlen ( kiosk_name ) < 0 || strlen(kiosk_name ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The name you entered is too long or too short." ) ;
	}

	Kiosk [ kiosk_id ] [ E_KIOSK_NAME ][0] = EOS ;

	strcat(Kiosk [ kiosk_id ] [ E_KIOSK_NAME ], kiosk_name ) ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE kiosks SET kiosk_name = '%e' WHERE kiosk_id = %d", 

		Kiosk [ kiosk_id ] [ E_KIOSK_NAME ], Kiosk [ kiosk_id ] [ E_KIOSK_ID ] ) ;

	mysql_tquery ( mysql, query ) ;

	SendClientMessage(playerid, COLOR_BLUE, sprintf("You've set kiosk ID %d's name to %s.",
		kiosk_id, Kiosk [ kiosk_id ] [ E_KIOSK_NAME ] ));

	WriteLog ( playerid, "kiosks", sprintf("%s changes name of kiosk %d to \"%s\"",  kiosk_id, kiosk_name ) );


	return true ;

}

/*
CMD:duty(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}

	new kiosk_id = Kiosk_GetClosestEntity ( playerid )  ;

	if ( kiosk_id == INVALID_KIOSK_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a kiosk!" ) ;
	}

	new kiosk_faction_id = Kiosk [ kiosk_id ] [ E_KIOSK_FACTION ] ;

	if ( factionid != kiosk_faction_id ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the right faction!" ) ;
	}
	new string [ 86 ] ;

	if(!strcmp(params, "lspd", true)) {
		if ( PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] = false ;
			//SetPlayerColor(playerid, 0xDEDEDEFF);

			if ( GetCharacterArmour ( playerid ) != 0 ) {

				SetCharacterArmour ( playerid, 0 );
			}

			Weapon_ResetPlayerWeapons(playerid);

			format ( string, sizeof ( string ), "has gone off duty as LSPD" ) ;
		}

		else if ( ! PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] = true ;
			PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ] = false ;
			//SetPlayerColor(playerid, COLOR_POLICE );

			format ( string, sizeof ( string ), "has gone on duty as LSPD" ) ;
		}

	}
	else if(!strcmp(params, "ems", true)) {
		if ( PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ] = false ;
			//SetPlayerColor(playerid, 0xDEDEDEFF);

			if ( GetCharacterArmour ( playerid ) != 0 ) {

				SetCharacterArmour ( playerid, 0 );
			}

			Weapon_ResetPlayerWeapons(playerid);

			format ( string, sizeof ( string ), "has gone off duty as EMS" ) ;
		}

		else if ( ! PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ] = true ;
			PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] = false ;
			//SetPlayerColor(playerid, COLOR_POLICE );

			format ( string, sizeof ( string ), "has gone on duty as EMS" ) ;
		}	
	}
	else if(!strcmp(params, "off", true)) {
		if ( PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] = false ;
			//SetPlayerColor(playerid, 0xDEDEDEFF);

			if ( GetCharacterArmour ( playerid ) != 0 ) {

				SetCharacterArmour ( playerid, 0 );
			}

			Weapon_ResetPlayerWeapons(playerid);

			format ( string, sizeof ( string ), "has gone off duty as EMS" ) ;
		}
		if ( PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ]  ) {
			PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_EMS_DUTY ] = false ;
			//SetPlayerColor(playerid, 0xDEDEDEFF);

			if ( GetCharacterArmour ( playerid ) != 0 ) {

				SetCharacterArmour ( playerid, 0 );
			}

			Weapon_ResetPlayerWeapons(playerid);

			format ( string, sizeof ( string ), "has gone off duty as LSPD" ) ;
		}
	
	}

	else return  SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/duty [lspd/ems/off]" ) ;
	
	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid ), string
	), faction_enum_id, false ) ;

	return true ;
}
*/