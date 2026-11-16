enum { // Cross script!

	E_FACTION_EXTRA_NONE,
	E_FACTION_EXTRA_GUNS,
	E_FACTION_EXTRA_DRUGS_WEED,
	E_FACTION_EXTRA_DRUGS_CRACK,
	E_FACTION_EXTRA_DRUGS_COKE,
	E_FACTION_EXTRA_DRUGS_METH
}

#include "faction/data.pwn"
#include "faction/func.pwn"
#include "faction/squads.pwn"
#include "faction/admin.pwn"
#include "faction/member.pwn"
#include "faction/player.pwn"
#include "faction/spawn.pwn"
#include "faction/communication.pwn"

#include "faction/bank/header.pwn"
//#include "faction/kiosk/header.pwn"
#include "faction/armory.pwn"
#include "faction/skins/header.pwn"

// https://i.imgur.com/37peJ77.png
// https://imgur.com/a/B5UvTyo?fbclid=IwAR1rSO8Gu7HdGmLczirxDHx9gjldtHFvHJrnU0S8zdgEjf85jGVC9UtBJCY
// https://i.imgur.com/Z6ihs2Z.png

// func IsFactionTypeVehicle
IsFactionTypeVehicle(vehicleid, factiontype)
{
	if ( vehicleid == INVALID_VEHICLE_ID || !vehicleid ) 
	{
		return false;
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if ( veh_enum_id == -1 ) 
	{
		return false;
	}

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_FACTION )
	{
		for_loop ( new i, j = sizeof ( Faction ); i < j ; i ++ ) 
		{
			if ( Faction [ i ] [ E_FACTION_ID ] == Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] && Faction [ i ] [ E_FACTION_TYPE ] == factiontype ) 
			{
				return true;
			}
		}
	}

	return false;
}

bool:IsFactionVehicle(vehicleid, factionid)
{
	if ( vehicleid == INVALID_VEHICLE_ID || !vehicleid ) 
	{
		return false;
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if ( veh_enum_id == -1 ) 
	{
		return false;
	}

	return Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_FACTION && Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] == factionid;
}

bool:IsGovFactionVehicle(vehicleid)
{
	new factiontype = GetVehicleFactionType(vehicleid);
	return factiontype == FACTION_TYPE_POLICE || factiontype == FACTION_TYPE_EMS || factiontype == FACTION_TYPE_DEA || factiontype == FACTION_TYPE_GOV;
}

// func GetVehicleFactionType
GetVehicleFactionType(vehicleid)
{
	if ( vehicleid == INVALID_VEHICLE_ID || !vehicleid ) 
	{
		return -1;
	}

	new veh_enum_id = Vehicle_GetEnumID ( vehicleid );

	if ( veh_enum_id == -1 ) 
	{
		return -1;
	}

	if ( Vehicle [ veh_enum_id ] [ E_VEHICLE_TYPE ] == E_VEHICLE_TYPE_FACTION )
	{
		for_loop ( new i, j = sizeof ( Faction ); i < j ; i ++ ) 
		{
			if ( Faction [ i ] [ E_FACTION_ID ] == Vehicle [ veh_enum_id ] [ E_VEHICLE_OWNER ] ) 
			{
				return Faction [ i ] [ E_FACTION_TYPE ];
			}
		}
	}

	return -1;
}

GetPlayerFactionType(playerid)
{
	if ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) 
	{
		new faction_enum_id = Faction_GetEnumID ( Character [ playerid ] [ E_CHARACTER_FACTIONID ] ) ;
		return Faction_GetType(faction_enum_id );
	}

	return -1;       
}

GetPlayerFactionSuspension(playerid)
{
	new suspended = 0;

	if (Character[playerid][E_CHARACTER_FACTIONID] && Character[playerid][E_CHARACTER_FACTION_SUSPENSION] && Character[playerid][E_CHARACTER_FACTION_SUSPENSION] > gettime())
	{
		suspended = Character[playerid][E_CHARACTER_FACTION_SUSPENSION] - gettime();
	}

	return suspended;
}

IsPlayerInFaction(playerid, factionid, bool:onduty=false)
{
	new faction = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	return faction == factionid && (!onduty || PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ]);
}

IsPlayerInFactionType(playerid, factiontype, bool:onduty=false) 
{
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return false ;
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return false ;
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == factiontype && (!onduty || PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ])) {

		return true ;
	}

	return false ;
}

