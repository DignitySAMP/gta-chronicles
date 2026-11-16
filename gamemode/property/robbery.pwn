#if !defined KEY_AIM
	#define KEY_AIM  128
#endif

#define MAX_ROBBERY_ACTORS		(50)

#define TYPE_SUCCESS        (0)
#define TYPE_FAILED         (1)
#define TYPE_UNFINISHED     (2)

#define MIN_MONEY_ROB       250
#define MAX_MONEY_ROB       2000
#define ROBBERY_WAIT_TIME   (5)
#define ROBBERY_CD_TIME     (15)
#define ROBBERY_CD_FINAL 	(90)

enum E_ACTOR_ROBBERY_DATA
{
	actor_skin,
	Float:actor_x,
	Float:actor_y,
	Float:actor_z,
	Float:actor_ang,
	actor_vw,
	money_min,
	money_max,

	bool:actor_created,
	actor_robbedRecently
}
static 
	robbery_data[MAX_ROBBERY_ACTORS][E_ACTOR_ROBBERY_DATA],
	i_actor = 0;

ActorRobbery_LoadEntities() {
	// Enex Robbable Actors
	//CreateActorRobbery(168, 1840.8673,-1847.1298,13.5912,359.9706); // unity 24.7
	//CreateActorRobbery(155, 2108.2527,-1799.2672,13.5806,93.5299); // pizzastack idlewood
	CreateActorRobbery(167, 2393.3604,-1907.1713,13.5541,359.6946); // willowfield cluck
	CreateActorRobbery(167, 2412.2874,-1504.0383,23.9969,270.3207); // els cluck
	CreateActorRobbery(209, 1033.2444,-1348.1082,13.7301,268.6368); // market donuts
	//CreateActorRobbery(168, 1918.0006,-1806.3690,13.5648,0.1146); // enex_actor_liquor
	CreateActorRobbery(228,2857.0188,-1465.8411,10.9494,267.6433); // jewelry_actor
	CreateActorRobbery(263,1539.1796,-1505.6322,13.5901,359.3333); // chinatown_actor
	CreateActorRobbery(262,1922.1794,-1769.5519,13.5988,271.2625); // enex_idle_actor
	CreateActorRobbery(67,2427.9563,-1743.1108,13.6750,181.5605); // enex_ganton_actor
	CreateActorRobbery(32,	1508.3876,-1486.4336,13.5613,180.0838); // chinatown_liquor_actor
	//CreateActorRobbery(57,	1682.4139,-1185.8818,23.9768,1.0713); // mul_jew_actor

	// Seville Enex
	CreateActorRobbery(28, 2725.3025,-2034.1794,13.6557,268.0336); // seville 24-7 28c

	// New alhambra actors
	CreateActorRobbery(205,	1859.6885,-1669.1941,13.4221,184.2137); // burgershot_actor
	CreateActorRobbery(182,	1860.4440,-1698.2705,13.6450,183.8769); // alhambra_shopkeeper
	CreateActorRobbery(181,	1901.3280,-1703.3267,13.5963,358.4051); // ogloc_studio_actor
}

forward RunActorAnimationSequence(playerid, actorid, animation_pattern);
forward OnPlayerStartRobbery(playerid, actorid, robbed_recently);
forward OnPlayerFinishRobbery(playerid, actorid, robbedmoney, type);

Robbery_OnPlayerCooldown(playerid) {

	if ( Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] ) {

		new query [ 128 ] ;

		if ( -- Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] <= 0 ) {

			mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_robbery_cooldown = 0 WHERE player_id = %d",

				Character [ playerid ] [ E_CHARACTER_ID ] 
			);

		}	

		else {
			mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_robbery_cooldown = %d WHERE player_id = %d",

				Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ], Character [ playerid ] [ E_CHARACTER_ID ] 
			);
		}

		mysql_tquery(mysql, query);
	}

	return true ;
}

