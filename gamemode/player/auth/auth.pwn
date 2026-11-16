
timer LoginWindow[1000](playerid, error_type) {
	SetPlayerInterior ( playerid, 0 );
	SetPlayerVirtualWorld ( playerid, 0 );

	//PlayerTextDrawShow(playerid, dltd[playerid]); //disable this for now to avoid headaches caused by logout

	// Maybe add a random swithc here like with old script!
	// SetPlayerCameraPos(playerid, 932.4440, -1134.0135, 55.3758);
	// SetPlayerCameraLookAt(playerid, 931.7225, -1133.3167, 55.0355

	//SetPlayerCameraPos(playerid, 2372.8328, -1397.9767, 68.7813);
	//SetPlayerCameraLookAt(playerid, 2372.1868, -1398.7446, 68.5212);

	//SetPlayerCameraPos(playerid, -30.9498, 1547.0497, 15.0286);
	//SetPlayerCameraLookAt(playerid, -30.0278, 1547.4324, 15.1486);

	//SetPlayerTime(playerid, 14, 30);

	//SetPlayerCameraPos(playerid, -34.4887, 1546.5784, 14.4010);
	//SetPlayerCameraLookAt(playerid, -33.5192, 1546.8405, 14.7060);

	//SetPlayerCameraPos(playerid, 2811.2034, -2101.7495, 72.4520);
	//SetPlayerCameraLookAt(playerid, 2810.5657, -2100.9695, 72.0470);

	//SetPlayerCameraPos(playerid, 2030.1835, -1823.6749, 35.0575);
	//SetPlayerCameraLookAt(playerid, 2029.4598, -1822.9767, 34.8476);
	
	//SetPlayerCameraPos(playerid, 2119.7529, -1867.0454, 39.2893);
	//SetPlayerCameraLookAt(playerid, 2119.0151, -1867.7268, 39.0541);
	//SetPlayerCameraPos(playerid, 2542.6013, -1499.0409, 32.4737);
	//SetPlayerCameraLookAt(playerid, 2542.1682, -1499.9508, 32.2888);

	//SetPlayerCameraPos(playerid, 2194.8206, -2157.0564, 52.9281);
	//SetPlayerCameraLookAt(playerid, 2195.8088, -2156.9148, 52.5832);

	// Mall
	//SetPlayerCameraPos(playerid, 1673.35, -1760.04, 40.28);
	//SetPlayerCameraLookAt(playerid, 1676.93, -1756.66, 39.40);

	// Pecado Hill View
	//SetPlayerCameraPos(playerid, 1897.7930, -1786.9674, 58.6179);
	//SetPlayerCameraLookAt(playerid, 1896.9960, -1787.5785, 58.4430);

	// Ganton Bridge to East LS/San Pedro View
	//SetPlayerCameraPos(playerid, 2585.18, -1671.68, 33.94);
	//SetPlayerCameraLookAt(playerid, 2582.25, -1667.63, 33.90);

	// Downtown View
	//SetPlayerCameraPos(playerid, 1271.68, -1558.19, 160.66);
	//SetPlayerCameraLookAt(playerid, 1275.01, -1554.45, 160.74);

	// El Pecado New View
	//SetPlayerCameraPos(playerid, 1651.10, -2078.49, 78.76);
	//SetPlayerCameraLookAt(playerid, 1653.73, -2074.44, 77.46);

	// El Pecado 2
	//SetPlayerCameraPos(playerid, 1803.57, -1840.09, 55.98);
	//SetPlayerCameraLookAt(playerid, 1799.88, -1843.46, 55.78);

	// Westside
	SetPlayerCameraPos(playerid, 1125.55, -1014.51, 121.43);
	SetPlayerCameraLookAt(playerid, 1128.55, -1018.49, 121.02);

	PlayerVar[playerid][E_PLAYER_CREATING_CHAR] = false;
	PlayerVar[playerid][E_PLAYER_FIRST_SPAWN] = true;
	Account[playerid][E_PLAYER_ACCOUNT_NAMESTYLE] = 1; // :sunglasses:

	inline LoginForm(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, response, listitem, inputtext

		new query [ 512 ] ;

		if ( ! response ) {

			Kick ( playerid ) ;
		}

		else if ( response  ) {

			mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM accounts WHERE account_name = '%e'", TEMP_ReturnPlayerName(playerid) ) ;

			inline AccountCheck() {

				new rows, fields ;
				cache_get_data ( rows, fields, mysql ) ;

				if ( rows ) {

					Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ]	= cache_get_field_int ( 0, "account_id" ) ;

					// Account [ playerid ] [ E_PLAYER_ACCOUNT_NAMESTYLE ]	= cache_get_field_int ( 0, "account_namestyle" ) ;

					cache_get_field_content ( 0, "account_name", 	 Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], mysql, MAX_PLAYER_NAME ) ;
					cache_get_field_content ( 0, "account_password", Account [ playerid ] [ E_PLAYER_ACCOUNT_PASSWORD ], mysql, MAX_PASSWORD_LENGTH ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = cache_get_field_int ( 0, "account_supporter" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] 	= cache_get_field_int ( 0, "account_stafflevel" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] 	= cache_get_field_int ( 0, "account_contributor" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_PREMIUMLEVEL]    = cache_get_field_int ( 0, "account_premiumlevel" ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_REPORTS_DONE ] =  cache_get_field_int ( 0, "account_reports_done" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ] =  cache_get_field_int ( 0, "account_questions_done" ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNACCESS ] =  cache_get_field_int ( 0, "account_gunaccess" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNBAN ] =  cache_get_field_int ( 0, "account_gunban" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_VEHBAN ] =  cache_get_field_int ( 0, "account_vehban" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_BIKEBAN ] =  cache_get_field_int ( 0, "account_bikeban" ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_RESPECTED ] =  cache_get_field_int ( 0, "account_respected" ) ;

					cache_get_field_content ( 0, "account_forumname",		Account [ playerid ] [ E_PLAYER_ACCOUNT_FORUMNAME ], mysql, MAX_PLAYER_NAME ) ;
					cache_get_field_content ( 0, "account_discordname",		Account [ playerid ] [ E_PLAYER_ACCOUNT_DISCORDNAME ], mysql, MAX_PLAYER_NAME ) ;
					cache_get_field_content ( 0, "account_email",	 		Account [ playerid ] [ E_PLAYER_ACCOUNT_EMAIL ], mysql, 256 ) ;
					
					Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_TIPS ] =  cache_get_field_int ( 0, "account_setting_tips" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_GZES ] =  cache_get_field_int ( 0, "account_setting_gangzones" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_BLNK ] =  cache_get_field_int ( 0, "account_setting_blinkers" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_DRAW ] =  cache_get_field_int ( 0, "account_setting_drawdistance" ) ;
					Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, Account[playerid][E_PLAYER_ACCOUNT_SETTINGS_DRAW], playerid);

					Account [ playerid ] [ E_PLAYER_ACCOUNT_REWARD_AMOUNT]    = cache_get_field_int ( 0, "account_reward_amount" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_REWARD_CLAIMED]    = cache_get_field_int ( 0, "account_reward_claimed" ) ;
					Account [ playerid ] [ E_PLAYER_ACCOUNT_REWARD_CLAIMED]    = cache_get_field_int ( 0, "account_reward_claimed" ) ;

					cache_get_field_content ( 0, "account_reward_ipaddress", Account [ playerid ] [ E_PLAYER_ACCOUNT_REWARD_IP ], mysql, 64 ) ;
					Account [ playerid ] [ E_PLAYER_SETTING_NAMESTYLE ] = cache_get_field_int ( 0, "account_name_style" );
					Account [ playerid ] [ E_PLAYER_REGISTER_DATE ] = cache_get_field_int ( 0, "account_register_date" );
					Account [ playerid ] [ E_PLAYER_REGISTER_LEGACY ] = cache_get_field_int ( 0, "account_registration_legacy" );

					Account [ playerid ] [ E_ACCOUNT_SETTINGS_ADMIN_CMD ] =  cache_get_field_int ( 0, "account_setting_admin_cmd" ) ;
					Account [ playerid ] [ E_ACCOUNT_SETTINGS_ADMIN_WRN ] =  cache_get_field_int ( 0, "account_setting_admin_wrn" ) ;
					Account [ playerid ] [ E_ACCOUNT_SETTINGS_ADMIN_MSG ] =  cache_get_field_int ( 0, "account_setting_admin_msg" ) ;
					Account [ playerid ] [ E_ACCOUNT_SETTINGS_HELPER_MSG ] =  cache_get_field_int ( 0, "account_setting_helper_msg" ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFROLE ] =  E_ADMIN_ROLE:cache_get_field_int ( 0, "account_staffrole" ) ;

					SetPVarInt(playerid, "Used_logout", false);
					//SetPlayerColor(playerid, 0xDEDEDEFF);

					// Adding a fix for spec!
					Character [ playerid ] [ E_CHARACTER_MOLE ] = INVALID_PLAYER_ID ;
					PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = INVALID_PLAYER_ID ;	
					PlayerVar [ playerid ] [ E_PLAYER_LISTEN ] = INVALID_PLAYER_ID ;
					PlayerVar [ playerid ] [ E_PLAYER_CHOSE_CHARACTER ] = false ;
					Character [ playerid ] [ E_CHARACTER_ID ] = -1 ;


					GangZone_ShowForPlayer(playerid);

					bcrypt_verify(playerid, "Account_OnBcryptVerify", inputtext, Account [ playerid ] [ E_PLAYER_ACCOUNT_PASSWORD ], "d", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
				}

				else if ( ! rows ) {


					// UCP registration is disabled. Allow ingame registration:
					if(!Server [ E_SERVER_REGISTRATION_UCP ]) {
						if (Server[E_SERVER_ACCS_DISABLED_UNTIL] && gettime() < Server[E_SERVER_ACCS_DISABLED_UNTIL])
						{
							SendClientMessage(playerid, COLOR_ERROR, "Sorry, new account registration has been temporarily disabled by an administrator.");
							SendClientMessage(playerid, COLOR_GRAD1, "Registrations will automatically reopen soon, so try again later!");
							KickPlayer(playerid);
							return true ;
						}

						if ( strlen ( inputtext ) < MIN_PASSWORD_LENGTH ) {

							SendClientMessage(playerid, COLOR_ERROR, "Your password must be at least 4 characters long.");
							LoginWindow(playerid, AUTH_MSG_DEFAULT);
							return true ;
						}

						bcrypt_hash(playerid, "Account_OnRegisterHash", inputtext, BCRYPT_COST ) ;
					}

					else if(Server [ E_SERVER_REGISTRATION_UCP ]) {

						SendUCPMessage(playerid) ;
						KickPlayer(playerid);					
					}
				}
			}

			mysql_tquery_inline ( mysql, query, using inline AccountCheck, "" ) ;
		}
		return true ;
	}

	new string [ 768 ] ;

	format ( string, sizeof ( string ), "{FFFFFF}Welcome to {ed7a34}%s{DEDEDE}, {FFFFFF}%s!\n\n\
		{DEDEDE}Failure to authenticate three times will result in a {E03232}kick{DEDEDE}.\nYou have a total of {EEC650}three minutes{DEDEDE} to authenticate.\n\n",
		SERVER_NAME, TEMP_ReturnPlayerName(playerid) ) ;

	switch ( error_type ) {

		case AUTH_MSG_DEFAULT: strcat ( string, "In order to proceed, enter a {EEC650}password{DEDEDE} below to authenticate (or register)."); // please enter your password below
		case AUTH_MSG_WRONG_PASS: strcat ( string, "The password you have entered is {E03232}incorrect{DEDEDE}. Please try again."); // the password you entered is incorrect
	}

	// if login attempts != 0, show login attempts
	// add timer here to kick player if no log in after x amount of time

	Dialog_ShowCallback ( playerid, using inline LoginForm, DIALOG_STYLE_PASSWORD, "Welcome to the server - please enter a password below", string, "Proceed", "Cancel" ) ;

	return true ;
}

