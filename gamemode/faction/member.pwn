CMD:invite(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/invite [target]");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target is already in a faction!");
	}

	Character [ target ] [ E_CHARACTER_FACTIONID ] =  Character [ playerid ] [ E_CHARACTER_FACTIONID ]  ;
	Character [ target ] [ E_CHARACTER_FACTIONTIER ] = 3 ;
	Character [ target ] [ E_CHARACTER_FACTION_SUSPENSION ] = 0 ;
	Character [ target ] [ E_CHARACTER_FACTIONRANK ] [ 0 ] = EOS ;
	strcat(Character [ target ] [ E_CHARACTER_FACTIONRANK ], "New Member" ) ;
	PlayerVar[target][E_PLAYER_PD_RADIO_CHANNEL] = -1;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionid = %d, player_factiontier = 3, player_factionsuspension = 0, player_factionrank = 'New Member' WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_FACTIONID ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);


	//Player_UpdateNameTag(target)  ;
	//UpdatePlayerNamesForOthers ( playerid ) ;

	Faction_SendMessage(factionid, sprintf("{ [%s] %s has invited %s to the faction. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true )
	), faction_enum_id, false, false, 0, true ) ;

	return true ;
}

CMD:uninvite(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 1 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/uninvite [target]");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONTIER ] <  Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target's tier has more privileges than you, so you can't modify them.");
	}

	Faction_SendMessage(factionid, sprintf("{ [%s] %s has removed %s from the faction. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true )
	), faction_enum_id, false, false, 0, true ) ;

	
	if(IsPlayerInPoliceFaction(target) || IsPlayerInDEAFaction(target) || IsPlayerInSecurityFaction(target)){
		ResetPlayerWeapons(target) ;
		Weapon_ResetPlayerWeapons(target) ;
	}

	Character [ target ] [ E_CHARACTER_FACTIONID ] = 0 ;
	Character [ target ] [ E_CHARACTER_FACTIONTIER ] = 3 ;
	Character [ target ] [ E_CHARACTER_FACTION_SUSPENSION ] = 0 ;
	Character [ target ] [ E_CHARACTER_FACTIONRANK ] [ 0 ] = EOS ;
	strcat(Character [ target ] [ E_CHARACTER_FACTIONRANK ], "None" ) ;

	Character [ target ] [ E_CHARACTER_FACTION_SQUAD ] = 0 ;
	PlayerVar [ target ] [ E_PLAYER_FACTION_DUTY ] = false;
	PlayerVar[target][E_PLAYER_PD_RADIO_CHANNEL] = -1;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionid = 0, player_factiontier = 3, player_factionsuspension = 0, player_factionrank = 'None', player_factionsquad = 0 WHERE player_id = %d", Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	UpdatePlayerNamesForOthers ( target ) ;
	//Player_UpdateNameTag(target)  ;

	return true ;
}

CMD:suspend(playerid, params[]) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid || !IsPlayerInDutyFaction(playerid) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can suspend its members.");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new target, hours, seconds;

	if ( sscanf ( params, "k<player>d", target, hours ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/suspend [player] [hours] (Setting 0 hours will unsuspend)");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONTIER ] <=  Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target's tier has the same or more privileges than you, so you can't suspend them.");
	}

	if (hours < 0 || hours > 120)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't suspend someone for less than 0 or more than 120 hours.");
	}

	seconds = hours * 3600;

	if (hours == 0)
	{
		Faction_SendMessage(factionid, sprintf("{ [%s] %s has unsuspended %s from the faction. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true )), faction_enum_id, false, false, 0, true ) ;
		Character[target][E_CHARACTER_FACTION_SUSPENSION] = 0;
	}
	else
	{
		Faction_SendMessage(factionid, sprintf("{ [%s] %s has suspended %s from the faction for %d hours. }", Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true ), hours), faction_enum_id, false, false, 0, true ) ;
		Character[target][E_CHARACTER_FACTION_SUSPENSION] = gettime() + seconds;
	}

	new query [ 256 ] ;
	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionsuspension = %d WHERE player_id = %d", Character[target][E_CHARACTER_FACTION_SUSPENSION], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	return true ;
}

