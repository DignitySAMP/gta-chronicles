//------------------------------------------------------------------------------
// Custom LSFD Fire Station No. 2 (Glen Park) - loosely based on LAFD Echo Park
// Created by Sporky (www.github.com/sporkyspork) for Singleplayer Roleplay (www.stretzofls.com)

#include <YSI_Coding\y_hooks>

#define MODELS_PATH "sporky/sols/int/lsfd"

/*

// done in visuals/models

static enum eFireStatObjects
{
    FIRESTAT_BASE = 3000,
    FIRESTAT_STAIRS,
    FIRESTAT_INT,
    FIRESTAT_MAST,
    FIRESTAT_ALPHA,
    FIRESTAT_FURN,
    FIRESTAT_PIPE1,
    FIRESTAT_PIPE2,
    FIRESTAT_JACKET,
    FIRESTAT_ROOF,
    FIRESTAT_CAGE,
    FIRESTAT_NET,
    FIRESTAT_2DFX,
    FIRESTAT_GLASS,
    FIRESTAT_BANNER,
}
*/

hook OnPlayerConnect(playerid)
{
    RemoveBuildingForPlayer(playerid, 4606, 1825.0000, -1413.9297, 12.5547, 0.25);
    RemoveBuildingForPlayer(playerid, 4594, 1825.0000, -1413.9297, 12.5547, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1842.1328, -1431.5859, 15.9141, 0.25);
    RemoveBuildingForPlayer(playerid, 1297, 1856.3984, -1442.8672, 15.9141, 0.25);
    RemoveBuildingForPlayer(playerid, 673, 1858.1875, -1439.6875, 11.9375, 0.25);
    return 1;
}

