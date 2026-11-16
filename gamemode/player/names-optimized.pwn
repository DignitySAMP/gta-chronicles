#include <YSI_Coding\y_hooks>

new DynamicText3D: PlayerNameTag[MAX_PLAYERS][MAX_PLAYERS];

hook OnGameModeInit() 
{
	for (new playerid; playerid < MAX_PLAYERS; playerid ++) 
    {
		for (new forplayerid; forplayerid < MAX_PLAYERS; forplayerid ++) 
        {
			PlayerNameTag[playerid][forplayerid] = CreateDynamic3DTextLabel(" ", -1, 0.0, 0.0, 0.15, 15.0, forplayerid, INVALID_VEHICLE_ID, true, -1, -1, playerid, -1, -1, 1);
		}
	}

    return 1;
}

hook OnPlayerSpawn(playerid) 
{
	UpdatePlayerNamesForPlayer(playerid);
	UpdatePlayerNamesForOthers(playerid);
    return 1;
}

hook OnPlayerStreamIn(playerid, forplayerid) 
{
    if(IsPlayerStreamedIn(playerid, forplayerid))
    {
		UpdatePlayerNamesForPlayer(playerid);
		UpdatePlayerNamesForOthers(playerid);
    }

    // Issue a streamer update too :)
    // Streamer_Update(forplayerid, STREAMER_TYPE_3D_TEXT_LABEL);
    
    /*
    if (!LastUpdate || (gettime() - LastUpdate) > 4)
    {
        Streamer_ProcessActiveItems();
        LastUpdate = gettime();
    }
    */

    return 1;
}

//hook OnPlayerDisconnect(playerid, reason)
hook SOLS_OnCloseConnection(playerid, reason)
{
    // When a hacking admin disconnects, recreate the nametags as default
    if (PlayerVar[playerid][E_PLAYER_ADMIN_WALLHACK])
    {
        for ( new i; i < MAX_PLAYERS; i ++ ) 
        {
            DestroyDynamic3DTextLabel(PlayerNameTag [ playerid ] [ i ]);
            PlayerNameTag [ playerid ] [ i ] = CreateDynamic3DTextLabel(" ", -1, 0.0, 0.0, 0.15, 15.0, i, INVALID_VEHICLE_ID, true, -1, -1, playerid, -1, -1, 1);
        }
    }
    
    return 1;
}

hook SOLS_OnAdmDutyChange(playerid)
{
    // When a hacking admin does /aduty off, recreate the nametags as default
    if (PlayerVar[playerid][E_PLAYER_ADMIN_WALLHACK] && !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY])
    {
        for ( new i; i < MAX_PLAYERS; i ++ ) 
        {
            DestroyDynamic3DTextLabel(PlayerNameTag [ playerid ] [ i ]);
            PlayerNameTag [ playerid ] [ i ] = CreateDynamic3DTextLabel(" ", -1, 0.0, 0.0, 0.15, 15.0, i, INVALID_VEHICLE_ID, true, -1, -1, playerid, -1, -1, 1);
        }

        PlayerVar[playerid][E_PLAYER_ADMIN_WALLHACK] = false;
    }

    return 1;
}

UpdatePlayerNamesForPlayer(playerid) {

	foreach(new targetid: Player) {
		UpdatePlayerNameTag(playerid, targetid);
	}

	return true ;
}

UpdatePlayerNamesForOthers(playerid) {

	foreach(new targetid: Player) {
		UpdatePlayerNameTag(targetid, playerid);
	}

	return true ;
}

static const CachedIntegratedHealthBar[][24] = 
{
    "{660000}",  // 0 - 9
    "{741717}",  // 10
    "{822e2e}",  // 20
    "{904646}",  // 30
    "{ac7474}",  // 40
    "{b98b8b}",  // 50
    "{c7a2a2}",  // 60
    "{d5b9b9}",  // 70
    "{e3d1d1}",  // 80
    "{f1e8e8}",  // 90
    "{FFFFFF}"   // 100
};

static const CachedHealthBar[][24] = 
{
    "{660000}°°°°°°°°°°",  // 0 - 9
    "°{660000}°°°°°°°°°",  // 10
    "°°{660000}°°°°°°°°",  // 20
    "°°°{660000}°°°°°°°",  // 30
    "°°°°{660000}°°°°°°",  // 40
    "°°°°°{660000}°°°°°",  // 50
    "°°°°°°{660000}°°°°",  // 60
    "°°°°°°°{660000}°°°",  // 70
    "°°°°°°°°{660000}°°",  // 80
    "°°°°°°°°°{660000}°",  // 90
    "°°°°°°°°°°"           // 100
};