CMD:settier(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new target, tier ;

	if ( sscanf ( params, "k<player>i", target, tier ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Tiers: 1. Owner | 2. Commander | 3. Normal | 4. Restricted");
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/settier [target] [tier]");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( tier < 1 || tier > 4 ) {
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Tier can't be less than 1 or higher than 4.");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONTIER ] <  Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target's tier has more privileges than you, so you can't modify them.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > tier ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't set a tier that's more privileged than your own.");	
	}

	Character [ target ] [ E_CHARACTER_FACTIONTIER ] = tier ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factiontier = %d WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_FACTIONTIER ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	Faction_SendMessage(factionid, sprintf("{ [%s] %s has changed %s to tier %d. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true ), tier
	), faction_enum_id, false, false, 0, true ) ;


	return true ;
}

CMD:adminfactionjoin(playerid, params[]) {

	return cmd_afjoin(playerid, params);
}

CMD:afjoin(playerid, params[]) 
{
	if (!IsFactionAdmin(playerid) && GetPlayerAdminLevel(playerid) < ADMIN_LVL_SENIOR)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You're not a faction admin.");
	}

	new factionid ;

	if ( sscanf ( params, "i", factionid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/afjoin [faction]");	
	}

	if ( factionid < 0 || factionid >= MAX_FACTIONS || Faction [ factionid ] [ E_FACTION_ID ] == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This faction does not exist.");	
	}

	Character [ playerid ] [ E_CHARACTER_FACTIONID ] = Faction [ factionid ] [ E_FACTION_ID ] ;
	Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] = 1 ;


	Character [ playerid ] [ E_CHARACTER_FACTIONRANK ] [ 0 ] = EOS ;
	strcat(Character [ playerid ] [ E_CHARACTER_FACTIONRANK ], "Admin" ) ;

	SendClientMessage(playerid, COLOR_INFO, sprintf("You temporarily joined faction %d (%s) as Tier 1.",
		factionid, Faction [ factionid ] [ E_FACTION_NAME ])) ;

	Radio_InitializePlayer(playerid);

	return true ;
}

CMD:setbadge(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new target, badge;

	if ( sscanf ( params, "k<player>d", target, badge ) || badge < 0 || badge > 9999 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setbadge [target] [badge number]");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

	Character [ target ] [ E_CHARACTER_FACTION_BADGE ] = badge;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionbadge = %d WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_FACTION_BADGE ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	Faction_SendMessage(factionid, sprintf("{ [%s] %s set badge #%03d for %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid,0,true ), Character [ target ] [ E_CHARACTER_FACTION_BADGE ], ReturnPlayerNameData ( target,0,true )
	), faction_enum_id, false, false, 0, true ) ;


	return true ;
}

CMD:setrank(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}
	

	new target, rank [ 64 ] ;

	if ( sscanf ( params, "k<player>s[64]", target, rank ) || !strcmp(rank, "Admin")) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setrank [target] [rank]");
	}

	if ( ! IsPlayerConnected ( target ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONID ] != Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't in the same faction as you!");
	}

	if ( Character [ target ] [ E_CHARACTER_FACTIONTIER ] <  Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target's tier has more privileges than you, so you can't modify them.");
	}

	if ( target == playerid && Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] != 1 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't modify your own rank.");	
	}

	Character [ target ] [ E_CHARACTER_FACTIONRANK ] [ 0 ] = EOS ;
	strcat(Character [ target ] [ E_CHARACTER_FACTIONRANK ], rank) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionrank = '%e' WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_FACTIONRANK ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	Faction_SendMessage(factionid, sprintf("{ [%s] %s has changed %s to %s. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid,0,true ), ReturnPlayerNameData ( target,0,true ), Character [ target ] [ E_CHARACTER_FACTIONRANK ]
	), faction_enum_id, false, false, 0, true ) ;


	return true ;
}

