//------------------------------------------------------------------------------
// Police arrest mugshots - uses useable camera system
// Written by Sporky (www.github.com/sporkyspork) for SOLS

// Character[targetid][E_CHARACTER_LAST_MUGSHOT]

#include <YSI_Coding\y_hooks>

#define PD_MUGSHOT_X -14.5380
#define PD_MUGSHOT_Y -102.4791
#define PD_MUGSHOT_Z 898.5792

/*
#define SD_MUGSHOT_X 1400.3131
#define SD_MUGSHOT_Y -20.8508
#define SD_MUGSHOT_Z 1001.1469
*/

#define SD_MUGSHOT_X 2460.4338
#define SD_MUGSHOT_Y -1517.8984
#define SD_MUGSHOT_Z 999.2344

static PD_CameraObject;
static DynamicText3D:PD_CameraLabel;

static SD_CameraObject;
static DynamicText3D:SD_CameraLabel;

static const Float:PD_MUG_CAM_POS[6] = { -14.32, -100.03, 898.75,   270.00, 0.00, -58.38 };
//static const Float:SD_MUG_CAM_POS[6] = {  1398.946, -22.797, 1001.206, 270.000, -165.200, -58.380 };
static const Float:SD_MUG_CAM_POS[6] = {  2457.563, -1519.032, 999.514, 270.00, 0.000, -55.199 };


static CreateCamera()
{
    PD_CameraObject = CreateDynamicObject(19623, PD_MUG_CAM_POS[0], PD_MUG_CAM_POS[1], PD_MUG_CAM_POS[2], PD_MUG_CAM_POS[3], PD_MUG_CAM_POS[4], PD_MUG_CAM_POS[5]);
    PD_CameraLabel = CreateDynamic3DTextLabel("[Mugshot Camera]{DEDEDE}\nAvailable Commands: {3479E3}/mugshot{DEDEDE}", 0x3479E3FF, PD_MUG_CAM_POS[0], PD_MUG_CAM_POS[1], PD_MUG_CAM_POS[2] + 0.33, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

    SD_CameraObject = CreateDynamicObject(19623, SD_MUG_CAM_POS[0], SD_MUG_CAM_POS[1], SD_MUG_CAM_POS[2], SD_MUG_CAM_POS[3], SD_MUG_CAM_POS[4], SD_MUG_CAM_POS[5]);
    SD_CameraLabel = CreateDynamic3DTextLabel("[Mugshot Camera]{DEDEDE}\nAvailable Commands: {3479E3}/mugshot{DEDEDE}", 0x3479E3FF, SD_MUG_CAM_POS[0], SD_MUG_CAM_POS[1], SD_MUG_CAM_POS[2] + 0.33, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0); 

    Streamer_SetIntData(STREAMER_TYPE_OBJECT, SD_CameraObject, E_STREAMER_WORLD_ID, 2319);
    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, SD_CameraLabel, E_STREAMER_WORLD_ID, 2319);
}

static DestroyCamera()
{
    if (IsValidDynamicObject(PD_CameraObject)) DestroyDynamicObject(PD_CameraObject);
    if (IsValidDynamic3DTextLabel(PD_CameraLabel)) DestroyDynamic3DTextLabel(PD_CameraLabel);

    if (IsValidDynamicObject(SD_CameraObject)) DestroyDynamicObject(SD_CameraObject);
    if (IsValidDynamic3DTextLabel(SD_CameraLabel)) DestroyDynamic3DTextLabel(SD_CameraLabel);

    PD_CameraObject = INVALID_STREAMER_ID;
    PD_CameraLabel = DynamicText3D:INVALID_STREAMER_ID;

    SD_CameraObject = INVALID_STREAMER_ID;
    SD_CameraLabel = DynamicText3D:INVALID_STREAMER_ID;
}

static RefreshCamera()
{
    DestroyCamera();
    CreateCamera();
}

static DoesCameraExist()
{
    return IsValidDynamicObject(PD_CameraObject) && IsValidDynamicObject(SD_CameraObject);
}

IsPlayerAtMugshotPos(playerid)
{
    return IsPlayerInRangeOfPoint(playerid, 7.5, PD_MUGSHOT_X, PD_MUGSHOT_Y, PD_MUGSHOT_Z) || IsPlayerInRangeOfPoint(playerid, 7.5, SD_MUGSHOT_X, SD_MUGSHOT_Y, SD_MUGSHOT_Z);
}

hook OnGameModeInit()
{
    CreateCamera();
    return 1;
}

hook OnPlayerUpdate(playerid)
{ 
    if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT])
    {
        if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 1)
        {
            ApplyAnimation(playerid, "CAMERA", "picstnd_in", 4.0, 0, 0, 0, 0, 0, 1);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 2;
        }
        else if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 2 && GetPlayerAnimationIndex(playerid) != 245)
        {
            RemovePlayerAttachedObject(playerid, 6);
            SetPlayerAttachedObject(playerid, 6, 18670, 6, 0.1, -0.05, -1.5, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

            ApplyAnimation(playerid, "CAMERA", "picstnd_take", 4.0, 0, 0, 0, 0, 0, 1);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 3;
        }
        else if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 3)
        {
            ApplyAnimation(playerid, "CAMERA", "picstnd_take", 4.0, 0, 0, 0, 0, 0, 1);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 4;
        }
        else if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 4 && GetPlayerAnimationIndex(playerid) != 247)
        {
            ApplyAnimation(playerid, "CAMERA", "picstnd_out", 4.0, 0, 0, 0, 0, 0, 1);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 5;
        }
        else if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 5)
        {
            ApplyAnimation(playerid, "CAMERA", "picstnd_out", 4.0, 0, 0, 0, 0, 0, 1);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 6;
        }
        else if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] == 6 && GetPlayerAnimationIndex(playerid) != 246)
        {
            RemovePlayerAttachedObject(playerid, 6);
            TogglePlayerControllable(playerid, 1);
            RefreshCamera();
            RemovePlayerCustomWeapon(playerid, 63);
            SetPlayerArmedWeapon(playerid, 0);
            PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 0;
            PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT] = false;
            ProxDetectorAutoMe(playerid, 20.0, "puts the camera back on the desk.", true);
        }
    }

    return 1;
}