Login_WrongPassword(playerid) {

	Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = 0 ;
	Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] = 0 ;
	Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = 0 ;
	Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFROLE ] = ADMIN_ROLE_NONE ;

	if ( ++ PlayerVar [ playerid ] [ E_PLAYER_LOGIN_FAILS ] >= 3 ) {

		KickPlayer(playerid);
		return true ;
	}

	LoginWindow(playerid, AUTH_MSG_WRONG_PASS);
	PlayerVar [ playerid ] [ player_islogged ] = false ;

	return true ;
}

Login_Succeeded(playerid) {

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET `account_lastip` = '%e', `account_lastlogin` = CURRENT_TIMESTAMP WHERE `account_id` = %d",
		ReturnIP(playerid), Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] );
	mysql_tquery(mysql, query);

	PlayerVar [ playerid ] [ player_islogged ] = true ;
	PlayerVar [ playerid ] [ player_isregistered ] = true ;

	//PlayerTextDrawHide(playerid, dltd[playerid]);

	if(Account [ playerid ] [ E_PLAYER_REGISTER_LEGACY ] == 0 ) {
		CheckUCPStatus ( playerid ) ;
	}
	else {

		BanChecker ( playerid ) ;
	}

	return true ;
}

forward Account_OnBcryptVerify(playerid, bool:success, accountid);
public Account_OnBcryptVerify(playerid, bool:success, accountid) {

	if ( ! IsPlayerConnected(playerid) || IsPlayerLogged(playerid) || Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] != accountid ) {

		return true ;
	}

	if ( ! success ) {

		return Login_WrongPassword(playerid);
	}

	return Login_Succeeded(playerid);
}

forward Account_OnRegisterHash(playerid, hashid);
public Account_OnRegisterHash(playerid, hashid) {
	#pragma unused hashid

	if ( ! IsPlayerConnected(playerid) ) {

		return true ;
	}

	new query [ 512 ], password [ MAX_PASSWORD_LENGTH ] ;

	bcrypt_get_hash(password);

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO accounts (account_name, account_password, account_salt, account_registration_legacy) VALUES ('%e', '%e', '', 1)",
		TEMP_ReturnPlayerName(playerid), password ) ;

	inline OnAccountRegister() {

		//SetPlayerColor(playerid, 0xDEDEDEFF);

		Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] = cache_insert_id ();
		Account [ playerid ] [ E_PLAYER_REGISTER_LEGACY ] = 1 ;
		//printf("Created account %s (%d) with ID %d.", ReturnPlayerNameData ( playerid ), playerid, Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;

		Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] [ 0 ] = EOS ;
		strcat(Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], TEMP_ReturnPlayerName(playerid));

		PlayerVar [ playerid ] [ player_islogged ] = true ;
		PlayerVar [ playerid ] [ player_isregistered ] = false ;

		// SendClientMessage(playerid, -1, "You registered.");
		NewPlayer_CountRegistrations(playerid);

				query [ 0 ] = EOS ;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_GZES ] = 0 ;

				mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET account_setting_gangzones = %d WHERE account_id = %d",
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_GZES ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ]) ;

				mysql_tquery(mysql, query);


		Account_DisplayCharacters(playerid) ;
	}
	mysql_tquery_inline(mysql, query, using inline OnAccountRegister, "");

	return true ;
}

timer LoginTimeout[180000](playerid, started) {

	if ( ! IsPlayerConnected(playerid) || IsPlayerLogged(playerid) || PlayerVar [ playerid ] [ E_PLAYER_LOGIN_STARTED ] != started ) {

		return true ;
	}

	KickPlayer(playerid);
	return true ;
}

static CharNameDlgStr[1024];

// mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO accounts (Character_name, Character_rentedhouse, Character_health) VALUES ('%e', '%e', '%e', '%d', '%d', '-1', '100.0')",
Account_CharacterCreation ( playerid, error = 0 ) {

	inline CharacterCreation(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, response, listitem, inputtext

		if ( ! response ) 
		{
			// Take them back
			SOLS_ShowCharSelection(playerid, 0, false);
			return true ;
		}

		if ( response ) {

			if ( strlen ( inputtext ) < 6 || strlen ( inputtext ) > MAX_PLAYER_NAME ) {

				//SendClientMessage(playerid, COLOR_ERROR, sprintf("Your name can't be less than 6 characters or more than %d!", MAX_PLAYER_NAME ) );
				Account_CharacterCreation ( playerid, 1 );

				return true ;
			}

			if ( ! IsRPNameRegex(inputtext) ) {

				//SendClientMessage(playerid, COLOR_ERROR, "The name you entered isn't valid. Try again and make sure you include the underscore." );
				Account_CharacterCreation ( playerid, 2 );

				return true ;
			}

			new query [ 96 ] ;
			mysql_format ( mysql, query, sizeof ( query ), "SELECT * FROM characters WHERE player_name = '%e'", inputtext);
			mysql_tquery(mysql, query, "Account_CheckPlayerName", "is", playerid, inputtext);
		}
	}

	CharNameDlgStr[0] = EOS;
	strcat(CharNameDlgStr, "{FFFFFF}You are about to create a new {5DB6E5}Player Character{FFFFFF}.");

	strcat(CharNameDlgStr, "\n\n{FFFFFF}Please read the following information:{ADBEE6}");
	strcat(CharNameDlgStr, "\n- Names must follow the Firstname_Lastname format (including the underscore).");
	strcat(CharNameDlgStr, "\n- Characters should be fictional, do not use famous, or recognizeable real-life names.");
	strcat(CharNameDlgStr, "\n- After entering a name, you will be able to select your character and complete their profile.\n\n");

	if (error == 1) strcat(CharNameDlgStr, sprintf("{FF0000}Names must be between 6 and %d characters in length.\n", MAX_PLAYER_NAME));
	else if (error == 2) strcat(CharNameDlgStr, "{FF0000}The name you entered wasn't in the correct format (Firstname_Lastname).\n");
	else if (error == 3) strcat(CharNameDlgStr, "{FF0000}Sorry, this character name is already taken by another player.\n");

	strcat(CharNameDlgStr, "{FFFFFF}Enter a name for your character and press {AA3333}OK{FFFFFF} to continue.");
	Dialog_ShowCallback ( playerid, using inline CharacterCreation, DIALOG_STYLE_INPUT, "Create New Character", CharNameDlgStr, "OK", "Back" );


	return true ;
}

