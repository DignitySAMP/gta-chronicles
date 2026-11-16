
// FOUNTAIN
stock FW_FountainCreate(playerid, fw, Float: X, Float: Y, Float: Z, Float: R, model1, model2)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	FW_Owner[fw] = playerid;
	FW_Stage[fw] = 1;
	FW_Type[fw] = FW_FOUNTAIN;
	FW_Colors[fw][0] = model1;
	FW_Colors[fw][1] = model2;
	if (FW_Colors[fw][0] == 0) {FW_Colors[fw][0] = 19284;}
	if (FW_Colors[fw][1] == 0) {FW_Colors[fw][1] = 19281;}
	FW_Object[fw][0][0] = CreateDynamicObject(1271, X, Y, Z-0.65, 0.0, 0.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][1][0] = CreateDynamicObject(2203, X, Y, Z-0.4, 0.0, 0.0, R, -1, 0, -1, 100.0);

	UpdateStreamerForAll();
	return 1;
}

forward FW_FountainFire(fw, stage);
public FW_FountainFire(fw, stage)
{
	for (new fo; fo != MAX_FWOBJECT; fo++)
	{
		if (FW_Object[fw][fo][0] == 0)
		{
			new Float: fwX, Float: fwY, Float: fwZ, model;
			GetDynamicObjectPos(FW_Object[fw][0][0], fwX, fwY, fwZ);

			switch(stage)
			{
				case 0: {model = FW_Colors[fw][0]; stage = 1;} 
				case 1: {model = FW_Colors[fw][1]; stage = 0;} 
			}
			FW_Object[fw][fo][0] = CreateDynamicObject(model, (fwX+(float(random(5))/10.0))-0.25, (fwY+(float(random(5))/10.0))-0.25, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
			MoveDynamicObject(FW_Object[fw][fo][0], (fwX+(float(random(80))/10.0))-4.0, (fwY+(float(random(80))/10.0))-4.0, fwZ+(20.0+float(random(15))), 15.0+(float(random(20))/10.0));
			FW_Object[fw][fo][1] = 1;
			UpdateStreamerForAll(); 
			break;
		}
		if (fo == (MAX_FWOBJECT-1)) 
		{
			//SendClientMessageToAll(MSG_WARNING, "ERROR: FIREWORK ENTITIES LIMIT REACHED"); 
			return 0;
		}
	}
	FW_Lifetime[fw] -= FOUNTAIN_DELAY;
	if (FW_Lifetime[fw] > 0) {SetTimerEx("FW_FountainFire", FOUNTAIN_DELAY, false, "ii", fw, stage); return 1;}
	FW_Stage[fw] = 3;
	SetTimerEx("FW_MainDestroy", DEF_STAY_TIME, false, "i", fw);
	return 0;
}

// ROCKET
stock FW_RocketCreate(playerid, fw, Float: X, Float: Y, Float: Z, Float: R, model1, model2)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	FW_Owner[fw] = playerid;
	FW_Stage[fw] = 1;
	FW_Type[fw] = FW_ROCKET;
	FW_Colors[fw][0] = model1;
	FW_Colors[fw][1] = model2;
	if (FW_Colors[fw][0] == 0) {FW_Colors[fw][0] = 19282;}
	if (FW_Colors[fw][1] == 0) {FW_Colors[fw][1] = 19281;}
	FW_Object[fw][0][0] = CreateDynamicObject(1271, X, Y, Z-0.65, 0.0, 0.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][1][0] = CreateDynamicObject(3790, X, Y, Z+0.95, 0.0, 90.0, R, -1, 0, -1, 100.0);

	UpdateStreamerForAll();
	return 1;
}

forward FW_RocketFire(fw);
public FW_RocketFire(fw)
{
	DestroyDynamicObject(FW_Object[fw][3][0]);
	new Float: fwX, Float: fwY, Float: fwZ, Float: R;
	GetDynamicObjectPos(FW_Object[fw][1][0], fwX, fwY, fwZ);

	for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
	{
		if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
		{
			PlayerPlaySound(i, 1095, 0, 0, 0);
		}
	}
	DestroyDynamicObject(FW_Object[fw][1][0]);

	Streamer_GetFloatData(0, FW_Object[fw][0][0], E_STREAMER_R_Z, R);

	FW_Object[fw][1][0] = CreateDynamicObject(3790, fwX, fwY, fwZ+0.95, 0.0, 90.0, R, -1, 0, -1, 300.0);
	FW_Object[fw][2][0] = CreateDynamicObject(345, fwX, fwY, fwZ-1.2, 90.0, 0.0, 0.0, -1, 0, -1, 300.0);
	fwX += (float(random(30))/10);
	fwY += (float(random(30))/10);
	fwZ = fwZ + 40 + float(random(5));
	MoveDynamicObject(FW_Object[fw][1][0], fwX, fwY, fwZ, 18.0);
	MoveDynamicObject(FW_Object[fw][2][0], fwX, fwY, fwZ-1.2, 18.0);
	FW_Object[fw][1][1] = 1;
	FW_Object[fw][2][1] = 2;
	UpdateStreamerForAll();
	SetTimerEx("FW_MainDestroy", DEF_STAY_TIME, false, "i", fw);
	return 0;
}

