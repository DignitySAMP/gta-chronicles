#define COLOR_IMPOUND	0x1F85DEFF
#define IMPOUND_FEE 2500

#define IMPOUND_X 1088.3052
#define IMPOUND_Y -1748.8958
#define IMPOUND_Z 13.4066

Impound_LoadEntities() 
{
	CreateDynamicMapIcon(IMPOUND_X, IMPOUND_Y, IMPOUND_Z, 55, 0xFFFFFFFF);
	CreateDynamicPickup(1247, 1, IMPOUND_X, IMPOUND_Y, IMPOUND_Z);
	CreateDynamic3DTextLabel("[Impound Lot]{DEDEDE}\nAvailable Commands: /impound, /unimpound", COLOR_IMPOUND, IMPOUND_X, IMPOUND_Y, IMPOUND_Z, 10.0);

}

CMD:unimpound(playerid, params[]) 
{
	if ( !IsPlayerInRangeOfPoint(playerid, 30.0, IMPOUND_X, IMPOUND_Y, IMPOUND_Z) )
	{
		return SendServerMessage ( playerid, COLOR_IMPOUND, "Impound", "A3A3A3", "You must be at the Impound Lot, check /gps for directions." ) ;
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if ( veh_enum_id == -1 || Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] != E_VEHICLE_TYPE_PLAYER ) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You're not in a proper vehicle.");
	}

	if (!Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED])
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle isn't impounded!");
	}

	new bool:admin = false;

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) 
	{
		if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL)
		{
			return SendClientMessage(playerid, COLOR_ERROR, "You do not own this vehicle!");
		}
		
		admin = true;
	}

	if (!PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
	{
		if (Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_UNTIL] > gettime())
		{
			new year, month, day, hour, minute, second, date[64];
			//new seconds = Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_UNTIL] - gettime();
			stamp2datetime(Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_UNTIL], year, month, day, hour, minute, second, 1);
			format(date, sizeof(date), "%02d/%02d/%04d - %02d:%02d:%02d", day, month, year, hour, minute, second) ;

			return SendServerMessage(playerid, COLOR_IMPOUND, "Impound", "A3A3A3", sprintf("You can't unimpound this vehicle until %s.", date));
		}

		if (Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST] && Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST] > GetPlayerCash(playerid))
		{
			return SendServerMessage(playerid, COLOR_IMPOUND, "Impound", "A3A3A3", sprintf("You need $%s to pay the impound fee for this vehicle.", IntegerWithDelimiter(Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST])));
		}
	}

	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ] = 1154.5194 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] = -1726.2858 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] = 13.8784 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ] = 189.2765 ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED] = 0;

	//SetVehiclePos(vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ]);
	//SetVehicleZAngle(vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ]);

	if (admin || PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
	{
		SendClientMessage(playerid, COLOR_INFO, sprintf("You've unimpounded a (%d) %s using your admin powers.", vehicleid, ReturnVehicleName(vehicleid)));
	}
	else
	{
		if (Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST])
		{
			TakePlayerCash(playerid, Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST]);
			Faction_AddBankMoneyPerType(0, Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST]);
		}

		SendClientMessage(playerid, COLOR_INFO, sprintf("You've unimpounded your %s for $%s.", ReturnVehicleName(vehicleid), IntegerWithDelimiter(Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST])));
		SendClientMessage(playerid, COLOR_YELLOW, "You can now use the vehicle again, remember to re-park it or it will spawn at the impound.");
	}

	new query [ 256 ] ; 

	mysql_format(mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_pos_x = '%f', vehicle_pos_y = '%f', vehicle_pos_z = '%f', vehicle_pos_a = '%f', vehicle_impounded = '%d' WHERE vehicle_sqlid = %d",
		Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], 
		Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], 
		Vehicle [veh_enum_id] [E_VEHICLE_IMPOUNDED], Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID] 
	) ;

	mysql_tquery(mysql, query);

	// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Unimpounded a %s (VID: %d, SQL: %d)", ReturnVehicleName(vehicleid), vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID]));

	return true ;
}

