CMD:buysupplies(playerid, params[]) {


	new id = Cartel_GetClosestEntity ( playerid ) ;

	if ( id == INVALID_DRUG_ID ) {

		return SendServerMessage ( playerid, COLOR_DRUGS, "Drugs", "A3A3A3", "You're not near a supply point." );
	}

	switch ( Cartel [ id ] [ E_CARTEL_SUPPLY_TYPE ] ) {
		case E_DRUG_TYPE_WEED: {
			if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_DRUGS_WEED ) ) {

				return SendClientMessage(playerid, -1, "Your faction does not have access to weed production!");
			}
		}

		case E_DRUG_TYPE_COKE: {
			if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_DRUGS_COKE ) ) {

				return SendClientMessage(playerid, -1, "Your faction does not have access to cocaine production!");
			}
		}

		case E_DRUG_TYPE_CRACK: {
			if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_DRUGS_CRACK ) ) {

				return SendClientMessage(playerid, -1, "Your faction does not have access to crack production!");
			}
		}

		case E_DRUG_TYPE_METH: {

			if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_DRUGS_METH) ) {

				return SendClientMessage(playerid, -1, "Your faction does not have access to meth production!");
			}
		}

	}

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 2)
	{
		// Requested by Reyo
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be Tier 2 or higher to do this.");
	} 


	Cartel_DisplaySupplyList ( playerid, Cartel [ id ] [ E_CARTEL_SUPPLY_TYPE ] ) ;

	return true ;
}


Cartel_DisplaySupplyList(playerid, type ) {

	new string [ 1024 ] ;

	format ( string, sizeof ( string ), "Supply Info \t Price\n" ) ;

	switch ( type ) {
		case E_DRUG_TYPE_WEED:  format ( string, sizeof ( string ), 
			"%sMaui Waui Seed\t$600\nNorthern Lights Seed\t$800\nO.G. Kush Seed\t$1000\nPurple Kush Seed\t$1200", string ); 
		case E_DRUG_TYPE_COKE:  format ( string, sizeof ( string ), 
			"%sSleigh Ride Seed\t$1200\nBlanca Flakes Seed\t$1800\nGold Dust Seed\t$2400\nParadise White Seed\t$3000", string ); 
		case E_DRUG_TYPE_CRACK: format ( string, sizeof ( string ), 
			"%sMoon Rocks Powder\t$1400\nGravel Balls Powder\t$2000\nBoulder Cakes Powder\t$2800\nTornado Crack Powder\t$3200", string ); 
		
		/*
		case E_DRUG_TYPE_METH : format ( string, sizeof ( string ), 
			"%sLab Requirements\t$2400\nCaustic Soda\t$3000\nMuratic Acid\t$3600\nHydrogen Chloride\t$4200", string ) ;
		*/

		case E_DRUG_TYPE_METH: return SendClientMessage(playerid, COLOR_RED, "The creation of this drug is temporarily disbanded." ) ;
	}

	inline Cartel_Supplies(pid, dialogid, response, listitem, string:inputtext[]) {
    	#pragma unused pid, dialogid, inputtext

		if ( response ) {

			switch ( listitem ) {

				case 0: {// 600
					switch ( type ) {

						case E_DRUG_TYPE_WEED: Drugs_AddSupplyToPlayer(playerid, type, E_WEED_TYPE_MAUI_WAUI, 600 ) ; // maui waui
						case E_DRUG_TYPE_COKE: Drugs_AddSupplyToPlayer(playerid, type, E_COKE_TYPE_SLEIGH_RIDE, 1200 ) ; // sleigh ride
						case E_DRUG_TYPE_CRACK: Drugs_AddSupplyToPlayer(playerid, type, E_CRACK_TYPE_MOON_ROCKS, 1400 ) ; // moon rocks
						case E_DRUG_TYPE_METH: Drugs_AddSupplyToPlayer(playerid, type, 0, 0 ) ; // lab requirements
					}
				}

				case 1: {// 1200

					switch ( type ) {

						case E_DRUG_TYPE_WEED: Drugs_AddSupplyToPlayer(playerid, type, E_WEED_TYPE_NORTHERN_LIGHTS, 800 ) ; // northern lights
						case E_DRUG_TYPE_COKE: Drugs_AddSupplyToPlayer(playerid, type, E_COKE_TYPE_BLANCA_FLAKES, 1800 ) ; // blanca flakes
						case E_DRUG_TYPE_CRACK: Drugs_AddSupplyToPlayer(playerid, type, E_CRACK_TYPE_GRAVEL_BALLS, 2000 ) ; // gravel balls
						case E_DRUG_TYPE_METH:  Drugs_AddSupplyToPlayer(playerid, type, 0, 0 ) ; // caistoc spda
					}
				
				}

				case 2: {// 1800

					switch ( type ) {

						case E_DRUG_TYPE_WEED: Drugs_AddSupplyToPlayer(playerid, type, E_WEED_TYPE_OG_KUSH, 1000 ) ; // og kush
						case E_DRUG_TYPE_COKE: Drugs_AddSupplyToPlayer(playerid, type, E_COKE_TYPE_GOLD_DUST, 2400) ; // gold dust
						case E_DRUG_TYPE_CRACK: Drugs_AddSupplyToPlayer(playerid, type, E_CRACK_TYPE_BOULDER_CAKES, 2800 ) ; // boulder cakes
						case E_DRUG_TYPE_METH:  Drugs_AddSupplyToPlayer(playerid, type, 0, 0 ) ; // muratic acid
					}
				}

				case 3: {// 2400

					switch ( type ) {

						case E_DRUG_TYPE_WEED: Drugs_AddSupplyToPlayer(playerid, type, E_WEED_TYPE_PURPLE_KUSH, 1200 ) ; // purple kush
						case E_DRUG_TYPE_COKE: Drugs_AddSupplyToPlayer(playerid, type, E_COKE_TYPE_PARADISE_WHITE, 3000 ) ; // paradise white
						case E_DRUG_TYPE_CRACK: Drugs_AddSupplyToPlayer(playerid, type, E_CRACK_TYPE_TORNADO_CRACK, 3200 ) ; // tornado crack
						case E_DRUG_TYPE_METH:  Drugs_AddSupplyToPlayer(playerid, type, 0, 0 ) ; // hydrogen chloride
					}
				}
			}
		}

	}

	Dialog_ShowCallback ( playerid, using inline Cartel_Supplies, DIALOG_STYLE_TABLIST_HEADERS, "Cartel Supplies", string, "Purchase", "Cancel" );

	return true ;
}
