
Paycheck_Process ( playerid ) {

	SendClientMessage(playerid, COLOR_YELLOW, "LOS SANTOS PAYCHECK");

	PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ++ ;

	new paycheck_jobs = 250 ; // this is job payout. 
	new paycheck_total = paycheck_jobs * PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ;

	new gov_paycheck = 250 ;
	new gov_paycheck_total = gov_paycheck * PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ;

	if ( PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] >= 6 ) {

		paycheck_total = paycheck_jobs - (paycheck_jobs / PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ]) ;
		gov_paycheck_total = gov_paycheck - (gov_paycheck / PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ]) ;
	}

	new query [ 1024 ] ;

	new savings_calc = ( Character [ playerid ] [ E_CHARACTER_SAVINGS ] / 700 ) / 2 ;
	Character [ playerid ] [ E_CHARACTER_SAVINGS ] += savings_calc ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_savings = %d WHERE player_id = %d", 
		Character [ playerid ] [ E_CHARACTER_SAVINGS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery(mysql, query);


	if( ! IsPlayerInPoliceFaction(playerid) ) {

		query[0]=EOS;
		//format ( query, sizeof ( query ), "PAYCHECK:{7ea928} +$%s{b3b3b3} || INTEREST:{7ea928} +$%s",  IntegerWithDelimiter(paycheck_total), IntegerWithDelimiter(interest)) ; 
		format ( query, sizeof ( query ), "WELFARE:{7ea928} +$%s{b3b3b3} || SAVINGS INTEREST: {7ea928} +$%s{b3b3b3} ($%s total)",  
			IntegerWithDelimiter(paycheck_total), IntegerWithDelimiter(savings_calc), IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_SAVINGS ])) ; 

	}

	else if( IsPlayerInPoliceFaction(playerid) ) {
		
		/*format ( query, sizeof ( query ), 
			"PAYCHECK:{7ea928} +$%s{b3b3b3} || INTEREST:{7ea928} +$%s{b3b3b3} || GOVERNMENT PAYCHECK: {1F98E2} +$%s", 
			IntegerWithDelimiter(paycheck_total), IntegerWithDelimiter(interest), IntegerWithDelimiter ( gov_paycheck ) );
		*/
		query[0]=EOS;
		format ( query, sizeof ( query ), 
			"WELFARE:{7ea928} +$%s{b3b3b3} || GOVERNMENT PAYCHECK: {1F98E2} +$%s{b3b3b3} || SAVINGS INTEREST: {7ea928} +$%s{b3b3b3} ($%s total)", 
			IntegerWithDelimiter(paycheck_total), IntegerWithDelimiter ( gov_paycheck_total ), IntegerWithDelimiter(savings_calc), IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_SAVINGS ]) );
		

		paycheck_total += gov_paycheck_total ;
	
	}

	SendClientMessage(playerid, 0xb3b3b3FF, query);

	if ( PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] > 8 ) {

		SendClientMessage(playerid, COLOR_YELLOW, "You've been ingame for a long time! Your paycheck has been limited to avoid money farming.");
	}

	
	new TAX_MODIFIER;

	new total_wealth = Character [ playerid ] [ E_CHARACTER_BANKCASH ] / 10 ;

	switch ( total_wealth ) {

		case 1 .. 10: { // 0 to 100k
			TAX_MODIFIER = 500 ;
		}
		case 11 .. 25: { // 110k to 250k

			TAX_MODIFIER = 450 ;
		}
		case 26 .. 50: { // 260k to 500k

			TAX_MODIFIER = 400 ;
		}
		case 51 .. 100: { // 510k to 1m

			TAX_MODIFIER = 350 ;
		}
		case 101 .. 250: { // 1.1m to 2.5m

			TAX_MODIFIER = 300 ;
		}		
		case 251 .. 500: { // 2.5m to 5m

			TAX_MODIFIER = 250 ;
		}
	}
	if ( total_wealth < 0 ) {

		TAX_MODIFIER = 600 ; 
	}


	new renting = Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ], rent ;

	if ( renting != -1 ) {
		// Player is using rented room
		if ( Character [ playerid ] [ E_CHARACTER_PROPERTYSPAWN ] == 1 ) {

			rent = Property [ renting ] [ E_PROPERTY_RENT ] ;

			query [ 0 ] = EOS ;

			Property [ renting ] [ E_PROPERTY_COLLECT ] += rent ;

			mysql_format(mysql, query, sizeof ( query ), "UPDATE properties SET property_collect = %d WHERE property_id = %d",
				Property [ renting ] [ E_PROPERTY_COLLECT ], Property [ renting ] [ E_PROPERTY_ID ]
			);

			mysql_tquery(mysql, query );
		}

		// Player isn't using rented room
		else if ( Character [ playerid ] [ E_CHARACTER_PROPERTYSPAWN ] == 0 ) {

			rent = 0 ;
		}
	}

