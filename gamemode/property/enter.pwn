
public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid) {
	new name[64], address [ 128 ], zone [ 64 ], city[32] ;

	new Float: z ;

	for_loop(new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] != -1 ) {

			if ( Property [ i ] [ E_PROPERTY_AREA ] == areaid ) {

				// Fix against the hud showing up wehn you're under / above the point
				GetPlayerPos ( playerid, z, z, z ) ;

				if ( (z - 1.5 ) > Property [ i ] [ E_PROPERTY_EXT_Z ] ) {

					return false ;
				}

				if ( (z + 1.5 ) < Property [ i ] [ E_PROPERTY_EXT_Z ] ) {

					return false ;
				}

				GetCoords2DZone(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], zone, sizeof ( zone ));
				GetPlayerAddress(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], address );
				GetCoords2DMainZone(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], city, sizeof ( city ) ) ;

				PlayerVar[playerid][E_PLAYER_PROPERTY_ENTER_IDX] = i;
				PlayerVar[playerid][E_PLAYER_AT_PROPERTY_ENTER] = true;

				if (strlen(Property [ i ] [ E_PROPERTY_NAME ]) && strcmp(Property [ i ] [ E_PROPERTY_NAME ], "Undefined", true))
				{
					new name_style[4];
					format ( name_style, sizeof ( name_style ), "~w~" ) ;

					switch(Property [ i ] [ E_PROPERTY_NAME_COLOR ]) 
					{
						case 1: format ( name_style, sizeof ( name_style ), "~r~" ) ;
						case 2: format ( name_style, sizeof ( name_style ), "~g~" ) ;
						case 3: format ( name_style, sizeof ( name_style ), "~b~" ) ;
						case 4: format ( name_style, sizeof ( name_style ), "~y~" ) ;
						case 5: format ( name_style, sizeof ( name_style ), "~p~" ) ;
						case 6: format ( name_style, sizeof ( name_style ), "~l~" ) ;
					}

					format(name, sizeof(name), "%s%s~w~", name_style, Property [ i ] [ E_PROPERTY_NAME ]);
					format(address, sizeof(address), "%s~n~%s", name, address);
				}

				if ( Property [ i ] [ E_PROPERTY_OWNER ] == INVALID_PROPERTY_OWNER ) {

					if ( Property [ i ] [ E_PROPERTY_PRICE ] > 0 ) 
					{
						PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~r~For Sale: $%s", address, i, zone, city, IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_PRICE ]) ) ) ;
					}
					else 
					{
						if ( Property [ i ] [ E_PROPERTY_FEE ] > 0 ) 
						{
							PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~p~Entry Fee: $%s", address, i, zone, city, IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_FEE ])) ) ;
						}
						else 
						{
							PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s", address, i, zone, city) ) ;
						}
					}
				}

				else {

					if ( Property [ i ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {
						if ( Property [ i ] [ E_PROPERTY_FEE ] > 0 ) {

							PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~b~This is your property~n~~p~Entry Fee: $%s", address, i, zone, city, IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_FEE ])) ) ;
						}

						else PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~b~This is your property", address, i, zone, city ) ) ;
						SendClientMessage(playerid, -1, sprintf("You own this property (%d). Use /propertyhelp to manage it.", i ) ) ;
					}

					else {
						if ( Property [ i ] [ E_PROPERTY_FEE ] > 0 ) {

							PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~g~Player Owned~n~~p~Entry Fee: $%s", address, i, zone, city, IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_FEE ])) ) ;
						}

						else PlayerTextDrawSetString(playerid, house_info_box[playerid], sprintf("%s, %d~n~%s, %s~n~~g~Player Owned", address, i, zone, city ) ) ;	
					}
				}

				PlayerTextDrawShow(playerid, house_info_box[playerid] );

				if ( Property [ i ] [ E_PROPERTY_RENT ] ) {

					if ( PlayerVar [ playerid ] [ E_PLAYER_RENT_WARNING ] != i ) {

						if ( Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ] != i ) {

							ShowPlayerInfoMessage( playerid, 
								sprintf("This property (%d) is rentable for $%s! Use /rentroom to rent it.",
									i, IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_RENT ]) ) , 
							.showtime = 6000 ) ;
						}

						else if ( Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ] == i ) {
							ShowPlayerInfoMessage( playerid, 
								sprintf("You're renting this property for $%s. To unrent use /unrentroom.", 
									IntegerWithDelimiter(Property [ i ] [ E_PROPERTY_RENT ] )) ,
							 .showtime = 6000 ) ;
						}

						PlayerVar [ playerid ] [ E_PLAYER_RENT_WARNING ] = i ;
					}
				}

				Streamer_Update(playerid, STREAMER_TYPE_PICKUP ) ;
			}

			else continue ;
		}

		else continue ;
	}

	#if defined prop_OnPlayerEnterDynamicArea
		return prop_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea prop_OnPlayerEnterDynamicArea
