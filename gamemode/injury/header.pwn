

#define INJURY_CRITICAL_DMG_HEAD 	33
#define INJURY_CRITICAL_DMG_TORSO 	66

enum {

	BODY_PART_TORSO = 3,
	BODY_PART_GROIN = 4,
	BODY_PART_LEFT_ARM = 5,
	BODY_PART_RIGHT_ARM = 6,
	BODY_PART_LEFT_LEG = 7,
	BODY_PART_RIGHT_LEG = 8,
	BODY_PART_HEAD = 9
} ;

#define MAX_BODY_PARTS  ( 2 ) // start at 3, end at 9

enum {
	DAMAGE_LEGS = 0,
	DAMAGE_ARMS,
}

new bool: PlayerDamage [ MAX_PLAYERS ] [ MAX_BODY_PARTS ] ;

#define WEAPON_UNARMED 0

#include "injury/health.pwn"
#include "injury/utils.pwn"
#include "injury/list.pwn"
#include "injury/injury.pwn"
#include "injury/func.pwn"
//#include "injury/trail.pwn"
#include "injury/stumble.pwn"
#include "injury/knife.pwn"

#if !defined INVALID_HOSPITAL_ID
	#define INVALID_HOSPITAL_ID	( -1 )
#endif

#if !defined SURGERY_FEE
	#define SURGERY_FEE ( 50 )
#endif

#if !defined BANDAGE_FEE
	#define BANDAGE_FEE	( 15 )
#endif

public OnPlayerDeath(playerid, killerid, reason) {


	//RemovePlayerFromGym(playerid, GetPlayerGymID(playerid), 2);
	Minigame_ResetVariables(playerid);
	PlayerVar [ playerid ] [ E_PLAYER_ONPLAYERDEATH ] = true ;

	new Float: x, Float: y, Float: z, Float: a ;
	GetPlayerPos(playerid, x, y, z );
	GetPlayerFacingAngle(playerid, a);

	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_X ] = x ;
	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Y ] = y ;
	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Z ] = z ;
	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_A ] = a ;
	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_INT ] = GetPlayerInterior(playerid);
	PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_VW ] = GetPlayerVirtualWorld(playerid) ;

	new idx, temp_gun, ammo ;

	for_loop ( new i, j = MAX_WEAPON_SLOTS; i < j ; i ++ ) {
		idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

		GetPlayerWeaponData(playerid, i, temp_gun, ammo) ;

		if ( Weapon [ idx ] [ E_WEAPON_GUNID ] == temp_gun ) {

			PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] = ammo ;
			if ( idx != 0 ) {
				printf("[CLIENT DEATH] Found weapon ID %d (server %d) on player %d with %d ammo. Storing!", idx, temp_gun, playerid, ammo ) ;
			}
		}

	}

	return true ;
}


