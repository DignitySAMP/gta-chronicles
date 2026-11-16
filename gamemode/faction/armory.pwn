static enum E_ARMORY
{
	E_ARMORY_INDEX,
	E_ARMORY_FAC_TYPE,
	E_ARMORY_NAME[64],
	E_ARMORY_DESC[128],
	Float:E_ARMORY_X,
	Float:E_ARMORY_Y,
	Float:E_ARMORY_Z,
	E_ARMORY_INT,
	E_ARMORY_VW,
	bool:E_ARMORY_HIDDEN
}

#define MAX_ARMORY_WEAPONS 9

static enum
{
	ARMORY_LSPD,
	ARMORY_LSFD,
	ARMORY_DEA,
	ARMORY_LSSD,
	ARMORY_SEC,
	ARMORY_SAN,
	ARMORY_FBI,
	ARMORY_AP,
	ARMORY_AP2,
	ARMORY_SWAT,
	ARMORY_SD2,
	ARMORY_GOV,
	ARMORY_SD_ELS,
	ARMORY_TAXI
}

static const Armory[][E_ARMORY] = 
{
	{ ARMORY_LSPD, FACTION_TYPE_POLICE, "Police Locker Room", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", -8.2547,-95.6716,898.5792, 6, 311 }, // LSPD
	{ ARMORY_LSFD, FACTION_TYPE_EMS, "Fire Dept. Locker Room", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1815.0, -1447.4, 13.592, 0, 0 }, // LSFD
	// { ARMORY_DEA, FACTION_TYPE_DEA, "DEA Armory", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kev, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 2848.08, -1476.4, 29.14, 0, 0 }, // DEA
	{ ARMORY_LSSD, FACTION_TYPE_POLICE, "Dillimore Station Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1392.21, -21.393, 1001.17, 127, 1512 }, // LSSD
	{ ARMORY_SEC, FACTION_TYPE_SECURITY, "Mall Security Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1736.3558, -1667.2622, 20.1712, 0, 0 }, // Mall Sec
	{ ARMORY_SAN, FACTION_TYPE_NEWS, "SAN Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1800.2623, -1663.6337, 32.2619, -1, -1 },
	{ ARMORY_FBI, FACTION_TYPE_DEA, "FBI/DEA Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 974.1708, -1517.5559, 15.1370, 0, 0 }, // DEA/FBI
	{ ARMORY_SWAT, FACTION_TYPE_POLICE, "Equipment Area", "{8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1949.7428, -2309.4136, 13.5828, 7, 6003, false },
	{ ARMORY_AP, FACTION_TYPE_DEA, "Aperture Corporation", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 206.8919, 1925.2609, 17.6506, 0, 0, true },
	{ ARMORY_AP2, FACTION_TYPE_DEA, "Aperture Corporation", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1348.1475,-1651.0931,13.6141, 0, 0, true },
	{ ARMORY_SD2, FACTION_TYPE_POLICE, "Sheriff Locker Room", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 2774.1130, -960.6407, 1532.4126, 127, 2137 },
	{ ARMORY_GOV, FACTION_TYPE_GOV, "City Hall Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 1511.8374,-1794.9758,18.7426, 0, 0 },
	{ ARMORY_SD_ELS, FACTION_TYPE_POLICE, "East LS Station Lockers", "{8D8DFF}/duty{DEDEDE}, {8D8DFF}/kevlar{DEDEDE}, {8D8DFF}/armory{DEDEDE}, {8D8DFF}/uniform", 2467.1758, -1539.8496, 999.2344, 6, 2319 }, // LSSD
	{ ARMORY_TAXI, FACTION_TYPE_TAXI, "Taxi Depot Lockers", "{8D8DFF}/duty{DEDEDE}", 2045.2909, -1837.6063, 13.6360, 0, 0 }
};

static enum E_ARMORY_WEAPON
{
	E_ARMORY_WEAPON_FAC_TYPE,
	E_ARMORY_WEAPON_ID,
	E_ARMORY_WEAPON_AMMO,
	E_ARMORY_WEAPON_TIER,
	E_ARMORY_WEAPON_SQUAD,
	bool:E_ARMORY_WEAPON_OFF_DUTY,
	E_ARMORY_WEAPON_ARMORY_INDEX
}

static const ArmoryWeapon[][E_ARMORY_WEAPON] = 
{
	{FACTION_TYPE_POLICE, 67, 42, 3, 0, true},		// PD Deagle
	{FACTION_TYPE_POLICE, 3, 1, 4},				// PD Baton
	{FACTION_TYPE_POLICE, 11, 15000, 4},		// PD Spray
	{FACTION_TYPE_POLICE, 45, 25, 3},			// PD Shotgun
	{FACTION_TYPE_POLICE, 63, 100, 4},			// PD Camera
	{FACTION_TYPE_POLICE, 49, 25, 3, FACTION_SQUAD_SWAT, false, ARMORY_SWAT},			// PD SWAT Shotgun
	{FACTION_TYPE_POLICE, 35, 120, 3, FACTION_SQUAD_SWAT, false, ARMORY_SWAT},			// PD SWAT MP5
	{FACTION_TYPE_POLICE, 40, 200, 3, FACTION_SQUAD_SWAT, false, ARMORY_SWAT},			// PD SWAT M4

	{FACTION_TYPE_EMS, 11, 15000, 3},			// Spraycan
	{FACTION_TYPE_EMS, 66, 2000, 3},			// Fire Extinguisher
	{FACTION_TYPE_EMS, 6, 1, 3},				// Shovel
	{FACTION_TYPE_EMS, 9, 1, 1},				// Chainsaw
	{FACTION_TYPE_EMS, 67, 42, 3, FACTION_SQUAD_ARSON},		// PD Deagle (Arson Squad)

	{FACTION_TYPE_DEA, 70, 70, 3, 0, true},		// DEA Deagle
	{FACTION_TYPE_DEA, 45, 25, 3},				// PD Shotgun
	{FACTION_TYPE_DEA, 71, 150, 3},				// DEA P90 USG
	{FACTION_TYPE_DEA, 63, 100, 4},				// Camera

	{FACTION_TYPE_SECURITY, 3, 1, 3},			// Baton
	{FACTION_TYPE_SECURITY, 11, 15000, 3},		// Spray
	{FACTION_TYPE_SECURITY, 66, 999, 3},		// Fire Ext

	{FACTION_TYPE_NEWS, 63, 100, 4},			// Camera

	{FACTION_TYPE_GOV, 67, 42, 3, FACTION_SQUAD_GOV_DAO, true},		// PD Deagle
	{FACTION_TYPE_GOV, 11, 15000, 3},								// Spray
	{FACTION_TYPE_GOV, 6, 1, 4, FACTION_SQUAD_GOV_PW},				// Shovel
	{FACTION_TYPE_GOV, 66, 2000, 4, FACTION_SQUAD_GOV_PW},			// Fire Extinguisher
	{FACTION_TYPE_GOV, 63, 100, 4}									// Camera
};

/*
static const Armory_Police[][E_ARMORY_WEAPON] = 
{
	{67, 42, 3, true},		// PD Deagle
	{3, 1, 3},				// PD Baton
	{11, 15000, 3},			// PD Spray
	{45, 25, 3},			// PD Shotgun
	{63, 100, 4}			// PD Camera
};

static const Armory_EMS[][E_ARMORY_WEAPON] = 
{
	{11, 15000, 3},			// Spraycan
	{66, 2000, 3},			// Fire Extinguisher
	{6, 1, 3},				// Shovel
	{9, 1, 1}				// Chainsaw
};

static const Armory_DEA[][E_ARMORY_WEAPON] = 
{
	{67, 42, 3, true},		// PD Deagle
	{35, 90, 3},			// Mp5
	{63, 100, 4}			// Camera
};

static const Armory_Sec[][E_ARMORY_WEAPON] = 
{
	{3, 1, 3},				// PD Baton
	{11, 15000, 3},			// PD Spray
	{66, 2000, 3}			// Fire Extinguisher
};
*/

Kiosk_LoadEntities () 
{
	new str[256];

	for (new i = 0; i < sizeof(Armory); i ++)
	{
		if (Armory[i][E_ARMORY_HIDDEN]) continue;
		
		format(str, sizeof(str), "[%s]", Armory[i][E_ARMORY_NAME]);
		
		if (strlen(Armory[i][E_ARMORY_DESC]))
		{
			strcat(str, "\n");
			strcat(str, Armory[i][E_ARMORY_DESC]);
		} 

		CreateDynamic3DTextLabel(str, 0x3479E3FF, Armory[i][E_ARMORY_X], Armory[i][E_ARMORY_Y], Armory[i][E_ARMORY_Z], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Armory[i][E_ARMORY_VW], Armory[i][E_ARMORY_INT]); 
		CreateDynamicPickup(1275, 1, Armory[i][E_ARMORY_X], Armory[i][E_ARMORY_Y], Armory[i][E_ARMORY_Z], Armory[i][E_ARMORY_VW], Armory[i][E_ARMORY_INT]);
		printf(" * [ARMORY] (%d) %s loaded.", i, Armory[i][E_ARMORY_NAME]);
	}

	CreateDynamicObject(2063, 206.931, 1924.296, 17.550, 0.000, 0.000, 180.0); // Kate_Mercer (2063) // A51
	CreateDynamicObject(14782, 364.268, 192.923, 1008.372, 0.000, 0.000, 90.0); // Kate_Mercer (14782) // Gov


	/*
	if ( IsValidDynamic3DTextLabel ( Server [ POLICE_KIOSK_LABEL ] ) ) {

		DestroyDynamic3DTextLabel(Server [ POLICE_KIOSK_LABEL ]);
	}

	if ( IsValidDynamic3DTextLabel ( Server [ MEDIC_KIOSK_LABEL ] ) ) {

		DestroyDynamic3DTextLabel(Server [ MEDIC_KIOSK_LABEL ]);
	}

	if ( IsValidDynamic3DTextLabel ( Server [ DEA_KIOSK_LABEL ] ) ) {

		DestroyDynamic3DTextLabel(Server [ DEA_KIOSK_LABEL ]);
	}

	if ( IsValidDynamic3DTextLabel ( Server [ SHERIFF_KIOSK_LABEL ] ) ) {

		DestroyDynamic3DTextLabel(Server [ SHERIFF_KIOSK_LABEL ]);
	}

	Server [ POLICE_KIOSK_LABEL ] = CreateDynamic3DTextLabel("[LSPD Armory]{DEDEDE}\nAvailable commands:{ffffff} /duty, /kev, /armory, /uniform",
		0x337AB8FF, Server [ E_SERVER_POLICE_KIOSK_X ], Server [ E_SERVER_POLICE_KIOSK_Y ], Server [ E_SERVER_POLICE_KIOSK_Z ],
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Server [ E_SERVER_POLICE_KIOSK_VW ], Server [ E_SERVER_POLICE_KIOSK_INT ]
	);

	Server [ MEDIC_KIOSK_LABEL ] = CreateDynamic3DTextLabel("[LSFD Locker Room]{DEDEDE}\nAvailable commands:{ffffff} /duty, /armory, /uniform",
		0xB83333FF, Server [ E_SERVER_MEDIC_KIOSK_X ], Server [ E_SERVER_MEDIC_KIOSK_Y ], Server [ E_SERVER_MEDIC_KIOSK_Z ],
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Server [ E_SERVER_MEDIC_KIOSK_VW ], Server [ E_SERVER_MEDIC_KIOSK_INT ]
	);

	Server [ DEA_KIOSK_LABEL ] = CreateDynamic3DTextLabel("[DEA Armory]{DEDEDE}\nAvailable commands:{ffffff} /duty, /kev, /armory, /uniform",
		0x910023FF, Server [ E_SERVER_DEA_KIOSK_X ], Server [ E_SERVER_DEA_KIOSK_Y ], Server [ E_SERVER_DEA_KIOSK_Z ],
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Server [ E_SERVER_DEA_KIOSK_VW ], Server [ E_SERVER_DEA_KIOSK_INT ]
	);

	Server [ SHERIFF_KIOSK_LABEL ] = CreateDynamic3DTextLabel("[Sheriff Armory]{DEDEDE}\nAvailable commands:{ffffff} /duty, /kev, /armory, /uniform",
		0x910023FF, Server [ E_SERVER_SHERIFF_KIOSK_X ], Server [ E_SERVER_SHERIFF_KIOSK_Y ], Server [ E_SERVER_SHERIFF_KIOSK_Z ],
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Server [ E_SERVER_SHERIFF_KIOSK_VW ], Server [ E_SERVER_SHERIFF_KIOSK_INT ]
	);
	*/
}

IsAtKisok(playerid)
{ 
	new vw = GetPlayerVirtualWorld(playerid);
	new int = GetPlayerInterior(playerid);

	for (new i = 0; i < sizeof(Armory); i ++)
	{	
		if (IsPlayerInRangeOfPoint(playerid, 5.0, Armory[i][E_ARMORY_X], Armory[i][E_ARMORY_Y], Armory[i][E_ARMORY_Z]))
		{
			if (Armory[i][E_ARMORY_INT] != -1 && int != Armory[i][E_ARMORY_INT]) return -1;
			if (Armory[i][E_ARMORY_VW] != -1 && vw != Armory[i][E_ARMORY_VW]) return -1;

			return i;
		}
	}

	return -1;
}

static ArmoryDlgStr[512];

CMD:gotokiosk(playerid)
{
	if (!GetPlayerAdminLevel(playerid)) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not authorized to do this.");
	new map[20], count;

	inline Kiosk_Selection(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, response, dialogid, listitem, inputtext

		if ( response ) 
		{
			new chosen = map[listitem];

			if (Armory[chosen][E_ARMORY_INT] != -1) SetPlayerInterior(playerid, Armory[chosen][E_ARMORY_INT]);
			if (Armory[chosen][E_ARMORY_VW] != -1) SetPlayerVirtualWorld(playerid, Armory[chosen][E_ARMORY_VW]);
			SOLS_SetPosWithFade(playerid, Armory[chosen][E_ARMORY_X], Armory[chosen][E_ARMORY_Y], Armory[chosen][E_ARMORY_Z]);

			AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Teleported to the %s kiosk", Armory[chosen][E_ARMORY_NAME]));
			SendAdminCmd(playerid, sprintf("Teleported to the %s kiosk", Armory[chosen][E_ARMORY_NAME]));
		}
	}

	ArmoryDlgStr[0] = EOS;
	for (new i = 0; i < sizeof(Armory); i ++)
	{
		if (Armory[i][E_ARMORY_HIDDEN]) continue;
		format(ArmoryDlgStr, sizeof(ArmoryDlgStr), "%s%s\n", ArmoryDlgStr, Armory[i][E_ARMORY_NAME]);

		map[count] = i;
		count ++;
	}

	Dialog_ShowCallback(playerid, using inline Kiosk_Selection, DIALOG_STYLE_LIST, "Kiosk Teleport", ArmoryDlgStr, "Select", "Close");
	return true;
}

CMD:gotoarmory(playerid)
{
	return cmd_gotokiosk(playerid);
}

CMD:armory(playerid) 
{
	new f = GetPlayerFactionType(playerid);
	if (f == -1) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction.");

	new k = IsAtKisok(playerid);
	if (k == -1) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near any faction kiosk.");
	else if (Armory[k][E_ARMORY_FAC_TYPE] != f) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't use this kiosk.");

	if (GetPlayerFactionSuspension(playerid))
	{
		new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ];
		if (factionid)
		{
			new faction_enum_id = Faction_GetEnumID(factionid); 
			Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s tried to use the armory while suspended. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false );
			SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't access this because you're currently suspended from the faction.");
		}

		return true;
	}

	new gun_name[32];
	new count, map[MAX_ARMORY_WEAPONS];

	inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, response, dialogid, listitem, inputtext

		if ( response ) 
		{
			new index = map[listitem];

			if (ArmoryWeapon[index][E_ARMORY_WEAPON_TIER] && (Character[playerid][E_CHARACTER_FACTIONTIER] > ArmoryWeapon[index][E_ARMORY_WEAPON_TIER]))
			{
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to take this.");
			}

			if (ArmoryWeapon[index][E_ARMORY_WEAPON_SQUAD] && (Character[playerid][E_CHARACTER_FACTION_SQUAD] != ArmoryWeapon[index][E_ARMORY_WEAPON_SQUAD]))
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the necessary faction squad or division to take this.");
			}

			if (!ArmoryWeapon[index][E_ARMORY_WEAPON_OFF_DUTY] && !PlayerVar[playerid][E_PLAYER_FACTION_DUTY])
			{
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be on duty to take this.");
			}

			if (ArmoryWeapon[index][E_ARMORY_WEAPON_ARMORY_INDEX] && ArmoryWeapon[index][E_ARMORY_WEAPON_ARMORY_INDEX] != Armory[k][E_ARMORY_INDEX])
			{
				return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You are not at the correct armory for this.");
			}

			Weapon_GetGunName ( ArmoryWeapon[index][E_ARMORY_WEAPON_ID], gun_name, sizeof(gun_name) ) ;				
			GiveCustomWeapon ( playerid, ArmoryWeapon[index][E_ARMORY_WEAPON_ID], ArmoryWeapon[index][E_ARMORY_WEAPON_AMMO] ); 

			//new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
			//new faction_enum_id = Faction_GetEnumID(factionid ); 

			AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Took a %s (%d Ammo) from the %s", gun_name, ArmoryWeapon[index][E_ARMORY_WEAPON_AMMO], Armory[k][E_ARMORY_NAME]));

			/*
			Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",
				Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), gun_name), faction_enum_id, false ) ;
			*/

		}
	}

	format(ArmoryDlgStr, sizeof(ArmoryDlgStr), "Weapon\tTier Limit") ;
	for (new i = 0; i < sizeof(ArmoryWeapon); i ++)
	{
		if (ArmoryWeapon[i][E_ARMORY_WEAPON_FAC_TYPE] != f) continue;
		if (ArmoryWeapon[i][E_ARMORY_WEAPON_ARMORY_INDEX] && ArmoryWeapon[i][E_ARMORY_WEAPON_ARMORY_INDEX] != Armory[k][E_ARMORY_INDEX]) continue;

		Weapon_GetGunName(ArmoryWeapon[i][E_ARMORY_WEAPON_ID], gun_name, sizeof(gun_name));
		format(ArmoryDlgStr, sizeof(ArmoryDlgStr), "%s\n%s\tTier %d", ArmoryDlgStr, gun_name, ArmoryWeapon[i][E_ARMORY_WEAPON_TIER]);

		map[count] = i;
		count ++;
	}

	if (count)
	{
		Dialog_ShowCallback(playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, Armory[k][E_ARMORY_NAME], ArmoryDlgStr, "Take", "Close");
	}
	else
	{
		SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This kiosk does not have an armory.");
	}

	return true ;
}

CMD:duty(playerid) 
{
	if (!IsPlayerInDutyFaction(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can go on or off duty.");
	}

	new vehicleid = INVALID_VEHICLE_ID;

	if (!IsPlayerInDEAFaction(playerid) && !IsPlayerNearKiosk(playerid))
	{
		if (PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ])
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can only go off duty at a faction armory.");
		}

		vehicleid = GetClosestVehicleEx(playerid, 7.5);

		if (vehicleid == INVALID_VEHICLE_ID || !IsFactionVehicle(vehicleid, Character[playerid][E_CHARACTER_FACTIONID]))
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not at a faction armory or vehicle.");
		}
	}

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID(factionid ); 
	new string [ 144 ] ;
	new suspension = GetPlayerFactionSuspension(playerid);
	new f = GetPlayerFactionType(playerid);

	if ( PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]  ) 
	{
		// Go off duty
		PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = false ;

		if ( GetCharacterArmour ( playerid ) != 0 ) {

			SetCharacterArmour ( playerid, 0 );
		}

		if (IsPlayerInPoliceFaction(playerid) || IsPlayerInDEAFaction(playerid))
		{
			// DEA/Police get EVERYTHING taken (as they can take an off duty handgun and might have other guns)
			Weapon_ResetPlayerWeapons(playerid);
		}
		else
		{
			// Other factions only get armory weapons taken
			for (new i = 0; i < sizeof(ArmoryWeapon); i ++)
			{
				if (ArmoryWeapon[i][E_ARMORY_WEAPON_FAC_TYPE] != f) continue;
				RemovePlayerCustomWeapon(playerid, ArmoryWeapon[i][E_ARMORY_WEAPON_ID]);
			}
		}

		// Also make sure any tazer is removed
		if (PlayerVar[playerid][E_PLAYER_TASER_EQUIPPED])
		{
			RemovePlayerCustomWeapon(playerid, 65);
			PlayerVar[playerid][E_PLAYER_TASER_EQUIPPED] = false;
		}		

		PlayerVar[playerid][E_PLAYER_BEANBAG_EQUIPPED] = false;
		PlayerVar[playerid][E_PLAYER_TACKLE_ACTIVE] = false;

		format ( string, sizeof ( string ), "has gone off duty" ) ;
	}
	else if ( ! PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]  ) 
	{ 
		// Go on duty
		if (suspension && factionid && faction_enum_id != INVALID_FACTION_ID)
		{
			Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s tried to go on duty while suspended. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false );
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't do this because you're currently suspended from the faction.");
		}

		PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = true ;

		if (vehicleid != INVALID_VEHICLE_ID)
		{	
			format ( string, sizeof ( string ), "has gone on duty at a \"%s\" (%d)", ReturnVehicleName(vehicleid), vehicleid ) ;
		}
		else
		{
			format ( string, sizeof ( string ), "has gone on duty" ) ;
		}
		
	}

	CallLocalFunction("SOLS_OnDutyStateChange", "d", playerid);

	SetCharacterHealth ( playerid, 100 );
	Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), string
	), faction_enum_id, false, false, 0, true ) ;

	return true ;
}

