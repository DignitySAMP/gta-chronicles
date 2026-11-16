#include "weapons/data/weapon_data.pwn"

enum {
	E_GUN_SEL_NONE,
	E_GUN_SEL_MELEE, 
	E_GUN_SEL_PISTOL,
	E_GUN_SEL_SHOTGUN,
	E_GUN_SEL_SMG,
	E_GUN_SEL_ASSAULT,
	E_GUN_SEL_BOLT_ACTION
} ;

enum E_AMMO_DATA {

	E_AMMO_CONSTANT,
	E_AMMO_DESC [ 32 ],
	E_AMMO_TIME,
	E_AMMO_METAL,
	E_AMMO_PARTS,
	E_AMMO_CLIPSIZE
} ;

enum {
	AMMO_TYPE_NONE = 0, 
	AMMO_TYPE_A, AMMO_TYPE_B, AMMO_TYPE_C, AMMO_TYPE_D, 
	AMMO_TYPE_F, AMMO_TYPE_G, AMMO_TYPE_H, AMMO_TYPE_I,
	AMMO_TYPE_J, AMMO_TYPE_K, AMMO_TYPE_L
} ;
 
new Ammo [ ] [ E_AMMO_DATA ] = {

	{ AMMO_TYPE_NONE,	"None (invalid)" } ,
	// type 			name 				    time 	 	metal 	parts 	clip
	{ AMMO_TYPE_A, 		"9x19mm Parabellum",	60, 		1, 		1, 		48 }, // default clip: 24
	{ AMMO_TYPE_B, 		".45 ACP",				60, 		1, 		2, 		32 }, // default clip: 17
	{ AMMO_TYPE_C, 		".44 Magnum",			105, 		2, 		2, 		12 }, // default clip: 6
	{ AMMO_TYPE_D, 		".30-06 Springfield",	150, 		2, 		2, 		8 }, // default clip: 4
	{ AMMO_TYPE_F, 		".308 Winchester",		160, 		2, 		2, 		8 }, // default clip: 4
	{ AMMO_TYPE_G, 		".223 Rem",				120, 		2, 		3, 		8 }, // default clip: 4
	{ AMMO_TYPE_H, 		"12 gauge",				125, 		2, 		3, 		12 }, // default clip: 6
	{ AMMO_TYPE_I, 		"7.62x39mm",			130, 		1, 		2, 		90 }, // default clip: 45
	{ AMMO_TYPE_J, 		"5.56x45mm",			140, 		1, 		2, 		90 }, // default clip: 45
	{ AMMO_TYPE_K,		".357 SIG",				60, 		2, 		2, 		7 }, // default clip: 7
	{ AMMO_TYPE_L,		"5.7x28mm",				60, 		2, 		2, 		30 } // default clip: 30
} ;	

enum E_WEAPON_DATA {

	E_WEAPON_GUNID,
	E_WEAPON_DESC[32],
	E_WEAPON_AMMO,
	E_WEAPON_CLIP_SIZE, // taken from singleplayer
	E_WEAPON_TYPE,

	E_WEAPON_TIME, // seconds
	E_WEAPON_WOOD,
	E_WEAPON_METAL,
	E_WEAPON_PARTS,

	bool: E_WEAPON_CRAFTABLE
} ;