CMD:togfchat(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	Faction [ faction_enum_id ] [ E_FACTION_CHAT ] = !Faction [ faction_enum_id ] [ E_FACTION_CHAT ] ;

	switch ( Faction [ faction_enum_id ] [ E_FACTION_CHAT ] ) {

		case false : {
			Faction_SendMessage(factionid, sprintf("{ [%s] %s has disabled the faction chat. }",

				Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true )
			), faction_enum_id, false, false, 0, true ) ;
		}

		case true: {

			Faction_SendMessage(factionid, sprintf("{ [%s] %s has enabled the faction chat. }",

				Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid, 0, true )
			), faction_enum_id, false, false, 0, true ) ;
		}
	}

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE factions SET faction_chat = %d WHERE faction_id = %d",
		Faction [ faction_enum_id ] [ E_FACTION_CHAT ], Faction [ faction_enum_id ] [ E_FACTION_ID ] ) ;

	mysql_tquery ( mysql, query ) ;

	return true ;
}

CMD:nofac(playerid, params[])
{
	return cmd_togfchat(playerid, params);
}

CMD:faction(playerid, params[]) {
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( ! Faction [ faction_enum_id ] [ E_FACTION_CHAT ] && Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This faction's chat is disabled.");
	}


	new input [ 128 ] ;

	if ( sscanf ( params, "s[128]", input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/f(action) [text]");
	}

	if ( strlen ( input ) > sizeof ( input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Your text can't be longer than %d characters.", sizeof ( input )));
	}

	new string[144];

	format(string, sizeof(string), "(( [%s] (%d) %s %s: %s ))", Faction[faction_enum_id][E_FACTION_ABBREV], playerid, Character[playerid][E_CHARACTER_FACTIONRANK], SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), input);
	Faction_SendMessage(factionid, string, faction_enum_id, true);
	SendAdminListen(playerid, string);

	format ( string, sizeof ( string ), "(( [%s] %s ))",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], input
	);

	AddLogEntry(playerid, LOG_TYPE_OOC, string);

	return true ;
}

CMD:f(playerid, params[]) {

	return cmd_faction(playerid, params ) ;
} 

// Fac leader chat
CMD:factionleaderchat(playerid, params[]) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ];

	if (!factionid || Character[playerid][E_CHARACTER_FACTIONTIER] > 1)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to use this chat");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	new input [ 128 ] ;

	if ( sscanf ( params, "s[128]", input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/f(action)l(eader)c(hat) [text]");
	}

	if ( strlen ( input ) > sizeof ( input ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Your text can't be longer than %d characters.", sizeof ( input )));
	}

	new string[144];

	format(string, sizeof(string), "(( [%s FLC] (%d) %s %s: %s ))", Faction[faction_enum_id][E_FACTION_ABBREV], playerid, Character[playerid][E_CHARACTER_FACTIONRANK], SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), input);
	
	Faction_SendMessage(factionid, string, faction_enum_id, true, false, 0xCC956EFF, false, Character[playerid][E_CHARACTER_FACTIONTIER]);
	SendAdminListen(playerid, string);

	format ( string, sizeof ( string ), "(( [%s FLC] %s ))",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], input
	);

	AddLogEntry(playerid, LOG_TYPE_OOC, string);

	return true ;
}

CMD:flc(playerid, params[]) 
{
	return cmd_factionleaderchat(playerid, params);
} 

CMD:fl(playerid, params[]) 
{
	return cmd_factionleaderchat(playerid, params);
} 

CMD:fhc(playerid, params[]) 
{
	return cmd_factionleaderchat(playerid, params);
} 

CMD:offlinesettier(playerid, params[]) 
{
	new factionid = Character [playerid][E_CHARACTER_FACTIONID];
	new fac_enum_id = INVALID_FACTION_ID;

	if (factionid)
	{
		fac_enum_id = Faction_GetEnumID(factionid); 
	}

	if (!factionid || fac_enum_id == INVALID_FACTION_ID) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction.");
	}

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 1)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be Tier 1 to offline-set another member's tier.");
	}

	new offline_name[32], tier;
	if (sscanf(params, "s[32]d", offline_name, tier))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/o(ffline)settier [firstname_lastname] [tier]");
	}

	if (tier < 1 || tier > 4)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "The new tier must be 1 (leader), 2 (command), 3 (regular) or 4 (restricted).");
	}

	new query[256];
	mysql_format(mysql, query, sizeof(query), "SELECT `player_id`, `player_name` FROM `characters` WHERE `player_name` LIKE '%e' AND `player_factionid` = '%d' LIMIT 1", offline_name, factionid); 

	inline OnOfflineSetTier() 
	{
		new rows, fields, player_id, player_name[32];
		cache_get_data(rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You entered an invalid character name (or this character isn't in your faction).");
		}

		cache_get_field_content(0, "player_name", player_name, mysql, 34);
		player_id = cache_get_field_int(0, "player_id");

		foreach(new idx: Player) 
		{
			if (Character[idx][E_CHARACTER_ID] == player_id) 
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player is online.");
			}
		}

		mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `player_factiontier` = %d WHERE `player_id` = %d", tier, player_id); 
		mysql_tquery(mysql, query);

		Faction_SendMessage(factionid, sprintf("{ [%s] %s has offline-set %s to Tier %d. }", Faction[fac_enum_id][E_FACTION_ABBREV], ReturnPlayerNameData(playerid, 0, true), player_name, tier), fac_enum_id, false, false, 0, true);
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineSetTier, "");
	return true ;
}

