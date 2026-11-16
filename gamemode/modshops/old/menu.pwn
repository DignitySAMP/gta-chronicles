
public OnPlayerSelectedMenuRow(playerid, row)
{
	if (GetPlayerMenu(playerid) == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ])
	{
		if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 0)
		{
			DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);
			if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row] == 0)
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 2;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row];
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 2, 29.0, 145.0, 186.0, 186.0);
				SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Upgrade");
				SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, "Cost");

				AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
				AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, "$150");
			}
			else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row] == 1)
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 1;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row];
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 1");
				new vehicleid = GetPlayerVehicleID(playerid);
				if (GetVehicleModel(vehicleid) != 483)
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 2");
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 3");
				}

				if (vpaintjob[vehicleid-1] != 3)
				{
					DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], vpaintjob[vehicleid-1]);
				}
			}
			else
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 1;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row];
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_WHEELARCH)
				{
					switch (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row] - 1)
					{
						case COMPONENT_TYPE_SPOILER:
						{
							SetPlayerCameraPos(playerid, 615.7711, -126.8826, 998.7869);
							SetPlayerCameraLookAt(playerid, 616.1115, -125.981, 998.52);
						}
						case COMPONENT_TYPE_SIDESKIRT:
						{
							SetPlayerCameraPos(playerid, 612.551, -126.8767, 997.6746);
							SetPlayerCameraLookAt(playerid, 613.1689, -126.0916, 997.6324);
						}
						case COMPONENT_TYPE_ROOF:
						{
							SetPlayerCameraPos(playerid, 611.6899, -124.1341, 998.957);
							SetPlayerCameraLookAt(playerid, 612.6635, -124.0004, 998.772);
						}
						case COMPONENT_TYPE_WHEELS:
						{
							SetPlayerCameraPos(playerid, 612.551, -126.8767, 997.6746);
							SetPlayerCameraLookAt(playerid, 613.1689, -126.0916, 997.6324);
						}
						case COMPONENT_TYPE_HOOD:
						{
							SetPlayerCameraPos(playerid, 610.8686, -123.9456, 998.8293);
							SetPlayerCameraLookAt(playerid, 611.8196, -123.8469, 998.5366);
						}
						case COMPONENT_TYPE_MISC:
						{
							SetPlayerCameraPos(playerid, 618.9148, -125.9082, 997.2668);
							SetPlayerCameraLookAt(playerid, 618.0776, -125.3645, 997.3261);
						}
						case COMPONENT_TYPE_FRONT_BUMPER, COMPONENT_TYPE_FRONT_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 611.384, -122.4332, 997.4291);
							SetPlayerCameraLookAt(playerid, 612.2263, -122.972, 997.4357);
						}
						case COMPONENT_TYPE_EXHAUST:
						{
							SetPlayerCameraPos(playerid, 618.9148, -125.9082, 997.2668);
							SetPlayerCameraLookAt(playerid, 618.0776, -125.3645, 997.3261);
						}
						case COMPONENT_TYPE_VENTS:
						{
							SetPlayerCameraPos(playerid, 611.1373, -124.2795, 998.1324);
							SetPlayerCameraLookAt(playerid, 612.1359, -124.2299, 998.1481);
						}
						case COMPONENT_TYPE_LAMPS:
						{
							SetPlayerCameraPos(playerid, 610.8206, -126.0154, 997.3317);
							SetPlayerCameraLookAt(playerid, 611.6263, -125.4232, 997.3185);
						}
						case COMPONENT_TYPE_REAR_BUMPER, COMPONENT_TYPE_REAR_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 619.0011, -126.195, 997.444);
							SetPlayerCameraLookAt(playerid, 618.3423, -125.4429, 997.461);
						}
						case COMPONENT_TYPE_NITRO:
						{
							SetPlayerCameraPos(playerid, 617.8134, -126.8104, 999.6476);
							SetPlayerCameraLookAt(playerid, 617.3374, -126.1012, 999.1275);
						}
						case COMPONENT_TYPE_STEREO:
						{
							SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
							SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
						}
						case COMPONENT_TYPE_HYDRAULICS:
						{
							SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
							SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
						}
						default:
						{
							SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
							SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
						}
					}
				}
				else if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_LOCOLOW)
				{
					switch (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row] - 1)
					{
						case COMPONENT_TYPE_SPOILER:
						{
							SetPlayerCameraPos(playerid, 613.5045, -77.61, 997.6773);
							SetPlayerCameraLookAt(playerid, 614.0041, -76.7527, 997.8019);
						}
						case COMPONENT_TYPE_SIDESKIRT:
						{
							SetPlayerCameraPos(playerid, 617.6616, -77.5803, 998.5854);
							SetPlayerCameraLookAt(playerid, 618.0117, -76.6793, 998.329);
						}
						case COMPONENT_TYPE_WHEELS:
						{
							SetPlayerCameraPos(playerid, 616.0645, -77.4652, 998.1566);
							SetPlayerCameraLookAt(playerid, 616.6523, -76.6904, 997.9242);
						}
						case COMPONENT_TYPE_HOOD:
						{
							SetPlayerCameraPos(playerid, 615.7546, -77.9771, 999.3472);
							SetPlayerCameraLookAt(playerid, 616.0991, -77.1049, 998.9999);
						}
						case COMPONENT_TYPE_VENTS:
						{
							SetPlayerCameraPos(playerid, 612.3392, -74.6454, 998.7184);
							SetPlayerCameraLookAt(playerid, 613.3315, -74.5934, 998.6063);
						}
						case COMPONENT_TYPE_EXHAUST:
						{
							SetPlayerCameraPos(playerid, 620.7762, -76.6076, 997.2366);
							SetPlayerCameraLookAt(playerid, 620.051, -75.9492, 997.4383);
						}
						case COMPONENT_TYPE_FRONT_BUMPER, COMPONENT_TYPE_FRONT_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 612.1144, -74.4962, 997.7816);
							SetPlayerCameraLookAt(playerid, 613.111, -74.4536, 997.7114);
						}
						case COMPONENT_TYPE_LAMPS:
						{
							SetPlayerCameraPos(playerid, 620.7762, -76.6076, 997.2366);
							SetPlayerCameraLookAt(playerid, 620.051, -75.9492, 997.4383);
						}
						case COMPONENT_TYPE_MISC:
						{
							SetPlayerCameraPos(playerid, 612.1144, -74.4962, 997.7816);
							SetPlayerCameraLookAt(playerid, 613.111, -74.4536, 997.7114);
						}
						case COMPONENT_TYPE_STEREO:
						{
							SetPlayerCameraPos(playerid, 612.1144, -74.4962, 997.7816);
							SetPlayerCameraLookAt(playerid, 613.111, -74.4536, 997.7114);
						}
						case COMPONENT_TYPE_HYDRAULICS:
						{
							SetPlayerCameraPos(playerid, 612.1144, -74.4962, 997.7816);
							SetPlayerCameraLookAt(playerid, 613.111, -74.4536, 997.7114);
						}
						case COMPONENT_TYPE_REAR_BUMPER, COMPONENT_TYPE_REAR_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 620.8461, -76.8773, 997.3512);
							SetPlayerCameraLookAt(playerid, 620.2133, -76.1111, 997.4626);
						}
						case COMPONENT_TYPE_NITRO:
						{
							SetPlayerCameraPos(playerid, 621.0414, -74.9455, 998.9329);
							SetPlayerCameraLookAt(playerid, 620.0759, -74.9535, 998.6727);
						}
						case COMPONENT_TYPE_ROOF:
						{
							SetPlayerCameraPos(playerid, 612.2584, -72.1851, 998.8818);
							SetPlayerCameraLookAt(playerid, 613.1286, -72.6701, 998.7961);
						}
						default:
						{
							SetPlayerCameraPos(playerid, 611.9196, -71.983, 998.9867);
							SetPlayerCameraLookAt(playerid, 612.8176, -72.3798, 998.7969);
						}
					}
				}
				else
				{
					switch (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row] - 1)
					{
						case COMPONENT_TYPE_STEREO:
						{
							SetPlayerCameraPos(playerid, 612.7667, 0.5696, 1002.114);
							SetPlayerCameraLookAt(playerid, 613.6664, 0.1645, 1001.951);
						}
						case COMPONENT_TYPE_WHEELS:
						{
							SetPlayerCameraPos(playerid, 614.4382, -4.5756, 1000.632);
							SetPlayerCameraLookAt(playerid, 614.9804, -3.7381, 1000.565);
						}
						case COMPONENT_TYPE_SPOILER:
						{
							SetPlayerCameraPos(playerid, 618.1872, -5.3884, 1002.423);
							SetPlayerCameraLookAt(playerid, 618.4805, -4.4899, 1002.097);
						}
						case COMPONENT_TYPE_SIDESKIRT:
						{
							SetPlayerCameraPos(playerid, 615.6667, -4.5419, 1000.27);
							SetPlayerCameraLookAt(playerid, 616.2391, -3.7425, 1000.452);
						}
						case COMPONENT_TYPE_ROOF:
						{
							SetPlayerCameraPos(playerid, 613.6697, -1.4788, 1002.232);
							SetPlayerCameraLookAt(playerid, 614.647, -1.5313, 1002.027);
						}
						case COMPONENT_TYPE_HOOD:
						{
							SetPlayerCameraPos(playerid, 613.5347, -1.7916, 1002.526);
							SetPlayerCameraLookAt(playerid, 614.4059, -1.7952, 1002.035);
						}
						case COMPONENT_TYPE_MISC:
						{
							SetPlayerCameraPos(playerid, 621.9104, -3.6269, 1000.408);
							SetPlayerCameraLookAt(playerid, 621.0475, -3.1303, 1000.314);
						}
						case COMPONENT_TYPE_LAMPS:
						{
							SetPlayerCameraPos(playerid, 611.6121, -1.4851, 1001.777);
							SetPlayerCameraLookAt(playerid, 612.6027, -1.507, 1001.642);
						}
						case COMPONENT_TYPE_EXHAUST:
						{
							SetPlayerCameraPos(playerid, 621.4796, -3.4952, 1000.33);
							SetPlayerCameraLookAt(playerid, 620.5905, -3.0499, 1000.435);
						}
						case COMPONENT_TYPE_VENTS:
						{
							SetPlayerCameraPos(playerid, 612.6115, -1.7655, 1001.3);
							SetPlayerCameraLookAt(playerid, 613.5665, -1.6304, 1001.036);
						}
						case COMPONENT_TYPE_FRONT_BUMPER, COMPONENT_TYPE_FRONT_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 611.6121, -1.4851, 1001.777);
							SetPlayerCameraLookAt(playerid, 612.6027, -1.507, 1001.642);
						}
						case COMPONENT_TYPE_REAR_BUMPER, COMPONENT_TYPE_REAR_BULLBAR:
						{
							SetPlayerCameraPos(playerid, 621.4796, -3.4952, 1000.33);
							SetPlayerCameraLookAt(playerid, 620.5905, -3.0499, 1000.435);
						}
						case COMPONENT_TYPE_NITRO:
						{
							SetPlayerCameraPos(playerid, 622.5965, -2.014, 1003.019);
							SetPlayerCameraLookAt(playerid, 621.7657, -2.0174, 1002.462);
						}
