public OnPlayerConnect(playerid)
{
	BikeStorage[playerid] = -1;
	DestroyDynamicRaceCP(PlayerDeliveryCP[playerid]);

	PlayerSubmissionText[playerid][0] = CreatePlayerTextDraw(playerid, 519.000000, 135.000000, "items");
	PlayerTextDrawAlignment(playerid, PlayerSubmissionText[playerid][0], 3);
	PlayerTextDrawBackgroundColor(playerid, PlayerSubmissionText[playerid][0], 255);
	PlayerTextDrawFont(playerid, PlayerSubmissionText[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSubmissionText[playerid][0], 0.380000, 1.600000);
	PlayerTextDrawColor(playerid, PlayerSubmissionText[playerid][0], -1278086145);
	PlayerTextDrawSetOutline(playerid, PlayerSubmissionText[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSubmissionText[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSubmissionText[playerid][0], 0);

	PlayerSubmissionText[playerid][1] = CreatePlayerTextDraw(playerid, 604.000000, 150.000000, "~n~0");
	PlayerTextDrawAlignment(playerid, PlayerSubmissionText[playerid][1], 3);
	PlayerTextDrawBackgroundColor(playerid, PlayerSubmissionText[playerid][1], 255);
	PlayerTextDrawFont(playerid, PlayerSubmissionText[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSubmissionText[playerid][1], 0.380000, 1.600000);
	PlayerTextDrawColor(playerid, PlayerSubmissionText[playerid][1], -1278086145);
	PlayerTextDrawSetOutline(playerid, PlayerSubmissionText[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerSubmissionText[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSubmissionText[playerid][1], 0);
	
	#if defined newsp_OnPlayerConnect
		return newsp_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect newsp_OnPlayerConnect
#if defined newsp_OnPlayerConnect
	forward newsp_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	DestroyDynamicRaceCP(PlayerDeliveryCP[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerSubmissionText[playerid][0]);
	PlayerTextDrawDestroy(playerid, PlayerSubmissionText[playerid][1]);

	#if defined newsp_OnPlayerDisconnect
		return newsp_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect newsp_OnPlayerDisconnect
#if defined newsp_OnPlayerDisconnect
	forward newsp_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerEnterDynamicRaceCP(playerid, STREAMER_TAG_RACE_CP checkpointid) {

	if ( checkpointid == PlayerDeliveryCP [ playerid ] ) {

		DestroyDynamicRaceCP(PlayerDeliveryCP[playerid]);
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 256 && oldkeys == 260) //Left
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(IsCourierVehicle(vehicleid)) //in a bike
			{
				if(BikeStorage[playerid] > 0)
				{
					PlayerPlaySound(playerid, 5600, 0.0, 0.0, 0.0);
					BikeStorage[playerid] --;
					new Float:pos[6];
					GetVehicleZAngle(vehicleid, pos[3]);
					GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
					GetVehiclePos(vehicleid, pos[4], pos[5], pos[2]);
					GetXYLeftOfVehicle(vehicleid, pos[0], pos[1], 1.00);
					GetXYLeftOfVehicle(vehicleid, pos[4], pos[5], 5.00);
					new package = CreateDynamicObject(1575, pos[0], pos[1], pos[2]+0.75, 0.0, 0.0, pos[3]+90.0);
					SetTimerEx("AngledThrow", 20, false, "iifff", package, 5, pos[4], pos[5], pos[2]+0.75);
					NewspaperJob_UpdateTextdraw(playerid);
					if(GetDistanceBetweenPoints(pos[4], pos[5], pos[2], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_X], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_Y], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_Z]) < 3.50)
					{
						NewspaperJob_TargetHit(playerid) ;
					}
					else NewspaperJob_TargetMiss(playerid) ;

					if(BikeStorage[playerid] < 1) {
						GPS_MarkLocation(playerid, "Return to the ~r~shop ~w~for more items.", E_GPS_COLOR_DEFAULT, 1348.6627, -1745.8923, 13.1051 ) ;
					}
				}
			}
		}
	}
	else if(newkeys == 64 && oldkeys == 68) //Right
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(IsCourierVehicle(vehicleid)) //in a bike
			{
				if(BikeStorage[playerid] > 0)
				{
					PlayerPlaySound(playerid, 5600, 0.0, 0.0, 0.0);
					BikeStorage[playerid] --;
					new Float:pos[6];
					GetVehicleZAngle(vehicleid, pos[3]);
					GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
					GetVehiclePos(vehicleid, pos[4], pos[5], pos[2]);
					GetXYRightOfVehicle(vehicleid, pos[0], pos[1], 1.00);
					GetXYRightOfVehicle(vehicleid, pos[4], pos[5], 5.00);
					new package = CreateDynamicObject(1575, pos[0], pos[1], pos[2]+0.75, 0.0, 0.0, pos[3]+90.0);
					SetTimerEx("AngledThrow", 20, false, "iifff", package, 5, pos[4], pos[5], pos[2]+0.75);
					NewspaperJob_UpdateTextdraw(playerid);
					if(GetDistanceBetweenPoints(pos[4], pos[5], pos[2], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_X], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_Y], CourierShop[BikeLocation[playerid]][E_COURIER_STORE_POS_Z]) < 3.50)
					{
						
						NewspaperJob_TargetHit(playerid) ;
					}
					else NewspaperJob_TargetMiss(playerid) ;

					if(BikeStorage[playerid] < 1)
					{
						DestroyDynamicRaceCP(PlayerDeliveryCP[playerid]);

						GPS_MarkLocation(playerid, "Return to the ~r~shop ~w~for more items.", E_GPS_COLOR_DEFAULT, 1348.6627, -1745.8923, 13.1051 ) ;
					}
				}
			}
		}
	}
	else if(PRESSED(KEY_SUBMISSION)) //start the courier job
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(IsCourierVehicle(vehicleid) && BikeStorage[playerid] == -1) //in a bike
			{
				BikeStorage[playerid] = 0;
				PlayerTextDrawSetString(playerid, PlayerSubmissionText[playerid][0], "~n~items");
				PlayerTextDrawSetString(playerid, PlayerSubmissionText[playerid][1], "0");
				PlayerTextDrawShow(playerid, PlayerSubmissionText[playerid][0]);
				PlayerTextDrawShow(playerid, PlayerSubmissionText[playerid][1]);

				GPS_MarkLocation(playerid, "Return to the ~r~shop ~w~for more items.", E_GPS_COLOR_DEFAULT, 1348.6627, -1745.8923, 13.1051 ) ;
			}
		}
	}
	
	#if defined newsp_OnPlayerKeyStateChange
		return newsp_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange newsp_OnPlayerKeyStateChange
