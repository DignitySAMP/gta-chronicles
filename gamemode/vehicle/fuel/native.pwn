public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float: rx, Float: ry, Float:rz) {
	
	if ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELSTATION ] ) {

		if ( IsValidDynamicObject(PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ]) ) {

			if ( objectid == PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] ) {

				new Float: obj_x, Float: obj_y, Float: obj_z ;
				GetDynamicObjectPos ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ], obj_x, obj_y, obj_z ) ;
				if ( GetPlayerDistanceFromPoint(playerid, x, y, z ) > 7.5 ) {

					PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELSTATION ] = false ;

					DestroyDynamicObject ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] ) ;
					PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] = INVALID_STREAMER_ID ;

					PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_TYPE ] = 0 ;

					SendClientMessage ( playerid, -1, "You're too far away from the placeholder object. Resetting state...");
				}

				else switch ( response ) {
					case EDIT_RESPONSE_CANCEL  : {

						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELSTATION ] = false ;

						DestroyDynamicObject ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] ) ;
						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] = INVALID_STREAMER_ID ;

						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_TYPE ] = 0 ;

						SendClientMessage ( playerid, -1, "You've cancelled the creation of a new pump.");
					}

					case EDIT_RESPONSE_FINAL   : {


						Fuel_OnCreateStation(PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_TYPE ], x, y, z, rx, ry, rz, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

						SendClientMessage(playerid, -1, "Created fuel station at designated location.");

						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELSTATION ] = false ;

						DestroyDynamicObject ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] ) ;
						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ] = INVALID_STREAMER_ID ;

						PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_TYPE ] = 0 ;

					}

					case EDIT_RESPONSE_UPDATE  : {

						SetDynamicObjectPos ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ], x, y, z ) ;
						SetDynamicObjectRot ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ], rx, ry, rz ) ;
					}
				}
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_EDITING_FUELSTATION ] ) {

		new idx = PlayerVar [ playerid ] [ E_PLAYER_EDITING_FUELSTATION_ID ] ;

		if ( IsValidDynamicObject( FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ] ) ) {

			if ( FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ] == objectid ) {

				new Float: obj_x, Float: obj_y, Float: obj_z ;
				GetDynamicObjectPos ( PlayerVar [ playerid ] [ E_PLAYER_PLACING_FUELST_OBJID ], obj_x, obj_y, obj_z ) ;
				if ( GetPlayerDistanceFromPoint(playerid, x, y, z ) > 7.5 ) {

					PlayerVar [ playerid ] [ E_PLAYER_EDITING_FUELSTATION ] = false ;

					SetDynamicObjectPos(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
						 FuelPump [ idx ] [ E_FUEL_PUMP_POS_X ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_Y ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_Z ]);

					SetDynamicObjectRot(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
						 FuelPump [ idx ] [ E_FUEL_PUMP_POS_RX ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_RY ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_RZ ]);

					SendClientMessage ( playerid, -1, "You're too far away from the placeholder object. Resetting state...");
				}

				else switch ( response ) {
					case EDIT_RESPONSE_CANCEL  : {

						SetDynamicObjectPos(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
							 FuelPump [ idx ] [ E_FUEL_PUMP_POS_X ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_Y ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_Z ]);

						SetDynamicObjectRot(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
							 FuelPump [ idx ] [ E_FUEL_PUMP_POS_RX ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_RY ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_RZ ]);

						SendClientMessage ( playerid, -1, sprintf("You've cancelled the editing of pump SQL ID %d.", FuelPump [ idx ] [ E_FUEL_PUMP_ID ] ));
					}

					case EDIT_RESPONSE_FINAL   : {

						SendClientMessage(playerid, -1, sprintf("You have moved fuel station SQL ID %d.", FuelPump [ idx ] [ E_FUEL_PUMP_ID ]));

						PlayerVar [ playerid ] [ E_PLAYER_EDITING_FUELSTATION ] = false ;

						FuelPump [ idx ] [ E_FUEL_PUMP_POS_X ] = x;
						FuelPump [ idx ] [ E_FUEL_PUMP_POS_Y ] = y ;
						FuelPump [ idx ] [ E_FUEL_PUMP_POS_Z ] = z ;
						FuelPump [ idx ] [ E_FUEL_PUMP_POS_RX ] = rx ;
						FuelPump [ idx ] [ E_FUEL_PUMP_POS_RY ] = ry ;
						FuelPump [ idx ] [ E_FUEL_PUMP_POS_RZ ] = rz ;

						SetDynamicObjectPos(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
							FuelPump [ idx ] [ E_FUEL_PUMP_POS_X ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_Y ],  
							FuelPump [ idx ] [ E_FUEL_PUMP_POS_Z ]
						);

						SetDynamicObjectRot(FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ],
							FuelPump [ idx ] [ E_FUEL_PUMP_POS_RX ],  FuelPump [ idx ] [ E_FUEL_PUMP_POS_RY ],  
							FuelPump [ idx ] [ E_FUEL_PUMP_POS_RZ ]
						);

						new query [ 512 ] ;

						mysql_format(mysql, query, sizeof(query), "UPDATE fuelstation SET fuelstation_pos_x = '%f', fuelstation_pos_y = '%f', fuelstation_pos_z = '%f',\
							fuelstation_pos_rx = '%f', fuelstation_pos_ry = '%f', fuelstation_pos_rz = '%f' WHERE fuelstation_id = %d ", 
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_X ],
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_Y ],
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_Z ],
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_RX ],
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_RY ],
								FuelPump [ idx ] [ E_FUEL_PUMP_POS_RZ ],
								FuelPump [ idx ] [ E_FUEL_PUMP_ID ]
						) ;

						mysql_tquery(mysql, query);
					}

					case EDIT_RESPONSE_UPDATE  : {

						SetDynamicObjectPos ( FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ], x, y, z ) ;
						SetDynamicObjectRot ( FuelPump [ idx ] [ E_FUEL_PUMP_OBJECTID ], rx, ry, rz ) ;
					}
				}
			}
		}

	}
	#if defined fuelst_OnPlayerEditDynObject
		return fuelst_OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float: rx, Float: ry, Float:rz);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditDynamicObject
	#undef OnPlayerEditDynamicObject
