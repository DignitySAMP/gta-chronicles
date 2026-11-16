#if !defined SERVER_PAYCHECK 
	#define SERVER_PAYCHECK 	( 450 )
#endif 

CMD:paycheck(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_MANAGER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	foreach(new targetid: Player) {

		Paycheck_Process ( targetid ) ;
	}

	SendAdminCmd(playerid, "forced a server-wide paycheck, happy days!");
	return true ;
}


ptask PaycheckTick[1800000](playerid) {

	Paycheck_Process(playerid);

	return true ;
}

CalculateLevel(playerid) {

	// every 8 hours, add 1 level.

	new old_level = Character [ playerid ] [ E_CHARACTER_LEVEL ] ;
	new level = Character [ playerid ] [ E_CHARACTER_HOURS ] / 8 ;

	level = level + 1; // starting level is 1, not 0
	
	Character [ playerid ] [ E_CHARACTER_LEVEL ] = level ;

	if ( old_level != level ) {

		/*
		SendClientMessage(playerid, COLOR_BLUE, "You have advanced to a new level!");
		SendClientMessage(playerid, 0xDEDEDEFF, 
			sprintf("Your old level: %d, your new level: %d (%d playing hours).", 
				old_level, level, Character [ playerid ] [ E_CHARACTER_HOURS ] ) ) ;
		*/

		SendClientMessage(playerid, COLOR_BLUE, sprintf("You've now played for %d hours and have advanced to Level %d.", Character [ playerid ] [ E_CHARACTER_HOURS ], level));
	}

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_level=%d WHERE player_id=%d",

		Character [ playerid ] [ E_CHARACTER_LEVEL ], Character [ playerid ] [ E_CHARACTER_ID ]
	);

	mysql_tquery(mysql, query);

	SetPlayerScore(playerid, Character [ playerid ] [ E_CHARACTER_LEVEL ] ) ;
}