CMD:osettier(playerid, params[])
{
	return cmd_offlinesettier(playerid, params);
}

CMD:offlinesetrank(playerid, params[]) 
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

	new offline_name[32], rank[64];
	if (sscanf(params, "s[32] s[64]", offline_name, rank) || strlen(rank) < 3)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/o(ffline)settrank [firstname_lastname] [rank name]");
	}

	new query[256];
	mysql_format(mysql, query, sizeof(query), "SELECT `player_id`, `player_name`, `player_factiontier` FROM `characters` WHERE `player_name` LIKE '%e' AND `player_factionid` = '%d' LIMIT 1", offline_name, factionid); 

	inline OnOfflineSetRank() 
	{
		new rows, fields, player_id, player_tier, player_name[32];
		cache_get_data(rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You entered an invalid character name (or this character isn't in your faction).");
		}

		cache_get_field_content(0, "player_name", player_name, mysql, 34);
		player_id = cache_get_field_int(0, "player_id");
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
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "As Tier 2, you can't edit faction members of equal or higher rank.");
            }
		}

		mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `player_factionrank` = '%e' WHERE `player_id` = %d", rank, player_id); 
		mysql_tquery(mysql, query);

		Faction_SendMessage(factionid, sprintf("{ [%s] %s has offline-set the rank of %s to %s. }", Faction[fac_enum_id][E_FACTION_ABBREV], ReturnPlayerNameData(playerid, 0, true), player_name, rank), fac_enum_id, false, false, 0, true);
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineSetRank, "");
	return true ;
}

CMD:osetrank(playerid, params[])
{
	return cmd_offlinesetrank(playerid, params);
}

CMD:offlineuninvite(playerid, params[]) 
{
	new factionid = Character [playerid][E_CHARACTER_FACTIONID];
	new fac_enum_id = INVALID_FACTION_ID;

	if (factionid)
	{
		fac_enum_id = Faction_GetEnumID(factionid); 
	}

	if (!factionid || fac_enum_id == INVALID_FACTION_ID) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction.");
	}

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 1)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be Tier 1 to offline-kick a faction member.");
	}

	new offline_name[32];
	if (sscanf(params, "s[32]", offline_name))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/o(ffline)uninvite [firstname_lastname]");
	}

	new query[256];
	mysql_format(mysql, query, sizeof(query), "SELECT `player_id`, `player_name` FROM `characters` WHERE `player_name` LIKE '%e' AND `player_factionid` = '%d' LIMIT 1", offline_name, factionid); 

	inline OnOfflineKick() 
	{
		new rows, fields, player_id, player_name[32];
		cache_get_data(rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You entered an invalid character name (or this character isn't in your faction).");
		}

		cache_get_field_content(0, "player_name", player_name, mysql, 34);
		player_id = cache_get_field_int(0, "player_id");

		foreach(new idx: Player) 
		{
			if (Character[idx][E_CHARACTER_ID] == player_id) 
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player is online.");
			}
		}

		mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `player_factionid` = 0, `player_factiontier` = 3, `player_factionsquad` = 0, `player_factionrank` = 'None' WHERE `player_id` = %d", player_id); 
		mysql_tquery(mysql, query);

		Faction_SendMessage(factionid, sprintf("{ [%s] %s has offline-kicked %s from the faction. }", Faction[fac_enum_id][E_FACTION_ABBREV], ReturnPlayerNameData(playerid, 0, true), player_name), fac_enum_id, false, false, 0, true);
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineKick, "");
	return true ;
}

