
static IssueLicenseDlg[512];

CMD:issuelicense(playerid, params[]){

	if ( !IsPlayerInPoliceFaction(playerid) && !IsPlayerInGovFaction(playerid) && !IsPlayerInSheriffFaction(playerid) ) 
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You do not have access to this command.");

	if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) 
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You do not have the appropriate rank for this command.");

	new target, type, days; 

	if(sscanf(params, "k<player>dd", target, type, days)) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/issuelicense [playerid] [1 - pf, 2 - ccw] [days]");
	}

	if (!IsPlayerConnected ( target ) || !IsPlayerLogged(target) || !IsPlayerPlaying(target)) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player isn't connected." ) ;

	if(playerid == target && Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 1 ) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You cannot give yourself a license. Ask someone higher." ) ;

	if(Character[target][E_CHARACTER_ATTRIB_AGE] < 18)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This character is too young to possess a gun license." ) ;

	if( days < 7 || days >= 180 )
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The number of days must be more than 7 and less than 180." ) ;

	if(type < 1 || type > 2)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Type must be either 1 or 2 ( 1 - pf, 2 - ccw )." ) ;

	new year, month, day, hour, minute, second, string[256], ltype;
	new timestamp = gettime() + (days * 86400);

	switch(type) {

		case 1: {

			if(HasLicenseSubType(target, LICENSE_TYPE_GUN, GUNLICENSE_TYPE_PF)) {
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player already has this type of license. Use /takelicense to revoke it." ) ;
			} else if(HasLicenseSubType(target, LICENSE_TYPE_GUN, GUNLICENSE_TYPE_CCW)) {
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player already has a CCW license. Use /takelicense to revoke it." ) ;
			}

			ltype = GUNLICENSE_TYPE_PF;
		}

		case 2: {

			if(!HasLicenseSubType(target, LICENSE_TYPE_GUN, GUNLICENSE_TYPE_PF)) {
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player doesn't have a PF license, which is necessary for a CCW." ) ;
			} else if(HasLicenseSubType(target, LICENSE_TYPE_GUN, GUNLICENSE_TYPE_CCW)) {
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Player already has a CCW license. Use /takelicense to revoke it." ) ;
			}

			ltype = GUNLICENSE_TYPE_CCW;
		}
	}

	stamp2datetime(timestamp, year, month, day, hour, minute, second, 1 ) ;

	format(IssueLicenseDlg, sizeof(IssueLicenseDlg), "{DEDEDE}Please confirm the following license data:\n\n");

	format(string, sizeof(string), "{4696db}Character Name: {a6d2f7}%s", SOLS_PlayerName(target));
	strcat(IssueLicenseDlg, string);

	format(string, sizeof(string), "\n{4696db}License Type: {a6d2f7}%s", ltype ? ("CCW") : ("PF"));
	strcat(IssueLicenseDlg, string);

	format(string, sizeof(string), "\n{4696db}Expiration Date: {a6d2f7}%d/%d/%d", day, month, year);
	strcat(IssueLicenseDlg, string);

	format(string, sizeof(string), "\n\n{fc6868}Warning: {fcaeae}Licenses are logged and actively monitored by the admin team\nAny attempt to abuse this feature will result in a permanent ban.");
	strcat(IssueLicenseDlg, string);

	inline LicenseDlg(pid, dialogid, response, listitem, string:inputtext[]) { 
		#pragma unused pid, dialogid, listitem, inputtext

		if (!response) { 
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You have quit the dialog. The license wasn't issued." ) ;
		}

		if(response){

			if (!IsPlayerConnected(target) || !IsPlayerLogged(target)) return true;

			RemoveGunLicense(target);

			License_Create ( playerid, target, LICENSE_TYPE_GUN, ltype, timestamp );
			SendServerMessage(playerid, COLOR_RED, "License", "A3A3A3", sprintf("You have successfully created a license for %s.", SOLS_PlayerName(target)));
			SendServerMessage(target, COLOR_RED, "License", "A3A3A3", sprintf("You have been given a Firearms license by %s.", SOLS_PlayerName(playerid)));
			return true;
		}
	}

	Dialog_ShowCallback ( playerid, using inline LicenseDlg, DIALOG_STYLE_MSGBOX, "Confirm License Data", IssueLicenseDlg, "Confirm", "Close" );

	return true;
}