public OnPlayerStartRobbery(playerid, actorid, robbed_recently)
{
    new string[128];
    if(robbed_recently)
    {
        SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", "This store has been robbed recently, please try again later!");
        return 0;
    }

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    format(string, sizeof(string), "** %s has begun robbing the property.", ReturnPlayerNameData(playerid, 0, true));
    ProxDetector(playerid, 30.0, COLOR_ACTION, string);

	switch ( random ( 5 ) ) {

		case 0: ProxDetectorActor ( actorid, 15.0, 0xDEDEDEFF, "Shopkeeper says: W-woah! Don't point that thing at me! I ain't done nuffin'!", .streamer=false);
		case 1: ProxDetectorActor ( actorid, 15.0, 0xDEDEDEFF, "Shopkeeper says: Please señor don't shoot me, I got a wife and kids...", .streamer=false);
		case 2: ProxDetectorActor ( actorid, 15.0, 0xDEDEDEFF, "Shopkeeper says: Don't shoot! Take the cash, it ain't mine anyway!", .streamer=false);
		case 3: ProxDetectorActor ( actorid, 15.0, 0xDEDEDEFF, "Shopkeeper says: You makin' a big mistake.. Just take the cash and don't shoot!", .streamer=false);
		case 4: ProxDetectorActor ( actorid, 15.0, 0xDEDEDEFF, "Shopkeeper says: Please don't take my money! I need to feed my children!", .streamer=false);
	}

	Robbery_SendPoliceAlert(actorid, playerid) ;


    format ( string, sizeof ( string ), "[!!][Robbery] (%d) %s has started robbing actor ID %d ",
    	playerid, ReturnPlayerNameData ( playerid ), actorid
    ) ;

    SendAdminMessage ( string );

    return 1;
}


public OnPlayerFinishRobbery(playerid, actorid, robbedmoney, type) {
    new string[128];

    switch(type) {
        case TYPE_SUCCESS: {
            format(string, sizeof(string), "You managed to steal %s from the property.", IntegerWithDelimiter(robbedmoney));
       		SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", string);

            format(string, sizeof(string), "** The cashier has given %s $%s out of the till.", ReturnPlayerNameData(playerid, 0, true), IntegerWithDelimiter(robbedmoney));
    		ProxDetectorActor(actorid, 15.0, COLOR_ACTION, string, .streamer=false);
 
            format(string, sizeof(string), "~w~You stole~n~~g~$%i", robbedmoney);
            GameTextForPlayer(playerid, string, 6000, 1);   

            GivePlayerCash(playerid, robbedmoney);
        }/*
        case TYPE_FAILED: {
        	format(string, sizeof(string), "* The cashier refuses to give %s the till's money.", ReturnPlayerNameData(playerid));
    		ProxDetectorActor(actorid, 20.0, COLOR_ACTION, string, .streamer=false);

       		SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", "The cashier refused to give you the money and triggered the alarm! Run!");
            GameTextForPlayer(playerid, "~r~Robbery Failed", 6000, 1);
        }*/
        case TYPE_UNFINISHED: {      
    		ProxDetectorActor(actorid, 15.0, COLOR_ACTION, "** The cashier triggers the alarm and calls 911 because the robber ran off.", .streamer=false);

        	SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", "You have gone too far away from the cashier, he managed to call 911! RUN!");
            GameTextForPlayer(playerid, "~y~Robbery Cancelled", 6000, 1);
        }
    }

    format ( string, sizeof ( string ), "[!!][Robbery] (%d) %s has robbed actor %d - result %d - haul: $%s",
    	playerid, ReturnPlayerNameData ( playerid ), actorid, type, IntegerWithDelimiter ( robbedmoney ) 
    ) ;

	AddLogEntry(playerid, LOG_TYPE_SCRIPT, sprintf("Robbed %s from a store with Actor ID %d", IntegerWithDelimiter ( robbedmoney ) , actorid));

    SendAdminMessage ( string );

    return 1;
}