IsPlayerInDutyFaction(playerid) 
{
	return IsPlayerInPoliceFaction(playerid) || IsPlayerInMedicFaction(playerid) || IsPlayerInNewsFaction(playerid) || IsPlayerInDEAFaction(playerid) || IsPlayerInSecurityFaction(playerid) || IsPlayerInGovFaction(playerid) || IsPlayerInTaxiFaction(playerid);
}

IsPlayerInMedicFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_EMS, onduty);
}

IsPlayerInDEAFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_DEA, onduty);
}

IsPlayerInAPFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFaction(playerid, 17, onduty);
}

IsPlayerInSecurityFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_SECURITY, onduty);
}

IsPlayerInTruckerFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_TRUCKER, onduty);
}

IsPlayerInTaxiFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_TAXI, onduty);
}

IsPlayerInGovFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_GOV, onduty);
}

IsPlayerInAnyGovFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInPoliceFaction(playerid, onduty) || IsPlayerInMedicFaction(playerid, onduty) || IsPlayerInDEAFaction(playerid, onduty) || IsPlayerInGovFaction(playerid, onduty);
}

// TODO: Move these to gov
IsPlayerGovJudge(playerid, bool:onduty=false)
{
	return IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_COURT, FACTION_TYPE_GOV, onduty);
}

IsPlayerGovAdmin(playerid, bool:onduty=false)
{
	return IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_ADMIN, FACTION_TYPE_GOV, onduty);
}

IsPlayerGovCop(playerid, bool:onduty=false)
{
	return IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_DAO, FACTION_TYPE_GOV, onduty);
}

IsPlayerGovTraffic(playerid, bool:onduty=false)
{
	return IsPlayerInFactionSquad(playerid, FACTION_SQUAD_GOV_TRAFFIC, FACTION_TYPE_GOV, onduty);
}

IsPlayerGovRecords(playerid, bool:onduty=false)
{
	return IsPlayerGovJudge(playerid, onduty) || IsPlayerGovCop(playerid, onduty) || IsPlayerGovAdmin(playerid, onduty);
}

IsPlayerInTicketFaction(playerid, bool:onduty=false)
{
	return IsPlayerInPoliceFaction(playerid, onduty) || IsPlayerGovTraffic(playerid, onduty);
}

//--
CMD:leavefaction(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id != INVALID_FACTION_ID ) 
	{
		Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s has left the faction. }",

			Faction [ faction_enum_id ] [ E_FACTION_ABBREV ], playerid, ReturnPlayerNameData ( playerid )
		), faction_enum_id, false, false, 0, true ) ;
	}

	// Disarm them as a precaution
	if (IsPlayerInDutyFaction(playerid))
	{
		Weapon_ResetPlayerWeapons(playerid);
	}

	Character [ playerid ] [ E_CHARACTER_FACTIONID ] = 0 ;
	Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] = 3 ;
	Character [ playerid ] [ E_CHARACTER_FACTION_SUSPENSION ] = 0 ;
	Character [ playerid ] [ E_CHARACTER_FACTIONRANK ] [ 0 ] = EOS ;
	strcat(Character [ playerid ] [ E_CHARACTER_FACTIONRANK ], "None" ) ;
	Character [ playerid ] [ E_CHARACTER_FACTION_SQUAD ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_FACTION_DUTY ] = false;
	PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL] = -1;

	new query [ 512 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_factionid = 0, player_factiontier = 3, player_factionrank = 'None', player_factionsuspension = 0, player_factionsquad = 0 WHERE player_id = %d", Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	SendClientMessage(playerid, 0xA3A3A3FF, "You've left your faction.");
	return true ;
}

