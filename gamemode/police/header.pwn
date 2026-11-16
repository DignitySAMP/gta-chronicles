#include "police/cmds/header.pwn"
#include "police/data/header.pwn"
#include "police/stun/header.pwn"
//#include "police/object/header.pwn"
#include "police/arrest.pwn"
//#include "police/impound.pwn"
#include "police/911.pwn"
#include "police/gunrack.pwn"
#include "police/cad.pwn"
#include "police/mugshot.pwn"
#include "police/crimes.pwn"
#include "police/spikes.pwn"
#include "police/sheriff_els.pwn"

/*
CMD:backup(playerid, params[]) {


	PlayerVar [ playerid ] [ E_PLAYER_BACKUP_TIME ] = 900 ;

	SendServerMessage ( playerid, COLOR_YELLOW, "Backup Info", "A3A3A3", "To see officers with distress calls, use /backuplist.");
	SendServerMessage ( playerid, COLOR_YELLOW, "Backup Info", "A3A3A3", "To see officers with distress calls, use /backuplist.");


	new string [ 256 ] ;

	format ( string, sizeof ( string ), "{[ [%s/HQ] [ID %d] %s %s is requesting for backup. Use /backupcall %d to trace them. ]}",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, Character [ playerid ] [ E_CHARACTER_FACTIONRANK ], SOLS_PlayerName ( playerid ), playerid
	);

	Faction_SendMessage(factionid, string, faction_enum_id, true, true);


	return true ;
}

CMD:backupcall(playerid, params[]) {

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {


	}

	return true ;
}

Police_PlayerBackupTick(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_BACKUP_TIME ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_BACKUP_TIME ] -- ;

		if ( PlayerVar [ playerid ] [ E_PLAYER_BACKUP_TIME ] == 600 ) {

		}
	}

	return true ;
}
*/

CMD:driverwarn(playerid, params[]) {
	
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/licenses [targetid]");
	}

	if ( ! IsPlayerConnected(target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}

 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

    new query [ 256 ] ;

    ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s has given %s a warning mark in their license.", SOLS_PlayerName(playerid), SOLS_PlayerName(target)));

    Character [ target ] [ E_CHARACTER_DRIVER_WARNINGS ] ++ ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_driver_warnings = %d WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_DRIVER_WARNINGS ],  Character [ target ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery(mysql, query);

    if (  Character [ target ] [ E_CHARACTER_DRIVER_WARNINGS ] >= 3 ) {

    	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_driver_warnings = 0, player_driverslicense = 0 WHERE player_id = %d",
    	 Character [ target ] [ E_CHARACTER_ID ] ) ;

    	mysql_tquery(mysql, query);

    	Character [ target ] [ E_CHARACTER_DRIVER_WARNINGS ]  = 0 ;
    	Character [ target ] [ E_CHARACTER_DRIVERSLICENSE]  = 0 ;

    	SendClientMessage(target, COLOR_INFO, "Your drivers license has recieved it's third warning. It has been confiscated!" ) ;
    	SendClientMessage(playerid, COLOR_YELLOW, "Your target's drivers license has recieved it's third warning! The license has been REMOVED!" ) ;
    }

	return true ;
}

/*

CMD:rights(playerid, params[]) {

	return cmd_mir(playerid, params);
}

CMD:mir(playerid, params[]) {

	if ( ! IsPlayerInPoliceFaction(playerid) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}	

	new string [ 256 ]  ;

	format ( string, sizeof ( string ), "By my authority as a police officer and protector of the peace you are hereby placed under arrest." ) ; 
    ProxDetectorNameTag(playerid, 35.0, -1, string, " says:", 0, true, false ) ;

	format ( string, sizeof ( string ), "You have the right to remain silent. Anything you say can and will be used in a court of law." ) ; 
    ProxDetectorNameTag(playerid, 35.0, -1, string, " says:", 0, true, false ) ;

	format ( string, sizeof ( string ), "You have the right to an attorney, if you cannot afford one then one will be appointed to you." ) ; 
    ProxDetectorNameTag(playerid, 35.0, -1, string, " says:", 0, true, false ) ;

	return true ;
}
*/


