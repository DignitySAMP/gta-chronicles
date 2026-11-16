#define PROPERTY_INACTIVE_DAYS	50
#define PROPERTY_INACTIVE_SECONDS (PROPERTY_INACTIVE_DAYS * 86400)

CMD:propertyactive(playerid) 
{
	return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Properties are now sold automatically after %d days of inactivity.", PROPERTY_INACTIVE_DAYS) );

	/*
	new property_enum_id = Property_GetClosestEntity( playerid ) ;


	if ( property_enum_id == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property." );
	}

	CheckInactiveProperty(playerid, property_enum_id);

	return true ;
	*/
}

CheckInactiveProperty(playerid, propertyid) {

	new query [ 96 ], owner_activity, owner_name [ MAX_PLAYER_NAME ] ;
	inline ReturnAccountLastLogin() {

		new rows, fields;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			owner_activity = cache_get_field_int ( 0, "player_logindate" ) ;
			cache_get_field_content ( 0, "player_name", owner_name, mysql, 64 ) ;

			//printf("Activity: %d", owner_activity ) ;
			//printf("Current time: %d", gettime() ) ;

			if ( gettime() - owner_activity > PROPERTY_INACTIVE_SECONDS )  { // 50 days

				new date[6] ;

				stamp2datetime ( owner_activity, date[0], date[1], date[2], date[3], date[4], date[5], 1 ) ;

				new string [ 168 ] ;

				if(GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR){
					format ( string, sizeof ( string ), "Owner (Character ID %d, %s) is {FF6347}INACTIVE!{DEDEDE} Last online at {A3A3A3}%02d/%02d/%d{DEDEDE} - {A3A3A3}%02d:%02d:%02d{DEDEDE}.", Property [ propertyid ] [ E_PROPERTY_OWNER ], owner_name, date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
				} else {
					format ( string, sizeof ( string ), "Owner (Character ID %d) is {FF6347}INACTIVE!{DEDEDE} Last online at {A3A3A3}%02d/%02d/%d{DEDEDE} - {A3A3A3}%02d:%02d:%02d{DEDEDE}.", Property [ propertyid ] [ E_PROPERTY_OWNER ], date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
				}

				SendClientMessage ( playerid, COLOR_GRAD1, string ) ; 
			}

			else {
				new date[6] ;

				stamp2datetime ( owner_activity, date[0], date[1], date[2], date[3], date[4], date[5], 1 ) ;

				new string [ 168 ] ;

				if(GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR){
					format ( string, sizeof ( string ), "Owner (Character ID %d, %s) is {33AA33}ACTIVE!{DEDEDE} Last online at {A3A3A3}%02d/%02d/%d{DEDEDE} - {A3A3A3}%02d:%02d:%02d{DEDEDE}.", Property [ propertyid ] [ E_PROPERTY_OWNER ], owner_name, date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
				} else {
					format ( string, sizeof ( string ), "Owner (Character ID %d) is {33AA33}ACTIVE!{DEDEDE} Last online at {A3A3A3}%02d/%02d/%d{DEDEDE} - {A3A3A3}%02d:%02d:%02d{DEDEDE}.", Property [ propertyid ] [ E_PROPERTY_OWNER ], date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
				}
		
				SendClientMessage ( playerid, COLOR_GRAD1, string ) ; 
			}
		}
	}
 
	mysql_format ( mysql, query, sizeof ( query ), "SELECT player_name, player_logindate FROM characters WHERE player_id = %d", Property [ propertyid ] [ E_PROPERTY_OWNER ] ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountLastLogin, "");


	return true ;
}




// NEW
AutoSellProperty(prop_enum_id)
{
	new query[512], reason[128];
	new address[64], zone[64];

	GetCoords2DZone(Property [ prop_enum_id ] [ E_PROPERTY_EXT_X ], Property [ prop_enum_id ] [ E_PROPERTY_EXT_Y ], zone, sizeof ( zone ));
	GetPlayerAddress(Property [ prop_enum_id ] [ E_PROPERTY_EXT_X ], Property [ prop_enum_id ] [ E_PROPERTY_EXT_Y ], address );

	if (Property[prop_enum_id][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_HOUSE) format(reason, sizeof(reason), "Inactive House ID %d Sold (%d %s, %s)", Property [ prop_enum_id ] [ E_PROPERTY_ID ], prop_enum_id, address, zone);
	else if (Property[prop_enum_id][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_BIZ) format(reason, sizeof(reason), "Inactive Business ID %d Sold (%d %s, %s)", Property [ prop_enum_id ] [ E_PROPERTY_ID ], prop_enum_id, address, zone);
	else format(reason, sizeof(reason), "Inactive Property ID %d Sold (%d %s, %s)", Property [ prop_enum_id ] [ E_PROPERTY_ID ], prop_enum_id, address, zone);

	inline OnAutoRefundProperty(id) 
	{
		if (cache_affected_rows(mysql))
		{
			new weapons = 0, drugs = 0;
			for (new x = 0; x < 10; x ++)
			{
				if (Property [ id ] [ E_PROPERTY_GUN ] [ x ] && Property [ id ] [ E_PROPERTY_AMMO ] [ x ])
				{
					// Create a refund each gun
					format(reason, sizeof(reason), "Was in Gun Slot %d of Inactive Property ID %d", x + 1, Property [ id ] [ E_PROPERTY_ID ]);
					mysql_format(mysql, query, sizeof(query), "INSERT INTO `refunds` (`refund_player_id`, `refund_type`, `refund_itemtype`, `refund_amount`, `refund_reason`) VALUES (%d, %d, %d, %d, '%e')", 
						Property [ id ] [ E_PROPERTY_OWNER ], 1, Property [ id ] [ E_PROPERTY_GUN ] [ x ], Property [ id ] [ E_PROPERTY_AMMO ] [ x ], reason);
					mysql_pquery(mysql, query);

					print(query);

					// 1 = REFUND_TYPE_WEAPON

					// Track how many were found
					weapons ++;
				}

				// Clear it out
				Property [ id ] [ E_PROPERTY_GUN ] [ x ] = 0;
				Property [ id ] [ E_PROPERTY_AMMO ] [ x ] = 0;
			}

			for (new x = 0; x < 10; x ++)
			{
				if (Property [ id ] [ E_PROPERTY_DRUGS_TYPE ] [ x ] && Property [ id ] [ E_PROPERTY_DRUGS_AMOUNT ] [ x ] > 0)
				{
					// Create a refund for each drug
					format(reason, sizeof(reason), "Was in Drug Slot %d of Inactive Property ID %d", x + 1, Property [ id ] [ E_PROPERTY_ID ]);
					mysql_format(mysql, query, sizeof(query), "INSERT INTO `refunds` (`refund_player_id`, `refund_type`, `refund_itemtype`, `refund_subtype`, `refund_infratype`, `refund_amount`, `refund_reason`) VALUES (%d, %d, %d, %d, %d, %f, '%e')", 
						Property [ id ] [ E_PROPERTY_OWNER ], 2, Property [ id ] [ E_PROPERTY_DRUGS_TYPE ] [ x ], Property [ id ] [ E_PROPERTY_DRUGS_PARAM ] [ x ], Property [ id ] [ E_PROPERTY_DRUGS_CONTAINER ] [ x ], Property [ id ] [ E_PROPERTY_DRUGS_AMOUNT ] [ x ], reason);
					mysql_pquery(mysql, query);

					// 2 = REFUND_TYPE_DRUG

					// Track how many were found
					drugs ++;
				}

				// Clear it out
				Property [ id ] [ E_PROPERTY_DRUGS_TYPE ] [ x ] = 0 ;
				Property [ id ] [ E_PROPERTY_DRUGS_PARAM ] [ x ] = 0;
				Property [ id ] [ E_PROPERTY_DRUGS_CONTAINER ] [ x ]  = 0 ;
				Property [ id ] [ E_PROPERTY_DRUGS_AMOUNT ] [ x ] = 0.0 ;
			}

			// Reset the owner now that the refund is complete.
			Property [ id ] [ E_PROPERTY_OWNER ] = INVALID_PROPERTY_OWNER;
			mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_owner = %d WHERE property_id = %d", Property [ id ] [ E_PROPERTY_OWNER ], Property [ id ] [ E_PROPERTY_ID ]);
			mysql_pquery(mysql, query);

			// And clear out any guns/drugs in the database too
			for (new x = 0; x < 10; x ++)
			{
				mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_gun_%d = 0, property_ammo_%d = 0, property_drugs_type_%d = 0, property_drugs_param_%d = 0, property_drugs_container_%d = 0, property_drugs_amount_%d = 0 WHERE property_id = %d", x, x, x, x, x, x, Property [ id ] [ E_PROPERTY_ID ]);
				mysql_pquery(mysql, query);
			}

			printf("Successfully auto sold and refunded Property %d (SQL: %d) (Also refunded %d drugs and %d weapons)", id, Property [ id ] [ E_PROPERTY_ID ], drugs, weapons);
		}
	}

	// Refund the owner and wait before doing anything else.
	mysql_format(mysql, query, sizeof(query), "INSERT INTO `refunds` (`refund_player_id`, `refund_amount`, `refund_reason`) VALUES (%d, %d, '%e')", Property [ prop_enum_id ] [ E_PROPERTY_OWNER ], Property [ prop_enum_id ] [ E_PROPERTY_PRICE ], reason);
	mysql_tquery_inline(mysql, query, using inline OnAutoRefundProperty, "d", prop_enum_id);
}

CheckInactiveProperties() {

	new query [ 96 ], owner_activity, count ;

	for ( new i, j = MAX_PROPERTIES; i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID && Property [ i ] [ E_PROPERTY_OWNER ] > 0 ) {

			inline ReturnAccountLastLogin() {

				new rows, fields;
				cache_get_data ( rows, fields, mysql ) ;

				if ( rows ) {

					owner_activity = cache_get_field_int ( 0, "player_logindate" ) ;

					//printf("Activity: %d", owner_activity ) ;
					//printf("Current time: %d", gettime() ) ;

					if ( (gettime() - owner_activity) > PROPERTY_INACTIVE_SECONDS ) // 50 days
					{
						// For now, let's not sell anything with guns/drugs in it

						/*
						new weapons = 0, drugs = 0;
						for (new x = 0; x < 10; x ++)
						{
							if (Property [ i ] [ E_PROPERTY_GUN ] [ x ] && Property [ i ] [ E_PROPERTY_AMMO ] [ x ]) weapons ++;
						}

						for (new x = 0; x < 10; x ++)
						{
							if (Property [ i ] [ E_PROPERTY_DRUGS_AMOUNT ] [ x ] > 0) drugs++;
						}

						if (drugs > 0 || weapons > 0)
						{
							printf("Property %d (SQL: %d) is inactive, but has weapons or drugs so skipping.", i, Property [ i ] [ E_PROPERTY_ID ]);
							continue;
						}
						*/ 

						//new date[6] ;

						//stamp2datetime ( owner_activity, date[0], date[1], date[2], date[3], date[4], date[5], 1 ) ;
						//printf( "Auto sold property ID %d - owner is inactive, last online at %02d/%02d/%d - %02d:%02d:%02d.", date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
						//printf( "Selling property ID %d - owner is inactive, last online at %02d/%02d/%d - %02d:%02d:%02d.", date[2], date[1], date[0], date[3], date[4], date[5]  ) ;

						AutoSellProperty(i);

						//printf("[DEBUG] Would auto sell property ID %d - owner is inactive, last online %d days ago.",  Property [ i ] [ E_PROPERTY_ID ], (gettime() - owner_activity) / 86400 );

						count ++ ;
					}
				}
			}

			mysql_format ( mysql, query, sizeof ( query ), "SELECT player_logindate FROM characters WHERE player_id = %d", Property [ i ] [ E_PROPERTY_OWNER ] ) ;
			mysql_tquery_inline(mysql, query, using inline ReturnAccountLastLogin, "");
		}

		else continue ;
	}
}