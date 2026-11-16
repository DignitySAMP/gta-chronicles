#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <strlib>
#include <zcmd>
#include <YSI\y_iterate>
#include <YSI\y_inline>
#include <YSI\y_dialog>


/*
	https://i.imgur.com/HEnZ4Ql.jpg

	[BUILD 1]:
	 - All original drugs are wiped.
	 - Stacking drug effects is not possible
	 - Drugs are saved as "quantity" rather than a complicated "gram" system
	 - All drugs and drug "seeds" are provided by the faction team through the scheme system
	 - Drugs are dynamic, meaning management can create drug types ingame with predefined settings (visuals, effects, addiction %, etc)
	 - Drugs will have it's own scheme system that can be accessed by management (or specific account IDs) to spawn drugs or seeds (logged)

	[PROPOSED CHANGES]:
	 - Make rules so people don't /usedrug before a brawl or shootout
	 - All effects/benefits must kick in over time and must be roleplayed.

	Growable: yes/no
	 - No, modelid = 0; only givable through the scheme system handled by FT (potential perk?)
	 - Yes, you'll have to enter a modelid that's displayed i.e. a weed plant, a pan or a lab table

	Addicting: yes/no
	 - No, this drug is not addicting and won't cause lasting effects
	 - Yes, this drug will cause addiction (+1 tick every 5 minutes of active effect. -1 tick every 30 minutes when off effect)	


*/

// Cross hooks. Replace with GTA-C funcs.
#define COLOR_YELLOW -1
forward Drugs_SetPlayerHealth ( playerid, Float: health );
forward Drugs_GetPlayerHealth ( playerid ) ;
public Drugs_SetPlayerHealth ( playerid, Float: health ) { return true ; }
public Drugs_GetPlayerHealth ( playerid )  { return true ; }



// Reparse definitions
forward Float: Drugs_AddictionHealthSubtract(addiction) ;
forward Float: Drugs_GetAddictionSpawnHealth(addiction) ;
forward Float: Drugs_GetPotencyAmplifier(potency);
forward Float: Drugs_GetPotencyEffectDuration(potency);

#include "data.pwn"
#include "addiction.pwn"
#include "potency.pwn"

#warning Make a setting for "drug effect (str 256)" that lets admins specify how the high effect should be RPed. This is displayed to the player.

public OnFilterScriptInit() {

	// Testing natives on compiling issues
	Drugs_OnPlayerSpawn(0);
	DrugsTick_Addiction(0);
	Drug_EditMenu(0, 0);

	return true ;
}

Drugs_OnPlayerSpawn(playerid) {

	// Things to apply when a player finishes spawning.

	Drugs_LoadPlayerEntities(playerid);
	if ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_IS_ADDICTED ] ) {
		new Float: spawn_health = Drugs_GetAddictionSpawnHealth ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) ;

		if ( spawn_health < Drugs_GetPlayerHealth ( playerid ) ) {

			Drugs_SetPlayerHealth(playerid, Drugs_GetAddictionSpawnHealth ( PlayerDrugs [ playerid ] [ E_PLAYER_DRUG_ADDICTION_LEVEL ] ) ) ;
		}
	}
	return true ;
}