CMD:ouninvite(playerid, params[])
{
	return cmd_offlineuninvite(playerid, params);
}

CMD:factionoff(playerid, params[]) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	new query [ 512 ];

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `player_id`, `player_name`, `account_name`, `player_factionrank`, `player_factionbadge`, `player_factionsuspension`, `player_factiontier`, `player_factionsquad` FROM `characters` JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `player_factionid` = '%d' ORDER BY `player_factionbadge` ASC",
		factionid
	) ; 

	new player_id, player_off_name [ MAX_PLAYER_NAME ], player_rank [ 64 ], player_badge, player_acc[32], suspension, tier, squad;

	inline OnOfflineMemberCheck() {

		new rows, fields ;
		cache_get_data ( rows, fields, mysql ) ;

		new dutyfac = IsPlayerInDutyFaction(playerid);

		if ( rows ) 
		{
			for_loop ( new i; i < rows; i ++ ) { 

				player_id = cache_get_field_int (i, "player_id");
				

				if ( Player_IsPlayerConnected ( player_id ) ) {

					continue ;
				}

				cache_get_field_content ( i, "player_name", player_off_name, mysql, MAX_PLAYER_NAME ) ;
				cache_get_field_content ( i, "player_factionrank", player_rank, mysql, 64 ) ;
				cache_get_field_content ( i, "account_name", player_acc, mysql, 32 ) ;
				player_badge = cache_get_field_int (i, "player_factionbadge");
				suspension = cache_get_field_int (i, "player_factionsuspension");
				tier = cache_get_field_int (i, "player_factiontier");
				squad = cache_get_field_int (i, "player_factionsquad");

				new suspended = suspension && gettime() < suspension;

				if (player_badge && suspended && dutyfac) SendClientMessage(playerid, COLOR_FACTION_RED, sprintf("SUSPENDED: %s %s #%03d (%s) | Tier: %d, Squad: %d", player_rank, player_off_name, player_badge, player_acc, tier, squad));
				else if (player_badge && dutyfac) SendClientMessage(playerid, COLOR_FACTION_RED, sprintf("OFFLINE: %s %s #%03d (%s) | Tier: %d, Squad: %d", player_rank, player_off_name, player_badge, player_acc, tier, squad));
				else if (suspended) SendClientMessage(playerid, COLOR_FACTION_RED, sprintf("SUSPENDED: %s %s (%s) | Tier: %d", player_rank, player_off_name, player_acc, tier));
				else SendClientMessage(playerid, COLOR_FACTION_RED, sprintf("OFFLINE: %s %s (%s) | Tier: %d", player_rank, player_off_name, player_acc, tier));
			}	
		}
	}

	mysql_tquery_inline(mysql, query, using inline OnOfflineMemberCheck, "");

	return true ;
}

CMD:foff(playerid, params[]) return cmd_factionoff(playerid, params);
CMD:foffline(playerid, params[]) return cmd_factionoff(playerid, params);

