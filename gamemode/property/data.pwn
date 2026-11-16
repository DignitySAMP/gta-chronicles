

enum E_PROPERTY_DATA {


	E_PROPERTY_ID,
	E_PROPERTY_TYPE,

	E_PROPERTY_PRICE,
	E_PROPERTY_OWNER,
	E_PROPERTY_LOCKED,
	E_PROPERTY_RENT,
	E_PROPERTY_FEE,
	E_PROPERTY_NAME [ 64 ],
	E_PROPERTY_NAME_COLOR,

	Float: E_PROPERTY_EXT_X,
	Float: E_PROPERTY_EXT_Y,
	Float: E_PROPERTY_EXT_Z,

	E_PROPERTY_EXT_INT,
	E_PROPERTY_EXT_VW, 


	Float: E_PROPERTY_INT_X,
	Float: E_PROPERTY_INT_Y,
	Float: E_PROPERTY_INT_Z,

	E_PROPERTY_INT_INT,
	E_PROPERTY_INT_VW,
	E_PROPERTY_COLLECT,

	E_PROPERTY_GUN [ 10 ],
	E_PROPERTY_AMMO [ 10 ],

	E_PROPERTY_DRUGS_TYPE [ 10 ],
	E_PROPERTY_DRUGS_PARAM [ 10 ],
	E_PROPERTY_DRUGS_CONTAINER [ 10 ],
	Float: E_PROPERTY_DRUGS_AMOUNT [ 10 ],


	E_PROPERTY_FURNI_LIMIT,

	// Dynamically chosen by player
	E_PROPERTY_MAPICON_ID,
	E_PROPERTY_PICKUP_ID,
	E_PROPERTY_CMD_LIST[128], // dynamic "avilable commands"

	E_PROPERTY_BUY_TYPE,

	Float: E_PROPERTY_BUY_POS_X,
	Float: E_PROPERTY_BUY_POS_Y,
	Float: E_PROPERTY_BUY_POS_Z,
	E_PROPERTY_BUY_POS_INT,
	E_PROPERTY_BUY_POS_VW,

	E_PROPERTY_EXTRA_TYPE,
	Float: E_PROPERTY_EXTRA_POS_X,
	Float: E_PROPERTY_EXTRA_POS_Y,
	Float: E_PROPERTY_EXTRA_POS_Z,
	E_PROPERTY_EXTRA_POS_INT,
	E_PROPERTY_EXTRA_POS_VW,

	E_PROPERTY_INTERIOR_HOURS,
	E_PROPERTY_INTERIOR_MINUTES,
	E_PROPERTY_INTERIOR_WEATHER,

	bool:E_PROPERTY_INT_AUDIO_ON,
	Float: E_PROPERTY_INT_AUDIO_X,
	Float: E_PROPERTY_INT_AUDIO_Y,
	Float: E_PROPERTY_INT_AUDIO_Z,
	E_PROPERTY_INT_AUDIO_ID,
	E_PROPERTY_INT_AUDIO_URL[128],

	DynamicText3D: E_PROPERTY_BUY_LABEL,
	E_PROPERTY_MAPICON,
	E_PROPERTY_PICKUP [ 3 ],
	E_PROPERTY_AREA,// USED TO SHOW TD

	bool:E_PROPERTY_FURNI_CREATED // NEW: used to optimize furniture
} ;

#if !defined MAX_PROPERTIES
	#define MAX_PROPERTIES	2000
#endif

#if !defined INVALID_PROPERTY_ID
	#define INVALID_PROPERTY_ID -1
#endif

#if !defined PROPERTY_PICKUP_DRAW_DIST
	#define PROPERTY_PICKUP_DRAW_DIST	( 15.0 )
#endif

#if !defined PROPERTY_NEAREST_DIST
	#define PROPERTY_NEAREST_DIST	( 1.5 )
#endif

#if !defined PROPERTY_AREA_CIRCLE
	#define PROPERTY_AREA_CIRCLE 	(3.0)
#endif

#if !defined INVALID_PROPERTY_OWNER
	#define INVALID_PROPERTY_OWNER	( -1 )
#endif

