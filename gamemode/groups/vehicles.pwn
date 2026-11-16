
CMD:groupcars(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Group [ group_enum_id ] [ E_GROUP_DATA_TYPE ] != GROUP_TYPE_COMPANY ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This feature is only possible with companies.");
	}

	SendClientMessage(playerid, COLOR_BLUE, sprintf("%s's company vehicles:", Group [ group_enum_id ] [ E_GROUP_DATA_NAME ])) ;

	for_loop ( new i, j = sizeof ( Vehicle ); i < j; i ++ ) {

		if ( IsValidVehicle ( Vehicle [ i ] [ E_VEHICLE_ID ] ) ) {

			if ( Vehicle [ i ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_GROUP && Vehicle [ i ] [ E_VEHICLE_OWNER ] == groupid ) {

				if ( GetVehicleDriver (Vehicle [ i ] [ E_VEHICLE_ID ] ) == INVALID_PLAYER_ID ) {
					SendClientMessage(playerid, COLOR_INFO, sprintf("[%s] [VID: %d] [MODID: %d] [UNOCCUPIED]",
						ReturnVehicleName ( Vehicle [ i ] [ E_VEHICLE_ID ] ), Vehicle [ i ] [ E_VEHICLE_ID ],  GetVehicleModel ( Vehicle [ i ] [ E_VEHICLE_ID ] )));
				}

				else SendClientMessage(playerid, COLOR_ERROR, sprintf("[%s] [VID: %d] [MODID: %d] [OCCUPIED]",
						ReturnVehicleName ( Vehicle [ i ] [ E_VEHICLE_ID ] ), Vehicle [ i ] [ E_VEHICLE_ID ],  GetVehicleModel ( Vehicle [ i ] [ E_VEHICLE_ID ] )));
			}

			else continue ;
		}

		else continue ;
	}

	return true ;
}

CMD:gcars(playerid, params[]) return cmd_groupcars(playerid, params);

static GroupTowName[MAX_GROUPS][MAX_PLAYER_NAME];

CMD:grouptowcars(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	format(GroupTowName [ group_enum_id ], MAX_PLAYER_NAME, "%s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER));

	new query [ 256 ] ;
	format(query, sizeof(query), "(( All group / company vehicles will respawn in 15 seconds. Action by: (%d) %s ))",  
		playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)
	);
	Group_SendMessage(group_enum_id, query, true, true);

	defer Group_RespawnCars(playerid, groupid, group_enum_id);
	return true ;
}
CMD:gtow(playerid, params[]) return cmd_grouptowcars(playerid, params);
CMD:gtowcars(playerid, params[]) return cmd_grouptowcars(playerid, params);
CMD:grouptow(playerid, params[]) return cmd_grouptowcars(playerid, params);

