// All functions that have to be included "last".

GetPlayerPropertyCount(playerid)
{
	new properties = 0;

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) 
	{
		if (Property[i][E_PROPERTY_ID] == INVALID_PROPERTY_ID) continue;
		if (Property[i][E_PROPERTY_OWNER] == Character[playerid][E_CHARACTER_ID] || Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[i][E_PROPERTY_ID])
		{
			properties ++;
		}
	}

	return properties;
}

static Spawn_LastPosition(playerid, bool:isrespawn)
{
	if ( ! Character [ playerid ] [ E_CHARACTER_LAST_POS_X ] || ! Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ] || !  Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ] ) {

		SendClientMessage(playerid, -1, "Can't find previous location, try a different spawn!");

		Player_LastSpawnPage [ playerid ] = 1 ;
		return SpawnArea_Selection(playerid) ;
	}

	new property_enum_id = INVALID_PROPERTY_ID;
	if (Character [ playerid ] [ E_CHARACTER_LAST_POS_VW ] > 0)
	{
		// Find out which property (if any) they are in
		property_enum_id = Property_GetInsideAtCoords(Character [ playerid ] [ E_CHARACTER_LAST_POS_X ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ], Character [ playerid ] [ E_CHARACTER_LAST_POS_VW ], Character [ playerid ] [ E_CHARACTER_LAST_POS_INT ]);
	}			

	if (!isrespawn)
	{
		SetSpawnInfo(playerid, 0, Character [ playerid ] [ E_CHARACTER_SKINID ], Character [ playerid ] [ E_CHARACTER_LAST_POS_X ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ], Character [ playerid ] [ E_CHARACTER_LAST_POS_A ], 0, 0, 0, 0, 0, 0);
		CS_SpawnPlayer(playerid) ;

		if (property_enum_id != INVALID_PROPERTY_ID)
		{
			Property_LoadFurniture(property_enum_id);
		}

		//SetPlayerSkin ( playerid, Character [ playerid ] [ E_CHARACTER_SKINID ] ) ;
	}

	SetPlayerInterior ( playerid, Character [ playerid ] [ E_CHARACTER_LAST_POS_INT ] ) ;
	SetPlayerVirtualWorld ( playerid, Character [ playerid ] [ E_CHARACTER_LAST_POS_VW ] ) ;

	if (property_enum_id != INVALID_PROPERTY_ID)
	{
		SOLS_SyncTimeAndWeather(playerid, property_enum_id);
		PropertyAudio_Sync(playerid, property_enum_id);

		SOLS_SetPosWithFade ( playerid,  Character [ playerid ] [ E_CHARACTER_LAST_POS_X ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ], ReturnPropEnterText(property_enum_id, false));
	}
	else
	{
		SOLS_SetPosWithFade ( playerid,  Character [ playerid ] [ E_CHARACTER_LAST_POS_X ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ], Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ]);
	}

	SetCameraBehindPlayer(playerid);

	
	// Must call this
	// Spawn_Common(playerid, isrespawn);
	return true;
}

static Spawn_Faction(playerid, bool:isrespawn=false)
{
	new faction_enum_id = INVALID_FACTION_ID;
	if (Character [ playerid ] [ E_CHARACTER_FACTIONID ])
	{
		faction_enum_id = Faction_GetEnumID(Character [ playerid ] [ E_CHARACTER_FACTIONID ] ); 
	}
	
	if (faction_enum_id != INVALID_FACTION_ID) 
	{
		if (!isrespawn)
		{
			SetSpawnInfo(playerid, 0, Character [ playerid ] [ E_CHARACTER_SKINID ], Faction [ faction_enum_id ] [ E_FACTION_SPAWN_X ], 
				Faction [ faction_enum_id ] [ E_FACTION_SPAWN_Y ], Faction [ faction_enum_id ] [ E_FACTION_SPAWN_Z ], Faction [ faction_enum_id ] [ E_FACTION_SPAWN_A ], 0, 0, 0, 0, 0, 0);
			CS_SpawnPlayer(playerid) ;
			//SetPlayerSkin ( playerid, Character [ playerid ] [ E_CHARACTER_SKINID ] ) ;
		}

		SetPlayerInterior ( playerid, Faction [ faction_enum_id ] [ E_FACTION_SPAWN_INT ] );
		SetPlayerVirtualWorld ( playerid, Faction [ faction_enum_id ] [ E_FACTION_SPAWN_VW ] );
		SOLS_SetPosWithFade(playerid, Faction [ faction_enum_id ] [ E_FACTION_SPAWN_X ], Faction [ faction_enum_id ] [ E_FACTION_SPAWN_Y ], Faction [ faction_enum_id ] [ E_FACTION_SPAWN_Z ], Faction [ faction_enum_id ] [ E_FACTION_NAME ]);
		SetCameraBehindPlayer(playerid);

		// Must call this
		// Spawn_Common(playerid, isrespawn);
	}
	else 
	{
		Player_LastSpawnPage [ playerid ] = 1 ;
		SendClientMessage(playerid, COLOR_ERROR, "You're not in a faction. Pick a different spawn.");
		SpawnArea_Selection(playerid) ;
	}

	return true;
}

