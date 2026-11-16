enum {

	E_ASSEMBLY_FACTORY_A,
	E_ASSEMBLY_FACTORY_B
}

enum E_GUN_ASSEMBLY_DATA {

	E_GUN_ASSEMBLY_CONST,
	E_GUN_ASSEMBLY_DESC [ 64 ],
	Float: E_GUN_ASSEMBLY_POS_X,
	Float: E_GUN_ASSEMBLY_POS_Y,
	Float: E_GUN_ASSEMBLY_POS_Z,
	E_GUN_ASSEMBLY_FACTORY,

	E_GUN_ASSEMBLY_WOOD,
	E_GUN_ASSEMBLY_METAL,
	E_GUN_ASSEMBLY_PARTS
} ;

enum { // ASSEMBLE_CONST

	E_ASSEMBLE_STORE,
	E_ASSEMBLE_SELECT,
	E_ASSEMBLE_PROCESS, 
	E_ASSEMBLE_PROCESS_2,
	E_ASSEMBLE_AMMO
} ;

new GunAssembly [ ] [ E_GUN_ASSEMBLY_DATA ] = {
	{ E_ASSEMBLE_STORE, 	"[0] Store Materials", 			2210.7278,	-2254.3242,	 14.9575, E_ASSEMBLY_FACTORY_A } ,
	{ E_ASSEMBLE_SELECT, 	"[1] Select Weapon",  			2149.9712,	-2257.7385,	 13.2990, E_ASSEMBLY_FACTORY_A },
	{ E_ASSEMBLE_PROCESS, 	"[2] Add Materials",  	 		2149.8743,	-2265.4771,	 13.3062, E_ASSEMBLY_FACTORY_A },
	{ E_ASSEMBLE_PROCESS_2, "[3] Assemble Parts", 	 		2147.4609,	-2270.7158,	 13.3106, E_ASSEMBLY_FACTORY_A },
	{ E_ASSEMBLE_AMMO, 		"[4] Create Ammo", 	 			2140.6470,	-2257.1946,	 13.3000, E_ASSEMBLY_FACTORY_A },

	{ E_ASSEMBLE_STORE, 	"[0] Store Materials", 			613.4673, 1160.9205, 2001.1836, E_ASSEMBLY_FACTORY_A } , 	// store_mats
	{ E_ASSEMBLE_SELECT, 	"[1] Select Weapon",  			609.1820, 1177.0088, 2008.7190, E_ASSEMBLY_FACTORY_A }, 	// select_weapon
	{ E_ASSEMBLE_PROCESS, 	"[2] Add Materials",  	 		613.8544, 1171.3127, 2001.0859, E_ASSEMBLY_FACTORY_A }, 	// create_ammo
	{ E_ASSEMBLE_PROCESS_2, "[3] Assemble Parts", 	 		600.8891, 1151.4727, 2001.0859, E_ASSEMBLY_FACTORY_A }, 	// add_materials
	{ E_ASSEMBLE_AMMO, 		"[4] Create Ammo", 	 			601.1114, 1158.0261, 2001.0859, E_ASSEMBLY_FACTORY_A },	// assemble

	{ E_ASSEMBLE_STORE, 	"[0] Store Materials", 			1642.2505,	-1546.2463,	 13.6915, E_ASSEMBLY_FACTORY_B } ,
	{ E_ASSEMBLE_SELECT, 	"[1] Select Weapon",  			1635.3817,	-1533.4987,	 13.6915, E_ASSEMBLY_FACTORY_B } ,
	{ E_ASSEMBLE_PROCESS, 	"[2] Add Materials",  			1641.3333,	-1532.3181,	 13.6915, E_ASSEMBLY_FACTORY_B } ,
	{ E_ASSEMBLE_PROCESS_2, "[3] Assemble Parts", 			1636.8312,	-1523.1224,	 13.6915, E_ASSEMBLY_FACTORY_B } ,
	{ E_ASSEMBLE_AMMO, 		"[4] Create Ammo", 	 			1642.5151,	-1524.8949,	 13.6915, E_ASSEMBLY_FACTORY_B } 
} ;

GD_FetchAssemblyPoint_Const(playerid) {
	for_loop ( new i, j = sizeof ( GunAssembly ); i < j; i ++ ) {

		if ( IsPlayerInRangeOfPoint(playerid, 3.0, 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_X ], 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Y ], 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Z ]
		)) {

			return GunAssembly [ i ] [ E_GUN_ASSEMBLY_CONST ] ;
		}
	}

	return -1 ;
}

GD_FetchAssemblyPoint_Factory(playerid) {
	for_loop ( new i, j = sizeof ( GunAssembly ); i < j; i ++ ) {

		if ( IsPlayerInRangeOfPoint(playerid, 3.0, 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_X ], 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Y ], 
			GunAssembly [ i ] [ E_GUN_ASSEMBLY_POS_Z ]
		)) {

			return GunAssembly [ i ] [ E_GUN_ASSEMBLY_FACTORY ] ;
		}
	}

	return -1 ;
}

CMD:assemble(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == -1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new constant = GD_FetchAssemblyPoint_Const ( playerid ) ;
	new factory = GD_FetchAssemblyPoint_Factory(playerid)  ;

	if ( constant == -1 ) {

		return SendClientMessage(playerid, -1, "Not in range!");
	}

	if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_GUNS ) ) {

		return SendClientMessage(playerid, -1, "Your faction does not have access to gun production!");
	}

	switch ( factory ) {

		case E_ASSEMBLY_FACTORY_A: {
			if ( factionid != 11 ) { // CDS
				return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This factory is reserved for Cartel De Santos!");
			}
		}

		case E_ASSEMBLY_FACTORY_B: {
			if ( factionid != 12 ) { // LCF
				return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This factory is reserved for Leone Crime Family!");
			}
		}

	}

	GD_AssembleGun(playerid, constant ) ;

	return true ;
}

CMD:materials(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == -1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new index [ 32 ], sub [ 32 ], amount ;

	new constant = GD_FetchAssemblyPoint_Const ( playerid ) ;
	new factory = GD_FetchAssemblyPoint_Factory(playerid)  ;

	if ( factory == -1 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a factory.");
	}

	if ( sscanf ( params, "s[32]s[32]i", index, sub, amount ) ) {

		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "/materials [withdraw/deposit] [wood/metal/parts] [amount]");
		return SendServerMessage ( playerid, COLOR_YELLOW, "Factory Storage", "DEDEDE", sprintf("[Wood: %d] [Metal: %d] [Parts: %d]",
			GD_Factory [ factory ] [ E_GD_FACT_WOOD ], GD_Factory [ factory ] [ E_GD_FACT_METAL ], GD_Factory [ factory ] [ E_GD_FACT_PARTS ] ));
	}

	if ( constant == -1 ) {

		return SendClientMessage(playerid, -1, "Not in range!");
	}

	if ( ! MatchPlayerFactionType ( playerid, E_FACTION_EXTRA_GUNS ) ) {

		return SendClientMessage(playerid, -1, "Your faction does not have access to gun production!");
	}

	switch ( factory ) {

		case E_ASSEMBLY_FACTORY_A: {
			if ( factionid != 11 ) { // CDS
				return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This factory is reserved for Cartel De Santos!");
			}
		}

		case E_ASSEMBLY_FACTORY_B: {
			if ( factionid != 12 ) { // LCF
				return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This factory is reserved for Leone Crime Family!");
			}
		}
	}

	new query [ 256 ] ;

	if ( GunAssembly [ constant ] [ E_GUN_ASSEMBLY_CONST ] == E_ASSEMBLE_STORE ) {

		if ( ! strcmp ( index, "withdraw", true ) ) {

			if ( ! strcmp ( sub, "wood", true ) ) {

				if ( GD_Factory [ factory ] [ E_GD_FACT_WOOD ] < amount ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of wood you're trying to withdraw is more than the container holds.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_WOOD ] -= amount ;
				Character [ playerid ] [ E_CHARACTER_GD_WOOD ] += amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've withdrawn %d wood from the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has withdrawn %d wood from the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET wood = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_WOOD ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_wood = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_WOOD ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}

			else if ( ! strcmp ( sub, "metal", true ) ) {

				if ( GD_Factory [ factory ] [ E_GD_FACT_METAL] < amount ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of metal you're trying to withdraw is more than the container holds.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_METAL ] -= amount ;
				Character [ playerid ] [ E_CHARACTER_GD_METAL ] += amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've withdrawn %d metal from the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has withdrawn %d metal from the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET metal = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_METAL ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_metal = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_METAL ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}

			
			else if ( ! strcmp ( sub, "parts", true ) ) {

				if ( GD_Factory [ factory ] [ E_GD_FACT_PARTS] < amount ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of parts you're trying to withdraw is more than the container holds.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_PARTS ] -= amount ;
				Character [ playerid ] [ E_CHARACTER_GD_PARTS ] += amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've withdrawn %d parts from the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has withdrawn %d parts from the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET parts = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_PARTS ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_parts = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}

		}

		else if ( ! strcmp ( index, "deposit", true ) ) {
			if ( ! strcmp ( sub, "wood", true ) ) {

				if ( amount > Character [ playerid ] [ E_CHARACTER_GD_WOOD ] ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of wood you're trying to deposit is more than what you have.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_WOOD ] += amount ;
				Character [ playerid ] [ E_CHARACTER_GD_WOOD ] -= amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've deposited %d wood into the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has deposited %d wood into the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET wood = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_WOOD ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_wood = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_WOOD ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}

			else if ( ! strcmp ( sub, "metal", true ) ) {

				if ( amount > Character [ playerid ] [ E_CHARACTER_GD_METAL ] ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of metal you're trying to deposit is more than what you have.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_METAL ] += amount ;
				Character [ playerid ] [ E_CHARACTER_GD_METAL ] -= amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've deposited %d metal into the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has deposited %d metal into the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET metal = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_METAL ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_metal = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_METAL ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}

			else if ( ! strcmp ( sub, "parts", true ) ) {

				if ( amount > Character [ playerid ] [ E_CHARACTER_GD_PARTS ] ) {

					return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "The amount of parts you're trying to deposit is more than what you have.");
				}

				GD_Factory [ factory ] [ E_GD_FACT_PARTS ] += amount ;
				Character [ playerid ] [ E_CHARACTER_GD_PARTS ] -= amount ;

				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've deposited %d parts into the storage container.", amount ));

				Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has deposited %d parts into the faction storage slot. }",
						ReturnPlayerNameData ( playerid ), amount), faction_enum_id, false 
				) ;

				mysql_format ( mysql, query, sizeof ( query ), "UPDATE gd_factory SET parts = %d WHERE factory = %d",
					GD_Factory [ factory ] [ E_GD_FACT_PARTS ], factory ) ;

				mysql_tquery(mysql, query);

				mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_gd_parts = %d WHERE player_id = %d",
					Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] );

				mysql_tquery(mysql, query);
			}
		}

		else return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "/materials [withdraw/deposit] [wood/metal/parts] [amount]");
	}

	else return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You're not near a storage point.");

	// GD_Factory [ x ] [ E_GD_FACT_WOOD ] 



	return true ;
}

GD_AssembleGun(playerid, constant) {

	new string [ 2048 ], ammo_name [ 32 ], gun_name [ 32 ] ;
	new idx ;
	new wood_state [ 32 ], metal_state [ 32 ], parts_state [ 32 ], state_count ; 
	new factory = GD_FetchAssemblyPoint_Factory(playerid)  ;

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == -1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}


	switch ( GunAssembly [ constant ] [ E_GUN_ASSEMBLY_CONST ] ) {

		case E_ASSEMBLE_SELECT: {

			// First they choose a weapon slot. At the end, they can choose which custom weapon.
			inline GD_Select_Gun(pid, dialogid, response, listitem, string:inputtext[]) {
		    	#pragma unused pid, dialogid, listitem, inputtext

				if ( ! response ) {

			    	return false ;
				}

				if ( response ) {

					new slot = GD_Data_GetFreeSlot( factory ) ;
					new index [ 32 ] = 0, index_counter ;

					if ( slot == -1 ) {

						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "There's no empty slot.");
					}

					inline GD_Select_GunEx(pidex, dialogidex, responseex, listitemex, string:inputtextex[]) {
				    	#pragma unused pidex, dialogidex, listitemex, inputtextex

						if ( responseex ) {
							idx = index [ listitemex ] ;

							if ( ! Weapon [ idx ] [ E_WEAPON_CRAFTABLE ] ) {
								return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon type can't be crafted.");
							}

							Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name )) ; 

						 	SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("Creation of a (%d) \"%s\" has been started. See slot %d.", idx, gun_name, slot ));

							GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ slot ] = idx ;

							string[0] = EOS ;
			    			mysql_format ( mysql, string, sizeof ( string ), "UPDATE gd_factory SET slot_%d_type = %d WHERE factory = %d",
			    				slot, GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ slot ], factory ) ;
			    			mysql_tquery(mysql, string);

							Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has started creating a (%d) %s in slot %d. }",
								ReturnPlayerNameData ( playerid ), idx, gun_name, slot), faction_enum_id, false 
							) ;
						}
					}


					string [ 0 ] = EOS ;

					format ( string, sizeof ( string ), "Replacement \t Weapon Name \t Weapon Ammo\n" ) ;

					for_loop ( new i, j = sizeof ( Weapon ); i < j ; i ++ ) {

						if ( Weapon [ i ] [ E_WEAPON_TYPE ] == GunSelection [ listitem ] [ E_GUN_SEL_GUNID ] ) {

							index [ index_counter ] = i ;
							index_counter ++ ;

							Weapon_GetAmmoName ( i, ammo_name, sizeof ( ammo_name ) ) ;
							format(string, sizeof ( string ), "%s%s\t%s\t%s\n", string, Weapon_GetName ( playerid,Weapon [ i ] [ E_WEAPON_GUNID ] ), Weapon [ i ] [ E_WEAPON_DESC ], ammo_name ) ;
						}
					}

					Dialog_ShowCallback ( playerid, using inline GD_Select_GunEx, DIALOG_STYLE_TABLIST_HEADERS, "Choose Weapon", string, "{C23030}Continue", "No way" );

					/*
					GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ slot ] = listitem ;
					SendClientMessage(playerid, -1, sprintf("Weapon (%d) %s has been put into slot %d.", 
						listitem, GunSelection [ listitem ] [ E_GUN_SEL_DESC ], slot ) ) ;
					*/
					return true ;
				}
			}

			string[0]=EOS;
			format(string, sizeof ( string ), "Type of weapon\n" ) ;

			for_loop(new i, j = sizeof ( GunSelection ); i < j ; i ++ ) {

				format(string, sizeof ( string ), "%s%s\n", string, GunSelection [ i ] [ E_GUN_SEL_DESC ] ) ;
			}


			Dialog_ShowCallback ( playerid, using inline GD_Select_Gun, DIALOG_STYLE_TABLIST_HEADERS, "Choose Weapon Type", string, "{C23030}Continue", "No way" );

		}

		case E_ASSEMBLE_PROCESS: { // add materials

			inline GD_Display_Guns(pid, dialogid, response, listitem, string:inputtext[]) {
		    	#pragma unused pid, dialogid, inputtext

				if ( ! response ) {

			    	return false ;
				}

				if ( response ) {

					idx = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] ;

					if ( ! Weapon [ idx ] [ E_WEAPON_CRAFTABLE ] ) {
						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon type can't be crafted.");
					}

					if ( idx == -1 ) {											
						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is empty!");
					}

					gun_name [ 0 ] = EOS ;
					Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name )) ; 

					state_count = 0 ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) state_count ++ ;

					if ( state_count < 3 ) {

						inline GD_StoreMaterials(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
					    	#pragma unused pidx, dialogidx, inputtextx

							if ( ! responsex ) {

								return GD_AssembleGun(playerid, constant) ;
							}

							else if ( responsex ) {

								new amount, final ;

						    	switch ( listitemx ) {

						    		case 0: {

										amount = Character [ playerid ] [ E_CHARACTER_GD_WOOD ] ;

										if ( amount == 0 ) {

											GD_AssembleGun(playerid, constant) ;
											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You don't have any wood on you.");
										}

										if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) {

											GD_AssembleGun(playerid, constant) ;
											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is already full!");
										}

										if ( amount > Weapon [ idx ] [ E_WEAPON_WOOD ] ) {

											final = ( amount - Weapon [ idx ] [ E_WEAPON_WOOD ] ) ;
											amount -= final ;
										}

										GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] += amount ;
										Character [ playerid ] [ E_CHARACTER_GD_WOOD ] -= amount ;

						    			SendClientMessage(playerid, -1, sprintf("You've stored %d wood (%d/%d). You have %d remaining.",
						    				
						    				amount,
						    				GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ],
											Weapon [ idx ] [ E_WEAPON_WOOD ],
						    				Character [ playerid ] [ E_CHARACTER_GD_WOOD ]
						    			));

										string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), "UPDATE gd_factory SET slot_%d_wood = %d WHERE factory = %d",
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ], factory ) ;
						    			mysql_tquery(mysql, string);

										GD_AssembleGun(playerid, constant) ;
										GD_SavePlayerParts(playerid) ;
						    		}
						    		case 1: {

										amount = Character [ playerid ] [ E_CHARACTER_GD_METAL ] ;

										if ( amount == 0 ) {

											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You don't have any metal on you.");
										}

										if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) {

											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is already full!");
										}

										if ( amount > Weapon [ idx ] [ E_WEAPON_METAL ] ) {

											final = ( amount - Weapon [ idx ] [ E_WEAPON_METAL ] ) ;
											amount -= final ;
										}

										GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] += amount ;
										Character [ playerid ] [ E_CHARACTER_GD_METAL ] -= amount ;

						    			SendClientMessage(playerid, -1, sprintf("You've stored %d metal (%d/%d). You have %d remaining.",
						    				
						    				amount,
						    				GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ],
											Weapon [ idx ] [ E_WEAPON_METAL ],
						    				Character [ playerid ] [ E_CHARACTER_GD_METAL ]
						    			));

										string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), "UPDATE gd_factory SET slot_%d_metal = %d WHERE factory = %d",
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ], factory ) ;
						    			mysql_tquery(mysql, string);

										GD_AssembleGun(playerid, constant) ;
										GD_SavePlayerParts(playerid) ;
						    		}

						    		case 2: {

										amount = Character [ playerid ] [ E_CHARACTER_GD_PARTS ] ;

										if ( amount == 0 ) {

											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You don't have any parts on you.");
										}

										if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) {

											return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is already full!");
										}

										if ( amount > Weapon [ idx ] [ E_WEAPON_PARTS ] ) {

											final = ( amount - Weapon [ idx ] [ E_WEAPON_PARTS ] ) ;
											amount -= final ;
										}

										GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] += amount ;
										Character [ playerid ] [ E_CHARACTER_GD_PARTS ] -= amount ;

						    			SendClientMessage(playerid, -1, sprintf("You've stored %d parts (%d/%d). You have %d remaining.",
						    				
						    				amount,
						    				GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ],
											Weapon [ idx ] [ E_WEAPON_PARTS ],
						    				Character [ playerid ] [ E_CHARACTER_GD_PARTS ]
						    			));


										string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), "UPDATE gd_factory SET slot_%d_parts = %d WHERE factory = %d",
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ], factory ) ;
						    			mysql_tquery(mysql, string);

										GD_AssembleGun(playerid, constant) ;
										GD_SavePlayerParts(playerid) ;
						    		}

						    		case 3: { // Cancel


								 		new gun = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] ;


										Character [ playerid ] [ E_CHARACTER_GD_WOOD ] += GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] ;
										Character [ playerid ] [ E_CHARACTER_GD_METAL ] += GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] ;
										Character [ playerid ] [ E_CHARACTER_GD_PARTS ] += GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] ;

								 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] = -1 ;
								 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] = 0 ;
								 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] = 0 ;
								 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] = 0 ;
								 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ] = 0 ;

										string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), 
						    				"UPDATE gd_factory SET slot_%d_type = %d, slot_%d_wood = %d, slot_%d_metal = %d, \
						    				slot_%d_parts = %d,slot_%d_unix = %d WHERE factory = %d",

						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ], 
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ], 
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ], 
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ], 
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ], 

						    				factory 
						    			) ;

						    			mysql_tquery(mysql, string);

						    			string [ 0 ] = EOS ;

										mysql_format(mysql, string, sizeof ( string ), "UPDATE characters SET player_gd_wood = %d, player_gd_metal = %d, player_gd_parts = %d WHERE player_id = %d", 
											Character [ playerid ] [ E_CHARACTER_GD_WOOD ], Character [ playerid ] [ E_CHARACTER_GD_METAL ], Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

										mysql_tquery ( mysql, string ) ;

										Weapon_GetGunName ( gun, gun_name, sizeof ( gun_name )) ; 
								 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've cancelled the %s in slot %d. Stored materials have been refunded to your person.", gun_name )) ;

										Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has cancelled the order of the (%d) %s in slot %d. }",
											ReturnPlayerNameData ( playerid ), idx, gun_name, listitem), faction_enum_id, false 
										) ;

										GD_SavePlayerParts(playerid) ;
								 		return true ;
						    		}
						    	}

						    	state_count = 0 ;
								if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) state_count ++ ;
								if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) state_count ++ ;
								if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) state_count ++ ;

								if ( state_count >= 3 ) {

				    				GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ] = gettime() + Weapon [ idx ] [ E_WEAPON_TIME ] ;
				    				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE",
				    					sprintf("You've finished storing materials for the %s. It will be finished in %d seconds.",  
				    						gun_name,
				    						(GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [listitem ] - gettime()) )
				    				) ;


									Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has finished storing materials for the (%d) %s in slot %d. }",
										ReturnPlayerNameData ( playerid ), idx, gun_name, listitem), faction_enum_id, false 
									) ;

									string[0] = EOS ;
					    			mysql_format ( mysql, string, sizeof ( string ), "UPDATE gd_factory SET slot_%d_unix = %d WHERE factory = %d",
					    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ], factory ) ;
					    			mysql_tquery(mysql, string);
				    			}

								return true ;
						    }
						}

						Dialog_ShowCallback ( playerid, using inline GD_StoreMaterials, DIALOG_STYLE_LIST, "Add Material To Gun", "Add Wood\nAdd Metal\nAdd Parts\nCancel", "Continue.", "Back" );
					}

					else if ( state_count >= 3 ) {

						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon already has all materials added!");
					}

					return true ;
				}
			}

			format(string, sizeof ( string ), "Name \t Wood \t Metal \t Parts\n" ) ;

			// Make it so if the weapon's materials aren't maxed it shows up here. Else make it say "Finished Storing Materials".
			// For other dialog, make it so only the guns with materials stored show up.
			for_loop ( new i, j = 5; i < j ; i ++ ) {

				state_count = 0 ;
				idx = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ i ] ;

				if ( idx != -1 ) {

					gun_name [ 0 ] = EOS ;
					Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name )) ; 

					/////////////////////////////////////////
					////////////// Wood checks //////////////
					/////////////////////////////////////////

					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ i ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) {

						format ( wood_state, sizeof ( wood_state ), "FULL" ) ;
						state_count ++ ;
					}

					else if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ i ] < Weapon [ idx ] [ E_WEAPON_WOOD ] ) {

						format ( wood_state, sizeof ( wood_state ), "%d/%d", 
							GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ i ],
							Weapon [ idx ] [ E_WEAPON_WOOD ]
						) ;
					} 

					/////////////////////////////////////////
					////////////// Metal checks //////////////
					/////////////////////////////////////////

					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ i ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) {

						format ( metal_state, sizeof ( metal_state ), "FULL" ) ;
						state_count ++ ;
					}

					else if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ i ] < Weapon [ idx ] [ E_WEAPON_METAL ] ) {

						format ( metal_state, sizeof ( metal_state ), "%d/%d", 
							GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ i ],
							Weapon [ idx ] [ E_WEAPON_METAL ]
						) ;
					} 


					/////////////////////////////////////////
					////////////// Parts checks //////////////
					/////////////////////////////////////////

					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ i ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) {

						format ( parts_state, sizeof ( parts_state ), "FULL" ) ;
						state_count ++ ;
					}

					else if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ i ] < Weapon [ idx ] [ E_WEAPON_PARTS ] ) {

						format ( parts_state, sizeof ( parts_state ), "%d/%d", 
							GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ i ],
							Weapon [ idx ] [ E_WEAPON_PARTS ]
						) ;
					} 

					if ( state_count < 3 ) {

						format(string, sizeof ( string ), "%s%s \t %s \t %s \t %s\n",
							string, gun_name, 
							wood_state, metal_state, parts_state
						) ;
					}

					else if ( state_count >= 3 ) {


						format(string, sizeof ( string ), "%s%s \t Awaiting assembly\n",
							string, gun_name
						) ;
					}
				}

				else format(string, sizeof ( string ), "%sEmpty Slot \t No info available\n", string ) ;
			}

			Dialog_ShowCallback ( playerid, using inline GD_Display_Guns, DIALOG_STYLE_TABLIST_HEADERS, "Weapons In Queue", string, "Store", "Cancel" );
		}

		case E_ASSEMBLE_PROCESS_2: {

			format(string, sizeof ( string ), "Name \t Status \t Time Left\n" ) ;

			inline GD_Display_WaitingGuns(pid, dialogid, response, listitem, string:inputtext[]) {
				#pragma unused pid, dialogid, inputtext

				if ( response ) {
					idx = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] ;

					if ( ! Weapon [ idx ] [ E_WEAPON_CRAFTABLE ] ) {
						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon type can't be crafted.");
					}


					if ( idx == -1 ) {											
						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is empty!");
					}

					state_count = 0 ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) state_count ++ ;

					if ( state_count < 3 ) {

						return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon needs more materials. Go back to the material line!");
					}

				 	if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ] >= gettime()) {


				 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This weapon isn't finished yet." ) ;
				 	}

				 	else if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ] < gettime()) {

						new slot = -1 ;

				 		for ( new i, j = 10 ; i < j ; i ++ ) {

				 			if ( ! Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] ) {

				 				slot = i ;
				 				break;
				 			}

				 			else continue ;
				 		}

				 		if ( slot == -1 ) {
				 			return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You have no gun package slots left! Check /gunpackages." ) ;
				 		}

				 		new gun = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] ;

				 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ] = -1 ;
				 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ] = 0 ;
				 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ] = 0 ;
				 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ] = 0 ;
				 		GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ] = 0 ;

						string[0] = EOS ;
		    			mysql_format ( mysql, string, sizeof ( string ), 
		    				"UPDATE gd_factory SET slot_%d_type = %d, slot_%d_wood = %d, slot_%d_metal = %d, \
		    				slot_%d_parts = %d,slot_%d_unix = %d WHERE factory = %d",

		    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ listitem ], 
		    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ listitem ], 
		    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ listitem ], 
		    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ listitem ], 
		    				listitem, GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ listitem ], 

		    				factory 
		    			) ;

		    			mysql_tquery(mysql, string);

						Weapon_GetGunName ( gun, gun_name, sizeof ( gun_name )) ; 
				 		//SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've finalised a %s. You're given a single clip of ammo.", gun )) ;


						Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has withdrawn the (%d) %s from slot %d. }",
							ReturnPlayerNameData ( playerid ), idx, gun_name, listitem), faction_enum_id, false 
						) ;

				 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've prepared a %s. It has been stored in package slot %d. (/gunpackages).", gun_name, slot )) ;

				 		Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ] = gun ;
				 		Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ] = Weapon [ gun ] [ E_WEAPON_CLIP_SIZE ] ;

				 		string [ 0 ] = EOS ;
				 		mysql_format ( mysql, string, sizeof ( string ), "UPDATE characters SET player_gun_package_%d = %d, player_gun_package_%d_ammo = %d WHERE player_id = %d",
				 			slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ slot ], 
				 			slot, Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO ] [ slot ], 
				 			Character [ playerid ] [ E_CHARACTER_ID ]
				 		) ;

				 		mysql_tquery(mysql, string);
				 	}
				}
			}
			
			for_loop ( new i, j = 5; i < j ; i ++ ) {

				state_count = 0 ;
				idx = GD_Factory [ factory ] [ E_GD_FACT_SLOT_TYPE ] [ i ] ;

				if ( idx != -1 ) {

					gun_name [ 0 ] = EOS ;
					Weapon_GetGunName ( idx, gun_name, sizeof ( gun_name )) ; 

					// Makes sure that only finalized guns show up!
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_WOOD ] [ i ] >= Weapon [ idx ] [ E_WEAPON_WOOD ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_METAL ] [ i ] >= Weapon [ idx ] [ E_WEAPON_METAL ] ) state_count ++ ;
					if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_PARTS ] [ i ] >= Weapon [ idx ] [ E_WEAPON_PARTS ] ) state_count ++ ;

					if ( state_count >= 3 ) {

						if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ i ] >= gettime()) {
							format(string, sizeof(string), "%s%s \t Awaiting Assembly \t %d seconds left\n", 
								string, gun_name, ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ i ] - gettime())
							);
						}

						else if ( GD_Factory [ factory ] [ E_GD_FACT_SLOT_UNIX ] [ i ] < gettime()) {
							format(string, sizeof(string), "%s%s \t Awaiting Assembly \t Finished\n", 
								string, gun_name
							);
						}
					}

					else {

						format(string, sizeof(string), "%s%s \t Needs more materials\n", 
							string, gun_name
						);
					}
				}

				else format(string, sizeof ( string ), "%sEmpty Slot \t No info available\n", string ) ;
			}

			Dialog_ShowCallback ( playerid, using inline GD_Display_WaitingGuns, DIALOG_STYLE_TABLIST_HEADERS, "Weapons In Queue", string, "Store", "Cancel" );
		}

		case E_ASSEMBLE_AMMO: {

			// !!!!!!!!!!!!!!!!!
			// Add /loadammo [slot] [amount]
			// Make ammo save on the player!

			string [ 0 ] = EOS ;

			new metal_required, parts_required ;

			inline GD_Display_AmmoMenu(pid, dialogid, response, listitem, string:inputtext[]) {
				#pragma unused pid, dialogid, inputtext

				if ( response ) {

					idx = GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ listitem ] ;


					if ( idx == -1 ) {
						inline GD_Display_AmmoMenuAdd(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
							#pragma unused pidx, dialogidx, inputtextx

							listitemx += 1 ;

							if ( responsex ) {
								inline GD_Display_AmmoMenuQty(pidy, dialogidy, responsey, listitemy, string:inputtexty[]) {
									#pragma unused pidy, dialogidy, inputtexty

									new clips ;

									if ( responsey ) {
										switch ( listitemy ) {

											case 0: clips = 1 ;
											case 1: clips = 5 ;
											case 2: clips = 10 ;
										}

										// Skipping array index 0 (invalid ammo type)!
										new slot = GD_Data_GetFreeAmmoSlot( factory ) ;
										GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ slot ] = listitemx ;
										GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ slot ] = clips ;

										string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), 
						    				"UPDATE gd_factory SET ammo_%d_type = %d, ammo_%d_amount = %d WHERE factory = %d",
						    				slot, GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ slot ],
						    				slot, GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ slot ], factory ) ;
						    			mysql_tquery(mysql, string);

										GD_AssembleGun(playerid, constant) ;
										GD_SavePlayerParts(playerid) ;


										Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has started fabricating %d clips of %s. }",
											ReturnPlayerNameData ( playerid ), clips, Ammo [ listitemx ] [ E_AMMO_DESC ]), faction_enum_id, false 
										) ;
									}
								}

								string[0] = EOS ;

								format ( string, sizeof ( string ), 
									"Amount \t Bullets \t Metal Required \t Parts Required\n\
									1 clip \t %d bullets \t %d \t %d\n\
									5 clips \t %d bullets \t %d \t %d\n\
									10 clips \t %d bullets \t %d \t %d",
									Ammo [ listitemx ] [ E_AMMO_CLIPSIZE ], Ammo [listitemx ] [ E_AMMO_METAL ], Ammo [listitemx ] [ E_AMMO_PARTS ],
									( Ammo [ listitemx ] [ E_AMMO_CLIPSIZE ] * 5), (Ammo [listitemx ] [ E_AMMO_METAL ] * 5), (Ammo [listitemx ] [ E_AMMO_PARTS ] * 5), 
									( Ammo [ listitemx ] [ E_AMMO_CLIPSIZE ] * 10), (Ammo [listitemx ] [ E_AMMO_METAL ] * 10), (Ammo [listitemx ] [ E_AMMO_PARTS ] * 10)
								) ;

								Dialog_ShowCallback ( playerid, using inline GD_Display_AmmoMenuQty, DIALOG_STYLE_TABLIST_HEADERS, "Ammo Creation", string, "Proceed", "Cancel" );

							}
						}

						string [ 0 ] = EOS ;
						format(string, sizeof ( string ), "Name \t Metal Cost \t Parts Cost \t Time Required\n" ) ;

						for_loop ( new i = 1, j = sizeof ( Ammo ); i < j ; i ++ ) {


							format(string, sizeof ( string ), "%s%s \t %d \t %d \t %d\n", string, Ammo [ i ] [ E_AMMO_DESC ], Ammo [ i] [ E_AMMO_METAL ], Ammo [ i] [ E_AMMO_PARTS ], Ammo [ i] [ E_AMMO_TIME ] ) ;
						}

						Dialog_ShowCallback ( playerid, using inline GD_Display_AmmoMenuAdd, DIALOG_STYLE_TABLIST_HEADERS, "Ammo Creation", string, "Proceed", "Cancel" );
					}

					else if ( idx != -1 ) {

						metal_required = Ammo [ idx ] [ E_AMMO_METAL ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT] [ listitem ]  ;
						parts_required = Ammo [ idx ] [ E_AMMO_PARTS ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT] [ listitem ]  ;

						state_count = 0 ;

						if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] >= metal_required ) state_count ++ ;
						if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] >= parts_required ) state_count ++ ;

						if ( state_count < 2 ) {

							new amount, final ; 

							inline GD_StoreMaterials_Ammo(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
						    	#pragma unused pidx, dialogidx, inputtextx

								if ( ! responsex ) {

									return GD_AssembleGun(playerid, constant) ;
								}

								else if ( responsex ) {

									switch (listitemx ) {

										case 0: {

											amount = Character [ playerid ] [ E_CHARACTER_GD_METAL] ;

											if ( amount == 0 ) {

												GD_AssembleGun(playerid, constant) ;
												return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You don't have any metal on you.");
											}

											if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] >= metal_required ) {

												GD_AssembleGun(playerid, constant) ;
												return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is already full!");
											}

											if ( amount > metal_required ) {

												final = ( amount - metal_required ) ;
												amount -= final ;
											}

											GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] += amount ;
											Character [ playerid ] [ E_CHARACTER_GD_METAL ] -= amount ;

							    			SendClientMessage(playerid, -1, sprintf("You've stored %d metal (%d/%d). You have %d remaining.",
							    				
							    				amount,
							    				GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ],
												metal_required,
							    				Character [ playerid ] [ E_CHARACTER_GD_METAL ]
							    			));


											string[0] = EOS ;
							    			mysql_format ( mysql, string, sizeof ( string ), 
							    				"UPDATE gd_factory SET ammo_%d_metal = %d WHERE factory = %d",
							    				listitem, GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ], factory ) ;
							    			mysql_tquery(mysql, string);

											GD_AssembleGun(playerid, constant) ;
											GD_SavePlayerParts(playerid) ;
										}

										case 1: {

											amount = Character [ playerid ] [ E_CHARACTER_GD_PARTS] ;

											if ( amount == 0 ) {

												GD_AssembleGun(playerid, constant) ;
												return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "You don't have any parts on you.");
											}

											if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] >= parts_required ) {

												GD_AssembleGun(playerid, constant) ;
												return SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This slot is already full!");
											}

											if ( amount > parts_required ) {

												final = ( amount - parts_required ) ;
												amount -= final ;
											}

											GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] += amount ;
											Character [ playerid ] [ E_CHARACTER_GD_PARTS ] -= amount ;

							    			SendClientMessage(playerid, -1, sprintf("You've stored %d parts (%d/%d). You have %d remaining.",
							    				
							    				amount,
							    				GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ],
												parts_required,
							    				Character [ playerid ] [ E_CHARACTER_GD_PARTS ]
							    			));		

							    			string[0] = EOS ;
							    			mysql_format ( mysql, string, sizeof ( string ), 
							    				"UPDATE gd_factory SET ammo_%d_parts = %d WHERE factory = %d",
							    				listitem, GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ], factory ) ;
							    			mysql_tquery(mysql, string);

											GD_AssembleGun(playerid, constant) ;
											GD_SavePlayerParts(playerid) ;
										}

										case 2: { // cancel

								 			new ammo = GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ listitem ] ;

											Character [ playerid ] [ E_CHARACTER_GD_METAL ] += GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] ;
											Character [ playerid ] [ E_CHARACTER_GD_PARTS ] += GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] ;

								 			GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ listitem ] 	= -1 ;
									 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] 	= 0 ;
									 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] 	= 0 ;
									 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] 	= 0 ;
									 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ]		= 0 ;

							    			string[0] = EOS ;
							    			mysql_format ( mysql, string, sizeof ( string ), 
							    				"UPDATE gd_factory SET ammo_%d_type = -1, ammo_%d_amount = 0, ammo_%d_metal = 0, ammo_%d_parts = 0, ammo_%d_unix = 0 WHERE factory = %d",
							    				listitem,listitem,listitem,listitem,listitem, factory ) ;
							    			mysql_tquery(mysql, string);

							    			mysql_tquery(mysql, string);

							    			string [ 0 ] = EOS ;

											mysql_format(mysql, string, sizeof ( string ), "UPDATE characters SET player_gd_metal = %d, player_gd_parts = %d WHERE player_id = %d", 
												Character [ playerid ] [ E_CHARACTER_GD_METAL ], Character [ playerid ] [ E_CHARACTER_GD_PARTS ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;

											mysql_tquery ( mysql, string ) ;

											Ammo_GetAmmoName ( ammo, gun_name, sizeof ( gun_name )) ; 
									 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf("You've cancelled the %s in slot %d. Stored materials have been refunded to your person.", gun_name )) ;
										
											GD_SavePlayerParts(playerid) ;

											Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has cancelled the order of %d clips of %s. }",
												ReturnPlayerNameData ( playerid ), GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ], Ammo [ ammo ] [ E_AMMO_DESC ]), faction_enum_id, false 
											) ;
										}
									}

									state_count = 0 ;

									if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] >= metal_required ) state_count ++ ;
									if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] >= parts_required ) state_count ++ ;

									// Weapon is created
									if ( state_count >= 2 ) {

										GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ] = gettime() + ( Ammo [ idx ] [ E_AMMO_TIME ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] ) ;

					    				SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE",
					    					sprintf("You've finished storing materials for the %s. It will be finished in %d seconds.",  
					    						Ammo [ idx ] [ E_AMMO_DESC ],
					    						(GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [listitem ] - gettime()) )
					    				) ;

						    			
						    			string[0] = EOS ;
						    			mysql_format ( mysql, string, sizeof ( string ), 
						    				"UPDATE gd_factory SET ammo_%d_unix = %d WHERE factory = %d",
						    				listitem, GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ], factory ) ;
						    			mysql_tquery(mysql, string);

										GD_AssembleGun(playerid, constant) ;
										GD_SavePlayerParts(playerid) ;

										Faction_SendMessage(factionid, sprintf("{ [FACTORY] %s has finished the order of %d clips of %s. }",
											ReturnPlayerNameData ( playerid ), GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ], Ammo [ idx ] [ E_AMMO_DESC ]), faction_enum_id, false 
										) ;
									}
								}
							}

							Dialog_ShowCallback ( playerid, using inline GD_StoreMaterials_Ammo, DIALOG_STYLE_LIST, "Add Material To Ammo", "Add Metal\nAdd Parts\nCancel", "Continue.", "Back" );
						}

						else if ( state_count >= 2 ) {

						 	if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ] >= gettime()) {

						 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", "This ammo batch isn't finished yet." ) ;
						 	}

						 	else if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ] < gettime()) {

						 		switch ( Ammo [ idx ] [ E_AMMO_CONSTANT]) {

							 		case AMMO_TYPE_A: Character [ playerid ] [ E_CHARACTER_AMMO_A ] += GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_B: Character [ playerid ] [ E_CHARACTER_AMMO_B ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_C: Character [ playerid ] [ E_CHARACTER_AMMO_C ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_D: Character [ playerid ] [ E_CHARACTER_AMMO_D ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_F: Character [ playerid ] [ E_CHARACTER_AMMO_F ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_G: Character [ playerid ] [ E_CHARACTER_AMMO_G ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_H: Character [ playerid ] [ E_CHARACTER_AMMO_H ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_I: Character [ playerid ] [ E_CHARACTER_AMMO_I ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
									case AMMO_TYPE_J: Character [ playerid ] [ E_CHARACTER_AMMO_J ]	+= GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ] ;
								}

						 		SendServerMessage ( playerid, COLOR_GD, "Gun Factory", "DEDEDE", sprintf( "You've made %d clips, each with %d bullets of %s. (%d total). To view your ammo, use /myammo.",
						 			GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ], Ammo [ idx ] [ E_AMMO_CLIPSIZE ], Ammo [ idx ] [ E_AMMO_DESC ], (GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] * Ammo [ idx ] [ E_AMMO_CLIPSIZE ]) ) ) ;

								GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ listitem ] 	= -1 ;
						 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ listitem ] 	= 0 ;
						 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ listitem ] 	= 0 ;
						 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ listitem ] 	= 0 ;
						 		GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ listitem ]		= 0 ;

				    			string[0] = EOS ;
				    			mysql_format ( mysql, string, sizeof ( string ), 
				    				"UPDATE gd_factory SET ammo_%d_type = -1, ammo_%d_amount = 0, ammo_%d_metal = 0, ammo_%d_parts = 0, ammo_%d_unix = 0 WHERE factory = %d",
				    				listitem,listitem,listitem,listitem,listitem, factory ) ;
				    			mysql_tquery(mysql, string);

				    			Ammo_SaveForPlayer(playerid);
						 	}
						}
					}
				}
			}

			metal_state[0]=EOS;
			parts_state[0]=EOS;

			format(string, sizeof ( string ), "Name \t Metal \t Parts \t Progress\n" ) ;



			for_loop ( new i, j = 5; i < j ; i ++ ) {
				state_count = 0 ;
				idx = GD_Factory [ factory ] [ E_GD_FACT_AMMO_TYPE ] [ i ] ;

				if ( idx != -1 ) {

					////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////// METAL CHECKS //////////////////////////////////
					////////////////////////////////////////////////////////////////////////////////

					metal_required = Ammo [ idx ] [ E_AMMO_METAL ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT] [ i ]  ;
					parts_required = Ammo [ idx ] [ E_AMMO_PARTS ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT] [ i ]  ;


					if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ i ] >= metal_required ) {

						format ( metal_state, sizeof ( metal_state ), "FULL" ) ;
						state_count ++ ;
					}

					else if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ i ] < metal_required ) {

						format ( metal_state, sizeof ( metal_state ), "%d/%d", GD_Factory [ factory ] [ E_GD_FACT_AMMO_METAL ] [ i ], metal_required ) ;
					} 

					////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////// PARTS CHECKS //////////////////////////////////
					////////////////////////////////////////////////////////////////////////////////
					if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ i ] >= parts_required ) {

						format ( parts_state, sizeof ( parts_state ), "FULL" ) ;
						state_count ++ ;
					}

					else if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ i ] < parts_required ) {

						format ( parts_state, sizeof ( parts_state ), "%d/%d",  GD_Factory [ factory ] [ E_GD_FACT_AMMO_PARTS ] [ i ], parts_required ) ;
					} 

					if ( state_count < 2 ) {

						format(string, sizeof ( string ), "%s%s \t %s \t %s \t %d clips (%d total)\n", string, Ammo [ idx ] [ E_AMMO_DESC ], metal_state, parts_state,  GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ], ( Ammo [ idx ] [ E_AMMO_CLIPSIZE ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ] ) ) ;
					}

					else if ( state_count >= 2 ) {

						if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ i ] >= gettime()) {
	
							format(string, sizeof ( string ), "%s%s \t Materials Added \t %d clips (%d total)\t Time left: %d seconds\n", string, Ammo [ idx ] [ E_AMMO_DESC ], GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ], ( Ammo [ idx ] [ E_AMMO_CLIPSIZE ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ] ), (GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [i ] - gettime())) ;
						}

						else if ( GD_Factory [ factory ] [ E_GD_FACT_AMMO_UNIX ] [ i ] < gettime()) {

							format(string, sizeof ( string ), "%s%s \t Materials Added \t %d clips (%d total)\t Finished\n", string, Ammo [ idx ] [ E_AMMO_DESC ],  GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ], ( Ammo [ idx ] [ E_AMMO_CLIPSIZE ] * GD_Factory [ factory ] [ E_GD_FACT_AMMO_AMOUNT ] [ i ] ) ) ;
						}
					}
				}

				else {

					format ( string, sizeof ( string ), "%sEmpty Slot - Create\n", string ) ;
				}
			}

			Dialog_ShowCallback ( playerid, using inline GD_Display_AmmoMenu, DIALOG_STYLE_TABLIST_HEADERS, "Ammo Creation", string, "Proceed", "Cancel" );
		}
	}

	return true ;
}


CMD:spoofmats(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new wood, metal, parts ;

	if ( sscanf  (params, "iii", wood, metal, parts ) ) {
		return SendClientMessage(playerid, -1, "/spoofmats <wood> <metal> <parts>" ) ;
	}

	Character [ playerid ] [ E_CHARACTER_GD_WOOD ] += wood ;
	Character [ playerid ] [ E_CHARACTER_GD_METAL ] += metal ;
	Character [ playerid ] [ E_CHARACTER_GD_PARTS ] += parts ;

	SendClientMessage(playerid, -1, sprintf("New wood: %d (added %d), new metal: %d (added %d), new parts: %d (added %d)",
		Character [ playerid ] [ E_CHARACTER_GD_WOOD ], wood,
		Character [ playerid ] [ E_CHARACTER_GD_METAL ], metal,
		Character [ playerid ] [ E_CHARACTER_GD_PARTS ], parts

	)) ;

	return true ;
}