new Weapon [ ] [ E_WEAPON_DATA ] = {
	
	// Add guns to the END of this array, not inbetween!! (fucks up guns for players)
	{ 0,			"Fist",								AMMO_TYPE_NONE,	1, 	E_GUN_SEL_NONE,		9999, 9999,	9999,	9999, false  },
	// Melee
	{ WEAPON_BRASSKNUCKLE,	"Brass Knuckle",			AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_GOLFCLUB,		"Golf Club", 				AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_NITESTICK,		"Nitestick", 				AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_KNIFE,			"Knife", 					AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_BAT,			"Bat", 						AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_SHOVEL,		"Shovel", 					AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_POOLSTICK,		"Poolstick", 				AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_KATANA,		"Katana", 					AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_CHAINSAW,		"Chainsaw", 				AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_CANE,			"Cane", 					AMMO_TYPE_NONE,	1,  E_GUN_SEL_MELEE, 	30, 0, 1, 0, true } , // 150
	{ WEAPON_SPRAYCAN, 		"Spray Can",				AMMO_TYPE_NONE,	15000, E_GUN_SEL_MELEE,	30, 0, 1, 0, true } , // 150



	// PIstols
	{ WEAPON_COLT45,		"ASP Pistol",				AMMO_TYPE_A, 	10, E_GUN_SEL_PISTOL,	45, 4, 5, 2, true }, // 
	{ WEAPON_COLT45,		"Glock 17",					AMMO_TYPE_A, 	10, E_GUN_SEL_PISTOL,	45, 5, 5, 2, true }, // 
	{ WEAPON_COLT45,		"Beretta M9",				AMMO_TYPE_I, 	10, E_GUN_SEL_PISTOL,	45, 6, 5, 2, true }, // 
	{ WEAPON_COLT45,		"Colt M1911",				AMMO_TYPE_J, 	10, E_GUN_SEL_PISTOL,	55, 6, 5, 4, true }, // 

	{ WEAPON_SILENCED,		"SIG P226 Silenced",		AMMO_TYPE_A, 	10, E_GUN_SEL_PISTOL,	60, 5, 5, 5, true }, //  2250
	{ WEAPON_SILENCED,		"SW1991 Silenced",			AMMO_TYPE_B, 	10, E_GUN_SEL_PISTOL,	75, 5, 5, 7, true }, // 2650
	{ WEAPON_SILENCED,		"H&K USP Silenced",			AMMO_TYPE_B, 	10, E_GUN_SEL_PISTOL,	75, 5, 5, 7, true }, // 2650
	{ WEAPON_SILENCED,		"Ruger P95 Silenced",		AMMO_TYPE_A, 	10, E_GUN_SEL_PISTOL,	60, 5, 5, 5, true }, //  2250

	{ WEAPON_DEAGLE,		"Llama M82",				AMMO_TYPE_I, 	7, E_GUN_SEL_PISTOL,	90, 7, 7, 10, true }, 
	{ WEAPON_DEAGLE,		"S&W Model 29",				AMMO_TYPE_C, 	7, E_GUN_SEL_PISTOL,	90, 7, 7, 10, true }, 
	{ WEAPON_DEAGLE,		"Ballester-Molina",			AMMO_TYPE_B, 	7, E_GUN_SEL_PISTOL,	80, 6, 7, 9, true }, 
	{ WEAPON_DEAGLE,		"Ruger Blackhawk",			AMMO_TYPE_C, 	7, E_GUN_SEL_PISTOL,	90, 5, 7, 9, true },  
	
	// SMG	
	{ WEAPON_UZI,			"Uzi",						AMMO_TYPE_A,	36, E_GUN_SEL_SMG,		115, 10, 10, 8, true }, // 4100
	{ WEAPON_UZI,			"Socimi Type 821", 			AMMO_TYPE_A,	36, E_GUN_SEL_SMG,		115, 10, 10, 8, true }, // 4100
	{ WEAPON_UZI,			"MAC-11",					AMMO_TYPE_A,	36, E_GUN_SEL_SMG,		130, 10, 10, 10, true }, // 4500
	{ WEAPON_UZI,			"MAC-10", 					AMMO_TYPE_A,	36, E_GUN_SEL_SMG,		130, 10, 10, 10, true }, // 4500
	
	{ WEAPON_TEC9,			"PP-90",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		115, 10, 10, 9, true }, // 4300
	{ WEAPON_TEC9,			"Skorpion",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		115, 10, 10, 9, true }, // 4300
	{ WEAPON_TEC9,			"Beretta M12",				AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		115, 10, 10, 9, true }, // 4300
	{ WEAPON_TEC9,			"KGP-9",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		115, 10, 10, 9, true }, // 4300
	
	{ WEAPON_MP5,			"FN P90",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		150, 12, 12, 10, false }, // 5000
	{ WEAPON_MP5,			"MP 40",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		150, 12, 12, 10, true }, // 5000
	{ WEAPON_MP5,			"PP-19 Bizon",				AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		150, 12, 12, 10, true }, // 5000
	{ WEAPON_MP5,			"H&K MP5",					AMMO_TYPE_A,	30, E_GUN_SEL_SMG,		150, 12, 12, 10, false }, // 5000

	// Assault Riffles
	{ WEAPON_AK47,			"AEK-971", 					AMMO_TYPE_I,	30, E_GUN_SEL_ASSAULT,	180, 15, 15, 15, true }, // 6750
	{ WEAPON_AK47,			"AK-74", 					AMMO_TYPE_I,	30, E_GUN_SEL_ASSAULT,	180, 15, 15, 15, true }, // 6750
	{ WEAPON_AK47,			"AKM", 						AMMO_TYPE_I,	30, E_GUN_SEL_ASSAULT,	180, 15, 15, 15, true }, // 6750
	{ WEAPON_AK47,			"AK-47", 					AMMO_TYPE_I,	30, E_GUN_SEL_ASSAULT,	180, 15, 15, 15, true }, // 6750

	{ WEAPON_M4,			"M-16", 					AMMO_TYPE_J,	30, E_GUN_SEL_ASSAULT,	200, 18, 18, 18, false }, // 8100
	{ WEAPON_M4,			"HK33", 					AMMO_TYPE_J,	30, E_GUN_SEL_ASSAULT,	200, 18, 18, 18, true }, // 8100
	{ WEAPON_M4,			"FN FNC", 					AMMO_TYPE_J,	30, E_GUN_SEL_ASSAULT,	200, 18, 18, 18, true }, // 8100
	{ WEAPON_M4,			"Norinco CQ", 				AMMO_TYPE_J,	30, E_GUN_SEL_ASSAULT,	200, 18, 18, 18, true }, // 8100

	// Shotguns
	{ WEAPON_SHOTGUN, 		"Mossberg 500", 			AMMO_TYPE_H,	12, E_GUN_SEL_SHOTGUN,	175, 20, 20, 15, true }, // 8000
  	{ WEAPON_SHOTGUN, 		"Remington 870", 			AMMO_TYPE_H,	12, E_GUN_SEL_SHOTGUN,	175, 20, 20, 15, false }, // 8000
  	{ WEAPON_SHOTGUN, 		"Winchester 1200", 			AMMO_TYPE_H,	12, E_GUN_SEL_SHOTGUN,	175, 20, 20, 15, true }, // 8000
  	{ WEAPON_SHOTGUN, 		"Remington 887", 			AMMO_TYPE_H,	12, E_GUN_SEL_SHOTGUN,	175, 20, 20, 15, false }, // 8000

  	{ WEAPON_SHOTGSPA, 		"USAS-12", 					AMMO_TYPE_H,	7, E_GUN_SEL_SHOTGUN,	200, 20, 20, 20, false }, // 9000
  	{ WEAPON_SHOTGSPA, 		"SPAS-15", 					AMMO_TYPE_H,	7, E_GUN_SEL_SHOTGUN,	200, 20, 20, 20, false }, // 9000
  	{ WEAPON_SHOTGSPA, 		"Saiga-12", 				AMMO_TYPE_H,	7, E_GUN_SEL_SHOTGUN,	200, 20, 20, 20, false }, // 9000
  	{ WEAPON_SHOTGSPA, 		"M1216", 					AMMO_TYPE_H,	7, E_GUN_SEL_SHOTGUN,	200, 20, 20, 20, false }, // 9000
		
  	{ WEAPON_SAWEDOFF, 		"Ithaca 37", 				AMMO_TYPE_H,	2, E_GUN_SEL_SHOTGUN,	250, 25, 30, 20, true }, // 11000
  	{ WEAPON_SAWEDOFF, 		"KS-23", 					AMMO_TYPE_H,	2, E_GUN_SEL_SHOTGUN,	250, 25, 30, 20, true }, // 11000
  	{ WEAPON_SAWEDOFF, 		"MAG-7", 					AMMO_TYPE_H,	2, E_GUN_SEL_SHOTGUN,	250, 25, 30, 20, true }, // 11000

  	// Bolt Action Rifles
	{ WEAPON_RIFLE, 		"M1903 Springfield", 		AMMO_TYPE_D,	5, E_GUN_SEL_BOLT_ACTION,	275, 20, 25, 25, true  }, //10750
	{ WEAPON_RIFLE, 		"M1917 Enfield", 			AMMO_TYPE_D,	5, E_GUN_SEL_BOLT_ACTION,	275, 20, 25, 25, true  }, //10750
	{ WEAPON_RIFLE, 		"Mosin-Nagant", 			AMMO_TYPE_D,	5, E_GUN_SEL_BOLT_ACTION,	275, 20, 25, 25, true  }, //10750
	{ WEAPON_RIFLE, 		"Karabiner 98k", 			AMMO_TYPE_D,	5, E_GUN_SEL_BOLT_ACTION,	275, 20, 25, 25, true  }, //10750
	
	{ WEAPON_SNIPER, 		"Remington 700", 			AMMO_TYPE_F, 	5, E_GUN_SEL_BOLT_ACTION,	300, 25, 25, 25, false  }, // 11250
	{ WEAPON_SNIPER, 		"Winchester 70", 			AMMO_TYPE_F, 	5, E_GUN_SEL_BOLT_ACTION,	300, 25, 25, 25, true  }, // 11250
	{ WEAPON_SNIPER, 		"Browning A-Bolt", 			AMMO_TYPE_G, 	5, E_GUN_SEL_BOLT_ACTION,	300, 25, 25, 25, true  }, // 11250
	{ WEAPON_SNIPER, 		"Ruger M77",		 		AMMO_TYPE_G, 	5, E_GUN_SEL_BOLT_ACTION,	300, 25, 25, 25, true  }, //  11250
	

	{ WEAPON_CAMERA, 		"Camera",					AMMO_TYPE_NONE,	1500, E_GUN_SEL_MELEE,	30, 1, 1, 1, false  }, // 450
	{ WEAPON_COLT45,		"Emmet's Colt",				AMMO_TYPE_A, 	24,   E_GUN_SEL_PISTOL,	45, 3, 2, 2, false  }, // 1000 [UNUSED 11-07-22]
	{ WEAPON_SILENCED,		"Tazer",					AMMO_TYPE_A, 	10, E_GUN_SEL_PISTOL,	60, 5, 5, 5, false  }, //  2250
	{ WEAPON_FIREEXTINGUISHER,	"Fire Extinguisher", 	AMMO_TYPE_NONE,	15000, E_GUN_SEL_MELEE,	30, 0, 1, 0, true }, // 150

	// New pistol for cops
	{ WEAPON_DEAGLE,		"S&W Model 4566",			AMMO_TYPE_B, 	7, E_GUN_SEL_PISTOL,	90, 7, 7, 10, false }, // for pd only

	// New troll weapon
	{ 0,		"Unused",			AMMO_TYPE_NONE, 	7, E_GUN_SEL_NONE,	90, 7, 7, 10, false }, // for hades only [UNUSED 11-07-22]
	{ 0,		"Unused",			AMMO_TYPE_NONE,	7, E_GUN_SEL_NONE,	200, 20, 20, 20, false }, // for spooky [UNUSED 11-07-22]

	// DEA Pistol & SMG
	{ WEAPON_DEAGLE,		"SIG P229",					AMMO_TYPE_K,	7, E_GUN_SEL_PISTOL,	90, 7, 7, 10, false }, // for DEA only
	{ WEAPON_MP5,			"FN P90 USG",				AMMO_TYPE_L,	30, E_GUN_SEL_SMG,		150, 12, 12, 10, false }, // for DEA only

	// Civilian PF Weapons
	{ WEAPON_COLT45,		"Kel-Tec P11",				AMMO_TYPE_A,	24, E_GUN_SEL_PISTOL,	45, 3, 2, 2, false  },
	{ WEAPON_DEAGLE,		"Ruger P90",				AMMO_TYPE_B,	7, E_GUN_SEL_PISTOL,	90, 7, 7, 10, false }
} ;