/*
CMD:fhelp(playerid, params[]) {

	return cmd_factionhelp(playerid, params);
}
CMD:factionhelp(playerid, params[]) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}


	SendClientMessage(playerid, COLOR_SERVER, "[List of faction commands]");
	SendClientMessage(playerid, COLOR_GRAD0, "/kioskhelp, /f(action), /(un)invite, /settier, /setrank, /f(action)on");
	SendClientMessage(playerid, COLOR_GRAD1, "/nofac, /ftow, /fvehicles (/fcars, /fveh, /fvehs), /fpark, /fskins, /fspawn");
	SendClientMessage(playerid, COLOR_GRAD0, "/fspawnicon, /fspawntog, /(faction)fhex, /nofac, /fcarcolor, /factionbank");
	SendClientMessage(playerid, COLOR_YELLOW, "[NEW]{DEDEDE} /p(a)g(er), /leavefaction, /chopshopcollect, /suspend");

	// Is player police
	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == 0 ) {

		SendClientMessage(playerid, COLOR_BLUE, "[Police Commands]");
		SendClientMessage(playerid, COLOR_GRAD0, "/duty, /kev, /armory, /radio, /dep, /channel, /hq, /m");
		SendClientMessage(playerid, COLOR_GRAD1, "/(un)cuff, /tazer, /beanbag, /tackle, /carcheck, /searchplate, /searchdata");
		SendClientMessage(playerid, COLOR_GRAD0, "/takelicense, /frisk, /disarm, /confiscate, /breakincar, /tolls, /arrest");
		SendClientMessage(playerid, COLOR_GRAD1, "/charge, /viewcrimes, /writeticket, /giveticket, /viewtickets, /driverwarn");
		SendClientMessage(playerid, COLOR_GRAD0, "/prisoners, /viewairspace, /atc, /setsquad, /setbadge, /showbadge, /lastalarm");
		SendClientMessage(playerid, COLOR_GRAD1, "/p(anic)b(utton), /b(ac)k(up), /cancelpanic, /cancelbk, /cad, /units, /swat, /spikes");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == 3 ) {

		SendClientMessage(playerid, COLOR_BLUE, "[Fire/EMS Commands]");
		SendClientMessage(playerid, COLOR_GRAD0, "/duty, /radio, /dep, /hq, /armory, /setbadge, /showbadge");
		SendClientMessage(playerid, COLOR_GRAD1, "/m, /atc, /helpup, /heal, /lastalarm, /panic");

	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_NEWS ) {

		SendClientMessage(playerid, COLOR_BLUE, "[News Commands]");
		SendClientMessage(playerid, COLOR_GRAD0, "/pager, /atc, /showbadge, /breaking, /broadcast, /newsadvert, /live");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_DEA ) {

		SendClientMessage(playerid, COLOR_BLUE, "[DEA/FBI Commands]");
		SendClientMessage(playerid, COLOR_GRAD0, "/duty, /kev, /armory, /radio, /hq, /(un)cuff, /tackle, /tazer, /searchplate, /searchdata");
		SendClientMessage(playerid, COLOR_GRAD1, "/carcheck, /frisk, /disarm, /confiscate, /detain, /breakincar, /viewcrimes, /viewtickets");
		SendClientMessage(playerid, COLOR_GRAD0, "/charge, /arrest, /viewairspace, /atc, /setbadge, /showbadge, /scanner");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_SECURITY ) {

		SendClientMessage(playerid, COLOR_BLUE, "[Security Commands]");
		SendClientMessage(playerid, COLOR_GRAD0, "/duty, /armory, /radio, /hq, /(un)cuff, /tazer, /frisk, /detain, /carcheck, /showbadge");
	}


	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] > ADMIN_LVL_NONE ) {

		SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN]{dedede} /afjoin, /f(action)name, /f(action)create, /fskinadd, /fhex");
	}
	
	return true ;
}*/