static const CachedKevlarBar[][24] = 
{
    "{666666}----------",   // 0 - 9
    "-{666666}---------",  // 10
    "--{666666}--------",  // 20
    "---{666666}-------",  // 30
    "----{666666}------",  // 40
    "-----{666666}-----",  // 50
    "------{666666}----",  // 60
    "-------{666666}---",  // 70
    "--------{666666}--",  // 80
    "---------{666666}-",  // 90
    "----------"           // 100
};

static namestr[256];

UpdatePlayerNameTag(playerid, forplayerid)
{
    if ( PlayerVar [ playerid ] [ E_PLAYER_NICKS_TOGGLED ] ) 
    {
        UpdateDynamic3DTextLabelText(PlayerNameTag [ playerid ] [ forplayerid ], 0xDEDEDEFF, " " ) ;
        return true ;
    }

    new armor = floatround(GetCharacterArmour ( forplayerid ), floatround_floor);
    new hp = floatround( (GetCharacterHealth ( forplayerid ) / 10.0), floatround_floor);
    new ap = armor / 10;
    namestr[0] = EOS;

    if (hp > 10) hp = 10;
    else if (hp < 0) hp = 0;

    if (ap > 10) ap = 10;
    else if (ap < 0) ap = 0;

    if ( PlayerVar [ forplayerid ] [ E_PLAYER_LOGOUT_TICK ] ) 
    {
        format ( namestr, sizeof ( namestr ),"{1F85DE}[ Using /logout ]{DEDEDE}\n" );
    }
    else if ( IsPlayerPaused ( forplayerid ) ) 
    {
        if (PlayerVar [ forplayerid ] [ E_PLAYER_ADMIN_DUTY ])
        {
            format ( namestr, sizeof ( namestr ),"{DE2E1F}[ Paused ]{E9971B}\n" );
        } 
        else format ( namestr, sizeof ( namestr ),"{DE2E1F}[ Paused ]{DEDEDE}\n" );
    }
    else if ( PlayerVar [ forplayerid ] [ E_PLAYER_ADMIN_DUTY ]  ) 
    {
        format ( namestr, sizeof ( namestr ),"{DBB275}[ Admin On Duty ]{E9971B}\n" );
    } 
    else if (PlayerVar [ forplayerid ] [ E_PLAYER_HELPER_DUTY ] )
    {
        format ( namestr, sizeof ( namestr ), "{AEC77D}[ Helper On Duty ]{DEDEDE}\n" );
    } 
    else if (PlayerVar [ forplayerid ] [ E_PLAYER_IS_OOC ] ) 
    {
        format ( namestr, sizeof ( namestr ), "{AAC4E5}(( Out Of Character )){DEDEDE}\n" );
    } 

    //GetNameTagHealthBar(forplayerid, hp_bar ) ;
    //GetNameTagArmourBar(forplayerid, kev_bar ) ;

    if(Account [ playerid ][E_PLAYER_SETTING_NAMESTYLE] == 0 ) {

        if (PlayerVar[forplayerid][E_PLAYER_ADMIN_DUTY])
        {
            format ( namestr, sizeof ( namestr ), "%s%s (%d)", namestr, Account[forplayerid][E_PLAYER_ACCOUNT_NAME], forplayerid ) ;
        }
        else if (PlayerVar [ forplayerid ] [ E_PLAYER_IS_MASKED ])
        {
            if ( armor ) format ( namestr, sizeof ( namestr ), "%sStranger (%d)\n{FFFFFF}%s\n{FF0000}%s", namestr, Character[forplayerid][E_CHARACTER_MASKID], CachedKevlarBar[ap], CachedHealthBar[hp] ) ;
            else format ( namestr, sizeof ( namestr ), "%sStranger (%d)\n{FF0000}%s", namestr, Character[forplayerid][E_CHARACTER_MASKID], CachedHealthBar[hp] ) ;
        }
        else
        {
            if ( armor ) format ( namestr, sizeof ( namestr ), "%s%s (%d)\n{FFFFFF}%s\n{FF0000}%s", namestr, Character[forplayerid][E_CHARACTER_NAME_MASK], forplayerid, CachedKevlarBar[ap], CachedHealthBar[hp] ) ;
            else format ( namestr, sizeof ( namestr ), "%s%s (%d)\n{FF0000}%s", namestr, Character[forplayerid][E_CHARACTER_NAME_MASK], forplayerid, CachedHealthBar[hp] ) ;
        }

    } else if(Account [ playerid ][E_PLAYER_SETTING_NAMESTYLE] == 1) {

        if (PlayerVar[forplayerid][E_PLAYER_ADMIN_DUTY])
        {
            format ( namestr, sizeof ( namestr ), "%s%s (%d)", namestr, Account[forplayerid][E_PLAYER_ACCOUNT_NAME], forplayerid ) ;
        }
        else if (PlayerVar [ forplayerid ] [ E_PLAYER_IS_MASKED ])
        {
            if ( armor ) format ( namestr, sizeof ( namestr ), "%s%sStranger (%d)\n{FFFFFF}%s", namestr, CachedIntegratedHealthBar[hp], Character[forplayerid][E_CHARACTER_MASKID], CachedKevlarBar[ap] ) ;
            else format ( namestr, sizeof ( namestr ), "%s%sStranger (%d)", namestr, CachedIntegratedHealthBar[hp], Character[forplayerid][E_CHARACTER_MASKID] ) ;
        }
        else
        {
            if ( armor ) format ( namestr, sizeof ( namestr ), "%s%s%s (%d)\n{FFFFFF}%s", namestr, CachedIntegratedHealthBar[hp], Character[forplayerid][E_CHARACTER_NAME_MASK], forplayerid, CachedKevlarBar[ap] ) ;
            else format ( namestr, sizeof ( namestr ), "%s%s%s (%d)", namestr, CachedIntegratedHealthBar[hp], Character[forplayerid][E_CHARACTER_NAME_MASK], forplayerid ) ;
        }  

    }

	UpdateDynamic3DTextLabelText(PlayerNameTag [ playerid ] [ forplayerid ], 0xDEDEDEFF, namestr ) ;
	return true ;
}