//						case COMPONENT_TYPE_HYDRAULICS:
//						{
//							SetPlayerCameraPos(playerid, 613.5844, -0.7127, 1002.031);
//							SetPlayerCameraLookAt(playerid, 614.5616, -0.84, 1001.862);
//						}
						default:
						{
							SetPlayerCameraPos(playerid, 612.7667, 0.5696, 1002.114);
							SetPlayerCameraLookAt(playerid, 613.6664, 0.1645, 1001.951);
						}
					}
				}
				new vehicleid = GetPlayerVehicleID(playerid);
				new modelid = GetVehicleModel(vehicleid);
				for (new c = 1, temp1 = 0; c <= vehiclevalidmods[modelid-400][0]; c++)
				{
					if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
					if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-1)
					{
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_name]);

						if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] == vehiclevalidmods[modelid-400][c])
						{
							DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], temp1);
						}

						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = vehiclevalidmods[modelid-400][c];
						temp1 ++;
						if (temp1 == MAX_MENU_ITEMS-1)
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Next >>");
							PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] = 0;
							break;
						}
					}
				}
			}
			ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
		}
		else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 1)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			if ((PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] == 0 && row == MAX_MENU_ITEMS - 1) || (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] == 1 && row == 0))
			{
				DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);

				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				new modelid = GetVehicleModel(vehicleid);

				if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] == 0)
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "<< Prev");
					for (new c = 1, temp1 = 0; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-1)
						{
							temp1 ++;
							if (temp1 < MAX_MENU_ITEMS) continue;

							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_name]);

							if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] == vehiclevalidmods[modelid-400][c])
							{
								DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], temp1-(MAX_MENU_ITEMS-1));
							}

							PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1-(MAX_MENU_ITEMS-1)] = vehiclevalidmods[modelid-400][c];
						}
					}
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] = 1;
				}
				else
				{
					for (new c = 1, temp1 = 0; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-1)
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_name]);

							if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] == vehiclevalidmods[modelid-400][c])
							{
								DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], temp1);
							}

							PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = vehiclevalidmods[modelid-400][c];
							temp1 ++;
							if (temp1 == MAX_MENU_ITEMS-1)
							{
								AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Next >>");
								break;
							}
						}
					}
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] = 0;
				}
			}
			else
			{
				if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 0)
				{
//
				}
				else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 1)
				{
					if (vpaintjob[vehicleid-1] != row)
					{
						DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);

						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 2;
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 2, 29.0, 145.0, 186.0, 186.0);
						SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Upgrade");
						SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, "Cost");

						if (row == 0)
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 1");
						}
						else if (row == 1)
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 2");
						}
						else
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 3");
						}
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, "$500");
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ] = row;

						ChangeVehiclePaintjob(vehicleid, row);
					}
				}
				else
				{
					if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] != PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row])
					{
						DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);

						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 2;
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 2, 29.0, 145.0, 186.0, 186.0);
						SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Upgrade");
						SetMenuColumnHeader(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, "Cost");

						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row]-1000][vmod_name]);
						new tmp[8];
						format(tmp, 8, "$%d", vehiclemodinfo[PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row]-1000][vmod_cost]);
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 1, tmp);

						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row];

						if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] != 0)
						{
							RemoveVehicleComponent2(vehicleid, vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2]);
						}
						AddVehicleComponent2(playerid, vehicleid, PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][row]);
					}
				}
			}
			ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
		}
		else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 2)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 0)
			{
				if (GetPlayerCash(playerid) < 150)
				{
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
					ShowPlayerSubtitle(playerid, "You don't have enough money to buy this item." ) ;
					//ShowPlayerSubtitle(playerid, "You don't have enough money to buy this item." ) ;
					return 1;
				}

				new Float:health;
				GetVehicleHealth(vehicleid, health);
				SOLS_RepairVehicle(vehicleid);
				if (health > 1000.0)
				{
					SOLS_SetVehicleHealth(vehicleid, health);
				}

				new modelid = GetVehicleModel(vehicleid);
				if (colorused[modelid-400] < varray[modelid-400][0][1]) colorused[modelid-400] ++;
				else colorused[modelid-400] = 1;

				ChangeVehicleColor(vehicleid, varray[modelid-400][colorused[modelid-400]][0], varray[modelid-400][colorused[modelid-400]][1]);

				CallRemoteFunction("OnVehicleRespray2", "dddd", playerid, vehicleid, varray[modelid-400][colorused[modelid-400]][0], varray[modelid-400][colorused[modelid-400]][1]);

				GivePlayerMoney(playerid, -150);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			}
			else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 1)
			{
				if (GetPlayerCash(playerid) < 500)
				{
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
					ShowPlayerSubtitle(playerid, "You don't have enough money to buy this item." ) ;
					return 1;
				}

				CallRemoteFunction("OnVehiclePaintjob2", "ddd", playerid, vehicleid, PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]);

				vpaintjob[vehicleid-1] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ];

				new Float:health;
				GetVehicleHealth(vehicleid, health);
				SOLS_RepairVehicle(vehicleid);
				if (health > 1000.0)
				{
					SOLS_SetVehicleHealth(vehicleid, health);
				}

				GivePlayerMoney(playerid, -500);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			}
			else
			{
				if (GetPlayerCash(playerid) < vehiclemodinfo[PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]-1000][vmod_cost])
				{
					ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
					ShowPlayerSubtitle(playerid, "You don't have enough money to buy this item." ) ;
					return 1;
				}

				CallRemoteFunction("OnVehicleMod2", "ddd", playerid, vehicleid, PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]);

				vcompids[vehicleid-1][vehiclemodinfo[PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]-1000][vmod_type]-1] = PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ];
				GivePlayerMoney(playerid, -vehiclemodinfo[PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]-1000][vmod_cost]);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			}

			DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

			if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_WHEELARCH)
			{
				SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
				SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
			}
			else if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_LOCOLOW)
			{
				SetPlayerCameraPos(playerid, 611.9196, -71.983, 998.9867);
				SetPlayerCameraLookAt(playerid, 612.8176, -72.3798, 998.7969);
			}
			else
			{
				SetPlayerCameraPos(playerid, 612.7667, 0.5696, 1002.114);
				SetPlayerCameraLookAt(playerid, 613.6664, 0.1645, 1001.951);
			}

			new modelid = GetVehicleModel(vehicleid);

			new temp1 = 0;

			AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 0;
			temp1 ++;
			switch (modelid)
			{
				case 483, 534, 535, 536, 558, 559, 560, 561, 562, 565, 566, 567, 575, 576:
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 1;
					temp1 ++;
				}
				default:
				{

				}
			}
			new c, ctypecount[MAX_COMPONENT_TYPES + 1];
			for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
			{
				if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
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

	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	if (GetPlayerMenu(playerid) == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ])
	{
		DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);
		if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 0)
		{
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = Menu:0;

			new vehicleid = GetPlayerVehicleID(playerid);

			switch (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ])
			{
				case MS_TYPE_TRANSFENDER_LS:
				{
					SetVehiclePos(vehicleid, 1041.354, -1022.302 - 12.5, 31.127 + 1.0); // y - 12.5
					SetVehicleZAngle(vehicleid, 180.0);
				}
				case MS_TYPE_TRANSFENDER_SF:
				{
					SetVehiclePos(vehicleid, -1935.847, 242.876 - 12.5, 33.561 + 1.0); // y - 12.5
					SetVehicleZAngle(vehicleid, 180.0);
				}
				case MS_TYPE_TRANSFENDER_LV:
				{
					SetVehiclePos(vehicleid, 2386.662, 1047.172 - 12.5, 9.812 + 1.0); // y - 12.5
					SetVehicleZAngle(vehicleid, 180.0);
				}
				case MS_TYPE_LOCOLOW:
				{
					SetVehiclePos(vehicleid, 2644.877, -2042.556 + 12.5, 12.607 + 1.0); // y + 12.5
					SetVehicleZAngle(vehicleid, 0.0);
				}
				case MS_TYPE_WHEELARCH:
				{
					SetVehiclePos(vehicleid, -2719.670 + 12.5, 217.481, 3.585 + 1.0); // x + 12.5
					SetVehicleZAngle(vehicleid, 270.0);
				}
			}
			SetVehicleVirtualWorld(vehicleid, 0);
			LinkVehicleToInterior(vehicleid, 0);

			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if (IsPlayerInVehicle(i, vehicleid))
				{
					SetPlayerVirtualWorld(i, 0);
					SetPlayerInterior(i, 0);
					SetCameraBehindPlayer(i);
					TogglePlayerControllable(i, 1); //
					PlayerModshopData [i] [ E_PLAYER_MODSHOP ] = MS_TYPE_NONE;
				}
			}

		}
		else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 1)
		{
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

			if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_WHEELARCH)
			{
				SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
				SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
			}
			else if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_LOCOLOW)
			{
				SetPlayerCameraPos(playerid, 611.9196, -71.983, 998.9867);
				SetPlayerCameraLookAt(playerid, 612.8176, -72.3798, 998.7969);
			}
			else
			{
				SetPlayerCameraPos(playerid, 612.7667, 0.5696, 1002.114);
				SetPlayerCameraLookAt(playerid, 613.6664, 0.1645, 1001.951);
			}

			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleModel(vehicleid);

			new temp1 = 0;

			AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
			PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 0;
			temp1 ++;
			switch (modelid)
			{
				case 483, 534, 535, 536, 558, 559, 560, 561, 562, 565, 566, 567, 575, 576:
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
					PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 1;
					temp1 ++;
				}
				default:
				{

				}
			}
			new c, ctypecount[MAX_COMPONENT_TYPES + 1];
			for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
			{
				if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
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
		else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] == 2)
		{
			DestroyMenu(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ]);
			if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 0)
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 0;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_WHEELARCH)
				{
					SetPlayerCameraPos(playerid, 611.2935, -121.2534, 999.0341);
					SetPlayerCameraLookAt(playerid, 612.0599, -121.7974, 998.6927);
				}
				else if (PlayerModshopData [playerid] [ E_PLAYER_MODSHOP ] == MS_TYPE_LOCOLOW)
				{
					SetPlayerCameraPos(playerid, 611.9196, -71.983, 998.9867);
					SetPlayerCameraLookAt(playerid, 612.8176, -72.3798, 998.7969);
				}
				else
				{
					SetPlayerCameraPos(playerid, 612.7667, 0.5696, 1002.114);
					SetPlayerCameraLookAt(playerid, 613.6664, 0.1645, 1001.951);
				}

				new vehicleid = GetPlayerVehicleID(playerid);
				new modelid = GetVehicleModel(vehicleid);

				new temp1 = 0;

				AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Respray");
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 0;
				temp1 ++;
				switch (modelid)
				{
					case 483, 534, 535, 536, 558, 559, 560, 561, 562, 565, 566, 567, 575, 576:
					{
						AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob");
						PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = 1;
						temp1 ++;
					}
					default:
					{

					}
				}
				new c, ctypecount[MAX_COMPONENT_TYPES + 1];
				for (c = 1; c <= vehiclevalidmods[modelid-400][0]; c++)
				{
					if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
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
			else if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ] == 1)
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 1;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				new vehicleid = GetPlayerVehicleID(playerid);

				AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 1");
				if (GetVehicleModel(vehicleid) != 483)
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 2");
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Paintjob 3");
				}

				if (vpaintjob[vehicleid-1] != 3)
				{
					DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], vpaintjob[vehicleid-1]);
				}

				ChangeVehiclePaintjob(vehicleid, vpaintjob[vehicleid-1]);
			}
			else
			{
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_STAGE ] = 1;
				PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ] = CreateMenu("Upgrades", 1, 29.0, 145.0, 186.0, 0.0);

				new vehicleid = GetPlayerVehicleID(playerid);
				new modelid = GetVehicleModel(vehicleid);

				if (PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_PAGE ] == 0)
				{
					for (new c = 1, temp1 = 0; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-1)
						{
							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_name]);
							if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] == vehiclevalidmods[modelid-400][c])
							{
								DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], temp1);
							}
							else
							{
								RemoveVehicleComponent2(vehicleid, PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]);
							}
							AddVehicleComponent2(playerid, vehicleid, vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2]);

							PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1] = vehiclevalidmods[modelid-400][c];
							temp1 ++;
							if (temp1 == MAX_MENU_ITEMS-1)
							{
								AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "Next >>");
								break;
							}
						}
					}
				}
				else
				{
					AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, "<< Prev");
					for (new c = 1, temp1 = 0; c <= vehiclevalidmods[modelid-400][0]; c++)
					{
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == COMPONENT_TYPE_NONE) continue;
						if (vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_type] == PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-1)
						{
							temp1 ++;
							if (temp1 < MAX_MENU_ITEMS) continue;

							AddMenuItem(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], 0, vehiclemodinfo[vehiclevalidmods[modelid-400][c]-1000][vmod_name]);
							if (vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2] == vehiclevalidmods[modelid-400][c])
							{
								DisableMenuRow(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], temp1-(MAX_MENU_ITEMS-1));
							}
							else
							{
								RemoveVehicleComponent2(vehicleid, PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MOD ]);
							}
							AddVehicleComponent2(playerid, vehicleid, vcompids[vehicleid-1][PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_CATA ]-2]);

							PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_ITEMS ][temp1-(MAX_MENU_ITEMS-1)] = vehiclevalidmods[modelid-400][c];
						}
					}
				}
			}
			ShowMenuForPlayer(PlayerModshopData [ playerid ] [ E_PLAYER_MODSHOP_MENU ], playerid);
		}
	}
	
	#if defined mod_OnPlayerExitedMenu
		return mod_OnPlayerExitedMenu(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerExitedMenu
	#undef OnPlayerExitedMenu
#else
	#define _ALS_OnPlayerExitedMenu
#endif

#define OnPlayerExitedMenu mod_OnPlayerExitedMenu
#if defined mod_OnPlayerExitedMenu
	forward mod_OnPlayerExitedMenu(playerid);
#endif