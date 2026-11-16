
IsWeaponEmmetColt(gunid) {

	// Used for emmet colt refunds.
	if ( gunid < 0 || gunid >= sizeof ( Weapon ) ) {

		return false ;
	}

	if ( ! strcmp (Weapon[gunid][E_WEAPON_DESC], "Emmet's Colt", true )) {

		return true ;
	}

	return false ;
}

Player_RefundEmmetColt(playerid) {

	new query [ 512 ] ;

	for ( new i, j = 12; i < j ; i ++ ) {

		if ( IsWeaponEmmetColt( PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ) ) {

			SendClientMessage(playerid, -1, "!");
			ZMsg_SendClientMessage ( playerid, COLOR_ERROR, "As of 11/07, all Emmet Colts are wiped. Your equipped Emmet Colt has been refunded. Relog to get access to it through /myrefunds." ) ;
			SendClientMessage(playerid, -1, "!");

			RemovePlayerCustomWeapon(playerid, PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ) ;

    		mysql_format(mysql, query, sizeof(query), 
    			"INSERT INTO `refunds` (`refund_player_id`, `refund_type`, `refund_amount`, `refund_reason`) VALUES (%d, 0, 2500, 'Emmet Colt hand removal')", 
        		Character [ playerid ] [ E_CHARACTER_ID ]
        	);

        	mysql_tquery(mysql , query);
		}

		else continue ;
	}
}



Vehicle_RefundEmmetColt(vehicle_enum_id) {

	new query [ 512 ] ;

	for ( new i, j = 10; i < j ; i ++ ) {

		if ( IsWeaponEmmetColt( Vehicle [ vehicle_enum_id ] [ E_VEHICLE_TRUNK_WEP ]  [ i ] ) ) {

			Vehicle [ vehicle_enum_id ] [ E_VEHICLE_TRUNK_WEP ]  [ i ] = 0 ;
			Vehicle [ vehicle_enum_id ] [ E_VEHICLE_TRUNK_AMMO ]  [ i ] = 0 ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE vehicles SET vehicle_trunk_wep_%d = 0, vehicle_trunk_ammo_%d = 0 WHERE vehicle_sqlid = %d",
				i + 1, i + 1, Vehicle [ vehicle_enum_id ] [ E_VEHICLE_SQLID ]
			) ;

			mysql_tquery(mysql, query);

			query [ 0 ] = EOS ;

			if ( Vehicle [ vehicle_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_PLAYER ) {

	    		mysql_format(mysql, query, sizeof(query), 
	    			"INSERT INTO `refunds` (`refund_player_id`, `refund_type`, `refund_amount`, `refund_reason`) VALUES (%d, 0, 2500, 'Emmet Colt vehicle removal')", 
	        		Vehicle [ vehicle_enum_id ] [ E_VEHICLE_OWNER ]
	        	);

	        	mysql_tquery(mysql , query);
	        }
		}

		else continue ;
	}
}

Property_RefundEmmetColt(property_enum_id) {

	new query [ 512 ] ;

	for ( new i, j = 10; i < j ; i ++ ) {

		if ( IsWeaponEmmetColt( Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ i ] ) ) {

			Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ i ] = 0 ;
			Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ i ] = 0 ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE properties SET property_gun_%d = 0, property_ammo_%d = 0 WHERE property_id = %d",
				i, i, Property [ property_enum_id ] [ E_PROPERTY_ID ] 
			) ;

			mysql_tquery(mysql, query);

			query [ 0 ] = EOS ;

    		mysql_format(mysql, query, sizeof(query), 
    			"INSERT INTO `refunds` (`refund_player_id`, `refund_type`, `refund_amount`, `refund_reason`) VALUES (%d, 0, 2500, 'Emmet Colt property removal')", 
        		Property [ property_enum_id ] [ E_PROPERTY_OWNER ]
        	);

        	mysql_tquery(mysql , query);
		}

		else continue ;
	}
}