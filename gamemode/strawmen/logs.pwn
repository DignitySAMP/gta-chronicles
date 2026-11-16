enum {

	E_STRAWMAN_LOG_TYPE_GUN,
	E_STRAWMAN_LOG_TYPE_AMMO,
	E_STRAWMAN_LOG_TYPE_DRUGS,

}
enum {

	E_STRAWMAN_INTERACT_SELL,
	E_STRAWMAN_INTERACT_SUPPLY
}

static StrawmanLogString [ 4096 ] ;

Strawman_Log(playerid, targetid, int_type, type, id, Float:amount, param1, param2) {

	StrawmanLogString [ 0 ] = EOS ;

	new amount_int = floatround ( amount ) ;

	new interaction[32], query[4400];

	switch(int_type) {

		case E_STRAWMAN_INTERACT_SELL: 		format(interaction, sizeof(interaction), "sold");
		case E_STRAWMAN_INTERACT_SUPPLY: 	format(interaction, sizeof(interaction), "supplied");
	}

	switch(type) {

		case E_STRAWMAN_LOG_TYPE_GUN: { // type = weapon id && param1 = ammo id(type)

			new gun_name [ 32 ], ammo_name [ 32 ] ;

			Weapon_GetGunName ( id, gun_name, sizeof ( gun_name ) );
			Weapon_GetAmmoName ( param1, ammo_name, sizeof ( ammo_name ) ) ;

			format ( StrawmanLogString, sizeof ( StrawmanLogString ), "(%d) %s has %s a (%d)%s with %d (%d)%s to (%d) %s", 
				playerid, ReturnPlayerNameData ( playerid ),
				interaction,
				id, gun_name,
				amount_int,
				param1, ammo_name,
				targetid, ReturnPlayerNameData ( targetid )
			) ;
		}

		case E_STRAWMAN_LOG_TYPE_AMMO: {

			new ammo_name [ 32 ] ;

			Weapon_GetAmmoName ( param1, ammo_name, sizeof ( ammo_name ) ) ;

			format ( StrawmanLogString, sizeof ( StrawmanLogString ), "(%d) %s has %s %d of (%d)%s to (%d) %s", 
				playerid, ReturnPlayerNameData ( playerid ),
				interaction, amount_int, param1, ammo_name,
				targetid, ReturnPlayerNameData ( targetid )
			) ;
		}

		case E_STRAWMAN_LOG_TYPE_DRUGS: {
			new drug_name [ 32 ], package_name [ 32 ], drug_type [ 32 ];

			Drugs_GetParamName ( id, param1, drug_name ) ;
			Drugs_GetTypeName(id, drug_type ) ;
			Drugs_GetPackageName ( param2, package_name ) ;

			format ( StrawmanLogString, sizeof ( StrawmanLogString ), "(%d) %s has %s %.02fgr of %s (%s in %s) to (%d) %s", 
				playerid, ReturnPlayerNameData ( playerid ),
				interaction, amount, drug_type, drug_name, package_name,
				targetid, ReturnPlayerNameData ( targetid )
			) ;
		}
	}

	mysql_format(mysql, query , sizeof ( query ), 
		"INSERT INTO strawman_logs(strawman_log_note, strawman_log_interact, strawman_log_accountid, strawman_log_unix) VALUES ('%e', %d, %d, %d)",
		StrawmanLogString, int_type, Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], gettime()
	) ;

	mysql_tquery(mysql, query);

	return true ;
}