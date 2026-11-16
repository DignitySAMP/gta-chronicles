CMD:smoke(playerid, params[]) {

	new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/smoke [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GANGS", "smkcig_prtl", 	4.1, true, 0, 0, 1, 1, 1);
		case 2: ApplyAnim(playerid, "GANGS", "smkcig_prtl_F", 	4.1, true, 0, 0, 1, 1, 1);
		case 3: ApplyAnim(playerid, "PED", "pass_Smoke_in_car", 4.1, true, 0, 0, 1, 1, 1);
		case 4: ApplyAnim(playerid, "PED", "smoke_in_car", 		4.1, true, 0, 0, 1, 1, 1);
	}

	return true ;
}


CMD:drink(playerid, params[]) {

	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/drink [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GANGS", "drnkbr_prtl", 4.1, true, 0, 0, 1, 1, 1);
		case 2: ApplyAnim(playerid, "GANGS", "drnkbr_prtl_F", 4.1, true, 0, 0, 1, 1, 1);
	}

	return true ;
}


CMD:use(playerid, params[]) {

	SendClientMessage(playerid, COLOR_RED, "With the addition of the new prop system, this command is deprecated. Use /myprops!");

/*	new type;

	if (!AnimationCheck(playerid)) {
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");
	}

	if (sscanf(params, "d", type)) {
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/use [1: beer - 2: wine - 3: sprunk - 4: ciggy]");
	}

	if (type < 1 || type > 4) {
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");
	}

 	switch ( type ) {

 		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER );
 		case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE );
 		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK );
 		case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY );
 	}*/

 	return true ;
}


CMD:ganghands(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/ganghands [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKB", 4.1, true, 0, 0, 1, 1);
		case 2: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKC", 4.1, true, 0, 0, 1, 1);
		case 3: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKD", 4.1, true, 0, 0, 1, 1);
		case 4: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKE", 4.1, true, 0, 0, 1, 1);
		case 5: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKF", 4.1, true, 0, 0, 1, 1);
		case 6: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKG", 4.1, true, 0, 0, 1, 1);
		case 7: ApplyAnim(playerid, "LOWRIDER", "PRTIAL_GNGTLKH", 4.1, true, 0, 0, 1, 1);
	}
	return 1;
}