public OnPlayerSpawn(playerid) {

	SetPlayerTeam(playerid, 1);

	// Re attach toys on respawn
	for ( new x = 0; x < MAX_PLAYER_ATTACHMENTS; x ++ ) 
	{
		if ( PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_VISIBLE ] [ x ] ) 
		{
			SOLS_SetPlayerAttachedObject(playerid, PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_INDEX ] [ x ], PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_MODEL ] [ x ], PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_BONE ] [ x ], 
				PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_OFFSET_X ] [ x ], PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_OFFSET_Y ] [ x ], PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_OFFSET_Z ] [ x ] ,
				PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_ROT_X ] [ x ] , PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_ROT_Y ] [ x ] , PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_ROT_Z ] [ x ],	
				PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_SCALE_X ] [ x ] , PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_SCALE_Y ] [ x ] , PlayerAttachments [ playerid ] [ E_PLAYER_ATTACH_SCALE_Z ] [ x ], 
				.save = false
			);
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_ONPLAYERDEATH ] ) {

		if ( PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_X ] == 0.0 ||
			PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Y ] == 0.0 ||
			PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Z ] == 0.0
		) {

			SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  "You've died clientwise due to an explosion, an undeclared weapon id or falling damage." );
			SendClientMessage(playerid, 0xA3A3A3FF, "We tried to respawn you to your last location but something went wrong. Porting you to the hospital..." ) ;


			PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] = 0 ;
			Injury_OnPlayerDeath(playerid) ;
		}

		else {

			SetPlayerPos(playerid, PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_X ], 
				PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Y ], PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Z ] 
			) ;

			SetPlayerFacingAngle (playerid, PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_A ] ) ;

			SetPlayerInterior ( playerid, PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_INT ] );
			SetPlayerVirtualWorld ( playerid, PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_VW ] ); 

			SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  "You've died clientwise due to an explosion, an undeclared weapon id or falling damage." );
			SendClientMessage(playerid, 0xA3A3A3FF, "You will be respawned momentarily. Your weapons will be restored." ) ;

			// They died clientwise - let's refund their shit.
			new idx  ;

			for_loop ( new i, j = MAX_WEAPON_SLOTS; i < j ; i ++ ) {
				idx = PlayerVar [ playerid ] [ E_PLAYER_WEAPON_EQUIPPED ][ i ] ;

				if ( idx != -1 && idx != 0 ) {

					GivePlayerWeapon(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] ) ;
					SOLS_SetPlayerAmmo(playerid, Weapon [ idx ] [ E_WEAPON_GUNID ], PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] ) ; // hard setting ammo
				}

				PlayerVar [ playerid ] [ E_PLAYER_AMMO_TEMP ] [ i ] = 0 ;
			}

		}

		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_X ] = 0.0 ;
		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Y ] = 0.0 ;
		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_Z ] = 0.0 ;

		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_POS_A ]  = 0.0 ;

		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_INT ] = 0;
		PlayerVar [ playerid ] [ E_PLAYER_CLIENT_DEATH_VW ] = 0 ;
	}	

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] ) {

		PlayerVar [ playerid ] [ E_PLAYER_ONPLAYERDEATH ] = false ;
	}

	#if defined injury_OnPlayerSpawn
		return injury_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn injury_OnPlayerSpawn
#if defined injury_OnPlayerSpawn
	forward injury_OnPlayerSpawn(playerid);
#endif

Injury_ApplyAnim (playerid, animlib[32], animname[32], anim_loop = 0, respawn_time = -1, bool:freeze_sync = true, anim_freeze = 1) {

	#pragma unused anim_loop, respawn_time, freeze_sync, anim_freeze

	ApplyAnimation(playerid, animlib, animname, 4.1, 0, anim_loop, true, anim_freeze, 0, 1);

	defer Injury_ReAppendAnim(playerid, animlib, sizeof(animlib), animname, sizeof(animname), anim_loop, anim_freeze ) ;

	return true ;
}

timer Injury_ReAppendAnim[1500](playerid, animlib[], animlib_len, animname[], animname_len, anim_loop, anim_freeze) {
	#pragma unused animlib_len, animname_len

	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] ) {

		ApplyAnimation(playerid, animlib, animname, 4.1, anim_loop, true, true, anim_freeze, 0, 1);
	}

	return true ;
}
/*
CMD:bandage(playerid, params[]) {

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/bandage [target]" ) ;
	}

	if ( ! PlayerVar [ playerid ] [ E_PLAYER_HAS_BANDAGE ] ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  " You don't own a bandage. Buy one at the hospital (red cross on map)." );
	}

	if ( Character [ target ] [ E_CHARACTER_BANDAGE_COOLDOWN ] > 0 ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("Your target is on a cooldown! They can get bandaged in %d seconds.", Character [ target ] [ E_CHARACTER_BANDAGE_COOLDOWN ] ) );
	}

	if ( Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] > 0 ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("You've bandaged too many people! You can bandage again in %d seconds.", Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] ) );
	}

	Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] = 900 ; // 15 seconds
	Character [ target ] [ E_CHARACTER_BANDAGE_COOLDOWN ] = 900 ; // 15 seconds

	//CancelBloodPuddle ( target ) ;

	new query [ 128 ] ;

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_bandage_cd = %d WHERE player_id = %d",
		Character [ target ] [ E_CHARACTER_BANDAGE_COOLDOWN ], Character [ target ] [ E_CHARACTER_ID ] );

	mysql_tquery(mysql, query);

	mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_last_bandage_cd = %d WHERE player_id = %d",
		Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ], Character [ playerid ] [ E_CHARACTER_ID ] );

	mysql_tquery(mysql, query);

	if ( playerid != target ) {

		ProxDetector ( playerid, 15.0, COLOR_ACTION, sprintf("* %s applies a bandage to %s's wounds.", ReturnPlayerNameData ( playerid ), ReturnPlayerNameData ( target ) ) );
	}

	else ProxDetector ( playerid, 15.0, COLOR_ACTION, sprintf("* %s bandages their wounds.", ReturnPlayerNameData ( playerid ) ) );

	SendClientMessage(playerid, COLOR_GRAD1, "You've used up your bandage. You and your target are on a 15 minute bandage cooldown." );

	return true ;
}

CMD:buybandage(playerid) {

	if ( ! IsPlayerNearHospital(playerid) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You're not at the right place! Head to either the ASGH or CGH! (red cross on map)" );
	}

	if ( GetPlayerCash ( playerid ) < BANDAGE_FEE ) {

		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("You need at least $%s in order to buy a bandage.", BANDAGE_FEE ));
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_HAS_BANDAGE ] ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You already have a bandage. Use it first by using /bandage." );
	}

	TakePlayerCash ( playerid, BANDAGE_FEE ) ;
	PlayerVar [ playerid ] [ E_PLAYER_HAS_BANDAGE ] = true ;

 	SendServerMessage( playerid, COLOR_RED, "Hospital", "A3A3A3",  "You've bought a bandage. Use it with /bandage. You can only bandage someone every fifteen minutes." );
 	return true ;
}*/


