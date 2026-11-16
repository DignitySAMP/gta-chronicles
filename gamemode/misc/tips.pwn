#define RAND_MSG_SERV_TICK		( 900000  )
task RandomServerMessages[RAND_MSG_SERV_TICK]() {

	switch ( Server [ E_SERVER_RAND_MSG ] ) {

		case 0: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} To view a list of server commands, you may use /help or ask a question via /ask." ) ;
		case 1: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} To view a list of server animations, you can use /anims and /stopanim to cancel an animation.") ;
		case 2: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} To ensure a smooth experience, follow and stay up to date with the server rules via /rules. ") ;
		case 3: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} To see all people who contributed to the server you can type /credits. These people all helped make this server possible.") ;
		case 4: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} Did you know that you can purchase your own pool table, basketball hoop, /door or more? Use /pricelist.") ;
		case 5: SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} You can create Spawnables (hundreds of small objects and props) with /spawn to enhance your roleplay scenes.") ;
		default: {
			SendTipMessage(COLOR_TIP, "[TIP]{E7EAB5} To see upcoming updates, script changelogs and or keep up with announcements, tune in on our Discord @ gta-chronicles.com/discord." ) ;
			Server [ E_SERVER_RAND_MSG ] = -1 ;
		}
	}

	Server [ E_SERVER_RAND_MSG ] ++ ;
}

SendTipMessage(color, text[]) {

	foreach(new playerid: Player) {

		// Only send tips / hints to people with them enabled in /settings
		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_SETTINGS_TIPS ] ) {

			SendClientMessage(playerid, color, text);
		}

		else continue ;
	}
}