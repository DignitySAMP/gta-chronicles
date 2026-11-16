//------------------------------------------------------------------------------
// Temporary *Basic* Character Select (Fix for crashing)
// By Spooky (www.github.com/sporkyspork) for GTA Chronicles (www.gta-chronicles.com)

#include <YSI_Coding\y_hooks>

enum E_CLASS_SELECTION_DATA {

	E_PLAYER_CLASS_SEL_ACTOR_ID,
	E_PLAYER_CLASS_SEL_CHARID,
	bool: E_PLAYER_CLASS_SEL_IN_MENU
} ;

new PlayerClassSelection [ MAX_PLAYERS ] [ E_CLASS_SELECTION_DATA ];

static const HEIGHT_FIX = 1500;     // fixed surrounding maps / models being visible
static const VW_OFFSET = 1;         // players get set to VW_OFFSET + playerid

static CharSelDlgStr[1024];

CreateLoginScreen() 
{
    CreateObject(LOGIN_TR_BASE,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_BITS,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_INTBITS,           -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_MAIN,              -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
    CreateObject(LOGIN_TR_STUDIOLIGHTSET,    -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
	CreateObject(LOGIN_TR_ALPHAS,            -2312.5725, 2783.9651, 63.9877 + HEIGHT_FIX, 0.0, 0.0, 0.0, 100.0 );
}

static const Float:CAM_SELECT_X = -2300.9243;
static const Float:CAM_SELECT_Y = 2789.3237;
static const Float:CAM_SELECT_Z = 1565.9877;
static const Float:CAM_SELECT_LOOK_X = -2310.9771;
static const Float:CAM_SELECT_LOOK_Y = 2785.6252;
static const Float:CAM_SELECT_LOOK_Z = 1564.9877;

static const Float:CAM_CREATE_X = -2307.93;
static const Float:CAM_CREATE_Y = 2785.46;
static const Float:CAM_CREATE_Z = 1565.97;
static const Float:CAM_CREATE_LOOK_X = -2312.92;
static const Float:CAM_CREATE_LOOK_Y = 2785.47;
static const Float:CAM_CREATE_LOOK_Z = 1565.63;

static SetupCharSelection(playerid, bool:fade=true)
{
    // Sets up the necessary per player things for char select (like pointing their cam)
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, VW_OFFSET + playerid);
    SetPlayerCameraPos(playerid, CAM_SELECT_X, CAM_SELECT_Y, CAM_SELECT_Z);
    SetPlayerCameraLookAt(playerid, CAM_SELECT_LOOK_X, CAM_SELECT_LOOK_Y, CAM_SELECT_LOOK_Z);

    if (fade)
    {
        UpdateZone(playerid, "Character Selection");
        BlackScreen(playerid);
        FadeIn(playerid, false);	
    }
}

static SetupCharCreate(playerid)
{
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, VW_OFFSET + playerid);
    InterpolateCameraPos(playerid, CAM_SELECT_X, CAM_SELECT_Y, CAM_SELECT_Z, CAM_CREATE_X, CAM_CREATE_Y, CAM_CREATE_Z, 2500);
    InterpolateCameraLookAt(playerid, CAM_SELECT_LOOK_X, CAM_SELECT_LOOK_Y, CAM_SELECT_LOOK_Z, CAM_CREATE_LOOK_X, CAM_CREATE_LOOK_Y, CAM_CREATE_LOOK_Z, 2500);
}