CMD:surgery(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    
	new property_id = IsPlayerNearSpecificBuyPoint(playerid, E_BUY_TYPE_HOSPITAL) ;


	if ( property_id == INVALID_PROPERTY_ID ) {

    	return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You're not at the right place! Head to either the ASGH or CGH! (red cross on map)" );
    }

	PlayerVar [ playerid ] [ E_PLAYER_BIZ_MENU ] = property_id ;

	if ( GetPlayerCash ( playerid ) < SURGERY_FEE ) {

		SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("You need at least $%s in order to use this service.", IntegerWithDelimiter(SURGERY_FEE) ));
		return true ;
	}

	new need = 0 ;

	if ( PlayerDamage [ playerid ] [ DAMAGE_ARMS ] ) need += 500 ;
	if ( PlayerDamage [ playerid ] [ DAMAGE_LEGS ] ) need += 500 ;

	if ( GetPlayerCash ( playerid ) < need ) {

		SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("You need at least $%s in order to use this service.", IntegerWithDelimiter(need) ));
		return true ;
	}

	new fee, bool: arms_pass, bool:legs_pass, string [ 256 ] ;

	format ( string, sizeof ( string  ), "You're being charged for" ) ;

	if ( PlayerDamage [ playerid ] [ DAMAGE_ARMS ] ) {

		format(string, sizeof ( string ), "%s your arm damage", string );
		fee += 500 ;
		arms_pass = true ;
		PlayerDamage [ playerid ] [ DAMAGE_ARMS ] = false ;
	}

 	if ( PlayerDamage [ playerid ] [ DAMAGE_LEGS ] ) {

		if ( arms_pass ) {
			format(string, sizeof ( string ), "%s, and your leg damage", string );
		}
		else format(string, sizeof ( string ), "%s your leg damage", string );

		legs_pass=true ;
 		fee += 500 ;
 		PlayerDamage [ playerid ] [ DAMAGE_LEGS ] = false ;
 	}

 	if (! arms_pass && ! legs_pass ) {

		format(string, sizeof ( string ), "%s absolutely nothing", string );
		fee = 0 ;
 	}

	format(string, sizeof ( string ), "%s. Total cost: $%s. To heal, visit a restaurant.", string, IntegerWithDelimiter(fee) );
	SendClientMessage(playerid, COLOR_GRAD0, string);

	TakePlayerCash ( playerid, fee ) ;
	new price = fee * 50 ; // i.e. 15 * 50 = 750
	Property_AddMoneyToTill(playerid, price, .margin=false ) ; 

	return true ;
}

