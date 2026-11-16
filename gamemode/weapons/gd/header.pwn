#include "weapons/gd/data.pwn"
#include "weapons/gd/types.pwn"
#include "weapons/gd/assembly.pwn"

GD_Factory_Init() {
	for_loop ( new i, j = sizeof ( GunAssembly ); i < j; i ++ ) {

		CreateDynamicPickup(19627, 1, GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_X ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Y ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Z ] );
		if ( GunAssembly [ i ] [E_GUN_ASSEMBLY_CONST ] != E_ASSEMBLE_STORE ) {
			CreateDynamic3DTextLabel(sprintf("%s\n{DEDEDE}Available commands: /assemble", GunAssembly [ i ] [ E_GUN_ASSEMBLY_DESC ]), COLOR_GD, GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_X ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Y ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Z ], 5.0 );
		}

		else {
			CreateDynamic3DTextLabel(sprintf("%s\n{DEDEDE}Available commands: /materials", GunAssembly [ i ] [ E_GUN_ASSEMBLY_DESC ]), COLOR_GD, GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_X ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Y ], GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Z ], 5.0 );
		}

	}

	CreateDynamic3DTextLabel("Wood Collection Point\n{DEDEDE}Available commands: /collectwood", COLOR_GD, -444.4202, -62.0944, 59.2086, 15.0 );
	CreateDynamicMapIcon(-444.4202,	-62.0944,	59.2086, 37, 0, -1, -1, -1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL );

	CreateDynamic3DTextLabel("Metal Collection Point\n{DEDEDE}Available commands: /collectmetal", COLOR_GD, 621.8036,	873.4282, -42.9534, 15.0 );
	CreateDynamicMapIcon(621.8036,	873.4282,	-42.9534, 37, 0, -1, -1, -1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL );

	CreateDynamic3DTextLabel("Parts Collection Point\n{DEDEDE}Available commands: /collectparts", COLOR_GD, 2559.3552,	2823.0505,	10.8203, 15.0 );
	CreateDynamicMapIcon(2559.3552,	2823.0505,	10.8203, 37, 0, -1, -1, -1, STREAMER_MAP_ICON_SD, MAPICON_GLOBAL );

	// Load guns in progress!
	GD_Factory_FetchData () ;

	return true ;
}

CMD:collectwood(playerid, params[]) {

	if ( IsPlayerInRangeOfPoint(playerid, 5.0, -444.4202,	-62.0944,	59.2086 ) ) {

		new amount ;

		if ( sscanf ( params, "i", amount )) {

	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "/collectwood [amount] ( 1 x $150 )" );
		}

		if ( amount < 1 || amount > 1000 ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "You can't buy more than 1000 wood." );
		}

		new cost = amount * 150 ;

		if ( GetPlayerCash ( playerid ) < cost ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Error", "DEDEDE", 
	 		sprintf( "You don't have this much money! You need at least $%s.", IntegerWithDelimiter ( cost ) ));
		}

	  	SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  sprintf("You've bought %dx wood for $%s.",  
	  		amount, IntegerWithDelimiter ( cost )));
		TakePlayerCash ( playerid, cost ) ;

		Character [ playerid ] [ E_CHARACTER_GD_WOOD ] += amount ;

		new query [ 256 ] ;

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_wood = %d WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_GD_WOOD ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery ( mysql, query ) ;
	}

	else return SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  "You're not at the correct location!" );
	return true ;
}

CMD:collectmetal(playerid, params[]) {

	if ( IsPlayerInRangeOfPoint(playerid, 5.0, 621.8036,	873.4282,	-42.9534 ) ) {

		new amount ;

		if ( sscanf ( params, "i", amount )) {

	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "/collectmetal [amount] ( 1 x $200 )" );
		}

		if ( amount < 1 || amount > 1000 ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "You can't buy more than 1000 metal." );
		}

		new cost = amount * 200 ;

		if ( GetPlayerCash ( playerid ) < cost ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Error", "DEDEDE", 
	 		sprintf( "You don't have this much money! You need at least $%s.", IntegerWithDelimiter ( cost ) ));
		}

	  	SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  sprintf("You've bought %dx metal for $%s.",  
	  		amount, IntegerWithDelimiter ( cost )));
		TakePlayerCash ( playerid, cost ) ;

		Character [ playerid ] [ E_CHARACTER_GD_METAL ] += amount ;

		new query [ 256 ] ;

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_metal = %d WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_GD_METAL ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery ( mysql, query ) ;
	}

	else return SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  "You're not at the correct location!" );
	return true ;
}

CMD:collectparts(playerid, params[]) {

	if ( IsPlayerInRangeOfPoint(playerid, 5.0, 2559.3552,	2823.0505,	10.8203 ) ) {

		new amount ;

		if ( sscanf ( params, "i", amount )) {

	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "/collectparts [amount] ( 1 x $250 )" );
		}

		if ( amount < 1 || amount > 1000 ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "DEDEDE",  "You can't buy more than 1000 parts." );
		}


		new cost = amount * 250 ;

		if ( GetPlayerCash ( playerid ) < cost ) {
	 		return SendServerMessage( playerid, COLOR_ERROR, "Error", "DEDEDE", 
	 		sprintf( "You don't have this much money! You need at least $%s.", IntegerWithDelimiter ( cost ) ));
		}

	  	SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  sprintf("You've bought %dx parts for $%s.",  
	  		amount, IntegerWithDelimiter ( cost )));
		TakePlayerCash ( playerid, cost ) ;

		Character [ playerid ] [ E_CHARACTER_GD_PARTS ] += amount ;

		new query [ 256 ] ;

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_parts = %d WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery ( mysql, query ) ;
	}

	else return SendServerMessage( playerid, COLOR_GD, "Gun Dealer", "DEDEDE",  "You're not at the correct location!" );
	return true ;
}

GD_SavePlayerParts(playerid) {

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_wood = %d, player_gd_metal = %d, player_gd_parts = %d WHERE player_id = %d", 
		Character [ playerid ] [ E_CHARACTER_GD_WOOD ], Character [ playerid ] [ E_CHARACTER_GD_METAL ],
		Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	mysql_tquery ( mysql, query ) ;
	return true ;
}