/*Player skins use ranges: 20000 to 30000 (10000 slots)
Objects use negative IDs: -1000 to -30000 (29000 slots)*/

/* (to disable all player skins owned by characters that haven't logged in within the last 50 days)
UPDATE `player_skins` JOIN `characters` ON `player_skins`.`player_skin_charid` = `characters`.`player_id` SET `player_skin_disabled` = 1 WHERE `characters`.`player_logindate` < UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL 50 DAY)) AND `player_skin_charid` > 0
*/

/* (to disable all player skins that haven't been used in the last 100 days)
UPDATE `player_skins` JOIN `characters` ON `player_skins`.`player_skin_charid` = `characters`.`player_id` SET `player_skin_disabled` = 1 WHERE `player_skin_lastused` < UNIX_TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL 100 DAY) AND `player_skin_charid` > 0 AND (21000 + `player_skins`.`player_skin_id`) != `characters`.`player_skinid`
*/

/*
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '250', 'wmciv2.dff', 'wmciv2.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '261', 'wmycd1beta.dff', 'wmycd1beta.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '147', 'wmybubeta.dff', 'wmybubeta.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '60', 'omystbeta.dff', 'omystbeta.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '93', 'wfystdress.dff', 'wfystdress.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '223', 'shmycr.dff', 'shmycr.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '233', 'swfyjg1.dff', 'swfyjg1.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '233', 'swfyst.dff', 'swfyst.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '41', 'vhfypro.dff', 'vhfypro.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '11', 'vbfycrp.dff', 'vbfycrp.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '216', 'wfyrihdress.dff', 'wfyrihdress.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '41', 'hfystbeta.dff', 'hfystbeta.txd');
	INSERT INTO `player_skins` (`player_skin_charid`, `player_skin_baseid`, `player_skin_dff`, `player_skin_txd`) VALUES ('0', '69', 'fbciv2.dff', 'fbciv2.txd');
	

*/

/*

INSERT INTO buyable_skins ( 
      buyable_skin_skinid, 
      buyable_skin_cost,
    buyable_skin_propertyid ) 
SELECT 21000 + player_skin_id, 
       '250', 
       '-1'
FROM player_skins
WHERE player_skins.player_skin_charid = 0 AND player_skins.player_skin_disabled = 0
ORDER BY player_skins.player_skin_id ASC

*/

/* (to disable all player skins owned by MALE characters that haven't logged in within the last 100 days)
UPDATE `player_skins` JOIN `characters` ON `player_skins`.`player_skin_charid` = `characters`.`player_id` SET `player_skin_disabled` = 1 WHERE `characters`.`player_logindate` < UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL 100 DAY)) AND `player_skin_charid` > 0 AND `characters`.`player_attribute_sex` = 1
*/

enum E_PLAYER_SKIN_DATA {

	E_PLAYER_SKIN_ID,
	E_PLAYER_SKIN_VALID,
	E_PLAYER_SKIN_CHARID,
	E_PLAYER_SKIN_BASEID,
	E_PLAYER_SKIN_DFFNAME [ 64 ],
	E_PLAYER_SKIN_TXDNAME [ 64 ],
	E_PLAYER_SKIN_SKINID,
	E_PLAYER_SKIN_LASTUSED,
	E_PLAYER_SKIN_DISABLED
}

#if !defined MAX_PLAYER_SKINS
	#define MAX_PLAYER_SKINS 2500
#endif

#if !defined INVALID_PLAYER_SKIN
	#define INVALID_PLAYER_SKIN	-1
#endif

new PlayerSkin [ MAX_PLAYER_SKINS ] [ E_PLAYER_SKIN_DATA ] ;

CMD:addplayerskin(playerid, params[]) 
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new live, charid, baseid, dff[64], txd[64] ;

	if ( sscanf ( params, "iiis[64]s[64]", live, charid, baseid, dff, txd ) || (live != 0 && live != 1)) 
	{
		SendClientMessage(playerid, -1, "/addplayerskin [live] [charid] [baseid] [dff-name] [txd-name] -- include .dff and .txd in the name." ) ;
		SendClientMessage(playerid, -1, "If [live] is set to 1, the skin will be added live (only do this if the files are on both the server and the CDN)." ) ;
		SendClientMessage(playerid, -1, "If [live] is set to 0, it's added next restart and will not appear or be useable until then (normal behavior)." ) ;
		return true;
	}

	PlayerSkin_Create(playerid, live, charid, baseid, dff, txd);
	return true ;
}