CMD:kevlar(playerid, params[]) 
{
    if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true) 
		&& !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_ARSON, FACTION_TYPE_EMS, true) 
		&& !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_ARMED, FACTION_TYPE_SECURITY, true)
		&& !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_DAO, FACTION_TYPE_GOV, true)
	)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a faction that has kevlar.");
	}

	if (!IsPlayerNearKiosk(playerid)) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not at the locker room.");

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
	
	SetCharacterHealth(playerid, 100);
	SetCharacterArmour(playerid, 100);

	//new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	//new faction_enum_id = Faction_GetEnumID(factionid ); 

	/*
	Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has taken kevlar from the armory. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true )
	), faction_enum_id, false ) ;
	*/

	return true ;
}

IsPlayerNearKiosk(playerid) 
{
	/*
	if ( IsPlayerInSheriffFaction(playerid) && IsPlayerInRangeOfPoint ( playerid, 5.0,  Server [ E_SERVER_SHERIFF_KIOSK_X ], 
		Server [ E_SERVER_SHERIFF_KIOSK_Y ], Server [ E_SERVER_SHERIFF_KIOSK_Z ] ) && 
		GetPlayerVirtualWorld ( playerid ) == Server [ E_SERVER_SHERIFF_KIOSK_VW ] &&
		GetPlayerInterior ( playerid ) == Server [ E_SERVER_SHERIFF_KIOSK_INT ] ) {

		return true ;
	}
	else if ( IsPlayerInPoliceFaction(playerid) && IsPlayerInRangeOfPoint ( playerid, 5.0,  Server [ E_SERVER_POLICE_KIOSK_X ], 
		Server [ E_SERVER_POLICE_KIOSK_Y ], Server [ E_SERVER_POLICE_KIOSK_Z ] ) && 
		GetPlayerVirtualWorld ( playerid ) == Server [ E_SERVER_POLICE_KIOSK_VW ] &&
		GetPlayerInterior ( playerid ) == Server [ E_SERVER_POLICE_KIOSK_INT ] ) {

		return true ;
	}
	else if ( IsPlayerInMedicFaction(playerid) && IsPlayerInRangeOfPoint ( playerid, 5.0,  Server [ E_SERVER_MEDIC_KIOSK_X ], 
		Server [ E_SERVER_MEDIC_KIOSK_Y ], Server [ E_SERVER_MEDIC_KIOSK_Z ] ) && 
		GetPlayerVirtualWorld ( playerid ) == Server [ E_SERVER_MEDIC_KIOSK_VW ] &&
		GetPlayerInterior ( playerid ) == Server [ E_SERVER_MEDIC_KIOSK_INT ] ) {

		return true ;
	}
	else if ( IsPlayerInDEAFaction(playerid) && IsPlayerInRangeOfPoint ( playerid, 5.0,  Server [ E_SERVER_DEA_KIOSK_X ], 
		Server [ E_SERVER_DEA_KIOSK_Y ], Server [ E_SERVER_DEA_KIOSK_Z ] ) && 
		GetPlayerVirtualWorld ( playerid ) == Server [ E_SERVER_DEA_KIOSK_VW ] &&
		GetPlayerInterior ( playerid ) == Server [ E_SERVER_DEA_KIOSK_INT ] ) {

		return true ;
	}
	*/


	new f = GetPlayerFactionType(playerid);
	if (f == -1) return false;

	new k = IsAtKisok(playerid);
	if (k == -1) return false;

	return (Armory[k][E_ARMORY_FAC_TYPE] == f);
}