CMD:otakelicense(playerid, params[]) 
{
	
	/*
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerGovAdmin(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as as a police or licensing officer." ) ;
	}

	if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 )
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You must be Tier 2 or higher to revoke a license.");
	}
	*/

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_SENIOR)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You don't have access to this command.");
	}

	new targetid, choice[8] ;
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	if ( sscanf ( params, "ds[8]", targetid, choice ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/otakelicense [character] [driver/gun]");
	}

    if(!strcmp(choice, "gun", true)) {
    	

		if ( faction_enum_id != INVALID_FACTION_ID ) Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has offline revoked the firearms's license of Character ID %d. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, SOLS_PlayerName ( playerid ), targetid
		), faction_enum_id, false, false, 0, true ) ;

		OfflineRemoveLicenses(targetid, 2);
  
    } else if (!strcmp(choice, "driver", true)) {

		if ( faction_enum_id != INVALID_FACTION_ID ) Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has offline revoked the driver's license of Character ID %d. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, SOLS_PlayerName ( playerid ), targetid
		), faction_enum_id, false, false, 0, true ) ;

		OfflineRemoveLicenses(targetid, 1);

    } else {
    	return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Unknown choice. Put in either 'gun' or 'driver'.");
    }

	return true ;
}

// ^^ needs rewritten with an SQL query to check the char exists and use their name

CMD:takelicense(playerid, params[]) {
	
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerGovAdmin(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as as a police or licensing officer." ) ;
	}

	if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 )
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You must be Tier 2 or higher to revoke a license.");
	}

	new targetid, choice[8] ;
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	if ( sscanf ( params, "k<player>s[8]", targetid, choice ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/takelicense [targetid] [driver/gun]");
	}

	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}

 	if (!IsPlayerNearPlayer(playerid, targetid, 3.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

    if(!strcmp(choice, "gun", true)) {
    	
    	if ( ! HasGunLicense(targetid) ) 
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Your target does not have a firearms license, you can't take it away!" ) ;

		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has revoked the firearms's license of (%d) %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, SOLS_PlayerName ( playerid ), targetid, SOLS_PlayerName ( targetid )
		), faction_enum_id, false, false, 0, true ) ;

		RemoveGunLicense(targetid);

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s revokes the firearms's license of %s.", SOLS_PlayerName(playerid),  SOLS_PlayerName(targetid)) ) ;

		// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid) and targetid
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Revoked all weapon licenses of %s (%d)", SOLS_PlayerName(targetid), targetid));
		AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Had their weapon licenses taken by %s (%d)", SOLS_PlayerName(playerid), playerid));

  
    } else if (!strcmp(choice, "driver", true)) {

    	if ( ! HasDriverLicense(targetid) ) 
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Your target does not have a driver's license, you can't take it away!" ) ;

		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has revoked the driver's license of (%d) %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, SOLS_PlayerName ( playerid ), targetid, SOLS_PlayerName ( targetid )
		), faction_enum_id, false, false, 0, true ) ;

		RemoveDriverLicense(targetid);

		ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "* %s revokes the driver's license of %s.", SOLS_PlayerName(playerid),  SOLS_PlayerName(targetid)) ) ;

		// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid) and targetid
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Revoked the driver's license of %s (%d)", SOLS_PlayerName(targetid), targetid));
		AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Had their driver's license taken by %s (%d)", SOLS_PlayerName(playerid), playerid));

    } else {
    	return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Unknown choice. Put in either 'gun' or 'driver'.");
    }

	return true ;
}

