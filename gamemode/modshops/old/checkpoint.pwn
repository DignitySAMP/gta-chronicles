

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new modshop = MS_TYPE_NONE;
	for (new ms = 0; ms < MAX_MOD_SHOPS; ms++)
	{
		if (modshopcps[ms] != checkpointid) continue;
		modshop = ms;
		break;
	}
	switch (modshop)
	{
		case MS_TYPE_TRANSFENDER_LS, MS_TYPE_TRANSFENDER_SF, MS_TYPE_TRANSFENDER_LV:
		{
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				return 1;
			}

			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleModel(vehicleid);

			if (vehiclevalidmods[modelid-400][0] == 0)
			{
				return 1;
			}

			switch (modelid)
			{
				case 483:
				{

					if (modshop == MS_TYPE_TRANSFENDER_LS)
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, 1041.354, -1022.302 - 12.5, 31.127 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}
					else if (modshop == MS_TYPE_TRANSFENDER_SF)
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, -1935.847, 242.876 - 12.5, 33.561 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}
					else// modshop == MS_TYPE_TRANSFENDER_LV
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, 2386.662, 1047.172 - 12.5, 9.812 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}

					SetVehiclePos(vehicleid, 617.536, -1.99, 999.98 + 1.0);
					SetVehicleZAngle(vehicleid, 90.0);
					SetVehicleVirtualWorld(vehicleid, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
					LinkVehicleToInterior(vehicleid, 1);

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (IsPlayerInVehicle(i, vehicleid))
						{
							SetPlayerVirtualWorld(i, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
							SetPlayerInterior(i, 1);
							SetPlayerCameraPos(i, 612.7667, 0.5696, 1002.114);
							SetPlayerCameraLookAt(i, 613.6664, 0.1645, 1001.951);
							TogglePlayerControllable(i, 0); //
							PlayerModshopData [ i ] [ E_PLAYER_MODSHOP ] = modshop;
						}
					}

					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][0] = 0;
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][1] = 1;
					new c, ctypecount[MAX_COMPONENT_TYPES + 1], temp1 = 2;
					for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						ctypecount[vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type]] ++;
					}
					for (c = 1; c <= MAX_COMPONENT_TYPES; c++)
					{
						if (ctypecount[c] == 0) continue;
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, comptypenames[c-1]);
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = c+1;
						temp1 ++;
					}
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
				}
				default:
				{

					if (modshop == MS_TYPE_TRANSFENDER_LS)
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, 1041.354, -1022.302 - 12.5, 31.127 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}
					else if (modshop == MS_TYPE_TRANSFENDER_SF)
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, -1935.847, 242.876 - 12.5, 33.561 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}
					else// modshop == MS_TYPE_TRANSFENDER_LV
					{
						for (new i = 0; i < MAX_PLAYERS; i++)
						{
							if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
							SetPlayerPos(i, 2386.662, 1047.172 - 12.5, 9.812 + 1.0); // y - 12.5
							SetPlayerFacingAngle(i, 180.0);
						}
					}

					SetVehiclePos(vehicleid, 617.536, -1.99, 999.98 + 1.0);
					SetVehicleZAngle(vehicleid, 90.0);
					SetVehicleVirtualWorld(vehicleid, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
					LinkVehicleToInterior(vehicleid, 1);

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (IsPlayerInVehicle(i, vehicleid))
						{
							SetPlayerVirtualWorld(i, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
							SetPlayerInterior(i, 1);
							SetPlayerCameraPos(i, 612.7667, 0.5696, 1002.114);
							SetPlayerCameraLookAt(i, 613.6664, 0.1645, 1001.951);
							TogglePlayerControllable(i, 0); //
							PlayerModshopData [ i ] [ E_PLAYER_MODSHOP ] = modshop;
						}
					}

					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][0] = 0;
					new c, ctypecount[MAX_COMPONENT_TYPES + 1], temp1 = 1;
					for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						ctypecount[vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type]] ++;
					}
					for (c = 1; c <= MAX_COMPONENT_TYPES; c++)
					{
						if (ctypecount[c] == 0) continue;
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, comptypenames[c-1]);
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = c+1;
						temp1 ++;
					}
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
				}
			}
		}
		case MS_TYPE_LOCOLOW:
		{
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				return 1;
			}

			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleModel(vehicleid);

			if (vehiclevalidmods[modelid-400][0] == 0 || IsVehicleModelAircraft(modelid) || IsVehicleModelBoat(modelid) || IsVehicleModelBicycle(modelid) || modelid == 449 || modelid == 537 || modelid == 538)
			{
				return 1;
			}

			switch (modelid)
			{
				case 534, 535, 536, 567, 575, 576:
				{

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
						SetPlayerPos(i, 2644.877, -2042.556 + 12.5, 12.607 + 1.0); // y + 12.5
						SetPlayerFacingAngle(i, 90.0);
					}

					SetVehiclePos(vehicleid, 616.783, -74.815, 997.014 + 1.0);
					SetVehicleZAngle(vehicleid, 90.0);
					SetVehicleVirtualWorld(vehicleid, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
					LinkVehicleToInterior(vehicleid, 2);

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (IsPlayerInVehicle(i, vehicleid))
						{
							SetPlayerVirtualWorld(i, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
							SetPlayerInterior(i, 2);
							SetPlayerCameraPos(i, 611.9196, -71.983, 998.9867);
							SetPlayerCameraLookAt(i, 612.8176, -72.3798, 998.7969);
							TogglePlayerControllable(i, 0); //
							PlayerModshopData [ i ] [ E_PLAYER_MODSHOP ] = MS_TYPE_LOCOLOW;
						}
					}

					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][0] = 0;
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][1] = 1;
					new c, ctypecount[MAX_COMPONENT_TYPES + 1], temp1 = 2;
					for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						ctypecount[vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type]] ++;
					}
					for (c = 1; c <= MAX_COMPONENT_TYPES; c++)
					{
						if (ctypecount[c] == 0) continue;
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, comptypenames[c-1]);
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = c+1;
						temp1 ++;
					}
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
				}
				case 566:
				{

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
						SetPlayerPos(i, 2644.877, -2042.556 + 12.5, 12.607 + 1.0); // y + 12.5
						SetPlayerFacingAngle(i, 90.0);
					}

					SetVehiclePos(vehicleid, 616.783, -74.815, 997.014 + 1.0);
					SetVehicleZAngle(vehicleid, 90.0);
					SetVehicleVirtualWorld(vehicleid, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
					LinkVehicleToInterior(vehicleid, 2);

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (IsPlayerInVehicle(i, vehicleid))
						{
							SetPlayerVirtualWorld(i, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
							SetPlayerInterior(i, 2);
							SetPlayerCameraPos(i, 611.9196, -71.983, 998.9867);
							SetPlayerCameraLookAt(i, 612.8176, -72.3798, 998.7969);
							TogglePlayerControllable(i, 0); //
							PlayerModshopData [ i ] [ E_PLAYER_MODSHOP ] = modshop;
						}
					}

					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][0] = 0;
					new c, ctypecount[MAX_COMPONENT_TYPES + 1], temp1 = 1;
					for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						ctypecount[vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type]] ++;
					}
					for (c = 1; c <= MAX_COMPONENT_TYPES; c++)
					{
						if (ctypecount[c] == 0) continue;
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, comptypenames[c-1]);
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = c+1;
						temp1 ++;
					}
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
				}
			}
		}
		case MS_TYPE_WHEELARCH:
		{
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			{
				return 1;
			}

			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleModel(vehicleid);

			if (vehiclevalidmods[modelid-400][0] == 0 || IsVehicleModelAircraft(modelid) || IsVehicleModelBoat(modelid) || IsVehicleModelBicycle(modelid) || modelid == 449 || modelid == 537 || modelid == 538)
			{
				return 1;
			}

			switch (modelid)
			{
				case 558, 559, 560, 561, 562, 565:
				{

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (GetPlayerSurfingVehicleID(i) != vehicleid) continue;
						SetPlayerPos(i, -2719.670 + 12.5, 217.481, 3.585 + 1.0); // x + 12.5
						SetPlayerFacingAngle(i, 270.0);
					}

					SetVehiclePos(vehicleid, 615.286, -124.239, 996.995 + 1.0);
					SetVehicleZAngle(vehicleid, 90.0);
					SetVehicleVirtualWorld(vehicleid, VIRTUAL_WORLD_MOD_SHOP + vehicleid);

					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (IsPlayerInVehicle(i, vehicleid))
						{
							SetPlayerVirtualWorld(i, VIRTUAL_WORLD_MOD_SHOP + vehicleid);
							LinkVehicleToInterior(vehicleid, 3);
							SetPlayerInterior(i, 3);
							SetPlayerCameraPos(i, 611.2935, -121.2534, 999.0341);
							SetPlayerCameraLookAt(i, 612.0599, -121.7974, 998.6927);
							TogglePlayerControllable(i, 0); //
							PlayerModshopData [ i ] [ E_PLAYER_MODSHOP ] = modshop;
						}
					}

					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][0] = 0;
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][1] = 1;
					new c, ctypecount[MAX_COMPONENT_TYPES + 1], temp1 = 2;
					for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						ctypecount[vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type]] ++;
					}
					for (c = 1; c <= MAX_COMPONENT_TYPES; c++)
					{
						if (ctypecount[c] == 0) continue;
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, comptypenames[c-1]);
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = c+1;
						temp1 ++;
					}
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
				}
			}
		}
	}
	
	#if defined mod_OnPlayerEnterDynamicCP
		return mod_OnPlayerEnterDynamicCP(playerid, checkpointid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicCP
	#undef OnPlayerEnterDynamicCP
#else
	#define _ALS_OnPlayerEnterDynamicCP
#endif

#define OnPlayerEnterDynamicCP mod_OnPlayerEnterDynamicCP
#if defined mod_OnPlayerEnterDynamicCP
	forward mod_OnPlayerEnterDynamicCP(playerid, checkpointid);
#endif