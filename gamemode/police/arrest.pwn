static enum E_HELPDESK_DATA
{
	E_HELPDESK_FACTION,
	E_HELPDESK_FACTYPE,
	E_HELPDESK_ICON,
	E_HELPDESK_NAME[64],
	E_HELPDESK_DESC[128],
	Float:E_HELPDESK_X,
	Float:E_HELPDESK_Y,
	Float:E_HELPDESK_Z,
	E_HELPDESK_INT,
	E_HELPDESK_VW,
	E_HELPDESK_LAST_CALLED
}

static FacHelpDesk[][E_HELPDESK_DATA] = 
{
	{ 10, -1, 1247, "Central Police Station", "{8D8DFF}/payfine{DEDEDE}, {8D8DFF}/prisoners", -11.4663, -87.5607, 898.5717, 6, -1 }, // LSPD
	{ 16, -1, 1247, "Dillimore Sheriff's Station", "{8D8DFF}/payfine{DEDEDE}, {8D8DFF}/prisoners", 1406.6608, 4.0925, 1001.0273, 127, 1512 }, // LSSD
	{ 10, -1, 1247, "East LS Police Station", "{8D8DFF}/payfine{DEDEDE}, {8D8DFF}/prisoners", 2455.6121, -1539.0337, 999.2344, 6, 2319 }, // LSSD
	{ 25, -1, 1239, "Fire Dept. Call Point", "", 1827.6770,-1441.5229,13.5967, 0, 0 }, // LSFD
	{ 33, -1, 1239, "City Hall Reception", "{8D8DFF}/payfine{DEDEDE}, {8D8DFF}/namechange{DEDEDE}, {8D8DFF}/laws{DEDEDE}, {8D8DFF}/dmv{DEDEDE}", 1481.0460, -1788.5773, 18.7360, 0, 0 }, // GOV
	{ 32, -1, 1239, "Mall Information", "{8D8DFF}/advert{DEDEDE}", 1732.4945, -1669.1420, 20.1651, 0, 0 }, // Mall
	{ -1, FACTION_TYPE_DEA, 1239, "Federal Building Reception", "",  990.0291, -1530.7581, 15.1297, 0, 0 }
};

Fine_LoadLabel()
{
	new str[256];

	for (new i = 0; i < sizeof(FacHelpDesk); i ++)
	{
		format(str, sizeof(str), "[%s]", FacHelpDesk[i][E_HELPDESK_NAME]);
		if (strlen(FacHelpDesk[i][E_HELPDESK_DESC]))
		{
			strcat(str, "\n");
			strcat(str, FacHelpDesk[i][E_HELPDESK_DESC]);
		} 
		strcat(str, "\n{DEDEDE}Please {3479E3}/ringbell {DEDEDE}for attention.");

		CreateDynamic3DTextLabel(str, 0x3479E3FF, FacHelpDesk[i][E_HELPDESK_X], FacHelpDesk[i][E_HELPDESK_Y], FacHelpDesk[i][E_HELPDESK_Z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FacHelpDesk[i][E_HELPDESK_VW], FacHelpDesk[i][E_HELPDESK_INT]); 
		CreateDynamicPickup(FacHelpDesk[i][E_HELPDESK_ICON], 1, FacHelpDesk[i][E_HELPDESK_X], FacHelpDesk[i][E_HELPDESK_Y], FacHelpDesk[i][E_HELPDESK_Z], FacHelpDesk[i][E_HELPDESK_VW], FacHelpDesk[i][E_HELPDESK_INT]);
		printf(" * [HELPDESK] (%d) %s loaded.", i, FacHelpDesk[i][E_HELPDESK_NAME]);
	}
}

IsAtFrontDesk(playerid)
{ 
	for (new i = 0; i < sizeof(FacHelpDesk); i ++)
	{	
		if (IsPlayerInRangeOfPoint(playerid, 5.0, FacHelpDesk[i][E_HELPDESK_X], FacHelpDesk[i][E_HELPDESK_Y], FacHelpDesk[i][E_HELPDESK_Z]))
		{
			return i;
		}
	}

	return -1;
}

IsAtCopFrontDesk(playerid)
{
	new desk = IsAtFrontDesk(playerid);
	return desk == 0 || desk == 1;
}

IsAtGovFrontDesk(playerid)
{
	new desk = IsAtFrontDesk(playerid);
	return desk == 4;
}

CMD:ringbell(playerid)
{
	new desk = IsAtFrontDesk(playerid);
	if (desk == -1) return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can only do this at a faction helpdesk.");

	new facid = FacHelpDesk[desk][E_HELPDESK_FACTION];
	new factype = FacHelpDesk[desk][E_HELPDESK_FACTYPE];

	if (FacHelpDesk[desk][E_HELPDESK_LAST_CALLED] && gettime() - FacHelpDesk[desk][E_HELPDESK_LAST_CALLED] < 900)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This reception bell has already been rung recently, try again later." ) ;
	}

	new str[144];
	format(str, sizeof(str), "[%s]: (%d) %s has rung the bell to request help.", FacHelpDesk[desk][E_HELPDESK_NAME], playerid, ReturnPlayerNameData(playerid, 0, true));
	FacHelpDesk[desk][E_HELPDESK_LAST_CALLED] = gettime();

	foreach(new policeid: Player) 
	{
		if ( Character [ policeid ] [ E_CHARACTER_FACTIONID ] ) 
		{
			new faction_enum_id = Faction_GetEnumID(Character [ policeid ] [ E_CHARACTER_FACTIONID ] ); 

			if ( faction_enum_id != INVALID_FACTION_ID ) 
			{
				if ( Faction [ faction_enum_id ] [ E_FACTION_ID ] == facid || Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == factype )
				{
					SendClientMessage(policeid, COLOR_FACTION, str);
				}
			}
		}
	}

	PlayerPlaySoundEx(playerid, 17802); // Play bell to nearby players from this player's position
	ProxDetectorAutoMe(playerid, 30.0, sprintf("rings the %s bell.", FacHelpDesk[desk][E_HELPDESK_NAME]), true);
	return true;
}