#if defined prop_OnPlayerEnterDynamicArea
	forward prop_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid) 
{
	if (PlayerVar[playerid][E_PLAYER_AT_PROPERTY_ENTER])
	{
		if (!IsPlayerInDynamicArea(playerid, Property[PlayerVar[playerid][E_PLAYER_PROPERTY_ENTER_IDX]][E_PROPERTY_AREA], true))
		{
			PlayerTextDrawSetString(playerid, house_info_box[playerid], "_" ) ;
			PlayerTextDrawHide(playerid, house_info_box[playerid] );
			PlayerVar[playerid][E_PLAYER_AT_PROPERTY_ENTER] = false;
		}
	}

	#if defined prop_OnPlayerLeaveDynamicArea
		return prop_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea prop_OnPlayerLeaveDynamicArea
#if defined prop_OnPlayerLeaveDynamicArea
	forward prop_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

ReturnPropEnterText(index, bool:color=true)
{
	new returnstr[128], zone[64], name_style[4];
	
	if (strlen(Property[index][E_PROPERTY_NAME]) > 1 && strcmp(Property[index][E_PROPERTY_NAME], "Undefined") && strcmp(Property[index][E_PROPERTY_NAME], "NULL"))
	{
		if (color)
		{
			switch (Property [ index ] [ E_PROPERTY_NAME_COLOR ]) 
			{
				case 1: format ( name_style, sizeof ( name_style ), "~r~" ) ;
				case 2: format ( name_style, sizeof ( name_style ), "~g~" ) ;
				case 3: format ( name_style, sizeof ( name_style ), "~b~" ) ;
				case 4: format ( name_style, sizeof ( name_style ), "~y~" ) ;
				case 5: format ( name_style, sizeof ( name_style ), "~p~" ) ;
				case 6: format ( name_style, sizeof ( name_style ), "~l~" ) ;
				default: format ( name_style, sizeof ( name_style ), "~w~" ) ;
			}

			format(returnstr, sizeof(returnstr), "%s%s", name_style, Property[index][E_PROPERTY_NAME]);
		}
		else
		{
			format(returnstr, sizeof(returnstr), "%s", Property[index][E_PROPERTY_NAME]);
		}
	}
	else
	{
		new address_id = GetAddressID(Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ]);
		
		if (address_id >= 0)
		{
			GetAddressFromID(address_id, zone, sizeof(zone));
			format(returnstr, sizeof(returnstr), "%d %s", index, zone);
		}
		else
		{
			GetCoords2DZone(Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ], zone, sizeof ( zone ));
			format(returnstr, sizeof(returnstr), "%d %s", index, zone);
		}
	}

	return returnstr;
}

// Checks if the furniture has been loaded and creates it if not
Property_LoadFurniture(prop_enum_id)
{
	if (!Property[prop_enum_id][E_PROPERTY_ID] || Property[prop_enum_id][E_PROPERTY_FURNI_CREATED])
	{
		return 0;
	}

	printf("[Property Furni] Requesting furniture for Prop Enum ID %d, SQL ID: %d, Name: %s", prop_enum_id, Property[prop_enum_id][E_PROPERTY_ID], Property[prop_enum_id][E_PROPERTY_NAME]);
	SavedFurni_LoadForProperty(prop_enum_id, Property[prop_enum_id][E_PROPERTY_ID]);
	Property[prop_enum_id][E_PROPERTY_FURNI_CREATED] = true;
	
	return 1;
}

