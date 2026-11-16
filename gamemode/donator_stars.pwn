#include <a_samp>
#include <streamer>

public OnFilterScriptInit() {

	new g_DynamicObject[68];
	g_DynamicObject[0] = CreateDynamicObject(19483, 1020.3718, -1133.6745, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[0], 0, "Bishop", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[1] = CreateDynamicObject(19483, 974.8618, -1133.6745, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[1], 0, "Filiposq", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[2] = CreateDynamicObject(19483, 979.3926, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[2], 0, "shoreline", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[3] = CreateDynamicObject(19483, 983.9432, -1133.5344, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[3], 0, "rusu", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[4] = CreateDynamicObject(19483, 988.4937, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[4], 0, "Lion", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[5] = CreateDynamicObject(19483, 993.0543, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[5], 0, "Inkeri0", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[6] = CreateDynamicObject(19483, 997.6054, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[6], 0, "Ziv", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[7] = CreateDynamicObject(19483, 1002.1675, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[7], 0, "CoKane", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[8] = CreateDynamicObject(19483, 1006.6901, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[8], 0, "Sons", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[9] = CreateDynamicObject(19483, 1011.2512, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[9], 0, "gus", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[10] = CreateDynamicObject(19483, 1015.7910, -1133.6545, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[10], 0, "Lorence", 90, "Arial", 24, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[11] = CreateDynamicObject(19483, 997.8256, -1133.5844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[11], 0, "Ziv Stein", 130, "Arial", 24, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[12] = CreateDynamicObject(19483, 984.2057, -1133.5444, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[12], 0, "Martin Osborn", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[13] = CreateDynamicObject(19483, 1011.4364, -1133.5944, 22.8372, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[13], 0, "Lance Rizzi", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[14] = CreateDynamicObject(19483, 1025.4821, -1133.6745, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[14], 0, "Condone", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[15] = CreateDynamicObject(19483, 1029.9742, -1133.6745, 22.8572, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[15], 0, "Waka", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[16] = CreateDynamicObject(19483, 1034.4479, -1133.6745, 22.8572, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[16], 0, "Lion", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[17] = CreateDynamicObject(19483, 1038.9393, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[17], 0, "HeartBeat", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[18] = CreateDynamicObject(19483, 1043.4500, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[18], 0, "RaZzor", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[19] = CreateDynamicObject(19483, 1047.9607, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[19], 0, "lance", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[20] = CreateDynamicObject(19483, 1052.4714, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[20], 0, "Vanquish", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[21] = CreateDynamicObject(19483, 1052.6014, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[21], 0, "Ezequiel Vega", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[22] = CreateDynamicObject(19483, 1056.9714, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[22], 0, "ManeMag", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[23] = CreateDynamicObject(19483, 1057.0800, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[23], 0, "Ryker Brown", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[24] = CreateDynamicObject(19483, 1061.4021, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[24], 0, "Blejicaaa", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[25] = CreateDynamicObject(19483, 1061.5321, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[25], 0, "Shawn Blackburn", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[26] = CreateDynamicObject(19483, 1065.9021, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[26], 0, "smurda ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[27] = CreateDynamicObject(19483, 1066.0321, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[27], 0, "Andre Hicks", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[28] = CreateDynamicObject(19483, 1070.4021, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[28], 0, "Rodriguez ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[29] = CreateDynamicObject(19483, 1070.5321, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[29], 0, "Olivia Rodriguez", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[30] = CreateDynamicObject(19483, 1094.7280, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[30], 0, "MeeP ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[31] = CreateDynamicObject(19483, 1094.8580, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[31], 0, "Kimberly Coleman", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[32] = CreateDynamicObject(19483, 1099.0387, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[32], 0, "Snafu ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[33] = CreateDynamicObject(19483, 1099.1687, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[33], 0, "Pancho Cordozar", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[34] = CreateDynamicObject(19483, 1103.3494, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[34], 0, "rebdissolved1119 ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[35] = CreateDynamicObject(19483, 1103.4794, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[35], 0, "Sol Prisa", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[36] = CreateDynamicObject(19483, 1107.6511, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[36], 0, "Catster420 ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[37] = CreateDynamicObject(19483, 1107.7811, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[37], 0, "Nick Sanchez", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[38] = CreateDynamicObject(19483, 1111.9228, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[38], 0, "Zigua6089 ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[39] = CreateDynamicObject(19483, 1112.0528, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[39], 0, "Ernest Bartaglieri", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[40] = CreateDynamicObject(19483, 1116.1945, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[40], 0, "twigyy ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[41] = CreateDynamicObject(19483, 1116.3245, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[41], 0, "Jamaar Finson", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	g_DynamicObject[42] = CreateDynamicObject(19483, 1120.4662, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[42], 0, "MrDreamer ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[43] = CreateDynamicObject(19483, 1120.5962, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[43], 0, "George Jefferson", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[44] = CreateDynamicObject(19483, 1124.7679, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[44], 0, "Grafake ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[45] = CreateDynamicObject(19483, 1124.8979, -1133.6844, 22.8472, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[45], 0, "Edmunds Niedre", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[46] = CreateDynamicObject(19483, 1129.0696, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[46], 0, "Saif Malice McMalice", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[47] = CreateDynamicObject(19483, 1133.3713, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[47], 0, "Leonidas", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[48] = CreateDynamicObject(19483, 1137.673, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[48], 0, "jayfinesse", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[49] = CreateDynamicObject(19483, 1141.9747, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[49], 0, "Graeme", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[50] = CreateDynamicObject(19483, 1146.2764, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[50], 0, "TyDolla", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[51] = CreateDynamicObject(19483, 1150.5781, -1133.6745, 22.8371, 180.0000, 90.0000, 180.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[51], 0, "Lamar_Prowell", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[52] = CreateDynamicObject(19483, 1175.3240, -1133.7745, 22.8871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[52], 0, "Chuckyloec ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[53] = CreateDynamicObject(19483, 1175.2000, -1133.7844, 22.8972, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[53], 0, "Raymond Taylor", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[54] = CreateDynamicObject(19483, 1180.4257, -1133.7745, 22.8871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[54], 0, "Sizzurp ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[55] = CreateDynamicObject(19483, 1185.5274, -1133.7745, 22.8871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[55], 0, "Lucius ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[56] = CreateDynamicObject(19483, 1185.4034, -1133.7844, 22.8972, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[56], 0, "Mikhail Antonov", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[57] = CreateDynamicObject(19483, 1190.8691, -1133.7745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[57], 0, "Spade ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[58] = CreateDynamicObject(19483, 1196.0000, -1133.6745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[58], 0, "Foxx ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[59] = CreateDynamicObject(19483, 1201.4325, -1133.6745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[59], 0, "SohaibM ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[60] = CreateDynamicObject(19483, 1201.3100, -1133.6844, 22.9972, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[60], 0, "Christopher Atonal", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);

	g_DynamicObject[61] = CreateDynamicObject(19483, 1206.8634, -1133.6745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[61], 0, "flffy ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[62] = CreateDynamicObject(19483, 1212.2943, -1133.6745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[62], 0, "vibes ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[63] = CreateDynamicObject(19483, 1217.6252, -1133.6745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[63], 0, "Nubzzy ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[64] = CreateDynamicObject(19483, 1223.0561, -1133.4745, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[64], 0, "Krypto ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[65] = CreateDynamicObject(19483, 1228.4570, -1133.4445, 22.9871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[65], 0, "Fifty ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);

	g_DynamicObject[66] = CreateDynamicObject(19483, 1233.8879, -1133.4445, 22.8871, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[66], 0, "LionVenom ", 90, "Arial", 20, 1, 0xFF745217, 0x0, 1);
	g_DynamicObject[67] = CreateDynamicObject(19483, 1233.6879, -1133.4445, 22.8972, 180.0000, 90.0000, 0.0000); //Plane009
	SetDynamicObjectMaterialText(g_DynamicObject[67], 0, "Ignacio Abraham", 130, "Arial", 20, 1, 0xFF840410, 0x0, 1);
	
	return true ;
}