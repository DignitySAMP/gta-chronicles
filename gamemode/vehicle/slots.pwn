
Player_GetOwnedVehicles ( playerid ) {

	new count = 0, query [ 128 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "SELECT COUNT(*) FROM `vehicles` WHERE `vehicle_type` = %d AND `vehicle_owner` = %d", E_VEHICLE_TYPE_PLAYER, Character [ playerid ] [ E_CHARACTER_ID ] ) ;

	new Cache:vehicle_count = mysql_query ( mysql, query ) ;

	cache_get_value_index_int ( 0, 0, count ) ;
	cache_delete ( vehicle_count ) ;

	return count ;
}

Player_GetMaxOwnedVehicles(playerid) {

	new max_vehicles = 2 ;
	
	if ( Character [ playerid ] [ E_CHARACTER_HOURS ] > 500 ) max_vehicles = 5;
	else if ( Character [ playerid ] [ E_CHARACTER_HOURS ] > 300 ) max_vehicles = 4;
	else if ( Character [ playerid ] [ E_CHARACTER_HOURS ] > 150 ) max_vehicles = 3;

	return max_vehicles ;
}