// temp command
CMD:setplayerskinvalid(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new skinid, valid;

	if ( sscanf ( params, "ii", skinid, valid ) || (valid < 0 || valid > 1) || (skinid < 21000 || skinid >= (21000 + MAX_PLAYER_SKINS)) )
	{
		return SendClientMessage(playerid, -1, "/setplayerskinvalid [skin model id] [valid 0 or 1]" ) ;
	}

	for_loop(new i, j = sizeof  ( PlayerSkin ); i < j ; i ++ ) 
	{
		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] == skinid ) 
		{
			if (valid)
			{
				PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = 1;
				return SendClientMessage(playerid, -1, sprintf("You set player skin %d (%s) to be useable.", skinid, PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));
			}
			else
			{
				PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = 0;
				return SendClientMessage(playerid, -1, sprintf("You set player skin %d (%s) to be unuseable.", skinid, PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));
			}
		}
	}

	
	SendClientMessage(playerid, -1, sprintf("Couldn't find player skin with ID %d", skinid));
	return true ;
}

CMD:enableplayerskin(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new skinid, valid;

	if ( sscanf ( params, "ii", skinid, valid ) || (valid < 0 || valid > 1) )
	{
		return SendClientMessage(playerid, -1, "/enableplayerskin [skin database id] [valid 0 or 1]" ) ;
	}

	for_loop(new i, j = sizeof  ( PlayerSkin ); i < j ; i ++ ) 
	{
		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] == skinid ) 
		{
			new query [ 256 ] ;
			mysql_format(mysql, query, sizeof ( query ), "UPDATE player_skins SET player_skin_disabled = %d WHERE player_skin_id = %d", valid, skinid ) ;
			mysql_tquery(mysql, query);

			if (valid)
			{
				PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = 1;
				return SendClientMessage(playerid, -1, sprintf("You set player skin %d (%s) to be enabled (next restart).", skinid, PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));
			}
			else
			{
				PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = 0;
				return SendClientMessage(playerid, -1, sprintf("You set player skin %d (%s) to be disabled (next restart).", skinid, PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));
			}
		}
	}

	
	SendClientMessage(playerid, -1, sprintf("Couldn't find player skin with ID %d", skinid));
	return true ;
}

PlayerSkin_GetFreeID ( ) {

	for_loop(new i, j = sizeof  ( PlayerSkin ); i < j ; i ++ ) {

		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] == INVALID_PLAYER_SKIN ) {

			return i ;
		}

		else continue ;
	}

	return INVALID_PLAYER_SKIN ;
}

