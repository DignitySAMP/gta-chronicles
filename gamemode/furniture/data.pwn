#if !defined MAX_FURNI_TEXTURES
	#define MAX_FURNI_TEXTURES 10
#endif 

enum E_FURNI_STORED_DATA {

	E_FURNI_SQL_ID,

	E_FURNI_MODEL,
	E_FURNI_EXTRA_ID, // property sql

	Float: E_FURNI_POS_X,
	Float: E_FURNI_POS_Y,
	Float: E_FURNI_POS_Z,

	Float: E_FURNI_ROT_X,
	Float: E_FURNI_ROT_Y,
	Float: E_FURNI_ROT_Z,

	E_FURNI_VW,
	E_FURNI_INT,

	E_FURNI_OBJECTID,

	E_FURNI_TEXTURE_INDEX[MAX_FURNI_TEXTURES]
} ;

#if !defined MAX_FURNITURE
	#define MAX_FURNITURE 400
#endif	

#if !defined INVALID_FURNI_SAVED_ID
	#define INVALID_FURNI_SAVED_ID -1 
#endif 

new Furniture [ MAX_PROPERTIES * MAX_FURNITURE ] [ E_FURNI_STORED_DATA ] ;

SavedFurni_LoadForProperty(prop_enum_id, prop_sql_id)
{
	inline Furniture_OnDataLoad() 
	{
		new rows, fields, mat_index ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows )
		{
			new startindex = prop_enum_id * MAX_FURNITURE;
			new endindex = startindex + MAX_FURNITURE;

			for ( new i; i < rows; i ++ ) 
			{
				if ( cache_get_field_int (i, "furniture_vw") == 0 ) 
				{
					printf("Furniture with SQL ID %d spawned on VW 0! Delete it!", cache_get_field_int (i, "furniture_sqlid") ) ;
					continue ;
				}
				 
				new index = startindex + i;

				if (index >= endindex)
				{
					printf("Furniture with SQL ID %d exceeded new allocated size", cache_get_field_int (i, "furniture_sqlid") ) ;
					continue ;
				}

				Furniture [ index ] [ E_FURNI_SQL_ID ]  = cache_get_field_int (i, "furniture_sqlid"); // cache_insert
				Furniture [ index ] [ E_FURNI_EXTRA_ID ]  = cache_get_field_int (i, "furniture_extraid");// property sql

				Furniture [ index ] [ E_FURNI_MODEL ]  = cache_get_field_int (i, "furniture_model");

				Furniture [ index ] [ E_FURNI_POS_X ]  = cache_get_field_float ( i, "furniture_pos_x");
				Furniture [ index ] [ E_FURNI_POS_Y ]  = cache_get_field_float ( i, "furniture_pos_y");
				Furniture [ index ] [ E_FURNI_POS_Z ]  = cache_get_field_float ( i, "furniture_pos_z");

				Furniture [ index] [ E_FURNI_ROT_X ]  = cache_get_field_float ( i, "furniture_rot_x");
				Furniture [index ] [ E_FURNI_ROT_Y ]  = cache_get_field_float ( i, "furniture_rot_y");
				Furniture [ index ] [ E_FURNI_ROT_Z ]  = cache_get_field_float ( i, "furniture_rot_z");

				Furniture [ index ] [ E_FURNI_VW ]  = cache_get_field_int (i, "furniture_vw");
				Furniture [ index ] [ E_FURNI_INT ]   = cache_get_field_int (i, "furniture_int");

				Furniture [ index ] [ E_FURNI_OBJECTID ] = CreateDynamicObject(
					Furniture [ index ] [ E_FURNI_MODEL ],
					Furniture [ index ] [ E_FURNI_POS_X ],
					Furniture [ index ] [ E_FURNI_POS_Y ],
					Furniture [ index ] [ E_FURNI_POS_Z ],
					Furniture [ index ] [ E_FURNI_ROT_X ],
					Furniture [ index ] [ E_FURNI_ROT_Y ],
					Furniture [ index ] [ E_FURNI_ROT_Z ],
					Furniture [ index ] [ E_FURNI_VW ],
					Furniture [ index ] [ E_FURNI_INT ], -1, 250.0
				);

				for ( new y; y < MAX_FURNI_TEXTURES; y ++ ) {

					Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ y ] = cache_get_field_int (i, sprintf("furniture_txd_%d", y ) ) ;
				
					if ( Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ y ] != -1 ) {
						mat_index = Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ y ] ;
						SetDynamicObjectMaterial(Furniture [ index ] [ E_FURNI_OBJECTID ], y, 
							material_information [ mat_index ] [ mat_info_model_id ], 
							material_information [ mat_index ] [ mat_info_txd_name ], 
							material_information [ mat_index ] [ mat_info_txt_name ]
						);
					}
				}

				// Storing the property SQL id so we can fetch it later (to make sure ppl cant edit furniture they dont own!)
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, Furniture [ index ] [ E_FURNI_OBJECTID ], E_STREAMER_EXTRA_ID, Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;

			}

			printf(" * [FURNITURE] Loaded %d furniture items for Property SQL ID %d.", rows, prop_sql_id);
		}
	}

	new query [ 128 ] ;
	mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM `furniture` WHERE `furniture_extraid` = %d", prop_sql_id );
	mysql_tquery_inline ( mysql, query, using inline Furniture_OnDataLoad, "" ) ;
}