CMD:helpup(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
   

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

	    return  SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/helpup [playerid/part of name]" );
	}

	if ( ! IsPlayerConnected(target ) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Connection", "A3A3A3",  "Your target isn't connected." );
	}

	if ( !IsPlayerNearPlayer(playerid, target, 4.0 ) ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You're not near your target." );
	}

	if ( !PlayerVar [ target ] [ E_PLAYER_INJUREDMODE ] ) {

	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Target isn't in injury mode!" );
	}

	if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInMedicFaction(playerid, true) && Character [ target ] [ E_CHARACTER_HELPUP_CD ])
	{
		// New cops/medics can always help up as long as they are on duty (we assume they rp it properly with their medical training/kits)
		new	cooldown = 3600 - (gettime() - Character [ target ] [ E_CHARACTER_HELPUP_CD ]);
		if (cooldown > 0)
		{
			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("Your target is on a /helpup cooldown for %d more seconds.", cooldown) );
		}
	}

	if (PlayerVar [ target ] [ E_PLAYER_INJURY_MIN_TICK ] > 60)
	{
		SendServerMessage ( playerid, COLOR_RED, "Error", "A3A3A3", sprintf("You must wait %d seconds before this player can be helped up.", PlayerVar [ target ] [ E_PLAYER_INJURY_MIN_TICK ] - 60) ) ;
		return true;
	}

	// New smarter critical injury calcuation:
	new critical = IsPlayerCriticallyWounded(target);

	if (critical && !IsPlayerInMedicFaction(playerid, true)) 
	{
		return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "This player is critically wounded and can only be revived by paramedics." );
	}

	Injury_RemoveData_Player(target) ;

	if (critical)
	{	
		ProxDetector ( playerid,30.0, COLOR_ACTION, sprintf("** Paramedic %s revives %s from critical injury.", ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true ) ) );
		SendClientMessage(target, COLOR_RED, sprintf("You were revived from critical injury by Paramedic %s (%d).", ReturnPlayerNameData ( playerid, 0, true ), playerid ) ) ;
		SendClientMessage(playerid, COLOR_RED, sprintf("You revived %s (%d) from critical injury using your faction's medical capabilities.", ReturnPlayerNameData ( target, 0, true ), target ) ) ;
	}
	else
	{
		ProxDetector ( playerid,30.0, COLOR_ACTION, sprintf("** %s helps %s to their feet.", ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true ) ) );
		SendClientMessage(target, COLOR_RED, sprintf("You've been helped back up to your feet by %s (%d).", ReturnPlayerNameData ( playerid, 0, true ), playerid ) ) ;
		SendClientMessage(playerid, COLOR_RED, sprintf("You helped %s (%d) back up to their feet.", ReturnPlayerNameData ( target, 0, true ), target ) ) ;
	}
	
	SendClientMessage(target, COLOR_YELLOW, "Note that you are still injured and should visit a hospital to receive surgery for your wounds.") ;
	SendClientMessage(target, COLOR_YELLOW, "You must also wait 30 minutes before using weapons again or attacking other players.");

	SendClientMessage(playerid, COLOR_YELLOW, "Note that they are still injured, are not allowed to use weapons, and should be taken to a hospital.");
	SendClientMessage(playerid, COLOR_YELLOW, "They must also wait 30 minutes before using weapons again or attacking other players.");

	Character [ target ] [ E_CHARACTER_HELPUP_CD ]  = gettime();
	SetPlayerChatBubble(target, "", COLOR_YELLOW, 7.5, 900000);

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_helpup_cd = %d WHERE player_id = %d", 
		Character [ target ] [ E_CHARACTER_HELPUP_CD ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	//NEW LOGGING: Log this as a LOG_TYPE_SCRIPT for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Helped up %s (%d) from injury", ReturnPlayerNameData ( target, 0, true ), target));
	AddLogEntry(target, LOG_TYPE_SCRIPT, sprintf("Was helped up from injury by %s (%d)", ReturnPlayerNameData ( playerid, 0, true ), playerid));

	return true ;
}

CMD:revive(playerid, params[])
{
	return cmd_helpup(playerid, params);
}