PlayerSkin_Create(playerid, live, charid, baseid, dff[64], txd[64] ) {

	new index = PlayerSkin_GetFreeID ( ) ; 

	if ( index == INVALID_PLAYER_SKIN ) {

		SendClientMessage(playerid, -1, "Tried to create skin but PlayerSkin_Create returned INVALID_PLAYER_SKIN (-1).");
		return print(" * [PLAYER SKIN] Tried to create add new skin PlayerSkin_Create returned -1.");
	}


	PlayerSkin [ index ] [ E_PLAYER_SKIN_CHARID ] = charid ;
	PlayerSkin [ index ] [ E_PLAYER_SKIN_BASEID ] = baseid ;
	
	PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ] [ 0 ] = EOS ;
	strcat(PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ], dff);

	PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ] [ 0 ] = EOS ;
	strcat(PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ], txd);

	PlayerSkin [ index ] [ E_PLAYER_SKIN_DISABLED ] = 0;
	PlayerSkin [ index ] [ E_PLAYER_SKIN_ID ] = 0;

	new query [ 512 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "INSERT INTO player_skins (player_skin_charid,player_skin_baseid, player_skin_dff, player_skin_txd, player_skin_lastused) VALUES (%d, %d, '%e', '%e', '%d')",

		PlayerSkin [ index ] [ E_PLAYER_SKIN_CHARID ], PlayerSkin [ index ] [ E_PLAYER_SKIN_BASEID ], 
		PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ], PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ],
		gettime()
	) ;

	inline pSkin_OnDatabaseInsert() 
	{	
		PlayerSkin [ index ] [ E_PLAYER_SKIN_ID ]  = cache_insert_id ();

		// First 1000 slots reserved for faction & other skins.
		PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ] = 21000 + PlayerSkin [ index ] [ E_PLAYER_SKIN_ID ] ;


		SendClientMessage(playerid, COLOR_BLUE, sprintf("SQL ID %d: Created player Skin ID %d for character %d (dff: \"%s\", txd: \"%s\").", 
			PlayerSkin [ index ] [ E_PLAYER_SKIN_ID ], PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ], 
			PlayerSkin [ index ] [ E_PLAYER_SKIN_CHARID ], PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ], 
			PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ] 
		) );

		if (live)
		{
			if (charid == 0)
			{
				PlayerSkin [ index ] [ E_PLAYER_SKIN_VALID ] = AddCharModel(PlayerSkin [ index ] [ E_PLAYER_SKIN_BASEID ], 
					PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ], 
					sprintf("public_skins/%s", PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ]),
					sprintf("public_skins/%s", PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ])
				);
			}
			else
			{
				PlayerSkin [ index ] [ E_PLAYER_SKIN_VALID ] = AddCharModel(PlayerSkin [ index ] [ E_PLAYER_SKIN_BASEID ], 
					PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ], 
					sprintf("player_skins/%s", PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME ]),
					sprintf("player_skins/%s", PlayerSkin [ index ] [ E_PLAYER_SKIN_TXDNAME ])
				);
			}
			

			if (PlayerSkin [ index ] [ E_PLAYER_SKIN_VALID ])
			{
				SendClientMessage(playerid, COLOR_INFO, sprintf("Player skin added live as Skin %d, switch VW to download the models.", PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ])); 
			}
			else
			{
				SendClientMessage(playerid, COLOR_ERROR, "WARNING: There was an error adding this skin live to the server, check files exist and are valid.");
			}
		}
	}

	mysql_tquery_inline(mysql, query, using inline pSkin_OnDatabaseInsert, "");

	return true ;
}

PlayerSkin_PurgeCheck(playerid)
{
	new skinid = Character [ playerid ] [ E_CHARACTER_SKINID ];

	for_loop(new i, j = sizeof  ( PlayerSkin ); i < j ; i ++ ) 
	{
		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] == skinid ) 
		{
			// SendClientMessage(playerid, -1, sprintf("You are using Custom Skin %d (%s).", skinid, PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));

			if (PlayerSkin [ i ] [ E_PLAYER_SKIN_DISABLED ])
			{
				SendClientMessage(playerid, -1, "WARNING: Your skin has been reset as the custom skin you were using no longer exists.");
				SetPlayerSkinEx(playerid, PlayerSkin [ i ] [ E_PLAYER_SKIN_BASEID ]);
			}

			break;
		}
	}
}

