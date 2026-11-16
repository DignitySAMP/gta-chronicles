
enum E_GROUP_DATA {

	E_GROUP_DATA_SQLID,
	E_GROUP_DATA_TYPE,
	E_GROUP_DATA_NAME [ 64 ],
	E_GROUP_DATA_MOTD [ 128 ],

	E_GROUP_DATA_HEX,

	E_GROUP_DATA_CHAT
}

new Group [ MAX_GROUPS ] [ E_GROUP_DATA ];
new Iterator:Groups<MAX_GROUPS>;

Group_Create(name[], type) {

	new index = Iter_Free(Groups);

	if ( index == INVALID_ITERATOR_SLOT ) {

		return false ;
	}

	Group [ index ] [ E_GROUP_DATA_TYPE ] = type ;

	format ( Group [ index ] [ E_GROUP_DATA_NAME ], 64, "%s", name ) ;
	Group [ index ] [ E_GROUP_DATA_MOTD ] [ 0 ] = EOS ;

	Group [ index ] [ E_GROUP_DATA_CHAT ] = true ;
	Group [ index ] [ E_GROUP_DATA_HEX ] = GROUP_COLOR_DEFAULT ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO groups(group_data_type, group_data_name, group_data_motd, group_data_chat, group_data_hex) VALUES (%d, '%e', '0', %d, %d)",

		Group [ index ] [ E_GROUP_DATA_TYPE ],
		Group [ index ] [ E_GROUP_DATA_NAME ],
		Group [ index ] [ E_GROUP_DATA_CHAT ],
		Group [ index ] [ E_GROUP_DATA_HEX ] 
	);

	print(query);

	inline Group_OnDatabaseInsert() {

		Group [ index ] [ E_GROUP_DATA_SQLID ] = cache_insert_id ();
		printf(" * [GROUP] Created group (%d) with ID %d.", 
			index, Group [ index ] [ E_GROUP_DATA_SQLID ] ) ;
		Iter_Add(Groups, index);
	}

	mysql_tquery_inline(mysql, query, using inline Group_OnDatabaseInsert, "");


	return true ;
}


Group_LoadEntities() {

	print(" * [GROUPS] Loading all groups...");

	for ( new i, j= MAX_GROUPS; i < j ; i ++ ) {
		Group [ i ] [ E_GROUP_DATA_SQLID ] = INVALID_GROUP_ID ;
	}

	inline Groups_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows && i < MAX_GROUPS; i ++ ) {

				Group [ i ] [ E_GROUP_DATA_SQLID ] = cache_get_field_int (i, "group_data_sqlid");
				Group [ i ] [ E_GROUP_DATA_TYPE ] = cache_get_field_int (i, "group_data_type");
				Group [ i ] [ E_GROUP_DATA_HEX ] = cache_get_field_int (i, "group_data_hex");

				cache_get_field_content ( i, "group_data_name", Group [ i ] [ E_GROUP_DATA_NAME ], mysql ) ;
				cache_get_field_content ( i, "group_data_motd", Group [ i ] [ E_GROUP_DATA_MOTD ], mysql ) ;
				
				Group [ i ] [ E_GROUP_DATA_CHAT ] = cache_get_field_int (i, "group_data_chat");

				Iter_Add(Groups, i);
			}

			printf(" * [GROUPS] Loaded %d groups.", rows ) ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM groups", using inline Groups_OnDataLoad, "" ) ;


	return true ;
}