stock CreateActorRobbery(skinid, Float:x, Float:y, Float:z, Float:ang, actor_vwid = 0, r_moneymin = MIN_MONEY_ROB, r_moneymax = MAX_MONEY_ROB)
{

	if ( skinid == 6 ) {

		return -1 ;
	}

	new actorid = GetActorFreeID();

	if(actorid == -1)
	{
		print("ERROR: MAX_ROBBERY_ACTOR reached, increase the limit size.");
		return -1;
	}

	CreateActor(skinid, x, y, z, ang);
	SetActorVirtualWorld(actorid, actor_vwid);

	robbery_data[actorid][actor_created] = true;
	robbery_data[actorid][actor_skin] = skinid;
	robbery_data[actorid][actor_x] = x;
	robbery_data[actorid][actor_y] = y;
	robbery_data[actorid][actor_z] = z;
	robbery_data[actorid][actor_ang] = ang;
	robbery_data[actorid][actor_vw] = actor_vwid;
	robbery_data[actorid][money_min] = r_moneymin;
	robbery_data[actorid][money_max] = r_moneymax;

	return (++ i_actor - 1); 
}

stock GetActorRobberyData(actorid, &skinid, &Float:x, &Float:y, &Float:z, &Float:ang, &actor_vwid, &r_moneymin, &r_moneymax)
{
	if(actorid == INVALID_ACTOR_ID)
		return 1;

	skinid = robbery_data[actorid][actor_skin];
	x = robbery_data[actorid][actor_x];
	y = robbery_data[actorid][actor_y];
	z = robbery_data[actorid][actor_z] ;
	ang = robbery_data[actorid][actor_ang] ;
	actor_vwid = robbery_data[actorid][actor_vw];
	r_moneymin = robbery_data[actorid][money_min];
	r_moneymax = robbery_data[actorid][money_max];
	return 1;
}

static GetActorFreeID() 
{
	for_loop(new i = 0; i < MAX_ROBBERY_ACTORS; i++) 
	{ 
		if(!robbery_data[i][actor_created]) return i;
	}
	return -1;
}

timer ActorRobbery_ResetSound[60000](playerid, Float: x, Float: y, Float: z ) {

	PlayerPlaySound ( playerid, 0, x, y, z ) ;
	printf("Reset robbery sound for %s (%d), at %0.3f, %0.3f, %0.3f.",
		TEMP_ReturnPlayerName(playerid), playerid, x, y, z ) ;

	return true ;
}