Ammo_SaveForPlayer(playerid) {

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_ammo_a = %d, player_ammo_b = %d, player_ammo_c = %d WHERE player_id = %d",

		Character [ playerid ] [ E_CHARACTER_AMMO_A ], Character [ playerid ] [ E_CHARACTER_AMMO_B ], Character [ playerid ] [ E_CHARACTER_AMMO_C ],
		Character [ playerid ] [ E_CHARACTER_ID ]
 	) ;

	mysql_tquery(mysql, query);

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_ammo_d = %d, player_ammo_e = %d, player_ammo_f = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_AMMO_D ], Character [ playerid ] [ E_CHARACTER_AMMO_E ], Character [ playerid ] [ E_CHARACTER_AMMO_F ],
		Character [ playerid ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, query);

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_ammo_g = %d, player_ammo_h = %d, player_ammo_i = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_AMMO_G ], Character [ playerid ] [ E_CHARACTER_AMMO_H ], Character [ playerid ] [ E_CHARACTER_AMMO_I ],
		Character [ playerid ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, query);

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_ammo_j = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_AMMO_J ], 
		Character [ playerid ] [ E_CHARACTER_ID ]
	) ;

	mysql_tquery(mysql, query);

	return true ;
}

Weapon_GetGunName ( idx, gun_name[], len = sizeof ( gun_name ) ) {


	if ( idx < 0 || idx >= sizeof ( Weapon ) ) {

		format ( gun_name, len, "Invalid" ) ;
	}


	else {
		format ( gun_name, len, "%s", Weapon [ idx ] [ E_WEAPON_DESC ] ) ;
	}
}

Weapon_GetGunReason ( idx, gun_name[], len = sizeof ( gun_name ) ) {


	if ( idx < 0 || idx >= sizeof ( Weapon ) ) {

		format ( gun_name, len, "Unknown Weapon" ) ;
	}
	else 
	{
		format ( gun_name, len, "%s", Weapon [ idx ] [ E_WEAPON_DESC ] ) ;
	}

	new firstchar = gun_name[0];
	if (firstchar == 'A' || firstchar == 'E' || firstchar == 'I' || firstchar == 'O' || firstchar == 'U')
	{
		format(gun_name, len, "an %s", gun_name);
	}
	else
	{
		format(gun_name, len, "a %s", gun_name);
	}
}

Weapon_GetAmmoName ( idx, ammo_name[], len = sizeof ( ammo_name ) ) {

	if ( idx < 0 || idx >= sizeof ( Weapon ) ) {

		format ( ammo_name, len, "Invalid" ) ;
		return ;
	}

	new ammo_const = Weapon [ idx ] [ E_WEAPON_AMMO ] ;

	for_loop ( new i, j = sizeof ( Ammo ); i < j ; i ++ ) {

		if ( Ammo [ i ] [ E_AMMO_CONSTANT ] == ammo_const ) {

			format ( ammo_name, len, "%s", Ammo [ i ] [ E_AMMO_DESC] ) ;
		}
	}
}

