


ShowVehicleCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Vehicle Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/mycars, /carfind, /engine, /carlock, /carlights, /carwindow");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/cartrunk, /carhood, /carcheck, /setstation, /seatbelt");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/carspawn, /cardespawn, /cartransfer, /carsell, /carattach");
	SendClientMessage(playerid, 0xF87070FF, "[STORAGE]: {FDBCBC}/cartrunkstoregun (/ctsgun), /cartrunktakegun (/cttgun)");
	SendClientMessage(playerid, 0xF87070FF, "[STORAGE]: {FDBCBC}/cartrunkstoredrug (/ctsdrug), /cartrunktakedrug (/cttdrug)");
	SendClientMessage(playerid, 0xF87070FF, "[STORAGE]: {FDBCBC}/cartrunkcheck (/ctcheck, /cartrunkshow), /carscrap, /cartow, /carcolor");
	SendClientMessage(playerid, 0xFFCC68FF, "[MISC]: {FFE1A8}/removemods, /setaw, /vehiclename, /carblink, /cardoor [open/close]");

	return true ;
}


ShowPropertyCommands(playerid) {
		
	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Property Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/myproperties, /propertybuy, /propertysell, /propertylock, /propertyfind");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/propertytransfer, /propertyscrap, /nosound, /furnihelp, /propertycollect");
	SendClientMessage(playerid, 0xFFCC68FF, "[RENTING]: {FFE1A8}/(un)rentroom, /propertyrent, /propertyinvite, /propertyevict");
	SendClientMessage(playerid, 0xF87070FF, "[STORAGE]: {FDBCBC}/propstorage, /propstoregun, /proptakegun, /propstoredrug, /proptakedrug");
	SendClientMessage(playerid, 0x77BBFAFF, "[COMMUNICATION]: {BBDEFF}/doorknock, /doorbell, /doorshout, /doorme, /doordo");
	SendClientMessage(playerid, 0x77BBFAFF, "[MISC/NEW]: {DEDEDE}/propertyad, /propertyname, /propertynamecolor, /propertywardrobe");
	SendClientMessage(playerid, 0x77BBFAFF, "[MISC/NEW]: {DEDEDE}/propertyexitpoint, /propertytime, /propertyweather, /propertyaudio");
	return true;
}

ShowGunCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Gun Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/passgun, /passammo, /seta(rmed)w(eapon)");
	ZMsg_SendClientMessage(playerid, 0xed7a34FF, "If you want to store / retrieve a gun, see /help property or /help vehicle.");

	return true;
}

ShowJobCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Job Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[DOCKWORKER]:{B2FFCD} /cargojob, /cargostop, /cargocollect, /cargostore") ;
	SendClientMessage(playerid, 0xF87070FF, "[TRUCKER]:{FDBCBC} /transport, /crate [pickup / putdown / list / reset]") ;
	SendClientMessage(playerid, 0xFFCC68FF, "[GARBAGEMAN]:{FFE1A8} Go to the trash depot (/gps) and enter a garbage truck!") ;

	return true ;
}

ShowDrugCommands(playerid){

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Drug Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[STORAGE]: {B2FFCD}/mydrugs, /drugsupplies, /drugcontainers (/drugpackages)" ) ;
	SendClientMessage(playerid, 0xF87070FF, "[PRODUCTION]: {FDBCBC}/drugsnear, /buysupplies, /drugsetup, /drugproduce (/drugwater, /drugcook), /drugcollect" ) ;
	SendClientMessage(playerid, 0xFFCC68FF, "[USAGE]: {FFE1A8}/druguse, /drugpass, /blunt, /stopdrugeffect [will not refund], /drugsplit, /drugmerge" ) ;

	return true;
}

ShowVoiceCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Voiceline Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "{B2FFCD}/voicelines - Shows all possible voicelines in a list");
	SendClientMessage(playerid, 0xF87070FF, "{FDBCBC}/myvoices - A list of your saved voicelines");
	SendClientMessage(playerid, 0xFFCC68FF, "{FFE1A8}/vl - Play a voiceline from your saved voicelines");

	return true ;
}

ShowPhoneCommands(playerid) {
	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Phone Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]:{B2FFCD} /ph(one), /pc, /ph(one)anim");
	SendClientMessage(playerid, 0xF87070FF, "[TEXTING]:{FDBCBC} /inbox, /sms");
	SendClientMessage(playerid, 0xFFCC68FF, "[CALLING]:{FFE1A8} /call, /h(angup), /pickup");

	return true;
}

