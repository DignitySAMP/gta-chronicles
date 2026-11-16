//------------------------------------------------------------------------------
// Camera flash and callback
// Written by Sporky (www.github.com/sporkyspork) for SOLS

#include <YSI_Coding\y_hooks>

static enum E_USEABLE_CAMERA_VARS
{
    E_USEABLE_CAMERA_ACTIVE,
    bool:E_USEABLE_CAMERA_FIRED,
    bool:E_USEABLE_CAMERA_FLASHED,
    E_USEABLE_CAMERA_AMMO,
    E_USEABLE_CAMERA_AMMO_TEMP,
    E_USEABLE_CAMERA_AIM_MDOE
}

static UseableCamera [ MAX_PLAYERS ] [ E_USEABLE_CAMERA_VARS ] ;

static ClearVars(playerid)
{
 	new cvar_clear[E_USEABLE_CAMERA_VARS];
	UseableCamera[playerid] = cvar_clear;
}

hook OnPlayerConnect(playerid)
{
    EnablePlayerCameraTarget(playerid, 0);
	ClearVars(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_FIRE))
	{
		new weapon = GetPlayerWeapon(playerid);
		new ammo = UseableCamera[playerid][E_USEABLE_CAMERA_AMMO_TEMP];
		new aim = GetPlayerCameraMode(playerid);

		if (weapon == WEAPON_CAMERA)
		{	
			if (aim == 46 && !UseableCamera[playerid][E_USEABLE_CAMERA_FIRED])
			{
                UseableCamera[playerid][E_USEABLE_CAMERA_FLASHED] = false;
			    UseableCamera[playerid][E_USEABLE_CAMERA_FIRED] = true;
			    UseableCamera[playerid][E_USEABLE_CAMERA_AMMO] = ammo;
			}
		}
	}

	return 1;
}

forward SOLS_OnPlayerPhoto(playerid, targetid);
public SOLS_OnPlayerPhoto(playerid, targetid)
{
    // printf("SOLS_OnPlayerPhoto(%d, %d)", playerid, targetid);
    // Just hook this
    return 1;
}

hook OnPlayerUpdate(playerid)
{  
    new weapon = GetPlayerWeapon(playerid);
    new ammo = GetPlayerAmmo(playerid);
    new aim = GetPlayerCameraMode(playerid);
    
    if (UseableCamera[playerid][E_USEABLE_CAMERA_AIM_MDOE] != aim)
    {
        if (aim == 46)
        {
            EnablePlayerCameraTarget(playerid, 1);
        }
        else if (UseableCamera[playerid][E_USEABLE_CAMERA_AIM_MDOE] == 46)
        {
            EnablePlayerCameraTarget(playerid, 0);
        }
        
        UseableCamera[playerid][E_USEABLE_CAMERA_AIM_MDOE] = aim;
    }

    UseableCamera[playerid][E_USEABLE_CAMERA_AMMO_TEMP] = ammo;
	
	if (UseableCamera[playerid][E_USEABLE_CAMERA_FIRED])
	{
	    if (weapon == WEAPON_CAMERA)
		{
            if (ammo != UseableCamera[playerid][E_USEABLE_CAMERA_AMMO])
            {
                new target = GetPlayerCameraTargetPlayer(playerid);

				if (IsPlayerConnected(target))
				{
					//SendClientMessage(playerid, -1, sprintf("You took a picture of %s", ReturnPlayerNameData(target, 0, true)));
                    //ShowPlayerFooter(playerid, sprintf("You took a picture of ~b~~h~%s~w~.", ReturnPlayerNameData(target, 0, true)));
				}
				
                CallLocalFunction("SOLS_OnPlayerPhoto", "dd", playerid, target);
                RemovePlayerAttachedObject(playerid, 6);
			    SetPlayerAttachedObject(playerid, 6, 18670, 6, 0.1, -0.05, -1.5, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

                UseableCamera[playerid][E_USEABLE_CAMERA_FIRED] = false;
                UseableCamera[playerid][E_USEABLE_CAMERA_FLASHED] = true;
            }
            
            // Waiting...
		}
		else
		{
		    UseableCamera[playerid][E_USEABLE_CAMERA_FIRED] = false;
		}
	}
    else if (UseableCamera[playerid][E_USEABLE_CAMERA_FLASHED] && weapon != WEAPON_CAMERA)
    {
        RemovePlayerAttachedObject(playerid, 6);
        UseableCamera[playerid][E_USEABLE_CAMERA_FLASHED] = false;
    }

    return 1;
}