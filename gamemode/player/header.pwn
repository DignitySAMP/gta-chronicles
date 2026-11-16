
//#include "player/data.pwn"
#include "player/auth/header.pwn"
#include "player/spawns/header.pwn"
#include "donator/player.pwn"
#include "player/pause.pwn"
#include "player/mask.pwn"
#include "player/settings.pwn"
#include "player/session.pwn"
#include "player/tutorial.pwn"
#include "player/ma_check.pwn"

#include "player/reward.pwn"

#include "player/names-optimized.pwn"
#include "player/names-scoreboard.pwn"
#include "player/logout.pwn"

#include "player/help.pwn"
#include "player/attributes.pwn"



// Skips class selection.
timer OnPlayerFullyConnected[250](playerid) {

	if ( ! IsPlayerConnected ( playerid ) ) {

		return true ;
	}

	// Check if people are connecting on same MA or using same IP...
	CheckDoubleConnection(playerid);

	// Check if player is ban evading
	// BanEvaderCheck(playerid);


	// Force spawn NPCs

	OnLoadPlayerTextdraws(playerid);
	TextDrawHideForPlayer(playerid, gBlindfoldTD); 

	PlayerVar [ playerid ] [ E_PLAYER_IS_SPECTATING ] = INVALID_PLAYER_ID ;
	PlayerVar [ playerid ] [ E_PLAYER_LISTEN ] = INVALID_PLAYER_ID ;
	Character [ playerid ] [ E_CHARACTER_MOLE ] = INVALID_PLAYER_ID ;
	PlayerVar [ playerid ] [ E_PLAYER_ADMIN_CONVO ] = -1 ;
	PlayerVar [ playerid ] [ E_PLAYER_LISTENING_BOOMBOX ] = -1 ; //invalid boombox
	PlayerVar [ playerid ] [ E_PLAYER_CHOSE_CHARACTER ] = false ;
	PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_DONATOR ] = false ;
	PlayerVar [ playerid ] [ E_PLAYER_TOGGLE_STRAWMAN ] = false ;
	PlayerVar [ playerid ] [ E_PLAYER_LAST_PM_SENDER ] = INVALID_PLAYER_ID ;
	PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] = -1 ;

	format(PlayerVar[playerid][E_PLAYER_CONNECTED_IP], 64, "%s", ReturnIP(playerid));

	Furniture_SetPlayerVariables(playerid);
	Dockworker_SetPlayerVariables ( playerid ) ;

	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/intro_0_gta_sa_theme.mp3");
	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/streetz_of_los_santos_theme.mp3");
	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/sols_intro_song_2021.mp3");
	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/singleplayer_roleplay_intro.mp3");
	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/singleplayer_roleplay_intro_aug.mp3");
	//SOLS_PlayAudioStreamForPlayer(playerid, "https://streetzofls.com/themes/singleplayer_roleplay_intro_aug.mp3");

	

	if (strlen(Server [ E_SERVER_SONG_URL ]))
	{
		SOLS_PlayAudioStreamForPlayer(playerid, Server [ E_SERVER_SONG_URL ]);
	}


	defer LoginWindow[1000](playerid, AUTH_MSG_DEFAULT);

	PlayerVar [ playerid ] [ E_PLAYER_LOGIN_STARTED ] = gettime() ;
	defer LoginTimeout(playerid, PlayerVar [ playerid ] [ E_PLAYER_LOGIN_STARTED ]);

	return true ;
}

CMD:setintrosong(playerid, params[])
{
	if (GetPlayerAdminLevel(playerid) < 5)
	{
		return SendServerMessage( playerid, COLOR_RED, "Error", "DEDEDE", "You don't have access to this command.");
	}

	new songurl[128];

	if (sscanf(params, "s[128]", songurl) || strlen(songurl) < 10)
	{
		return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/setintrosong [url]");
	}
	    
	format(Server [ E_SERVER_SONG_URL ], 128, "%s", songurl);
	//SendAdminMessage(sprintf("[AdmWarn] %s (%d) set intro URL: %s", ReturnPlayerNameData(playerid), playerid, Server [ E_SERVER_SONG_URL ]));
	SendAdminCmd(playerid, sprintf("set the intro music URL to: %s", Server [ E_SERVER_SONG_URL ]));

	new query [ 256 ] ;
	mysql_format(mysql, query, sizeof ( query ), "UPDATE `server` SET `server_song_url` = '%e'", Server [ E_SERVER_SONG_URL ]);
	mysql_tquery(mysql, query);

	return true;
}


