#tryinclude <a_samp>
native IsValidVehicle(vehicleid);
#tryinclude <zcmd>
#tryinclude <sscanf2>
#tryinclude <foreach>

#if !defined PAWNRAKNET_INC_
    #include <Pawn.RakNet>
#endif

SOLS_SetVehicleZAngle(vehicleid, Float: rotation) {

	if ( ! IsValidVehicle ( vehicleid ) ) {

		printf("Vehicleid %d isn't valid.", vehicleid);
		return true ;
	}

    printf("%d %f", vehicleid, rotation);

    new BitStream:bs = BS_New();


    BS_WriteValue(
        bs,
        PR_UINT8, vehicleid,
        PR_FLOAT, rotation
    );


    // This should work, but it doesn't because the RPC is sent only to the last player that interacted with the vehicle (NaN)
    foreach(new playerid: Player) {

   	 	BS_RPC(bs, playerid, 160);
   	}

    BS_Delete(bs);

	return true ;
}


CMD:test(playerid) {

	new Float: x, Float: y, Float: z ;
	GetPlayerPos(playerid, x, y, z ) ;
	GetXYInFrontOfPlayer(playerid, x, y, 5.0 ) ;
	CreateVehicle ( 562, x, y, z, 0.0, -1, -1, -1 );

	return true; 
}

CMD:rotation(playerid, params[]) {

	new Float: angle, vehicleid ;

	if ( sscanf ( params, "if", vehicleid, angle ) ) {

		return SendClientMessage(playerid, -1, "/rotation [veh] [angle]");
	}

	SOLS_SetVehicleZAngle(vehicleid, angle ) ;

	return true ;
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