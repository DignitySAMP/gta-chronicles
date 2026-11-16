 
#include "a_samp"

#define IsVehicleOccupied IsVehicleOccupied_
#define GetVehicleDriver GetVehicleDriver_
#define GetWeaponSlot GetWeaponSlot_
#define IsPlayerSpawned IsPlayerSpawned_

#pragma compress 0
#define YSI_NO_HEAP_MALLOC

#define KEY_AIM KEY_HANDBRAKE
#define KEY_AIM_FIRE    132 


#if defined MAX_PLAYERS
	#undef MAX_PLAYERS 
	#define MAX_PLAYERS 250
#endif

#if defined MAX_OBJECTS
	#undef MAX_OBJECTS
	#define MAX_OBJECTS 	(10000)
#endif

#include "crashdetect"
#include "sscanf2"
#include <samp_bcrypt>


#include "YSI_Coding\y_inline"
#include "ww_mysql"
#include "strlib"
#define STREAMER_USE_DYNAMIC_TEXT3D_TAG
#include "streamer"
#define GetDynamicObjectModel(%0) Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

#include "zcmd"
#include "YSI_Visual\y_dialog"
#include "YSI_Coding\y_timers"
#include "YSI_Data\y_iterate"	
#include "progress2"

#define IsNumeric IsNumeric_

// misc
//#include "zmessage"
#include "config/zmessage_custom.pwn" // no longer hooking sendclientmessage!
#include "3DTryg"
#include "MenuStore"
#include "iptrace"	
//#include "callbacks.pwn"	
//#include <PawnPlus>

// objects
#include "colandreas"
#include "fsutil"	

// array hack
#include "md-sort"

// regex
#include "Pawn.Regex"


//#define DEV_ANTICRASH
//#warning Find a way to make this log once an iteration goes above 100!
//#warning Add this and log it properly! https://github.com/Zeex/samp-plugin-crashdetect/pull/75
#if defined DEV_ANTICRASH
	#define for_loop(%1;%2;%3) \
	    PrintAmxBacktrace(); \
	    for(%1;%2;%3)

	#define while_loop(%1) \
	    PrintAmxBacktrace(); \
	    while(%1)
#else
	#define for_loop(%1;%2;%3) \
	    for(%1;%2;%3)

	#define while_loop(%1) \
	    while(%1)
#endif