public OnPlayerConnect(playerid) {
	
	StartConnection(playerid) ;

	#if defined data_OnPlayerConnect
		return data_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect data_OnPlayerConnect
#if defined data_OnPlayerConnect
	forward data_OnPlayerConnect(playerid);
#endif


public OnPlayerDisconnect(playerid, reason) {

	CloseConnection(playerid, reason);
		
	#if defined config_OnPlayerDisconnect
		return config_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect config_OnPlayerDisconnect
#if defined config_OnPlayerDisconnect
	forward config_OnPlayerDisconnect(playerid, reason);
#endif


/*
CMD:spawn(playerid, params[]) {

	if ( ! IsPlayerSpawned ( playerid ) ) {

		if ( GetPlayerState(playerid ) == PLAYER_STATE_SPECTATING ) {
			Player_DisplaySpawnList(playerid);
		}

		else return SendClientMessage(playerid, COLOR_RED, "You must be spectating to be able to use this command.");
	}

	else return SendClientMessage(playerid, COLOR_RED, "You can't be spawned if you want to use this command.");

	return true ;
}
*/
CMD:login(playerid, params[]) {

	if ( ! PlayerVar [ playerid ] [ player_islogged ] ) {
		LoginWindow(playerid, AUTH_MSG_DEFAULT );
		return true ;
	}

	else return SendClientMessage(playerid, COLOR_ERROR, "Can only be used when not logged in.");
}

CMD:aka(playerid, params[]) {

	return cmd_id(playerid, params);
}
CMD:id ( playerid, params [] ) 
{
	new count = 1, str[128];

    if ( IsNumeric ( params ) ) 
	{
		new id = strval(params);
		SendClientMessage(playerid, COLOR_BLUE, sprintf("[Search results for ID %d]", id));

		if (id > MAX_PLAYERS)
		{
			// Presumably this is a masked ID, so return a special case for it
			foreach(new i : Player) 
			{

				if (PlayerVar[i][E_PLAYER_IS_MASKED] && Character[i][E_CHARACTER_MASKID] == id)
				{
					format(str, sizeof(str), "%d. Stranger (ID: %d) (Level: %d | Hours: %d)", count, Character[i][E_CHARACTER_MASKID], Character[i][E_CHARACTER_LEVEL], Character[i][E_CHARACTER_HOURS]);
					SendClientMessage(playerid, 0xDEDEDEFF, str);
					count ++;
				}
			}

			return true;
		}

		// Otherwise just return regular player info, even if they are masked (which will prevent MG as you won't be able to check if someone's masked or not)
    	if (id < 0 || !IsPlayerConnected(id) || !IsPlayerLogged(id))
		{
    		return SendClientMessage(playerid, COLOR_ERROR, "This player isn't connected or logged in.");
    	}

		if (!Character[id][E_CHARACTER_ACC_HIDE] || GetPlayerAdminLevel(playerid))
		{
			format(str, sizeof(str), "%d. %s (ID: %d) (Account: %s | Level: %d | Hours: %d)", count, Character[id][E_CHARACTER_NAME_RP], id, Account[id][E_PLAYER_ACCOUNT_NAME], Character[id][E_CHARACTER_LEVEL], Character[id][E_CHARACTER_HOURS]);
		}
		else
		{
			if (strlen(Character[id][E_CHARACTER_ACC_HIDE_NAME]))
			{
				format(str, sizeof(str), "%d. %s (ID: %d) (Account: %s | Level: %d | Hours: %d)", count, Character[id][E_CHARACTER_NAME_RP], id, Character[id][E_CHARACTER_ACC_HIDE_NAME], Character[id][E_CHARACTER_LEVEL], Character[id][E_CHARACTER_HOURS]);
			}
			else
			{
				format(str, sizeof(str), "%d. %s (ID: %d) (Level: %d | Hours: %d)", count, Character[id][E_CHARACTER_NAME_RP], id, Character[id][E_CHARACTER_LEVEL], Character[id][E_CHARACTER_HOURS]);
			}
		}

		SendClientMessage(playerid, 0xDEDEDEFF, str);
	}
	else
	{
		if (strlen(params) < 3) 
		{
    		return SendClientMessage(playerid, COLOR_ERROR, "/id [name] - enter at least 3 characters.");
	    }

		SendClientMessage(playerid, COLOR_BLUE, sprintf("[Search results for '%s']", params));

		foreach(new i: Player )
		{
			if (!Character[i][E_CHARACTER_ACC_HIDE] || GetPlayerAdminLevel(playerid))
			{
				if (strfind ( Account [ i ] [ E_PLAYER_ACCOUNT_NAME ], params, true ) != -1 || strfind ( Character [ i ] [ E_CHARACTER_NAME ], params, true ) != -1 ) 
				{
					format(str, sizeof(str), "%d. %s (ID: %d) (Account: %s | Level: %d | Hours: %d)", count, Character[i][E_CHARACTER_NAME_RP], i, Account[i][E_PLAYER_ACCOUNT_NAME], Character[i][E_CHARACTER_LEVEL], Character[i][E_CHARACTER_HOURS]);
					SendClientMessage(playerid, 0xDEDEDEFF, str);
					count ++;
				}
			}
			else
			{
				if (strlen(Character[i][E_CHARACTER_ACC_HIDE_NAME]))
				{
					if (strfind(Character[i][E_CHARACTER_ACC_HIDE_NAME], params, true) != -1 || strfind ( Character [ i ] [ E_CHARACTER_NAME ], params, true ) != -1 ) 
					{
						format(str, sizeof(str), "%d. %s (ID: %d) (Account: %s | Level: %d | Hours: %d)", count, Character[i][E_CHARACTER_NAME_RP], i, Character[i][E_CHARACTER_ACC_HIDE_NAME], Character[i][E_CHARACTER_LEVEL], Character[i][E_CHARACTER_HOURS]);
						SendClientMessage(playerid, 0xDEDEDEFF, str);
						count ++;
					}
				}
				else
				{
					if (strfind ( Character [ i ] [ E_CHARACTER_NAME ], params, true ) != -1 ) 
					{
						format(str, sizeof(str), "%d. %s (ID: %d) (Level: %d | Hours: %d)", count, Character[i][E_CHARACTER_NAME_RP], i, Character[i][E_CHARACTER_LEVEL], Character[i][E_CHARACTER_HOURS]);
						SendClientMessage(playerid, 0xDEDEDEFF, str);
						count ++;
					}
				}
			}
		}

		if (count == 1)
		{
			return SendClientMessage(playerid, COLOR_RED, "No players were found with this name.");
		}
	}

	return true ;
}


GetPlayerNametagPreference(playerid) {

	return Account [ playerid ] [ E_PLAYER_ACCOUNT_NAMESTYLE ] ;
}

CMD:myslots(playerid) {

	/*
		Players can no longer own infinite houses / cars. This shows their used slots.
		In a future update, make this dependant on level / hours played.
	*/

	new owned_houses = Player_GetOwnedHouses ( playerid ) ;
	new max_houses  = Player_GetMaxOwnedHouses ( playerid ) ;

	new owned_bizzes = Player_GetOwnedBusinesses ( playerid ) ;
	new max_bizzes = Player_GetMaxOwnedBusinesses ( playerid ) ;

	new owned_cars = Player_GetOwnedVehicles ( playerid ) ;
	new max_cars = Player_GetMaxOwnedVehicles ( playerid );

	SendClientMessage ( playerid, COLOR_BLUE, "[Player Ownable Slots]:");

	SendClientMessage ( playerid, COLOR_GRAD0, sprintf("[Cars]{DEDEDE} %d / %d slots used.", owned_cars, max_cars )) ;
	SendClientMessage ( playerid, COLOR_GRAD0, sprintf("[House]{DEDEDE} %d / %d slots used.", owned_houses, max_houses )) ;
	SendClientMessage ( playerid, COLOR_GRAD0, sprintf("[Business]{DEDEDE} %d / %d slots used.", owned_bizzes, max_bizzes )) ;

	ZMsg_SendClientMessage ( playerid, COLOR_WARNING, "[Houses]{A3A3A3} (< 150 hours):{dedede} 1 house{a3a3a3} (> 150 hours, < 300 hours):{dedede} 2 houses{a3a3a3} (> 300 hours):{dedede} 3 houses");
	ZMsg_SendClientMessage ( playerid, COLOR_WARNING, "[Businesses]{A3A3A3} (< 100 hours):{dedede} 0 businesses{a3a3a3} (> 100 hours, < 300 hours):{dedede} 1 business{a3a3a3} (> 300 hours):{dedede} 2 businesses");
	ZMsg_SendClientMessage ( playerid, COLOR_WARNING, "[Vehicles]{A3A3A3} (< 150 hours):{dedede} 2 cars{a3a3a3} (> 150 hours, < 300 hours):{dedede} 3 cars{a3a3a3} (> 300 hours, < 500 hours):{dedede} 4 cars{a3a3a3} (> 500  hours):{dedede} 5 cars");


	return true ;
}

IsPlayerNewbie(playerid) { // Universal function to declare whether a player is new to the server.

	// Started playing before the update.
	if (! Account [ playerid ] [ E_PLAYER_REGISTER_DATE ] ) {

		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_GUNACCESS ] ) return false ; // They've got gun access, so theyve been around for a while.
		if ( Account [ playerid ] [ E_PLAYER_REGISTER_LEGACY ] ) return false ; // They've been registered since before the UCP.
		if ( gettime() > (Character [ playerid ] [ E_CHARACTER_REGISTERDATE ] + 604800) ) return false ; // they've had the character for longer than 1 week

		// Only return true IF they've got less than 24 hours played if they registered before this update, 
		// don't have gun access, don't have legacy, and their character is younger than 7 days.
		if ( Character [ playerid ] [ E_CHARACTER_HOURS ] < 24 ) return true ;
	}

	// Player account is younger than 3 weeks
	if ( Account [ playerid ] [ E_PLAYER_REGISTER_DATE ] + 1814400 > gettime() ) {
		// if they've got more than 48 hours played, they're no longer considered "new"
		if ( Character [ playerid ] [ E_CHARACTER_HOURS ] < 48 ) return true ; 
	}

	return false ;
}