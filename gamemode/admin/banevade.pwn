BanEvaderCheck ( playerid ) {

	new bool: message_sent ;

	inline GetBanData() {

		new rows, fields, banned_ip [ 16 ];
		cache_get_data ( rows, fields, mysql ) ;
		
		if ( rows ) {

			for ( new i ; i < rows ; i ++ ) {

				cache_get_field_content(i, "account_ip", banned_ip, mysql, sizeof ( banned_ip ) ) ;

				if ( IpMatch ( banned_ip, ReturnIP ( playerid ) ) ) {
					
					if ( ! message_sent ) {
						SendAdminWarning ( sprintf("[BAN EVADING] ID %d may be ban evading!  Do a GEO location check!", playerid ) ) ;
						SendAdminWarning ( sprintf("Their IP (%s) matches netblock of banned IP (%s) and (%d total matches!)", ReturnIP ( playerid ), banned_ip, rows), false, ADMIN_LVL_GENERAL ) ;
						
						message_sent = true ;
					}
				}

				else continue ;
			}
		}
	}

	mysql_tquery_inline(mysql, "SELECT account_ip FROM bans", using inline GetBanData, "");

	return true ;
}

GetIPVal ( const ip[] ) {

  	new len = strlen(ip);

	if (!(len > 0 && len < 17))
    	return 0;

	new count, pos, dest[3], val[4];
	for (new i; i < len; i++) {

		if (ip[i] == '.' || i == len) {
			strmid(dest, ip, pos, i);
			pos = (i + 1);
		
		    val[count] = strval(dest);
		    if (!(1 <= val[count] <= 255))
		        return 0;
		        
			count++;
			if (count > 3)
				return 0;
		}
	}
	
	if (count != 3)
	    return 0;

	return ((val[0] * 16777216) + (val[1] * 65536) + (val[2] * 256) + (val[3]));
}

IpMatch(const ip1[], const ip2[], rangetype = 26) {
   	new ip = GetIPVal(ip1);
    new subnet = GetIPVal(ip2);

    new mask = -1 << (32 - rangetype);
    subnet &= mask;

    return bool:((ip & mask) == subnet);
}