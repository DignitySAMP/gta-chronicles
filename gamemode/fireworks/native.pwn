
public OnPlayerConnect(playerid)
{
	ApplyAnimation(playerid, "BOMBER", "null", 0.0, 0, 0 , 0, 0, 0);

	#if defined fw_OnPlayerConnect
		return fw_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect fw_OnPlayerConnect
#if defined fw_OnPlayerConnect
	forward fw_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	if (GetPVarInt(playerid, "FireworkPlaced"))
	{
		for (new fw; fw != MAX_FIREWORK; fw++)
		{
			if (FW_Owner[fw] == playerid && FW_Stage[fw] <= 1)
			{
				FW_MainDestroy(fw);
			}
		}
	}

	#if defined fw_OnPlayerDisconnect
		return fw_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect fw_OnPlayerDisconnect
#if defined fw_OnPlayerDisconnect
	forward fw_OnPlayerDisconnect(playerid, reason);
#endif