ShowFurniCommands(playerid) {


	SendClientMessage(playerid, 0x5FB9D1FF, "[ ___________ Furniture Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "{B2FFCD}/furnimode - use this at your property exit point");
	SendClientMessage(playerid, 0xF87070FF, "{FDBCBC}/furni - to buy new furniture, for a price");
	SendClientMessage(playerid, 0xFFCC68FF, "{FFE1A8}/furnilist - shows a list of all furniture spawned in the property");
	SendClientMessage(playerid, 0xFFCC68FF, "{FFE1A8}/furniedit - lets you select furniture to edit");
	SendClientMessage(playerid, 0x77BBFAFF, "{BBDEFF}/furniwipe - removes and refunds all furni");
	SendClientMessage(playerid, 0x58DD85FF, "{B2FFCD}/intfurni - lets you change interior to blank interior");
	SendClientMessage(playerid, 0x58DD85FF, "{B2FFCD}/furniperm - gives another player furniture permissions");

	return true ;
}


ShowSpraytagCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Spraytag Commands  ___________ ]");
	SendClientMessage(playerid, COLOR_GRAD0, "{B2FFCD}/s(pray)t(ag)choose - pick a static and/or dynamic tag");
	SendClientMessage(playerid, COLOR_GRAD1, "{FDBCBC}/s(pray)t(ag)info - shows information of the spraytag");
	SendClientMessage(playerid, COLOR_GRAD0, "{FFE1A8}/s(pray)t(ag)wipe - lets you wipe the spraytag (LSPD only)");

	return true ;
}

ShowGateCommands(playerid){


	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Gate Commands  ___________ ]");
	SendClientMessage(playerid, COLOR_GRAD0, "{B2FFCD}/gate - opens / closes a gate.");
	/*if ( Account [ playerid ] [ E_PLAYER_ACCOUNT_STAFFLEVEL ] > ADMIN_LVL_NONE ) {

		SendClientMessage(playerid, COLOR_YELLOW, "When using admin commands on gates, use the NORMAL ID. Not the SQL/Database ID!");
		SendClientMessage(playerid, COLOR_BLUE, "[ADMIN]{A3A3A3}/gatecreate, /gateradius, /gateopen, /gatemove, /gatetexture");
		SendClientMessage(playerid, COLOR_BLUE, "[ADMIN]{DEDEDE}/gateworld, /gateint, /gatetype, /gatedelete, /gatespeed");
	}*/
	
	return true ;
}

ShowAnimCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ________________________ Available Animations ________________________ ]") ;

	SendClientMessage(playerid, 0xF1D55EFF, "» Actions {FFFFFF}| /time - /jog - /handsup - /crossarms - /spray - /fucku - /wank - /throw - /lean - /gsign") ;
	SendClientMessage(playerid, 0xF1D55EFF, "» Actions {FFFFFF}| /slapass - /wave - /wash - /ganghands - /guardstance - /patdown - /cmon - /jump - /bomb") ;
	SendClientMessage(playerid, 0xF1D55EFF, "» Actions {FFFFFF}| /goggles - /slide - /balcony - /undercar - /flagdrop - /liftup - /casino - /swipe - /press ") ;
	SendClientMessage(playerid, 0xF1D55EFF, "» Actions {FFFFFF}| /cover - /look - /squat - /plunger - /carry - /hitchhike - /camcrouch") ;
	SendClientMessage(playerid, 0x729767FF, "» Express {FFFFFF}| /kiss - /eat - /smoke - /drink - /laugh - /cry - /tired - /facepalm - /angry") ;	
	SendClientMessage(playerid, 0xEF6060FF, "» Injury {FFFFFF}| /injured - /fall - /crack - /ko - /gethit - /fight - /cpr - /getup") ;
	SendClientMessage(playerid, 0xA0765AFF, "» Weapons {FFFFFF}| /aim - /bat - /batidle - /knifehold - /pointgun - /pistolwhip - /riflehold - /knife - /point") ;
	SendClientMessage(playerid, 0xACA179FF, "» Comfort {FFFFFF}| /sit - /lay - /sleep - /foodsit - /office") ;
	SendClientMessage(playerid, 0x81AE99FF, "» Ambient {FFFFFF}| /dance - /gfunk - /playidle - /copambient - /clothes - /recruit - /bop - /handstand - /dj") ;
	SendClientMessage(playerid, 0xF2A55DFF, "» Vehicle {FFFFFF}| /carlook - /caranim - /carphone - /carfuss - /cartalk - /driverko - /lowrider") ;
	SendClientMessage(playerid, 0x985F83FF, "» Particle {FFFFFF}| /puke - /exhale - /shakebottle");

	SendClientMessage(playerid, 0xffffffFF, "To stop an animation use /sa or /stopanim.");

	return 1;
}

ShowKioskCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Kiosk Commands  ___________ ]");
	SendClientMessage(playerid, 0x58DD85FF, "[GENERAL]: {B2FFCD}/k(iosk)t(ake), /k(iosk)r(eturn)");
	
	return true ;
}

ShowMiscCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Miscellaneous Commands  ___________ ]");
	SendClientMessage(playerid, COLOR_GRAD0, "/settings, /pay, /paya(nim), /id, /boombox, /factions, /showinjuries, /tognicks,");
	SendClientMessage(playerid, COLOR_GRAD1, "/bus, /(un)rentvehicle, /taketest, /setchat, /clearcp (/nocp), /synctags, /nosound,");
	SendClientMessage(playerid, COLOR_GRAD0, "/fillcar, /emmet, /carcolorlist, /hudscalefix, /payfine, /license(s), /badge");
	SendClientMessage(playerid, COLOR_GRAD1, "/gascan, /cmc, /dmvcp, /mask, /removemask, /call, /sms, /pickup, /h(angup)");
	SendClientMessage(playerid, COLOR_GRAD0, "/helpup, /surgery, /address (/whereami, /street), /kane, /adminrecord, /playerskin, /rules");
	SendClientMessage(playerid, COLOR_GRAD1, "/blindfold, /accept, /charity, /servertime, /assemble, /collectwood, /collectmetal, /collectparts");
	SendClientMessage(playerid, COLOR_GRAD0, "/advert, /propadvert, /coin, /dice, /greet, /namechange, /toys, /reloadtoys, /buytoys, /pricelist");
	SendClientMessage(playerid, COLOR_GRAD1, "/givefear, /giverespect, /r(espected)c(hat) /dropgun, /synctags, /synctablist, /credits");
	SendClientMessage(playerid, COLOR_GRAD0, "/atc, /toys, /mytoys, /chopshop, /prisoners, /savings, /mytickets, /mycrimes");
	SendClientMessage(playerid, COLOR_GRAD1, "/propertyactive, /lockpick, /smashwindow, /spawn, /myspawns, /dc, /togdc, /gymstats, /fightstyle");
	
	return true ;
}

ShowHelpCommands(playerid) {

	SendClientMessage(playerid, 0xed7a34FF, "[ ___________ Common Server Commands  ___________ ]");

	if(IsPlayerHelper(playerid)) {

		SendClientMessage(playerid, 0xDEDEDEFF, "/help {b8b8b8}[ vehicle, property, guns, job, faction, drug, voice, phone,");
		SendClientMessage(playerid, 0xb8b8b8FF, "furniture, spraytag, basketball, gate, anims, misc, groups, staff ]");

	} else {

		SendClientMessage(playerid, 0xDEDEDEFF, "[COMMANDS]: {DEDEDE}/help {b8b8b8}[ vehicle, property, guns, job, faction, drug, voice, phone,");
		SendClientMessage(playerid, 0xb8b8b8FF, "furniture, spraytag, basketball, gate, anims, misc, groups ]");

	}

	ZMsg_SendClientMessage(playerid, 0xed7a34FF, "Useful commands: {68ed34}/hold, /spawn{DEDEDE}, /mycars, /myproperties, /myguns, /mydrugs, /myslots, /myitems, /myprofile");

	return true;
}