/*
CMD:fine(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new targetid, fine ;
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	if ( sscanf ( params, "k<player>i", targetid, fine ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/fine [targetid] [amount]" ) ;
		return true ;
	}
	
	if ( targetid == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't fine yourself." ) ;
	}

	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Your target isn't connected." ) ;
	}

 	if (!IsPlayerNearPlayer(playerid, targetid, 6.0)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "DEDEDE", "You're not near your target." ) ;
    }
    
	Character [ targetid ] [ E_CHARACTER_OUTSTANDING_FINES ] += fine ;

	ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has fined %s for $%s.", ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( targetid ),
	 IntegerWithDelimiter(fine) ) ) ;

	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has fined (%d) %s for $%s }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid ), targetid, ReturnPlayerNameData ( targetid ), IntegerWithDelimiter(fine)
	), faction_enum_id, false ) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_outstanding_fines = %d WHERE player_id = %d",

		Character [ targetid ] [ E_CHARACTER_OUTSTANDING_FINES ], Character [ targetid ] [ E_CHARACTER_ID ]
	);

	mysql_tquery(mysql, query) ;

	SendServerMessage ( targetid, COLOR_FACTION, "Fine", "A3A3A3", sprintf("You've been fined for $%s (total fines: $%s). Pay it at the LSPD using /payfine.",
		IntegerWithDelimiter(fine), IntegerWithDelimiter(Character [ targetid ] [ E_CHARACTER_OUTSTANDING_FINES ])) ) ;


	return true ;
}
*/

/*
CMD:payfine(playerid, params[]) {

	if ( IsPlayerInRangeOfPoint ( playerid, 5.0, PD_RECEPTION_POS_X, PD_RECEPTION_POS_Y, PD_RECEPTION_POS_Z ) ) {

		if ( Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] <= 0 ) {

			return SendServerMessage ( playerid, COLOR_BLUE, "Fine", "A3A3A3", "You don't have any outstanding fines." ) ;
		}

		if ( GetPlayerCash ( playerid ) < Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] ) {

			return SendServerMessage ( playerid, COLOR_BLUE, "Fine", "A3A3A3", sprintf("You don't have enough money. You need at least $%s.",
			IntegerWithDelimiter(Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ]) )) ;
		}


		for_loop( new i, j = sizeof ( Faction ); i < j ; i ++ ) {

			if ( Faction [ i ] [ E_FACTION_TYPE ] == 0 ) {

				Faction_AddBankMoney(i, Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] ) ;
			}

			else continue ;
		}

		TakePlayerCash(playerid, Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] ) ;
		Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ] = 0 ;

		new query [ 256 ] ;

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_outstanding_fines = %d WHERE player_id = %d",
			Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ], Character [ playerid ] [ E_CHARACTER_ID ]
		);

		mysql_tquery(mysql, query) ;

		SendServerMessage ( playerid, COLOR_BLUE, "Fine", "A3A3A3", "You've paid off your debt. You don't have any outstanding fines." ) ;
		return true ;
	}

	else {

		SendServerMessage ( playerid, COLOR_BLUE, "Fine", "A3A3A3", "You can only pay fines at the front desk of a police station." ) ;
		GPS_MarkLocation(playerid, "The ~r~LSPD station~w~ has been marked on your ~r~minimap~w~.", E_GPS_COLOR_DEFAULT, 1555.5000,-1675.6400,16.1953 ) ;
	}

	return true ;
}
*/