ShowGunLicense(playerid, target) {
    for_loop( new i; i < sizeof ( License ); i++){
		if(License[i][LICENSE_OWNER] == Character[playerid][E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_GUN ) {

			SendClientMessage(target, 0xBC2626FF,"[__________] SAN ANDREAS FIREARMS LICENSE [__________]");
			SendClientMessage(target, COLOR_YELLOW, sprintf("[Full Name]:{DEDEDE} %s", SOLS_PlayerName(playerid) ) ) ;
			SendClientMessage(target, COLOR_YELLOW, sprintf("[License No.]:{DEDEDE} %d", License[i][LICENSE_NO])) ;
			SendClientMessage(target, COLOR_YELLOW, sprintf("[License Type]:{DEDEDE} %s", (License[i][LICENSE_SUBTYPE]) ? ("CCW") : ("PF"))) ;
			SendClientMessage(target, COLOR_YELLOW, sprintf("[Firearms License]:{DEDEDE} %s", GetLicenseStatus(i))) ;

			SendClientMessage(target, COLOR_HINT, sprintf("[INFO]: {DEDEDE}%s has just shown you their Firearms License. It will go away in 30 seconds or you can /hidelicense.", SOLS_PlayerName(playerid)));

			break;

			} else continue;
	}

    return true;
}

ShowDriverLicense(playerid, target) {

    if(Character[playerid][E_CHARACTER_DRIVERSLICENSE]) {

    	if(!PlayerVar[playerid][E_PLAYER_ATTRIBS_EDITABLE])
		    License_ShowPlayerGUI(playerid, target, LICENSE_TYPE_DRIVER);

		SendClientMessage(target, 0xBC2626FF, "[__________] SAN ANDREAS DRIVER'S LICENSE [__________]");
		SendClientMessage(target, COLOR_YELLOW, sprintf("[Full Name]:{DEDEDE} %s", Character [ playerid ] [ E_CHARACTER_NAME_RP ] ) ) ;
		SendClientMessage(target, COLOR_YELLOW, sprintf("[Driving License]:{DEDEDE} Active")) ;

		if( IsPlayerInPoliceFaction(target) ) {
			SendClientMessage(target, 0x3A84C4FF, "[__] MOBILE DATA COMPUTER PRINT OUT [__]");

			//SendClientMessage(target, 0x3A84C4FF, sprintf("[Outstanding fines]{DEDEDE}: $%s", IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] )) ) ;
			SendClientMessage(target, 0x3A84C4FF, sprintf("[Driver Warnings]{DEDEDE}: %d/3", Character [ playerid ] [ E_CHARACTER_DRIVER_WARNINGS ] ) ) ;

			//Property_ShowPlayerProperties(playerid, target ) ;
		}

		SendClientMessage(target, COLOR_HINT, sprintf("[INFO]: {DEDEDE}%s has just shown you their Driver License. It will go away in 30 seconds or you can /hidelicense.", ReturnPlayerNameData(playerid, 0, 1)));
		defer HidePlayerLicenseTD(target);

    } else {
    	for_loop( new i; i < sizeof ( License ); i++){
			if(License[i][LICENSE_OWNER] == Character[playerid][E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_DRIVER) {

				if(!PlayerVar[playerid][E_PLAYER_ATTRIBS_EDITABLE])
		    		License_ShowPlayerGUI(playerid, target, LICENSE_TYPE_DRIVER);

				SendClientMessage(target, 0xBC2626FF, "[__________] SAN ANDREAS DRIVER'S LICENSE [__________]");
				SendClientMessage(target, COLOR_YELLOW, sprintf("[Full Name]:{DEDEDE} %s", Character [ playerid ] [ E_CHARACTER_NAME_RP ] ) ) ;
				SendClientMessage(target, COLOR_YELLOW, sprintf("[License No.]:{DEDEDE} %d", License[i][LICENSE_NO])) ;
				SendClientMessage(target, COLOR_YELLOW, sprintf("[Driving License]:{DEDEDE} %s", GetLicenseStatus(i))) ;

				if( IsPlayerInPoliceFaction(target) ) {
					SendClientMessage(target, 0x3A84C4FF, "[__] MOBILE DATA COMPUTER PRINT OUT [__]");

					//SendClientMessage(target, 0x3A84C4FF, sprintf("[Outstanding fines]{DEDEDE}: $%s", IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] )) ) ;
					SendClientMessage(target, 0x3A84C4FF, sprintf("[Driver Warnings]{DEDEDE}: %d/3", Character [ playerid ] [ E_CHARACTER_DRIVER_WARNINGS ] ) ) ;

					//Property_ShowPlayerProperties(playerid, target ) ;
				}

				SendClientMessage(target, COLOR_HINT, sprintf("[INFO]: {DEDEDE}%s has just shown you their Driver License. It will go away in 30 seconds or you can /hidelicense.", ReturnPlayerNameData(playerid, 0, 1)));
				defer HidePlayerLicenseTD(target);

				break;

			} else continue;
		}
    }
   	return true;
}

ChangeLicenseStatus ( licenseid, status ) {

	new query[1024];

	License [ licenseid ] [ LICENSE_STATUS ] = status;
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE licenses SET license_status = %d WHERE license_id = %d", License [ licenseid ] [ LICENSE_STATUS ], License [ licenseid ] [ LICENSE_ID ]) ;

	mysql_tquery(mysql, query);
	return true;
}

GetLicenseStatus (licenseid) {

	new status[64], year, month, day, hour, minute, second;

	stamp2datetime(License[licenseid][LICENSE_EXP], year, month, day, hour, minute, second, 1);
	if (License[licenseid][LICENSE_EXP] < gettime()) License[licenseid][LICENSE_STATUS] = LICENSE_STATUS_EXPIRED;

	switch(License[licenseid][LICENSE_STATUS]) {
		case LICENSE_STATUS_UNCLAIMED: { status = "{fcaa26}Unclaimed{FFFFFF}"; }
		case LICENSE_STATUS_ACTIVE: { status = "{1db31b}Active{FFFFFF}"; }
		case LICENSE_STATUS_REVOKED: { status = "{e30909}Revoked{FFFFFF}"; }
		case LICENSE_STATUS_EXPIRED: { 
			stamp2datetime(License[licenseid][LICENSE_EXP], year, month, day, hour, minute, second, 1 ) ;
			format(status, sizeof(status), "{1e31e3}Expired{FFFFFF} - expired on %d/%d/%d.", day, month, year);
		}
		default: {
			status = "None";
		}
	}

	return status;
}


RemoveDriverLicense(playerid) {
	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == Character [playerid] [E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_DRIVER) {

			License_Delete(i);

		} else continue;
	}

	Character[playerid][E_CHARACTER_DRIVERSLICENSE] = 0;

	new query [ 256 ];
	mysql_format ( mysql, query, sizeof ( query ), "UPDATE `characters` SET player_driverslicense = %d WHERE player_id = %d", Character[playerid][E_CHARACTER_DRIVERSLICENSE], Character[playerid][E_CHARACTER_ID]);
	mysql_tquery(mysql, query );
	return true;
}

RemoveGunLicense(playerid) {
	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == Character [playerid] [E_CHARACTER_ID] && License[i][LICENSE_TYPE] == LICENSE_TYPE_GUN) {

			License_Delete(i);

		} else continue;
	}

	return true;
}