PlayerSkin_LoadEntities() {
	print(" * [PLAYERSKINS] Loading custom player skins...\n");

	for_loop ( new i; i < MAX_PLAYER_SKINS ; i ++ ) {

		PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] = INVALID_PLAYER_SKIN ;
	}

	new count = 0;
	new countp = 0;

	inline PlayerSkin_OnDataLoad() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			for_loop ( new i; i < rows && i < MAX_PLAYER_SKINS; i ++ ) { 

				PlayerSkin [ i ] [ E_PLAYER_SKIN_LASTUSED ]		= cache_get_field_int (i, "player_skin_lastused");

				/*#warning Make sure to test this! If LASTUSED < 1 month ago, don't load it!
				if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_LASTUSED ] < gettime() - 7776000 ) {

					continue ;
				}

				else {
*/
				PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ]			= cache_get_field_int (i, "player_skin_id");
				PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID ] 		= cache_get_field_int (i, "player_skin_charid");
				PlayerSkin [ i ] [ E_PLAYER_SKIN_BASEID ]		= cache_get_field_int (i, "player_skin_baseid");
				PlayerSkin [ i ] [ E_PLAYER_SKIN_DISABLED ] 	= cache_get_field_int (i, "player_skin_disabled");

				cache_get_field_content ( i, "player_skin_dff", 	PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ], mysql, 64 ) ;
				cache_get_field_content ( i, "player_skin_txd", 	PlayerSkin [ i ] [ E_PLAYER_SKIN_TXDNAME ], mysql, 64 ) ;

				PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] = 21000 + PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] ;

				if (PlayerSkin [ i ] [ E_PLAYER_SKIN_DISABLED ] == 1) continue;

				if (PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID ] == 0)
				{
					PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = AddCharModel(PlayerSkin [ i ] [ E_PLAYER_SKIN_BASEID ], 
						PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], 
						sprintf("public_skins/%s", PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]),
						sprintf("public_skins/%s", PlayerSkin [ i ] [ E_PLAYER_SKIN_TXDNAME ])
					);
				}
				else
				{
					PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] = AddCharModel(PlayerSkin [ i ] [ E_PLAYER_SKIN_BASEID ], 
						PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], 
						sprintf("player_skins/%s", PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]),
						sprintf("player_skins/%s", PlayerSkin [ i ] [ E_PLAYER_SKIN_TXDNAME ])
					);
				}

				

				if (!PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] )
				{
					printf("SKIN WARNING: Invalid skin when added: %d (%s, %s) (SQL: %d)", PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ], PlayerSkin [ i ] [ E_PLAYER_SKIN_TXDNAME ], PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ]);
				}
				else
				{
					if (PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID ] == 0)
					{
						countp ++;
					}
					else
					{
						count ++;
					}
				}
				//}
			}
		}

		printf("TOTAL PLAYER SKINS ADDED: %d", count);
		printf("TOTAL PUBLIC SKINS ADDED: %d", countp);
	}

	new query [ 256 ] ;
	mysql_format(mysql, query, sizeof ( query ), "SELECT * FROM player_skins" ) ;
	mysql_tquery_inline ( mysql, query, using inline PlayerSkin_OnDataLoad, "" ) ;

	return true ;
}

CMD:playerskins(playerid) {

	return cmd_playerskin(playerid);
}

CMD:customskin(playerid) {

	return cmd_playerskin(playerid);
}

CMD:customskins(playerid) {

	return cmd_playerskin(playerid);
}

/*
CMD:playerskin(playerid) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new dialog_string [ 1024 ], count, selection [ 64 ] ;

	strcat(dialog_string, "Skin ID \t Skin Name \t SQL ID\n");

	for_loop ( new i, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) {

		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] != INVALID_PLAYER_SKIN ) {

			if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID] == Character [ playerid ] [ E_CHARACTER_ID ] ) {
				format ( dialog_string, sizeof ( dialog_string ), "%s%d \t %s \t %d\n", dialog_string,
					PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME],
					PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] 
				) ;

				selection [ count ] = i ;

				count ++ ;
			}

			else continue ;
		}

		else continue ;
	}

	if ( ! count ) {

		format ( dialog_string, sizeof ( dialog_string ), "%sThere's no skins to show.", dialog_string) ;
	}

	inline PlayerSkinList(pid, dialogid, response, listitem, string:inputtext[] ) { 
		#pragma unused pid, dialogid, response, listitem, inputtext
		if ( ! count ) {

			return true ;
		}

		if ( response ) {

			new index = selection [ listitem ] ;

			if (!PlayerSkin [ index ] [ E_PLAYER_SKIN_VALID ])
			{
				return SendClientMessage(playerid, COLOR_BLUE, "This skin isn't valid or the files were not added to the server yet.");
			}

			SendClientMessage(playerid, COLOR_BLUE, sprintf("You've changed into skin ID %d (%s).", PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ], PlayerSkin [ index ] [ E_PLAYER_SKIN_DFFNAME] ) ) ;

			SetPlayerSkinEx(playerid, PlayerSkin [ index ] [ E_PLAYER_SKIN_SKINID ] ) ;
			PlayerSkin [ index ] [ E_PLAYER_SKIN_LASTUSED ] = gettime () ;  

			new query [ 512 ] ;

			mysql_format(mysql, query, sizeof ( query ), "UPDATE player_skins SET player_skin_lastused = %d WHERE player_skin_id = %d", 
				PlayerSkin [ index ] [ E_PLAYER_SKIN_LASTUSED ], PlayerSkin [ index ] [ E_PLAYER_SKIN_ID ]
			) ;

			mysql_tquery(mysql, query);

		}
	}

	Dialog_ShowCallback ( playerid, using inline PlayerSkinList, DIALOG_STYLE_TABLIST_HEADERS, "Custom Skin List", dialog_string, "Select", "Cancel" ) ;

	return true ;
}
*/

