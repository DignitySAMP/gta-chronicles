enum E_GUN_REFUND_DATA {

	E_REFUND_GUNID,
	E_REFUND_FEE
} ;

new GunRefund [ ] [ E_GUN_REFUND_DATA ] = {
	{ WEAPON_SPRAYCAN,		50 },
	{ WEAPON_BRASSKNUCKLE,	150 },
	{ WEAPON_BAT,			200 },
	{ WEAPON_KNIFE,			250 },
	{ WEAPON_COLT45,		750 },
	{ WEAPON_UZI,			1500 },
	{ WEAPON_TEC9,			1500 }
} ;

CalculateRefund ( weaponid ) {

	for_loop ( new i, j = sizeof ( GunRefund ); i < j ; i ++ ) {

		if ( weaponid == GunRefund [ i ] [ E_REFUND_GUNID ] ) {

			return GunRefund [ i ] [ E_REFUND_FEE ]  ;
		}

		else continue ;
	}

	return 250 ;
}
 
stock Property_RefundGuns(enum_id) {

	new fee ;

	if ( Property [ enum_id ] [ E_PROPERTY_GUN_1 ] ) {
		fee += CalculateRefund( Property [ enum_id ] [ E_PROPERTY_GUN_1 ] ) ;
	}
	if ( Property [ enum_id ] [ E_PROPERTY_GUN_2 ] ) {
		fee += CalculateRefund( Property [ enum_id ] [ E_PROPERTY_GUN_2 ] ) ;
	}
	if ( Property [ enum_id ] [ E_PROPERTY_GUN_3 ] ) {
		fee += CalculateRefund( Property [ enum_id ] [ E_PROPERTY_GUN_3 ] ) ;
	}

	new character_id = Property [ enum_id ] [ E_PROPERTY_OWNER ] ;

	if ( fee == 0 ) {

		return true ;
	}

	new query [ 1024 ] ;

	if ( character_id != -1 ) {

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_property_refund = %d WHERE player_id = %d", 
			fee, character_id
		) ;

		mysql_tquery(mysql, query );
	}

	mysql_format(mysql, query, sizeof ( query ), "UPDATE properties SET property_gun_1 = 0, property_ammo_1 = 0,\
		property_gun_2 = 0, property_ammo_2 = 0, property_gun_3 = 0, property_ammo_3 = 0 WHERE property_id = %d",

		Property [ enum_id ] [ E_PROPERTY_ID ]
	) ;

	mysql_tquery(mysql, query);

	printf("Property [%d] - refunding $%d for player id %d.", Property [ enum_id ] [ E_PROPERTY_ID ], fee, character_id ) ;
	return true ;
}


stock Vehicle_RefundGuns(enum_id) {

	new fee ;

	for_loop ( new i, j = 5; i < j ; i ++ ) {
		if ( Vehicle [ enum_id ] [ E_VEHICLE_TRUNK_WEP ] [ i ] ) {
			fee += CalculateRefund( Vehicle [ enum_id ] [ E_VEHICLE_TRUNK_WEP ] [ i ] ) ;
		}	
	}

	new character_id = Vehicle [ enum_id ] [ E_VEHICLE_OWNER ] ;

	if ( fee == 0 ) {

		return true ;
	}

	new query [ 1024 ] ;

	if ( character_id != -1 ) {

		mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_vehicle_refund = %d WHERE player_id = %d", 
			fee, character_id
		) ;
		
		mysql_tquery(mysql, query );
	}


	mysql_format(mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_trunk_wep_1 = 0, vehicle_trunk_ammo_1 = 0,\
	vehicle_trunk_wep_2 = 0, vehicle_trunk_ammo_2 = 0, vehicle_trunk_wep_3 = 0, vehicle_trunk_ammo_3 = 0, vehicle_trunk_wep_4 = 0,\
	vehicle_trunk_ammo_4 = 0, vehicle_trunk_wep_5 = 0, vehicle_trunk_ammo_5 = 0 WHERE vehicle_sqlid = %d",

		Vehicle [ enum_id ] [ E_VEHICLE_SQLID ]
	) ;

	mysql_tquery(mysql, query);

	printf("Vehicle [%d] - refunding $%d for player id %d.", Vehicle [ enum_id ] [ E_VEHICLE_SQLID ] , fee, character_id ) ;
	return true ;
}