OfflineRemoveLicenses(characterid, type) {

	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == characterid && License[i][LICENSE_TYPE] == type) {

			License_Delete(i);

		} else continue;
	}

	return true;
}

GetLicenseName (licenseid) {

	new name[16];

	switch(License[licenseid][LICENSE_TYPE]) {
		case LICENSE_TYPE_DRIVER: { name = "Driver"; }
		case LICENSE_TYPE_ID: { name = "Identification"; }
		case LICENSE_TYPE_GUN: { name = "Firearms"; }
		default: {
			name = "None";
		}
	}

	return name;
}

GetLicenseSubName (licenseid) {

	new name[16];

	switch(License[licenseid][LICENSE_SUBTYPE]) {
		case GUNLICENSE_TYPE_PF: { name = "PF"; }
		case GUNLICENSE_TYPE_CCW: { name = "CCW"; }
		default: {
			name = "None";
		}
	}

	return name;
}

HasDriverLicense(playerid) {
	
	if (Character[playerid][E_CHARACTER_DRIVERSLICENSE]){
			return true;
	} else {
		for_loop( new i; i < sizeof ( License ); i++){
			if(License[i][LICENSE_OWNER] == Character[playerid][E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_DRIVER) {
				return true;
			} else continue;
		}
	}

	return false;
}

HasGunLicense(playerid) {
	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == Character [playerid] [E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_GUN) {
			return true;
		} else continue;
	}

	return false;
}

HasActiveGunLicense(playerid) {
	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == Character [playerid] [E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == LICENSE_TYPE_GUN && License[i][LICENSE_EXP] > gettime()) {
			return true;
		} else continue;
	}

	return false;
}


HasLicenseSubType(playerid, type, subtype) {
	for_loop( new i; i < sizeof ( License ); i++){

		if(License[i][LICENSE_OWNER] == Character [playerid] [E_CHARACTER_ID] && License[i][LICENSE_ID] != INVALID_LICENSE_ID && License[i][LICENSE_TYPE] == type && License[i][LICENSE_SUBTYPE] == subtype) {
			return true;
		} else continue;
	}

	return false;
}


/*
CMD:revokelicense(playerid, params[]){

	if ( !IsPlayerInPoliceFaction(playerid) && !IsPlayerInGovFaction(playerid) && !IsPlayerInSheriffFaction(playerid) ) 
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You do not have access to this command.");

	if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) 
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "You do not have the appropriate rank for this command.");

	new target; 

	if(sscanf(params, "d", target)) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/revokelicense [characterid]");

	if(target < 0)
		return SendServerMessage(playerid, COLOR_RED, "Error", "A3A3A3", "Character ID must be bigger than 0.");

	for_loop( new i; i < sizeof ( License ); i++){
		if(License[i][LICENSE_OWNER] == target) {
			License[i][LICENSE_STATUS] = LICENSE_STATUS_REVOKED;
		} else continue;
	}

	SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", sprintf("You have revoked all licenses for characterid %d.", target));
	return true;
}*/