// NEW: we don't load ALL furniture on startup anymore.
// Furniture for a property is now created the first time anyone enters it
// Note, it's never unloaded after creation
// This will reduce server lag (and maybe client lag) MASSIVELY! (there were 60,000 furniture objects which is a lot of loops)

SavedFurni_LoadEntities() 
{
	
	for ( new i, j = sizeof ( Furniture ); i < j ; i ++ ) 
	{

		Furniture [ i ] [ E_FURNI_SQL_ID ] = INVALID_FURNI_SAVED_ID ;
	}

	print(" * [FURNITURE] Loading blank interiors...");
 	Furniture_LoadBlankInteriors() ;

	// Exit out here now
	return 1;
}

SavedFurni_ResetObjectTextures(playerid, index) {

	if ( ! IsValidDynamicObject(  Furniture [ index ] [ E_FURNI_OBJECTID ] ) ) {

		return true ;
	}

    DestroyDynamicObject( Furniture [ index ] [ E_FURNI_OBJECTID ] ) ;

	Furniture [ index ] [ E_FURNI_OBJECTID ] = CreateDynamicObject(
		Furniture [ index ] [ E_FURNI_MODEL ],
		Furniture [ index ] [ E_FURNI_POS_X ],
		Furniture [ index ] [ E_FURNI_POS_Y ],
		Furniture [ index ] [ E_FURNI_POS_Z ],
		Furniture [ index ] [ E_FURNI_ROT_X ],
		Furniture [ index ] [ E_FURNI_ROT_Y ],
		Furniture [ index ] [ E_FURNI_ROT_Z ],
		Furniture [ index ] [ E_FURNI_VW ],
		Furniture [ index ] [ E_FURNI_INT ], -1, 250.0
	);
 
	Streamer_SetIntData(STREAMER_TYPE_OBJECT, Furniture [ index ] [ E_FURNI_OBJECTID ], E_STREAMER_EXTRA_ID, Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;
		
 
	new mat_index ;
	for ( new y; y < MAX_FURNI_TEXTURES; y ++ ) {

		if ( Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ y ] != -1 ) {
			mat_index = Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ y ] ;
			SetDynamicObjectMaterial(Furniture [ index ] [ E_FURNI_OBJECTID ], y, 
				material_information [ mat_index ] [ mat_info_model_id ], 
				material_information [ mat_index ] [ mat_info_txd_name ], 
				material_information [ mat_index ] [ mat_info_txt_name ]
			);
		}
	}

	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

	foreach(new targetid: Player) {

		if ( targetid != playerid ) {

			if ( IsPlayerInRangeOfPoint(targetid, 10.0, 
				Furniture [ index ] [ E_FURNI_POS_X ],
				Furniture [ index ] [ E_FURNI_POS_Y ],
				Furniture [ index ] [ E_FURNI_POS_Z ]
			)) {

				Streamer_Update(targetid, STREAMER_TYPE_OBJECT);
			}
		}
	}

	return true ;
}

SavedFurni_FetchEmptyID(prop_enum_id) 
{
	if (prop_enum_id == INVALID_PROPERTY_ID || prop_enum_id >= MAX_PROPERTIES) return INVALID_FURNI_SAVED_ID;

	new startindex = prop_enum_id * MAX_FURNITURE;
	new endindex = startindex + MAX_FURNITURE;

	for ( new i = startindex, j = endindex; i < j ; i ++ ) 
	{
		if ( Furniture [ i ] [ E_FURNI_SQL_ID ] == INVALID_FURNI_SAVED_ID ) 
		{
			printf("[SavedFurni_FetchEmptyID] Found free ID %d for Property %d (%d - %d)", i, prop_enum_id, startindex, endindex);
			return i ;
		}
	}

	return INVALID_FURNI_SAVED_ID ;
}