/*


[00:35:19] [debug] Run time error 11: "Divide by zero"
[00:35:19] [debug] AMX backtrace:
[00:35:19] [debug] #0 002de2a0 in Paycheck_Process (playerid=0) at money/paycheck.pwn:208
[00:35:19] [debug] #1 002dbc24 in public PaycheckTick (playerid=0) at money/paycheck.pwn:31


	new property_tax ;

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			continue ;
		}

		if ( Property [ i ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

			property_tax += ( Property [ i ] [ E_PROPERTY_PRICE ] / TAX_MODIFIER ) ;
		}

		else continue ;
	}
	new vehicle_tax ;

	for_loop ( new i, j = sizeof ( Vehicle ); i < j ; i ++ ) {

		if ( ! IsValidVehicle ( Vehicle [ i ] [ E_VEHICLE_ID ] ) ) {

			continue ;
		}

		if ( Vehicle [ i ] [ E_VEHICLE_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

			vehicle_tax += ( DealerShip_GetModelPrice (Vehicle [ i ] [ E_VEHICLE_MODELID ] ) / TAX_MODIFIER ) ;
		}

		else continue ;
	}

	SendClientMessage(playerid, -1, sprintf("Tax Modifier: %d", TAX_MODIFIER ) ) ;

	SendClientMessage(playerid, 0xb3b3b3FF, sprintf("RENT:{a43e2c} -$%d{b3b3b3} || PROPERTY TAX:{a43e2c} -$%d{b3b3b3} || Vehicle TAX:{a43e2c} -$%d" ,
	 	rent, property_tax, vehicle_tax ) ) ;*/
	
	SendClientMessage(playerid, 0xb3b3b3FF, sprintf("RENT:{a43e2c} -$%d", rent) ) ;
	new old_balance = Character [ playerid ] [ E_CHARACTER_BANKCASH ] ;

	Character [ playerid ] [ E_CHARACTER_BANKCASH ] += paycheck_total ;

	Character [ playerid ] [ E_CHARACTER_BANKCASH ] -= rent ;
	//Character [ playerid ] [ E_CHARACTER_BANKCASH ] -= property_tax ;
	//Character [ playerid ] [ E_CHARACTER_BANKCASH ] -= vehicle_tax ;

	SendClientMessage(playerid, 0xb3b3b3FF, sprintf("OLD BALANCE:{2ebae8} $%d{b3b3b3} || NEW BALANCE:{2ebae8} $%d{b3b3b3} || MODIFIER: {2ebae8}%d",
		old_balance, Character [ playerid ] [ E_CHARACTER_BANKCASH ], TAX_MODIFIER ) ) ;

	Character [ playerid ] [ E_CHARACTER_PAYCHECK ] = 0 ;
	Character [ playerid ] [ E_CHARACTER_HOURS ] ++ ;
	CalculateLevel(playerid);

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_hours = %d, player_bankcash = %d, player_paycheck = 0 WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_HOURS ], Character [ playerid ] [ E_CHARACTER_BANKCASH ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	Gym_UpdatePaycheckData(playerid);

	return true ;
}
