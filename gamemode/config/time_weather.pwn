

static enum WEATHER_IDS
{
	EXTRASUNNY_LA = 0,
	SUNNY_LA,
	EXTRASUNNY_SMOG_LA,
	SUNNY_SMOG_LA,
	CLOUDY_LA,
	SUNNY_SF,
	EXTRASUNNY_SF,
	CLOUDY_SF,
	RAINY_SF,
	FOGGY_SF,
	SUNNY_VEGAS,
	EXTRASUNNY_VEGAS,
	CLOUDY_VEGAS,
	EXTRASUNNY_COUNTRYSIDE,
	SUNNY_COUNTRYSIDE,
	CLOUDY_COUNTRYSIDE,
	RAINY_COUNTRYSIDE,
	EXTRASUNNY_DESERT,
	SUNNY_DESERT,
	SANDSTORM_DESERT,
	UNDERWATER
};

static const WEATHER_IDS:ServerWeatherIds[] = 
{
	EXTRASUNNY_LA, SUNNY_LA, EXTRASUNNY_SMOG_LA, SUNNY_SMOG_LA, CLOUDY_LA, EXTRASUNNY_SF, SUNNY_VEGAS, EXTRASUNNY_COUNTRYSIDE, SUNNY_COUNTRYSIDE, CLOUDY_COUNTRYSIDE, RAINY_COUNTRYSIDE
};

SOLS_SyncTimeAndWeather(playerid, property_enum_id=-1)
{
	new hours = Server[E_SERVER_TIME_HOURS];
	new minutes = Server[E_SERVER_TIME_MINUTES];
	new weather = Server[E_SERVER_WEATHER];

	if (property_enum_id != -1 || GetPlayerVirtualWorld(playerid))
	{
		if (property_enum_id == -1)
		{
			property_enum_id = IsPlayerInsideProperty(playerid);
		}

		if (property_enum_id != INVALID_PROPERTY_ID) 
		{
			hours = GetPropertyTime(property_enum_id, 0);
			minutes = GetPropertyTime(property_enum_id, 1);
			weather = GetPropertyWeather(property_enum_id);

			if (hours == -1 || minutes == -1)
			{
				hours = Server[E_SERVER_TIME_HOURS];
				minutes = Server[E_SERVER_TIME_MINUTES];
			}

			if (weather == -1)
			{
				weather = Server[E_SERVER_WEATHER];
			}
		}
	}

	SetPlayerWeather(playerid, weather);
	SetPlayerTime(playerid, hours, minutes);
	TextDrawSetString(hud_time, Server[E_SERVER_TIME_STRING]);

	if (Character[playerid][E_CHARACTER_HUD_CLOCK]) TextDrawShowForPlayer(playerid, hud_time); 
	else TextDrawHideForPlayer(playerid, hud_time); 
}

SOLS_SyncPlayerTime(playerid, property_enum_id=-1)
{
	new hours = Server[E_SERVER_TIME_HOURS];
	new minutes = Server[E_SERVER_TIME_MINUTES];

	if (property_enum_id != -1 || GetPlayerVirtualWorld(playerid))
	{
		if (property_enum_id == -1)
		{
			property_enum_id = IsPlayerInsideProperty(playerid);
		}

		if (property_enum_id != INVALID_PROPERTY_ID) 
		{
			hours = GetPropertyTime(property_enum_id, 0);
			minutes = GetPropertyTime(property_enum_id, 1);

			if (hours == -1 || minutes == -1)
			{
				hours = Server[E_SERVER_TIME_HOURS];
				minutes = Server[E_SERVER_TIME_MINUTES];
			}
		}
	}

	SetPlayerTime(playerid, hours, minutes);
	TextDrawSetString(hud_time, Server[E_SERVER_TIME_STRING]);

	if (Character[playerid][E_CHARACTER_HUD_CLOCK]) TextDrawShowForPlayer(playerid, hud_time); 
	else TextDrawHideForPlayer(playerid, hud_time); 
}

SOLS_SyncPlayerWeather(playerid, property_enum_id=-1)
{
	new weather = Server[E_SERVER_WEATHER];

	if (property_enum_id != -1 || GetPlayerVirtualWorld(playerid))
	{
		if (property_enum_id == -1)
		{
			property_enum_id = IsPlayerInsideProperty(playerid);
		}

		if (property_enum_id != INVALID_PROPERTY_ID) 
		{
			weather = GetPropertyWeather(property_enum_id);

			if (weather == -1)
			{
				weather = Server[E_SERVER_WEATHER];
			}
		}
	}

	SetPlayerWeather(playerid, weather);
}

