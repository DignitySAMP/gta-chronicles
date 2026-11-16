
// GetAngleToPos made by MegaDreams
stock Float: GetAngleToPos(Float: PX, Float: PY, Float: X, Float: Y)
{
	new Float:Angle = floatabs(atan((Y-PY)/(X-PX)));
	Angle = (X<=PX && Y>=PY) ? floatsub(180,Angle) : (X<PX && Y<PY) ? floatadd(Angle,180) : (X>=PX && Y<=PY) ? floatsub(360.0,Angle) : Angle;
	Angle = floatsub(Angle, 90.0);
	Angle = (Angle>=360.0) ? floatsub(Angle, 360.0) : Angle;
	return Angle;
}



stock GetOffsetPos(&Float:x, &Float:y, Float:distance, Float: r)
{	// Created by Y_Less
	x += (distance * floatsin(-r, degrees));
	y += (distance * floatcos(-r, degrees));
}

stock Get2DRandomDistanceAway(&Float: fwX, &Float: fwY, min_distance, max_distance = 100)
{
	new Float: tempX = fwX, Float: tempY = fwY;
	new rX = random(max_distance);
	new rY = random(max_distance);
	tempX += float(rX-(max_distance/2));
	tempY += float(rY-(max_distance/2));
	while (GetDistance(tempX, tempY, 10.0, fwX, fwY, 10.0) < min_distance/2)
	{
		tempX = fwX;
		tempY = fwY;
		rX = random(max_distance);
		rY = random(max_distance);
		tempX += float(rX-(max_distance/2));
		tempY += float(rY-(max_distance/2));
	}
	fwX = tempX;
	fwY = tempY;
	return 1;
}

stock Get3DRandomDistanceAway(&Float: fwX, &Float: fwY, &Float: fwZ, min_distance, max_distance = 100)
{
	new Float: tempX = fwX, Float: tempY = fwY, Float: tempZ = fwZ;
	new rX = random(max_distance);
	new rY = random(max_distance);
	new rZ = random(max_distance);
	tempX += float(rX-(max_distance/2));
	tempY += float(rY-(max_distance/2));
	tempZ += float(rZ-(max_distance/2));
	while (GetDistance(tempX, tempY, tempZ, fwX, fwY, fwZ) < min_distance/2)
	{
		tempX = fwX;
		tempY = fwY;
		tempZ = fwZ;
		rX = random(max_distance);
		rY = random(max_distance);
		rZ = random(max_distance);
		tempX += float(rX-(max_distance/2));
		tempY += float(rY-(max_distance/2));
		tempZ += float(rZ-(max_distance/2));
	}
	fwX = tempX;
	fwY = tempY;
	fwZ = tempZ;
	return 1;
}