CMD:help(playerid, params[]) {

	new option[32];

	if(sscanf(params, "s[32]", option))
		return ShowHelpCommands(playerid);

	if(!strcmp(option, "property", true) || !strcmp(option, "prop", true) || !strcmp(option, "house", true) || !strcmp(option, "business", true) || !strcmp(option, "houses", true) || !strcmp(option, "properties", true) || !strcmp(option, "businesses", true))
		return ShowPropertyCommands(playerid);

	if(!strcmp(option, "groups", true) || !strcmp(option, "grp", true) || !strcmp(option, "group", true) || !strcmp(option, "grps", true))
		return Group_ShowCommands(playerid);

	if(!strcmp(option, "car", true) || !strcmp(option, "vehicle", true) || !strcmp(option, "veh", true) || !strcmp(option, "v", true) || !strcmp(option, "cars", true) || !strcmp(option, "vehs", true)|| !strcmp(option, "vehicles", true))
		return ShowVehicleCommands(playerid);

	if(!strcmp(option, "gun", true) || !strcmp(option, "guns", true) || !strcmp(option, "weapon", true) || !strcmp(option, "weapons", true)|| !strcmp(option, "firearms", true))
		return ShowGunCommands(playerid);

	if(!strcmp(option, "jobs", true) || !strcmp(option, "job", true) || !strcmp(option, "work", true))
		return ShowJobCommands(playerid);

	if(!strcmp(option, "faction", true) || !strcmp(option, "factions", true))
		return ShowFactionCommands(playerid);

	if(!strcmp(option, "drug", true) || !strcmp(option, "drugs", true))
		return ShowDrugCommands(playerid);

	if(!strcmp(option, "voice", true) || !strcmp(option, "voiceline", true) || !strcmp(option, "voicelines", true))
		return ShowVoiceCommands(playerid);

	if(!strcmp(option, "phone", true) || !strcmp(option, "cell", true) || !strcmp(option, "call", true))
		return ShowPhoneCommands(playerid);

	if(!strcmp(option, "furniture", true) || !strcmp(option, "furni", true) || !strcmp(option, "decorate", true))
		return ShowFurniCommands(playerid);

	if(!strcmp(option, "spray", true) || !strcmp(option, "spraytag", true) || !strcmp(option, "tag", true))
		return ShowSpraytagCommands(playerid);

	if(!strcmp(option, "basket", true) || !strcmp(option, "basketball", true))
		return ShowBasketballCommmands(playerid);

	if(!strcmp(option, "gate", true) || !strcmp(option, "gates", true))
		return ShowGateCommands(playerid);

	if(!strcmp(option, "anim", true) || !strcmp(option, "anims", true))
		return ShowAnimCommands(playerid);

	//if(!strcmp(option, "kiosk", true) || !strcmp(option, "kosk", true))
		//return ShowKioskCommands(playerid);

	if(!strcmp(option, "miscellaneous", true) || !strcmp(option, "misc", true))
		return ShowMiscCommands(playerid);

	if(!strcmp(option, "staff", true) || !strcmp(option, "helper", true) || !strcmp(option, "admin", true))
		return ShowStaffCommands(playerid);


	return true ;
}


// all shortcuts.

// property

CMD:bizhelp(playerid, params[]) {return cmd_propertyhelp(playerid, params);}
CMD:househelp(playerid, params[]) {return cmd_propertyhelp(playerid, params);}
CMD:prophelp(playerid, params[]) {return cmd_propertyhelp(playerid, params);}

CMD:propertyhelp(playerid, params[]) {
	return ShowPropertyCommands(playerid);
}

// car

CMD:vhelp(playerid, params[]) {return cmd_carhelp(playerid, params);}
CMD:vehiclehelp(playerid, params[]) {return cmd_carhelp(playerid, params);}

CMD:carhelp(playerid, params[]) {
	return ShowVehicleCommands(playerid);
}


// guns


CMD:ghelp(playerid, params[]) {return cmd_gunhelp(playerid, params);}
CMD:weaponhelp(playerid, params[]) {return cmd_gunhelp(playerid, params);}

CMD:gunhelp(playerid, params[]) {
	return ShowGunCommands(playerid);
}


// jobs
CMD:truckerhelp(playerid, params[]) {return cmd_jobhelp(playerid, params);}

CMD:jobs(playerid, params[]) {return cmd_jobhelp(playerid, params);}

CMD:jobhelp(playerid, params[]) {
	return ShowJobCommands(playerid);
}


//factions

CMD:fhelp(playerid, params[]) {return cmd_factionhelp(playerid, params);}

CMD:factionhelp(playerid, params[]){
	return ShowFactionCommands(playerid);
}

// drugs

CMD:drughelp(playerid, params[]){
	return ShowDrugCommands(playerid);
}

// voice
CMD:voicehelp(playerid, params[]){
	return ShowVoiceCommands(playerid);
}

// call
CMD:phonehelp(playerid, params[]){
	return ShowPhoneCommands(playerid);
}

// furni

CMD:furniturehelp(playerid, params[]){
	return ShowFurniCommands(playerid);
}

CMD:furnihelp(playerid, params[]){
	return ShowFurniCommands(playerid);
}

// spraytag

CMD:spraytaghelp(playerid, params[]){
	return ShowSpraytagCommands(playerid);
}

CMD:sprayhelp(playerid, params[]){
	return ShowSpraytagCommands(playerid);
}

//gate

CMD:gatehelp(playerid, params[]){
	return ShowGateCommands(playerid);
}

// anims

CMD:animhelp ( playerid, params [] ) {
	return ShowAnimCommands(playerid);
}

CMD:anims ( playerid, params [] ) {
	return ShowAnimCommands(playerid);
}

// kiosk

CMD:kioskhelp ( playerid, params [] ) {
	return ShowKioskCommands(playerid);
}

// misc

CMD:mischelp ( playerid, params [] ) {
	return ShowMiscCommands(playerid);
}

CMD:commands ( playerid, params [] ) {
	return ShowMiscCommands(playerid);
}
