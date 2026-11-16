//------------------------------------------------------------------------------
// SANN Interior
// Created by Spooky (www.github.com/sporkyspork) for GTAC:RP
// Environments created by Spooky, Reyo and Ryhes

#include <YSI_Coding\y_hooks>

#define SAN_HIGH_SD 200.0
#define SAN_MED_SD	100.0
#define SAN_LOW_SD	50.0

#define SAN_EXT_X   1781.48 
#define SAN_EXT_Y 	-1648.43 
#define SAN_EXT_Z 	26.84
#define SAN_EXT_RZ 	125.50

#define SAN_INT_X (SAN_EXT_X + 0.0)
#define SAN_INT_Y (SAN_EXT_Y + 0.0)
#define SAN_INT_Z (SAN_EXT_Z + 0.0)
#define SAN_INT_RZ (SAN_EXT_RZ + 0.0)

#define SAN_INT_PATH "sann"

enum
{
	SAN_INT_MAIN = -5785,
	SAN_INT_BITS,
	SAN_INT_LIVE,
	SAN_INT_LIVEGLASS,
	SAN_INT_PART,
	SAN_INT_GLASS,
	SAN_INT_WIN,
	SAN_INT_LOBBY,
	SAN_EXT_LOGO,
	SAN_EXT_BITS,
	SAN_EXT_ALPHA,
	SAN_EXT_BILLBD
}

static SAN_INT_OBJ_MAIN;
static SAN_INT_OBJ_BITS;
static SAN_INT_OBJ_LIVE;
static SAN_INT_OBJ_LIVEGLASS;
static SAN_INT_OBJ_PART;
static SAN_INT_OBJ_GLASS;
static SAN_INT_OBJ_WIN;
static SAN_INT_OBJ_LOBBY;
static SAN_EXT_OBJ;

static STREAMER_TAG_AREA:SAN_INT_AREA;

static AddModels()
{
    AddSimpleModel(-1, 1923, 	SAN_INT_MAIN, 	SAN_INT_PATH"/sanint_main.dff",     SAN_INT_PATH"/sanint.txd" ) ;
	AddSimpleModel(-1, 1923, 	SAN_INT_BITS, 	SAN_INT_PATH"/sanint_bits.dff",     SAN_INT_PATH"/sanint_bits.txd" ) ;
	AddSimpleModel(-1, 1923, 	SAN_INT_LIVE, 	SAN_INT_PATH"/sanint_live.dff",     SAN_INT_PATH"/sanint_live.txd" ) ;
	AddSimpleModel(-1, 19325, 	SAN_INT_LIVEGLASS, 	SAN_INT_PATH"/sanint_liveglass.dff",     SAN_INT_PATH"/sanint_live.txd" ) ;
	AddSimpleModel(-1, 1923, 	SAN_INT_PART, 	SAN_INT_PATH"/sanint_partition.dff",     SAN_INT_PATH"/sanint.txd" ) ;
    AddSimpleModel(-1, 19325,	SAN_INT_GLASS, 	SAN_INT_PATH"/sanint_glass.dff",    SAN_INT_PATH"/sanint.txd" ) ;
    AddSimpleModel(-1, 19325,  	SAN_INT_WIN, 	SAN_INT_PATH"/sanint_win.dff",     	SAN_INT_PATH"/sanint.txd" ) ;
	AddSimpleModel(-1, 1923,  	SAN_INT_LOBBY, 	SAN_INT_PATH"/sanint_lobbybits.dff",     	SAN_INT_PATH"/sanint_lobbybits.txd" ) ;

	AddSimpleModel(-1, 1923, 	SAN_EXT_LOGO, 	SAN_INT_PATH"/sanext_logo.dff",     SAN_INT_PATH"/sanext_bits.txd" ) ;
	AddSimpleModel(-1, 1923, 	SAN_EXT_BITS, 	SAN_INT_PATH"/sanext_bits.dff",     SAN_INT_PATH"/sanext_bits.txd" ) ;
	AddSimpleModel(-1, 19325, 	SAN_EXT_ALPHA, 	SAN_INT_PATH"/sanext_alphas.dff",     SAN_INT_PATH"/sanext_bits.txd" ) ;
	AddSimpleModel(-1, 1923, 	SAN_EXT_BILLBD, SAN_INT_PATH"/sanext_billbd.dff",     SAN_INT_PATH"/sanext_bits.txd" ) ;
}