/*
GetNameTagHealthBar(playerid, bar[], len = sizeof ( bar ) ) {

    switch ( floatround( GetCharacterHealth ( playerid ) ) ) {

        case 100 .. 200 :   format ( bar, len, "°°°°°°°°°°"         ) ;
        case 90 .. 99:      format ( bar, len, "°°°°°°°°°{660000}°" ) ;
        case 80 .. 89:      format ( bar, len, "°°°°°°°°{660000}°°" ) ;
        case 70 .. 79:      format ( bar, len, "°°°°°°°{660000}°°°" ) ;      
        case 60 .. 69:      format ( bar, len, "°°°°°°{660000}°°°°" ) ;      
        case 50 .. 59:      format ( bar, len, "°°°°°{660000}°°°°°" ) ;      
        case 40 .. 49:      format ( bar, len, "°°°°{660000}°°°°°°" ) ;      
        case 30 .. 39:      format ( bar, len, "°°°{660000}°°°°°°°" ) ;     
        case 20 .. 29:      format ( bar, len, "°°{660000}°°°°°°°°" ) ;     
        case 10 .. 19:      format ( bar, len, "°{660000}°°°°°°°°°" ) ;
        default:            format ( bar, len, "{660000}°°°°°°°°°°" ) ; // 0 .. 9:
    }
}


GetNameTagArmourBar(playerid, bar[], len = sizeof ( bar ) ) {

    switch ( floatround( GetCharacterArmour ( playerid ) ) ) {

        case 100 .. 200 :   format ( bar, len, "----------"         ) ;
        case 90 .. 99:      format ( bar, len, "---------{666666}-" ) ;
        case 80 .. 89:      format ( bar, len, "--------{666666}--" ) ;
        case 70 .. 79:      format ( bar, len, "-------{666666}---" ) ;      
        case 60 .. 69:      format ( bar, len, "------{666666}----" ) ;      
        case 50 .. 59:      format ( bar, len, "-----{666666}-----" ) ;      
        case 40 .. 49:      format ( bar, len, "----{666666}------" ) ;      
        case 30 .. 39:      format ( bar, len, "---{666666}-------" ) ;     
        case 20 .. 29:      format ( bar, len, "--{666666}--------" ) ;     
        case 10 .. 19:      format ( bar, len, "-{666666}---------" ) ;
        default:            format ( bar, len, "{666666}----------" ) ; // 0 .. 9:
    }
}
*/

CMD:synctags(playerid) {

    UpdatePlayerNamesForPlayer ( playerid );
    Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
    SendClientMessage(playerid, COLOR_INFO, "Updated the nametags of other players for you." ) ;

    return true ;
}

CMD:names(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < 2) return 0;

    new Float:range, testlos;

	if ( sscanf ( params, "fD(1)", range, testlos ) ) 
    {
		return SendClientMessage(playerid, -1, "/names [distance | 15.0] [line of sight | 1]" ) ;
	}

    if (!PlayerVar[playerid][E_PLAYER_ADMIN_DUTY] && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "You must be on admin duty to do this.");

    for ( new i; i < MAX_PLAYERS; i ++ ) 
    {
        DestroyDynamic3DTextLabel(PlayerNameTag [ playerid ] [ i ]);
        PlayerNameTag [ playerid ] [ i ] = CreateDynamic3DTextLabel(" ", -1, 0.0, 0.0, 0.15, range, i, INVALID_VEHICLE_ID, testlos, -1, -1, playerid, -1, -1, 1);
	}

    PlayerVar[playerid][E_PLAYER_ADMIN_WALLHACK] = true;
    
    UpdatePlayerNamesForPlayer(playerid);
    Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
    return 1;
}