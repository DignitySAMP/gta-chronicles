#include <a_samp>
#include <streamer>


public OnFilterScriptInit () {
	new g_DynamicObject[20];
	g_DynamicObject[0] = CreateDynamicObject(2895, 427.0910, -808.7026, 60.9844, 0.0000, 0.0000, 56.5999, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[1] = CreateDynamicObject(325, 426.7920, -808.1529, 60.9128, -9.5999, -78.8998, 22.0999, -1, -1, -1, 300.0); //flowera
	g_DynamicObject[2] = CreateDynamicObject(2895, 426.4527, -809.1610, 60.8654, 0.0000, -7.2999, 24.8999, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[3] = CreateDynamicObject(2895, 425.6443, -809.1528, 60.6532, 0.0000, -9.9999, -15.4000, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[4] = CreateDynamicObject(2895, 424.9429, -808.6184, 60.3909, 0.0000, -9.9999, -61.2000, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[5] = CreateDynamicObject(2895, 424.7799, -807.8657, 60.2670, 0.0000, -0.7999, -114.8000, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[6] = CreateDynamicObject(2895, 425.4263, -807.2574, 60.3590, 0.0000, 4.8000, -143.5000, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[7] = CreateDynamicObject(2895, 426.2703, -806.9249, 60.5417, 0.0000, 9.1000, -167.1001, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[8] = CreateDynamicObject(2895, 426.9596, -807.1329, 60.7681, 0.0000, 12.3000, 144.7999, -1, -1, -1, 300.0); //fun_flower_law
	g_DynamicObject[9] = CreateDynamicObject(325, 426.8081, -807.9959, 60.8861, -9.5999, -78.8998, -5.9000, -1, -1, -1, 300.0); //flowera
	g_DynamicObject[10] = CreateDynamicObject(2237, 425.7450, -807.6912, 61.4016, -1.9999, 5.9999, 83.8000, -1, -1, -1, 300.0); //CJ_SHOVEL2
	g_DynamicObject[11] = CreateDynamicObject(2053, 425.6640, -807.6349, 61.4779, -65.6000, 0.0000, 0.0000, -1, -1, -1, 300.0); //CJ_JERRY_HAT
	g_DynamicObject[12] = CreateDynamicObject(19477, 423.3261, -810.3499, 61.4369, 0.0000, 0.0000, 5.6000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[12], 0, "May this grave be your memorial", 130, "Arial", 18, 0, 0xFF000000, 0x0, 1);
	g_DynamicObject[13] = CreateDynamicObject(3264, 423.2726, -810.3706, 59.3743, 0.0000, 0.0000, 95.1999, -1, -1, -1, 300.0); //privatesign3
	SetDynamicObjectMaterial(g_DynamicObject[13], 1, 3083, "billbox", "ADDWOOD", 0xFFFFFFFF);
	g_DynamicObject[14] = CreateDynamicObject(19477, 423.2262, -809.1541, 61.1569, 0.0000, 0.0000, 4.7000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[14], 0, "Rex", 90, "Arial", 24, 1, 0xFF335F3F, 0x0, 0);
	g_DynamicObject[15] = CreateDynamicObject(19477, 423.3251, -810.3399, 61.5469, 0.0000, 0.0000, 5.6000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[15], 0, "Rest easy old soldier", 130, "Arial", 24, 1, 0xFF000000, 0x0, 1);
	g_DynamicObject[16] = CreateDynamicObject(19477, 423.3261, -810.3499, 61.3369, 0.0000, 0.0000, 5.6000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[16], 0, "Let the sun and moon shine on you", 130, "Arial", 17, 0, 0xFF000000, 0x0, 1);
	g_DynamicObject[17] = CreateDynamicObject(19477, 423.3281, -810.3698, 61.0870, 0.0000, 0.0000, 5.6000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[17], 0, "The Old Guard never Forgets", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[18] = CreateDynamicObject(19477, 423.3271, -810.3598, 61.2370, 0.0000, 0.0000, 5.6000, -1, -1, -1, 300.0); //Plane003
	SetDynamicObjectMaterialText(g_DynamicObject[18], 0, "You won't be forgotten my friend", 130, "Arial", 17, 0, 0xFF000000, 0x0, 1);
	g_DynamicObject[19] = CreateDynamicObject(854, 426.0328, -808.0396, 60.7659, -6.3999, -15.9000, 0.0000, -1, -1, -1, 300.0); //CJ_urb_rub_3b
	SetDynamicObjectMaterial(g_DynamicObject[19], 0, 13295, "ce_terminal", "grass4dirtyb", 0xFFFFFFFF);

	return true ;
}
