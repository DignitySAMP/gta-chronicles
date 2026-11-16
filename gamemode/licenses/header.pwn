
#define MAX_LICENSES 2000
#define INVALID_LICENSE_ID -1

new bool:IsInLicenseCooldown[MAX_PLAYERS];

#if !defined SERVER_DMV_X
	#define SERVER_DMV_X	1481.0460
#endif 
#if !defined SERVER_DMV_Y
	#define SERVER_DMV_Y	-1788.5773
#endif 
#if !defined SERVER_DMV_Z
	#define SERVER_DMV_Z	18.7360
#endif 

enum E_LICENSE_DATA {

	LICENSE_ID,

	LICENSE_NO,
	LICENSE_OWNER,

	LICENSE_TYPE,
	LICENSE_SUBTYPE,

	LICENSE_EXP,
	LICENSE_ISSUER,

	LICENSE_STATUS // 0 - unclaimed, 1 - active, 2 - revoked
};

new License [MAX_LICENSES] [E_LICENSE_DATA];

enum {
	LICENSE_TYPE_ID,
	LICENSE_TYPE_DRIVER,
	LICENSE_TYPE_GUN
}

enum {
	GUNLICENSE_TYPE_PF = 0,
	GUNLICENSE_TYPE_CCW = 1
};

enum {
	LICENSE_STATUS_UNCLAIMED = 0,
	LICENSE_STATUS_ACTIVE = 1,
	LICENSE_STATUS_REVOKED = 2,
	LICENSE_STATUS_EXPIRED = 3
};


enum {
	E_BADGE_TYPE_PD,
	E_BADGE_TYPE_SD,
	E_BADGE_TYPE_DEA,
	E_BADGE_TYPE_FBI
}

#include "licenses/gui.pwn"
#include "licenses/native.pwn"
#include "licenses/gun.pwn"

License_OnScriptInit() {
	AddSimpleModel(-1, 1337, -28992, "sprite_model.dff", "license/license.txd");
	return true ;
}

License_GetFreeID() {

	for_loop ( new i, j = sizeof ( License ); i < j ; i ++ ) {

		if ( License [ i ] [ LICENSE_ID ] == INVALID_LICENSE_ID ) {

			return i ;		
		}
	}

	return INVALID_LICENSE_ID ;
}


License_LoadEntities() {

	for_loop ( new i, j = sizeof ( License ); i < j; i ++ ) {

		License [ i ] [ LICENSE_ID ] = INVALID_LICENSE_ID ;
	}

	print(" * [LICENSE] Loading all licenses...");

	inline License_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) { 

				License [ i ] [ LICENSE_ID ] = cache_get_field_int (i, "license_id");
				License [ i ] [ LICENSE_NO ] = cache_get_field_int (i, "license_no");
				License [ i ] [ LICENSE_OWNER ] = cache_get_field_int (i, "license_owner");
				License [ i ] [ LICENSE_TYPE ] = cache_get_field_int (i, "license_type");
				License [ i ] [ LICENSE_SUBTYPE ] = cache_get_field_int (i, "license_subtype");
				License [ i ] [ LICENSE_EXP ] = cache_get_field_int (i, "license_exp");
				License [ i ] [ LICENSE_ISSUER ] = cache_get_field_int (i, "license_issuer");
				License [ i ] [ LICENSE_STATUS ] = cache_get_field_int (i, "license_status");

			}

			printf(" * [LICENSE] Loaded %d licenses.", rows ) ;


		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM licenses", using inline License_OnDataLoad, "" ) ;

	return true ;
}

