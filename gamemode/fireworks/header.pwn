/*
	 // - - - - - - - - - - - - - - //
	//   Advanced Fireworks v1.0   //
   // - - - - - - - - - - - - - - // 


	Original script: Basssiiie
	https://github.com/Basssiiie/Advanced-Fireworks


	Edited by Hades (Dignity) for SOLS
	 
*/

// The color of warning messages in the chat.
// Default: 0xFF0000FF
#define MSG_WARNING 0xFF0000FF

// The maximum amount of firework instances that players can place, per server.
// Default: 20
#define MAX_FIREWORK 20

// The maximum amount of particle objects that can be spawned per firework instance.
// Default: 75
#define MAX_FWOBJECT 256

// This defines how long the fireworks will stay around before it gets destroyed, after it's finished firing all its rounds.
// Default: 10000 (10 seconds)
#define DEF_STAY_TIME 10000


#define FW_UNKNOWN 0
#define FW_FOUNTAIN 1
#define FW_ROCKET 2
#define FW_SPLITTER 3
#define FW_UMBRELLA 4
#define FW_CAKE 5

#define DEF_ANIM_TIME 2500
#define DEF_DELAY_FIRE 250

// Fountain defines
#define FOUNTAIN_LIFE 10000
#define FOUNTAIN_DELAY 200

// Rocket defines
#define ROCKET_DUPLICATES 25
#define ROCKET_DELAY 1000

// Splitter defines
#define SPLITTER_DUPLICATE_1 7
#define SPLITTER_DUPLICATE_2 10
#define SPLITTER_DELAY 1000

// Umbrella defines
#define UMBRELLA_DUPLICATES 30
#define UMBRELLA_DELAY 1000

// Cake defines
#define CAKE_DUPLICATES 10
#define CAKE_DELAY 500
#define CAKE_SINGLE_DELAY 500
#define CAKE_BIG_DELAY 2500

new FW_Owner[MAX_FIREWORK] = {-1, ...};
new FW_Type[MAX_FIREWORK];
new FW_Lifetime[MAX_FIREWORK];
new FW_Stage[MAX_FIREWORK];
new FW_Colors[MAX_FIREWORK][2];
new FW_Object[MAX_FIREWORK][MAX_FWOBJECT][2];


#include "fireworks/data.pwn"
#include "fireworks/func.pwn"
#include "fireworks/visual.pwn"
#include "fireworks/effects.pwn"
#include "fireworks/native.pwn"

Fireworks_Init() {
	// Create the fireworks menus
	MenuFireworkLighting = CreateMenu("Firework", 1, 150, 300,1000,35);
	AddMenuItem(MenuFireworkLighting, 0, "Fountain");
	AddMenuItem(MenuFireworkLighting, 0, "Rocket");
	AddMenuItem(MenuFireworkLighting, 0, "Splitter");
	AddMenuItem(MenuFireworkLighting, 0, "Umbrella");
	AddMenuItem(MenuFireworkLighting, 0, "Cake");
	FWSize = CreateMenu("Firework effects", 1, 150, 300, 500, 0);
	SetMenuColumnHeader(FWSize, 0, "Choose the size of the effects..");
	AddMenuItem(FWSize, 0, "Small");
	AddMenuItem(FWSize, 0, "Big");
	FWColor = CreateMenu("Firework color", 1, 150, 300, 500, 0);
	AddMenuItem(FWColor, 0, "White");
	AddMenuItem(FWColor, 0, "Red");
	AddMenuItem(FWColor, 0, "Green");
	AddMenuItem(FWColor, 0, "Blue");
}

CMD:shootfireworks(playerid, params[]) {
	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}

	if (GetPVarInt(playerid, "FireworkPlaced") == 1 && GetPVarInt(playerid, "FW_Pending" ) == 1 ) 
	{
		DeletePVar(playerid, "FireworkPlaced");
		DeletePVar(playerid, "FW_Pending");
		SetPVarInt(playerid, "TimerMainFire", SetTimerEx("FW_MainFire", DEF_DELAY_FIRE, true, "i", playerid));
		return 1;
	}
	

	return true ;
}