mBrowser:pskins_listadmin(playerid, response, row, model, name[]) 
{
	if ( response ) 
	{
		SetPlayerSkinEx(playerid, model);

		for_loop ( new i, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) 
		{
			if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] == model ) 
			{
				SendClientMessage(playerid, -1, sprintf("Changed to Skin ID: %d (SQL: %d) (%s)", model, PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ], PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME ]));
				break;
			}
		}
	}

	return true ;
}

mBrowser:pskins_listplayer(playerid, response, row, model, name[]) 
{
	if ( response ) 
	{
		for_loop ( new i, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) 
		{
			if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] == model ) 
			{
				if (!PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ]) return SendClientMessage(playerid, COLOR_ERROR, "This skin isn't valid or the files were not added to the server yet.");
				if (PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID] != Character [ playerid ] [ E_CHARACTER_ID ]) return SendClientMessage(playerid, COLOR_ERROR, "This isn't your skin...");

				SendClientMessage(playerid, COLOR_BLUE, sprintf("You've changed into Skin ID %d (%s).", PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], PlayerSkin [ i ] [ E_PLAYER_SKIN_DFFNAME] ) ) ;
				SendClientMessage(playerid, COLOR_WARNING, "This feature will be replaced by wardrobes soon, use /propertywardrobe to add one to your property.");

				SetPlayerSkinEx(playerid, PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ] ) ;
				PlayerSkin [ i ] [ E_PLAYER_SKIN_LASTUSED ] = gettime () ;  

				new query [ 128 ] ;

				mysql_format(mysql, query, sizeof ( query ), "UPDATE player_skins SET player_skin_lastused = %d WHERE player_skin_id = %d", 
					PlayerSkin [ i ] [ E_PLAYER_SKIN_LASTUSED ], PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ]
				) ;

				mysql_tquery(mysql, query);
				break;
			}
		}
	}

	return true ;
}


// New command for admins to view all skins and see how much SHIT is clogging the server's poor storage
CMD:allskins(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new starting, racestr[8], genderstr[8], race = -2, gender = -2, showplayerid;
	if ( sscanf ( params, "s[8]s[8]D(0)K<player>(-1)", genderstr, racestr, starting, showplayerid) || (starting < 0 || starting >= MAX_PLAYER_SKINS))
	{
		return SendClientMessage(playerid, -1, "/allskins [male/female/both] [white/black/latin/asian/all] [start index] [show to player id]" ) ;
	}

	if (showplayerid == -1) showplayerid = playerid;

	if (showplayerid && !IsPlayerConnected(showplayerid))
	{
		return SendClientMessage(playerid, -1, "Invalid show to player." ) ;
	}

	if (!strcmp(racestr, "white", true)) race = SKIN_RACE_WHITE;
	else if (!strcmp(racestr, "black", true)) race = SKIN_RACE_BLACK;
	else if (!strcmp(racestr, "latin", true)) race = SKIN_RACE_LATIN;
	else if (!strcmp(racestr, "asian", true)) race = SKIN_RACE_ASIAN;
	else if (!strcmp(racestr, "all", true)) race = -1;

	if (!strcmp(genderstr, "male", true)) gender = SKIN_GENDER_MALE;
	else if (!strcmp(genderstr, "female", true)) gender = SKIN_GENDER_FEMALE;
	else if (!strcmp(genderstr, "both", true)) gender = -1;

	ModelBrowser_ClearData(showplayerid);
	new name[64], baseid, skingender, skinrace, count = 0;

	for_loop ( new i = starting, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) 
	{
		if ( PlayerSkin [ i ] [ E_PLAYER_SKIN_ID ] != INVALID_PLAYER_SKIN && PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ] ) 
		{
			baseid = PlayerSkin [ i ] [ E_PLAYER_SKIN_BASEID ];
			skinrace = GetSkinRace(baseid);
			skingender = GetSkinGender(baseid);

			if (gender != -1 && skingender != gender) continue;
			if (race != -1 && skinrace != race) continue;

			format(name, 64, "%d", PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ]);
			ModelBrowser_AddData(showplayerid, PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], name ) ;
			count ++;

			if (count >= 300)
			{
				break;
			}
		}
	}

	if (count <= 0) return SendClientMessage(playerid, -1, "No skins found." ) ;
	ModelBrowser_SetupTiles(showplayerid, "Added Player Skins", "pskins_listadmin");
	SendClientMessage(playerid, -1, sprintf("Showing %d skins for your search (Max: 300)", count));
	return true;
}

