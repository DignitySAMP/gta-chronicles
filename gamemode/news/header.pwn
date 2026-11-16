//------------------------------------------------------------------------------
// Legal RP Project - RP News Faction
// Created by Sporky (www.github.com/sporkyspork) for Singleplayer Roleplay (www.stretzofls.com)

#include "news/sanhq.pwn"
#include <YSI_Coding\y_hooks>

#define BROADCAST_STATE_NONE    0
#define BROADCAST_STATE_LIVE    1
#define BROADCAST_STATE_PAUSED  2

#define NEWS_LOCKER_X   750.7045
#define NEWS_LOCKER_Y   -1366.5341
#define NEWS_LOCKER_Z   9053.4209

static DynamicText3D: NEWS_KIOSK_LABEL;


static BroadcastStates[3][10] = 
{
    "None",
    "Live",
    "Paused"
};

#define MAX_BROADCAST_TITLE 64

static enum E_PLAYER_NEWS_DATA {
	E_PLAYER_NEWS_BROADCASTING,
    E_PLAYER_NEWS_BROADCAST_TITLE[MAX_BROADCAST_TITLE],
    bool:E_PLAYER_NEWS_LISTENING,
    E_PLAYER_NEWS_LISTENING_TO,
    E_PLAYER_NEWS_ADDED_TO
}

static enum 
{
    E_NEWS_MODEL_MIC = 25200,
    E_NEWS_MODEL_VEST,
    E_NEWS_MODEL_BOOM,
    E_NEWS_MODEL_CAM,
    E_NEWS_MODEL_LIGHT
}

static PlayerNewsVar [ MAX_PLAYERS ] [ E_PLAYER_NEWS_DATA ] ;
//static bool:G_ANYONE_BROADCASTING;

IsPlayerInNewsFaction(playerid, bool:onduty=false) 
{
	return IsPlayerInFactionType(playerid, FACTION_TYPE_NEWS, onduty);
}

static breakingcooldown = 0;