CMD:prisoners(playerid, params[]) 
{
	if ( !IsAtCopFrontDesk(playerid) && !IsPlayerInPoliceFaction(playerid, true) && GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) 
	{
		return SendServerMessage ( playerid, COLOR_BLUE, "Error", "A3A3A3", "You can only view the list of prisoners at the front desk of a police station." ) ;
	}

	new string [ 128 ] ;

	SendClientMessage(playerid, COLOR_BLUE, "List of prisoners:");

	foreach(new targetid: Player) {

		if ( Character [ targetid ] [ E_CHARACTER_ARREST_TIME ] ) {
			format ( string, sizeof ( string ), "(%d) %s in  for %d seconds.", targetid, ReturnPlayerNameData ( targetid, 0, true ), Character [ targetid ] [ E_CHARACTER_ARREST_TIME ] ) ;
			SendClientMessage(playerid, 0xDEDEDEFF, string);

		}
	}

	return true ;
}

CMD:jailtime(playerid)
{
	if (Character[playerid][E_CHARACTER_ARREST_TIME])
	{
		// New, shows jail time only when they do the command
		GameTextForPlayer(playerid, sprintf("~w~~n~~n~~n~~n~~n~~n~Jail Time: ~r~%d seconds", Character[playerid][E_CHARACTER_ARREST_TIME]), 3000, 3 );
	}
	
	return 1;
}


