/*
Add discord_bot_token YOURDISCORDBOTTOKEN to your server.cfg file
https://github.com/maddinat0r/samp-discord-connector/wiki

Addressing a few common misconceptions:

Discord IDs are too large to fit inside pawn's 32-bit integers. Discord IDs must be provided as strings and converted to 
DCC integers through the DCC_Get* functions. The plugin stores the real IDs internally, your script will only contain the 
indexes for each of those.


To send a private message to a user, you first have to open a PM channel by calling DCC_CreatePrivateChannel, passing a 
result callback, and calling DCC_GetCreatedPrivateChannel in the result callback. The latter will return a channel id, 
which you can use to call other channel natives (for example DCC_SendChannelMessage) with.

*/


#warning Add a way to log unofficial attacks.

/*
	These attacks will be logged in a simple mysql database and posted in the applicable Discord channel "faction-attack-logs". 

	All leaders + FT will be able to access this channel.


	/startattack has to be done before an attack (lets you choose target faction). This temporarily puts a label on top of your head.
	/joinattack puts you in the attacker list. People that don't do /joinattack but participate in a fight will be punished.
	/logattack takes all of the data from the /startattack and /joinattack. This will post an embed in the attack-logs channel with the attack log.

	This will start logging all attacks done by TARGET FACTION.
	This will start logging all damage done by ATTACKING FACTION to TARGET FACTION.
	Anyone who isn't in the attack but part of the attacking faction and damaging target faction, will be detected and punished.
	Defenders will be logged automatically according to damage they do.
	People that fail to log their attack will have their faction striked (the script will know regardless)

*/

enum E_ATTACK_LOG {

	bool: E_ATTACK_ACTIVE, // 1 attack at a time
	E_ATTACK_PARTICIPANT [ MAX_PLAYERS ],

	// Damage done by either party (people who didn't log)
	E_ATTACK_DMG_PARTICIPANT [ MAX_PLAYERS ],
	E_ATTACK_DMG_VICTIM	 [ MAX_PLAYERS ],

	E_ATTACK_TARGET_FACTION
} ;

new AttackLog [ MAX_FACTIONS ] [ E_ATTACK_LOG ] ;

AttackLog_LoadEntities(factionid) {

	AttackLog [ factionid ] [ E_ATTACK_ACTIVE ] = false ;

	for(new i, j = MAX_PLAYERS; i < j ; i ++ ) {

		AttackLog [ factionid ] [ E_ATTACK_PARTICIPANT ]		= -1 ; 
		AttackLog [ factionid ] [ E_ATTACK_DMG_PARTICIPANT ]	= -1 ; 
		AttackLog [ factionid ] [ E_ATTACK_DMG_VICTIM ]			= -1 ; 
	}

	AttackLog [ factionid ] [ E_ATTACK_TARGET_FACTION ] = INVALID_FACTION_ID ;
}

CMD:startattack(playerid, params[]) {

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

	if (  AttackLog [ faction_enum_id ] [ E_ATTACK_ACTIVE ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "An attack is already ongoing. Log it first or cancel it (/logattack, /cancelattack).");
	}

	new faction_target ;

	if ( sscanf ( params, "i", faction_target ) ) {

		SendClientMessage ( playerid, -1, "Select the faction ID from /factions." ) ;
		return true;
	}

	// This puts a label ONTOP of the player. People can do /joinattack.

	SendClientMessage(playerid, COLOR_YELLOW, "Make sure ALL participants do /joinattack! Those who don't WILL be punished!");

	ZMsg_SendClientMessage ( playerid, COLOR_ERROR, 
		"Don't forget to /logattack once you are done or your faction WILL get striked and you PUNISHED!");


	Faction_SendMessage(Faction [ faction_enum_id ] [ E_FACTION_ID], sprintf("{ [%s] %s has started planning an attack. Use /joinattack to participate. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
	), faction_enum_id, false ) ;



	return true ;
}