Property_Enter(playerid, prop_enum_id, bool:feedback=true) 
{
	new index = prop_enum_id;

	if ( index == INVALID_PROPERTY_ID ) 
	{
		if (feedback) 
		{
			SendClientMessage(playerid, -1, "You're not near any property that you can enter or exit.");
		}

		return false ;
	}

	if ( !IsPlayerInRangeOfPoint ( playerid, 5.0, Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ], Property [ index ] [ E_PROPERTY_EXT_Z ] )) 
	{
		// Forbid exit when not outside
		return false ;
	}

	if ( Property [ index ] [ E_PROPERTY_LOCKED ] ) 
	{
		return SendClientMessage(playerid, -1, "This property is locked.");
	}

	if ( Property [ index ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_STATIC ) {

		return SendClientMessage(playerid, -1, "This property can't be entered.");
	}

	switch ( Property [ index ] [ E_PROPERTY_BUY_TYPE ] ) {
		case E_BUY_TYPE_DEALERSHIP, E_BUY_TYPE_GASSTATION, E_BUY_TYPE_MODSHOP: {
			return SendClientMessage(playerid, -1, "This business type can't be entered.");
		}
	}

	if ( Property [ index ] [ E_PROPERTY_FEE ] ) 
	{
		if(IsPlayerNewbie(playerid)) {
			SendClientMessage(playerid, COLOR_YELLOW, sprintf("You weren't charged the entrance fee of $%s to enter this property as you are a new player.",  IntegerWithDelimiter(Property [ index ] [ E_PROPERTY_FEE ] ) ) ) ;
		}

		else 
		{
			if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, COLOR_YELLOW, sprintf("You weren't charged the entrance fee of $%s to enter this property as you're on admin duty.", IntegerWithDelimiter(Property[index][E_PROPERTY_FEE])));
			else if (IsPlayerInAnyGovFaction(playerid, true) || IsPlayerInSecurityFaction(playerid, true)) SendClientMessage(playerid, COLOR_YELLOW, sprintf("You weren't charged the entrance fee of $%s to enter this property as you're on faction duty.", IntegerWithDelimiter(Property[index][E_PROPERTY_FEE])));

			if (PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] || IsPlayerInAnyGovFaction(playerid, true) || IsPlayerInSecurityFaction(playerid, true)) {}
			else
			if (  Property [ index ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] || Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ] == Property [ index ] [ E_PROPERTY_ID ] ) 
			{
				SendClientMessage(playerid, COLOR_YELLOW, sprintf("You weren't charged the entrance fee of $%s to enter this property as you own or rent it.",  IntegerWithDelimiter(Property [ index ] [ E_PROPERTY_FEE ] ) ) ) ;
			}
			else
			{

				if ( GetPlayerCash ( playerid ) < Property [ index ] [ E_PROPERTY_FEE ] ) {

					return SendClientMessage(playerid, COLOR_YELLOW, sprintf("You need at least $%s to enter this property.", IntegerWithDelimiter(Property [ index ] [ E_PROPERTY_FEE ] ) ) ) ;
				}

				TakePlayerCash ( playerid, Property [ index ] [ E_PROPERTY_FEE ] ) ;
		//		Property_AddMoneyToTill(playerid, Property [ index ] [ E_PROPERTY_FEE ], .margin=false ) ; 
				SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've been charged the entrance fee of $%s to enter this property.",  IntegerWithDelimiter(Property [ index ] [ E_PROPERTY_FEE ] ) ) ) ;

				new query [ 96 ] ;

				Property [ index ] [ E_PROPERTY_COLLECT ] += Property [ index ] [ E_PROPERTY_FEE ] ;

				mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_collect = %d WHERE property_id = %d", 

					Property [ index ] [ E_PROPERTY_COLLECT ], Property [ index ] [ E_PROPERTY_ID ]
				) ;

				mysql_tquery(mysql, query );
			}
		}

	}

	PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] = index ;
	PlayerVar [ playerid ] [ E_PLAYER_BIZ_MENU ] = index ;

	// NEW: Check if furniture needs created
	Property_LoadFurniture(index);

	SetPlayerInterior(playerid, Property [ index ] [ E_PROPERTY_INT_INT ]) ;
	SetPlayerVirtualWorld(playerid, Property [ index ] [ E_PROPERTY_INT_VW ]) ;
	//SOLS_SetPlayerPos(playerid, Property [ index ] [ E_PROPERTY_INT_X ], Property [ index ] [ E_PROPERTY_INT_Y ], Property [ index ] [ E_PROPERTY_INT_Z ] + 0.1 );
	SOLS_SetPosWithFade(playerid, Property [ index ] [ E_PROPERTY_INT_X ], Property [ index ] [ E_PROPERTY_INT_Y ], Property [ index ] [ E_PROPERTY_INT_Z ], ReturnPropEnterText(index));

	// Smarter function to sync times
	SOLS_SyncTimeAndWeather(playerid, index);
	PropertyAudio_Sync(playerid, index);

	if ( Property [ index ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_BIZ ) {
		
		if(strcmp(Property [ index ] [ E_PROPERTY_NAME ], "Undefined", true)) {

			new name_style[64];

			switch(Property [ index ] [ E_PROPERTY_NAME_COLOR ]) {

				case 0: format ( name_style, sizeof ( name_style ), "~w~" ) ;
				case 1: format ( name_style, sizeof ( name_style ), "~r~" ) ;
				case 2: format ( name_style, sizeof ( name_style ), "~g~" ) ;
				case 3: format ( name_style, sizeof ( name_style ), "~b~" ) ;
				case 4: format ( name_style, sizeof ( name_style ), "~y~" ) ;
				case 5: format ( name_style, sizeof ( name_style ), "~p~" ) ;
				case 6: format ( name_style, sizeof ( name_style ), "~l~" ) ;
			}

           	//ShowPlayerSubtitle(playerid, sprintf("Welcome to %s%s", name_style, Property [ index ] [ E_PROPERTY_NAME ]), .showtime = 4000 );
			ShowZoneMessage(playerid, sprintf("%s%s", name_style, Property [ index ] [ E_PROPERTY_NAME ]), true);

		}
	}

	UpdatePlayerNamesForPlayer ( playerid );
	UpdatePlayerNamesForOthers ( playerid );

	PlayerPlaySound(playerid, 1, 0, 0, 0);

	if ( GetPlayerAdminLevel ( playerid ) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) {

		SendClientMessage(playerid, COLOR_YELLOW, 
			sprintf("[ADMIN/ENTER_PROP]: [ID %d] [SQL: %d] [Owner: %d] [Type: %d] [Buy Type: %d]", index, Property [ index ] [ E_PROPERTY_ID ], Property [ index ] [ E_PROPERTY_OWNER ],
			Property [ index ] [ E_PROPERTY_TYPE ], Property [ index ] [ E_PROPERTY_BUY_TYPE ]
	 	) ) ;
	}

	if (  Property [ index ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

		SendServerMessage ( playerid, COLOR_PROPERTY, "Property", "DEDEDE", sprintf("You have $%s waiting for you in your property till. (/propertycollect)", IntegerWithDelimiter ( Property [ index ] [ E_PROPERTY_COLLECT ] ) ) ) ;
	}

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Entered Property %d (SQL: %d)", index, Property [ index ] [ E_PROPERTY_ID ]));

	return true ;
}


Property_Exit(playerid, prop_enum_id, bool:feedback=true) 
{
	new index = prop_enum_id;

	if ( index == INVALID_PROPERTY_ID )
	{
		if (feedback) 
		{
			SendClientMessage(playerid, -1, "You're not near any property that you can enter or exit.");
		}

		return false ;
	}

	if ( !IsPlayerInRangeOfPoint ( playerid, 5.0, Property [ index ] [ E_PROPERTY_INT_X ], Property [ index ] [ E_PROPERTY_INT_Y ], Property [ index ] [ E_PROPERTY_INT_Z ] )) 
	{
		// Forbid exit when not inside
		return false ;
	}

	SetPlayerInterior(playerid, Property [ index ] [ E_PROPERTY_EXT_INT ] ) ;
	SetPlayerVirtualWorld(playerid, Property [ index ] [ E_PROPERTY_EXT_VW ] ) ;
	//SOLS_SetPlayerPos(playerid, Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ], Property [ index ] [ E_PROPERTY_EXT_Z ] + 0.1);
	SOLS_SetPosWithFade(playerid, Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ], Property [ index ] [ E_PROPERTY_EXT_Z ]);

	UpdatePlayerNamesForPlayer ( playerid );
	UpdatePlayerNamesForOthers ( playerid );
	PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] = INVALID_PROPERTY_ID ;
	PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] = INVALID_PROPERTY_ID ;
	PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ] = INVALID_PROPERTY_ID ;
	
	SOLS_SyncTimeAndWeather(playerid);
	PropertyAudio_Sync(playerid);

	if ( GetPlayerAdminLevel ( playerid ) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) {

		SendClientMessage(playerid, COLOR_YELLOW, 
			sprintf("[ADMIN/LEAVE_PROP]: [ID %d] [SQL: %d] [Owner: %d] [Type: %d] [Buy Type: %d]", index, Property [ index ] [ E_PROPERTY_ID ], Property [ index ] [ E_PROPERTY_OWNER ],
			Property [ index ] [ E_PROPERTY_TYPE ], Property [ index ] [ E_PROPERTY_BUY_TYPE ]
	 	) ) ;
	}

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Exited Property %d (SQL: %d)", index, Property [ index ] [ E_PROPERTY_ID ]));

	return true ;
}

