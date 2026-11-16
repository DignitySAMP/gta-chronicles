
TEMP_ReturnPlayerName(playerid) {
	// Find a way to get rid of this redundant function A.S.A.P.

	new name [ MAX_PLAYER_NAME ] ;

	GetPlayerName ( playerid, name, sizeof ( name ) ) ;

	return name ;
}

TRP_ClearAnimations(playerid) {

	ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	new Float: x, Float: y, Float: z ;
	GetPlayerPos ( playerid, x, y, z ) ;
	SetPlayerPos ( playerid, x, y, z + 0.25 ) ;

	return true ;
}

ProxDetector(playerid, Float:max_range, color, string[], Float:max_ratio = 1.6, bool: ignore_own_pid = false ) {

	new Float:pos_x, Float:pos_y, Float:pos_z, Float:range, Float:range_ratio, Float:range_with_ratio ;
	new clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b;

	if ( ! GetPlayerPos(playerid, pos_x, pos_y, pos_z ) ) {

		return 0;
	}
 
	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	new playerroom = GetPlayerSoundRoomArea(playerid);

	foreach (new i : Player) {

		if ( ignore_own_pid ) {

			if ( i == playerid ) {
				continue ;
			}
		}

		// if (!IsPlayerStreamedIn(i, playerid)) continue;
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);

		if (range > max_range) continue;

		if ( GetPlayerInterior ( i ) != GetPlayerInterior ( playerid) ) {
			continue ;
		}

		if ( GetPlayerVirtualWorld( i ) != GetPlayerVirtualWorld ( playerid ) ) {
			continue ;
		}

		new forplayerroom = GetPlayerSoundRoomArea(i);
		//printf("Receiver (%s) (dist %.02f) room: %d", ReturnPlayerNameData(forplayerid, 0, true), range, forplayerroom);

		if (playerroom && forplayerroom && playerroom != forplayerroom)
		{
			// They are in totally different soundproofed rooms (e.g. player 1 is in interview A and player 2 is in interview B)
			range = range * 4; // note we actually increase it to do this as it's distance from the player
		}

		if (playerroom != forplayerroom)
		{
			// One player is perhaps in a room and the other isn't - just REDUCE the range of everything
			range = range * 3; // note we actually increase it to do this as it's distance from the player
		}

		/*
		if (playerroom && SoundRooms[GetPlayerSoundRoom(playerid)][E_SOUNDROOM_BLOCK_OUTSIDE] && playerroom != forplayerroom)
		{
			// Sender is inside a soundroom that should block and recipient is outside so reduce it more
			range = range * 4;
		}
		*/

		if (range > max_range) continue;

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		ZMsg_SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}

	WriteLog ( playerid, "proxdetector", string );

// 	SetPlayerChatBubble(playerid, string, color, max_range, 10000);

	return 1;
}


ProxDetectorActor(actorid, Float:max_range, color, string[], Float:max_ratio = 1.6, bool: ignore_own_pid = false, streamer = false ) {

	new Float:pos_x, Float:pos_y, Float:pos_z, Float:range, Float:range_ratio, Float:range_with_ratio ;
	new clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b;

	if ( streamer ) {
		if ( ! GetDynamicActorPos(actorid, pos_x, pos_y, pos_z ) ) {

			return 0;
		}
	}

	else {
		if ( ! GetActorPos(actorid, pos_x, pos_y, pos_z ) ) {

			return 0;
		}		
	}
 
	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	foreach (new i : Player) {

		if ( ignore_own_pid ) {

			if ( i == actorid ) {
				continue ;
			}
		}

		// if (!IsPlayerStreamedIn(i, playerid)) continue;
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);

		if (range > max_range) continue;

		if ( GetPlayerVirtualWorld( i ) != GetActorVirtualWorld ( actorid ) ) {
			continue ;
		}

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		ZMsg_SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}

	WriteLog ( actorid, "proxdetector", string );

// 	SetPlayerChatBubble(playerid, string, color, max_range, 10000);

	return 1;
}