public OnPlayerSelectDynamicObject( playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z ) 
{
	if (!GetPVarInt(playerid, "selectingobject"))
	{
		new extra_id = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID) ;

		if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] == extra_id ) {

			new index = Furniture_FetchArrayFromExtra(extra_id, objectid);

			if ( index == INVALID_FURNI_SAVED_ID ) {

				return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "The object you selected isn't a furniture item." ) ;
			}

			if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] == Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) {

				if ( objectid == Furniture [ index ] [ E_FURNI_OBJECTID] ) {

					Furniture_ViewMenu(playerid, objectid, extra_id ) ;
				}
			}
		}

		else return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
	}

	#if defined furni_OnPlayerSelectDynamicObj
		return furni_OnPlayerSelectDynamicObj( playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z );
	#else
		return 0;
	#endif
}

#if defined _ALS_OnPlayerSelectDynamicObj
	#undef OnPlayerSelectDynamicObject
#else
	#define _ALS_OnPlayerSelectDynamicObj
#endif

#define OnPlayerSelectDynamicObject furni_OnPlayerSelectDynamicObj
#if defined furni_OnPlayerSelectDynamicObj
	forward furni_OnPlayerSelectDynamicObj( playerid, STREAMER_TAG_OBJECT:objectid, modelid, Float:x, Float:y, Float:z );
#endif

Furniture_ViewMenu(playerid, objectid, extra_id) 
{

	if ( GetPlayerVirtualWorld(playerid) == 0) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside a house!" ) ;
	}

	CancelEdit(playerid);
 
	inline Furni_Dialog_Menu(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, dialogid, listitem, inputtext

		if ( response ) {

			switch ( listitem ) {

				case 0: { // copy
					Furniture_CopyObject ( playerid, objectid, extra_id ) ;
				}

				case 1: { // move
					Furniture_EditObject ( playerid, objectid, extra_id ) ;
				}
				case 2: { // rotate
					Furniture_RotateObject ( playerid, objectid, extra_id ) ;
				}
				case 3: { // textures
					Furniture_TextureMenu ( playerid, objectid, extra_id ) ;
				}
				case 4: { // delete
					Furniture_DestroyObject( playerid, objectid, extra_id );
				}
			}
		}
	}

	Dialog_ShowCallback ( playerid, using inline Furni_Dialog_Menu, DIALOG_STYLE_LIST, "Editing Furniture", "Copy Object\nMove Object\nRotate Object\nManage Textures\nDestroy Object", "Continue", "Close" );

	return true ;
}

