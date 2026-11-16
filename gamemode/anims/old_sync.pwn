// LOWRIDER (CAR / VEHICLE) seating anims

CMD:lowrider1(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 768 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider2(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 769 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider3(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 770 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider4(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 771 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider5(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 772 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider6(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 773 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider7(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 775 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider8(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 776 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}


CMD:lowrider9(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 779 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider10(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 780 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider11(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 782 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider12(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 784 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}


CMD:lowrider13(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 785 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider14(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 787 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}

CMD:lowrider15(playerid, params[]) {
    if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }
    new index = 788 ; 

    new animlib[32], animname[32];
    GetAnimationName(index, animlib, sizeof ( animlib ), animname, sizeof ( animname ) ) ;

    new loop ;
    sscanf ( params, "I(0)", loop ) ;

    if ( ! loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 0, 0, 0, 0, 1);
    }

    else if ( loop ) {
       ApplyAnimation(playerid, animlib, animname, 4.1, 0, 1, 1, 1, 1, 1); 
    }

    SendClientMessage(playerid, -1, sprintf("%s, %s", animlib, animname ) ) ;
    return true ;
}