Float:Property_PlayerExtDistance(playerid, prop_enum_id)
{
	return GetPlayerDistanceFromPoint(playerid, Property [ prop_enum_id ] [ E_PROPERTY_EXT_X ], Property [ prop_enum_id ] [ E_PROPERTY_EXT_Y ], Property [ prop_enum_id ] [ E_PROPERTY_EXT_Z ]);
}

Float:Property_PlayerIntDistance(playerid, prop_enum_id)
{
	return GetPlayerDistanceFromPoint(playerid, Property [ prop_enum_id ] [ E_PROPERTY_INT_X ], Property [ prop_enum_id ] [ E_PROPERTY_INT_Y ], Property [ prop_enum_id ] [ E_PROPERTY_INT_Z ]);
}

Property_GetOutsidePos(prop_enum_id, &Float:x, &Float:y, &Float:z)
{
	x = Property [ prop_enum_id ] [ E_PROPERTY_EXT_X ];
	y = Property [ prop_enum_id ] [ E_PROPERTY_EXT_Y ];
	z = Property [ prop_enum_id ] [ E_PROPERTY_EXT_Z ];
}

Property_GetInsidePos(prop_enum_id, &Float:x, &Float:y, &Float:z)
{
	x = Property [ prop_enum_id ] [ E_PROPERTY_INT_X ];
	y = Property [ prop_enum_id ] [ E_PROPERTY_INT_Y ];
	z = Property [ prop_enum_id ] [ E_PROPERTY_INT_Z ];
}