CMD:factionon(playerid, params[])
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	new tier, squad;
	new dutyfac = IsPlayerInDutyFaction(playerid);

	foreach(new idx: Player ) 
	{
		if (Character [ idx ] [ E_CHARACTER_FACTIONID ] == factionid && (strcmp(Character[idx][E_CHARACTER_FACTIONRANK], "Admin") != 0 || playerid == idx)) 
		{
			new suspended = GetPlayerFactionSuspension(idx);
			new badge = Character [ idx ] [ E_CHARACTER_FACTION_BADGE ];
			new duty = PlayerVar [ idx ] [ E_PLAYER_FACTION_DUTY ];
			new oncad = CAD_GetPlayerUnit(idx);
			tier = Character [ idx ] [ E_CHARACTER_FACTIONTIER ];
			squad = Character [ idx ] [ E_CHARACTER_FACTION_SQUAD ];

			if (dutyfac && suspended && badge && duty) SendClientMessage(playerid, COLOR_FACTION_GREEN, sprintf("SUSPENDED: (ID %d) %s %s #%03d (%s) | Tier: %d, Squad: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Character [ idx ] [ E_CHARACTER_FACTION_BADGE ], Account[idx][E_PLAYER_ACCOUNT_NAME], tier, squad ) );
			else if (suspended && badge && dutyfac) SendClientMessage(playerid, COLOR_GREY, sprintf("SUSPENDED: (ID %d) %s %s #%03d (%s) | Tier: %d, Squad: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Character [ idx ] [ E_CHARACTER_FACTION_BADGE ], Account[idx][E_PLAYER_ACCOUNT_NAME], tier, squad ) );
			else if (suspended) SendClientMessage(playerid, COLOR_GREY, sprintf("SUSPENDED: (ID %d) %s %s (%s) | Tier: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Account[idx][E_PLAYER_ACCOUNT_NAME], tier ) );
			else if (dutyfac && duty && oncad) SendClientMessage(playerid, COLOR_FACTION_GREEN, sprintf("ON DUTY: (ID %d) [%s] %s %s #%03d (%s) | Tier: %d, Squad: %d", idx, CAD_PrintPlayerUnit(idx, true), Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Character [ idx ] [ E_CHARACTER_FACTION_BADGE ], Account[idx][E_PLAYER_ACCOUNT_NAME], tier, squad ) );
			else if (dutyfac && duty) SendClientMessage(playerid, COLOR_FACTION_GREEN, sprintf("ON DUTY: (ID %d) %s %s #%03d (%s) | Tier: %d, Squad: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Character [ idx ] [ E_CHARACTER_FACTION_BADGE ], Account[idx][E_PLAYER_ACCOUNT_NAME], tier, squad ) );		
			else if (dutyfac) SendClientMessage(playerid, COLOR_GREY, sprintf("OFF DUTY: (ID %d) %s %s #%03d (%s) | Tier: %d, Squad: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Character [ idx ] [ E_CHARACTER_FACTION_BADGE ], Account[idx][E_PLAYER_ACCOUNT_NAME], tier, squad ) );
			else SendClientMessage(playerid, COLOR_FACTION_GREEN, sprintf("ONLINE: (ID %d) %s %s (%s) | Tier: %d", idx, Character [ idx ] [ E_CHARACTER_FACTIONRANK ], ReturnPlayerNameData ( idx, 0, true ), Account[idx][E_PLAYER_ACCOUNT_NAME], tier ) );
		}
	}

	return true;
}

CMD:fon(playerid, params[])
{
	return cmd_factionon(playerid, params);
}

CMD:fonline(playerid, params[])
{
	return cmd_factionon(playerid, params);
}

Player_IsPlayerConnected ( player_sql_id ) {
	foreach(new idx: Player ) {

		if ( Character [ idx ] [ E_CHARACTER_ID ] == player_sql_id ) {

			return true  ;
		}
	}

	return false ;
}

static FacActivityStr[4096];
static FacActivityQuery[600];
static FacActivityTitle[MAX_PLAYER_NAME];

ShowPlayerActivity(playerid, accountid, days)
{
	mysql_format(mysql, FacActivityQuery, sizeof(FacActivityQuery), "SELECT `characters`.`player_name` AS `Name`, `characters`.`player_factionid` AS `Faction`, (SUM(`e_session_time`)/60) AS `Hours`, (SUM(`e_session_duty`)/60) AS `Duty` FROM `characters` LEFT JOIN `sessions` ON `characters`.`player_id` = `sessions`.`e_session_char` AND `sessions`.`e_session_unix_store` > UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL %d DAY)) WHERE `characters`.`account_id` = %d GROUP BY `characters`.`player_name` ORDER BY SUM(`e_session_time`) DESC", days, accountid);

	inline Activity_OnList() 
	{
		new rows, fields, Float:hours, Float:duty, factionid, player_name_display[32];
		cache_get_data (rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "There is no character activity for this timeframe.") ;
		}

		format(FacActivityStr, sizeof(FacActivityStr), "Character\tFaction\tTotal Hours");

		for_loop ( new i, p = rows; i < p; i ++ ) 
		{
			//cache_get_field_content(i, "Name", player_name);
			cache_get_field_content(i, "Name", player_name_display);
			strreplace(player_name_display, "_", " ");

			hours = cache_get_field_content_float(i, "Hours");
			duty = cache_get_field_content_float(i, "Duty");
			factionid = cache_get_field_content_int(i, "Faction");

			new fac_enum_id = Faction_GetEnumID(factionid);

			if (factionid && fac_enum_id != -1)
			{
				if (duty > 0) format(FacActivityStr, sizeof(FacActivityStr), "%s\n%s\t%s\t%.02f (%.02f On Duty)", FacActivityStr, player_name_display, Faction[fac_enum_id][E_FACTION_ABBREV], hours, duty);
				else format(FacActivityStr, sizeof(FacActivityStr), "%s\n%s\t%s\t%.02f", FacActivityStr, player_name_display, Faction[fac_enum_id][E_FACTION_ABBREV], hours);
			}
			else
			{
				format(FacActivityStr, sizeof(FacActivityStr), "%s\n%s\t%s\t%.02f", FacActivityStr, player_name_display, "None", hours);
			}
		}

		inline DlgActivityList(pid, dialogid, response, listitem, string:inputtext[]) 
    	{
			#pragma unused pid, dialogid, inputtext, listitem

			if (response)
			{
				// Do nothing
			}
		}

		Dialog_ShowCallback(playerid, using inline DlgActivityList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("%s's Activity (Last %d days)", FacActivityTitle, days), FacActivityStr, "Back");
	}

	mysql_tquery_inline(mysql, FacActivityQuery, using inline Activity_OnList, "");
	return true;
}

CMD:ocheckactivity(playerid, params[])
{
	if (!GetPlayerAdminLevel(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission for this.");
	}

	new account_name[32], option[6], days = 0;
	sscanf(params, "s[32] s[6]", account_name, option);

	if (strlen(option))
	{
		if (!strcmp(option, "day", true)) days = 1;
		else if (!strcmp(option, "week", true)) days = 7;
		else if (!strcmp(option, "month", true)) days = 30;
	}

	if (!days || strlen(account_name) < 3)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/ocheckactivity [account name] [day/week/month]");
	}

	format(FacActivityTitle, sizeof(FacActivityTitle), "%s", account_name);

	new query [ 200 ] ;

	inline ReturnAccountName() 
	{
		new rows, fields;
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Database didn't return any account data. Maybe you mistyped the ID" )  ;
		}
		else if ( rows ) 
		{
			new account_id = cache_get_field_content_int(0, "account_id");
			if (account_id) ShowPlayerActivity(playerid, account_id, days);
		}
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT account_id FROM accounts WHERE account_name LIKE '%e'", account_name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountName, "");

	return true;
}

CMD:checkactivity(playerid, params[])
{
	if (!GetPlayerAdminLevel(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission for this.");
	}

	new forplayerid, option[6], days = 0;
	sscanf(params, "k<player>s[6]", forplayerid, option);

	if (strlen(option))
	{
		if (!strcmp(option, "day", true)) days = 1;
		else if (!strcmp(option, "week", true)) days = 7;
		else if (!strcmp(option, "month", true)) days = 30;
	}

	if (!IsPlayerConnected(forplayerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/checkactivity [player] [day/week/month]");
	}

	new accountid = Account[forplayerid][E_PLAYER_ACCOUNT_ID];

	if (!days || !accountid || !IsPlayerPlaying(forplayerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/checkactivity [player] [day/week/month]");
	}

	format(FacActivityTitle, sizeof(FacActivityTitle), "%s", Account[forplayerid][E_PLAYER_ACCOUNT_NAME]);
	ShowPlayerActivity(playerid, accountid, days);
	return true;
}

CMD:myactivity(playerid, params[])
{
	new option[6], days = 0;
	sscanf(params, "s[6]", option);

	if (strlen(option))
	{
		if (!strcmp(option, "day", true)) days = 1;
		else if (!strcmp(option, "week", true)) days = 7;
		else if (!strcmp(option, "month", true)) days = 30;
	}

	new accountid = Account[playerid][E_PLAYER_ACCOUNT_ID];

	if (!days || !accountid || !IsPlayerPlaying(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/myactivity [day/week/month]");
	}

	format(FacActivityTitle, sizeof(FacActivityTitle), "%s", Account[playerid][E_PLAYER_ACCOUNT_NAME]);
	ShowPlayerActivity(playerid, accountid, days);
	return true;
}

CMD:factivity(playerid, params[])
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] > 2 ) {
		// 1 : owner, 2: command, 3 : member

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have permission to do this.");
	}

	new typestr[10], option[6], days = 0, type = 0;
	sscanf(params, "s[10] s[6]", typestr, option);

	if (strlen(option))
	{
		if (!strcmp(option, "day", true)) days = 1;
		else if (!strcmp(option, "week", true)) days = 7;
		else if (!strcmp(option, "month", true)) days = 30;
	}

	if (strlen(typestr))
	{
		if (strcmp(typestr, "character", true) == 0) type = 1;
		else if (strcmp(typestr, "account", true) == 0) type = 2;
	}

	if (!days || !type)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/factivity [character/account] [day/week/month]");
	}

	if (type == 1) mysql_format(mysql, FacActivityQuery, sizeof(FacActivityQuery), "SELECT `characters`.`player_name` AS `Name`, `characters`.`player_factionrank` AS `Rank`, (SUM(`e_session_time`)/60) AS `Hours`, (SUM(`e_session_duty`)/60) AS `Duty` FROM `characters` LEFT JOIN `sessions` ON `characters`.`player_id` = `sessions`.`e_session_char` AND `sessions`.`e_session_unix_store` > UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL %d DAY)) WHERE `characters`.`player_factionid` = %d GROUP BY `characters`.`player_name` ORDER BY SUM(`e_session_time`) DESC LIMIT 100", days, factionid);
	else mysql_format(mysql, FacActivityQuery, sizeof(FacActivityQuery), "SELECT `accounts`.`account_name` AS `Name`, `characters`.`player_name` AS `Rank`, (SUM(`e_session_time`)/60) AS `Hours`, (SUM(`e_session_duty`)/60) AS `Duty` FROM `characters` JOIN `accounts` ON `characters`.`account_id` = `accounts`.`account_id` LEFT JOIN `sessions` ON `characters`.`player_id` = `sessions`.`e_session_char` AND `sessions`.`e_session_unix_store` > UNIX_TIMESTAMP((CURRENT_TIMESTAMP - INTERVAL %d DAY)) WHERE `characters`.`player_factionid` = %d GROUP BY `characters`.`account_id` ORDER BY SUM(`e_session_time`) DESC LIMIT 100", days, factionid);

	inline Activity_OnList() 
	{
		new rows, fields, Float:hours, Float:duty, rank[32], player_name_display[32];
		cache_get_data (rows, fields, mysql);

		if (!rows)
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "There is no faction activity for this timeframe.") ;
		}

		format(FacActivityStr, sizeof(FacActivityStr), "Player\tRank\tTotal Hours (On Duty)");

		for_loop ( new i, p = rows; i < p; i ++ ) 
		{
			//cache_get_field_content(i, "Name", player_name);
			cache_get_field_content(i, "Name", player_name_display);
			cache_get_field_content(i, "Rank", rank);
			strreplace(player_name_display, "_", " ");
			hours = cache_get_field_content_float(i, "Hours");
			duty = cache_get_field_content_float(i, "Duty");

			format(FacActivityStr, sizeof(FacActivityStr), "%s\n%s\t%s\t%.02f (%.02f)", FacActivityStr, player_name_display, rank, hours, duty);
		}

		inline DlgActivityList(pid, dialogid, response, listitem, string:inputtext[]) 
    	{
			#pragma unused pid, dialogid, inputtext, listitem

			if (response)
			{
				// Do nothing
			}
		}

		Dialog_ShowCallback(playerid, using inline DlgActivityList, DIALOG_STYLE_TABLIST_HEADERS, sprintf("%s Activity (Last %d days)", Faction[faction_enum_id][E_FACTION_ABBREV], days), FacActivityStr, "Back");
	}

	mysql_tquery_inline(mysql, FacActivityQuery, using inline Activity_OnList, "");
	return 1;
}