/*
CMD:movedeaarmory(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Server [ E_SERVER_DEA_KIOSK_X ] = x ;
	Server [ E_SERVER_DEA_KIOSK_Y ] = y ;
	Server [ E_SERVER_DEA_KIOSK_Z ] = z ;

	Server [ E_SERVER_DEA_KIOSK_VW ] = GetPlayerVirtualWorld ( playerid ) ;
	Server [ E_SERVER_DEA_KIOSK_INT ] = GetPlayerInterior ( playerid ) ;



	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE server SET dea_kiosk_x = '%f', dea_kiosk_y = '%f', dea_kiosk_z = '%f', dea_kiosk_vw = %d, dea_kiosk_int = %d",

		Server [ E_SERVER_DEA_KIOSK_X ],
		Server [ E_SERVER_DEA_KIOSK_Y ],
		Server [ E_SERVER_DEA_KIOSK_Z ],
		Server [ E_SERVER_DEA_KIOSK_VW ],
		Server [ E_SERVER_DEA_KIOSK_INT ]
	);

	mysql_tquery(mysql, query);

	query[0]=EOS;
    format ( query, sizeof ( query ), "[DEA Armory]: (%d) %s has moved the armory to their current location. Inform the DEA!", playerid, ReturnPlayerNameData ( playerid )  ) ;
	SendAdminMessage(query) ;

	Kiosk_LoadEntities () ;

	return true ;
}

CMD:movepdarmory(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Server [ E_SERVER_POLICE_KIOSK_X ] = x ;
	Server [ E_SERVER_POLICE_KIOSK_Y ] = y ;
	Server [ E_SERVER_POLICE_KIOSK_Z ] = z ;

	Server [ E_SERVER_POLICE_KIOSK_VW ] = GetPlayerVirtualWorld ( playerid ) ;
	Server [ E_SERVER_POLICE_KIOSK_INT ] = GetPlayerInterior ( playerid ) ;



	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE server SET police_kiosk_x = '%f', police_kiosk_y = '%f', police_kiosk_z = '%f', police_kiosk_vw = %d, police_kiosk_int = %d",

		Server [ E_SERVER_POLICE_KIOSK_X ],
		Server [ E_SERVER_POLICE_KIOSK_Y ],
		Server [ E_SERVER_POLICE_KIOSK_Z ],
		Server [ E_SERVER_POLICE_KIOSK_VW ],
		Server [ E_SERVER_POLICE_KIOSK_INT ]
	);

	mysql_tquery(mysql, query);

	query[0]=EOS;
    format ( query, sizeof ( query ), "[PD Armory]: (%d) %s has moved the armory to their current location. Inform the LSPD!", playerid, ReturnPlayerNameData ( playerid )  ) ;
	SendAdminMessage(query) ;

	Kiosk_LoadEntities () ;

	return true ;
}

CMD:movesdarmory(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Server [ E_SERVER_SHERIFF_KIOSK_X ] = x ;
	Server [ E_SERVER_SHERIFF_KIOSK_Y ] = y ;
	Server [ E_SERVER_SHERIFF_KIOSK_Z ] = z ;

	Server [ E_SERVER_SHERIFF_KIOSK_VW ] = GetPlayerVirtualWorld ( playerid ) ;
	Server [ E_SERVER_SHERIFF_KIOSK_INT ] = GetPlayerInterior ( playerid ) ;



	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE server SET sheriff_kiosk_x = '%f', sheriff_kiosk_y = '%f', sheriff_kiosk_z = '%f', sheriff_kiosk_vw = %d, sheriff_kiosk_int = %d",

		Server [ E_SERVER_SHERIFF_KIOSK_X ],
		Server [ E_SERVER_SHERIFF_KIOSK_Y ],
		Server [ E_SERVER_SHERIFF_KIOSK_Z ],
		Server [ E_SERVER_SHERIFF_KIOSK_VW ],
		Server [ E_SERVER_SHERIFF_KIOSK_INT ]
	);

	mysql_tquery(mysql, query);

	query[0]=EOS;
    format ( query, sizeof ( query ), "[SD Armory]: (%d) %s has moved the armory to their current location. Inform the LSSD!", playerid, ReturnPlayerNameData ( playerid )  ) ;
	SendAdminMessage(query) ;

	Kiosk_LoadEntities () ;

	return true ;
}

CMD:moveemsarmory(playerid) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	Server [ E_SERVER_MEDIC_KIOSK_X ] = x ;
	Server [ E_SERVER_MEDIC_KIOSK_Y ] = y ;
	Server [ E_SERVER_MEDIC_KIOSK_Z ] = z ;

	Server [ E_SERVER_MEDIC_KIOSK_VW ] = GetPlayerVirtualWorld ( playerid ) ;
	Server [ E_SERVER_MEDIC_KIOSK_INT ] = GetPlayerInterior ( playerid ) ;



	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"UPDATE server SET medic_kiosk_x = '%f', medic_kiosk_y = '%f', medic_kiosk_z = '%f', medic_kiosk_vw = %d, medic_kiosk_int = %d",

		Server [ E_SERVER_MEDIC_KIOSK_X ],
		Server [ E_SERVER_MEDIC_KIOSK_Y ],
		Server [ E_SERVER_MEDIC_KIOSK_Z ],
		Server [ E_SERVER_MEDIC_KIOSK_VW ],
		Server [ E_SERVER_MEDIC_KIOSK_INT ]
	);

	mysql_tquery(mysql, query);

	query[0]=EOS;
    format ( query, sizeof ( query ), "[EMS Armory]: (%d) %s has moved the armory to their current location. Inform the LSFD!", playerid, ReturnPlayerNameData ( playerid )  ) ;
	SendAdminMessage(query) ;

	Kiosk_LoadEntities () ;

	return true ;
}
*/