Furniture_CopyObject(playerid, objectid, extra_id ) {

	if ( GetPlayerVirtualWorld(playerid) == 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside a house!" ) ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] != extra_id || PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ] == INVALID_PROPERTY_ID || ( Property [ PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ] ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] && PlayerVar [ playerid ] [ E_PLAYER_FURNI_PERM ] != extra_id ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
	}

	new prop_enum_id = PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ];
	new index = SavedFurni_FetchEmptyID(prop_enum_id) ;

	if ( index == INVALID_FURNI_SAVED_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "Couldn't fetch new furniture ID - server furniture limit has been reached." ) ;
	}
	
	new index_old = Furniture_FetchArrayFromExtra(extra_id, objectid);

	if ( index_old == INVALID_FURNI_SAVED_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "Couldn't fetch linked object." ) ;
	}

	new cost = Furniture_GetPrice( index_old );
	if (cost > 0 && GetPlayerCash(playerid) < cost)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  sprintf("You need $%s to copy this item.", IntegerWithDelimiter(cost)) ) ;
	}


	// furni_mode = property_sql_id.
	Furniture [ index ] [ E_FURNI_EXTRA_ID ] = Furniture [ index_old ] [ E_FURNI_EXTRA_ID ] ; 

	Furniture [ index ] [ E_FURNI_MODEL ] = Furniture [ index_old ] [ E_FURNI_MODEL ] ;

	Furniture [ index ] [ E_FURNI_POS_X ] =  Furniture [ index_old ] [ E_FURNI_POS_X ] ;
	Furniture [ index ] [ E_FURNI_POS_Y ] =  Furniture [ index_old ] [ E_FURNI_POS_Y ] ;
	Furniture [ index ] [ E_FURNI_POS_Z ] =  Furniture [ index_old ] [ E_FURNI_POS_Z ] ;

	Furniture [ index ] [ E_FURNI_ROT_X ] =  Furniture [ index_old ] [ E_FURNI_ROT_X ] ;
	Furniture [ index ] [ E_FURNI_ROT_Y ] =  Furniture [ index_old ] [ E_FURNI_ROT_Y ] ;
	Furniture [ index ] [ E_FURNI_ROT_Z ] =  Furniture [ index_old ] [ E_FURNI_ROT_Z ] ;

	Furniture [ index ] [ E_FURNI_VW ] = Furniture [ index_old ] [ E_FURNI_VW ] ;
	Furniture [ index ] [ E_FURNI_INT ] =  Furniture [ index_old ] [ E_FURNI_INT ] ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"INSERT INTO furniture(furniture_extraid, furniture_model, furniture_pos_x, furniture_pos_y, \
		furniture_pos_z, furniture_rot_x, furniture_rot_y, furniture_rot_z, furniture_vw, furniture_int) \
		VALUES (%d, %d, '%f', '%f', '%f', '%f', '%f', '%f', %d, %d)",
		Furniture [ index ] [ E_FURNI_EXTRA_ID ], Furniture [ index ] [ E_FURNI_MODEL ],
		Furniture [ index ] [ E_FURNI_POS_X ] , Furniture [ index ] [ E_FURNI_POS_Y ], Furniture [ index ] [ E_FURNI_POS_Z ],
		Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ],
		Furniture [ index ] [ E_FURNI_VW ], Furniture [ index ] [ E_FURNI_INT ]
	) ;

	if ( !Furniture_IncrementPropLimit(playerid, PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "This property has reached its furniture limit. Delete some to get more storage or contact a dev." ) ;
	}

	Furniture [ index ] [ E_FURNI_SQL_ID ] = 0 ;
	TakePlayerCash(playerid, cost);

	inline Furniture_OnDatabaseInsert() {

		Furniture [ index ] [ E_FURNI_SQL_ID ] = cache_insert_id ();
		printf(" * [Furniture] Created furniture item (%d) with ID %d.", 
			index, Furniture [ index ] [ E_FURNI_SQL_ID ] ) ;


		query [ 0 ] = EOS ;
		for ( new a; a < MAX_FURNI_TEXTURES; a ++ ) {

			Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ a ] = -1 ;

			mysql_format(mysql, query, sizeof ( query ), "UPDATE furniture SET furniture_txd_%d = -1 WHERE furniture_sqlid = %d", 
				a, Furniture [ index ] [ E_FURNI_SQL_ID ] ) ;
			mysql_tquery(mysql, query);
		}

		Furniture [ index ] [ E_FURNI_OBJECTID ] = CreateDynamicObject(
			Furniture [ index ] [ E_FURNI_MODEL ],
			Furniture [ index ] [ E_FURNI_POS_X ],
			Furniture [ index ] [ E_FURNI_POS_Y ],
			Furniture [ index ] [ E_FURNI_POS_Z ],
			Furniture [ index ] [ E_FURNI_ROT_X ],
			Furniture [ index ] [ E_FURNI_ROT_Y ],
			Furniture [ index ] [ E_FURNI_ROT_Z ],
			Furniture [ index ] [ E_FURNI_VW ],
			Furniture [ index ] [ E_FURNI_INT ], -1, 250.0
		);


		Streamer_SetIntData(STREAMER_TYPE_OBJECT, Furniture [ index ] [ E_FURNI_OBJECTID ], E_STREAMER_EXTRA_ID, Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;
		
		Furniture_EditObject(playerid, Furniture [ index ] [ E_FURNI_OBJECTID ], Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Furniture_OnDatabaseInsert, "");

	return true ;
}