new Property [ MAX_PROPERTIES ] [ E_PROPERTY_DATA ] ;

enum {

	E_PROPERTY_TYPE_HOUSE,
	E_PROPERTY_TYPE_BIZ,
	E_PROPERTY_TYPE_STATIC, // gas stations etc

}

Property_OnCreate(type, Float: pos_x, Float: pos_y, Float: pos_z, int, vw, price ) {

	new index = Property_GetFreeID() ;

	if ( index == INVALID_PROPERTY_ID ) {

		printf("Failed to create property because Property_OnCreate returned %d", index ) ;
		return false ;
	}

	Property [ index ] [ E_PROPERTY_OWNER ] 		= INVALID_PROPERTY_OWNER ;
	Property [ index ] [ E_PROPERTY_PRICE ] 		= price ;
	Property [ index ] [ E_PROPERTY_TYPE ]		 	= type ;

	Property [ index ] [ E_PROPERTY_EXT_X ] 		= pos_x ;
	Property [ index ] [ E_PROPERTY_EXT_Y ] 		= pos_y ;
	Property [ index ] [ E_PROPERTY_EXT_Z ] 		= pos_z ;

	Property [ index ] [ E_PROPERTY_EXT_INT ] 		= int ;
	Property [ index ] [ E_PROPERTY_EXT_VW ] 		= vw ;


	Property [ index ] [ E_PROPERTY_INT_X ] 		= 244.411987 ;
	Property [ index ] [ E_PROPERTY_INT_Y ] 		= 305.032989 ;
	Property [ index ] [ E_PROPERTY_INT_Z ] 		= 999.148437 ;

	Property [ index ] [ E_PROPERTY_INT_INT ] 		= 1 ;

	Property [ index ] [ E_PROPERTY_FURNI_LIMIT ] 	= 0 ;
	Property [ index ] [ E_PROPERTY_BUY_TYPE ] 		= 0 ;
	Property [ index ] [ E_PROPERTY_FEE ] 			= 0 ;
	Property [ index ] [ E_PROPERTY_COLLECT ] 		= 0 ;
	Property [ index ] [ E_PROPERTY_RENT ] 			= 0 ;
	Property [ index ] [ E_PROPERTY_LOCKED ] 		= 0 ;

	format(Property [ index ] [ E_PROPERTY_NAME ], 32, "Undefined");
	Property [index] [ E_PROPERTY_NAME_COLOR ] = 0;

	for (new x = 0; x < 10; x ++)
	{
		// Clear it out
		Property [ index ] [ E_PROPERTY_GUN ] [ x ] = 0;
		Property [ index ] [ E_PROPERTY_AMMO ] [ x ] = 0;
	}

	for (new x = 0; x < 10; x ++)
	{
		// Clear it out
		Property [ index ] [ E_PROPERTY_DRUGS_TYPE ] [ x ] = 0 ;
		Property [ index ] [ E_PROPERTY_DRUGS_PARAM ] [ x ] = 0;
		Property [ index ] [ E_PROPERTY_DRUGS_CONTAINER ] [ x ]  = 0 ;
		Property [ index ] [ E_PROPERTY_DRUGS_AMOUNT ] [ x ] = 0.0 ;
	}

	

	Property [ index ] [ E_PROPERTY_BUY_POS_X ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_BUY_POS_Y ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_BUY_POS_Z ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_BUY_POS_INT ] = 0 ;
	Property [ index ] [ E_PROPERTY_BUY_POS_VW ] = 0 ;

	Property [ index ] [ E_PROPERTY_EXTRA_TYPE ] = 0 ;
	Property [ index ] [ E_PROPERTY_EXTRA_POS_X ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_EXTRA_POS_Y ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_EXTRA_POS_Z ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_EXTRA_POS_INT ] = 0 ;
	Property [ index ] [ E_PROPERTY_EXTRA_POS_VW ] = 0 ;

	Property [ index ] [ E_PROPERTY_INT_AUDIO_ON ] = false ;
	Property [ index ] [ E_PROPERTY_INT_AUDIO_X ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_INT_AUDIO_Y ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_INT_AUDIO_Z ] = 0.0 ;
	Property [ index ] [ E_PROPERTY_INT_AUDIO_ID ] = 0 ;
	Property [ index ] [ E_PROPERTY_INT_AUDIO_URL ] [ 0 ] = EOS ;

	Property [ index ] [ E_PROPERTY_ID ] = 0 ;

	Property_SetupVisualEntities(index) ;

	new query [ 1024 ] ;

	mysql_format(mysql, query, sizeof(query), "INSERT INTO properties(property_type, property_price, property_owner, property_ext_x, property_ext_y, property_ext_z, property_ext_int, property_ext_vw, property_int_x, property_int_y, property_int_z, property_int_int) \
		VALUES (%d, %d, %d, '%f', '%f', '%f', %d, %d, '%f', '%f', '%f', %d )",
		Property [ index ] [ E_PROPERTY_TYPE ], Property [ index ] [ E_PROPERTY_PRICE ], Property [ index ] [ E_PROPERTY_OWNER ], 
		Property [ index ] [ E_PROPERTY_EXT_X ], Property [ index ] [ E_PROPERTY_EXT_Y ], Property [ index ] [ E_PROPERTY_EXT_Z ], 
		Property [ index ] [ E_PROPERTY_EXT_INT ], Property [ index ] [ E_PROPERTY_EXT_VW ], Property [ index ] [ E_PROPERTY_INT_X ], 
		Property [ index ] [ E_PROPERTY_INT_Y ], Property [ index ] [ E_PROPERTY_INT_Z ], Property [ index ] [ E_PROPERTY_INT_INT ]
	);

	inline Property_OnDatabaseInsert() {

		Property [ index ] [ E_PROPERTY_ID ] = cache_insert_id ();
		Property [ index ] [ E_PROPERTY_INT_VW ] = Property [ index ] [ E_PROPERTY_ID ];

		Property_SetupVisualEntities(index) ;

		printf(" * [Property] Created property (%d) with ID %d.", 
			index, Property [ index ] [ E_PROPERTY_ID ] ) ;
	}

	mysql_tquery_inline(mysql, query, using inline Property_OnDatabaseInsert, "");

	return true ;
}