CMD:adminbreaking(playerid, params[])
{
    new text[128], str[144];

    if (GetPlayerAdminLevel(playerid) <= ADMIN_LVL_SENIOR) return SendServerMessage (playerid, COLOR_ERROR, "Access Denied", "A3A3A3", "You don't have access to this." );

	if (sscanf ( params, "s[128]", text )) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/adminbreaking [text]" ) ;

	format ( str, sizeof ( str ), "[BREAKING NEWS] %s", text ) ;

	foreach(new targetid: Player) 
    {
		ZMsg_SendClientMessage ( targetid, 0xff2a00FF, str);
	}

    SendAdminMessage(sprintf("[Last /adminbreaking was done by (%d) %s [%s].]", playerid, Character [ playerid ] [ E_CHARACTER_NAME ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ) ;
	return true ;
}


CMD:breaking(playerid, params[])
{
    new text[128], str[144];

	if (sscanf ( params, "s[128]", text )) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/breaking [text]" ) ;

    if (!IsPlayerInNewsFaction(playerid, true))
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a news faction." ) ;

    if (breakingcooldown && (gettime() - breakingcooldown) < 60)
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must wait before sending another breaking news alert." ) ;

	format ( str, sizeof ( str ), "[BREAKING NEWS] %s: %s", SOLS_PlayerName(playerid), text ) ;

	foreach(new targetid: Player) 
    {
		ZMsg_SendClientMessage ( targetid, 0xff2a00FF, str);
	}

    breakingcooldown = gettime();
	WriteLog ( playerid, "chat/misc", text );
	return true ;
}

CMD:newsadvert(playerid, params[]) 
{
    new text[128], str[144];

	if (sscanf ( params, "s[128]", text )) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/newsadvert [text]" ) ;

    if (!IsPlayerInNewsFaction(playerid, true))
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a news faction." ) ;

	format ( str, sizeof ( str ), "[Advertisement] %s", text) ;
	
    foreach(new targetid: Player) 
    {
		ZMsg_SendClientMessage ( targetid, COLOR_ADV, str);
	}

	SendAdminMessage(sprintf("(Last /newsad was done by (%d) %s [%s])", playerid, Character [ playerid ] [ E_CHARACTER_NAME ], Account [ playerid ] [ E_PLAYER_ACCOUNT_NAME ] ) ) ;
	return true ;
}

CMD:newsad(playerid, params[])
{
    return cmd_newsadvert(playerid, params);
}

CMD:broadcast(playerid, params[]) 
{
    new option[7], title[128], str[200];
    sscanf(params, "s[7] ", option);

    if (strlen(option) > 1)
    {
        if (!strcmp(option, "add", true))
        {
            if (!PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not hosting a live broadcast." ) ;
            }

            new targetid;
            if (sscanf(params, "s[7] r", option, targetid))
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [add] [player ID]" ) ;
            }

            if (!IsPlayerPlaying(targetid) || !PlayerNewsVar[targetid][E_PLAYER_NEWS_LISTENING] || PlayerNewsVar[targetid][E_PLAYER_NEWS_LISTENING_TO] != playerid)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player either isn't connected or is not tuned to your broadcast." ) ;
            }

            format ( str, sizeof ( str ), "[LIVE] ** %s joined the broadcast.", SOLS_PlayerName(targetid) );
            foreach(new i: Player) 
            {
                if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] == playerid)
                {
                    ZMsg_SendClientMessage(i, COLOR_SERVER, str);
                }
            }

            PlayerNewsVar[targetid][E_PLAYER_NEWS_ADDED_TO] = playerid;
        }
        else if (!strcmp(option, "remove", true))
        {
            if (!PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not hosting a live broadcast." ) ;
            }

            new targetid;
            if (sscanf(params, "s[7] r", option, targetid))
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [remove] [player ID]" ) ;
            }

            if (!IsPlayerPlaying(targetid) || PlayerNewsVar[targetid][E_PLAYER_NEWS_ADDED_TO] != playerid)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player hasn't been added to your broadcast, so you can't remove them.");
            }

            format ( str, sizeof ( str ), "[LIVE] ** %s was removed from the broadcast.", SOLS_PlayerName(targetid) );

            foreach(new i: Player) 
            {
                if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] == playerid)
                {
                    ZMsg_SendClientMessage(i, COLOR_SERVER, str);
                }
            }

            PlayerNewsVar[targetid][E_PLAYER_NEWS_ADDED_TO] = INVALID_PLAYER_ID;
        }
        else if (!strcmp(option, "leave", true))
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You cannot leave your own broadcast." ) ;
            }

            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] == INVALID_PLAYER_ID)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You've not been added to a live broadcast." ) ;
            }

            format ( str, sizeof ( str ), "[LIVE] ** %s left the broadcast.", SOLS_PlayerName(playerid) );

            foreach(new i: Player) 
            {
                if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] == playerid)
                {
                    ZMsg_SendClientMessage(i, COLOR_SERVER, str);
                }
            }

            PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] = INVALID_PLAYER_ID;
        }
        else if (!strcmp(option, "start", true))
        {
            if (!IsPlayerInNewsFaction(playerid, true))
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a news faction." ) ;

            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're already doing a live broadcast." ) ;
            }

            if (sscanf(params, "s[7] s[128]", option, title))
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [start] [broadcast title]" ) ;
            }

            if (strlen(title) <= 0 || strlen(title) >= MAX_BROADCAST_TITLE)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [start] [broadcast title]" ) ;
            }

            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] = BROADCAST_STATE_LIVE;
            format(PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST_TITLE], MAX_BROADCAST_TITLE, "%s", title);

            // SendClientMessage(playerid, -1, sprintf("You've started a live news broadcast titled: \"%s\".", title));
            // SendClientMessage(playerid, -1, "You or anyone nearby can now type /live to speak on air.");

            ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s starts a live broadcast of \"%s\".", ReturnPlayerNameData(playerid, 0, true), title));

            format ( str, sizeof ( str ), "[TIP] {36D191}%s went live with {36906b}\"%s\"{36D191} Type {36906b}/broadcasts{36D191} to listen.", ReturnPlayerNameData(playerid, 0, true), title, playerid) ;
	
            foreach(new targetid: Player) 
            {
                if (IsPlayerPlaying(targetid))
                    ZMsg_SendClientMessage ( targetid, COLOR_SERVER, str);
            }

            PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING] = true;
            PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] = playerid;
        }
        else if (!strcmp(option, "end", true))
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] == BROADCAST_STATE_NONE)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You've not started a live broadcast." ) ;
            }

            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] = BROADCAST_STATE_NONE;
            //SendClientMessage(playerid, -1, "You've put away your microphone and ended the live news broadcast.");
            ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s ends the live broadcast of \"%s\".", ReturnPlayerNameData(playerid, 0, true), PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST_TITLE]));
        }
        else if (!strcmp(option, "mute", true))
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] != BROADCAST_STATE_LIVE)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a live broadcast to mute." ) ;
            }

            ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s mutes the microphone, pausing the live broadcast.", ReturnPlayerNameData(playerid, 0, true)));

            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] = BROADCAST_STATE_PAUSED;
            // SendClientMessage(playerid, -1, "You've muted your microphone and are no longer broadcasting live.");
        }
        else if (!strcmp(option, "unmute", true))
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] != BROADCAST_STATE_PAUSED)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have a muted broadcast to resume." ) ;
            }

            ProxDetector(playerid, 30.0, COLOR_PURPLE, sprintf("** %s unmutes the microphone, resuming the live broadcast.", ReturnPlayerNameData(playerid, 0, true)));

            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] = BROADCAST_STATE_LIVE;
            // SendClientMessage(playerid, -1, "You've unmuted your microphone and are now broadcasting live again.");
        }
        else
        {
            return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [start/mute/unmute/end/add/remove/leave]" ) ;
        }

        
        //G_ANYONE_BROADCASTING = false;
        foreach(new i: Player) 
        {
            if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] != INVALID_PLAYER_ID)
            {
                if (!PlayerNewsVar[PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO]][E_PLAYER_NEWS_BROADCASTING])
                {
                    // Player stopped broadcasting while being listened to by another player
                    format ( str, sizeof ( str ), "[LIVE]{36D191} The live broadcast of {e24f80}\"%s\"{36D191} has finished.", PlayerNewsVar[PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO]][E_PLAYER_NEWS_BROADCAST_TITLE]) ;
                    ZMsg_SendClientMessage ( i, COLOR_SERVER, str);

                    PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] = INVALID_PLAYER_ID;
                    PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] = false;   
                }
            }

            if (PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING] == BROADCAST_STATE_LIVE)
            {
                //G_ANYONE_BROADCASTING = true;
            }
        }

        return true;
    }

    return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/broadcast [start/mute/unmute/end/add/remove/leave]" ) ;
}

