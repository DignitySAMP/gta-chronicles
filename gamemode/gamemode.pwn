 /*	 e
 
// TextdrawLetterSize Rule -> Thanks to DamianC
// Letter-size-y = letter-size-x * 4
// For a nice font display
  
	[find pms between two players]
		SELECT *
		FROM `logs`
		WHERE `text` LIKE '%Lowride. sends to [BDT]Exyze%' OR  `text` LIKE '%[BDT]Exyze sends to Lowride.%';

	[find individual logs]
		SELECT *
		FROM `logs`
		WHERE `text` LIKE '%Lowride. sends to [BDT]Exyze%' ;
*/

//#define PHONE_V2_DEV
 
#define MAX_FACTION_TYPES       8
 
#define FACTION_TYPE_POLICE 	0 
#define FACTION_TYPE_EMS		3
#define FACTION_TYPE_NEWS		4
#define FACTION_TYPE_DEA		5
#define FACTION_TYPE_SECURITY	6
#define FACTION_TYPE_TRUCKER	7
#define FACTION_TYPE_GOV  		8
#define FACTION_TYPE_CONSTRUCT  9
#define FACTION_TYPE_TAXI       10

#define FACTION_SQUAD_NONE 0

#define FACTION_SQUAD_CRASH 1
#define FACTION_SQUAD_SWAT 	2
#define FACTION_SQUAD_IAG 	3
#define FACTION_SQUAD_TRAFF	4
#define FACTION_SQUAD_AIR   5

#define FACTION_SQUAD_ARSON 1

#define FACTION_SQUAD_ARMED 1

#define FACTION_SQUAD_GOV_DAO       1
#define FACTION_SQUAD_GOV_PW        2
#define FACTION_SQUAD_GOV_ADMIN     3
#define FACTION_SQUAD_GOV_COURT     4
#define FACTION_SQUAD_GOV_COUNCIL   5
#define FACTION_SQUAD_GOV_TRAFFIC   6
  
enum E_PLAYER_NAME_STYLE
{
    PLAYER_NAME_STYLE_ROLEPLAY,   // RP name (so char name replaced with spaces, but uses mask if masked)
    PLAYER_NAME_STYLE_CHARACTER,  // Char name replaced by spaces, ignores mask
    PLAYER_NAME_STYLE_ACCOUNT,    // Account name
    PLAYER_NAME_STYLE_LEGACY,     // Old shit like Account (F. Last)
    PLAYER_NAME_STYLE_DEFAULT     // Wrapper for default GetPlayerName
}

enum { // helper ranks
	HELPER_LVL_NONE,
	HELPER_LVL_NORMAL = 1,
	HELPER_LVL_SENIOR,
	HELPER_LVL_ADVANCED
} ;
  
enum E_LOG_TYPES
{
	LOG_TYPE_NONE,
	LOG_TYPE_CHAT,
	LOG_TYPE_ACTION,
	LOG_TYPE_SCRIPT,
	LOG_TYPE_GAME,
	LOG_TYPE_DAMAGE,
	LOG_TYPE_OOC,
	LOG_TYPE_PM,
	LOG_TYPE_PHONE,
	LOG_TYPE_PAGER,
	LOG_TYPE_ADMIN,
	LOG_TYPE_RADIO,
	LOG_TYPE_CMD,
	LOG_TYPE_DRUGS,
	LOG_TYPE_ANTICHEAT,
	LOG_TYPE_GRAFFITI

}

enum
{
	DEATHTYPE_WEAPON,
	DEATHTYPE_KNIFED,
	DEATHTYPE_CUSTOM,
	DEATHTYPE_CLIENT
}

enum E_SERVER_DATA {

	// Non saving
	E_SERVER_UPTIME,

	E_SERVER_TIME_HOURS,
	E_SERVER_TIME_MINUTES,
	E_SERVER_TIME_STRING[16],

	E_SERVER_TIME_DAYS,
	E_SERVER_TIME_MONTHS,

	E_SERVER_WEATHER_TICK,
	E_SERVER_WEATHER, 

	E_SERVER_OOC_ENABLED,
	//E_SERVER_RC_ENABLED, // respected
	E_SERVER_DC_ENABLED, // donator
	E_SERVER_SC_ENABLED, // strawman
	E_SERVER_TOLLS_LOCKED,

	E_SERVER_ADMIN_HEX,
	E_SERVER_HELPER_HEX,

	// motd
	E_SERVER_MOTD_STRING_1 [ 96 ],
	E_SERVER_MOTD_STRING_2 [ 96 ],
	E_SERVER_MOTD_STRING_3 [ 96 ],
	E_SERVER_MOTD_EDITOR   [ 24 ],
	E_SERVER_MOTD_EDIT_TIME,

	E_SERVER_TEXTDRAW_TICK,

	E_SERVER_CHOPSHOP_FACTIONID,
	E_SERVER_CHOPSHOP_COLLECT,

	DynamicText3D: E_SERVER_CHOPSHOP_LABEL,

	// Random help msgs
	E_SERVER_RAND_MSG,

	// For casinos
	E_SERVER_SLOTS_JACKPOT,
	DynamicText3D: E_SERVER_SLOTS_JACKPOTLABEL [ 3 ],

	Float: E_SERVER_LAST_911_POS_X,
	Float: E_SERVER_LAST_911_POS_Y,
	Float: E_SERVER_LAST_911_POS_Z,
	E_SERVER_LAST_911_TYPE,
	E_SERVER_LAST_911_NUMBER,


	Float: E_SERVER_POLICE_KIOSK_X,
	Float: E_SERVER_POLICE_KIOSK_Y,
	Float: E_SERVER_POLICE_KIOSK_Z,
	E_SERVER_POLICE_KIOSK_INT,
	E_SERVER_POLICE_KIOSK_VW,
	DynamicText3D: POLICE_KIOSK_LABEL,


	Float: E_SERVER_MEDIC_KIOSK_X,
	Float: E_SERVER_MEDIC_KIOSK_Y,
	Float: E_SERVER_MEDIC_KIOSK_Z,
	E_SERVER_MEDIC_KIOSK_INT,
	E_SERVER_MEDIC_KIOSK_VW,
	DynamicText3D: MEDIC_KIOSK_LABEL,

	Float: E_SERVER_DEA_KIOSK_X,
	Float: E_SERVER_DEA_KIOSK_Y,
	Float: E_SERVER_DEA_KIOSK_Z,
	E_SERVER_DEA_KIOSK_INT,
	E_SERVER_DEA_KIOSK_VW,
	DynamicText3D: DEA_KIOSK_LABEL,

	Float: E_SERVER_SHERIFF_KIOSK_X,
	Float: E_SERVER_SHERIFF_KIOSK_Y,
	Float: E_SERVER_SHERIFF_KIOSK_Z,
	E_SERVER_SHERIFF_KIOSK_INT,
	E_SERVER_SHERIFF_KIOSK_VW,
	DynamicText3D:SHERIFF_KIOSK_LABEL,

	E_SERVER_SONG_URL[128],
	E_SERVER_ACCS_DISABLED_UNTIL,
	E_SERVER_REGISTRATION_UCP,

	bool: E_SERVER_IS_DS_OFF

} ;

new Server [ E_SERVER_DATA ] ;

#include "config/header.pwn"

forward SOLS_OnMySQL_Init(handle);
public SOLS_OnMySQL_Init(handle)
{
	// You can hook this
	printf("SOLS_OnMySQL_Init: %d", handle);
	return 1;
}

#include "browser/header.pwn"
#include "sporky/anticheat.pwn"
#include "sporky/metrics.pwn"