Furniture_CreateObject(playerid, model) 
{

	if ( GetPlayerVirtualWorld(playerid) == 0 )
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside!" ) ;
		return false;
	}

	new prop_enum_id = PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ];
	new index = SavedFurni_FetchEmptyID(prop_enum_id) ;

	if ( index == INVALID_FURNI_SAVED_ID ) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "Couldn't fetch new furniture ID - server furniture limit has been reached." ) ;
		return false;
	}

	
	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	GetXYInFrontOfPlayer ( playerid, x, y, 1.5 );


	// furni_mode = property_sql_id.
	Furniture [ index ] [ E_FURNI_EXTRA_ID ] = PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] ;

	Furniture [ index ] [ E_FURNI_MODEL ] = model ;

	Furniture [ index ] [ E_FURNI_POS_X ] = x ;
	Furniture [ index ] [ E_FURNI_POS_Y ] = y ;
	Furniture [ index ] [ E_FURNI_POS_Z ] = z ;

	Furniture [ index ] [ E_FURNI_ROT_X ] = 0.0 ;
	Furniture [ index ] [ E_FURNI_ROT_Y ] = 0.0 ;
	Furniture [ index ] [ E_FURNI_ROT_Z ] = 0.0 ;

	Furniture [ index ] [ E_FURNI_VW ] = GetPlayerVirtualWorld(playerid);
	Furniture [ index ] [ E_FURNI_INT ] = GetPlayerInterior(playerid ) ;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), 
		"INSERT INTO furniture(furniture_extraid, furniture_model, furniture_pos_x, furniture_pos_y, \
		furniture_pos_z, furniture_rot_x, furniture_rot_y, furniture_rot_z, furniture_vw, furniture_int) \
		VALUES (%d, %d, '%f', '%f', '%f', '%f', '%f', '%f', %d, %d)",
		Furniture [ index ] [ E_FURNI_EXTRA_ID ], Furniture [ index ] [ E_FURNI_MODEL ],
		Furniture [ index ] [ E_FURNI_POS_X ] , Furniture [ index ] [ E_FURNI_POS_Y ], Furniture [ index ] [ E_FURNI_POS_Z ],
		Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ],
		Furniture [ index ] [ E_FURNI_VW ], Furniture [ index ] [ E_FURNI_INT ]
	) ;

	if ( !Furniture_IncrementPropLimit(playerid, PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] ) ) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "This property has reached its furniture limit. Delete some to get more storage or contact a dev." ) ;
		return false;
	}

	Furniture [ index ] [ E_FURNI_SQL_ID ] = 0 ;

	inline Furniture_OnDatabaseInsert() {

		Furniture [ index ] [ E_FURNI_SQL_ID ] = cache_insert_id ();
		printf(" * [Furniture] Created furniture item (%d) with ID %d.", 
			index, Furniture [ index ] [ E_FURNI_SQL_ID ] ) ;


		query [ 0 ] = EOS ;
		for ( new a; a < MAX_FURNI_TEXTURES; a ++ ) {

			Furniture [ index ] [ E_FURNI_TEXTURE_INDEX ] [ a ] = -1 ;

			mysql_format(mysql, query, sizeof ( query ), "UPDATE furniture SET furniture_txd_%d = -1 WHERE furniture_sqlid = %d", 
				a, Furniture [ index ] [ E_FURNI_SQL_ID ] ) ;
			mysql_tquery(mysql, query);
		}

		Furniture [ index ] [ E_FURNI_OBJECTID ] = CreateDynamicObject(
			Furniture [ index ] [ E_FURNI_MODEL ],
			Furniture [ index ] [ E_FURNI_POS_X ],
			Furniture [ index ] [ E_FURNI_POS_Y ],
			Furniture [ index ] [ E_FURNI_POS_Z ],
			Furniture [ index ] [ E_FURNI_ROT_X ],
			Furniture [ index ] [ E_FURNI_ROT_Y ],
			Furniture [ index ] [ E_FURNI_ROT_Z ],
			Furniture [ index ] [ E_FURNI_VW ],
			Furniture [ index ] [ E_FURNI_INT ], -1, 250.0
		);

		Streamer_SetIntData(STREAMER_TYPE_OBJECT, Furniture [ index ] [ E_FURNI_OBJECTID ], E_STREAMER_EXTRA_ID, Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;
		
		Furniture_EditObject(playerid, Furniture [ index ] [ E_FURNI_OBJECTID ], Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Furniture_OnDatabaseInsert, "");

	return true ;
}

Furniture_GetPrice( index ) {

	new price  = 0 ;

	for(new i, j = sizeof ( furniture_inventory ); i < j ; i ++ ) {
		if ( Furniture [ index ] [ E_FURNI_MODEL ] == furniture_inventory[ i ][ f_inven_model ] ) {

			price = furniture_inventory[ i ][ f_inven_price ] ;
			break ;
		}

		else continue ;
	}

	return price ;
}

Furniture_DestroyObject( playerid, objectid, extra_id ) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] != extra_id || PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ] == INVALID_PROPERTY_ID || ( Property [ PlayerVar [ playerid ] [ E_PLAYER_FURNI_INDEX ] ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] && PlayerVar [ playerid ] [ E_PLAYER_FURNI_PERM ] != extra_id ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
	}

	new index = Furniture_FetchArrayFromExtra(extra_id, objectid);

	if ( index == INVALID_FURNI_SAVED_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "The object you selected isn't a furniture item." ) ;
	}

	if ( Furniture [ index ] [ E_FURNI_OBJECTID ] == objectid ) {

		new array_index = -1 ;

		for(new i, j = sizeof ( furniture_inventory ); i < j ; i ++ ) {
			if ( Furniture [ index ] [ E_FURNI_MODEL ] ==  furniture_inventory[ i ][ f_inven_model ] ) {

				array_index = i ;
				break ;
			}

			else continue ;
		}

		if ( IsValidDynamicObject( Furniture [ index ] [ E_FURNI_OBJECTID ] ) ) 
		{
			DestroyDynamicObject( Furniture [ index ] [ E_FURNI_OBJECTID ] ) ;
		}

		Furniture [ index ] [ E_FURNI_OBJECTID ] = INVALID_STREAMER_ID;

		new furni_name[64];
		new id = Furniture_FetchIDFromModel(Furniture [ index ] [ E_FURNI_MODEL ] ) ;

		if ( id == -1 ) {

			format ( furni_name, sizeof ( furni_name ), "Invalid" ) ;
		}

		else Furniture_FetchName(id, furni_name ) ;

		new query [ 256 ] ;

		mysql_format(mysql, query, sizeof(query), "DELETE FROM furniture WHERE furniture_sqlid = %d", 

			Furniture [ index ] [ E_FURNI_SQL_ID ] 
		) ;

		mysql_tquery(mysql, query);

		query [ 0 ] = EOS ;

		Furniture_DecreasePropLimit ( playerid, Furniture [ index ] [ E_FURNI_EXTRA_ID ] ) ;

		new refund ;
		if ( array_index != -1 ) {
			refund = furniture_inventory[ array_index ][ f_inven_price ] ;
			GivePlayerCash ( playerid, refund ) ;
			format ( query, sizeof ( query ), "You have destroyed your %s (sql %d). You've been refunded $%s.", 
			furni_name, Furniture [ index ] [ E_FURNI_SQL_ID ], IntegerWithDelimiter(refund) ) ;
		}

		else {
			format ( query, sizeof ( query ), "You have destroyed your %s (sql %d).", 
				furni_name, Furniture [ index ] [ E_FURNI_SQL_ID ] ) ;
		}
		
		SendServerMessage ( playerid, COLOR_FURNITURE, "Furniture", "DEDEDE", query);

		Furniture [ index ] [ E_FURNI_SQL_ID ] = -1 ;
		Furniture [ index ] [ E_FURNI_EXTRA_ID ] = -1 ;
	}

	return true ;
}


