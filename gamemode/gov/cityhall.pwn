#include <YSI_Coding\y_hooks>

#define CH_INT_SD	100.0
#define CH_LOW_SD	60.0

static RemovePlayerBuildings(playerid)
{
	RemoveBuildingForPlayer(playerid, 4024, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 4044, 1481.1875, -1785.0703, 22.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 4002, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3980, 1481.1875, -1785.0703, 22.3828, 0.25);
}

static AddModels()
{
	// CITY HALL, PERSHING SQUARE, LS
    AddSimpleModel(-1, 19379, -5300, "cityhall/EXT/ch_ext.dff", "cityhall/EXT/ch_ext.txd");
    AddSimpleModel(-1, 19379, -5301, "cityhall/EXT/ch_tower.dff", "cityhall/EXT/ch_tower.txd");

    AddSimpleModel(-1, 19379, -5302, "cityhall/INT/F1/ch_int1_m.dff", "cityhall/INT/F1/ch_int1.txd");   // FLOOR 1
    AddSimpleModel(-1, 19379, -5303, "cityhall/INT/F1/ch_int1_west.dff", "cityhall/INT/F1/ch_int1.txd");   // FLOOR 1
    AddSimpleModel(-1, 19379, -5304, "cityhall/INT/F1/ch_int1_east_NEW.dff", "cityhall/INT/F1/ch_int1.txd");   // FLOOR 1
    AddSimpleModel(-1, 19379, -5305, "cityhall/INT/F2/ch_int2.dff", "cityhall/INT/F2/ch_int2.txd");     // FLOOR 2
    AddSimpleModel(-1, 19379, -5306, "cityhall/INT/ch_entGarage.dff", "cityhall/INT/ch_entGarage.txd"); // FLOOR 0

    AddSimpleModel(-1, 19379, -5307, "cityhall/BITS/ch_int2_bits_m_NEW.dff", "cityhall/BITS/ch_int2_bits_m.txd");
    AddSimpleModel(-1, 19379, -5308, "cityhall/BITS/ch_int2_bits_east.dff", "cityhall/BITS/ch_int2_bits_offices.txd"); // EAST OF BUILDING
    AddSimpleModel(-1, 19379, -5309, "cityhall/BITS/ch_int2_bits_west.dff", "cityhall/BITS/ch_int2_bits_offices.txd"); // WEST OF BUILDING
    AddSimpleModel(-1, 19379, -5310, "cityhall/BITS/ch_reception_bits.dff", "cityhall/BITS/ch_reception_bits.txd");
    AddSimpleModel(-1, 19379, -5311, "cityhall/BITS/ch_court_bits_NEW.dff", "cityhall/BITS/ch_court_bits.txd");
    AddSimpleModel(-1, 19379, -5312, "cityhall/BITS/ch_holding_bits.dff", "cityhall/BITS/ch_holding_bits.txd");
    AddSimpleModel(-1, 19379, -5313, "cityhall/BITS/ch_news_bits.dff", "cityhall/BITS/ch_news_bits.txd");
    AddSimpleModel(-1, 19379, -5314, "cityhall/BITS/ch_news2_bits.dff", "cityhall/BITS/ch_news2_bits.txd"); // CAMERAS & LIGHTS
    AddSimpleModel(-1, 19325, -5315, "cityhall/BITS/ch_int1_alphas_NEW.dff", "cityhall/BITS/ch_alphas.txd");
    AddSimpleModel(-1, 19325, -5316, "cityhall/BITS/ch_int2_alphas.dff", "cityhall/BITS/ch_alphas.txd");

    AddSimpleModel(-1, 19325, -5317, "cityhall/BITS/MISC/ch_holdingBars.dff", "cityhall/BITS/MISC/ch_holdingBars.txd");
    AddSimpleModel(-1,  1491, -5318, "cityhall/BITS/MISC/ch_archdoor.dff", "cityhall/BITS/MISC/ch_archdoor.txd"); // SWINGING DOORS
    AddSimpleModel(-1, 19379, -5319, "cityhall/BITS/MISC/ch_doubleBench.dff", "cityhall/BITS/MISC/ch_seating.txd");
    AddSimpleModel(-1, 19379, -5320, "cityhall/BITS/MISC/ch_singleBench.dff", "cityhall/BITS/MISC/ch_seating.txd");
    AddSimpleModel(-1, 19379, -5321, "cityhall/BITS/MISC/ch_fabricChair_3.dff", "cityhall/BITS/MISC/ch_seating.txd");
    AddSimpleModel(-1, 19379, -5322, "cityhall/BITS/MISC/ch_fabricChair_6.dff", "cityhall/BITS/MISC/ch_seating.txd");
    AddSimpleModel(-1, 19379, -5323, "cityhall/BITS/MISC/ch_curtains_open.dff", "cityhall/BITS/MISC/ch_curtains.txd");
    AddSimpleModel(-1, 19379, -5324, "cityhall/BITS/MISC/ch_curtains_closed.dff", "cityhall/BITS/MISC/ch_curtains.txd");
    AddSimpleModel(-1, 19379, -5325, "cityhall/BITS/MISC/ch_xray.dff", "cityhall/BITS/MISC/ch_securitypoint.txd");
    AddSimpleModel(-1, 19379, -5326, "cityhall/BITS/MISC/ch_metdetPortal.dff", "cityhall/BITS/MISC/ch_securitypoint.txd");
    //AddSimpleModel(-1, 19379, -5327, "cityhall/BITS/MISC/ch_lightPanels.dff", "cityhall/BITS/MISC/ch_lightPanels.txd");

	AddSimpleModel(-1, 19379, -5328, "cityhall/BITS/MISC/ch_logorug.dff", "cityhall/BITS/MISC/ch_logorug.txd");

	AddSimpleModel(-1, 19379, -5329, "cityhall/BITS/ch_int2_lights_m.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 2 MIDDLE LIGHTS
	AddSimpleModel(-1, 19379, -5330, "cityhall/BITS/ch_int2_lights_e.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 2 EAST LIGHTS
	AddSimpleModel(-1, 19379, -5331, "cityhall/BITS/ch_int2_lights_w.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 2 WEST LIGHTS

	AddSimpleModel(-1, 19379, -5332, "cityhall/BITS/ch_int1_lights_m.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 1 MIDDLE LIGHTS
	AddSimpleModel(-1, 19379, -5333, "cityhall/BITS/ch_int1_lights_e.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 1 EAST LIGHTS
	AddSimpleModel(-1, 19379, -5334, "cityhall/BITS/ch_int1_lights_w.dff", "cityhall/BITS/ch_lights.txd");     // FLOOR 1 WEST LIGHTS

	AddSimpleModel(-1, 1523, -5335, "cityhall/BITS/DOORS/ch_door_safety.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // DIRECTOR of PUBLIC SAFETY DOOR
	AddSimpleModel(-1, 1523, -5336, "cityhall/BITS/DOORS/ch_door_health.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // DIRECTOR of PUBLIC HEALTH DOOR
	AddSimpleModel(-1, 1523, -5337, "cityhall/BITS/DOORS/ch_door_admin.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // DIRECTOR of PUBLIC ADMIN DOOR
	AddSimpleModel(-1, 1523, -5338, "cityhall/BITS/DOORS/ch_door_util.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // DIRECTOR of PUBLIC UTIL DOOR
	AddSimpleModel(-1, 1523, -5339, "cityhall/BITS/DOORS/ch_door_mayor.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // OFFICE of the MAYOR DOOR
	AddSimpleModel(-1, 1523, -5340, "cityhall/BITS/DOORS/ch_door_court.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // COUTTROOM DOOR
	AddSimpleModel(-1, 1523, -5341, "cityhall/BITS/DOORS/ch_door_auth.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // AUTH PERSONNEL DOOR
	AddSimpleModel(-1, 1523, -5342, "cityhall/BITS/DOORS/ch_door_blank.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // BLANK DOOR

	AddSimpleModel(-1, 19379, -5343, "cityhall/BITS/MISC/ch_scanstrip_off.dff", "cityhall/BITS/MISC/ch_securitypoint.txd");     	// Metal Detector scan strip off
	AddSimpleModel(-1, 19379, -5344, "cityhall/BITS/MISC/ch_scanstrip_on.dff", "cityhall/BITS/MISC/ch_securitypoint.txd");		// Metal Detector scan strip lit up

	AddSimpleModel(-1, 19379, -5345, "cityhall/BITS/MISC/ch_officechair.dff", "cityhall/BITS/MISC/ch_chair.txd");		// Non-col office chair
	AddSimpleModel(-1, 19379, -5346, "cityhall/BITS/MISC/ch_mayorchair.dff", "cityhall/BITS/MISC/ch_chair.txd");		// Non-col mayor leather chair

	AddSimpleModel(-1, 1495, -5347, "cityhall/BITS/DOORS/ch_door_auth.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // AUTH PERSONNEL DOOR STATIC (for gates)
	AddSimpleModel(-1, 1495, -5348, "cityhall/BITS/DOORS/ch_door_court.dff", "cityhall/BITS/DOORS/ch_doors.txd");     // COURT DOOR STATIC (for gates)

	AddSimpleModel(-1, 19379, -5350, "cityhall/BITS/ch_int1_jc_bits.dff",   "cityhall/BITS/ch_int1_jc_bits.txd");
    AddSimpleModel(-1,  1491, -5351, "cityhall/BITS/DOORS/ch_jc_door.dff",   "cityhall/BITS/DOORS/ch_doors_NEW.txd");
    AddSimpleModel(-1, 19379, -5352, "cityhall/INT/F1/ch_int1_jc.dff",      "cityhall/INT/F1/ch_int1_jc.txd");
}

#define CH_INT2_X 	1480.7150
#define CH_INT2_Y 	-1806.3851
#define CH_INT2_Z 	60.2603

#define CH_INT2_LIGHTS_E_X 	CH_INT2_X + 30.228
#define CH_INT2_LIGHTS_E_Y 	CH_INT2_Y + 6.26
#define CH_INT2_LIGHTS_E_Z 	CH_INT2_Z + 0.0

#define CH_INT2_LIGHTS_W_X 	CH_INT2_X - 29.256
#define CH_INT2_LIGHTS_W_Y 	CH_INT2_Y + 6.261
#define CH_INT2_LIGHTS_W_Z 	CH_INT2_Z + 0.0

#define CH_INT1_LIGHTS_X 1480.2847
#define CH_INT1_LIGHTS_Y -1786.1709
#define CH_INT1_LIGHTS_Z 22.5778

#define CH_INT1_LIGHTS_E_X CH_INT1_LIGHTS_X + 31.007
#define CH_INT1_LIGHTS_E_Y CH_INT1_LIGHTS_Y - 0.224
#define CH_INT1_LIGHTS_E_Z CH_INT1_LIGHTS_Z - 0.368

#define CH_INT1_LIGHTS_W_X CH_INT1_LIGHTS_X - 40.921
#define CH_INT1_LIGHTS_W_Y CH_INT1_LIGHTS_Y - 1.921
#define CH_INT1_LIGHTS_W_Z CH_INT1_LIGHTS_Z - 0.368

static CreateObjects()
{
	CreateDynamicObject(-5300, 1481.1875, -1785.0703, 22.3828, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.0, 600.0); //cityhall/EXT/ch_ext
	CreateDynamicObject(-5301, 1479.4396, -1800.8850, 56.0234, 0.0000, 0.0000, 0.0000, -1, 0, -1, 900.0, 900.0); //cityhall/EXT/ch_tower

	CreateDynamicObject(-5302, 1481.0470, -1788.2802, 20.6032, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.0, 300.0); //cityhall/INT/F1/ch_int1_m
	CreateDynamicObject(-5303, 1439.9196, -1788.4557, 20.2363, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/INT/F1/ch_int1_west
	CreateDynamicObject(-5304, 1522.3042, -1792.2316, 20.4855, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/INT/F1/ch_int1_east
	CreateDynamicObject(-5305, CH_INT2_X, CH_INT2_Y, CH_INT2_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/INT/F2/ch_int2
	CreateDynamicObject(-5306, 1519.8329, -1817.0587, 17.0943, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/INT/ch_entGarage

	CreateDynamicObject(-5307, 1480.8616, -1801.4857, 59.8623, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_bits_m
	CreateDynamicObject(-5308, 1510.8290, -1800.3860, 59.4716, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_bits_east
	CreateDynamicObject(-5309, 1450.7886, -1800.3766, 59.4768, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_bits2_bits_west
	CreateDynamicObject(-5310, 1480.4220, -1792.7776, 18.6693, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_reception_bits
	CreateDynamicObject(-5311, 1539.3530, -1781.0728, 19.5025, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_court_bits
	CreateDynamicObject(-5312, 1514.4655, -1793.1696, 19.0765, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //cityhall/BITS/ch_holding_bits
	CreateDynamicObject(-5313, 1425.6432, -1788.2056, 19.4579, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_news_bits
	CreateDynamicObject(-5314, 1420.3099, -1790.8083, 18.9490, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_news2_bits
	CreateDynamicObject(-5315, 1466.0079, -1784.8112, 19.3069, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int1_alphas
	CreateDynamicObject(-5316, 1480.7150, -1801.4836, 59.8778, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_alphas

	CreateDynamicObject(-5317, 1518.0785, -1801.8888, 19.7333, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //cityhall/BITS/MISC/ch_holdingBars.dff

	//CreateDynamicObject(-5327, 1480.2847, -1786.1709, 22.5778, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/MISC/ch_lightPanels

	CreateDynamicObject(-5318, 1467.3413, -1787.7892, 17.7337, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/MISC/ch_archdoor
	CreateDynamicObject(-5318, 1467.5981, -1784.5607, 17.7336, 0.0000, 0.0000, 90.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/MISC/ch_archdoor
	CreateDynamicObject(-5318, 1494.4921, -1787.7897, 17.7337, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/MISC/ch_archdoor
	CreateDynamicObject(-5318, 1494.7489, -1784.5612, 17.7336, 0.0000, 0.0000, 90.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/MISC/ch_archdoor

	CreateDynamicObject(-5329, CH_INT2_X, CH_INT2_Y, CH_INT2_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_lights_m
	CreateDynamicObject(-5330, CH_INT2_LIGHTS_E_X, CH_INT2_LIGHTS_E_Y, CH_INT2_LIGHTS_E_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_lights_e
	CreateDynamicObject(-5331, CH_INT2_LIGHTS_W_X, CH_INT2_LIGHTS_W_Y, CH_INT2_LIGHTS_W_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int2_lights_w

	CreateDynamicObject(-5332, CH_INT1_LIGHTS_X, CH_INT1_LIGHTS_Y, CH_INT1_LIGHTS_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int1_lights_m
	CreateDynamicObject(-5333, CH_INT1_LIGHTS_E_X, CH_INT1_LIGHTS_E_Y, CH_INT1_LIGHTS_E_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int1_lights_e
	CreateDynamicObject(-5334, CH_INT1_LIGHTS_W_X, CH_INT1_LIGHTS_W_Y, CH_INT1_LIGHTS_W_Z, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //cityhall/BITS/ch_int1_lights_w

	CreateDynamicObject(-5328, 1483.4919, -1812.6958, 57.7466, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_logorug.dff
	CreateDynamicObject(-5322, 1420.3562, -1789.0478, 18.2765, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5322, 1420.3562, -1791.0478, 18.2765, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5322, 1420.3562, -1787.0482, 18.2765, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5322, 1420.3562, -1793.0478, 18.2765, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5321, 1427.8514, -1780.8039, 18.2882, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_3.dff
	CreateDynamicObject(-5320, 1493.8076, -1781.1960, 18.2173, 0.0000, 0.0000, 90.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_singleBench.dff
	CreateDynamicObject(-5320, 1468.2567, -1781.1960, 18.2173, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_singleBench.dff
	CreateDynamicObject(-5322, 1528.6894, -1781.0687, 18.8843, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5322, 1530.1103, -1781.0687, 18.4843, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_fabricChair_6.dff
	CreateDynamicObject(-5319, 1528.6694, -1795.7965, 18.1779, 0.0000, 0.0000, -90.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1791.2967, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1793.2960, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1795.2960, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1797.2960, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1799.2960, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff
	CreateDynamicObject(-5319, 1539.5837, -1801.2960, 18.1779, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_doubleBench.dff

	// Doors by Spooks
	CreateDynamicObject(-5335, CH_INT2_X - 22.177, CH_INT2_Y + 9.771, CH_INT2_Z - 2.506, 0.0, 0.0, 0.0, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/DOORS/ch_door_safety.dff
	CreateDynamicObject(-5336, CH_INT2_X - 20.394, CH_INT2_Y + 2.718, CH_INT2_Z - 2.506, 0.0, 0.0, 180.0, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/DOORS/ch_door_health.dff
	CreateDynamicObject(-5337, CH_INT2_X + 20.394, CH_INT2_Y + 9.771, CH_INT2_Z - 2.506, 0.0, 0.0, 0.0, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/DOORS/ch_door_admin.dff
	CreateDynamicObject(-5338, CH_INT2_X + 22.177, CH_INT2_Y + 2.718, CH_INT2_Z - 2.506, 0.0, 0.0, 180.0, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/DOORS/ch_door_util.dff
	CreateDynamicObject(-5339, CH_INT2_X - 5.967, CH_INT2_Y - 5.504, CH_INT2_Z - 2.512, 0.0, 0.0, 270.0, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/DOORS/ch_door_mayor.dff

	CreateDynamicObject(-5341, 1474.128, -1794.159, 17.726, 0.000, 0.000, 270.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_auth.dff
	CreateDynamicObject(-5342, 1449.028, -1789.448, 17.736, 0.000, 0.000, 180.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff                                                                                        
	CreateDynamicObject(-5341, 1488.019, -1795.521, 17.723, 0.000, 0.000, 90.000, -1, 0, -1, CH_INT_SD, CH_INT_SD);  //CITYHALL/BITS/DOORS/ch_door_auth.dff
	CreateDynamicObject(-5342, 1461.431, -1789.448, 17.736, 0.000, 0.000, 180.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff                                                                                       
	CreateDynamicObject(-5342, 1504.101, -1789.448, 17.736, 0.000, 0.000, 180.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff                                                                                           
	//CreateDynamicObject(-5341, 1515.804, -1789.448, 17.736, 0.000, 0.000, 180.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_auth.dff                                                                                           
	CreateDynamicObject(-5342, 1514.247, -1783.150, 17.715, 0.000, 0.000, 0.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff  
	CreateDynamicObject(-5342, 1459.904, -1783.150, 17.715, 0.000, 0.000, 0.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff  
	CreateDynamicObject(-5342, 1447.483, -1783.150, 17.715, 0.000, 0.000, 0.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/BITS/DOORS/ch_door_blank.dff  
	//CreateDynamicObject(-5340, 1527.713, -1785.495, 17.735, 0.000, 0.000, -90.000, -1, 0, -1, CH_INT_SD, CH_INT_SD);  //CITYHALL/BITS/DOORS/ch_door_court.dff  
	//CreateDynamicObject(-5341, 1514.556, -1806.833, 17.725, 0.000, 0.000, 0.000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5341)
	//CreateDynamicObject(-5341, 1512.719, -1803.553, 17.725, 0.000, 0.000, -89.799, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5341)

	// XRAY
	CreateDynamicObject(-5325, 1522.365, -1786.061, 19.045, 0.000, 0.000, 180.000, -1, 0, -1, CH_INT_SD, CH_INT_SD); // Kate_Mercer (-5325)

	// Chairs added by Spooks
	CreateDynamicObject(1502, 1491.495, -1813.540, 57.760, 0.000, 0.000, 90.000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (1502)
	CreateDynamicObject(-5346, 1487.577, -1812.429, 57.740, 0.000, 0.000, -79.818, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5345, 1471.838, -1807.455, 57.747, 0.000, 0.000, 111.058, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5346, 1459.417, -1791.918, 57.770, 0.000, 0.000, 13.653, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1459.050, -1809.572, 57.750, 0.000, 0.000, 175.711, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5345, 1452.331, -1808.615, 57.740, 0.000, 0.000, 15.879, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1452.061, -1795.009, 57.760, 0.000, 0.000, 5.499, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5346, 1480.507, -1788.800, 57.750, 0.000, 0.000, -1.897, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1482.905, -1788.815, 57.750, 0.000, 0.000, -7.597, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1485.955, -1791.165, 57.750, 0.000, 0.000, -88.097, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1482.856, -1793.602, 57.750, 0.000, 0.000, -177.097, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1480.379, -1793.728, 57.750, 0.000, 0.000, 172.902, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1477.934, -1793.464, 57.750, 0.000, 0.000, 158.702, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1477.979, -1788.785, 57.750, 0.000, 0.000, 13.002, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1475.042, -1791.137, 57.750, 0.000, 0.000, 88.702, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1502.646, -1791.901, 57.750, 0.000, 0.000, -3.597, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, 1501.916, -1809.274, 57.750, 0.000, 0.000, 169.002, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)
	CreateDynamicObject(-5345, 1512.726, -1805.082, 57.740, 0.000, 0.000, 169.322, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1512.510, -1808.005, 57.740, 0.000, 0.000, 3.022, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1509.369, -1791.458, 57.740, 0.000, 0.000, -167.077, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1482.490, -1794.801, 17.726, 0.000, 0.000, -98.500, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1479.612, -1794.680, 17.726, 0.000, 0.000, 123.300, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1522.316, -1783.602, 17.715, 0.000, 0.000, -170.100, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5345)
	CreateDynamicObject(-5346, 1539.764, -1777.024, 18.261, 0.000, 0.000, 0.000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); // Kate_Mercer (-5346)

	CreateDynamicObject(-5350, 1536.9415, -1765.9395, 19.5858, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/ch_int1_jc_bits
    CreateDynamicObject(-5352, 1537.0829, -1765.9963, 19.7338, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_INT_SD, CH_INT_SD); //CITYHALL/INT/F1/ch_int1_jc
    CreateDynamicObject(-5351, 1532.2407, -1774.7523, 17.7338, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_jc_door (judge chambers)


	CreateDynamicObject(-5351, 1541.3464, -1803.6534, 17.7336, 0.0000, 0.0000, 180.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_jc_door (judge chambers)
	CreateDynamicObject(-5351, 1537.7128, -1803.6503, 17.7336, 0.0000, 0.0000, 0.0000, -1, 0, -1, CH_LOW_SD, CH_LOW_SD); //CITYHALL/BITS/MISC/ch_jc_door (judge chambers)
}

hook OnGameModeInit()
{
	print("[CH] Loading and creating City Hall");

	AddModels();
	CreateObjects();
	CreateBlinds();
	CreateDetectors();

	print("[CH] Loaded and created City Hall");
	return 1;
}

hook OnPlayerConnect(playerid)
{
	RemovePlayerBuildings(playerid);
	// printf("[CH] Removed Buildings for %d", playerid);
	return 1;
}

static enum E_CH_BLIND
{
	E_CH_BLIND_OPEN_MODEL,
	E_CH_BLIND_CLOSE_MODEL,
	Float:E_CH_BLIND_X,
	Float:E_CH_BLIND_Y,
	Float:E_CH_BLIND_Z,
	Float:E_CH_BLIND_RX,
	Float:E_CH_BLIND_RY,
	Float:E_CH_BLIND_RZ,
	bool:E_CH_BLIND_CLOSED,
	STREAMER_TAG_OBJECT:E_CH_BLIND_OBJECT,
	STREAMER_TAG_3D_TEXT_LABEL:E_CH_BLIND_LABEL
}

static Blinds[][E_CH_BLIND] = 
{
	{ -5323, -5324, 1549.899, -1788.788, 19.705, 0.000, 0.000, 0.00 },
	{ -5323, -5324, 1412.480, -1789.291, 19.696, 0.000, 0.000, 180.000 }
};

static CreateBlinds()
{
	for (new i = 0; i < sizeof(Blinds); i ++)
	{
		Blinds[i][E_CH_BLIND_OBJECT] = CreateDynamicObject(Blinds[i][E_CH_BLIND_OPEN_MODEL], Blinds[i][E_CH_BLIND_X], Blinds[i][E_CH_BLIND_Y], Blinds[i][E_CH_BLIND_Z], Blinds[i][E_CH_BLIND_RX], Blinds[i][E_CH_BLIND_RY], Blinds[i][E_CH_BLIND_RZ]);
		UpdateBlindText(i);
	}
}

static UpdateBlind(blind)
{
	new i = blind;
	DestroyDynamicObject(Blinds[i][E_CH_BLIND_OBJECT]);
	
	if (Blinds[i][E_CH_BLIND_CLOSED])
	{
		Blinds[i][E_CH_BLIND_OBJECT] = CreateDynamicObject(Blinds[i][E_CH_BLIND_CLOSE_MODEL], Blinds[i][E_CH_BLIND_X], Blinds[i][E_CH_BLIND_Y], Blinds[i][E_CH_BLIND_Z], Blinds[i][E_CH_BLIND_RX], Blinds[i][E_CH_BLIND_RY], Blinds[i][E_CH_BLIND_RZ]);
	}
	else
	{
		Blinds[i][E_CH_BLIND_OBJECT] = CreateDynamicObject(Blinds[i][E_CH_BLIND_OPEN_MODEL], Blinds[i][E_CH_BLIND_X], Blinds[i][E_CH_BLIND_Y], Blinds[i][E_CH_BLIND_Z], Blinds[i][E_CH_BLIND_RX], Blinds[i][E_CH_BLIND_RY], Blinds[i][E_CH_BLIND_RZ]);
	}

	UpdateBlindText(blind);
	return 1;
}

static UpdateBlindText(blind)
{
	new i = blind, Float:x, Float:y, Float:z;

	if (!Blinds[i][E_CH_BLIND_LABEL])
	{
		GetDynObjRelativePos(Blinds[i][E_CH_BLIND_OBJECT], x, y, z, -0.20, 0.0, -0.5);
		Blinds[i][E_CH_BLIND_LABEL] = CreateDynamic3DTextLabel("Curtains", 0x3479E3FF, x, y, z, 3.0, .testlos = true);
	}

	if (Blinds[i][E_CH_BLIND_CLOSED])
	{
		UpdateDynamic3DTextLabelText(Blinds[i][E_CH_BLIND_LABEL], 0x3479E3FF, "[Curtains]\n{DEDEDE}Press {FFFF00}~k~~VEHICLE_ENTER_EXIT~ {DEDEDE}to open.");
	}
	else
	{
		UpdateDynamic3DTextLabelText(Blinds[i][E_CH_BLIND_LABEL], 0x3479E3FF, "[Curtains]\n{DEDEDE}Press {FFFF00}~k~~VEHICLE_ENTER_EXIT~ {DEDEDE}to close.");
	}

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Check if the player is not in a vehicle and pressed the conversation yes key (Y by default)
	if (PRESSED(KEY_SECONDARY_ATTACK))
	{
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;
        
		for (new i = 0; i < sizeof(Blinds); i ++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Blinds[i][E_CH_BLIND_X], Blinds[i][E_CH_BLIND_Y], Blinds[i][E_CH_BLIND_Z]))
			{
				if (Blinds[i][E_CH_BLIND_CLOSED])
				{
					ProxDetectorAutoMe(playerid, 15.0, "opens the curtains.", true);
					Blinds[i][E_CH_BLIND_CLOSED] = false;
				}
				else
				{
					ProxDetectorAutoMe(playerid, 15.0, "closes the curtains.", true);
					Blinds[i][E_CH_BLIND_CLOSED] = true;
				}

				UpdateBlind(i);
				Streamer_Update(playerid);
				return 1;
			}
		}
	}

    return 1;
}


static enum E_CH_DETECTOR
{
	E_CH_DET_STATIC_MODEL,
	E_CH_DET_SCAN_OFF_MODEL,
	E_CH_DET_SCAN_ON_MODEL,
	Float:E_CH_DET_X,
	Float:E_CH_DET_Y,
	Float:E_CH_DET_Z,
	Float:E_CH_DET_RX,
	Float:E_CH_DET_RY,
	Float:E_CH_DET_RZ,
	bool:E_CH_DET_SCAN_ON,
	STREAMER_TAG_OBJECT:E_CH_DET_STATIC_OBJECT,
	STREAMER_TAG_OBJECT:E_CH_DET_SCAN_OBJECT,
	STREAMER_TAG_AREA:E_CH_DET_SCAN_AREA,
}

static Detectors[][E_CH_DETECTOR] = 
{
	{-5326, -5343, -5344, 1522.190, -1787.058, 19.205, 0.000, 0.000, 180.000 }
};

static CreateDetectors()
{
	for (new i = 0; i < sizeof(Detectors); i ++)
	{
		Detectors[i][E_CH_DET_STATIC_OBJECT] = CreateDynamicObject(Detectors[i][E_CH_DET_STATIC_MODEL], Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z], Detectors[i][E_CH_DET_RX], Detectors[i][E_CH_DET_RY], Detectors[i][E_CH_DET_RZ]);
		Detectors[i][E_CH_DET_SCAN_OBJECT] = CreateDynamicObject(Detectors[i][E_CH_DET_SCAN_OFF_MODEL], Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z], Detectors[i][E_CH_DET_RX], Detectors[i][E_CH_DET_RY], Detectors[i][E_CH_DET_RZ]);
		Detectors[i][E_CH_DET_SCAN_AREA] = CreateDynamicSphere(Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z], 7.5);
		printf("[CH] Detector %d created with area %d", i, Detectors[i][E_CH_DET_SCAN_AREA]);
	}
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		for (new i = 0, j = sizeof(Detectors); i < j; i ++)
		{
			if (Detectors[i][E_CH_DET_SCAN_AREA] == areaid)
			{
				// ShowPlayerFooter(playerid, "You ~g~entered~w~ the detector area.", 2500);
				PlayerVar[playerid][E_PLAYER_IN_DETECTOR] = true;
				PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX] = i;
				break;
			}
		}
	}

    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (PlayerVar[playerid][E_PLAYER_IN_DETECTOR] && PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX] >= 0)
	{
		if (areaid == Detectors[PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX]][E_CH_DET_SCAN_AREA])
		{
			// ShowPlayerFooter(playerid, "You ~r~left~w~ the detector area.", 2500);
			PlayerVar[playerid][E_PLAYER_IN_DETECTOR] = false;
			PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX] = -1;
		}
	}

    return 1;
}

static bool:IsMetalWeapon(weaponid)
{
	if (weaponid == 0 || weaponid == 5 || weaponid == 7 || weaponid == 10 || weaponid == 14 || weaponid == 15 || weaponid == 18) return false;
	return true;
}

timer DeactivateDetector[3000](i)
{
	DestroyDynamicObject(Detectors[i][E_CH_DET_SCAN_OBJECT]);
	Detectors[i][E_CH_DET_SCAN_OBJECT] = CreateDynamicObject(Detectors[i][E_CH_DET_SCAN_OFF_MODEL], Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z], Detectors[i][E_CH_DET_RX], Detectors[i][E_CH_DET_RY], Detectors[i][E_CH_DET_RZ]);
	Detectors[i][E_CH_DET_SCAN_ON] = false;

	foreach (new x : Player)
	{
		if (PlayerVar[x][E_PLAYER_DETECTOR_SOUNDED])
		{
			PlayerPlaySound(x, 1, 0.0, 0.0, 0.0);
		}

		if (IsPlayerInDynamicArea(x, Detectors[i][E_CH_DET_SCAN_AREA]))
		{
			Streamer_Update(x, STREAMER_TYPE_OBJECT);
		}

		PlayerVar[x][E_PLAYER_DETECTOR_SOUNDED] = false;
	}

	return 1;
}

timer DeactivateSound[1500]()
{
	foreach (new x : Player)
	{
		if (PlayerVar[x][E_PLAYER_DETECTOR_SOUNDED])
		{
			PlayerPlaySound(x, 0, 0.0, 0.0, 0.0);
		}
	}

	return 1;
}

static ActivateDetector(playerid, i)
{
	if (Detectors[i][E_CH_DET_SCAN_ON])
	{
		// Do nothing
		return 0;
	}

	DestroyDynamicObject(Detectors[i][E_CH_DET_SCAN_OBJECT]);
	Detectors[i][E_CH_DET_SCAN_OBJECT] = CreateDynamicObject(Detectors[i][E_CH_DET_SCAN_ON_MODEL], Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z], Detectors[i][E_CH_DET_RX], Detectors[i][E_CH_DET_RY], Detectors[i][E_CH_DET_RZ]);
	
	foreach (new x : Player)
	{
		if (IsPlayerInRangeOfPoint(x, 20.0, Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z]))
		{
			Streamer_Update(x, STREAMER_TYPE_OBJECT);
			PlayerPlaySound(x, 6001, Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z] + 1.0);
			PlayerVar[x][E_PLAYER_DETECTOR_SOUNDED] = true;
		}
	}

	//ProxDetector(playerid, 15.0, COLOR_ACTION, sprintf("** %s has triggered the metal detector.", SOLS_PlayerName(playerid)));
	ProxDetectorAutoMe(playerid, 30.0, "triggers the metal detector.", true);

	defer DeactivateDetector(i);
	defer DeactivateSound();

	Detectors[i][E_CH_DET_SCAN_ON] = true;
	return 1;
}

hook OnPlayerUpdate(playerid)
{
	if (PlayerVar[playerid][E_PLAYER_IN_DETECTOR] && PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX] >= 0)
	{
		new i = PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX];
		if (IsPlayerInRangeOfPoint(playerid, 1.0, Detectors[i][E_CH_DET_X], Detectors[i][E_CH_DET_Y], Detectors[i][E_CH_DET_Z]))
		{
			new gun, ammo, bool:alarm;
			
			for (new j = 0; j <= 12; j++)
			{
				GetPlayerWeaponData(playerid, j, gun, ammo);

				if (gun && ammo && IsMetalWeapon(gun))
				{
					alarm = true;
					break;
				}
			}

			if (alarm || random(40) == 0)
			{
				ActivateDetector(playerid, i);
			}
			else
			{
				ProxDetectorAutoMe(playerid, 30.0, "passes through the metal detector.");
			}

			PlayerVar[playerid][E_PLAYER_DETECTOR_INDEX] = -1;
			PlayerVar[playerid][E_PLAYER_IN_DETECTOR] = false;
		}
	}

	return 1;
}
