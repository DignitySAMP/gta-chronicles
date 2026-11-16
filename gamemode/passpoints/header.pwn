#include "passpoints/data.pwn"
#include "passpoints/cmds.pwn"

Passpoint_GetPos(point_id, &Float:x, &Float:y, &Float:z)
{
	x = Passpoint [ point_id ] [ E_PASSPOINT_POS_X ];
	y = Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ];
	z = Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ];
}

Passpoint_GetLinkPos(point_id, &Float:x, &Float:y, &Float:z)
{
	x = Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ];
	y = Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ];
	z = Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ];
}

forward SOLS_OnPlayerPasspoint(playerid, point_id);
public SOLS_OnPlayerPasspoint(playerid, point_id)
{
	// Hookable
	// printf("SOLS_OnPlayerPasspoint: %d, %d", playerid, point_id);
	return true;
}

PlayerUsePasspoint(playerid, point_id, type, bool:feedback=true)
{
	if (PlayerVar[playerid][E_PLAYER_IS_FADING]) return false;

	if (IsPlayerIncapacitated(playerid, true)) 
	{
        if (feedback) SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." );
		return false;
    }

	new property_enum_id = -1;

	new bool:access = true;
	if (Passpoint[point_id][E_PASSPOINT_FACTION] > 0) access = Passpoint [ point_id ] [ E_PASSPOINT_FACTION ] == Character [ playerid ] [ E_CHARACTER_FACTIONID ];

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
		{
			SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to use this passpoint.");
		} 
		else
		{
			// NEW: Allow people to /pass faction passpoints if they are next to a faction member
			if (Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] == 0)
			{
				foreach (new nearplayer:Player)
				{
					if (Character [ nearplayer ] [ E_CHARACTER_FACTIONID ] == Passpoint [ point_id ] [ E_PASSPOINT_FACTION ] && IsPlayerNearPlayer(playerid, nearplayer, 5.0))
					{
						access = true; 
						break;
					}
				}
			}

			if (!access)
			{
				if (feedback)
				{
					if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR) SendClientMessage(playerid, -1, "You don't have normal access to this passpoint, but can go on admin duty to use it.");
					else SendServerMessage(playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You don't have access to this passpoint.");
				}

				return false;
			}
		}
	}	

	switch ( type ) 
	{
		case 0: { // near original point
			switch (  Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] ) {

				case 0: {
					if ( IsPlayerInAnyVehicle(playerid) ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint on foot." ) ;
					}

					// Try to find out what property it is, if any.
					if (Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ] && Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ])
					{
						// Checking for INTERIOR point!
						for ( new x, y = sizeof ( Property ); x < y; x ++ ) 
						{
							if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID && Property [ x ] [ E_PROPERTY_INT_INT ] == Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ] && Property [ x ] [ E_PROPERTY_ID ] == Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) 
							{
								property_enum_id = x;
							}
						}
					}

					SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
					SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);

					if (property_enum_id != -1)
					{
						// Set the property vars here (same as /enter) TODO: move this to a hook or something
						PlayerVar[playerid][E_PLAYER_LAST_PROPERTY_ENTERED] = property_enum_id;
						PlayerVar[playerid][E_PLAYER_BIZ_MENU] = property_enum_id;

						Property_LoadFurniture(property_enum_id); // NEW: load furni if needed
						SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ], ReturnPropEnterText(property_enum_id));
					}
					else
					{
						PlayerVar[playerid][E_PLAYER_LAST_PROPERTY_ENTERED] = INVALID_PROPERTY_ID;
						if (Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ] == 0 && Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] == 0)
						{
							SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ]);
						}
						else
						{
							SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ], Passpoint [ point_id ] [ E_PASSPOINT_DESC ]);
						}	
					}

					SetPlayerFacingAngle(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_A ]);

					AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Entered Passpoint %d \"%s\" (SQL: %d)", point_id, Passpoint [ point_id ] [ E_PASSPOINT_DESC ], Passpoint [ point_id ] [ E_PASSPOINT_SQLID ]));
				}

				case 1: {
					if ( ! IsPlayerInAnyVehicle(playerid) ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint with a vehicle." ) ;
					}

					if ( GetPlayerVehicleSeat(playerid) != 0 ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You must be the driver of a vehicle in order to use this." ) ;
					}

					new vehicleid = GetPlayerVehicleID(playerid);

					if ( vehicleid == 0 ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You're not in a vehicle!" ) ;
					}

					SOLS_SetVehiclePos(playerid, vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ] ) ;
					
					SetVehicleVirtualWorld(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
					LinkVehicleToInterior(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ] ) ;

					foreach(new forplayerid: Player) {

						if ( GetPlayerVehicleID(forplayerid) == vehicleid ) {

							SetPlayerVirtualWorld(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
							SetPlayerInterior(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);
						}
					}

					SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
					SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);
				}
			}
		}

		case 1: { // near linked point

			switch (  Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] ) {

				case 0: {
					if ( IsPlayerInAnyVehicle(playerid) ) return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint on foot." ) ;

					// Try to find out what property it is, if any.
					
					if (Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ] && Passpoint [ point_id ] [ E_PASSPOINT_WORLD ])
					{
						// Checking for INTERIOR point!
						for ( new x, y = sizeof ( Property ); x < y; x ++ ) 
						{
							if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID && Property [ x ] [ E_PROPERTY_INT_INT ] == Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ] && Property [ x ] [ E_PROPERTY_ID ] == Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) 
							{
								property_enum_id = x;
							}
						}
					}

					SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
					SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);

					if (property_enum_id != -1)
					{
						// Set the property vars here (same as /enter) TODO: move this to a hook or something
						PlayerVar[playerid][E_PLAYER_LAST_PROPERTY_ENTERED] = property_enum_id;
						PlayerVar[playerid][E_PLAYER_BIZ_MENU] = property_enum_id;

						Property_LoadFurniture(property_enum_id); // NEW: load furni if needed
						SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ], ReturnPropEnterText(property_enum_id));
					}
					else
					{	
						PlayerVar[playerid][E_PLAYER_LAST_PROPERTY_ENTERED] = INVALID_PROPERTY_ID;
						if (Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ] == 0 && Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] == 0)
						{
							SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ]);
						}
						else
						{
							SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ], Passpoint [ point_id ] [ E_PASSPOINT_DESC ]);
						}
					}

					SetPlayerFacingAngle(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_A ]);
					AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Exited Passpoint %d \"%s\" (SQL: %d)", point_id, Passpoint [ point_id ] [ E_PASSPOINT_DESC ], Passpoint [ point_id ] [ E_PASSPOINT_SQLID ]));
				}

				case 1: {
					if ( ! IsPlayerInAnyVehicle(playerid) ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint with a vehicle." ) ;
					}

					if ( GetPlayerVehicleSeat(playerid) != 0 ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You must be the driver of a vehicle in order to use this." ) ;
					}

					new vehicleid = GetPlayerVehicleID(playerid);

					if ( vehicleid == 0 ) {

						return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You're not in a vehicle!" ) ;
					}

					SOLS_SetVehiclePos(playerid, vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ] ) ;
					
					SetVehicleVirtualWorld(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
					LinkVehicleToInterior(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ] ) ;

					foreach(new forplayerid: Player) {

						if ( GetPlayerVehicleID(forplayerid) == vehicleid ) {

							SetPlayerVirtualWorld(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
							SetPlayerInterior(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);
						}
					}
					
					SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
					SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);
				}
			}
		}
	}

	if ( PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) 
	{
		SendClientMessage(playerid, -1, sprintf("Closest point (enum ID): %d", point_id ) ) ;
	}

	SOLS_SyncTimeAndWeather(playerid, property_enum_id);
	if (property_enum_id != -1) PropertyAudio_Sync(playerid, property_enum_id);
	else PropertyAudio_Stop(playerid);

	
	CallLocalFunction("SOLS_OnPlayerPasspoint", "dd", playerid, point_id);

	return true;
}