License_Create ( playerid, target, type, subtype, expiration ) {

	new license_enum_id = License_GetFreeID();

	if ( license_enum_id == INVALID_LICENSE_ID ) {

		return print(" * [LICENSE] Tried to create a new license but License_Create returned -1.");
	}

	License [ license_enum_id ] [ LICENSE_NO ] = gettime() / 2;
	License [ license_enum_id ] [ LICENSE_OWNER ] = Character[target][E_CHARACTER_ID];
	License [ license_enum_id ] [ LICENSE_TYPE ] = type;
	License [ license_enum_id ] [ LICENSE_SUBTYPE ] = subtype;
	License [ license_enum_id ] [ LICENSE_EXP ] = expiration;
	License [ license_enum_id ] [ LICENSE_ISSUER ] = Character[playerid][E_CHARACTER_ID]; // characterid of the person who issued it.
	License [ license_enum_id ] [ LICENSE_STATUS ] = LICENSE_STATUS_ACTIVE;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO licenses (license_no, license_owner, license_type, license_subtype, license_exp, license_issuer, license_status) VALUES (%d, %d, %d, %d, %d, %d, %d)",
		License [ license_enum_id ] [ LICENSE_NO ], License [ license_enum_id ] [ LICENSE_OWNER ], License [ license_enum_id ] [ LICENSE_TYPE ], License [ license_enum_id ] [ LICENSE_SUBTYPE ],
		License [ license_enum_id ] [ LICENSE_EXP ], License [ license_enum_id ] [ LICENSE_ISSUER ], License [ license_enum_id ] [ LICENSE_STATUS ]
	) ;

	inline License_OnDatabaseInsert() {

		License [ license_enum_id ] [ LICENSE_ID ] = cache_insert_id ();
		printf(" * [LICENSE] Created license (%d) with ID %d.", 
			license_enum_id, License [ license_enum_id ] [ LICENSE_ID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline License_OnDatabaseInsert, "");

	return true ;
}

License_Delete(licenseid) {

	new query [ 256 ];
	mysql_format ( mysql, query, sizeof ( query ), "DELETE FROM `licenses` WHERE license_id = %d", License[licenseid][LICENSE_ID]);
	mysql_tquery(mysql, query );

	License [ licenseid ] [ LICENSE_ID ] = INVALID_LICENSE_ID;

	return true;
}


CMD:license(playerid, params[]) return cmd_licenses(playerid, params);
CMD:licence(playerid, params[]) return cmd_licenses(playerid, params);
CMD:showlicense(playerid, params[]) return cmd_licenses(playerid, params);
CMD:mylicense(playerid, params[]) return cmd_licenses(playerid, params);
CMD:licenses(playerid, params[]) {

	new target, option[16];

	if ( sscanf ( params, "k<player>s[16]", target, option ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/license [targetid] [id, drivers, gun]");
	}

	if(IsInLicenseCooldown[playerid]){
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "You've just shown your license. Wait a bit before showing it again.");
	}

	if ( ! IsPlayerConnected(target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}


 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }


    if(!strcmp(option, "id", true)){

    	if(!PlayerVar[playerid][E_PLAYER_ATTRIBS_EDITABLE])
    		License_ShowPlayerGUI(playerid, target, LICENSE_TYPE_ID);

    	SendClientMessage(target, 0xBC2626FF, "[__________] SAN ANDREAS IDENTIFICATION [__________]");
		SendClientMessage(target, COLOR_YELLOW, sprintf("[Full Name]:{DEDEDE} %s", Character [ playerid ] [ E_CHARACTER_NAME_RP ] ) ) ;
		SendClientMessage(target, COLOR_YELLOW, sprintf("[Social Security Number]:{DEDEDE} %d", Character [ playerid ] [ E_CHARACTER_ID ] * Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ])) ;

		SendClientMessage(target, COLOR_HINT, sprintf("[INFO]: {DEDEDE}%s has just shown you their ID. It will go away in 30 seconds or you can /hidelicense.", ReturnPlayerNameData(playerid, 0, 1)));
		defer HidePlayerLicenseTD(target);
    }

    else if(!strcmp(option, "driver", true) || !strcmp(option, "drivers", true)){

    	if(HasDriverLicense(playerid)) {
    		ShowDriverLicense(playerid, target);
    	} else {
    		return SendClientMessage(playerid, COLOR_ERROR, "You do not possess a driver license! Get one at the City Hall. (/gps)");
    	}
    }

    else if(!strcmp(option, "gun", true) || !strcmp(option, "guns", true)){

    	if(HasGunLicense(playerid)) {
    		ShowGunLicense(playerid, target);
    	} else return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "You do not possess a valid firearms license!");

    } else return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/license [targetid] [id, drivers, gun]");

	if(playerid == target) {
		ProxDetectorAutoMe(playerid, 30.0, "looks at their license card.", true);
	} else {
			ProxDetectorAutoMe(playerid, 30.0, sprintf("shows a license card to %s.", ReturnPlayerNameData(target, 0, true)), true);
	}

	IsInLicenseCooldown[playerid] = true;
	defer ClearLicenseCooldown(playerid);

	return true ;
}