ShowFactionCommands(playerid) {

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new  faction_enum_id = Faction_GetEnumID(factionid);

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	SendClientMessage(playerid, 0x5FB9D1FF, "[ ___________ Faction Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]:{B2FFCD} /f(chat), /nofaction, /fcars, /fskins, /fonline, /foffline, /factivity, /leavefaction");

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] <= 1)
	{
		SendClientMessage(playerid, 0x58DD85FF, "[TIER 1]:{B2FFCD} /fbank (coming soon), /fspawn, /fspawnicon, /fspawntog, /ouninvite, /osettier");
	}

	if (Character [ playerid ] [ E_CHARACTER_FACTIONTIER ] <= 2)
	{
		SendClientMessage(playerid, 0x58DD85FF, "[TIER 2]:{B2FFCD} /fl(chat), /invite, /suspend, /uninvite, /(o)setrank, /(o)setsquad");
		SendClientMessage(playerid, 0x58DD85FF, "[TIER 2]:{B2FFCD} /togfchat, /setbadge, /ftow, /fpark, /fcarcolor");
	}

	// Is player police
	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == 0 ) 
	{
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/duty, /kev, /armory, /radio, /dep, /channel, /hq, /m, /fcall");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/(un)cuff, /tazer, /beanbag, /tackle, /carcheck, /searchplate, /searchdata");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/takelicense, /frisk, /disarm, /confiscate, /breakincar, /tolls, /arrest");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/charge, /viewcrimes, /writeticket, /giveticket, /viewtickets, /driverwarn");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/prisoners, /viewairspace, /atc, /showbadge, /lastalarm, /gunrack");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/p(anic)b(utton), /b(ac)k(up), /cancelpanic, /cancelbk, /cad, /units");
		SendClientMessage(playerid, 0x77BBFAFF, "[POLICE]: {BBDEFF}/swat, /spikes, /acc(eptcall), /a(ccept)l(ast)c(all)");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_GOV ) 
	{
		SendClientMessage(playerid, 0x7a8ea1FF, "[GOV]: {BBDEFF}/duty, /radio, /dep, /hq, /armory, /showbadge");

		if (IsPlayerGovCop(playerid))
		{
			SendClientMessage(playerid, 0x7a8ea1FF, "[GOV Investigator]: {BBDEFF}/kevlar, /(un)cuff, /tackle, /charge");
		}

		if (IsPlayerGovAdmin(playerid))
		{
			SendClientMessage(playerid, 0x7a8ea1FF, "[GOV Admin]: {BBDEFF}/issuelicense, /takelicense");
		}

		if (IsPlayerGovTraffic(playerid))
		{
			SendClientMessage(playerid, 0x7a8ea1FF, "[GOV Traffic]: {BBDEFF}/writeticket, /giveticket, /impound, /tow, /viewtickets, /searchplate");
		}

		if (IsPlayerGovRecords(playerid))
		{
			SendClientMessage(playerid, 0x7a8ea1FF, "[GOV Records]: {BBDEFF}/searchdata, /searchplate, /viewcrimes, /viewtickets");
		}

	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_EMS ) {

		SendClientMessage(playerid, 0xF87070FF, "[FD]: {FDBCBC}/duty, /radio, /dep, /hq, /armory, /showbadge, /fcall");
		SendClientMessage(playerid, 0xF87070FF, "[FD]: {FDBCBC}/cad, /m, /atc, /revive, /heal, /firehose, /lastalarm, /panic");
		SendClientMessage(playerid, 0xF87070FF, "[FD]: {FDBCBC}/acc(eptcall), /a(ccept)l(ast)c(all)");

		if (IsPlayerInFactionSquad(playerid, FACTION_SQUAD_ARSON, FACTION_TYPE_EMS))
		{
			SendClientMessage(playerid, 0xF87070FF, "[FD Arson]: {FDBCBC}/kevlar, /(un)cuff, /tackle, /charge, /searchdata");
		}
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_NEWS ) {

		SendClientMessage(playerid, 0xFFCC68FF, "[NEWS]: {FFE1A8}/pager, /atc, /showbadge, /breaking, /broadcast, /newsadvert, /live");
		SendClientMessage(playerid, 0xFFCC68FF, "[NEWS]: {FFE1A8}/fcall, /scanner, /911s");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_DEA ) {

		SendClientMessage(playerid, 0x77BBFAFF, "[FED]: {BBDEFF}/duty, /kev, /armory, /radio, /hq, /(un)cuff, /tackle, /tazer, /searchplate, /searchdata");
		SendClientMessage(playerid, 0x77BBFAFF, "[FED]: {BBDEFF}/carcheck, /frisk, /disarm, /confiscate, /detain, /breakincar, /viewcrimes, /viewtickets");
		SendClientMessage(playerid, 0x77BBFAFF, "[FED]: {BBDEFF}/charge, /arrest, /viewairspace, /atc, /showbadge, /scanner, /911s");
		SendClientMessage(playerid, 0x77BBFAFF, "[FED]: {BBDEFF}/panicbutton (/pb), /backup (/bk), /cancelpanic (/pbc), /cancelbk (/bkc)");
		
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_SECURITY ) {
		SendClientMessage(playerid, 0x58DD85FF, "[SECURITY]: {B2FFCD}/duty, /armory, /radio, /hq, /(un)cuff, /tazer, /frisk, /detain, /carcheck, /showbadge");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] == FACTION_TYPE_TAXI ) {
		SendClientMessage(playerid, 0x58DD85FF, "[TAXI]: {B2FFCD}/duty, /radio, /hq, /fcall, /taxiad, /acceptcall");
	}
	
	return true ;
}