// New, cleaner & smarter passpoint function
GetClosestPasspoint(playerid, Float:radius, &passpoint_id, &passpoint_type)
{
    new closest = -1, closest_type = -1;
    new Float:current;
    new Float:last = radius;

	new interior = GetPlayerInterior(playerid);
	new world = GetPlayerVirtualWorld(playerid);
	new type = -1;

    for (new i = 0; i < sizeof(Passpoint); i ++)
    {
		if (Passpoint[i][E_PASSPOINT_SQLID] == INVALID_PASSPOINT_ID) continue;

		if (Passpoint[i][E_PASSPOINT_INTERIOR] == interior && Passpoint[i][E_PASSPOINT_WORLD] == world && Passpoint[i][E_PASSPOINT_LINKED_INTERIOR] == interior && Passpoint[i][E_PASSPOINT_LINKED_WORLD] == world)
		{
			new Float:out = GetPlayerDistanceFromPoint(playerid, Passpoint[i][E_PASSPOINT_POS_X], Passpoint[i][E_PASSPOINT_POS_Y], Passpoint[i][E_PASSPOINT_POS_Z]);
			new Float:link = GetPlayerDistanceFromPoint(playerid, Passpoint[i][E_PASSPOINT_LINKED_X], Passpoint[i][E_PASSPOINT_LINKED_Y], Passpoint[i][E_PASSPOINT_LINKED_Z]);

			if (out < link)
			{
				type = 0;
				current = out;
			}
			else
			{
				type = 1;
				current = link;
			}
		}
		else
		{
			if (Passpoint[i][E_PASSPOINT_INTERIOR] == interior && Passpoint[i][E_PASSPOINT_WORLD] == world)
			{
				current = GetPlayerDistanceFromPoint(playerid, Passpoint[i][E_PASSPOINT_POS_X], Passpoint[i][E_PASSPOINT_POS_Y], Passpoint[i][E_PASSPOINT_POS_Z]);
				type = 0;
			}
			else if (Passpoint[i][E_PASSPOINT_LINKED_INTERIOR] == interior && Passpoint[i][E_PASSPOINT_LINKED_WORLD] == world)
			{
				current = GetPlayerDistanceFromPoint(playerid, Passpoint[i][E_PASSPOINT_LINKED_X], Passpoint[i][E_PASSPOINT_LINKED_Y], Passpoint[i][E_PASSPOINT_LINKED_Z]);
				type = 1;
			}
			else
			{
				continue;
			}
		}

		if (current < last && current < Passpoint[i][E_PASSPOINT_RADIUS])
        {
			closest = i;
			closest_type = type;
            last = current;
        }
    }

	passpoint_id = closest;
	passpoint_type = closest_type;
}

