enum E_POLICE_OBJECT_DATA {

	E_PD_OBJ_ID,
	E_PD_OBJ_OBJECTID,

	// Stores returned name + acc & char id
	E_PD_OBJ_PLACEDBY [ MAX_PLAYER_NAME + 32 ]
} ;

#if !defined MAX_PD_OBJECTS
	#define MAX_PD_OBJECTS ( 150 ) 
#endif

#if !defined INVALID_PDOBJ_ID
	#define INVALID_PDOBJ_ID	-1
#endif

new PoliceObjects [ MAX_PD_OBJECTS ] [ E_POLICE_OBJECT_DATA ] ;


PoliceObject_LoadEntities() {

	for_loop(new i, j = sizeof ( PoliceObjects ); i < j ; i ++ ) {

		PoliceObjects [ i ] [ E_PD_OBJ_ID ] = INVALID_PDOBJ_ID ;
	}
}

PoliceObject_GetFreeID() {

	for_loop(new i, j = sizeof ( PoliceObjects ); i < j ; i ++ ) {

		if ( PoliceObjects [ i ] [ E_PD_OBJ_ID ] == INVALID_PDOBJ_ID ) {

			return i ; 
		}
	}

	return INVALID_PDOBJ_ID ;
}

PoliceObject_CreateEntity(playerid, modelid ) {

	new pdobj_enum_id = PoliceObject_GetFreeID() ;

	if ( pdobj_enum_id == INVALID_PDOBJ_ID ) {

		SendClientMessage(playerid, COLOR_RED, "Failed to create police object - either all slots are filled or the server failed to set it up.");
		return true ;
	}

	PoliceObjects [ pdobj_enum_id ] [ E_PD_OBJ_ID ] = pdobj_enum_id ; 

	PoliceObjects [ pdobj_enum_id ] [ E_PD_OBJ_PLACEDBY ] [ 0 ] = EOS ;
	format ( PoliceObjects [ pdobj_enum_id ] [ E_PD_OBJ_PLACEDBY ], MAX_PLAYER_NAME + 32, "%s (acc ID: %d, char ID: %d)", 
		ReturnPlayerNameData(playerid), Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], Character [ playerid ] [ E_CHARACTER_ID ] 
	) ;

	new Float: x, Float: y, Float: z;

	GetPlayerPos ( playerid, x, y, z ) ;
	GetXYInFrontOfPlayer ( playerid, x, y, 2.0 );

	PoliceObjects [ pdobj_enum_id ] [ E_PD_OBJ_OBJECTID ] = CreateDynamicObject(modelid, 
		x, y, z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)
	) ;

	PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = true ;
	EditDynamicObject(playerid, PoliceObjects [ pdobj_enum_id ] [ E_PD_OBJ_OBJECTID ] ) ;

	return true ;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] ) {

		new pd_obj_enum_id = INVALID_PDOBJ_ID;

		for_loop ( new i, j = sizeof ( PoliceObjects ); i < j ; i ++ ) {

			if ( PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ] == objectid ) {

				pd_obj_enum_id = i ;
			}

			else continue ;
		}

		if ( pd_obj_enum_id == INVALID_PDOBJ_ID ) {

			SendClientMessage(playerid, -1, "Object is invalid - removing.");
			PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = false ;
			SOLS_DestroyObject(PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ], "Police/OnEditObject INVALID_PD_OBJ", true ) ;
			PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ] = INVALID_OBJECT_ID ;
		}

		else {

			if ( PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ] == objectid ) {

				SendClientMessage(playerid, -1, "Passed");
				if ( ! Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
					PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = false ;
					SOLS_DestroyObject(PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ], "Police/OnEditObject Not In Faction", true ) ;
					PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ] = INVALID_OBJECT_ID  ;

					return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
				}

				else {

					if ( response == EDIT_RESPONSE_CANCEL ) {

						new faction_enum_id = Faction_GetEnumID ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) ;

						Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has deleted faction object ID %d with index %d. }",

							Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid ), objectid, PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_ID ]
						), faction_enum_id, false ) ;

						SOLS_DestroyObject(PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ], "Police/OnEditObject CANCEL", true ) ;
						PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ] = INVALID_PDOBJ_ID ;
						PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = false ;
					}

					else if ( response == EDIT_RESPONSE_FINAL ) {

						SetDynamicObjectPos(PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ], x, y, z);
						SOLS_SetObjectRot(PoliceObjects [ pd_obj_enum_id ] [ E_PD_OBJ_OBJECTID ], rx, ry, rz, "Police/EditDynamicObject FINAL", true) ;

						PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = false ;
						new faction_enum_id = Faction_GetEnumID ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) ;

						Faction_SendMessage(Character [ playerid ] [ E_CHARACTER_FACTIONID ], sprintf("{ [%s] %s has placed a faction object at their location (model %d) }",

							Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid ), GetDynamicObjectModel ( objectid )
						), faction_enum_id, false ) ;
					}
				}
			}
		}
	}

	#if defined pdobj_OnPlayerEditDynamicObject
		return pdobj_OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditDynamicObject
	#undef OnPlayerEditDynamicObject
#else
	#define _ALS_OnPlayerEditDynamicObject
#endif

#define OnPlayerEditDynamicObject pdobj_OnPlayerEditDynamicObject
#if defined pdobj_OnPlayerEditDynamicObject
	forward pdobj_OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif

CMD:fobjnear(playerid, params[]) {

	return cmd_factionobjectnear(playerid, params);
}
CMD:factionobjectnear(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}
	
	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}


	new nearestid = PoliceObject_GetClosestEntity(playerid)  ;

	if ( nearestid == INVALID_PDOBJ_ID ) {

  		return SendServerMessage ( playerid, COLOR_ERROR, "Faction Object", "A3A3A3", "You're not near an object!" ) ;
	}

	SendClientMessage(playerid, COLOR_BLUE, "[Nearest Faction Object]:");
	SendClientMessage(playerid, 0xDEDEDEFF, sprintf("ID: %d - Model ID: %d - Placed By: %s",
		PoliceObjects [ nearestid ] [ E_PD_OBJ_ID ], GetDynamicObjectModel (PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ]), 
		PoliceObjects [ nearestid ] [ E_PD_OBJ_PLACEDBY ] )
	) ;

	return true ;
}

CMD:factionobjectedit(playerid, params[]) {

	return cmd_fobjedit(playerid, params);
}
CMD:fobjedit(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}

	new id, Float: radius ;

	if ( sscanf ( params, "iF(2.5)", id, radius)) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/fobjedit [id] [optional: radius]");
	}

	new nearestid = PoliceObject_GetClosestEntity(playerid, radius)  ;

	if ( nearestid == INVALID_PDOBJ_ID ) {

  		return SendServerMessage ( playerid, COLOR_ERROR, "Faction Object", "A3A3A3", "You're not near the object you want to move. Move near it's center!" ) ;
	}

	if ( PoliceObjects [ nearestid ] [ E_PD_OBJ_ID ] != id ) {

  		return SendServerMessage ( playerid, COLOR_ERROR, "Faction Object", "A3A3A3", "You either entered an invalid ID or not near the object you want to move. Move near it's center!" ) ;
	}

	if ( ! IsValidDynamicObject(PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ] ) ) {

  		return SendServerMessage ( playerid, COLOR_ERROR, "Faction Object", "A3A3A3", "For some reason this object ID is invalid. Tell a faction owner to do /factionclearobjects." ) ;
	}

	PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_PDOBJ ] = true ;
	EditDynamicObject(playerid, PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ] ) ;

	Faction_SendMessage(factionid, sprintf("{ [%s] %s is editing faction object ID %d with model %d. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid ), PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ], GetDynamicObjectModel ( PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ] )
	), faction_enum_id, false ) ;

	return true ;
}

CMD:factionobjectdel(playerid, params[]) {

	return cmd_fobjdel(playerid, params);
}
CMD:fobjdel(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}

	return SendServerMessage ( playerid, COLOR_BLUE, "Faction Object", "A3A3A3", "To delete an object, use /fobjedit and press ESC." ) ;
}

CMD:fobjclear(playerid, params[]) {

	return cmd_factionobjectclear(playerid, params);
}
CMD:factionobjectclear(playerid, params[]) {
	// Clears all faction objects

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}
	
	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	for_loop ( new i, j = sizeof ( PoliceObjects ); i < j ; i ++ ) {

		if ( PoliceObjects [ i ] [ E_PD_OBJ_ID ] == INVALID_PDOBJ_ID ) {

			continue ;
		}

		PoliceObjects [ i ] [ E_PD_OBJ_ID ] = INVALID_PDOBJ_ID ;

		if ( IsValidDynamicObject( PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ] ) ) {

			SOLS_DestroyObject( PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], "Police/OnFactionObjectClear", true ) ;
		}
	}

	Faction_SendMessage(factionid, sprintf("{ [%s] %s has removed all faction objects. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
	), faction_enum_id, false ) ;

	return true ;
}

PoliceObject_GetClosestEntity(playerid, Float: radius = 2.5) {

	new vw, int, Float: x, Float: y, Float: z ;

	for_loop(new i, j = sizeof ( PoliceObjects ); i < j ; i ++ ) {

		if ( PoliceObjects [ i ] [ E_PD_OBJ_ID ] == INVALID_PDOBJ_ID ) {

			continue ;
		}

		if ( IsValidDynamicObject( PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ] ) ) {

			SOLS_DestroyObject( PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], "Police/GetClosestEntity VALID CHECK", true ) ;
		}

		Streamer_GetFloatData(STREAMER_TYPE_OBJECT,  PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], E_STREAMER_X, x );
		Streamer_GetFloatData(STREAMER_TYPE_OBJECT,  PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], E_STREAMER_Y, y );
		Streamer_GetFloatData(STREAMER_TYPE_OBJECT,  PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], E_STREAMER_Z, z );

		int = Streamer_GetIntData(STREAMER_TYPE_OBJECT,  PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], E_STREAMER_INTERIOR_ID );
		vw = Streamer_GetIntData(STREAMER_TYPE_OBJECT,  PoliceObjects [ i ] [ E_PD_OBJ_OBJECTID ], E_STREAMER_WORLD_ID );

		if ( IsPlayerInRangeOfPoint(playerid, radius, x, y, z) && GetPlayerVirtualWorld(playerid) == vw && GetPlayerInterior(playerid) == int ) {

			return i ;
		}

		else continue ;
	}

	return INVALID_PDOBJ_ID ;
}
