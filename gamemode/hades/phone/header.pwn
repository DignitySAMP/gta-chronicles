/*
Preface
 - Remove the buggy GUI, move everything to simple inline dialogs
 - Calling is interactive, singleplayer: ringing soundid, alert box "Your phone is ringing, caller XXXX, Press Y to pick up or N to ignore."
 (After picking up, box changes to "Press N to hang up the call.");
 - A single command (/phone) to trigger the individual menus, move these to individual modules / functions for future ease
 - Able to use contact name both in /sms, /call & co

Payphones [80%]
 - Able to be created by admins
 - Call from a static "1-800-XXXX (SQLID)" number.
 - Current "placeholder" for /burnerphones.
 - Do /phonebooth to see the number, so you can call phone booths. 

Contacts [90%]
 - People can be called through number or contact name
 - Ability to view contacts in dialogs (page support) and able to be edited easily (name, number, note)
 - /contacts [online | offline | all]

History
 - SMS history
 - Call history

Interaction
 - /pme (/pme clears his throat after coughing loudly.)
 - /pdo (/pdo You hear the phone being passed around.)
 - /ptalk [playerid] (Lets someone else talk on the phone (only usable if /loudspeaker is on))
 - /loudspeaker  (Streams the phone radius using Proxdetector to a short (/low) range)
 - /showcontacts
 - /showtexts
 - /passphone
 - /givephone (ports phone nr etc over)

Misc Functionality
 - /hidenumber (lets you call with a "hidden" number, add logging to this, perhaps UNIQUE id)
 - /blockhidden (blocks all hidden calls, i.e. "* SERVICE PROVIDER: Your recipient is blocking calls from hidden numbers.")
 - /blocknumber [x] (blocks calls from a specific number, i.e. * VOICEMAIL: The number you have dialed is currently unavailable)
 - Basic phone signal system (Using an dynamic area grid system to measure distance without having to use hacky laggy functions)
 - Ability to send SMS to numbers of players who are offline
 -- (Player logs in: "SMS: You have X unread text messages.");
 - Ability to call numbers that are offline
 -- (Player logs in: "CALL: You got called, use /history to view who tried to call you");
 - Phone credit (reup in stores) or subscription (per paycheck, you subscribe for X amount of texts or you'll need to pay extra)
*/

enum {
    PHONE_COLOUR_OK = 0x6AE82BFF,
    PHONE_COLOUR_MED = 0xE8C12BFF,
    PHONE_COLOUR_BAD = 0xE83A2BFF
} ;

#include "hades/phone/payphones.pwn"
#include "hades/phone/data.pwn"

/*

Delete all mentions of 
            #if !defined PHONE_V2_DEV
*/

#include "hades/phone/contacts.pwn"
#include "hades/phone/history.pwn"
#include "hades/phone/func.pwn"

#warning Able to send offline text/calls (voicemail)!

// Sync SendPlayerChatText

CMD:pickup(playerid, params[]) {

	return true ;
}

CMD:hangup(playerid, params[]) {
	
	return true; 
}

CMD:sms(playerid, params[]) {
    new target[32], text[128] ;

    if ( sscanf ( params, "s[32]s[128]", target, text)) return SendClientMessage(playerid, COLOR_ERROR, "/call [number/contact] [text]");

    new targetid = Contacts_MatchEntries(playerid, target);

    if ( targetid == INVALID_PLAYER_ID ) {
        // Not online.

        new match_number = Contacts_MatchEntries_Number(playerid, target);

        if(match_number != 0 ) { // offline SMS, target number = match_number!

            PhoneLog_AddEntry(playerid, E_PHONE_LOG_SMS, E_PHONE_LOG_STATUS_UNREAD, Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], text) ;
        }

        return true ;
    }


    else if(targetid == -2 )  return true ; // function handled error message, just end the command

    if ( strlen ( text ) > 128 ) {
        return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "Your text message can't have more than 128 characters.") ;   
    }

    new string [ 256 ], contact_name [ 32 ] ;
    Contact_GetSavedName(Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name ) ;

    format ( string, sizeof ( string ), "SMS from %d (%s): %s", Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name, text ) ;
    ZMsg_SendClientMessage(targetid, COLOR_YELLOW, string);

    contact_name [ 0 ] = EOS, string [ 0 ] = EOS ;

    Contact_GetSavedName(Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name ) ;

    format ( string, sizeof ( string ), "SMS to %d (%s): %s", Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name, text ) ;
    ZMsg_SendClientMessage(playerid, COLOR_YELLOW, string);

    PlayerPlaySound(playerid, 21002, 0.0, 0.0, 0.0);
    PlayerPlaySound(targetid, 21000, 0.0, 0.0, 0.0);

    PhoneLog_AddEntry(playerid, E_PHONE_LOG_SMS, E_PHONE_LOG_STATUS_READ, Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ targetid ] [ E_CHARACTER_PHONE_NUMBER ], text) ;

	return true; 
}

