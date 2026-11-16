#include <a_samp>
#include <sscanf2>
#include <strlib>
#include <zcmd>

CMD:playsound(playerid, params[]) {

	new input ;

	if ( sscanf ( params, "i", input ) ) {

		return SendClientMessage(playerid, -1, "/playsound <input>");
	}

	PlayerPlaySound(playerid, input, 0.0, 0.0, 0.0);

	SendClientMessage(playerid, -1, sprintf("Playing sound ID %d", input )) ;

	return true ;
}