forward Account_CheckPlayerName(playerid, string: name[]) ;
public Account_CheckPlayerName(playerid, string: name[]) {

	if ( ! IsPlayerConnected(playerid) || ! IsPlayerLogged(playerid) ) {

		return true ;
	}

	new rows, fields ;
	cache_get_data ( rows, fields, mysql ) ;

	if ( rows ) {

		//SendClientMessage(playerid, COLOR_ERROR, sprintf("The name \"%s\" already exists. Choose a different one!", name ) ) ;
		Account_CharacterCreation ( playerid, 3 );

		return true ;
	}

	else if ( ! rows ) {

		new query [ 1024 ] ;

		Character [ playerid ] [ E_CHARACTER_NAME ] [ 0 ] = EOS ;
		strcat(Character [ playerid ] [ E_CHARACTER_NAME ], name);
		Character [ playerid ] [ E_CHARACTER_SKINID ] = 264 ;

		Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ] = -1 ;
		Character [ playerid ] [ E_CHARACTER_PROPERTYSPAWN ] = -1 ;
		Character [ playerid ] [ E_CHARACTER_HEALTH ] = 100.0 ;

		mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO characters (player_name, account_id, player_skinid, player_health, player_fat, player_muscle, player_stamina, player_spawnproperty) VALUES ('%e', %d, %d, '100.0', '400.0', '400.0', '400.0', '-1')",
		Character [ playerid ] [ E_CHARACTER_NAME ], Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], Character [ playerid ] [ E_CHARACTER_SKINID ] ) ;

		Gym_SetupDefaultVariables(playerid);

		inline OnCharacterRegister() {

			Character [ playerid ] [ E_CHARACTER_ID ] = cache_insert_id ();

			/*
			SendClientMessage(playerid, COLOR_BLUE, sprintf("Created character \"%s\" with ID %d.",
				Character [ playerid ] [ E_CHARACTER_NAME ], Character [ playerid ] [ E_CHARACTER_ID ] ) ) ;
			*/

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_registerdate = %d WHERE player_id = %d",
				gettime(), Character [ playerid ] [ E_CHARACTER_ID ] ) ;
			mysql_tquery(mysql, query, "", "");

			Character [ playerid ] [ E_CHARACTER_HUD_TRADEMARK] = true ;
			Character [ playerid ] [ E_CHARACTER_HUD_VEH_FADEIN] = true ;
			Character [ playerid ] [ E_CHARACTER_HUD_VEHICLE] 	= true ;
			Character [ playerid ] [ E_CHARACTER_HUD_TERRITORY] = true ;
			Character [ playerid ] [ E_CHARACTER_VOICELINE_SOUND] = true ;
			Character [ playerid ] [ E_CHARACTER_HUD_MINIGAME ] = true ;
			Character [ playerid ] [ E_CHARACTER_HUD_CLOCK ] = true ;

			switch ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {

				// Dignity PMs blocked
				case 1: PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ] = true ;
			}

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_hud_territory = 1, player_hud_vehfadein = 1, player_hud_trademark = 1, player_hud_vehicle = 1, player_hud_voicelines = 1, player_hud_minigame = 1, player_hud_clock=1 WHERE player_id = %d",
				Character [ playerid ] [ E_CHARACTER_ID ]) ;
			mysql_tquery(mysql, query);


			Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ] = FIGHT_STYLE_NORMAL ;
			SetPlayerFightingStyle(playerid, Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ]);

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_fightstyle = %d WHERE player_id = %d",
				Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ], Character [ playerid ] [ E_CHARACTER_ID ]) ;
			mysql_tquery(mysql, query);
		}

		mysql_tquery_inline(mysql, query, using inline OnCharacterRegister, "");


		defer Account_DisplayCharacters(playerid) ;

		return true ;
	}

	return true ;
}

GetCharacterCount(playerid) {


	return PlayerVar [ playerid ] [ E_PLAYER_CHARACTER_FOUND ] ;
}

timer Account_DisplayCharacters[500](playerid) {

	if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {

		SendClientMessage(playerid, -1, "Tried fetching characters, but your account ID isn't valid. Please relog.");
		defer LoginWindow[1000](playerid, AUTH_MSG_DEFAULT);
		return false ;
	}

	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	// SetPlayerTime(playerid, Server [ E_SERVER_TIME_HOURS], Server [ E_SERVER_TIME_MINUTES]);

	inline E_CHECK_PLAYER_CHARACTERS() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		PlayerVar [ playerid ] [ E_PLAYER_CHARACTER_FOUND ] = 0;

		if ( ! rows ) {

			//SendClientMessage(playerid, -1, "No characters to show!");
			//Account_CharacterCreation(playerid);

			// NEW: Show them the normal char select screen
			SOLS_ShowCharSelection(playerid, 0);

			return true ;
		}

		else if ( rows ) {

			new name [ 24 ] ;

			for_loop ( new i; i < rows; i ++ ) {

				cache_get_field_content ( i, "player_name", name, mysql, MAX_PLAYER_NAME ) ;
		
				if ( i >= MAX_CHARACTERS) {

					SendClientMessage(playerid, COLOR_RED, sprintf("Tried loading character \"%s\", but you've passed your character limit! It's unusable!", name ) ) ;
					continue ;
				}

				// Core data
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_ID ]	= cache_get_field_int ( i, "player_id" ) ;
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_ACC_ID ]	= cache_get_field_int ( i, "account_id" ) ;

				format ( CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_NAME ], MAX_PLAYER_NAME, "%s", name ) ;
				format ( CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_RP_NAME ], MAX_PLAYER_NAME, "%s", name ) ;
				strreplace(CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_RP_NAME ], "_", " ");

				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_SKIN ]	= cache_get_field_int ( i, "player_skinid" ) ;

				// Custom selection stuff
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_FACTION_ID ] = cache_get_field_int ( i, "player_factionid" ) ;
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_FACTION_TIER ] = cache_get_field_int ( i, "player_factiontier" ) ;
				cache_get_field_content ( i, "player_factionrank", CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_FACTION_RANK ], mysql, 64 ) ;
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_HOURS_PLAYED ] = cache_get_field_int ( i, "player_hours" ) ;
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_LAST_LOGIN ] = cache_get_field_int ( i, "player_logindate" ) ;
				//cache_get_field_content ( i, "login_date_str", CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_LAST_LOGIN_STR ], mysql, 32 ) ;

				

				// Hitman lockout
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_HITMAN_KILLED ] = cache_get_field_int ( i, "player_hitman_killed" ) ;
				CharacterBuffer [ playerid ] [ i ] [ E_CHAR_BUFFER_HITMAN_UNLOCKED ] = cache_get_field_int ( i, "player_hitman_unlocked" ) ;


				// For the selection script so we can use this value cross value.
				PlayerVar [ playerid ] [ E_PLAYER_CHARACTER_FOUND ] ++ ;
			}

			//PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] = 0 ;
			//Select_StartCharacterSelection(playerid, PlayerClassSelection [ playerid ] [ E_PLAYER_CLASS_SEL_CHARID ] );
			//SendClientMessage(playerid, -1, "Found character!");

			SOLS_ShowCharSelection(playerid, 0);
		}
	}

	mysql_tquery_inline ( mysql, sprintf("SELECT * FROM `characters` WHERE `account_id` = %d", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ]), using inline E_CHECK_PLAYER_CHARACTERS, "" ) ;

	return true ;
}

forward SOLS_OnLoadCharacter(playerid, character_id);
public SOLS_OnLoadCharacter(playerid, character_id)
{
	UpdatePlayerNameCache(playerid);

	// You can hook this :)
	return 1;
}