#if defined newsp_OnPlayerKeyStateChange
	forward newsp_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

NewspaperJob_EnterCP(playerid) {
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1348.6627, -1745.8923, 13.1051)) //This is courier job's CP
	{
		DisablePlayerCheckpoint(playerid);
		BikeStorage[playerid] = 6;

		NewspaperJob_UpdateTextdraw(playerid);
		NewspaperJob_NewObjective(playerid);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(IsCourierVehicle(GetPlayerVehicleID(playerid)) && BikeStorage[playerid] == -1)
		{
			ShowPlayerInfoMessage(playerid, "Press ~k~~TOGGLE_SUBMISSIONS~ to start courier job.", .height=167.5, .width=180, .showtime=6000);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		}
	}
	else if(BikeStorage[playerid] != -1)
	{
		BikeStorage[playerid] = -1;
		cmd_nocp(playerid);
		DestroyDynamicRaceCP(PlayerDeliveryCP[playerid]);
		PlayerTextDrawHide(playerid, PlayerSubmissionText[playerid][0]);
		PlayerTextDrawHide(playerid, PlayerSubmissionText[playerid][1]);
	}
	
	#if defined newspa_OnPlayerStateChange
		return newspa_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange newspa_OnPlayerStateChange
#if defined newspa_OnPlayerStateChange
	forward newspa_OnPlayerStateChange(playerid, newstate, oldstate);
#endif