Furniture_RotateObject ( playerid, objectid, extra_id ) {

	if ( GetPlayerVirtualWorld(playerid) == 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside a house!" ) ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] != extra_id ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
	}

	new index = Furniture_FetchArrayFromExtra(extra_id, objectid);

	if ( index == INVALID_FURNI_SAVED_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "The object you selected isn't a furniture item." ) ;
	}


	new Float: old_rx, Float: old_ry, Float: old_rz ;
	GetDynamicObjectRot(objectid, old_rx, old_ry, old_rz ) ;

	inline Furni_Rot_Menu(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, dialogid, listitem, inputtext

		if(!response) {
			Furniture_ViewMenu(playerid, objectid, extra_id) ;
		}

		else if ( response ) {

			new query [ 256 ];

			switch ( listitem ) {
				case 0: { // rx
					inline Furni_Rot_Change(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
	    				#pragma unused pidx, dialogidx, listitemx

						if(!responsex) Furniture_RotateObject(playerid, objectid, extra_id);

						else if (responsex) {
							Furniture [ index ] [ E_FURNI_ROT_X ] = floatstr(inputtextx) ;
							
							mysql_format(mysql, query, sizeof ( query ), "UPDATE furniture SET furniture_rot_x = '%f' WHERE furniture_sqlid = %d",
								Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_SQL_ID ]
							);

							mysql_tquery(mysql, query);

							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("Old x rotation coordinates:{dedede} %0.3f", old_rx));
							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("New x rotation coordinates:{dedede} rx: %0.3f", Furniture [ index ] [ E_FURNI_ROT_X ] ));
				
							SetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID  ], Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ] );
						}
					}

					Dialog_ShowCallback ( playerid, using inline Furni_Rot_Change, DIALOG_STYLE_INPUT, "Editing Furniture", "Enter your desired X rotation of the object", "Change", "Back" );

				}
				case 1: { // ry
					inline Furni_Rot_Change(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
	    				#pragma unused pidx, dialogidx, listitemx

						if(!responsex) Furniture_RotateObject(playerid, objectid, extra_id);

						else if (responsex) {
							Furniture [ index ] [ E_FURNI_ROT_Y ] = floatstr(inputtextx) ;
							
							mysql_format(mysql, query, sizeof ( query ), "UPDATE furniture SET furniture_rot_y = '%f' WHERE furniture_sqlid = %d",
								Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_SQL_ID ]
							);

							mysql_tquery(mysql, query);							

							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("Old y rotation coordinates:{dedede} %0.3f", old_ry));
							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("New y rotation coordinates:{dedede} rx: %0.3f", Furniture [ index ] [ E_FURNI_ROT_Y ] ));
				
							SetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID  ], Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ] );
						}
					}

					Dialog_ShowCallback ( playerid, using inline Furni_Rot_Change, DIALOG_STYLE_INPUT, "Editing Furniture", "Enter your desired Y rotation of the object", "Change", "Back" );

				}
				case 2: { // rz
					inline Furni_Rot_Change(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
	    				#pragma unused pidx, dialogidx, listitemx

						if(!responsex) Furniture_RotateObject(playerid, objectid, extra_id);

						else if (responsex) {
							Furniture [ index ] [ E_FURNI_ROT_Z ] = floatstr(inputtextx) ;
							mysql_format(mysql, query, sizeof ( query ), "UPDATE furniture SET furniture_rot_z = '%f' WHERE furniture_sqlid = %d",
								Furniture [ index ] [ E_FURNI_ROT_Z ], Furniture [ index ] [ E_FURNI_SQL_ID ]
							);

							mysql_tquery(mysql, query);

							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("Old z rotation coordinates:{dedede} %0.3f", old_rz));
							SendClientMessage(playerid, COLOR_FURNITURE, sprintf("New z rotation coordinates:{dedede} rx: %0.3f", Furniture [ index ] [ E_FURNI_ROT_Z ] ));
				
							SetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID  ], Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ] );

						}
					}
					Dialog_ShowCallback ( playerid, using inline Furni_Rot_Change, DIALOG_STYLE_INPUT, "Editing Furniture", "Enter your desired Z rotation of the object", "Change", "Back" );
				}
			}
		}
	}

	Dialog_ShowCallback ( playerid, using inline Furni_Rot_Menu, DIALOG_STYLE_LIST, "Editing Furniture", sprintf("X Rotation: %0.4f\nY Rotation: %0.4f\nZ Rotation: %0.4f", old_rx, old_ry, old_rz), "Change", "Back" );