CMD:fireworks(playerid, params[]) {
	if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] < ADMIN_LVL_MANAGER ) {

		return false ;
	}


	inline FireworksSetup(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, dialogid, inputtext

		if ( response ) {

			SetPVarInt(playerid, "FW_ColorsNumber", 2);

			switch ( listitem ) {

				case 0: SetPVarInt(playerid, "FW_MenuItem", FW_FOUNTAIN);
				case 1: SetPVarInt(playerid, "FW_MenuItem", FW_ROCKET);
				case 2: SetPVarInt(playerid, "FW_MenuItem", FW_SPLITTER);
				case 3: SetPVarInt(playerid, "FW_MenuItem", FW_UMBRELLA);
				case 4: SetPVarInt(playerid, "FW_MenuItem", FW_CAKE);
			}

			inline FireworksSetup_Size(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
	    		#pragma unused pidx, dialogidx, inputtextx

				if ( responsex ) {
					switch ( listitemx ) {

						case 0: { // small
							SetPVarInt(playerid, "FW_Big", 0);
						}

						case 1: { // large

							SetPVarInt(playerid, "FW_Big", 1);
						}
					}

					inline FireworksSetup_ColorA(pidy, dialogidy, responsey, listitemy, string:inputtexty[]) {
		    			#pragma unused pidy, dialogidy, inputtexty

						if ( responsey ) {
							switch ( listitemy ) {

								case 0: { // White
									if (GetPVarInt(playerid, "FW_Big") == 1) {
										SetPVarInt(playerid, "FW_Color1", 19295);
									} 
									else {
										SetPVarInt(playerid, "FW_Color1", 19281);
									} 
								}
								case 1: { // red
									if (GetPVarInt(playerid, "FW_Big") == 1) {
										SetPVarInt(playerid, "FW_Color1", 19296);
									} 
									else {
										SetPVarInt(playerid, "FW_Color1", 19282);
									} 
								}
								case 2: { // green
									if (GetPVarInt(playerid, "FW_Big") == 1) {
										SetPVarInt(playerid, "FW_Color1", 19297);
									} 
									else {
										SetPVarInt(playerid, "FW_Color1", 19283);
									} 
								}
								case 3: { // Blue
									if (GetPVarInt(playerid, "FW_Big") == 1) {
										SetPVarInt(playerid, "FW_Color1", 19298);
									} 
									else {
										SetPVarInt(playerid, "FW_Color1", 19284);
									} 
								}
							}
							if (GetPVarInt(playerid, "FW_ColorsNumber") == 1) {
								DeletePVar(playerid, "FW_Big");
								FW_MainCreate(playerid, GetPVarInt(playerid, "FW_MenuItem"));
								return 1;
							}
							inline FireworksSetup_ColorB(pidz, dialogidz, responsez, listitemz, string:inputtextz[]) {
				    			#pragma unused pidz, dialogidz, inputtextz

								if ( responsez ) {

									switch ( listitemz ) {
										case 0: {
											if (GetPVarInt(playerid, "FW_Big") == 1) {
												SetPVarInt(playerid, "FW_Color2", 19295);
											} 
											else {
												SetPVarInt(playerid, "FW_Color2", 19281);
											}
										} 
										case 1: {
											if (GetPVarInt(playerid, "FW_Big") == 1) {
												SetPVarInt(playerid, "FW_Color2", 19296);
											} 
											else {
												SetPVarInt(playerid, "FW_Color2", 19282);
											}
										} 
										case 2: {
											if (GetPVarInt(playerid, "FW_Big") == 1) {
												SetPVarInt(playerid, "FW_Color2", 19297);
											} 
											else {
												SetPVarInt(playerid, "FW_Color2", 19283);
											}
										} 
										case 3: {
											if (GetPVarInt(playerid, "FW_Big") == 1) {
												SetPVarInt(playerid, "FW_Color2", 19298);
											} 
											else {
												SetPVarInt(playerid, "FW_Color2", 19284);
											}
										} 
									}

									TogglePlayerControllable(playerid, 1);
									FW_MainCreate(playerid, GetPVarInt(playerid, "FW_MenuItem"));
									DeletePVar(playerid, "FW_MenuItem");
									DeletePVar(playerid, "FW_ColorsNumber");
									DeletePVar(playerid, "FW_Big");
								}

								else {
									DeletePVar(playerid, "FW_Color1");
									DeletePVar(playerid, "FW_Color2");
									DeletePVar(playerid, "FW_MenuItem");
									DeletePVar(playerid, "FW_ColorsNumber");
									DeletePVar(playerid, "FW_Big");
								}
				    		}

			    			Dialog_ShowCallback ( playerid, using inline FireworksSetup_ColorB, DIALOG_STYLE_LIST, 
	    					"{C23030}FIREWORK SETUP{DEDEDE} - Choose Colour 2", "White\nRed\nGreen\nBlue", "{C23030}Continue", "Cancel" );
						}

						else {
							DeletePVar(playerid, "FW_Color1");
							DeletePVar(playerid, "FW_Color2");
							DeletePVar(playerid, "FW_MenuItem");
							DeletePVar(playerid, "FW_ColorsNumber");
							DeletePVar(playerid, "FW_Big");
						}

					}
	    			Dialog_ShowCallback ( playerid, using inline FireworksSetup_ColorA, DIALOG_STYLE_LIST, 
	    				"{C23030}FIREWORK SETUP{DEDEDE} - Choose Colour 1", "White\nRed\nGreen\nBlue", "{C23030}Continue", "Cancel" );
    			}

				else {
					DeletePVar(playerid, "FW_Color1");
					DeletePVar(playerid, "FW_Color2");
					DeletePVar(playerid, "FW_MenuItem");
					DeletePVar(playerid, "FW_ColorsNumber");
					DeletePVar(playerid, "FW_Big");
				}
    		}

	    	Dialog_ShowCallback ( playerid, using inline FireworksSetup_Size, DIALOG_STYLE_LIST, "{C23030}FIREWORK SETUP{DEDEDE} - Choose Size", 
	    		"Small Effect\nLarge Effect", "{C23030}Continue", "Cancel" );
		}
	}

	Dialog_ShowCallback ( playerid, using inline FireworksSetup, 
		DIALOG_STYLE_LIST, "{C23030}FIREWORK SETUP{DEDEDE} - Choose Effect", 
		"Fountain\nRocket\nSplitter\nUmbrella\nCake", "{C23030}Continue", "Cancel" );

	return true ;
}



// Other things
stock UpdateStreamerForAll()
{
	for (new p = 0, mp = GetPlayerPoolSize(); p <= mp; p++)
	{
		Streamer_Update(p);
	}
	return 1;
}
