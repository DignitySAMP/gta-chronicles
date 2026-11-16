CMD:crate(playerid, params[]) {



	if (PlayerVar [ playerid ] [ E_PLAYER_CRATE_COOLDOWN ]  >= gettime ()) {
		
		new string[256];

		format ( string, sizeof ( string ), "You need to wait %d seconds before using this command again.", PlayerVar [ playerid ] [ E_PLAYER_CRATE_COOLDOWN] - gettime ()) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", string );
	}

	if ( ! strcmp ( params, "pickup", true ) ) {

		Crate_Pickup ( playerid ) ;
	}

	else if ( ! strcmp ( params, "putdown", true ) ) {

		Crate_Putdown ( playerid ) ;
	}

	else if ( ! strcmp ( params, "list", true ) ) {
		if(IsPlayerInAnyVehicle(playerid)) {

			new string[3456], line[64], crate_type[10], 
				vehicleid = GetPlayerVehicleID(playerid), count, 
				veh_enum_id = Vehicle_GetEnumID ( vehicleid );

			if ( vehicleid == INVALID_VEHICLE_ID || veh_enum_id == -1) {

				return SendClientMessage(playerid, COLOR_ERROR, "You're not in any proper vehicle!");
			}

			new modelid = GetVehicleModel ( vehicleid ), item_id ;

			for_loop(new idx = 0; idx < GetMaxStorageModel(modelid); idx++) {
				if(VehicleVar [ veh_enum_id ] [ E_VEHICLE_TRUCKER_ITEM ] [ idx ] > -1) {

					item_id = VehicleVar [ veh_enum_id ] [ E_VEHICLE_TRUCKER_ITEM ] [ idx ] ;

					if ( item_id != -1 ) {
						if(IsLiquid(item_id)) { 

							crate_type = "Liquid"; 
						}

						else if(IsBrokenMaterial(item_id)) { 

							crate_type = "Material"; 
						}
						else if(IsFood(item_id)) { 

							crate_type = "Food"; 
						}
						else { 

							crate_type = "Crate Box"; 
						}

						format(line, sizeof(line), "%s (ID: %d)\tContent: {ffff00}%s\n", crate_type, idx, 
							TruckerItem[item_id][E_WHOLESALER_ITEM_NAME]
						);
					}

					else format ( line, sizeof ( line ), "Unknown (ID: %d)\tContent: {ffff00}Unknown\n", idx ) ;

					strcat(string, line);

					count ++ ;
				}
			}

			inline TruckerBootInfo(pid, dialogid, response, listitem, string:inputtext[]) {
			    #pragma unused pid, response, dialogid, listitem, inputtext

				return true ;
			}

			Dialog_ShowCallback ( playerid, using inline TruckerBootInfo, DIALOG_STYLE_TABLIST, "Trucker Trunk Storage", string, "OK", "" );

			if ( ! count ) {

				return SendClientMessage(playerid, -1, "Nothing found." ) ;
			}
		}

		else return SendServerMessage ( playerid, COLOR_JOB, "Trucker", "DEDEDE", "You can only do this command while inside of a vehicle."  ) ;
	}

	else if ( ! strcmp ( params, "reset", true ) ) {

		if(PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX ] != -1) {

			ApplyAnimation(playerid, "bsktball", "bball_jump_cancel_o", 4.1, 0, 0, 0, 1, 1, 1);

			PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX ] = -1 ;
			PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX_OBJ ] = -1 ;

			new item, item_name [ 32 ] ;

			item = PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX_ITEM ] ;
			TruckerItem_GetName(item, item_name, sizeof ( item_name ) ) ;

			PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX_ITEM ] = -1 ;

			new string [ 128 ] ;

			format ( string, sizeof ( string ), "You've reset your crate variables. Your %s crate has been removed without refund.", item_name  ) ;
			SendServerMessage ( playerid, COLOR_JOB, "Trucker", "DEDEDE", string ) ;

			SetPlayerSpecialAction(playerid, 0);
			RemovePlayerAttachedObject(playerid, E_ATTACH_INDEX_SYSTEM);
		}

		else return SendServerMessage ( playerid, COLOR_JOB, "Trucker", "DEDEDE", "You aren't carrying a crate."  ) ;
	}

	else return SendClientMessage(playerid, -1, "/crate [pickup/putdown/list/reset] (warning: \"reset\" removes your carry data, without refund" ) ;
	return true ;
}
