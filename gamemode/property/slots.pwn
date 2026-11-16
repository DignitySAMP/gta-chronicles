
Player_GetOwnedHouses ( playerid ) {

	new count = 0 ;

	for ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_HOUSE ) {
			if ( Property [ i ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

				count ++ ;
			}

			else continue ;
		}
	}

	return count ;
}

Player_GetMaxOwnedHouses(playerid) {

	new max_houses = 1 ;

	if ( Character [ playerid ] [ E_CHARACTER_HOURS ] > 300) max_houses = 3;
	else if ( Character [ playerid ] [ E_CHARACTER_HOURS ] > 150 ) max_houses = 2;

	return max_houses ;
}

Player_GetOwnedBusinesses ( playerid ) {

	new count = 0 ;

	for ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_BIZ ) {
			if ( Property [ i ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

				count ++ ;
			}

			else continue ;
		}
	}

	return count ;
}

Player_GetMaxOwnedBusinesses(playerid) 
{
	new max_businesses = 0 ;

	if (Character [ playerid ] [ E_CHARACTER_HOURS ] > 300)
	{
		max_businesses = 2;
	}
	else if (Character [ playerid ] [ E_CHARACTER_HOURS ] > 100)
	{
		max_businesses = 1;
	}
	
	return max_businesses ;
}