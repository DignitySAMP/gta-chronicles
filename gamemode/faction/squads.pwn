enum E_FACTION_SQUAD
{
	E_FACTION_SQUAD_ID,
	E_FACTION_SQUAD_FACTION_TYPE,
	E_FACTION_SQUAD_NAME[24]
}

static const Squads[][E_FACTION_SQUAD] = 
{
    {FACTION_SQUAD_NONE, -1, "None"},
    {FACTION_SQUAD_CRASH, FACTION_TYPE_POLICE, "Detective"},
    {FACTION_SQUAD_SWAT, FACTION_TYPE_POLICE, "SWAT"},
    {FACTION_SQUAD_IAG, FACTION_TYPE_POLICE, "Internal Affairs"},
    {FACTION_SQUAD_TRAFF, FACTION_TYPE_POLICE, "Traffic"},
    {FACTION_SQUAD_AIR, FACTION_TYPE_POLICE, "Air Support"},

    {FACTION_SQUAD_ARSON, FACTION_TYPE_EMS, "Arson"},

    {FACTION_SQUAD_ARMED, FACTION_TYPE_SECURITY, "Armed Security"},

    {FACTION_SQUAD_GOV_DAO, FACTION_TYPE_GOV, "DA's Office"},
    {FACTION_SQUAD_GOV_PW, FACTION_TYPE_GOV, "Public Works"},
    {FACTION_SQUAD_GOV_ADMIN, FACTION_TYPE_GOV, "Public Admin"},
    {FACTION_SQUAD_GOV_COURT, FACTION_TYPE_GOV, "Judicial"},
    {FACTION_SQUAD_GOV_COUNCIL, FACTION_TYPE_GOV, "City Council"},
    {FACTION_SQUAD_GOV_TRAFFIC, FACTION_TYPE_GOV, "Traffic"}
};

GetPlayerFactionSquad(playerid)
{
	if (Character [ playerid ] [ E_CHARACTER_FACTIONID ])
	{
		return Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ];
	}
	
	return 0;
}

IsPlayerInFactionSquad(playerid, squad, factiontype = -1, bool:onduty=false)
{
	if (factiontype != -1)
	{
		if (!IsPlayerInFactionType(playerid, factiontype, onduty)) return 0;
	}

	return Character [ playerid ] [ E_CHARACTER_FACTIONID ] && Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ] == squad;
}

CMD:setsquad(playerid, params[]) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}
	
	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2) 
	{
		// 1 : owner, 2: command, 3 : member
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

    new userid = INVALID_PLAYER_ID, option = -1, helpstr[128], squad = -1;
	sscanf ( params, "k<player>i", userid, option );

    format(helpstr, sizeof(helpstr), "Available Squads: ");
    new index = 0;

    for (new i = 0; i < sizeof(Squads); i ++)
    {
        if (Squads[i][E_FACTION_SQUAD_FACTION_TYPE] != -1 && GetPlayerFactionType(playerid) != Squads[i][E_FACTION_SQUAD_FACTION_TYPE]) continue;
        else if (index) strcat(helpstr, ", ");

        format(helpstr, sizeof(helpstr), "%s%d: %s", helpstr, Squads[i][E_FACTION_SQUAD_ID], Squads[i][E_FACTION_SQUAD_NAME]);
        
        if (option >= 0 && option == Squads[i][E_FACTION_SQUAD_ID])
        {
            squad = i;
            break;
        }
        
        index ++;
    }

    if (index < 1)
    {
        // return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Your faction doesn't have any squads.");
    }

    if (squad == -1)
    {
        SendClientMessage(playerid, 0xDEDEDEFF, helpstr);
        SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setsquad [player] [squad]" );
        return true;
    }

    if (!IsPlayerConnected(userid) || !IsPlayerPlaying(userid) || !IsPlayerInFaction(userid, factionid))
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Invalid player or this player isn't in your faction.");
    }

    if (Character[playerid][E_CHARACTER_FACTIONTIER] == 2)
    {
        new their_squad = Character[userid][E_CHARACTER_FACTION_SQUAD];
        new our_squad = Character[playerid][E_CHARACTER_FACTION_SQUAD];

        if (!our_squad || (our_squad != Squads[squad][E_FACTION_SQUAD_ID] && squad != 0) || (their_squad && their_squad != our_squad)) 
            return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "As Tier 2, you can only change the membership of the squad you're in.");
    }

    Character[userid][E_CHARACTER_FACTION_SQUAD] = Squads[squad][E_FACTION_SQUAD_ID];

    new query[128];
    mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_factionsquad = %d WHERE player_id = %d", Character[userid][E_CHARACTER_FACTION_SQUAD], Character[userid][E_CHARACTER_ID]);
	mysql_tquery(mysql, query);

    Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s set the squad of (%d) %s to \"%s\" }",
		Faction[faction_enum_id][ E_FACTION_ABBREV], playerid, SOLS_PlayerName(playerid), userid, SOLS_PlayerName(userid), Squads[squad][E_FACTION_SQUAD_NAME]
	), faction_enum_id, false, false, 0, true ) ;
	
	return true ;
}