Ammo_GetAmmoName(idx, ammo_name[], len = sizeof ( ammo_name ) ) {

	for_loop ( new i, j = sizeof ( Ammo ); i < j ; i ++ ) {

		if ( Ammo [ i ] [ E_AMMO_CONSTANT ] == idx ) {

			format ( ammo_name, len, "%s", Ammo [ i ] [ E_AMMO_DESC] ) ;
		}
	}
}

CMD:spoofgivegun(playerid, params[]) {

	new targetid, id, ammo ;

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	if ( sscanf  ( params, "k<player>ii", targetid, id, ammo ) || ! IsPlayerConnected ( targetid ) ) {

		return SendClientMessage(playerid, -1, "/spoofgivegun [player] [id] [ammo]" ) ;
	}

	if ( ammo < 0 || ammo > 999 ) {
		return SendClientMessage(playerid, -1, "Not gonna happen." ) ;
	}

	GiveCustomWeapon ( targetid, id, ammo ); 
	new gun_name[32];
	Weapon_GetGunName(id, gun_name, 32);

	SendClientMessage(playerid, -1, sprintf("You gave (%d) %s a %s (%d) with %d ammo.", targetid, ReturnPlayerNameData(targetid), gun_name, id, ammo ) );
	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Gave a %s (%d) a spoofed %s (%d) with %d ammo.", ReturnPlayerNameData(targetid), targetid, gun_name, id, ammo));
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Received a spoofed %s (%d) with %d ammo from %s.", gun_name, id, ammo, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT)));

	return true ;
}

CMD:spoofgun(playerid, params[]) {

	new id, ammo ;

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	if ( sscanf  ( params, "ii", id, ammo ) ) {

		return SendClientMessage(playerid, -1, "/spoofgun [id] [ammo]" ) ;
	}

	if ( ammo < 0 || ammo > 999 ) {
		return SendClientMessage(playerid, -1, "Not gonna happen." ) ;
	}

	GiveCustomWeapon ( playerid, id, ammo ); 
	new gun_name[32];
	Weapon_GetGunName(id, gun_name, 32);

	SendClientMessage(playerid, -1, sprintf("You gave yourself a %s (%d) with %d ammo.", gun_name, id, ammo ) );
	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Spoofed a %s (%d) with %d ammo.", gun_name, id, ammo));

	return true ;
}

stock GetCustomWeaponInSlot(playerid, slot ) {

	new idx = -1 ;

	for_loop ( new i, j = 13 ; i < j ; i ++ ) {
		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

		if ( idx == -1 ) {

			continue ;
		}

		if ( GetWeaponSlot ( Weapon [ idx ] [ E_WEAPON_GUNID ] ) == slot ) {

			return idx ;
		}
	}

	return idx ;
}

GiveCustomWeapon(playerid, index, ammo ) {

	new gunid = Weapon [ index ] [ E_WEAPON_GUNID ] ;
	new slot = GetWeaponSlot ( gunid ) ;

	if ( gunid == 0 || ammo < 1 ) {

		return true ;
	}

	if ( gunid == 41 && ammo < 0.0 ) {

		if ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
			ammo = 15000 ;
		}

		else {
			ammo = 1000 ;
			SendClientMessage(playerid, COLOR_YELLOW, "There was an error processing your spray-can ammo. We've reset it to 1000." ) ;
		}
	}

	new query [ 256 ] ;

	if ( slot != -1 ) {

		// Because the script doesn't clear weapons replaced by weapon slots, we do it when a new gun is given to avoid doubles
		mysql_format ( mysql, query, sizeof ( query ), "DELETE FROM player_weapons WHERE character_id = %d AND weapon_id = %d",
			Character [ playerid ] [ E_CHARACTER_ID ], PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][slot ]
		 ) ;

		mysql_tquery(mysql, query);
	}

	//ResetPlayerWeapons(playerid);
	PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][slot ] = index ;
	PlayerVar [ playerid ] [ E_PLAYER_AMMO_SYNCED ][slot] =  ammo ;
	GivePlayerWeapon ( playerid, gunid, ammo ) ;
	SOLS_SetPlayerAmmo ( playerid, gunid, ammo ) ;

	return true ;
}

forward GetPlayerCustomWeapon(playerid);
public GetPlayerCustomWeapon(playerid) {

	new idx = -1 ;

	if ( playerid == INVALID_PLAYER_ID ) {

		return idx ;
	}

	for_loop ( new i, j = 13 ; i < j ; i ++ ) {
		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

		if ( idx < 0 || idx >= sizeof ( Weapon ) )  {

			continue ;
		}

		if ( Weapon [ idx ] [ E_WEAPON_GUNID ] == GetPlayerWeapon ( playerid ) ) {

			return idx ;
		}
	}

	return idx ;
}

Float: Weapon_GetAmmoDamage ( idx ) {

	new Float: amount = 0.5 ;

	new ammo = Weapon [ idx ] [ E_WEAPON_AMMO ] ;

	if ( ammo < 0 || ammo >= sizeof ( Ammo ) ) {

		print("Returning invalid amount!" ) ;
		return amount ;
	}

	switch ( Ammo [ ammo ] [ E_AMMO_CONSTANT ] ) {

		case AMMO_TYPE_NONE: amount = 0.15 ;		//	None (invalid)
		case AMMO_TYPE_A: amount = 2.5 ;		//	9x19mm Parabellum
		case AMMO_TYPE_B: amount = 4.0 ; 		//	.45 ACP	
		case AMMO_TYPE_C: amount = 7.0 ;		//	.44 Magnum		
		case AMMO_TYPE_D: amount = 5.0 ;		//	.30-06 Springfield
		case AMMO_TYPE_F: amount = 5.0 ;		//	.308 Winchester
		case AMMO_TYPE_G: amount = 7.5 ;		//	.223 Rem
		case AMMO_TYPE_H: amount = 7.5 ;		//	12 gauge	
		case AMMO_TYPE_I: amount = 3.75 ;		//	7.62?39mm	
		case AMMO_TYPE_J: amount = 4.0 ;		//	5.56x45mm	
		case AMMO_TYPE_K: amount = 9.0 ;		//  .357 SIG  // deagle
		case AMMO_TYPE_L: amount = 7.0 ;		//  FN 5.7x28mm
	}

	return amount ;
}

CMD:givegun(playerid, params[]) {

	return cmd_passgun(playerid, params);
}