CMD:heal(playerid, params[]) 
{
	if (!IsPlayerInMedicFaction(playerid, true)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You're not on duty as a firefighter/medic.") ;
	}

	new target;

	if ( sscanf ( params, "k<player>", target ) ) 
	{
	    return  SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/heal [player]" );
	}

	if ( ! IsPlayerConnected(target ) ) 
	{
	    return  SendServerMessage( playerid, COLOR_RED, "Connection", "A3A3A3",  "Your target isn't connected." );
	}

	if ( target == playerid ) 
	{
	    return  SendServerMessage( playerid, COLOR_RED, "Connection", "A3A3A3",  "You can't heal yourself." );
	}

	if ( !IsPlayerNearPlayer(playerid, target, 4.0 ) ) 
	{
	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "You're not near your target." );
	}

	if ( PlayerVar [ target ] [ E_PLAYER_INJUREDMODE ] ) 
	{
	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "This player needs to be revived first." );
	}

	if (Character [ target ] [ E_CHARACTER_HEAL_CD ])
	{
		new	cooldown = 3600 - (gettime() - Character [ target ] [ E_CHARACTER_HEAL_CD ]);
		if (cooldown > 0)
		{
			return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  sprintf("Your target is on a /heal cooldown for %d more seconds.", cooldown) );
		}
	}

	new count = 0;

	for_loop ( new i; i < MAX_WOUNDS; i ++ ) 
	{
		if ( PlayerWounds [ i ] [ dmg_player ] == target ) 
		{
			count ++;
		}
	}

	if ( !count ) 
	{
	    return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "This player has no injuries to heal." );
	}

	ProxDetector ( playerid, 30.0, COLOR_ACTION, sprintf("** Paramedic %s heals the wounds of %s.", ReturnPlayerNameData ( playerid, 0, true ), ReturnPlayerNameData ( target, 0, true ) ) );

	new cuffed = ( GetPVarInt(target, "CUFFED") == 1 ) ;

	Injury_RemoveData(target) ;
	if ( cuffed ) SOLS_SetPlayerCuffed(target, true, false);
	TogglePlayerControllable ( target, true ) ;

	SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  sprintf("You have healed the injuries of (%d) %s using your faction's medical capabilities.", target, ReturnPlayerNameData ( target, 0, true ) ) );
	SendServerMessage( target, COLOR_INJURY, "Injury", "A3A3A3",  sprintf("Your injuries have been healed by Paramedic %s (%d).", ReturnPlayerNameData ( playerid, 0, true ), playerid ) );

	SendAdminMessage ( sprintf("[AdmWarn] ** Paramedic %s (%d) healed the injuries of (%d) %s.", 
    	ReturnPlayerNameData(playerid), playerid, target, ReturnPlayerNameData ( target )));

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Healed the injuries of %s (%d)", ReturnPlayerNameData ( target, 0, true ), target));
	UpdatePlayerNamesForOthers ( playerid ) ;

	Character [ target ] [ E_CHARACTER_HEAL_CD ] = gettime();

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_heal_cd = %d WHERE player_id = %d", 
		Character [ target ] [ E_CHARACTER_HEAL_CD ], Character [ target ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery(mysql, query);

	return true ;
}

CMD:clearinjuriesradius(playerid, params[])
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_JUNIOR ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new Float:radius;

	if ( sscanf ( params, "f", radius ) ) 
	{
	    return  SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/clearinjuriesradius [radius]" );
	}

	if (radius <= 0 || radius > 250)
	{
		return  SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "Radius must be between 1 and 250" );
	}

	new vw = GetPlayerVirtualWorld(playerid);
	new int = GetPlayerInterior(playerid);
	new count = 0;

	foreach(new i : Player) 
	{
		if (!IsPlayerPlaying(i)) continue;
		if (GetPlayerVirtualWorld(i) != vw || GetPlayerInterior(i) != int) continue;

		if (IsPlayerNearPlayer(i, playerid, radius))
		{
			new cuffed = ( GetPVarInt(i, "CUFFED") == 1 ) ;

			Injury_RemoveData(i);
			if ( cuffed ) SOLS_SetPlayerCuffed(i, true, false);
			TogglePlayerControllable(i, true );
			AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Cleared the injuries of (%d) %s", i, SOLS_PlayerName(i, PLAYER_NAME_STYLE_LEGACY)));
			SendServerMessage(i, COLOR_INJURY, "Injury", "A3A3A3", sprintf("Your injuries have been cleared by (%d) %s.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT)) );

			count ++;
		}	
	}

	if (count)
	{
		SendAdminCmd(playerid, sprintf("cleared the injuries of %d players in a %.02f radius.", count, radius));
	}

	return true;
}

CMD:reviveradius(playerid, params[])
{
	return cmd_clearinjuriesradius(playerid, params);
}

CMD:clearinjuries(playerid, params[]) {

	if ( GetPlayerHelperLevel ( playerid ) < HELPER_LVL_ADVANCED ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new target ;

	if ( sscanf ( params, "k<player>", target ) ) {

	    return  SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/clearinjuries [playerid/part of name]" );
	}

	if ( ! IsPlayerConnected(target ) ) {

	    return  SendServerMessage( playerid, COLOR_RED, "Connection", "A3A3A3",  "Your target isn't connected." );
	}

	new cuffed = ( GetPVarInt(target, "CUFFED") == 1 ) ;

	Injury_RemoveData(target) ;
	if ( cuffed ) SOLS_SetPlayerCuffed(target, true, false);
	TogglePlayerControllable ( target, true ) ;

	//SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  sprintf("You have cleared the injuries of (%d) %s.", target, ReturnPlayerNameData ( target ) ) );
	//SendServerMessage( target, COLOR_INJURY, "Injury", "A3A3A3",  sprintf("Your injuries have been cleared by (%d) %s.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT)) );
	
	new query [ 128 ] ;
	format ( query, sizeof ( query ),"You've been revived/healed by %s (%d).", SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_ACCOUNT), playerid);
	SendClientMessage(target, COLOR_YELLOW, query);

	SendHelperCmdWarn(playerid, sprintf("cleared the injuries of (%d) %s", target, ReturnPlayerNameData(target)));
	
	UpdatePlayerNamesForOthers ( target ) ;

	return true ;
}
/*
Injury_BandageCooldown_Tick(playerid) { 

	new query [ 256 ] ;

	// Bandage Cooldowns
	if ( Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ] > 0 ) {
		Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ] -- ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_bandage_cd = %d WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ], Character [ playerid ] [ E_CHARACTER_ID ] 
		) ;

		mysql_tquery(mysql, query ) ;

		if ( Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ] <= 0 ) {


			Character [ playerid ] [ E_CHARACTER_BANDAGE_COOLDOWN ] = 0 ;
			SendServerMessage( playerid, COLOR_RED, "Bandage", "A3A3A3",  "Your bandage cooldown expired. You can now get bandaged again." );
		}
	}

	if ( Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] > 0 ) {
		Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] -- ;

		mysql_format(mysql, query, sizeof(query), "UPDATE characters SET player_last_bandage_cd = %d WHERE player_id = %d", 
			Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ], Character [ playerid ] [ E_CHARACTER_ID ] 
		) ;

		mysql_tquery(mysql, query ) ;

		if ( Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] <= 0 ) {

			Character [ playerid ] [ E_CHARACTER_LAST_BANDAGE_CD ] = 0 ;
			SendServerMessage( playerid, COLOR_RED, "Bandage", "A3A3A3",  "Your bandaging cooldown expired. You can now bandage other people again." );
		}
	}

	return true ;
}
*/

Injury_RemoveVariables(playerid) {

	PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] = false ;
	PlayerVar [ playerid ] [ E_PLAYER_INJURED_LAST_VEH ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] = 60 ;
	PlayerVar [ playerid ] [ E_PLAYER_PHONE_DECLINE_CALL ] = false ;

    PlayerDamage [ playerid ] [ DAMAGE_LEGS ] = false ;
    PlayerDamage [ playerid ] [ DAMAGE_ARMS ] = false ;

	PlayerVar [ playerid ] [ E_PLAYER_IS_TAZED_TIME ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_IS_TAZED ]  = false ;

	PlayerVar [ playerid ] [ E_PLAYER_IS_BEANBAGGED_TIME ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_IS_BEANBAGGED ]  = false ;

	PlayerVar [ playerid ] [ E_PLAYER_IS_TACKLED ] = false ;

	return true ;
}
