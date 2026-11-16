Weapon_RefundOldPlayerWeapons(playerid) {

	ResetPlayerWeapons(playerid);

    new
        weaponid,
        amount,
        query[256]
    ;
    
	inline Server_OnDataLoad() {

	    for_loop(new i, j = cache_get_row_count(mysql); i < j; i++) // loop through all the rows that were found
	    {
	        weaponid    = cache_get_row_int(i, 0, mysql);
	        amount = CalculateRefund ( weaponid ) ;

	        if(!(0 <= weaponid <= 46)) // check if weapon is valid (should be)
	        {
	            printf("[info] Warning: OnLoadPlayerWeapons - Unknown weaponid '%d'. Skipping.", weaponid);
	            continue;
	        }
	        
	        query [ 0 ] = EOS ;

	        mysql_format(mysql, query, sizeof(query), "DELETE FROM weapons WHERE weapon_id = %d AND character_id = %d", weaponid, Character [ playerid ] [ E_CHARACTER_ID ]) ;
	        mysql_tquery(mysql, query);

			if ( amount ) {
			   	SendServerMessage ( playerid, COLOR_BLUE, "Gun Wipe Refund: Hand Weapon", "A3A3A3", sprintf("You've been refunded $%s for the %s you had in your hand.", IntegerWithDelimiter(amount), Weapon_GetName ( playerid, weaponid ) ) ) ;

			   	GivePlayerCash(playerid, amount ) ;
			}
	    }
	}

	mysql_format(mysql, query, sizeof(query), "SELECT weapon_id, weapon_ammo FROM weapons WHERE character_id = %d", Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery_inline ( mysql, query, using inline Server_OnDataLoad, "" ) ;

    return true;
}