CMD:arrest(playerid, params[] ) {
   
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new targetid, time ;
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID( factionid ); 

	if ( sscanf ( params, "k<player>i", targetid, time ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/arrest [targetid] [time (in minutes)]" ) ;
		return true ;
	}

	if (!IsPlayerConnected(targetid)) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Your target isn't connected." ) ;
	if (!IsPlayerNearPlayer(playerid, targetid, 10.0))  return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near this player." ) ;
		
	if (!PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] || GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
	{
		if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true))
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
		}

		if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3)
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
		}

		if ( time < 10 ) return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "You can't arrest someone for less than 10 minutes." ) ;
		else if ( time > 180 ) return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "You can't arrest someone for more than 3 hours (180 minutes)." ) ;

		if ( targetid == playerid ) 
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't arrest yourself." ) ;
		}

		if (!IsPlayerInDEAFaction(playerid))
		{
			if (!Character[targetid][E_CHARACTER_LAST_MUGSHOT] || gettime() - Character[targetid][E_CHARACTER_LAST_MUGSHOT] > 43200)
			{
				// If no mugshot, or last mugshot is more than 12 hours old deny arrest
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't arrest this person until you take their mugshot." ) ;
			}
		}
	}

	new Float: x, Float: y, Float: z ; 
	GetPlayerPos ( targetid, x, y, z ) ;

	Character [ targetid ] [ E_CHARACTER_ARREST_TIME ] = time * 60 ;

	Character [ targetid ] [ E_CHARACTER_ARREST_X ] = x ;
	Character [ targetid ] [ E_CHARACTER_ARREST_Y ] = y ;
	Character [ targetid ] [ E_CHARACTER_ARREST_Z ] = z ;

	Character [ targetid ] [ E_CHARACTER_ARREST_VW ] = GetPlayerVirtualWorld(targetid) ;
	Character [ targetid ] [ E_CHARACTER_ARREST_INT ] = GetPlayerInterior(targetid) ;

	Weapon_ResetPlayerWeapons(targetid);
	SendServerMessage(targetid, COLOR_FACTION, "Arrest", "A3A3A3", sprintf("You have been imprisoned for %d minutes by %s %s (%d).", time, Character[playerid][E_CHARACTER_FACTIONRANK], ReturnPlayerCharName(playerid), playerid));
	//SendClientMessage(targetid, 0xA3A3A3FF, "Your weapons have been confiscated.");
	
	Weapon_SavePlayerWeapons(targetid);

	new query [ 1024 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_arrest_x = '%f', player_arrest_y = '%f', player_arrest_z = '%f',\
		player_arrest_vw = %d, player_arrest_int = %d, player_arrest_time = %d  WHERE player_id = %d",

		Character [ targetid ] [ E_CHARACTER_ARREST_X ], Character [ targetid ] [ E_CHARACTER_ARREST_Y ], 
		Character [ targetid ] [ E_CHARACTER_ARREST_Z ], Character [ targetid ] [ E_CHARACTER_ARREST_VW ], 
		Character [ targetid ] [ E_CHARACTER_ARREST_INT ], Character [ targetid ] [ E_CHARACTER_ARREST_TIME ],
		 Character [ targetid ] [ E_CHARACTER_ID ]
	);

	mysql_tquery(mysql, query);

	// Do the auto ticket revokation

	new days = 259200; // 3 days to seconds // if you change this, change it in crimes/searchdata too
	mysql_format(mysql, query, sizeof(query), "UPDATE `criminalfines` SET `fine_status` = 2, `fine_revoker` = 'The System' WHERE `fine_status` = 0 AND `fine_player_name` LIKE '%e' AND DATE_ADD(`fine_date`, INTERVAL %d second) < CURRENT_TIMESTAMP", Character[targetid][E_CHARACTER_NAME], days);

	inline Ticket_OnAutoRevoke() 
	{
		new affected = cache_affected_rows(mysql);
		if (affected)
		{
			SendClientMessage(targetid, 0xA3A3A3FF, sprintf("The %d ticket(s) that you failed to pay in time were automatically revoked.", affected));
			SendClientMessage(playerid, 0xA3A3A3FF, sprintf("The %d ticket(s) that they failed to pay in time were automatically revoked.", affected));
		} 
	}

	mysql_tquery_inline(mysql, query, using inline Ticket_OnAutoRevoke, "");

	if ( faction_enum_id != INVALID_FACTION_ID ) Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has arrested (%d) %s for %d minutes. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], 
		playerid, ReturnPlayerNameData ( playerid, 0, true ), 
		targetid, ReturnPlayerNameData ( targetid, 0, true ), time
	), faction_enum_id, false, false, 0, true ) ;

	/*
	for_loop( new i, j = sizeof ( Faction ); i < j ; i ++ ) {

		if ( Faction [ i ] [ E_FACTION_TYPE ] == 0 ) {

			Faction_AddBankMoney(i, 2500 ) ;
		}

		else continue ;
	}
	*/

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Arrested %s for %d minutes", ReturnPlayerNameData(targetid), time));
	AddLogEntry(targetid, LOG_TYPE_SCRIPT, sprintf("Was arrested by %s %s for %d minutes", Character[playerid][E_CHARACTER_FACTIONRANK], ReturnPlayerNameData(playerid), time));

	SendClientMessage(targetid, 0xA3A3A3FF, "Type \"/jailtime\" to see how long you have left in jail.");
	//SendClientMessage ( playerid, COLOR_YELLOW, "Don't forget to /setarrestpos to update their cell spawn location!");

	return true ;
}

CMD:setarrestpos(playerid, params[] ) {
    
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true))
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty as a police officer." ) ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setarrestpos [targetid]" ) ;
		return true ;
	}


	if ( targetid == playerid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't arrest yourself." ) ;
	}

	if ( ! IsPlayerConnected(targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Your target isn't connected." ) ;
	}

	if (!IsPlayerNearPlayer(playerid, targetid, 10.0))  return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near this player." ) ;

	new Float: x, Float: y, Float: z ; 
	GetPlayerPos ( targetid, x, y, z ) ;

	Character [ targetid ] [ E_CHARACTER_ARREST_X ] = x ;
	Character [ targetid ] [ E_CHARACTER_ARREST_Y ] = y ;
	Character [ targetid ] [ E_CHARACTER_ARREST_Z ] = z ;

	Character [ targetid ] [ E_CHARACTER_ARREST_VW ] = GetPlayerVirtualWorld(targetid) ;
	Character [ targetid ] [ E_CHARACTER_ARREST_INT ] = GetPlayerInterior(targetid) ;

	new query [ 1024 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_arrest_x = '%f', player_arrest_y = '%f', player_arrest_z = '%f',\
		player_arrest_vw = %d, player_arrest_int = %d WHERE player_id = %d",

		Character [ targetid ] [ E_CHARACTER_ARREST_X ], Character [ targetid ] [ E_CHARACTER_ARREST_Y ], 
		Character [ targetid ] [ E_CHARACTER_ARREST_Z ], Character [ targetid ] [ E_CHARACTER_ARREST_VW ], 
		Character [ targetid ] [ E_CHARACTER_ARREST_INT ],
		Character [ targetid ] [ E_CHARACTER_ID ]
	);

	mysql_tquery(mysql, query);

	/*
	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has updated (%d) %s's arrest position. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], 
		playerid, ReturnPlayerNameData ( playerid ), 
		targetid, ReturnPlayerNameData ( targetid )
	), faction_enum_id, false ) ;
	*/

	SendClientMessage(playerid, COLOR_BLUE, sprintf("You've updated the arrest spawn location of (%d) %s.", targetid, ReturnPlayerNameData(targetid, 0, true)));
	SendClientMessage(targetid, COLOR_ERROR, sprintf("Officer (%d) %s has updated your arrest spawn location.", playerid, ReturnPlayerNameData(playerid, 0, true)));

	return true ;
}

