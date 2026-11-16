
stock FW_MainCreate(playerid, firework)
{
	if (IsPlayerNPC(playerid) || !IsPlayerConnected(playerid)) return 0;
	
	if (GetPlayerInterior(playerid) != 0) 
	{
		SendClientMessage(playerid, MSG_WARNING, "You can't light fireworks inside!"); 
		return 0;
	}
	
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		switch(firework)
		{
			case FW_UNKNOWN:
			{
				SendClientMessage(playerid, MSG_WARNING, "Fireworks couldn't be created!");
				return 0;
			}
			case FW_FOUNTAIN, FW_ROCKET, FW_SPLITTER, FW_UMBRELLA, FW_CAKE:
			{
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 1.0, 0, 0, 0, 1, 0, 1);
				SetTimerEx("FW_MainCreateEnd", DEF_ANIM_TIME, false, "ii", playerid, firework);
				return 1;
			}
		}
	}
	else SendClientMessage(playerid, MSG_WARNING, "You have to be on foot to place fireworks down!");
	return 0;
}

forward FW_MainCreateEnd(playerid, firework);
public FW_MainCreateEnd(playerid, firework)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	for(new fw; fw != MAX_FIREWORK; fw++)
	{
		if (FW_Owner[fw] == -1)
		{
			new pName[MAX_PLAYER_NAME];
			SetPVarInt(playerid, "FireworkPlaced", 1);
			GetPlayerName(playerid, pName, sizeof(pName));
			TogglePlayerControllable(playerid, 1);
			ClearAnimations(playerid);
			new Float: plX, Float: plY, Float: fwX, Float: fwY, Float: Z;
			GetPlayerPos(playerid, plX, plY, Z);
			GetXYInFrontOfPlayer(playerid, fwX, fwY, 1.0);
			SetPVarInt(playerid, "FW_Pending", 1);
			new Float: R = GetAngleToPos(plX, plY, fwX, fwY);
			switch(firework)
			{
				case FW_UNKNOWN:
				{
					SendClientMessage(playerid, MSG_WARNING, "Fireworks couldn't be created!");
					return 0;
				}
				case FW_FOUNTAIN:
				{
					FW_FountainCreate(playerid, fw, fwX, fwY, Z, R, GetPVarInt(playerid, "FW_Color1"), GetPVarInt(playerid, "FW_Color2"));
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					return 1;
				}
				case FW_ROCKET: 
				{
					FW_RocketCreate(playerid, fw, fwX, fwY, Z, R, GetPVarInt(playerid, "FW_Color1"), GetPVarInt(playerid, "FW_Color2"));
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					return 1;
				}
				case FW_SPLITTER:
				{
					FW_SplitterCreate(playerid, fw, fwX, fwY, Z, R, GetPVarInt(playerid, "FW_Color1"), GetPVarInt(playerid, "FW_Color2"));
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					return 1;
				}
				case FW_UMBRELLA:
				{
					FW_UmbrelllaCreate(playerid, fw, fwX, fwY, Z, R, GetPVarInt(playerid, "FW_Color1"), GetPVarInt(playerid, "FW_Color2"));
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					return 1;
				}
				case FW_CAKE: 
				{
					FW_CakeCreate(playerid, fw, fwX, fwY, Z, R, GetPVarInt(playerid, "FW_Color1"), GetPVarInt(playerid, "FW_Color2"));
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					return 1;
				}
				default:
				{
					SendClientMessage(playerid, MSG_WARNING, "Fireworks couldn't be created!");
					return 0;
				}
			}
		}
	}
	SendClientMessage(playerid, MSG_WARNING, "Server limit is reached! Light some before you place more.");
	return 0;
}

forward FW_MainFire(playerid);
public FW_MainFire(playerid)
{
	for (new fw; fw != MAX_FIREWORK; fw++)
	{
		if (FW_Owner[fw] == playerid && FW_Stage[fw] == 1)
		{
			switch (FW_Type[fw])
			{
				case FW_UNKNOWN:
				{
					FW_Owner[fw] = -1;
					//SendClientMessage(playerid, MSG_WARNING, "Fireworks couldn't be lighted!");
					return 0;
				}
				case FW_FOUNTAIN: 
				{
					FW_Lifetime[fw] = FOUNTAIN_LIFE;
					FW_Stage[fw] = 2;
					new Float: fwX, Float: fwY, Float: fwZ;
					GetDynamicObjectPos(FW_Object[fw][0][0], fwX, fwY, fwZ);
					
					for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
					{
						if(IsPlayerInRangeOfPoint(i,50, fwX, fwY, fwZ))
						{
							PlayerPlaySound(i, 1134, 0, 0, 0);
						}
					}
					
					SetTimerEx("FW_FountainFire", FOUNTAIN_DELAY, false, "ii", fw, 0);
					return 1;
				}
				case FW_ROCKET: 
				{
					FW_Stage[fw] = 2;
					new Float: XYZ[3];
					GetDynamicObjectPos(FW_Object[fw][0][0], XYZ[0], XYZ[1], XYZ[2]);
					FW_Object[fw][3][0] = CreateDynamicObject(18727, XYZ[0], XYZ[1], XYZ[2], 0.0, 0.0, 0.0, 150);
					SetTimerEx("FW_RocketFire", ROCKET_DELAY, false, "i", fw);
					return 1;
				}
				case FW_SPLITTER:
				{
					FW_Stage[fw] = 2;
					new Float: XYZ[3];
					GetDynamicObjectPos(FW_Object[fw][0][0], XYZ[0], XYZ[1], XYZ[2]);
					FW_Object[fw][3][0] = CreateDynamicObject(18727, XYZ[0], XYZ[1], XYZ[2], 0.0, 0.0, 0.0, 150);
					SetTimerEx("FW_SplitterFire", SPLITTER_DELAY, false, "i", fw);
					return 1;
				}
				case FW_UMBRELLA:
				{
					FW_Stage[fw] = 2;
					new Float: XYZ[3];
					GetDynamicObjectPos(FW_Object[fw][0][0], XYZ[0], XYZ[1], XYZ[2]);
					FW_Object[fw][3][0] = CreateDynamicObject(18727, XYZ[0], XYZ[1], XYZ[2], 0.0, 0.0, 0.0, 150);
					SetTimerEx("FW_UmbrelllaFire", UMBRELLA_DELAY, false, "i", fw);
					return 1;
				}
				case FW_CAKE:
				{
					FW_Stage[fw] = 2;
					SetTimerEx("FW_CakeFire", CAKE_DELAY, false, "ii", fw, 1);
					return 1;
				}
			}
			return 1;
		}
	}
	KillTimer(GetPVarInt(playerid, "TimerMainFire"));
	DeletePVar(playerid, "TimerMainFire");
	return 0;
}

forward FW_MainDestroy(fw);
public FW_MainDestroy(fw)
{
	FW_Owner[fw] = -1;
	FW_Type[fw] = FW_UNKNOWN;
	FW_Lifetime[fw] = 0;
	FW_Stage[fw] = 0;
	FW_Colors[fw][0] = 0;
	FW_Colors[fw][1] = 0;
	for (new fo; fo != MAX_FWOBJECT; fo++)
	{
		if (FW_Object[fw][fo][0] != 0)
		{
			if (IsValidDynamicObject(FW_Object[fw][fo][0])) {DestroyDynamicObject(FW_Object[fw][fo][0]);}
			FW_Object[fw][fo][0] = 0;
			FW_Object[fw][fo][1] = 0;
		}
	}
	return 1;
}