Account_LoadCharacterData(playerid, character_id) {

	new query [ 512 ] ; 

	inline E_FETCH_PLAYER_CHARACTER() {
		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows && IsPlayerConnected(playerid) && IsPlayerLogged(playerid) && cache_get_field_int ( 0, "account_id" ) == Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) {

			Character [ playerid ] [ E_CHARACTER_ID ] = cache_get_field_int ( 0, "player_id" ) ;
			Character [ playerid ] [ E_CHARACTER_ACCOUNT_ID ] = cache_get_field_int ( 0, "account_id" ) ;

			cache_get_field_content ( 0, "player_name", Character [ playerid ] [ E_CHARACTER_NAME ], mysql, MAX_PLAYER_NAME ) ;

			cache_get_field_content ( 0, "player_uniqueid", Character [ playerid ] [ E_CHARACTER_UNIQUEID ], mysql, MAX_UNIQUE_ID_LENGTH ) ;
			cache_get_field_content ( 0, "player_ip", Character [ playerid ] [ E_CHARACTER_IP ], mysql, MAX_UNIQUE_ID_LENGTH ) ;


	 		Character [ playerid ] [ E_CHARACTER_REGISTERED ] = cache_get_field_int ( 0, "player_registered" ) ;

			Character [ playerid ] [ E_CHARACTER_LAST_POS_X ]	= cache_get_field_float ( 0, "player_last_pos_x" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_POS_Y ]	= cache_get_field_float ( 0, "player_last_pos_y" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_POS_Z ]	= cache_get_field_float ( 0, "player_last_pos_z" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_POS_A ]	= cache_get_field_float ( 0, "player_last_pos_a" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_POS_INT ] = cache_get_field_int ( 0, "player_last_pos_int" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_POS_VW ]  = cache_get_field_int ( 0, "player_last_pos_vw" ) ;

			Character [ playerid ] [ E_CHARACTER_SKINID ]			= cache_get_field_int ( 0, "player_skinid" ) ;
			Character [ playerid ] [ E_CHARACTER_CHAT_STYLE ]			= cache_get_field_int ( 0, "player_chatstyle" ) ;

 			Character [ playerid ] [ E_CHARACTER_FACTIONID ]			= cache_get_field_int ( 0, "player_factionid" ) ;
			Character [ playerid ] [ E_CHARACTER_FACTIONTIER ]			= cache_get_field_int ( 0, "player_factiontier" ) ;
			cache_get_field_content ( 0, "player_factionrank", Character [ playerid ] [ E_CHARACTER_FACTIONRANK ], mysql, 64 ) ;
			Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ]			= cache_get_field_int ( 0, "player_factionsquad" ) ;
			Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ]			= cache_get_field_int ( 0, "player_factionbadge" ) ;
			Character [ playerid ] [ E_CHARACTER_FACTION_SUSPENSION ]			= cache_get_field_int ( 0, "player_factionsuspension" ) ;

 			Character [ playerid ] [ E_CHARACTER_OUTSTANDING_FINES ]	= cache_get_field_int ( 0, "player_outstanding_fines" ) ;

			Character [ playerid ] [ E_CHARACTER_ARREST_TIME ] = cache_get_field_int ( 0, "player_arrest_time" ) ;
			Character [ playerid ] [ E_CHARACTER_ARREST_X ] =  cache_get_field_float ( 0, "player_arrest_x" ) ;
			Character [ playerid ] [ E_CHARACTER_ARREST_Y ] =  cache_get_field_float ( 0, "player_arrest_y" ) ;
			Character [ playerid ] [ E_CHARACTER_ARREST_Z ] =  cache_get_field_float ( 0, "player_arrest_z" ) ;
			Character [ playerid ] [ E_CHARACTER_ARREST_VW ] = cache_get_field_int ( 0, "player_arrest_vw" ) ;
			Character [ playerid ] [ E_CHARACTER_ARREST_INT ] = cache_get_field_int ( 0, "player_arrest_int" ) ;

			Character [ playerid ] [ E_CHARACTER_CASH ] 			= cache_get_field_int ( 0, "player_cash" ) ;
			Character [ playerid ] [ E_CHARACTER_BANKCASH ] 		= cache_get_field_int ( 0, "player_bankcash" ) ;
			Character [ playerid ] [ E_CHARACTER_SAVINGS ] 			= cache_get_field_int ( 0, "player_savings" ) ;

			Character [ playerid ] [ E_CHARACTER_PAYCHECK ] 		= cache_get_field_int ( 0, "player_paycheck" ) ;
			Character [ playerid ] [ E_CHARACTER_LEVEL ] = cache_get_field_int ( 0, "player_level" ) ;
			SetPlayerScore(playerid, Character [ playerid ] [ E_CHARACTER_LEVEL ] ) ;
			Character [ playerid ] [ E_CHARACTER_HOURS ] = cache_get_field_int ( 0, "player_hours" ) ;
			Character [ playerid ] [ E_CHARACTER_EXP ] = cache_get_field_int ( 0, "player_exp" ) ;

			Character [ playerid ] [ E_CHARACTER_REGISTERDATE ]	= cache_get_field_int ( 0, "player_registerdate" ) ;
			Character [ playerid ] [ E_CHARACTER_LOGINDATE ]	= cache_get_field_int ( 0, "player_logindate" ) ;

			// Inventory
			Character [ playerid ] [ E_CHARACTER_DRIVERSLICENSE ] = cache_get_field_int ( 0, "player_driverslicense" ) ;
			//Character [ playerid ] [ E_CHARACTER_GUNLICENSE ] = cache_get_field_int ( 0, "player_gunlicense" ) ;

			Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ] = cache_get_field_int ( 0, "player_phnumber" ) ;
			Character [ playerid ] [ E_CHARACTER_PHONE_COLOUR ] = cache_get_field_int ( 0, "player_phcolour" ) ;
			Character [ playerid ] [ E_CHARACTER_PHONE_BACKGROUND ] = cache_get_field_int ( 0, "player_phbg" ) ;
			Character [ playerid ] [ E_CHARACTER_PHONE_CREDIT ] = cache_get_field_int ( 0, "player_phcredit" ) ;
			Character [ playerid ] [ E_CHARACTER_PHONE_BATTERY ] = cache_get_field_int ( 0, "player_phbattery" ) ;

			Character [ playerid ] [ E_CHARACTER_HEALTH ]	= cache_get_field_float ( 0, "player_health" ) ;
			Character [ playerid ] [ E_CHARACTER_ARMOUR ]	= cache_get_field_float ( 0, "player_armour" ) ;

			Character [ playerid ] [ E_CHARACTER_SOLD_PROPERTY ] = cache_get_field_int ( 0, "player_soldproperty" ) ;
			Character [ playerid ] [ E_CHARACTER_SOLD_FUELSTATION ] = cache_get_field_int ( 0, "player_soldfuelstation" ) ;
			Character [ playerid ] [ E_CHARACTER_SOLD_FURNITURE ] = cache_get_field_int ( 0, "player_soldfurni" ) ;


			Character [ playerid ] [ E_CHARACTER_RENTEDHOUSE ]  = cache_get_field_int ( 0, "player_rentroom" ) ;
			Character [ playerid ] [ E_CHARACTER_PROPERTYSPAWN ]  		= cache_get_field_int ( 0, "player_spawnproperty" ) ;

			Character [ playerid ] [ E_CHARACTER_MASKID ] 				=  cache_get_field_int ( 0, "player_maskid" ) ;

			Character [ playerid ] [ E_CHARACTER_HUD_DIRECTION ]		=  cache_get_field_int ( 0, "player_hud_direction" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_VEH_FADEIN]		=  cache_get_field_int ( 0, "player_hud_vehfadein" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_TRADEMARK] 		=  cache_get_field_int ( 0, "player_hud_trademark" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_VEHICLE] 			=  cache_get_field_int ( 0, "player_hud_vehicle" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_TERRITORY] 		=  cache_get_field_int ( 0, "player_hud_territory" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_MINIGAME] 		=  cache_get_field_int ( 0, "player_hud_minigame" ) ;
			Character [ playerid ] [ E_CHARACTER_HUD_CLOCK] 		=  cache_get_field_int ( 0, "player_hud_clock" ) ;

			Character [ playerid ] [ E_CHARACTER_BLUNT_STRAIN ] 		=  cache_get_field_int ( 0, "player_blunt_strain" ) ;
			Character [ playerid ] [ E_CHARACTER_BLUNT_PROGRESS ] 		=  cache_get_field_int ( 0, "player_blunt_progress" ) ;

			Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ] 	=  cache_get_field_int ( 0, "player_bandage_cd" ) ;
			Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] 		=  cache_get_field_int ( 0, "player_last_bandage_cd" ) ;

			Character [ playerid ] [ E_CHARACTER_HELPUP_CD ] 		=  cache_get_field_int ( 0, "player_helpup_cd" ) ;
			Character [ playerid ] [ E_CHARACTER_HEAL_CD ] 		=  cache_get_field_int ( 0, "player_heal_cd" ) ;

			Character [ playerid ] [ E_CHARACTER_AJAIL_TIME ]		=  cache_get_field_int ( 0, "player_ajail_time" ) ;
			cache_get_field_content ( 0, "player_oajail_reason", Character [ playerid ] [ E_CHARACTER_OAJAIL_REASON ], mysql, 64 ) ;
			cache_get_field_content ( 0, "player_oajail_admin", Character [ playerid ] [ E_CHARACTER_OAJAIL_ADMIN ], mysql, 24 ) ;

			Character [ playerid ] [ E_CHARACTER_GD_WOOD ] =  cache_get_field_int ( 0, "player_gd_wood" ) ;
			Character [ playerid ] [ E_CHARACTER_GD_METAL ] =  cache_get_field_int ( 0, "player_gd_metal" ) ;
			Character [ playerid ] [ E_CHARACTER_GD_PARTS ] =  cache_get_field_int ( 0, "player_gd_parts" ) ;

			Character [ playerid ] [ E_CHARACTER_TUTORIAL ] =  cache_get_field_int ( 0, "player_tutorial" ) ;


			Character [ playerid ] [ E_CHARACTER_AMMO_A ]	=  cache_get_field_int ( 0, "player_ammo_a" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_B ]	=  cache_get_field_int ( 0, "player_ammo_b" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_C ]	=  cache_get_field_int ( 0, "player_ammo_c" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_D ]	=  cache_get_field_int ( 0, "player_ammo_d" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_E ]	=  cache_get_field_int ( 0, "player_ammo_e" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_F ]	=  cache_get_field_int ( 0, "player_ammo_f" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_G ]	=  cache_get_field_int ( 0, "player_ammo_g" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_H ]	=  cache_get_field_int ( 0, "player_ammo_h" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_I ]	=  cache_get_field_int ( 0, "player_ammo_i" ) ;
			Character [ playerid ] [ E_CHARACTER_AMMO_J ]	=  cache_get_field_int ( 0, "player_ammo_j" ) ;

			Character [ playerid ] [ E_CHARACTER_VL_SLOT_0 ] =  cache_get_field_int ( 0, "player_vl_slot_0" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_1 ] =  cache_get_field_int ( 0, "player_vl_slot_1" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_2 ] =  cache_get_field_int ( 0, "player_vl_slot_2" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_3 ] =  cache_get_field_int ( 0, "player_vl_slot_3" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_4 ] =  cache_get_field_int ( 0, "player_vl_slot_4" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_5 ] =  cache_get_field_int ( 0, "player_vl_slot_5" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_6 ] =  cache_get_field_int ( 0, "player_vl_slot_6" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_7 ] =  cache_get_field_int ( 0, "player_vl_slot_7" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_8 ] =  cache_get_field_int ( 0, "player_vl_slot_8" ) ;
			Character [ playerid ] [ E_CHARACTER_VL_SLOT_9 ] =  cache_get_field_int ( 0, "player_vl_slot_9" ) ;

			Character [ playerid ] [ E_CHARACTER_VOICELINE_SOUND] =  cache_get_field_int ( 0, "player_hud_voicelines" ) ;
			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_STATIC ] =  cache_get_field_int ( 0, "player_spraytag" ) ;

			// Money givers
			Character [ playerid ] [ E_CHARACTER_PROPERTY_REFUND ] =  cache_get_field_int ( 0, "player_property_refund" ) ;
			Character [ playerid ] [ E_CHARACTER_VEHICLE_REFUND ] =  cache_get_field_int ( 0, "player_vehicle_refund" ) ;
			Character [ playerid ] [ E_CHARACTER_UPDATE_REWARD ] =  cache_get_field_int ( 0, "player_update_reward" ) ;

			// Fear and respect
			Character [ playerid ] [ E_CHARACTER_RESPECT ]  			=  cache_get_field_int ( 0, "player_respect" ) ;
			Character [ playerid ] [ E_CHARACTER_FEAR ]  				=  cache_get_field_int ( 0, "player_fear" ) ;
			Character [ playerid ] [ E_CHARACTER_FnR_GIVABLE ]  		=  cache_get_field_int ( 0, "player_fnr_givable" ) ;

			// Drugs
			Character [ playerid ] [ E_CHARACTER_DRUG_EFFECT_TICKS ]	= cache_get_field_int ( 0, "player_drug_effect_ticks" ) ;
			Character [ playerid ] [ E_CHARACTER_DRUG_EFFECT_ACTIVE ]	= cache_get_field_int ( 0, "player_drug_effect_active" ) ;
			Character [ playerid ] [ E_CHARACTER_DRUG_EFFECT_PARAM ]	= cache_get_field_int ( 0, "player_drug_effect_param" ) ;
			Character [ playerid ] [ E_CHARACTER_DRUG_EFFECT_TYPE ]		= cache_get_field_int ( 0, "player_drug_effect_type" ) ;

			Character [ playerid ] [ E_CHARACTER_MOLE ] = cache_get_field_int ( 0, "player_mole" ) ;


			//Character [ playerid ] [ E_CHARACTER_PROP_FOOD ] 			= cache_get_field_int ( 0, "player_prop_food" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_FOOD_TIME ] 		= cache_get_field_int ( 0, "player_prop_food_timeleft" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_FOOD_USES ]		= cache_get_field_int ( 0, "player_prop_food_uses" ) ;

			//Character [ playerid ] [ E_CHARACTER_PROP_DRINK ] 			= cache_get_field_int ( 0, "player_prop_drink" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_DRINK_TIME ] 		= cache_get_field_int ( 0, "player_prop_drink_timeleft" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_DRINK_USES ]		= cache_get_field_int ( 0, "player_prop_drink_uses" ) ;

			//Character [ playerid ] [ E_CHARACTER_PROP_CIGARETTE ] 		= cache_get_field_int ( 0, "player_prop_cigarette" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_CIGARETTE_USES ] 	= cache_get_field_int ( 0, "player_prop_cigarette_uses_left" ) ;

			//Character [ playerid ] [ E_CHARACTER_PROP_MENU ] 			= cache_get_field_int ( 0, "player_prop_menu" ) ;
			//Character [ playerid ] [ E_CHARACTER_PROP_CRATE ]		 	= cache_get_field_int ( 0, "player_prop_crate" ) ;

			Character [ playerid ] [ E_CHARACTER_HITMAN ] 		= cache_get_field_int ( 0, "player_hitman" ) ; 
			Character [ playerid ] [ E_CHARACTER_HITMAN_RANK ] = cache_get_field_int ( 0, "player_hitman_rank" ) ;

			Character [ playerid ] [ E_CHARACTER_HITMAN_KILLED ] = cache_get_field_int ( 0, "player_hitman_killed" ) ;
			Character [ playerid ] [ E_CHARACTER_HITMAN_UNLOCKED ] = cache_get_field_int ( 0, "player_hitman_unlocked" ) ;
			Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] = cache_get_field_int ( 0, "player_robbery_cooldown" ) ;

			Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ] = cache_get_field_int ( 0, "player_fightstyle" ) ;
			Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE_TICK ] = cache_get_field_int ( 0, "player_fightstyle_tick" ) ;

			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_WIPE_CD ] = cache_get_field_int ( 0, "player_spraytag_wipe_cd" ) ;
			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_DYNAMIC] = cache_get_field_int ( 0, "player_spraytag_dynamic" ) ;
			cache_get_field_content ( 0, "player_spraytag_dyn_text", Character [ playerid ] [ E_CHARACTER_SPRAYTAG_DYN_TEXT], mysql, 64 ) ;
			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_DYN_FCOLOR] = cache_get_field_int ( 0, "player_spraytag_dyn_fcolor" ) ;
			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_DYN_CD] = cache_get_field_int ( 0, "player_spraytag_dyn_cd" ) ;
			Character [ playerid ] [ E_CHARACTER_SPRAYTAG_STATIC_CD] = cache_get_field_int ( 0, "player_spraytag_static_cd" ) ;
			
			Character [ playerid ] [ E_CHARACTER_DRIVER_WARNINGS] = cache_get_field_int ( 0, "player_driver_warnings" ) ;
			Character [ playerid ] [ E_CHARACTER_CHOPSHOP_CD] = cache_get_field_int ( 0, "player_chopshop_cd" ) ;
			Character [ playerid ] [ E_CHARACTER_LOCKPICK] = cache_get_field_int ( 0, "player_lockpicks" ) ;
			Character [ playerid ] [ E_CHARACTER_CRASHED_DUTY] = cache_get_field_int ( 0, "player_keep_duty" ) ;


			Character [ playerid ] [ E_CHARACTER_GYM_SETUP ] = cache_get_field_int ( 0, "player_gym_setup" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_ENERGY ] = cache_get_field_int ( 0, "player_gym_energy" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_ENERGY_INTERNAL ] = cache_get_field_int ( 0, "player_gym_energy_internal" ) ;

			Character [ playerid ] [ E_CHARACTER_GYM_WEIGHT ] = cache_get_field_int ( 0, "player_gym_weight" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_WEIGHT_XP ] = cache_get_field_int ( 0, "player_gym_weight_xp" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_WEIGHT_INTERNAL ] = cache_get_field_int ( 0, "player_gym_weight_internal" ) ;

			Character [ playerid ] [ E_CHARACTER_GYM_MUSCLE ] = cache_get_field_int ( 0, "player_gym_muscle" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_MUSCLE_XP ] = cache_get_field_int ( 0, "player_gym_muscle_xp" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_MUSCLE_INTERNAL ] = cache_get_field_int ( 0, "player_gym_muscle_internal" ) ;

			Character [ playerid ] [ E_CHARACTER_GYM_HUNGER ] = cache_get_field_int ( 0, "player_gym_hunger" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_HUNGER_INTERNAL ] = cache_get_field_int ( 0, "player_gym_hunger_internal" ) ;

			Character [ playerid ] [ E_CHARACTER_GYM_THIRST ] = cache_get_field_int ( 0, "player_gym_thirst" ) ;
			Character [ playerid ] [ E_CHARACTER_GYM_THIRST_INTERNAL ] = cache_get_field_int ( 0, "player_gym_thirst_internal" ) ;
			
			Character [ playerid ] [ E_CHARACTER_PAGER_FREQ ]		=  cache_get_field_int ( 0, "player_pager_freq" ) ;
			cache_get_field_content ( 0, "player_pager_nick", Character [ playerid ] [ E_CHARACTER_PAGER_NICK ], mysql, 11) ;

			Character [ playerid ] [ E_CHARACTER_LAST_MUGSHOT ]	= cache_get_field_int ( 0, "player_last_mugshot" ) ;
			Character [ playerid ] [ E_CHARACTER_STRAWMAN ]	= cache_get_field_int ( 0, "player_strawman" ) ;

			Character [ playerid ] [ E_CHARACTER_VEH_DUP ]	= cache_get_field_int ( 0, "player_vehdup" ) ;
			Character [ playerid ] [ E_CHARACTER_PROP_DUP ]	= cache_get_field_int ( 0, "player_propdup" ) ;


			Character [ playerid ][ E_CHARACTER_ATTRIB_SEX ]	= cache_get_field_int ( 0, "player_attribute_sex" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_AGE ]	= cache_get_field_int ( 0, "player_attribute_age" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_RACE ]	= cache_get_field_int ( 0, "player_attribute_race" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_EYES ]	= cache_get_field_int ( 0, "player_attribute_eyes" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_HAIR ]	= cache_get_field_int ( 0, "player_attribute_hair" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_BODY ]	= cache_get_field_int ( 0, "player_attribute_body" ) ;
			Character [ playerid ][ E_CHARACTER_ATTRIB_HEIGHT ] = cache_get_field_int ( 0, "player_attribute_height" ) ;
			cache_get_field_content ( 0, "player_attribute_desc", Character [ playerid ] [ E_CHARACTER_ATTRIB_DESC ], mysql, 128) ;

			Character [ playerid ][ E_CHARACTER_SKILL_PISTOL ]	= cache_get_field_int ( 0, "player_skill_pistol" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_SDPISTOL ]	= cache_get_field_int ( 0, "player_skill_sdpistol" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_DEAGLE ]	= cache_get_field_int ( 0, "player_skill_deagle" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_SHOTGUN ]	= cache_get_field_int ( 0, "player_skill_shotgun" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_SAWNOFF ]	= cache_get_field_int ( 0, "player_skill_sawnoff" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_SPAZ ]	= cache_get_field_int ( 0, "player_skill_spaz" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_UZI ]	= cache_get_field_int ( 0, "player_skill_uzi" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_MP5 ]	= cache_get_field_int ( 0, "player_skill_mp5" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_AK47 ]	= cache_get_field_int ( 0, "player_skill_ak47" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_M4 ]	= cache_get_field_int ( 0, "player_skill_m4" ) ;
			Character [ playerid ][ E_CHARACTER_SKILL_SNIPER ]	= cache_get_field_int ( 0, "player_skill_sniper" ) ;

			Character [ playerid ][ E_CHARACTER_AMMO_PURGED ]	= cache_get_field_int ( 0, "player_ammo_purged" ) ;

			Character [ playerid ][ E_CHARACTER_GROUPID ]= cache_get_field_int ( 0, "player_groupid" ) ;
			Character [ playerid ][ E_CHARACTER_GROUPTIER ]= cache_get_field_int ( 0, "player_grouptier" ) ;

			// New setting
			Character [ playerid ][ E_CHARACTER_ACC_HIDE ] = cache_get_field_int ( 0, "player_account_hidden" ) ;
			cache_get_field_content ( 0, "player_account_hidden_name", Character [ playerid ] [ E_CHARACTER_ACC_HIDE_NAME ], mysql, 32) ;

			if (!strcmp(Character [ playerid ] [ E_CHARACTER_ACC_HIDE_NAME ], "NULL"))
			{
				Character [ playerid ] [ E_CHARACTER_ACC_HIDE_NAME ] [0] = EOS;
			}

			Character[playerid][E_CHARACTER_ADMIN_HIDE] = cache_get_field_int(0, "player_admin_hidden");
			

			SetPlayerName(playerid, Character [ playerid ] [ E_CHARACTER_NAME ]);

			// Nametag shit
			UpdateTabListForPlayers(playerid);
			UpdatePlayerTablistForOthers ();

			for ( new i, j = 10 ; i < j ; i ++ ) {
				Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE ] [ i ] = cache_get_field_int ( 0, sprintf("player_gun_package_%d", i) ) ;
				Character [ playerid ] [ E_CHARACTER_GUN_PACKAGE_AMMO] [ i ] = cache_get_field_int ( 0, sprintf("player_gun_package_%d_ammo", i) ) ;
			}
			
			if ( Character [ playerid ] [ E_CHARACTER_HOURS] >= 6 ) {

				if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNACCESS ] ) {

					mysql_format(mysql, query, sizeof ( query ), "UPDATE accounts SET account_gunaccess = 1 WHERE account_id = %d", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
					mysql_tquery(mysql, query ) ;

					Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNACCESS ] = true ;
				}
			}

			/*
			SendClientMessage(playerid, -1, sprintf("Logged in as (%d) %s.", 
				Character [ playerid ] [ E_CHARACTER_ID ], Character [ playerid ] [ E_CHARACTER_NAME ]
			)) ;
			*/

			PlayerVar [ playerid ] [ E_PLAYER_CHOSE_CHARACTER ] = true ;

			mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_logindate = %d, player_ip = '%e' WHERE player_id = %d",
				gettime(), ReturnIP(playerid), Character [ playerid ] [ E_CHARACTER_ID ] ) ;
			mysql_tquery(mysql, query, "", "");

			/*
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior ( playerid, 3 ) ;
			SetPlayerCameraPos(playerid, 1525.4880, -7.4773, 1002.6321);
			SetPlayerCameraLookAt(playerid, 1526.3781, -7.9292, 1002.4353);
			*/


			// SetPlayerTime(playerid, Server [ E_SERVER_TIME_HOURS], 00);
			

			Streamer_Update(playerid, STREAMER_TYPE_OBJECT ) ;

			if (Character [ playerid ] [ E_CHARACTER_HEALTH ] > 99.0)
			{
				Character [ playerid ] [ E_CHARACTER_HEALTH ] = 100.0;
			}

			SetPlayerHealth(playerid, Character [ playerid ] [ E_CHARACTER_HEALTH ] ) ;
			//SetPlayerArmour ( playerid, Character [ playerid ] [ E_CHARACTER_ARMOUR ] ) ;

			SetPlayerFightingStyle(playerid, Character [ playerid ] [ E_CHARACTER_FIGHTSTYLE ]);
 
 			Groups_OnPlayerLogin(playerid);
			Player_SendLoginMessage ( playerid ); 
			PlayerSkin_PurgeCheck(playerid);

			// Temp Holiday
			//EasterEgg_LoadPlayerEntities(playerid) ; // Holiday Event: Easter
			//Halloween_LoadPlayerEntities(playerid); // Holiday Event: Halloween
			//Christmas_LoadPlayerEntities(playerid); // Holiday Event: Christmas

			// Drugs loading
			Drugs_LoadEntity_Containers(playerid) ;
			Drugs_LoadEntities_PlayerDrugs(playerid) ;
			Drugs_LoadEntity_Supplies ( playerid ) ;

			#if !defined PHONE_V2_DEV
				Phone_ViewPhonebook_SQL(playerid, .view=false); // load phonebook
			#endif


			//Init_LoadPlayerProps ( playerid ) ; // Load player props

			PlayerVar [ playerid ] [ E_PLAYER_PLACING_DRUG_PLANT ] = -1 ;
			PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX ] = -1 ;

			// Clearing phone variables.
			PlayerVar [ playerid ] [ player_phonecalling ] = INVALID_PLAYER_ID ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_STATUS ] = true ; // phone on by default
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ACCEPT_CALL ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_ALERT_TICKS ] = 0 ;
			PlayerVar [ playerid ] [ E_PLAYER_PHONE_RINGTONE_TICK ] = 0 ;
			PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);

			SetPlayerCash(playerid, Character [ playerid ] [ E_CHARACTER_CASH ]) ;
			Contributor_ApplyRights(playerid) ;

			if ( ! Character [ playerid ] [ E_CHARACTER_REGISTERED ] ) 
			{
				SOLS_ShowCharCreation(playerid, Character [ playerid ] [ E_CHARACTER_ID ]);
				// Player_ShowSkinMenu(playerid) ;
			}

			else if ( Character [ playerid ] [ E_CHARACTER_REGISTERED ] ) {

//				SendClientMessage(playerid, COLOR_YELLOW, "If the spawn dialog doesn't show up, use /spawn to trigger it again.");
				Player_DisplaySpawnList(playerid);
			}

			if (GetPlayerAdminLevel(playerid) && Character[playerid][E_CHARACTER_ADMIN_HIDE])
			{
				SendClientMessage(playerid, COLOR_YELLOW, "Note: you are hidden from /admins on this character, /settings to change.");
			}

			CallLocalFunction("SOLS_OnLoadCharacter", "dd", playerid, character_id);
		}
	}

	mysql_tquery_inline ( mysql, sprintf("SELECT * FROM characters WHERE player_id = %d", character_id), using inline E_FETCH_PLAYER_CHARACTER, "" ) ;

	return true ;
}