CMD:tunein(playerid, params[])
{
    new targetid;

    if (sscanf ( params, "k<player>", targetid )) 
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/tunein [player]" ) ;

    if (!IsPlayerConnected(targetid))
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player isn't broadcasting." ) ;

    if (!PlayerNewsVar[targetid][E_PLAYER_NEWS_BROADCASTING])
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "This player isn't broadcasting." ) ;

    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must stop broadcasting first." ) ;

    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] != INVALID_PLAYER_ID)
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must leave your current broadcast first." ) ;

    PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING] = true;
    PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] = targetid;
    SendClientMessage(playerid, -1, sprintf("You're now listening to \"%s\" by %s.", PlayerNewsVar[targetid][E_PLAYER_NEWS_BROADCAST_TITLE], ReturnPlayerNameData(targetid)));
    return true;
}

CMD:tuneout(playerid)
{
    if (!PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING])
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You aren't listening to a broadcast." ) ;

    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must stop broadcasting first." ) ;

    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] != INVALID_PLAYER_ID)
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must leave your current broadcast first." ) ;

    PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING] = false;
    PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] = INVALID_PLAYER_ID;
    return true;
}

static BroadcastsDlgStr[1024];

CMD:broadcasts(playerid, params[])
{
    format(BroadcastsDlgStr, sizeof(BroadcastsDlgStr), "Title\tBroadcaster\tStatus\tListeners\n");

    new listeners[MAX_PLAYERS], broadcasts = 0;
    new map[MAX_PLAYERS];

    foreach(new i: Player) 
    {
        if (!PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING])
        {
            
            /*if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && IsPlayerConnected(PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO]))
            {
                listeners[PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO]] ++;
            }*/            
            if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && IsPlayerConnected(PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO]))
            {
                listeners[PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO]] ++;
            }

        } 
    }

    foreach(new i: Player) 
    {
        if (PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING])
        {
            format(BroadcastsDlgStr, sizeof(BroadcastsDlgStr), "%s\t%s\t%s\t%s\t%d\n", BroadcastsDlgStr, PlayerNewsVar[i][E_PLAYER_NEWS_BROADCAST_TITLE], SOLS_PlayerName(i), BroadcastStates[PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING]], listeners[i]);
            // SendClientMessage(playerid, -1, sprintf("Title: \"%s\", Reporter: %s, Status: %s, Listeners: %d", PlayerNewsVar[i][E_PLAYER_NEWS_BROADCAST_TITLE], ReturnPlayerNameData(i), BroadcastStates[PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING]], listeners[i]));
            map[broadcasts] = i;
            broadcasts ++;  
        }
    }

    if (!broadcasts)
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "There are currently no broadcasts." ) ;
    }

    inline BroadcastsDlg(pid, dialogid, response, listitem, string:inputtext[]) {

        #pragma unused pid, dialogid, inputtext, listitem

        if (response)
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING])
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must stop broadcasting first." ) ;

            new broadcasterid = map[listitem];
            if (IsPlayerConnected(broadcasterid) && PlayerNewsVar[broadcasterid][E_PLAYER_NEWS_BROADCASTING])
            {
                PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING] = true;
                PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] = broadcasterid;
                SendClientMessage(playerid, -1, sprintf("You're now listening to \"%s\" by %s.  Type /tuneout to stop.", PlayerNewsVar[broadcasterid][E_PLAYER_NEWS_BROADCAST_TITLE], SOLS_PlayerName(broadcasterid)));
            }
        }
    }

    Dialog_ShowCallback ( playerid, using inline BroadcastsDlg, DIALOG_STYLE_TABLIST_HEADERS, "Live Broadcasts", BroadcastsDlgStr, "Listen", "Back" );

    return true;
}