timer Group_RespawnCars[15000](playerid, groupid, group_enum_id) {

	for_loop ( new i, j = sizeof ( Vehicle ); i < j; i ++ ) {

		if ( IsValidVehicle ( Vehicle [ i ] [ E_VEHICLE_ID ] ) && GetVehicleDriver ( Vehicle [ i ] [ E_VEHICLE_ID ]  ) == INVALID_PLAYER_ID  ) {

			if ( Vehicle [ i ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_GROUP && Vehicle [ i ] [ E_VEHICLE_OWNER ] == groupid ) {
						
				if ( IsValidDynamic3DTextLabel( Vehicle [ i ] [ E_VEHICLE_LABEL ] ) ) {

					DestroyDynamic3DTextLabel( Vehicle [ i ] [ E_VEHICLE_LABEL ] ) ;
				}

				SOLS_SetVehicleToRespawn(Vehicle [ i ] [ E_VEHICLE_ID ], "/gtow") ;
				ChangeVehicleColor(Vehicle [ i ] [ E_VEHICLE_ID ], Vehicle [ i ] [ E_VEHICLE_COLOR_A ], Vehicle [ i ] [ E_VEHICLE_COLOR_B ]);

				Vehicle [ i ] [ E_VEHICLE_FUEL ] = 100 ;
			}

			else continue ;
		}

		else continue ;
	}

	new query [ 128 ] ;
	format(query, sizeof(query), "(( (%d) %s has respawned all group / company vehicles. ))",  
		playerid, GroupTowName[group_enum_id]
	);
	Group_SendMessage(group_enum_id, query, true, true);

	return true ;
}

CMD:groupcarcolor(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}

	new color_a, color_b ;

	if ( sscanf ( params, "ii", color_a, color_b ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/g(roup)carcolor [color-a] [color-b]");
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "You can't do this as you're not the driver.");

	if ( vehicleid == INVALID_VEHICLE_ID || !vehicleid ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if( veh_enum_id != -1 && Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_GROUP) {

		if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] == Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {

			ChangeVehicleColor(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], color_a, color_b);

			Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ] = color_a ;
			Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ] = color_b ;

			new query [ 512 ] ;

			format(query, sizeof(query), "(( (%d) %s has changed the group's [%d] %s's car colors to %d and %d. ))",  
				playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], ReturnVehicleName ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] ), color_a, color_b
			);
			Group_SendMessage(group_enum_id, query, true, true);

			query [ 0 ] = EOS ;

			mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET vehicle_color_a = %d, vehicle_color_b = %d  WHERE vehicle_sqlid = %d",
				Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ]) ;

			mysql_tquery(mysql, query);
		}
	}

	return true ;
}
CMD:gcarcolor(playerid, params[]) return cmd_groupcarcolor(playerid, params);

CMD:grouppark(playerid, params[]) {

	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a group!");
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching group enumerator ID! Contact a DEV.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] > 2 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have the privileges to be able to do this command.");
	}


	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_ERROR, "You can't do this as you're not the driver.");

	if ( vehicleid == INVALID_VEHICLE_ID || !vehicleid ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're not near any vehicle!");
	}

	if( veh_enum_id != -1 && Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_GROUP) {

		if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] == Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {

			new Float: x, Float: y, Float: z, Float: a ;
			GetVehiclePos(vehicleid, x, y, z ) ;
			GetVehicleZAngle(vehicleid, a);

			Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ] = x ;
			Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] = y ;
			Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] = z ;
			Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ] = a ;

			SOLS_DestroyVehicle(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ]) ;

			veh_enum_id = Vehicle_Recreate ( veh_enum_id, Vehicle [ veh_enum_id ] [ E_VEHICLE_MODELID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_A], Vehicle [ veh_enum_id ] [ E_VEHICLE_COLOR_B], 0, 0) ;
			SetVehicleNumberPlate(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_LICENSE ] ) ;

			SetEngineStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_ENGINE ]);
			SetDoorStatus(Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], Vehicle [ veh_enum_id ] [ E_VEHICLE_DOORS ]);

			new query [ 512 ] ;

			format(query, sizeof(query), "(( (%d) %s has reparked the group's [%d] %s. ))",  
				playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ], ReturnVehicleName ( Vehicle [ veh_enum_id ] [ E_VEHICLE_ID ] )
			);
			Group_SendMessage(group_enum_id, query, true, true);

			query [ 0 ] = EOS ;

			mysql_format(mysql, query, sizeof(query), "UPDATE vehicles SET vehicle_pos_x = '%f',vehicle_pos_y = '%f',vehicle_pos_z = '%f',vehicle_pos_a = '%f' WHERE vehicle_sqlid = %d",
				Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID ]) ;

			mysql_tquery(mysql, query);

			SetVehiclePos(vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] ) ;
			SetVehicleZAngle(vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ]);

			return true ;
		}
	}	

	SendClientMessage(playerid, COLOR_ERROR, "You do not own this vehicle!");

	return true ;
}
CMD:gpark(playerid, params[]) return cmd_grouppark(playerid, params);

