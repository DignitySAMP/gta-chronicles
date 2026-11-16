/*
	
	(Base) Potency (this is an option when a drug or drug "seed" is spawned):
	 0 (Default) - Drugs last the default tick value. [[Grow Time: 2 hours per tick]]
	 1 - Drugs last 5% longer.  [[Grow Time: 3 hours per tick ]]
	 2 - Drugs last 10% longer + Effect amplified * 2. [[Grow Time: 4 hours per tick ]]
	 3 - Drugs last 10% longer + Effect amplified * 3. [[Grow Time: 5 hours per tick ]]
	 4 - Drugs last 15% longer + Effect amplified * 2. [[Grow Time: 4 hours per tick ]]
	 5 - Drugs last 15% longer + Effect amplified * 3. [[Grow Time: 5 hours per tick ]]
*/

Drugs_GetPotencyDesc(potency, desc[], len=sizeof(desc)) {

	switch ( potency ) {
		case 1: format ( desc, len, "Poor" ) ;
		case 2: format ( desc, len, "Below Average" ) ;
		case 3: format ( desc, len, "Average" ) ;
		case 4: format ( desc, len, "Above Average" ) ;
		case 5: format ( desc, len, "Excellent" ) ;
		default: format ( desc, len, "Very Poor" ) ;
	}
}


public Float: Drugs_GetPotencyAmplifier(potency) {

	new Float: amplifier ;

	switch ( potency) {

		case 1: amplifier = 1.10 ;
		case 2: amplifier = 1.15 ;
		case 3: amplifier = 1.20 ;
		case 4: amplifier = 1.25 ;
		case 5: amplifier = 1.30 ;
		default: amplifier = 1.0 ;
	}

	return amplifier ;
}

public Float: Drugs_GetPotencyEffectDuration(potency) {
	// Effect time = DEFAULT * duration

	new Float: duration ;

	switch ( potency) {

		case 1: duration = 1.20 ;
		case 2: duration = 1.40 ;
		case 3: duration = 1.60 ;
		case 4: duration = 1.80 ;
		case 5: duration = 2.00 ;
		default: duration = 1.00 ;

	}

	return duration ;
}