ProxDetectorObject(objectid, Float:max_range, color, string[], Float:max_ratio = 1.6, streamer = true ) {

	new Float:pos_x, Float:pos_y, Float:pos_z, Float:range, Float:range_ratio, Float:range_with_ratio ;
	new clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b;

	if ( streamer ) {
		if ( ! GetDynamicObjectPos(objectid, pos_x, pos_y, pos_z ) ) {

			return 0;
		}
	}

	else {
		if ( ! GetObjectPos(objectid, pos_x, pos_y, pos_z ) ) {

			return 0;
		}		
	}
 
	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	foreach (new i : Player) {
		// if (!IsPlayerStreamedIn(i, playerid)) continue;
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);

		if (range > max_range) continue;

		if ( GetPlayerVirtualWorld( i ) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID) ) {
			continue ;
		}
		if ( GetPlayerInterior ( i ) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID ) ) {
			continue ;
		}

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		ZMsg_SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}

	WriteLog ( objectid, "proxdetector", string );

// 	SetPlayerChatBubble(playerid, string, color, max_range, 10000);

	return 1;
}

ProxDetectorAutoMe(playerid, Float:max_range, text[], bool:show = false, bool:log = false)
{
	new str[144], output[144];
	format ( str, sizeof ( str ), "%s %s", ReturnPlayerNameData(playerid, 0, true), text ) ;

	format ( output, sizeof ( output ), "** %s", str ) ;
	SetPlayerChatBubble(playerid, output, COLOR_ACTION, max_range, 5000);

	if (log)
	{
		// NEW LOGGING: Log this as a LOG_TYPE_ACTION for sender (playerid)
		AddLogEntry(playerid, LOG_TYPE_ACTION, sprintf("> ** %s", text));

		//WriteLog ( playerid, "chat/annonated", output );
	}

	if (show)
	{
		format ( output, sizeof ( output ), "> ** %s", str ) ;
		SendClientMessage(playerid, COLOR_ACTION, output);
	}

	return true;
}

ProxDetectorNameTag(playerid, Float:max_range, color, text[], extra[], action=0, customcolor=true, invert_action=false, Float:max_ratio = 1.6, bool: ignore_own_pid = false, bool:low=false) 
{

	new Float:pos_x, Float:pos_y, Float:pos_z, Float:range, Float:range_ratio, Float:range_with_ratio ;
	new clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b;

	new full_string[256], final_color ;
	
	new interior = GetPlayerInterior(playerid);
	new world = GetPlayerVirtualWorld(playerid);


	if ( ! GetPlayerPos(playerid, pos_x, pos_y, pos_z ) ) {

		return 0;
	}
 
	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	new playerroom = GetPlayerSoundRoomArea(playerid);
	//printf("Sender (%s) room: %d", ReturnPlayerNameData(playerid, 0, true), playerroom);

	if ( invert_action ) 
	{
		format ( full_string, sizeof ( full_string ), "%s (( %s ))", text, ReturnPlayerNameData(playerid, 0, true )) ;
	}
	else 
	{
		format ( full_string, sizeof ( full_string ), "%s%s %s", ReturnPlayerNameData(playerid,  0, true), extra, text ) ;
	}

	switch ( action ) 
	{
		case 1: strins(full_string, "* ", 0);
		case 2: strins(full_string, "(Windows Open) ", 0);
	}

	foreach (new forplayerid : Player) 
	{
		if (ignore_own_pid && forplayerid == playerid) continue;

		// default color here
		final_color = color;

		if (forplayerid != playerid)
		{
			range = GetPlayerDistanceFromPoint(forplayerid, pos_x, pos_y, pos_z);

			if (GetPlayerInterior(forplayerid) != interior) continue;
			if (GetPlayerVirtualWorld(forplayerid) != world) continue;

			new forplayerroom = GetPlayerSoundRoomArea(forplayerid);
			//printf("Receiver (%s) (dist %.02f) room: %d", ReturnPlayerNameData(forplayerid, 0, true), range, forplayerroom);

			if (playerroom && forplayerroom && playerroom != forplayerroom)
			{
				// They are in totally different soundproofed rooms (e.g. player 1 is in interview A and player 2 is in interview B)
				range = range * 4; // note we actually increase it to do this as it's distance from the player
			}

			if (playerroom != forplayerroom)
			{
				// One player is perhaps in a room and the other isn't - just REDUCE the range of everything
				range = range * 3; // note we actually increase it to do this as it's distance from the player
			}

			/*
			if (playerroom && SoundRooms[GetPlayerSoundRoom(playerid)][E_SOUNDROOM_BLOCK_OUTSIDE] && playerroom != forplayerroom)
			{
				// Sender is inside a soundroom that should block and recipient is outside so reduce it more
				range = range * 4;
			}
			*/

			if (range > max_range) continue;

			range_ratio = (range_with_ratio - range) / range_with_ratio;
			clr_r = floatround(range_ratio * color_r);
			clr_g = floatround(range_ratio * color_g);
			clr_b = floatround(range_ratio * color_b);

			if ( customcolor ) 
			{
				final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
			}
		}

		ZMsg_SendClientMessage(forplayerid, final_color, full_string);
	}

	if (invert_action)
	{
		// NEW LOGGING: Log this as a LOG_TYPE_ACTION for sender (playerid)
		if (low)
		{
			AddLogEntry(playerid, LOG_TYPE_ACTION, sprintf("[Low] %s", full_string));
		}
		else
		{
			AddLogEntry(playerid, LOG_TYPE_ACTION, full_string);
		}
	}
	else if (action)
	{
		// NEW LOGGING: Log this as a LOG_TYPE_ACTION for sender (playerid)
		if (low)
		{
			AddLogEntry(playerid, LOG_TYPE_ACTION, sprintf("[Low] * %s", text));
		}
		else
		{
			AddLogEntry(playerid, LOG_TYPE_ACTION, sprintf("* %s", text));
		}
	}

	return true ;
}