static ProxDetectorLive(playerid, broadcasterid, Float:range, local_color, remote_color, text[], bool:action=false) 
{
    new Float:distance, Float:remote_distance;
    new color = local_color;
    new Float:senderpos[3];
    new Float:broadcastpos[3];
    new Float:distancescaled;
    new str[512];
    new colorvalue;

    GetPlayerPos(playerid, senderpos[0], senderpos[1], senderpos[2]);
    GetPlayerPos(broadcasterid, broadcastpos[0], broadcastpos[1], broadcastpos[2]);

    remote_distance = GetPlayerDistanceFromPoint(playerid, broadcastpos[0], broadcastpos[1], broadcastpos[2]);

    foreach (new i: Player)
    {
        new bool:islocal = false;

        if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] && PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] == broadcasterid)
        {
            // Remote chat
            color = remote_color;
            distance = remote_distance;

            if (!action) format ( str, sizeof ( str ), "[LIVE] %s says: %s", ReturnPlayerNameData(playerid,  0, true), text ) ;
            else format ( str, sizeof ( str ), "[LIVE] * %s", text ) ;
        }
        else
        {
            // Local chat
            color = local_color;
            distance = GetPlayerDistanceFromPoint(i, senderpos[0], senderpos[1], senderpos[2]);

            if (action) format ( str, sizeof ( str ), "[LIVE] * %s (( %s ))", ReturnPlayerNameData(playerid,  0, true), text ) ;
            else format ( str, sizeof ( str ), "%s says [live]: %s", ReturnPlayerNameData(playerid,  0, true), text ) ;    

            islocal = true;       
        }

        new r = ((color >> 24) & 0xFF);
        new g = ((color >> 16) & 0xFF);
        new b = ((color >> 8) & 0xFF);       

        if (!islocal || distance <= range) // receiving player is within the specified distance
        {
            // get normalized distance to create a fade.
            if (!action)
            {
                distancescaled = (distance / range);
                new colormod = floatround(distancescaled * 128.0);

                new cr = r - colormod;
                new cg = g - colormod;
                new cb = b - colormod;
                
                if (r < 0) cr = 0;
                if (g < 0) cg = 0;
                if (b < 0) cb = 0;

                colorvalue = ((cr & 0xFF) << 24) + ((cg & 0xFF) << 16) + ((cb & 0xFF) << 8);
            }
                
            if ((!islocal || broadcasterid == playerid) || action) colorvalue = color;

            ZMsg_SendClientMessage ( i, colorvalue, str);
        }
    }
}

