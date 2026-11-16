
/*
CMD:help(playerid, params[]) {


	SendClientMessage(playerid, COLOR_SERVER, "[List of common server commands]");
	SendClientMessage(playerid, COLOR_YELLOW, "[SYSTEMS]{A3A3A3} /anims, /jobhelp, /propertyhelp, /f(action)help, /carhelp, /kioskhelp, /chathelp");
	SendClientMessage(playerid, COLOR_YELLOW, "[SYSTEMS]{A3A3A3} /gatehelp /drughelp, /voicehelp, /phonehelp, /furnihelp, /spraytaghelp, /basketballhelp");
	SendClientMessage(playerid, COLOR_GRAD0, "/settings, /pay, /paya(nim), /id, /boombox, /factions, /showinjuries, /seta(armed)w(eapon), /passgun, /passammo,");
	SendClientMessage(playerid, COLOR_GRAD1, "/bus, /(un)rentvehicle, /taketest, /setchat, /clearcp (/nocp), /synctags, /nosound, /tognicks,");
	SendClientMessage(playerid, COLOR_GRAD0, "/fillcar, /emmet, /carcolorlist, /hudscalefix, /payfine, /license(s), /badge");
	SendClientMessage(playerid, COLOR_GRAD1, "/gascan, /arf, /arp, /cmc, /dmvcp, /mask, /removemask, /call, /sms, /pickup, /h(angup), /setaw");
	SendClientMessage(playerid, COLOR_GRAD0, "/helpup, /surgery, /address (/whereami, /street), /kane, /adminrecord, /playerskin, /rules");
	SendClientMessage(playerid, COLOR_GRAD1, "/blindfold, /accept, /charity, /servertime, /assemble, /collectwood, /collectmetal, /collectparts");
	SendClientMessage(playerid, COLOR_GRAD0, "/advert, /coin, /dice, /greet, /namechange, /toys, /reloadtoys, /buytoys, /pricelist");
	SendClientMessage(playerid, COLOR_GRAD1, "/givefear, /giverespect, /r(espected)c(hat) /dropgun, /synctags, /synctablist, /credits");
	SendClientMessage(playerid, COLOR_GRAD0, "/myprops, /dropprop, /atc, /toys, /mytoys, /chopshop, /prisoners, /savings, /mytickets");
	SendClientMessage(playerid, COLOR_GRAD1, "/propertyactive, /lockpick, /smashwindow, /spawn, /myspawns, /dc, /togdc, /gymstats, /fightstyle");

	if ( IsPlayerHelper ( playerid ) ) {

		SendClientMessage(playerid, COLOR_HELPER, "[Helper]{DEDEDE} /staffhelp" ) ;
	}

	if ( IsPlayerContributor(playerid) ) {
		SendClientMessage ( playerid, COLOR_ERROR, "[Contributor]{DEDEDE} /a(chat), /h(elper)c(hat), /togadmin");
	}

	SendClientMessage(playerid, COLOR_SERVER, "[NEW]{A3A3A3} /lastonline, /getma(steraccount), /getc(haracters), /myfuelstations, /nearestpump, /neareststation");

	return true ;
}

*/

CMD:hitmanhelp(playerid) {
	if ( IsPlayerHitman ( playerid ) ) {

		SendClientMessage(playerid, 0x222222FF, "[Hitman]{DEDEDE} /contracts, /contractupdate, /contractoffer, /contractremove");
		SendClientMessage(playerid, 0x222222FF, "[Hitman]{DEDEDE} /e(ar)p(lug), /mole, /killmole, /makehitman, /hitmanrank, /marktarget (do this before killing: puts them on 2 hour CD)");
		SendClientMessage(playerid, 0x222222FF, "[Hitman]{DEDEDE} Always do /mask when you are doing hitman contracts /AT ANY MOMENT/. Do not approach contractors without /mask.");
		SendClientMessage(playerid, 0x222222FF, "[Hitman]{DEDEDE} Roleplay tracing numbers is allowed for hitmans. You have to RP getting moles before using.");
		SendClientMessage(playerid, 0x222222FF, "[Hitman]{DEDEDE} If you share hitman secrets IC or OOC you will be banned. If you get discovered, it's an auto CK.");

		return true ;
	}

	else return false ;
}

CMD:kane(playerid) {

	SendClientMessage(playerid, -1, "warm it up kane!");
	return true ;
}

