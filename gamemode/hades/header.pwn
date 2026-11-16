#include "hades/emmet_refunds.pwn"

#if defined PHONE_V2_DEV
	#include "hades/phone/header.pwn"
#endif

#include <YSI_Coding\y_hooks>

static enum E_ENTERABLE_TYPE
{
	E_ENTERABLE_TYPE_NONE,
	E_ENTERABLE_TYPE_PASSPOINT,
	E_ENTERABLE_TYPE_GATE,
	E_ENTERABLE_TYPE_PROPERTY
}

static enum E_ENTERABLE
{
	E_ENTERABLE_ID,
	E_ENTERABLE_SUBTYPE,
	Float:E_ENTERABLE_X,
	Float:E_ENTERABLE_Y,
	Float:E_ENTERABLE_Z
}

static Enterable[E_ENTERABLE_TYPE][E_ENTERABLE];

static GetEnterablePos(E_ENTERABLE_TYPE:type, id, &Float:x, &Float:y, &Float:z)
{
	if (type == E_ENTERABLE_TYPE_PASSPOINT)
	{
		if (Enterable[type][E_ENTERABLE_SUBTYPE] == 0) Passpoint_GetPos(id, x, y, z);
		else Passpoint_GetLinkPos(id, x, y, z);
	}
	else if (type == E_ENTERABLE_TYPE_GATE)
	{
		Gate_GetPos(id, x, y, z);
	}
	else if (type == E_ENTERABLE_TYPE_PROPERTY)
	{
		if (Enterable[type][E_ENTERABLE_SUBTYPE] == 0) Property_GetOutsidePos(id, x, y, z);
		else Property_GetInsidePos(id, x, y, z);
	}
}

AddEnterableForConsideration(E_ENTERABLE_TYPE:type, id, subtype)
{	
	Enterable[type][E_ENTERABLE_ID] = id;
	if (id == -1) return;

	Enterable[type][E_ENTERABLE_SUBTYPE] = subtype;
	GetEnterablePos(type, id, Enterable[type][E_ENTERABLE_X], Enterable[type][E_ENTERABLE_Y], Enterable[type][E_ENTERABLE_Z]);
}

E_ENTERABLE_TYPE:GetClosestEnterable(playerid, Float:radius=5.0)
{
	// Refresh the cache first
	new var_clear[E_ENTERABLE_TYPE][E_ENTERABLE];
	Enterable = var_clear;

	// Loop all types and populate the position data/distances
	for (new E_ENTERABLE_TYPE:i; i < E_ENTERABLE_TYPE; i ++)
	{
		new id = -1, subtype = 0;

		switch (i)
		{
			case E_ENTERABLE_TYPE_PASSPOINT:
			{
				GetClosestPasspoint(playerid, radius, id, subtype);
			}
			case E_ENTERABLE_TYPE_GATE:
			{
				id = Gate_GetClosestEntity(playerid, radius);
			}
			case E_ENTERABLE_TYPE_PROPERTY:
			{
				GetClosestProperty(playerid, radius, id, subtype);
			}
		}

		AddEnterableForConsideration(i, id, subtype);
	}

	// Calculate closest
	new E_ENTERABLE_TYPE:closest = E_ENTERABLE_TYPE_NONE;
    new Float:current;
    new Float:last = radius;

	for (new E_ENTERABLE_TYPE:i; i < E_ENTERABLE_TYPE; i ++)
	{
		if (i == E_ENTERABLE_TYPE_NONE) continue;
		if (Enterable[i][E_ENTERABLE_ID] == -1) continue;

		current = GetPlayerDistanceFromPoint(playerid, Enterable[i][E_ENTERABLE_X], Enterable[i][E_ENTERABLE_Y], Enterable[i][E_ENTERABLE_Z]);
		
		if (current < last)
		{
			closest = i;
			last = current;
		}
	}

	return closest;
}