static ShowCharSelectDialog(playerid)
{
    // printf("ShowCharSelectDialog: %d", playerid);

    format(CharSelDlgStr, sizeof(CharSelDlgStr), "ID\tName\tLast Played");
    new count = GetCharacterCount(playerid);

    new year, month, day, hour, minute, second;

    for ( new i, j = count; i < j ; i ++ )
    {
        if (CharacterBuffer[playerid][i][E_CHAR_BUFFER_LAST_LOGIN])
        {
            stamp2datetime(CharacterBuffer[playerid][i][E_CHAR_BUFFER_LAST_LOGIN], year, month, day, hour, minute, second, 1);
            format(CharSelDlgStr, sizeof(CharSelDlgStr), "%s\n%d\t%s\t%s %d, %d", CharSelDlgStr, CharacterBuffer[playerid][i][E_CHAR_BUFFER_ID], CharacterBuffer[playerid][i][E_CHAR_BUFFER_RP_NAME], date_getMonth(month), day, year);
        }
        else
        {
            format(CharSelDlgStr, sizeof(CharSelDlgStr), "%s\n%d\t%s\t%s", CharSelDlgStr, CharacterBuffer[playerid][i][E_CHAR_BUFFER_ID], CharacterBuffer[playerid][i][E_CHAR_BUFFER_RP_NAME], "Never");
        }
    }

    if (count < MAX_CHARACTERS)
    {
        strcat(CharSelDlgStr, "\n*\tCreate New Character");
    }

    inline DlgCharSelect(pid, dialogid, response, listitem, string:inputtext[] ) 
    { 
		#pragma unused pid, dialogid, response, listitem, inputtext

		if (!response) // Quit
        {
			KickPlayer(playerid);
			return true ;
		}
        
        if (listitem >= count)
        {
            if (count < MAX_CHARACTERS)
            {
                // Create new
                return Account_CharacterCreation ( playerid ) ;
            }
        }
        else
        {
            // Select
            return Account_LoadCharacterData(playerid, CharacterBuffer [ playerid ] [ listitem ] [ E_CHAR_BUFFER_ID ]);
        }
    }

    Dialog_ShowCallback(playerid, using inline DlgCharSelect, DIALOG_STYLE_TABLIST_HEADERS, "Select Character", CharSelDlgStr, "Select", "Quit");
    return true;
}

SOLS_ShowCharSelection(playerid, charid, bool:fade=true)
{
    #pragma unused charid

    // printf("SOLS_ShowCharSelection: %d", playerid);
    SetupCharSelection(playerid, fade);
    PlayerVar[playerid][E_PLAYER_CREATING_CHAR] = false;

    defer OnShowCharSelection(playerid);
}

timer OnShowCharSelection[1000](playerid) 
{
    ShowCharSelectDialog(playerid);
	return 1;	
}

timer OnShowCharCreation[2500](playerid) 
{
	//Player_ShowSkinMenu(playerid); // old <
    SOLS_ShowPlayerAttributes(playerid, playerid); // new


	return 1;	
}

SOLS_ShowCharCreation(playerid, charid)
{
    #pragma unused charid

    // printf("SOLS_ShowCharCreation: %d", playerid);
    SetupCharCreate(playerid);
    defer OnShowCharCreation(playerid);
    PlayerVar[playerid][E_PLAYER_CREATING_CHAR] = true;
}

ClassBrowser_HideTextDraws(playerid) 
{
    #pragma unused playerid
    return 1;
}

ClassBrowser_LoadStaticDraws() 
{
	return 1;
}

ClassBrowser_LoadPlayerDraws(playerid) 
{
    #pragma unused playerid
	return 1;
}

ClassBrowser_DestroyPlayerDraws(playerid) 
{
    #pragma unused playerid
    return 1;
}

// Hook of Char Creation Attributes
hook SOLS_OnEditAttributes(playerid)
{
    // Confirm creation
    if (PlayerVar[playerid][E_PLAYER_CREATING_CHAR])
    {
        new sex = 0;
        if (Character[playerid][E_CHARACTER_ATTRIB_SEX] == E_ATTRIBUTE_SEX_FEMALE) sex = 1;

        new race = 3;
        if (Character[playerid][E_CHARACTER_ATTRIB_RACE] == E_ATTRIBUTE_RACE_WHITE) race = 2;
        else if (Character[playerid][E_CHARACTER_ATTRIB_RACE] == E_ATTRIBUTE_RACE_BLACK) race = 0;
        else if (Character[playerid][E_CHARACTER_ATTRIB_RACE] == E_ATTRIBUTE_RACE_LATIN) race = 1;

        Player_SetupSpawnVariables(playerid, race, sex);
    }

    return 1;
}