Arrest_Tick(playerid) {

	if ( Character [ playerid ] [ E_CHARACTER_ARREST_TIME ]) {

		if ( -- Character [ playerid ] [ E_CHARACTER_ARREST_TIME ] <= 0 ) {

			Character [ playerid ] [ E_CHARACTER_ARREST_TIME ] = 0 ;

			SOLS_SetPlayerPos(playerid, 1811.0447,-1577.7692,13.5267);
			SetPlayerFacingAngle(playerid, 260.1323);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			new query [ 256 ] ;

			mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_arrest_time = 0 WHERE player_id = %d", 
				Character [ playerid ] [ E_CHARACTER_ID ] ) ;

			mysql_tquery(mysql, query);

			SendServerMessage ( playerid, COLOR_BLUE, "Arrest", "A3A3A3", "You've been released from captivity." ) ;
		}
		/*
		else {

			GameTextForPlayer(playerid, sprintf("~w~~n~~n~~n~~n~~n~~n~Jail Time: ~r~%d", Character [ playerid ] [ E_CHARACTER_ARREST_TIME ]), 950, 3 ) ;
		}
		*/
	}
}

Spawn_ArrestJail(playerid, bool:isrespawn)
{
	#pragma unused isrespawn

	SetSpawnInfo(playerid, 0, Character [ playerid ] [ E_CHARACTER_SKINID ], 
		Character [ playerid ] [ E_CHARACTER_ARREST_X ], Character [ playerid ] [ E_CHARACTER_ARREST_Y ], 
		Character [ playerid ] [ E_CHARACTER_ARREST_Z ], 0.0, 0, 0, 0, 0, 0, 0);

	CS_SpawnPlayer(playerid) ;

	SetCameraBehindPlayer(playerid);
	SetPlayerSkin ( playerid, Character [ playerid ] [ E_CHARACTER_SKINID ] ) ;

	SetPlayerVirtualWorld ( playerid, Character [ playerid ] [ E_CHARACTER_ARREST_VW ] );
	SetPlayerInterior(playerid, Character [ playerid ] [ E_CHARACTER_ARREST_INT ] );
	SetPlayerHealth(playerid, Character [ playerid ] [ E_CHARACTER_HEALTH ] ) ;

	// SOLS_SetPlayerPos ( playerid, Character [ playerid ] [ E_CHARACTER_ARREST_X ], Character [ playerid ] [ E_CHARACTER_ARREST_Y ], Character [ playerid ] [ E_CHARACTER_ARREST_Z ] );
	SOLS_SetPosWithFade(playerid, Character [ playerid ] [ E_CHARACTER_ARREST_X ], Character [ playerid ] [ E_CHARACTER_ARREST_Y ], Character [ playerid ] [ E_CHARACTER_ARREST_Z ]);

	SendServerMessage ( playerid, COLOR_BLUE, "Arrest", "A3A3A3", "You've been returned back to your cell." );
	// Weapon_ResetPlayerWeapons(playerid);
	
	//SendClientMessage(playerid, 0xA3A3A3FF, "Your weapons have been confiscated.");
	Weapon_SavePlayerWeapons(playerid);
	Attach_LoadPlayerEntities(playerid);

	SendClientMessage(playerid, 0xA3A3A3FF, "Type \"/jailtime\" to see how long you have left in jail.");
	return true;
}