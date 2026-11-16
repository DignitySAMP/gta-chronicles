/*
#if !defined SERVER_DMV_X
	#define SERVER_DMV_X	1278.1571
#endif 
#if !defined SERVER_DMV_Y
	#define SERVER_DMV_Y	-1546.9106
#endif 
#if !defined SERVER_DMV_Z
	#define SERVER_DMV_Z	13.5547
#endif 

DMV_Init() {

	CreateDynamicPickup(1581, 1, SERVER_DMV_X, SERVER_DMV_Y, SERVER_DMV_Z );
	CreateDynamic3DTextLabel(sprintf("%s\n{DEDEDE}Available commands: /buylicense", "Department of Motor Vehicles"), COLOR_VEHICLE, SERVER_DMV_X, SERVER_DMV_Y, SERVER_DMV_Z, 15.0 );

}
CMD:taketest(playerid) {

	return SendServerMessage ( playerid, COLOR_BLUE, "DMV", "A3A3A3", "This feature is deprecated as a new DMV script is being developed. Use /buylicense!" ) ;
}

CMD:buylicense ( playerid ) {

	if ( GetPlayerCash ( playerid ) < SERVER_DMV_FEE ) {
		return SendServerMessage ( playerid, COLOR_BLUE, "DMV", "A3A3A3", sprintf("You don't have enough money to buy a license. You need at least $%s.", IntegerWithDelimiter ( SERVER_DMV_FEE ) )) ;
	}

	if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, SERVER_DMV_X, SERVER_DMV_Y, SERVER_DMV_Z ) ) {

		return SendServerMessage ( playerid, COLOR_BLUE, "DMV", "A3A3A3", "You're not near the DMV! Use /gps." ) ;
	}

	if ( Character [ playerid ] [ E_CHARACTER_DRIVERSLICENSE ] ) {

		return SendServerMessage ( playerid, COLOR_BLUE, "DMV", "A3A3A3", "You already have a license." ) ;
	}

	TakePlayerCash ( playerid, SERVER_DMV_FEE ) ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_driverslicense = 1 WHERE player_id = %d", Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	Character [ playerid ] [ E_CHARACTER_DRIVERSLICENSE ] = 1 ;

	return SendServerMessage ( playerid, COLOR_BLUE, "DMV", "A3A3A3", sprintf("Congratulations! You've bought your license for $%s.", IntegerWithDelimiter ( SERVER_DMV_FEE ) ) ) ;
}
*/

// See sporky/dmv.pwn ^^^

/*
CMD:license(playerid, params[]) return cmd_licenses(playerid, params);
CMD:licenses(playerid, params[]) {

	new target, gunlicensestr[64];

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Syntax", "a3a3a3", "/licenses [targetid]");
	}

	if ( ! IsPlayerConnected(target ) ) {

		return SendServerMessage(playerid, COLOR_RED, "Error", "a3a3a3", "Target isn't connected.");
	}


 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	SendClientMessage(target, 0xBC2626FF, "[__________] SAN ANDREAS IDENTIFICATION [__________]");

	SendClientMessage(target, COLOR_YELLOW, sprintf("[Full Name]:{DEDEDE} %s", Character [ playerid ] [ E_CHARACTER_NAME_RP ] ) ) ;
	SendClientMessage(target, COLOR_YELLOW, sprintf("[Driving License]:{DEDEDE} %s", ( Character [ playerid ] [ E_CHARACTER_DRIVERSLICENSE ] != 0) ? ("{3FC62F}Yes") : ("{BC2626}No") )) ;

	format(gunlicensestr, sizeof(gunlicensestr), "{BC2626}%s", "No");
	if (Character [ playerid ] [ E_CHARACTER_GUNLICENSE ] > 0)
	{
		new year, month, day, hour, minute, second ;
		stamp2datetime(Character [ playerid ] [ E_CHARACTER_GUNLICENSE ], year, month, day, hour, minute, second, 1 ) ;
		if (Character [ playerid ] [ E_CHARACTER_GUNLICENSE ] < gettime()) format(gunlicensestr, sizeof(gunlicensestr), "{FBC02D}Expired (%02d/%02d/%04d)", day, month, year);
		else format(gunlicensestr, sizeof(gunlicensestr), "{3FC62F}Yes (Expires %02d/%02d/%04d)", day, month, year);
	}

	SendClientMessage(target, COLOR_YELLOW, sprintf("[Firearms License]: %s", gunlicensestr)) ;
	SendClientMessage(target, COLOR_YELLOW, sprintf("[Social Security Number]:{DEDEDE} %d", 1000 + Character [ playerid ] [ E_CHARACTER_ID ] * Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ) ;


 	if( IsPlayerInPoliceFaction(target) ) {
		SendClientMessage(target, 0x3A84C4FF, "[__] MOBILE DATA COMPUTER PRINT OUT [__]");

		SendClientMessage(target, 0x3A84C4FF, sprintf("[Outstanding fines]{DEDEDE}: $%s", IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] )) ) ;
		SendClientMessage(target, 0x3A84C4FF, sprintf("[Driver Warnings]{DEDEDE}: %d/3", Character [ playerid ] [ E_CHARACTER_DRIVER_WARNINGS ] ) ) ;

		Property_ShowPlayerProperties(playerid, target ) ;
	}

	//ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s shows their license to %s.", ReturnPlayerNameData(playerid, 0, true), ReturnPlayerNameData(target, 0, true) ) );
	ProxDetectorAutoMe(playerid, 30.0, sprintf("shows a license card to %s.", ReturnPlayerNameData(target, 0, true)), true);

	return true ;
}
*/