static PropertyDlgStr[4096];

enum
{
	PLAYER_SPAWN_TYPE_LAST,
	PLAYER_SPAWN_TYPE_FACTION,
	PLAYER_SPAWN_TYPE_PROPERTY,
	PLAYER_SPAWN_TYPE_NEWBIE
}

new PlayerSpawnOptions[MAX_PLAYERS][4];

Player_DisplaySpawnList(playerid, bool:respawn=false) {

	inline SpawnLocationPick(pid, dialogid, response, listitem, string:inputtext[] ) 
	{ 
		#pragma unused pid, dialogid, response, listitem, inputtext

		if ( ! response && !respawn ) 
		{
			SendClientMessage(pid, COLOR_RED, "Actually choose a spawn location!");
			return Player_DisplaySpawnList(pid) ;
		}

		if ( response && listitem >= 0 && listitem < sizeof ( PlayerSpawnOptions [ ] ) ) 
		{
			PlayerSpawnSelection(pid, listitem, respawn );
			return true;
		}
	}

	format(PropertyDlgStr, sizeof(PropertyDlgStr), "Type\tOption\n");

	new options = 0, address[64], zone[64];

	if (Character[playerid][E_CHARACTER_ARREST_TIME])
	{
		strcat(PropertyDlgStr, "{BCAAA4}Prison\tBack to your cell...");
		PlayerSpawnOptions[playerid][options] = PLAYER_SPAWN_TYPE_LAST;
		options ++;
	}
	else
	{
		if (Character[playerid][E_CHARACTER_LAST_POS_X] && Character[playerid][E_CHARACTER_LAST_POS_Y] && Character[playerid][E_CHARACTER_LAST_POS_Z])
		{
			new Float:x, Float:y, Float:z;
			x = Character[playerid][E_CHARACTER_LAST_POS_X];
			y = Character[playerid][E_CHARACTER_LAST_POS_Y];
			z = Character[playerid][E_CHARACTER_LAST_POS_Z];

			new property_enum_id = -1;
			if (Character[playerid][E_CHARACTER_LAST_POS_VW] > 0)
			{
				property_enum_id = Property_GetInsideAtCoords(x, y, z, Character[playerid][E_CHARACTER_LAST_POS_VW], Character[playerid][E_CHARACTER_LAST_POS_INT]); 
			}

			if (property_enum_id != -1)
			{
				strcat(PropertyDlgStr, sprintf("{FFCC80}Previous Location\t%s\n", ReturnPropEnterText(property_enum_id, false)));
			}
			else
			{
				GetCoords2DZone(x, y, zone, sizeof(zone));
				GetPlayerAddress(x, y, address);
				strcat(PropertyDlgStr, sprintf("{FFCC80}Previous Location\t%s, %s\n", address, zone));
			}

			PlayerSpawnOptions[playerid][options] = PLAYER_SPAWN_TYPE_LAST;
			options ++;
		}

		if (Character[playerid][E_CHARACTER_FACTIONID]) 
		{
			new faction_enum_id = Faction_GetEnumID(Character[playerid][E_CHARACTER_FACTIONID]);
			if (faction_enum_id != -1) 
			{
				strcat(PropertyDlgStr, sprintf("{9FA8DA}Your Faction\t%s\n", Faction_GetNameByID(faction_enum_id)));
				PlayerSpawnOptions[playerid][options] = PLAYER_SPAWN_TYPE_FACTION;
				options ++;
			}
		}

		new properties = GetPlayerPropertyCount(playerid);
		if (properties)
		{
			strcat(PropertyDlgStr, "{80CBC4}Your Properties\tSelect...\n");
			PlayerSpawnOptions[playerid][options] = PLAYER_SPAWN_TYPE_PROPERTY;
			options ++;
		}

		strcat(PropertyDlgStr, "{F48FB1}Newcomer Spawns\tSelect...\n");
		PlayerSpawnOptions[playerid][options] = PLAYER_SPAWN_TYPE_NEWBIE;

		PlayerVar[playerid][E_PLAYER_SPAWN_OPTIONS_COUNT] = options;
	}

	if (options)
	{
		if (respawn)
		{
			Dialog_ShowCallback ( playerid, using inline SpawnLocationPick, DIALOG_STYLE_TABLIST_HEADERS, "Spawn Selection", PropertyDlgStr, "Select", "Back" ) ;
		}
		else
		{
			Dialog_ShowCallback ( playerid, using inline SpawnLocationPick, DIALOG_STYLE_TABLIST_HEADERS, "Spawn Selection", PropertyDlgStr, "Select", "" ) ;
		}
	}
	else
	{
		// Show the newcomer spawn dialog instead since there's nowhere else
		Spawn_Newbie(playerid, respawn);
	}

	if (respawn)
	{
		return true;
	}


	return true ;			
}

