enum {

	MAX_DRUGS = 100,
	INVALID_DRUG_ID = -1,
	MAX_DRUG_NAME = 32
}

enum E_DRUG_DATA {

	E_DRUG_SQLID,
	E_DRUG_NAME [ MAX_DRUG_NAME ],
	E_DRUG_ADDICTING, // does the drug use the addiction system?

	E_DRUG_GROWABLE, // is drug creatable or only scheme spawnable
	E_DRUG_GROWABLE_MODELID, // the modelid to show when "creating" the drug

	E_DRUG_VISUAL_TYPE, // the index of the visual effect, see visuals.pwn
	E_DRUG_EFFECT_TYPE, // the index of the effect type, see effects.pwn
	E_DRUG_EFFECT_PARAM [ 2 ] // param 1 & 2 for health, i.e. how often should they get health and how much
} ;

new Drug [ MAX_DRUGS ] [ E_DRUG_DATA ] ;
new Iterator:Drugs<MAX_DRUGS>;


Drugs_GetDrugName(sql_id, name[], len=sizeof(name)) {

	format ( name, len, "Unknown");
	foreach(new index: Drugs) {

		if ( Drug [ index ] [ E_DRUG_SQLID ] == sql_id ) {

			format ( name, len, "%s", Drug [ index ] [ E_DRUG_NAME ] );
		}
	}
}

enum E_PLAYER_DRUG_DATA {
	// Player drug profiles

	E_PLAYER_DRUG_CHARACTER_ID, // character id

	bool: E_PLAYER_DRUG_IS_ADDICTED, // declares if player suffers from addiction
	E_PLAYER_DRUG_ADDICTION_LEVEL, // level of the addiction
	E_PLAYER_DRUG_ADDICTED_DRUG, // drug the player is addicted to (sql id)
	E_PLAYER_DRUG_ADDICTION_TICK, // how many ticks until the addiction effect kicks in
	E_PLAYER_DRUG_ADDICTION_EXPIRE, // how many ticks needed until an addiction level subsides,

	bool: E_PLAYER_DRUG_EFFECT, // is player high
	E_PLAYER_DRUG_HIGH_USED, // drug the player is high on (sql id)
	E_PLAYER_DRUG_DURATION, // how many ticks until an effect kicks in
} ;

new PlayerDrugs [ MAX_PLAYERS ] [ E_PLAYER_DRUG_DATA ] ;


Drugs_LoadPlayerEntities(playerid) {
	#pragma unused playerid
}


Drug_EditMenu(playerid, drug_id) {
	#warning Only allow edits if the player is a manager. Else, this will just show the info and the drug stats.

	new DrugEditDlgString[2048];

	inline DrugMenu_Edit(pid, dialogid, response, listitem, string:inputtext[])  {
		#pragma unused pid, dialogid, inputtext, listitem, response

		if ( response ) {

			switch ( listitem ) {

				case 0: DrugEditDlgString[0] = EOS, format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), 
					"{DEDEDE}This option changes the name of the drug.\n\n\
					Make sure there are no existing drugs with this name already or\n\
					there might be script complications.\n\n\
					Please try to keep drug names and brands as close to real life\n\
					(realistic) as possible." 
				) ;

				case 1: DrugEditDlgString[0] = EOS, format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), 
					"{DEDEDE}This option changes whether the drug is addicting.\n\n\
					Enabling this will allow the \"addiction\" system to enable for\n\
					the player. Depending on how much they use, addictions will cause\n\
					damage over time (until 35.0 health) and impact their spawn health.\n\n\
					\
					Addictions can fade over time (by withstanding the negative effects)\n\
					or by getting medical help. Fading over time is done per stage, for\n\
					example if you are an addict of level 3, you need to go down to\n\
					stage 2, then 1, then 0 respectively.\n\n\
					\
					{046bc5}Addiction Levels{DEDEDE}:\n\
					{75c504}1) \"experimental\":{DEDEDE} -1.5 hp every 35 min. Spawn hp is 90.0.\n\
					Stage expires automatically after 6 hours of no use.\n\
					{c5b504}2) \"dependant\":{DEDEDE} -2.5 hp every 30 min. Spawn hp is 80.0.\n\
					Stage expires automatically 8 hours of no use.\n\
					{c56b04}3) \"hazardous\":{DEDEDE} -2.5 hp every 25 min. Spawn hp is 70.0.\n\
					Stage expires automatically 10 hours of no use.\n\
					{ad1e1e}4) \"critical\":{DEDEDE} -3.0 hp every 25 min. Spawn hp is 60.0.\n\
					Stage expires automatically 12 hours of no use."
				) ;
				case 2: DrugEditDlgString[0] = EOS, format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), 
					"{DEDEDE}This option determines whether a drug is growable.\n\n\
					Growable has a broader term here in the sense that because drugs are dynamic\n\
					it simply means that they can be manufractured by players, either through\n\
					growth, production or refinery.\n\n\
					\
					Changing this option to \"no\" means that the drug can only be ultimately\n\
					accessed through an admin spawning it in and giving the first batch to a\n\
					player or faction to sell.\n\n\
					\
					Changing this option to \"yes\" means that the drug can has to be spawned\n\
					in through a \"seed\" which the player it's given to has to \"grow\" into\n\
					a proper drug. For weed this would be a plant, for crack this would be\n\
					cooking the drug, for meth it would be chemically producing it, and so on.\n\n\
					\
					This option would be toggled off for drugs that are not realistically\n\
					manufractured in our server environment, for example cocaine, mushrooms, etc ..." 
				) ;
				case 3: DrugEditDlgString[0] = EOS, format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), 
					"{DEDEDE}This option declares which model ID is spawned when a player uses a\n\
					drug \"seed\". They will need to interact with this object to make the drug\n\
					develop into an usable entity.\n\n\
					\
					This object will require interaction at specific interactions through a key\n\
					press. These actions must be roleplayed and documented in order to guarantee\n\
					full drug \"growth\".\n\n\
					\
					Failure to interact on time will result in your drug losing potency. Interacting\n\
					with your drug on time will sustain it's original potency (potency is declared\n\
					when the drug or drug seedis originally given to a player).\n\n\
					\
					Interacting on time and making it reach 100'/. has the chance to increase the\n\
					base defined potency level. For example if your potency is level 3, perfect\n\
					interaction will give you a 50/50 chance to reach level 4 potency."
				);
				case 4: format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), "" ) ;
				case 5: format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), "" ) ;
				case 6: format ( DrugEditDlgString, sizeof ( DrugEditDlgString ), "" ) ;
			}
		}
	}

	new name[32], addiction, growable, grow_model_id, visual[32], effect[32], effect_param_0, effect_param_1 ;


	format(DrugEditDlgString, sizeof ( DrugEditDlgString ), 
		"Name: \t %s\nAddicting: \t %s\nGrowable: \t %s\nGrow Model ID: \t %d\nVisual: \t %s\nEffect: \t %s\nEffect Params: \t (%d), (%d)",
		name,
		(addiction) ? ("{5DB145}Yes") : ("{B14545}No"), 
		(growable) ? ("{5DB145}Yes") : ("{B14545}No"),
		grow_model_id,
		visual,
		effect, 
		effect_param_0, effect_param_1
	);

	Dialog_ShowCallback ( forplayerid, using inline DrugMenu_Edit, DIALOG_STYLE_MSGBOX, "Admin Record", DrugEditDlgString, "OK", "Back" );

}