CMD:plunger(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "MISC", "PLUNGER_01", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:playidle(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/playidle [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "PLAYIDLES", "SHIFT", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "PLAYIDLES", "SHLDR", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "PLAYIDLES", "STRETCH", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


CMD:carlook(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/carlook [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC1_BL", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC1_BR", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC1_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC1_FR", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC2_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC3_BR", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC3_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC3_FR", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:caranim( playerid, cmdtext[] ) {

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if(isnull(cmdtext)) {
		return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/caranim [relax/tap]");
	}
	
	if(!strcmp(cmdtext, "relax", true, strlen(cmdtext))) {
		AnimationLoop(playerid, "CAR", "sit_relaxed", 4.1, 1, 0, 0, 0, 0, 1);
	}
	else if(!strcmp(cmdtext, "tap", true, strlen(cmdtext))) {	
		AnimationLoop(playerid, "CAR", "Tap_hand", 4.1, 1, 0, 0, 0, 0, 1);	
	}
	else{
		return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/caranim [relax/tap]");
	}

	return 1;
}


CMD:slide(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "AIRPORT", "THRW_BARL_THRW", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:balcony(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/balcony [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "BD_FIRE", "BD_PANIC_01", 4.1, 0, 0, 0, 1, 0, 1);
		case 2: ApplyAnimation(playerid, "BD_FIRE", "BD_PANIC_02", 4.1, 0, 0, 0, 1, 0, 1);
		case 3: ApplyAnimation(playerid, "BD_FIRE", "BD_PANIC_03", 4.1, 0, 0, 0, 1, 0, 1);
		case 4: ApplyAnimation(playerid, "BD_FIRE", "BD_PANIC_04", 4.1, 0, 0, 0, 1, 0, 1);
	}

	return 1;
}


CMD:driverko(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "BIKELEAP", "STRUGGLE_DRIVER", 4.1, 1, 0, 0, 0, 0, 1);	
	return 1;
}

CMD:bikepunch(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/bikepunch [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "BIKES", "BIKES_SNATCH_L", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "BIKES", "BIKES_SNATCH_R", 4.1, 0, 0, 0, 0, 0, 1);
	}

	return 1;
}


CMD:gunhold(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BUDDY", "BUDDY_RELOAD", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:cmon(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "CAMERA", "CAMCRCH_CMON", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:squat(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "CAMERA", "CAMCRCH_TO_CAMSTND", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:look(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/look [1-2]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "CAMERA", "CAMSTND_LKABT", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "ON_LOOKERS", "LKAROUND_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}


CMD:undercar(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/undercar [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CAR", "FIXN_CAR_LOOP", 4.1, 1, 0, 0, 0, 0, 1);	
		case 2: ApplyAnimation(playerid, "CAR", "FIXN_CAR_OUT", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid, "BENCHPRESS", "GYM_BP_GETON", 4.1, 0, 0, 0, 1, 0, 1);	
	}

	return 1;
}

CMD:flagdrop(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "CAR", "FLAG_DROP", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:liftup(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/liftup [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "FOOD", "SHP_TRAY_LIFT", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "BOX", "CATCH_BOX", 4.1, 0, 0, 0, 0, 0, 1);
	}

	return 1;
}
CMD:liftdown(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:carphone(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/carphone [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CAR_CHAT", "CARFONE_IN",  4.1, 0, 0, 0, 0, 1, 1);
		case 2: AnimationLoop(playerid,"CAR_CHAT", "CARFONE_LOOPA",  4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,"CAR_CHAT", "CARFONE_LOOPA_TO_B", 4.1, 0, 0, 0, 1, 0, 1);
	}

	return 1;
}


CMD:carfuss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/carfuss [1-10]");

	if (type < 1 || type > 10)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CAR_CHAT", "CAR_SC1_BL", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC1_BR", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC1_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC1_FR", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC2_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC3_BR", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC3_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC4_BR", 4.1, 1, 0, 0, 0, 0, 1);
		case 9: AnimationLoop(playerid,	"CAR_CHAT", "CAR_SC4_FL", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: AnimationLoop(playerid,"CAR_CHAT", "CAR_SC4_FR", 4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}


CMD:cartalk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/cartalk [1-3]");

	if (type < 1 || type > 3)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CAR_CHAT", "CAR_TALKM_IN", 4.1, 0, 0, 0, 1, 0, 1);
		case 2: AnimationLoop(playerid,	"CAR_CHAT", "CAR_TALKM_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	"CAR_CHAT", "CAR_TALKM_OUT", 4.1, 0, 0, 0, 1, 0, 1);
	}

	return 1;
}
CMD:casino(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/casino [1-5]");

	if (type < 1 || type > 5)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CASINO", "CARDS_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid,	"CASINO", "ROULETTE_BET", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	"CASINO", "ROULETTE_LOSE", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid,	"CASINO", "SLOT_PLYR", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid,	"CASINO", "SLOT_WIN_OUT", 4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}

CMD:clothes(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/clothes [1-6]");

	if (type < 1 || type > 6)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "CLOTHES", "CLO_BUY", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid,	"CLOTHES", "CLO_POSE_LEGS", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	"CLOTHES", "CLO_POSE_LOOP",  4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid,	"CLOTHES", "CLO_POSE_SHOES", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid,	"CLOTHES", "CLO_POSE_WATCH", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid,	"CLOTHES", "CLO_POSE_TORSO", 4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}

CMD:copambient(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/copambient [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid,  "COP_AMBIENT", "COPBROWSE_LOOP",	4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid,	 "COP_AMBIENT", "COPBROWSE_NOD", 	4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	 "COP_AMBIENT", "COPBROWSE_SHAKE",	4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimationLoop(playerid,	 "COP_AMBIENT", "COPLOOK_LOOP", 	4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimationLoop(playerid,	 "COP_AMBIENT", "COPLOOK_SHAKE", 	4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid,	 "COP_AMBIENT", "COPLOOK_THINK", 	4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid,	 "COP_AMBIENT", "COPLOOK_WATCH", 	4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}


// NEW 04/04/20

CMD:batidle(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/batidle [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid,  "CRACK", "BBALBAT_IDLE_01",	4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid,	 "CRACK", "BBALBAT_IDLE_02", 	4.1, 1, 0, 0, 0, 0, 1);
	}

	return 1;
}

CMD:press(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid,	 "CRIB", "CRIB_USE_SWITCH", 	4.1, 0, 0, 0, 0, 0, 1);

	return 1;
}


CMD:handstand(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "DAM_JUMP", "DAM_DIVE_LOOP",  4.1, 0, 0, 0, 1, 0, 1);

	return 1;
}


CMD:gethit(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "DILDO", "DILDO_HIT_1",  4.1, 0, 0, 0, 0, 0, 1);

	return 1;
}
CMD:knifehold(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "DILDO", "DILDO_IDLE",  4.1, 1, 0, 0, 0, 0, 1);

	return 1;
}


CMD:pointgun(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	AnimationLoop(playerid, "FAT", "FATIDLE_ROCKET",  4.1, 1, 0, 0, 0, 0, 1);

	return 1;
}
CMD:guardstance(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/guardstance [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: AnimationLoop(playerid, "FIGHT_B", "FIGHTB_IDLE",  4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimationLoop(playerid, "FIGHT_D", "FIGHTD_IDLE",  4.1, 1, 0, 0, 0, 0, 1);
	}
	
	return 1;
}

CMD:fight(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/fight [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "FIGHT_B", "HITB_1",	4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "FIGHT_B", "HITB_2", 	4.1, 0, 0, 0, 0, 0, 1);
		case 3: AnimationLoop(playerid,	 "FIGHT_C", "FIGHTC_G", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "FIGHT_D", "FIGHTD_1", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "FIGHT_D", "FIGHTD_2", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "FIGHT_D", "FIGHTD_3", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid, "FIGHT_D", "FIGHTD_G", 4.1, true, 0, 0, 0, 0, 1);
	}

	return 1;
}

CMD:switchseat(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/switchseat [1-2]");

	if (type < 1 || type > 2)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "FINALE2", "FIN_SWITCH_P",  4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "FINALE2", "FIN_SWITCH_S",  4.1, 0, 0, 0, 0, 0, 1);
	}
	
	return 1;
}
CMD:pistolwhip(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "FLOWERS", "FLOWER_ATTACK_M",  4.1, 0, 0, 0, 0, 0, 1);

	return 1;
}