Weapon_PassGunResponse(playerid, target) {

	// minigame/shakehands.pwn

	if ( ! IsPlayerConnected(target) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "The player who offered to give you the gun is not connected." );	
	}

	new idx = GetPlayerCustomWeapon(playerid) ;

	if ( idx == -1 || GetPlayerWeapon ( playerid ) == 0) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have a weapon in your hands!" );
    }

	if (IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(target))
	{
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this while they or you are in a vehicle." );
	}

 
 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		SendServerMessage( target, COLOR_ERROR, "Error", "A3A3A3",  "You aren't near the person who is giving you the gun." );
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You aren't near the person you want to give the gun to." );
    }

    if ( ! CanPlayerUseGuns(target, 8) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "Your account is too new! You can't use gun related features yet." ) ;
	}


    // Only do anim if they're close to the player to avoid abuse
    if ( IsPlayerNearPlayer ( playerid, target, 2.0 ) ) {
		SetPlayerToFacePlayer(target, playerid);
		SetPlayerToFacePlayer(playerid, target);

		ApplyAnimation(target, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
	}

	new ammo = SOLS_GetPlayerAmmo ( playerid ) ;

	if ( idx != GetPVarInt(target, "GUNREQUEST_ID" ) ) {

		SendServerMessage( target, COLOR_ERROR, "Error", "A3A3A3",  "The request sender scrolled to a different weapon. They must keep the weapon they want to pass in their hand." );
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You scrolled to a different weapon. Keep the weapon you want to pass in your hand!" );
    }

    if ( IsPlayerPaused ( playerid ) ) {

		SendServerMessage( target, COLOR_ERROR, "Error", "A3A3A3",  "The sender has tabbed out. They must remain ingame when giving the gun to avoid security issues." );
 		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't tab out when giving a gun - the anticheat may mark you as a weapon hacker otherwise." );
    }

	RemovePlayerCustomWeapon(playerid, idx ) ;
	GiveCustomWeapon ( target, idx, ammo ) ;

	new gun_name [ 32 ], string [ 128 ] ;
	Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name ) );

	format ( string, sizeof ( string ), "** %s passes their %s to %s.", ReturnPlayerNameData ( playerid, 0, true ), gun_name,  ReturnPlayerNameData ( target, 0, true ) ) ;
	ProxDetector ( playerid,15.0, COLOR_ACTION, string ) ;

	SendAdminMessage ( sprintf("[AdmMsg]: ** %s (%d) passes their %s to %s (%d).", 
    	ReturnPlayerNameData(playerid), playerid, gun_name, ReturnPlayerNameData ( target ), target));

	//NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Passed a %s (%d) (Ammo: %d) to %s (%d)", gun_name, idx, ammo, ReturnPlayerNameData ( target, 0, true ), target));
	AddLogEntry(target, LOG_TYPE_SCRIPT, sprintf("Received a %s (%d) (Ammo: %d) from %s (%d)", gun_name, idx, ammo, ReturnPlayerNameData ( playerid, 0, true ), playerid));

	return true ;
}

CMD:passgun(playerid, params[]) {

	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "/passgun [target]" );
	}

	if ( target == INVALID_PLAYER_ID ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Player isn't connected." );
	}

	if (  PlayerVar [ target ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_SENIOR)
	{
		// new: allows tier 2 and 1 to pass guns to tier 3, and tier 3 to pass guns to tier 2 and 1
		// senior admins can pass to anyone

		if (IsPlayerInMedicFaction(playerid))
		{
			return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Members of your faction cannot use this command." );
		}

		if (IsPlayerInPoliceFaction(playerid))
		{
			if (!IsPlayerInPoliceFaction(target)) 
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Police faction members cannot pass weapons to anyone outside their faction." );
			
			if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 && Character [ target ] [ E_CHARACTER_FACTIONTIER ] > 2 ) 
			{
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be at least tier 2 to be able to pass weapons." ) ;
			}
		}
	}

    if ( IsPlayerIncapacitated(target) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "Your target is incapacitated and can't accept this." ) ;
    }

	if ( ! CanPlayerUseGuns(target, 8) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Target player can't receive weapons until they have 8 playing hours." );
	}	

	if ( ! CanPlayerUseGuns(playerid, 8) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command until you have 8 playing hours." );
	}	

 	if (!IsPlayerNearPlayer(playerid, target, 6.0)) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You're not near your target." );
    }

 	if(GetPVarInt(target, "GUNREQUEST") != 0) {
 		return SendServerMessage(playerid, COLOR_ERROR, "Error", "DEDEDE", "This person already has a request wait till the time expires.");
	}	
 
    new string[144], gun_name [ 32 ] ;

	new idx = GetPlayerCustomWeapon(playerid) ;


	if ( idx == -1 || GetPlayerWeapon ( playerid ) == 0) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have a weapon in your hands!" );
    }

	Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name ) );
	new ammo = SOLS_GetPlayerAmmo ( playerid ) ;



    format(string, sizeof(string), "[Info] {777777}You have offered your {DE9B1F}%s{777777} with %d ammo to %s (This person has 30 seconds to respond).", 
    	gun_name, ammo, ReturnPlayerNameData(target, 0, true));

    SendClientMessage(playerid, 0xAAFF00FF, string);

    format(string, sizeof(string), "[Info] {777777}%s (%d) has offered you their {DE9B1F}%s{777777} with %d ammo.",
    	ReturnPlayerNameData(playerid, 0, true), playerid, gun_name, ammo );

    SendClientMessage(target, 0xAAFF00FF, string);
    SendClientMessage(target, 0xAAFF00FF, "Type \"/accept gun\" to cooperate (you have 30 seconds to respond).");

	SendClientMessage(playerid, COLOR_YELLOW, "Friendly reminder: this won't stack ammo with the gun you already have." ) ;
	SendClientMessage(target, COLOR_YELLOW, "Friendly reminder: this won't stack ammo with the gun you already have." ) ;

    SetPVarInt(target, "GUNREQUEST", 1);
    SetPVarInt(target, "GUNREQUEST_TARGET", playerid);
    SetPVarInt(target, "GUNREQUEST_ID", idx);

    defer PassRequestExpire(target, playerid);
			       
	return true ;
}
timer PassRequestExpire[30000](playerid, targetid) {

	// playerid = player who has request
	// targetid = player who sent request

	if(GetPVarInt(playerid, "GUNREQUEST") == 1)
	{
	    SendClientMessage(playerid, -1, "{AAFF00}[Info] {777777}Your gun pass request has expired.");
	    SendClientMessage(targetid, -1, "{AAFF00}[Info] {777777}Your gun pass request has expired.");
	    SetPVarInt(playerid, "GUNREQUEST", 0);
    	SetPVarInt(playerid, "GUNREQUEST_TARGET", INVALID_PLAYER_ID);
	    return 1;
	}
	return 1;
}

