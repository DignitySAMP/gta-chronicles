GetXYLeftOfVehicle(vehicleid, &Float:X, &Float:Y, Float:distance)
{
    new Float:Angle;
    GetVehicleZAngle(vehicleid, Angle); Angle += 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

GetXYRightOfVehicle(vehicleid, &Float:X, &Float:Y, Float:distance)
{
    new Float:Angle;
    GetVehicleZAngle(vehicleid, Angle); Angle -= 90.0;
    X += floatmul(floatsin(-Angle, degrees), distance);
    Y += floatmul(floatcos(-Angle, degrees), distance);
}

IsCourierVehicle(vehicleid)
{
	new Vehs[] = { 481 };
	for(new i = 0; i < sizeof(Vehs); i++)
	{
		if(GetVehicleModel(vehicleid) == Vehs[i]) return 1;
	}
	return 0;
}