CMD:call(playerid, params[]) {

    new target[32] ;

    if ( sscanf ( params, "s[32]", target)) return SendClientMessage(playerid, COLOR_ERROR, "/call [number/contact]");

    new targetid = Contacts_MatchEntries(playerid, target);

    if ( targetid == INVALID_PLAYER_ID ) return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", sprintf("The number or contact with prefix \"%s\" can't be reached.", target)) ;
    else if(targetid == -2 )  return true ; // function handled error message, just end the command

    if ( IsPlayerCalling ( targetid ) || PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGING ] ) {
        return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "The line goes over but jumps to voicemail immediately. The line is already occupied." ) ;
    }   

    if ( IsPlayerCalling ( playerid ) ||  PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING ] ) {
        return SendServerMessage( playerid, PHONE_COLOUR_BAD, "Phone", "A3A3A3", "You're already calling with someone else! Hang up first!" ) ;
    }


    PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING ] = true ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGING ] = true ;
    PlayerPhoneData [ targetid ] [ E_PLAYER_PHONE_RINGER ] = playerid ;

    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

    defer OnPhoneRing[1500](playerid, targetid, 0);

    // initiate ringing
    return true ;
}

timer OnPhoneRing[1000](playerid, forplayerid, sound) {

    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(forplayerid)){
        return true ;
    }

    if (  PlayerPhoneData [ forplayerid ] [ E_PLAYER_PHONE_RINGING ] && PlayerPhoneData [ playerid ] [ E_PLAYER_PHONE_RINGING ] ) {

        PlayerPhoneData [ forplayerid ] [ E_PLAYER_PHONE_RINGING_TICKS ] ++ ;

        if ( PlayerPhoneData [ forplayerid ] [ E_PLAYER_PHONE_RINGING_TICKS ] >= 20) {

            ShowPlayerInfoMessage(playerid, "They didn't pick up in time. Try again later.", .height=285.0, .width = 200.0, .showtime=4500);
            ShowPlayerInfoMessage(forplayerid, "You didn't pick up the phone in time.", .height=285.0, .width = 200.0, .showtime=4500);

            new contact_name [ 32 ] ;
            Contact_GetSavedName(Character [ forplayerid ] [ E_CHARACTER_PHONE_NUMBER ], Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name ) ;

            SendClientMessage(forplayerid, COLOR_YELLOW, sprintf("Missed call from %d (%s)", Character [ playerid ] [ E_CHARACTER_PHONE_NUMBER ], contact_name));
           
            Phone_ResetVariables(forplayerid);
            Phone_ResetVariables(playerid);
            return true ;
        }

        ShowPlayerInfoMessage(forplayerid, "Your phone is ringing. Press ~k~~CONVERSATION_YES~ to pick up or ~k~~CONVERSATION_NO~ to hang up. Or ~b~/pickup~w~ and ~b~/hangup~w~ respectively.", .height=285.0, .width = 200.0);
        ShowPlayerInfoMessage(playerid, "The line is dialing. Waiting for recipient to pick up. Use ~k~~CONVERSATION_NO~ or /hangup to cancel the call.", .height=285.0, .width = 200.0);
    
        if(sound>=2) {
            PlayerPlaySound(playerid, 16001, 0.0, 0.0, 0.0);
            PlayerPlaySound(forplayerid, 20600, 0.0, 0.0, 0.0);

            sound ++;
            defer OnPhoneRing(playerid, forplayerid, sound);
        }

        else {

            defer OnPhoneRing(playerid, forplayerid, 0);
        }
    }

    return true ;
}