forward AngledThrow(package, times, Float:X, Float:Y, Float:Z);
public AngledThrow(package, times, Float:X, Float:Y, Float:Z)
{
	if(times > 0)
	{
		MoveDynamicObject(package, X, Y, Z, 10.0);
		SetTimerEx("AngledThrow", 50, false, "iifff", package, times-1, X, Y, Z-0.31);
	}
	else
	{
		SetTimerEx("DeletePackage", 5000, false, "i", package);
	}
	return 1;
}

forward DeletePackage(package);
public DeletePackage(package)
{
	DestroyDynamicObject(package);
	return 1;
}