Paycheck_Process ( playerid ) {

	if ( ! IsPlayerPlaying ( playerid ) ) {

		return false ;
	}

	SendClientMessage(playerid, COLOR_YELLOW, "BANK STATEMENT");

	PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ++ ;

	new paycheck_jobs = 250 ; // this is job payout. 
	new paycheck_total = paycheck_jobs * PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ;

	new salary = 0;
	new salary_total = 0;
	new duty_bonus = 0;
	
	if (IsPlayerInSheriffFaction(playerid))			{ salary = 200; duty_bonus = 250; }
	else if (IsPlayerInPoliceFaction(playerid)) 	{ salary = 225; duty_bonus = 250; }
	else if (IsPlayerInMedicFaction(playerid)) 		{ salary = 200; duty_bonus = 250; }
	else if (IsPlayerInDEAFaction(playerid)) 		{ salary = 275; duty_bonus = 100; }
	else if (IsPlayerInSecurityFaction(playerid)) 	{ salary = 175; duty_bonus = 250; }
	else if (IsPlayerInNewsFaction(playerid)) 		{ salary = 250;	duty_bonus = 150; }
	else if (IsPlayerInGovFaction(playerid)) 		{ salary = 250; duty_bonus = 100; }
	else if (IsPlayerInTruckerFaction(playerid)) 	{ salary = 250; duty_bonus = 0;	  }
	else if (IsPlayerInTaxiFaction(playerid)) 		{ salary = 100; duty_bonus = 175; }
	else if (IsPlayerInAnyGovFaction(playerid))		{ salary = 200; duty_bonus = 100; }

	if (salary)
	{
		if (Character[playerid][E_CHARACTER_FACTIONTIER] == 1) salary += 175;
		if (Character[playerid][E_CHARACTER_FACTIONTIER] == 2) salary += 100;
		if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3) salary -= 50; // tier 4 or higher gets less

		salary_total = salary * PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] >= 6 ) 
	{
		paycheck_total = paycheck_jobs - (paycheck_jobs / PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ]) ;
		salary_total = salary - (salary / PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ]) ;
	}

	new query [ 256 ] ;

	new savings_calc = ( Character [ playerid ] [ E_CHARACTER_SAVINGS ] / 700 ) / 2 ;
	Character [ playerid ] [ E_CHARACTER_SAVINGS ] += savings_calc ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_savings = %d WHERE player_id = %d", 
		Character [ playerid ] [ E_CHARACTER_SAVINGS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery(mysql, query);

	query[0]=EOS;
	format ( query, sizeof ( query ), "UNIVERSAL INCOME: {7ea928}$%s {b3b3b3}|| SAVINGS INTEREST: {7ea928}$%s{b3b3b3} ($%s total)",  
		IntegerWithDelimiter(paycheck_total), IntegerWithDelimiter(savings_calc), IntegerWithDelimiter(Character[playerid][E_CHARACTER_SAVINGS])); 

	SendClientMessage(playerid, 0xb3b3b3FF, query);

	if (salary_total)
	{
		// Salary faction paycheck
		new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
		new faction_enum_id = Faction_GetEnumID(factionid); 
		new salarystr[128];
		

		if (PlayerVar[playerid][ E_PLAYER_FACTION_DUTY] && duty_bonus > 0)
		{
			format(salarystr, sizeof(salarystr), "%s SALARY: {7ea928}$%s {b3b3b3}(Tier %d){b3b3b3} || DUTY BONUS: {7ea928}$%s", Faction[faction_enum_id][E_FACTION_ABBREV], IntegerWithDelimiter(salary_total), Character[playerid][E_CHARACTER_FACTIONTIER], IntegerWithDelimiter(duty_bonus));
			salary_total += duty_bonus;
		}
		else 
		{
			format(salarystr, sizeof(salarystr), "%s SALARY: {7ea928}$%s {b3b3b3}(Tier %d)", Faction[faction_enum_id][E_FACTION_ABBREV], IntegerWithDelimiter(salary_total), Character[playerid][E_CHARACTER_FACTIONTIER]);
		}

		SendClientMessage(playerid, 0xb3b3b3FF, salarystr);
		paycheck_total += salary_total;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PAYCHECK_INCR ] > 8 ) {

		SendClientMessage(playerid, COLOR_YELLOW, "You've been ingame for a long time! Your paycheck has been limited to avoid money farming.");
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
	 
	if (rent > 0)
	{
		SendClientMessage(playerid, 0xb3b3b3FF, sprintf("RENT:{a43e2c} $%d", rent) ) ;
	}

	new old_balance = Character [ playerid ] [ E_CHARACTER_BANKCASH ] ;

	Character [ playerid ] [ E_CHARACTER_BANKCASH ] += paycheck_total ;
	Character [ playerid ] [ E_CHARACTER_BANKCASH ] -= rent ;

	SendClientMessage(playerid, 0xb3b3b3FF, sprintf("OLD BALANCE:{2ebae8} $%d{b3b3b3} || NEW BALANCE:{2ebae8} $%d{b3b3b3}",
		old_balance, Character [ playerid ] [ E_CHARACTER_BANKCASH ] ) ) ;

	Character [ playerid ] [ E_CHARACTER_PAYCHECK ] = 0 ;


	if ( GetPlayerPausedTime(playerid) > 5400000 ) {

		SendClientMessage ( playerid, COLOR_YELLOW, "You've been paused for more than one hour and thirty minutes. We do not condone AFK hour / money farmers. Hours will not increase until you play." ) ;

	}

	else {

		Character [ playerid ] [ E_CHARACTER_HOURS ] ++ ;
		CalculateLevel(playerid);
	}

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_hours = %d, player_bankcash = %d, player_paycheck = 0 WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_HOURS ], Character [ playerid ] [ E_CHARACTER_BANKCASH ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery ( mysql, query ) ;

	new bool: recent_removal = false ;
	if ( Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ]  ) {
		Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ] -- ;

		SendClientMessage ( playerid, COLOR_BLUE, sprintf("Your fightstyle is protected for %d more paychecks.", Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ] ));
		if ( Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ] <= 0 ) {

			SendClientMessage ( playerid, COLOR_ERROR, "Your fightstyle protection is now gone. If you do not maintain your skills from this point forward, you will LOSE the fightstyle!");
			SendClientMessage(playerid, COLOR_YELLOW, "If you have the proper stats required for your fightstyle, you can go back to any gym to \"extend\" this protection.");
			Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ] = 0 ;
			Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ] = FIGHT_STYLE_NORMAL ;
		}

		recent_removal = true ;
		Gym_SaveVariables(playerid);
	}

	else {
		if (! recent_removal ) {
			Gym_CheckFightStyleExpiration(playerid);
		}
	}

	query [ 0 ] = EOS ;

	return true ;
}