Player_SendLoginMessage(playerid) {

	//new query [ 1024 ] ;
	//new buffer [ 1024 ] ;

	new str[256], rank[24], staff[32];

	SendClientMessage(playerid, -1, " " ) ;
	format ( str, sizeof ( str ), "Hey {5CB4E3}%s{FFFFFF}, welcome back to {ed7a34}%s!{FFFFFF}", Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], SERVER_NAME );
	SendClientMessage(playerid, -1, str ) ;
/*
	SendClientMessage(playerid, -1, " " ) ;

	buffer [ 0 ] = EOS, query [ 0 ] = EOS ;
	new year, month, day, hour, minute, second ;
	stamp2datetime(Character [ playerid ] [ E_CHARACTER_LOGINDATE ], year, month, day, hour, minute, second, 1 ) ;

	format ( buffer, sizeof ( buffer ), "%s the %d%s of %s, %d{FFFFFF} at {36906b}%d:%d:%d",
	date_dayName(day, month, year), day, date_dayOrdinal (day), date_getMonth(month), year, hour, minute, second ) ;

	SendClientMessage(playerid, -1, sprintf("Last seen at {36906b}%s{FFFFFF}.", buffer));
*/
	//query [ 0 ] = EOS ;
	//buffer [ 0 ] = EOS ;

	GetPremiumRank ( Account [ playerid ] [ E_PLAYER_ACCOUNT_PREMIUMLEVEL ], rank, 24 ) ;
	GetAdminRankName ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ], staff, 32 ) ;

	SendClientMessage(playerid, -1, sprintf("You're logged in as a {EEC650}%s{FFFFFF}, playing as {5CB4E3}%s (%d)", rank, ReturnPlayerNameData(playerid, 0, true), Character[playerid][E_CHARACTER_ID]));
	
	if (Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ])
	{
		SendClientMessage(playerid, -1, sprintf("Note that your account has {EEC650}%s{FFFFFF} staff permissions.", staff));
	}

	if (Server [ E_SERVER_MOTD_EDIT_TIME ])
	{
		new year, month, day, hour, minute, second ;
		stamp2datetime(Server [ E_SERVER_MOTD_EDIT_TIME ], year, month, day, hour, minute, second, 1 ) ;
		SendClientMessage(playerid, -1, sprintf("To view the MOTD, type {ed7a34}/viewmotd{DEDEDE} (last updated on {EEC650}%s %d, %d{DEDEDE})", date_getMonth(month), day, year ) ) ;
	}

	SendClientMessage(playerid, -1, " " ) ;

	//CheckPendingLicense(playerid);
	
	return true ;
}

