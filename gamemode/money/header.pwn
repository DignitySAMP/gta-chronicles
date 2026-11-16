/*

	Dynamic ATM system
	Robbery system
	Etc
*/

#include "money/bank.pwn"

GetPlayerCash ( playerid ) {

	return Character [ playerid ] [ E_CHARACTER_CASH ] ;
}

SetPlayerCash(playerid, amount) {

	Character [ playerid ] [ E_CHARACTER_CASH ] = amount ;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Character [ playerid ] [ E_CHARACTER_CASH ] ) ;

	return true ;
}

GivePlayerCash ( playerid, amount ) {

	if ( amount < 0 || Character [ playerid ] [ E_CHARACTER_CASH ] > cellmax - amount ) {

		return false ;
	}

	Character [ playerid ] [ E_CHARACTER_CASH ] += amount ;

	new query [ 96 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_cash = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_CASH ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney ( playerid ) ;
	GivePlayerMoney ( playerid, Character [ playerid ] [ E_CHARACTER_CASH ] ) ;

	return Character [ playerid ] [ E_CHARACTER_CASH ] ;
}

TakePlayerCash ( playerid, amount ) {

	if ( amount < 0 ) {

		return false ;
	}

	Character [ playerid ] [ E_CHARACTER_CASH ] -= amount ;

	new query [ 96 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_cash = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_CASH ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	ResetPlayerMoney ( playerid ) ;
	GivePlayerMoney ( playerid, Character [ playerid ] [ E_CHARACTER_CASH ] ) ;

	return Character [ playerid ] [ E_CHARACTER_CASH ] ; 
}

TakePlayerBankCash ( playerid, amount ) {

	if ( amount < 0 ) {

		return false ;
	}

	Character [ playerid ] [ E_CHARACTER_BANKCASH ] -= amount ;

	new query [ 96 ] ; 

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_bankcash = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_BANKCASH ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query ) ;

	return Character [ playerid ] [ E_CHARACTER_BANKCASH ] ; 
}


IntegerWithDelimiter(integer, delimiter[] = ",") {
    new string[16];

    format(string, sizeof string, "%i", integer);

    for_loop (new i = strlen(string) - 3, j = ((integer < 0) ? 1 : 0); i > j; i -= 3) {

        strins(string, delimiter, i, sizeof string);
    }

    return string;
}

CMD:givemoney ( playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_MANAGER) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, amount ;

	if ( sscanf ( params, "k<player>i", targetid, amount ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/givemoney [playerid] [amount of money]");
	}

	if ( ! IsPlayerConnected( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
	}

	GivePlayerCash ( targetid, amount ) ;

	SendClientMessage(playerid, COLOR_INFO, sprintf("You have given (%d) %s $%s.",
		targetid, ReturnPlayerNameData ( targetid ), IntegerWithDelimiter ( amount ) ) ) ;
	SendClientMessage(targetid, COLOR_INFO, sprintf("You have been given $%s by (%d) %s.",
		IntegerWithDelimiter ( amount ), playerid, ReturnPlayerNameData ( playerid ) ) ) ;

	return true ;
}
CMD:takemoney ( playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, amount ;

	if ( sscanf ( params, "k<player>i", targetid, amount ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/takemoney [playerid] [amount of money]");
	}

	if ( ! IsPlayerConnected( targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
	}

	TakePlayerCash ( targetid, amount ) ;

	SendClientMessage(playerid, COLOR_INFO, sprintf("You have fined (%d) %s $%s.",
		targetid, ReturnPlayerNameData ( targetid ), IntegerWithDelimiter ( amount ) ) ) ;
	SendClientMessage(targetid, COLOR_ERROR, sprintf("You have been fined $%s by (%d) %s.",
		IntegerWithDelimiter ( amount ), playerid, ReturnPlayerNameData ( playerid ) ) ) ;

	return true ;
}


CMD:pay ( playerid, params [] ) {
	
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new targetid, amount ;

	if ( sscanf ( params, "k<player>i", targetid, amount ) ) {
				
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "/pay [player] [amount]" ) ;
	}

	if ( targetid == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Your target seems to be invalid (not connected)." ) ;
	}

	if (  PlayerVar [ targetid ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if ( targetid == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Why would you pay yourself?" ) ;	
	}

 	if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if ( amount < 1 || amount > GetPlayerCash ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have that much money." ) ;
	}

	TakePlayerCash ( playerid, amount ) ;
	GivePlayerCash ( targetid, amount ) ;

	ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "** %s has paid $%s to %s.", ReturnPlayerNameData(playerid, 0, true), IntegerWithDelimiter ( amount ), ReturnPlayerNameData(targetid, 0, true)) ) ;

	SendClientMessage(targetid, 0x3E7C17FF, sprintf("You have received $%s from %s.", IntegerWithDelimiter(amount), ReturnPlayerNameData(playerid, 0, true) ));

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Paid $%s to %s (%d)", IntegerWithDelimiter(amount), ReturnPlayerNameData ( targetid, 0, true ), targetid), true);
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Received $%s from %s (%d)", IntegerWithDelimiter(amount), ReturnPlayerNameData ( playerid, 0, true ), playerid), true);

	return true ;
}


CMD:paya(playerid, params[]) {

	return cmd_payanim(playerid, params);
}

CMD:payanim ( playerid, params [] ) {
	
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new targetid, amount ;

	if ( sscanf ( params, "k<player>i", targetid, amount ) ) {
				
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "/payanim [player] [amount]" ) ;
	}

	if ( targetid == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Your target seems to be invalid (not connected)." ) ;
	}

	if (  PlayerVar [ targetid ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if ( targetid == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "Why would you pay yourself?" ) ;	
	}

 	if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if ( amount < 1 || amount > GetPlayerCash ( playerid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You don't have that much money." ) ;
	}

    // Only do anim if they're close to the player to avoid abuse

    if ( !IsPlayerInAnyVehicle(playerid) || !IsPlayerInAnyVehicle(targetid)) {
	    if ( IsPlayerNearPlayer ( playerid, targetid, 2.0 )) {
			SetPlayerToFacePlayer(targetid, playerid);
			SetPlayerToFacePlayer(playerid, targetid);

			ApplyAnimation(targetid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
			ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
		}
	}

	TakePlayerCash ( playerid, amount ) ;
	GivePlayerCash ( targetid, amount ) ;

	ProxDetector ( playerid, 20, COLOR_ACTION, sprintf( "** %s has paid $%s to %s.", ReturnPlayerNameData(playerid, 0, true), IntegerWithDelimiter ( amount ), ReturnPlayerNameData(targetid, 0, true)) ) ;
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Paid $%s to %s (%d)", IntegerWithDelimiter(amount), ReturnPlayerNameData ( targetid, 0, true ), targetid), true);
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Received $%s from %s (%d)", IntegerWithDelimiter(amount), ReturnPlayerNameData ( playerid, 0, true ), playerid), true);
	
	return true ;
}