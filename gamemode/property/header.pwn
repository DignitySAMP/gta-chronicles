new PlayerText: house_info_box [ MAX_PLAYERS ] = { PlayerText: INVALID_TEXT_DRAW, ... } ;

#include "property/robbery.pwn"
#include "property/types.pwn"
#include "property/data.pwn"
#include "property/enter.pwn"
#include "property/user.pwn"
#include "property/admin.pwn"
#include "property/store_gun.pwn"
#include "property/store_drugs.pwn"
#include "property/interiors.pwn"
#include "property/enex.pwn"
#include "property/buy.pwn"
#include "property/advert.pwn"
#include "property/bank.pwn"
#include "property/extra.pwn"
#include "property/gps.pwn"
#include "property/inactive.pwn"
#include "property/slots.pwn"
#include "property/realty.pwn"
#include "property/audio.pwn"

IsValidProperty(index) {

	if ( index == -1 ) {

		return false ;
	}

	if ( Property [ index ] [ E_PROPERTY_ID ] != INVALID_PROPERTY_ID ) {

		return true ;
	}

	return false ;
}

GetPropertyID(index) {

	return Property [ index ] [ E_PROPERTY_ID ] ;

}

Property_ShowPlayerProperties(playerid, target ) {
	new address [ 64 ], zone [ 64 ] ;

	for_loop ( new i, j = sizeof ( Property ); i < j ; i ++ ) {

		if ( Property [ i ] [ E_PROPERTY_ID ] == INVALID_PROPERTY_ID ) {

			continue ;
		}

		if ( Property [ i ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] ) {

			address [ 0 ] = EOS, zone [ 0 ] = EOS ;

			GetCoords2DZone(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], zone, sizeof ( zone ));
			GetPlayerAddress(Property [ i ] [ E_PROPERTY_EXT_X ], Property [ i ] [ E_PROPERTY_EXT_Y ], address );

			SendClientMessage(target, 0x3A84C4FF, sprintf("[Owned Property]{DEDEDE} (id. %d) Located at %s, %s", i, address, zone ) );
		}

		else continue ;
	}

	return true ;
}

CMD:mic(playerid, params[]) {

	new index = PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_BLUE, "Property", "A3A3A3", "You're not in a business! Re-enter if you think this is a bug.");
	}

	if ( Property [ index ] [ E_PROPERTY_TYPE ] != E_PROPERTY_TYPE_BIZ) {

		return SendServerMessage ( playerid, COLOR_BLUE, "Property", "A3A3A3", "You're not in a business! Re-enter if you think this is a bug.");
	}

	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new text [ 144 ] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/mic [text]" ) ;
	}
	
	new string [ 256 ] ;

	format ( string, sizeof ( string ), "%s says [MIC]: %s", SOLS_PlayerName(playerid), text ) ;
	ProxDetector ( playerid, 64.0, 0x9dff96AA, string ) ;

	WriteLog ( playerid, "chat/local", string );

	return true;
}

/*
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys ) {
	
	if ( newkeys & KEY_SECONDARY_ATTACK ) {

		if ( ! IsPlayerIncapacitated(playerid) && ! IsPlayerInMinigame(playerid) ) {
    
			cmd_enter(playerid);
			cmd_exit(playerid);
		}
	}

	#if defined property_OnPlayerKeyStateChange
		return property_OnPlayerKeyStateChange(playerid, newkeys, oldkeys );
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange property_OnPlayerKeyStateChange
#if defined property_OnPlayerKeyStateChange
	forward property_OnPlayerKeyStateChange(playerid, newkeys, oldkeys );
#endif*/


CMD:nosound(playerid, params[]) {

	new status;

	if ( sscanf ( params, "i", status ) ) {

		return SendClientMessage(playerid, COLOR_ERROR, "/nosound [status: 1: nothing, 0: default outdoor ambience]");
	}

	if ( status < 0 || status > 1 ) {

		return SendClientMessage(playerid, COLOR_ERROR, "Invalid status! Choose: 1: nothing, 0: default outdoor ambience.");
	}

	PlayerPlaySound(playerid, status, 0, 0, 0);

	SendClientMessage(playerid, -1, "Reset your sound! Useful if you hear the \"air\" sound whilst in an interior." ) ;

	return true ;
}

CMD:enter(playerid) 
{
	if (PlayerVar[playerid][E_PLAYER_IS_FADING]) return true; // Make them wait first
	
	if (IsPlayerIncapacitated(playerid, true)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." );
    }

	if (!Gym_Enter(playerid)) 
	{
		new property_enum_id = Property_GetClosestEntity(playerid);
		Property_Enter(playerid, property_enum_id, true);
	}

	return true ;
}

CMD:exit(playerid) 
{
	if (PlayerVar[playerid][E_PLAYER_IS_FADING]) return true; // Make them wait first
	
	if (IsPlayerIncapacitated(playerid, true)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." );
    }

	if (!Gym_Exit(playerid)) 
	{
		new property_enum_id = Property_GetClosestEntity(playerid);
		Property_Exit(playerid, property_enum_id, true);
	}

	return true ;
}

IsPlayerInsideProperty(playerid) {

	if ( PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] != INVALID_PROPERTY_ID ) 
	{
		return PlayerVar [ playerid ] [ E_PLAYER_LAST_PROPERTY_ENTERED ] ;
	}

	return Property_GetInside(playerid);
}