CMD:laugh(playerid, params[]) {
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnim(playerid, "RAPPING", "Laugh_01", 4.1, false, 0, 0, 0, 0, 1);

	return true ;
}
CMD:cry(playerid, params[]) {
    if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnim(playerid,  "GRAVEYARD", "mrnF_loop", 4.1, true, 0, 0, 0, 0, 1);

	return true ;
}



CMD:bop(playerid, params[]) {

	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/bop [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GYMNASIUM", "GYM_TREAD_CELEBRATE", 	4.1, true, 0, 0, 1, 1, 1);
		case 2: ApplyAnim(playerid, "LOWRIDER", "RAP_A_LOOP",	4.1, true, 0, 0, 1, 1, 1);
		case 3: ApplyAnim(playerid, "LOWRIDER", "RAP_B_LOOP", 4.1, true, 0, 0, 1, 1, 1);
		case 4: ApplyAnim(playerid, "LOWRIDER", "RAP_C_LOOP",	4.1, true, 0, 0, 1, 1, 1);
	}

	return true ;
}

CMD:lowrider(playerid, params[]) {
	new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/lowrider [1-15]");

	if (type < 1 || type > 15)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_BDBNCE",	4.1, true, 0, 0, 1, 1, 1);
		case 2: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_HAIR",	4.1, true, 0, 0, 1, 1, 1);
		case 3: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_HURRY",	4.1, true, 0, 0, 1, 1, 1);
		case 4: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_IDLELOOP",	4.1, true, 0, 0, 1, 1, 1);
		case 5: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_IDLE_TO_L0",	4.1, true, 0, 0, 1, 1, 1);
		case 6: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L0_BNCE",	4.1, true, 0, 0, 1, 1, 1);
		case 7: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L0_TO_L1",	4.1, true, 0, 0, 1, 1, 1);
		case 8: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L12_TO_L0",	4.1, true, 0, 0, 1, 1, 1);
		case 9: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L1_TO_L2",	4.1, true, 0, 0, 1, 1, 1);
		case 10: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L2_BNCE",	4.1, true, 0, 0, 1, 1, 1);
		case 11: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L2_TO_L3",	4.1, true, 0, 0, 1, 1, 1);
		case 12: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L3_BNCE",	4.1, true, 0, 0, 1, 1, 1);
		case 13: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L3_LOOP",	4.1, true, 0, 0, 1, 1, 1);
		case 14: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L4_BNCE",	4.1, true, 0, 0, 1, 1, 1);
		case 15: ApplyAnim(playerid, "LOWRIDER", "LRGIRL_L4_LOOP",	4.1, true, 0, 0, 1, 1, 1);
	}

	return true ;
}