IsAccountNameRegex(const propname[])
{
	static Regex:regex;
	if (!regex) regex = Regex_New("^([A-Za-z0-9_]+)$");

	return Regex_Check(propname, regex);
}

IsRPNameRegex(const propname[])
{
	static Regex:regex;
	if (!regex) regex = Regex_New("^([A-Z][a-z]+_[A-Z][a-z]{0,2}[A-Z]{0,1}[a-z]*)$");

	return Regex_Check(propname, regex);
}

/*
IsRPName(const name[]) {
    new underscores = 0, max_underscores = SERVER_MAX_NAME_UNDERSCORES;
    if (name[0] < 'A' || name[0] > 'Z') return false;
    if ( strlen ( name ) < 5 ) return false ;
    if ( strlen ( name ) > MAX_PLAYER_NAME ) return false ;

    for_loop(new i = 1; i < strlen(name); i++) {

        if(name[i] != '_' && (name[i] < 'A' || name[i] > 'Z') && (name[i] < 'a' || name[i] > 'z')) return false;
        if( (name[i] >= 'A' && name[i] <= 'Z') && (name[i - 1] != '_') ) return false;

        if(name[i] == '_') {
            underscores++;
            if(underscores > max_underscores || i == strlen(name)) return false;
            if(name[i + 1] < 'A' || name[i + 1] > 'Z') return false;
        }
    }

    if (underscores == 0) return false;

    return true;
}
*/

