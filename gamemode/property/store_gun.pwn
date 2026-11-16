CMD:propstorage(playerid, params[]) {

	return cmd_propertystorage(playerid, params);
}
CMD:propertystorage(playerid, params[]) {
	
	
	if (!PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) 
	{
		if ( IsPlayerInPoliceFaction ( playerid ) ) {
			return SendServerMessage ( playerid, COLOR_ERROR, "Warning", "A3A3A3", "Police officers can not use gun-related commands to avoid abuse." ) ;
		}
		if ( IsPlayerIncapacitated(playerid) ) {
		
			return true ; 
		}
		if ( ! CanPlayerUseGuns(playerid, 8) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "Your account is too new! You can't use gun related features yet." ) ;
		}
	}

	new property_enum_id = Property_GetClosestEntity( playerid ) ;

	if ( property_enum_id == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property");
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] && !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) {
		
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own this property.");
	}

	SendClientMessage(playerid, COLOR_PROPERTY, "Property Contents:" ) ;
	new gun_name [ 32 ] ;

	new count  = 0 ;
	for ( new i, j = 10 ; i < j ; i ++ ) {


		if ( Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ i ] ) { 
			Weapon_GetGunName ( Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ i ], gun_name, sizeof ( gun_name ) );
			SendClientMessage(playerid, COLOR_GRAD0, sprintf("(Slot %d): %s with %d ammo.", i, gun_name, Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ i ] ) );
			count ++ ;
		}
	}

	if ( ! count ) {

		SendClientMessage(playerid, 0xDEDEDEFF, "No guns to show!");
	}

	count  = 0 ;

	new drug_name [ 32 ], drug_type [ 32 ], package_name [ 32 ], string [ 256 ] ;

	for ( new i, j = 10 ; i < j ; i ++ ) {


		if ( Property [ property_enum_id ] [ E_PROPERTY_DRUGS_TYPE ] [ i ] != E_DRUG_TYPE_NONE ) {
			Drugs_GetParamName ( Property [ property_enum_id ] [ E_PROPERTY_DRUGS_TYPE ] [ i ], 
				Property [ property_enum_id ] [ E_PROPERTY_DRUGS_PARAM ] [ i ], drug_name 
			) ;

			Drugs_GetPackageName ( Property [ property_enum_id ] [ E_PROPERTY_DRUGS_CONTAINER ] [ i ], package_name ) ;

			Drugs_GetTypeName(Property [ property_enum_id ] [ E_PROPERTY_DRUGS_TYPE ] [ i ], drug_type ) ;

			format ( string, sizeof ( string ), "(Slot %d): %.02fgr of %s stored in a %s. {FFFF00}[%s] ",
				i, Property [ property_enum_id ] [ E_PROPERTY_DRUGS_AMOUNT] [ i ], drug_name, package_name, drug_type
			 ) ;

			SendClientMessage(playerid, COLOR_GRAD0, string );
			count ++ ;
		}
	}

	if ( ! count ) {

		SendClientMessage(playerid, 0xDEDEDEFF, "No drugs to show!");
	}

	return true ;
}
CMD:proptakegun(playerid, params[]) {

	return cmd_propertytakegun(playerid, params);
}
CMD:propertytakegun(playerid, params[]) 
{
	if ( ! CanPlayerDoGunCMD(playerid) ) 
	{
		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	new property_enum_id = Property_GetClosestEntity( playerid ) ;
	if ( property_enum_id == INVALID_PROPERTY_ID ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property.");
	}

	if (!GetPlayerAdminLevel(playerid) || !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
	{
		if ( IsPlayerInPoliceFaction ( playerid ) || IsPlayerInMedicFaction(playerid) ) 
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Warning", "A3A3A3", "Members of your faction can not use gun-related commands to avoid abuse." ) ;
		}

		if ( IsPlayerIncapacitated(playerid) ) 
		{
			return true ;
		}

		if ( ! CanPlayerUseGuns(playerid, 8) ) 
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "Your account is too new! You can't use gun related features yet." ) ;
		}

		if ( Property [ property_enum_id ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own this property.");
		}
	}


	new slot ;

	if ( sscanf ( params, "i", slot ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/propertytakegun [slot: 0-9]");
	}

	if ( slot < 0 || slot > 9 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Slot can't be less than 0 or higher than 9.");
	}

	if ( AC_GetPlayerWeapon(playerid) != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're already holding a weapon.");
	}

	new gun_name [ 32 ], query [ 256 ], ammo, gun ;
	gun = Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ];
	ammo = Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ slot ];

	if (gun < 1 || ammo < 1) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This slot is empty and has no gun to take.");
	}

	Weapon_GetGunName ( Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ], gun_name, sizeof ( gun_name ) );
	GiveCustomWeapon ( playerid, Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ], Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ slot ] ) ;

	Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ] = 0 ;
	Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ slot ] =  0 ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE properties SET property_gun_%d = %d, property_ammo_%d = %d WHERE property_id =%d  ",

		slot, Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ],
		slot, Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ slot ],
		Property [ property_enum_id ] [ E_PROPERTY_ID ]
	) ;

	mysql_tquery ( mysql, query );

    ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s takes a %s from their property.", ReturnPlayerNameData(playerid, 0, true), gun_name));

	SendAdminMessage ( sprintf("[AdmMsg]: ** %s (%d) takes a %s from their property.", 
    	ReturnPlayerNameData(playerid), playerid, gun_name));

	// printf("[PROPGUN] %s took a %s (%d) (Ammo: %d) from their property (%d)", ReturnPlayerNameData(playerid), gun_name, gun, ammo, Property [ property_enum_id ] [ E_PROPERTY_ID ]);

	//NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Took a %s (%d) (Ammo: %d) from Property %d", gun_name, gun, ammo, Property [ property_enum_id ] [ E_PROPERTY_ID ]));

	return true ;
}

