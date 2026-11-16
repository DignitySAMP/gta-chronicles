
IsVehicleModelBicycle(modelid)
{
	switch (modelid)
	{
		case 481, 509, 510: return true;
	}
	return false;
}

IsVehicleModelHelicopter(modelid)
{
	switch (modelid)
	{
		case 417, 425, 447, 469, 487, 488, 497, 548, 563: return true;
	}
	return false;
}

IsVehicleModelPlane(modelid)
{
	switch (modelid)
	{
		case 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return true;
	}
	return false;
}

IsVehicleModelAircraft(modelid)
{
	if (IsVehicleModelHelicopter(modelid) || IsVehicleModelPlane(modelid)) return true;
	return false;
}

IsVehicleModelBoat(modelid)
{
	switch (modelid)
	{
		case 430, 446, 452, 454, 453, 472, 473, 484, 493, 595: return true;
	}
	return false;
}