#include "player/header.pwn"
#include "donator/header.pwn"
#include "visuals/header.pwn"
#include "inform/header.pwn"
#include "gps/header.pwn"
#include "admin/header.pwn"
#include "attachments/header.pwn"
#include "anims/header.pwn"
#include "money/header.pwn"
#include "hitman/header.pwn"
#include "vehicle/header.pwn"
#include "carjack/header.pwn"
#include "faction/header.pwn"
#include "groups/header.pwn"
#include "weapons/header.pwn"
#include "drugs/header.pwn"
#include "gym/header.pwn"
#include "property/header.pwn"
#include "furniture/header.pwn"
#include "passpoints/header.pwn"
#include "licenses/header.pwn"
#include "police/header.pwn"
#include "news/header.pwn"
#include "boombox/header.pwn"
#include "gates/header.pwn"
#include "injury/header.pwn"
//#include "injury-new/header.pwn"
#include "message/header.pwn"
#if !defined PHONE_V2_DEV
#include "phone/header.pwn"
#endif
#include "skins/header.pwn"
#include "interact/header.pwn"
#include "config/time_weather.pwn"
#include "config/native.pwn"
#include "money/paycheck.pwn"
#include "jobs/header.pwn"
#include "minigame/header.pwn"
#include "weapons/refunds.pwn"
#include "anticheat/header.pwn"
#include "fader/header.pwn"
#include "helpers/header.pwn"
#include "player/names.pwn"
#include "misc/header.pwn"
#include "gangzones/header.pwn"
#include "spraytag/header.pwn"
#include "paynspray/header.pwn"
#include "modshops/header.pwn"
#include "chopshop/header.pwn"
#include "vending/header.pwn"
#include "sporky/header.pwn"
#include "fbi/header.pwn"
#include "samp/header.pwn"
#include "strawmen/main.pwn"

//#include "custom/header.pwn"
//#include "firms/header.pwn"
//#include "prison/header.pwn"
//#include "properties/header.pwn"
//#include "whitelist/header.pwn"

#include "player/player_hooked.pwn"
#include "config/server-native.pwn"
#include "visuals/loadtextdraws.pwn"


#include "discord/header.pwn"
//#include "event_easter.pwn"
//#include "event_halloween.pwn"
//#include "event_christmas.pwn"
#include "mall/header.pwn"
#include "fireworks/header.pwn"
#include "gov/header.pwn"
#include "maps/header.pwn"
#include "hades/header.pwn"
 
main() {

	MySQL_Init();
	CA_Init();

	//Streamer_TickRate( 1000 );
	//Streamer_VisibleItems( STREAMER_TYPE_OBJECT, 900 );
	//Streamer_CellSize( 300.0 );
	//Streamer_CellDistance( 450.0 );

	Main_LoadDatabaseSettings();
	Main_LoadServerSettings();
	Main_LoadStaticModels() ;
	
	OnLoadTextdraws();

	Models_AddModels ( ); 
	MapHandler ();
	LoadStaticMaps();

	// Model loading goes first!
	#if !defined CUSTOM_SKINS_DEVBUILD
	PlayerSkin_LoadEntities (); 
	#endif
	Attachments_LoadCustomModels();

	Bank_LoadMap() ;
	Fine_LoadLabel() ;
	Vehicle_LoadEntities ();
	Property_LoadEntities() ;
	SavedFurni_LoadEntities();
	Tune_LoadEntities() ;
	Faction_LoadEntities ();
	SprayTag_LoadEntities( );
	Wounds_LoadEntities ( ) ;
	//Emmet_LoadEntities();
	ScrapYard_LoadEntities();
	Gate_LoadEntities();
	Drugs_LoadEntities();
	Jobs_Init() ;
	Advert_Init() ;
	GD_Factory_Init();
	Minigames_LoadEntities();
	RPRF_LoadEntities();
	Respray_LoadEntities();
	//PropStation_LoadEntities() ;
	Toll_LoadEntities();
	Hitman_LoadEntities();
	PassPoint_LoadEntities();
	Impound_LoadEntities();
	ActorRobbery_LoadEntities();
	GunPackage_LoadEntities();
	GangZone_LoadEntities();
	Attachments_LoadEntities();
	Boombox_LoadEntities ();
	PNS_LoadEntities();
	ChopShop_LoadEntities();
	Fuel_OnScriptInit();

	#if defined PROPERTY_V2_DEVBUILD
		Enex_LoadEntities();
		EnexBuyPt_LoadEntities();
	#endif

	#if defined PHONE_V2_DEV
	    Payphone_LoadEntities();
    	Contacts_LoadEntries();
    	PhoneLog_LoadEntries() ;
    #endif

	Group_LoadEntities();

	Mall_LoadEntities();
	Realty_LoadEntities();

	License_OnScriptInit();
	Notes_Load();

	License_LoadEntities();

	//EasterEggs_LoadEntities() ; // Holiday Event: Easter
	//Halloween_LoadEntities(); // Holiday Event: Halloween
	//Christmas_LoadEntities(); // Holiday Event: Christmas

	// load npcs
	//NPC_Init();

	// Deleting empty weapons for database maintenance
	mysql_tquery(mysql, "DELETE FROM player_weapons WHERE weapon_ammo = 0");

	AddPlayerClass(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	defer ASCII_Print[5000]() ;

	return true ;
}


public OnGameModeExit(){

	mysql_close(mysql);

	return true ;
}


IsPlayerIncapacitated(playerid, bool:excludeCuffs=false) {
	if ( PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] ||  PlayerVar [ playerid ] [ E_PLAYER_IS_BEANBAGGED ] || PlayerVar [ playerid ] [ E_PLAYER_IS_TAZED ] ||
		! IsPlayerSpawned ( playerid ) || PlayerVar [ playerid ] [ E_PLAYER_IS_TACKLED ] || PlayerVar [ playerid ] [ E_PLAYER_TRUCKER_CARRY_BOX ] != -1) {
		return true ;
	}
	
	// New by Sporks: option to exclude just being cuffed from this check
	if (!excludeCuffs && (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || GetPVarInt(playerid, "CUFFED") == 1))
	{
	    return true;
	}

	if ( IsPlayerInMinigame(playerid) ) {

		return true ;
	}

	if (  PlayerVar [ playerid ] [ E_PLAYER_INJUREDMODE ] && PlayerVar [ playerid ] [ E_PLAYER_INJURY_TICK ] <= 0  ) {
		
		return true ;
	}


	return false ;
}


