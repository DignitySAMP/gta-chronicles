

CMD:flip(playerid){
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");


	ClearAnimations(playerid); 
	ApplyAnimation(playerid,"ped", "KD_right", 4.0, 0, 0, 0, 1, 0);

	return true ;
}

CMD:facepalm( playerid, cmdtext[] )
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.1, 0, 0, 0, 0, 0, 1);

	return 1;
}

CMD:stop ( playerid, params [] ) {

    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "POLICE", "CopTraf_Stop", 4.0, 1, 0, 0, 0, 0, 1);

	return true ;
}


CMD:lean(playerid, params[])
{
	new type;

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/lean [1-5]");

	if (type < 1 || type > 5)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (type == 1) AnimationLoop(playerid, "GANGS", "leanIDLE", 4.0, 1, 0, 0, 0, 0, 1);
	else if (type == 2) AnimationLoop(playerid, "MISC", "Plyrlean_loop", 4.0, 1, 0, 0, 0, 0, 1);
	else if (type == 3) AnimationLoop(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
	else if (type == 4) AnimationLoop(playerid, "SMOKING", "m_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	else if (type == 5) AnimationLoop(playerid, "SMOKING", "f_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);

	return 1;
}

CMD:getup ( playerid, params [] ) {

    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "PED", "getup", 4.1, 0, 0, 0, 0, 0, 1);

	return true ;
}

CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/dance [1-14]");

	if (type < 1 || type > 14)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	    case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	    case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	    case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
		case 5: AnimationLoop(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 1, 1, 1); 
		case 6: AnimationLoop(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 1, 1, 1); 
		case 7: AnimationLoop(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 1, 1, 1); 
		case 8: AnimationLoop(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 1, 1, 1); 
		case 9: AnimationLoop(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 1, 1, 1); 
		case 10: AnimationLoop(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 1, 1, 1); 
		case 11: AnimationLoop(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 1, 1, 1); 
		case 12: AnimationLoop(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 1, 1, 1); 
		case 13: AnimationLoop(playerid, "DANCING", "dnce_M_d", 4.1, 1, 0, 0, 1, 1, 1); 
		case 14: AnimationLoop(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 1, 1, 1); 
	}
	return 1;
}

CMD:gkick ( playerid, params [] ) {
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 0, 0, 0, 0, 1);

	return true ;
}

CMD:handsup(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:camcrouch ( playerid, params [] ) {
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");


	AnimationLoop(playerid, "CAMERA", "camcrch_idleloop", 4.1, 1, 0, 0, 0, 0, 1);

	return true ;
}

CMD:riflehold ( playerid, params [] ) {

    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "PED", "Gun_2_IDLE", 4.1, 0, 1, 1, 1, 1, 1); 

	return true ;
}

CMD:time ( playerid, params [] ) {
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "PLAYIDLES", "time", 4.1, 0, 0, 0, 0, 0, 1);

	new string [ 128 ] ;
	format ( string, sizeof ( string ), "[Watch]: {DEDEDE}The time is %.0d:%02d on %s %d, 1997.",
		Server [ E_SERVER_TIME_HOURS ], Server [ E_SERVER_TIME_MINUTES ], 
		date_getMonth(Server [ E_SERVER_TIME_MONTHS ]), Server [ E_SERVER_TIME_DAYS ]
	);

	SendClientMessage ( playerid, COLOR_HINT, string ) ;

	return true ;
}

CMD:ko ( playerid, params [] ) {

    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new animstate ;

	if ( sscanf ( params, "i", animstate )) {

		return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/ko [1-2]") ;
	}

	if ( animstate < 1 || animstate > 2 ) {

		return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/ko [1-2]") ;
	}

	if ( animstate == 1 ) {

		return AnimationLoop(playerid,"PED","KO_SHOT_STOM", 4.1, 0, 1, 1, 1, 1, 1); 
	}

	else if ( animstate == 2 ) {

		return AnimationLoop(playerid,"PED","KO_SHOT_FACE",4.1, 0, 1, 1, 1, 1, 1); 
	}

	return true ;
}

CMD:fall(playerid, params [] ) 
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/fall [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	if (type == 1) AnimationLoop(playerid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1); 
	else if (type == 2) AnimationLoop(playerid, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 0, 1); 

	return true;
}

CMD:carryidle ( playerid, params [] ) {

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

 	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY ) ;

	return true ;
}

CMD:bat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/bat [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
	    case 1: ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 1, 0, 1);
	    case 2: ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 1, 0, 1);
	    case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 1, 1, 1, 0, 1);
	    case 5: AnimationLoop(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: AnimationLoop(playerid, "BASEBALL", "BAT_BLOCK", 4.1, 0, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimation(playerid, "BASEBALL", "BAT_HIT_1", 4.1, 0, 1, 1, 0, 0, 1);
	    case 8: ApplyAnimation(playerid, "BASEBALL", "BAT_M", 4.1, 0, 0, 0, 0, 0, 1);
	}

	return 1;
}