/*
	PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECT ] = true ;
	PlayerVar [ playerid ] [ E_FURNI_EDITING_EXTRAID ] = extraid ;
	PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECTID ] = objectid ;

	EditDynamicObject(playerid, objectid);
	SendServerMessage ( playerid, COLOR_FURNITURE, "Furniture", "DEDEDE",  "Move the furniture to a desired location using the arrows. Press ESC to reset original placement." ) ;
*/

	return true ;
}

Furniture_EditObject(playerid, objectid, extraid) {

	if ( GetPlayerVirtualWorld(playerid) == 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside a house!" ) ;
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] != extraid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
	}

	PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECT ] = true ;
	PlayerVar [ playerid ] [ E_FURNI_EDITING_EXTRAID ] = extraid ;
	PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECTID ] = objectid ;

	EditDynamicObject(playerid, objectid);
	SendServerMessage ( playerid, COLOR_FURNITURE, "Furniture", "DEDEDE",  "Move the furniture to a desired location using the arrows. Press ESC to reset original placement." ) ;

	return true ;
}

Furniture_FetchArrayFromExtra(extra_id, objectid) {

	for ( new i, j = sizeof ( Furniture ); i < j ; i ++ ) {

		if ( Furniture [ i ] [ E_FURNI_EXTRA_ID ] == extra_id) {
			if (  Furniture [ i ] [ E_FURNI_OBJECTID] == objectid ) {

				return i ;
			}
		}

		else continue ;
	}

	return INVALID_FURNI_SAVED_ID ;
}

