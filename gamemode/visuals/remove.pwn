#define MAX_RMB_LINES 2000

static enum E_RMB
{
    E_RMB_MODEL,
    Float:E_RMB_X,
    Float:E_RMB_Y,
    Float:E_RMB_Z,
    Float:E_RMB_RADIUS,
    bool:E_RMB_BAD
}

static RMBLines[MAX_RMB_LINES][E_RMB];
static RMB_INDEX = 0;

SOLS_RemoveBuilding(playerid, modelid, Float:x, Float:y, Float:z, Float:radius)
{
    // print("SOLS RMB");

    /*
    RMBLines[RMB_INDEX][E_RMB_MODEL] = modelid;
    RMBLines[RMB_INDEX][E_RMB_X] = x;
    RMBLines[RMB_INDEX][E_RMB_Y] = y;
    RMBLines[RMB_INDEX][E_RMB_Z] = z;
    RMBLines[RMB_INDEX][E_RMB_RADIUS] = radius;
    
    new Float:distance;

    for (new i = 0; i < RMB_INDEX; i++)
    {
        if (RMBLines[i][E_RMB_MODEL] != modelid) continue;

        distance = GetDistanceBetweenPoints(x, y, z, RMBLines[i][E_RMB_X], RMBLines[i][E_RMB_Y], RMBLines[i][E_RMB_Z]);

        if (distance < 10.0)
        {
            RMBLines[RMB_INDEX][E_RMB_BAD] = true;
            break;
        }

        // printf("Removing (%d) %d at %.02f, %.02f, %.02f which is %.02fm away from (%d) %d at %.02f, %.02f, %.02f", RMB_INDEX, modelid, x, y, z, GetDistanceBetweenPoints(x, y, z, RMBLines[i][E_RMB_X], RMBLines[i][E_RMB_Y], RMBLines[i][E_RMB_Z]), i, RMBLines[i][E_RMB_MODEL], RMBLines[i][E_RMB_X], RMBLines[i][E_RMB_Y], RMBLines[i][E_RMB_Z]);
    }

    RMB_INDEX ++;
    */

    return RemoveBuildingForPlayer(playerid, modelid, x, y, z, radius);
}


