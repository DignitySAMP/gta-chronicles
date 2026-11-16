CMD:searchplate(playerid, params[]) {
    
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInTicketFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true) && !IsPlayerGovRecords(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new licenseplate [ 32 ] ;

	if ( sscanf ( params, "s[32]", licenseplate ) ) 
	{
		// New: automatically check for nearby car (that the player isn't in) and use it if no plate is specified
		new Float:x, Float:y, Float:z, playerveh = GetPlayerVehicleID(playerid), world = GetPlayerVirtualWorld(playerid);
		new closest = INVALID_VEHICLE_ID, Float:current, Float:last = 10.0; // 10.0 radius for /searchplate
		
		GetPlayerPos(playerid, x, y, z);
		GetXYInFrontOfPlayer(playerid, x, y, 2.0);

		for (new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
		{
			if (!IsValidVehicle(i)) continue;
			if (playerveh == i) continue;
			if (GetVehicleVirtualWorld(i) != world) continue;

			current = GetVehicleDistanceFromPoint(i, x, y, z);

			if (current < last)
			{
				closest = i;
				last = current;
			}
		}

		if (closest == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "/searchplate [number-plate]");
		
		new veh_enum_id = Vehicle_GetEnumID(closest);
		if (veh_enum_id == -1) return SendClientMessage(playerid, -1, "/searchplate [number-plate]");
		format(licenseplate, sizeof(licenseplate), "%s", Vehicle[veh_enum_id][E_VEHICLE_LICENSE]);
	}

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s ran a vehicle check on \"%s\" }", 
			Faction[faction_enum_id][E_FACTION_ABBREV], playerid, ReturnPlayerNameData(playerid, 0, true), licenseplate), faction_enum_id, false ) ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"SELECT `player_name`, `account_name`, `vehicle_type`, `vehicle_owner`, `vehicle_modelid`, `vehicle_license`, `vehicle_color_a`, `vehicle_impounded`, `vehicle_impound_cost` FROM `vehicles` LEFT JOIN `characters` ON `characters`.`player_id` = `vehicles`.`vehicle_owner` LEFT JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `vehicle_license` LIKE '%e'", licenseplate ) ;

	SendClientMessage(playerid, COLOR_BLUE, sprintf("Vehicle Database result for '%s':", licenseplate));

	new veh_model, veh_plate [ 32 ], veh_owner, veh_charname [ MAX_PLAYER_NAME ], veh_accountname [ MAX_PLAYER_NAME ], account_id = -1, veh_color, veh_type, veh_impounded, veh_impound_cost;
	#pragma unused account_id

	new owner_name [ 96 ] ; 

	inline Vehicle_FetchRegistry() 
	{
		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if (!rows)
		{
			return SendClientMessage(playerid, 0xDEDEDEFF, "No vehicles found for this plate.");
		}

		for_loop ( new i; i < rows; i ++ ) 
		{ 
			veh_model = cache_get_field_int (i, "vehicle_modelid") ;
			veh_color = cache_get_field_int (i, "vehicle_color_a") ;
			veh_type = cache_get_field_int (i, "vehicle_type") ;
			veh_impounded = cache_get_field_int (i, "vehicle_impounded") ;
			veh_impound_cost = cache_get_field_int (i, "vehicle_impound_cost") ;
			veh_owner = cache_get_field_int (i, "vehicle_owner") ;
			
			cache_get_field_content ( i, "vehicle_license", veh_plate, mysql, 32 ) ;
			cache_get_field_content ( i, "player_name", veh_charname, mysql, MAX_PLAYER_NAME ) ;
			cache_get_field_content ( i, "account_name", veh_accountname, mysql, MAX_PLAYER_NAME ) ;

			switch ( veh_type ) {

				case E_VEHICLE_TYPE_RENTAL: format ( owner_name, sizeof ( owner_name), "{90CAF9}Rental {FFFFFF}((Government))" ) ;
				case E_VEHICLE_TYPE_JOB: format ( owner_name, sizeof ( owner_name), "{90CAF9}Business{FFFFFF} ((Job))" ) ;
				case E_VEHICLE_TYPE_DMV: format ( owner_name, sizeof ( owner_name), "{90CAF9}DMV{FFFFFF}((Government))" ) ;
				
				case E_VEHICLE_TYPE_FACTION:
				{
					format(owner_name, sizeof(owner_name), "{90CAF9}%s{FFFFFF} ((Faction))", "Organization");
					new veh_faction_enum_id = -1;

					for_loop(new f, j = sizeof ( Faction ); f < j ; f ++) 
					{
						if (Faction[f][E_FACTION_ID] != INVALID_FACTION_ID && Faction[f][E_FACTION_ID] == veh_owner)
						{
							veh_faction_enum_id = f;
							break;
						}
					}

					if (veh_faction_enum_id != -1 && strcmp(Faction[veh_faction_enum_id][E_FACTION_NAME], "None"))
					{
						if (Faction[veh_faction_enum_id][E_FACTION_TYPE] == FACTION_TYPE_DEA) format(owner_name, sizeof(owner_name), "{90CAF9}US Government");
						else format(owner_name, sizeof(owner_name), "{90CAF9}%s", Faction[veh_faction_enum_id][E_FACTION_NAME]);
					}
				}
				
				case E_VEHICLE_TYPE_GROUP:
				{
					format(owner_name, sizeof(owner_name), "{90CAF9}%s{FFFFFF} ((Group))", "Business");

					foreach(new groupid: Groups) 
					{
						if (Group[groupid][E_GROUP_DATA_TYPE] == GROUP_TYPE_COMPANY && Group[groupid][E_GROUP_DATA_SQLID] == veh_owner) 
						{
							format(owner_name, sizeof(owner_name), "{90CAF9}%s", Group[groupid][E_GROUP_DATA_NAME]);
							break;
						}
					}
				} 

				default: format ( owner_name, sizeof ( owner_name ), "{90CAF9}%s {FFFFFF}((%s))", veh_charname, veh_accountname ) ; // player type
			}

			if (veh_impounded)
			{
				SendClientMessage(playerid, -1, sprintf("> {%s}[%d] {FFFFFF}%s (%s), Owner: %s (Impounded: $%s)", 
					VehicleColoursTableRGBA[veh_color], i+1, ReturnVehicleModelName(veh_model), veh_plate, owner_name, IntegerWithDelimiter(veh_impound_cost)) 
				) ;
			}
			else
			{
				SendClientMessage(playerid, -1, sprintf("> {%s}[%d] {FFFFFF}%s (%s), Owned By: %s", 
					VehicleColoursTableRGBA[veh_color], i+1, ReturnVehicleModelName(veh_model), veh_plate, owner_name) 
				) ;
			}
		}
	}

	mysql_tquery_inline(mysql, query, using inline Vehicle_FetchRegistry, "");

	return true ;
}