GetPropertyTime(property_enum_id, type) {

	if ( property_enum_id < 0 || property_enum_id >= MAX_PROPERTIES ) {
		return -1 ;
	}

	switch ( type ) {
		case 0: return Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_HOURS ]; // hours
		case 1: return Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_MINUTES ]; // minutes
	}

	return -1 ;
}

GetPropertyWeather(property_enum_id) 
{
	if (property_enum_id < 0 || property_enum_id >= MAX_PROPERTIES) 
	{
		return -1 ;
	}

	return Property[property_enum_id][E_PROPERTY_INTERIOR_WEATHER];
}

CMD:propertytime(playerid, params[]) 
{

	new property_enum_id = Property_GetClosestEntity( playerid ) ;


	if ( property_enum_id == INVALID_PROPERTY_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property." );
	}

	if ( Property [ property_enum_id ] [ E_PROPERTY_TYPE ] == E_PROPERTY_TYPE_STATIC ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't change the time of a static property." );
	}

	new access = Property [ property_enum_id ] [ E_PROPERTY_OWNER ] == Character [ playerid ] [ E_CHARACTER_ID ] || Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[property_enum_id][E_PROPERTY_ID] || Character[playerid][E_CHARACTER_PROP_DUP] == Property[property_enum_id][E_PROPERTY_ID] ;

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to change the time in this property." );
		else if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR) return SendClientMessage(playerid, -1, "You don't have normal access to this property, but can go on admin duty to do this.");
		else return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own or rent this property." );
	}	

	new hours, minutes ;

	if ( sscanf ( params, "ii", hours, minutes ) ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3",  "/propertytime [hours] [minutes] (-1 for both to disable)" );
	}

	if (hours < -1 || hours > 23) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The hours must be between 0 and 23 (or -1 to disable)" );
	else if (minutes < -1 || minutes > 59) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The minutes must be between 0 and 59 (or -1 to disable)" );

	Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_HOURS ] = hours ;
	Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_MINUTES ] = minutes ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_int_hours = %d,property_int_mins = %d WHERE property_id = %d", 

		Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_HOURS ], Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_MINUTES ], Property [ property_enum_id ] [ E_PROPERTY_ID ]
	);

	mysql_tquery(mysql, query);

	if (hours == -1 && minutes == -1)
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3",  "You set the property interior time back in sync with outside.");
		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Set the interior time of Property %d (SQL: %d) to real time.", property_enum_id, Property [ property_enum_id ] [ E_PROPERTY_ID ]));
	}
	else
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3",  sprintf("You set the property interior time to %02d:%02d.", Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_HOURS ], Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_MINUTES ] ) );
		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Set the interior time of Property %d (SQL: %d) to %02d:%02d.", property_enum_id, Property [ property_enum_id ] [ E_PROPERTY_ID ], Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_HOURS ], Property [ property_enum_id ] [ E_PROPERTY_INTERIOR_MINUTES ] ));
	}


	foreach(new inhabitants: Player) 
	{
		// Syncing interior times.
		new property_id = IsPlayerInsideProperty(inhabitants);

		if (property_id == property_enum_id) 
		{
			SOLS_SyncPlayerTime(inhabitants, property_enum_id);
		}
	}

	return true ;
}

CMD:proptime(playerid, params[]) {

	return cmd_propertytime(playerid, params);
}

CMD:propertyweather(playerid, params[]) 
{
	new property_enum_id = Property_GetClosestEntity(playerid);

	if (property_enum_id == INVALID_PROPERTY_ID) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near a property.");
	}

	if (Property[property_enum_id][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_STATIC)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't change the time of a static property." );
	}

	new access = Property[property_enum_id][E_PROPERTY_OWNER] == Character[playerid][E_CHARACTER_ID] || Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[property_enum_id][E_PROPERTY_ID] || Character[playerid][E_CHARACTER_PROP_DUP] == Property[property_enum_id][E_PROPERTY_ID];

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to change the weather in this property." );
		else if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR) return SendClientMessage(playerid, -1, "You don't have normal access to this property, but can go on admin duty to do this.");
		else return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own or rent this property." );
	}	

	new weather;

	if (sscanf(params, "d", weather)) 
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/propertyweather [weather id] (-1 to disable)" );
	}

	if (weather < -1 || weather > 23) return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "The weather id must be between 0 and 22 (or -1 to disable)" );

	Property[property_enum_id][E_PROPERTY_INTERIOR_WEATHER] = weather;

	new query[256];
	mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_int_weather = %d WHERE property_id = %d", Property[property_enum_id][E_PROPERTY_INTERIOR_WEATHER], Property[property_enum_id][E_PROPERTY_ID]);
	mysql_tquery(mysql, query);

	if (weather == -1)
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3",  "You set the property weather back in sync with outside.");
		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Set the interior time of Property %d (SQL: %d) to real time.", property_enum_id, Property[property_enum_id][E_PROPERTY_ID]));
	}
	else
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3",  sprintf("You set the property weather to %d.", Property[property_enum_id][E_PROPERTY_INTERIOR_WEATHER]));
		AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Set the interior weather of Property %d (SQL: %d) to %d.", property_enum_id, Property[property_enum_id][E_PROPERTY_ID], Property[property_enum_id][E_PROPERTY_INTERIOR_WEATHER]));
	}

	foreach(new inhabitants: Player) 
	{
		// Syncing interior weathers.
		new property_id = IsPlayerInsideProperty(inhabitants);

		if (property_id == property_enum_id) 
		{
			SOLS_SyncPlayerWeather(inhabitants, property_enum_id);
		}
	}

	return true ;
}

CMD:propweather(playerid, params[])
{
	return cmd_propertyweather(playerid, params);
}