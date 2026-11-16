DamageArms ( playerid, Float:health ) {

    if ( ! PlayerDamage [ playerid ] [ DAMAGE_ARMS ] && health < 66.0 )
    { 

        // SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  "You've been hit in your arm! Shooting skills reduced." );

        //Weapon_SetSkillLevel(playerid, 500);
        PlayerDamage [ playerid ] [ DAMAGE_ARMS ] = true ;
        SetPlayerDrunkLevel(playerid, 2500);
        DisplayDamageUpdate(playerid, "Arms");
        // WriteLog ( playerid, "injury", sprintf("%s injured their arms.",ReturnPlayerNameData(playerid) ) );
        //return true ;
    }

    return true ;
}

DamageLegs ( playerid, Float:health ) {

    if ( ! PlayerDamage [ playerid ] [ DAMAGE_LEGS ] && health < 66.0 ) 
    {
        PlayerDamage [ playerid ] [ DAMAGE_LEGS ] = true ;
        PlayerVar[playerid][E_PLAYER_DMG_FELL_AT] = 0;

        if (PlayerVar[playerid][E_PLAYER_SPRINTING])
        {
            ApplyAnimation(playerid, "ped", "fall_collapse", 4.1, 0, 1, 1, 0, 0, 1);
        }

        DisplayDamageUpdate(playerid, "Legs");

        // SendServerMessage( playerid, COLOR_INJURY, "Injury", "A3A3A3",  "Your legs have been injured. You may experience trouble walking." );
        // WriteLog ( playerid, "injury", sprintf("%s injured their legs.",ReturnPlayerNameData(playerid) ) );

        //defer LegDamageHandler(playerid);
        //return true ;
    }

    return true ;
}

#include <YSI_Coding\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED(KEY_JUMP) && !IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid, "CUFFED") == 1)
    {
        ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.1, 0, 1, 1, 0, 0);
    }

    /*
    if (PRESSED(KEY_AIM) && GetPlayerWeapon(playerid) >= 22)
    {
        PlayerVar[playerid][E_PLAYER_PRESSED_AIM] = true;
    }
    else if (RELEASED(KEY_AIM))
    {
        PlayerVar[playerid][E_PLAYER_PRESSED_AIM] = false;
    }
    */

    if (PRESSED(KEY_SPRINT))
    {
        PlayerVar[playerid][E_PLAYER_RELEASED_SPRINT] = false;
        PlayerVar[playerid][E_PLAYER_PRESSED_SPRINT] = true;

        if (PlayerVar[playerid][E_PLAYER_SPRINTING] && PlayerDamage[playerid][DAMAGE_LEGS])
        {
            ApplyAnimation(playerid, "ped", "fall_collapse", 4.1, 0, 1, 1, 0, 0, 1);
        }
    }
    else if (RELEASED(KEY_SPRINT))
    {
        PlayerVar[playerid][E_PLAYER_RELEASED_SPRINT] = true;
        PlayerVar[playerid][E_PLAYER_RELEASED_SPRINT_AT] = gettime();
    }

    return 1;
}