Property_GetFreeID () {

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			return i ; 
		}

		else continue ; 
	}


	return INVALID_PROPERTY_ID ;
}

Property_GetEnumID (sql_id) 
{
	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) 
	{
		if ( Property [ i ] [ E_PROPERTY_ID ] == sql_id ) 
		{
			return i ; 
		}
	}

	return INVALID_PROPERTY_ID ;
}

Property_GetSQLID (enum_id) 
{
	return Property [ enum_id ] [ E_PROPERTY_ID ] ; 
}

Property_GetType(prop_enum_id)
{
	return Property [ prop_enum_id ] [ E_PROPERTY_TYPE ];
}


Property_LoadEntities() {

	// setup static buy points for enex ints
	Property_SetupBuyPoints() ;

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		Property [ i ] [ E_PROPERTY_ID ] = -1 ;
	}

	print(" * [PROPERTY] Loading all properties...");

	inline Property_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows; i ++ ) {

				Property [ i ] [ E_PROPERTY_ID ] = cache_get_field_int (i, "property_id" );

				Property [ i ] [ E_PROPERTY_TYPE ] = cache_get_field_int (i, "property_type" );
				Property [ i ] [ E_PROPERTY_PRICE ] = cache_get_field_int (i, "property_price" );
				Property [ i ] [ E_PROPERTY_OWNER ] = cache_get_field_int (i, "property_owner" );
				Property [ i ] [ E_PROPERTY_FEE ] = cache_get_field_int (i, "property_fee" );

				cache_get_field_content (i, "property_name", Property [ i ] [ E_PROPERTY_NAME ], mysql, 64);
				Property [ i ] [ E_PROPERTY_NAME_COLOR ] = cache_get_field_int (i, "property_name_color" );

				Property [ i ] [ E_PROPERTY_EXT_X ] = cache_get_field_float (i, "property_ext_x" );
				Property [ i ] [ E_PROPERTY_EXT_Y ] = cache_get_field_float (i, "property_ext_y" );
				Property [ i ] [ E_PROPERTY_EXT_Z ] = cache_get_field_float (i, "property_ext_z" );

				Property [ i ] [ E_PROPERTY_EXT_INT ] = cache_get_field_int (i, "property_ext_int" );
				Property [ i ] [ E_PROPERTY_EXT_VW ] = cache_get_field_int (i, "property_ext_vw" );

				Property [ i ] [ E_PROPERTY_INT_X ] = cache_get_field_float (i, "property_int_x" );
				Property [ i ] [ E_PROPERTY_INT_Y ] = cache_get_field_float (i, "property_int_y" );
				Property [ i ] [ E_PROPERTY_INT_Z ] = cache_get_field_float (i, "property_int_z" );

				Property [ i ] [ E_PROPERTY_INT_INT ] = cache_get_field_int (i, "property_int_int" );
				Property [ i ] [ E_PROPERTY_INT_VW ] = cache_get_field_int (i, "property_int_vw" );

				if (Property [ i ] [ E_PROPERTY_INT_VW ] == -1) // -1 is the default value
				{
					// This hack allows properties to be created in virtual world 0 (e.g. houses with windows to the real world)
					Property [ i ] [ E_PROPERTY_INT_VW ] = Property [ i ] [ E_PROPERTY_ID ];
				}

				Property [ i ] [ E_PROPERTY_RENT ] = cache_get_field_int (i, "property_rent" );
				Property [ i ] [ E_PROPERTY_COLLECT ] = cache_get_field_int (i, "property_collect" );

				Property [ i ] [ E_PROPERTY_FURNI_LIMIT ] = cache_get_field_int (i, "property_furni_limit" );

				Property [ i ] [ E_PROPERTY_BUY_TYPE ] = cache_get_field_int (i, "property_buy_type" );
				Property [ i ] [ E_PROPERTY_BUY_POS_X ] = cache_get_field_float (i, "property_buy_pos_x" );
				Property [ i ] [ E_PROPERTY_BUY_POS_Y ] = cache_get_field_float (i, "property_buy_pos_y" );
				Property [ i ] [ E_PROPERTY_BUY_POS_Z ] = cache_get_field_float (i, "property_buy_pos_z" );

				Property [ i ] [ E_PROPERTY_BUY_POS_INT ] = cache_get_field_int (i, "property_buy_pos_int" );
				Property [ i ] [ E_PROPERTY_BUY_POS_VW ] = cache_get_field_int (i, "property_buy_pos_vw" );

				Property [ i ] [ E_PROPERTY_EXTRA_TYPE ] = cache_get_field_int (i, "property_extra_type" );
				Property [ i ] [ E_PROPERTY_EXTRA_POS_X ] = cache_get_field_float (i, "property_extra_pos_x" );
				Property [ i ] [ E_PROPERTY_EXTRA_POS_Y ] = cache_get_field_float (i, "property_extra_pos_y" );
				Property [ i ] [ E_PROPERTY_EXTRA_POS_Z ] = cache_get_field_float (i, "property_extra_pos_z" );
				Property [ i ] [ E_PROPERTY_EXTRA_POS_INT ] = cache_get_field_int (i, "property_extra_pos_int" );
				Property [ i ] [ E_PROPERTY_EXTRA_POS_VW ] = cache_get_field_int (i, "property_extra_pos_vw" );


 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 0 ] 		= cache_get_field_int ( i, "property_drugs_type_0" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 0 ] 	= cache_get_field_int ( i, "property_drugs_param_0" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 0 ] = cache_get_field_int ( i, "property_drugs_container_0" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 0 ] 	= cache_get_field_float ( i, "property_drugs_amount_0" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 1 ] 		= cache_get_field_int ( i, "property_drugs_type_1" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 1 ] 	= cache_get_field_int ( i, "property_drugs_param_1" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 1 ] = cache_get_field_int ( i, "property_drugs_container_1" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 1 ] 	= cache_get_field_float ( i, "property_drugs_amount_1" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 2 ] 		= cache_get_field_int ( i, "property_drugs_type_2" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 2 ] 	= cache_get_field_int ( i, "property_drugs_param_2" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 2 ] = cache_get_field_int ( i, "property_drugs_container_2" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 2 ] 	= cache_get_field_float ( i, "property_drugs_amount_2" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 3 ] 		= cache_get_field_int ( i, "property_drugs_type_3" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 3 ] 	= cache_get_field_int ( i, "property_drugs_param_3" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 3 ] = cache_get_field_int ( i, "property_drugs_container_3" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 3 ] 	= cache_get_field_float ( i, "property_drugs_amount_3" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 4 ] 		= cache_get_field_int ( i, "property_drugs_type_4" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 4 ] 	= cache_get_field_int ( i, "property_drugs_param_4" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 4 ] = cache_get_field_int ( i, "property_drugs_container_4" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 4 ] 	= cache_get_field_float ( i, "property_drugs_amount_4" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 5 ] 		= cache_get_field_int ( i, "property_drugs_type_5" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 5 ] 	= cache_get_field_int ( i, "property_drugs_param_5" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 5 ] = cache_get_field_int ( i, "property_drugs_container_5" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 5 ] 	= cache_get_field_float ( i, "property_drugs_amount_5" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 6 ] 		= cache_get_field_int ( i, "property_drugs_type_6" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 6 ] 	= cache_get_field_int ( i, "property_drugs_param_6" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 6 ] = cache_get_field_int ( i, "property_drugs_container_6" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 6 ] 	= cache_get_field_float ( i, "property_drugs_amount_6" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 7 ] 		= cache_get_field_int ( i, "property_drugs_type_7" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 7 ] 	= cache_get_field_int ( i, "property_drugs_param_7" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 7 ] = cache_get_field_int ( i, "property_drugs_container_7" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 7 ] 	= cache_get_field_float ( i, "property_drugs_amount_7" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 8 ] 		= cache_get_field_int ( i, "property_drugs_type_8" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 8 ] 	= cache_get_field_int ( i, "property_drugs_param_8" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 8 ] = cache_get_field_int ( i, "property_drugs_container_8" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 8 ] 	= cache_get_field_float ( i, "property_drugs_amount_8" ) ; 

				Property [ i ] [ E_PROPERTY_DRUGS_TYPE ] [ 9 ] 		= cache_get_field_int ( i, "property_drugs_type_9" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_PARAM ] [ 9 ] 	= cache_get_field_int ( i, "property_drugs_param_9" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_CONTAINER ] [ 9 ] = cache_get_field_int ( i, "property_drugs_container_9" ) ; 
				Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ 9 ] 	= cache_get_field_float ( i, "property_drugs_amount_9" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 0 ] = cache_get_field_int ( i, "property_gun_0" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 0 ] = cache_get_field_int ( i, "property_ammo_0" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 1 ] = cache_get_field_int ( i, "property_gun_1" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 1 ] = cache_get_field_int ( i, "property_ammo_1" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 2 ] = cache_get_field_int ( i, "property_gun_2" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 2 ] = cache_get_field_int ( i, "property_ammo_2" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 3 ] = cache_get_field_int ( i, "property_gun_3" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 3 ] = cache_get_field_int ( i, "property_ammo_3" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 4 ] = cache_get_field_int ( i, "property_gun_4" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 4 ] = cache_get_field_int ( i, "property_ammo_4" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 5 ] = cache_get_field_int ( i, "property_gun_5" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 5 ] = cache_get_field_int ( i, "property_ammo_5" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 6 ] = cache_get_field_int ( i, "property_gun_6" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 6 ] = cache_get_field_int ( i, "property_ammo_6" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 7 ] = cache_get_field_int ( i, "property_gun_7" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 7 ] = cache_get_field_int ( i, "property_ammo_7" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 8 ] = cache_get_field_int ( i, "property_gun_8" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 8 ] = cache_get_field_int ( i, "property_ammo_8" ) ; 

				Property [ i ] [ E_PROPERTY_GUN ] [ 9 ] = cache_get_field_int ( i, "property_gun_9" ) ; 
				Property [ i ] [ E_PROPERTY_AMMO] [ 9 ] = cache_get_field_int ( i, "property_ammo_9" ) ; 

				Property [ i ] [ E_PROPERTY_LOCKED ] = cache_get_field_int ( i, "property_locked" ) ;

				Property [ i ] [ E_PROPERTY_INTERIOR_HOURS ]  	= cache_get_field_int ( i, "property_int_hours" ) ; 
				Property [ i ] [ E_PROPERTY_INTERIOR_MINUTES ]  = cache_get_field_int ( i, "property_int_mins" ) ; 

				Property [ i ] [ E_PROPERTY_INTERIOR_WEATHER ]  = cache_get_field_int ( i, "property_int_weather" ) ; 

				Property [ i ] [ E_PROPERTY_INT_AUDIO_ON ]  = bool:cache_get_field_int ( i, "property_int_audio_on" ) ; 
				Property [ i ] [ E_PROPERTY_INT_AUDIO_ID ]  = cache_get_field_int ( i, "property_int_audio_id" ) ; 
				Property [ i ] [ E_PROPERTY_INT_AUDIO_X ]  = cache_get_field_float ( i, "property_int_audio_x" ) ; 
				Property [ i ] [ E_PROPERTY_INT_AUDIO_Y ]  = cache_get_field_float ( i, "property_int_audio_y" ) ; 
				Property [ i ] [ E_PROPERTY_INT_AUDIO_Z ]  = cache_get_field_float ( i, "property_int_audio_z" ) ; 
				cache_get_field_content (i, "property_int_audio_url", Property [ i ] [ E_PROPERTY_INT_AUDIO_URL ], mysql, 128);

				Property_SetupVisualEntities(i);
				PropertySetupBuyPoint(i) ;
				//Property_Refund(i);

				Property_RefundEmmetColt(i);
			}


			printf(" * [PROPERTY] Loaded %d properties.", rows ) ;
			CheckInactiveProperties();
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM properties", using inline Property_OnDataLoad, "" ) ;

	return true ;
}