hook SOLS_OnPlayerPhoto(playerid, targetid)
{
    if (PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT])
    {
        if (IsPlayerConnected(targetid) && PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET] == targetid)
        {
            new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
            new faction_enum_id = Faction_GetEnumID( factionid ); 

            Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s photographed (%d) %s for their mugshot. }", 
                Faction[faction_enum_id][E_FACTION_ABBREV], playerid, ReturnPlayerNameData(playerid, 0, true), targetid, ReturnPlayerNameData(targetid, 0, true)), faction_enum_id, false ) ;

            PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT] = false;
            PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET] = INVALID_PLAYER_ID;
            Character[targetid][E_CHARACTER_LAST_MUGSHOT] = gettime();

            new query[256];
            mysql_format(mysql, query, sizeof(query), "UPDATE `characters` SET `player_last_mugshot` = %d WHERE `player_id` = %d", Character[targetid][E_CHARACTER_LAST_MUGSHOT], Character [targetid][E_CHARACTER_ID]);
            mysql_tquery(mysql, query);

            SendClientMessage(targetid, COLOR_ERROR, sprintf("Your arrest mugshot on file was updated by (%d) %s.", playerid, ReturnPlayerNameData(playerid, 0, true)));
            //ProxDetectorAutoMe(playerid, 20.0, sprintf("takes a mugshot of %s.", ReturnPlayerNameData(targetid, 0, true)));
        }
        else
        {
            SendClientMessage(playerid, COLOR_ERROR, sprintf("The mugshot of %s (%d) wasn't taken: move further back from them and try again.", ReturnPlayerNameData(PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET], 0, true), PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET]));
        }

        TogglePlayerControllable(playerid, 0);
        ApplyAnimation(playerid, "CAMERA", "picstnd_in", 2.0, 0, 0, 0, 0, 0, 1);
        PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 1;
    }

    return 1;
}

CMD:refreshmugshot(playerid)
{
    if (!IsPlayerInPoliceFaction(playerid, true))
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be on duty as a police officer to do this." ) ;
    }

    if (!IsPlayerAtMugshotPos(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be at the mugshot position." ) ;
	}

    if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] || PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT])
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You are already taking a mugshot, finish it first." ) ;
    }

    RefreshCamera();
    new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
    new faction_enum_id = Faction_GetEnumID( factionid ); 

    Faction_SendMessage(factionid, sprintf("{ [%s] (%d) %s refreshed the mugshot camera. }", 
        Faction[faction_enum_id][E_FACTION_ABBREV], playerid, ReturnPlayerNameData(playerid, 0, true)), faction_enum_id, false ) ;

    return 1;
}

CMD:mugshot(playerid, params[])
{
	new giveplayerid;

    if (PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT])
    {
        PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT] = 0;
        PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT] = false;
        PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET] = INVALID_PLAYER_ID;
     
        if ( !PlayerVar [ playerid ] [ E_PLAYER_SAVE_CAMERA ] ) {
            RemovePlayerCustomWeapon(playerid, 63);
        }

        PlayerVar [ playerid ] [ E_PLAYER_SAVE_CAMERA ] = false ;
        SetPlayerArmedWeapon(playerid, 0);
        RefreshCamera();

        return SendClientMessage(playerid, COLOR_ERROR, "You cancelled taking the mugshot.");
    }
	
	if (sscanf(params, "k<player>", giveplayerid) || !IsPlayerConnected(giveplayerid) || giveplayerid == playerid)
	    return SendServerMessage( playerid, COLOR_RED, "Usage", "DEDEDE", "/mugshot [player]");

    if (!IsPlayerInPoliceFaction(playerid, true) && !IsPlayerInDEAFaction(playerid, true))
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be on duty as a police officer to do this." ) ;
    }

    if (!IsPlayerAtMugshotPos(playerid) || !IsPlayerAtMugshotPos(giveplayerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Both you and the other player must be at the mugshot position." ) ;
	}

    if (PlayerVar[playerid][E_PLAYER_TAKEN_MUGSHOT])
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You are already taking a mugshot, finish it first." ) ;
    }

    if (!DoesCameraExist())
    {
        return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Someone is already using the mugshot camera (if not then use /refreshmugshot)" ) ;
    }

    DestroyCamera();
    ProxDetectorAutoMe(playerid, 20.0, "picks up the camera from the desk.", true);
    SendClientMessage(playerid, COLOR_BLUE, sprintf("Use the camera to take a picture of %s (%d) for their mugshot.", ReturnPlayerNameData(giveplayerid, 0, true), giveplayerid));

	PlayerVar[playerid][E_PLAYER_TAKING_MUGSHOT] = true;
    PlayerVar[playerid][E_PLAYER_MUGSHOT_TARGET] = giveplayerid;

    PreloadAnimLib(playerid, "CAMERA");
    PreloadAnimLib(giveplayerid, "CAMERA");
    
    // Give camera

    if ( ! DoesPlayerHaveWeapon(playerid, WEAPON_CAMERA ) ) {

        GiveCustomWeapon(playerid, 63, 2);
        SOLS_SetPlayerAmmo(playerid, GetCustomWeaponGunId(63), 2);
    }

    else {
        PlayerVar [ playerid ] [ E_PLAYER_SAVE_CAMERA ] = true ;
    }

	return true;
}
