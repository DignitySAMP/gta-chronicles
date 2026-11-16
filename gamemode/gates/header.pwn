#if !defined GATE_RESET_TIME
	#define GATE_RESET_TIME 15000 // ms
#endif

#if !defined SERVER_TOLL_FEE 
	#define SERVER_TOLL_FEE	( 150 )
#endif

#include "gates/data.pwn"
#include "gates/func.pwn"
#include "gates/cmds.pwn"
#include "gates/tolls.pwn"

// ############################################################# //

CMD:door(playerid, params[]) {

	return cmd_gate(playerid, params);
}

CMD:toll(playerid, params[]) {

	return cmd_gate(playerid, params);
}

PlayerUseGate(playerid, gate_enum_id, bool:feedback=true)
{
	if ( IsPlayerIncapacitated(playerid) ) 
	{
		if (feedback) SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
        return false;
    }

	if ( gate_enum_id == INVALID_GATE_ID ) 
	{
		if (feedback) SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Invalid gate enum ID." ) ;
		return false;
	}

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_GENERAL && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) 
	{
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("[GATE] Gate ID %d (SQL: %d). Type: %s. Owned by ID %d.",
			gate_enum_id,Gate [ gate_enum_id ] [ E_GATE_SQLID ], Gate_GetType(gate_enum_id), Gate [ gate_enum_id ] [ E_GATE_OWNER ] )) ;
	}

	if ( ! IsValidDynamicObject( Gate [ gate_enum_id ] [ E_GATE_OBJECTID] )) 
	{
		SendClientMessage(playerid, -1, "This gate isn't set up properly (no object)");
		return false;
	}

	if (IsDynamicObjectMoving(Gate [ gate_enum_id ] [ E_GATE_OBJECTID ]))
	{
		SendClientMessage(playerid, -1, "Wait for the gate to finish moving first.");
		return false;
	}

	// New gate access code by Spooks, supports properties now too.
	new bool:access = true;
	switch ( Gate [ gate_enum_id ] [ E_GATE_TYPE ] ) 
	{
		case E_GATE_TYPE_INVALID: return SendClientMessage(playerid, -1, "This gate isn't set up. Contact an admin.");
		case E_GATE_TYPE_PROPERTY:
		{
			if (!Gate[gate_enum_id][E_GATE_OWNER]) return SendClientMessage(playerid, -1, "This gate isn't assigned to a property. Contact an admin.");
			else access = Character[playerid][E_CHARACTER_RENTEDHOUSE] && Character[playerid][E_CHARACTER_RENTEDHOUSE] == Gate[gate_enum_id][E_GATE_OWNER];

			if (!access)
			{
				for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) 
				{
					if (Gate[gate_enum_id][E_GATE_OWNER] == Property[i][E_PROPERTY_ID])
					{
						access = Property[i][E_PROPERTY_OWNER] == Character[playerid][E_CHARACTER_ID];
						break;
					}
				}
			}
		} 
		case E_GATE_TYPE_PLAYER: access = Character[playerid][E_CHARACTER_ID] == Gate[gate_enum_id][E_GATE_OWNER];
		case E_GATE_TYPE_FACTION:
		{
			if (!Gate[gate_enum_id][E_GATE_OWNER]) return SendClientMessage(playerid, -1, "This gate isn't assigned to a faction. Contact an admin.");
			new faction_enum_id = Faction_GetEnumID(Gate[gate_enum_id][E_GATE_OWNER]);

			if (faction_enum_id == -1) return SendClientMessage(playerid, -1, "This gate isn't assigned to an invalid faction. Contact an admin.");

			if (Faction[faction_enum_id][E_FACTION_TYPE] == FACTION_TYPE_DEA)
			{
				// Allows FBI and DEA to share gates.
				access = bool:IsPlayerInDEAFaction(playerid);
			}
			else
			{
				access = Character[playerid][E_CHARACTER_FACTIONID] == Gate[gate_enum_id][E_GATE_OWNER];
			}

			if (access && GetPlayerFactionSuspension(playerid) != 0) access = false;
		}
	}

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to open this gate." );
		else if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR) return SendClientMessage(playerid, -1, "You don't have normal access to this gate, but can go on admin duty to open it.");
		else return SendClientMessage(playerid, -1, "You don't have access to this gate.");
	}	

	if ( Gate [ gate_enum_id ] [ E_GATE_TOLL ]) 
	{

		if ( ! IsPlayerInAnyVehicle(playerid)) {
			return SendClientMessage(playerid, COLOR_RED, "Trying to avoid the toll tax? Nice try! This command only works INSIDE a car!" ) ;
		}

		if ( GetPlayerCash ( playerid) < SERVER_TOLL_FEE ) {

			SendClientMessage(playerid, COLOR_RED, sprintf("You need at least $%s to operate the tolls.", IntegerWithDelimiter(SERVER_TOLL_FEE ) ) ) ;
			return true ;
		}

		if ( Server [ E_SERVER_TOLLS_LOCKED ] ) {

			return SendClientMessage(playerid, -1, "The tolls are currently closed by the LSPD. If they remain closed after extended duration, call 311 or an admin.");
		}

		if  (  Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {

			return SendClientMessage(playerid, COLOR_RED, "This toll gate is already opened!" ) ;
		}

		new toll_fee = GetMaxStorageModel(GetVehicleModel( GetPlayerVehicleID(playerid) )) * 10;

		if ( GetPlayerCash ( playerid) < toll_fee ) {

			SendClientMessage(playerid, COLOR_RED, sprintf("You need at least $%s to operate the tolls.", IntegerWithDelimiter(toll_fee ) ) ) ;
			return true ;
		}

		TakePlayerCash ( playerid, toll_fee ) ;

		if  ( ! Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {
			SendClientMessage(playerid, COLOR_INFO, sprintf("The toll gate will shut automatically after 15 seconds. You've been charged $%s transportation tax.", IntegerWithDelimiter(toll_fee )));
			defer Gate_ResetState(gate_enum_id);
		}
	}

	else if ( ! Gate [ gate_enum_id ] [ E_GATE_TOLL ]) {

		if ( Gate [ gate_enum_id ] [ E_GATE_AUTOCLOSE] ) {

			if  ( ! Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {
				SendClientMessage(playerid, COLOR_INFO, "The gate will shut automatically after 15 seconds. Don't get stuck!");
				defer Gate_ResetState(gate_enum_id);
			}
		}
	}


	new movetime ;

	if ( Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {

		movetime = MoveDynamicObject(Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_X ] + 0.001, Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Y ] + 0.001, 
			Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Z ], Gate [ gate_enum_id ] [ E_GATE_SPEED ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_X ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Y ], 
			Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Z ] ) ;

		if ( PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) {

			SendClientMessage(playerid, COLOR_YELLOW, sprintf("[GATE] Gate ID %d (SQL: %d) closed in %d milliseconds.", gate_enum_id,Gate [ gate_enum_id ] [ E_GATE_SQLID ],  movetime )) ;
		}

		Gate [ gate_enum_id ] [ E_GATE_STATE ] = false ;
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Closed Gate %d (SQL: %d)", gate_enum_id, Gate[gate_enum_id][E_GATE_SQLID]));
						
	}
	else if ( ! Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {

		if ( Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_X ] == 0.0 || Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Y ] == 0.0 || Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Z ] == 0.0 ) {

			return SendClientMessage(playerid, -1, "Gate open positions aren't set up. Get an admin to set them up before doing this command.");
		}
		
		movetime = MoveDynamicObject(Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_X ] + 0.001, Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Y ] + 0.001, 
			Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Z ], Gate [ gate_enum_id ] [ E_GATE_SPEED ], Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_X ], Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_Y ], 
			Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_Z ] ) ;


		if ( PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] ) {

			SendClientMessage(playerid, COLOR_YELLOW, sprintf("[GATE] Gate ID %d (SQL: %d) opened in %d milliseconds.", gate_enum_id,Gate [ gate_enum_id ] [ E_GATE_SQLID ],  movetime )) ;
		}

		Gate [ gate_enum_id ] [ E_GATE_STATE ] = true ;
		AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Opened Gate %d (SQL: %d)", gate_enum_id, Gate[gate_enum_id][E_GATE_SQLID]));
	}

	return true ;

}

CMD:gate(playerid, params[]) 
{
	if ( IsPlayerIncapacitated(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new gate_enum_id = Gate_GetClosestEntity(playerid);
	if (gate_enum_id == INVALID_GATE_ID) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near any gate." ) ;
	}

	PlayerUseGate(playerid, gate_enum_id, true);
	return true;
}


timer Gate_ResetState[GATE_RESET_TIME](gate_enum_id) {

	if ( Gate [ gate_enum_id ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return true ;
	}

	if ( Gate [ gate_enum_id ] [ E_GATE_STATE ] ) {

		//SetDynamicObjectPos( Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_X ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Y ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Z ] );
		//SOLS_SetObjectRot ( Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_X ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Y ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Z ], "Gate/ResetState", true) ; 
	
		MoveDynamicObject(Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_X ] + 0.001, Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Y ] + 0.001, 
		Gate [ gate_enum_id ] [ E_GATE_CLOSED_POS_Z ], Gate [ gate_enum_id ] [ E_GATE_SPEED ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_X ], Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Y ], 
		Gate [ gate_enum_id ] [ E_GATE_CLOSED_ROT_Z ] ) ;

		Gate [ gate_enum_id ] [ E_GATE_STATE ] = false ;
	}

	return true ;
}