GetClosestProperty(playerid, Float:radius, &prop_enum_id, &property_type)
{
	new closest = INVALID_PROPERTY_ID, closest_type = -1, type = 0;
    new Float:current;
    new Float:last = radius;

	new interior = GetPlayerInterior(playerid);
	new world = GetPlayerVirtualWorld(playerid);

    for (new i = 0; i < sizeof(Property); i ++)
    {
		if (Property[i][E_PROPERTY_ID] == INVALID_PROPERTY_ID) continue;

		if (Property[i][E_PROPERTY_EXT_INT] == interior && Property[i][E_PROPERTY_EXT_VW] == world)
		{
        	current = GetPlayerDistanceFromPoint(playerid, Property[i][E_PROPERTY_EXT_X], Property[i][E_PROPERTY_EXT_Y], Property[i][E_PROPERTY_EXT_Z]);
			type = 0;
		}
		else if (Property[i][E_PROPERTY_INT_INT] == interior && Property[i][E_PROPERTY_ID] == world)
		{
			current = GetPlayerDistanceFromPoint(playerid, Property[i][E_PROPERTY_INT_X], Property[i][E_PROPERTY_INT_Y], Property[i][E_PROPERTY_INT_Z]);
			type = 1;
		}
		else
		{
			continue;
		}

		if (current < last)
        {
            closest = i;
			closest_type = type;
            last = current;
        }
    }

	prop_enum_id = closest;
	property_type = closest_type;
}

Property_GetClosestEntity( playerid, Float: radius = PROPERTY_NEAREST_DIST )  {

	new Float: dis = 99999.99, Float: dis2, index = INVALID_PROPERTY_ID ;
	new world = GetPlayerVirtualWorld(playerid);
	new interior = GetPlayerInterior(playerid);

	// Checking for EXTERIOR point!
	for ( new x, y = sizeof ( Property ); x < y; x ++ ) {

		if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) {

			dis2 = GetPlayerDistanceFromPoint(playerid, 
				Property [ x ] [ E_PROPERTY_EXT_X ], 
				Property [ x ] [ E_PROPERTY_EXT_Y ], 
				Property [ x ] [ E_PROPERTY_EXT_Z ]
			);

			if (dis2 < dis && interior == Property[x][E_PROPERTY_EXT_INT] && world == Property[x][E_PROPERTY_EXT_VW]) 
			{
	            dis = dis2;
	            index = x;
			}
		}
	}

	if ( dis <= radius ) {

		return index;
	}

	else index = INVALID_PROPERTY_ID ;
	
	if (!interior && !world && radius > 2.5) radius = 2.5; // lowering the radius for this to minimize potential vw 0 conflicts

	// Checking for INTERIOR point!
	for ( new x, y = sizeof ( Property ); x < y; x ++ ) {

		if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) {

			dis2 = GetPlayerDistanceFromPoint(playerid, 
				Property [ x ] [ E_PROPERTY_INT_X ], 
				Property [ x ] [ E_PROPERTY_INT_Y ], 
				Property [ x ] [ E_PROPERTY_INT_Z ]
			);

			// updated to allow returning properties in vw 0, or with a different vw to their id
			if (dis2 < dis && interior == Property[x][E_PROPERTY_INT_INT] && world == Property[x][E_PROPERTY_INT_VW])
			{
	            dis = dis2;
	            index = x;
			}
		}
	}

	if ( dis <= radius ) {

		return index;
	}

	else index = INVALID_PROPERTY_ID ;

	return index ;
