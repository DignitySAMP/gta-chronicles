SSCANF:unmaskedplayer(name[]) 
{
    if(isnull(name)) 
    {
        return INVALID_PLAYER_ID ;
    }

    new id, matches;

    if ( sscanf(name, "i", id ) ) 
    {
        foreach(new i : Player) 
        {
            if( strfind( Character [ i ] [ E_CHARACTER_NAME ], name, true ) != -1) 
            {
                matches++;
                id = i;

                if(matches > 1) {
                    return INVALID_PLAYER_ID;
                }
            }            
        }

        if(matches) return id;
        return INVALID_PLAYER_ID;
    }

    if(id < 0 || id > MAX_PLAYERS) {
        return INVALID_PLAYER_ID;
    }

    if (!IsPlayerConnected(id)) {
        return INVALID_PLAYER_ID;
    }

    return id;
}

SSCANF:player(name[]) {

    if(isnull(name)) {

        return INVALID_PLAYER_ID ;
    }

    new id, matches;

    if ( sscanf(name, "i", id ) ) {

        foreach(new i : Player) {

            /*
            if(strfind( Account [ i ] [ E_PLAYER_ACCOUNT_NAME ], name, true) != -1) {
                matches++;
                id = i;

                if(matches > 1) return INVALID_PLAYER_ID;
            }

            else if ( strfind( Character [ i ] [ E_CHARACTER_NAME ], name, true ) != -1) {
                matches++;
                id = i;

                if(matches > 1) return INVALID_PLAYER_ID;
            }*/
            if( strfind( Character [ i ] [ E_CHARACTER_NAME ], name, true ) != -1) 
            {
                matches++;
                id = i;

                if(matches > 1) {
                    return INVALID_PLAYER_ID;
                }
            }            
        }

        if(matches) return id;
        return INVALID_PLAYER_ID;
    }

    if(id < 0) {
        return INVALID_PLAYER_ID;
    }

    if (id > MAX_PLAYERS)
    {
        // Presumably this is a mask id
        foreach(new i : Player) 
        {
            if (PlayerVar[i][E_PLAYER_IS_MASKED] && Character[i][E_CHARACTER_MASKID] == id)
            {
                return i;
            }
        }

        return INVALID_PLAYER_ID;
    }

    if (!IsPlayerConnected(id)) {
        return INVALID_PLAYER_ID;
    }

    return id;
}

ReturnPlayerCharName ( playerid, bool:masked=false ) 
{
    if (IsPlayerMasked(playerid) && masked)
    {
        new name[MAX_PLAYER_NAME];

        /*
        if ( IsPlayerHitman ( playerid ) ) {
            format ( name, sizeof ( name ), "Stranger 666" ) ;
        }
        */

        format ( name, sizeof ( name ), "Stranger %d", GetPlayerMaskID(playerid) ) ;
        return name;
    }

    new name[MAX_PLAYER_NAME];
    format(name, MAX_PLAYER_NAME, Character[playerid][E_CHARACTER_NAME]);

    for (new i = 0, len = strlen(name); i < len; i ++) 
    {
        if (name[i] == '_') name[i] = ' ';
    }
    
    return name;
}