CMD:loadgun(playerid, params[]) {

	return cmd_reload(playerid, params);
}
CMD:reload(playerid, params[]) {

	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new idx = GetPlayerCustomWeapon(playerid) ;

	if ( idx == -1 ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Ammo", "A3A3A3",  "You must have a weapon equipped in your hands!" );
	}

	// Fetches slot automatically... Leaves less time for the player!
	new amount ;

	if ( sscanf ( params, "i", amount ) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "/reload [amount-of-bullets]" );
	}

	if ( amount < 0 ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "Why the fuck would you /reload negative ammo? Are you retarded?" );
	}
	
	new string[128], ammo, ammo_name [ 64 ] ;

	switch ( Weapon [ idx ] [ E_WEAPON_AMMO ] ) {
		case 0: {
			return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "This weapon doesn't have ammo!" );
		}

		case 1: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_A ] < amount ) {

				Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;
				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_A ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_A ) {

					Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_A ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 2: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_B ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_B ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_B ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_B ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 3: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_C ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_C ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_C ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_C ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 4: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_D ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_D ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_D ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_D ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 5: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_F ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_F ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_F ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_F ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 6: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_G ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_G ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_G ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_G ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 7: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_H ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_H ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_H ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_H ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 8: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_I ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_I ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_I ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_I ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
		case 9: {
			if ( Character [ playerid ] [ E_CHARACTER_AMMO_J ] < amount ) {

				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have this many bullets from this ammo type!" );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_J ] >= amount ) {

				if ( Weapon [ idx ] [ E_WEAPON_AMMO ] != AMMO_TYPE_J ) {

					Weapon_GetAmmoName (idx, ammo_name, sizeof ( ammo_name ) ) ;
					format ( string, sizeof ( string ), "The bullet type you're trying to store isn't for this weapon. You need %s shells.", ammo_name );
					return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
				}

				Character [ playerid ] [ E_CHARACTER_AMMO_J ] -= amount ;

				ammo = SOLS_GetPlayerAmmo ( playerid ) ;
				ammo += amount ;

				GiveCustomWeapon ( playerid, idx, amount ) ;
				SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], ammo ) ;
			}
		}
	}

	new gun_name [ 64 ] ;

	Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;
	Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name ) ) ;

	
	ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("** %s reloads their %s with %d %s bullets.", 
			ReturnPlayerNameData ( playerid, 0, true ), gun_name, amount, ammo_name ) );

	Ammo_SaveForPlayer ( playerid ) ;


	PlayReloadAnimation(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ] ) ;

	return true ;
}

CMD:myammo(playerid, params[]) {


	SendClientMessage(playerid, COLOR_RED, "List of owned ammo" ) ;	
	
	new string [ 64 ] ;

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_A ] ) {
		format ( string, sizeof ( string ), "[Slot 0]: [9x19mm Parabellum: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_A ]);
		SendClientMessage(playerid, 0xDEDEDEFF, string );
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_B ] ) {
		format ( string, sizeof ( string ), "[Slot 1]: [.45 ACP: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_B ] ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_C ] ) {
		format ( string, sizeof ( string ), "[Slot 2]: [.44 Magnum: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_C ] ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_D ] ) {
		format ( string, sizeof ( string ), "[Slot 3]: [.30-06 Springfield: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_D ] ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_F ] ) {
		format ( string, sizeof ( string ), "[Slot 4]: [.308 Winchester: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_F ] ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_G ] ) {
		format ( string, sizeof ( string ), "[Slot 5]: [.223 Rem: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_G ] ) ;

		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_H ] ) {
		format ( string, sizeof ( string ), "[Slot 6]: [12 gauge: %d bullets] ", Character [ playerid ] [ E_CHARACTER_AMMO_H ]) ;

		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_I ] ) {
		format ( string, sizeof ( string ), "[Slot 7]: [7.62?39mm: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_I ]) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}

	if ( Character [ playerid ] [ E_CHARACTER_AMMO_J ] ) {
		format ( string, sizeof ( string ), "[Slot 8]: [5.56x45mm: %d bullets]", Character [ playerid ] [ E_CHARACTER_AMMO_J ] ) ;
		SendClientMessage(playerid, 0xDEDEDEFF, string);
	}


	return true ;
}

CMD:giveammo(playerid, params[]) {

	return cmd_passammo(playerid, params);
}

CMD:passammo(playerid, params[]) {


	// Fetches slot automatically... Leaves less time for the player!
	new targetid, slot, amount ;

	if ( sscanf ( params, "k<player>ii", targetid, slot, amount ) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "/passammo [targetid] [slot] [amount-of-bullets]" );
	}

	if ( ! IsPlayerConnected ( targetid ) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "Player isn't connected!" );
	}

	if (  PlayerVar [ targetid ] [ E_PLAYER_IS_SPECTATING ] == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }

	if ( ! CanPlayerUseGuns(targetid, 8) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Target player can't receive weapons until they have 8 playing hours." );
	}	

	if ( ! CanPlayerUseGuns(playerid, 8) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command until you have 8 playing hours." );
	}	

 	if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You're not near your target." );
    }

    if ( amount < 0 ) {

    	new string [ 128 ] ;
        format ( string, sizeof ( string ), "[AdmWarn]: (%d) %s has tried to give NEGATIVE ammo (ammo dupe: %dx) to (%d) %s.", 
    		playerid, ReturnPlayerNameData ( playerid ), amount, targetid, ReturnPlayerNameData ( targetid )   ) ;
		SendAdminWarning(string, true) ;

		SendClientMessage(playerid, COLOR_ERROR, "You can't give negative ammo. Your action has been logged and admins are notified.");

		return true ;
    }


	new string [64], ammo_name [ 32 ], idx ;

	switch ( slot ) {
		case 0: {
			idx = AMMO_TYPE_A ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_A ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_A ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_A ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_A ] += amount ;
			}
		}
		case 1: {
			idx = AMMO_TYPE_B ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_B ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_B ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_B ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_B ] += amount ;
			}
		}
		case 2: {
			idx = AMMO_TYPE_C ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_C ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_C ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_C ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_C ] += amount ;
			}
		}
		case 3: {
			idx = AMMO_TYPE_D ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_D ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_D ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_D ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_D ] += amount ;
			}
		}
		case 4: {
			idx = AMMO_TYPE_F ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_F ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_F ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_F ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_F ] += amount ;
			}
		}
		case 5: {
			idx = AMMO_TYPE_G ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_G ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_G ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_G ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_G ] += amount ;
			}
		}

		case 6: {
			idx = AMMO_TYPE_H ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_H ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_H ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_H ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_H ] += amount ;
			}
		}
		case 7: {
			idx = AMMO_TYPE_I ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_I ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_I ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_I ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_I ] += amount ;
			}
		}
		case 8: {
			idx = AMMO_TYPE_J ;
			Ammo_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;

			if ( Character [ playerid ] [ E_CHARACTER_AMMO_J ] < amount ) {

				format ( string, sizeof ( string ), "You don't have this many %s bullets!", ammo_name  );
				return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  string );
			}

			else if ( Character [ playerid ] [ E_CHARACTER_AMMO_J ] >= amount ) {

				Character [ playerid ] [ E_CHARACTER_AMMO_J ] -= amount ;
				Character [ targetid ] [ E_CHARACTER_AMMO_J ] += amount ;
			}
		}

		default: {

			return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "Only slots 0-8!" );
		}
	}

	ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("** %s passes %s %d %s bullets.", ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( targetid, 0, true ), amount, ammo_name ) );

	Ammo_SaveForPlayer ( playerid ) ;
	Ammo_SaveForPlayer ( targetid ) ;

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Passed %d x %s Ammo to %s (%d)", amount, ammo_name,  ReturnPlayerNameData ( targetid, 0, true ), targetid), true);
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Received %d x %s Ammo from %s (%d)", amount, ammo_name,  ReturnPlayerNameData ( playerid, 0, true ), playerid), true);
	return true ;
}

CMD:checkguns(playerid, params[])
{
	new targetid;

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You don't have access to this command." );
	}

	if ( sscanf ( params, "k<player>", targetid ) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "/checkguns [player]" );
	}

	if ( ! IsPlayerConnected ( targetid ) ) {
		return SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "Player isn't connected!" );
	}

	SendClientMessage(playerid, COLOR_RED, sprintf("List of weaponry on (%d) %s (server side):", targetid, ReturnPlayerNameData ( targetid )  )) ;

	new gunid, ammo, idx, ammo_name [ 32 ] ;

	for_loop ( new i, j = 12 ; i < j ; i ++ ) {

		idx = PlayerVar [ targetid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;
		GetPlayerWeaponData(targetid, i, gunid, ammo ) ;
		if ( idx != 0 ) {

			Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;
			SendClientMessage(playerid, COLOR_GD, sprintf("[Slot %d]{DEDEDE} (id %d) %s with %d ammo (%s) (server ammo: %d).", 
				GetWeaponSlot(Weapon [ idx ] [ E_WEAPON_GUNID ]), idx, Weapon [ idx ] [ E_WEAPON_DESC ], ammo, ammo_name, PlayerVar [ targetid ] [ E_PLAYER_AMMO_SYNCED ] [ i ] ) ) ;
		}

		else continue ;
	}

	return true;
}

CMD:myguns(playerid, params[]) {

	SendClientMessage(playerid, COLOR_RED, "List of your weaponry ( on your person ):" ) ;

	new gunid, ammo, idx, ammo_name [ 32 ] ;

	for_loop ( new i, j = 12 ; i < j ; i ++ ) {

		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;
		GetPlayerWeaponData(playerid, i, gunid, ammo ) ;
		if ( idx != 0 && ammo > 0 ) {

			Weapon_GetAmmoName ( idx, ammo_name, sizeof ( ammo_name ) ) ;
			SendClientMessage(playerid, COLOR_GD, sprintf("[Slot %d]{DEDEDE} (id %d) %s with %d ammo (%s).", 
				GetWeaponSlot(Weapon [ idx ] [ E_WEAPON_GUNID ]), idx, Weapon [ idx ] [ E_WEAPON_DESC ], ammo, ammo_name ) ) ;
		}

		else continue ;
		// For use with /setaw.

	}


	SendClientMessage(playerid, COLOR_YELLOW, "To see your ammo, use /myammo. For packages, use /gunpackages.");

	return true ;
}
Anticheat_RefundApprovedGuns(playerid) {
	new idx  ;

	// Give back their guns.
	for_loop ( new i, j = MAX_WEAPON_SLOTS; i < j ; i ++ ) {
		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

		if ( idx != -1 && idx != 0 ) {

			GivePlayerWeapon(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] ) ;
			SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] ) ; // hard setting ammo
		}

		PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] = 0 ;
	}
}


Anticheat_SaveApprovedGuns(playerid) {
	new idx, temp_gun, ammo ;

	for_loop ( new i, j = MAX_WEAPON_SLOTS; i < j ; i ++ ) {
		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

		GetPlayerWeaponData(playerid, i, temp_gun, ammo) ;

		if ( Weapon [ idx ] [ E_WEAPON_GUNID ] == temp_gun ) {

			PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] = ammo ;
			if ( idx != 0 ) {

				printf("[ANTICHEAT] Found weapon ID %d (server %d) on player %d with %d ammo. Storing!", idx, temp_gun, playerid, ammo ) ;
			}

		}
	}
}

static WeaponACStr[512];

Weapon_AnticheatCheck(playerid) {

	if ( ! IsPlayerSpawned ( playerid ) ) {

		return true ;
	}

	if ( IsPlayerPaused ( playerid ) ) {

		return true ;
	}

	new gunid = GetPlayerWeapon ( playerid ) ;
	new slot = GetWeaponSlot ( gunid ) ;

	switch ( gunid ) {

		case 0, 1 : {
			return true ;
		}
	}

	new idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ slot ] ;

	if ( idx == -1  || idx >= sizeof ( Weapon )) {

		idx = 0 ;
	}
 
	if ( gunid == WEAPON_SPRAYCAN || gunid == WEAPON_PARACHUTE ) {

		return true ;
	}

	if ( gunid != Weapon [ idx ] [ E_WEAPON_GUNID ] ) 
	{
		// If tick has been active for 5 seconds
	    if ( PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_TICK ] >= gettime()) {

            format ( WeaponACStr, sizeof ( WeaponACStr ), "[AdmWarn]: (%d) %s's client weapon doesn't match their server weapon. Removing weapon [%d/3]. [Client: %d] [Server %d:%d]", 
            	playerid, ReturnPlayerNameData ( playerid ), PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING ], GetPlayerWeapon ( playerid ), idx, Weapon [ idx ] [ E_WEAPON_GUNID ]  ) ;
    		SendAdminWarning(WeaponACStr) ;

    		//ResetPlayerWeapons(playerid);
    		AC_RemovePlayerWeapon(playerid, GetPlayerWeapon ( playerid ));

    		if ( ++ PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING ] >= 3 ) {

    			// Player has sent 9 warnings so far! Ban the fucker!
    			if ( PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING_EXTRA ] >= 3 ) 
				{
  					PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING_EXTRA ] = 0 ;
    				PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING ] = 0 ;

					new reason [ 64 ], hours = 99999, secs = hours * 3600, unbants = gettime() + secs;

 					format ( WeaponACStr, sizeof ( WeaponACStr ), "[AdmWarn]: (%d) %s has been banned for weapon hacks (client: %d, server: %d:%d).", playerid, ReturnPlayerNameData ( playerid ), GetPlayerWeapon ( playerid), idx, Weapon [ idx ] [ E_WEAPON_GUNID ]  ) ;
		            SendAdminWarning(WeaponACStr, true) ;

		            format ( reason, sizeof ( reason ), "Anticheat Detection: Weapon Hacks" ) ;
		            SetAdminRecord ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], -1337, ARECORD_TYPE_BAN, reason, -1, ReturnDateTime () ) ;
		            
		            mysql_format(mysql, WeaponACStr, sizeof(WeaponACStr), "INSERT INTO bans (account_id, account_name, account_ip, ban_admin, ban_reason, ban_time, unban_time) VALUES (%d, '%e', '%e', '%e', '%e', %d, %d)",
		            Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], ReturnIP ( playerid ), "Anticheat", reason, gettime(), unbants);
		            mysql_tquery(mysql, WeaponACStr);

		            SendRconCommand(sprintf("banip %s", ReturnIP ( playerid )));
		            KickPlayer ( playerid ) ;               
		        }

		        else {

			        format ( WeaponACStr, sizeof ( WeaponACStr ), "[AdmWarn]: (%d) %s's has gotten %d/3 warnings. Hard resetting & restoring ALL their weapons now! [Client weapon: %d] [Server: %d:%d]", 
			            playerid, ReturnPlayerNameData ( playerid ), PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING ], GetPlayerWeapon ( playerid), idx, Weapon [ idx ] [ E_WEAPON_GUNID ]  ) ;
			    	SendAdminWarning(WeaponACStr, true) ;

			        Anticheat_SaveApprovedGuns(playerid);
			        ResetPlayerWeapons(playerid);
			        Anticheat_RefundApprovedGuns(playerid);

			        PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING_EXTRA ] ++ ;
			        PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_WARNING ] = 0 ;
			    }
    		}

    		return true ;
        }

        PlayerVar [ playerid ] [ E_PLAYER_GUN_AC_TICK ] = gettime () + 2 ;
	}

	return true ;
}

CMD:customgunlist(playerid, params[]) {

	Weapons_ShowList(playerid);

	return true ;
}

Weapons_ShowList (playerid ) {


	if ( PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] = 1 ;
	}


	// Pagination stuff
	new MAX_ITEMS_ON_PAGE = 10, string [ 1024 ], bool: nextpage ;
    new resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;


    new ammo_name [ 32 ] ;
    strcat(string, "ID\tReplacement\t Weapon \t Ammo\n");

    for_loop ( new i = resultcount, j = sizeof ( Weapon ); i < j; i ++ ) {

		resultcount ++ ;

        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] ) {

        	Weapon_GetAmmoName ( i, ammo_name, sizeof ( ammo_name ) ) ;
			format(string, sizeof(string), "%s%d \t %s \t %s \t %s \n", string, 
				i, Weapon_GetName ( playerid, Weapon [ i ] [ E_WEAPON_GUNID ] ), Weapon [ i ] [ E_WEAPON_DESC ], ammo_name ); 
        }

     	if ( resultcount >= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] ) {

            nextpage = true;
            break;
        }
	}

	new pages = floatround ( resultcount / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1 ;

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }

	inline weapon_show_list(pid, dialogid, response, listitem, string: inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;

		if ( ! response ) {

			if ( PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] -- ;
				return Weapons_ShowList ( playerid ) ;
			}

			else return true ;
		}

		if ( response ) {

			if ( listitem >= MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] ++ ;
				return Weapons_ShowList (playerid ) ;
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {


				SendClientMessage(playerid, COLOR_RED, "Gun Crafting Info:" ) ;

        		Weapon_GetAmmoName ( selection, ammo_name, sizeof ( ammo_name ) ) ;
				SendClientMessage(playerid, COLOR_YELLOW, sprintf("[ID: %d] [Name: \"%s\"] [Ammo:] \"%s\"] [Clip size: %d]", 
					selection,
					Weapon [ selection ] [ E_WEAPON_DESC ], 
					ammo_name, 
					Weapon [ selection ] [ E_WEAPON_CLIP_SIZE ] 
				) ) ;

				SendClientMessage(playerid, COLOR_YELLOW, sprintf("[Wood: %d] [Metal: %d] [Parts: %d] [Time: %d]",
					Weapon [ selection ] [ E_WEAPON_WOOD ], Weapon [ selection ] [ E_WEAPON_METAL ], 
					Weapon [ selection ] [ E_WEAPON_PARTS ], Weapon [ selection ] [ E_WEAPON_TIME ]
				 ) ) ;

 				return true ;
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ] > 1 ) {
		Dialog_ShowCallback ( playerid, using inline weapon_show_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Custom Weapons: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ], pages), string, "Select", "Previous" ) ;
	}

	else Dialog_ShowCallback ( playerid, using inline weapon_show_list, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Custom Weapons: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_GUNLIST_PAGE ], pages), string, "Select", "Back" ) ;

	// SendClientMessage(playerid, COLOR_YELLOW, "If you want to know the gun ID, use the \"ID\" row from this list!" ) ;

	return true ;
}