CMD:propstoregun(playerid, params[]) {

	return cmd_propertystoregun(playerid, params);
}

CMD:propertystoregun(playerid, params[]) {
	if ( ! CanPlayerDoGunCMD(playerid) ) {

		return SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3",  "You can't do this command when you're inside a vehicle, or are on temporary cooldown." );
	}

	if ( IsPlayerInPoliceFaction ( playerid ) || IsPlayerInMedicFaction(playerid) ) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Warning", "A3A3A3", "Members of your faction can not use gun-related commands to avoid abuse." ) ;
    }

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return true ;
    }
    if ( ! CanPlayerUseGuns(playerid, 8) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "DEDEDE", "Your account is too new! You can't use gun related features yet." ) ;
	}
	
	new property_enum_id = Property_GetClosestEntity( playerid ) ;

	if ( property_enum_id == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property.");
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_OWNER ] != Character [ playerid ] [ E_CHARACTER_ID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own this property.");
	}

	new slot ;

	if ( sscanf ( params, "i", slot ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/propertystoregun [slot: 0-9]");
	}

	if ( slot < 0 || slot > 9 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Slot can't be less than 0 or higher than 9.");
	}

	if ( AC_GetPlayerWeapon(playerid) == 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not holding a weapon.");
	}

	new gunid = GetPlayerCustomWeapon(playerid) ;
	new synced_ammo = SOLS_GetPlayerAmmo(playerid);
	new ammo = GetPlayerAmmo(playerid);

	if (ammo > synced_ammo)
	{
		// No legitimate reason for the client ammo to be HIGHER than the synced ammo, so can safely change it
		ammo = synced_ammo;
	}

	if (ammo < 1 || gunid < 1)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not holding a valid weapon (check returned -1).");
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_GUN ][slot] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There's already a weapon in this slot!");
	}

	new gun_name [ 32 ], query [ 256 ] ;
	Weapon_GetGunName ( gunid, gun_name, sizeof ( gun_name ) );

	Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ] = gunid;
	Property [ property_enum_id ] [ E_PROPERTY_AMMO ][ slot ] = ammo;

	RemovePlayerCustomWeapon(playerid, gunid ) ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE properties SET property_gun_%d = %d, property_ammo_%d = %d  WHERE property_id =%d  ",

		slot, Property [ property_enum_id ] [ E_PROPERTY_GUN ] [ slot ], slot, Property [ property_enum_id ] [ E_PROPERTY_AMMO ] [ slot ], Property [ property_enum_id ] [ E_PROPERTY_ID ]
	) ;

	mysql_tquery ( mysql, query );

    ProxDetector(playerid, 15.0, COLOR_PURPLE, sprintf("** %s stores a %s in their property.", 
    	ReturnPlayerNameData(playerid, 0, true), gun_name));

	SendAdminMessage ( sprintf("[AdmMsg]: ** %s (%d) stores a %s in their property.", 
		ReturnPlayerNameData(playerid), playerid, gun_name));

	//printf("[PROPGUN] %s stored a %s (%d) (Ammo: %d) in their property (%d)", ReturnPlayerNameData(playerid), gun_name, gunid, Property [ property_enum_id ] [ E_PROPERTY_AMMO ][ slot ], Property [ property_enum_id ] [ E_PROPERTY_ID ]);

	//NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Stored a %s (%d) (Ammo: %d) in Property %d", gun_name, gunid, Property [ property_enum_id ] [ E_PROPERTY_AMMO ][ slot ], Property [ property_enum_id ] [ E_PROPERTY_ID ]));

	return true ;
}
