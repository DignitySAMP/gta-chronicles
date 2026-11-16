enum {
	E_CONTRIBUTOR_NONE = 0,
	E_CONTRIBUTOR_VETERAN, // old, down to earth ex admins i.e. street, TNT, ... (NO ADMIN POWER!)
	E_CONTRIBUTOR_INVITED, // contributors that do/did a lot of work like ryhes / janichar
	E_CONTRIBUTOR_DEVELOPER, // general admin power
	E_CONTRIBUTOR_SPOOKY, // op
	E_CONTRIBUTOR_RYHES, // publicly advanced admin but has manager
} ;

IsPlayerContributor(playerid) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {
		return true ;
	}

	return false ;
}

GetContributorRankName(rank, rank_name[], len = sizeof ( rank_name ) ) {

	rank_name [ 0 ] = EOS ;

	switch ( rank ) {

		case E_CONTRIBUTOR_NONE:		strcat ( rank_name, "None", len ) ;
		case E_CONTRIBUTOR_VETERAN:		strcat ( rank_name, "Veteran", len ) ;
		case E_CONTRIBUTOR_INVITED:		strcat ( rank_name, "Invited", len ) ;
		case E_CONTRIBUTOR_DEVELOPER:	strcat ( rank_name, "Developer", len ) ;
		case E_CONTRIBUTOR_SPOOKY:		strcat ( rank_name, "Manager", len ) ;
		case E_CONTRIBUTOR_RYHES:		strcat ( rank_name, "Advanced Admin", len ) ;
		default: strcat ( rank_name, "Regular", len ) ;
	}
}

GetContributorRankColor(rank, rank_color[], len = sizeof ( rank_color ) ) {

	rank_color [ 0 ] = EOS ;

	switch ( rank ) {

		case E_CONTRIBUTOR_RYHES:	strcat ( rank_color, "{d47d44}", len ) ;
		case E_CONTRIBUTOR_SPOOKY:	strcat ( rank_color, "{a45d5d}", len ) ;
		default: strcat ( rank_color, "{5097d9}", len ) ;
	}
}

Contributor_ApplyRights(playerid) {

	switch ( Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {

		case E_CONTRIBUTOR_VETERAN: {
			SendClientMessage ( playerid, COLOR_YELLOW, "You have been invited to the admin chat. You will be able to talk in /achat as a");
			SendClientMessage ( playerid, COLOR_YELLOW, "thank you for your community efforts and past contributions. You have been given");
			SendClientMessage ( playerid, COLOR_YELLOW, "helper status. It is recommended to help out during rush hour, but not obligated.");
			SendClientMessage ( playerid, 0xDEDEDEFF, "To disable spam, use /togadmin.}");
			Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = ADMIN_LVL_NONE;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = true ;
		}
		case E_CONTRIBUTOR_INVITED: {

			SendClientMessage ( playerid, COLOR_YELLOW, "You have been invited to the admin chat. You have the same rights as a Junior Admin");
			SendClientMessage ( playerid, COLOR_YELLOW, "due to your past contributions. You do not have any direct obligations, but it is");
			SendClientMessage ( playerid, COLOR_YELLOW, "encouraged to help out during rush hour.{DEDEDE}To disable spam, use /togadmin.");
			SendClientMessage ( playerid, COLOR_RED, "Only use admin commands during admin sessions, not for your own benefit!");

			Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = ADMIN_LVL_JUNIOR ;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = true ;
		}
		case E_CONTRIBUTOR_DEVELOPER: {

			SendClientMessage ( playerid, COLOR_YELLOW, "You have been invited to the admin chat. You have the same rights as a Lead Admin");
			SendClientMessage ( playerid, COLOR_YELLOW, "because of your Developer status. You do not have any direct obligations, but it is");
			SendClientMessage ( playerid, COLOR_YELLOW, "encouraged to help out during rush hour.{DEDEDE}To disable spam, use /togadmin.");
			SendClientMessage ( playerid, COLOR_RED, "Only use admin commands during admin sessions, not for your own benefit!");
			Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = ADMIN_LVL_DEVELOPER ;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = true ;
		}
		case E_CONTRIBUTOR_SPOOKY: {

			SendClientMessage ( playerid, COLOR_YELLOW, "You are Sporky, or Spooky, or maybe just Hades (ew).");
			SendClientMessage ( playerid, COLOR_RED, "Only use admin commands during admin sessions (lol, gl with that), not for your own benefit!");
			Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = ADMIN_LVL_DEVELOPER ;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = true ;
		}
		case E_CONTRIBUTOR_RYHES: 
		{
			SendClientMessage ( playerid, COLOR_YELLOW, "You are Mexican Santa, de-viber of Vibes, filler (and creator) of gaps and a really bad pool player.");
			SendClientMessage ( playerid, COLOR_RED, "There was a note here that says only to use admin commands for legit reason, but gl with that.");
			Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] = ADMIN_LVL_DEVELOPER ;
			Account [ playerid ] [ E_PLAYER_ACCOUNT_SUPPORTER ] = true ;
		}
	}
}