// SPLITTER
stock FW_SplitterCreate(playerid, fw, Float: X, Float: Y, Float: Z, Float: R, model1, model2)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	FW_Owner[fw] = playerid;
	FW_Stage[fw] = 1;
	FW_Type[fw] = FW_SPLITTER;
	FW_Colors[fw][0] = model1;
	FW_Colors[fw][1] = model2;
	if (FW_Colors[fw][0] == 0) {FW_Colors[fw][0] = 19282;}
	FW_Object[fw][0][0] = CreateDynamicObject(1271, X, Y, Z-0.65, 0.0, 0.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][1][0] = CreateDynamicObject(3786, X, Y, Z+0.95, 0.0, 90.0, R, -1, 0, -1, 100.0);


	UpdateStreamerForAll();
	return 1;
}

forward FW_SplitterFire(fw);
public FW_SplitterFire(fw)
{
	DestroyDynamicObject(FW_Object[fw][3][0]);
	new Float: fwX, Float: fwY, Float: fwZ, Float: R;
	GetDynamicObjectPos(FW_Object[fw][1][0], fwX, fwY, fwZ);
	

	for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
	{
		if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
		{
			PlayerPlaySound(i, 1095, 0, 0, 0);
		}
	}
	
	DestroyDynamicObject(FW_Object[fw][1][0]);
	Streamer_GetFloatData(0, FW_Object[fw][0][0], E_STREAMER_R_Z, R);

	FW_Object[fw][1][0] = CreateDynamicObject(3786, fwX, fwY, fwZ+0.95, 0.0, 90.0, R, -1, 0, -1, 300.0);
	FW_Object[fw][2][0] = CreateDynamicObject(345, fwX, fwY, fwZ-1.2, 90.0, 0.0, 0.0, -1, 0, -1, 300.0);
	fwX += (float(random(30))/10);
	fwY += (float(random(30))/10);
	fwZ = fwZ + 40.0 + float(random(5));
	MoveDynamicObject(FW_Object[fw][1][0], fwX, fwY, fwZ, 18.0);
	MoveDynamicObject(FW_Object[fw][2][0], fwX, fwY, fwZ-1.2, 18.0);
	FW_Object[fw][1][1] = 1;
	FW_Object[fw][2][1] = 3;
	UpdateStreamerForAll();
	SetTimerEx("FW_MainDestroy", DEF_STAY_TIME, false, "i", fw);
	return 0;
}

// Umbrella
stock FW_UmbrelllaCreate(playerid, fw, Float: X, Float: Y, Float: Z, Float: R, model1, model2)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	FW_Owner[fw] = playerid;
	FW_Stage[fw] = 1;
	FW_Type[fw] = FW_UMBRELLA;
	FW_Colors[fw][0] = model1;
	FW_Colors[fw][1] = model2;
	if (FW_Colors[fw][0] == 0) {FW_Colors[fw][0] = 19282;}
	if (FW_Colors[fw][1] == 0) {FW_Colors[fw][1] = 19281;}
	FW_Object[fw][0][0] = CreateDynamicObject(1271, X, Y, Z-0.65, 0.0, 0.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][1][0] = CreateDynamicObject(3790, X, Y, Z+0.95, 0.0, 90.0, R, -1, 0, -1, 100.0);

	
	UpdateStreamerForAll();
	return 1;
}

forward FW_UmbrelllaFire(fw);
public FW_UmbrelllaFire(fw)
{
	DestroyDynamicObject(FW_Object[fw][3][0]);
	new Float: fwX, Float: fwY, Float: fwZ, Float: R;
	GetDynamicObjectPos(FW_Object[fw][1][0], fwX, fwY, fwZ);
	
	for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
	{
		if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
		{
			PlayerPlaySound(i, 1095, 0, 0, 0);
		}
	}
	
	DestroyDynamicObject(FW_Object[fw][1][0]);
	
	Streamer_GetFloatData(0, FW_Object[fw][0][0], E_STREAMER_R_Z, R);

	
	FW_Object[fw][1][0] = CreateDynamicObject(3790, fwX, fwY, fwZ+0.95, 0.0, 90.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][2][0] = CreateDynamicObject(345, fwX, fwY, fwZ-1.2, 90.0, 0.0, 0.0, -1, 0, -1, 300.0);
	fwX += (float(random(30))/10);
	fwY += (float(random(30))/10);
	fwZ = fwZ + 40.0 + float(random(5));
	MoveDynamicObject(FW_Object[fw][1][0], fwX, fwY, fwZ, 18.0);
	MoveDynamicObject(FW_Object[fw][2][0], fwX, fwY, fwZ-1.2, 18.0);
	FW_Object[fw][1][1] = 1;
	FW_Object[fw][2][1] = 2;
	UpdateStreamerForAll();
	SetTimerEx("FW_MainDestroy", DEF_STAY_TIME, false, "i", fw);
	return 0;
}

