

RemovePlayerCustomWeapon(playerid, idx ) {

	new query [ 384 ] ;

	for_loop ( new i, j = MAX_WEAPON_SLOTS, index ; i < j ; i ++ ) {
		index = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;
		if ( index == idx ) {

			mysql_format(mysql, query, sizeof(query), "DELETE FROM player_weapons WHERE weapon_id = %d AND character_id = %d", idx, Character [ playerid ] [ E_CHARACTER_ID ] ) ;
		    mysql_tquery(mysql, query );

			AC_RemovePlayerWeapon(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ] ) ;
			SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], 0);
			PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] = 0 ;

			break;
		}
		else continue ;
	}
}

Weapon_ResetPlayerWeapons(playerid) {

	new query[384] ;

	// Clearing the database to make sure that invalid guns are gone.
	mysql_format(mysql, query, sizeof(query), "DELETE FROM player_weapons WHERE character_id = %d", Character [ playerid ] [ E_CHARACTER_ID ] ) ;
    mysql_tquery(mysql, query );


	for_loop ( new i, j = MAX_WEAPON_SLOTS ; i < j ; i ++ ) {

		PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] = 0 ;
	}

    ResetPlayerWeapons(playerid);
}

Weapon_SavePlayerWeapons(playerid) 
{
	if (!PlayerVar[playerid][E_PLAYER_WEAPONS_LOADED])
	{
		// Don't need to save a players weapons if they haven't first been loaded :)
		printf("Skipping saving weapons for (%d) %s (Char ID: %d) as they weren't loaded in the first place.", playerid, SOLS_PlayerName(playerid), Character[playerid][E_CHARACTER_ID]);
		return false;
	}

	new ammo, idx, query[256], amount;

	if ( PlayerVar [ playerid ] [ E_PLAYER_DRIVEBY_BRASSKNUCKLES ] ) {
		PlayerVar [ playerid ] [ E_PLAYER_DRIVEBY_BRASSKNUCKLES ]  = false ;
		PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ 0 ] = 1 ;
	}

	for_loop ( new i, j = MAX_WEAPON_SLOTS ; i < j ; i ++ ) 
	{
		idx = PlayerVar[playerid][E_PLAYER_WEAPON_EQUIPPED][i];
		ammo = PlayerVar[playerid][E_PLAYER_AMMO_SYNCED][i];
		
		if (idx > 0) 
		{
			amount ++;
	    	mysql_format(mysql, query, sizeof(query), "INSERT INTO player_weapons VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE weapon_ammo = %d;", Character [ playerid ] [ E_CHARACTER_ID ], idx, ammo, ammo);
	    	mysql_pquery(mysql, query); // parallel queries
			//print(query);
	  	}

		else continue ;
	}

	// printf("CloseConnection: Saving %d weapons for (%d) %s (Char ID: %d)", amount, playerid, TEMP_ReturnPlayerName(playerid), Character [ playerid ] [ E_CHARACTER_ID ]);
	return true;
}

timer Weapon_LoadPlayerWeapons[2500](playerid) 
{
	if (!IsPlayerSpawned(playerid) || !IsPlayerPlaying(playerid) || PlayerVar[playerid][E_PLAYER_WEAPONS_LOADED] || Character[playerid][E_CHARACTER_AJAIL_TIME] > 0)
	{
		// Don't need to load weapons if the player is not playing, not spawned, already loaded or in ajail
		// SendClientMessage(playerid, -1, "TEST: The server declined to load your saved weapons (if any).");
		PlayerVar[playerid][E_PLAYER_WEAPONS_LOADED] = true;
		return false;
	}

	ResetPlayerWeapons(playerid);

    new
        index,
        ammo,
        query[256],
		gun_name[64]
    ;

	inline Server_OnDataLoad() 
	{
		new rows, fields, count;
        cache_get_data(rows, fields, mysql);

	    for_loop(new i, j = rows; i < j; i++) // loop through all the rows that were found
	    {
			index = cache_get_field_int (i, "weapon_id");
			ammo = cache_get_field_int (i, "weapon_ammo");		
	        
	        if(!(0 <= index < sizeof ( Weapon ) ) ) // check if weapon is valid (should be)
	        {
	            printf("[warning] OnLoadPlayerWeapons (%d: %s) - Unknown weaponid '%d'. Skipping.", playerid, TEMP_ReturnPlayerName(playerid), index);
	            continue;
	        }

			if (ammo < 1)
			{
				printf("[warning] OnLoadPlayerWeapons (%d: %s) - Invalid ammo (%d) for weaponid '%d'. Skipping.", playerid, TEMP_ReturnPlayerName(playerid), ammo, index);
	            continue;
			}

			if (index == 67)
			{
				// skip pd deagle if not in a police faction, or not on duty as arson
				if (!IsPlayerInPoliceFaction(playerid) && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_ARSON, FACTION_TYPE_EMS, true) && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_DAO, FACTION_TYPE_GOV))
				{
					printf("[warning] OnLoadPlayerWeapons (%d: %s) - Not in faction/on duty for weaponid '%d'. Skipping.", playerid, TEMP_ReturnPlayerName(playerid), index);
					continue;
				}
			}

	        GiveCustomWeapon(playerid, index, ammo ) ;
			Weapon_GetGunName(index, gun_name, sizeof(gun_name ));
			AddLogEntry(playerid, LOG_TYPE_GAME, sprintf("Loaded into the game with a %s (%d) (Ammo: %d)", gun_name, index, ammo), true);
			
			count ++;
	    }

		if (count)
		{
			SetPlayerArmedWeapon(playerid, 0);
			if (count == 1) SendServerMessage(playerid, COLOR_INFO, "Weapons", "A3A3A3", sprintf("%d saved weapon was loaded and given to you.", count));
			else SendServerMessage(playerid, COLOR_INFO, "Weapons", "A3A3A3", sprintf("%d saved weapons were loaded and given to you.", count));
			printf("[weapons load] Restored %d saved weapons for (%d) %s (Char: %d)", count, playerid, SOLS_PlayerName(playerid), Character [ playerid ] [ E_CHARACTER_ID ]);
		}
		else
		{
			AddLogEntry(playerid, LOG_TYPE_GAME, "Loaded into the game.", true);
		}
	}

	mysql_format(mysql, query, sizeof(query), "SELECT weapon_id, weapon_ammo FROM player_weapons WHERE character_id = %d", Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery_inline ( mysql, query, using inline Server_OnDataLoad, "" ) ;

	// Stop weapons being loaded again now that they've been loaded :)
	PlayerVar[playerid][E_PLAYER_WEAPONS_LOADED] = true;

    return true;
}