/*
CMD:armory(playerid) {

	if ( IsPlayerNearKiosk ( playerid ) ) {

		new string [ 256 ] ;
		new suspension = GetPlayerFactionSuspension(playerid);

		if (suspension)
		{
			new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ];
			if (factionid)
			{
				new faction_enum_id = Faction_GetEnumID(factionid); 
				Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s tried to use the armory while suspended. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false );
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't access this because you're currently suspended from the faction.");
			}
		}

		if (IsPlayerInSheriffFaction(playerid))
		{
			inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) {
			    #pragma unused pid, response, dialogid, listitem, inputtext

				if ( response ) {

					new weapon_idx, ammo, weapon_name [ 32 ] ;

					switch ( listitem ) 
					{
						case 0: weapon_idx = 67, ammo = 42 ; // Pistol
						case 1: weapon_idx = 3, ammo = 1 ; // Baton
						case 2: weapon_idx = 11, ammo = 15000 ; // Pepperspray
						case 3: weapon_idx = 45, ammo = 25  ; // Shotgun
						case 4: weapon_idx = 63, ammo = 100  ; // Camera
					}

					if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3 && listitem != 1 && listitem != 2 && listitem != 4)
					{
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
					}

					if (!IsPlayerInPoliceFaction(playerid, true) && listitem != 0)
					{
						// PD off duty gun
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be on duty to take this." ) ;
					}

					Weapon_GetGunName ( weapon_idx, weapon_name, sizeof  (weapon_name ) ) ;				
					GiveCustomWeapon ( playerid, weapon_idx, ammo ); 

					new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
					new faction_enum_id = Faction_GetEnumID(factionid ); 
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",

						Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), weapon_name
					), faction_enum_id, false ) ;
				}

				return true ;
			}

			format(string, sizeof(string), "Description\tTier Limit\n" ) ;
			format ( string, sizeof ( string ), "%sDuty-issued Handgun\tTier 3\nBaton / Nightstick\tTier 4\nPepper Spray\tTier 4\nPatrol Shotgun\tTier 3\nCamera\tTier 4", string ) ;
			Dialog_ShowCallback ( playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, "Sheriff Armory", string, "OK", "" );
		}

		else if (IsPlayerInPoliceFaction(playerid)) 
		{
			inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) {
			    #pragma unused pid, response, dialogid, listitem, inputtext

				if ( response ) {

					new weapon_idx, ammo, weapon_name [ 32 ] ;

					switch ( listitem ) 
					{
						case 0: weapon_idx = 67, ammo = 42 ; // Pistol
						case 1: weapon_idx = 3, ammo = 1 ; // Baton
						case 2: weapon_idx = 11, ammo = 15000 ; // Pepperspray
						case 3: weapon_idx = 45, ammo = 25  ; // Shotgun
		
						case 4: {
							if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_SWAT)) {
								return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be SWAT or Tier 1 to take this from the armory." ) ;
							}

							weapon_idx = 35; 
							ammo = 150; // MP5
						}

						case 5: {
							if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_SWAT))  {
								return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be SWAT or Tier 1 to take this from the armory." ) ;
							} 
							weapon_idx = 40 ;
							ammo = 200 ; // M4
						}
						case 6: {
							if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_SWAT) ) {
								return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be SWAT or Tier 1 to take this from the armory." ) ;
							} 
							weapon_idx = 60 ;
							ammo = 25 ; // sniper
						}
						case 7: {
							if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_SWAT)) {
								return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be SWAT or Tier 1 to take this from the armory." ) ;
							} 
							weapon_idx = 49 ;
							ammo = 50 ; // SPAZ
						}

						case 8: weapon_idx = 63, ammo = 100  ; // Camera
					}

					if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3 && listitem != 1 && listitem != 2 && listitem != 8)
					{
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
					}

					if (!IsPlayerInPoliceFaction(playerid, true) && listitem != 0)
					{
						// PD off duty gun
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be on duty to take this." ) ;
					}

					if (listitem > 3 && listitem < 8 && listitem != 7)
					{
						SendClientMessage(playerid, COLOR_ERROR, "Taking SWAT weapons from the armory is discouraged, please use /swat instead.");
					}

					Weapon_GetGunName ( weapon_idx, weapon_name, sizeof  (weapon_name ) ) ;
				
					GiveCustomWeapon ( playerid, weapon_idx, ammo ); 

					new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
					new faction_enum_id = Faction_GetEnumID(factionid ); 
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",

						Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), weapon_name
					), faction_enum_id, false ) ;
				}

				return true ;
			}


			format(string, sizeof(string), "Description\tTier Limit\n" ) ;

			format ( string, sizeof ( string ), 
				"%sDuty-issued Handgun\tTier 3\nBaton / Nightstick\tTier 4\nPepper Spray\tTier 4\nPatrol Shotgun\tTier 3\
				\nSubmachinegun\tTier 1 (SWAT)\
				\nAssault Rifle\tTier 1 (SWAT)\nSniper Rifle\tTier 1 (SWAT)\nCombat Shotgun\tTier 1 (SWAT)\nCamera\tTier 4", string ) ;

			Dialog_ShowCallback ( playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, "Police Armory", string, "OK", "" );
		}

		else if ( IsPlayerInMedicFaction(playerid, true) ) {
			inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) {
			    #pragma unused pid, response, dialogid, listitem, inputtext

				if ( response ) {

					new weapon_idx, ammo, weapon_name [ 32 ] ;

					switch ( listitem ) {

						case 0: weapon_idx = 11, ammo = 15000 ; // Pepperspray
						case 1: weapon_idx = 66, ammo = 1500 ; // Fire Extinguisher
						case 2: weapon_idx = 6, ammo = 1 ; // Shovel
						case 3: weapon_idx = 9, ammo = 1 ; // Chainsaw
					}

					if (listitem == 3)
					{
						if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2)
							return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You need to be at least tier 2 to be able to access this weapon." ) ;

						SendServerMessage ( playerid, COLOR_ERROR, "Warning", "A3A3A3", "The chainsaw is only for roleplay purposes, never use it as a weapon." ) ;
					}

					if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3 && listitem != 1)
					{
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
					}

					Weapon_GetGunName ( weapon_idx, weapon_name, sizeof  (weapon_name ) ) ;
				
					GiveCustomWeapon ( playerid, weapon_idx, ammo ); 

					new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
					new faction_enum_id = Faction_GetEnumID(factionid ); 
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",

						Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), weapon_name
					), faction_enum_id, false ) ;
				}

				return true ;
			}


			format(string, sizeof(string), "Description \t Tier Limit\n" ) ;

			format ( string, sizeof ( string ), 
				"%sMace (Pepperspray)\tTier 3\nFire Extinguisher\tTier 4\nShovel\tTier 3\nChainsaw\tTier 2", string ) ;

			Dialog_ShowCallback ( playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, "LSFD Armory", string, "OK", "" );

		}

		else if (IsPlayerInDEAFaction(playerid)) 
		{
			new guns[4] = {4, 67, 35, 63};  // Knife, Pistol, MP5, Camera
			new ammos[4] = {1, 42, 90, 100}; // Knife, Pistol, MP5, Camera
			new tiers[4] = {3, 3, 3, 4};
			new gun_name[32];

			inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) 
			{
			    #pragma unused pid, response, dialogid, listitem, inputtext

				if ( response ) 
				{
					new gun = guns[listitem];
					new ammo = ammos[listitem];
					new tier = tiers[listitem];

					if (Character[playerid][E_CHARACTER_FACTIONTIER] > tier)
					{
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
					}
		
					Weapon_GetGunName ( gun, gun_name, sizeof(gun_name ) ) ;
					GiveCustomWeapon ( playerid, gun, ammo ); 

					new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
					new faction_enum_id = Faction_GetEnumID(factionid ); 
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",

						Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), gun_name
					), faction_enum_id, false ) ;
				}

				return true ;
			}

			format(string, sizeof(string), "Weapon\tTier Limit") ;
			
			for (new i = 0; i < sizeof(guns); i ++)
			{
				Weapon_GetGunName ( guns[i], gun_name, sizeof  (gun_name ) ) ;
				format(string, sizeof(string), "%s\n%s\tTier %d", string, gun_name, tiers[i]) ;
			}

			Dialog_ShowCallback ( playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, "DEA Armory", string, "Take", "Close" );
		}

		else if (IsPlayerInSecurityFaction(playerid)) 
		{
			new guns[4] = {3, 11, 66};  // Nightstick, Spraycan, Fire Extinguisher 
			new ammos[4] = {1, 999, 999}; // Nightstick, Spraycan, Fire Extinguisher 
			new tiers[4] = {3, 3, 3};
			new gun_name[32];

			inline Armory_Selection(pid, dialogid, response, listitem, string:inputtext[]) 
			{
			    #pragma unused pid, response, dialogid, listitem, inputtext

				if ( response ) 
				{
					new gun = guns[listitem];
					new ammo = ammos[listitem];
					new tier = tiers[listitem];

					if (Character[playerid][E_CHARACTER_FACTIONTIER] > tier)
					{
						return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
					}
		
					Weapon_GetGunName ( gun, gun_name, sizeof(gun_name ) ) ;
					GiveCustomWeapon ( playerid, gun, ammo ); 

					new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
					new faction_enum_id = Faction_GetEnumID(factionid ); 
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has taken a %s from the armory. }",

						Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), gun_name
					), faction_enum_id, false ) ;
				}

				return true ;
			}

			format(string, sizeof(string), "Weapon\tTier Limit") ;
			
			for (new i = 0; i < sizeof(guns); i ++)
			{
				Weapon_GetGunName ( guns[i], gun_name, sizeof  (gun_name ) ) ;
				format(string, sizeof(string), "%s\n%s\tTier %d", string, gun_name, tiers[i]) ;
			}

			Dialog_ShowCallback ( playerid, using inline Armory_Selection, DIALOG_STYLE_TABLIST_HEADERS, "Security Armory", string, "Take", "Close" );
		}

		else return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a faction with an armory.");

	}

	else return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near the police armory.");

	return true ;
}
*/

