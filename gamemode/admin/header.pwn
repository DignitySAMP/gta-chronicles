
#include "admin/data.pwn"
#include "admin/contributor.pwn"
#include "admin/arecord.pwn"
#include "admin/misc.pwn"
#include "admin/ajail.pwn"
#include "admin/bans.pwn"
#include "admin/movement.pwn"
#include "admin/spectate_gui.pwn"
#include "admin/spectate.pwn"
#include "admin/vehicle.pwn"
#include "admin/vehicle_func.pwn"
#include "admin/jetpack.pwn"
#include "admin/true-rp.pwn"
#include "admin/namechanges.pwn"
#include "admin/reports.pwn"
#include "admin/setstat.pwn"
#include "admin/coc.pwn"
#include "admin/convo.pwn"
#include "admin/banevade.pwn"
#include "admin/public.pwn"
#include "admin/maintenance.pwn"
#include "admin/note.pwn"
#include "admin/vpn.pwn"
#include "admin/subroles.pwn"

CMD:admins(playerid, params[]) 
{
	new staff_rank, contrib_rank, rank_name[32], rank_color[16], string[128], count;
	SendClientMessage(playerid, 0xb18745FF, "__________________ Online Administrators __________________") ;

	foreach(new targetid: Player) 
	{
		if (Character[targetid][E_CHARACTER_ADMIN_HIDE] && GetPlayerAdminLevel(playerid) < ADMIN_LVL_MANAGER) continue;

		staff_rank = Account[targetid][E_PLAYER_ACCOUNT_STAFFLEVEL];
		contrib_rank = Account[targetid][E_PLAYER_ACCOUNT_CONTRIBUTOR];

		if (staff_rank || contrib_rank)
		{
			if (contrib_rank)
			{
				GetContributorRankName(Account[targetid][E_PLAYER_ACCOUNT_CONTRIBUTOR], rank_name, 32);
				GetContributorRankColor(Account[targetid][E_PLAYER_ACCOUNT_CONTRIBUTOR], rank_color, 16);
			}
			else
			{
				GetAdminRankName(Account[targetid][E_PLAYER_ACCOUNT_STAFFLEVEL], rank_name, 32);
				GetAdminRankColor(Account[targetid][E_PLAYER_ACCOUNT_STAFFLEVEL], rank_color, 16);
			}

			format(string, sizeof(string), "» %s%s{DEDEDE} | %s (ID: %d) | Requests: %d", rank_color, rank_name, Account[targetid][E_PLAYER_ACCOUNT_NAME], targetid, Account[targetid][E_PLAYER_ACCOUNT_REPORTS_DONE]);
			if (HasAnyAdminRole(targetid)) format(string, sizeof(string), "%s | Roles: %s", string, PrintAdminRoles(targetid));

			if (PlayerVar[targetid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, 0x54acd2FF, string);
			else SendClientMessage(playerid, 0xa6a492FF, string);

			count ++;
		}
	}

	if (!count) 
	{
		SendClientMessage(playerid, COLOR_GRAD0, "None");
	}

	SendClientMessage(playerid, COLOR_GRAD1, "To view a list of helpers, use /helpers.");
	return true ;
}

CMD:gunban(playerid, params[]) {

	return cmd_setgunrights(playerid, params);
}

CMD:setgunrights(playerid, params[]) {


	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Only big dick niggas!" ) ;
	}

	new user, status, string [ 256 ] ;

	if ( sscanf ( params, "k<player>i", user, status ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setgunrights [target] [status: 0 (able), 1 (banned)" ) ;
		return true ;
	}

	if ( ! IsPlayerConnected(user)) {
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
		return true ;	
	}

	Account [ user ] [ E_PLAYER_ACCOUNT_GUNBAN ] =  status ;

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, 	sizeof ( string ), 	"UPDATE accounts SET account_gunban = %d WHERE account_id = %d",
		Account [ user ] [ E_PLAYER_ACCOUNT_GUNBAN ], Account [ user ] [ E_PLAYER_ACCOUNT_ID ]
	);

	mysql_tquery(mysql, string);

	if ( status ) {
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've just gun banned (%d) %s.", user, ReturnPlayerNameData ( user ) ) ) ;
		SendClientMessage(user, COLOR_YELLOW, sprintf("You've just been gun banned by (%d) %s.", playerid, ReturnPlayerNameData ( playerid ) ) ) ;

		string [ 0 ] = EOS ;

		format ( string, sizeof ( string ), "[GUN-BAN] %s (%d) has just gun banned %s (%d).", ReturnPlayerNameData(playerid), playerid, ReturnPlayerNameData(user), user );
		SendAdminMessage ( string, true ) ;
	}

	else if ( ! status ) {
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You've removed (%d) %s's gun ban.", user, ReturnPlayerNameData ( user ) ) ) ;
		SendClientMessage(user, COLOR_YELLOW, sprintf("Your gun ban has been removed by (%d) %s. You will be watched!", playerid, ReturnPlayerNameData ( playerid ) ) ) ;

		string [ 0 ] = EOS ;

		format ( string, sizeof ( string ), "[GUN-BAN] %s (%d) has removed %s (%d)'s gun ban.", ReturnPlayerNameData(playerid), playerid, ReturnPlayerNameData(user), user );
		SendAdminMessage ( string, true ) ;	
	}

	return true ;
}

CMD:vehban(playerid, params[]) 
{
	if ( GetPlayerAdminLevel(playerid) < ADMIN_LVL_SENIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Only big dick niggas!" ) ;
	}

	new user, status, string [ 256 ] ;

	if ( sscanf ( params, "k<player>i", user, status ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/vehban [player] [status: 0 (able), 1 (banned)" ) ;
		return true ;
	}

	if ( ! IsPlayerConnected(user) || ! IsPlayerPlaying(user)) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
		return true ;	
	}

	Account [ user ] [ E_PLAYER_ACCOUNT_VEHBAN ] =  status ;

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, 	sizeof ( string ), 	"UPDATE accounts SET account_vehban = %d WHERE account_id = %d",
		Account [ user ] [ E_PLAYER_ACCOUNT_VEHBAN ], Account [ user ] [ E_PLAYER_ACCOUNT_ID ]
	);

	mysql_tquery(mysql, string);

	if ( status ) 
	{
		SendClientMessage(user, COLOR_YELLOW, sprintf("Your permission to drive vehicles was revoked by Admin %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
		format ( string, sizeof ( string ), "[VEH-BAN] (%d) %s has vehicle banned (%d) %s.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), user, ReturnPlayerNameData(user));
		SendAdminMessage ( string, true ) ;
	}
	else if ( ! status ) 
	{
		SendClientMessage(user, COLOR_YELLOW, sprintf("Your permission to drive vehicles was reinstated by Admin %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
		format ( string, sizeof ( string ), "[VEH-BAN] (%d) %s has vehicle unbanned (%d) %s.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), user, ReturnPlayerNameData(user));
		SendAdminMessage ( string, true ) ;
	}

	return true ;
}

CMD:bikeban(playerid, params[]) 
{
	if ( GetPlayerAdminLevel(playerid) < ADMIN_LVL_SENIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Only big dick niggas!" ) ;
	}

	new user, status, string [ 256 ] ;

	if ( sscanf ( params, "k<player>i", user, status ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/bikeban [player] [status: 0 (able), 1 (banned)" ) ;
		return true ;
	}

	if ( ! IsPlayerConnected(user) || ! IsPlayerPlaying(user)) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected." ) ;
		return true ;	
	}

	Account [ user ] [ E_PLAYER_ACCOUNT_BIKEBAN ] =  status ;

	string [ 0 ] = EOS ;

	mysql_format(mysql, string, 	sizeof ( string ), 	"UPDATE accounts SET account_bikeban = %d WHERE account_id = %d",
		Account [ user ] [ E_PLAYER_ACCOUNT_BIKEBAN ], Account [ user ] [ E_PLAYER_ACCOUNT_ID ]
	);

	mysql_tquery(mysql, string);

	if ( status ) 
	{
		SendClientMessage(user, COLOR_YELLOW, sprintf("Your permission to drive bikes was revoked by Admin %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
		format ( string, sizeof ( string ), "[VEH-BAN] (%d) %s has banned (%d) %s from using bikes.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), user, ReturnPlayerNameData(user));
		SendAdminMessage ( string, true ) ;
	}
	else if ( ! status ) 
	{
		SendClientMessage(user, COLOR_YELLOW, sprintf("Your permission to drive bikes was reinstated by Admin %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid));
		format ( string, sizeof ( string ), "[VEH-BAN] (%d) %s has unbanned (%d) %s from using bikes.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), user, ReturnPlayerNameData(user));
		SendAdminMessage ( string, true ) ;
	}

	return true ;
}

CMD:getplayernumber(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/getnumber [number]: gets name of number holder") ;
	}

	if ( ! IsPlayerConnected(targetid) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "Target isn't connected!") ;
	}

	SendClientMessage(playerid, COLOR_BLUE, "Target is CURRENTLY ONLINE:" ) ;

	new query [ 256 ] ;

	format ( query, sizeof ( query ), "Last result fetched: found name %s (%s) linked to number %d.",
		Character [ targetid ] [ E_CHARACTER_NAME ], Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ] ) ;

	SendClientMessage(playerid, COLOR_YELLOW, query);
	
	return true ;
}

CMD:getnumber(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new input ;

	if ( sscanf ( params, "i", input ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/getnumber [number]: gets name of number holder") ;
	}


	new targetid = INVALID_PLAYER_ID  ;

	foreach(new i: Player) {

		if ( Character [ i ] [ E_CHARACTER_PHONE_NUMBER ] == input ) {

			targetid = i ;
		
			break ;
		}

		else continue ;
	}

	new query [ 256 ] ;

	if ( targetid == INVALID_PLAYER_ID ) {

		SendClientMessage(playerid, COLOR_BLUE, "Target is not online - consulting database..." ) ;

		new name [ MAX_PLAYER_NAME ] ;

		inline Number_OnDataLoad() {

			new rows, fields ;
			cache_get_data ( rows, fields, mysql ) ;

			if ( rows ) {

				for_loop ( new i, j = rows; i < j ; i ++ ) {
					cache_get_field_content ( i, "player_name", name, mysql, MAX_PLAYER_NAME ) ;

					query [ 0 ] = EOS ;
					format ( query, sizeof ( query ), "Database result %d: found name %s linked to number %d.", i, name, input ) ;
					SendClientMessage(playerid, COLOR_YELLOW, query);
				}
			}

			else if ( ! rows ) {

				SendClientMessage(playerid, COLOR_RED, "Database returned no rows - are you sure the input is correct?" ) ;
				return true ;
			}
		}

		query [ 0 ] = EOS ;
		mysql_format(mysql, query, sizeof(query), "SELECT player_name FROM characters WHERE player_phnumber = %d", input ) ;

		mysql_tquery_inline ( mysql, query, using inline Number_OnDataLoad, "" ) ;
	}

	else if ( targetid != INVALID_PLAYER_ID ) {

		SendClientMessage(playerid, COLOR_BLUE, "Target is CURRENTLY ONLINE:" ) ;

		query [ 0 ] = EOS ;

		format ( query, sizeof ( query ), "Last result fetched: found name %s (%s) linked to number %d.",
			ReturnPlayerNameData(targetid), Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], input ) ;

		SendClientMessage(playerid, COLOR_YELLOW, query);
	}

	return true ;
}

IsAnyAdminOnline() {

	foreach(new playerid: Player) {

		if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] ) {
			return true ;
		}
	}

	return false ;
}

/*
CMD:punishlist(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	SendClientMessage(playerid,-1,"{71EB00}[KICKABLE] {FFFFFF}AFK IN PUBLIC | FOREIGN LANGUAGES IN PUBLIC CHATS | SPAM | REQUESTING ADMIN HELP IN /PM");
	SendClientMessage(playerid,-1,"{EBCF00}[5-15 MIN] {ADADAD}BRAWL RULES | COMING BACK TO DEATH SCENE | ABUSING ANIMS OR STOPANIM | OLYMPIC SWIMMING");
	SendClientMessage(playerid,-1,"{EBCF00}[5-15 MIN] {ADADAD}NON-RP CAR SURF | AFK DURING RP | BUNNYHOPPING | STEALING MARKED GOV VEHICLES");
	SendClientMessage(playerid,-1,"{EBCF00}[5-15 MIN] {ADADAD}ABUSE OF VOIP | FIREARM/DRUG ADVERTISEMENTS | OOC SALES OF FIREARMS/DRUGS");
	SendClientMessage(playerid,-1,"{FF8400}[15-45 MIN] {FFFFFF}NINJA JACKING | NON-RP DRIVING | COP WHORING | GANG WHORING | DRIVER DRIVE BY");
	SendClientMessage(playerid,-1,"{FF8400}[15-45 MIN] {FFFFFF}GUN WHORING | CAR DEATHMATCH | OOC INSULTS | CHICKEN RUNNING | GREENZONE RULES");
	SendClientMessage(playerid,-1,"{FF8400}[15-45 MIN] {FFFFFF}MIXING IC AND OOC | INAPPROPRIATE USAGE OF /DO | MOANING IN /B");
	SendClientMessage(playerid,-1,"{FF4000}[45-120 MIN] {ADADAD}POWERGAMING | METAGAMING | FAILURE TO SHOW FEAR | TERRORISM | SCAM/ROB/TICKET RULES");
	SendClientMessage(playerid,-1,"{F00000}[60-120 MIN] {FFFFFF}DEATHMATCHING/POOR REASON TO KILL | TROLLING | REVENGE KILLING");
	SendClientMessage(playerid,-1,"{F00000}[60-120 MIN] {FFFFFF}QUIT/CRASH TO AVOID DEATH/JAIL/RP | OOC LYING | REFUSING/FAILURE TO RP");
	SendClientMessage(playerid,-1,"{B00000}[3+ DAY BAN] {ADADAD}STAFF DISRESPECT | OOC RACISM | OOC SCAMMING | LYING TO AN ADMIN");
	SendClientMessage(playerid,-1,"{B00000}[7+ DAY BAN] {ADADAD}HACKING (PERM) | BUG ABUSING | CHEATING | RAPE WITHOUT PERMISSION | ADVERTISING");
	SendClientMessage(playerid,-1,"{B000A4}[ACCOUNT] {FFFFFF}CELEBRITY NAMES | UNREALISTIC NAMES | RACIST NAMES");

	return 1;
}
*/

CMD:adminhelp(playerid) {

	return ShowStaffCommands(playerid);
}

ShowStaffCommands(playerid) {

	if ( ! Account [ playerid ] [ E_PLAYER_ACCOUNT_CONTRIBUTOR ] ) {
		if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR && !IsPlayerHelper(playerid) ) {

			return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
		}
	}

	SendClientMessage(playerid, COLOR_ERROR, "[List of staff commands]:" ) ;

	if (GetPlayerHelperLevel(playerid) >= HELPER_LVL_NORMAL)
	{
		SendClientMessage ( playerid, 0x9FE6A0FF, "[TRIAL HELPER] /h(elper)c(hat), /a(ccept)h(elp), /answer, /questions");
	}

	if (GetPlayerHelperLevel(playerid) >= HELPER_LVL_SENIOR)
	{
		SendClientMessage ( playerid, 0x72B065FF, "[HELPER] /helperduty, /checkcars, /respawnplayer, /mark, /gotomark, /goto, /gethere, /gps (tp locations)");
	}

	if (GetPlayerHelperLevel(playerid) >= HELPER_LVL_ADVANCED)
	{
		SendClientMessage ( playerid, 0x59C9BDFF, "[SENIOR HELPER] /reports, /acceptreport (/ar), /denyreport (/dr), /namechanges, /resetattributes");
		SendClientMessage ( playerid, 0x59C9BDFF, "[SENIOR HELPER] /unfreeze, /getcar, /fixcar, /fuelcar, /slapcar, /slap, /clearinjuries, /setint, /setvw");
	}

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_JUNIOR ) 
	{
		SendClientMessage ( playerid, 0xD1B68DFF, "[JUNIOR] /a(chat), /aduty, /acinvite, /acuninvite, /spec, /kick, /ban, /ajail, /unajail");
		SendClientMessage ( playerid, 0xD1B68DFF, "[JUNIOR] /offlineban, /offlineajail, /removemask, /omaskid, /adminrecord, /resetemail" ) ;
		SendClientMessage ( playerid, 0xD1B68DFF, "[JUNIOR] /disarm, /confiscate, /frisk, /getcharid, /getcharname, /getchars, /getma" ) ;
		SendClientMessage ( playerid, 0xD1B68DFF, "[JUNIOR] /getnumber, /getcoordinates, /notes, /entercar, /ecc, /carflip, /takecar" ) ;
		SendClientMessage ( playerid, 0xD1B68DFF, "[JUNIOR] /listmasked, /listcars, /listnear, /checkrefunds, /propertygoto" ) ;
	}

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_GENERAL ) {

		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /banip, /unbanip, /setskin, /jetpack, /damages, /deletecar" ) ;
		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /carslap, /carhp, /propertycheck, /propertyint(erior)list" ) ;
		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /gotoxyz, /s(pray)t(ag)goto, /carsavesiren, /caradminpark");
		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /geoip, /settime, /setweather, /s(pray)t(ag)clearcd, /engine, /tp, /aooc" ) ;	
		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /allspawns /setarmor /sethealth, /caradmincolor, /checkstats, /checkproperties, /checkguns" ) ;	
		SendClientMessage ( playerid, 0xDBB275FF, "[GENERAL] /admin911, /wardrobehelp, /checkvpn, /fgoto, /makeooc, /noclip, /names" ) ;	
	}

	if ( GetPlayerAdminLevel(playerid) >= ADMIN_LVL_SENIOR)
	{
		SendClientMessage ( playerid, 0xf58840FF, "[SENIOR] /setucpbypass, /setfightstyle, /setcarhp, /vehban, /bikeban, /otakelicense, /afjoin" ) ;
	}

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_ADVANCED ) 
	{
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /f(action)name, /f(action)create,  /f(action)hex, /f(action)skinadd, /f(action)extra, /f(action)visible" ) ;
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /setmotd, setstat, /spoof(give)gun, /spoofmats, /spoofdrug, /spoofdrugstation, /spoofammo");
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /drugsetparam, /drugsetstage /drugsetticks, /drugforcefinish, /drugsuppliergoto, /spoofattach" ) ;
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /s(pray)t(ag)create, /s(pray)t(ag)delete, /addattachpoint, /attachpointdelete, /attachpointlink");
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /gangzoneassign, /gangzonecontest, /gangzoneid, /carcreate, /carowner, /cartype, /carjob, /chopshopfaction");
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /gotostore, /gotowholesaler, /togd(onator)c(hat), /takemoney, /togglenoclip, /(set)customanim");
		//SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /createfuelpump, /linkpumptostation, /unlinkpump, /viewlinkedpumps, /gotopump, /movepump, /deletepump, /unlinkedpumps");
		//SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] /createfuelstation, /gotostation, /movestation, /auctionstation, /deletestation, /stationinfo");
		SendClientMessage ( playerid, 0xD08615FF, "[ADVANCED] NEW: /gunban, /adminad, /adminbreaking");
		//SendClientMessage ( playerid, 0x965B00FF, "[ADVANCED] /firmtype, /firmname, /firmgoto, /firmmove, /firminfo, /firmlog" ) ;
	}

	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_MANAGER ) 
	{
		SendClientMessage ( playerid, 0x965B00FF, "[LEAD] /man, /makeadmin, /makehelper, /makestrawman, /givemoney, /adminhex, /helperhex, /paycheck, /togds, /setadminrole" ) ;
	}

	if ( GetPlayerAdminLevel ( playerid ) > ADMIN_LVL_MANAGER ) 
	{
		SendClientMessage ( playerid, 0x965B00FF, "[MANAGER] /makecontributor, /addplayerskin, /setintrosong, /spoofbuy, /spoofpool, /spoofprop, /poolspoof" ) ;
	}

	PrintAdminRoleCmds(playerid);
	return true ;
}


CMD:staffhelp(playerid) {
	return ShowStaffCommands(playerid);
}

CMD:setucpbypass(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_SENIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new name [ MAX_PLAYER_NAME ], bypass ;

	if ( sscanf ( params, "s[24]d", name, bypass ) || bypass < 0 || bypass > 1 ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setucpbypass [account name] [0 or 1]");
	}

	new query [ 128 ] ;
	inline ReturnAccountID() 
	{
		new rows, fields, accid, accname[32];
		cache_get_data ( rows, fields, mysql ) ;

		if ( ! rows ) 
		{
			return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Database didn't return any data. Did you type the name correctly?");
		}

		accid = cache_get_field_int (0, "account_id" ) ;
		cache_get_field_content(0, "account_name", accname, mysql, sizeof ( accname ) ) ;

		mysql_format ( mysql, query, sizeof ( query ), "UPDATE `accounts` SET `account_registration_legacy` = %d WHERE `account_id` = %d", bypass, accid ) ;
		mysql_tquery(mysql, query);

		SendAdminCmd(playerid, sprintf("set the UCP bypass status of %s (Account ID: %d) to %d", accname, accid, bypass));
	}

	mysql_format ( mysql, query, sizeof ( query ), "SELECT `account_id`, `account_name` FROM `accounts` WHERE `account_name` = '%e'", name ) ;
	mysql_tquery_inline(mysql, query, using inline ReturnAccountID, "");

	return true;
}

CMD:listcars(playerid)
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new count = 0;

	foreach (new i:Player)
	{
		new vehicleid = GetPlayerVehicleID(i);

		if (vehicleid && GetPlayerVehicleSeat(i) == 0)
		{
			SendClientMessage(playerid, -1, sprintf("VID: %d (%s) | Driver: (%d) %s", vehicleid, ReturnVehicleName(vehicleid), i, ReturnPlayerNameData(i))); 
			count ++;
		}
	}

	SendClientMessage(playerid, -1, sprintf("Total vehicles with a driver: %d", count));
	if (count) SendAdminCmd(playerid, "used /listcars to view all vehicles with a driver");

	return true;
}

CMD:listmasked(playerid)
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new count = 0;

	foreach (new i:Player)
	{
		if (PlayerVar[i][E_PLAYER_IS_MASKED])
		{
			SendClientMessage(playerid, -1, sprintf("(%d) Stranger %d | %s", i, Character[i][E_CHARACTER_MASKID], ReturnPlayerNameData(i))); 
			count ++;
		}
	}

	SendClientMessage(playerid, -1, sprintf("Total masked players: %d", count));
	if (count) SendAdminCmd(playerid, "used /listmasked to view all masked players");

	return true;
}

CMD:viewcars(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_SENIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new modelid ;

	if ( sscanf ( params, "i", modelid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/viewcars [modelid]");
	}

	for ( new i, j = MAX_VEHICLES; i < j ; i ++ ) {

		if ( IsValidVehicle(i)){
			if ( GetVehicleModel(i) == modelid ) {

				SendClientMessage(playerid, -1, sprintf("Model ID %d; vehicle ID %d", modelid, i ) ) ;
			}
		}
	}

	/*
	new string [ 150 ] ;
	format ( string, sizeof ( string ), "[AC] %s (%d) checked all spawned cars with model %d.", ReturnPlayerNameData(playerid), playerid, modelid);
	SendAdminMessage ( string ) ;
	*/

	return true ;
}

/*
CMD:blockaccounts(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new seconds;

	if ( sscanf ( params, "i", seconds ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/blockaccounts [seconds] (disables new accounts for x seconds)");

	}

	if (seconds == 0) Server[E_SERVER_ACCS_DISABLED_UNTIL] = 0;
	else if (seconds < 0 || seconds > 3600) return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Seconds can't be less than 0 or more than 3600.");

	Server[E_SERVER_ACCS_DISABLED_UNTIL] = gettime() + seconds;
	SendAdminMessage(sprintf("[!!!] [AdmWarn] (%d) %s has disabled new accounts for %d seconds.", playerid, ReturnPlayerNameData ( playerid ), seconds )) ;

	return true;
}
*/

CMD:setmotd(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	
	new slot, text [ 96 ] ;

	if ( sscanf ( params, "is[96]", slot, text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setmotd [1, 2, 3] [text]");

	}

	switch ( slot ) {

		case 1 : format (Server [ E_SERVER_MOTD_STRING_1 ], 96, "%s", text ) ;
		case 2 : format (Server [ E_SERVER_MOTD_STRING_2 ], 96, "%s", text ) ;
		case 3 : format (Server [ E_SERVER_MOTD_STRING_3 ], 96, "%s", text ) ; 
		default : {

			return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Slot can't be lower than 1 or higher than 3.");
		}
	}

	format ( Server [ E_SERVER_MOTD_EDITOR ], MAX_PLAYER_NAME, "%s", Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ]) ;
	Server [ E_SERVER_MOTD_EDIT_TIME ] = gettime();

	new query [ 512 ] ;
	mysql_format(mysql, query, sizeof ( query ), "UPDATE server SET server_slots_motd_1 = '%e', server_slots_motd_2 = '%e', server_slots_motd_3 = '%e', server_motd_editor = '%e', server_motd_edit_time = %d", 
		Server [ E_SERVER_MOTD_STRING_1 ], Server [ E_SERVER_MOTD_STRING_2 ], Server [ E_SERVER_MOTD_STRING_3 ], 
		Server [ E_SERVER_MOTD_EDITOR ], Server [ E_SERVER_MOTD_EDIT_TIME ]
	) ;

	mysql_tquery(mysql, query);

	return cmd_viewmotd(playerid);
}	

CMD:geoip ( playerid, params [] ) {

	
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/geoip [target]") ;
	}

	if ( targetid == INVALID_PLAYER_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player doesn't need to be connected.") ;
	}

	if ( GetPlayerAdminLevel ( playerid ) <= GetPlayerAdminLevel(targetid) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "No, you don't.");
	}


	new country [ 32 ], region [ 32 ], city [ 32 ], isp [ 32 ], timez [ 32 ], zipcode [ 32 ] ;

	GetPlayerCountry(targetid, country ) ;
	GetPlayerRegion(targetid, region ) ;
	GetPlayerCity(targetid, city ) ;
	GetPlayerISP(targetid, isp ) ;
	GetPlayerZipcode(targetid, zipcode ) ;
	GetPlayerTimezone(targetid, timez ) ; 

	new string [ 150 ] ;

	format ( string, sizeof ( string ), "(%d) %s's GEODATA (IP: %s) [TIMEZONE: %s]", targetid, ReturnPlayerNameData(targetid), ReturnIP ( targetid ), timez );
	SendClientMessage(playerid, COLOR_YELLOW, string ) ;

	format ( string, sizeof ( string ), "Country: %s - Region: %s - City: %s - ISP: %s - Zipcode: %s", country, region, city, isp, zipcode );
	SendClientMessage(playerid, COLOR_YELLOW, string ) ;

	format ( string, sizeof ( string ), "[GEO] %s (%d) has checked %s (%d)'s geo data.", ReturnPlayerNameData(playerid), playerid, ReturnPlayerNameData(targetid), targetid );
	SendAdminMessage ( string ) ;

	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Checked GeoIP of %s", ReturnPlayerNameData(targetid)));
	//WriteLog ( playerid, "admin/misc",string);
	//WriteLog ( playerid, "admin/all", string);

	return true ;
}

CMD:setarmor(playerid, params[]) 
{
	if (GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL)
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;

	new targetid, armor;

	if (sscanf ( params, "k<player>i", targetid, armor))
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setarmor [player] [armor]");

	if ( ! IsPlayerConnected ( targetid ) )
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");

	if (armor < 0 || armor > 100)
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Armor must be between 0 - 100.");

	SetCharacterArmour(targetid, armor);
	SendAdminCmd(playerid, sprintf("set the armor of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), armor));

	return true ;
}

CMD:setkevlar(playerid, params[]) return cmd_setarmor(playerid, params);
CMD:setkev(playerid, params[]) return cmd_setarmor(playerid, params);
CMD:setarmour(playerid, params[]) return cmd_setarmor(playerid, params);
CMD:seta(playerid, params[]) return cmd_setarmor(playerid, params);
CMD:setap(playerid, params[]) return cmd_setarmor(playerid, params);

CMD:sethealth(playerid, params[]) 
{
	if (GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL)
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;

	new targetid, health;

	if (sscanf ( params, "k<player>i", targetid, health))
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/sethealth [player] [health]");

	if ( ! IsPlayerConnected ( targetid ) )
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");

	if (health < 0 || health > 100)
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Heath must be between 0 - 100.");

	SetCharacterHealth(targetid, health);
	SendAdminCmd(playerid, sprintf("set the health of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), health));

	return true ;
}

CMD:sethp(playerid, params[]) return cmd_sethealth(playerid, params);
CMD:seth(playerid, params[]) return cmd_sethealth(playerid, params);

CMD:setduty(playerid, params[]) 
{
	if (GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL)
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;

	new targetid, duty;

	if (sscanf ( params, "k<player>i", targetid, duty))
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setduty [player] [duty status]");

	if ( ! IsPlayerConnected ( targetid ) )
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");

	if (duty != 0 && duty != 1)
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Duty status must be 0 [off] or 1 [on]");

	if (!IsPlayerInDutyFaction(targetid))
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This player isn't in a faction that can go on or off duty.");

	if (duty == 0) PlayerVar [ targetid ] [ E_PLAYER_FACTION_DUTY ] = false;
	else if (duty == 1) PlayerVar [ targetid ] [ E_PLAYER_FACTION_DUTY ] = true;
	CallLocalFunction("SOLS_OnDutyStateChange", "d", targetid);
	
	SendAdminCmd(playerid, sprintf("set the duty status of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), duty));
	return true ;
}


CMD:akill(playerid, params[])
{
	if (GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_SENIOR)
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;

	new targetid, reason[64];

	if (sscanf ( params, "k<player>s[64]", targetid, reason))
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/akill [player] [death reason]");

	format(PlayerVar [ targetid ] [ E_PLAYER_INJURY_REASON ], 64, "%s", reason);

	TogglePlayerControllable(targetid, false);
	OnPlayerInjuryMode(targetid, playerid, DEATHTYPE_CUSTOM, 0) ;
	SetCharacterHealth(targetid, 25.0);
	return true;
}


CMD:setskin(playerid, params[]) {


	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid, skinid ;

	if ( sscanf ( params, "k<player>i", targetid, skinid ) ) {

		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setskin [targetid] [skinid]");
	}

	if ( ! IsPlayerConnected ( targetid ) ) {
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "Target isn't connected.");
	}

	SetPlayerSkinEx ( targetid, skinid ) ;
	SendAdminCmd(playerid, sprintf("set the skin of (%d) %s to %d", targetid, ReturnPlayerNameData(targetid), skinid));

	return true ;
}

CMD:omaskid(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	new maskid ;

	if ( sscanf ( params, "i", maskid ) ) {

		return SendClientMessage(playerid, -1, "/omaskid [maskid]" ) ;
	}

	new string [ 96 ], returned_name [ MAX_PLAYER_NAME ] ;

	inline FindOfflineMaskID() {

		new rows, fields;
		cache_get_data ( rows, fields, mysql ) ;

		if ( rows ) {

			cache_get_field_content(0, "player_name", returned_name, mysql, sizeof ( returned_name ) ) ;
			format ( string, sizeof ( string ), "Mask ID %d is linked to \"%s\" (/getma)", maskid, returned_name ) ;

			return SendClientMessage ( playerid, 0xD19932FF, string ) ; 
		}

		else {
			format (string, sizeof ( string ), "The mask ID \"%d\" could not be found.", maskid ) ;
			return SendServerMessage ( playerid, COLOR_RED, "Error", "DEDEDE", string ) ;
		}

	}

	mysql_format ( mysql, string, sizeof ( string ), "SELECT player_name FROM characters WHERE player_maskid = %d", maskid ) ;
	mysql_tquery_inline(mysql, string, using inline FindOfflineMaskID, "");

	SendAdminCmd(playerid, sprintf("checked the identity of Mask ID %d", maskid));
	return true ;
}


CMD:charity ( playerid, params [] ) {

	new amount, reason [ 64 ], string [ 256 ] ;

	if ( sscanf ( params, "is[64]", amount, reason ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "/charity [amount] [reason]");
	}

	if ( amount < 0 ) {

		format ( string, sizeof ( string ), "[AdminWarn]: (%d) %s just tried to spawn money by /charity'ing negative values! (amount: %d)", playerid, ReturnPlayerNameData ( playerid ), amount );
		SendAdminWarning ( string ) ;

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Nice try. This action has been logged.");
	}

	if ( Character [ playerid ] [ E_CHARACTER_CASH ] < amount ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have that much money in your hand!");
	}

	if ( ! strlen ( reason ) || strlen ( reason ) > 64 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Your reason can't be longer than 64 characters, or empty.");
	}

	inline CharityConfirm(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, dialogid, listitem, inputtext

		if ( ! response ) {

	    	return false ;
		}

		if ( response ) 
		{	
			format ( string, sizeof ( string ), "[CHARITY] (%d) %s has just charitied $%s. Reason: %s", playerid, ReturnPlayerNameData ( playerid ), IntegerWithDelimiter ( amount ), reason );
			SendAdminMessage ( string, true ) ;
			SendClientMessage(playerid, COLOR_YELLOW, string ) ;

			AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Charitied $%s for %s", IntegerWithDelimiter(amount), reason));
			DCC_SendCharityLogMessage(string);
			
			TakePlayerCash ( playerid, amount ) ;

			return true ;
		}
	}

	new confirmstring [ 1024 ] ;

	format ( confirmstring, sizeof ( confirmstring ), 

		"{C23030}READ THIS BEFORE PRESSING CONTINUE.{DEDEDE}\n\n\
		You're about to charity {C23030}%s{DEDEDE} to the server.\n\n\
		{C23030}THERE IS NO WAY TO GET THIS MONEY BACK.{DEDEDE}\n\n\
		Only press continue if you're certain."

	, IntegerWithDelimiter ( amount )  ) ;

	Dialog_ShowCallback ( playerid, using inline CharityConfirm, DIALOG_STYLE_MSGBOX, "{C23030}ANTI DUMBASS WARNING{DEDEDE}", confirmstring, "{C23030}Continue", "No way" );

	return true ;
}


CMD:maskid(playerid, params[]) {
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}
	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendClientMessage(playerid, -1, "/maskid [playerid]" ) ;
	}

	if ( ! IsPlayerConnected( targetid ) ) {

		return SendClientMessage(playerid, -1, "Target isn't connected." ) ;
	}

	new string [ 96 ] ;

	format ( string, sizeof ( string ), "(%d) %s's mask ID is %d.", targetid, Account [ targetid ] [ E_PLAYER_ACCOUNT_NAME ], GetPlayerMaskID(targetid ) ) ;
	SendClientMessage(playerid, COLOR_YELLOW, string);

	format ( string, sizeof ( string ), "[MASK] %s (%d) has checked %s (%d)'s mask id.", ReturnPlayerNameData(playerid), playerid, ReturnPlayerNameData(targetid), targetid ) ;

	WriteLog ( playerid, "admin/misc", string );
	WriteLog ( playerid, "admin/all",  string );

	SendAdminMessage(string);

	return true ;
}

CMD:whonear(playerid, params[]) {
 	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

   	const Float:DEFAULT_RANGE = 20.0; //THIS IS THE RANGE IF THE USER TYPES "/WHONEAR" ON IT'S OWN

    new count, Float:range;
    if (sscanf(params, "f", range) == 0) count = DisplayPlayersInRange(playerid, range);
    else count = DisplayPlayersInRange(playerid, DEFAULT_RANGE);
	if (count == 0) SendClientMessage(playerid, 0xFFFFFFFF, "None");

	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Checked nearby players with radius %.02f", range));
    return 1;
}

CMD:listnear(playerid, params[]) return cmd_whonear(playerid, params);

CMD:makeooc(playerid, params[]){

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/makeooc [targetid]");
	}

	if ( ! IsPlayerConnected( targetid ) ) {
		return SendClientMessage(playerid, COLOR_ERROR, "Your target isn't connected." ) ;
	}

	if(targetid == playerid) {
		return SendClientMessage(playerid, COLOR_ERROR, "You cannot set yourself to OOC. Use /adminduty to get a tag above your name.");
	}

	if ( !PlayerVar [ targetid ] [ E_PLAYER_IS_OOC ] ) 
	{
		PlayerVar [ targetid ] [ E_PLAYER_IS_OOC ] = true;

		if(PlayerVar [ targetid ] [ E_PLAYER_INJUREDMODE ] ||  PlayerVar [ targetid ] [ E_PLAYER_IS_BEANBAGGED ] || PlayerVar [ targetid ] [ E_PLAYER_IS_TAZED ]||PlayerVar [ targetid ] [ E_PLAYER_IS_TACKLED ]) {
			Injury_RemoveData_Player(targetid);
		}

		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Administrator %s has set you to Out-Of-Character.", ReturnPlayerNameData ( playerid, true, 0 )));
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You have set %s to OOC.", ReturnPlayerNameData(targetid, 0, true)));
	} 
	else if (PlayerVar [ targetid ] [ E_PLAYER_IS_OOC ]) 
	{
		PlayerVar [ targetid ] [ E_PLAYER_IS_OOC ] = false;

		SendClientMessage(targetid, COLOR_YELLOW, sprintf("Administrator %s has set you to In-Character.", ReturnPlayerNameData ( playerid, true, 0 )));
		SendClientMessage(playerid, COLOR_YELLOW, sprintf("You have set %s to IC.", ReturnPlayerNameData(targetid, 0, true)));
    }

    UpdatePlayerNameCache ( targetid );
 	UpdatePlayerNamesForOthers ( targetid ) ;

	return true;

}


stock DisplayPlayersInRange(playerid, Float:range)//returns the number of results found, 0 if no results
{
    const PID = 0;
	const DIST = 1;
    new
        msg[110],
		Float:PlayerDist[MAX_PLAYERS][2],
		count = 0;
	format(msg, sizeof(msg), "Players Found Within Range of %.1f:", range);
    SendClientMessage(playerid, 0xFFFFFFFF, msg);
    foreach(new pid: Player)
    {
        if (IsPlayerConnected(pid))
        {
            new
				Float:x, Float:y, Float:z, Float:dist;
			GetPlayerPos(pid, x, y, z);
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if (dist <= range)
			{
				if (GetPlayerAdminLevel(playerid) <= ADMIN_LVL_SENIOR)
				{
					if (GetPlayerAdminLevel(pid) > ADMIN_LVL_SENIOR && GetPlayerState(pid) == PLAYER_STATE_SPECTATING) continue;
				}

			    PlayerDist[count][PID] = pid;
			    PlayerDist[count][DIST] = dist;
			    count++;
			}
		}
    }
    quickSort(PlayerDist, 0, count-1);
    for_loop (new i = 0; i < count; i++)
    {
        new name[MAX_PLAYER_NAME+1];
		GetPlayerName(floatround(PlayerDist[i][PID], floatround_ceil), name, sizeof(name));
	    format(msg, sizeof(msg), "[ID %.0f] [%s] [DIST %.1f]", PlayerDist[i][PID], name, PlayerDist[i][DIST]);
	    SendClientMessage(playerid, 0xFFFFFFFF, msg);
    }
    return count;
}

stock quickSort(Float:array[][], left, right)//sorts a 2D array, sorts by arr[X][1] NOT arr[X][0]
{
    new
        tempLeft = left,
        tempRight = right,
        Float:pivot = array[(left + right) / 2][1],
        Float:tempVar1, Float:tempVar2;
    while_loop(tempLeft <= tempRight)
    {
        while_loop(array[tempLeft][1] < pivot) tempLeft++;
        while_loop(array[tempRight][1] > pivot) tempRight--;

        if(tempLeft <= tempRight)
        {
            tempVar1 = array[tempLeft][0];
            tempVar2 = array[tempLeft][1];
			array[tempLeft][0] = array[tempRight][0];
			array[tempLeft][1] = array[tempRight][1];
		 	array[tempRight][0] = tempVar1;
		 	array[tempRight][1] = tempVar2;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) quickSort(array, left, tempRight);
    if(tempLeft < right) quickSort(array, tempLeft, right);
}

CMD:reyo(playerid)
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	SOLS_SetPosWithFade(playerid, 1480.8456, -1800.8101, 156.7500, "Reyo Overview");
	SetPlayerFacingAngle(playerid, 0.0);
	AddLogEntry(playerid, LOG_TYPE_ADMIN, "Teleported to Reyo chill spot");

	return true;
}

CMD:ryhes(playerid, params[]) {

	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new index ;

	sscanf ( params, "I(0)", index ) ;

	switch( index ) {
		case 1: {

			SOLS_SetPosWithFade(playerid, 1645.9507,-1645.1332,87.3750, "Ryhes Overview 1");
			SetPlayerFacingAngle(playerid, 133.5789);
		}

		case 2:{

			SOLS_SetPosWithFade(playerid, 1646.3711,-1629.0222,87.375, "Ryhes Overview 2");
			SetPlayerFacingAngle(playerid, 47.2594);
		}

		case 3:{

			SOLS_SetPosWithFade(playerid, 1662.5876,-1628.6708,87.3321, "Ryhes Overview 3");
			SetPlayerFacingAngle(playerid, 315.138);
		}

		default: {

			SOLS_SetPosWithFade(playerid, 1662.5555,-1644.9266,87.3750, "Ryhes Overview");
			SetPlayerFacingAngle(playerid, 225.6998);
		}
	}

	AddLogEntry(playerid, LOG_TYPE_ADMIN, "Teleported to Ryhes chill spot");

	return true ;
}

CMD:rules(playerid) {


	SendClientMessage(playerid, COLOR_SERVER, "[Frequently Misused Rules]");
	SendClientMessage(playerid, COLOR_YELLOW, "For a list of all rules, visit \"http://gta-chronicles.com/rules\"." ) ;

/*
	SendClientMessage(playerid, COLOR_SERVER, "[Frequently Misused Rules]");

	SendClientMessage(playerid, COLOR_BLUE, "This is a fraction of commonly misused rules. For a full list visit {FFD600}\"shorturl.at/bdlsC\"");
	SendClientMessage(playerid, COLOR_GRAD1, "You {F14824}CAN NOT{DEDEDE} use spray-cans or firearms (inc. katanas/chainsaws) in brawls. Car ramming is also {F14824}NOT ALLOWED.") ;
	SendClientMessage(playerid, COLOR_GRAD0, "After dying you {F14824}CAN NOT{DEDEDE} go back to your death location for 30 minutes and forget EVERYTHING leading up to the killing.") ;
	SendClientMessage(playerid, COLOR_GRAD1, "Bunnyhopping is {F14824}discouraged{DEDEDE}. Bunnyhopping during a chase or RP scene is {F14824}NOT allowed");
	SendClientMessage(playerid, COLOR_GRAD0, "You are {F14824}NOT allowed{DEDEDE} to abuse/exploit/glitch animations AND /stopanim to get ANY advantage in ANY situation!");
	*/
	return true ;
}



CMD:pricelist(playerid) {

	SendClientMessage(playerid, COLOR_SERVER, "[Prices of all player-ownable entities]");
	SendClientMessage(playerid, COLOR_YELLOW, "For a list of all prices, visit \"http://gta-chronicles.com/pricelist\"." ) ;

/*
	SendClientMessage(playerid, COLOR_SERVER, "[Prices of all player-ownable entities]");
	SendClientMessage(playerid, COLOR_YELLOW, "Note that placements are /FINAL/. We do not move entities once placed down PERIOD. Be 100 percent sure before buying one!" ) ;
	SendClientMessage(playerid, 0xD74011FF, "NOTE{DEDEDE} We will also NOT remove your existing placement and create a new one elsewhere. They only get removed when there's a bug" ) ;

	SendClientMessage(playerid, COLOR_BLUE, "Basketball Hoop:{DEDEDE} $35.000 {D74011}[can NOT be moved - placements are /FINAL/.]") ; 
	SendClientMessage(playerid, COLOR_BLUE, "Pool Table:{DEDEDE} $50.000 {D74011}[free custom colour included]") ;
	SendClientMessage(playerid, COLOR_BLUE, "Pool Table Move:{DEDEDE} $7.500 {D74011}[Can only move/rotate short distances]") ;
	SendClientMessage(playerid, COLOR_BLUE, "Poker Table:{DEDEDE} $45.000 {D74011}[can NOT be moved - placements are /FINAL/.]") ;
	SendClientMessage(playerid, COLOR_BLUE, "Custom door (/gate):{DEDEDE} $25.000 {D74011}[can be assigned to PUBLIC, CHARACTER, PROPERTY and FACTION]") ;

	SendClientMessage(playerid, COLOR_BLUE, "Property Interior Change:{DEDEDE} $15.000") ;
	SendClientMessage(playerid, COLOR_BLUE, "Property Exterior Move:{DEDEDE} $10.000") ;


	SendClientMessage(playerid, COLOR_BLUE, "Passpoint [includes name / color] (/pass point A to point B):{DEDEDE} $10.000") ;
	SendClientMessage(playerid, COLOR_BLUE, "Passpoint Type Change (player/vehicle):{DEDEDE} $5.000") ;
	SendClientMessage(playerid, COLOR_BLUE, "Passpoint Faction Change (faction restricted):{DEDEDE} $5.000") ;
	SendClientMessage(playerid, COLOR_BLUE, "Passpoint Name / Color Change:{DEDEDE} $5.000") ;
	SendClientMessage(playerid, COLOR_BLUE, "Passpoint Move (ext/int):{DEDEDE} $5.000") ;

*/
	return true ;
}


CMD:resetemail(playerid, params[]){

	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/resetemail [id] - forces player to change their email.") ;
	}

	if (!IsPlayerConnected(target))
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This ID isn't connected.") ;

	SendServerMessage( playerid, COLOR_SECURITY, "Security", "A3A3A3",  sprintf("You have forced (%d) %s to change their email.", target, SOLS_PlayerName(target))) ;
	SendServerMessage( target, COLOR_SECURITY, "Security", "A3A3A3",  sprintf("%s (%d) has forced you to change your email. Please make sure it's correct before submitting.", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid)) ;

	SendHelperCmdWarn(playerid, sprintf("forced (%d) %s to change their e-mail address", target, ReturnPlayerNameData(target)));
	GetPlayerEmail(target);

	return true;
}


Admin_CountReports(playerid, reporter, report[]) {

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO report_activity (admin_id, reporter_id, report) VALUES (%d, %d, '%e')", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], Account [ reporter ] [ E_PLAYER_ACCOUNT_ID ], report) ;

	mysql_tquery(mysql, query);

}