ProxDetectorVehicle(vehicleid, Float:max_range, color, string[], Float:max_ratio = 1.6 ) {

	new Float:pos_x, Float:pos_y, Float:pos_z, Float:range, Float:range_ratio, Float:range_with_ratio ;
	new clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b;


	if ( ! GetVehiclePos(vehicleid, pos_x, pos_y, pos_z ) ) {

		return 0;
	}

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	foreach (new i : Player) {
		// if (!IsPlayerStreamedIn(i, playerid)) continue;
		range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);

		if (range > max_range) continue;

		if ( GetPlayerVirtualWorld( i ) != GetVehicleVirtualWorld(vehicleid) ) {
			continue ;
		}
/*
		if ( GetPlayerInterior ( i ) != GetVehicleInterior ( vehicleid ) ) {
			continue ;
		}*/

		range_ratio = (range_with_ratio - range) / range_with_ratio;
		clr_r = floatround(range_ratio * color_r);
		clr_g = floatround(range_ratio * color_g);
		clr_b = floatround(range_ratio * color_b);

		ZMsg_SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
	}

	WriteLog ( vehicleid, "proxdetector", string );

// 	SetPlayerChatBubble(playerid, string, color, max_range, 10000);

	return 1;
}

stock SendServerMessage ( playerid, color, const prefix[], const hexcolor [], const text[] ) {
// Usage: SendServerMessage(playerid, COLOR_BLUE, "Uh Oh!", "{DEDEDE}, "Your engine has broken down!");
// Returns: {blue}[Uh Oh!]{DEDEDE} Your engine has broken down!

	new string [ 512 ] ;

	format ( string, sizeof ( string ), "[%s]{%s} %s", prefix, hexcolor, text  ) ;

    return SendClientMessage(playerid, color, string ) ;
}

stock SendServerMessageToAll ( color, prefix[], hexcolor[], text[] ) {

	return SendClientMessageToAll(color, sprintf("[%s]{%s} %s", prefix, hexcolor, text ) ) ;
}

stock ReturnIP(playerid) {
	static ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));

	return ip;
}

stock ClearChat(playerid) {

	for_loop ( new i; i < 20; i ++ ) {

		SendClientMessage(playerid, 0xA3A3A3FF, " ");
	}
}


new PlayerConnectSerial [ MAX_PLAYERS ] ;

stock KickPlayer ( playerid, time = 1000 ) {

	defer DisconnectUser[time](playerid, PlayerConnectSerial[playerid]);
    
    return true;
}

timer DisconnectUser[1000](playerid, serial) {

    //print("DisconnectUser timer called (main.pwn)");

	if ( serial != PlayerConnectSerial[playerid] ) return 0 ;

    return Kick ( playerid ) ;
}


