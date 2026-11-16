#include <a_samp>
#include <streamer>

static Carshow[3];
static CarshowRot[3];
static bool:CarshowBool;
static Float:CarshowOffset[3];

#define CARSHOW_X 1721.3691
#define CARSHOW_Y -1699.5600
#define CARSHOW_Z 11.7636
#define CARSHOW_DELTA   0.015

static bool:CarshowEnabled;
static CarshowModel;

static enum E_AUTO_DOOR
{
	Float:E_AUTO_DOOR_X,
	Float:E_AUTO_DOOR_Y,
	Float:E_AUTO_DOOR_Z,
	E_AUTO_DOOR_OBJ[2],
	E_AUTO_DOOR_AREA,
	bool:E_AUTO_DOOR_OPEN,
	E_AUTO_DOOR_NEARBY
}

#define AUTO_DOOR_DELTA 0.5

static GashAutoDoors[2][E_AUTO_DOOR] =
{
    { 1721.375, -1625.76, 20.905 },
    { 1721.375, -1625.76, 14.253 }
};

static SetGashAutoDoor(door, bool:open)
{
	new i = door;
	
	if (open)
	{
	    MoveDynamicObject(GashAutoDoors[i][E_AUTO_DOOR_OBJ][0], GashAutoDoors[i][E_AUTO_DOOR_X] - ( 1.95 * 2), GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], AUTO_DOOR_DELTA);
        MoveDynamicObject(GashAutoDoors[i][E_AUTO_DOOR_OBJ][1], GashAutoDoors[i][E_AUTO_DOOR_X] + ( 1.95 * 2), GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], AUTO_DOOR_DELTA);
	}
	else
	{
	    MoveDynamicObject(GashAutoDoors[i][E_AUTO_DOOR_OBJ][0], GashAutoDoors[i][E_AUTO_DOOR_X] - 1.95, GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], AUTO_DOOR_DELTA);
        MoveDynamicObject(GashAutoDoors[i][E_AUTO_DOOR_OBJ][1], GashAutoDoors[i][E_AUTO_DOOR_X] + 1.95, GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], AUTO_DOOR_DELTA);
	}

	GashAutoDoors[door][E_AUTO_DOOR_OPEN] = open;
}

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{

    for (new i = 0; i < sizeof(GashAutoDoors); i ++)
    {
        if (GashAutoDoors[i][E_AUTO_DOOR_AREA] == areaid)
        {
            GashAutoDoors[i][E_AUTO_DOOR_NEARBY] ++;
            
            if (!GashAutoDoors[i][E_AUTO_DOOR_OPEN])
            {
				SetGashAutoDoor(i, true);
            }
            
            break;
        }
    }

    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{

    for (new i = 0; i < sizeof(GashAutoDoors); i ++)
    {
        if (GashAutoDoors[i][E_AUTO_DOOR_AREA] == areaid)
        {
			GashAutoDoors[i][E_AUTO_DOOR_NEARBY] = 0;
			foreach (new p: Player)
			{
				if (p != playerid && IsPlayerInDynamicArea(p, areaid)) GashAutoDoors[i][E_AUTO_DOOR_NEARBY] ++;
			}

            if (!GashAutoDoors[i][E_AUTO_DOOR_NEARBY] && GashAutoDoors[i][E_AUTO_DOOR_OPEN])
            {
				SetGashAutoDoor(i, false);
            }

            break;
        }
    }

    return 1;
}

#define MALL_INT_X 1721.544
#define MALL_INT_Y -1663.975
#define MALL_INT_Z 12.376

#define MALL_GASH_X (MALL_INT_X - 0.294)
#define MALL_GASH_Y (MALL_INT_Y + 31.473)
#define MALL_GASH_Z (MALL_INT_Z + 5.455)

#define MALL_COFFEE_X (MALL_INT_X + 11.305)
#define MALL_COFFEE_Y (MALL_INT_Y + 9.18)
#define MALL_COFFEE_Z (MALL_INT_Z + 2.692)

#define MALL_VINYL_X (MALL_INT_X - 15.534)
#define MALL_VINYL_Y (MALL_INT_Y + 8.039)
#define MALL_VINYL_Z (MALL_INT_Z + 8.639)

#define MALL_JEWEL_X (MALL_INT_X - 16.680)
#define MALL_JEWEL_Y (MALL_INT_Y - 13.946)
#define MALL_JEWEL_Z (MALL_INT_Z + 8.663)

#define MALL_ITA_X (MALL_INT_X - 16.686)
#define MALL_ITA_Y (MALL_INT_Y - 34.011)
#define MALL_ITA_Z (MALL_INT_Z + 8.666)

#define MALL_AMMU_X (MALL_INT_X - 16.278)
#define MALL_AMMU_Y (MALL_INT_Y - 38.988)
#define MALL_AMMU_Z (MALL_INT_Z + 2.507)

#define MALL_TOOL_X (MALL_INT_X - 16.193)
#define MALL_TOOL_Y (MALL_INT_Y - 18.611)
#define MALL_TOOL_Z (MALL_INT_Z + 2.165)

#define MALL_MGMT_N_X (MALL_INT_X + 16.288)
#define MALL_MGMT_N_Y (MALL_INT_Y + 12.731)
#define MALL_MGMT_N_Z (MALL_INT_Z + 8.639)

#define MALL_PIZZA_X (MALL_INT_X - 15.674)
#define MALL_PIZZA_Y (MALL_INT_Y + 12.576)
#define MALL_PIZZA_Z (MALL_INT_Z + 2.261)

#define MALL_247_X (MALL_INT_X + 15.918)
#define MALL_247_Y (MALL_INT_Y - 35.125)
#define MALL_247_Z (MALL_INT_Z + 1.054)

#define MALL_SALOON_X (MALL_INT_X + 16.272)
#define MALL_SALOON_Y (MALL_INT_Y - 41.330)
#define MALL_SALOON_Z (MALL_INT_Z + 8.287)

#define MALL_TWAT_X (MALL_INT_X + 16.925)
#define MALL_TWAT_Y (MALL_INT_Y - 24.549)
#define MALL_TWAT_Z (MALL_INT_Z + 8.899)

#define MALL_WC_X (MALL_INT_X + 15.458)
#define MALL_WC_Y (MALL_INT_Y - 14.249)
#define MALL_WC_Z (MALL_INT_Z + 2.151)

static MallDynArea;

Mall_LoadEntities()
{
	MallDynArea = CreateDynamicRectangle(1631.1038, -1751.5531, 1816.5465, -1588.5083, 0, 0);

    AddSimpleModel(-1, 1923, -5100, "mall/carshowbase.dff", "mall/carshow.txd");
    AddSimpleModel(-1, 1923, -5101, "mall/carshowcar.dff", "mall/carshow.txd");
    AddSimpleModel(-1, 19325, -5102, "mall/carshowglass.dff", "mall/carshow.txd");

    AddSimpleModel(-1, 1923, -5103, "mall/mall_BANNERS.dff", "mall/mall.txd");
    
    AddSimpleModel(-1, 1923, -5104, "mall/mall_ROAD.dff", "mall/mall.txd");
    AddSimpleModel(-1, 1923, -5105, "mall/mall_EXT.dff", "mall/mall.txd");
    AddSimpleModel(-1, 1923, -5106, "mall/mall_INT.dff", "mall/mall.txd");
    
    AddSimpleModel(-1, 1923, -5107, "mall/mall_BITS.dff", "mall/mall_BITS.txd");
    AddSimpleModel(-1, 8674, -5108, "mall/mall_ALPHAS.dff", "mall/mall_ALPHAS.txd");
    AddSimpleModel(-1, 8674, -5109, "mall/mall_NEON.dff", "mall/mall_ALPHAS.txd");
    AddSimpleModel(-1, 8674, -5110, "mall/mall_ALPHAS2.dff", "mall/mall_ALPHAS.txd");
    
    AddSimpleModel(-1, 8674, -5115, "mall/mall_BOLLARD.dff", "mall/mall_ALPHAS.txd");
    
    CreateDynamicObject(-5104, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 800.0, 800.0); // MALL EXT ROAD
    CreateDynamicObject(-5105, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 800.0, 800.0); // MALL EXT MAIN
	CreateDynamicObject(-5106, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 450.0, 450.0); // MALL INT MAIN
	CreateDynamicObject(-5107, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 200.0, 200.0); // MALL BITS
	CreateDynamicObject(-5108, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 250.0, 250.0); // MALL ALPHAS
	CreateDynamicObject(-5103, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // MALL BANNERS
	
	CreateDynamicObject(-5109, MALL_INT_X - 0.736, MALL_INT_Y - 4.887, MALL_INT_Z + 14.499, 0.000, 0.000, 0.000, -1, -1, -1, 450.0, 450.0); // MALL NEON
	
	CreateDynamicObject(-5110, MALL_INT_X, MALL_INT_Y, MALL_INT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 150.0, 150.0); // MALL ALPHAS
    
    // BOLLARDS
    CreateDynamicObject(-5115, 1711.020, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1712.631, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1714.242, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1715.852, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1717.464, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1719.075, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1720.686, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1722.307, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1723.919, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1725.520, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1727.122, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1728.732, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1730.344, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1731.945, -1718.002, 13.177, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	
	// SIDE BOLLARDS
	CreateDynamicObject(-5115, 1699.531, -1668.032, 12.518, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1699.531, -1670.174, 12.518, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1743.172, -1670.174, 12.518, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	CreateDynamicObject(-5115, 1743.172, -1668.122, 12.518, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bollards
	
	// FOUNTAIN
	CreateDynamicObject(18739, 1721.557, -1639.827, 13.181, 0.000, 0.000, 0.000, -1, -1, -1, 75.0, 75.0); // Fountain PTFX
	CreateDynamicObject(18741, 1721.603, -1639.829, 11.351, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Fountain PTFX
    
    
    AddSimpleModel(-1, 1923, -5111, "mall/mall_GASH_MAIN.dff", "mall/mall_GASH.txd");
    AddSimpleModel(-1, 1923, -5112, "mall/mall_ESCL_DOWN.dff", "mall/mall_ESCL.txd");
    AddSimpleModel(-1, 19325, -5113, "mall/mall_GASH_WIN.dff", "mall/mall_GASH.txd");
    AddSimpleModel(-1, 1923, -5114, "mall/mall_GASH_BITS.dff", "mall/mall_GASH.txd");
 	
 	AddSimpleModel(-1, 1499, -5116, "mall/mall_GASH_DOOR1.dff", "mall/mall_GASH.txd");
 	AddSimpleModel(-1, 1499, -5117, "mall/mall_GASH_DOOR2.dff", "mall/mall_GASH.txd");
 	
 	AddSimpleModel(-1, 19325, -5118, "mall/mall_GASH_AUTODOOR_L.dff", "mall/mall_GASH.txd");
 	AddSimpleModel(-1, 19325, -5119, "mall/mall_GASH_AUTODOOR_R.dff", "mall/mall_GASH.txd");
 	
 	for (new i = 0; i < sizeof(GashAutoDoors); i ++)
 	{
 	    GashAutoDoors[i][E_AUTO_DOOR_OBJ][0] = CreateDynamicObject(-5118, GashAutoDoors[i][E_AUTO_DOOR_X], GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], 0.000, 0.000, 0.000); // Spooky (-5118)
        GashAutoDoors[i][E_AUTO_DOOR_OBJ][1] = CreateDynamicObject(-5119, GashAutoDoors[i][E_AUTO_DOOR_X], GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], 0.000, 0.000, 0.000); // Spooky (-5119)
        GashAutoDoors[i][E_AUTO_DOOR_AREA] = CreateDynamicSphere(GashAutoDoors[i][E_AUTO_DOOR_X], GashAutoDoors[i][E_AUTO_DOOR_Y], GashAutoDoors[i][E_AUTO_DOOR_Z], 3.00);
		SetGashAutoDoor(i, false);
	}

	CreateDynamicObject(-5111, MALL_GASH_X, MALL_GASH_Y, MALL_GASH_Z, 0.000, 0.000, 0.000); // Spooky (-5111)
	CreateDynamicObject(-5113, MALL_GASH_X + 11.918, MALL_GASH_Y - 7.212, MALL_GASH_Z - 3.863, 0.000, 0.000, 0.000); // Spooky (-5113)
	CreateDynamicObject(-5114, MALL_GASH_X, MALL_GASH_Y, MALL_GASH_Z, 0.000, 0.000, 0.000); // Spooky (-5114)
	
	// Doors
	CreateDynamicObject(-5116, 1719.291, -1617.166, 20.466, 0.000, 0.000, 90.000, -1, -1, -1, 40.0, 40.0); // GASH CHANGE DOOR
	CreateDynamicObject(-5117, 1723.445, -1617.127, 20.456, 0.000, 0.000, -90.000, -1, -1, -1, 40.0, 40.0); // GASH CHANGE DOOR

	// Escl
	CreateDynamicObject(3743, 1737.548, -1633.208, 16.090, 0.000, 0.000, 180.0, -1, -1, -1, 100.0, 100.0); // GASH ESCL UP
    CreateDynamicObject(-5112, 1705.193, -1633.208, 16.090, 0.000, 0.000, 180.0, -1, -1, -1, 100.0, 100.0); // GASH ESCL DN
    
    // Misc?  Cash, etc.
    CreateDynamicObject(1514, 1721.883, -1622.229, 13.605, 0.000, 0.000, 0.000); // Spooky (1514)
    
    // DOuble escl
    CreateDynamicObject(3586, 1721.563, -1678.497, 15.77, 0.000, 0.000, 180.000); // Spooky (3586)
    
    
    AddSimpleModel(-1, 1923, -5120, "mall/mall_COFFEE_MAIN.dff", "mall/mall_COFFEE.txd");
 	AddSimpleModel(-1, 1923, -5121, "mall/mall_COFFEE_BITS.dff", "mall/mall_COFFEE.txd");
 	AddSimpleModel(-1, 19325, -5122, "mall/mall_COFFEE_ALPHA.dff", "mall/mall_COFFEE.txd");
 	AddSimpleModel(-1, 1923, -5123, "mall/mall_COFFEE_TABLE.dff", "mall/mall_COFFEE.txd");
 	AddSimpleModel(-1, 1923, -5124, "mall/mall_COFFEE_SIGN.dff", "mall/mall_COFFEE.txd");
 	
 	CreateDynamicObject(-5120, MALL_COFFEE_X, MALL_COFFEE_Y, MALL_COFFEE_Z, 0.000, 0.000, 0.000); // Spooky (-5120) // mall_COFFEE_MAIN
	CreateDynamicObject(-5121, MALL_COFFEE_X + 5.297, MALL_COFFEE_Y + 1.837, MALL_COFFEE_Z - 1.878, 0.000, 0.000, 0.000); // Spooky (-5121) // mall_COFFEE_BITS
	CreateDynamicObject(-5122, MALL_COFFEE_X + 0.266, MALL_COFFEE_Y - 3.005, MALL_COFFEE_Z - 1.231, 0.000, 0.000, 0.000); // Spooky (-5122) // mall_COFFEE_ALPHA
	CreateDynamicObject(-5124, MALL_COFFEE_X + 0.084, MALL_COFFEE_Y - 3.086, MALL_COFFEE_Z + 0.594, 0.000, 0.000, 0.000); // Spooky (-5124) // mall_COFFEE_SIGN


	CreateDynamicObject(-5123, 1735.252, -1660.754, 13.098, 0.000, 0.000, 0.000); // Spooky (-5123)
	CreateDynamicObject(-5123, 1735.252, -1663.515, 13.098, 0.000, 0.000, 0.000); // Spooky (-5123)
	CreateDynamicObject(-5123, 1738.824, -1663.515, 13.098, 0.000, 0.000, -86.299); // Spooky (-5123)
	CreateDynamicObject(-5123, 1738.626, -1660.441, 13.098, 0.000, 0.000, -24.499); // Spooky (-5123)

	
	AddSimpleModel(-1, 1923, -5140, "mall/mall_VINYL_MAIN.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 1923, -5141, "mall/mall_VINYL_BITS.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 1923, -5142, "mall/mall_VINYL_LIGHTS.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 1923, -5143, "mall/mall_VINYL_RECS1.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 1923, -5144, "mall/mall_VINYL_RECS2.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 1923, -5145, "mall/mall_VINYL_STAND.dff", "mall/mall_VINYL.txd");
	AddSimpleModel(-1, 19325, -5146, "mall/mall_VINYL_GLASS.dff", "mall/mall_VINYL.txd");
	
	CreateDynamicObject(-5140, MALL_VINYL_X, MALL_VINYL_Y, MALL_VINYL_Z, 0.000, 0.000, 0.000); // Spooky (-5140) // mall_VINYL_MAIN
	CreateDynamicObject(-5141, MALL_VINYL_X - 1.37, MALL_VINYL_Y + 1.058, MALL_VINYL_Z + 0.298, 0.000, 0.000, 0.000); // Spooky (-5141) // mall_VINYL_BITS
	CreateDynamicObject(-5142, MALL_VINYL_X - 0.477, MALL_VINYL_Y + 0.43, MALL_VINYL_Z + 1.875, 0.000, 0.000, 0.000); // Spooky (-5142) // mall_VINYL_LIGHTS
	CreateDynamicObject(-5146, MALL_VINYL_X + 4.077, MALL_VINYL_Y - 2.083, MALL_VINYL_Z - 0.504, 0.000, 0.000, 0.000); // Spooky (-5145) // mall_VINYL_GLASS

	
	CreateDynamicObject(-5144, 1709.578, -1652.523, 19.731, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-5144)
	CreateDynamicObject(-5144, 1709.578, -1656.174, 19.731, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-5144)
	CreateDynamicObject(-5144, 1709.578, -1659.834, 19.731, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-5144)
	CreateDynamicObject(-5144, 1709.578, -1663.425, 19.731, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Spooky (-5144)
	CreateDynamicObject(-5143, 1705.876, -1652.452, 19.681, 0.000, 0.000, 90.0, -1, -1, -1, 100.0, 100.0); // Spooky (-5143)
	CreateDynamicObject(-5143, 1705.803, -1656.163, 19.681, 0.000, 0.000, 90.0, -1, -1, -1, 100.0, 100.0); // Spooky (-5143)
	CreateDynamicObject(-5143, 1705.737, -1659.593, 19.681, 0.000, 0.000, 90.0, -1, -1, -1, 100.0, 100.0); // Spooky (-5143)
	CreateDynamicObject(-5145, 1705.150, -1649.053, 20.001, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Spooky (-5145)
	CreateDynamicObject(-5145, 1705.221, -1648.252, 20.001, 0.000, 0.000, -89.699, -1, -1, -1, 50.0, 50.0); // Spooky (-5145)
	
	AddSimpleModel(-1, 1923, -5150, "mall/mall_JEWEL_main.dff", "mall/mall_JEWEL.txd");
	AddSimpleModel(-1, 1923, -5151, "mall/mall_JEWEL_bits.dff", "mall/mall_JEWEL.txd");
	AddSimpleModel(-1, 8674, -5152, "mall/mall_JEWEL_glass.dff", "mall/mall_JEWEL.txd");
	AddSimpleModel(-1, 19325, -5153, "mall/mall_JEWEL_glass2.dff", "mall/mall_JEWEL.txd");
	AddSimpleModel(-1, 1923, -5154, "mall/mall_JEWEL_lights.dff", "mall/mall_JEWEL.txd");
	
	CreateDynamicObject(-5150, MALL_JEWEL_X, MALL_JEWEL_Y, MALL_JEWEL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5151, MALL_JEWEL_X, MALL_JEWEL_Y, MALL_JEWEL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Bits
	CreateDynamicObject(-5152, MALL_JEWEL_X, MALL_JEWEL_Y, MALL_JEWEL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Glass
	CreateDynamicObject(-5153, MALL_JEWEL_X, MALL_JEWEL_Y, MALL_JEWEL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Glass Inside
	CreateDynamicObject(-5154, MALL_JEWEL_X, MALL_JEWEL_Y, MALL_JEWEL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Lights
	
	AddSimpleModel(-1, 1923, -5155, "mall/mall_ITA_main.dff", "mall/mall_ITA.txd");
	AddSimpleModel(-1, 1923, -5156, "mall/mall_ITA_bits.dff", "mall/mall_ITA.txd");
	AddSimpleModel(-1, 19325, -5157, "mall/mall_ITA_glass.dff", "mall/mall_ITA.txd");
	AddSimpleModel(-1, 1923, -5158, "mall/mall_ITA_table.dff", "mall/mall_ITA.txd");
	
	CreateDynamicObject(-5155, MALL_ITA_X, MALL_ITA_Y, MALL_ITA_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5156, MALL_ITA_X, MALL_ITA_Y, MALL_ITA_Z, 0.000, 0.000, 0.000, -1, -1, -1, 75.0, 75.0); // Bits
	CreateDynamicObject(-5157, MALL_ITA_X + 5.12, MALL_ITA_Y + 0.031, MALL_ITA_Z - 0.313, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Glass
	
	// Tables
	CreateDynamicObject(-5158, 1707.036, -1709.194, 19.693, 0.000, 0.000, 0.000); // Spooky (-5158)
	CreateDynamicObject(-5158, 1707.032, -1705.313, 19.693, 0.000, 0.000, 90.400); // Spooky (-5158)
	CreateDynamicObject(-5158, 1706.990, -1701.473, 19.693, 0.000, 0.000, -175.399); // Spooky (-5158)
	CreateDynamicObject(-5158, 1706.815, -1697.758, 19.693, 0.000, 0.000, -91.499); // Spooky (-5158)
	CreateDynamicObject(-5158, 1703.146, -1705.315, 19.693, 0.000, 0.000, -91.499); // Spooky (-5158)
	CreateDynamicObject(-5158, 1703.033, -1709.173, 19.693, 0.000, 0.000, -3.499); // Spooky (-5158)
	
	AddSimpleModel(-1, 1923, -5160, "mall/mall_AMMU_main.dff", "mall/mall_AMMU.txd");
	AddSimpleModel(-1, 1923, -5161, "mall/mall_AMMU_bits.dff", "mall/mall_AMMU.txd");
	AddSimpleModel(-1, 19325, -5162, "mall/mall_AMMU_glass.dff", "mall/mall_AMMU.txd");
	AddSimpleModel(-1, 1923, -5163, "mall/mall_AMMU_guns.dff", "mall/mall_AMMU.txd");
	AddSimpleModel(-1, 1923, -5164, "mall/mall_AMMU_sign.dff", "mall/mall_AMMU.txd");
	
	CreateDynamicObject(-5160, MALL_AMMU_X, MALL_AMMU_Y, MALL_AMMU_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5161, MALL_AMMU_X, MALL_AMMU_Y, MALL_AMMU_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bits
	CreateDynamicObject(-5162, MALL_AMMU_X, MALL_AMMU_Y, MALL_AMMU_Z, 0.000, 0.000, 0.000, -1, -1, -1, 125.0, 125.0); // Glass
	
	CreateDynamicObject(-5163, MALL_AMMU_X - 3.096, MALL_AMMU_Y + 6.718, MALL_AMMU_Z - 0.674, 0.000, 0.000, 0.000, -1, -1, -1, 25.0, 25.0); // Guns
	CreateDynamicObject(-5164, MALL_AMMU_X + 4.001, MALL_AMMU_Y - 5.875, MALL_AMMU_Z + 0.635, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Sign
	CreateDynamicObject(-5164, MALL_AMMU_X + 4.001, MALL_AMMU_Y + 5.090, MALL_AMMU_Z + 0.635, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Sign
	
	AddSimpleModel(-1, 1923, -5165, "mall/mall_TOOL_main.dff", "mall/mall_TOOL.txd");
	AddSimpleModel(-1, 1923, -5166, "mall/mall_TOOL_bits.dff", "mall/mall_TOOL.txd");
	AddSimpleModel(-1, 19325, -5167, "mall/mall_TOOL_glass.dff", "mall/mall_TOOL.txd");
	
	CreateDynamicObject(-5165, MALL_TOOL_X, MALL_TOOL_Y, MALL_TOOL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5166, MALL_TOOL_X, MALL_TOOL_Y, MALL_TOOL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 75.0, 75.0); // Bits
    CreateDynamicObject(-5167, MALL_TOOL_X, MALL_TOOL_Y, MALL_TOOL_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Glass
    
    AddSimpleModel(-1, 1923, -5170, "mall/mall_MGMT_N_MAIN.dff", "mall/mall_MGMT.txd");
	AddSimpleModel(-1, 19325, -5171, "mall/mall_MGMT_N_GLASS.dff", "mall/mall_MGMT.txd");
	
	CreateDynamicObject(-5170, MALL_MGMT_N_X, MALL_MGMT_N_Y, MALL_MGMT_N_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
    CreateDynamicObject(-5171, MALL_MGMT_N_X, MALL_MGMT_N_Y, MALL_MGMT_N_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Glass
    
	CreateDynamicObject(-3494, 1732.989, -1653.201, 19.140, 0.000, 0.000, -90.000, -1, -1, -1, 100.0, 100.0); // Door
	CreateDynamicObject(-3495, 1732.989, -1650.773, 19.140, 0.000, 0.000, -90.000, -1, -1, -1, 100.0, 100.0); // Door
	
	CreateDynamicObject(-3495, 1736.634, -1656.781, 19.140, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Door
	CreateDynamicObject(-3494, 1739.069, -1656.781, 19.140, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Door
	
	AddSimpleModel(-1, 1923, -5180, "mall/mall_247.dff", "mall/mall_247.txd");
	AddSimpleModel(-1, 1923, -5181, "mall/mall_247_BITS.dff", "mall/mall_247.txd");
	AddSimpleModel(-1, 19325, -5182, "mall/mall_247_alpha.dff", "mall/mall_247.txd");
	CreateDynamicObject(-5180, MALL_247_X, MALL_247_Y, MALL_247_Z, 0.000, 0.000, 90.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5181, MALL_247_X, MALL_247_Y, MALL_247_Z, 0.000, 0.000, 90.000, -1, -1, -1, 100.0, 100.0); // Bits
	CreateDynamicObject(-5182, MALL_247_X, MALL_247_Y, MALL_247_Z, 0.000, 0.000, 90.000, -1, -1, -1, 100.0, 100.0); // Alpha
	
	AddSimpleModel(-1, 1923, -5185, "mall/mall_PIZZA.dff", "mall/mall_PIZZA.txd");
	AddSimpleModel(-1, 1923, -5186, "mall/mall_PIZZA_BITS.dff", "mall/mall_PIZZA.txd");
	AddSimpleModel(-1, 19325, -5187, "mall/mall_PIZZA_ALPHA.dff", "mall/mall_ALPHAS.txd");
	CreateDynamicObject(-5185, MALL_PIZZA_X, MALL_PIZZA_Y, MALL_PIZZA_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5186, MALL_PIZZA_X - 1.620, MALL_PIZZA_Y - 3.457, MALL_PIZZA_Z - 2.066, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bits
	CreateDynamicObject(-5187, MALL_PIZZA_X + 4.234, MALL_PIZZA_Y - 6.537, MALL_PIZZA_Z - 0.510, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Alpha
	
	AddSimpleModel(-1, 1923, -5190, "mall/mall_SALOON.dff", "mall/mall_SALOON.txd");
	AddSimpleModel(-1, 1923, -5191, "mall/mall_SALOON_BITS.dff", "mall/mall_SALOON.txd");
	AddSimpleModel(-1, 19325, -5192, "mall/mall_SALOON_ALPHA.dff", "mall/mall_ALPHAS.txd");
	CreateDynamicObject(-5190, MALL_SALOON_X, MALL_SALOON_Y, MALL_SALOON_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5191, MALL_SALOON_X, MALL_SALOON_Y, MALL_SALOON_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bits
	CreateDynamicObject(-5192, MALL_SALOON_X - 4.812, MALL_SALOON_Y - 0.098, MALL_SALOON_Z + 0.102, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Alpha
	
	AddSimpleModel(-1, 1923, -5195, "mall/mall_TWAT.dff", "mall/mall_TWAT.txd");
	AddSimpleModel(-1, 1923, -5196, "mall/mall_TWAT_BITS.dff", "mall/mall_TWAT.txd");
	AddSimpleModel(-1, 19325, -5197, "mall/mall_TWAT_alpha.dff", "mall/mall_ALPHAS.txd");
	CreateDynamicObject(-5195, MALL_TWAT_X, MALL_TWAT_Y, MALL_TWAT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 300.0, 300.0); // Main
	CreateDynamicObject(-5196, MALL_TWAT_X, MALL_TWAT_Y, MALL_TWAT_Z, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Bits
	CreateDynamicObject(-5197, MALL_TWAT_X - 5.470, MALL_TWAT_Y + 0.114, MALL_TWAT_Z - 0.475, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // Alpha
	
	AddSimpleModel(-1, 1923, -5200, "mall/mall_WCS.dff", "mall/mall_WCS.txd");
	CreateDynamicObject(-5200, MALL_WC_X, MALL_WC_Y, MALL_WC_Z, 0.000, 0.000, 0.000, -1, -1, -1, 150.0, 150.0); // Less important
	
 	AddSimpleModel(-1, 1923, -5201, "mall/mall_FOUNTAIN.dff", "mall/mall_FOUNTAIN.txd");
    CreateDynamicObject(-5201, 1721.5520, -1639.8190, 13.0070, 0.000, 0.000, 0.000, -1, -1, -1, 100.0, 100.0); // MALL FOUNTAIN

	AddSimpleModel(-1, 19325, -5202, "mall/mall_RAILINGS.dff", "mall/mall_ALPHAS.txd");
    CreateDynamicObject(-5202, MALL_INT_X + 0.022, MALL_INT_Y - 58.007, MALL_INT_Z + 1.179, 0.000, 0.000, 0.000, -1, -1, -1, 150.0, 150.0); // MALL EXT RAILINGS

	AddSimpleModel(-1, 1923, -5203, "mall/mall_BOOTH.dff", "mall/mall_BOOTH.txd");
    CreateDynamicObject(-5203, MALL_INT_X + 13.662, MALL_INT_Y - 5.282, MALL_INT_Z + 8.639, 0.000, 0.000, 0.000, -1, -1, -1, 200.0, 200.0); // MALL INFO BOOTH
	CreateDynamicObject(1722, 1737.134, -1668.707, 19.161, 0.000, 0.000, 94.400, -1, -1, -1, 50.0, 50.0); // Kate_Mercer (1722)
	CreateDynamicObject(1806, 1735.365, -1670.070, 19.191, 0.000, 0.000, -164.399, -1, -1, -1, 50.0, 50.0); // Kate_Mercer (1806)
	CreateDynamicObject(1806, 1734.411, -1671.769, 19.151, 0.000, 0.000, -21.600, -1, -1, -1, 50.0, 50.0);// Kate_Mercer (1806)

	AddSimpleModel(-1, 1923, -5210, "mall/mall_PODIUM.dff", "mall/mall_OPENING.txd");
    AddSimpleModel(-1, 1923, -5211, "mall/mall_RIBBON.dff", "mall/mall_OPENING.txd");
	AddSimpleModel(-1, 1923, -5212, "mall/mall_RIBBON_CUT.dff", "mall/mall_OPENING.txd");
	AddSimpleModel(-1, 975, -5213, "mall/mall_GATE.dff", "mall/mall_GATE.txd");

	CreateMallCarShow();
    return 1;
}

IsPlayerInMallArea(playerid)
{
	return IsPlayerInDynamicArea(playerid, MallDynArea);
}

public OnObjectMoved(objectid)
{
    if (CarshowEnabled && objectid == Carshow[0])
    {
		CarshowBool = !CarshowBool;

        for (new i = 0; i < sizeof(Carshow); i ++)
        {
			if (IsValidObject(Carshow[i]))
			{
				CarshowRot[i] = (CarshowRot[i] + 179) % 360;
				if (CarshowBool) MoveObject(Carshow[i], CARSHOW_X + CarshowOffset[0], CARSHOW_Y + CarshowOffset[1], CARSHOW_Z + CarshowOffset[2] - 0.1, CARSHOW_DELTA, 0.0, 0.0, CarshowRot[i]);
				else MoveObject(Carshow[i], CARSHOW_X + CarshowOffset[0], CARSHOW_Y + CarshowOffset[1], CARSHOW_Z + CarshowOffset[2] + 0.1, CARSHOW_DELTA, 0.0, 0.0, CarshowRot[i]);
			}
        }
    }

    return 1;
}

static DestroyMallCarShow()
{
	for (new i = 0; i < sizeof(Carshow); i ++)
	{
		if (IsValidObject(Carshow[i]))
		{
			DestroyObject(Carshow[i]);
		}

		Carshow[i] = INVALID_OBJECT_ID;
	}
}

static CreateMallCarShow()
{
	DestroyMallCarShow();
	CarshowBool = false;

	if (CarshowModel)
	{
		Carshow[0] = CreateObject(-5100, CARSHOW_X, CARSHOW_Y, CARSHOW_Z, 0.000, 0.000, 0.000); // Spooky (-5029)
		Carshow[1] = CreateObject(CarshowModel, CARSHOW_X + CarshowOffset[0], CARSHOW_Y + CarshowOffset[1], CARSHOW_Z + CarshowOffset[2], 0.000, 0.000, 0.000); // Spooky (-5029)
	}
	else
	{
		Carshow[0] = CreateObject(-5100, CARSHOW_X, CARSHOW_Y, CARSHOW_Z, 0.000, 0.000, 0.000); // Spooky (-5029)
		Carshow[1] = CreateObject(-5101, CARSHOW_X, CARSHOW_Y, CARSHOW_Z, 0.000, 0.000, 0.000); // Spooky (-5030)
		Carshow[2] = CreateObject(-5102, CARSHOW_X, CARSHOW_Y, CARSHOW_Z, 0.000, 0.000, 0.000); // Spooky (-5031)
		CarshowOffset[0] = 0.0;
		CarshowOffset[1] = 0.0;
		CarshowOffset[2] = 0.0;
	}

	for (new i = 0; i < sizeof(Carshow); i ++)
	{
		CarshowRot[i] = 179;

		if (IsValidObject(Carshow[i]))
		{
			MoveObject(Carshow[i], CARSHOW_X + CarshowOffset[0], CARSHOW_Y + CarshowOffset[1], CARSHOW_Z + CarshowOffset[2] + 0.1, CARSHOW_DELTA, 0.0, 0.0, CarshowRot[i]);
		}
	}

	CarshowEnabled = true;
}

CMD:mallcarshow(playerid, params[])
{
	new enabled;

	if (!IsPlayerAdmin(playerid)) return false;

	if (sscanf(params, "d", enabled)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/mallcarshow [0 or 1]");
	}

	CarshowEnabled = bool:enabled;

	if (CarshowEnabled) CreateMallCarShow();
	else DestroyMallCarShow();

	return true;
}

CMD:mallcarshowmodel(playerid, params[])
{
	new modelid, Float:x, Float:y, Float:z;

	if (!IsPlayerAdmin(playerid)) return false;

	if (sscanf(params, "dF(0.0)F(0.0)F(0.0)", modelid, x, y, z)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/mallcarshowmodel [modelid (0 is default)] [x] [y] [z]");
	}

	CarshowModel = modelid;
	CarshowOffset[0] = x;
	CarshowOffset[1] = y;
	CarshowOffset[2] = z;

	if (CarshowEnabled) CreateMallCarShow();
	else DestroyMallCarShow();

	return true;
}

static Podium;
static Ribbon;
static Chairs[50];
static ChairIndex = 0;

AddChair(model, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	Chairs[ChairIndex] = CreateDynamicObject(model, x, y, z, rx, ry, rz);
	ChairIndex ++;
}

CMD:mallribbon(playerid, params[])
{
	new enabled;

	if (!IsPlayerAdmin(playerid)) return false;

	if (sscanf(params, "d", enabled)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/mallribbon [0 or 1]");
	}

	if (Podium && IsValidDynamicObject(Podium)) DestroyDynamicObject(Podium);
	if (Ribbon && IsValidDynamicObject(Ribbon)) DestroyDynamicObject(Ribbon);

	for (new i = 0; i < 50; i ++)
	{
		if (Chairs[i] && IsValidDynamicObject(Chairs[i]))
		{
			DestroyDynamicObject(Chairs[i]);
		}
	}

	if (!enabled)
	{
		return true;
	}

	ChairIndex = 0;
	AddChair(2121, 1718.864, -1701.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1719.765, -1701.080, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1720.696, -1701.087, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1721.676, -1701.094, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1722.637, -1701.101, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1723.568, -1701.109, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)

	AddChair(2121, 1718.864, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1719.765, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1720.696, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1721.676, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1722.637, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1723.568, -1699.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)

	AddChair(2121, 1718.864, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1719.765, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1720.696, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1721.676, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1722.637, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)
	AddChair(2121, 1723.568, -1697.073, 12.413, 0.000, 0.000, 180.000); // Kate_Mercer (2121)

	Podium = CreateDynamicObject(-5210, 1720.802, -1688.970, 12.514, 0.000, 0.000, -90.0); // Kate_Mercer (-5210)
	Ribbon = CreateDynamicObject(-5211, 1721.615, -1687.047, 12.514, 0.000, 0.000, 90.0); // Kate_Mercer (-5211)
	return true;
}

CMD:cutribbon(playerid, params[])
{
	if (!GetPlayerAdminLevel(playerid)) return false;
	if (Ribbon && IsValidDynamicObject(Ribbon)) DestroyDynamicObject(Ribbon);

	Ribbon = CreateDynamicObject(-5212, 1721.615, -1687.047, 12.514, 0.000, 0.000, 90.0); // Kate_Mercer (-5211)

	foreach (new i: Player)
	{
		if (IsPlayerInRangeOfPoint(i, 50.0, 1721.615, -1687.047, 12.514))
		{
			Streamer_Update(i, STREAMER_TYPE_OBJECT);
		}
	}

	ProxDetectorAutoMe(playerid, 30.0, "cuts the ribbon.", true);
	return true;
}