CMD:impound(playerid, params[]) 
{

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (!IsPlayerInTicketFaction(playerid, true) && !IsPlayerInDEAFaction(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty in a faction that can impound vehicles." ) ;
	}

	new vehicleid = 0, cost = 0, time = 0, reason[64];
	new bool:ispolice = IsPlayerInDEAFaction(playerid) || IsPlayerInPoliceFaction(playerid);

	if (ispolice)
	{
		if (sscanf(params, "ddds[64]", vehicleid, time, cost, reason) || !vehicleid)
		{
			SendServerMessage(playerid, COLOR_RED, "Usage", "DEDEDE", "/impound [vehicle id] [hours] [cost] [reason]");
			return SendServerMessage(playerid, COLOR_RED, "Usage", "DEDEDE", "Vehicle ID from /dl, hours is in addition to impound cost.");
		}
	}
	else
	{
		if (sscanf(params, "dds[64]", vehicleid, cost, reason) || !vehicleid)
		{
			SendServerMessage(playerid, COLOR_RED, "Usage", "DEDEDE", "/impound [vehicle id] [cost] [reason]");
			return SendServerMessage(playerid, COLOR_RED, "Usage", "DEDEDE", "Hint: get the Vehicle ID from /dl.");
		}
	}

	if (!strlen(reason) || strlen(reason) >= 64 || IsNumeric(reason))
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "You must enter an impound reason (max 64 chars).");
	}

	if (time > 24 && Character[playerid][E_CHARACTER_FACTIONTIER] > 2)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "You must be Tier 2 or higher to impound for more than 24 hours.");
	}

	if (time && !ispolice)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "Only the police can impound vehicles for hours.");
	}

	if (time < 0 || time > 336)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "The time must be between 0 and 336 hours (2 weeks)");
	}

	if (cost > 1000 && !ispolice)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "Only the police can impound a vehicle for more than $1,000");
	} 

	if (cost < 0 || cost > 10000)
	{
		return SendServerMessage(playerid, COLOR_RED, "Error", "DEDEDE", "The impound fee must be between $0 (free) and $10,000");
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if ( veh_enum_id == -1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "You're entered an invalid vehicle ID.");
	}

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] != E_VEHICLE_TYPE_PLAYER ) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You can only impound player owned vehicles!");
	}

	if ( !IsPlayerInRangeOfPoint(playerid, 30.0, IMPOUND_X, IMPOUND_Y, IMPOUND_Z ) ) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You can only do this at the impound lot.");
	}

	if (Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED])
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle is already impounded.");
	}

	if (!IsVehicleInRangeOfPoint(vehicleid, 30.0, IMPOUND_X, IMPOUND_Y, IMPOUND_Z ) ) 
	{
		return SendClientMessage(playerid, COLOR_ERROR, "This vehicle isn't close enough to the impound lot.");
	}

	new Float: x, Float: y, Float: z, Float: a  ;

	GetVehiclePos(vehicleid, x, y, z );
	GetVehicleZAngle(vehicleid, a ) ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ] = x ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ] = y ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ] = z ;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ] = a ;

	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED] = 1;
	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED_UNTIL] = gettime() + (time * 3600);
	Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUND_COST] = cost;
	format(Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUND_REASON ], 64, "%s", reason);
	format(Vehicle [ veh_enum_id ] [ E_VEHICLE_IMPOUNDED_BY ], 64, "%s", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));

	SetDoorStatus ( vehicleid, true );
	SetEngineStatus(vehicleid, false);

	JT_RemovePlayerFromVehicle(playerid);

	new query [ 512 ] ; 

	mysql_format(mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_pos_x = '%f', vehicle_pos_y = '%f', vehicle_pos_z = '%f', vehicle_pos_a = '%f', vehicle_impounded = %d, vehicle_impounded_until = FROM_UNIXTIME(%d), vehicle_impound_cost = %d, vehicle_impound_reason = '%e', vehicle_impounded_by = '%e' WHERE vehicle_sqlid = %d",
		Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_X ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Y ], 
		Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_Z ], Vehicle [ veh_enum_id ] [ E_VEHICLE_POS_A ], 
		Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED], Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_UNTIL], Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_COST], Vehicle[veh_enum_id][E_VEHICLE_IMPOUND_REASON], Vehicle[veh_enum_id][E_VEHICLE_IMPOUNDED_BY],
		Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID] 
	) ;

	mysql_tquery(mysql, query);

	// NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Impounded a %s (VID: %d, SQL: %d) for $%s", ReturnVehicleName(vehicleid), vehicleid, Vehicle [ veh_enum_id ] [ E_VEHICLE_SQLID], IntegerWithDelimiter(cost)));
	new msg[144];

	if (time) format(msg, sizeof(msg), "%d hours and $%s", time, IntegerWithDelimiter(cost));
	else format(msg, sizeof(msg), "$%s for \"%s\"", IntegerWithDelimiter(cost), reason);

	format(msg, sizeof(msg), "{ [%s] (%d) %s impounded a %s (%s) for %s. }", Faction_GetAbbreviationByID(faction_enum_id), playerid, SOLS_PlayerName(playerid), ReturnVehicleName(vehicleid), Vehicle[veh_enum_id][E_VEHICLE_LICENSE], msg);
	Faction_SendMessage(factionid, msg, faction_enum_id, false, false, 0, true);

	SendClientMessage(playerid, COLOR_YELLOW, "You've impounded the vehicle, turned off the engine and locked it for safety.");

	foreach(new targetid: Player) 
	{
		if ( IsPlayerConnected(targetid) && IsPlayerSpawned ( targetid ) ) 
		{
			if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] == Character [ targetid ] [ E_CHARACTER_ID ] ) 
			{
				if (time) SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your %s (%s) was impounded for %d hours and $%s by %s.", ReturnVehicleName(vehicleid), Vehicle[veh_enum_id][E_VEHICLE_LICENSE], time, IntegerWithDelimiter(cost), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)));
				else SendClientMessage(targetid, COLOR_YELLOW, sprintf("Your %s (%s) was impounded for $%s by %s.", ReturnVehicleName(vehicleid), Vehicle[veh_enum_id][E_VEHICLE_LICENSE], IntegerWithDelimiter(cost), SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER)));
				SendClientMessage(targetid, COLOR_YELLOW, "You can retrieve your vehicle at the Impound Lot by typing \"/unimpound\".");
			}
		}
	}

	return true ;
}