task HandleIngameTime[60000]() 
{
	new year, month, day, hour, minute, second;
	new timestamp = gettime();
	stamp2datetime(timestamp, year, month, day, hour, minute, second, 1);

	Server [ E_SERVER_TIME_DAYS ] = day;
	Server [ E_SERVER_TIME_MONTHS ] = month;

	if ( ++ Server [ E_SERVER_TIME_MINUTES ] >= 60 ) 
	{
		Server [ E_SERVER_TIME_MINUTES ] = 0 ;
		Server [ E_SERVER_WEATHER_TICK ] ++ ;

		if (Server[E_SERVER_WEATHER] == _:RAINY_COUNTRYSIDE || (Server[E_SERVER_WEATHER_TICK] >= 6 && random(5) == 0))
		{ 
			Server [ E_SERVER_WEATHER_TICK ] = 0;
			new weather = _:ServerWeatherIds[random(sizeof(ServerWeatherIds))];
			SOLS_SetWeather(weather);
		}

		if ( ++ Server [ E_SERVER_TIME_HOURS] > 23 ) 
		{
			Server [ E_SERVER_TIME_HOURS] = 0 ;
		}

		// Update global worldtime var here.  Per player is done later.
		SetWorldTime(Server [ E_SERVER_TIME_HOURS ]);
	}

	// Build the textdraw string
	format(Server[E_SERVER_TIME_STRING], 16, "%02d:%02d", Server[E_SERVER_TIME_HOURS], Server[E_SERVER_TIME_MINUTES]);


	UpdateGymStatsDay(); // updates the "day" in stats

	foreach(new playerid: Player) 
	{
		#if !defined PHONE_V2_DEV
		PlayerTextDrawSetString(playerid, ptd_ph_design[playerid][10], Server[E_SERVER_TIME_STRING]);
		#endif

		/*
		if (IsPlayerLogged(playerid) && PlayerVar[playerid][E_PLAYER_CHOSE_CHARACTER]) 
		{
			
		}
		*/

		// Syncing interior or world time.
		SOLS_SyncPlayerTime(playerid);
	}
}

CMD:settime(playerid, params[]) 
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new hour, minute ;

	if ( sscanf ( params, "ii", hour, minute ) || hour < 0 || hour > 23 || minute < 0 || minute > 59 ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/settime [hour] [minutes]") ;
	}

	SendAdminCmd(playerid, sprintf("changed the server world time to %02d:%02d", hour, minute));
	SOLS_SetTime(hour, minute);
	return true ;
}


CMD:setweather(playerid, params[]) 
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_GENERAL ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
	}

	new weather ;

	if ( sscanf ( params, "i", weather ) ) {
		return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "/setweather [weather]") ;
	}

	SendAdminCmd(playerid, sprintf("changed the server weather to %d", weather));
	SOLS_SetWeather(weather);
	return true ;
}

forward SOLS_OnWeatherChanged(old_weather, new_weather);
public SOLS_OnWeatherChanged(old_weather, new_weather)
{
	// Hook this shit
	return 1;
}

SOLS_SetWeather(weatherid)
{
	new oldweatherid = Server [ E_SERVER_WEATHER ];
	Server [ E_SERVER_WEATHER ] = weatherid ;

	// Global first
	SetWeather(weatherid);

	// Then, per player
	foreach(new i: Player)
	{
		SOLS_SyncPlayerWeather(i);
	}

	// new, hookable
	CallLocalFunction("SOLS_OnWeatherChanged", "dd", oldweatherid, weatherid);
	return 1;
}

SOLS_SetTime(hour, minute)
{
	Server [ E_SERVER_TIME_HOURS ] = hour ;
	Server [ E_SERVER_TIME_MINUTES ] = minute - 1 ; // - 1 for update!
	
	// Global first
	SetWorldTime(hour);

	// Then, per player
	foreach(new i: Player)
	{
		SOLS_SyncPlayerTime(i);
	}

	return 1;
}

#include <YSI_Coding\y_hooks>

hook OnGameModeInit() 
{
	new year, month, day, hour, minute, second;
	new timestamp = gettime();
	stamp2datetime(timestamp, year, month, day, hour, minute, second, 1);

	Server [ E_SERVER_TIME_HOURS] = hour;
	Server [ E_SERVER_TIME_MINUTES ] = minute;

	// Force weather change from default
	Server [ E_SERVER_WEATHER_TICK ] = 0;
	Server [ E_SERVER_TIME_DAYS ] = day;
	Server [ E_SERVER_TIME_MONTHS ] = month;

	// Set global time
	SetWorldTime(Server[E_SERVER_TIME_HOURS]);

	// Set global weather
	Server[E_SERVER_WEATHER] = _:ServerWeatherIds[random(sizeof(ServerWeatherIds))];
	SetWeather(Server[E_SERVER_WEATHER]);

	// Build the textdraw string
	format(Server[E_SERVER_TIME_STRING], 16, "%02d:%02d", Server[E_SERVER_TIME_HOURS], Server[E_SERVER_TIME_MINUTES]);

	return 1;
}

hook OnPlayerConnect(playerid)
{
	SetPlayerWeather(playerid, Server [ E_SERVER_WEATHER ]);
	SetPlayerTime(playerid, Server [ E_SERVER_TIME_HOURS], Server [ E_SERVER_TIME_MINUTES]);
	return 1;
}

hook SOLS_OnCharacterSpawn(playerid, isrespawn)
{
	SOLS_SyncTimeAndWeather(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	SOLS_SyncTimeAndWeather(playerid);
	return 1;
}