CMD:badge(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid) && !IsPlayerInMedicFaction(playerid) && !IsPlayerInNewsFaction(playerid, true) && !IsPlayerInDEAFaction(playerid) && !IsPlayerInSecurityFaction(playerid, true) || GetPlayerFactionSuspension(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're either not on duty, or you can't use this.");
	}

	if(IsInLicenseCooldown[playerid]){
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "You've just shown your badge. Wait a bit before showing it again.");
	}
		

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID(factionid ); 
	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/badge [targetid]");
	}

	if ( ! IsPlayerConnected(target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}

 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
	}

	new msg[256];

    switch(Faction [ faction_enum_id ] [ E_FACTION_ID ]) {

    	case 34: { //fbi (34)
    		Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_FBI);
    		format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their FBI Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    	}

    	case 29: { //dea
    		Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_DEA);
    		format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their DEA Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    	}

    	case 10: { // pd
    		Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_PD);
    		format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their PD Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    	}

    	case 16: { // sd
    		Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_SD);
    		format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their SD Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    	}

    }

	ProxDetectorAutoMe(playerid, 30.0, sprintf("shows their badge to %s.", ReturnPlayerNameData(target, 0, true)), true);

	SendClientMessage(target, COLOR_BLUE, sprintf("[__________] %s Badge [__________]", Faction[faction_enum_id][E_FACTION_ABBREV]));
	SendClientMessage(target, COLOR_GRAD1, sprintf("Name: %s", ReturnPlayerCharName(playerid) ) ) ;
	SendClientMessage(target, COLOR_GRAD1, sprintf("Rank: %s", Character [ playerid ] [ E_CHARACTER_FACTIONRANK ] ) ) ;
	SendClientMessage(target, COLOR_GRAD1, sprintf("Badge: #%03d", Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ] ) ) ;

	SendClientMessage(target, COLOR_HINT, msg);

	defer HidePlayerBadgeTD(target);

	IsInLicenseCooldown[playerid] = true;
	defer ClearLicenseCooldown(playerid);

	return true ;
}


CMD:flashbadge(playerid, params[]){

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if ((!IsPlayerInPoliceFaction(playerid) && !IsPlayerInMedicFaction(playerid) && !IsPlayerInNewsFaction(playerid, true) && !IsPlayerInDEAFaction(playerid) && !IsPlayerInSecurityFaction(playerid, true) && !IsPlayerInGovFaction(playerid)) || GetPlayerFactionSuspension(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're either not on duty, or you can't use this.");
	}

	if(IsInLicenseCooldown[playerid]){
		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "You've just shown your badge. Wait a bit before showing it again.");
	}	

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID(factionid ); 

	new Float: x, Float: y, Float: z, msg[256];
	GetPlayerPos(playerid, x, y, z);

	ProxDetectorAutoMe(playerid, 30.0, "flashes their badge.", true);

	foreach(new target: Player) {

		if(IsPlayerInRangeOfPoint(target, 6.0, x, y, z)){

			if(target == playerid)
				continue;

			switch(Faction [ faction_enum_id ] [ E_FACTION_ID ]) {

    			case 34: { //fbi (34)
    				Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_FBI);
    				format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their FBI Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    			}

    			case 29: { //dea
    				Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_DEA);
    				format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their DEA Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    			}

    			case 10: { // pd
    				Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_PD);
    				format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their PD Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    			}

    			case 16: { // sd
    				Badge_ShowPlayerGUI(playerid, target, E_BADGE_TYPE_SD);
    				format(msg, sizeof(msg), sprintf("[INFO]: {DEDEDE}%s has just shown you their SD Badge. It will go away in 30 seconds or you can /hidebadge.", ReturnPlayerNameData(playerid, 0, 1)));
    			}

    		}
			
			SendClientMessage(target, COLOR_BLUE, sprintf("[__________] %s Badge [__________]", Faction[faction_enum_id][E_FACTION_ABBREV]));
			SendClientMessage(target, COLOR_GRAD1, sprintf("Name: %s", ReturnPlayerCharName(playerid) ) ) ;
			SendClientMessage(target, COLOR_GRAD1, sprintf("Rank: %s", Character [ playerid ] [ E_CHARACTER_FACTIONRANK ] ) ) ;
			SendClientMessage(target, COLOR_GRAD1, sprintf("Badge: #%03d", Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ] ) ) ;

			SendClientMessage(target, COLOR_HINT, msg);

			defer HideQuickPlayerBadgeTD(target);

		}
	}

	IsInLicenseCooldown[playerid] = true;
	defer ClearLicenseCooldown(playerid);

	return true;
}

CMD:showbadge(playerid, params[]){
	return cmd_badge(playerid, params);
}

CMD:hidelicense(playerid, params[]){
	License_HidePlayerGUI(playerid);
	Badge_HidePlayerGUI(playerid);
	return true;
}

CMD:hidebadge(playerid, params[]){
	return cmd_hidelicense(playerid, params);
}

timer HidePlayerLicenseTD[30000](playerid) { 
		License_HidePlayerGUI(playerid);
		return true;
}

timer HidePlayerBadgeTD[30000](playerid) { 
		Badge_HidePlayerGUI(playerid);
		return true;
}

timer HideQuickPlayerBadgeTD[10000](playerid) { 
		Badge_HidePlayerGUI(playerid);
		return true;
}

timer ClearLicenseCooldown[10000](playerid){
	IsInLicenseCooldown[playerid] = false;
	return true;
}