PlayerUseClosestEnterable(playerid, bool:feedback=false)
{
	if (IsPlayerIncapacitated(playerid)) return false;
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return false;
	if (PlayerVar[playerid][E_PLAYER_IS_FADING]) return false;

	new E_ENTERABLE_TYPE:closest = GetClosestEnterable(playerid, 2.5);
	if (closest == E_ENTERABLE_TYPE_NONE)
	{
		if (feedback) return SendClientMessage(playerid, COLOR_ERROR, "Couldn't find anything to enter/open/use.");
		return false;
	}
	
	new id = Enterable[closest][E_ENTERABLE_ID];
	new type = Enterable[closest][E_ENTERABLE_SUBTYPE];

	switch (closest)
	{
		case E_ENTERABLE_TYPE_PASSPOINT:
		{
			PlayerUsePasspoint(playerid, id, type, feedback);
		}
		case E_ENTERABLE_TYPE_GATE:
		{
			PlayerUseGate(playerid, id, feedback);
		}
		case E_ENTERABLE_TYPE_PROPERTY:
		{
			if (type == 0) Property_Enter(playerid, id, feedback);
			else if (type == 1) Property_Exit(playerid, id, feedback);
		}
	}

	return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	/*
		CopaCabana suggestion:
		1. Universal /lock (or hotkey, could be L) to lock/unlock cars, houses, businesses.
		2. Hotkey (could be Y) to enter/exit properties instead of typing the cmd.

	*/

	if ( PlayerVar [ playerid ] [ E_PLAYER_HOTKEY_CD ] < gettime() ) 
	{
		/*
		if ( newkeys & KEY_CTRL_BACK ) 
		{
			if ( GetPlayerState(playerid) == PLAYER_STATE_ONFOOT ) 
			{
				SOLS_OnPropertyLock(playerid, false);
			}

			if ( GetPlayerState(playerid) == PLAYER_STATE_ONFOOT || GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER ) 
			{
				SOLS_OnCarLock(playerid, false);
			}
		}

		// Spooky: H doesn't work in cars (we will need to either use Y, N or 2 for this)
		// I made a universal /lock for now as a shortcut that people can use for anything
		*/

		// makes sure people don't enter when brawling since we check if aim key is held
		if ( PRESSED(KEY_SECONDARY_ATTACK) && !HOLDING(KEY_AIM) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) 
		{
			// Spooky: massively improved this to support everything ( 2 hours of work :( )
			PlayerUseClosestEnterable(playerid);

			// 2 second cooldown to reduce function spam.
			PlayerVar [ playerid ] [ E_PLAYER_HOTKEY_CD ] = gettime() + 1; 
		}
		else if (PRESSED(KEY_AIM))
		{
			// Spooky: also fixed this
			if ( GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE && PlayerVar [ playerid ] [ E_PLAYER_LOOPING_ANIM ] ) 
			{
				return cmd_sa(playerid, "");
			}

			// 2 second cooldown to reduce function spam.
			PlayerVar [ playerid ] [ E_PLAYER_HOTKEY_CD ] = gettime() + 1; 
		}
		else if (PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if (vehicleid && vehicleid != INVALID_VEHICLE_ID && GetVehicleSpeedSOLS(vehicleid) < 5.0)
			{
				// Spooky: this is a shortcut (H) for /gate for people in vehicles
				new gate_enum_id = Gate_GetClosestEntity(playerid);
				if (gate_enum_id != INVALID_GATE_ID)
				{
					PlayerUseGate(playerid, gate_enum_id, false);
				}
			}

			// 2 second cooldown to reduce function spam.
			PlayerVar [ playerid ] [ E_PLAYER_HOTKEY_CD ] = gettime() + 1; 
		}

		
	}

	return Y_HOOKS_CONTINUE_RETURN_1 ;
}

CMD:lock(playerid)
{
	// Check if they are in a vehicle first, if so only use that
	if (IsPlayerInAnyVehicle(playerid))
	{
		SOLS_PlayerLockCar(playerid, GetPlayerVehicleID(playerid), true);
		return true;
	}

	new vehicleid = GetClosestVehicleEx(playerid, 5.0);
	new prop_enum_id = Property_GetClosestEntity(playerid, 2.5);

	if (vehicleid == -1 || vehicleid == INVALID_VEHICLE_ID) vehicleid = 0;

	// We do the property first since it has a smaller range
	if (prop_enum_id != INVALID_PROPERTY_ID)
	{
		SOLS_PlayerLockProperty(playerid, prop_enum_id, true); // Same function that /proplock calls
		return true;
	}

	if (vehicleid)
	{
		SOLS_PlayerLockCar(playerid, vehicleid, true); // Same function that /carlock calls
		return true;
	}

	return true;
}