// CAKE (is a lie! ^_^)
stock FW_CakeCreate(playerid, fw, Float: X, Float: Y, Float: Z, Float: R, model1, model2)
{
	if (!IsPlayerConnected(playerid)) {return 0;}
	FW_Owner[fw] = playerid;
	FW_Stage[fw] = 1;
	FW_Type[fw] = FW_CAKE;
	FW_Colors[fw][0] = model1;
	FW_Colors[fw][1] = model2;
	if (FW_Colors[fw][0] == 0) {FW_Colors[fw][0] = 19282;}
	if (FW_Colors[fw][1] == 0) {FW_Colors[fw][1] = 19281;}
	FW_Object[fw][0][0] = CreateDynamicObject(1271, X, Y, Z-0.65, 0.0, 0.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][1][0] = CreateDynamicObject(2902, X, Y, Z-0.55, 0.0, -45.0-90.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][2][0] = CreateDynamicObject(2902, X, Y, Z-0.5, 0.0, -22.5-90.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][3][0] = CreateDynamicObject(2902, X, Y, Z-0.45, 0.0, 0.0-90.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][4][0] = CreateDynamicObject(2902, X, Y, Z-0.5, 0.0, 22.5-90.0, R, -1, 0, -1, 100.0);
	FW_Object[fw][5][0] = CreateDynamicObject(2902, X, Y, Z-0.55, 0.0, 45.0-90.0, R, -1, 0, -1, 100.0);
	UpdateStreamerForAll();
	return 1;
}

forward FW_CakeFire(fw, stage);
public FW_CakeFire(fw, stage)
{
	new fwTime;
	if (stage != 11)
	{
		for (new fo; fo != MAX_FWOBJECT; fo++)
		{
			if (FW_Object[fw][fo][0] == 0)
			{
				new Float: fwX, Float: fwY, Float: fwZ, Float: fwU, Float: fwR;
				GetDynamicObjectPos(FW_Object[fw][1][0], fwX, fwY, fwZ);
				GetDynamicObjectRot(FW_Object[fw][0][0], fwU, fwU, fwR);
				
				for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
				{
					if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
					{
						PlayerPlaySound(i, 1095, 0, 0, 0);
					}
				}
				
				FW_Object[fw][fo][0] = CreateDynamicObject(FW_Colors[fw][0], fwX, fwY, fwZ-0.5, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
				switch (stage)
				{
					case 1, 10, 12:{GetOffsetPos(fwX, fwY, 30.0, fwR+90); fwZ += 25.0;}
					case 2, 9, 13: {GetOffsetPos(fwX, fwY, 20.0, fwR+90); fwZ += 35.0;}
					case 3, 8, 14: {									  fwZ += 40.0;}
					case 4, 7, 15: {GetOffsetPos(fwX, fwY, 20.0, fwR-90); fwZ += 35.0;}
					case 5, 6, 16: {GetOffsetPos(fwX, fwY, 30.0, fwR-90); fwZ += 25.0;}
				}
				MoveDynamicObject(FW_Object[fw][fo][0], fwX, fwY, fwZ, 25.0);
				FW_Object[fw][fo][1] = 1;
				break;
			}
			if (fo == (MAX_FWOBJECT-1)) 
			{
				SendClientMessageToAll(MSG_WARNING, "ERROR: FIREWORK ENTITIES LIMIT REACHED"); 
				return 0;
			}
		}
		if (FW_Stage[fw] != 2) {return 1;}
		switch (stage)
		{
			case 1..4, 6..9: {fwTime = CAKE_SINGLE_DELAY;}
			case 5, 10: {fwTime = CAKE_BIG_DELAY;}
		}
		UpdateStreamerForAll();
		stage++;
		SetTimerEx("FW_CakeFire", fwTime, false, "ii", fw, stage);
		return 1;
	}
	else
	{
		FW_Stage[fw] = 3;
		FW_CakeFire(fw, 12);
		FW_CakeFire(fw, 13);
		FW_CakeFire(fw, 14);
		FW_CakeFire(fw, 15);
		FW_CakeFire(fw, 16);
		UpdateStreamerForAll();
		SetTimerEx("FW_MainDestroy", DEF_STAY_TIME, false, "i", fw);
		return 0;
	}
}
