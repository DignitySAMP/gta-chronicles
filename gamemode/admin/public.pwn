
CMD:lastonline(playerid, params[]) {

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/lastonline [character]: use /getc to find characters linked to MA");
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Names can't be longer than 24 characters");
	}


	new query [ 128 ] ;

	inline ReturnAccountLastLogin() {

		new rows, fields, returned_name[32], returned_date, date[6] ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Database didn't return any data. Did you type the name correctly?");
		}

		if ( rows ) {

			returned_date = cache_get_field_int ( 0, "player_logindate" ) ;
			cache_get_field_content(0, "player_name", returned_name, mysql, sizeof ( returned_name ) ) ;

			AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Checked the last login date of %s", returned_name));

			if ( ! returned_date ) { 

				return SendClientMessage ( playerid, COLOR_RED, "This player hasn't logged in yet." ) ;
			}

			stamp2datetime ( returned_date, date[0], date[1], date[2], date[3], date[4], date[5], 1 ) ;

			format ( query, sizeof ( query ), "{D19932}%s{FFFFFF} was last online at %02d/%02d/%d - %02d:%02d:%02d.", returned_name, date[2], date[1], date[0], date[3], date[4], date[5]  ) ;
			return SendClientMessage ( playerid, COLOR_GRAD1, query ) ; 
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT player_name, player_logindate FROM characters WHERE player_name = '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountLastLogin, "");

	return true ;
}

CMD:getcharid(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/getcharid [name]");
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Names can't be longer than 24 characters");
	}

	new query [ 256 ] ;
	inline ReturnCharid() {

		new rows, fields, charname[32], charid, accname[32];
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Database didn't return any data. Did you type the name correctly?");
		}

		for_loop ( new i; i < rows; i ++ ) 
		{
			charid = cache_get_field_int ( i, "player_id" ) ;
			cache_get_field_content(i, "player_name", charname, mysql, sizeof ( charname ) ) ;
			cache_get_field_content(i, "account_name", accname, mysql, sizeof ( accname ) ) ;
			SendClientMessage ( playerid, COLOR_GRAD1, sprintf("Character: %s (ID: %d, Account: %s)", charname, charid, accname) ) ; 
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `characters`.`player_id`, `characters`.`player_name`, `accounts`.`account_name` FROM `characters` JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `player_name` LIKE '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnCharid, "");

	return true ;
}

CMD:gcid(playerid, params[])
{
	return cmd_getcharid(playerid, params);
}

CMD:getcharname(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new charid;

	if ( sscanf ( params, "d", charid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/getcharname [character id]");
	}

	new query [ 256 ] ;
	inline ReturnCharName() {

		new rows, fields, charname[32], accname[32];
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Database didn't return any data. Did you type the ID correctly?");
		}

		for_loop ( new i; i < rows; i ++ ) 
		{
			cache_get_field_content(i, "player_name", charname, mysql, sizeof ( charname ) ) ;
			cache_get_field_content(i, "account_name", accname, mysql, sizeof ( accname ) ) ;
			SendClientMessage ( playerid, COLOR_GRAD1, sprintf("Character: %s (ID: %d, Account: %s)", charname, charid, accname) ) ; 
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `characters`.`player_id`, `characters`.`player_name`, `accounts`.`account_name` FROM `characters` JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `player_id` = '%d'", charid ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnCharName, "");

	return true ;
}

CMD:gcn(playerid, params[])
{
	return cmd_getcharname(playerid, params);
}

CMD:getmasteraccount ( playerid, params [] ) {


	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/getma(steraccount) [character name]");
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Names can't be longer than 24 characters.");
	}

	if (!GetPlayerAdminLevel(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to use this command.");
	}

	new query [ 128 ] ;

	inline ReturnAccountID() {

		new rows, fields, returned_id, returned_name [ MAX_PLAYER_NAME ];
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) {

			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Database didn't return any account data. Maybe you mistyped the name" )  ;
		}

		if ( rows ) {

			returned_id = cache_get_field_content_int(0, "account_id", mysql ) ;

			inline ReturnAccountName() {

				cache_get_data ( rows, fields, mysql ) ;

				if ( ! rows ) {

					return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Account ID exists but couldn't fetch name (no rows). Contact a dev." )  ;
				}	

				else if ( rows ) {

					cache_get_field_content(0, "account_name", returned_name, mysql, sizeof ( returned_name ) ) ;

					format ( query, sizeof ( query ), "%s's{FFFFFF} master account is {D19932}(%d) %s{FFFFFF}", name, returned_id, returned_name ) ;
					return SendClientMessage ( playerid, 0xD19932FF, query ) ; 
				}
			}

			mysql_format ( mysql, query, sizeof ( query ), "SELECT account_name FROM accounts WHERE account_id = %d", returned_id ) ;
			mysql_tquery_inline(mysql, query, using inline ReturnAccountName, "");
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT account_id FROM characters WHERE player_name = '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountID, "");

	return true ;
}

CMD:getma ( playerid, params [ ] ) {
	return cmd_getmasteraccount ( playerid, params ) ;
}

CMD:getcharacters ( playerid, params [] ) {

	new name [ MAX_PLAYER_NAME ] ;

	if ( sscanf ( params, "s[24]", name ) ) {
	
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/getc(haracters) [master_name]");
	}

	if (!GetPlayerAdminLevel(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to use this command.");
	}

	if ( strlen ( name ) > MAX_PLAYER_NAME ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Names can't be longer than 24 characters.");
	}

	new query [ 128 ] ;

	inline ReturnMasterID() {

		new rows, fields, returned_id, returned_name[32], level;
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Database didn't return any account data. Maybe you mistyped the name" )  ;
		}

		returned_id = cache_get_field_content_int(0, "account_id", mysql ) ;
		cache_get_field_content(0, "account_name", returned_name, mysql, sizeof ( returned_name ) ) ;

		inline ReturnCharacters() 
		{
			cache_get_data ( rows, fields, mysql ) ;

			if ( ! rows ) 
			{
				return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Account ID exists but couldn't fetch name (no rows). Contact a dev." )  ;
			}	

			SendClientMessage(playerid, 0xDEDEDEFF, sprintf("Found %d characters for account (%d) %s:", rows, returned_id, returned_name) ) ;

			for (new i = 0; i < rows; i ++)
			{
				returned_id = cache_get_field_content_int(i, "player_id", mysql ) ;
				level = cache_get_field_content_int(i, "player_level", mysql ) ;
				cache_get_field_content(i, "player_name", returned_name, mysql, sizeof ( returned_name ) ) ;

				SendClientMessage(playerid, 0xD19932FF, sprintf("(%d) %s (Level: %d)", returned_id, returned_name, level) ) ;
			}
		}

		mysql_format ( mysql, query, sizeof ( query ), "SELECT player_id, player_name, player_level FROM characters WHERE account_id = %d", returned_id ) ;
		mysql_tquery_inline(mysql, query, using inline ReturnCharacters, "");	
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT account_id, account_name FROM accounts WHERE account_name LIKE '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnMasterID, "");	

	return true ;
}

CMD:getc ( playerid, params [] ) {
	return cmd_getcharacters ( playerid, params ) ;
}

CMD:getchars ( playerid, params [] ) {
	return cmd_getcharacters ( playerid, params ) ;
}