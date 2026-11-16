#include <a_samp>
#include <sscanf2>
#include <strlib>
#include <zcmd>


CMD:drugtest(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return true ;
	}

	new time, weather ;

	if ( sscanf ( params, "ii", time, weather )) {
		return SendClientMessage(playerid, -1, "/drugtest [time] [weather]" ) ;
	}

	SetPlayerTime(playerid, time, 0 );
	SetPlayerWeather ( playerid, weather ) ;

	SendClientMessage(playerid, -1, sprintf("Time %d, weather %d", time, weather )) ;

	return true ;
}
CMD:drugtest2(playerid, params[]) {

	if(!IsPlayerAdmin(playerid)) {

		return true ;
	}

	new time=random(23), weather=random(1000) ;
	SetPlayerTime(playerid, time, 0 );
	SetPlayerWeather ( playerid, weather ) ;

	SendClientMessage(playerid, -1, sprintf("Time %d, weather %d", time, weather )) ;

	return true ;
}