/*
GetClosestPasspoint(playerid) {

	new Float: MAX_RANGE = 5.0;

    new point_id = -1, Float:dis = 99999.99, Float:dis2, Float: dis3, type ;

    for_loop ( new i, j = sizeof ( Passpoint ); i < j; i ++ ) {

    	if ( Passpoint [ i ] [ E_PASSPOINT_SQLID ] == INVALID_PASSPOINT_ID ) {

    		continue ;
    	}

        dis2 = GetPlayerDistanceFromPoint(playerid, Passpoint [ i ] [ E_PASSPOINT_POS_X ], Passpoint [ i ] [ E_PASSPOINT_POS_Y ], Passpoint [ i ] [ E_PASSPOINT_POS_Z ] );
        if(dis2 < dis &&  GetPlayerInterior(playerid) == Passpoint [ i ] [ E_PASSPOINT_INTERIOR ] && GetPlayerVirtualWorld(playerid) == Passpoint [ i ] [ E_PASSPOINT_WORLD ] && dis2 < Passpoint[i][E_PASSPOINT_RADIUS])
        {
            dis = dis2;
            point_id = i;
            type = 0 ;
        }
    }

    for_loop ( new i, j = sizeof ( Passpoint ); i < j; i ++ ) {

    	if ( Passpoint [ i ] [ E_PASSPOINT_SQLID ] == INVALID_PASSPOINT_ID ) {

    		continue ;
    	}

        dis3 = GetPlayerDistanceFromPoint(playerid, Passpoint [ i ] [ E_PASSPOINT_LINKED_X ], Passpoint [ i ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ i ] [ E_PASSPOINT_LINKED_Z ] );
        if(dis3 < dis &&  GetPlayerInterior(playerid) == Passpoint [ i ] [ E_PASSPOINT_LINKED_INTERIOR ] && GetPlayerVirtualWorld(playerid) == Passpoint [ i ] [ E_PASSPOINT_LINKED_WORLD ] && dis3 < Passpoint[i][E_PASSPOINT_RADIUS])
        {
            dis = dis3;
            point_id = i;
            type = 1 ;
        }
    }

	new bool:access = true;
	if (Passpoint[point_id][E_PASSPOINT_FACTION] > 0) access = Passpoint [ point_id ] [ E_PASSPOINT_FACTION ] == Character [ playerid ] [ E_CHARACTER_FACTIONID ];

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
		{
			access = true;
			SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to use this passpoint.");
		} 
		else
		{
			// NEW: Allow people to /pass faction passpoints if they are next to a faction member
			if (Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] == 0)
			{
				foreach (new nearplayer:Player)
				{
					if (Character [ nearplayer ] [ E_CHARACTER_FACTIONID ] == Passpoint [ point_id ] [ E_PASSPOINT_FACTION ] && IsPlayerNearPlayer(playerid, nearplayer, 5.0))
					{
						access = true; 
						break;
					}
				}
			}

			if (!access)
			{
				if (GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR) return SendClientMessage(playerid, -1, "You don't have normal access to this passpoint, but can go on admin duty to use it.");
				else return SendServerMessage(playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You don't have access to this passpoint.");
			}
		}
	}	


	if ( dis <= MAX_RANGE ) 
	{
	    switch ( type ) {

	    	case 0: { // near original point
	    		switch (  Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] ) {

					case 0: {
						if ( IsPlayerInAnyVehicle(playerid) ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint on foot." ) ;
						}

						SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
						SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);
						SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ]) ;
						SetPlayerFacingAngle(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_A ]);

						AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Entered Passpoint %d \"%s\" (SQL: %d)", point_id, Passpoint [ point_id ] [ E_PASSPOINT_DESC ], Passpoint [ point_id ] [ E_PASSPOINT_SQLID ]));
					}

					case 1: {
						if ( ! IsPlayerInAnyVehicle(playerid) ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint with a vehicle." ) ;
						}

						if ( GetPlayerVehicleSeat(playerid) != 0 ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You must be the driver of a vehicle in order to use this." ) ;
						}

						new vehicleid = GetPlayerVehicleID(playerid);

						if ( vehicleid == 0 ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You're not in a vehicle!" ) ;
						}

						SOLS_SetVehiclePos(playerid, vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_X ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Y ], Passpoint [ point_id ] [ E_PASSPOINT_LINKED_Z ] ) ;
						
						SetVehicleVirtualWorld(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
						LinkVehicleToInterior(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ] ) ;

						foreach(new forplayerid: Player) {

							if ( GetPlayerVehicleID(forplayerid) == vehicleid ) {

								SetPlayerVirtualWorld(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
								SetPlayerInterior(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);
							}
						}

						SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_WORLD ] ) ;
						SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_LINKED_INTERIOR ]);
					}
				}
	    	}

	    	case 1: { // near linked point

				switch (  Passpoint [ point_id ] [ E_PASSPOINT_TYPE  ] ) {

					case 0: {
						if ( IsPlayerInAnyVehicle(playerid) ) return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint on foot." ) ;

						SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
						SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);
						SOLS_SetPosWithFade(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ]) ;
						SetPlayerFacingAngle(playerid, Passpoint [ point_id ] [ E_PASSPOINT_POS_A ]);

						AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Exited Passpoint %d \"%s\" (SQL: %d)", point_id, Passpoint [ point_id ] [ E_PASSPOINT_DESC ], Passpoint [ point_id ] [ E_PASSPOINT_SQLID ]));
					}

					case 1: {
						if ( ! IsPlayerInAnyVehicle(playerid) ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You can only pass through this passpoint with a vehicle." ) ;
						}

						if ( GetPlayerVehicleSeat(playerid) != 0 ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You must be the driver of a vehicle in order to use this." ) ;
						}

						new vehicleid = GetPlayerVehicleID(playerid);

						if ( vehicleid == 0 ) {

							return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You're not in a vehicle!" ) ;
						}

						SOLS_SetVehiclePos(playerid, vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_POS_X ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Y ], Passpoint [ point_id ] [ E_PASSPOINT_POS_Z ] ) ;
						
						SetVehicleVirtualWorld(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
						LinkVehicleToInterior(vehicleid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ] ) ;

						foreach(new forplayerid: Player) {

							if ( GetPlayerVehicleID(forplayerid) == vehicleid ) {

								SetPlayerVirtualWorld(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
								SetPlayerInterior(forplayerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);
							}
						}
						
						SetPlayerVirtualWorld(playerid, Passpoint [ point_id ] [ E_PASSPOINT_WORLD ] ) ;
						SetPlayerInterior(playerid, Passpoint [ point_id ] [ E_PASSPOINT_INTERIOR ]);
					}
				}
	    	}
	    }

    	return point_id ;
    }

    return INVALID_PASSPOINT_ID ;
}
*/

CMD:pass(playerid, params[]) 
{
	if (PlayerVar[playerid][E_PLAYER_IS_FADING]) return true; // Make them wait first
	
	if (IsPlayerIncapacitated(playerid, true)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." );
    }

	new passpoint_id, passpoint_type;
	GetClosestPasspoint(playerid, 15.0, passpoint_id, passpoint_type);

	if (passpoint_id == -1)
	{
		return SendServerMessage ( playerid, COLOR_INFO, "Passpoint", "A3A3A3", "You're not near a passpoint." ) ;
	}

	PlayerUsePasspoint(playerid, passpoint_id, passpoint_type, true);
	return true ;
}