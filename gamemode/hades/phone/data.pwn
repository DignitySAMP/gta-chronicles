
enum E_PLAYER_PHONE_DATA {

    bool: E_PLAYER_IS_CALLING,
    E_PLAYER_CALLING_WITH,
    bool: E_PLAYER_PHONE_RINGING,
    E_PLAYER_PHONE_RINGER,
    E_PLAYER_PHONE_RINGING_TICKS,
} ;

new PlayerPhoneData [ MAX_PLAYERS ] [ E_PLAYER_PHONE_DATA ] ;

ConnectCall(playerid, targetid) {

    PlayerPhoneData [ playerid ] [ E_PLAYER_IS_CALLING ] = true ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_IS_CALLING ] = true ;


    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING ] = false ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGING ] = false ;

    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGER ] = INVALID_PLAYER_ID ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGER ] = INVALID_PLAYER_ID ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGING_TICKS ] = 0 ;

    PlayerPhoneData [ playerid ] [ E_PLAYER_CALLING_WITH ] = targetid ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_CALLING_WITH ] = playerid ;
}

IsPlayerCalling(playerid) {

    return ( PlayerPhoneData [ playerid ] [ E_PLAYER_IS_CALLING ] && PlayerPhoneData [ playerid ] [ E_PLAYER_CALLING_WITH ] != INVALID_PLAYER_ID ) ;
}

GetPlayerCaller(playerid) {

    return PlayerPhoneData [ playerid ] [ E_PLAYER_CALLING_WITH ] ;
}

Phone_ResetVariables(playerid) {
  
    PlayerPhoneData [ playerid ] [ E_PLAYER_IS_CALLING ] = false ;
    PlayerPhoneData [ playerid ] [ E_PLAYER_CALLING_WITH ] = INVALID_PLAYER_ID ;
    
    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING ] = false ;
    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGER ] = INVALID_PLAYER_ID ;
    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING_TICKS ] = 0 ;
}

public OnPlayerConnect(playerid) {
    Phone_ResetVariables(playerid);

    #if defined phone_OnPlayerConnect
        return phone_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect phone_OnPlayerConnect
#if defined phone_OnPlayerConnect
    forward phone_OnPlayerConnect(playerid);
#endif


Phone_GenerateRandomNumber(&number) {

    // Player 

    new query [ 256 ] ;

    mysql_format(mysql, query, sizeof ( query ), 
        "SELECT FLOOR(RAND() * 99999) AS random_num FROM characters\
        WHERE \"random_num\" NOT IN ( SELECT player_phnumber FROM characters)\
        LIMIT 1;"
    ) ;

    inline GenerateRandomNumber() {

        new rows, fields ;
        cache_get_data ( rows, fields, mysql ) ;

        if ( rows ) {

            number = cache_get_field_content_int ( 0, "random_num", mysql ) ;
        }
    }

    mysql_tquery_inline(mysql, query, using inline GenerateRandomNumber, "");

}