CMD:credits(playerid) {

	SendClientMessage(playerid, COLOR_ORANGE, "A list of all noteworthy contributors to our community" ) ;

	SendClientMessage(playerid, COLOR_BLUE, "[Development Help]:" ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "SF-CNR:{DEDEDE} Open sourcing their pool, poker, blackjack, roulette and slots script. " ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "PatrickGTR:{DEDEDE} Open sourcing their actor robbery script. " ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Matz:{DEDEDE} Creating the basketball script, trucking job and gym script for SOLS." ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Reyo / Janichar / Ryhes:{DEDEDE} 95 percent of all custom models and maps are pioneered by these triumvirs." ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Greco:{DEDEDE} Almost 65 percent of exterior maps and many interior maps are done by Greco." ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Shabo:{DEDEDE} Small third party development work and helping Hades with ideas / troubleshooting") ;
	SendClientMessage(playerid, COLOR_ORANGE, "DenNorske:{DEDEDE} Helping Hades set up DDoS protection on the new dedicated server after a week long attack.") ;
	SendClientMessage(playerid, COLOR_ORANGE, "Spooky:{DEDEDE} Gamemode development, new systems (/spawn, sirens, blinkers) and custom models (pd int and more!)" ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Kubi (PL) and Patryk:{DEDEDE} Open sourcing their vehicle blinker data." ) ;

	SendClientMessage(playerid, COLOR_BLUE, "[Community Help]:" ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Phoenix:{DEDEDE} Helping with reassembling the community, pre-launch community management" ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "Limex:{DEDEDE} Old owner of True Roleplay - drove Hades to create a T-RP remake which is what the server runs on right now." ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "BigBear / Biggie:{DEDEDE} Intensive server testing (often spending hours with Hades ingame) pre and post launch." ) ;

	SendClientMessage(playerid, COLOR_BLUE, "[Conclusion]:" ) ;
	SendClientMessage(playerid, COLOR_ORANGE, "The Community{DEDEDE} for making this server possible and sticking by the staff team through sweat and frustration." ) ;

	return true ;
}



CMD:clearmychat(playerid) 
{
	for_loop (new i, j = 10; i < j; i ++ ) 
	{
		SendClientMessage(playerid, -1, " " );
	}

	return true;
}

CMD:cmc(playerid) return cmd_clearmychat(playerid);
CMD:clearchat(playerid) return cmd_clearmychat(playerid);
CMD:chatclear(playerid) return cmd_clearmychat(playerid);

CMD:servertime ( playerid, params [] ) {

	new string [ 128 ] ;

	format ( string, sizeof ( string ), "The current OOC [[VPS/SERVER HOST]] date/time is %s(GMT +1)", ReturnDateTime () ) ;
	SendClientMessage ( playerid, 0xDEDEDEFF, string ) ;

	string[0] = EOS ;
	format ( string, sizeof ( string ), "The current IC [[roleplay universe]] date/time is %.02d/%.02d/1997 %.0d:%.02d",
		Server [ E_SERVER_TIME_DAYS ], Server [ E_SERVER_TIME_MONTHS ],
		Server [ E_SERVER_TIME_HOURS ], Server [ E_SERVER_TIME_MINUTES ]

	);
	SendClientMessage ( playerid, 0xDEDEDEFF, string ) ;


	return true ;
}

CMD:viewmotd(playerid) {

	SendClientMessage(playerid, 0xD1B68DFF, "===={DBB275}===={D5A04E}===={DE921F}===={DEDEDE} [{C87900} MOTD {DEDEDE} ] {DE921F}===={D5A04E}===={DBB275}===={D1B68D}====" ) ;

	if ( strlen ( Server [ E_SERVER_MOTD_STRING_1 ] ) > 1) {
		SendClientMessage(playerid, -1, Server [ E_SERVER_MOTD_STRING_1 ] );
	}

	if ( strlen ( Server [ E_SERVER_MOTD_STRING_2 ] ) > 1) {
		SendClientMessage(playerid, -1, Server [ E_SERVER_MOTD_STRING_2 ] );
	}

	if ( strlen ( Server [ E_SERVER_MOTD_STRING_3 ] ) > 1) {
		SendClientMessage(playerid, -1, Server [ E_SERVER_MOTD_STRING_3 ] );
	}

	SendClientMessage(playerid, 0xD1B68DFF, "===={DBB275}===={D5A04E}===={DE921F}===={C87900}========{DE921F}===={D5A04E}===={DBB275}===={D1B68D}====" ) ;

	SendClientMessage(playerid, 0xDEDEDEAA, sprintf("Last updated by %s.", Server [ E_SERVER_MOTD_EDITOR ] ) ) ;

	return true ;
}