/*
	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) {

			if ( IsPlayerInRangeOfPoint(playerid, radius, Property [ i ] [ E_PROPERTY_EXT_X ],  Property [ i ] [ E_PROPERTY_EXT_Y ],  Property [ i ] [ E_PROPERTY_EXT_Z ] ) ) {

				if ( GetPlayerVirtualWorld(playerid) ==  Property [ i ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( playerid ) ==  Property [ i ] [ E_PROPERTY_EXT_INT ] ) {

					return i ; 
				}
			}

			else if ( IsPlayerInRangeOfPoint(playerid, radius, Property [ i ] [ E_PROPERTY_INT_X ],  Property [ i ] [ E_PROPERTY_INT_Y ],  Property [ i ] [ E_PROPERTY_INT_Z ] ) ) {

				if ( GetPlayerVirtualWorld(playerid) ==  Property [ i ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ i ] [ E_PROPERTY_INT_INT ] ) {

					return i ; 
				}
			}
		}

		else continue ; 
	}


	return INVALID_PROPERTY_ID ;*/
}

Property_GetInside( playerid, Float: radius = 100.0 )  {

	new Float: dis = 99999.99, Float: dis2, index = INVALID_PROPERTY_ID ;
	new interior = GetPlayerInterior(playerid);
	new world = GetPlayerVirtualWorld(playerid);

	if (!interior && !world && radius > 15.0) radius = 15.0; // lowering the radius for this to minimize potential vw 0 conflicts

	// Checking for INTERIOR point!
	for ( new x, y = sizeof ( Property ); x < y; x ++ ) {

		if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) {

			dis2 = GetPlayerDistanceFromPoint(playerid, 
				Property [ x ] [ E_PROPERTY_INT_X ], 
				Property [ x ] [ E_PROPERTY_INT_Y ], 
				Property [ x ] [ E_PROPERTY_INT_Z ]
			);

			// if in vw 0, vw check is skipped to (superficially in a broken way) allow property interiors in vw 0
			if (dis2 < dis && interior == Property[x][E_PROPERTY_INT_INT] && world == Property[x][E_PROPERTY_INT_VW])
			{
	            dis = dis2;
	            index = x;
			}
		}
	}

	if ( dis <= radius ) {

		return index;
	}

	return INVALID_PROPERTY_ID ;
}

Property_GetInsideAtCoords( Float:xx, Float:yy, Float:zz, world = -1, interior = -1, Float:radius = 100.0 )  
{
	new Float: dis = 99999.99, Float: dis2, index = INVALID_PROPERTY_ID ;

	// Checking for INTERIOR point! (note, intentionally for now doesn't work with vw 0 properties to avoid possible rare bugs)
	for ( new x, y = sizeof ( Property ); x < y; x ++ ) {

		if ( Property [ x ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) 
		{
			if (world != -1 && world != Property [ x ] [ E_PROPERTY_ID ]) continue;
			if (interior != -1 && interior != Property [ x ] [ E_PROPERTY_INT_INT ]) continue;

			dis2 = GetPointDistanceToPoint(xx, yy, zz, 
				Property [ x ] [ E_PROPERTY_INT_X ], 
				Property [ x ] [ E_PROPERTY_INT_Y ], 
				Property [ x ] [ E_PROPERTY_INT_Z ]
			);

			if (dis2 < dis ) {

	            dis = dis2;
	            index = x;
			}
		}
	}

	if ( dis <= radius ) {

		return index;
	}

	return INVALID_PROPERTY_ID ;
}