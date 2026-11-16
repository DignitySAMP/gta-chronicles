CMD:mask(playerid) {

	if ( Character [ playerid ] [ E_CHARACTER_HOURS ] < 8 ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You need at least 8 playing hours before you can use a /mask.");
	}

	if ( ! Character [ playerid ] [ E_CHARACTER_MASKID ] ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a mask! Buy one from the 24/7.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_MASKID ] <= MAX_PLAYERS ) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", sprintf("Mask IDs must be higher than %d, your current (%d) is too low. Ask an admin to change it.", MAX_PLAYERS, Character [ playerid ] [ E_CHARACTER_MASKID ]));
	}

	if (IsPlayerIncapacitated(playerid) && !PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] ) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't put on a mask just now.");
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] ) {

		ProxDetectorAutoMe(playerid, 15.0, "takes off their mask.", true, true);
		//ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has taken off their mask.", ReturnPlayerNameData ( playerid, 0, true ) ) );
        PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] = false ;
        //SetPlayerName(playerid, Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ;
		SetPlayerName(playerid, Character [ playerid ] [ E_CHARACTER_NAME ]);

		new year, month, day, hour, minute, second;
		stamp2datetime(gettime(), year, month, day, hour, minute, second, 1);
		SendServerMessage(playerid, COLOR_ORANGE, "Mask", "A3A3A3", sprintf("You removed your mask at %02d:%02d:%02d, it will be discoverable in your inventory for 30 minutes.", hour, minute, second));
    }

    else if (! PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] ) 
	{
		if (IsPlayerInAnyGovFaction(playerid, true) && !PlayerVar[playerid][E_PLAYER_SWAT_ACTIVE] && !IsPlayerInDEAFaction(playerid) && !IsPlayerInFactionSquad(playerid, FACTION_SQUAD_CRASH, FACTION_TYPE_POLICE))
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't put on a mask while on duty in a government faction.");
		}

		if (!Attachments_CountMask(playerid) && !GetPlayerAdminLevel(playerid) && !Character[playerid][E_CHARACTER_FACTIONID])
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You aren't wearing a face covering object, check /toys.");
		}

		ProxDetectorAutoMe(playerid, 15.0, "puts on their mask.", true, true);
		//ProxDetector ( playerid,15.0, COLOR_ACTION, sprintf("* %s has put on their mask.", ReturnPlayerNameData ( playerid, 0, true ) ) );
        PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] = true ;

        new string [ 64 ] ;

        format ( string, sizeof ( string ), "Stranger %d", GetPlayerMaskID(playerid) ) ; 
        SetPlayerName ( playerid,  string ) ;

		new year, month, day, hour, minute, second;
		stamp2datetime(gettime(), year, month, day, hour, minute, second, 1);
		SendServerMessage(playerid, COLOR_ORANGE, "Mask", "A3A3A3", sprintf("You put on your mask at %02d:%02d:%02d.", hour, minute, second));
		// SendServerMessage(playerid, COLOR_ORANGE, "Mask", "A3A3A3", sprintf("You put on your mask at %02d:%02d:%02d.", hour, minute, second));
    }

	PlayerVar [ playerid ] [ E_PLAYER_LAST_MASKED_AT ] = gettime();

	// Update cached name strings
	UpdatePlayerNameCache ( playerid );
 	UpdatePlayerNamesForOthers ( playerid ) ;

	return true ;
}

CMD:removemask(playerid, params[]) {

	new userid ;

	if ( sscanf ( params, "i", userid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/removemask [targetid]");
	}

	if ( ! IsPlayerConnected(userid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
	}

	// If no admin
	if ( GetPlayerAdminLevel ( playerid ) < 1 ) {

		if ( ! IsPlayerIncapacitated(userid) ) {

			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Your target must be incapacitated! (injured/tased/cuffed/...)");
		}
		else if (!IsPlayerNearPlayer(playerid, userid, 5.0))
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're too far away from this player.");
		}
	}

	if (!PlayerVar [ userid ] [ E_PLAYER_IS_MASKED ])
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player isn't masked.");
	}

	SendClientMessage(userid, COLOR_GRAD0, sprintf("%s has removed your mask.",  ReturnPlayerNameData ( playerid, 0, true ) ) ) ;
	SendClientMessage(playerid, COLOR_GRAD0, sprintf("You removed the mask from (%d) %s.",  userid, ReturnPlayerNameData ( userid, 0, true ) ) ) ;
	cmd_mask(userid);

	return true ;
}

CalculateMaskID(playerid) {

	new accid = Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], 
		charid = Character [ playerid ] [ E_CHARACTER_ID ] ;

	new mask_id = ( ( accid + charid ) / 2 );

	mask_id += random ( 99 ) ;

	if (mask_id <= 1000) mask_id += 1000;

	return mask_id ;
}

IsPlayerMasked(playerid) {

	if ( playerid == INVALID_PLAYER_ID ) {

		return false ;
	}

	return PlayerVar [ playerid ] [ E_PLAYER_IS_MASKED ] ;
}

GetPlayerMaskID(playerid) {

	if ( playerid == INVALID_PLAYER_ID ) {

		return false ;
	}

	return Character [ playerid ] [ E_CHARACTER_MASKID ] ;
}