#else
	#define _ALS_OnPlayerEditDynamicObject
#endif

#define OnPlayerEditDynamicObject fuelst_OnPlayerEditDynObject
#if defined fuelst_OnPlayerEditDynObject
	forward fuelst_OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float: rx, Float: ry, Float:rz);
#endif

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid) 
{
	foreach(new fuelid: FuelPump) 
	{
		if (FuelPump[fuelid][E_FUEL_PUMP_AREAID] == areaid) 
		{
			if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
			{
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);

				if (floatabs(z - FuelPump[fuelid][E_FUEL_PUMP_POS_Z]) < 7.5) // stops helicopters being affected, etc
				{ 
					switch (FuelPump[fuelid][E_FUEL_PUMP_TYPE]) 
					{
						case E_FUEL_TYPE_RON:		PlayerTextDrawSetString(playerid, fuel_player_gui[playerid][9], "Welcome to ~y~RON~w~, press ~r~~k~~VEHICLE_FIREWEAPON~ ~w~to begin.");
						case E_FUEL_TYPE_GLOBEOIL:	PlayerTextDrawSetString(playerid, fuel_player_gui[playerid][9], "Welcome to ~r~~h~Globe Oil~w~, press ~r~~k~~VEHICLE_FIREWEAPON~ ~w~to begin.");
						case E_FUEL_TYPE_TERROIL:	PlayerTextDrawSetString(playerid, fuel_player_gui[playerid][9], "Welcome to ~g~~h~TERROIL~w~, press ~r~~k~~VEHICLE_FIREWEAPON~ ~w~to begin.");
						default: return 1;
					}

					//Fuel_ShowPlayerGUI(playerid, FuelPump[fuelid][E_FUEL_PUMP_TYPE]);
					PlayerVar[playerid][E_PLAYER_FUEL_GUI_SHOWN] = false; 
					PlayerVar[playerid][E_PLAYER_NEAR_FUELSTATION] = true;
					PlayerVar[playerid][E_PLAYER_USING_NOZZLE] = false;
					PlayerTextDrawShow(playerid, fuel_player_gui[playerid][9]);
				}
			}
		}
	}

	#if defined fuelst_OnPlayerEnterDynamicArea
		return fuelst_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea fuelst_OnPlayerEnterDynamicArea