CMD:checkskins(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_DEVELOPER ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new forplayerid;
	if ( sscanf ( params, "k<player>", forplayerid))
	{
		return SendClientMessage(playerid, -1, "/checkskins [player]" ) ;
	}

	if (!IsPlayerConnected(forplayerid))
	{
		return SendClientMessage(playerid, -1, "Invalid player id." ) ;
	}

	ModelBrowser_ClearData(playerid);
	new name[64], count = 0;

	for_loop ( new i = 0, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) 
	{
		if (PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID] == Character [ forplayerid ] [ E_CHARACTER_ID ] && PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ]) 
		{
			format(name, 64, "%d", PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ]);
			ModelBrowser_AddData(playerid, PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], name ) ;
			count ++;
		}
	}

	if (count <= 0) return SendClientMessage(playerid, -1, "No skins found for this player." ) ;
	ModelBrowser_SetupTiles(playerid, "Player Skins", "pskins_listadmin");
	SendClientMessage(playerid, -1, sprintf("Showing %d skins for (%d) %s", count, forplayerid, ReturnPlayerNameData(forplayerid)));
	return true;
}

CMD:playerskin(playerid) 
{
	if (IsPlayerIncapacitated(playerid)) return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;

	ModelBrowser_ClearData(playerid);
	new count, name[64];

	for_loop ( new i, j = MAX_PLAYER_SKINS ; i < j ; i ++ ) 
	{
		if (PlayerSkin [ i ] [ E_PLAYER_SKIN_CHARID] == Character [ playerid ] [ E_CHARACTER_ID ] && PlayerSkin [ i ] [ E_PLAYER_SKIN_VALID ]) 
		{
			format(name, 64, "%d", PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ]);
			ModelBrowser_AddData(playerid, PlayerSkin [ i ] [ E_PLAYER_SKIN_SKINID ], name ) ;
			count ++;
		}
	}

	if (!count) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have any custom player skins added.") ;

	ModelBrowser_SetupTiles(playerid, "Your Custom Skins", "pskins_listplayer");
	return true ;
}

static GetPlayerSkinEnumId(skinid)
{
	for_loop(new i, j = sizeof  ( PlayerSkin ); i < j ; i ++ ) 
	{
		if (PlayerSkin[i][E_PLAYER_SKIN_SKINID] == skinid)
		{
			return i;
		}
	}

    return -1;
}

SOLS_GetPlayerBaseSkinID(skinid)
{
    if (skinid >= 20000)
    {
        new id = GetPlayerSkinEnumId(skinid);
        if (id != -1)
        {
            return PlayerSkin[id][E_PLAYER_SKIN_BASEID];
        }
    }

    return skinid;
}

Skin_GetBaseModel(skinid)
{
	if (skinid < 312) return skinid;

	new id = GetPlayerSkinEnumId(skinid);
	if (id != -1) return PlayerSkin[id][E_PLAYER_SKIN_BASEID];

	skinid = SOLS_GetBaseSkinID(skinid);
	if (skinid >= 312) return 0;

	return skinid;
}