stock Property_LinkSQLToEnum(sql_id) {

	for ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == sql_id ) {

			return i ;
		}

		else continue ;
	}

	return -1 ;
}


Property_SetupVisualEntities(enum_id) {
	// There's a bug with pickups that causes them to stay streamed. Something is overwriting the ID.
	// Usually happens when you spawn right ontop of it using the property spawn script.

	if ( Property [ enum_id ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_BIZ ) {

		if ( IsValidDynamicMapIcon( Property [ enum_id ] [ E_PROPERTY_MAPICON ] ) ) {

			DestroyDynamicMapIcon( Property [ enum_id ] [ E_PROPERTY_MAPICON ] ) ;
			Property [ enum_id ] [ E_PROPERTY_MAPICON ] = INVALID_STREAMER_ID;
		}

		new icon = PropertyType_GetMapIcon (Property [ enum_id ] [ E_PROPERTY_BUY_TYPE ]);

		if ( icon ) {
			Property [ enum_id ] [ E_PROPERTY_MAPICON ] = CreateDynamicMapIcon(Property [ enum_id ] [ E_PROPERTY_EXT_X ], Property [ enum_id ] [ E_PROPERTY_EXT_Y ], Property [ enum_id ] [ E_PROPERTY_EXT_Z ], icon, 0xFFFFFFFF, -1, -1, -1, PROPERTY_PICKUP_DRAW_DIST ) ;
		}
	}

	new pickup_model, Float:pickup_offset_z = 0.0;
	
	switch ( Property [ enum_id ] [ E_PROPERTY_TYPE ] ) {

		case E_PROPERTY_TYPE_HOUSE: {
			pickup_model = 19902 ; // yellow arrow
		}
		case E_PROPERTY_TYPE_BIZ: {

			pickup_model = PropertyType_GetPickup ( Property [ enum_id ] [ E_PROPERTY_BUY_TYPE ] ) ;

		}
		case E_PROPERTY_TYPE_STATIC: {
			pickup_model = 1239 ; // yellow "i"
		}
	}

	if (pickup_model == 19902) pickup_offset_z = -1.0;

	// We create the circle first because it is linked to the pickups.
	if ( IsValidDynamicArea( Property [ enum_id ] [ E_PROPERTY_AREA ] ) ) {

		DestroyDynamicArea( Property [ enum_id ] [ E_PROPERTY_AREA ] ) ;
	}

	Property [ enum_id ] [ E_PROPERTY_AREA ] = CreateDynamicCircle(Property [ enum_id ] [ E_PROPERTY_EXT_X ], Property [ enum_id ] [ E_PROPERTY_EXT_Y ], 
		PROPERTY_AREA_CIRCLE, Property [ enum_id ] [ E_PROPERTY_EXT_VW ], Property [ enum_id ] [ E_PROPERTY_EXT_INT ]) ;

	if ( IsValidDynamicPickup( Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 0 ] ) ) {

		DestroyDynamicPickup(Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 0 ] ) ;
	}

	Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 0 ] = CreateDynamicPickup(
		pickup_model, 1, 
		Property [ enum_id ] [ E_PROPERTY_EXT_X ], Property [ enum_id ] [ E_PROPERTY_EXT_Y ], Property [ enum_id ] [ E_PROPERTY_EXT_Z ] + pickup_offset_z,
		Property [ enum_id ] [ E_PROPERTY_EXT_VW ], Property [ enum_id ] [ E_PROPERTY_EXT_INT ], -1,
		PROPERTY_PICKUP_DRAW_DIST
	);

	if ( IsValidDynamicPickup( Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 1 ] ) ) {

		DestroyDynamicPickup(Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 1 ] ) ;
	}

	Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 1 ] = CreateDynamicPickup(
		19902, 1, 
		Property [ enum_id ] [ E_PROPERTY_INT_X ], Property [ enum_id ] [ E_PROPERTY_INT_Y ], Property [ enum_id ] [ E_PROPERTY_INT_Z ] + pickup_offset_z,
		Property [ enum_id ] [ E_PROPERTY_ID ], Property [ enum_id ] [ E_PROPERTY_INT_INT ], -1,
		PROPERTY_PICKUP_DRAW_DIST
	);

	if ( IsValidDynamicPickup( Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 2 ] ) ) {

		DestroyDynamicPickup(Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 2 ] ) ;
		Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 2 ] = INVALID_STREAMER_ID;
	}

	if ( IsValidDynamic3DTextLabel(Property [ enum_id ] [ E_PROPERTY_BUY_LABEL ] ) ) {

		DestroyDynamic3DTextLabel( Property [ enum_id ] [ E_PROPERTY_BUY_LABEL ] ) ;
		Property [ enum_id ] [ E_PROPERTY_BUY_LABEL ] = DynamicText3D:INVALID_STREAMER_ID;
	}

	if ( Property [ enum_id ] [ E_PROPERTY_BUY_TYPE ] != E_BUY_TYPE_NONE && floatround(Property[enum_id][E_PROPERTY_BUY_POS_X]) != 0 && floatround(Property[enum_id][E_PROPERTY_BUY_POS_Y]) != 0) 
	{
		Property [ enum_id ] [ E_PROPERTY_PICKUP ] [ 2 ] = CreateDynamicPickup(
			pickup_model, 1, 
			Property [ enum_id ] [ E_PROPERTY_BUY_POS_X ], Property [ enum_id ] [ E_PROPERTY_BUY_POS_Y ], Property [ enum_id ] [ E_PROPERTY_BUY_POS_Z ] + pickup_offset_z,
			Property [ enum_id ] [ E_PROPERTY_BUY_POS_VW ], Property [ enum_id ] [ E_PROPERTY_BUY_POS_INT ], -1,
			PROPERTY_PICKUP_DRAW_DIST
		);

		PropertySetupBuyPoint(enum_id) ;

	}

	return true ;
}