hook OnGameModeInit()
{
    AddSimpleModel(-1, 14846, FIRESTAT_BASE, MODELS_PATH"/firestat_base.dff", MODELS_PATH"/firestation.txd");
	AddSimpleModel(-1, 14846, FIRESTAT_STAIRS, MODELS_PATH"/firestat_stairs.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_INT, MODELS_PATH"/firestat_int.dff", MODELS_PATH"/firestation.txd");
	AddSimpleModel(-1, 18112, FIRESTAT_ALPHA, MODELS_PATH"/firestat_alpha.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_FURN, MODELS_PATH"/firestat_furn.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_PIPE1, MODELS_PATH"/firevacpipe1.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_PIPE2, MODELS_PATH"/firevacpipe2.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_JACKET, MODELS_PATH"/firejacket.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_ROOF, MODELS_PATH"/firestat_roof.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_CAGE, MODELS_PATH"/firestat_cage.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 19466, FIRESTAT_NET, MODELS_PATH"/firestat_net.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 16335, FIRESTAT_MAST, MODELS_PATH"/firestat_mast.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 14846, FIRESTAT_2DFX, MODELS_PATH"/firestat_2dfx.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 19466, FIRESTAT_GLASS, MODELS_PATH"/firestat_glass.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 3281, FIRESTAT_BANNER, MODELS_PATH"/fdbanner.dff", MODELS_PATH"/firestation.txd");
    AddSimpleModel(-1, 1523, FIRESTAT_DOOR, MODELS_PATH"/mafcasdoor.dff", MODELS_PATH"/mafcasdoor.txd");
    AddSimpleModel(-1, 1495, FIRESTAT_BAYDOOR_L, MODELS_PATH"/fdbaydoor_l.dff", MODELS_PATH"/fdbaydoor.txd");
    AddSimpleModel(-1, 1495, FIRESTAT_BAYDOOR_R, MODELS_PATH"/fdbaydoor_r.dff", MODELS_PATH"/fdbaydoor.txd");
    printf("FD BAY DOOR L: %d, R: %d", FIRESTAT_BAYDOOR_L, FIRESTAT_BAYDOOR_R);

    CreateFireStation();
    return 1;
}

#undef MODELS_PATH

static CreateFireStation()
{
	// Base objects:
    CreateDynamicObject(FIRESTAT_BASE, 1824.991, -1432.688, 18.076, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_STAIRS, 1822.326, -1447.006, 17.188, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_INT, 1828.044, -1435.413, 20.264, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_ALPHA, 1823.659, -1436.593, 18.059, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_FURN, 1820.263, -1430.205, 13.688, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_PIPE1, 1830.238, -1431.193, 16.087, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_PIPE1, 1823.841, -1431.203, 16.100, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_PIPE2, 1834.205, -1439.524, 16.124, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_PIPE2, 1818.811, -1439.369, 16.121, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_ROOF, 1824.152, -1429.401, 24.602, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_CAGE, 1825.314, -1436.235, 28.586, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_NET, 1825.314, -1436.235, 28.586, 0.000, 0.000, 0.000); // Sporky (-3006)
    CreateDynamicObject(FIRESTAT_MAST, 1819.464, -1427.65, 36.063, 0.000, 0.000, 0.000);
    CreateDynamicObject(FIRESTAT_2DFX, 1828.044, -1435.413, 20.264, 0.000000, 0.000000, 0.000000);
    CreateDynamicObject(FIRESTAT_GLASS, 1823.659, -1436.593, 18.059, 0.000000, 0.000000, 0.000000); 

    // Lights
    CreateDynamicObject(3785, 1827.272, -1442.065, 16.723, 0.000, 0.000, 0.000); // Sporky (3785)
    CreateDynamicObject(3785, 1827.272, -1447.376, 16.723, 0.000, 0.000, 0.000); // Sporky (3785)
    CreateDynamicObject(3785, 1833.559, -1440.559, 16.723, 0.000, 0.000, 270.000); // Sporky (3785)
    CreateDynamicObject(3785, 1829.166, -1440.580, 16.723, 0.000, 0.000, 270.000); // Sporky (3785)
    CreateDynamicObject(3785, 1825.096, -1432.736, 27.412, 0.000, 0.000, 0.000); // Sporky (3785)
    CreateDynamicObject(3785, 1817.844, -1433.485, 27.382, 0.000, 0.000, -88.299); // Sporky (3785)

    // Jackets
    CreateDynamicObject(FIRESTAT_JACKET, 1824.670, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1823.890, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1823.130, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1820.840, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1819.329, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1818.549, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1825.438, -1423.008, 13.691, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1817.050, -1423.008, 13.690, 0.000, 0.000, 0.000, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1813.980, -1445.274, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1813.991, -1446.205, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1814.001, -1447.185, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1814.012, -1448.136, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1814.022, -1449.066, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)
    CreateDynamicObject(FIRESTAT_JACKET, 1814.032, -1450.026, 13.793, 0.000, 0.000, 90.599, -1, -1, -1, 50.0, 50.0); // Sporky (-FIRESTAT_JACKET)


    // Bball
    CreateDynamicObject(946, 1815.071, -1441.869, 26.322, 0.000, 0.000, -91.300); // Sporky (946)
    // CreateDynamicObject(946, 1835.312, -1441.948, 26.322, 0.000, 0.000, 90.599); // Sporky (946)

    // Banner
    CreateDynamicObject(FIRESTAT_BANNER, 1836.845, -1428.946, 20.486, 0.000, 0.000, 89.899); // Sporky (-3014)

    // Basic furniture
    CreateDynamicObject(1998, 1825.405, -1444.695, 12.545, 0.000, 0.000, -90.299); // Sporky (1998)
    CreateDynamicObject(1806, 1825.107, -1445.733, 12.544, 0.000, 0.000, -62.099); // Sporky (1806)
    // CreateDynamicObject(1209, 1826.715, -1441.716, 12.556, 0.000, 0.000, -89.599); // Sporky (1209) // vending - uses custom now
    CreateDynamicObject(11706, 1826.743, -1440.587, 12.546, 0.000, 0.000, 100.399); // Sporky (11706)
    CreateDynamicObject(2673, 1826.413, -1440.642, 12.646, 0.000, 0.000, 22.699); // Sporky (2673)
    CreateDynamicObject(11709, 1815.141, -1440.518, 13.253, 0.000, 0.000, 0.000); // Sporky (11709)

    // More furniture
    CreateDynamicObject(15036, 1828.61, -1449.23, 19.48,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(11706, 1826.62, -1446.04, 18.30,   0.00, 0.00, 96.18, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(11706, 1826.59, -1445.16, 18.30,   0.00, 0.00, 85.74, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(19916, 1826.78, -1447.31, 18.38,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1968, 1834.93, -1447.83, 18.90,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1968, 1833.12, -1447.85, 18.90,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1968, 1834.96, -1443.16, 18.90,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2821, 1826.83, -1448.24, 19.33,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2830, 1835.24, -1443.32, 19.16,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2672, 1835.28, -1444.22, 18.65,   0.00, 0.00, -17.94, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2674, 1818.74, -1433.72, 18.40,   0.00, 0.00, 292.68, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2675, 1826.99, -1445.81, 18.43,   0.00, 0.00, 33.66, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2858, 1833.07, -1447.76, 19.16,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2860, 1834.93, -1447.90, 19.16,   0.00, 0.00, -17.28, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(14532, 1814.34, -1423.39, 19.36,   0.00, 0.00, -116.10, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2106, 1817.03, -1423.29, 19.17,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2105, 1818.52, -1430.67, 19.62,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2238, 1817.01, -1430.71, 19.58,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2479, 1814.09, -1429.98, 19.59,   0.00, 0.00, -89.28, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2238, 1814.08, -1429.05, 19.91,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2478, 1821.77, -1424.27, 19.74,   0.00, 0.00, -90.84, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2464, 1821.76, -1429.94, 19.64,   0.00, 0.00, 267.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(19825, 1813.82, -1426.92, 22.01,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(15027, 1823.21, -1421.34, 18.69,   0.00, 0.00, -57.48, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2838, 1817.11, -1429.48, 18.38,   0.00, 0.00, 95.52, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2206, 1816.86, -1434.25, 18.32,   0.00, 0.00, 270.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2164, 1813.82, -1432.75, 18.34,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2164, 1813.81, -1438.26, 18.36,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2163, 1813.84, -1435.51, 18.36,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1964, 1816.62, -1434.63, 19.40,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2251, 1813.97, -1434.50, 20.11,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2194, 1817.04, -1434.05, 19.51,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(19999, 1815.26, -1435.19, 18.37,   0.00, 0.00, 88.80, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1827, 1818.92, -1435.19, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2167, 1821.21, -1431.13, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1808, 1820.36, -1431.31, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(11721, 1813.86, -1424.53, 19.08,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2670, 1835.40, -1438.20, 18.47,   0.00, 0.00, -103.44, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2247, 1818.79, -1435.12, 19.21,   0.00, 0.00, 31.26, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2613, 1820.20, -1430.42, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2841, 1828.67, -1438.15, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1817, 1828.76, -1435.87, 18.38,   0.00, 0.00, -29.04, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1711, 1827.10, -1437.23, 18.38,   0.00, 0.00, 98.10, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1712, 1827.17, -1435.15, 18.38,   0.00, 0.00, 61.32, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1712, 1829.87, -1433.97, 18.38,   0.00, 0.00, -31.44, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1711, 1831.44, -1437.70, 18.38,   0.00, 0.00, 259.26, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(11706, 1836.01, -1438.94, 18.30,   0.00, 0.00, 236.22, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2671, 1833.35, -1447.12, 18.39,   0.00, 0.00, -17.94, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2839, 1829.42, -1435.68, 18.86,   0.00, 0.00, -15.24, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2631, 1828.99, -1424.28, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2630, 1832.06, -1424.50, 18.38,   0.00, 0.00, 2.58, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2630, 1833.59, -1424.37, 18.38,   0.00, 0.00, -2.52, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2627, 1835.33, -1424.51, 18.38,   0.00, 0.00, 179.58, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2915, 1830.57, -1423.78, 18.49,   0.00, 0.00, -27.42, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2916, 1827.47, -1423.67, 18.55,   0.00, 0.00, 16.38, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2751, 1830.65, -1423.52, 18.47,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2647, 1827.27, -1423.47, 18.54,   0.00, 0.00, 116.58, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1776, 1828.41, -1440.13, 19.47,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1775, 1829.89, -1440.18, 19.47,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(11706, 1827.14, -1440.23, 18.30,   0.00, 0.00, 12.18, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2673, 1825.90, -1428.93, 18.48,   0.00, 0.00, -115.08, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2673, 1826.83, -1440.72, 18.48,   0.00, 0.00, 61.32, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2671, 1834.17, -1442.57, 18.39,   0.00, 0.00, -105.78, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2749, 1830.44, -1423.52, 18.45,   0.00, 0.00, 54.96, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(3004, 1826.34, -1429.05, 19.92,   265.00, 0.00, 124.20, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(3004, 1826.35, -1428.91, 19.92,   265.00, 3.00, 85.32, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1598, 1826.75, -1423.31, 18.64,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(19805, 1829.54, -1422.90, 20.13,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(14532, 1836.00, -1438.03, 19.36,   0.00, 0.00, -267.24, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2186, 1821.54, -1436.94, 18.38,   0.00, 0.00, 270.06, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2613, 1821.99, -1437.63, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2674, 1821.15, -1436.67, 18.40,   0.00, 0.00, 270.96, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(19805, 1822.19, -1429.53, 20.13,   0.00, 0.00, 90.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1778, 1822.43, -1423.78, 18.40,   0.00, 0.00, 46.92, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(1808, 1825.99, -1428.57, 18.36,   0.00, 0.00, 270.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2613, 1826.33, -1428.12, 18.38,   0.00, 0.00, 0.00, -1, -1, -1, 50.0, 50.0);
    CreateDynamicObject(2673, 1829.81, -1440.55, 18.48,   0.00, 0.00, -36.60, -1, -1, -1, 50.0, 50.0);

    new fdfolders[1];
    fdfolders[0] = CreateDynamicObject(2162, 1813.95, -1435.62, 18.34,   0.00, 0.00, 98.04);

    for (new i = 0; i < sizeof(fdfolders); i ++)
	{
	    SetDynamicObjectMaterial(fdfolders[i], 1, 18887, "forcefields", "white");
	    SetDynamicObjectMaterial(fdfolders[i], 2, 18887, "forcefields", "white");
	}

    new fdchairs[2];

    fdchairs[0] = CreateDynamicObject(1708, 1819.46, -1437.03, 18.38,   0.00, 0.00, -177.30);
    fdchairs[1] = CreateDynamicObject(1708, 1818.50, -1433.29, 18.38,   0.00, 0.00, -2.64);

    for (new i = 0; i < sizeof(fdchairs); i ++)
	{
	    SetDynamicObjectMaterial(fdchairs[i], 1, 2206, "cj_office", "CJ_WOOD5");
    }

    new fdbeds[4];

    fdbeds[0] = CreateDynamicObject(1796, 1819.46, -1426.36, 18.38,   0.00, 0.00, 0.00);
    fdbeds[1] = CreateDynamicObject(1796, 1815.90, -1426.43, 18.38,   0.00, 0.00, 0.00);
    fdbeds[2] = CreateDynamicObject(1796, 1819.64, -1427.49, 18.38,   0.00, 0.00, 180.00);
    fdbeds[3] = CreateDynamicObject(1796, 1816.06, -1427.48, 18.38,   0.00, 0.00, 180.00);

    for (new i = 0; i < sizeof(fdbeds); i ++)
	{
	    SetDynamicObjectMaterial(fdbeds[i], 1, 1812, "cj_beds", "CJ_MAT1");
        SetDynamicObjectMaterial(fdbeds[i], 2, 2137, "cj_kitchen", "CJ_Black_metal");
        //SetDynamicObjectMaterial(fdbeds[i], 2, 2206, "cj_office", "CJ_WOOD5");
    }

    new fdwardrobes[6];
    fdwardrobes[0] = CreateDynamicObject(1740, 1817.04, -1424.44, 18.38,   0.00, 0.00, 0.00);
    fdwardrobes[1] = CreateDynamicObject(1740, 1817.00, -1429.47, 18.38,   0.00, 0.00, 180.00);
    fdwardrobes[2] = CreateDynamicObject(1740, 1818.48, -1429.45, 18.38,   0.00, 0.00, 180.00);
    fdwardrobes[3] = CreateDynamicObject(2087, 1821.88, -1423.64, 18.36,   0.00, 0.00, 270.00);
    fdwardrobes[4] = CreateDynamicObject(2087, 1821.88, -1429.08, 18.36,   0.00, 0.00, 270.00);
    fdwardrobes[5] = CreateDynamicObject(2087, 1813.93, -1430.23, 18.36,   0.00, 0.00, 90.00);

    for (new i = 0; i < sizeof(fdwardrobes); i ++)
	{
	    SetDynamicObjectMaterial(fdwardrobes[i], 0, 2206, "cj_office", "CJ_WOOD5");
        //SetDynamicObjectMaterial(fdwardrobes[i], 0, 2137, "cj_kitchen", "CJ_Black_metal");
    }

    new fdtvs[3];

    fdtvs[0] = CreateDynamicObject(2296, 1830.15, -1439.27, 18.38,   0.00, 0.00, 180.00);
    fdtvs[1] = CreateDynamicObject(2231, 1826.80, -1439.46, 18.38,   0.00, 0.00, -183.96);
    fdtvs[2] = CreateDynamicObject(2231, 1831.06, -1439.47, 18.38,   0.00, 0.00, -175.86);

    for (new i = 0; i < sizeof(fdtvs); i ++)
	{
	    // SetDynamicObjectMaterial(fdtvs[i], 0, 2206, "cj_office", "CJ_WOOD5");
    }

    // Doors
    CreateDynamicObject(FIRESTAT_DOOR, 1822.12, -1427.65, 19.72,   0.00, 0.00, 90.00);
    CreateDynamicObject(FIRESTAT_DOOR, 1822.14, -1435.85, 19.72,   0.00, 0.00, 90.00);
    CreateDynamicObject(FIRESTAT_DOOR, 1826.27, -1426.18, 19.72,   0.00, 0.00, 270.00);
    CreateDynamicObject(FIRESTAT_DOOR, 1826.29, -1442.44, 19.72,   0.00, 0.00, 270.00);
}

CMD:gotofd(playerid)
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_JUNIOR) return 0;

    SetPlayerPos(playerid,  1822.326, -1445.006, 13.988);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    return 1;
}