CMD:offlinesetsquad(playerid, params[]) 
{
	new factionid = Character [playerid][E_CHARACTER_FACTIONID];
	new fac_enum_id = INVALID_FACTION_ID;

	if (factionid)
	{
		fac_enum_id = Faction_GetEnumID(factionid); 
	}

	if (!factionid || fac_enum_id == INVALID_FACTION_ID || Character[playerid][E_CHARACTER_FACTIONTIER] > 2) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're either not in a faction or not a high enough tier to do this.");
	}

	new offline_name[32], option = -1, helpstr[128], squad = -1;
    sscanf(params, "s[32]d", offline_name, option);

	format(helpstr, sizeof(helpstr), "Available Squads: ");
    new index = 0;

    for (new i = 0; i < sizeof(Squads); i ++)
    {
        if (Squads[i][E_FACTION_SQUAD_FACTION_TYPE] != -1 && GetPlayerFactionType(playerid) != Squads[i][E_FACTION_SQUAD_FACTION_TYPE]) continue;
        else if (index) strcat(helpstr, ", ");

        format(helpstr, sizeof(helpstr), "%s%d: %s", helpstr, Squads[i][E_FACTION_SQUAD_ID], Squads[i][E_FACTION_SQUAD_NAME]);
        
        if (option >= 0 && option == Squads[i][E_FACTION_SQUAD_ID])
        {
            squad = i;
            break;
        }
        
        index ++;
    }

    if (!strlen(offline_name) || squad == -1)
    {
        SendClientMessage(playerid, 0xDEDEDEFF, helpstr);
        SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/o(ffline)setsquad [firstname_lastname] [squad]" );
        return true;
    }

	new query[256];
	mysql_format(mysql, query, sizeof(query), "SELECT `player_id`, `player_name`, `player_factionsquad`, `player_factiontier` FROM `characters` WHERE `player_name` LIKE '%e' AND `player_factionid` = '%d' LIMIT 1", offline_name, factionid); 

	inline OnOfflineSetSquad() 
	{
		new rows, fields, player_id, player_squad, player_tier, player_name[32];
		cache_get_data(rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You entered an invalid character name (or this character isn't in your faction).");
		}

		cache_get_field_content(0, "player_name", player_name, mysql, 34);
		player_id = cache_get_field_int(0, "player_id");
        player_squad = cache_get_field_int(0, "player_factionsquad");
        player_tier = cache_get_field_int(0, "player_factiontier");

        foreach(new idx: Player) 
		{
			if (Character[idx][E_CHARACTER_ID] == player_id) 
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player is online.");
			}
		}

        if (Character[playerid][E_CHARACTER_FACTIONTIER] != 1)
        {
            if (player_tier <= Character[playerid][E_CHARACTER_FACTIONTIER])
            {
                return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "As Tier 2, you can't edit faction members of equal or higher rank.");
            }

            new their_squad = player_squad;
            new our_squad = Character[playerid][E_CHARACTER_FACTION_SQUAD];

            if (!our_squad || (our_squad != their_squad && their_squad != 0)) 
                return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "As Tier 2, you can only change the membership of your own Squad.");
        }

		mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `player_factionsquad` = %d WHERE `player_id` = %d", Squads[squad][E_FACTION_SQUAD_ID], player_id); 
		mysql_tquery(mysql, query);

		Faction_SendMessage(factionid, sprintf("{ [%s] %s has offline-set the squad of %s to \"%s\" }", Faction[fac_enum_id][E_FACTION_ABBREV], ReturnPlayerNameData(playerid, 0, true), player_name, Squads[squad][E_FACTION_SQUAD_NAME]), fac_enum_id, false, false, 0, true);
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineSetSquad, "");
	return true ;
}

CMD:osetsquad(playerid, params[])
{
	return cmd_offlinesetsquad(playerid, params);
}