CMD:confiscate(playerid, params[]) {

	new targetid, Float:amount;

	if ( sscanf ( params, "k<player>", targetid ) ) {
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "/confiscate [targetid]");
	}
    
	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		if ( ! IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid)) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a police faction.");
		}	

	 	if (!IsPlayerNearPlayer(playerid, targetid, 3.0)) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
	    }
	}

	for_loop ( new i, j = MAX_PLAYER_DRUGS; i < j ; i ++ ) 
	{
		if ( PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_TYPE ] != E_DRUG_TYPE_NONE && PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_AMOUNT ] > 0 )
		{
			amount += PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_AMOUNT ];
		}

		PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_SQLID ] 		= -1 ;
		PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_TYPE ] 		= E_DRUG_TYPE_NONE ;
		PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_PARAM ] 		= 0 ;
		PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_CONTAINER ] 	= 0 ;
		PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_AMOUNT ]		= 0.0 ;
	}

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR && amount > 0.0) 
	{
	    ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s has confiscated %.02fg of drugs from %s.", SOLS_PlayerName(playerid), amount, SOLS_PlayerName(targetid)));
	}

	Character [ targetid ] [ E_CHARACTER_LOCKPICK ] = 0;

	new query [ 128 ] ;
	for ( new i, j = 10 ; i < j ; i ++ ) {

		Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] = 0 ;
		Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ i ] = 0 ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_gun_package_%d = 0, player_gun_package_%d_ammo = 0 WHERE player_id = %d",
			i, i, Character [ targetid ] [ E_CHARACTER_ID ]
		);

		mysql_tquery(mysql, query);
	}


	PlayerDrugs_Save(targetid);

	/*
	query[0]=EOS;

	format ( query, sizeof ( query ), "[!] CONFISCATE: (%d) %s has confiscated (%d) %s's drugs / weapon packages.", 
		playerid, SOLS_PlayerName ( playerid ), targetid, SOLS_PlayerName ( targetid )) ;

	SendAdminMessage(query) ;
	*/

	//WriteLog ( playerid, "admin/guns", query);
	//WriteLog ( playerid, "admin/all", query);

	// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Confiscated %.02fg of drugs from %s (%d)", amount, SOLS_PlayerName(targetid), targetid));
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Had %.02fg of drugs confiscated by %s (%d)", amount, SOLS_PlayerName(playerid), playerid));

	return true ;
}

CMD:disarm(playerid, params[]) {

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "/disarm [targetid]");
	}
    
	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}

	if ( IsPlayerInAnyVehicle(targetid)) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Your target has to leave the vehicle they are in before you can disarm them." ) ;
    }

	
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		if ( ! IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a police faction.");
		}	

	 	if (!IsPlayerNearPlayer(playerid, targetid, 3.0)) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
	    }
	}

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
	    ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s has disarmed %s.", SOLS_PlayerName(playerid), SOLS_PlayerName(targetid)));
	}

	ResetPlayerWeapons(targetid) ;
	Weapon_ResetPlayerWeapons(targetid) ;

	PlayerVar[targetid][E_PLAYER_TASER_EQUIPPED] = false;
	PlayerVar[targetid][E_PLAYER_BEANBAG_EQUIPPED] = false;
	PlayerVar[targetid][E_PLAYER_TACKLE_ACTIVE] = false;

	/*
	new query [ 384 ] ;

	format ( query, sizeof ( query ), "[!] DISARM: (%d) %s has disarmed (%d) %s.", 
		playerid, SOLS_PlayerName ( playerid ), targetid, SOLS_PlayerName ( targetid )) ;

	SendAdminMessage(query) ;
	*/

	//WriteLog ( playerid, "admin/guns", query);
	//WriteLog ( playerid, "admin/all", query);

	// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Used /disarm on %s (%d)", SOLS_PlayerName(targetid), targetid));
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Was disarmed by %s (%d)", SOLS_PlayerName(playerid), playerid));

	return true ;
}