CMD:live(playerid, params[])
{
    new text[144], color = COLOR_ADV;
    
    // This is the reporter.
    if (sscanf ( params, "s[128]", text )) 
        return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/live [text]" ) ;

    if (strlen(text) < 3)
        return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/live [text]" ) ;

	if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] == BROADCAST_STATE_LIVE)
    {
        ProxDetectorLive(playerid, playerid, 15.0, -1, COLOR_ADV, text);
    }
    else if (PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] != INVALID_PLAYER_ID)
    {
        ProxDetectorLive(playerid, PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO], 15.0, -1, COLOR_ADV, text);
    }
    else
    {
        // Find closest reporter
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        new world = GetPlayerVirtualWorld(playerid);
        new closest = INVALID_PLAYER_ID;
        new Float:current;
        new Float:last = 5.0; // 5.0 radius for /live

        foreach (new i: Player) 
        {
            if (i == playerid) continue;
            if (GetPlayerVirtualWorld(i) != world) continue;
            if (PlayerNewsVar[i][E_PLAYER_NEWS_BROADCASTING] != BROADCAST_STATE_LIVE) continue;

            current = GetPlayerDistanceFromPoint(i, x, y, z);

            if (current < last)
            {
                closest = i;
                last = current;
            }
        }

        if (!IsPlayerConnected(closest))
            return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not near any live broadcasters." ) ;

        if (!PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING] || PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] != closest)
        {
            return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be tuned in to this player's broadcast to speak on it." ) ;
        }
 
        ProxDetectorLive(playerid, closest, 15.0, -1, COLOR_ADV, text);
    }

    if (strlen(text))
        SetPlayerChatBubble(playerid, sprintf("(live) %s", text), color, 15.0, (strlen(text) * 50) + 2500);

    return true;
}

CMD:livedo(playerid, params[])
{
    new text[144];

    if (sscanf ( params, "s[128]", text )) 
        return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/livedo [text]" ) ;

    if (strlen(text) < 3)
        return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/livedo [text]" ) ;
    
	if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] == BROADCAST_STATE_LIVE)
    {
        ProxDetectorLive(playerid, playerid, 30.0, COLOR_ACTION, COLOR_ADV, text, true);
    }
    else if (PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] != INVALID_PLAYER_ID)
    {
        ProxDetectorLive(playerid, PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO], 30.0, COLOR_ACTION, COLOR_ADV, text, true);
    }
    else
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You've not been added to any live broadcasts." ) ;
    }

    return true;
}

hook OnGameModeInit()
{
    AddSimpleModel(-1, 19142, -E_NEWS_MODEL_VEST, "sporky/news/press_vest.dff", "sporky/news/press_stuff.txd");
    AddSimpleModel(-1, 19610, -E_NEWS_MODEL_MIC, "sporky/news/press_mic.dff", "sporky/news/press_stuff.txd");
    AddSimpleModel(-1, 19611, -E_NEWS_MODEL_BOOM, "sporky/news/boom_mic.dff", "sporky/news/press_stuff.txd");
    AddSimpleModel(-1, 19623, -E_NEWS_MODEL_CAM, "sporky/news/filmcamera.dff", "sporky/news/filmcamera.txd");
    AddSimpleModel(-1, 19611, -E_NEWS_MODEL_LIGHT, "sporky/news/filmlight.dff", "sporky/news/filmlight.txd");

    /*
    if ( IsValidDynamic3DTextLabel ( NEWS_KIOSK_LABEL ) ) {

		DestroyDynamic3DTextLabel(NEWS_KIOSK_LABEL);
	}

    NEWS_KIOSK_LABEL = CreateDynamic3DTextLabel("[SAN Newsroom]{DEDEDE}\nAvailable commands:{ffffff} /duty, /uniform",
		0xB83333FF, NEWS_LOCKER_X, NEWS_LOCKER_Y, NEWS_LOCKER_Z,
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, -1, -1
	);
    */

    return 1;
}

