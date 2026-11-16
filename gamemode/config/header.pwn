#include "config/includes.pwn"

#if !defined SERVER_HOSTNAME
	#define SERVER_HOSTNAME   		"[0.3.DL] GTA Chronicles | gta-chronicles.com"
	//#define SERVER_HOSTNAME   		"[0.3.DL] Singleplayer Roleplay | Happy New Year!"
#endif

#if !defined SERVER_MODE

/* 


	Revision format:

	Example:
	v1.2.9

	version 1 - the main gamemode version
	subversion 2 - the 'content stage' or whatever
	infraversion 9 - each update this gets increased until the subversion is increased

*/

	#define SERVER_MODE       		"GTAC:RP 1.4.8 R8"
#endif

#if !defined SERVER_MAP
	#define SERVER_MAP		    	"Los Santos"
#endif

#if !defined SERVER_NAME 
	#define SERVER_NAME 			"GTA Chronicles"
#endif

#if !defined SERVER_WEBSITE
	#define SERVER_WEBSITE	    	"gta-chronicles.com"
#endif

#if !defined SERVER_VEH_RENT_FEE
	#define SERVER_VEH_RENT_FEE			( 125 )
#endif 

#if !defined SERVER_DMV_FEE
	#define SERVER_DMV_FEE 			( 250 )
#endif

#if !defined SERVER_MAX_NAME_UNDERSCORES
	#define SERVER_MAX_NAME_UNDERSCORES	(2)
#endif

#include "config/data/header.pwn"
#include "config/utils/header.pwn"
#include "config/gui/header.pwn"

#include "config/commands.pwn"
#include "config/main.pwn"
#include "config/paused.pwn"

#include "config/modelconstants.pwn"
#include "config/colors.pwn"

GetUptime(result[], len = sizeof ( result ) ) {

    new remaining = gettime() - Server [ E_SERVER_UPTIME ], 
        seconds, minutes, hours, days ;

    seconds = remaining % 60 ;
    remaining /= 60 ;
    minutes = remaining % 60 ;
    remaining /= 60 ;
    hours = remaining % 24 ;
    remaining /= 24 ;
    days = remaining ;

    if ( days ) format(result, len, "%d days, %d hours, %d minutes and %d seconds", days, hours, minutes, seconds);
	else if ( hours )  format(result, len, "%d hours, %d minutes and %d seconds", hours, minutes, seconds);
	else if ( minutes ) format(result, len, "%d minutes and %d seconds", minutes, seconds);
    else format(result, len, "%d seconds", seconds);
}


WriteLog ( playerid, const dir[], const text[]) {

	new query [ 512 ], Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;

	format ( query, sizeof ( query ), "X: %f, Y: %f, Z: %f, vw: %d, int: %d", x, y, z, GetPlayerVirtualWorld ( playerid ), GetPlayerInterior ( playerid ) ) ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO logs (dir, text, date, ip, info) VALUES ('%e', '%e', '%e', '%e', '%e')",
	dir, text, ReturnDateTime ( ), ReturnIP ( playerid ), query );

	mysql_tquery ( mysql, query ) ;

	return true ;
}