Weapon_ConvertSkillLevel(skill, level)
{
	new converted = 0;

	if (level == 1)
	{
		if (skill == WEAPONSKILL_PISTOL) converted = 40;
		else if (skill == WEAPONSKILL_PISTOL_SILENCED) converted = 500;
		else if (skill == WEAPONSKILL_DESERT_EAGLE) converted = 200;
		else if (skill == WEAPONSKILL_SHOTGUN || skill == WEAPONSKILL_SAWNOFF_SHOTGUN || skill == WEAPONSKILL_SPAS12_SHOTGUN) converted = 200;
		else if (skill == WEAPONSKILL_MICRO_UZI) converted = 50;
		else if (skill == WEAPONSKILL_MP5) converted = 250;
		else if (skill == WEAPONSKILL_AK47 || skill == WEAPONSKILL_M4) converted = 200;
		else if (skill == WEAPONSKILL_SNIPERRIFLE) converted = 300;
	}
	else if (level > 1) converted = 999;

	return converted;
}

Weapon_SetSkillLevel(playerid) 
{
	if (IsPlayerInPoliceFaction(playerid) || IsPlayerInDEAFaction(playerid))
	{
		if (Character[playerid][E_CHARACTER_SKILL_SHOTGUN] < 1) Character[playerid][E_CHARACTER_SKILL_SHOTGUN] = 1;
		if (Character[playerid][E_CHARACTER_SKILL_SPAZ] < 1) Character[playerid][E_CHARACTER_SKILL_SPAZ] = 1;
		if (Character[playerid][E_CHARACTER_SKILL_MP5] < 1) Character[playerid][E_CHARACTER_SKILL_MP5] = 1;
		if (Character[playerid][E_CHARACTER_SKILL_M4] < 1) Character[playerid][E_CHARACTER_SKILL_M4] = 1;
		if (Character[playerid][E_CHARACTER_SKILL_AK47] < 1) Character[playerid][E_CHARACTER_SKILL_AK47] = 1;
	}

	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 			Weapon_ConvertSkillLevel(WEAPONSKILL_PISTOL, Character[playerid][E_CHARACTER_SKILL_PISTOL]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 	Weapon_ConvertSkillLevel(WEAPONSKILL_PISTOL_SILENCED, Character[playerid][E_CHARACTER_SKILL_SDPISTOL]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 	Weapon_ConvertSkillLevel(WEAPONSKILL_DESERT_EAGLE, Character[playerid][E_CHARACTER_SKILL_DEAGLE]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 			Weapon_ConvertSkillLevel(WEAPONSKILL_SHOTGUN, Character[playerid][E_CHARACTER_SKILL_SHOTGUN]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 	Weapon_ConvertSkillLevel(WEAPONSKILL_SAWNOFF_SHOTGUN, Character[playerid][E_CHARACTER_SKILL_SAWNOFF]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 	Weapon_ConvertSkillLevel(WEAPONSKILL_SPAS12_SHOTGUN, Character[playerid][E_CHARACTER_SKILL_SPAZ]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 		Weapon_ConvertSkillLevel(WEAPONSKILL_MICRO_UZI, Character[playerid][E_CHARACTER_SKILL_UZI]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 				Weapon_ConvertSkillLevel(WEAPONSKILL_MP5, Character[playerid][E_CHARACTER_SKILL_MP5]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 			Weapon_ConvertSkillLevel(WEAPONSKILL_AK47, Character[playerid][E_CHARACTER_SKILL_AK47]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 				Weapon_ConvertSkillLevel(WEAPONSKILL_M4, Character[playerid][E_CHARACTER_SKILL_M4]));	
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 		Weapon_ConvertSkillLevel(WEAPONSKILL_SNIPERRIFLE, Character[playerid][E_CHARACTER_SKILL_SNIPER]));
}