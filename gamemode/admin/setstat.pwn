CMD:setstat(playerid, params[]) { // player

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}


	new choice[32], targetid, input ;

	if ( sscanf ( params, "s[32]k<player>i", choice, targetid, input ) ) {

		SendClientMessage(playerid, COLOR_RED, "/setstat [option] [targetid] [input]");
		SendClientMessage(playerid, COLOR_YELLOW, "STATS: mask / donator / phone / hours / license / donator / level");
		SendClientMessage(playerid, COLOR_YELLOW, "SKILL: pistol / sdpistol / deagle / shotgun / sawnoff / spas12 / uzi / mp5 / ak47 / m4 / sniper");
		return true ;
	}

	if ( ! IsPlayerConnected(targetid)) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "Target isn't connected.") ;
	}
	new query [ 256 ], buffer [ 64 ] ;

	// Changes the level (temporarily) of the player
	if ( ! strcmp(choice, "level", true)) 
	{
		Character [ targetid ] [ E_CHARACTER_LEVEL ] = input ;
		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_level=%d WHERE player_id=%d", Character [ targetid ] [ E_CHARACTER_LEVEL ], Character [ targetid ] [ E_CHARACTER_ID ]);
		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the Level of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Level was set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}

	// Changes the mask ID of the player
	else if ( ! strcmp(choice, "mask", true)) {

		Character [ targetid ] [ E_CHARACTER_MASKID ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_maskid = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_MASKID ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the Mask ID of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Mask ID was set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}

	// Changes the donator level of the player
	else if ( ! strcmp(choice, "donator", true)) {
	
		if ( input < 0 || input > 7 ) {

			SendClientMessage(playerid, COLOR_RED, "Donator values: 0: Regular Player, 1: Early Supporter, 2: Bronze Player, 3: Silver Player");
			return SendClientMessage(playerid, COLOR_RED, "4: Gold Player, 5: Sapphire Supporter, 6: Emerald Player, 7: Ruby Player");
		}

		Account [ targetid ] [ E_PLAYER_ACCOUNT_PREMIUMLEVEL ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET account_premiumlevel = %d WHERE account_id = %d",
			Account [ targetid ] [ E_PLAYER_ACCOUNT_PREMIUMLEVEL ], Account [ targetid ] [ E_PLAYER_ACCOUNT_ID ] ) ;

		mysql_tquery(mysql, query);

		buffer[0]=EOS;
		GetPremiumRank ( Account [ targetid ] [ E_PLAYER_ACCOUNT_PREMIUMLEVEL ], buffer ) ;

		SendAdminCmd(playerid, sprintf("set the donator level of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Donator Level was set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}
	// Changes the phone number of the player
	else if ( ! strcmp(choice, "phone", true)) {
		Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_phnumber = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the Phone Number of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Phone Number was set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}
	else if ( ! strcmp(choice, "hours", true)) {
		Character [ targetid ] [ E_CHARACTER_HOURS ] = input ;

		SetPlayerScore(targetid, Character [ targetid ] [ E_CHARACTER_LEVEL ] ) ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_hours = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_HOURS ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the Playing Hours of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Playing Hours were set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}
	else if ( ! strcmp(choice, "license", true)) {
		Character [ targetid ] [ E_CHARACTER_DRIVERSLICENSE ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_driverslicense = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_DRIVERSLICENSE ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the Driving License of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), input));
		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your Driving License was set to %d by %s (%d).", input, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	}
	/*
	// Changes the givable respect points of the player
	else if ( ! strcmp(choice, "rppoints", true)) {
		Character [ targetid ] [ E_CHARACTER_FnR_GIVABLE ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_fnr_givable = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_FnR_GIVABLE ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's giveable rp points to %d.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_FnR_GIVABLE ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your giveable rp points to %d.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_FnR_GIVABLE  ]) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}

	// Changes the respect of the player
	else if ( ! strcmp(choice, "respect", true)) {
		Character [ targetid ] [ E_CHARACTER_RESPECT ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_respect = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_RESPECT ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's respect to %d.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_RESPECT ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your respect to %d.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_RESPECT ] ) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}
	// Changes the fear of the player
	else if ( ! strcmp(choice, "fear", true)) {
		Character [ targetid ] [ E_CHARACTER_FEAR ] = input ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_fear = %d WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_FEAR ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's fear to %d.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_FEAR ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your fear to %d.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_FEAR ] ) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}
	*/
	/*
	// Changes the stamina of the player
	else if ( ! strcmp(choice, "stamina", true)) {
		Character [ targetid ] [ E_CHARACTER_STAMINA ] = float(input) ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_stamina = '%f' WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_STAMINA ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's stamina to %0.3f.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_STAMINA ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your stamina to %0.3f.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_STAMINA ] ) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}
	// Changes the muscle of the player
	else if ( ! strcmp(choice, "muscle", true)) {
		Character [ targetid ] [ E_CHARACTER_MUSCLE ] = float(input) ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_muscle = '%f' WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_MUSCLE ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's muscle to %0.3f.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_MUSCLE ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your muscle to %0.3f.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_MUSCLE ] ) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}
	// Changes the fat of the player
	else if ( ! strcmp(choice, "fat", true)) {
		Character [ targetid ] [ E_CHARACTER_FAT ] = float(input) ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_fat = '%f' WHERE player_id = %d",
			Character [ targetid ] [ E_CHARACTER_FAT ], Character [ targetid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, query);

		format ( query, sizeof ( query ), "[!!!] [AdmWarn] %s has set %s's fat to %0.3f.", 
			ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ), Character [ targetid ] [ E_CHARACTER_FAT ] ) ;

		SendAdminMessage(query) ;	

		format ( query, sizeof ( query ), "Admin %s (%d) has set your fat to %0.3f.", 
			ReturnPlayerNameData ( playerid ), playerid, Character [ targetid ] [ E_CHARACTER_FAT ] ) ;	

		SendClientMessage(targetid, COLOR_YELLOW, query);
	}	
	*/
	// Changes the outstanding fines of the player
	else if ( ! strcmp(choice, "fines", true)) {

		SendClientMessage(playerid, COLOR_YELLOW, "Not added yet.");
	}

	// Changes the wood of the player
	else if ( ! strcmp(choice, "wood", true)) {

		SendClientMessage(playerid, COLOR_YELLOW, "Not added yet.");
	}
	// Changes the metal of the player
	else if ( ! strcmp(choice, "metal", true)) {

		SendClientMessage(playerid, COLOR_YELLOW, "Not added yet.");
	}
	// Changes the parts of the player
	else if ( ! strcmp(choice, "parts", true)) {

	}

	else if ( ! strcmp(choice, "pistol", true)) SetGunStat(playerid, targetid, 0, input);
	else if ( ! strcmp(choice, "sdpistol", true)) SetGunStat(playerid, targetid, 1, input);
	else if ( ! strcmp(choice, "deagle", true)) SetGunStat(playerid, targetid, 2, input);
	else if ( ! strcmp(choice, "shotgun", true)) SetGunStat(playerid, targetid, 3, input);
	else if ( ! strcmp(choice, "sawnoff", true)) SetGunStat(playerid, targetid, 4, input);
	else if ( ! strcmp(choice, "spas12", true)) SetGunStat(playerid, targetid, 5, input);
	else if ( ! strcmp(choice, "uzi", true)) SetGunStat(playerid, targetid, 6, input);
	else if ( ! strcmp(choice, "mp5", true)) SetGunStat(playerid, targetid, 7, input);
	else if ( ! strcmp(choice, "ak47", true)) SetGunStat(playerid, targetid, 8, input);
	else if ( ! strcmp(choice, "m4", true)) SetGunStat(playerid, targetid, 9, input);
	else if ( ! strcmp(choice, "sniper", true)) SetGunStat(playerid, targetid, 10, input);


	else 
	{
		SendClientMessage(playerid, COLOR_RED, "/setstat [option] [targetid] [input]");
		SendClientMessage(playerid, COLOR_YELLOW, "STATS: mask / donator / phone / hours / license / gunlicense / donator");
		SendClientMessage(playerid, COLOR_YELLOW, "SKILL: pistol / sdpistol / deagle / shotgun / sawnoff / spas12 / uzi / mp5 / ak47 / m4 / sniper");
	}

	return true ;
}

static const SkillLevels[][10] = 
{
	"Novice",
	"Gangster",
	"Hitman"
};

static enum E_GUN_STAT
{
	E_GUN_SKILL_NAME[20],
	E_GUN_SKILL_FIELD[32],
	E_PLAYER_CHARACTER_DATA:E_GUN_SKILL_STAT
}

static const GunStat[][E_GUN_STAT] = 
{
	{ "Pistol", "player_skill_pistol",  E_CHARACTER_SKILL_PISTOL },
	{ "Silenced Pistol",	"player_skill_sdpistol", 	E_CHARACTER_SKILL_SDPISTOL },
	{ "Desert Eagle",	"player_skill_deagle", 	E_CHARACTER_SKILL_DEAGLE },
	{ "Shotgun",	"player_skill_shotgun", 	E_CHARACTER_SKILL_SHOTGUN },
	{ "Sawnoff Shotgun",	"player_skill_sawnoff", 	E_CHARACTER_SKILL_SAWNOFF },
	{ "SPAS-12",	"player_skill_spaz", 	E_CHARACTER_SKILL_SPAZ },
	{ "Micro Uzi",	"player_skill_uzi", 	E_CHARACTER_SKILL_UZI },
	{ "MP5",	"player_skill_mp5", 	E_CHARACTER_SKILL_MP5 },
	{ "AK47",	"player_skill_ak47", 	E_CHARACTER_SKILL_AK47 },
	{ "M4",	"player_skill_m4", 	E_CHARACTER_SKILL_M4 },
	{ "Sniper Rifle",	"player_skill_sniper", 	E_CHARACTER_SKILL_SNIPER }
};

SetGunStat(playerid, targetid, index, value)
{
	if (value > 2) value = 2;
	else if (value < 0) value = 0;

	new E_PLAYER_CHARACTER_DATA:var = GunStat[index][E_GUN_SKILL_STAT];
	Character[targetid][var] = value;
	
	new query[128];
	mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `%s` = %d WHERE player_id = %d", GunStat[index][E_GUN_SKILL_FIELD], value, Character[targetid][E_CHARACTER_ID]);
	mysql_tquery(mysql, query);

	SetPlayerSkillLevel(targetid, index, Weapon_ConvertSkillLevel(index, value));

	//AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Set the %s skill of %s to %d", GunStat[index][E_GUN_SKILL_NAME], ReturnPlayerNameData(targetid), value));
	AddLogEntry(targetid, LOG_TYPE_ADMIN, sprintf("Had their %s skill set to %d by %s", GunStat[index][E_GUN_SKILL_NAME], value, ReturnPlayerNameData(playerid)));

	SendAdminCmd(playerid, sprintf("set the %s skill of (%d) %s to %d", GunStat[index][E_GUN_SKILL_NAME], targetid, ReturnPlayerNameData(targetid), value));
	SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your %s skill was set to %d by %s (%d).", GunStat[index][E_GUN_SKILL_NAME], value, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
	
	return true;
}

/*
CMD:setcar(playerid, params[]) { // car

	#warning Player must be in car.

	// Changes the model of the vehicle
	if ( ! strcmp(params, "model", true)) {

	}

	// Changes the license plate of the vehicle
	else if ( ! strcmp(params, "plate", true)) {

	}

	// Changes the type of the vehicle
	else if ( ! strcmp(params, "type", true)) {

	}

	// Changes the owner of the vehicle
	else if ( ! strcmp(params, "owner", true)) {

	}

	// Changes the siren of the vehicle
	else if ( ! strcmp(params, "siren", true)) {

	}

	// Changes the jobid of the vehicle
	else if ( ! strcmp(params, "jobid", true)) {

	}

	// Changes the neon of the vehicle
	else if ( ! strcmp(params, "neon", true)) {

	}

	else {
		SendClientMessage(playerid, -1, "/setcar [option]");
		SendClientMessage(playerid, -1, "Available options: model / plate / type / owner / siren / jobid / neon");
	}
}

CMD:viewstats(playerid, params[]) {
	#warning Finish this and all of the above.

	return true ;
}*/