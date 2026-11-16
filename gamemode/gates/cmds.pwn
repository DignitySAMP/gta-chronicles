IsGateAdmin(playerid)
{
	return GetPlayerAdminLevel(playerid) >= ADMIN_LVL_SENIOR || IsPropertyAdmin(playerid);
}

CheckGateAdmin(playerid)
{
	if (!IsGateAdmin(playerid))
	{
		SendServerMessage(playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You must be a Property Admin or Senior+ to use gate commands.");
		return false;
	}

	return true;
}

PrintGateAdminCmds(playerid)
{
	SendClientMessage(playerid, COLOR_PROPERTY, "[PROPERTY] /gategoto, /gatecreate, /gatedelete, /gatemove, /gateopen, /gateradius, /gatespeed, /gateautoclose, /gatetexture");
}

CMD:gatedelete(playerid, params[]) {

	new gateid ;

	if (!CheckGateAdmin(playerid)) return true;

	if ( sscanf ( params, "i", gateid ) ) {

		return SendClientMessage(playerid, -1, "/gatedelete [gateid]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "DELETE FROM gates WHERE gate_sqlid = %d", Gate [ gateid ] [ E_GATE_SQLID ] ) ;
	mysql_tquery(mysql, query );

	if ( IsValidDynamicObject( Gate [ gateid ] [ E_GATE_OBJECTID ] ) ) {

		SOLS_DestroyObject(Gate [ gateid ] [ E_GATE_OBJECTID ], "Gate/CMD_GateDelete", true ) ;
	}

	Gate [ gateid ] [ E_GATE_OBJECTID ] = INVALID_STREAMER_ID;

	SendClientMessage(playerid, -1, sprintf("You've deleted gate SQL ID %d.", Gate [ gateid ] [ E_GATE_SQLID ] ) ) ;
	
	Gate [ gateid ] [ E_GATE_SQLID ] = INVALID_GATE_ID ;

	Gate [ gateid ] [ E_GATE_CLOSED_POS_X ] = 0.0 ;
	Gate [ gateid ] [ E_GATE_CLOSED_POS_Y ] = 0.0 ;  
	Gate [ gateid ] [ E_GATE_CLOSED_POS_Z ] = 0.0 ;

	WriteLog ( playerid, "gates", sprintf("%s deleted gate SQL ID %d..",ReturnPlayerNameData(playerid),Gate [ gateid ] [ E_GATE_SQLID ] ) );

	return true ;
}

CMD:gatespeed(playerid, params[]) 
{
	if (!CheckGateAdmin(playerid)) return true;
	new gateid,Float: speed ;

	if ( sscanf ( params, "if", gateid, speed ) ) {

		return SendClientMessage(playerid, -1, "/gatespeed [gateid] [speed (in miliseconds, i.e. \"0.75\")]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_SPEED ] = speed ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gates SET gate_speed = '%f' WHERE gate_sqlid = %d",

		speed, Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query );

	SendClientMessage(playerid, -1, sprintf("Updated gate ID %d's speed to %.3f.", gateid, Gate [ gateid ] [ E_GATE_SPEED ] ) ) ;

	WriteLog ( playerid, "gates", sprintf("%s Updated gate ID %d's speed to %.3f.",ReturnPlayerNameData(playerid), gateid, Gate [ gateid ] [ E_GATE_SPEED ] ) );
	return true ;
}

CMD:gatecreate(playerid, params[]) 
{
	if (!CheckGateAdmin(playerid)) return true;
	
	new gate_enum_id = Gate_GetFreeID() ;

	if (  gate_enum_id == -1 ) {

		return print("* [GATE] No free enum IDs left - [Gate_CreateEntity] failed!!");
	}

	new modelid ;

	if ( sscanf ( params, "i", modelid ) ) {

		return SendClientMessage(playerid, -1, "/gatecreate [modelid]" ) ;
	}

	new Float: x, Float: y, Float: z ;
	GetPlayerPos(playerid, x, y, z ) ;

	GetXYInFrontOfPlayer(playerid, x, y, 2.5 );

	// We set a new gate ID so that multiple gates don't overlap creation.
	Gate [ gate_enum_id ] [ E_GATE_SQLID ] = GATE_SETUP_ID ;
	Gate [ gate_enum_id ] [ E_GATE_MODELID ] = modelid ;

	Gate [ gate_enum_id ] [ E_GATE_TYPE ] = E_GATE_TYPE_INVALID ;
	Gate [ gate_enum_id ] [ E_GATE_OWNER ] = -1 ;

	Gate [ gate_enum_id ] [ E_GATE_SETUP ] = 0 ;
	Gate [ gate_enum_id ] [ E_GATE_RADIUS ] = 2.5 ;

	Gate [ gate_enum_id ] [ E_GATE_STATE ] = false ;
	Gate [ gate_enum_id ] [ E_GATE_TOLL ] = 0 ;
	Gate [ gate_enum_id ] [ E_GATE_AUTOCLOSE ] = 0 ;
	Gate [ gate_enum_id ] [ E_GATE_SPEED ] = 0.0 ;

	Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_X ] = 0.0 ;
	Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Y ] = 0.0 ;
	Gate [ gate_enum_id ] [ E_GATE_OPEN_POS_Z ] = 0.0 ;

	Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_X ] = 0.0 ;
	Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_Y ] = 0.0 ;
	Gate [ gate_enum_id ] [ E_GATE_OPEN_ROT_Z ] = 0.0 ;

	for_loop ( new tex = 0; tex < 16; tex ++ ) {

		Gate [ gate_enum_id ] [ E_GATE_TEXTUREID ] [ tex ] = 0 ;
	}

	Gate [ gate_enum_id ] [ E_GATE_INTERIOR ] = GetPlayerInterior(playerid) ;
	Gate [ gate_enum_id ] [ E_GATE_VIRTUALWORLD ] = GetPlayerVirtualWorld(playerid) ;

	Gate [ gate_enum_id ] [ E_GATE_OBJECTID ] = CreateDynamicObject(modelid, 
		x, y, z, 0.0, 0.0, 0.0, Gate [ gate_enum_id ] [ E_GATE_VIRTUALWORLD ], Gate [ gate_enum_id ] [ E_GATE_INTERIOR ] );

	PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_GATE ] = true ;

	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], E_STREAMER_STREAM_DISTANCE, 500 );
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Gate [ gate_enum_id ] [ E_GATE_OBJECTID ], E_STREAMER_DRAW_DISTANCE, 500 );
	EditDynamicObject(playerid, Gate [ gate_enum_id ] [ E_GATE_OBJECTID ] ) ;


	return true ;
}