CMD:gfunk(playerid, params[]) {

	new type;

	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/gfunk [1-4]");

	if (type < 1 || type > 4)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GFUNK", "DANCE_G3", 4.1, true, false, false, false, 0, false); // gfunk 1
		case 2: ApplyAnim(playerid, "GFUNK", "DANCE_G4", 4.1, true, false, false, false, 0, false); // gfunk 2
		case 3: ApplyAnim(playerid, "GFUNK", "DANCE_G7", 4.1, false, false, false, false, 0, false); // gfunk 3
		case 4: ApplyAnim(playerid, "GFUNK", "DANCE_G7", 4.1, true, false, false, false, 0, false); // gfunk 4
	}

	return true ;
}

CMD:angry(playerid, params[]){

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnim(playerid, "RIOT", "RIOT_ANGRY", 4.1, true, false, false, false, 0, false); // dj 1

	return true;
}

CMD:dj(playerid, params[]) {

	new type;

	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/dj [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnim(playerid, "GFUNK", "DANCE_G10", 4.1, true, false, false, false, 0, false); // dj 1
		case 2: ApplyAnim(playerid, "GFUNK", "DANCE_G11", 4.1, true, false, false, false, 0, false); // dj 2
		case 3: ApplyAnim(playerid, "GFUNK", "DANCE_G12", 4.1, true, false, false, false, 0, false); // dj 3
		case 4: ApplyAnim(playerid, "GFUNK", "DANCE_G13", 4.1, true, false, false, false, 0, false); // dj 4
		case 5: AnimationLoop(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimationLoop(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimationLoop(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: AnimationLoop(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
	}

	return true ;
}


// NEW by Sporks

CMD:aim(playerid, params[])
{
    if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/aim [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type)
	{
		case 1: AnimationLoop(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
		case 2: AnimationLoop(playerid, "PED", "gang_gunstand", 4.0, 1, 0, 0, 0, 0);
		case 3: AnimationLoop(playerid, "SHOP", "SHP_GUN_AIM", 4.1, 0, 1, 1, 1, 1000);
		case 4: AnimationLoop(playerid, "SHOP", "SHP_DUCK_FIRE", 4.1, 0, 1, 1, 1, 1000);
		case 5: AnimationLoop(playerid, "PED", "gun_stand", 4.1, 1, 0, 0, 0, 0);
		case 6: AnimationLoop(playerid, "POLICE", "COP_getoutcar_lhs", 4.1, 0, 1, 1, 1, 1000);
		case 7: AnimationLoop(playerid, "POOL", "POOL_IDLE_STANCE", 4.1, 1, 0, 0, 0, 0);
	}

	return true;
}

CMD:aimgun(playerid, params[]) return cmd_aim(playerid, params);

CMD:patdown(playerid)
{
	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "POLICE", "plc_drgbst_01", 4.1, 0, 0, 0, 0, 2000, 1);
	return true;
}

CMD:foodsit(playerid, params[])
{
	if (!AnimationCheck(playerid))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/foodsit [1-8]");

	if (type < 1 || type > 8)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type)
	{
		case 1: AnimationLoop(playerid,"FOOD", "FF_Sit_Eat1", 4.1, 1, 0, 0, 0, 0);
		case 2: AnimationLoop(playerid,"FOOD", "FF_Sit_Eat2", 4.1, 1, 0, 0, 0, 0);
		case 3: AnimationLoop(playerid,"FOOD", "FF_Sit_Eat3", 4.1, 1, 0, 0, 0, 0);
		case 4: AnimationLoop(playerid,"FOOD", "FF_Sit_In", 4.1, 0, 0, 0, 1, 0);
		case 5: AnimationLoop(playerid,"FOOD", "FF_Sit_In_L", 4.1, 0, 0, 0, 1, 0);
		case 6: AnimationLoop(playerid,"FOOD", "FF_Sit_In_R", 4.1, 0, 0, 0, 1, 0);
		case 7: AnimationLoop(playerid,"FOOD", "FF_Sit_Look", 4.1, 1, 0, 0, 0, 0);
		case 8: AnimationLoop(playerid,"FOOD", "FF_Sit_Loop", 4.1, 1, 0, 0, 0, 0);
	}

	return true;
}

CMD:siteat(playerid, params[]) return cmd_foodsit(playerid, params);
CMD:sitfood(playerid, params[]) return cmd_foodsit(playerid, params);

CMD:swatraid(playerid, params[])
{
	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	new type ;
	if (sscanf(params, "d", type))
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "/swatraid [1-7]");

	if (type < 1 || type > 7)
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "Invalid type specified.");

	switch (type)
	{
		case 1: ApplyAnim(playerid,"SWAT","swt_breach_01",4.0,0,1, 1, 1, 4000);
		case 2: ApplyAnim(playerid,"SWAT","swt_breach_02",4.0,0,1, 1, 1, 4000);
		case 3: ApplyAnim(playerid,"SWAT","swt_breach_03",4.0,0,1, 1, 1, 4000);
		case 4: ApplyAnim(playerid,"SWAT","swt_wllshoot_in_L",4.0,0,1, 1, 1, 1000);
		case 5: ApplyAnim(playerid,"SWAT","swt_wllshoot_out_L",4.0,0,1, 1, 1, 1000);
		case 6: ApplyAnim(playerid,"SWAT","swt_wllshoot_in_R",4.0,0,1, 1, 1, 1000);
		case 7: ApplyAnim(playerid,"SWAT","swt_wllshoot_out_R",4.0,0,1, 1, 1, 1000);
	}

	return true;
}

static ForcedLoopingAnim(playerid, animlib[], animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    for (new i = 0; i < 10; i++)
    {
    	AnimationLoop(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp, 1);
   	}
}

CMD:jogging(playerid)
{
	if (!AnimationCheck(playerid, true)) // don't allow while cuffed
	    return SendServerMessage( playerid, COLOR_RED, "Animation", "DEDEDE", "You can't perform animations at the moment.");

	if (IsPlayerMale(playerid))
	{
		ForcedLoopingAnim(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 100);
	}
	else
	{
		ForcedLoopingAnim(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 100);
	}

	return true;
}

CMD:jog(playerid) return cmd_jogging(playerid);


/*



ApplyAnimation(playerid, "FREEWEIGHTS", "GYM_BARBELL", 4.1, true, false, false, true, 0, false); // dumbellraises
ApplyAnimation(playerid, "FREEWEIGHTS", "GYM_FREE_CELEBRATE", 4.1, false, false, false, true, 0, false); // stretch 2

ApplyAnimation(playerid, "GANGS", "INVITE_YES", 4.1, false, false, false, true, 0, false); // yes
ApplyAnimation(playerid, "GANGS", "INVITE_NO", 4.1, false, false, false, true, 0, false); // no

ApplyAnimation(playerid, "GANGS", "SHAKE_CARA", 4.1, false, false, false, true, 0, false); // shakecar 1
ApplyAnimation(playerid, "GANGS", "SHAKE_CARK", 4.1, false, false, false, true, 0, false); // shakecar 2
ApplyAnimation(playerid, "GANGS", "SHAKE_CARSH", 4.1, false, false, false, true, 0, false); // shakecar 3

ApplyAnimation(playerid, "GHETTO_DB", "GDB_CAR2_SWE", 4.1, false, false, false, true, 0, false); // carfuss 8
ApplyAnimation(playerid, "GHETTO_DB", "GDB_CAR2_PLY", 4.1, false, false, false, true, 0, false); // carfuss 9
ApplyAnimation(playerid, "GHETTO_DB", "GDB_CAR_SWE", 4.1, true, false, false, true, 0, false); // carfuss 10
ApplyAnimation(playerid, "GHETTO_DB", "GDB_CAR_SMO", 4.1, true, false, false, true, 0, false); // carfuss 11
ApplyAnimation(playerid, "GHETTO_DB", "GDB_CAR_RYD", 4.1, true, false, false, true, 0, false); // carfuss 12



ApplyAnimation(playerid, "HAIRCUTS", "BRB_HAIR_01", 4.1, true, false, false, true, 0, false); // haircut 1
ApplyAnimation(playerid, "HAIRCUTS", "BRB_HAIR_02", 4.1, true, false, false, true, 0, false); // haircut 2
ApplyAnimation(playerid, "HAIRCUTS", "BRB_SIT_IN", 4.1, false, false, false, true, 0, false); // haircut 3

ApplyAnimation(playerid, "HEIST9", "Use_SWIPECARD", 4.1, false, false, false, false, 0, false); // swipe
ApplyAnimation(playerid, "INT_HOUSE", "WASH_UP", 4.1, false, false, false, false, 0, false); // wash 2
ApplyAnimation(playerid, "INT_SHOP", "SHOP_CASHIER", 4.1, false, false, false, false, 0, false); // cashier
ApplyAnimation(playerid, "INT_SHOP", "SHOP_LOOKA", 4.1, true, false, false, false, 0, false); // look 1
ApplyAnimation(playerid, "JST_BUISNESS", "GIRL_01", 4.1, true, true, true, false, 0, false); // girlfuss 1
ApplyAnimation(playerid, "JST_BUISNESS", "GIRL_02", 4.1, true, true, true, false, 0, false); // crossleg

ApplyAnimation(playerid, "KISSING", "GF_CARARGUE_01", 4.1, true, false, false, false, 0, false); // argue 1
ApplyAnimation(playerid, "KISSING", "GF_CARARGUE_02", 4.1, true, false, false, false, 0, false); // argue 2
ApplyAnimation(playerid, "KISSING", "GF_STREETARGUE_01", 4.1, true, false, false, false, 0, false); // argue 3
ApplyAnimation(playerid, "KISSING", "GF_STREETARGUE_02", 4.1, true, false, false, false, 0, false); // argue 4

ApplyAnimation(playerid, "KISSING", "GIFT_GIVE", 4.1, false, false, false, false, 0, false); // givegift
ApplyAnimation(playerid, "KISSING", "GIFT_GET", 4.1, false, false, false, false, 0, false); // getgift
ApplyAnimation(playerid, "KNIFE", "KNIFE_4", 4.1, false, false, false, false, 0, false); // stomp 7
ApplyAnimation(playerid, "MD_CHASE", "CARHIT_TUMBLE", 4.1, false, true, true, true, 0, false); // carhit-tumble
ApplyAnimation(playerid, "MD_CHASE", "MD_BIKE_LND_ROLL", 4.1, false, true, true, true, 0, false); // rolldie 1
ApplyAnimation(playerid, "MD_CHASE", "MD_BIKE_LND_ROLL_F", 4.1, false, true, true, true, 0, false); // rolldie 2
ApplyAnimation(playerid, "MD_CHASE", "MD_HANG_LND_ROLL", 4.1, false, true, true, true, 0, false); // rolldie 3
ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, false, true, true, false, 0, false); // cpr
ApplyAnimation(playerid, "MISC", "BITCHSLAP", 4.1, false, true, true, true, 0, false); // bslap
ApplyAnimation(playerid, "MISC", "BNG_WNDW", 4.1, false, true, true, true, 0, false); // wndw 1
ApplyAnimation(playerid, "MISC", "BNG_WNDW_02", 4.1, false, true, true, true, 0, false); // wndw 2
ApplyAnimation(playerid, "MISC", "CASE_PICKUP", 4.1, false, true, true, false, 0, false); // casepick
ApplyAnimation(playerid, "MISC", "PLUNGER_01", 4.1, false, true, true, false, 0, false); // plunger 1
ApplyAnimation(playerid, "MISC", "PLYR_SHKHEAD", 4.1, false, true, true, false, 0, false); // facepalm 2
ApplyAnimation(playerid, "MISC", "SCRATCHBALLS_01", 4.1, false, true, true, false, 0, false); // scballs
ApplyAnimation(playerid, "MUSCULAR", "MUSCLEIDLE_ROCKET", 4.1, false, false, false, true, 0, false); // pointgun 2
ApplyAnimation(playerid, "ON_LOOKERS", "LKAROUND_LOOP", 4.1, true, false, false, false, 0, false); // lookout
ApplyAnimation(playerid, "ON_LOOKERS", "LKUP_LOOP", 4.1, false, false, false, false, 0, false); // lookup
ApplyAnimation(playerid, "ON_LOOKERS", "LKUP_POINT", 4.1, false, false, false, false, 0, false); // lookpoint
ApplyAnimation(playerid, "ON_LOOKERS", "PANIC_HIDE", 4.1, true, false, false, false, 0, false); // panic 1
ApplyAnimation(playerid, "ON_LOOKERS", "PANIC_COWER", 4.1, true, false, false, false, 0, false); // panic 2
ApplyAnimation(playerid, "ON_LOOKERS", "PANIC_LOOP", 4.1, true, false, false, false, 0, false); // panic 3
ApplyAnimation(playerid, "ON_LOOKERS", "PANIC_POINT", 4.1, true, false, false, false, 0, false); // panic 3
ApplyAnimation(playerid, "ON_LOOKERS", "PANIC_SHOUT", 4.1, true, false, false, false, 0, false); // panic 4
ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, true, false, false, false, 0, false); // scribble
ApplyAnimation(playerid, "OTB", "WTCHRACE_CMON", 4.1, true, false, false, false, 0, false); // cmon 2
ApplyAnimation(playerid, "OTB", "WTCHRACE_WIN", 4.1, true, false, false, false, 0, false); // victory
ApplyAnimation(playerid, "PLAYIDLES", "SHIFT", 4.1, true, false, false, false, 0, false); // idle 1
ApplyAnimation(playerid, "PLAYIDLES", "SHLDR", 4.1, true, false, false, false, 0, false); // idle 2
ApplyAnimation(playerid, "PLAYIDLES", "STRETCH", 4.1, true, false, false, false, 0, false); // idle 3
ApplyAnimation(playerid, "PLAYIDLES", "STRLEG", 4.1, true, false, false, false, 0, false); // idle 4
ApplyAnimation(playerid, "PLAYIDLES", "TIME", 4.1, true, false, false, false, 0, false); // idle 5
ApplyAnimation(playerid, "POLICE", "COPTRAF_AWAY", 4.1, true, false, false, false, 0, false); // copwave 1
ApplyAnimation(playerid, "POLICE", "COPTRAF_COME", 4.1, true, false, false, false, 0, false); // copwave 2
ApplyAnimation(playerid, "POLICE", "COPTRAF_LEFT", 4.1, true, false, false, false, 0, false); // copwave 3
ApplyAnimation(playerid, "POLICE", "COPTRAF_STOP", 4.1, true, false, false, false, 0, false); // copwave 4
ApplyAnimation(playerid, "POLICE", "COP_MOVE_FWD", 4.1, true, true, true, false, 0, false); // copmove 1
ApplyAnimation(playerid, "POLICE", "CRM_DRGBST_01", 4.1, false, true, true, false, 0, false); // busted
ApplyAnimation(playerid, "POLICE", "DOOR_KICK", 4.1, false, true, true, false, 0, false); // doorkick
ApplyAnimation(playerid, "PYTHON", "PYTHON_CROUCHRELOAD", 4.1, false, false, false, true, 0, false); // python 1
ApplyAnimation(playerid, "PYTHON", "PYTHON_FIRE", 4.1, false, false, false, true, 0, false); // python 2
ApplyAnimation(playerid, "PYTHON", "PYTHON_FIRE_POOR", 4.1, false, false, false, true, 0, false); // python 3
ApplyAnimation(playerid, "PYTHON", "PYTHON_RELOAD", 4.1, false, false, false, true, 0, false); // python 4
ApplyAnimation(playerid, "RAPPING", "RAP_C_LOOP", 4.1, true, false, false, false, 0, false); // bop 5
ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY", 4.1, false, false, false, true, 0, false); // mad
ApplyAnimation(playerid, "RIOT", "RIOT_CHALLENGE", 4.1, false, false, false, true, 0, false); // mad 2
ApplyAnimation(playerid, "ROCKET", "WALK_ROCKET", 4.1, true, true, true, true, 0, false); // gnpointwalk 1

ApplyAnimation(playerid, "RYDER", "RYD_BECKON_01", 4.1, false, false, false, false, 0, false); // beckon 1
ApplyAnimation(playerid, "RYDER", "RYD_BECKON_02", 4.1, false, false, false, false, 0, false); // beckon 2
ApplyAnimation(playerid, "RYDER", "RYD_BECKON_03", 4.1, false, false, false, false, 0, false); // beckon 3

ApplyAnimation(playerid, "SPRAYCAN", "SPRAYCAN_FULL", 4.1, false, false, false, false, 0, false); // spray 2

ApplyAnimation(playerid, "WOP", "DANCE_G5", 4.1, true, false, false, false, 0, false); // wop 1



ApplyAnimation(playerid, "RUNNINGMAN", "DANCE_G9", 4.1, true, false, false, false, 0, false); // moonwalk 1
ApplyAnimation(playerid, "RUNNINGMAN", "DANCE_G14", 4.1, true, false, false, false, 0, false); // moonwalk 2
ApplyAnimation(playerid, "RUNNINGMAN", "DANCE_B12", 4.1, false, false, false, false, 0, false); // dab
ApplyAnimation(playerid, "VENDING", "VEND_DRINK_P", 4.1, false, false, false, false, 0, false); // drink 2*/