hook OnPlayerConnect(playerid)
{
    new clear [ E_PLAYER_NEWS_DATA ] ;
    PlayerNewsVar[playerid] = clear;
    PlayerNewsVar[playerid][E_PLAYER_NEWS_LISTENING_TO] = INVALID_PLAYER_ID;
    PlayerNewsVar[playerid][E_PLAYER_NEWS_ADDED_TO] = INVALID_PLAYER_ID;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new i: Player)
    {
        if (PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] == playerid)
        {
            PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING_TO] = INVALID_PLAYER_ID;
            PlayerNewsVar[i][E_PLAYER_NEWS_LISTENING] = false;
        }

        if (PlayerNewsVar[i][E_PLAYER_NEWS_ADDED_TO] == playerid)
        {
            PlayerNewsVar[i][E_PLAYER_NEWS_ADDED_TO] = INVALID_PLAYER_ID;
        }
    }

    return 1;
}

/*
hook OnPlayerText(playerid, text[])
{
    if (!G_ANYONE_BROADCASTING) return 1;
    

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid);

    foreach(new i: Player) 
    {
        if (PlayerNewsVar[i][E_PLAYER_NEWS_BROADCAST] == BROADCAST_STATE_LIVE)
        {
             
        }
    }
    


    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST] == BROADCAST_STATE_LIVE)
    {
        new string[144];
        format ( string, sizeof ( string ), "[LIVE] %s says: %s", ReturnPlayerCharName(playerid), text) ;

        foreach(new targetid: Player) 
        {
            ZMsg_SendClientMessage ( targetid, COLOR_ADV, string);
        }

        // -1 should stop processing onplayertext
        return -1;
    }

    // and ret value here shouldn't matter
    return 1;
}
*/

hook OnPlayerUpdate(playerid)
{
    // quick but bad way of doing this atm
    if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] != BROADCAST_STATE_NONE)
    {
        if (IsPlayerIncapacitated(playerid))
        {
            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] = BROADCAST_STATE_NONE;
            SendClientMessage(playerid, -1, "Your news broadcast was interrupted.");
        }

        if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCASTING] == BROADCAST_STATE_LIVE)
        {
            SetPlayerChatBubble(playerid, sprintf("(( Broadcasting \"%s\" [ Type /live to join in. ] ))", PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST_TITLE], playerid), COLOR_SERVER, 7.5, 7500);
        }
    }

    return 1;
}

/*
static enum E_NEWS_TOYS
{
    E_NEWS_TOY_NAME,
    E_NEWS_TOY_MODEL,
    E_NEWS_TOY_BONE
}

static NewsToys [ E_NEWS_TOYS ] = 
{
    {"Press Armor Vest", E_NEWS_MODEL_VEST, 1},
    {"Press Microphone", E_NEWS_MODEL_MIC, 6},
    {"Boom Microphone", E_NEWS_MODEL_BOOM, 6}
};

CMD:microphone(playerid, params[])
{
    new option[7];
    sscanf(params, "s[7]", option);

    if (!IsPlayerInNewsFaction(playerid, true))
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a news faction." ) ;

    if (strlen(option) > 1)
    {
        if (!strcmp(option, "hold", true))
        {
            Att

            
            return true ;
        }
        else if (!strcmp(option, "drop", true))
        {
            if (PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST] == BROADCAST_STATE_NONE)
            {
                return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You've not started a live broadcast." ) ;
            }

            PlayerNewsVar[playerid][E_PLAYER_NEWS_BROADCAST] = BROADCAST_STATE_NONE;
            SendClientMessage(playerid, -1, "You've put away your microphone and ended the live news broadcast.");
            return true ;
        }
    }

    return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/microphone [hold/drop]" ) ;
}
*/

/*
static NewsDlgStr[256];

CMD:newstoys(playerid, params[])
{
    format(NewsDlgStr, sizeof(NewsDlgStr), "");
    for (new i = 0; i < sizeof(NewsToys); i ++)
    {
        format(NewsDlgStr, sizeof(NewsDlgStr), "%s%s\n", NewsDlgStr, NewsToys[i][E_NEWS_TOY_NAME]);
    }

    inline SpawnableCats(pid, dialogid, response, listitem, string:inputtext[]) {

        #pragma unused pid, dialogid, inputtext, listitem

        if (response && listitem < MAX_SPAWNABLE_CATEGORIES) ShowSpawnCatDlg(playerid, listitem);
    }

    Dialog_ShowCallback ( playerid, using inline SpawnableCats, DIALOG_STYLE_LIST, "Select Category", SpawnableDlgStr, "Wear", "Back" );
}
*/