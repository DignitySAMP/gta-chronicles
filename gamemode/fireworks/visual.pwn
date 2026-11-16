
public OnDynamicObjectMoved(STREAMER_TAG_OBJECT:objectid)
{
	for (new fw; fw != MAX_FIREWORK; fw++)
	{
		if (FW_Type[fw] != FW_UNKNOWN)
		{
			for (new fo; fo != MAX_FWOBJECT; fo++)
			{
				if (FW_Object[fw][fo][0] == objectid)
				{
					switch(FW_Type[fw])
					{
						case FW_FOUNTAIN:
						{
							switch (FW_Object[fw][fo][1]) 
							{
								case 1:
								{
									new Float: fwX, Float: fwY, Float: fwZ;
									GetDynamicObjectPos(FW_Object[fw][fo][0], fwX, fwY, fwZ);
									MoveDynamicObject(FW_Object[fw][fo][0], fwX, fwY, fwZ-10.0, 2.0+float(random(3)));
									FW_Object[fw][fo][1] = 2;
								}
								case 2: {DestroyDynamicObject(FW_Object[fw][fo][0]); FW_Object[fw][fo][0] = 0; FW_Object[fw][fo][1] = 0;}
							}
							return 1;
						}
						case FW_ROCKET:
						{
							switch (FW_Object[fw][fo][1])
							{
								case 1:
								{
									new Float: fwX, Float: fwY, Float: fwZ, stage;
									for (new prt; prt != ROCKET_DUPLICATES; prt++)
									{
										for (new fo2; fo2 != MAX_FWOBJECT; fo2++)
										{
											if (FW_Object[fw][fo2][0] == 0)
											{
												new model;
												switch (stage)
												{
													case 0: {model = FW_Colors[fw][0]; stage = 1;}
													case 1: {model = FW_Colors[fw][1]; stage = 0;}
												}
												GetDynamicObjectPos(objectid, fwX, fwY, fwZ);
												FW_Object[fw][fo2][0] = CreateDynamicObject(model, fwX, fwY, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
												Get3DRandomDistanceAway(fwX, fwY, fwZ, 15, 30);
												MoveDynamicObject(FW_Object[fw][fo2][0], fwX, fwY, fwZ, 10.0+(float(random(20))/10.0));
												FW_Object[fw][fo2][1] = 2;
												break;
											}
										}
									}
									
									for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
									{
										if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
										{
											PlayerPlaySound(i, 1009, 0, 0, 0);
										}
									}
									
									DestroyDynamicObject(FW_Object[fw][fo][0]);
									FW_Object[fw][fo][0] = 0;
									FW_Object[fw][fo][1] = 0;
									UpdateStreamerForAll();
									return 1;
								}
								case 2: 
								{
									DestroyDynamicObject(FW_Object[fw][fo][0]); 
									FW_Object[fw][fo][0] = 0; 
									FW_Object[fw][fo][1] = 0;
								}
							}
							return 1;
						}
						case FW_SPLITTER:
						{
							switch (FW_Object[fw][fo][1])
							{
								case 1:
								{
									new Float: fwX, Float: fwY, Float: fwZ;
									for (new prt; prt != SPLITTER_DUPLICATE_1; prt++)
									{
										for (new fo2; fo2 != MAX_FWOBJECT; fo2++)
										{
											if (FW_Object[fw][fo2][0] == 0)
											{
												GetDynamicObjectPos(objectid, fwX, fwY, fwZ);
												FW_Object[fw][fo2][0] = CreateDynamicObject(FW_Colors[fw][0], fwX, fwY, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
												Get3DRandomDistanceAway(fwX, fwY, fwZ, 20, 40);
												MoveDynamicObject(FW_Object[fw][fo2][0], fwX, fwY, fwZ, 10.0+(float(random(20))/10.0));
												FW_Object[fw][fo2][1] = 2;
												break;
											}
										}
									}
									
									for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
									{
										if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
										{
											PlayerPlaySound(i, 1009, 0, 0, 0);
										}
									}
									
									DestroyDynamicObject(FW_Object[fw][fo][0]);
									FW_Object[fw][fo][0] = 0;
									FW_Object[fw][fo][1] = 0;
									UpdateStreamerForAll();
									return 1;
								}
								case 2:
								{
									new Float: fwX, Float: fwY, Float: fwZ;
									for (new prt; prt != SPLITTER_DUPLICATE_2; prt++)
									{
										for (new fo2; fo2 != MAX_FWOBJECT; fo2++)
										{
											if (FW_Object[fw][fo2][0] == 0)
											{
												GetDynamicObjectPos(objectid, fwX, fwY, fwZ);
												FW_Object[fw][fo2][0] = CreateDynamicObject(FW_Colors[fw][1], fwX, fwY, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
												Get3DRandomDistanceAway(fwX, fwY, fwZ, 15, 30);
												MoveDynamicObject(FW_Object[fw][fo2][0], (fwX+(float(random(200))/10.0))-10.0, (fwY+(float(random(200))/10.0))-10.0, (fwZ+(float(random(200))/10.0))-10.0, 7.0+(float(random(20))/10.0));
												FW_Object[fw][fo2][1] = 3;
												break;
											}
										}
									}
									
									for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
									{
										if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
										{
											PlayerPlaySound(i, 1009, 0, 0, 0);
										}
									}
									
									DestroyDynamicObject(FW_Object[fw][fo][0]);
									FW_Object[fw][fo][0] = 0;
									FW_Object[fw][fo][1] = 0;
									UpdateStreamerForAll();
									return 1;
								}
								case 3: {DestroyDynamicObject(FW_Object[fw][fo][0]); FW_Object[fw][fo][0] = 0; FW_Object[fw][fo][1] = 0;}
							}
							return 1;
						}
						case FW_UMBRELLA:
						{
							switch (FW_Object[fw][fo][1])
							{
								case 1:
								{
									new Float: fwX, Float: fwY, Float: fwZ, stage;
									for (new prt; prt != UMBRELLA_DUPLICATES; prt++)
									{
										for (new fo2; fo2 != MAX_FWOBJECT; fo2++)
										{
											if (FW_Object[fw][fo2][0] == 0)
											{
												new model;
												switch (stage)
												{
													case 0: {model = FW_Colors[fw][0]; stage = 1;}
													case 1: {model = FW_Colors[fw][1]; stage = 0;}
												}

												GetDynamicObjectPos(objectid, fwX, fwY, fwZ);
												FW_Object[fw][fo2][0] = CreateDynamicObject(model, fwX, fwY, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
												Get2DRandomDistanceAway(fwX, fwY, 25, 40);
												MoveDynamicObject(FW_Object[fw][fo2][0], fwX, fwY, fwZ, 8.0+(float(random(20))/10.0));
												FW_Object[fw][fo2][1] = 2;
												break;
											}
										}
									}
									
									for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
									{
										if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
										{
											PlayerPlaySound(i, 1009, 0, 0, 0);
										}
									}
									
									DestroyDynamicObject(FW_Object[fw][fo][0]);
									FW_Object[fw][fo][0] = 0;
									FW_Object[fw][fo][1] = 0;
									UpdateStreamerForAll();
									return 1;
								}
								case 2: {DestroyDynamicObject(FW_Object[fw][fo][0]); FW_Object[fw][fo][0] = 0; FW_Object[fw][fo][1] = 0;}
							}
							return 1;
						}
						case FW_CAKE: 
						{
							switch (FW_Object[fw][fo][1]) 
							{
								case 1:
								{
									new Float: fwX, Float: fwY, Float: fwZ;
									for (new prt; prt != CAKE_DUPLICATES; prt++)
									{
										for (new fo2; fo2 != MAX_FWOBJECT; fo2++)
										{
											if (FW_Object[fw][fo2][0] == 0)
											{
												GetDynamicObjectPos(objectid, fwX, fwY, fwZ);
												FW_Object[fw][fo2][0] = CreateDynamicObject(FW_Colors[fw][1], fwX, fwY, fwZ, 0.0, 0.0, 0.0, -1, 0, -1, 300.0);
												Get3DRandomDistanceAway(fwX, fwY, fwZ, 25, 40);
												MoveDynamicObject(FW_Object[fw][fo2][0], fwX, fwY, fwZ, 15.0+(float(random(20))/10.0));
												FW_Object[fw][fo2][1] = 2;
												break;
											}
										}
									}
									
									for (new i = 0, mp = GetPlayerPoolSize(); i <= mp; i++)
									{
										if(IsPlayerInRangeOfPoint(i,50,fwX, fwY, fwZ))
										{
											PlayerPlaySound(i, 1009, 0, 0, 0);
										}
									}
									
									DestroyDynamicObject(FW_Object[fw][fo][0]);
									FW_Object[fw][fo][0] = 0;
									FW_Object[fw][fo][1] = 0;
									UpdateStreamerForAll();
									return 1;
								}
								case 2: {DestroyDynamicObject(FW_Object[fw][fo][0]); FW_Object[fw][fo][0] = 0; FW_Object[fw][fo][1] = 0;}
							}
							return 1;
						}
					}
					return 0;
				}
			}
		}
	}
	#if defined fw_OnDynamicObjectMoved
		return fw_OnDynamicObjectMoved(STREAMER_TAG_OBJECT:objectid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDynamicObjectMoved
	#undef OnDynamicObjectMoved
#else
	#define _ALS_OnDynamicObjectMoved
#endif

#define OnDynamicObjectMoved fw_OnDynamicObjectMoved
#if defined fw_OnDynamicObjectMoved
	forward fw_OnDynamicObjectMoved(STREAMER_TAG_OBJECT:objectid);
#endif