ReturnPlayerNameDataHex(playerid,color=true) {

    new name[64], faction_enum_id, faction_type;

    if ( ! IsPlayerMasked(playerid) ) {

        GetPlayerName ( playerid, name, sizeof ( name ) ) ;

        name [ 0 ] = EOS ;
        if ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {

            faction_enum_id = Faction_GetEnumID ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) ;
            faction_type = Faction_GetType(faction_enum_id );

            if (!IsPlayerInDutyFaction(playerid) || PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ])
            {
                new hexcolor = -1;
                if (faction_type == FACTION_TYPE_POLICE)
                {
                    // strcat(name, sprintf("[LSPD]%s", Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ] ) ) ;
                    hexcolor = 0x304EDFFF ;
                }
                else if (faction_type == FACTION_TYPE_EMS)
                {
                    // strcat(name, sprintf("[LSFD]%s", Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ] ) ) ;
                    hexcolor = 0xDF303BFF ;
                }
                else if (faction_type == FACTION_TYPE_NEWS )
                {
                    // strcat(name, sprintf("[SAN]%s", Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ] ) ) ;
                    hexcolor = 0x2b87a1FF ;
                }
                else
                {
                    hexcolor = Faction [ faction_enum_id ] [ E_FACTION_HEXCOLOR ] ;
                }

                if (color)
                {
                    format ( name, sizeof ( name ), "{%06x}[%s]%s", ( hexcolor >>> 8), Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ; 
                } 
                else
                {
                    format ( name, sizeof ( name ), "[%s]%s", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ; 
                }  
                
            }
            else  format(name, sizeof(name), "%s", Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ;
        }

        else  format(name, sizeof(name), "%s", Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ;
    }

    else if ( IsPlayerMasked(playerid) ) 
    {
        /*
        if ( IsPlayerHitman ( playerid ) ) {
            format ( name, sizeof ( name ), "Stranger 666" ) ;
        }
        */

        format ( name, sizeof ( name ), "Stranger %d", GetPlayerMaskID(playerid) ) ;
    }

    return name;
}

/*
enum E_PLAYER_NAME_STYLE
{
    PLAYER_NAME_STYLE_ROLEPLAY,   // RP name (so char name replaced with spaces, but uses mask if masked)
    PLAYER_NAME_STYLE_CHARACTER,  // Char name replaced by spaces, ignores mask
    PLAYER_NAME_STYLE_ACCOUNT,    // Account name
    PLAYER_NAME_STYLE_LEGACY,     // Old shit like Account (F. Last)
    PLAYER_NAME_STYLE_DEFAULT     // Wrapper for default GetPlayerName
}
*/

// Definition of these is in gamemmode for now

SOLS_PlayerName(playerid, E_PLAYER_NAME_STYLE:namestyle = PLAYER_NAME_STYLE_ROLEPLAY)
{
    new returned_name[64];

    if (!Character[playerid][E_CHARACTER_NAME_CACHED_AT])
    {
        UpdatePlayerNameCache(playerid);
    }

    switch (namestyle)
    {
        case PLAYER_NAME_STYLE_ROLEPLAY:
        {
            format(returned_name, sizeof(returned_name), "%s", Character[playerid][E_CHARACTER_NAME_MASK]);
        }
        case PLAYER_NAME_STYLE_CHARACTER:
        {
            format(returned_name, sizeof(returned_name), "%s", Character[playerid][E_CHARACTER_NAME_RP]);
        }
        case PLAYER_NAME_STYLE_ACCOUNT:
        {
            format(returned_name, sizeof(returned_name), "%s", Account[playerid][E_PLAYER_ACCOUNT_NAME]);
        }
        case PLAYER_NAME_STYLE_LEGACY:
        {
            format(returned_name, sizeof(returned_name), "%s (%s)", Character[playerid][E_CHARACTER_NAME_RP], Account[playerid][E_PLAYER_ACCOUNT_NAME]);
        }
        default:
        {
            GetPlayerName(playerid, returned_name, sizeof(returned_name));
        }
    }

    return returned_name;
}

// DONT USE THIS ANYMORE, USE NEW FUNC ABOVE!!!!
ReturnPlayerNameData ( playerid, handler = 0, charname = 0 ) 
{
    new name[96], shortname[MAX_PLAYER_NAME];
    #pragma unused handler, shortname

    if (!Character[playerid][E_CHARACTER_NAME_CACHED_AT])
    {
        UpdatePlayerNameCache(playerid);
    }

    if (!charname)
    {
        // This is the old names: "account (f. last)"

        /*
        format(shortname, sizeof ( shortname ), "%s", Character [ playerid ] [ E_CHARACTER_NAME ] ) ;
        strdel ( shortname, 0, strfind(shortname,"_",true) + 1);
        format ( name, sizeof ( name ), "%s (%.1s. %s)", Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ], Character [ playerid ] [ E_CHARACTER_NAME ], shortname ) ;
        */

        // New format for this now emphasizes char name over acc name
        format ( name, sizeof ( name ), "%s (%s)", Character[playerid][E_CHARACTER_NAME_RP], Account[playerid][E_PLAYER_ACCOUNT_NAME]);

    }
    else
    {
        // this will return their first_last without spaces, or their mask name
        format ( name, sizeof ( name ), "%s", Character[playerid][E_CHARACTER_NAME_MASK] );
    }

    /*
     if ( IsPlayerHitman ( playerid ) ) {
            format ( name, sizeof ( name ), "Stranger 666" ) ;
        }
    */

    return name;
}

UpdatePlayerNameCache(playerid)
{
    // update our name cache
    format(Character[playerid][E_CHARACTER_NAME_RP], MAX_PLAYER_NAME, ReturnPlayerCharName(playerid, false));
    format(Character[playerid][E_CHARACTER_NAME_MASK], MAX_PLAYER_NAME, ReturnPlayerCharName(playerid, true));
    Character[playerid][E_CHARACTER_NAME_CACHED_AT] = gettime();
}

CMD:fixname(playerid, params[])
{
    if (!GetPlayerAdminLevel(playerid)) return false;

    new giveplayerid;
    if (sscanf(params, "d", giveplayerid)) return SendClientMessage(playerid, COLOR_ERROR, "/fixname [player ID]");
    if (giveplayerid < 0 || giveplayerid >= MAX_PLAYERS) return SendClientMessage(playerid, COLOR_ERROR, "/fixname [player ID]");

    UpdatePlayerNameCache(giveplayerid);
    return true;
}