#if defined fuelst_OnPlayerEnterDynamicArea
	forward fuelst_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid) 
{
	foreach(new fuelid: FuelPump) 
	{
		if (FuelPump[fuelid][E_FUEL_PUMP_AREAID] == areaid) 
		{
			Fuel_HidePlayerGUI(playerid);
			PlayerVar[playerid][E_PLAYER_FUEL_GUI_SHOWN] = false; 
			PlayerVar[playerid][E_PLAYER_NEAR_FUELSTATION] = false;
			PlayerVar[playerid][E_PLAYER_USING_NOZZLE] = false;
			if (PlayerVar[playerid][E_PLAYER_FUEL_COST]) TakePlayerCash(playerid, PlayerVar[playerid][E_PLAYER_FUEL_COST]);
			PlayerVar[playerid][E_PLAYER_FUEL_COST] = 0;
		}
	}
	
	#if defined fuelst_OnPlayerLeaveDynamicArea
		return fuelst_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea fuelst_OnPlayerLeaveDynamicArea
#if defined fuelst_OnPlayerLeaveDynamicArea
	forward fuelst_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	
	if ( IsPlayerInAnyVehicle ( playerid ) && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) {
		if ( newkeys & KEY_FIRE ) { // KEY_FIRE == KEY_WALK in vehicles (4)
			if ( PlayerVar [ playerid ] [ E_PLAYER_NEAR_FUELSTATION ] ) 
			{

				new fuelid = Fuel_GetNearestPump(playerid, 10.0);
				new vehicleid = GetPlayerVehicleID(playerid);
				new veh_enum_id = Vehicle_GetEnumID(vehicleid) ;

				if ( GetEngineStatus(vehicleid) ) {

					return SendClientMessage(playerid, COLOR_ERROR, "Turn your vehicle off before attempting to refuel!");
				}

				if ( fuelid != INVALID_FUEL_STATION_ID ) {

					if (!PlayerVar[playerid][E_PLAYER_FUEL_GUI_SHOWN])
					{
						Fuel_ShowPlayerGUI(playerid, FuelPump[fuelid][E_FUEL_PUMP_TYPE]);
						PlayerVar[playerid][E_PLAYER_FUEL_GUI_SHOWN] = true; 
						return true;
					}

					if ( veh_enum_id == -1 ) {

						return true ;
					}

					if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] >= 100 ) {

						Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] = 100 ;
						ShowPlayerInfoMessage(playerid, "Your vehicle is already full of fuel (100 '/.). It's pointless to fill it up further.", 
						 	.height=285.0, .width = 200.0, .showtime = 6000
						);
			
						return true ;
					} 

					if ( ! PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] ) {
						PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] = true ;

						PlayerTextDrawHide ( playerid, fuel_player_gui[playerid][2] );
						PlayerTextDrawShow ( playerid, fuel_player_gui[playerid][3] );

						PlayerTextDrawHide(playerid, fuel_player_gui[playerid][4] ) ;
						PlayerTextDrawHide(playerid, fuel_player_gui[playerid][5] ) ;
						PlayerTextDrawHide(playerid, fuel_player_gui[playerid][6] ) ;

						PlayerTextDrawSetString(playerid, fuel_player_gui[playerid][7], sprintf("%d '/.~n~~g~$0__", Vehicle [ veh_enum_id ] [ E_VEHICLE_FUEL ] ));
						PlayerTextDrawShow(playerid, fuel_player_gui[playerid][7]); // fuel amount

						OnPlayerRefuelCar(playerid);

						Fuel_OnShowPlayerGui_Extra(playerid );
					}

					else if ( PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] ) {
						PlayerVar [ playerid ] [ E_PLAYER_USING_NOZZLE ] = false ;

						PlayerTextDrawShow ( playerid, fuel_player_gui[playerid][2] );
						PlayerTextDrawHide ( playerid, fuel_player_gui[playerid][3] );

						PlayerTextDrawShow(playerid, fuel_player_gui[playerid][4] ) ;
						PlayerTextDrawShow(playerid, fuel_player_gui[playerid][5] ) ;
						PlayerTextDrawShow(playerid, fuel_player_gui[playerid][6] ) ;

						PlayerTextDrawHide(playerid, fuel_player_gui[playerid][7]); // fuel amount

						Fuel_OnHidePlayerGui_Extra(playerid);
					}
				}
			}
		}
	}


	#if defined fuels_OnPlayerKeyStateChange
		return fuels_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange fuels_OnPlayerKeyStateChange
#if defined fuels_OnPlayerKeyStateChange
	forward fuels_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif


public OnPlayerConnect(playerid) {
	
	Fuel_OnLoadPlayerGUI(playerid);


	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);



	#if defined fuel_OnPlayerConnect
		return fuel_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect fuel_OnPlayerConnect
#if defined fuel_OnPlayerConnect
	forward fuel_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason) {
	
	if ( PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) {

		TakePlayerCash ( playerid, PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] ) ;
		PlayerVar [ playerid ] [ E_PLAYER_FUEL_COST ] = 0 ;
	}

	Fuel_DestroyPlayerGUI(playerid);

	#if defined fuel_OnPlayerDisconnect
		return fuel_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect fuel_OnPlayerDisconnect
#if defined fuel_OnPlayerDisconnect
	forward fuel_OnPlayerDisconnect(playerid, reason);
#endif