/*
CMD:frisk(playerid, params[]) {

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "/frisk [targetid]");
	}

	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {
	 	if (!IsPlayerNearPlayer(playerid, targetid, 3.0)) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
	    }
	}

	if (  PlayerVar [ targetid ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }
    
	SendClientMessage(playerid, COLOR_RED, sprintf("Found weapons on %s:", SOLS_PlayerName ( targetid, 0, true ) ) ) ;

	new gunid, ammo, idx, ammo_name [ 32 ] ;

	for_loop ( new i, j = 12 ; i < j ; i ++ ) {

		idx = PlayerVar [ targetid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;
		GetPlayerWeaponData(targetid, i, gunid, ammo ) ;

		if ( idx != 0 ) {

			Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			SendClientMessage(playerid, COLOR_GD, sprintf("[Slot %d]:{DEDEDE} (id %d) %s with %d ammo (%s).", 
				GetWeaponSlot(Weapon [ idx ] [ E_WEAPON_GUNID ]), idx, Weapon [ idx ] [ E_WEAPON_DESC ], ammo, ammo_name ) ) ;
		}

		else continue ;
	}
	SendClientMessage(playerid, COLOR_RED, sprintf("Found drugs on %s:", SOLS_PlayerName ( targetid, 0, true ) ) ) ;

	new drug_name [ 32 ], drug_type [ 32 ], package_name [ 32 ] ;

	for_loop ( new i, j = MAX_PLAYER_DRUGS; i < j ; i ++ ) {

		if ( PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_TYPE ] != E_DRUG_TYPE_NONE ) {


			Drugs_GetParamName ( PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_TYPE ], 
				PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_PARAM ], drug_name 
			) ;

			Drugs_GetPackageName ( PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_CONTAINER ], package_name ) ;

			Drugs_GetTypeName(PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_TYPE ], drug_type ) ;

			SendClientMessage(playerid, COLOR_DRUGS, sprintf("[Slot %d]{DEDEDE} %.02fgr of %s stored in a %s. {FFFF00}[%s] ",
				i, PlayerDrugs [ targetid ] [ i ] [ E_PLAYER_DRUG_AMOUNT ], drug_name, package_name, drug_type
			 ) ) ;
		}
	}

	SendClientMessage(playerid, COLOR_RED, sprintf("Found gun packages on %s:", SOLS_PlayerName ( targetid, 0, true ) ) ) ;

	new gun_name [ 32 ] ;

	for ( new i, j = 10 ; i < j ; i ++ ) {

		if ( ! Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] ) {
			continue ;
		}

		Weapon_GetGunName ( Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ], gun_name, sizeof ( gun_name )) ; 

		SendClientMessage(playerid, COLOR_GD, sprintf("[Slot %d]{DEDEDE} [(%d) %s] [%d ammo]", 
			i, Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ], gun_name, 
			Character [ targetid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ i ] 
		)) ;
	}

	SendClientMessage(playerid, COLOR_RED, sprintf("Found money on %s:", SOLS_PlayerName ( targetid, 0, true ) ) ) ;

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		SendClientMessage(playerid, COLOR_BLUE, sprintf("Cash: $%s", IntegerWithDelimiter ( Character [ targetid ] [ E_CHARACTER_CASH ] ) ) ) ;
 	}

 	else {
		SendClientMessage(playerid, COLOR_BLUE, sprintf("Cash: $%s - Bank: $%s", 
			IntegerWithDelimiter ( Character [ targetid ] [ E_CHARACTER_CASH ] ), 
			IntegerWithDelimiter ( Character [ targetid ] [ E_CHARACTER_BANKCASH ] ) ) 
		) ;
 	}

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {
	    ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s has frisked %s.", 
	    	SOLS_PlayerName(playerid), SOLS_PlayerName(targetid)));
	}

	new query [ 384 ] ;
	format ( query, sizeof ( query ), "[!] FRISK: (%d) %s has frisked (%d) %s.", 
		playerid, SOLS_PlayerName ( playerid ), targetid, SOLS_PlayerName ( targetid )) ;

	SendAdminMessage(query) ;

	//WriteLog ( playerid, "admin/frisk", query);
	//WriteLog ( playerid, "admin/all", query);

	// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Used /frisk on %s (%d)", SOLS_PlayerName(targetid), targetid));

	return true ;
}
*/

IsPlayerInPoliceFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_POLICE, onduty);
}

// Just checks for SQL ID 16 in addition
IsPlayerInSheriffFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_POLICE, onduty) && IsPlayerInFaction(playerid, 16);
}