static LegacyRefundQuery[256];
static CheckLegacyRefunds(playerid)
{
	if ( Character [ playerid ] [ E_CHARACTER_SOLD_FUELSTATION ] ) {
		FuelStation_RefundPlayer(playerid);

		Character [ playerid ] [ E_CHARACTER_SOLD_FUELSTATION ] = 0 ;

		mysql_format(mysql, LegacyRefundQuery, sizeof(LegacyRefundQuery), "UPDATE characters SET player_soldfuelstation = 0 WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_ID ] ) ;
		mysql_tquery(mysql, LegacyRefundQuery);
	}

	if ( Character [ playerid ] [ E_CHARACTER_SOLD_PROPERTY ] ) {

		new id = Character [ playerid ] [ E_CHARACTER_SOLD_PROPERTY ] ;

		Property_RefundPlayer(playerid, id) ;

		Character [ playerid ] [ E_CHARACTER_SOLD_PROPERTY ] = -1 ;
		mysql_format(mysql, LegacyRefundQuery, sizeof(LegacyRefundQuery), "UPDATE characters SET player_soldproperty = 0 WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, LegacyRefundQuery);
	}

	if ( Character [ playerid ] [ E_CHARACTER_SOLD_FURNITURE ] ) {

		SendClientMessage(playerid, -1, " " ) ;
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("WARNING:{DEDEDE} ALL of your furniture has been sold while you were OFFLINE. You have been refunded $%s.",
			IntegerWithDelimiter ( Character [ playerid ] [ E_CHARACTER_SOLD_FURNITURE ] ) ) ) ;
		SendClientMessage(playerid, COLOR_RED, "If you think this was a mistake, post a refund request with the property ID. ");
		SendClientMessage(playerid, -1, " " ) ;

		GivePlayerCash ( playerid, Character [ playerid ] [ E_CHARACTER_SOLD_FURNITURE ] ) ;
		Character [ playerid ] [ E_CHARACTER_SOLD_FURNITURE ] = 0 ;

		mysql_format(mysql, LegacyRefundQuery, sizeof(LegacyRefundQuery), "UPDATE characters SET player_soldfurni = 0 WHERE player_id = %d",
			Character [ playerid ] [ E_CHARACTER_ID ] ) ;

		mysql_tquery(mysql, LegacyRefundQuery);
	}
}

static CheckFactionSpawnStuff(playerid)
{
	new suspension = GetPlayerFactionSuspension(playerid);
	if (suspension)
	{
		PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = false;
    	SendClientMessage(playerid, COLOR_BLUE, sprintf("You are currently suspended from your faction for another %d hour(s).", suspension / 3600));
	}
    else if ( Character [ playerid ] [ E_CHARACTER_CRASHED_DUTY] >= gettime() && IsPlayerInDutyFaction(playerid)) 
	{
    	PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = true;
    	SendClientMessage(playerid, COLOR_BLUE, "Your faction duty state has been restored (logged in before 2 hours passed).");
    }		
}


// -------------------------------------------------------
// The below functions are whenever a player spawns or respawns from the MENUS only (e.g. login or /respawnplayer) and NOT if they die/respawn from the GAME
// Use them when your scripts need to do stuff when a player logs in, e.g. checking if they have an email address set
// Example is below, always include y_hooks at the top of the file first (so that the same hook in different files don't conflict)


// #include <YSI_Coding\y_hooks>

/*
	hook SOLS_OnCharacterSpawn(playerid, isrespawn)
	{
		PlayerVar[playerid][E_PLAYER_PM_BLOCKED] = true;
		SendClientMessage(playerid, COLOR_YELLOW, "Your PMs have been automatically blocked to avoid player nuisance.");
		return 1;
	}
*/

// -----------------------------------------------------

forward SOLS_OnCharacterSpawn(playerid, isrespawn);
public SOLS_OnCharacterSpawn(playerid, isrespawn)
{
	// printf("Processing SOLS_OnCharacterSpawn for (%d) %s: isrespawn = %d", playerid, SOLS_PlayerName(playerid), isrespawn);
	// Note that a respawn is only if they die or toggle spectate, etc.  It does NOT include /respawnplayer (which is a teleport only)

	if (!isrespawn)
	{
		// Hades' PMs thing
		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] == 1 ) 
		{
			PlayerVar [ playerid ] [ E_PLAYER_PM_BLOCKED ]  = true ;
			SendClientMessage(playerid, COLOR_YELLOW, "Your PMs have been automatically blocked to avoid player nuisance." ) ;
		}

		// Email collection (but not for newly registered accounts as we do this after they close the info box)
		if (!PlayerVar [ playerid ] [ E_PLAYER_FRESH_SPAWN ])
		{
			if (!strcmp ( Account [ playerid ] [ E_PLAYER_ACCOUNT_EMAIL ], "Undefined", true) ) 
			{
				GetPlayerEmail(playerid);
			}
		}

		// Rewards (last was back in December, disabling this for now)
		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_REWARD_AMOUNT ]) 
		{
			// SendClientMessage(playerid, 0xA3A3A3FF, sprintf("You have a reward pending. Type {38b088}\"/claimprize\"{A3A3A3} to collect it."));
		}

		// Faction related spawn stuff (moved from weapon loading code)
		if (Character [ playerid ] [ E_CHARACTER_FACTIONID ])
		{
			CheckFactionSpawnStuff(playerid);	
		}
	}

	// Armor is re-set either on first or respawn, but only after CheckFactionSpawnStuff(playerid);	above.
	SetPlayerArmour (playerid, Character [ playerid ] [ E_CHARACTER_ARMOUR ] ) ;
	if (Character [ playerid ] [ E_CHARACTER_HEALTH ] > 0) SetPlayerHealth (playerid, Character [ playerid ] [ E_CHARACTER_HEALTH ] ) ;
	// SendClientMessage(playerid, -1, "TEST: Your health and armor were set to their saved values.");

	// TODO: MOVE THIS TO A HOOK PLEASE
	#if defined CUSTOM_SKINS_DEVBUILD
	Customization_OnPlayerSpawn ( playerid ) ;
	#endif

	// ------------------------------------------
	return 1;
}

timer OnSpawn_Common[1000](playerid, isrespawn)
{
	Attach_LoadDelayedEntities(playerid);
	UpdatePlayerNamesForPlayer(playerid);
	Weapon_SetSkillLevel(playerid);

	if (!isrespawn)
	{
		// Legacy refunds (the old code like furniture)
		CheckLegacyRefunds(playerid);
		
		// New refund system (weapons and properties)
		Refund_CheckRefunds(playerid); 

		// Ammo purge 2022 edition
		Refund_TakeOldAmmo(playerid);

		// Load players weapons (this function has additional checks in it)
		Weapon_LoadPlayerWeapons(playerid); 

		// Refund Emmet Colts (11/07)
		Player_RefundEmmetColt(playerid);
	}

	// And then fire the hookable spawn event for setting other stuff
	CallLocalFunction("SOLS_OnCharacterSpawn", "dd", playerid, isrespawn);
	PlayerVar[playerid][E_PLAYER_FIRST_SPAWN] = false;
}

Spawn_Common(playerid, isrespawn=0)
{
	// Very important that this is set.
	PlayerVar[playerid][E_PLAYER_SPAWNED_CHARACTER] = true;
	PlayerVar[playerid][E_PLAYER_CREATING_CHAR] = false;

	// Then doing the rest on a short delay to maybe solve some spawn issues for people
	defer OnSpawn_Common(playerid, isrespawn);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	// printf("OnPlayerRequestSpawn: (%d) %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));

    if (!IsPlayerLogged(playerid) || !PlayerVar[playerid][E_PLAYER_CHOSE_CHARACTER])
	{
		SendClientMessage(playerid, -1, "You must login to spawn!");
		SendAdminWarning(sprintf("[!!!] [AdmWarn] (%d) %s tried to spawn without logging in or choosing a character.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT)));
		printf("Blocked OnPlayerRequestSpawn for %d (%s)", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));
		return 0;
	}

    return 1;
}

#include <YSI_Coding\y_hooks>

forward SOLS_OnPlayerSpawn(playerid);
public SOLS_OnPlayerSpawn(playerid)
{	
	if (!PlayerVar[playerid][E_PLAYER_SPAWNED_CHARACTER])
	{
		printf("SOLS_OnPlayerSpawn (FIRST): (%d) %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY));
		new year, month, day, hour, minute, second;
		stamp2datetime(gettime(), year, month, day, hour, minute, second, 1 );
		// SendClientMessage(playerid, -1, sprintf("TEST: You were spawned into the game at %02d:%02d:%02d.", hour, minute, second));
		Spawn_Common(playerid, 0);
	}
	else
	{
		printf("SOLS_OnPlayerSpawn (RESPAWN): (%d) %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY));
		Spawn_Common(playerid, 1);
	}

	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, Account[playerid][E_PLAYER_ACCOUNT_SETTINGS_DRAW], playerid);

	return 1;
}

hook OnPlayerSpawn(playerid)
{
	printf("OnPlayerSpawn: (%d) %s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));

	if (!IsPlayerLogged(playerid))
	{
		// SendAdminMessage(sprintf("[!!!] [AdmWarn] (%d) %s spawned without logging in and was kicked.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT)));
		printf("[!] Kicked (%d) %s for spawning without being logged in.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));
		Kick(playerid);
		return 0;
	}

	if (!PlayerVar[playerid][E_PLAYER_CHOSE_CHARACTER])
	{
		// SendAdminMessage(sprintf("[!!!] [AdmWarn] (%d) %s spawned without choosing a character and was kicked.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT)));
		printf("[!] Kicked (%d) %s for spawning without choosing a character.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_DEFAULT));
		Kick(playerid);
		return 0;
	}

	CallLocalFunction("SOLS_OnPlayerSpawn", "d", playerid);
	return 1;
}

