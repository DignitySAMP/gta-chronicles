// Add these to PLAYER_VARS enum
#include "visuals/models.pwn"
#include "visuals/objects.pwn"
#include "visuals/objects_static.pwn"
#include "visuals/remove.pwn"
#include "visuals/commands.pwn"

#include <YSI_Coding\y_hooks>

new bool: IsPlayerFinishedDownloading [ MAX_PLAYERS ] ;

/*

	Player skins use ranges: 20000 to 30000 (10000 slots)
	Objects use negative IDs: -1000 to -30000 (29000 slots)

	native AddCharModel(baseid, newid, dffname[], txdname[]);
	native AddSimpleModel(virtualworld, baseid, newid, dffname[], txdname[]);
*/

/*

new bool: IsPlayerFinishedDownloading [ MAX_PLAYERS ] ;

static localfiles[][] = 
{
    "attachments/lsfd/lifepak.dff",
    "attachments/lsfd/lifepak.txd",
    "sporky/news/filmcamera.dff",
    "sporky/news/filmcamera.txd",
    "sporky/news/filmlight.dff",
    "sporky/news/filmlight.txd",
    "sporky/sols/int/lsfd/mafcasdoor.dff",
    "sporky/sols/int/lsfd/mafcasdoor.txd",
    "faction_skins/san/mskin4.dff",
    "faction_skins/san/mskin4.txd"
};

public OnPlayerRequestDownload ( playerid, type, crc ) 
{
    new dlfilename [ 64 + 1 ], foundfilename = 0, requesturl[128];
    
    if ( !IsPlayerConnected ( playerid ) ) return 0;
    
    switch ( type ) {

    	case DOWNLOAD_REQUEST_TEXTURE_FILE: foundfilename = FindTextureFileNameFromCRC ( crc, dlfilename, sizeof ( dlfilename ) ) ;
    	case DOWNLOAD_REQUEST_MODEL_FILE: 	foundfilename = FindModelFileNameFromCRC ( crc, dlfilename, sizeof ( dlfilename ) ) ;
    }

    if ( foundfilename ) 
    {
        for (new i = 0; i < sizeof(localfiles); i ++)
        {
            if (!strcmp(dlfilename, localfiles[i]))
            {
                // printf("serving file: %s (%x) locally", dlfilename, crc);
                return 1;
            }
        }

        format(requesturl, 128, "%s/%s", baseurl, dlfilename);
        // printf("redirecting file: %s (%x) to %s", dlfilename, crc, requesturl);
        RedirectDownload ( playerid, requesturl );
    }
    
    return 0;
}

*/

hook OnGameModeInit()
{
    // Does the above in a filterscript now
    // SendRconCommand("loadfs sols_dl_redirect");
    return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld) {

    IsPlayerFinishedDownloading [ playerid ] = true ;

    return 1;
}

CMD:drawdistance( playerid, params[ ] )
{
    new string[128], dist = 0;

    if (strmatch(params, "minimal")) dist = 250;
    else if (strmatch(params, "low")) dist = 500;
    else if (strmatch(params, "medium")) dist = 750;
    else if (strmatch(params, "default")) dist = 900;
    else if (strmatch(params, "high")) dist = 1250;
    else if (strmatch(params, "ultra")) dist = 1500;
    else if (strmatch(params, "maximum")) dist = 2000;
    else if (strmatch(params, "info"))
    {
        format ( string, sizeof ( string ), "You have currently %d objects streamed towards your client.", Streamer_GetVisibleItems( STREAMER_TYPE_OBJECT, playerid ) );
        SendClientMessage( playerid, COLOR_INFO, string );
        return true;
    }

    if (dist)
    {
        Account[playerid][E_PLAYER_ACCOUNT_SETTINGS_DRAW] = dist;

        SendClientMessage(playerid, COLOR_INFO, sprintf("You changed your maximum number of streamed objects to %d.", dist));
        Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, Account[playerid][E_PLAYER_ACCOUNT_SETTINGS_DRAW], playerid);

        SendClientMessage(playerid, COLOR_YELLOW, "Note:{DEDEDE} This changes how many objects your client can see at once. It does NOT change object draw distances!");

        mysql_format(mysql, string, sizeof(string), "UPDATE `accounts` SET `account_setting_drawdistance` = %d WHERE `account_id` = %d", Account[playerid][E_PLAYER_ACCOUNT_SETTINGS_DRAW], Account[playerid][E_PLAYER_ACCOUNT_ID]);
        mysql_tquery(mysql, string);

        return true;
    }
   
    SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/drawdistance [minimal/low/medium/default/high/ultra/maximum]");
    SendClientMessage(playerid, COLOR_YELLOW, "Warning: The setting \"minimal\" and \"maximum\" might have undesirable effects.");
    SendClientMessage(playerid, COLOR_GRAD0, "Additionally, use \"/drawdistance info\" to view information.");

    return true ;
}