Spawn_Newbie(playerid, bool:isrespawn)
{
	Player_LastSpawnPage [ playerid ] = 1 ;

	if (isrespawn)
	{
		SpawnArea_SelectionEx(playerid);
		return true;
	}

	SpawnArea_Selection(playerid);
	return true;
}

static PropertyDlgStr[4096];

static Spawn_Properties(playerid, bool:isrespawn=false)
{
	// Make a list of properties to spawn at
	new address[64], zone[64], count = 0, map[50];
	format(PropertyDlgStr, sizeof(PropertyDlgStr), "Type\tAddress");

	for_loop ( new i, j = sizeof ( Property ); i < j && count < sizeof ( map ) ; i ++ )
	{
		if (Property[i][E_PROPERTY_ID] == INVALID_PROPERTY_ID) continue;
		if (Property[i][E_PROPERTY_OWNER] == Character[playerid][E_CHARACTER_ID] || Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[i][E_PROPERTY_ID]) 
		{
			address[0] = EOS, zone[0] = EOS;
			GetCoords2DZone(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], zone, sizeof ( zone ));
			GetPlayerAddress(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], address );

			if (Property[i][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_BIZ) format(PropertyDlgStr, sizeof(PropertyDlgStr), "%s\n{4FC3F7}Business\t%s", PropertyDlgStr, ReturnPropEnterText(i, false));
			else if (Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[i][E_PROPERTY_ID]) format(PropertyDlgStr, sizeof(PropertyDlgStr), "%s\n{DCE775}Residence\t%d %s, %s", PropertyDlgStr, i, address, zone);
			else if (Property[i][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_HOUSE) format(PropertyDlgStr, sizeof(PropertyDlgStr), "%s\n{AED581}Residence\t%d %s, %s", PropertyDlgStr, i, address, zone);
			else format(PropertyDlgStr, sizeof(PropertyDlgStr), "%s\nStatic\t%d %s, %s (SQL: %d)", PropertyDlgStr, i, address, zone, Property[i][E_PROPERTY_ID]);
			
			map[count] = i;
			count ++;
		}
	}

	if (count == 0)
	{
		// Something went badly wrong
		Player_LastSpawnPage [ playerid ] = 1 ;
		SendClientMessage(playerid, COLOR_ERROR, "You don't have any properties. Pick a different spawn.");
		SpawnArea_Selection(playerid);
		return true;
	}

	inline DlgPropertySpawn(pid, dialogid, response, listitem, string:inputtext[]) 
	{ 
		#pragma unused pid, dialogid, response, listitem, inputtext

		if (!response) 
		{
			// Take them back to the main list
			return Player_DisplaySpawnList(pid, isrespawn);
		}

		new chosen = map[listitem];
		Spawn_Property(playerid, chosen, isrespawn);
		return true;
	}

	Dialog_ShowCallback ( playerid, using inline DlgPropertySpawn, DIALOG_STYLE_TABLIST_HEADERS, "Spawn Property", PropertyDlgStr, "Select", "Back" ) ;
	return true;
}

static Spawn_Property(playerid, property_enum_id, bool:isrespawn=false)
{
	// new property_enum_id = Property_LinkSQLToEnum(Character [ playerid ] [ E_CHARACTER_PROPERTYSPAWN ]) ;

	if ( property_enum_id == -1 ) 
	{
		SendClientMessage(playerid, -1, "You haven't set which property you'd like to spawn at. Please choose a different spawn!");

		Player_LastSpawnPage [ playerid ] = 1 ;
		return SpawnArea_Selection(playerid) ;
	}

	// NEW: load furni if needed
	Property_LoadFurniture(property_enum_id);

	if (!isrespawn)
	{
		SetSpawnInfo(playerid, 0, Character [ playerid ] [ E_CHARACTER_SKINID ], Property [ property_enum_id ] [ E_PROPERTY_INT_X ],  Property [ property_enum_id ] [ E_PROPERTY_INT_Y ], Property [ property_enum_id ] [ E_PROPERTY_INT_Z ], Character [ playerid ] [ E_CHARACTER_LAST_POS_A ], 0, 0, 0, 0, 0, 0);
		CS_SpawnPlayer(playerid) ;
		//SetPlayerSkin(playerid, Character [ playerid ] [ E_CHARACTER_SKINID ]);
	}

	SetCameraBehindPlayer(playerid);
	SetPlayerInterior ( playerid, Property [ property_enum_id ] [ E_PROPERTY_INT_INT ] ) ;
	SetPlayerVirtualWorld ( playerid, Property [ property_enum_id ] [ E_PROPERTY_INT_VW ] ) ;
	SOLS_SetPosWithFade (playerid, Property [ property_enum_id ] [ E_PROPERTY_INT_X ],  Property [ property_enum_id ] [ E_PROPERTY_INT_Y ], Property [ property_enum_id ] [ E_PROPERTY_INT_Z ], ReturnPropEnterText(property_enum_id));

	SOLS_SyncTimeAndWeather(playerid, property_enum_id);
	PropertyAudio_Sync(playerid, property_enum_id);
	
	//SendClientMessage(playerid, -1, "You've spawned inside the selected property!");
	// Streamer_Update(playerid, STREAMER_TYPE_PICKUP);

	// Must call this
	// Spawn_Common(playerid, isrespawn);
		
	return true;
}