CMD:joinattack(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( !AttackLog [ faction_enum_id ] [ E_ATTACK_ACTIVE ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There isn't any attack ongoing right now.");
	}


	for ( new i, j = MAX_PLAYERS; i < j ; i ++ ) {

		if ( AttackLog [ faction_enum_id ] [ E_ATTACK_PARTICIPANT ] [ i ] == -1 ) {

			AttackLog [ faction_enum_id ] [ E_ATTACK_PARTICIPANT ] [ i ] = Character [ playerid ] [ E_CHARACTER_ID ]  ;

			Faction_SendMessage(Faction [ faction_enum_id ] [ E_FACTION_ID], sprintf("{ [%s] %s has joined the attack plans. }",

				Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
			), faction_enum_id, false ) ;

			break ;
		}
	}

	return true ;
}

CMD:cancelattack(playerid, params[]) {

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

	if ( !AttackLog [ faction_enum_id ] [ E_ATTACK_ACTIVE ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There isn't any attack ongoing right now.");
	}

	// Post in channel, hold "attack" info in memory until this is done.
	// Attack info is per faction, and only 1 attack can be done at a time.

	Faction_SendMessage(Faction [ faction_enum_id ] [ E_FACTION_ID], sprintf("{ [%s] %s has cancelled the attack. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
	), faction_enum_id, false ) ;

	AttackLog_LoadEntities(faction_enum_id);

	return true ;
}



CMD:logattack(playerid, params[]) {

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

	if ( !AttackLog [ faction_enum_id ] [ E_ATTACK_ACTIVE ] ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There isn't any attack ongoing right now.");
	}

	// Post in channel, hold "attack" info in memory until this is done.
	// Attack info is per faction, and only 1 attack can be done at a time.


	Faction_SendMessage(Faction [ faction_enum_id ] [ E_FACTION_ID], sprintf("{ [%s] %s has posted the attack logs. }",

		Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], ReturnPlayerNameData ( playerid )
	), faction_enum_id, false ) ;

	Discord_SendAttackLog(faction_enum_id ) ;

	return true ;
}

Attack_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart ) {

	#pragma unused weaponid, bodypart, amount

	if ( issuerid != INVALID_PLAYER_ID ) {

		if ( Character [ issuerid ] [ E_CHARACTER_FACTIONID ] ) {

			new bool: duplicate = false ;

			new attacking_faction = Faction_GetEnumID(Character [ issuerid ] [ E_CHARACTER_FACTIONID ] ); 

			if ( attacking_faction != INVALID_FACTION_ID ) {

				new target_faction = AttackLog [ attacking_faction ] [ E_ATTACK_TARGET_FACTION ] ;

				if ( Faction_GetEnumID( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) == target_faction) {

					duplicate = false ;
					for ( new i, j = MAX_PLAYERS; i < j ; i ++ ) {

						if ( AttackLog [ attacking_faction ] [ E_ATTACK_DMG_VICTIM ] [ i ] == playerid ) {
							duplicate = true ;
						}
					}

					if ( ! duplicate ) {
						for ( new i, j = MAX_PLAYERS; i < j ; i ++ ) {

							if ( AttackLog [ attacking_faction ] [ E_ATTACK_DMG_VICTIM ] [ i ] == -1 ) {

								// Incase victim logs, we still have their char id and can pull the names appropiately.
								AttackLog [ attacking_faction ] [ E_ATTACK_DMG_VICTIM ] [ i ] = Character [ playerid ] [ E_CHARACTER_ID ] ;
								break ;
							}

							else continue ;
						}
					}
				}

				if ( Faction_GetEnumID( Character [ issuerid ] [ E_CHARACTER_FACTIONID ] ) == attacking_faction) {

					duplicate = false ;
					for ( new i, j = MAX_PLAYERS; i < j ; i ++ ) {

						if ( AttackLog [ attacking_faction ] [ E_ATTACK_DMG_PARTICIPANT ] [ i ] == issuerid ) {
							duplicate = true ;
						}
					}

					if ( ! duplicate ) {
						for ( new i, j = MAX_PLAYERS; i < j ; i ++ ) {

							if ( AttackLog [ attacking_faction ] [ E_ATTACK_DMG_PARTICIPANT ] [ i ] == -1 ) {

								// Incase victim logs, we still have their char id and can pull the names appropiately.
								AttackLog [ attacking_faction ] [ E_ATTACK_DMG_PARTICIPANT ] [ i ] = Character [ issuerid ] [ E_CHARACTER_ID ] ;
								break ;
							}

							else continue ;
						}
					}
				}
			}
		}
	}

	return true ;	
}

Discord_SendAttackLog(faction_enum_id ) {

	if (  AttackLog [ faction_enum_id ] [ E_ATTACK_ACTIVE ] ) {

		new DCC_Channel: log_channel_id = DCC_FindChannelByName("official-attack-logs");


		new embed_description [ 2048 ] ;


		new DCC_Embed: embed_id = DCC_CreateEmbed("Attack Log", embed_description, "https://play.streetzofls.com");


		//DCC_AddEmbedField(embed_id, const name[], const value[], bool:inline = false);

		DCC_SetEmbedColor(embed_id, Faction_GetHex ( Faction [ faction_enum_id ] [ E_FACTION_ID ] ) );
		DCC_SetEmbedImage(embed_id, "https://i.imgur.com/w4aiQOL.png");
		DCC_SetEmbedFooter(embed_id, "Automatically generated through ingame attack logger.");

		DCC_SendChannelEmbedMessage(log_channel_id, embed_id, sprintf("Attack log posted on %s:",  ReturnDateTime ()  ));


		// At the end of logging, reset the data.
	 	AttackLog_LoadEntities(faction_enum_id);
	}

	return true ;
}