Map_RemoveBuildings(playerid) {
/*
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): The first 1000 removed buildings ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): Are fine ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): Once it goes past this ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): And model ID used in those 1k lines ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): Will not trigger ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): Might not be the exact issue, but ^ is my guess based from the tests we just did ]}
{[ [ADMIN CHAT] Manager Hades (R. Sheldon) (1): We can try fixing it by creating a center object in each area of remove lines and only ...
... removing it once, but using the radius ]}

*/

    // Hotel WIP
    SOLS_RemoveBuilding(playerid, 4075, 1791.7969, -1716.9844, 12.5234, 0.25);
	SOLS_RemoveBuilding(playerid, 4076, 1783.1016, -1702.3047, 14.3516, 0.25);
	SOLS_RemoveBuilding(playerid, 1531, 1799.1328, -1708.7656, 14.1016, 0.25);
	SOLS_RemoveBuilding(playerid, 4018, 1791.7969, -1716.9844, 12.5234, 0.25);
	SOLS_RemoveBuilding(playerid, 4027, 1783.1016, -1702.3047, 14.3516, 0.25);

    // Trailer fix
    //SOLS_RemoveBuilding(playerid, 14386, 0.3359, -0.2891, 999.8828, 0.25);
    //SOLS_RemoveBuilding(playerid, 14385, 0.2969, 0.6094, 1000.0000, 0.25);
    //SOLS_RemoveBuilding(playerid, 2275, -0.1406, 5.3516, 1000.0000, 0.25);
    SOLS_RemoveBuilding(playerid, -1, 0.2969, 0.6094, 1000.0000, 15.0);

    // New pecado
    SOLS_RemoveBuilding(playerid, 700, 1812.3438, -1968.8047, 11.4453, 0.25);

    // AP
    SOLS_RemoveBuilding(playerid, 4200, 1352.6328, -1647.3438, 14.7031, 0.25);
    SOLS_RemoveBuilding(playerid, 4199, 1352.6328, -1647.3438, 14.7031, 0.25);

    // EC Door Road
    SOLS_RemoveBuilding(playerid, 3061, 1820.2477, -1994.2225, 13.5731, 50.0);

    // East LA billboard fix
    SOLS_RemoveBuilding(playerid, 17535, 2364.0547, -1391.5313, 41.3516, 0.25);

    // Map for ElJefe house in Flint County
    SOLS_RemoveBuilding(playerid, 791, -608.492, -1280.520, 15.984, 0.250);
    SOLS_RemoveBuilding(playerid, 785, -608.492, -1280.520, 15.984, 0.250);


    // SANN HQ NEW
    SOLS_RemoveBuilding(playerid, 4077, 1781.4766, -1648.4219, 26.8359, 0.25);
    SOLS_RemoveBuilding(playerid, 4028, 1781.4766, -1648.4219, 26.8359, 0.25);
    SOLS_RemoveBuilding(playerid, 1311, 1823.4219, -1647.2734, 16.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 1266, 1805.0234, -1692.4453, 25.1484, 0.25);
    SOLS_RemoveBuilding(playerid, 1260, 1805.0234, -1692.4453, 25.1484, 0.25);

    // san pedro NEW, OPTIMIZED
	SOLS_RemoveBuilding(playerid, 17869, 2510.4766, -1543.2734, 21.7109, 0.25);
    SOLS_RemoveBuilding(playerid, 17870, 2520.7266, -1530.2500, 22.7422, 0.25);
    SOLS_RemoveBuilding(playerid, 17865, 2510.4766, -1543.2734, 21.7109, 0.25);
    SOLS_RemoveBuilding(playerid, 17864, 2520.7266, -1530.2500, 22.7422, 0.25);
    SOLS_RemoveBuilding(playerid, 1297, 2522.9766, -1508.9609, 26.3047, 0.25);
    SOLS_RemoveBuilding(playerid, 17702, 2490.9063, -1504.3281, 22.9219, 0.25); //Lae2_roads31 LOD (obj 17639)
    SOLS_RemoveBuilding(playerid, 17863, 2467.4609, -1538.2500, 27.6016, 0.25); //compmart_alpha (also SD wires)
    
    // optimized san pedro palm tree
    SOLS_RemoveBuilding(playerid, 620, 2530.2188, -1567.6406, 20.9297, 70.0);
    SOLS_RemoveBuilding(playerid, 673, 2552.5703, -1550.0234, 20.9297, 50.0);
    SOLS_RemoveBuilding(playerid, 616, 2510.5625, -1563.4766, 21.8047, 50.0);
	
    // EAST LS SHERIFF'S STATION
    SOLS_RemoveBuilding(playerid, 17868, 2458.3828, -1532.4375, 22.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 17862, 2458.3828, -1532.4375, 22.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 1297, 2474.1016, -1544.2578, 26.3594, 30.0);  // sd lamps
    SOLS_RemoveBuilding(playerid, 17916, 2366.8125, -1537.5391, 39.4688, 0.25); // billboard
    SOLS_RemoveBuilding(playerid, 1525, 2462.2656, -1541.4141, 25.4219, 0.25); // alpha
    SOLS_RemoveBuilding(playerid, 760,  2482.9297, -1530.5391, 26.3047, 30.0); // bushes
    SOLS_RemoveBuilding(playerid, 1308, 2491.8281, -1516.5078, 23.2109, 0.25); // telepole

    // Black Magic Strip Club (Biskit)
    SOLS_RemoveBuilding(playerid, 4119, 1375.2734, -1452.3984, 23.0391, 0.25);
    SOLS_RemoveBuilding(playerid, 4117, 1375.2734, -1452.3984, 23.0391, 0.25);

    // Rooftop lounge by Grafake - https://forum.gta-chronicles.com/index.php?threads/5769/#post-69081
    SOLS_RemoveBuilding(playerid, 6389, 586.195, -1634.670, 31.209, 0.250);
    SOLS_RemoveBuilding(playerid, 6396, 586.195, -1634.670, 31.209, 0.250);
    SOLS_RemoveBuilding(playerid, 726, 608.046, -1657.318, 14.803, 0.250);
    SOLS_RemoveBuilding(playerid, 1226, 543.945, -1631.088, 19.959, 0.250);

    // Jandro4 wires
    SOLS_RemoveBuilding(playerid, 4984, 1880.7109, -2112.6328, 21.2578, 0.25);

    // Annyoing tree at SAN
    SOLS_RemoveBuilding(playerid, 713, 1807.5156, -1625.8828, 12.7031, 0.25);

    // PDS Skatepark Fences
    SOLS_RemoveBuilding(playerid, 1413, 2756.6355, -2090.0481, 11.15, 75.0);
    SOLS_RemoveBuilding(playerid, 1447, 2756.6355, -2090.0481, 11.15, 75.0);

    // Willowfield CB (roof unit)
    SOLS_RemoveBuilding(playerid, 1687, 2398.3906, -1910.9609, 21.2266, 0.25);

    // COORS MAP (East Beach skinheads)
    SOLS_RemoveBuilding(playerid, 714, 2833.79, -1228.34, 24.25, 30.0);

    // Mall
    SOLS_RemoveBuilding(playerid, 1280, 1721.7350, -1653.4364, 41.4488, 100.0);    
    SOLS_RemoveBuilding(playerid, 625, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 1216, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 620, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 643, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 642, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 641, 1721.7350, -1653.4364, 41.4488, 100.0);
    SOLS_RemoveBuilding(playerid, 4073, 1721.8750, -1643.0547, 12.7344, 100.0);
    SOLS_RemoveBuilding(playerid, 4074, 1722.0547, -1702.2891, 12.8125, 100.0);
    SOLS_RemoveBuilding(playerid, 4181, 1721.7500, -1657.9297, 30.1875, 100.0);
    SOLS_RemoveBuilding(playerid, 4216, 1722.7109, -1661.2109, 38.6250, 100.0);
    SOLS_RemoveBuilding(playerid, 1287, 1700.2266, -1721.5859, 13.0938, 100.0);
    SOLS_RemoveBuilding(playerid, 1288, 1700.2266, -1720.6484, 13.0938, 100.0);
    SOLS_RemoveBuilding(playerid, 1289, 1700.2266, -1719.5938, 13.0938, 100.0);
    SOLS_RemoveBuilding(playerid, 4141, 1721.7500, -1657.9297, 30.1875, 100.0);
    SOLS_RemoveBuilding(playerid, 1231, 1722.2891, -1703.2500, 15.1797, 100.0);
    SOLS_RemoveBuilding(playerid, 3987, 1722.0547, -1702.2891, 12.8125, 100.0);
    SOLS_RemoveBuilding(playerid, 1294, 1744.8750, -1706.2578, 17.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 4033, 1721.8750, -1643.0547, 12.7344, 100.0);
    SOLS_RemoveBuilding(playerid, 1537, 1725.4297, -1637.4375, 19.2109, 100.0);
    SOLS_RemoveBuilding(playerid, 1533, 1728.4453, -1637.4375, 19.2109, 100.0);
    SOLS_RemoveBuilding(playerid, 3743, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2756, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2759, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2757, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2758, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2761, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 2760, 1716.3906, -1618.9922, 16.2500, 100.0);
    SOLS_RemoveBuilding(playerid, 4034, 1720.5625, -1620.7266, 17.6484, 100.0);
    SOLS_RemoveBuilding(playerid, 14674, 1721.6328, -1655.1875, 24.3125,100.0);
    SOLS_RemoveBuilding(playerid, 14675, 1719.7500, -1655.7656, 30.1953,100.0);
    SOLS_RemoveBuilding(playerid, 2744, 1721.6172, -1655.6641, 21.6641, 100.0);
    SOLS_RemoveBuilding(playerid, 1283, 1690.2109, -1718.5781, 15.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1701.1484, -1753.2266, 12.3516, 0.25);


// * RANCHO
    //parkhill1

    SOLS_RemoveBuilding(playerid, 3627, 2396.8750, -2126.5000, 16.0469, 50.0);
    SOLS_RemoveBuilding(playerid, 3686, 2396.8750, -2126.5000, 16.0469, 50.0);
    SOLS_RemoveBuilding(playerid, 1412, 2400.0391, -2145.7109, 13.7500, 40.00);
    SOLS_RemoveBuilding(playerid, 5221, 2360.7188, -2117.0078, 16.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 3291, 2371.4922, -2114.9766, 13.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 3291, 2371.7500, -2135.5547, 13.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 5300, 2347.4141, -2109.8672, 12.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 3255, 2371.7500, -2135.5547, 13.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 5294, 2348.8750, -2119.9219, 24.8984, 0.25);
    SOLS_RemoveBuilding(playerid, 5299, 2347.4141, -2109.8672, 12.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 3255, 2371.4922, -2114.9766, 13.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 5192, 2360.7188, -2117.0078, 16.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 5370, 2390.1719, -2033.8203, 23.8281, 0.25);


    //parkhill2
    SOLS_RemoveBuilding(playerid, 712, 2329.3750, -2171.7266, 21.7188, 100.0);
    SOLS_RemoveBuilding(playerid, 5285, 2290.3047, -2170.4375, 16.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 5289, 2293.8047, -2172.7734, 11.7109, 0.25);
    SOLS_RemoveBuilding(playerid, 3295, 2290.4219, -2145.7656, 17.2031, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2241.2969, -2183.9766, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2226.3203, -2168.9922, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2226.3203, -2168.9922, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 2278.2266, -2227.4688, 13.7656, 0.25);
    SOLS_RemoveBuilding(playerid, 1447, 2273.9609, -2224.3594, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 2269.7656, -2221.2266, 13.7656, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2241.2969, -2183.9766, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 5290, 2281.7813, -2168.6094, 23.6016, 0.25);
    SOLS_RemoveBuilding(playerid, 5373, 2281.7813, -2168.6094, 23.6016, 0.25);
    SOLS_RemoveBuilding(playerid, 5275, 2293.8047, -2172.7734, 11.7109, 0.25);
    SOLS_RemoveBuilding(playerid, 5278, 2290.3047, -2170.4375, 16.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 5364, 2292.7500, -2176.2969, 14.4063, 0.25);
    SOLS_RemoveBuilding(playerid, 3286, 2290.4219, -2145.7656, 17.2031, 0.25);

    SOLS_RemoveBuilding(playerid, 1308, 2291.94, -2158.29, 9.92, 60.0);
    SOLS_RemoveBuilding(playerid, 1307, 2352.9922, -2125.9844, 12.3203, 40.0);
    SOLS_RemoveBuilding(playerid, 3594, 2308.3906, -2133.1484, 13.1641, 50.0);


    //factory
    SOLS_RemoveBuilding(playerid, 3747, 2184.68, -2260.66, 12.34, 90.0);
    SOLS_RemoveBuilding(playerid, 3744, 2184.68, -2260.66, 12.34, 90.0);

    SOLS_RemoveBuilding(playerid, 5123, 2195.0859, -2266.6172, 12.5625, 0.25);
    SOLS_RemoveBuilding(playerid, 5213, 2195.0859, -2266.6172, 12.5625, 0.25);
    SOLS_RemoveBuilding(playerid, 5214, 2193.5000, -2266.6172, 17.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 5215, 2151.7344, -2273.2969, 18.6563, 0.25);
    SOLS_RemoveBuilding(playerid, 3686, 2169.1172, -2276.5859, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 3686, 2195.0859, -2216.8438, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 3686, 2220.7813, -2261.0547, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 5287, 2235.9141, -2282.4609, 13.1875, 0.25);

    SOLS_RemoveBuilding(playerid, 5304, 2197.1875, -2325.5391, 27.5313, 0.25);
    SOLS_RemoveBuilding(playerid, 3289, 2140.4219, -2301.9688, 12.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 5305, 2198.8516, -2213.9219, 14.8828, 0.25);

    SOLS_RemoveBuilding(playerid, 3295, 2144.4297, -2307.9063, 24.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3296, 2152.5938, -2303.8203, 24.4375, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2179.9219, -2334.8516, 14.8125, 0.25);
    SOLS_RemoveBuilding(playerid, 5126, 2197.1875, -2325.5391, 27.5313, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2165.2969, -2317.5000, 14.8125, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2184.6250, -2308.3281, 17.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 3286, 2144.4297, -2307.9063, 24.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3287, 2152.5938, -2303.8203, 24.4375, 0.25);
    SOLS_RemoveBuilding(playerid, 3258, 2140.4219, -2301.9688, 12.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2202.8047, -2290.1016, 17.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2130.2891, -2290.0938, 16.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 3585, 2234.4297, -2287.3906, 14.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 3578, 2165.0703, -2288.9688, 13.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2193.2578, -2286.2891, 14.8125, 0.25);
    SOLS_RemoveBuilding(playerid, 3630, 2217.5859, -2284.6641, 15.2344, 0.25);
    SOLS_RemoveBuilding(playerid, 3585, 2231.8359, -2284.6406, 14.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 5277, 2235.9141, -2282.4609, 13.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 3627, 2169.1172, -2276.5859, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 5171, 2124.9453, -2275.4531, 20.1406, 0.25);
    SOLS_RemoveBuilding(playerid, 5131, 2151.7344, -2273.2969, 18.6563, 0.25);
    SOLS_RemoveBuilding(playerid, 3569, 2204.6328, -2274.4141, 14.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 3630, 2227.3828, -2274.7891, 15.2344, 0.25);

    SOLS_RemoveBuilding(playerid, 5129, 2148.7813, -2269.6406, 17.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 5130, 2139.8594, -2271.7813, 16.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 3631, 2140.0391, -2271.5391, 14.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 5268, 2143.3047, -2267.4531, 20.2969, 0.25);
    SOLS_RemoveBuilding(playerid, 3569, 2212.0938, -2267.0703, 14.9375, 0.25);

    SOLS_RemoveBuilding(playerid, 5127, 2193.5000, -2266.6172, 17.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 3631, 2149.1406, -2266.9063, 12.8750, 0.25);
    SOLS_RemoveBuilding(playerid, 5260, 2161.3438, -2264.9141, 14.0156, 0.25);
    SOLS_RemoveBuilding(playerid, 3631, 2161.8516, -2264.0938, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 3631, 2163.3750, -2262.6875, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 3627, 2220.7813, -2261.0547, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 3569, 2219.4219, -2259.5234, 14.8828, 0.25);
    SOLS_RemoveBuilding(playerid, 3631, 2142.3047, -2255.8984, 12.8750, 0.25);
    SOLS_RemoveBuilding(playerid, 5262, 2152.7109, -2256.7813, 15.2109, 0.25);

    SOLS_RemoveBuilding(playerid, 5261, 2152.2578, -2239.4609, 14.5000, 0.25);
    SOLS_RemoveBuilding(playerid, 5269, 2146.3750, -2248.7969, 14.6172, 0.25);
    SOLS_RemoveBuilding(playerid, 5132, 2163.2891, -2251.6094, 14.1406, 0.25);
    SOLS_RemoveBuilding(playerid, 5259, 2168.8438, -2246.7813, 13.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 3578, 2194.4766, -2242.8750, 13.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2217.2188, -2250.3594, 16.3672, 0.25);
    SOLS_RemoveBuilding(playerid, 3569, 2226.9688, -2252.1406, 14.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 3569, 2234.3906, -2244.8281, 14.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2183.1719, -2237.2734, 14.8125, 0.25);


    SOLS_RemoveBuilding(playerid, 3577, 2149.1406, -2266.9063, 12.8750, 150.0);

    SOLS_RemoveBuilding(playerid, 3578, 2235.1641, -2231.8516, 13.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2174.6406, -2215.6563, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 3627, 2195.0859, -2216.8438, 15.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 5244, 2198.8516, -2213.9219, 14.8828, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2193.0625, -2196.6406, 15.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2215.8047, -2199.2188, 16.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2207.8750, -2191.2500, 16.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2223.7422, -2207.1875, 16.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 3630, 2242.5156, -2289.0547, 15.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 3564, 2243.4766, -2278.0938, 14.1563, 0.25);

    SOLS_RemoveBuilding(playerid, 3585, 2246.4297, -2269.3672, 14.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 3630, 2261.6016, -2270.0313, 15.1953, 0.25);

    SOLS_RemoveBuilding(playerid, 3631, 2243.1250, -2258.4531, 14.2891, 0.25);

    SOLS_RemoveBuilding(playerid, 3564, 2262.2813, -2259.2891, 14.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 3585, 2252.7031, -2263.0859, 14.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 3576, 2253.5469, -2253.9375, 15.2422, 0.25);


    SOLS_RemoveBuilding(playerid, 1226, 2240.7813, -2240.8984, 16.3672, 0.25);

    SOLS_RemoveBuilding(playerid, 3633, 2153.7734, -2253.0859, 14.2031, 100.0);
    SOLS_RemoveBuilding(playerid, 3632, 2144.2969, -2258.1484, 13.9297, 100.0);

    //roads
    SOLS_RemoveBuilding(playerid, 4868, 2139.6094, -2292.4219, 15.3203, 0.25);
    SOLS_RemoveBuilding(playerid, 5045, 2139.6094, -2292.4219, 15.3203, 0.25);
    SOLS_RemoveBuilding(playerid, 5276, 2219.6016, -2200.4922, 12.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 5284, 2219.6016, -2200.4922, 12.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 5288, 2275.4063, -2095.2656, 12.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 5271, 2275.4063, -2095.2656, 12.5078, 0.25);
    //misc (lamps, etc)
    SOLS_RemoveBuilding(playerid, 1226, 2137.8438, -2232.1172, 16.2891, 0.25);
    SOLS_RemoveBuilding(playerid, 1374, 2266.8359, -2242.9219, 14.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1373, 2283.8125, -2243.4453, 15.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1374, 2284.4766, -2241.8516, 14.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1373, 2267.5000, -2241.3281, 15.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1373, 2259.8906, -2111.3359, 15.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1374, 2261.4766, -2112.0000, 14.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1373, 2262.0000, -2095.0234, 15.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1374, 2260.4063, -2094.3594, 14.1016, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2337.8203, -2053.3047, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2250.9766, -2119.0547, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2166.7031, -2203.3203, 16.2891, 0.25);

    // Idlewood (idlewoodghetto 1 & 2) removals:
    SOLS_RemoveBuilding(playerid, 955, 2060.1172, -1897.6406, 12.9297, 0.25);
    SOLS_RemoveBuilding(playerid, 5523, 2021.6563, -1810.7266, 18.6016, 0.25);
    SOLS_RemoveBuilding(playerid, 5525, 2029.5000, -1819.2734, 14.3359, 0.25);
    SOLS_RemoveBuilding(playerid, 5417, 2029.5000, -1819.2734, 14.3359, 0.25);
    SOLS_RemoveBuilding(playerid, 5411, 2021.6563, -1810.7266, 18.6016, 0.25);
    // Janissary El Corona
    // New Hades EC restore:
    SOLS_RemoveBuilding(playerid, 5015, 1964.6406, -2109.4219, 14.1094, 0.25);
    SOLS_RemoveBuilding(playerid, 4807, 1964.6406, -2109.4219, 14.1094, 0.25);
    SOLS_RemoveBuilding(playerid, 5198, 1983.5313, -2085.1172, 18.0781, 0.25);
    SOLS_RemoveBuilding(playerid, 5202, 2050.3594, -2045.9297, 20.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2051.0547, -2089.6094, 15.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2026.2500, -2093.3906, 15.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 3578, 2026.8359, -2099.4531, 13.3203, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2026.2500, -2093.3984, 15.0703, 0.25);
    SOLS_RemoveBuilding(playerid, 3578, 2050.5938, -2099.4609, 13.3203, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2051.0469, -2089.6016, 15.0703, 0.25);
    SOLS_RemoveBuilding(playerid, 5189, 1983.5313, -2085.1172, 18.0781, 0.25);
    SOLS_RemoveBuilding(playerid, 5138, 2050.3594, -2045.9297, 20.8672, 0.25);
    // Janissary additions EC
    // Reyo Market
    /*
    SOLS_RemoveBuilding(playerid, 5959, 1111.9063, -1241.6875, 18.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 5961, 1140.1797, -1207.2578, 18.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 3685, 1183.6250, -1230.2344, 20.5703, 0.25);
    SOLS_RemoveBuilding(playerid, 3685, 1183.6250, -1257.8750, 17.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 6009, 1183.6953, -1241.3594, 16.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 727, 1203.9531, -1265.7891, 12.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 727, 1165.6172, -1216.8828, 16.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 1266, 1104.5156, -1269.3750, 23.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 1260, 1104.5156, -1269.3750, 23.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1163.4453, -1267.3672, 13.4141, 0.25);
    SOLS_RemoveBuilding(playerid, 5771, 1111.9063, -1241.6875, 18.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 5821, 1120.3438, -1248.9375, 20.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 5855, 1095.6797, -1212.7813, 18.2891, 0.25);
    SOLS_RemoveBuilding(playerid, 5823, 1140.1797, -1207.2578, 18.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1165.9297, -1250.3516, 13.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 3684, 1183.6250, -1257.8750, 17.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 3684, 1183.6250, -1230.2344, 20.5703, 0.25);
    SOLS_RemoveBuilding(playerid, 6006, 1183.6953, -1241.3594, 16.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1203.1953, -1257.5625, 14.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1202.4844, -1236.2891, 16.3672, 0.25);
    */
    // Janice RMB #2

    SOLS_RemoveBuilding(playerid, 1460, 2630.9141, -1973.0313, 13.3438, 10.0);
    SOLS_RemoveBuilding(playerid, 3638, 2666.4375, -1955.7031, 15.7344, 25.0);
    SOLS_RemoveBuilding(playerid, 3562, 2248.36, -1437.97, 24.53, 50.0);
    SOLS_RemoveBuilding(playerid, 3582, 2248.36, -1437.97, 24.53, 50.0);


    SOLS_RemoveBuilding(playerid, 5682, 2241.4297, -1433.6719, 31.2813, 0.25);
    SOLS_RemoveBuilding(playerid, 5151, 2704.1953, -1966.6875, 13.7578, 0.25);
    SOLS_RemoveBuilding(playerid, 4827, 2704.1953, -1966.6875, 13.7578, 0.25);
    //SOLS_RemoveBuilding(playerid, 5185, 2143.9141, -2166.9219, 13.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 3244, 2632.3906, -1954.8203, 12.7578, 0.25);
    SOLS_RemoveBuilding(playerid, 5151, 2674.1016, -1990.7891, 15.1875, 0.25);
    //SOLS_RemoveBuilding(playerid, 5197, 2143.9141, -2166.9219, 13.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 5241, 2674.1016, -1990.7891, 15.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 708, 2639.2734, -1976.3281, 12.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 5314, 2085.1797, -2132.7031, 12.4141, 0.25);
    SOLS_RemoveBuilding(playerid, 5315, 2085.1797, -2132.7031, 12.4141, 0.25);
    SOLS_RemoveBuilding(playerid, 1524, 2704.1953, -1966.6875, 13.7578, 0.25);

    SOLS_RemoveBuilding(playerid, 5649, 2252.0000, -1434.1406, 23.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 713, 2275.3906, -1438.6641, 22.5547, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2260.8672, -1413.1641, 26.3906, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2235.6953, -1413.1641, 26.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2229.0234, -1411.6406, 22.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 1264, 2224.9844, -1408.9063, 23.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2265.6172, -1410.3359, 21.7734, 0.25);
    SOLS_RemoveBuilding(playerid, 1221, 2253.2188, -1409.8906, 23.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 1264, 2224.1250, -1408.8359, 23.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 1221, 2226.8516, -1404.7422, 23.6328, 0.25);
    SOLS_RemoveBuilding(playerid, 1220, 2222.9609, -1469.7422, 23.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1230, 2223.6328, -1468.7500, 23.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1220, 2225.1328, -1471.7266, 23.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1221, 2225.0938, -1471.1328, 23.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 1224, 2225.6797, -1468.6172, 23.4297, 0.25);
    SOLS_RemoveBuilding(playerid, 1230, 2225.7969, -1470.7266, 23.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1221, 2225.8516, -1466.6484, 23.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 3582, 2232.3984, -1464.7969, 25.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2241.8906, -1458.9297, 22.9609, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2228.6094, -1454.4219, 26.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 1221, 2251.2891, -1461.8281, 23.6328, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2253.7813, -1454.4219, 26.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 1220, 2256.6563, -1456.8984, 22.8594, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2227.2031, -1444.5000, 22.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 5428, 2252.0000, -1434.1406, 23.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2226.5156, -1426.7656, 23.1172, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2243.5703, -1423.6094, 22.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2256.4063, -1444.5078, 23.1016, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2266.0859, -1442.0703, 26.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3593, 2261.7734, -1441.1016, 23.5000, 0.25);
    //SOLS_RemoveBuilding(playerid, 1297, 2267.3672, -1425.8750, 26.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3593, 2265.0781, -1424.4766, 23.5000, 0.25);
    SOLS_RemoveBuilding(playerid, 1297, 2273.6406, -1434.1484, 26.3906, 0.25);
    //  Janichar V3
    // SOLS_RemoveBuilding(playerid, 1297, 2235.6953, -1413.1641, 26.3906, 0.25);
    // SOLS_RemoveBuilding(playerid, 1297, 2253.7813, -1454.4219, 26.3906, 0.25);
    // SOLS_RemoveBuilding(playerid, 1297, 2266.0859, -1442.0703, 26.3906, 0.25);
    // SOLS_RemoveBuilding(playerid, 5185, 2143.9141, -2166.9219, 13.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2223.0938, -1410.1172, 23.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1307, 2272.6797, -1459.1875, 22.0547, 0.25);
    // Reyo
    SOLS_RemoveBuilding(playerid, 3687, 2135.7422, -2186.4453, 15.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 3687, 2162.8516, -2159.7500, 15.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 3687, 2150.1953, -2172.3594, 15.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 3622, 2135.7422, -2186.4453, 15.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 3622, 2150.1953, -2172.3594, 15.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 3622, 2162.8516, -2159.7500, 15.6719, 0.25);
    // Reyo 2
    SOLS_RemoveBuilding(playerid, 3688, 2182.5547, -2042.5859, 17.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 3755, 2228.1719, -2063.7969, 17.7031, 0.25);
    SOLS_RemoveBuilding(playerid, 3756, 2228.1719, -2063.7969, 17.7031, 0.25);
    SOLS_RemoveBuilding(playerid, 3621, 2182.5547, -2042.5859, 17.9375, 0.25);
    // Janice 21/12/19
    SOLS_RemoveBuilding(playerid, 1308, 2185.4766, -1211.3594, 22.9531, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2190.3359, -1203.5000, 23.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2219.1563, -1211.4688, 23.0391, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2209.3125, -1207.0391, 23.0000, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2233.3594, -1205.5234, 22.0938, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2251.3516, -1211.3047, 23.0391, 0.25);
    SOLS_RemoveBuilding(playerid, 1216, 2257.6563, -1211.1875, 23.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1216, 2259.2031, -1211.2109, 23.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2257.5547, -1197.5156, 22.0938, 0.25);
    
    // Dignity Gas Station Fences
    // RemoveBuildingForPlayer(playerid, 1412, 1933.77, -1808.96, 12.52, 50.0);

    // Reyo Unity building next to idlegas
    // SOLS_RemoveBuilding(playerid, 4976, 1931.0000, -1871.3906, 15.8438, 0.25);
    // SOLS_RemoveBuilding(playerid, 4848, 1931.0000, -1871.3906, 15.8438, 0.25);
    // SOLS_RemoveBuilding(playerid, 1226, 1931.8750, -1863.4609, 16.3203, 0.25);
    // SOLS_RemoveBuilding(playerid, 1226, 1915.7422, -1863.4609, 16.3203, 0.25);

    // Fences at unity building next to idlegas (alley)
    // SOLS_RemoveBuilding(playerid, 1412, 1914.9297, -1879.7344, 13.6797, 20.0);
    // SOLS_RemoveBuilding(playerid, 1413, 1914.9297, -1879.7344, 13.6797, 20.0);

    // Janice new
    //SOLS_RemoveBuilding(playerid, 5041, 1845.7891, -1855.6484, 15.9844, 0.25);
    //SOLS_RemoveBuilding(playerid, 5059, 1841.1094, -1856.0469, 14.9375, 0.25);
    //SOLS_RemoveBuilding(playerid, 1560, 1834.1797, -1844.0781, 12.5703, 0.25);
    //SOLS_RemoveBuilding(playerid, 1561, 1834.1797, -1841.0625, 12.5703, 0.25);
    //SOLS_RemoveBuilding(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 0.25);
    //SOLS_RemoveBuilding(playerid, 5040, 1845.7891, -1855.6484, 15.9844, 0.25);
    //SOLS_RemoveBuilding(playerid, 5042, 1850.5703, -1855.6797, 14.3672, 0.25);
    SOLS_RemoveBuilding(playerid, 5224, 2385.1875, -1906.5156, 18.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 5168, 2385.1875, -1906.5156, 18.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 2396.3047, -1899.6172, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 2399.3281, -1899.6172, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 2070.2109, -1794.5938, 12.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 2068.1641, -1780.6094, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 2105.9219, -1807.2500, 12.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 1522, 1038.9453, -1341.1484, 12.7188, 0.25);

    SOLS_RemoveBuilding(playerid, 5526, 2049.5781, -1781.6797, 18.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 5530, 2112.9375, -1797.0938, 19.3359, 0.25);
    SOLS_RemoveBuilding(playerid, 5521, 2049.5781, -1781.6797, 18.3281, 0.25);

    SOLS_RemoveBuilding(playerid, 1533, 2419.3047, -1510.4844, 22.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 17534, 2402.3125, -1503.5938, 28.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 1537, 2419.3047, -1507.4688, 22.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 5975, 1014.0234, -1361.4609, 20.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 5732, 1014.0234, -1361.4609, 20.3516, 0.25);

    // Duro IB
    SOLS_RemoveBuilding(playerid, 3563, 2150.0391, -1281.1250, 25.5938, 0.25);
    SOLS_RemoveBuilding(playerid, 3555, 2150.0391, -1281.1250, 25.5938, 0.25);
    SOLS_RemoveBuilding(playerid, 1408, 2157.4141, -1277.4063, 23.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 1408, 2157.1016, -1282.8516, 23.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 1408, 2156.7891, -1288.2969, 23.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 1408, 2157.6797, -1271.9688, 23.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 5635, 2182.2891, -1324.7500, 28.6016, 0.25);
    // Janichar Jefferson Park
    SOLS_RemoveBuilding(playerid, 3563, 2184.9766, -1359.7891, 27.2266, 0.25);
    SOLS_RemoveBuilding(playerid, 3562, 2202.5781, -1359.1328, 27.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 5584, 2218.8906, -1342.5547, 25.2422, 0.25);
    SOLS_RemoveBuilding(playerid, 1527, 2233.9531, -1367.6172, 24.5313, 0.25);
    SOLS_RemoveBuilding(playerid, 714, 2217.0234, -1320.8047, 22.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 1264, 2177.0938, -1345.1875, 23.4219, 0.25);
    SOLS_RemoveBuilding(playerid, 1264, 2177.9844, -1345.1719, 23.4219, 0.25);
    SOLS_RemoveBuilding(playerid, 3555, 2184.9766, -1359.7891, 27.2266, 0.25);
    SOLS_RemoveBuilding(playerid, 3582, 2202.5781, -1359.1328, 27.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2226.8750, -1371.2109, 22.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2233.3359, -1371.2109, 22.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2258.1484, -1371.2109, 22.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 5426, 2218.8906, -1342.5547, 25.2422, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2258.1484, -1352.6328, 22.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 5654, 2263.5234, -1312.6250, 37.0781, 0.25);
    // January 19
    SOLS_RemoveBuilding(playerid, 4982, 1892.5391, -2012.8281, 21.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 5086, 1892.5391, -2012.8281, 21.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 4981, 1898.3984, -1913.4063, 20.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 5084, 1898.3984, -1913.4063, 20.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 2192.2578, -2140.0234, 21.9219, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 2173.2109, -2123.3516, 21.9531, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 2152.1016, -2109.5547, 22.0156, 0.25);
    SOLS_RemoveBuilding(playerid, 3696, 2336.9219, -1211.4219, 31.4297, 0.25);
    SOLS_RemoveBuilding(playerid, 3697, 2336.9219, -1211.4219, 31.4297, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1879.9922, -1879.8906, 13.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1885.2578, -1879.8984, 13.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1864.1797, -1879.6641, 13.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1869.4609, -1879.6641, 13.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1874.7344, -1879.6641, 13.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1890.5234, -1879.6641, 13.6797, 0.25);

    // ASGH removal
    /*
    SOLS_RemoveBuilding(playerid, 5930, 1134.2500, -1338.0781, 23.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 5708, 1134.2500, -1338.0781, 23.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 617, 1178.6016, -1332.0703, 12.8906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1184.0078, -1353.5000, 12.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1184.0078, -1343.2656, 12.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 618, 1177.7344, -1315.6641, 13.2969, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1184.8125, -1292.9141, 12.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1184.8125, -1303.1484, 12.5781, 0.25);
    */
   
    // Pizza Stack
    SOLS_RemoveBuilding(playerid, 1432, 2104.0156, -1812.4219, 12.6719, 50.0);
    SOLS_RemoveBuilding(playerid, 1408, 2099.8516, -1813.9063, 13.1016, 50.0);
    SOLS_RemoveBuilding(playerid, 5418, 2112.9375, -1797.0938, 19.3359, 0.25);

    // Janice Removebuildings
    SOLS_RemoveBuilding(playerid, 1411, 2208.0625, -2142.2266, 14.1328, 10.0);
    SOLS_RemoveBuilding(playerid, 1412, 2166.6406, -2076.8672, 13.8203, 70.0);
    SOLS_RemoveBuilding(playerid, 3683, 2768.0469, -2104.4844, 17.7891, 50.0);
    SOLS_RemoveBuilding(playerid, 3636, 2768.0469, -2104.4844, 17.7891, 50.0);
    //SOLS_RemoveBuilding(playerid, 1308,  1972.95, -2069.48, 12.53, 20.0);
    SOLS_RemoveBuilding(playerid, 5239, 2758.5391, -2104.8984, 18.2813, 0.25);
    SOLS_RemoveBuilding(playerid, 5113, 2758.5391, -2104.8984, 18.2813, 0.25);

    // Bahamas
    //SOLS_RemoveBuilding(playerid, 5597, 2011.4688, -1300.8984, 28.6953, 0.25);
    //SOLS_RemoveBuilding(playerid, 5461, 2011.4688, -1300.8984, 28.6953, 0.25);

    // FYB Crack Den
    //SOLS_RemoveBuilding(playerid, 3662, 2164.9375, -1666.3047, 17.5547, 0.25);
    //SOLS_RemoveBuilding(playerid, 1501, 2165.1094, -1671.4531, 14.0703, 0.25);
    //SOLS_RemoveBuilding(playerid, 3661, 2164.9375, -1666.3047, 17.5547, 0.25);
    
    // Sweet Enex (Ryhes)
    SOLS_RemoveBuilding(playerid, 17771, 2529.8906, -1677.6641, 16.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 17698, 2529.8906, -1677.6641, 16.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 17926, 2528.5547, -1679.4375, 16.2813, 0.25);
    SOLS_RemoveBuilding(playerid, 1498, 2523.6953, -1678.5938, 14.4844, 0.25);
    SOLS_RemoveBuilding(playerid, 17566, 2520.7344, -1673.8359, 15.5469, 0.25);
    // Commerce Billboard (Casino)
    SOLS_RemoveBuilding(playerid, 1261, 1638.5859, -1721.4766, 27.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
    SOLS_RemoveBuilding(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
    SOLS_RemoveBuilding(playerid, 1267, 1638.5859, -1721.4766, 27.9922, 0.25);
    // Seville Skatepark Tower
    SOLS_RemoveBuilding(playerid, 3244, 2758.4297, -2124.8594, 10.6172, 0.25);
    SOLS_RemoveBuilding(playerid, 3244, 2632.3906, -2033.4375, 12.7578, 0.25);
    // Ryhes Little Mexico
    SOLS_RemoveBuilding(playerid, 4124, 1653.4844, -1826.6406, 23.9219, 0.25); //LOD
    SOLS_RemoveBuilding(playerid, 4212, 1661.8047, -1826.7188, 24.8281, 0.25); //lanitewin1_LAN
    SOLS_RemoveBuilding(playerid, 4123, 1653.4844, -1826.6406, 23.9219, 0.25); //cityhallblock1_LAn
    // Ryhes Jewelry Enex East Beach
    SOLS_RemoveBuilding(playerid, 17584, 2846.0469, -1453.3281, 24.7969, 0.25); //LOD BeachBlok3_LAe2 (EBJewelry)
    SOLS_RemoveBuilding(playerid, 17553, 2846.0469, -1453.3281, 24.7969, 0.25); //BeachBlok3_LAe2 (EBJewelry)
    // Reyo / Ryhes Mulholland Jewelry Enex
    //SOLS_RemoveBuilding(playerid, 4686, 1685.7969, -1186.3047, 33.3359, 0.25); //LOD
    //SOLS_RemoveBuilding(playerid, 4682, 1685.7969, -1186.3047, 33.3359, 0.25);
    // Idlegas Enex Ryhes
    SOLS_RemoveBuilding(playerid, 5535, 1918.8516, -1776.3281, 16.9766, 0.25); //LOD laepetrol1a
    SOLS_RemoveBuilding(playerid, 5409, 1918.8516, -1776.3281, 16.9766, 0.25); //laepetrol1a (IDLEGAS)
    // Ganton 24.7 ENEX Ryhes
    SOLS_RemoveBuilding(playerid, 17757, 2450.8750, -1757.3984, 16.0000, 0.25); //LOD market2_lae
    SOLS_RemoveBuilding(playerid, 17519, 2450.8750, -1757.3984, 16.0000, 0.25); //market2_lae (ganton24/7)
    // Unity Road (ryhes/unity & ryhes/roadrage)
    // SOLS_RemoveBuilding(playerid, 4161, 1686.6250, -1806.4297, 12.4609, 0.25); //LOD
    // SOLS_RemoveBuilding(playerid, 4160, 1686.6250, -1806.4297, 12.4609, 0.25); //Roads19_LAn
    // SOLS_RemoveBuilding(playerid, 4961, 1745.2031, -1882.8516, 26.1406, 0.25); //LOD
    // SOLS_RemoveBuilding(playerid, 4821, 1745.2031, -1882.8516, 26.1406, 0.25); //BTOLAND2_LAS
    // SOLS_RemoveBuilding(playerid, 5024, 1748.8438, -1883.0313, 14.1875, 0.25); //snpedtee_LAS
    // KACC Factory for Parts
    SOLS_RemoveBuilding(playerid, 985, 2497.4063, 2777.0703, 11.5313, 0.25);
    SOLS_RemoveBuilding(playerid, 986, 2497.4063, 2769.1094, 11.5313, 0.25);
    // Janichar Alhambra
    SOLS_RemoveBuilding(playerid, 5504, 2046.0000, -1613.0000, 12.0000, 0.25);
    SOLS_RemoveBuilding(playerid, 5515, 1931.6484, -1577.5703, 12.3594, 0.25);
    SOLS_RemoveBuilding(playerid, 5516, 1977.8359, -1569.0469, 19.0703, 0.25);
    SOLS_RemoveBuilding(playerid, 5534, 1927.7031, -1754.3125, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 5536, 1866.3281, -1789.7813, 20.9453, 0.25);
    SOLS_RemoveBuilding(playerid, 5541, 1822.8906, -1725.2578, 12.4688, 0.25);
    SOLS_RemoveBuilding(playerid, 5542, 1884.6641, -1613.4219, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 5543, 1941.6563, -1682.5703, 12.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 5544, 1873.7422, -1682.4766, 34.7969, 0.25);
    SOLS_RemoveBuilding(playerid, 5545, 1971.6563, -1682.3125, 13.7422, 0.25);
    SOLS_RemoveBuilding(playerid, 5548, 2046.0000, -1613.0000, 12.0000, 0.25);
    SOLS_RemoveBuilding(playerid, 5633, 2089.3594, -1643.9297, 18.2188, 0.25);
    SOLS_RemoveBuilding(playerid, 5634, 1931.3125, -1574.8438, 16.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 1524, 1837.6641, -1640.3828, 13.7578, 0.25);
    SOLS_RemoveBuilding(playerid, 1524, 1959.3984, -1577.7578, 13.7578, 0.25);
    SOLS_RemoveBuilding(playerid, 3772, 1975.5078, -1719.0391, 19.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 3773, 1971.2734, -1701.7734, 17.8828, 0.25);
    SOLS_RemoveBuilding(playerid, 3774, 1974.9453, -1667.4844, 17.6563, 0.25);
    SOLS_RemoveBuilding(playerid, 3772, 1976.1250, -1682.9609, 19.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 3773, 1971.3516, -1651.2969, 17.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 3774, 1972.3906, -1630.0000, 17.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 5397, 1866.3281, -1789.7813, 20.9453, 0.25);
    SOLS_RemoveBuilding(playerid, 5503, 1927.7031, -1754.3125, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1867.5547, -1748.2031, 16.3594, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1855.7188, -1741.5391, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1879.5078, -1741.4844, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1908.2188, -1741.4844, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 5502, 1822.8906, -1725.2578, 12.4688, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 1929.5781, -1736.9063, 21.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1931.0391, -1726.3281, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1945.7656, -1716.3594, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1958.3672, -1736.5547, 14.4844, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1825.9297, -1697.5625, 16.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1832.3828, -1694.3125, 9.7188, 0.25);
    SOLS_RemoveBuilding(playerid, 1537, 1837.4375, -1683.9688, 12.3047, 0.25);
    SOLS_RemoveBuilding(playerid, 1533, 1837.4375, -1683.9531, 12.3047, 0.25);
    SOLS_RemoveBuilding(playerid, 1537, 1837.4375, -1686.9844, 12.3125, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1825.8516, -1667.0781, 16.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1832.8984, -1670.7656, 9.7188, 0.25);
    SOLS_RemoveBuilding(playerid, 1533, 1837.4375, -1677.9219, 12.2969, 0.25);
    SOLS_RemoveBuilding(playerid, 1537, 1837.4375, -1680.9531, 12.2969, 0.25);
    SOLS_RemoveBuilding(playerid, 1533, 1837.4375, -1680.9375, 12.2969, 0.25);
    SOLS_RemoveBuilding(playerid, 5408, 1873.7422, -1682.4766, 34.7969, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1931.0391, -1702.2891, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 1929.5781, -1694.4609, 21.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1931.0391, -1667.0313, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1937.5547, -1669.8906, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 5441, 1941.6563, -1682.5703, 12.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1979.4219, -1748.1641, 16.3984, 0.25);
    //SOLS_RemoveBuilding(playerid, 1308, 1978.8594, -1742.5703, 12.7031, 0.25);
    SOLS_RemoveBuilding(playerid, 3580, 1975.5078, -1719.0391, 19.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1988.7656, -1702.0469, 15.0156, 0.25);
    SOLS_RemoveBuilding(playerid, 3616, 1971.2734, -1701.7734, 17.8828, 0.25);
    SOLS_RemoveBuilding(playerid, 3580, 1976.1250, -1682.9609, 19.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 5412, 1971.6563, -1682.3125, 13.7422, 0.25);
    SOLS_RemoveBuilding(playerid, 3617, 1974.9453, -1667.4844, 17.6563, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1931.0391, -1637.8984, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1945.7656, -1635.7734, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1855.7188, -1623.2813, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1879.5078, -1623.1016, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 1891.9688, -1622.0000, 12.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1908.2188, -1622.9844, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 712, 1929.5781, -1627.6250, 21.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1883.8203, -1616.4297, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 5501, 1884.6641, -1613.4219, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1908.2813, -1608.1172, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 1943.8672, -1602.8047, 12.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 5474, 1931.6484, -1577.5703, 12.3594, 0.25);
    SOLS_RemoveBuilding(playerid, 5630, 1928.4922, -1575.9688, 20.5547, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1955.3047, -1649.8828, 15.0625, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1986.5938, -1650.9219, 14.6641, 0.25);
    SOLS_RemoveBuilding(playerid, 3616, 1971.3516, -1651.2969, 17.9063, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1955.0156, -1632.9219, 14.9688, 0.25);
    SOLS_RemoveBuilding(playerid, 3617, 1972.3906, -1630.0000, 17.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 1951.5391, -1616.5078, 12.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1954.3594, -1603.6406, 12.5000, 0.25);
    SOLS_RemoveBuilding(playerid, 645, 1976.1719, -1600.1797, 12.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 5475, 1977.8359, -1569.0469, 19.0703, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 1979.7734, -1614.9375, 12.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1987.1172, -1618.2578, 12.5000, 0.25);
    // START Alhambra additional removals
    SOLS_RemoveBuilding(playerid, 5517, 1883.5234, -1576.4453, 20.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 740, 1887.1953, -1565.8984, 9.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 740, 1863.3125, -1568.6484, 11.7734, 0.25);
    SOLS_RemoveBuilding(playerid, 714, 2007.6094, -1556.6563, 12.5938, 0.25);
    SOLS_RemoveBuilding(playerid, 5476, 1883.5234, -1576.4453, 20.1953, 0.25);
    SOLS_RemoveBuilding(playerid, 1307, 1931.7422, -1569.8828, 12.6641, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1942.5625, -1599.2969, 12.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 1307, 1983.3359, -1557.6797, 12.6641, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2021.3359, -1599.2969, 12.9922, 0.25);
    // END Alhambra additional removals
    // Janichar ELS vagos carwash
    SOLS_RemoveBuilding(playerid, 17738, 2459.3594, -1486.1250, 34.1641, 0.25);
    SOLS_RemoveBuilding(playerid, 17855, 2490.9063, -1474.3438, 27.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 17856, 2492.3203, -1484.8047, 28.2656, 0.25);
    SOLS_RemoveBuilding(playerid, 17852, 2490.9063, -1474.3438, 27.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 17853, 2492.3203, -1484.8047, 28.2656, 0.25);
    SOLS_RemoveBuilding(playerid, 17537, 2459.3594, -1486.1250, 34.1641, 0.25);
    //SOLS_RemoveBuilding(playerid, 17860, 2485.0313, -1463.8984, 25.7578, 0.25);
    //START Ryhes EC HILL El Pecado //
    SOLS_RemoveBuilding(playerid, 4961, 1745.2031, -1882.8516, 26.1406, 0.25); //unity n that
    SOLS_RemoveBuilding(playerid, 4962, 1669.6406, -1922.1797, 16.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 4963, 1739.3047, -1951.9531, 12.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 4964, 1722.7500, -2014.6328, 16.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 4965, 1734.3984, -2019.7031, 14.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 5033, 1745.2031, -1882.8516, 26.1406, 0.25);
    SOLS_RemoveBuilding(playerid, 5055, 1745.2031, -1882.8516, 26.1406, 0.25);
    SOLS_RemoveBuilding(playerid, 5067, 1701.3906, -1954.1328, 10.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 1261, 1680.2813, -1917.7891, 24.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 1261, 1680.6328, -2015.9688, 25.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 1268, 1683.2188, -1954.7734, 23.9844, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1687.3594, -2076.5703, 18.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 4873, 1734.3984, -2019.7031, 14.3438, 0.25);
    SOLS_RemoveBuilding(playerid, 4860, 1722.7500, -2014.6328, 16.5078, 0.25);
    SOLS_RemoveBuilding(playerid, 1267, 1680.6328, -2015.9688, 25.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1781.2031, -2076.5703, 18.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 3573, 1798.6484, -2057.9141, 14.9844, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1808.8828, -2016.6094, 9.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1781.2031, -2000.4297, 18.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 1259, 1683.2188, -1954.7734, 23.9844, 0.25);
    SOLS_RemoveBuilding(playerid, 4891, 1681.1641, -1966.9922, 31.0859, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1698.1797, -1992.0391, 18.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 4818, 1669.6406, -1922.1797, 16.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1687.4375, -1923.4609, 11.5625, 0.25);
    SOLS_RemoveBuilding(playerid, 1267, 1680.2813, -1917.7891, 24.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1687.4375, -1903.4766, 11.5625, 0.25);
    SOLS_RemoveBuilding(playerid, 4881, 1701.3906, -1954.1328, 10.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1725.3906, -1927.0000, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 1280, 1714.9609, -1909.6328, 12.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 1280, 1714.9609, -1914.2969, 12.9375, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1725.3906, -1897.2266, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 955, 1729.7891, -1943.0469, 12.9453, 0.25);
    SOLS_RemoveBuilding(playerid, 4817, 1739.3047, -1951.9531, 12.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 4853, 1736.9766, -1960.6563, 15.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1736.2734, -1972.5000, 18.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1727.1953, -1930.8984, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 1280, 1725.9063, -1923.5000, 12.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1727.1953, -1908.0938, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1727.1953, -1916.3047, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 1280, 1725.9063, -1908.1797, 12.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1687.4375, -1881.0078, 11.5625, 0.25);
    SOLS_RemoveBuilding(playerid, 634, 1712.9297, -1868.2109, 12.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 634, 1721.0234, -1868.2109, 12.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1727.1953, -1893.1563, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 1280, 1725.9063, -1893.5000, 12.9609, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1724.8750, -1859.5391, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1703.4688, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1710.8359, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1714.9766, -1841.8516, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1710.8359, -1833.0547, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1703.4688, -1833.0547, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1704.7422, -1829.7969, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1721.1563, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1731.4766, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1741.7969, -1833.0547, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1731.4766, -1833.0547, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1721.1563, -1833.0547, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 1723.9297, -1829.7969, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1732.6719, -1830.0781, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 963, 1747.0391, -1942.6641, 13.6094, 0.25);
    SOLS_RemoveBuilding(playerid, 962, 1757.1484, -1942.6563, 13.6094, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1792.7500, -1974.5547, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1794.5938, -1980.7500, 9.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1774.7578, -1931.3125, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1808.8828, -1985.3359, 9.6719, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1806.4297, -1931.6016, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 4821, 1745.2031, -1882.8516, 26.1406, 0.25);
    SOLS_RemoveBuilding(playerid, 5024, 1748.8438, -1883.0313, 14.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 5083, 1748.8438, -1883.0313, 14.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1774.7578, -1901.5391, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1806.4297, -1901.8281, 16.3750, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1755.8203, -1859.5391, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1808.1250, -1859.5391, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1783.6719, -1859.5391, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1747.1875, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1742.5547, -1835.0625, 16.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1762.8281, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1778.4766, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1794.1172, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 1809.7656, -1846.7109, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 708, 1837.6406, -1968.3438, 12.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 4966, 1868.9531, -2003.6563, 13.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 4968, 1823.0078, -2087.1719, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 4970, 1880.3359, -2001.9219, 12.5703, 0.25);
    SOLS_RemoveBuilding(playerid, 4971, 1815.4531, -1958.4609, 12.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 4974, 1899.1563, -1936.3359, 14.2656, 0.25);
    SOLS_RemoveBuilding(playerid, 3667, 1826.6016, -1989.6094, 15.2109, 0.25);
    SOLS_RemoveBuilding(playerid, 4837, 1823.0078, -2087.1719, 12.4609, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1818.7188, -2017.6094, 16.2734, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1822.9609, -2015.9063, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3588, 1826.6016, -1989.6094, 15.2109, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1810.6797, -1944.6406, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 4819, 1815.4531, -1958.4609, 12.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1817.1797, -1944.6406, 11.4453, 0.25);
    SOLS_RemoveBuilding(playerid, 671, 1835.0078, -2015.3594, 12.6406, 0.25);
    SOLS_RemoveBuilding(playerid, 4806, 1880.3359, -2001.9219, 12.5703, 0.25);
    SOLS_RemoveBuilding(playerid, 4859, 1868.9531, -2003.6563, 13.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 4895, 1899.1563, -1936.3359, 14.2656, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1655.4453, -2026.8984, 27.5000, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1661.1641, -1970.6953, 28.6406, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 1644.7891, -1909.1172, 29.6875, 0.25);
    //forbanna hælvettes faenskap
    //SOLS_RemoveBuilding(playerid, -1, 1828.1111, -1979.6530, 13.6167, 1); //EC door road
    //SOLS_RemoveBuilding(playerid, -1, 1832.8406, -1995.0116, 13.5547, 1); //EC door road
    //SOLS_RemoveBuilding(playerid, -1, 1820.2477, -1994.2225, 13.5731, 1); //EC door road
    SOLS_RemoveBuilding(playerid, 1413, 1810.8281, -1971.3594, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1816.1094, -1971.3594, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1821.3828, -1971.3594, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1826.6406, -1971.5859, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1831.9063, -1971.5938, 13.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1818.4688, -1935.1875, 16.2109, 0.25);
    //END Ryhes EC HILL El Pecado //
    // Greco 28/07
    //SOLS_RemoveBuilding(playerid, 17763, 2572.1250, -1472.7031, 34.9609, 0.25);
    //SOLS_RemoveBuilding(playerid, 17536, 2572.1250, -1472.7031, 34.9609, 0.25);
    // Janichar Update 3! (New Unity Station, Ganton Gym ENEX, Hyde Park Redone)
    SOLS_RemoveBuilding(playerid, 4025, 1777.8359, -1773.9063, 12.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 4070, 1719.7422, -1770.7813, 23.4297, 0.25);
    SOLS_RemoveBuilding(playerid, 4071, 1722.5000, -1775.3984, 14.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 4072, 1777.4375, -1782.3047, 12.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 4215, 1777.5547, -1775.0391, 36.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 3983, 1722.5000, -1775.3984, 14.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 3986, 1719.7422, -1770.7813, 23.4297, 0.25);
    SOLS_RemoveBuilding(playerid, 647, 1791.1797, -1816.6328, 14.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1788.5078, -1816.5703, 13.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 647, 1796.9609, -1817.3906, 14.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 1801.8828, -1817.3047, 13.3516, 0.25);
    SOLS_RemoveBuilding(playerid, 4012, 1777.4375, -1782.3047, 12.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 4019, 1777.8359, -1773.9063, 12.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 4849, 1892.3359, -2109.5078, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 4969, 1932.4297, -2123.4063, 15.9453, 0.25);
    SOLS_RemoveBuilding(playerid, 5018, 1892.3359, -2109.5078, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 3670, 1759.9375, -2136.1953, 15.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 1531, 1936.8828, -2134.9063, 14.2188, 0.25);
    SOLS_RemoveBuilding(playerid, 1261, 1935.1797, -2140.1094, 19.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1921.0156, -2153.3516, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1921.0156, -2148.0703, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 3635, 1759.9375, -2136.1953, 15.1719, 0.25);
    //SOLS_RemoveBuilding(playerid, 4984, 1880.7109, -2112.6328, 21.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 5087, 1880.7109, -2112.6328, 21.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1921.0156, -2137.5078, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1921.0156, -2142.7891, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1921.0156, -2121.2500, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1921.0156, -2126.5313, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1372, 1920.0547, -2122.4141, 12.6875, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1921.0156, -2115.9766, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 1413, 1921.0156, -2110.6953, 13.7266, 0.25);
    SOLS_RemoveBuilding(playerid, 5017, 1932.4297, -2123.4063, 15.9453, 0.25);
    SOLS_RemoveBuilding(playerid, 1267, 1935.1797, -2140.1094, 19.1875, 0.25);
    SOLS_RemoveBuilding(playerid, 1532, 1939.6016, -2116.7578, 12.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1944.8047, -2136.2578, 15.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 1944.8047, -2110.2969, 15.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 5313, 2043.9922, -2016.8672, 25.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 5316, 2043.9922, -2016.8672, 25.0547, 0.25);
    SOLS_RemoveBuilding(playerid, 5312, 2068.9609, -2013.4766, 24.1563, 0.25);
    SOLS_RemoveBuilding(playerid, 3286, 2042.1953, -1986.0859, 38.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 17758, 2260.0000, -1707.7344, 17.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 1498, 2229.6641, -1720.4219, 12.5547, 0.25);
    SOLS_RemoveBuilding(playerid, 17515, 2260.0000, -1707.7344, 17.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 17978, 2260.0000, -1707.7344, 17.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 1531, 1724.7344, -1741.5000, 14.1016, 0.25);
    // Ryhes Westmont
    SOLS_RemoveBuilding(playerid, 5205, 2111.6563, -1873.3672, 16.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 5206, 2163.6719, -1873.6172, 15.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 5207, 2167.0391, -1925.2031, 15.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 5208, 2115.0000, -1921.5234, 15.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2159.8281, -1930.6328, 15.0781, 0.25);
    SOLS_RemoveBuilding(playerid, 3567, 2142.9141, -1947.4219, 13.2656, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2118.2891, -1939.3984, 16.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2114.5547, -1928.1875, 5.0313, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2113.3984, -1925.0391, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2115.6719, -1922.7656, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2123.3594, -1928.0703, 6.8438, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2159.8281, -1930.6328, 15.0781, 0.25);
    SOLS_RemoveBuilding(playerid, 5181, 2167.0391, -1925.2031, 15.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 5182, 2115.0000, -1921.5234, 15.3906, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2122.6563, -1916.7891, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2116.9297, -1916.0781, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2121.5078, -1909.5313, 10.8047, 0.25);
    SOLS_RemoveBuilding(playerid, 620, 2110.2734, -1906.5859, 5.0313, 0.25);
    SOLS_RemoveBuilding(playerid, 5183, 2111.6563, -1873.3672, 16.3984, 0.25);
    SOLS_RemoveBuilding(playerid, 5180, 2163.6719, -1873.6172, 15.8203, 0.25);
    // Ryhes Seville
    SOLS_RemoveBuilding(playerid, 5256, 2768.4453, -2012.0938, 14.7969, 0.25);
    SOLS_RemoveBuilding(playerid, 1532, 2724.8594, -2025.7969, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 5302, 2741.0703, -2004.7813, 14.8750, 0.25);
    SOLS_RemoveBuilding(playerid, 5173, 2768.4453, -2012.0938, 14.7969, 0.25);
    // Janichar Return
    SOLS_RemoveBuilding(playerid, 3686, 2127.8828, -2083.2734, 16.0781, 0.25);
    SOLS_RemoveBuilding(playerid, 3688, 2159.9688, -2093.6875, 17.8594, 0.25);
    SOLS_RemoveBuilding(playerid, 3578, 2074.0156, -2099.4453, 13.3203, 0.25);
    SOLS_RemoveBuilding(playerid, 3621, 2159.9688, -2093.6875, 17.8594, 0.25);
    SOLS_RemoveBuilding(playerid, 3627, 2127.8828, -2083.2734, 16.0781, 0.25);
    // Rancho overlapping objects
    SOLS_RemoveBuilding(playerid, 3574, 2092.6875, -2043.3984, 15.0703, 0.25);
    SOLS_RemoveBuilding(playerid, 5200, 2014.8125, -2041.1406, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 5280, 2137.2891, -2063.2734, 13.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 5279, 2137.2891, -2063.2734, 13.8516, 0.25);
    SOLS_RemoveBuilding(playerid, 5186, 2014.8125, -2041.1406, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2073.8281, -2091.2344, 15.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2073.8359, -2091.2188, 15.0703, 0.25);
    // Reyo Westmont Graffiti on Fence
    SOLS_RemoveBuilding(playerid, 5374, 2085.2666, -1909.7165, 22.9930, 0.50 );

    // New LSPD at LS MALL
    SOLS_RemoveBuilding(playerid, 6161, 989.6719, -1553.6641, 19.8984, 0.25);
    SOLS_RemoveBuilding(playerid, 6162, 941.4141, -1530.6172, 23.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 6163, 986.8203, -1520.0703, 17.9297, 0.25);
    SOLS_RemoveBuilding(playerid, 6164, 982.6172, -1530.8281, 12.8359, 0.25);
    SOLS_RemoveBuilding(playerid, 6192, 988.9063, -1487.9063, 24.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 615, 929.0391, -1559.4609, 12.4766, 0.25);
    SOLS_RemoveBuilding(playerid, 6157, 941.4141, -1530.6172, 23.1719, 0.25);
    SOLS_RemoveBuilding(playerid, 6159, 989.6719, -1553.6641, 19.8984, 0.25);
    SOLS_RemoveBuilding(playerid, 6160, 982.6172, -1530.8281, 12.8359, 0.25);
    SOLS_RemoveBuilding(playerid, 6158, 986.8203, -1520.0703, 17.9297, 0.25);
    SOLS_RemoveBuilding(playerid, 621, 1024.1250, -1524.0156, 12.5391, 15.0);
    SOLS_RemoveBuilding(playerid, 759, 1025.5156, -1526.1563, 12.6875, 30.0);
    SOLS_RemoveBuilding(playerid, 759, 972.69, -1554.02, 20.84, 30.0);


    // Janichar RHB bar Enex (Removed as of 03/01/2021)
    //SOLS_RemoveBuilding(playerid, 17966, 2347.9219, -1364.2891, 27.1563, 0.25);
    //SOLS_RemoveBuilding(playerid, 17542, 2347.9219, -1364.2891, 27.1563, 0.25);
    // Janichar ELS vagos apt enex
    SOLS_RemoveBuilding(playerid, 17729, 2540.8281, -1350.5859, 40.8984, 0.25);
    SOLS_RemoveBuilding(playerid, 17679, 2540.8281, -1350.5859, 40.8984, 0.25);
    SOLS_RemoveBuilding(playerid, 17591, 2606.3828, -1341.8438, 47.5469, 0.25);
    
    // Jefferson
    SOLS_RemoveBuilding(playerid, 1687, 2208.7344, -1183.9609, 33.2734, 50.0);

    SOLS_RemoveBuilding(playerid, 5611, 2223.2656, -1202.1875, 27.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 5612, 2222.9922, -1162.6016, 30.0391, 0.25);
    SOLS_RemoveBuilding(playerid, 5638, 2184.5000, -1179.3281, 36.4063, 0.25);
    SOLS_RemoveBuilding(playerid, 1527, 2224.7656, -1193.0625, 25.8359, 0.25);
    SOLS_RemoveBuilding(playerid, 1226, 2209.3125, -1197.5469, 28.5859, 0.25);
    SOLS_RemoveBuilding(playerid, 5406, 2223.2656, -1202.1875, 27.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 5413, 2222.9922, -1162.6016, 30.0391, 0.25);

    SOLS_RemoveBuilding(playerid, 1493, 2233.7188, -1160.5547, 24.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 1493, 2192.3281, -1150.8359, 32.7813, 0.25);
    SOLS_RemoveBuilding(playerid, 1689, 2243.0547, -1190.0781, 33.6953, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2252.2969, -1178.2813, 25.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2255.5078, -1170.4531, 25.1328, 0.25);
    SOLS_RemoveBuilding(playerid, 673, 2256.3828, -1178.2031, 24.7344, 0.25);
    SOLS_RemoveBuilding(playerid, 17954, 2577.2344, -1350.3984, 56.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 5632, 2161.0781, -1131.6797, 31.1172, 0.25);
    // Janice extra RMB Jeff / ELS Apt Enex
    SOLS_RemoveBuilding(playerid, 1226, 2189.6094, -1197.0234, 27.3281, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 2216.6797, -1175.8125, 30.5547, 0.25);
    SOLS_RemoveBuilding(playerid, 1290, 2217.1953, -1152.7031, 30.5547, 0.25);
    // Reyo Toledo
    // SOLS_RemoveBuilding(playerid, 5117, 2031.2500, -1962.3125, 13.2891, 0.25);
    // SOLS_RemoveBuilding(playerid, 5194, 2031.2500, -1962.3125, 13.2891, 0.25);
    SOLS_RemoveBuilding(playerid, 5199, 1982.6406, -2038.1641, 14.7891, 0.25);
    SOLS_RemoveBuilding(playerid, 5201, 1988.1406, -2003.4219, 15.7734, 0.25);
    SOLS_RemoveBuilding(playerid, 5282, 2153.4063, -2051.4297, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 5283, 2213.1719, -2033.0625, 12.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 3723, 2197.7500, -1993.3594, 14.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 3723, 2100.7031, -1989.3984, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3723, 2093.2813, -1975.5859, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3723, 2178.7344, -1971.2656, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3723, 2189.9922, -1949.3281, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2072.5469, -1967.6016, 15.1172, 0.25);
    SOLS_RemoveBuilding(playerid, 5328, 2081.3594, -1974.3438, 8.7031, 0.25);
    SOLS_RemoveBuilding(playerid, 5344, 2039.5078, -1967.0156, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 5345, 2136.5078, -1992.8906, 12.7969, 0.25);
    SOLS_RemoveBuilding(playerid, 5346, 2016.3125, -1968.9219, 17.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 5347, 2130.6328, -1987.8984, 13.1484, 0.25);
    SOLS_RemoveBuilding(playerid, 5348, 2130.6328, -1987.8984, 13.1484, 0.25);
    SOLS_RemoveBuilding(playerid, 3770, 2197.9766, -1970.5625, 14.0000, 0.25);
    SOLS_RemoveBuilding(playerid, 5357, 2177.9922, -2006.7578, 23.2891, 0.25);
    SOLS_RemoveBuilding(playerid, 5360, 2132.9141, -1963.7344, 15.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2218.9141, -2125.3984, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2226.3828, -2117.9297, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2222.6484, -2121.6641, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2230.1172, -2114.1953, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2233.8516, -2110.4609, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1448, 2190.9844, -2106.9766, 12.6172, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2237.5859, -2106.7344, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 2241.3203, -2103.0000, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 5337, 1995.4375, -2066.1484, 18.5313, 0.25);
    SOLS_RemoveBuilding(playerid, 5273, 2153.4063, -2051.4297, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 1532, 1977.0547, -2035.8906, 12.5391, 0.25);
    SOLS_RemoveBuilding(playerid, 5140, 1982.6406, -2038.1641, 14.7891, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2109.6016, -2034.9141, 11.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2125.6641, -2034.9141, 11.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 5272, 2213.1719, -2033.0625, 12.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 1306, 2001.0234, -2024.2891, 19.7500, 0.25);
    SOLS_RemoveBuilding(playerid, 5136, 1988.1406, -2003.4219, 15.7734, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2093.8828, -2003.5547, 11.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2093.8828, -2018.8672, 11.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2109.6016, -2018.8672, 11.5156, 0.25);
    SOLS_RemoveBuilding(playerid, 5291, 2177.9922, -2006.7578, 23.2891, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1989.0859, -1982.4766, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1983.8125, -1982.4766, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 1412, 1978.5313, -1982.4766, 13.8203, 0.25);
    SOLS_RemoveBuilding(playerid, 3567, 1986.5703, -1974.4922, 13.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 5153, 1975.7109, -1974.5078, 13.1172, 0.25);
    SOLS_RemoveBuilding(playerid, 3567, 2004.4922, -1974.4922, 13.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 3567, 2008.6250, -1974.5469, 15.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 5152, 1997.7656, -1974.4688, 14.8750, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2070.3672, -1979.2266, 11.6016, 0.25);
    SOLS_RemoveBuilding(playerid, 1308, 2074.2734, -1999.6016, 11.6016, 0.25);
    SOLS_RemoveBuilding(playerid, 3722, 2100.7031, -1989.3984, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3722, 2093.2813, -1975.5859, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 5343, 2136.5078, -1992.8906, 12.7969, 0.25);
    SOLS_RemoveBuilding(playerid, 3722, 2178.7344, -1971.2656, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 3722, 2197.7500, -1993.3594, 14.9922, 0.25);
    SOLS_RemoveBuilding(playerid, 3626, 2197.9766, -1970.5625, 14.0000, 0.25);
    SOLS_RemoveBuilding(playerid, 5190, 2203.7969, -1992.1641, 14.2578, 0.25);
    SOLS_RemoveBuilding(playerid, 5169, 2016.3125, -1968.9219, 17.6250, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2072.5469, -1967.6016, 15.1172, 0.25);
    SOLS_RemoveBuilding(playerid, 5342, 2039.5078, -1967.0156, 12.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 5170, 2132.9141, -1963.7344, 15.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 3722, 2189.9922, -1949.3281, 16.8672, 0.25);
    SOLS_RemoveBuilding(playerid, 5216, 2243.6484, -2021.0156, 12.4141, 0.25);
    SOLS_RemoveBuilding(playerid, 5120, 2243.6484, -2021.0156, 12.4141, 0.25);
    // Willowfield PnS
    SOLS_RemoveBuilding(playerid, 3744, 2331.3828, -2001.6719, 15.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 3744, 2313.0469, -2008.5391, 15.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 1266, 2336.9141, -1987.6328, 21.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2313.0469, -2008.5391, 15.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 3574, 2331.3828, -2001.6719, 15.0234, 0.25);
    SOLS_RemoveBuilding(playerid, 1260, 2336.9141, -1987.6328, 21.8281, 0.25);
    // LAMP FIX TOLEDO
    SOLS_RemoveBuilding(playerid, 1226, 2209.5859, -1977.5234, 16.4844, 0.25);
    // ELS CHURCH
    SOLS_RemoveBuilding(playerid, 17722, 2411.1641, -1402.8828, 28.0156, 0.25);
    SOLS_RemoveBuilding(playerid, 3593, 2407.3125, -1418.3594, 23.6875, 0.25);
    SOLS_RemoveBuilding(playerid, 17636, 2411.1641, -1402.8828, 28.0156, 0.25);
    SOLS_RemoveBuilding(playerid, 3593, 2413.3281, -1399.6094, 23.6875, 0.25);
    SOLS_RemoveBuilding(playerid, 700, 2413.5781, -1409.8594, 22.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 17527, 2414.3984, -1362.2031, 32.6016, 0.25);

    //idlewood industrial/tattoo/barber shop (ALHAMBRA)
    SOLS_RemoveBuilding(playerid, 5524, 2025.3750, -1773.9531, 16.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 1524, 2034.3984, -1801.6719, 14.5469, 0.25);
    SOLS_RemoveBuilding(playerid, 1268, 2030.9297, -1763.1641, 28.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 1268, 2066.8125, -1791.7891, 21.9766, 0.25);
    SOLS_RemoveBuilding(playerid, 1259, 2030.9297, -1763.1641, 28.5781, 0.25);
    SOLS_RemoveBuilding(playerid, 5628, 2025.3750, -1773.9531, 16.6797, 0.25);
    SOLS_RemoveBuilding(playerid, 5522, 2048.7188, -1776.4766, 18.6484, 0.25);
    SOLS_RemoveBuilding(playerid, 1259, 2066.8125, -1791.7891, 21.9766, 0.25);
    // ELS LOD FIX!
    SOLS_RemoveBuilding(playerid, 17754, 2402.3125, -1503.5938, 28.9922, 0.25);
    // LITTLE MEXICO (UNDER VERDANT BLUFFS FREEWAY)
    SOLS_RemoveBuilding(playerid, 4066, 1629.4609, -1812.2891, 13.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 4098, 1622.6250, -1824.7891, 17.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 4124, 1653.4844, -1826.6406, 23.9219, 0.25);
    SOLS_RemoveBuilding(playerid, 4212, 1661.8047, -1826.7188, 24.8281, 0.25);
    SOLS_RemoveBuilding(playerid, 1266, 1648.0156, -1795.0703, 25.0391, 0.25);
    SOLS_RemoveBuilding(playerid, 4085, 1622.6250, -1824.7891, 17.4922, 0.25);
    SOLS_RemoveBuilding(playerid, 4122, 1629.4609, -1812.2891, 13.5234, 0.25);
    SOLS_RemoveBuilding(playerid, 4123, 1653.4844, -1826.6406, 23.9219, 0.25);
    SOLS_RemoveBuilding(playerid, 1260, 1648.0156, -1795.0703, 25.0391, 0.25);
    // Ganton Gym 2021
    //- Fixed floating graffiti at Little Mexico. (Add RMB)
    SOLS_RemoveBuilding(playerid, 4227, 1614.6328, -1862.2109, 14.0156, 0.25);
    // - Fixed graffiti bug at Toledo - update sols_new_ec.map
    SOLS_RemoveBuilding(playerid, 5375, 1995.4375, -2066.1484, 18.5313, 0.25);
    
    
    // MC clubhouse enex
    SOLS_RemoveBuilding(playerid, 4049, 1330.3750, -1793.0781, 22.9688, 0.25);
    SOLS_RemoveBuilding(playerid, 4112, 1330.3750, -1793.0781, 22.9688, 0.25);

    // Removes a door for a garage in EC
    SOLS_RemoveBuilding(playerid, 5020, 1877.4141, -2096.5078, 14.0391, 0.25);

    // pds_telewires model
    SOLS_RemoveBuilding(playerid, 5265, 2678.9688, -2003.8125, 21.5000, 0.25); //telewires

    // AOD
    SOLS_RemoveBuilding(playerid, 4049, 1330.3750, -1793.0781, 22.9688, 0.25);
    SOLS_RemoveBuilding(playerid, 4112, 1330.3750, -1793.0781, 22.9688, 0.25);

    // PNS IDLEWOOD
    SOLS_RemoveBuilding(playerid, -1, 2059.2615,-1831.3491,13.5469, 10.0);
    SOLS_RemoveBuilding(playerid, 5422, 2071.4766, -1831.4219, 14.5625, 0.25);

    // ELS CAR WASH / GARAGE
    SOLS_RemoveBuilding(playerid, -1, 2490.9063, -1474.3438, 27.3438, 0.25);
    SOLS_RemoveBuilding(playerid, -1, 2492.3203, -1484.8047, 28.2656, 0.25);
    SOLS_RemoveBuilding(playerid, -1, 2459.3594, -1486.1250, 34.1641, 0.25);
    SOLS_RemoveBuilding(playerid, 1527, 2522.4609, -1478.7422, 24.1641, 0.25); // GANG TAG TUNNEØ

    // FAST FOODS
    SOLS_RemoveBuilding(playerid, -1, 2105.4885, -1806.3651, 13.5547, 20.0); // pizzastacks

    SOLS_RemoveBuilding(playerid, -1, 2419.7024, -1509.0459, 24.0000, 8.00); // ELS cluck (doors)
    SOLS_RemoveBuilding(playerid, -1, 2402.3125, -1503.5938, 28.9922, 0.25); // ELS cluck (building+lod)

    SOLS_RemoveBuilding(playerid, -1, 2397.7568, -1899.1840, 13.5469, 3.0); // cluck2 (doors)
    SOLS_RemoveBuilding(playerid, -1, 2401.5962, -1904.2756, 13.5489, 5.0); // cluck2 (chairsntables)
    SOLS_RemoveBuilding(playerid, -1, 2385.1875, -1906.5156, 18.4453, 0.25); //
    SOLS_RemoveBuilding(playerid, 1527, 2392.3594, -1914.5703, 14.7422, 0.25); //g tag

    // DEAD END EC GHOUSE
    SOLS_RemoveBuilding(playerid, -1, 1759.9375, -2136.1953, 15.1719, 0.25);



    return true ;
}