public OnPlayerEditDynamicObject( playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz ) {
	
	if ( PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECT ] ) {

		if ( PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECTID ] == objectid ) {
			new extra_id = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID) ;
			
			if ( GetPlayerVirtualWorld(playerid) == 0 ) {

				CancelEdit(playerid);
				return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You can't create furniture outside a house!" ) ;
			}

			if ( PlayerVar [ playerid ] [ E_PLAYER_FURNI_MODE ] != extra_id ) {

				CancelEdit(playerid);
				return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "You are not in furniture mode, or this object is not synced to this property." ) ;
			}

			if ( extra_id == PlayerVar [ playerid ] [ E_FURNI_EDITING_EXTRAID ] ) {

				new index = Furniture_FetchArrayFromExtra(extra_id, objectid);

				if ( index == INVALID_FURNI_SAVED_ID ) {

					return SendServerMessage ( playerid, COLOR_ERROR, "Furniture", "DEDEDE",  "Couldn't fetch linked object." ) ;
				}

				new Float: old_x, Float: old_y, Float: old_z, Float: old_rx, Float: old_ry, Float: old_rz ;

				GetDynamicObjectPos(Furniture [ index ] [ E_FURNI_OBJECTID ], old_x, old_y, old_z ) ;
				GetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID ], old_rx, old_ry, old_rz ) ;

				switch ( response ) {

					case EDIT_RESPONSE_CANCEL: {

						SetDynamicObjectPos(Furniture [ index ] [ E_FURNI_OBJECTID ], old_x, old_y, old_z ) ;
						SetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID ], old_rx, old_ry, old_rz ) ;

						PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECT ] = false ;
						PlayerVar [ playerid ] [ E_FURNI_EDITING_EXTRAID ] = -1 ;
						PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECTID ] = -1 ;
					}

					case EDIT_RESPONSE_FINAL: {

						new query [ 256 ] ;
					
						Furniture [ index ] [ E_FURNI_POS_X ] = x ;
						Furniture [ index ] [ E_FURNI_POS_Y ] = y ;
						Furniture [ index ] [ E_FURNI_POS_Z ] = z ;
						Furniture [ index ] [ E_FURNI_ROT_X ] = rx ;
						Furniture [ index ] [ E_FURNI_ROT_Y ] = ry ;
						Furniture [ index ] [ E_FURNI_ROT_Z ] = rz ;

						SetDynamicObjectPos( Furniture [ index ] [ E_FURNI_OBJECTID ], Furniture [ index ] [ E_FURNI_POS_X ], Furniture [ index ] [ E_FURNI_POS_Y ], Furniture [ index ] [ E_FURNI_POS_Z ] );
						SetDynamicObjectRot(Furniture [ index ] [ E_FURNI_OBJECTID  ], Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ] );

						mysql_format(mysql, query, sizeof ( query ), 
							"UPDATE furniture SET furniture_pos_x = '%f', furniture_pos_y = '%f', furniture_pos_z = '%f', \
							furniture_rot_x = '%f', furniture_rot_y = '%f', furniture_rot_z = '%f' WHERE furniture_sqlid = %d",
							Furniture [ index ] [ E_FURNI_POS_X ], Furniture [ index ] [ E_FURNI_POS_Y ], Furniture [ index ] [ E_FURNI_POS_Z ], Furniture [ index ] [ E_FURNI_ROT_X ], Furniture [ index ] [ E_FURNI_ROT_Y ], Furniture [ index ] [ E_FURNI_ROT_Z ],
							Furniture [ index ] [ E_FURNI_SQL_ID ]
						);

						mysql_tquery(mysql, query);

						query [ 0 ] = EOS ;

						new furni_name [ 64 ], id = Furniture_FetchIDFromModel(Furniture [ index ] [ E_FURNI_MODEL ] ) ;

						if ( id == -1 ) {

							format ( furni_name, sizeof ( furni_name ), "Invalid" ) ;
						}

						else Furniture_FetchName(id, furni_name ) ;

						format ( query, sizeof ( query ), "Updated placement of furniture ID %d (sql%d) %s.",
						index, Furniture [ index ] [ E_FURNI_SQL_ID ], furni_name) ;

						SendServerMessage ( playerid, COLOR_FURNITURE, "Furniture", "DEDEDE", query);

						PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECT ] = false ;
						PlayerVar [ playerid ] [ E_FURNI_EDITING_EXTRAID ] = -1 ;
						PlayerVar [ playerid ] [ E_FURNI_EDITING_OBJECTID ] = -1 ;

						Furniture_ViewMenu(playerid, Furniture [ index ] [ E_FURNI_OBJECTID ], extra_id ) ;
					}
				}
			}
		}
	}

	#if defined furni_OnPlayerEditDynamicObject
		return furni_OnPlayerEditDynamicObject( playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz );
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditDynamicObject
	#undef OnPlayerEditDynamicObject
#else
	#define _ALS_OnPlayerEditDynamicObject
#endif

#define OnPlayerEditDynamicObject furni_OnPlayerEditDynamicObject
#if defined furni_OnPlayerEditDynamicObject
	forward furni_OnPlayerEditDynamicObject( playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz );
#endif