forward SOLS_OnDutyStateChange(playerid);
public SOLS_OnDutyStateChange(playerid)
{
	// Hook this
	//printf("SOLS_OnDutyStateChange: %d", playerid);
	return 1;
}

/*
CMD:duty(playerid) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID(factionid ); 

	new string [ 144 ] ;

	new suspension = GetPlayerFactionSuspension(playerid);

	if (IsPlayerInNewsFaction(playerid))
	{
		// TEMP SAN DUTY
		if (IsPlayerInRangeOfPoint(playerid, 5.0, 750.7045, -1366.5341, 9053.4209))
		{
			if ( PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]  ) 
			{
				PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = false;
				format ( string, sizeof ( string ), "has gone off duty" ) ;
			}
			else
			{
				if (suspension && factionid && faction_enum_id)
				{
					Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s tried to go on duty while suspended. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false );
					return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't do this because you're currently suspended from the faction.");
				}

				PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = true;
				format ( string, sizeof ( string ), "has gone on duty" ) ;
			}

			SetCharacterHealth ( playerid, 100 );
			Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s %s. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), string), faction_enum_id, false ) ;
			return true;
		}

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in the newsroom.");
	}


	if (!IsPlayerInPoliceFaction(playerid) && !IsPlayerInMedicFaction(playerid) && !IsPlayerInDEAFaction(playerid))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a government faction.");

	
	if ( IsPlayerNearKiosk ( playerid ) ) {

		if ( PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]  ) {
			// Go off duty

			PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = false ;

			if ( GetCharacterArmour ( playerid ) != 0 ) {

				SetCharacterArmour ( playerid, 0 );
			}

			Weapon_ResetPlayerWeapons(playerid);

			format ( string, sizeof ( string ), "has gone off duty" ) ;
		}

		else if ( ! PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]  ) { 
			// Go on duty

			if (suspension && factionid && faction_enum_id)
			{
				Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s tried to go on duty while suspended. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false );
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't do this because you're currently suspended from the faction.");
			}

			PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = true ;

			format ( string, sizeof ( string ), "has gone on duty" ) ;
		}

		CallLocalFunction("SOLS_OnDutyStateChange", "d", playerid);

		SetCharacterHealth ( playerid, 100 );
		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s %s. }",

			Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid, 0, true ), string
		), faction_enum_id, false ) ;
	}

	else return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near the faction armory.");

	return true ;
}
*/