CMD:sword(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/sword [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
	    case 1: ApplyAnimation(playerid, "SWORD", "sword_1", 4.1, 0, 1, 1, 1, 0, 1);
	    case 2: ApplyAnimation(playerid, "SWORD", "sword_2", 4.1, 0, 1, 1, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "SWORD", "sword_3", 4.1, 0, 1, 1, 1, 0, 1);
	    case 4: ApplyAnimation(playerid, "SWORD", "sword_4", 4.1, 0, 1, 1, 1, 0, 1);
	    case 5: AnimationLoop(playerid, "SWORD", "sword_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: AnimationLoop(playerid, "SWORD", "sword_BLOCK", 4.1, 0, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimation(playerid, "SWORD", "sword_HIT_1", 4.1, 0, 1, 1, 0, 0, 1);
	    case 8: ApplyAnimation(playerid, "SWORD", "sword_part", 4.1, 0, 1, 1, 1, 1, 1);
	}

	return 1;
}

CMD:bar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/bar [1-9]");

	if (type < 1 || type > 9)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 1, 0, 1);
		case 5: ApplyAnimation(playerid, "BAR", "Barserve_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimation(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
	    case 7: AnimationLoop(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: AnimationLoop(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 1, 0, 1);
	    case 9: AnimationLoop(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:swim(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/swim [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
	    case 1: AnimationLoop(playerid, "SWIM", "Swim_Tread", 4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "SWIM", "Swim_Glide", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "SWIM", "Swim_Breast", 4.1, 1, 1, 1, 1, 1, 1);
	}

	return 1;
}

CMD:barber(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/barber [1-13]");

	if (type < 1 || type > 14)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
	    case 1: ApplyAnimation(playerid, "haircuts", "brb_beard_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "haircuts", "brb_buy", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "haircuts", "brb_cut", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "haircuts", "brb_cut_in", 4.1, 0, 0, 0, 1, 0, 1); 
		case 5: ApplyAnimation(playerid, "haircuts", "brb_cut_out", 4.1, 0, 0, 0, 1, 0, 1); 
		case 6: ApplyAnimation(playerid, "haircuts", "brb_hair_01", 4.1, 0, 0, 0, 1, 0, 1);
		case 7: ApplyAnimation(playerid, "haircuts", "brb_hair_02", 4.1, 0, 0, 0, 1, 0, 1);
		case 8: ApplyAnimation(playerid, "haircuts", "brb_in", 4.1, 0, 0, 0, 1, 0, 1); 
		case 9: ApplyAnimation(playerid, "haircuts", "brb_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: ApplyAnimation(playerid, "haircuts", "brb_out", 4.1, 0, 0, 0, 1, 0, 1); 
		case 11: ApplyAnimation(playerid, "haircuts", "brb_sit_in", 4.1, 0, 0, 0, 1, 0, 1); 
		case 12: ApplyAnimation(playerid, "haircuts", "brb_sit_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 13: ApplyAnimation(playerid, "haircuts", "brb_sit_out", 4.1, 0, 0, 0, 1, 0, 1); 
	}
	return 1;
}

CMD:wash(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:lay(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/lay [1-5]");

	if (type < 1 || type > 5)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: AnimationLoop(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:workout(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/workout [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: AnimationLoop(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: AnimationLoop(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
	    case 7: AnimationLoop(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:blowjob(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/blowjob [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:bomb(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:carry(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/carry [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:hurt(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/hurt [1-5]");

	if (type < 1 || type > 5)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
	    case 1: AnimationLoop(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "SWAT", "gnstwall_injurd", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "CRACK", "CRCKIDLE1", 4.1, 1, 0, 0, 1, 0, 1);
		case 4: AnimationLoop(playerid, "CRACK", "CRCKIDLE3", 4.1, 1, 0, 0, 1, 0, 1);
		case 5: AnimationLoop(playerid, "heist9", "cas_g2_gasko", 4.1, 0, 0, 0, 1, 0, 1);
	}

	return 1;
}

CMD:injured(playerid, params[])
{
	return cmd_hurt(playerid, params);
}

CMD:crack(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/crack [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: AnimationLoop(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
	    case 4: AnimationLoop(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: AnimationLoop(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: AnimationLoop(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:sleep(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/sleep [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: AnimationLoop(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:dive(playerid, params[]) return cmd_jump(playerid, params);

CMD:deal(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/deal [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: AnimationLoop(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: AnimationLoop(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:dancing(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/dancing [1-10]");

	if (type < 1 || type > 10)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: AnimationLoop(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: AnimationLoop(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: AnimationLoop(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: AnimationLoop(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
	    case 9: AnimationLoop(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
	    case 10: AnimationLoop(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:eat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/eat [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnim(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1);
	    case 2: ApplyAnim(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 1, 1, 1, 1, 1);
	    case 3: ApplyAnim(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:recruit(playerid, params[]) {
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/recruit [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GANGS", "Invite_No", 4.1, 0, 0, 0, 1, 1, 1);
		case 2: ApplyAnim(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 1, 1, 1);
	}
	return 1;
}

CMD:gsign(playerid, params[])
{ 
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/gsign [1-10]");

	if (type < 1 || type > 10)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GHANDS", "gsign1", 	 4.1, 0, 0, 0, 1, 1);
		case 2: ApplyAnim(playerid, "GHANDS", "gsign1LH", 	 4.1, 0, 0, 0, 1, 1);
		case 3: ApplyAnim(playerid, "GHANDS", "gsign2", 	 4.1, 0, 0, 0, 1, 1);
		case 4: ApplyAnim(playerid, "GHANDS", "gsign2LH", 	 4.1, 0, 0, 0, 1, 1);
		case 5: ApplyAnim(playerid, "GHANDS", "gsign3",		 4.1, 0, 0, 0, 1, 1);
		case 6: ApplyAnim(playerid, "GHANDS", "gsign3LH", 	 4.1, 0, 0, 0, 1, 1);
		case 7: ApplyAnim(playerid, "GHANDS", "gsign4", 	 4.1, 0, 0, 0, 1, 1);
		case 8: ApplyAnim(playerid, "GHANDS", "gsign4LH", 	 4.1, 0, 0, 0, 1, 1);
		case 9: ApplyAnim(playerid, "GHANDS", "gsign5", 	 4.1, 0, 0, 0, 1, 1);
		case 10: ApplyAnim(playerid, "GHANDS", "gsign5LH", 	 4.1, 0, 0, 0, 1, 1);
	}
	return 1;
}

CMD:chat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/chat [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:goggles(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:spray(playerid, params[])
{
	new type;

    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/spray [1-2]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "SPRAYCAN", "spraycan_full", 4.1, 0, 0, 0, 0, 0, 1);
	}
 	
	return 1;
}

CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:office(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/office [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:kiss(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/kiss [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:knife(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/knife [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnim(playerid, "KNIFE", "knife_4", 4.1, true, 0, 0, 1, 1, 1);
		case 5: AnimationLoop(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:cpr(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

/*
CMD:aim(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/aim [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: AnimationLoop(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: AnimationLoop(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}*/

CMD:cheer(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/cheer [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:strip(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/strip [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


CMD:slapass( playerid, params [] ) {

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

 	return AnimationLoop(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 0, 0, 0, 0, 1); // Ass Slapping
}

CMD:wave(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/wave [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:smokeidle(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/smokeidle [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "SHOP", "Smoke_RYD", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:reloadanim(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/reloadanim [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) 
	{
		case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid, "TEC", "TEC_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid, "SILENCED", "silence_reload", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:taichi(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:wank(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/wank [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:cover(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}

CMD:hide(playerid, params[]) return cmd_cover(playerid, params);
CMD:cower(playerid, params[]) return cmd_cover(playerid, params);

CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:tired(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/tired [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:sit(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/sit [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0, 1);
		case 3: AnimationLoop(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0, 1);
		case 7: AnimationLoop(playerid, "jst_buisness", "girl_02", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:crossarms(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/crossarms [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: AnimationLoop(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: AnimationLoop(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: AnimationLoop(playerid, "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:fucku(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:walk(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/walk [1-16]");

	if (type < 1 || type > 17)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 2: AnimationLoop(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 3: AnimationLoop(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
	    case 4: AnimationLoop(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 5: AnimationLoop(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
	    case 6: AnimationLoop(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 7: AnimationLoop(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
	    case 8: AnimationLoop(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
	    case 9: AnimationLoop(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
	    case 10: AnimationLoop(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
	    case 11: AnimationLoop(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 12: AnimationLoop(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 13: AnimationLoop(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 14: AnimationLoop(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
	    case 15: AnimationLoop(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 16: AnimationLoop(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:point(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/point [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
	    case 1: AnimationLoop(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: AnimationLoop(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: AnimationLoop(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


CMD:skate(playerid, params[]) {
	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);

/*
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/skate [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}*/
	return 1;
}

CMD:hitchhike(playerid, params[]){
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");


	// Straight from LS-RP (but better)!
	if(! strcmp(params, "left", true)) {

		ApplyAnimation(playerid,"MISC", "Hiker_Pose_L", 4.0, 1, 0, 0, 0, 0); // hitch hike
	}	
	else if(! strcmp(params, "right", true)) {

		ApplyAnimation(playerid,"MISC", "Hiker_Pose", 4.0, 1, 0, 0, 0, 0); // hitch hike
	}
	else return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/hitchhike [left/right]");
	
	return true ;
}
