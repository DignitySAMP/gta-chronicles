#define SPIKE_MODEL 2899

/*
CMD:spike(playerid, params[]) {
    if ( ! PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty and can't do this." ) ;
    }
    
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

	return SendServerMessage ( playerid, COLOR_BLUE, "Faction Object", "A3A3A3", "To spawn spikes, use /fobj and select the first index. (/fobj -> ENTER to spawn instantly)" ) ;
}


Spike_Tick(playerid) {

	if ( IsPlayerInAnyVehicle(playerid) && GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) {

		new nearestid = PoliceObject_GetClosestEntity(playerid, 3.0)  ;

		if ( nearestid == INVALID_PDOBJ_ID ) {

	  		return true ;
		}

		if ( GetDynamicObjectModel ( PoliceObjects [ nearestid ] [ E_PD_OBJ_OBJECTID ]) == SPIKE_MODEL ) {
			static tires[4];

			GetVehicleDamageStatus(GetPlayerVehicleID(playerid), tires[0], tires[1], tires[2], tires[3]);

			if (tires[3] != 1111) {
			    UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), tires[0], tires[1], tires[2], 1111);
			}

			return true ;
		}
	}

	return true ;	
}
*/