timer ASCII_Print[5000]() {

	print("  ");
	print("       __                        __                          ___  ");
	print("      /\\ \\__                    /\\ \\__                     /'___\\ ");
	print("  ____\\ \\ ,_\\  _ __    __     __\\ \\ ,_\\   ____        ___ /\\ \\__/ ");
	print(" /',__\\\\ \\ \\/ /\\`'__\\/'__`\\ /'__`\\ \\ \\/  /',__\\      / __`\\ \\ ,__\\");
	print("/\\__, `\\\\ \\ \\_\\ \\ \\//\\  __//\\  __/\\ \\ \\_/\\__, `\\    /\\ \\L\\ \\ \\ \\_/");
	print("\\/\\____/ \\ \\__\\\\ \\_\\\\ \\____\\ \\____\\\\ \\__\\/\\____/    \\ \\____/\\ \\_\\ ");
	print(" \\/___/   \\/__/ \\/_/ \\/____/\\/____/ \\/__/\\/___/      \\/___/  \\/_/ ");
	print("  ");
	print("  ");
	print(" ___                                                __            ");
	print("/\\_ \\                                              /\\ \\__                  ");
	print("\\//\\ \\     ___     ____        ____     __      ___\\ \\ ,_\\   ___     ____  ");
	print("  \\ \\ \\   / __`\\  /',__\\      /',__\\  /'__`\\  /' _ `\\ \\ \\/  / __`\\  /',__\\ ");
	print("   \\_\\ \\_/\\ \\L\\ \\/\\__, `\\    /\\__, `\\/\\ \\L\\.\\_/\\ \\/\\ \\ \\ \\_/\\ \\L\\ \\/\\__, `\\");
	print("   /\\____\\ \\____/\\/\\____/    \\/\\____/\\ \\__/.\\_\\ \\_\\ \\_\\ \\__\\ \\____/\\/\\____/");
	print("   \\/____/\\/___/  \\/___/      \\/___/  \\/__/\\/_/\\/_/\\/_/\\/__/\\/___/  \\/___/ ");
	print("  ");                                                                      
}


UpdateTabListForPlayers(playerid)
{
    //new color = 0xDEDEDEFF;
    //new faction_enum_id, faction_type;
    //new name[MAX_PLAYER_NAME];
    
    foreach(new i:Player)
    {
        SetPlayerNameForPlayer(i, playerid, Character[i][E_CHARACTER_NAME]);
        SetPlayerColorForPlayer(i, playerid, 0xDEDEDEFF);
    }
    
    return true ;
}