// Temp command for nich's sd gates
CMD:gatestyle(playerid, params[])
{
	if (!CheckGateAdmin(playerid)) return true;

	new gateid, style;

	if ( sscanf ( params, "ii", gateid, style ) ) {

		return SendClientMessage(playerid, -1, "/gatestyle [gateid] [1: nich sd gate]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	if (style == 1)
	{
		new tmpobjid = Gate[gateid][E_GATE_OBJECTID];
		SetDynamicObjectMaterial(tmpobjid, 0, 1419, "break_fence3", "CJ_FRAME_Glass", 0x00000000);
		SetDynamicObjectMaterial(tmpobjid, 1, 17588, "lae2coast_alpha", "plainglass", 0x00000000);
		SetDynamicObjectMaterial(tmpobjid, 2, 14577, "casinovault01", "cof_wood1", 0x00000000);
	}

	return true;
}

CMD:gatetoll(playerid, params[]) 
{
	if (!CheckGateAdmin(playerid)) return true;

	new gateid, status ;

	if ( sscanf ( params, "ii", gateid, status ) ) {

		return SendClientMessage(playerid, -1, "/gatetoll [gateid] [0: no, 1: yes]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_TOLL] = status ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gates SET gate_toll = %d WHERE gate_sqlid = %d",

		status, Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query );

	SendClientMessage(playerid, -1, sprintf("Updated gate ID %d's toll status to %d.", gateid, Gate [ gateid ] [ E_GATE_TOLL ] ) ) ;

	WriteLog ( playerid, "gates", sprintf("%s updated gate ID %d'stoll status to %d.", ReturnPlayerNameData(playerid), gateid, Gate [ gateid ] [ E_GATE_TOLL ] ) );

	return true ;
}

CMD:gateautoclose(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;

	new gateid, status ;

	if ( sscanf ( params, "ii", gateid, status ) ) {

		return SendClientMessage(playerid, -1, "/gateautoclose [gateid] [0: no, 1: yes]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_AUTOCLOSE] = status ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gates SET gate_autoclose = %d WHERE gate_sqlid = %d",

		status, Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query );

	SendClientMessage(playerid, -1, sprintf("Updated gate ID %d's autoclose status to %d.", gateid, Gate [ gateid ] [ E_GATE_AUTOCLOSE ] ) ) ;

	WriteLog ( playerid, "gates", sprintf("%s updated gate ID %d's autoclose status to %d.", ReturnPlayerNameData(playerid), gateid, Gate [ gateid ] [ E_GATE_AUTOCLOSE ] ) );

	return true ;
}

CMD:gateradius(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid,Float: radius ;

	if ( sscanf ( params, "if", gateid, radius ) ) {

		return SendClientMessage(playerid, -1, "/gateradius [gateid] [radius]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_RADIUS ] = radius ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE gates SET gate_radius = '%f' WHERE gate_sqlid = %d",

		radius, Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query );

	SendClientMessage(playerid, -1, sprintf("Updated gate ID %d's radius to %.3f.", gateid, Gate [ gateid ] [ E_GATE_RADIUS ] ) ) ;

	WriteLog ( playerid, "gates", sprintf("%s updated gate ID %d's radius to %.3f.", ReturnPlayerNameData(playerid), gateid, Gate [ gateid ] [ E_GATE_RADIUS ] ) );


	return true ;
}

CMD:gateopen(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid ;

	if ( sscanf ( params, "i", gateid ) ) {

		return SendClientMessage(playerid, -1, "/gateopen [gateid]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_SETUP ] = 1 ;
	PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_GATE ] = true ;

	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Gate [ gateid ] [ E_GATE_OBJECTID ], E_STREAMER_STREAM_DISTANCE, 500 );
	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Gate [ gateid ] [ E_GATE_OBJECTID ], E_STREAMER_DRAW_DISTANCE, 500 );
	EditDynamicObject(playerid, Gate [ gateid ] [ E_GATE_OBJECTID ] ) ;


	return true ;
}

CMD:gatemove(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid ;

	if ( sscanf ( params, "i", gateid ) ) {

		return SendClientMessage(playerid, -1, "/gatemove [gateid]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}


	new Float: x, Float: y, Float: z ;
	GetPlayerPos(playerid, x, y, z ) ;

	GetXYInFrontOfPlayer(playerid, x, y, 2.5 );
	SetDynamicObjectPos(Gate [ gateid ] [ E_GATE_OBJECTID ], x, y, z);

	Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Gate [ gateid ] [ E_GATE_OBJECTID ], E_STREAMER_STREAM_DISTANCE, 500 );

	Gate [ gateid ] [ E_GATE_SETUP ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_IS_MOVING_GATE ] = true ;

	EditDynamicObject(playerid, Gate [ gateid ] [ E_GATE_OBJECTID ] ) ;


	return true ;
}


CMD:gatetexture(playerid, params[]) {
	// support 16 indexes, use same method as kiosk for saving
	if (!CheckGateAdmin(playerid)) return true;
	

	new gateid, texture_slot, textureid, texturetxd[256], texturename[256] ;

	if ( sscanf ( params, "iiis[256]s[256]", gateid, texture_slot, textureid, texturetxd, texturename )) {

		return SendClientMessage(playerid, -1, "/gatetex(ture) [gateid] [index] [txd-model] [txd-txd] [txd-name]" ) ;
	}

	if ( texture_slot < 0 || texture_slot > 15 ) {

		return SendClientMessage(playerid, -1, "Texture slot can't be less than 0 or more than 15.");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_TEXTUREID ] [ texture_slot ] = textureid ;

	Gate_Texture_TXD [ gateid ] [ texture_slot ] [ 0 ] = EOS ;
	Gate_Texture_Name [ gateid ] [ texture_slot ]  [ 0 ] = EOS ;

	strcat(Gate_Texture_TXD [ gateid ] [ texture_slot ] , texturetxd );
	strcat(Gate_Texture_Name [ gateid ] [ texture_slot ] , texturename );

	// re-using string to save memory
	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE gates SET gate_textureid%d = %d, gate_texturetxd%d = '%e', gate_texturename%d = '%e' WHERE gate_sqlid = %d",
		texture_slot, Gate [ gateid ] [ E_GATE_TEXTUREID ] [ texture_slot ], 
		texture_slot, Gate_Texture_TXD [ gateid ] [ texture_slot ], 
		texture_slot, Gate_Texture_Name [ gateid ] [ texture_slot ],
	 	Gate [ gateid ] [ E_GATE_SQLID]
	) ; 

	mysql_tquery(mysql, query );

	SetDynamicObjectMaterial(Gate [ gateid ] [ E_GATE_OBJECTID ], texture_slot, Gate [ gateid ] [ E_GATE_TEXTUREID ] [ texture_slot ], Gate_Texture_TXD [ gateid ] [ texture_slot ], Gate_Texture_Name [ gateid ] [ texture_slot ], 0xFFFFFFFF );


	SendClientMessage(playerid, -1, sprintf("Set gate ID %d's texture on slot %d to id %d, txd %s and name %s.",
		gateid, texture_slot, textureid, texturetxd, texturename ) ) ;

	WriteLog ( playerid, "gates", sprintf("%s Set gate ID %d's texture on slot %d to id %d, txd %s and name %s.",
		ReturnPlayerNameData(playerid), gateid, texture_slot, textureid, texturetxd, texturename ) );


	return true ;
}

CMD:gateworld(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid, virtualworld ;

	if ( sscanf ( params, "ii", gateid, virtualworld ) ) {


		return SendClientMessage(playerid, -1, "/gatevw [gateid] [virtualworld]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_VIRTUALWORLD ] = virtualworld ;

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, Gate [gateid ] [ E_GATE_OBJECTID ], E_STREAMER_WORLD_ID, virtualworld ) ;

	Streamer_Update(playerid);

	SendClientMessage(playerid, -1, sprintf("Gate ID %d's virtual world set to %d.", gateid, virtualworld ) ) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE gates SET gate_virtualworld = %d WHERE gate_sqlid = %d",
		Gate [ gateid ] [ E_GATE_VIRTUALWORLD ], Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query);
	
	WriteLog ( playerid, "gates", sprintf("%s Gate ID %d's virtual world set to %d..",ReturnPlayerNameData(playerid), gateid, virtualworld) );


	return true ;
}

CMD:gateint(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	

	new gateid, interior ;

	if ( sscanf ( params, "ii", gateid, interior ) ) {


		return SendClientMessage(playerid, -1, "/gateint [gateid] [interior]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_INTERIOR ] = interior ;

	Streamer_SetIntData(STREAMER_TYPE_OBJECT, Gate [gateid ] [ E_GATE_OBJECTID ], E_STREAMER_INTERIOR_ID, interior ) ;

	Streamer_Update(playerid);

	SendClientMessage(playerid, -1, sprintf("Gate ID %d's interior set to %d.", gateid, interior ) ) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE gates SET gate_interior = %d WHERE gate_sqlid = %d",
		Gate [ gateid ] [ E_GATE_INTERIOR ], Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query);

	WriteLog ( playerid, "gates", sprintf("%s Gate ID %d's interior set to %d.",ReturnPlayerNameData(playerid), gateid, interior) );


	return true ;
}

CMD:gatetype(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid, ownerid, typeid ;

	if ( sscanf ( params, "iii", gateid, typeid, ownerid ) ) {

		SendClientMessage(playerid, COLOR_ERROR, "/gatetype [gateid] [type] [owner] ");
		return SendClientMessage(playerid, -1, "0: Invalid | 1: Public | 2: Player-owned | 3: Property-linked | 4: Faction-owned");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

	Gate [ gateid ] [ E_GATE_TYPE ] = typeid ;
	Gate [ gateid ] [ E_GATE_OWNER ] = ownerid ;

	SendClientMessage(playerid, -1, sprintf("Set gate ID %d's type to %d and owner to %d.", gateid, typeid, ownerid ) ) ;
	WriteLog ( playerid, "gates", sprintf("%s Set gate ID %d's type to %d and owner to %d.",ReturnPlayerNameData(playerid), gateid, typeid, ownerid ) );


	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE gates SET gate_type = %d, gate_owner = %d WHERE gate_sqlid = %d",
		Gate [ gateid ] [ E_GATE_TYPE ], Gate [ gateid ] [ E_GATE_OWNER ], Gate [ gateid ] [ E_GATE_SQLID ] ) ;

	mysql_tquery(mysql, query);

	return true ;
}


CMD:gategoto(playerid, params[]) {
	if (!CheckGateAdmin(playerid)) return true;
	
	new gateid ;

	if ( sscanf ( params, "i", gateid ) ) {

		return SendClientMessage(playerid, -1, "/gategoto [gateid]");
	}

	if ( gateid < 0 || gateid >= MAX_GATES ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}	

	if ( Gate [ gateid ] [ E_GATE_SQLID ] == INVALID_GATE_ID ) {

		return SendClientMessage(playerid, -1, "Gate ID you entered is invalid." ) ;
	}

 	SetPlayerPos ( playerid, Gate [ gateid ] [ E_GATE_CLOSED_POS_X ], Gate [ gateid ] [ E_GATE_CLOSED_POS_Y ], Gate [ gateid ] [ E_GATE_CLOSED_POS_Z ] );

 	SetPlayerInterior ( playerid, Gate [ gateid ] [ E_GATE_INTERIOR ]) ;
 	SetPlayerVirtualWorld ( playerid, Gate [ gateid ] [ E_GATE_VIRTUALWORLD ]) ;

	SendClientMessage(playerid, -1, sprintf("Teleported to gate ID %d.", gateid  ) ) ;
	WriteLog ( playerid, "gates", sprintf("%s teleported to gate ID %d.",ReturnPlayerNameData(playerid), gateid ) );


	return true ;
}