#define COLOUR_HITMAN	(0x737373FF)

#include "hitman/roles.pwn"
#include "hitman/mole.pwn"
#include "hitman/cmds.pwn"
#include "hitman/contracts.pwn"

IsPlayerHitman ( playerid ) {

	if ( Character [ playerid ] [ E_CHARACTER_HITMAN ] ) {

		return true ;
	}

	return false ;
}

SendHitmanMessage ( text [] ) {

	foreach(new playerid: Player) {

		if ( IsPlayerSpawned ( playerid ) && IsPlayerLogged ( playerid  ) ) {
			if ( IsPlayerHitman ( playerid ) ) {

				ZMsg_SendClientMessage(playerid, COLOUR_HITMAN, text ) ;
			}
		}
	}

	return true ;
}


CMD:marktarget(playerid, params[]) {
	if ( ! IsPlayerHitman ( playerid ) ) {

		return false ;
	}

	new targetid, idx ;

	// Marks target for 2 hour cooldown once kill succeeds by hitman
	if ( sscanf ( params, "k<player>i", targetid, idx ) ) {

		SendClientMessage(playerid, COLOR_YELLOW, "/marktarget [targetid] [contract-id: /contracts] ((will 'disable' their character for 2 hours))");
		SendClientMessage(playerid, COLOR_RED, "This marker does not save. If you fail, you must re-apply it later." ) ;
		return true ;
	}

	if ( ! IsPlayerConnected(targetid)) {

		return SendClientMessage(playerid, COLOR_ERROR, "Target isn't connected. " ) ;
	}

	if ( idx < 0 || idx >= MAX_CONTRACTS || Contract [ idx ] [ E_CONTRACT_SQLID ] == INVALID_CONTRACT_ID || Contract [ idx ] [ E_CONTRACT_STATUS ] != E_CONTRACT_STATUS_APPROVED ) {

		return SendClientMessage(playerid, COLOR_ERROR, "The contract ID you entered doesn't exist or isn't approved." ) ;
	}

	if ( !IsPlayerNearPlayer(playerid, targetid, 35.0 ) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You're not near your target." );
	}

	PlayerVar [ targetid ] [ E_PLAYER_HITMAN_MARKED ] = true ;
	PlayerVar [ targetid ] [ E_PLAYER_HITMAN_CONTRACT ] = idx ;
	PlayerVar [ targetid ] [ E_PLAYER_HITMAN_KILLER ] = Character [ playerid ] [ E_CHARACTER_ID ] ;
	
	new string [ 256 ] ;

	format ( string, sizeof ( string ), "You have marked (%d) %s to be killed for contract ID %d. You must execute them for the reward.",
		targetid, ReturnPlayerNameData(targetid), idx 
	) ;

	SendClientMessage(targetid, COLOUR_HITMAN, "You've got an extremely uncomfortable feeling. You feel as if you're being watched by Death himself." ) ;

	format ( string, sizeof ( string ), "{[ [HITMAN] %s has marked %s as the target for contract %d. ]}", 
		ReturnPlayerNameData(playerid), ReturnPlayerNameData(targetid), idx 
	) ;

	SendHitmanMessage ( string ) ;

	return true ;

}