PropertySetupBuyPoint(property_id) {

	if ( Property [ property_id ] [ E_PROPERTY_BUY_TYPE ] == E_BUY_TYPE_NONE || (floatround(Property[property_id][E_PROPERTY_BUY_POS_X]) == 0 && floatround(Property[property_id][E_PROPERTY_BUY_POS_Y]) == 0) ) 
	{
		return true ;
	}

	new extra_type, property_type, string [ 256 ], type_name [ 32 ], type_extra [ 32 ], type_cmds [ 128 ] ;

	if ( IsValidDynamic3DTextLabel(Property [ property_id ] [ E_PROPERTY_BUY_LABEL ] ) ) {

		DestroyDynamic3DTextLabel( Property [ property_id ] [ E_PROPERTY_BUY_LABEL ] ) ;
		Property [ property_id ] [ E_PROPERTY_BUY_LABEL ] = DynamicText3D:INVALID_STREAMER_ID;
	}

	switch ( Property [ property_id ] [ E_PROPERTY_BUY_TYPE ] ) {
		case E_BUY_TYPE_DEALERSHIP, E_BUY_TYPE_GASSTATION, E_BUY_TYPE_MODSHOP: {

			extra_type = Property [ property_id ] [ E_PROPERTY_EXTRA_TYPE ] ;
			property_type = Property [ property_id ] [ E_PROPERTY_BUY_TYPE ] ;

			string [ 0 ] = EOS, type_name [ 0 ] = EOS, type_cmds [ 0 ] = EOS ;

			// For now this only works with dealerships!
			switch ( property_type ) {
				
				case E_BUY_TYPE_DEALERSHIP: {
					switch ( extra_type ) {

						case 0: format ( type_extra, sizeof ( type_extra ), " Budget " ) ;
						case 1: format ( type_extra, sizeof ( type_extra ), " Muscle " ) ;
						case 2: format ( type_extra, sizeof ( type_extra ), " Sports " ) ;
						case 3: format ( type_extra, sizeof ( type_extra ), " Utility " ) ;
						case 4: format ( type_extra, sizeof ( type_extra ), " Aircraft " ) ;
						case 5: format ( type_extra, sizeof ( type_extra ), " Bike " ) ;
						case 6: format ( type_extra, sizeof ( type_extra ), " Boat " ) ;
					}
				}
			}

			PropertyType_GetName ( property_type, type_name, sizeof ( type_name ) ) ;
			PropertyType_GetCommand ( property_type, type_cmds, sizeof ( type_cmds ) ) ;

			format ( string, sizeof ( string ), "[%d] [%s%s]\n{DEDEDE}Available Commands: %s",
				property_id, type_extra, type_name, type_cmds
			) ;

			Property [ property_id ] [ E_PROPERTY_BUY_LABEL ] = CreateDynamic3DTextLabel(string, COLOR_PROPERTY, 
				Property [ property_id ] [ E_PROPERTY_EXT_X ], Property [ property_id ] [ E_PROPERTY_EXT_Y ], Property [ property_id ] [ E_PROPERTY_EXT_Z ],
				15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Property [ property_id ] [ E_PROPERTY_EXT_VW], Property [ property_id ] [ E_PROPERTY_EXT_INT],-1 
			) ;

			return true ;
		}
	}

	property_type = Property [ property_id ] [ E_PROPERTY_BUY_TYPE ] ;

	string [ 0 ] = EOS, type_name [ 0 ] = EOS, type_cmds [ 0 ] = EOS ;

	PropertyType_GetName ( property_type, type_name, sizeof ( type_name ) ) ;
	PropertyType_GetCommand ( property_type, type_cmds, sizeof ( type_cmds ) ) ;

	format ( string, sizeof ( string ), "[%d] [%s]\n{DEDEDE}Available Commands: %s",
		property_id, type_name, type_cmds
	) ;

	Property [ property_id ] [ E_PROPERTY_BUY_LABEL ] = CreateDynamic3DTextLabel(string, COLOR_PROPERTY, 
		Property [ property_id ] [ E_PROPERTY_BUY_POS_X ], Property [ property_id ] [ E_PROPERTY_BUY_POS_Y ], Property [ property_id ] [ E_PROPERTY_BUY_POS_Z ],
		15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, Property [ property_id ] [ E_PROPERTY_BUY_POS_VW], Property [ property_id ] [ E_PROPERTY_BUY_POS_INT],-1 
	) ;



	return true ;
}