CMD:searchdata(playerid, params[]) {
    
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true) && !IsPlayerGovRecords(playerid, true) && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_ARSON, FACTION_TYPE_EMS, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new rpname [ 32 ] ;

	if ( sscanf ( params, "s[32]", rpname ) ) {

		return SendClientMessage(playerid, -1, "/searchdata [firstname_lastname] (include the underscore!)" ) ;
	}

	new query [ 512 ], display_name[32];

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `player_id`, `player_name`, `player_driverslicense`, `player_outstanding_fines`, `player_last_mugshot` FROM `characters` WHERE `player_name` LIKE '%e'", rpname ) ;

	new char_id, dlicense, veh_plate[32], actual_name[32], veh_model, veh_color, fines_str[32], crimes, gunlicensestr[32], licenses_str[32], crimes_str[32], mugshot, mugshot_str[40];
	// new fines;

	inline Character_FetchDetails() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if (rows)
		{
			char_id = cache_get_field_int (0, "player_id");
			dlicense = cache_get_field_int (0, "player_driverslicense") ;
			//glicense = cache_get_field_int (0, "player_gunlicense") ;
			//fines = cache_get_field_int (0, "player_outstanding_fines") ;
			mugshot = cache_get_field_int (0, "player_last_mugshot") ;
			cache_get_field_content (0, "player_name", actual_name, mysql, 32) ;
			cache_get_field_content (0, "player_name", display_name, mysql, 32) ;
		}

		if (!rows || !char_id)
		{
			//SendClientMessage(playerid, COLOR_BLUE, sprintf("Person Database result for '%s':", rpname ) ) ;
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("No results found for '%s'.", rpname));
		}

		new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
		new faction_enum_id = Faction_GetEnumID( factionid ); 

		strreplace(display_name, "_", " ");

		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s ran a person check on \"%s\" }", 
			Faction[faction_enum_id][E_FACTION_ABBREV], playerid, ReturnPlayerNameData(playerid, 0, true), display_name), faction_enum_id, false ) ;

		SendClientMessage(playerid, COLOR_BLUE, sprintf("Person Database result for '%s':", display_name ) ) ;


		mysql_format ( mysql, query, sizeof ( query ), "SELECT `fine_status`, UNIX_TIMESTAMP(`fine_date`) AS `timestamp` FROM `criminalfines` WHERE `fine_player_name` LIKE '%e'", actual_name ) ;

		new total_tickets, unpaid_tickets, expired_tickets, status, timestamp;
		new days = 259200; // 3 days to seconds // if you change this, change it in arrest/crimes too
		new now = gettime(); // current time

		inline Character_FetchTickets() 
		{
			cache_get_data ( rows, fields, mysql ) ;

			if (rows)
			{
				for_loop ( new i; i < rows; i ++ ) 
				{ 
					status = cache_get_field_int (i, "fine_status");
					timestamp = cache_get_field_int (i, "timestamp");
					
					new due = days - (now - timestamp);
					total_tickets ++ ;

					if (due < 0 && status == 0) expired_tickets ++;
					else if (status == 0) unpaid_tickets ++;
				}
			}

			mysql_format ( mysql, query, sizeof ( query ), "SELECT COUNT(*) AS `crimes` FROM `criminalrecords` WHERE `record_holder` LIKE '%e'", actual_name ) ;

			inline Character_FetchCrimes() 
			{
				cache_get_data ( rows, fields, mysql ) ;

				crimes = cache_get_field_int (0, "crimes");
				format(crimes_str, sizeof(crimes_str), "{A5D6A7}%s", "None");
				if (crimes > 0)
				{
					format(crimes_str, sizeof(crimes_str), "{EF9A9A}%d", crimes);
				}

				new year, month, day, hour, minute, second ;
				format(mugshot_str, sizeof(mugshot_str), "{EF9A9A}%s", "None Available");
				if (mugshot > 0)
				{
					stamp2datetime(mugshot, year, month, day, hour, minute, second, 1 ) ;
					format(mugshot_str, sizeof(mugshot_str), "{A5D6A7}On File (%02d/%02d/%04d)", day, month, year);
				}

				format(gunlicensestr, sizeof(gunlicensestr), "{EF9A9A}%s", "None");

				for_loop( new i; i < sizeof ( License ); i++)
				{
					if (License[i][LICENSE_OWNER] == char_id && License[i][LICENSE_TYPE] == LICENSE_TYPE_GUN && License[i][LICENSE_ID] != INVALID_LICENSE_ID) 
					{
						stamp2datetime(License[i][LICENSE_EXP], year, month, day, hour, minute, second, 1);
						if (License[i][LICENSE_EXP] < gettime()) format(gunlicensestr, sizeof(gunlicensestr), "{FFCC80}%s (%02d/%02d/%04d)", GetLicenseSubName(i), day, month, year);
						else format(gunlicensestr, sizeof(gunlicensestr), "{A5D6A7}%s (%02d/%02d/%04d)", GetLicenseSubName(i), day, month, year);
					}
				}

				format(licenses_str, sizeof(licenses_str), "{EF9A9A}%s", "None");

				if (dlicense){
					format(licenses_str, sizeof(licenses_str), "{A5D6A7}Valid");
				} else {
					for_loop( new i; i < sizeof ( License ); i++) {
						if (License[i][LICENSE_OWNER] == char_id && License[i][LICENSE_TYPE] == LICENSE_TYPE_DRIVER && License[i][LICENSE_ID] != INVALID_LICENSE_ID) 
						{
							format(licenses_str, sizeof(licenses_str), "{A5D6A7}Valid");
							break;
						}
					}
				}

				format(fines_str, sizeof(fines_str), "{A5D6A7}%s", "None");
				if (total_tickets > 0 && !unpaid_tickets && !expired_tickets) format(fines_str, sizeof(fines_str), "{A5D6A7}%d (0 Pending)", total_tickets);
				else if (total_tickets > 0 && expired_tickets > 0) format(fines_str, sizeof(fines_str), "{EF9A9A}%d (%d Unpaid)", total_tickets, expired_tickets);
				else if (total_tickets > 0 && unpaid_tickets > 0) format(fines_str, sizeof(fines_str), "{A5D6A7}%d (%d Pending)", total_tickets, unpaid_tickets);

				SendClientMessage(playerid, -1, sprintf("> Name: {90CAF9}%s {FFFFFF}| Drivers: %s {FFFFFF}| Firearms: %s", display_name, licenses_str, gunlicensestr));
				SendClientMessage(playerid, -1, sprintf("> Priors: %s {FFFFFF}| Tickets: %s {FFFFFF}| Photograph: %s", crimes_str, fines_str, mugshot_str));

				SendClientMessage(playerid, COLOR_BLUE, "Vehicle Database result:");

				mysql_format ( mysql, query, sizeof ( query ), "SELECT `vehicle_modelid`, `vehicle_license`, `vehicle_color_a` FROM `vehicles` WHERE `vehicle_type` = 3 AND `vehicle_owner` = %d", char_id ) ;

				inline Vehicle_FetchOwner() {

					cache_get_data ( rows, fields, mysql ) ;

					if ( rows ) {

						for_loop ( new i; i < rows; i ++ ) { 

							veh_model = cache_get_field_int (i, "vehicle_modelid") ;
							veh_color = cache_get_field_int (i, "vehicle_color_a") ;
							cache_get_field_content ( i, "vehicle_license", veh_plate, mysql, 32 ) ;

							SendClientMessage(playerid, -1, sprintf("> {%s}[%d] {FFFFFF}%s (%s)", 
								VehicleColoursTableRGBA[veh_color], i+1, ReturnVehicleModelName(veh_model), veh_plate ) ) ;
						}
					}
					else
					{
						SendClientMessage(playerid, 0xDEDEDEFF, "No vehicles found.");
					}
				}

				mysql_tquery_inline(mysql, query, using inline Vehicle_FetchOwner, "");
			}

			mysql_tquery_inline(mysql, query, using inline Character_FetchCrimes, "");

		}

		mysql_tquery_inline(mysql, query, using inline Character_FetchTickets, "");

	}

	mysql_tquery_inline(mysql, query, using inline Character_FetchDetails, "");
	return true ;
}

CMD:searchplayer(playerid, params[]) { return cmd_searchdata(playerid, params); }
CMD:searchname(playerid, params[]) { return cmd_searchdata(playerid, params); }