public RunActorAnimationSequence(playerid, actorid, animation_pattern)
{
	if ( ! IsPlayerConnected ( playerid ) ) return 1 ;

	switch(animation_pattern)
	{
		case 0:
		{
			ClearActorAnimations(actorid);
			ApplyActorAnimation(actorid, "SHOP", "SHP_Rob_HandsUp", 4.1, 0, 1, 1, 1, 0);
		
			//SetTimerEx("RunActorAnimationSequence", 1000 * ROBBERY_WAIT_TIME, false, "iii", playerid, actorid, 1);
			SetTimerEx("RunActorAnimationSequence", 2500 * ROBBERY_WAIT_TIME, false, "iii", playerid, actorid, 1);
		
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
		
			foreach(new i: Player) {
				if ( ! IsPlayerLogged ( i ) || ! IsPlayerSpawned ( i ) ) {

					continue ;
				}

				if ( IsPlayerInRangeOfPoint(i, 25.0, x, y, z ) ) {
					PlayerPlaySound(i, 3401, x, y, z);
					//#warning May cause overflow and crash server...
					defer ActorRobbery_ResetSound(i, x, y, z ) ;
				}
			}
		}
		case 1:
		{
			if(!IsPlayerInRangeOfPoint(playerid, 7.5, robbery_data[actorid][actor_x], robbery_data[actorid][actor_y], robbery_data[actorid][actor_z]))
			{
				OnPlayerFinishRobbery(playerid, actorid, 0, TYPE_UNFINISHED);
			}
			else 
			{
				ClearActorAnimations(actorid);
				ApplyActorAnimation(actorid, "SHOP", "SHP_Rob_GiveCash", 4.1, 1, 1, 1, 1, 0);
				ProxDetectorActor(actorid, 20.0, COLOR_ACTION, "* The cashier begins putting the till money in a bag.", .streamer=false);
       			SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", "The cashier is doing his best to fill the bag. Please wait for them to finish.");

				SetTimerEx("RunActorAnimationSequence", 2500 * ROBBERY_CD_TIME, false, "iii", playerid, actorid, 2);
			}
		}
		case 2:
		{
			if(!IsPlayerInRangeOfPoint(playerid, 7.5, robbery_data[actorid][actor_x], robbery_data[actorid][actor_y], robbery_data[actorid][actor_z]))
			{
				OnPlayerFinishRobbery(playerid, actorid, 0, TYPE_UNFINISHED);
			}
			else 
			{
				OnPlayerFinishRobbery(playerid, actorid, (random(robbery_data[actorid][money_max] - robbery_data[actorid][money_min]) + robbery_data[actorid][money_min]), TYPE_SUCCESS);
			}
		
			//new 
			//robberyChance = random(100);
			//if(robberyChance > 50)
			//{
			
			//}
			//else OnPlayerFinishRobbery(playerid, actorid, 0, TYPE_FAILED);
		}
		case 3:
		{
			// Force hard reset anims:
			ClearActorAnimations(actorid);
			ApplyActorAnimation(actorid, "PED", "IDLE_STANCE", 4.0, 0, 0, 0, 0, 1);
			ApplyActorAnimation(actorid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 1);
			ApplyActorAnimation(actorid, "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1);

			PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
		}

	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_AIM) == KEY_AIM && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		switch(GetPlayerWeapon(playerid))
		{
			case 22 .. 33: 
			{
				new actorid = GetPlayerCameraTargetActor(playerid);
				if (actorid != INVALID_ACTOR_ID && !IsPlayerInAnyGovFaction(playerid) && robbery_data[actorid][actor_created] ) { // Prevent cops/medics doing robberies

					new query [ 128 ] ;

				    if ( Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] ) {

				    	format ( query, sizeof ( query ), "You're on a robbing cooldown! Try again in %d seconds!", Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] ) ;
				        SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", query );
				 
				    }

					else if (Character[playerid][E_CHARACTER_LEVEL] <= 1)
					{
						SendServerMessage ( playerid, COLOR_PROPERTY, "Robbery", "DEDEDE", "You must be at least level two to rob a store." );
					}

					else if(gettime() - robbery_data[actorid][actor_robbedRecently] < 60 * ROBBERY_CD_FINAL) {
						OnPlayerStartRobbery(playerid, actorid, 1);
					}

					else {
					robbery_data[actorid][actor_robbedRecently] = gettime();
					Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ] = 1800 ; // 30 min

					mysql_format(mysql, query, sizeof ( query ), "UPDATE characters SET player_robbery_cooldown = %d WHERE player_id = %d",

						Character [ playerid ] [ E_CHARACTER_ROBBERY_COOLDOWN ], Character [ playerid ] [ E_CHARACTER_ID ] 
					);

					mysql_tquery(mysql, query);

					RunActorAnimationSequence(playerid, actorid, 0);
					OnPlayerStartRobbery(playerid, actorid, 0);
					}
				}
			}
		}
	}
	
	#if defined actorrob_OnPlayerKeyStateChange
		return actorrob_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif

#define OnPlayerKeyStateChange actorrob_OnPlayerKeyStateChange
#if defined actorrob_OnPlayerKeyStateChange
	forward actorrob_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif