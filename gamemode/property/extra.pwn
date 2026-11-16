/*
	House Actions
	-> /doorbell, /doorknock
*/


CMD:doorshout(playerid, params[]) {

	new index = Property_GetClosestEntity( playerid ) ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You're not near an entrance (property door)." ) ;

	}

	new text [ 144 ], full_string[256] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/doorshout [text]" ) ;
	}

	new bool: status, final_color, color = 0xDEDEDEFF, Float: max_ratio = 1.6, Float: max_range = 20.0,  Float:range, 
		Float:range_ratio, Float:range_with_ratio, clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b 
	;

    ProxDetectorNameTag(playerid, 20.0, -1, text, " shouts (door):", 0, true, false ) ;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {
		
			status = false ;
		}
	}

	else if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {
		
			status = true ;
		}
	}

	foreach(new targetid: Player) {

		if ( targetid == playerid ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {

				if ( ! status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "%s shouts (door, inside): %s", ReturnPlayerNameData(playerid,  0, true), text ) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "%s{%06x} shouts (door, inside): %s", ReturnPlayerNameDataHex(playerid), (final_color >>> 8), text ) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

		else if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {

				if ( status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "%s shouts (door, outside): %s", ReturnPlayerNameData(playerid,  0, true), text ) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "%s{%06x} shouts (door, outside): %s", ReturnPlayerNameDataHex(playerid), (final_color >>> 8), text ) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

	}

	return true ;
}


CMD:doorme(playerid, params[]) {

	new index = Property_GetClosestEntity( playerid ) ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You're not near an entrance (property door)." ) ;

	}

	new text [ 144 ], full_string[256] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/doorme [text]" ) ;
	}

    ProxDetectorNameTag(playerid, 15.0, COLOR_ACTION, text, "", 1,  .customcolor=false, .invert_action=false ) ;

	new bool: status, final_color, color = COLOR_ACTION, Float: max_ratio = 1.6, Float: max_range = 20.0,  Float:range, 
		Float:range_ratio, Float:range_with_ratio, clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b 
	;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {
		
			status = false ;
		}
	}

	else if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {
		
			status = true ;
		}
	}

	foreach(new targetid: Player) {

		if ( targetid == playerid ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {

				if ( ! status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* (door, inside) %s %s", ReturnPlayerNameData(playerid,  0, true), text ) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* (door, inside) %s %s", ReturnPlayerNameDataHex(playerid, .color=false), text ) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

		else if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {

				if ( status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* (door, outside) %s %s", ReturnPlayerNameData(playerid,  0, true), text ) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* (door, outside) %s %s", ReturnPlayerNameDataHex(playerid, .color=false), text ) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

	}

	return true ;
}


CMD:doordo(playerid, params[]) {

	new index = Property_GetClosestEntity( playerid ) ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You're not near an entrance (property door)." ) ;

	}

	new text [ 144 ], full_string[256] ;

	if ( sscanf ( params, "s[144]", text ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/doordo [text]" ) ;
	}

    ProxDetectorNameTag(playerid, 15.0, COLOR_ACTION, text, "", 1, .customcolor=false, .invert_action=true ) ;

	new bool: status, final_color, color = COLOR_ACTION, Float: max_ratio = 1.6, Float: max_range = 20.0,  Float:range, 
		Float:range_ratio, Float:range_with_ratio, clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b 
	;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {
		
			status = false ;
		}
	}

	else if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {
		
			status = true ;
		}
	}

	foreach(new targetid: Player) {

		if ( targetid == playerid ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_EXT_VW ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_EXT_INT ] ) {

				if ( ! status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_EXT_X ],  Property [ index ] [ E_PROPERTY_EXT_Y ],  Property [ index ] [ E_PROPERTY_EXT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s (( %s, door, inside ))", text, ReturnPlayerNameData(playerid, 0, true)) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s (( %s, door, inside ))", text, ReturnPlayerNameDataHex(playerid,.color=false)) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

		else if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {

				if ( status ) {

					continue ;
				}

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s (( %s, door, outside ))", text, ReturnPlayerNameData(playerid, 0, true)) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s (( %s, door, outside ))", text, ReturnPlayerNameDataHex(playerid,.color=false)) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}

	}

	return true ;
}



CMD:doorbell(playerid, params[]) {

	new index = Property_GetClosestEntity( playerid ) ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You're not near an entrance (property door)." ) ;

	}

	new full_string[256] ;

	new final_color, color = COLOR_ACTION, Float: max_ratio = 1.6, Float: max_range = 20.0,  Float:range, 
		Float:range_ratio, Float:range_with_ratio, clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b 
	;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {
		
			return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You can't ring the doorbell from the inside, are you stupid?" ) ;
		}
	}

	//ProxDetectorNameTag(playerid, 15.0, COLOR_ACTION, "rings the doorbell.", "", 1,  .customcolor=false, .invert_action=false ) ;
	ProxDetectorAutoMe(playerid, 20.0, "rings the doorbell.", true);

	foreach(new targetid: Player) {

		if ( targetid == playerid ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s rings the doorbell (outside).", ReturnPlayerNameData(playerid, 0, true)) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s rings the doorbell (outside).", ReturnPlayerNameDataHex(playerid,.color=false)) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}
	}

	return true ;
}

CMD:doorknock(playerid, params[]) {

	new index = Property_GetClosestEntity( playerid ) ;

	if ( index == INVALID_PROPERTY_ID ) {

		return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You're not near an entrance (property door)." ) ;

	}

	new full_string[256] ;

	new final_color, color = COLOR_ACTION, Float: max_ratio = 1.6, Float: max_range = 20.0,  Float:range, 
		Float:range_ratio, Float:range_with_ratio, clr_r, clr_g, clr_b, Float:color_r, Float:color_g, Float:color_b 
	;

	color_r = float(color >> 24 & 0xFF);
	color_g = float(color >> 16 & 0xFF);
	color_b = float(color >> 8 & 0xFF);
	range_with_ratio = max_range * max_ratio;

	if ( IsPlayerInRangeOfPoint(playerid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

		if ( GetPlayerVirtualWorld(playerid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( playerid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {
		
			return SendServerMessage(playerid, COLOR_PROPERTY, "Property", "DEDEDE", "You can't knock the door from the inside, are you stupid?" ) ;
		}
	}
	
    //ProxDetectorNameTag(playerid, 15.0, COLOR_ACTION, "knocks on the door.", "", 1,  .customcolor=false, .invert_action=false ) ;
	ProxDetectorAutoMe(playerid, 20.0, "knocks on the door.", true);

	foreach(new targetid: Player) {

		if ( targetid == playerid ) {

			continue ;
		}

		if ( IsPlayerInRangeOfPoint(targetid, max_range, Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ] ) ) {

			if ( GetPlayerVirtualWorld(targetid) ==  Property [ index ] [ E_PROPERTY_ID ] && GetPlayerInterior ( targetid ) ==  Property [ index ] [ E_PROPERTY_INT_INT ] ) {

				range = GetPlayerDistanceFromPoint(targetid,  Property [ index ] [ E_PROPERTY_INT_X ],  Property [ index ] [ E_PROPERTY_INT_Y ],  Property [ index ] [ E_PROPERTY_INT_Z ]);

				range_ratio = (range_with_ratio - range) / range_with_ratio;
				clr_r = floatround(range_ratio * color_r);
				clr_g = floatround(range_ratio * color_g);
				clr_b = floatround(range_ratio * color_b);

				switch ( GetPlayerNametagPreference(targetid) ) {
					case 1: {

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s knocks on the door (outside).", ReturnPlayerNameData(playerid, 0, true)) ;
					}

					case 2:	{

						final_color = (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24) ;
						format ( full_string, sizeof ( full_string ), "* %s knocks on the door (outside).", ReturnPlayerNameDataHex(playerid,.color=false)) ;
					}
				}

				ZMsg_SendClientMessage(targetid, final_color, full_string);
			}
		}
	}

	return true ;
}