stock IsNumeric(const string[])
{
	for_loop (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}


IsPlayerNearPlayer(playerid, targetid, Float:radius) {
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return GetPlayerState(targetid) != PLAYER_STATE_SPECTATING && (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock SetPlayerToFacePlayer(playerid, targetid)
{
	new
	    Float:x[2],
	    Float:y[2],
	    Float:z[2],
	    Float:angle;

	GetPlayerPos(targetid, x[0], y[0], z[0]);
	GetPlayerPos(playerid, x[1], y[1], z[1]);

	angle = (180.0 - atan2(x[1] - x[0], y[1] - y[0]));
	SetPlayerFacingAngle(playerid, angle + (5.0 * -1));
}


ReturnDateTime ( ) {
	new date[36];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	format(date, sizeof(date), "%02d/%02d/%d, %02d:%02d",
	date[0], date[1], date[2], date[3], date[4]);

	return date;
}


GetStateName(stateId, status[], len=sizeof(status)) {

	switch(stateId)
    {
        case PLAYER_STATE_ONFOOT: {
        	format ( status, len, "ON FOOT" ) ;
        }

        case PLAYER_STATE_DRIVER: {
        	format ( status, len, "DRIVER" ) ;
		}

		case PLAYER_STATE_PASSENGER: {
			format ( status, len, "PASSENGER" ) ;
		}

		case PLAYER_STATE_EXIT_VEHICLE: {
			format ( status, len, "EXIT VEHICLE" ) ;
		}

		case PLAYER_STATE_ENTER_VEHICLE_DRIVER: {
			format ( status, len, "ENTER VEHICLE DRIVER" ) ;
		}

		case PLAYER_STATE_ENTER_VEHICLE_PASSENGER: {
			format ( status, len, "ENTER VEHICLE PASSENGER" ) ;
		}

		case PLAYER_STATE_WASTED: {
			format ( status, len, "WASTED" ) ;
		}

		case PLAYER_STATE_SPAWNED: {
			format ( status, len, "SPAWNED" ) ;
		}

		case PLAYER_STATE_SPECTATING: {
			format ( status, len, "SPECTATING" ) ;
        }

        default: {
        	format ( status, len, "NONE" ) ;
 		}
    }
}


stock IsPlayerCloseToPlayer(player_to_check, player_to_compare, Float:range)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(player_to_compare, x, y, z);

    if(IsPlayerInRangeOfPoint(player_to_check, range, x, y, z) && GetPlayerInterior(player_to_check) == GetPlayerInterior(player_to_compare) && GetPlayerVirtualWorld(player_to_check) == GetPlayerVirtualWorld(player_to_compare) && GetPlayerState(player_to_check) != PLAYER_STATE_SPECTATING && GetPlayerState(player_to_compare) != PLAYER_STATE_SPECTATING)
    {
        return 1;
    }
    return 0;
}



stock MakePlayerFacePoint(playerid, Float: fpX, Float: fpY, Float: fpZ ) {
    new Float:Px, Float:Py, Float: Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
  
    Pa = floatabs(atan((fpY-Py)/(fpX-Px)));
    if(fpX <= Px && fpY >= Py) Pa = floatsub(180, Pa);
    else if(fpX < Px && fpY < Py) Pa = floatadd(Pa, 180);
    else if(fpX >= Px && fpY <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if(Pa >= 360.0) Pa = floatsub(Pa, 360.0);

    SetPlayerFacingAngle(playerid, Pa);
}

stock MakePlayerFaceVehicle(playerid, facevehicleid ) {
    new Float:Px, Float:Py, Float: Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    new Float:fpX, Float:fpY, Float: fpZ;
    GetVehiclePos(facevehicleid, fpX, fpY, fpZ );

    Pa = floatabs(atan((fpY-Py)/(fpX-Px)));
    if(fpX <= Px && fpY >= Py) Pa = floatsub(180, Pa);
    else if(fpX < Px && fpY < Py) Pa = floatadd(Pa, 180);
    else if(fpX >= Px && fpY <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if(Pa >= 360.0) Pa = floatsub(Pa, 360.0);

    SetPlayerFacingAngle(playerid, Pa);
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

GetXYLeftOfPlayer(playerid, &Float:X, &Float:Y, Float:distance) {
    new Float:Angle;
    GetPlayerFacingAngle(playerid, Angle); Angle += 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

stock bool:IsPlayerInSquare( playerid, Float:MIN_X , Float:MAX_X , Float:MIN_Y , Float:MAX_Y ) 

	// https://sa-mp-fr.com/tutorials/article/26-tutoriel-isplayerinsquare-une-d%C3%A9riv%C3%A9e-de-isplayerinarea/
{

	if( !IsPlayerConnected( playerid ) ) return false ;

	static
		Float:P_POS[ 3 ]
		;

	GetPlayerPos( playerid , P_POS[ 0 ] , P_POS[ 1 ] , P_POS[ 2 ] ) ;

	if( ( MIN_X <= P_POS[ 0 ] <= MAX_X  ) &&  ( MIN_Y <= P_POS[ 1 ] <= MAX_Y )  ) return true ;

	return false ;
}