static CreateObjects()
{
	SAN_EXT_OBJ = CreateDynamicObject(4028, SAN_EXT_X, SAN_EXT_Y, SAN_EXT_Z, 0.00, 0.00, SAN_EXT_RZ, -1, 0, -1, 600.0, 600.0); // The exterior
	SAN_INT_OBJ_MAIN = CreateDynamicObject(SAN_INT_MAIN, SAN_INT_X, SAN_INT_Y, SAN_INT_Z, 0.00, 0.00, SAN_INT_RZ, -1, -1, -1, 300.0, 300.0); // The main shell
	SAN_INT_OBJ_BITS = CreateDynamicObject(SAN_INT_BITS, 1786.1664, -1655.8224, 33.6717, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The interior bits
    SAN_INT_OBJ_LIVE = CreateDynamicObject(SAN_INT_LIVE, SAN_INT_X - 11.213, SAN_INT_Y + 17.923, SAN_INT_Z + 4.338, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The live stage
	SAN_INT_OBJ_LIVEGLASS = CreateDynamicObject(SAN_INT_LIVEGLASS, SAN_INT_X - 11.213, SAN_INT_Y + 17.923, SAN_INT_Z + 4.338, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The live stage
	SAN_INT_OBJ_PART = CreateDynamicObject(SAN_INT_PART, SAN_INT_X, SAN_INT_Y, SAN_INT_Z, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The interior partitions
	SAN_INT_OBJ_GLASS = CreateDynamicObject(SAN_INT_GLASS, SAN_INT_X, SAN_INT_Y, SAN_INT_Z, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The interior glass
	SAN_INT_OBJ_WIN = CreateDynamicObject(SAN_INT_WIN, SAN_INT_X, SAN_INT_Y, SAN_INT_Z, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The outside window glass
	SAN_INT_OBJ_LOBBY = CreateDynamicObject(SAN_INT_LOBBY, 1797.0834, -1673.4590, 32.8893, 0.00, 0.00, SAN_INT_RZ, -1, 0, -1, 300.0, 300.0); // The lobby sofas etc

	SAN_INT_AREA = CreateDynamicCuboid(SAN_INT_X - 24.635, SAN_INT_Y - 32.849, SAN_INT_Z + 3.0, SAN_INT_X + 22.851, SAN_INT_Y + 23.381, SAN_INT_Z + 10.533);
	//SAN_INT_AREA = CreateDynamicCuboid(1781.48 - 24.635, -1648.43 - 32.849, 26.84 + 3.0, 1781.48 + 22.851, -1648.43 + 23.381, 26.84 + 10.533);

	CreateDynamicObject(SAN_EXT_LOGO, SAN_EXT_X + 23.665, SAN_EXT_Y + -19.920, SAN_EXT_Z + 6.929, 0.00, 0.00, SAN_EXT_RZ, -1, 0, -1, 300.0, 300.0); // The 3d sign
	CreateDynamicObject(SAN_EXT_LOGO, 1793.218, -1676.738, SAN_EXT_Z + 6.929, 0.000, 0.000, -54.500); // Kate_Mercer (-5777)
	CreateDynamicObject(SAN_EXT_LOGO, 1784.097, -1629.339, SAN_EXT_Z + 6.929, 0.000, 0.000, -144.300); // Kate_Mercer (-5777)

	CreateDynamicObject(SAN_EXT_BITS, 1802.5676, -1654.2424, 15.9018, 0.00, 0.00, 0.00, -1, 0, -1, 300.0, 300.0); // san ext bits
	CreateDynamicObject(SAN_EXT_ALPHA, 1807.8093, -1649.7664, 13.5099, 0.00, 0.00, 0.00, -1, 0, -1, 300.0, 300.0); // san ext alphas	

	// Bilboard
	CreateDynamicObject(1267, 1808.34, -1689.27, 28.52,   0.00, 0.00, 213.36, -1, 0, -1, 300.0, 300.0);
	CreateDynamicObject(SAN_EXT_BILLBD, 1808.833, -1688.636, 35.150, 0.000, 0.000, 123.700, -1, 0, -1, 300.0, 300.0);
	//CreateDynamicObject(SAN_EXT_BILLBD, 1805.556, -1691.824, 31.103, 0.000, 0.000, 145.000, -1, 0, -1, 300.0, 300.0); // sanext_billbd

	// Chairs
	CreateDynamicObject(-5345, 1790.963, -1656.148, 31.261, 0.000, 0.000, 15.600, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1792.301, -1655.244, 31.271, 0.000, 0.000, 34.600, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1793.592, -1654.499, 31.261, 0.000, 0.000, 56.500, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1796.874, -1668.821, 31.251, 0.000, 0.000, -160.099, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1790.921, -1651.084, 31.251, 0.000, 0.000, -158.899, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1788.898, -1652.433, 31.261, 0.000, 0.000, -139.599, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1789.729, -1651.796, 31.261, 0.000, 0.000, -144.300, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5728, 1769.459, -1628.424, 31.428, 0.000, 0.000, -73.499, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5728)
	CreateDynamicObject(-5728, 1768.349, -1629.208, 31.427, 0.000, 0.000, -40.800, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5728)
	CreateDynamicObject(-5345, 1783.854, -1645.400, 31.261, 0.000, 0.000, 144.399, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1786.922, -1643.051, 31.261, 0.000, 0.000, 153.500, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1789.245, -1645.912, 31.251, 0.000, 0.000, 109.599, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1780.633, -1647.930, 31.261, 0.000, 0.000, -56.399, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1782.603, -1650.380, 31.261, 0.000, 0.000, -38.000, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1780.919, -1662.566, 31.251, 0.000, 0.000, -36.799, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1775.321, -1654.591, 31.251, 0.000, 0.000, -41.499, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1770.974, -1646.791, 31.261, 0.000, 0.000, -135.100, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
	CreateDynamicObject(-5345, 1787.681, -1670.880, 31.251, 0.000, 0.000, -131.299, -1, 0, -1, 100.0, 100.0, SAN_INT_AREA); // Kate_Mercer (-5345)
}

static ToggleItems(playerid, bool:toggle)
{
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_EXT_OBJ, !toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_MAIN, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_BITS, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_LIVE, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_LIVEGLASS, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_PART, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_GLASS, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_WIN, toggle);
	Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, SAN_INT_OBJ_LOBBY, toggle);
}

hook OnPlayerConnect(playerid)
{
	ToggleItems(playerid, false);
	return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (areaid == SAN_INT_AREA)
	{
		// SendClientMessage(playerid, -1, sprintf("Left area: %d", areaid));
		ToggleItems(playerid, false);
	}

	return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (areaid == SAN_INT_AREA)
	{
		// SendClientMessage(playerid, -1, sprintf("Entered area: %d", areaid));
		ToggleItems(playerid, true);
	}
    
    return 1;
}

hook OnGameModeInit()
{
	print("[SAN_INT] Loading and creating SANN HQ Interior");

	AddModels();
	CreateObjects();

	print("[SAN_INT] Loaded and created SANN HQ Interior");
	return 1;
}

hook SOLS_OnPlayerPasspoint(playerid, point_id)
{
	if (IsPlayerInDynamicArea(playerid, SAN_INT_AREA, true))
	{
		ToggleItems(playerid, true);
		printf("Forced SAN_INT_AREA update for %s (%d)", SOLS_PlayerName(playerid), playerid);
	}

	return true;
}