PlayerSpawnSelection(playerid, listitem, bool:isrespawn=false ) 
{
	if ( !Character [ playerid ] [ E_CHARACTER_GYM_SETUP ] ) 
	{
		Gym_SetupDefaultVariables(playerid);
	}
	
	// So basically, they can spawn at:
	// 0. Last Location
	// 1. Faction Spawn
	// 2. Property Spawns
	// 3. Newcomer Spawns

	// But, if they are arrested/ajailed we override the spawn selection regardless.

	if (Character [ playerid ] [ E_CHARACTER_AJAIL_TIME ])
	{
		Spawn_AdminJail(playerid, isrespawn);
		return true;
	}

	if ( Character [ playerid ] [ E_CHARACTER_ARREST_TIME ]) 
	{
		Spawn_ArrestJail(playerid, isrespawn);
		return true;
	}

	if (listitem < 0 || listitem >= sizeof ( PlayerSpawnOptions[] )) return true ;

	new option = PlayerSpawnOptions[playerid][listitem];

	if (option == PLAYER_SPAWN_TYPE_LAST) Spawn_LastPosition(playerid,isrespawn);
	else if (option == PLAYER_SPAWN_TYPE_FACTION) Spawn_Faction(playerid,isrespawn);
	else if (option == PLAYER_SPAWN_TYPE_PROPERTY) Spawn_Properties(playerid,isrespawn);
	else
	{
		Spawn_Newbie(playerid, isrespawn);
	} 

	if ( ! Character [ playerid ] [ E_CHARACTER_TUTORIAL ] ) 
	{
		SendServerMessage ( playerid, COLOR_SERVER, "Server", "DEDEDE", "You've not finished the tutorial yet! You can view it by doing /tutorial.");
	}

	return true ;
}


IsPlayerSpawned(playerid) {

	switch (GetPlayerState(playerid)) {
		case PLAYER_STATE_ONFOOT .. PLAYER_STATE_PASSENGER,
		     PLAYER_STATE_SPAWNED: {
			return true;
		}
	}

	return false;
}


SOLS_SetObjectRot(objectid, Float: x, Float: y, Float: z, reason[], streamer) {
	#pragma unused reason

	/*
	if ( streamer ) {

		printf("SetDynamicObjectRot: [%s] Rotated object ID %d with model %d to x %0.2f, y %0.2f, z, %0.2f. Reason: %s",
			reason, objectid, GetDynamicObjectModel(objectid), x, y, z, reason ) ;

		SetDynamicObjectRot(objectid, x, y, z);
	}

	else if ( ! streamer ) {

		printf("SetObjectRot: [%s] Rotated object ID %d with model %d to x %0.2f, y %0.2f, z, %0.2f. Reason: %s",
			reason, objectid, GetObjectModel(objectid), x, y, z, reason ) ;

		SetObjectRot(objectid, x, y, z);	
	}*/

	if ( streamer ) {

		if ( IsValidDynamicObject(objectid) ) {

			SetDynamicObjectRot(objectid, x, y, z);
		}
	}

	else {

		SetObjectRot(objectid, x, y, z);
	}
}



SOLS_DestroyObject(objectid, reason[], streamer, warn=false) {

	if ( streamer ) {
		if(warn) {
			printf("DestroyDynamicObject: [%s] Destroyed object ID %d with model %d, reason %s", 
				reason, objectid, GetDynamicObjectModel(objectid), reason);
		}

		if ( IsValidDynamicObject(objectid) ) {
			DestroyDynamicObject(objectid);
		}
	}

	else if ( ! streamer ) {
		if(warn) {
			printf("DestroyObject: [%s] Destroyed object ID %d with model %d, reason %s", 
				reason, objectid, GetObjectModel(objectid), reason);
		}
		DestroyObject(objectid);
	}
}

