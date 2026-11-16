
Main_LoadDatabaseSettings() {

	inline Server_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {
			Server [ E_SERVER_SLOTS_JACKPOT ] = cache_get_field_int (0, "server_slots_jackpot");

			cache_get_field_content ( 0, "server_slots_motd_1", Server[ E_SERVER_MOTD_STRING_1 ], mysql, 96 ) ;
			cache_get_field_content ( 0, "server_slots_motd_2", Server [ E_SERVER_MOTD_STRING_2 ], mysql, 96 ) ;
			cache_get_field_content ( 0, "server_slots_motd_3", Server [ E_SERVER_MOTD_STRING_3 ], mysql, 96 ) ;
			cache_get_field_content ( 0, "server_motd_editor", Server [ E_SERVER_MOTD_EDITOR ], mysql, 24 ) ;
			Server [ E_SERVER_MOTD_EDIT_TIME ] = cache_get_field_int (0, "server_motd_edit_time");

			Server [ E_SERVER_CHOPSHOP_FACTIONID ] = cache_get_field_int (0, "server_chopshop_factionid");
			Server [ E_SERVER_CHOPSHOP_COLLECT ] = cache_get_field_int (0, "server_chopshop_collect");
			Server [ E_SERVER_ADMIN_HEX ] = cache_get_field_int (0, "server_admin_hex");
			Server [ E_SERVER_HELPER_HEX ] = cache_get_field_int (0, "server_helper_hex");


			Server [ E_SERVER_POLICE_KIOSK_X ] = cache_get_field_float (0, "police_kiosk_x");
			Server [ E_SERVER_POLICE_KIOSK_Y ] = cache_get_field_float (0, "police_kiosk_y");
			Server [ E_SERVER_POLICE_KIOSK_Z ] = cache_get_field_float (0, "police_kiosk_z");
			Server [ E_SERVER_POLICE_KIOSK_INT ] = cache_get_field_int (0, "police_kiosk_int");
			Server [ E_SERVER_POLICE_KIOSK_VW ] = cache_get_field_int (0, "police_kiosk_vw");
	
			Server [ E_SERVER_MEDIC_KIOSK_X ] = cache_get_field_float (0, "medic_kiosk_x");
			Server [ E_SERVER_MEDIC_KIOSK_Y ] = cache_get_field_float (0, "medic_kiosk_y");
			Server [ E_SERVER_MEDIC_KIOSK_Z ] = cache_get_field_float (0, "medic_kiosk_z");
			Server [ E_SERVER_MEDIC_KIOSK_INT ] = cache_get_field_int (0, "medic_kiosk_int");
			Server [ E_SERVER_MEDIC_KIOSK_VW ] = cache_get_field_int (0, "medic_kiosk_vw");

			Server [ E_SERVER_DEA_KIOSK_X ] = cache_get_field_float (0, "dea_kiosk_x");
			Server [ E_SERVER_DEA_KIOSK_Y ] = cache_get_field_float (0, "dea_kiosk_y");
			Server [ E_SERVER_DEA_KIOSK_Z ] = cache_get_field_float (0, "dea_kiosk_z");
			Server [ E_SERVER_DEA_KIOSK_INT ] = cache_get_field_int (0, "dea_kiosk_int");
			Server [ E_SERVER_DEA_KIOSK_VW ] = cache_get_field_int (0, "dea_kiosk_vw");

			Server [ E_SERVER_SHERIFF_KIOSK_X ] = cache_get_field_float (0, "sheriff_kiosk_x");
			Server [ E_SERVER_SHERIFF_KIOSK_Y ] = cache_get_field_float (0, "sheriff_kiosk_y");
			Server [ E_SERVER_SHERIFF_KIOSK_Z ] = cache_get_field_float (0, "sheriff_kiosk_z");
			Server [ E_SERVER_SHERIFF_KIOSK_INT ] = cache_get_field_int (0, "sheriff_kiosk_int");
			Server [ E_SERVER_SHERIFF_KIOSK_VW ] = cache_get_field_int (0, "sheriff_kiosk_vw");

			cache_get_field_content ( 0, "server_song_url", Server [ E_SERVER_SONG_URL ], mysql, 128 ) ;

			// 1: ucp, 0: dialogs
			Server [ E_SERVER_REGISTRATION_UCP ] = cache_get_field_int (0, "registration_ucp");


			Kiosk_LoadEntities () ;
		}
	}

	mysql_tquery_inline ( mysql, "SELECT * FROM server", using inline Server_OnDataLoad, "" ) ;

	//Server [ E_SERVER_RC_ENABLED ] = true ;
	Server [ E_SERVER_DC_ENABLED ] = true ;
	Server [ E_SERVER_SC_ENABLED ] = true ;
	Server [ E_SERVER_UPTIME ] = gettime () ; 
}

Main_LoadServerSettings() {
	//ImportGrandLarcenyVehicles();

    DisableInteriorEnterExits() ; 
    AllowInteriorWeapons(false);
    SetNameTagDrawDistance(20.0);

	DisableNameTagLOS() ;
	ShowNameTags(false); // handles custom name script

	ShowPlayerMarkers ( PLAYER_MARKERS_MODE_OFF );
	SetGameModeText(SERVER_MODE);

	// Because SOLS uses special characters that go lost when encoding, we don't use this...
	SendRconCommand("hostname   "SERVER_HOSTNAME"");
	SendRconCommand("mapname 	"SERVER_MAP"	");
	SendRconCommand("weburl 	"SERVER_WEBSITE"");
}

Main_LoadStaticModels() {
	

	AddSimpleModel(-1, 1337, -29993, "dignity/champagne_bottle.dff", "dignity/champagne_bottle.txd");
	AddSimpleModel(-1, 1337, -29994, "phone.dff", "phone_nice.txd");
	AddSimpleModel(-1, 1337, -29995, "phone.dff", "phone.txd");
	AddSimpleModel(-1, 1337, -29996, "sprite_model.dff", "newgen.txd");

	AddSimpleModel(-1, 1923, -29997, "sprite_model.dff", "speedometer.txd");
	AddSimpleModel(-1, 1923, -29998, "sprite_model.dff", "nosmeter.txd");
	AddSimpleModel(-1, 1923, -29999, "sprite_model.dff", "fuelmeter.txd");

	AddSimpleModel(-1, 1923, -29000, "spraytag_vla.dff", "spraytag_vla.txd");
	AddSimpleModel(-1, 1923, -29001, "spraytag_tdf.dff", "spraytag_tdf.txd");

	AddSimpleModel(-1, 1337, -29010, "sprite_model.dff", "dltd.txd");
}