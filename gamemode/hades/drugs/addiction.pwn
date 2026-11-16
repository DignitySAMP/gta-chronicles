/*
	[[ 
		Player Addiction Stages (Save which drug they're addicted to):
		 	0 (Default) - No addiction triggered on use
		 	(25 ticks) 1 - Spawn with 90% hp. HP goes down 1.5 every 35 minutes
		 	(50 ticks) 2 - Spawn with 75% hp. HP does down 2.5 every 30 minutes.
		 	(75 ticks) 3 - Spawn with 60% hp. HP does down 2.5 every 25 minutes.
		 	(100 ticks) 4 - Spawn with 50% hp. HP goes down 3.0 every 25 minutes.
	]]
*/


#define ADDICTION_SUBTRACT_MIN_HEALTH	(35.0) // the addiction will impact health until this is reached

DrugsTick_Addiction(playerid) {

	if ( !PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_IS_ADDICTED ] || PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ] != INVALID_DRUG_ID || !PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) {
		// If the player isn't addicted, isn't addicted to a drug or has no addiction level, let's skip the tick.

		return true ;
	}

	if ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_EFFECT ] && PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_EFFECT ] && PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_HIGH_USED ] == PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ] ) {

		return true ;
	}

	new drug_name [ MAX_DRUG_NAME ], addiction_desc[64] ;
	PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_EXPIRE ] -- ; // The addiction should subside slowly over time.

	if ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] >= 1 && PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_EXPIRE ] == 0 ) {
		// If their addiction level is above positive and their expire is zero, let's drop them down an addiction level.

		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_EXPIRE ] = Drugs_GetAddictionExpireTime( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ]);
		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] -- ;
	}
	else  if ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] <= 0 ) {
		// If the player's addiction level is zero or less, let's reset their addiction.

		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_IS_ADDICTED ]  = false ;
		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] = 0 ;
		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_EXPIRE ] = 0 ;
		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ] = INVALID_DRUG_ID ;

		Drugs_GetDrugName(PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ], drug_name);
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("Your addiction to %s has subsided. You feel frail and exhausted.", drug_name) ) ;

		return true ;
	}

	PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_TICK ] -- ; // Their addiction should have negative effects kick in over time.

	if ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_TICK ] <= 0 ) {
		// Their addiction tick has reached zero. Let's punish them for not feeding into their addiction.

		new Float: final_health  = Drugs_GetPlayerHealth ( playerid ) - Drugs_AddictionHealthSubtract ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) ;

		if ( final_health <= ADDICTION_SUBTRACT_MIN_HEALTH ) { 
			// Let's make sure they can't actually kill themselves, rather just debuff them forever

			final_health = Drugs_GetPlayerHealth ( playerid ) - Drugs_AddictionHealthSubtract ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) ;
		}

		Drugs_SetPlayerHealth ( playerid, final_health ) ;

		Drugs_GetDrugName(PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ], drug_name);
		Drugs_GetAddictionDesc(PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTED_DRUG ], addiction_desc);

		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You feel weaker for not neglecting to your %s %s addiction and lose %0.2f health.", addiction_desc, drug_name, Drugs_AddictionHealthSubtract ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ])));
		SendClientMessage(playerid, COLOR_YELLOW, "You can avoid this effect by getting high on the drug, suffering the damage (quitting over time) or getting medical help." );

		// And reset their addiction tick so it can kick in again at a later time.
		PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_TICK ] = Drugs_GetAddictionSubtractTime ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) ;
	}

	return true ;
}

Drugs_GetAddictionDesc(addiction, desc[], len=sizeof(desc)) {

	switch ( addiction ) {
		case 1: format ( desc, len, "experimental" ) ;
		case 2: format ( desc, len, "dependant" ) ;
		case 3: format ( desc, len, "hazardous" ) ;
		case 4: format ( desc, len, "critical" ) ;
		default: format ( desc, len, "fresh" ) ;
	}
}

public Float: Drugs_AddictionHealthSubtract(addiction) {

	new Float: subtract = 1.0 ;
	switch ( addiction ) {
		case 1: subtract = 1.5 ;
		case 2: subtract = 2.5 ;
		case 3: subtract = 2.5 ;
		case 4: subtract = 3.0 ;
	}
	return subtract ;
}
Drugs_GetAddictionSubtractTime(addiction) {
	// Returns the tick time in seconds, to be used in "DrugAddiction" in ticks, add an addiction variable that 
	// gets this value. Each tick (second) subtracts the value. No value left in the variable triggers 
	// Drugs_AddictionHealthSubtract (health subtraction)

	new subtract_time = 2400 ; // 40 minutes
	switch ( addiction ) {
		case 1: subtract_time = 2100 ; // 35 minutes
		case 2: subtract_time = 1800 ; // 30 minutes
		case 3: subtract_time = 1500 ; // 25 minutes
		case 4: subtract_time = 1500 ; // 25 minutes
	}
	return subtract_time ;
}
Drugs_GetAddictionExpireTime(addiction) {
	// Returns the tick time in seconds for a player to drop an addiction level. Players can drop addiction levels
	// over time, but at higher stages you might need pharmaceutical assistance as the duration it takes coupled
	// with the negative effects are not worth it.

	new expire_time = 18000 ; // 5 hours
	switch ( addiction ) {
		case 1: expire_time = 21600 ; // 6 hours
		case 2: expire_time = 28800 ; // 8 hours
		case 3: expire_time = 36000 ; // 10 hours
		case 4: expire_time = 43200 ; // 12 hours
	}
	return expire_time ;
}

public Float: Drugs_GetAddictionSpawnHealth(addiction) {
	// An addict spawns with lower health. This declares that value.

	new Float: spawn_health = 100 ;
	switch ( addiction ) {
		case 1: spawn_health = 90 ;
		case 2: spawn_health = 80 ;
		case 3: spawn_health = 70 ;
		case 4: spawn_health = 60 ;
	}
	return spawn_health ;
}

