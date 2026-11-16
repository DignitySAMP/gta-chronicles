/*
    [WIPE DRUGS ECONOMY + REMOVE THE BUY POINTS OF DRUGS]
    [MAKE IT SO PEOPLE CAN'T CONSUME 0.1G TO AVOID ABUSE]

    [WIPE AMMO ECONOMY + REMOVE EMMET]
   	[MAKE IT SO PEOPLE CAN PASS AMMO + GUNS BUT LOG IT THOROUGHLY]

*/

#define MAX_STRAWMEN    (150)

new StrawmenDlgString [ 4000 ] ; 

#include "strawmen/access.pwn"
#include "strawmen/chat.pwn"
#include "strawmen/logs.pwn"


#include "strawmen/packages.pwn"
#include "strawmen/supply.pwn"
#include "strawmen/sell.pwn"


CMD:strawmen(playerid, params[]) {
    if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
    }

    if ( ! strcmp(params, "manage", true)) {

        #warning Check if user is strawmen FT
        Strawmen_ManageMenu ( playerid ) ;
    }


    return true ;
}   

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// FUNCTIONALITY SYSTEM ///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CMD:spoofammo(playerid, params[]) {

    new id, ammo ;

    if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this command.") ;
    }

    if ( sscanf  ( params, "ii", id, ammo ) ) {

        SendClientMessage(playerid, COLOR_ERROR, "/spoofammo [type] [amount]" ) ;
        SendClientMessage(playerid, COLOR_BLUE, "Ammo types");

        for ( new i = 1, j =sizeof ( Ammo ); i < j ; i ++ ) {

            SendClientMessage(playerid, COLOR_YELLOW, sprintf("(%d / ID %d) \"%s\" (m: %d, p: %d - time: %d / clip: %d)",
                i, Ammo [ i ] [ E_AMMO_CONSTANT ], Ammo [ i ] [ E_AMMO_DESC ], Ammo [ i ] [ E_AMMO_TIME ], 
                Ammo [ i ] [ E_AMMO_METAL ], Ammo [ i ] [ E_AMMO_PARTS ], Ammo [ i ] [ E_AMMO_CLIPSIZE ]

            ));
        }

        return true; 
    }

    SendClientMessage(playerid, -1, "Work in progres. Be patient." ) ;

    return true ;
}