// You need to call this with a SAMP gunid.
SOLS_SetPlayerAmmo(playerid, gunid, amount) {

	new slot = GetWeaponSlot ( gunid ) ;

	PlayerVar [ playerid ] [ E_PLAYER_AMMO_SYNCED ] [ slot ] =  amount ;

	return SetPlayerAmmo(playerid, gunid, amount);
}

SOLS_GetPlayerAmmo(playerid) {

	new ammo = PlayerVar [ playerid ] [ E_PLAYER_AMMO_SYNCED ] [ GetWeaponSlot ( GetPlayerWeapon ( playerid ) ) ] ;

	if ( ammo == 0 ) {

		ammo = GetPlayerAmmo(playerid);
	}

	return ammo ;
	//return GetPlayerAmmo(playerid);
}

SOLS_SetPlayerPos(playerid, Float: x, Float: y, Float: z, freeze=true ) {

    BlackScreen(playerid);

	new vw = GetPlayerVirtualWorld(playerid);
	new int = GetPlayerInterior(playerid);

	Streamer_UpdateEx(playerid, x, y, z, vw, int, STREAMER_TYPE_OBJECT);
	SetPlayerPos(playerid, x, y, z);
	//Streamer_UpdateEx(playerid, x, y, z, vw, int, STREAMER_TYPE_OBJECT);

	FadeIn ( playerid, freeze );	
	Boombox_SyncForPlayer( playerid ) ;

	// defer DoStreamerUpdate(playerid, x, y, z, vw, int);

	return true ;
}

timer DoStreamerUpdate[250](playerid, Float:x, Float:y, Float:z, vw, int)
{	
	Streamer_UpdateEx(playerid, x, y, z, vw, int, STREAMER_TYPE_OBJECT);
}

SOLS_SetVehiclePos(playerid, vehicleid, Float: x, Float: y, Float: z ) {

	if ( GetPlayerVehicleID ( playerid ) == vehicleid && GetPlayerVehicleSeat(playerid) == 0 ) {

		BlackScreen(playerid);

		SetVehiclePos(vehicleid, x, y, z ) ;
		JT_PutPlayerInVehicle(playerid, vehicleid, 0);

		new vw = GetPlayerVirtualWorld(playerid);
		new int = GetPlayerInterior(playerid);

		Streamer_UpdateEx(playerid, x, y, z, vw, int, STREAMER_TYPE_OBJECT);

		FadeIn ( playerid );
	}
}

IsPlayerListeningToAudioStream(playerid) {

	if ( ! IsPlayerSpawned ( playerid ) || ! IsPlayerLogged ( playerid ) ) {

		return true ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_AUDIO_STREAM ] ) {

		return true ;
	}

	else return false ;
}

SOLS_PlayAudioStreamForPlayer ( playerid, url [], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0 ) {

	if ( IsPlayerListeningToAudioStream(playerid) ) {

		SOLS_StopAudioStreamForPlayer(playerid);
	}

	PlayerVar [ playerid ] [ E_PLAYER_AUDIO_STREAM ] = true ;

	PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos ) ;
}

SOLS_StopAudioStreamForPlayer ( playerid ) {

	PlayerVar [ playerid ] [ E_PLAYER_AUDIO_STREAM ] = false ;
	StopAudioStreamForPlayer(playerid);
}


SOLS_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0) 
{
    new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);

	if (vehicleid <= 0 || vehicleid >= MAX_VEHICLES)
	{
		printf("VEH ERROR: SOLS_CreateVehicle with type %d, got back an invalid Vehicle ID (%d)",vehicletype, vehicleid);
		return INVALID_VEHICLE_ID;
	}

	Vehicle_ResetSlot(vehicleid);
	RemoveVehicleTurnSignals(vehicleid, EI_TURN_SIGNAL_BOTH);
	SOLS_SetVehicleHealth(vehicleid, 999);
	Gunrack_Reset(vehicleid);
	SOLS_ResetVehicleSirens(vehicleid);

    return vehicleid ;
}

SOLS_SetVehicleCanExplode(vehicleid, bool:explode) 
{
	VehicleVar[vehicleid][E_VEHICLE_CAN_EXPLODE] = explode;
}


SOLS_SetVehicleHealth(vehicleid, Float:health) {

	new Float: fixed_health = health;

	if ( health >= 999 ) {

		fixed_health = 999 ;
	}

	return SetVehicleHealth(vehicleid, fixed_health ) ;
}

stock SOLS_AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren=0) {

	new vid = AddStaticVehicleEx(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
	SetVehicleHealth(vid, 999);
	return vid;
}

stock SOLS_AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2) {
	new vid = AddStaticVehicle(vehicletype, x, y, z, rotation, color1, color2);
	SetVehicleHealth(vid, 999);
	return vid;
}


SOLS_RepairVehicle(vehicleid) {

	RepairVehicle(vehicleid);
	SOLS_SetVehicleHealth(vehicleid, 999);
	UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);

	return true ;
}