CMD:makecontributor(playerid, params[]) {

	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	new user, type ;

	if ( sscanf ( params, "k<player>i", user, type) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/makecontributor [player] [type]" ) ;

		SendClientMessage(playerid, COLOR_YELLOW, "List of types:");
		SendClientMessage(playerid, COLOR_RED, "0: None");
		SendClientMessage(playerid, COLOR_RED, "1: Veteran{DEDEDE} (No Admin Powers)");
		SendClientMessage(playerid, COLOR_RED, "2: Invited{DEDEDE} (Junior Admin Powers)");
		SendClientMessage(playerid, COLOR_RED, "3: Developer{DEDEDE} (Manager Powers)");
		SendClientMessage(playerid, COLOR_RED, "4: Spooky{DEDEDE} (ALL THE POWERS)");
		SendClientMessage(playerid, COLOR_RED, "5: Ryhes{DEDEDE} (Advanced Admin)");
		return true ;
	}

	if ( ! IsPlayerConnected(user) || type < 0 || type > E_CONTRIBUTOR_RYHES ) {
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected, or the type is not 0 to 5." ) ;
		return true ;	
	}

	Account [ user ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] = type ;

	new rank_name [ 32 ], string [ 256 ] ;

	GetContributorRankName ( Account [ user ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ], rank_name, 32 ) ;

	format ( string, sizeof ( string ), "{[ %s (%d) has invited %s (%d) as a %s. ]}",  ReturnPlayerNameData ( playerid ), playerid,
		ReturnPlayerNameData ( user ), user, rank_name ) ;

	SendAdminMessage(string, true) ;

	WriteLog ( playerid, "admin/makecontr", string );
	WriteLog ( playerid, "admin/all", string );

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, sizeof(string), "UPDATE accounts SET account_contributor = %d WHERE account_id = %d", 

		Account [ user ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ], Account [ user ] [ E_PLAYER_ACCOUNT_ID ] ) ;

	mysql_tquery(mysql, string);
	Contributor_ApplyRights(user);


	return true ;
}

/*
CMD:togadmin(playerid) {

	if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] && GetPlayerAdminLevel(playerid) < ADMIN_LVL_MANAGER ) {

		return SendClientMessage ( playerid, COLOR_ERROR, "Only Contributors and Managers can use this command." ) ;
	}


	if ( PlayerVar [ playerid ] [ E_PLAYER_ADMIN_WARNS_TOGGLED ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_ADMIN_WARNS_TOGGLED ] = false ;
		SendClientMessage ( playerid, COLOR_BLUE, "You've enabled admin/helper warnings.");

	}

	else {
		PlayerVar [ playerid ] [ E_PLAYER_ADMIN_WARNS_TOGGLED ] = true ;
		SendClientMessage ( playerid, COLOR_BLUE, "You've disabled admin/helper warnings.");
	}

	return true ;
}
*/