CMD:kev(playerid, params[]) {

	return cmd_kevlar(playerid, params);
}

/*
CMD:kevlar(playerid, params[]) {

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    	
	if (!IsPlayerNearKiosk(playerid))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near the armory!" ) ;

    if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty as a police officer.");

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3)
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not a high enough tier of employee to do this.");
	
	SetCharacterHealth(playerid, 100);
	SetCharacterArmour(playerid, 100);

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	new faction_enum_id = Faction_GetEnumID(factionid ); 

	Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has taken kevlar from the armory. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true )
	), faction_enum_id, false ) ;

	return true ;
}
*/

stock Kiosk_GetGunPrice(weapon) {
	new gun_cost ;

	switch ( weapon ) {
		case 1 .. 8: 	gun_cost = 25 ;
		case 9:	 		gun_cost = 50 ;
		case 10 .. 15: 	gun_cost = 20 ;
		case 16 .. 18: 	gun_cost = 125 ;
		case 22 .. 23: 	gun_cost = 150 ;
		case 24: 		gun_cost = 250 ;
		case 25: 		gun_cost = 300 ;
		case 26: 		gun_cost = 325 ;
		case 27: 		gun_cost = 350 ;
		case 28: 		gun_cost = 250 ;
		case 29:		gun_cost = 275 ;
		case 30: 		gun_cost = 500 ;
		case 31: 		gun_cost = 750 ;
		case 32: 		gun_cost = 225 ;
		case 33: 		gun_cost = 800 ;
		case 34: 		gun_cost = 1000 ;
		default: {
			gun_cost = 25 ;
		}
	}

	return gun_cost ;
}