hook OnPlayerUpdate(playerid)
{   
    /*
    if (PlayerVar[playerid][E_PLAYER_PRESSED_AIM] && PlayerDamage[playerid][DAMAGE_ARMS])
    {
        SetPlayerDrunkLevel(playerid, 2250);
    }
    */

    if (PlayerVar[playerid][E_PLAYER_RELEASED_SPRINT] && PlayerVar[playerid][E_PLAYER_SPRINTING])
    {
        if (gettime() - PlayerVar[playerid][E_PLAYER_RELEASED_SPRINT_AT] > 1)
        {
            // SendClientMessage(playerid, -1, sprintf("No longer sprinting: %.02f", GetPlayerSpeed(playerid)));
            PlayerVar[playerid][E_PLAYER_SPRINTING] = false;
        }
    }

    if (PlayerVar[playerid][E_PLAYER_PRESSED_SPRINT] && !PlayerVar[playerid][E_PLAYER_SPRINTING])
    {
        if (IsPlayerSprinting(playerid))
        {
            PlayerVar[playerid][E_PLAYER_SPRINT_SPEED] = GetPlayerSpeed(playerid) - 0.01;
            PlayerVar[playerid][E_PLAYER_SPRINTING] = true;
            PlayerVar[playerid][E_PLAYER_PRESSED_SPRINT] = false;

            if (PlayerDamage[playerid][DAMAGE_LEGS])
            {
                ApplyAnimation(playerid, "ped", "fall_collapse", 4.1, 0, 1, 1, 0, 0, 1);
            }

            // SendClientMessage(playerid, -1, sprintf("Sprint speed: %.02f", PlayerVar[playerid][E_PLAYER_SPRINT_SPEED]));
        }
    }

    return 1;
}

/*
CMD:hurtmylegs(playerid)
{
    if (!PlayerDamage[playerid][DAMAGE_LEGS])
    {
        DamageLegs(playerid, 50.0);
    }
    else
    {
        PlayerDamage[playerid][DAMAGE_LEGS] = false;
    }
   
    return true;
}

CMD:hurtmyarms(playerid)
{
    if (!PlayerDamage[playerid][DAMAGE_ARMS])
    {
        DamageArms(playerid, 50.0);
    }
    else
    {
        PlayerDamage[playerid][DAMAGE_ARMS] = false;
    }

    return true;
}
*/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


IsPlayerRunning ( playerid ) {
    new keys, ud, lr ;
    GetPlayerKeys ( playerid, keys, ud, lr ) ;

    if ( keys & KEY_WALK )
        return false ;

    if ( ud == 0 && lr == 0 )
        return false ;

    return true ;
}

// Only works for a split second after they start sprinting
stock IsPlayerSprinting(playerid)
{
    new index = GetPlayerAnimationIndex(playerid);
    return (index >= 1246 && index <= 1248) || index == 1279 || index == 1458 || index == 462 || index == 910;
}

stock IsPlayerFalling ( playerid ) {
    new index = GetPlayerAnimationIndex ( playerid ) ;

    if ( index >= 958 && index <= 979 || index == 1130 || index == 1195 || index == 1132 ) return true ;

    return false ;
}

static DisplayDamageUpdate(playerid, dmg_type[]) 
{
    if (PlayerVar[playerid][E_PLAYER_DAMAGE_SHOWN])
    {
        return false;
    }

	TextDrawShowForPlayer(playerid, E_GYM_PROGRESS_GUI);
	PlayerTextDrawSetString(playerid, E_GYM_PROGRESS_PGUI[playerid][1], "mdl-30000:-0"); 
    PlayerTextDrawSetString( playerid, E_GYM_PROGRESS_PGUI[playerid][0], dmg_type); 
    PlayerTextDrawSetString( playerid, E_GYM_PROGRESS_PGUI[playerid][2], "~r~~h~-" ); 

	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][0] ); 
	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][1] ); 
	PlayerTextDrawShow( playerid, E_GYM_PROGRESS_PGUI[playerid][2] ); 

    PlayerVar[playerid][E_PLAYER_DAMAGE_SHOWN] = true;
	defer HideDamageUpdate(playerid);
    return true;
}

timer HideDamageUpdate[3500](playerid) 
{
    TextDrawHideForPlayer(playerid, E_GYM_PROGRESS_GUI);
    PlayerTextDrawHide(playerid, E_GYM_PROGRESS_PGUI[playerid][0]); 
    PlayerTextDrawHide(playerid, E_GYM_PROGRESS_PGUI[playerid][1]); 
    PlayerTextDrawHide(playerid, E_GYM_PROGRESS_PGUI[playerid][2]); 

    PlayerVar[playerid][E_PLAYER_DAMAGE_SHOWN] = false;

	return true ;
}