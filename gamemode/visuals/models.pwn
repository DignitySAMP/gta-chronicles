// Now found in "config/modelconstants.pwn"

/*
CreateTestObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 300.0, Float:drawdistance = 300.0)
{
    streamdistance = 800.0;
    drawdistance = 800.0;

    return CreateDynamicObject(modelid, x, y, z, rx, ry, rz, worldid, interiorid, playerid, streamdistance, drawdistance);
}
*/


#define MAX_ADDED_FACTION_SKINS 300

static enum E_ADDED_SKIN_DATA
{
    E_ADDED_SKIN_BASE_ID,
    E_ADDED_SKIN_ID,
    E_ADDED_SKIN_NAME[64]
}

static AddedSkins[MAX_ADDED_FACTION_SKINS][E_ADDED_SKIN_DATA];
static AddedSkinsCount;

Models_AddModels() { 
  
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, OBJ_SKULL_HUMAN,"skull_human.dff", "skull_human.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, OBJ_SKULL_STEER,"skull_steer.dff", "skull_steer.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, OBJ_ROPESTACK,  "ropestack.dff", "ropestack.txd");

    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, WATER_POOL,      "waterpool.dff", "waterpool.txd" ) ;
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, WATER_POOL_MED,  "waterpool_med.dff", "waterpool.txd" ) ;
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, WATER_POOL_LARGE, "waterpool_large.dff", "waterpool.txd" ) ;

    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_BOTTLE,      "reyo/cratebottles.dff",         "reyo/cratebottles.txd");
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_FISH,        "reyo/cratefish.dff",            "reyo/cratefish.txd");
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_FRUITS,      "reyo/cratefruits.dff",          "reyo/cratefruits.txd");
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_HALFBOTTLES, "reyo/cratehalfbottles.dff",     "reyo/cratehalfbottles.txd");
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_MEAT,        "reyo/cratemeat.dff",            "reyo/cratemeat.txd");
    AddSimpleModel ( -1, CUSTOM_OBJECT_BASEID, REYO_CRATE_SALAD,       "reyo/cratesalad.dff",           "reyo/cratesalad.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WAREHOUSE2, "lsrpk/warehouse2.dff", "lsrpk/warehouse2.txd");

    /*
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WAREHOUSE, "lsrpk/warehousecutout.dff", "lsrpk/warehousecutout.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_LONGBEACHPARK, "lsrpk/longbeachpark.dff", "lsrpk/longbeachpark.txd");
    
    
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_IDLEWOODGHETTO1, "lsrpk/idlewoodhood1.dff", "lsrpk/idlewoodhood1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_IDLEWOODGHETTO2, "lsrpk/idlewoodhood2.dff", "lsrpk/idlewoodhood2.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SCHOOLMAP, "lsrpk/beaumont-high.dff", "lsrpk/beaumont-high.txd");
    */

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DIGNITY_TABLE0, "lsrpk/props/ghetto_table_black.dff", "lsrpk/props/ghetto_table_textures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DIGNITY_TABLE1, "lsrpk/props/ghetto_table_blue.dff", "lsrpk/props/ghetto_table_textures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DIGNITY_TABLE2, "lsrpk/props/ghetto_table_green.dff", "lsrpk/props/ghetto_table_textures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DIGNITY_TABLE3, "lsrpk/props/ghetto_table_red.dff", "lsrpk/props/ghetto_table_textures.txd");

    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      BONK_LSPDTAPE,         "bonk/policetape.dff", "bonk/policetape.txd");

    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,       KOSIDIAN_MURAL_1,       "kosidian/mural1.dff",     "kosidian/murals.txd" );
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,       KOSIDIAN_MURAL_2,       "kosidian/mural2.dff",     "kosidian/murals.txd" );
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,       KOSIDIAN_MURAL_3,       "kosidian/mural3.dff",     "kosidian/murals.txd" );
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,       KOSIDIAN_MURAL_4,       "kosidian/mural4.dff",     "kosidian/murals.txd" );

    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON6,     "janice/jefferson6.dff",           "janice/jefferson6.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON9,     "janice/jefferson9.dff",           "janice/jefferson9.txd");
    //AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_JANDRO4,         "janice/jandro4.dff", "janice/jandro4.txd");
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_JANDRO4,         "ryhes/jandro4new.dff", "ryhes/jandro4new.txd");


    /*  // Old Janice Models - Removed March 3rd 2022 by Spooky 

    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON4,     "janice/jefferson4.dff",           "janice/jefferson4.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON5,     "janice/jefferson5.dff",           "janice/jefferson5.txd");
    
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON7,     "janice/jefferson7.dff",           "janice/jefferson7.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON8,     "janice/jefferson8.dff",           "janice/jefferson8.txd");
    
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JEFFERSON10,    "janice/jefferson10.dff",          "janice/jefferson10.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_EC1,            "janice/Ec1.dff",                  "janice/Ec1.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_EC2,            "janice/Ec2.dff",                  "janice/Ec2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS,           "janice/deds.dff",                 "janice/deds.txd");
    //AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_CANAL,          "janice/canal.dff",                "janice/canal.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS2,          "janice/deds2.dff",                "janice/deds2.txd");
    //AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_CANAL2,         "janice/canal2.dff",               "janice/canal2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS3,          "janice/deds3.dff",                "janice/deds3.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS4,          "janice/deds4.dff",                "janice/deds4.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS5,          "janice/deds5.dff",                "janice/deds5.txd");
    //AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_NEWSPAPER,      "janice/newspaper.dff",            "janice/newspaper.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_DEDS6,          "janice/deds6.dff",                "janice/deds6.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE1,        "janice/Ghouse1.dff",              "janice/Ghouse1.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE2,        "janice/Ghouse2.dff",              "janice/Ghouse2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE3,        "janice/Ghouse3.dff",              "janice/Ghouse3.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE4,        "janice/Ghouse4.dff",              "janice/Ghouse4.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE5,        "janice/Ghouse5.dff",              "janice/Ghouse5.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_GHOUSE6,        "janice/Ghouse6.dff",              "janice/Ghouse6.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO1,         "janice/bueno1.dff",               "janice/bueno1.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO2,         "janice/bueno2.dff",               "janice/bueno2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO3,         "janice/bueno3.dff",               "janice/bueno3.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO4,         "janice/bueno4.dff",               "janice/bueno4.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO5,         "janice/bueno5.dff",               "janice/bueno5.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO6,         "janice/bueno6.dff",               "janice/bueno6.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO7,         "janice/bueno7.dff",               "janice/bueno7.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO8,         "janice/bueno8.dff",               "janice/bueno8.txd");
 //   AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO9,         "janice/bueno9.dff",               "janice/bueno9.txd");
 //   AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO10,        "janice/bueno10.dff",              "janice/bueno10.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JANDRO,         "janice/jandro.dff",               "janice/jandro.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JANDRO2,        "janice/jandro2.dff",              "janice/jandro2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_JANDRO3,        "janice/jandro3.dff",              "janice/jandro3.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_SWEET,          "janice/sweet.dff",                "janice/sweet.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_SWEET2,         "janice/sweet2.dff",               "janice/sweet2.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_SWEET2,         "janice/sweet2.dff",               "janice/sweet2.txd");

    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_BUENO11,         "janice/bueno11.dff", "janice/bueno11.txd");
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_BUENO12,         "janice/bueno12.dff", "janice/bueno12.txd");
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_BUENO13,         "janice/bueno13.dff", "janice/bueno13.txd");
    AddSimpleModel(-1,      CUSTOM_OBJECT_BASEID,      JANICE_LIKOR,           "janice/likor.dff", "janice/likor.txd");
    

    
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       JANICE_BUENO14,        "janice/bueno14.dff",              "janice/bueno14.txd");

    */


    /* // Removed in GTAC:RP 1.1.0 March 3rd by Spooky

    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       REYO_MARKET_1,          "reyo/marketparkprops.dff", "reyo/marketparkprops.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       REYO_MARKET_2,          "reyo/marketpark.dff", "reyo/marketpark.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       REYO_MARKET_3,          "reyo/markethouses.dff", "reyo/markethouses.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       REYO_MARKET_4,          "reyo/marketbackside.dff", "reyo/marketbackside.txd");
    AddSimpleModel(-1,     CUSTOM_OBJECT_BASEID,       REYO_MARKET_5,          "reyo/marketdriveinhouses.dff", "reyo/marketdriveinhouses.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SBF, "reyo/sbf.dff", "reyo/sbf.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SBF2, "reyo/sbf2.dff", "reyo/sbf2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SBF3, "reyo/sbf3.dff", "reyo/sbf3.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB, "janice/rhb.dff", "janice/rhb.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB2, "janice/rhb2.dff", "janice/rhb2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB3, "janice/rhb3.dff", "janice/rhb3.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GARCIA, "janice/garcia.dff", "janice/garcia.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_SBF4, "janice/sbf4.dff", "janice/sbf4.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_JEFFERSON1, "janice/jefferson1.dff", "janice/jefferson1.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_TATTOOBARBER,   "janice/tattoobarber.dff",      "janice/tattoobarber.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_SMOKE,          "janice/smoke.dff",             "janice/smoke.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_SHOP1,          "janice/shop1.dff",             "janice/shop1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_SHOP2,          "janice/shop2.dff",             "janice/shop2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_PIZZA,          "janice/pizza.dff",             "janice/pizza.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GYM,            "janice/gym.dff",               "janice/gym.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_DONUT,          "janice/donut.dff",             "janice/donut.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_CLUCK2,         "janice/cluck2.dff",            "janice/cluck2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_CLUCK,          "janice/cluck.dff",            "janice/cluck.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_BAR,            "janice/bar.dff",               "janice/bar.txd");

    */

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SHOES, "reyo/shoeswhite.dff", "reyo/shoes.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_DOMINO_TABLE, "reyo/domino_table.dff", "reyo/domino_table.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_BEER_NEW_2, "reyo/beernew2.dff", "reyo/beernewtextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_BEER_NEW_3, "reyo/beernew3.dff", "reyo/beernewtextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_ARMCHAIR,         "reyo/armchair.dff",            "reyo/armchair.txd");

    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DIGNITY_HOUSE,         "dignity/hades_house.dff",      "dignity/hades_house.txd");
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_YACHT,         "reyo/yacht.dff",      "reyo/yacht.txd");


    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_BACKSIDESTORES,         "reyo/market_backsitestores.dff",      "reyo/market_backsitestores.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_ARMCHAIR2,         "reyo/armchair2.dff",            "reyo/armchair2.txd");


    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PIZZASTACKS,         "reyo/pizzastacks.dff",            "reyo/pizzastacks.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_IDLEWOODGAS,         "reyo/idlewoodgas.dff",            "reyo/idlewoodgas.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_MARKETPARKFENCE,     "reyo/market_parkfence.dff",            "reyo/market_parkfence.txd");


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_CASINOPLC,     "reyo/casinoplc.dff",            "reyo/casinoplc.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_CASINOCUBE,     "reyo/casinocube.dff",            "reyo/casinocube.txd");


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_MXFLAG,     "ryhes/mxFlag.dff",            "ryhes/mxFlag.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_SWEET_EXT,  "ryhes/sweets_ext.dff",        "ryhes/sweetextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_SWEET_INT,  "ryhes/sweets_int.dff",        "ryhes/sweetextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_GRECO_PICTURE,  "ryhes/grecopics.dff",        "ryhes/grecopics.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_JVALVE,          "ryhes/jvalve.dff",                 "ryhes/jvalve.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_GUITAR,          "ryhes/guitar_acoustic.dff",        "ryhes/guitar_acoustic.txd");

    // Replaced by new Hunting Eagle building
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_EB_JEWELRY_INT,      "ryhes/eb_jewelry_int.dff",        "ryhes/eb_jewelry_int.txd");
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_EB_JEWELRY,          "ryhes/eb_jewelry.dff",        "ryhes/eb_jewelry.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_MULH_JEWELRY,          "ryhes/jewVertex.dff",        "ryhes/jeweltextures.txd");

    // Robbable Jewelry Stuff
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WATCHES_1, "reyo/watches1.dff",       "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WATCHES_2, "reyo/watches2.dff",       "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WATCHES_3, "reyo/watches3.dff",       "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WATCHES_4, "reyo/watches4.dff",       "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_WATCHES_5, "reyo/watches5.dff",       "reyo/jwlrytextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_MINIDIAMOND1, "reyo/minidiamond1.dff", "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_MINIDIAMOND2, "reyo/minidiamond2.dff", "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_MINIDIAMOND3, "reyo/minidiamond3.dff", "reyo/jwlrytextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_GOLD1, "reyo/gold1.dff",                 "reyo/jwlrytextures.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_DUMMYJWLR, "reyo/dummyjwlr.dff",      "reyo/jwlrytextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_DIAMONDS1, "reyo/diamonds1.dff",      "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_DIAMONDS2, "reyo/diamonds2.dff",      "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_DIAMONDS3, "reyo/diamonds3.dff",      "reyo/jwlrytextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_CHAIN1, "reyo/chain1.dff",            "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_CHAIN2, "reyo/chain2.dff",            "reyo/jwlrytextures.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_CHAIN3, "reyo/chain3.dff",            "reyo/jwlrytextures.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_ENEX_IDLEGAS, "ryhes/idlegas.dff",            "ryhes/idlegas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_ENEX_GANTON247, "ryhes/ganton24.dff",            "ryhes/ganton24.txd");

    // Removed March 3rd 2022
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_UNITY_ROAD_1, "ryhes/unity_misc.dff",    "ryhes/unity_misc.txd" );
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_UNITY_ROAD_2, "ryhes/unity.dff",         "ryhes/unity.txd" );
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_UNITY_ROAD_3, "ryhes/roadrage.dff",      "ryhes/roadrage.txd" );

    // Reyo jewewllers in downtown - removed march 3rd
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_J_CONTENTS, "reyo/jcontents.dff",            "reyo/jcontents.txd");

    /* // Old Janice Models - Removed March 3rd 2022 by Spooky 

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_1, "janice/alhambra1.dff",            "janice/alhambra1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_2, "janice/alhambra2.dff",            "janice/alhambra2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_3, "janice/alhambra3.dff",            "janice/alhambra3.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_4, "janice/alhambra4.dff",            "janice/alhambra4.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_5, "janice/alhambra5.dff",            "janice/alhambra5.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_6, "janice/alhambra6.dff",            "janice/alhambra6.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_7, "janice/alhambra7.dff",            "janice/alhambra7.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_8, "janice/alhambra8.dff",            "janice/alhambra8.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_9, "janice/alhambra9.dff",            "janice/alhambra9.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_10, "janice/alhambra10.dff",            "janice/alhambra10.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_11, "janice/alhambra11.dff",            "janice/alhambra11.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_12, "janice/alhambra12.dff",            "janice/alhambra12.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_13, "janice/alhambra13.dff",            "janice/alhambra13.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_14, "janice/alhambra14.dff",            "janice/alhambra14.txd");
    

    */

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_ENEX_IDLEGAS_INT, "ryhes/idlegas_objects.dff",            "ryhes/idlegas_objects.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_ENEX_GANTON_INT, "ryhes/ganton24_objects.dff",            "ryhes/ganton24_objects.txd");


    /* // Old Janice Models - Removed March 3rd 2022 by Spooky 

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_15, "janice/alhambra15.dff",            "janice/alhambra15.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_16, "janice/alhambra16.dff",            "janice/alhambra16.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_17, "janice/alhambra17.dff",            "janice/alhambra17.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ALHAMBRA_18,   "janice/alhambra18.dff",            "janice/alhambra18.txd");

    */
    
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_RUBBISH_BITS, "reyo/rubbish_bits.dff",            "reyo/rubbish_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_ALLEY2_BITS,  "reyo/alley2_bits.dff",            "reyo/alley2_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_ALLEY_BITS,   "reyo/alley_bits.dff",            "reyo/alley_bits.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SHOP_WINDOWS, "reyo/shop_windows.dff",            "reyo/.txd");
 
    

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SBF_VP,      "reyo/sbf_vp.dff", "reyo/sevtextures.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SBF4_VP,     "reyo/sbf4_vp.dff", "reyo/sevtextures.txd" ) ;



    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_ALHTABLES,     "reyo/alhtables.dff",             "reyo/alhtables.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_BURGER_WINDOW,     "reyo/burger_window.dff",   "reyo/windowtexture.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PARKBITS, "reyo/parkbits.dff", "reyo/parkbits.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PHONEBITS,     "reyo/phonebits.dff",          "reyo/phonebits.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_RUBBISHBITS,     "reyo/rubbish_bits.dff",     "reyo/rubbish_bits.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SHOP_WINDOW,     "reyo/shop_window.dff",      "reyo/windowtexture.txd" ) ;

    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PD_BUILD,     "reyo/pdfloor.dff",      "reyo/pdfloor.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PD_FLOOR,     "reyo/pdbuild.dff",      "reyo/pdbuild.txd" ) ;


    

    
    // Old pecado
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_1,     "janice/ECHill1.dff",      "janice/ECHill1.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_2,     "janice/ECHill2.dff",      "janice/ECHill2.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_3,     "janice/ECHill3.dff",      "janice/ECHill3.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_4,     "janice/ECHill4.dff",      "janice/ECHill4.txd" ) ;
    
    /* // Old Janice Models - Removed March 3rd 2022 by Spooky 

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_5,     "janice/ECHill5.dff",      "janice/ECHill5.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_HILL_6,     "janice/ECHill6.dff",      "janice/ECHill6.txd" ) ;

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS1,           "janice/ELS1.dff", "janice/ELS1.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS2,           "janice/ELS2.dff", "janice/ELS2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS3,           "janice/ELS3.dff", "janice/ELS3.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS4,           "janice/ELS4.dff", "janice/ELS4.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS5,           "janice/ELS5.dff", "janice/ELS5.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS6,           "janice/ELS6.dff", "janice/ELS6.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_ELS7,           "janice/ELS7.dff", "janice/ELS7.txd" ) ;

    */



    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_GRD_PIANO,           "ryhes/grd_piano.dff", "ryhes/grd_piano.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_GREEK_FLAG,           "ryhes/greekFlag.dff", "ryhes/greekFlag.txd" ) ;


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT1,           "ryhes/westmont/reyo_westmont1.dff",    "ryhes/westmont/reyo_westmont1.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT2,           "ryhes/westmont/reyo_westmont2.dff",    "ryhes/westmont/reyo_westmont2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT_BITS,           "ryhes/westmont/reyo_wm_bits.dff",  "ryhes/westmont/reyo_wm_bits.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT_BITS2,           "ryhes/westmont/w_bits2.dff",      "ryhes/westmont/w_bits2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT4,           "ryhes/westmont/westmont_4.dff",        "ryhes/westmont/westmont.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_WESTMONT_2A,           "ryhes/westmont/westmont2.dff",       "ryhes/westmont/westmont.txd" ) ;

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_SEVILLE_STORES,           "ryhes/seville/sbfstores.dff",     "ryhes/seville/sbfstores.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_SEVILLE_SBFVP,           "ryhes/seville/sbf_vp.dff",         "ryhes/seville/sevtextures.txd" ) ;


    /*
    // Old Janice Models - Removed March 3rd by Spooky
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_VEG,           "janice/EC_veg.dff",                      "janice/EC_bits.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_EC_LAMPS,           "janice/EC_lamps.dff",                  "janice/EC_bits.txd" ) ;

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_UNITY_ST1,           "janice/unitystation1.dff",                  "janice/unitystation1.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_UNITY_ST2,           "janice/unitystation2.dff",                  "janice/unitystation2.txd" ) ;

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB_INT,           "janice/rhb_int.dff",                  "janice/rhb_int.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB_INT2,           "janice/rhb_int2.dff",                  "janice/rhb_int2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_RHB_BITS,           "janice/rhb_bits.dff",                  "janice/rhb_bits.txd" ) ;

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GANTONGYM1,           "janice/gantongym1.dff",                  "janice/gantongym1.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GANTONGYM2,           "janice/gantongym2.dff",                  "janice/gantongym2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GANTONGYM3,           "janice/gantongym3.dff",                  "janice/gantongym3.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, JANICE_GANTONGYM4,           "janice/gantongym4.dff",                  "janice/gantongym4.txd" ) ;
    */

    AddSimpleModel(-1, 19478, REYO_KYALPHA,                          "reyo/ky_alpha.dff", "reyo/ky_alpha.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_KYBITS,           "reyo/ky_bits.dff", "reyo/ky_bits.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_KYPARK,           "reyo/ky_park.dff", "reyo/ky_park.txd" ) ;
    AddSimpleModel(-1, 19325, KY_VALPHA,           "reyo/ky_vAlpha.dff", "reyo/ky_alpha.txd" ) ;
    AddSimpleModel(-1, 5635, KY_LAEALPHA3,           "reyo/ky_laealpha3.dff", "reyo/ky_laealpha3.txd" ) ;
    
    
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RYHES_MEXICO, "ryhes/islamx.dff", "ryhes/islamx.txd" ) ;
    
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PDBUILDING,   "reyo/pdbuilding1.dff",     "reyo/pdbuilding1.txd" ) ;
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PDSTATIC,     "reyo/pdstatic.dff",        "reyo/pdstatic.txd" ) ;
   // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PDVEG,        "reyo/pdveg.dff",           "reyo/pdveg.txd" ) ;

    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_PDGARAGE, "reyo/pdgarage.dff", "reyo/pdgarage.txd" ) ;

    /* // Old Janice Models - Removed March 3rd by Spooky
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_0,       "janice/santosvagos0.dff",      "janice/santosvagos0.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_1,       "janice/santosvagos1.dff",      "janice/santosvagos1.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_2,       "janice/santosvagos2.dff",      "janice/santosvagos2.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_3,       "janice/santosvagos3.dff",      "janice/santosvagos3.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_4,       "janice/santosvagos4.dff",      "janice/santosvagos4.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_5,       "janice/santosvagos5.dff",      "janice/santosvagos5.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_6,       "janice/santosvagos6.dff",      "janice/santosvagos6.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_7,       "janice/santosvagos7.dff",      "janice/santosvagos7.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_8,       "janice/santosvagos8.dff",      "janice/santosvagos8.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_9,       "janice/santosvagos9.dff",      "janice/santosvagos9.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_10,      "janice/santosvagos10.dff",     "janice/santosvagos10.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_DOOR_1,  "janice/santosvagosdoor1.dff", "janice/santosvagosdoors.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_DOOR_2,  "janice/santosvagosdoor2.dff", "janice/santosvagosdoors.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_DOOR_3,  "janice/santosvagosdoor3.dff", "janice/santosvagosdoors.txd" ) ;
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,JANICE_SANTOSVAGOS_DOOR_4,  "janice/santosvagosdoor4.dff", "janice/santosvagosdoors.txd" ) ;
    */

    /* // Old Janice Models - Removed March 3rd by Spooky
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFBACKYARD,  "janice/jefbackyard.dff",  "janice/jefbackyard.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFBOTLEFT,  "janice/jefbotleft.dff",   "janice/jefbotleft.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMEETING,  "janice/jefmeeting.dff",   "janice/jefmeeting.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL1,  "janice/jefmotel1.dff",    "janice/jefmotel1.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL2,  "janice/jefmotel2.dff",    "janice/jefmotel2.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL3,  "janice/jefmotel3.dff",    "janice/jefmotel3.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL4,  "janice/jefmotel4.dff",    "janice/jefmotel4.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL5,  "janice/jefmotel5.dff",    "janice/jefmotel5.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL6,  "janice/jefmotel6.dff",    "janice/jefmotel6.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFMOTEL7,  "janice/jefmotel7.dff",    "janice/jefmotel7.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFRIGHTBEH,  "janice/jefrightbeh.dff",  "janice/jefrightbeh.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFUPMID,  "janice/jefupmid.dff",     "janice/jefupmid.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFUPRIGHT,  "janice/jefupright.dff",   "janice/jefupright.txd" );
    */


    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  REYO_UNITYST,  "reyo/unityst.dff",   "reyo/unityst.txd" );
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  REYO_UNITYST,  "reyo/unityst_temp.dff",   "reyo/unityst.txd" );

    // Removed 1.1.1
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  JANICE_JEFBOTRIGHT, "janice/jefbotright.dff", "janice/jefbotright.txd" ) ;


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_1, "TOLEDO/to_land.dff", "TOLEDO/to_roads.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_2, "TOLEDO/to_road1.dff", "TOLEDO/to_roads.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_3, "TOLEDO/to_road2.dff", "TOLEDO/to_roads.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_4, "TOLEDO/to_road3.dff", "TOLEDO/to_roads.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_5, "TOLEDO/to_road0.dff", "TOLEDO/to_roads.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_6, "TOLEDO/to_flats.dff", "TOLEDO/to_flats.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_7, "TOLEDO/to_bits.dff", "TOLEDO/to_flats.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_8, "TOLEDO/to_flat_stores1.dff", "TOLEDO/to_flat_shops.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_9, "TOLEDO/to_flat_stores2.dff", "TOLEDO/to_flat_shops.txd");
    AddSimpleModel(-1, 8674,                TOLEDO_PART_10,  "TOLEDO/to_alpha.dff", "TOLEDO/to_flats.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_11, "TOLEDO/to_lamps.dff", "TOLEDO/to_lamps.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_12, "TOLEDO/to_carwash.dff", "TOLEDO/to_carwash.txd");
    AddSimpleModel(-1, 8674,                TOLEDO_PART_13,  "TOLEDO/to_veg.dff", "TOLEDO/to_veg.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_14, "TOLEDO/to_prjland.dff", "TOLEDO/to_prjland.txd");
    AddSimpleModel(-1, 8674,                 TOLEDO_PART_15, "TOLEDO/tol_decorations.dff", "TOLEDO/tol_decorations.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_16, "TOLEDO/tol_store1.dff", "TOLEDO/tol_store1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_17, "TOLEDO/tol_store2.dff", "TOLEDO/tol_store2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_18, "TOLEDO/tol_store3.dff", "TOLEDO/tol_store3.txd");
    
    
    // Removed March 3rd 2022
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, TOLEDO_PART_19, "TOLEDO/to_flat_bits.dff", "TOLEDO/to_flats.txd");


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_1, "3101/alhambra_1.dff",              "3101/alhambra_1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_2, "3101/alhambra_2.dff",              "3101/alhambra_2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_3, "3101/alhambra_3.dff",              "3101/alhambra_3.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_4, "3101/alhambra_4.dff",              "3101/alhambra_4.txd");
    AddSimpleModel(-1, 8674, NEW3101_ALH_5, "3101/alhambra_alphas.dff",         "3101/alhambra_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_6, "3101/alhambra_bits.dff",           "3101/alhambra_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_7, "3101/alhambra_houses.dff",         "3101/alhambra_houses.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_8, "3101/alhambra_projects.dff",       "3101/alhambra_projects.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_9, "3101/alhambra_roads.dff",          "3101/alhambra_roads.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_0, "3101/alhambra_sm.dff",             "3101/alhambra_sm.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ALH_0, "3101/alhambra_sm_car.dff",             "3101/alhambra_sm_car.txd");
    
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_KP_BITS1, "3101/kellybits1.dff",            "3101/kellybits1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_KP_BITS2, "3101/kellydetails1.dff",         "3101/kellydetails1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_KP_BITS3, "3101/kellyland.dff",             "3101/kellyland.txd");
    AddSimpleModel(-1, 8674, NEW3101_KP_BITS4, "3101/kellyprj_alpha.dff",        "3101/kellyprj_alpha.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_KP_BITS5, "3101/kellyprj1.dff",             "3101/kellyprj1.txd");

    // replaced by new ones
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ELS_1, "3101/els_apts_alpha.dff",          "3101/els_apts_alpha.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ELS_2, "3101/els_apts_furni.dff",          "3101/els_apts_furni.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ELS_3, "3101/els_apts_int.dff",            "3101/els_apts_int.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ELS_4, "3101/els_apts_m.dff",              "3101/els_apts_m.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW3101_ELS_5, "3101/els_apts_trash.dff",          "3101/els_apts_trash.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_5,       "sanpedro/elschurch1.dff", "sanpedro/elschurch1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_6,       "sanpedro/elschurch2.dff", "sanpedro/elschurch2.txd");
    AddSimpleModel(-1,  8674, SANPEDRO_7,       "sanpedro/elschurch_alphas.dff", "sanpedro/elschurch_alphas.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ALHAMBRA_NEW_1,   "ALHAMBRA/iw_hoodstores.dff", "ALHAMBRA/iw_hoodstores.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ALHAMBRA_NEW_2,   "ALHAMBRA/iw_storebits.dff", "ALHAMBRA/iw_storebits.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ALHAMBRA_NEW_3,   "ALHAMBRA/iw_hoodroad.dff", "ALHAMBRA/iw_hoodroad.txd");
    AddSimpleModel(-1,  8674, ALHAMBRA_NEW_4,   "ALHAMBRA/iw_storebits_alpha.dff", "ALHAMBRA/iw_storebits_alpha.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ALHAMBRA_NEW_5,   "ALHAMBRA/iw_houses.dff", "ALHAMBRA/iw_houses.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ALHAMBRA_NEW_6,   "ALHAMBRA/iw_housebits.dff", "ALHAMBRA/iw_housebits.txd");
    AddSimpleModel(-1,  8674, ALHAMBRA_NEW_7,   "ALHAMBRA/iw_housebits_alpha.dff", "ALHAMBRA/iw_housebits_alpha.txd");

    // ELS CHURCH
    CreateDynamicObject(SANPEDRO_5, 2422.0930, -1426.3690, 28.7380, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00);  //elschurch1
    CreateObject(SANPEDRO_6, 2411.1640, -1402.8830, 28.0160, 0.0000, 0.0000, 0.0000, 800.0);  //elschurch2
    CreateDynamicObject(SANPEDRO_7, 2414.3984, -1362.2031, 32.6016, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00);  //elschurch_alphas


    // IDLEWOOD (ALHAMBRA)
    CreateObject(ALHAMBRA_NEW_1, 2068.3650, -1786.8160, 14.6630, 0.0000, 0.0000, 0.0000, 800.00); //iw_hoodstores
    CreateDynamicObject(ALHAMBRA_NEW_2, 2063.7360, -1779.9260, 13.0800, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00);  //iw_storebits
    //CreateObject(ALHAMBRA_NEW_3, 2020.3300, -1815.8940, 12.6340, 0.0000, 0.0000, 0.0000, 800.00); //iw_hoodroad
    CreateDynamicObject(ALHAMBRA_NEW_4, 2068.7380, -1786.0430, 15.7440, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00);  //iw_storebits_alpha
    CreateObject(ALHAMBRA_NEW_5, 2022.8960, -1783.6260, 14.5590, 0.0000, 0.0000, 0.0000, 800.00); //iw_houses
    CreateDynamicObject(ALHAMBRA_NEW_6, 2011.0590, -1781.6180, 13.9220, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00);  //iw_housebits
    CreateDynamicObject(ALHAMBRA_NEW_7, 2010.4900, -1779.5830, 16.7720, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00);  //iw_housebits_alpha


    // Removed March 3rd 2022
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SIGN_ELEC, "reyo/electronicsign.dff",          "reyo/electronicsign.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, REYO_SIGN_GROW, "reyo/growshopsign.dff",          "reyo/growshopsign.txd");


    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_UNITY_BITS, "ryhes/oldunity_alphabits.dff",        "ryhes/oldunity_alphabits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_ECHILL_BITS, "ryhes/ECHill_bits.dff",        "ryhes/ECHill_bits.txd");
    AddSimpleModel(-1, 8674,                    RYHES_ECHILL_BITS_NOCOL, "ryhes/ECHill_nocol.dff",        "ryhes/ECHill_bits.txd");

    // * LITTLE MEXICO (LMX)
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_1, "LMX/lmx_1.dff", "LMX/lmx_1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_2, "LMX/lmx_officebits.dff", "LMX/lmx_officebits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_3, "LMX/lmx_2.dff", "LMX/lmx_2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_4, "LMX/lmx_bsmtbits.dff", "LMX/lmx_bsmtbits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_5, "LMX/lmx_garbits.dff", "LMX/lmx_garbits.txd");
    AddSimpleModel(-1,  8674,                   RYHES_LMX_6, "LMX/lmx_alphas_1.dff", "LMX/lmx_alphas_1.txd");
    AddSimpleModel(-1,  8674,                   RYHES_LMX_7, "LMX/lmx_alphas_2.dff", "LMX/lmx_alphas_2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_8, "LMX/lmx_aptbits.dff", "LMX/lmx_aptbits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_9, "LMX/lmx_bits_1.dff", "LMX/lmx_bits_1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_10, "LMX/lmx_bits_2.dff", "LMX/lmx_bits_2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_11, "LMX/lmx_land.dff", "LMX/lmx_land.txd");
    AddSimpleModel(-1,  8674,                   RYHES_LMX_12, "LMX/lmx_officealphas.dff", "LMX/lmx_officealphas.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID,   RYHES_LMX_13, "LMX/lmx_mecgar_bits.dff", "LMX/lmx_mecgar_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    RYHES_LMX_14, "LMX/lmx_storebits.dff", "LMX/lmx_storebits.txd");
    AddSimpleModel(-1,  8674,                   RYHES_LMX_15, "LMX/vbfw_fence.dff", "LMX/vbfw_fence.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    GANTON_GYM_1, "reyo/gymenex.dff", "reyo/gymenex.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,    GANTON_GYM_2, "reyo/gymsolids.dff", "reyo/gymsolids.txd");
    AddSimpleModel(-1, 8674,    GANTON_GYM_3, "reyo/gymalpha.dff", "reyo/gymalpha.txd");
 

    AddSimpleModel(-1,  8674,                   REYO_JEFFERSON_1, "reyo/jm_bits2.dff", "reyo/jm_bits2.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID,                   REYO_JEFFERSON_2, "reyo/jm_main.dff", "reyo/jm_main.txd");
 

    CreateDynamicObject(GANTON_GYM_1, 2260.0000, -1707.7342, 17.1718, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00);  //REYO/GGRE/gymenex.dff
    CreateDynamicObject(GANTON_GYM_2, 2243.2453, -1702.9897, 14.1324, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00);  //REYO/GGRE/gymsolids.dff
    CreateDynamicObject(GANTON_GYM_3, 2236.4431, -1709.0810, 13.7950, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00);  //REYO/GGRE/gymalpha.dff



    // * GREATER LS (RANCHO/PARKHILL)
    AddSimpleModel(-1,  8674, RANCHO_PH1_1, "RANCHO/PH/1/ph1AlphasNEW.dff", "RANCHO/PH/1/ph1Alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH1_2, "RANCHO/PH/1/ph1Grndbase.dff", "RANCHO/PH/1/ph1Grndbase.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH1_3, "RANCHO/PH/1/ph1Projects.dff", "RANCHO/PH/1/ph1Projects.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH1_4, "RANCHO/PH/1/ph1Solids.dff", "RANCHO/PH/1/ph1Solids.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH1_5, "RANCHO/PH/1/ph1RoadNEW.dff", "RANCHO/PH/1/ph1Road.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH2_1, "RANCHO/PH/2/ph2Build.dff", "RANCHO/PH/2/ph2Build.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH2_2, "RANCHO/PH/2/ph2Details.dff", "RANCHO/PH/2/ph2Details.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH2_3, "RANCHO/PH/2/ph2Grndbase.dff", "RANCHO/PH/2/ph2Grndbase.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH2_4, "RANCHO/PH/2/ph2Road.dff", "RANCHO/PH/2/ph2Road.txd");
    AddSimpleModel(-1,  8674, RANCHO_PH2_5, "RANCHO/PH/2/ph2Alphas.dff", "RANCHO/PH/2/ph2Alphas.txd");

    AddSimpleModel(-1,  8674, RANCHO_PH3_1, "RANCHO/PH/3/ph3AlphasNEW.dff", "RANCHO/PH/3/ph3Alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH3_2, "RANCHO/PH/3/ph3Bits.dff", "RANCHO/PH/3/ph3Bits.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH3_5, "RANCHO/PH/3/ph3Buildings.dff", "RANCHO/PH/3/ph3Buildings.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH3_3, "RANCHO/PH/3/ph3Groundbase_cstnNEW.dff", "RANCHO/PH/3/ph3Groundbase_cstn.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RANCHO_PH3_4, "RANCHO/PH/3/ph3Housings.dff", "RANCHO/PH/3/ph3Housings.txd");

    // AOD clubhouse ENEX // Old models before remaster in GTAC:RP 1.1.0 - Removed March 3rd
    /*
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_1, "hades/_building_complete.dff", "hades/_building_textures.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_2, "hades/_building_interior.dff", "hades/_building_interior.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_3, "hades/_building_door.dff", "hades/_building_textures.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_4, "hades/_building_garage.dff", "hades/_building_textures.txd");

    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_5, "hades/_building_garage_duo.dff", "hades/_building_textures.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_6, "hades/_building_floor.dff", "hades/_building_floor.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_7, "hades/_building_top.dff", "hades/_building_textures.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_8, "hades/_building_interior_decorations.dff", "hades/_building_int_decorations.txd");

    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_9, "hades/_building_int_church_decor.dff", "hades/_building_interior_church.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_10, "hades/_building_int_church_col.dff", "hades/_building_interior_church.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_11, "hades/_building_bar_deco.dff", "hades/_building_bar.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_12, "hades/_building_bar_cols.dff", "hades/_building_bar.txd");
    AddSimpleModel(-1,  CUSTOM_OBJECT_BASEID, HADES_MC_ENEX_13, "hades/_building_bar_shelf.dff", "hades/_building_bar.txd");
    AddSimpleModel(-1,  8674, HADES_MC_ENEX_14, "hades/_building_bar_cage.dff", "hades/_building_bar.txd");
    */

    

    // RANCHO 
    //PARKHILL 1 (n)

    /*
        Ryhes — Today at 14:52
        Ph1grndbase/ph2grndbase is set to 1000, while everything else is set to 800. I think that might be the issue
        That was the issue with lm at least, when that was crashing people
    */
 
    CreateDynamicObject(RANCHO_PH1_1, 2367.1010, -2104.6790, 13.6710, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //ph1Alphas.txd
    CreateObject(RANCHO_PH1_2, 2360.9360, -2117.0170, 14.8510, 0.0000, 0.0000, 0.0000, 900.00); //ph1Grndbase.txd
    CreateDynamicObject(RANCHO_PH1_3, 2359.5310, -2109.4610, 15.3720, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ph1Projects.txd
    CreateDynamicObject(RANCHO_PH1_4, 2297.6900, -2080.5870, 12.5500, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ph1Solids.txd
    CreateObject(RANCHO_PH1_5, 2275.4070, -2095.2659, 12.5077, 0.0000, 0.0000, 0.0000, 900.00); //ph1Road.txd
    //CreateObject(RANCHO_PH1_5, 2288.4084, -2087.2087, 12.4211, 0.0000, 0.0000, 0.0000, 800.00); //ph1Road.txd (COL FIX)

    //PARKHILL 2 (mid)
    CreateDynamicObject(RANCHO_PH2_1, 2305.4860, -2165.2919, 16.8260, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //ph2Build.dff
    CreateDynamicObject(RANCHO_PH2_2, 2283.6020, -2175.0910, 15.3640, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ph2Details.dff
    CreateObject(RANCHO_PH2_3, 2290.3129, -2170.4309, 10.8767, 0.0000, 0.0000, 0.0000, 900.00); //ph2Grndbase.dff
    CreateObject(RANCHO_PH2_4, 2219.6040, -2200.4930, 12.5080, 0.0000, 0.0000, 0.0000, 900.00); //ph2Road
    CreateDynamicObject(RANCHO_PH2_5, 2295.9770, -2180.7250, 15.1610, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //ph2Alphas

    //PARKHILL 3 (s)
    CreateDynamicObject(RANCHO_PH3_1, 2216.6070, -2242.8240, 18.7810, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //RANCHO/3/ph3Alphas
    CreateDynamicObject(RANCHO_PH3_2, 2219.6490, -2243.6600, 17.1620, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //RANCHO/3/ph3Bits
    CreateObject(RANCHO_PH3_3, 2182.1979, -2273.2570, 13.0740, 0.0000, 0.0000, 0.0000, 900.00); //RANCHO/3/ph3Groundbase_cstn
    CreateDynamicObject(RANCHO_PH3_4, 2215.2780, -2240.8050, 14.7170, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //RANCHO/3/ph3Housings


    // Removed with New Pecado
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, OLDEC_ALPHABITS, "ELPECADO/oldEC_alphabits.dff", "ELPECADO/oldEC_alphabits.txd");
    //CreateDynamicObject(OLDEC_ALPHABITS, 1892.5391, -2012.8281, 21.3750, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00);  //ELPECADO/oldEC_alphabits

    /*
    SOLS_AddCharModel(102, 20001, "faction_skins/rhb/Ballas1.dff", "faction_skins/rhb/Ballas1.txd" ) ;
    SOLS_AddCharModel(103, 20002, "faction_skins/rhb/Ballas2.dff", "faction_skins/rhb/Ballas2.txd" ) ;
    SOLS_AddCharModel(104, 20003, "faction_skins/rhb/Ballas3.dff", "faction_skins/rhb/Ballas3.txd" ) ;

    SOLS_AddCharModel(108, 20004, "faction_skins/vagos/custom_vago1.dff", "faction_skins/vagos/custom_vago1.txd" ) ;
    SOLS_AddCharModel(109, 20005, "faction_skins/vagos/custom_vago2.dff", "faction_skins/vagos/custom_vago2.txd" ) ;
    SOLS_AddCharModel(110, 20006, "faction_skins/vagos/custom_vago3.dff", "faction_skins/vagos/custom_vago3.txd" ) ;
    SOLS_AddCharModel(108, 20007, "faction_skins/vagos/custom_vago4.dff", "faction_skins/vagos/custom_vago4.txd" ) ;
    */

    //SOLS_AddCharModel(173, 20008, "faction_skins/vla/sfr1.dff", "faction_skins/vla/sfr1.txd" ) ;
    //SOLS_AddCharModel(114, 20009, "faction_skins/vla/vla1.dff", "faction_skins/vla/vla1.txd" ) ;
    //SOLS_AddCharModel(115, 20010, "faction_skins/vla/vla2.dff", "faction_skins/vla/vla2.txd" ) ;
    //SOLS_AddCharModel(116, 20011, "faction_skins/vla/vla3.dff", "faction_skins/vla/vla3.txd" ) ;

    SOLS_AddCharModel(124, 20012, "faction_skins/cds/gd1.dff", "faction_skins/cds/gd1.txd" ) ;
    SOLS_AddCharModel(125, 20013, "faction_skins/cds/gd2.dff", "faction_skins/cds/gd2.txd" ) ;
    SOLS_AddCharModel(126, 20014, "faction_skins/cds/gd3.dff", "faction_skins/cds/gd3.txd" ) ;
    SOLS_AddCharModel(127, 20015, "faction_skins/cds/gd4.dff", "faction_skins/cds/gd4.txd" ) ;

    /*
    SOLS_AddCharModel(266, 20016, "faction_skins/lspd/white.dff", "faction_skins/lspd/white.txd" ) ;
    SOLS_AddCharModel(267, 20017, "faction_skins/lspd/hispanic.dff", "faction_skins/lspd/hispanic.txd" ) ;
    SOLS_AddCharModel(265, 20018, "faction_skins/lspd/black.dff", "faction_skins/lspd/black.txd" ) ;
*/
    SOLS_AddCharModel(102, 20019, "faction_skins/fyb/ballas1.dff", "faction_skins/fyb/ballas1.txd" ) ;
    SOLS_AddCharModel(103, 20020, "faction_skins/fyb/ballas2.dff", "faction_skins/fyb/ballas2.txd" ) ;
    SOLS_AddCharModel(104, 20021, "faction_skins/fyb/ballas3.dff", "faction_skins/fyb/ballas3.txd" ) ;
//    SOLS_AddCharModel(143, 20022, "faction_skins/fyb/sbmycr.dff", "faction_skins/fyb/sbmycr.txd" ) ;

    /*
    SOLS_AddCharModel(105, 20023, "faction_skins/gsf/grove1.dff", "faction_skins/gsf/grove1.txd" ) ;
    SOLS_AddCharModel(106, 20024, "faction_skins/gsf/grove2.dff", "faction_skins/gsf/grove2.txd" ) ;
    SOLS_AddCharModel(107, 20025, "faction_skins/gsf/grove3.dff", "faction_skins/gsf/grove3.txd" ) ;
    SOLS_AddCharModel(106, 20026, "faction_skins/gsf/grove4.dff", "faction_skins/gsf/grove4.txd" ) ;
    SOLS_AddCharModel(105, 20027, "faction_skins/gsf/grove5.dff", "faction_skins/gsf/grove5.txd" ) ;

    SOLS_AddCharModel(105, 20028, "faction_skins/sbf/SBF_FACTION_SKIN.dff", "faction_skins/sbf/SBF_FACTION_SKIN.txd" ) ;
    */
 
    /*
    SOLS_AddCharModel(267, 20029, "faction_skins/lspd/hern.dff", "faction_skins/lspd/hern.txd" ) ;
    SOLS_AddCharModel(280, 20030, "faction_skins/lspd/lapd1.dff", "faction_skins/lspd/lapd1.txd" ) ;
    SOLS_AddCharModel(284, 20031, "faction_skins/lspd/lapdm1.dff", "faction_skins/lspd/lapdm1.txd" ) ;
    SOLS_AddCharModel(266, 20032, "faction_skins/lspd/pulaski.dff", "faction_skins/lspd/pulaski.txd" ) ;
    SOLS_AddCharModel(281, 20033, "faction_skins/lspd/sfpd1.dff", "faction_skins/lspd/sfpd1.txd" ) ;*/
    SOLS_AddCharModel(285, 20034, "faction_skins/lspd/swatblack.dff", "faction_skins/lspd/swatblack.txd" ) ;
    SOLS_AddCharModel(286, 20035, "faction_skins/lspd/swatmasked.dff", "faction_skins/lspd/swatmasked.txd" ) ;
    SOLS_AddCharModel(287, 20036, "faction_skins/lspd/swatwhite.dff", "faction_skins/lspd/swatwhite.txd" ) ;
    //SOLS_AddCharModel(265, 20037, "faction_skins/lspd/tenpen.dff", "faction_skins/lspd/tenpen.txd" ) ;
    //SOLS_AddCharModel(307, 20038, "faction_skins/lspd/vbfycpd.dff", "faction_skins/lspd/vbfycpd.txd" ) ;
    //SOLS_AddCharModel(306, 20039, "faction_skins/lspd/wfyclpd.dff", "faction_skins/lspd/wfyclpd.txd" ) ;


    /*
    SOLS_AddCharModel(103, 20040, "faction_skins/ktb/KTB1.dff", "faction_skins/ktb/KTB1.txd" ) ;
    SOLS_AddCharModel(102, 20041, "faction_skins/ktb/KTB2.dff", "faction_skins/ktb/KTB2.txd" ) ;
    SOLS_AddCharModel(104, 20042, "faction_skins/ktb/KTB3.dff", "faction_skins/ktb/KTB3.txd" ) ;
    SOLS_AddCharModel(28,  20043, "faction_skins/ktb/KTB4.dff", "faction_skins/ktb/KTB4.txd" ) ;
    */

    /*
    SOLS_AddCharModel(105,  20044, "faction_skins/chf/jacket.dff", "faction_skins/chf/jacket.txd" ) ;
    SOLS_AddCharModel(107,  20045, "faction_skins/chf/tanktop.dff", "faction_skins/chf/tanktop.txd" ) ;
    SOLS_AddCharModel(106,  20046, "faction_skins/chf/tshirt.dff", "faction_skins/chf/tshirt.txd" ) ;
    */

    /*
    SOLS_AddCharModel(110, 20047, "faction_skins/vagos/lsv4.dff", "faction_skins/vagos/lsv4.txd" ) ;
    SOLS_AddCharModel(109, 20048, "faction_skins/vagos/lsv5.dff", "faction_skins/vagos/lsv5.txd" ) ;
    SOLS_AddCharModel(108, 20049, "faction_skins/vagos/lsv6.dff", "faction_skins/vagos/lsv6.txd" ) ;
    SOLS_AddCharModel(109, 20050, "faction_skins/vagos/lsv7.dff", "faction_skins/vagos/lsv7.txd" ) ;

    SOLS_AddCharModel(103, 20051, "faction_skins/tdb/balla0.dff", "faction_skins/tdb/balla0.txd" ) ;
    SOLS_AddCharModel(102, 20052, "faction_skins/tdb/ballas1.dff", "faction_skins/tdb/ballas1.txd" ) ;
    SOLS_AddCharModel(104, 20053, "faction_skins/tdb/ballas2.dff", "faction_skins/tdb/ballas2.txd" ) ;
    SOLS_AddCharModel(28,  20054, "faction_skins/tdb/ballas3.dff", "faction_skins/tdb/ballas3.txd" ) ;
    SOLS_AddCharModel(103, 20055, "faction_skins/tdb/ballas4.dff", "faction_skins/tdb/ballas4.txd" ) ;
    */

    /*
    SOLS_AddCharModel(173, 20056, "faction_skins/mbg/mbg1.dff", "faction_skins/mbg/mbg1.txd" ) ;
    SOLS_AddCharModel(174, 20057, "faction_skins/mbg/mbg2.dff", "faction_skins/mbg/mbg2.txd" ) ;
    SOLS_AddCharModel(175, 20058, "faction_skins/mbg/mbg3.dff", "faction_skins/mbg/mbg3.txd" ) ;
    SOLS_AddCharModel(113, 20059, "faction_skins/mbg/mbg4.dff", "faction_skins/mbg/mbg4.txd" ) ;
    */


    /*
    // SOLS_AddCharModel(103, 20060, "faction_skins/tdb/tdb1.dff", "faction_skins/tdb/tdb1.txd" ) ; // [16:33:07] [warning] Could not validate 0x654025A.dff. Error(44008:0x3) Deleting..
    SOLS_AddCharModel(102, 20061, "faction_skins/tdb/tdb2.dff", "faction_skins/tdb/tdb2.txd" ) ;
    SOLS_AddCharModel(104, 20062, "faction_skins/tdb/tdb3.dff", "faction_skins/tdb/tdb3.txd" ) ;
    */


    SOLS_AddCharModel(102, 20063, "faction_skins/fyb/FYB1.dff", "faction_skins/fyb/FYB1.txd" ) ;
    SOLS_AddCharModel(103, 20064, "faction_skins/fyb/FYB2.dff", "faction_skins/fyb/fyb2.txd" ) ;
    SOLS_AddCharModel(104, 20065, "faction_skins/fyb/FYB3.dff", "faction_skins/fyb/FYB3.txd" ) ;
    SOLS_AddCharModel(28, 20066, "faction_skins/fyb/FYB4.dff", "faction_skins/fyb/fyb4.txd" ) ;


    /*
    SOLS_AddCharModel(114, 20067, "faction_skins/vla/cholo1.dff", "faction_skins/vla/cholo1.txd" ) ;
    SOLS_AddCharModel(173, 20068, "faction_skins/vla/cholo2.dff", "faction_skins/vla/cholo2.txd" ) ;
    SOLS_AddCharModel(116, 20069, "faction_skins/vla/vla_fskin_080422.dff", "faction_skins/vla/vla_fskin_080422.txd" ) ;
    SOLS_AddCharModel(116, 20070, "faction_skins/vla/cholo4.dff", "faction_skins/vla/cholo4.txd" ) ;
    SOLS_AddCharModel(114, 20071, "faction_skins/vla/cholo5.dff", "faction_skins/vla/cholo5.txd" ) ;
    SOLS_AddCharModel(115, 20072, "faction_skins/vla/cholo6.dff", "faction_skins/vla/cholo6.txd" ) ;
    SOLS_AddCharModel(116, 20073, "faction_skins/vla/cholo7.dff", "faction_skins/vla/cholo7.txd" ) ;
    SOLS_AddCharModel(5, 20074, "faction_skins/vla/cholo8.dff", "faction_skins/vla/cholo8.txd" ) ;
    */


    SOLS_AddCharModel(233, 20075, "faction_skins/lspd/swatfemale.dff", "faction_skins/lspd/swatfemale.txd" ) ;


    /* // old pd

    SOLS_AddCharModel(69, 20076, "faction_skins/lspd/bfypd1.dff", "faction_skins/lspd/bfypd1.txd" ) ;
    SOLS_AddCharModel(69, 20077, "faction_skins/lspd/bfypd2.dff", "faction_skins/lspd/bfypd2.txd" ) ;
    SOLS_AddCharModel(55, 20078, "faction_skins/lspd/ofypd1.dff", "faction_skins/lspd/ofypd1.txd" ) ;
    SOLS_AddCharModel(150, 20079, "faction_skins/lspd/wfypd1.dff", "faction_skins/lspd/wfypd1.txd" ) ;

    */


    SOLS_AddCharModel(251, 20080, "faction_skins/lsfd/wfylafdh1.dff", "faction_skins/lsfd/wfylafdh1.txd" ) ;
    SOLS_AddCharModel(308, 20081, "faction_skins/lsfd/ofylafdh1.dff", "faction_skins/lsfd/ofylafdh1.txd" ) ;
    SOLS_AddCharModel(308, 20082, "faction_skins/lsfd/bfylafdh1.dff", "faction_skins/lsfd/bfylafdh1.txd" ) ;
    SOLS_AddCharModel(274, 20083, "faction_skins/lsfd/bmylafdh1.dff", "faction_skins/lsfd/bmylafdh1.txd" ) ;
    SOLS_AddCharModel(275, 20084, "faction_skins/lsfd/hmylafdh1.dff", "faction_skins/lsfd/hmylafdh1.txd" ) ;
    SOLS_AddCharModel(276, 20085, "faction_skins/lsfd/wmylafdh1.dff", "faction_skins/lsfd/wmylafdh1.txd" ) ;
    SOLS_AddCharModel(308, 20086, "faction_skins/lsfd/wfylaemt2.dff", "faction_skins/lsfd/wfylaemt2.txd" ) ;
    SOLS_AddCharModel(216, 20087, "faction_skins/lsfd/wfylaemt3.dff", "faction_skins/lsfd/wfylaemt3.txd" ) ;
    SOLS_AddCharModel(275, 20088, "faction_skins/lsfd/hmylaemt1.dff", "faction_skins/lsfd/hmylaemt1.txd" ) ;
    SOLS_AddCharModel(276, 20089, "faction_skins/lsfd/wmylaemt1.dff", "faction_skins/lsfd/wmylaemt1.txd" ) ;
    SOLS_AddCharModel(279, 20090, "faction_skins/lsfd/wmysffd2.dff", "faction_skins/lsfd/wmysffd2.txd" ) ;
    SOLS_AddCharModel(251, 20091, "faction_skins/lsfd/wfysffd1.dff", "faction_skins/lsfd/wfysffd1.txd" ) ;

    /* // old pd

    SOLS_AddCharModel(280, 20092, "faction_skins/lspd/lapd1.dff", "faction_skins/lspd/lapd1.txd" ) ;
    SOLS_AddCharModel(281, 20093, "faction_skins/lspd/sfpd1.dff", "faction_skins/lspd/sfpd1.txd" ) ;
    SOLS_AddCharModel(282, 20094, "faction_skins/lspd/lvpd1.dff", "faction_skins/lspd/lvpd1.txd" ) ;
    SOLS_AddCharModel(283, 20095, "faction_skins/lspd/csherna.dff", "faction_skins/lspd/csherna.txd" ) ;
    SOLS_AddCharModel(288, 20096, "faction_skins/lspd/dsherna.dff", "faction_skins/lspd/dsherna.txd" ) ;
    SOLS_AddCharModel(280, 20097, "faction_skins/lspd/fbipd.dff", "faction_skins/lspd/fbipd.txd" ) ;
    SOLS_AddCharModel(284, 20098, "faction_skins/lspd/male01pd.dff", "faction_skins/lspd/male01pd.txd" ) ;
    SOLS_AddCharModel(284, 20099, "faction_skins/lspd/bmybupd.dff", "faction_skins/lspd/bmybupd.txd" ) ;
    SOLS_AddCharModel(284, 20100, "faction_skins/lspd/bmyripd.dff", "faction_skins/lspd/bmyripd.txd" ) ;

    */



    /*
    SOLS_AddCharModel(284, 20101, "faction_skins/tdf/betafam3.dff", "faction_skins/tdf/betafam3.txd" ) ;
    SOLS_AddCharModel(284, 20102, "faction_skins/tdf/betafam4.dff", "faction_skins/tdf/betafam4.txd" ) ;
    SOLS_AddCharModel(284, 20103, "faction_skins/tdf/betafam5.dff", "faction_skins/tdf/betafam5.txd" ) ;
    // SOLS_AddCharModel(284, 20103, "faction_skins/tdf/betafam9.dff", "faction_skins/tdf/betafam9.txd" ) ;
    */

    SOLS_AddCharModel(219, 20104, "faction_skins/lsfd/bfylafd1.dff", "faction_skins/lsfd/bfylafd1.txd" ) ;
    SOLS_AddCharModel(278, 20105, "faction_skins/lsfd/bmylafd1.dff", "faction_skins/lsfd/bmylafd1.txd" ) ;
    SOLS_AddCharModel(219, 20106, "faction_skins/lsfd/bfylaemt1.dff", "faction_skins/lsfd/bfylaemt1.txd" ) ;
    //SOLS_AddCharModel(286, 20107, "faction_skins/lsfd/lapd1.dff", "faction_skins/lsfd/lapd1.txd" ) ;

    /*
    SOLS_AddCharModel(284, 20108, "faction_skins/lssd/bmycr.dff", "faction_skins/lssd/bmycr.txd" ) ;
    SOLS_AddCharModel(284, 20109, "faction_skins/lssd/male01.dff", "faction_skins/lssd/male01.txd" ) ;

    SOLS_AddCharModel(275, 20110, "faction_skins/lssd/vhmycrm.dff", "faction_skins/lssd/vhmycrm.txd" ) ;
    SOLS_AddCharModel(275, 20111, "faction_skins/lssd/sindaco.dff", "faction_skins/lssd/sindaco.txd" ) ;

    SOLS_AddCharModel(283, 20112, "faction_skins/lssd/lapd1.dff", "faction_skins/lssd/lapd1.txd" ) ;
    SOLS_AddCharModel(288, 20113, "faction_skins/lssd/lvpd1.dff", "faction_skins/lssd/lvpd1.txd" ) ;

    SOLS_AddCharModel(219, 20114, "faction_skins/lssd/sbfyri.dff", "faction_skins/lssd/sbfyri.txd" ) ;
    SOLS_AddCharModel(211, 20115, "faction_skins/lssd/gungrl3.dff", "faction_skins/lssd/gungrl3.txd" ) ;

    SOLS_AddCharModel(303, 20116, "faction_skins/lssd/oss/lapdpc.dff", "faction_skins/lssd/oss/lapdpc.txd" ) ;
    SOLS_AddCharModel(170, 20117, "faction_skins/lssd/oss/OSSasian.dff", "faction_skins/lssd/oss/OSSasian.txd" ) ;
    SOLS_AddCharModel(284, 20118, "faction_skins/lssd/oss/OSSblack.dff", "faction_skins/lssd/oss/OSSblack.txd" ) ;
    SOLS_AddCharModel(184, 20119, "faction_skins/lssd/oss/OSSmex.dff", "faction_skins/lssd/oss/OSSmex.txd" ) ;
    SOLS_AddCharModel(288, 20120, "faction_skins/lssd/oss/maffa.dff", "faction_skins/lssd/oss/maffa.txd" ) ;
    SOLS_AddCharModel(288, 20121, "faction_skins/lssd/oss/vmaff1b.dff", "faction_skins/lssd/oss/vmaff1b.txd" ) ;
    */

    SOLS_AddCharModel(278, 20125, "faction_skins/lsfd/new/lafd1.dff", "faction_skins/lsfd/new/lafd1.txd" ) ;
    SOLS_AddCharModel(277, 20126, "faction_skins/lsfd/new/lvpd1.dff", "faction_skins/lsfd/new/lvpd1.txd" ) ;
    SOLS_AddCharModel(278, 20127, "faction_skins/lsfd/new/fbi.dff", "faction_skins/lsfd/new/fbi.txd" ) ;
    SOLS_AddCharModel(251, 20128, "faction_skins/lsfd/new/fem.dff", "faction_skins/lsfd/new/fem.txd" ) ;
    SOLS_AddCharModel(233, 20129, "faction_skins/lsfd/new/fem2.dff", "faction_skins/lsfd/new/fem2.txd" ) ;
    SOLS_AddCharModel(219, 20130, "faction_skins/lsfd/new/fem3.dff", "faction_skins/lsfd/new/fem3.txd" ) ;

    SOLS_AddCharModel(154, 20131, "faction_skins/san/1.dff", "faction_skins/san/1.txd" ) ;
    SOLS_AddCharModel(156, 20132, "faction_skins/san/2.dff", "faction_skins/san/2.txd" ) ;
    SOLS_AddCharModel(164, 20133, "faction_skins/san/3.dff", "faction_skins/san/3.txd" ) ;

    //SOLS_AddCharModel(71, 20136, "faction_skins/chuff/guard.dff", "faction_skins/chuff/guard.txd" ) ;
    //SOLS_AddCharModel(164, 20137, "faction_skins/chuff/guard1.dff", "faction_skins/chuff/guard1.txd" ) ;
    //SOLS_AddCharModel(163, 20138, "faction_skins/chuff/guard2.dff", "faction_skins/chuff/guard2.txd" ) ;


    SOLS_AddCharModel(71, 20134, "faction_skins/chuff/wmysgrd.dff", "faction_skins/chuff/wmysgrd.txd" ) ;
    SOLS_AddCharModel(163, 20135, "faction_skins/chuff/wmysgrd_1.dff", "faction_skins/chuff/wmysgrd_1.txd" ) ;
    SOLS_AddCharModel(164, 20136, "faction_skins/chuff/wmysgrd_2.dff", "faction_skins/chuff/wmysgrd_2.txd" ) ;
    SOLS_AddCharModel(71, 20137, "faction_skins/chuff/guard.dff", "faction_skins/chuff/guard.txd" ) ;
    SOLS_AddCharModel(164, 20138, "faction_skins/chuff/guard1.dff", "faction_skins/chuff/guard1.txd" ) ;
    SOLS_AddCharModel(163, 20139, "faction_skins/chuff/guard2.dff", "faction_skins/chuff/guard2.txd" ) ;

    SOLS_AddCharModel(166, 20140, "faction_skins/fbi/fedbmybu.dff", "faction_skins/fbi/fedbmybu.txd" ) ;
    SOLS_AddCharModel(286, 20141, "faction_skins/fbi/fedlapd1.dff", "faction_skins/fbi/fedlapd1.txd" ) ;
    SOLS_AddCharModel(186, 20142, "faction_skins/fbi/fedsomyri.dff", "faction_skins/fbi/fedsomyri.txd" ) ;
    SOLS_AddCharModel(286, 20143, "faction_skins/fbi/fedwmybu.dff", "faction_skins/fbi/fedwmybu.txd" ) ;
    SOLS_AddCharModel(165, 20144, "faction_skins/fbi/suitlapd1.dff", "faction_skins/fbi/suitlapd1.txd" ) ;
    SOLS_AddCharModel(165, 20145, "faction_skins/fbi/suitwmybu.dff", "faction_skins/fbi/suitwmybu.txd" ) ;

    SOLS_AddCharModel(286, 20146, "faction_skins/dea/fbi_dea.dff", "faction_skins/dea/fbi_dea.txd" ) ;
    SOLS_AddCharModel(186, 20147, "faction_skins/dea/somyri_dea.dff", "faction_skins/dea/somyri_dea.txd" ) ;

    /*
    // new lssd
    SOLS_AddCharModel(310, 20148, "faction_skins/lssd/csherna_lssd_02.dff", "faction_skins/lssd/csherna_lssd_02.txd" ) ;
    SOLS_AddCharModel(310, 20149, "faction_skins/lssd/csherna_lssd_03.dff", "faction_skins/lssd/csherna_lssd_03.txd" ) ;

    //lssd seb
    SOLS_AddCharModel(285, 20150, "faction_skins/lssd/seb/seb_lssd_1.dff", "faction_skins/lssd/seb/seb_lssd_1.txd" ) ;
    SOLS_AddCharModel(285, 20151, "faction_skins/lssd/seb/seb_lssd_2.dff", "faction_skins/lssd/seb/seb_lssd_2.txd" ) ;
    SOLS_AddCharModel(285, 20152, "faction_skins/lssd/seb/seb_lssd_3.dff", "faction_skins/lssd/seb/seb_lssd_3.txd" ) ;
    SOLS_AddCharModel(285, 20153, "faction_skins/lssd/seb/seb_lssd_4.dff", "faction_skins/lssd/seb/seb_lssd_4.txd" ) ;
    SOLS_AddCharModel(285, 20154, "faction_skins/lssd/seb/seb_lssd_5.dff", "faction_skins/lssd/seb/seb_lssd_5.txd" ) ;
    SOLS_AddCharModel(285, 20155, "faction_skins/lssd/seb/seb_lssd_6.dff", "faction_skins/lssd/seb/seb_lssd_6.txd" ) ;
    SOLS_AddCharModel(285, 20156, "faction_skins/lssd/seb/seb_lssd_7.dff", "faction_skins/lssd/seb/seb_lssd_7.txd" ) ;
    SOLS_AddCharModel(285, 20157, "faction_skins/lssd/seb/seb_lssd_8.dff", "faction_skins/lssd/seb/seb_lssd_8.txd" ) ;
    SOLS_AddCharModel(285, 20158, "faction_skins/lssd/seb/seb_lssd_9.dff", "faction_skins/lssd/seb/seb_lssd_9.txd" ) ;
    */

    // lspd detective
    SOLS_AddCharModel(285, 20159, "faction_skins/lspd/wm_detective.dff", "faction_skins/lspd/wm_detective.txd" ) ;
    SOLS_AddCharModel(285, 20160, "faction_skins/lspd/hm_detective.dff", "faction_skins/lspd/hm_detective.txd" ) ;
    SOLS_AddCharModel(285, 20161, "faction_skins/lspd/bm_detective.dff", "faction_skins/lspd/bm_detective.txd" ) ;

    //lspd swat
    SOLS_AddCharModel(233, 20162, "faction_skins/lspd/swat/blackfswatbdu.dff", "faction_skins/lspd/swat/blackfswatbdu.txd" ) ;
    SOLS_AddCharModel(285, 20163, "faction_skins/lspd/swat/blackmswatbdu.dff", "faction_skins/lspd/swat/blackmswatbdu.txd" ) ;
    SOLS_AddCharModel(285, 20164, "faction_skins/lspd/swat/hispanicmswatbdu.dff", "faction_skins/lspd/swat/hispanicmswatbdu.txd" ) ;
    SOLS_AddCharModel(233, 20165, "faction_skins/lspd/swat/whitefswatbdu.dff", "faction_skins/lspd/swat/whitefswatbdu.txd" ) ;
    SOLS_AddCharModel(285, 20166, "faction_skins/lspd/swat/whitemswatbdu.dff", "faction_skins/lspd/swat/whitemswatbdu.txd" ) ;

    //lsfd pilots

    SOLS_AddCharModel(274, 20167, "faction_skins/lsfd/pilots/bmofirepilot.dff", "faction_skins/lsfd/pilots/bmofirepilot.txd" ) ;
    SOLS_AddCharModel(274, 20168, "faction_skins/lsfd/pilots/bmyfirepilot.dff", "faction_skins/lsfd/pilots/bmyfirepilot.txd" ) ;
    SOLS_AddCharModel(276, 20169, "faction_skins/lsfd/pilots/wmofirepilot.dff", "faction_skins/lsfd/pilots/wmofirepilot.txd" ) ;
    SOLS_AddCharModel(276, 20170, "faction_skins/lsfd/pilots/wmyfirepilot.dff", "faction_skins/lsfd/pilots/wmyfirepilot.txd" ) ;

    // lsfd hazmat
    SOLS_AddCharModel(277, 20171, "faction_skins/lsfd/lafd1_hazmat.dff", "faction_skins/lsfd/lafd1_hazmat.txd" ) ;

    // coors
    //SOLS_AddCharModel(250, 20172, "faction_skins/coors/collin_hanagen.dff", "faction_skins/coors/collin_hanagen.txd" ) ;
    //SOLS_AddCharModel(250, 20173, "faction_skins/coors/kyle_fiedler.dff", "faction_skins/coors/kyle_fiedler.txd" ) ;
    //SOLS_AddCharModel(250, 20174, "faction_skins/coors/myles_maynard.dff", "faction_skins/coors/myles_maynard.txd" ) ;
    //SOLS_AddCharModel(188, 20175, "faction_skins/coors/patrick_winstanley.dff", "faction_skins/coors/patrick_winstanley.txd" ) ;
    //SOLS_AddCharModel(188, 20176, "faction_skins/coors/paul_moore.dff", "faction_skins/coors/paul_moore.txd" ) ;
    //SOLS_AddCharModel(191, 20177, "faction_skins/coors/stacy_fuller.dff", "faction_skins/coors/stacy_fuller.txd" ) ;
    //SOLS_AddCharModel(188, 20178, "faction_skins/coors/vincent_palmer.dff", "faction_skins/coors/vincent_palmer.txd" ) ;

    //lsfd arson
    SOLS_AddCharModel(251, 20179, "faction_skins/lsfd/arson/vwfypro.dff", "faction_skins/lsfd/arson/vwfypro.txd" ) ;
    SOLS_AddCharModel(277, 20180, "faction_skins/lsfd/arson/csher.dff", "faction_skins/lsfd/arson/csher.txd" ) ;
    SOLS_AddCharModel(277, 20181, "faction_skins/lsfd/arson/lvpd1.dff", "faction_skins/lsfd/arson/lvpd1.txd" ) ;
    SOLS_AddCharModel(277, 20182, "faction_skins/lsfd/arson/lvpd2.dff", "faction_skins/lsfd/arson/lvpd2.txd" ) ;
    SOLS_AddCharModel(278, 20183, "faction_skins/lsfd/arson/wbdyg2.dff", "faction_skins/lsfd/arson/wbdyg2.txd" ) ;

    /*

    //lssd detective
    SOLS_AddCharModel(283, 20185, "faction_skins/lssd/lssd_rdet_1.dff", "faction_skins/lssd/lssd_rdet_1.txd" ) ;
    SOLS_AddCharModel(283, 20186, "faction_skins/lssd/lssd_rdet_2.dff", "faction_skins/lssd/lssd_rdet_2.txd" ) ;
    SOLS_AddCharModel(283, 20187, "faction_skins/lssd/lssd_rdet_3.dff", "faction_skins/lssd/lssd_rdet_3.txd" ) ;
    SOLS_AddCharModel(283, 20188, "faction_skins/lssd/lssd_rdet_4.dff", "faction_skins/lssd/lssd_rdet_4.txd" ) ;

    // lssd seb
    SOLS_AddCharModel(285, 20189, "faction_skins/lssd/lssd_seb_1.dff", "faction_skins/lssd/lssd_seb_1.txd" ) ;
    SOLS_AddCharModel(285, 20190, "faction_skins/lssd/lssd_seb_2.dff", "faction_skins/lssd/lssd_seb_2.txd" ) ;
    SOLS_AddCharModel(285, 20191, "faction_skins/lssd/lssd_seb_3.dff", "faction_skins/lssd/lssd_seb_3.txd" ) ;

    */

    /*
    // lsv
    SOLS_AddCharModel(30, 20192, "faction_skins/lsv/lsv_sicario_1.dff", "faction_skins/lsv/lsv_sicario_1.txd" ) ;
    SOLS_AddCharModel(110, 20193, "faction_skins/lsv/lsv_vato_2.dff", "faction_skins/lsv/lsv_vato_2.txd" ) ;
    SOLS_AddCharModel(108, 20194, "faction_skins/lsv/lsv_vato2_3.dff", "faction_skins/lsv/lsv_vato2_3.txd" ) ;
    SOLS_AddCharModel(109, 20195, "faction_skins/lsv/lsv_vato3_4.dff", "faction_skins/lsv/lsv_vato3_4.txd" ) ;
    */

    //yakuza
    SOLS_AddCharModel(233, 20196, "faction_skins/ykz/aiya_misumi.dff", "faction_skins/ykz/aiya_misumi.txd" ) ;
    SOLS_AddCharModel(60, 20197, "faction_skins/ykz/freddy_akihiro.dff", "faction_skins/ykz/freddy_akihiro.txd" ) ;
    SOLS_AddCharModel(60, 20198, "faction_skins/ykz/henry_kayoko.dff", "faction_skins/ykz/henry_kayoko.txd" ) ;
    SOLS_AddCharModel(118, 20199, "faction_skins/ykz/tatsuya_akimo.dff", "faction_skins/ykz/tatsuya_akimo.txd" ) ;

    /*
    //ktb
    SOLS_AddCharModel(102, 20200, "faction_skins/ktb/KTB_ballas_1.dff", "faction_skins/ktb/KTB_ballas_1.txd" ) ;
    SOLS_AddCharModel(103, 20201, "faction_skins/ktb/KTB_ballas_2.dff", "faction_skins/ktb/KTB_ballas_2.txd" ) ;
    SOLS_AddCharModel(104, 20202, "faction_skins/ktb/KTB_ballas_3.dff", "faction_skins/ktb/KTB_ballas_3.txd" ) ;
    SOLS_AddCharModel(102, 20203, "faction_skins/ktb/KTB_ballas_4.dff", "faction_skins/ktb/KTB_ballas_4.txd" ) ;
    SOLS_AddCharModel(103, 20204, "faction_skins/ktb/KTB_ballas_5.dff", "faction_skins/ktb/KTB_ballas_5.txd" ) ;
    SOLS_AddCharModel(102, 20205, "faction_skins/ktb/KTB_ballas_6.dff", "faction_skins/ktb/KTB_ballas_6.txd" ) ;
    SOLS_AddCharModel(102, 20206, "faction_skins/ktb/KTB_ballas_7.dff", "faction_skins/ktb/KTB_ballas_7.txd" ) ;
    SOLS_AddCharModel(102, 20207, "faction_skins/ktb/KTB_ballas_8.dff", "faction_skins/ktb/KTB_ballas_8.txd" ) ;
    //SOLS_AddCharModel(190, 20208, "faction_skins/ktb/KTB_ballas_10.dff", "faction_skins/ktb/KTB_ballas_10.txd" ) ;
    */

    SOLS_AddCharModel(163, 20210, "faction_skins/chuff/chuff1.dff", "faction_skins/chuff/chuff1.txd" ) ;
    SOLS_AddCharModel(71, 20211, "faction_skins/chuff/chuff2.dff", "faction_skins/chuff/chuff2.txd" ) ;
    SOLS_AddCharModel(71, 20212, "faction_skins/chuff/chuff3.dff", "faction_skins/chuff/chuff3.txd" ) ;
    SOLS_AddCharModel(71, 20213, "faction_skins/chuff/chuff4.dff", "faction_skins/chuff/chuff4.txd" ) ;
    SOLS_AddCharModel(71, 20214, "faction_skins/chuff/chuff5.dff", "faction_skins/chuff/chuff5.txd" ) ;
    SOLS_AddCharModel(163, 20215, "faction_skins/chuff/chuff6.dff", "faction_skins/chuff/chuff6.txd" ) ;
    SOLS_AddCharModel(163, 20216, "faction_skins/chuff/chuff7.dff", "faction_skins/chuff/chuff7.txd" ) ;
    SOLS_AddCharModel(71, 20217, "faction_skins/chuff/chuff8.dff", "faction_skins/chuff/chuff8.txd" ) ;
    SOLS_AddCharModel(71, 20218, "faction_skins/chuff/chuff9.dff", "faction_skins/chuff/chuff9.txd" ) ;

    SOLS_AddCharModel(147, 20220, "faction_skins/lsfd/90s/wmybu.dff", "faction_skins/lsfd/90s/wmybu.txd" ) ;
    SOLS_AddCharModel(147, 20221, "faction_skins/lsfd/90s/wmybu2.dff", "faction_skins/lsfd/90s/wmybu2.txd" ) ;
    SOLS_AddCharModel(17, 20222, "faction_skins/lsfd/90s/bmybu.dff", "faction_skins/lsfd/90s/bmybu.txd" ) ;
    SOLS_AddCharModel(274, 20223, "faction_skins/lsfd/90s/laemt1.dff", "faction_skins/lsfd/90s/laemt1.txd" ) ;
    SOLS_AddCharModel(275, 20224, "faction_skins/lsfd/90s/lvemt1.dff", "faction_skins/lsfd/90s/lvemt1.txd" ) ;
    SOLS_AddCharModel(276, 20225, "faction_skins/lsfd/90s/sfemt1.dff", "faction_skins/lsfd/90s/sfemt1.txd" ) ;
    SOLS_AddCharModel(276, 20226, "faction_skins/lsfd/90s/sfemt2.dff", "faction_skins/lsfd/90s/sfemt2.txd" ) ;
    SOLS_AddCharModel(276, 20227, "faction_skins/lsfd/90s/sfemt3.dff", "faction_skins/lsfd/90s/sfemt3.txd" ) ;
    SOLS_AddCharModel(251, 20228, "faction_skins/lsfd/90s/wfylg1.dff", "faction_skins/lsfd/90s/wfylg1.txd" ) ;
    SOLS_AddCharModel(251, 20229, "faction_skins/lsfd/90s/wfylg2.dff", "faction_skins/lsfd/90s/wfylg2.txd" ) ;
    SOLS_AddCharModel(139, 20230, "faction_skins/lsfd/90s/bfybe.dff", "faction_skins/lsfd/90s/bfybe.txd" ) ;

    SOLS_AddCharModel(104, 20231, "faction_skins/ballas1.dff", "faction_skins/ballas1.txd" ) ;
    SOLS_AddCharModel(105, 20232, "faction_skins/ballas2.dff", "faction_skins/ballas2.txd" ) ;
    SOLS_AddCharModel(106, 20233, "faction_skins/ballas3.dff", "faction_skins/ballas3.txd" ) ;
    SOLS_AddCharModel(107, 20234, "faction_skins/fam1.dff", "faction_skins/fam1.txd" ) ;
    SOLS_AddCharModel(106, 20235, "faction_skins/fam2.dff", "faction_skins/fam2.txd" ) ;
    SOLS_AddCharModel(109, 20236, "faction_skins/spp/SPP_Piru_1_27032022.dff", "faction_skins/spp/SPP_Piru_1_27032022.txd" ) ;
    //SOLS_AddCharModel(109, 20236, "faction_skins/fam3.dff", "faction_skins/fam3.txd" ) ;

    /*
    SOLS_AddCharModel(104, 20237, "faction_skins/spp/piru1.dff", "faction_skins/spp/piru1.txd" ) ;
    SOLS_AddCharModel(105, 20238, "faction_skins/spp/piru2.dff", "faction_skins/spp/piru2.txd" ) ;
    SOLS_AddCharModel(106, 20239, "faction_skins/spp/piru3.dff", "faction_skins/spp/piru3.txd" ) ;
    //SOLS_AddCharModel(105, 20240, "faction_skins/spp/piru4.dff", "faction_skins/spp/piru4.txd" ) ;
    SOLS_AddCharModel(105, 20240, "faction_skins/spp/SPP_Piru_2_27032022.dff", "faction_skins/spp/SPP_Piru_2_27032022.txd" ) ;
    SOLS_AddCharModel(104, 20241, "faction_skins/spp/piru5.dff", "faction_skins/spp/piru5.txd" ) ;
    */

    /*
    // ccp (not da chinese one)
    SOLS_AddCharModel(106, 20242, "faction_skins/ccp/ccp_fskin1_280322.dff", "faction_skins/ccp/ccp_fskin1_280322.txd" ) ;
    //SOLS_AddCharModel(106, 20243, "faction_skins/ccp/ccp_fskin2_280322.dff", "faction_skins/ccp/ccp_fskin2_280322.txd" ) ; // [warning] Could not validate 0x1B271B3D.dff. Error(44007:0x116) Deleting..
    SOLS_AddCharModel(107, 20244, "faction_skins/ccp/ccp_fskin3_280322.dff", "faction_skins/ccp/ccp_fskin3_280322.txd" ) ;
    SOLS_AddCharModel(106, 20245, "faction_skins/ccp/ccp_fskin4_280322.dff", "faction_skins/ccp/ccp_fskin4_280322.txd" ) ;
    //SOLS_AddCharModel(105, 20246, "faction_skins/ccp/ccp_fskin5_280322.dff", "faction_skins/ccp/ccp_fskin5_280322.txd" ) ; // [warning] Could not validate 0xB71AF6C9.dff. Error(44007:0x116) Deleting..
    SOLS_AddCharModel(107, 20247, "faction_skins/ccp/ccp_fskin6_280322.dff", "faction_skins/ccp/ccp_fskin6_280322.txd" ) ; 
    SOLS_AddCharModel(107, 20248, "faction_skins/ccp/ccp_fskin7_280322.dff", "faction_skins/ccp/ccp_fskin7_280322.txd" ) ;
    SOLS_AddCharModel(106, 20249, "faction_skins/ccp/ccp_fskin8_280322.dff", "faction_skins/ccp/ccp_fskin8_280322.txd" ) ;
    SOLS_AddCharModel(106, 20250, "faction_skins/ccp/ccp_fskin9_280322.dff", "faction_skins/ccp/ccp_fskin9_280322.txd" ) ;
    //SOLS_AddCharModel(107, 20251, "faction_skins/ccp/ccp_fskin10_280322.dff", "faction_skins/ccp/ccp_fskin10_280322.txd" ) ; // [warning] Could not validate 0x88783156.dff. Error(44007:0x116) Deleting..
    SOLS_AddCharModel(105, 20252, "faction_skins/ccp/ccp_fskin11_280322.dff", "faction_skins/ccp/ccp_fskin11_280322.txd" ) ;
    */

    // some random ccf skin
    SOLS_AddCharModel(126, 20243, "faction_skins/ccf/CCF_Garofalo_062022.dff", "faction_skins/ccf/CCF_Garofalo_062022.txd" ) ;
    SOLS_AddCharModel(295, 20244, "faction_skins/ccf/CCF_Lee_072022.dff", "faction_skins/ccf/CCF_Lee_072022.txd" ) ;

    // aperture
    SOLS_AddCharModel(287, 20253, "faction_skins/ap/army.dff", "faction_skins/ap/army.txd" ) ;
    SOLS_AddCharModel(287, 20254, "faction_skins/ap/psycho.dff", "faction_skins/ap/psycho.txd" ) ;
    SOLS_AddCharModel(166, 20255, "faction_skins/ap/bmymib1.dff", "faction_skins/ap/bmymib1.txd" ) ;
    SOLS_AddCharModel(165, 20256, "faction_skins/ap/wmomib1.dff", "faction_skins/ap/wmomib1.txd" ) ;
    SOLS_AddCharModel(286, 20257, "faction_skins/ap/claude.dff", "faction_skins/ap/claude.txd" ) ;
    SOLS_AddCharModel(191, 20258, "faction_skins/ap/gungrl3.dff", "faction_skins/ap/gungrl3.txd" ) ;

    // dea
    // SOLS_AddCharModel(165, 20260, "faction_skins/dea/wmyconb.dff", "faction_skins/dea/wmyconb.txd" ) ;
    SOLS_AddCharModel(166, 20261, "faction_skins/dea/wbdyg1.dff", "faction_skins/dea/wbdyg1.txd" ) ;

    /*
    // lssd seb 2
    SOLS_AddCharModel(309, 20263, "faction_skins/lssd/seb/lssd_sebfemale1_120422.dff", "faction_skins/lssd/seb/lssd_sebfemale1_120422.txd" ) ;
    SOLS_AddCharModel(309, 20264, "faction_skins/lssd/seb/lssd_sebfemale2_120422.dff", "faction_skins/lssd/seb/lssd_sebfemale2_120422.txd" ) ;
    SOLS_AddCharModel(309, 20265, "faction_skins/lssd/seb/lssd_swtfemale_120422.dff", "faction_skins/lssd/seb/lssd_swtfemale_120422.txd" ) ;
    SOLS_AddCharModel(309, 20266, "faction_skins/lssd/seb/lssd_swtfemale2_120422.dff", "faction_skins/lssd/seb/lssd_swtfemale2_120422.txd" ) ;

    // lssd det
    SOLS_AddCharModel(303, 20268, "faction_skins/lssd/det/lssd_blackdetective2_120422.dff", "faction_skins/lssd/det/lssd_blackdetective2_120422.txd" ) ;
    SOLS_AddCharModel(303, 20269, "faction_skins/lssd/det/lssd_blackfield_120422.dff", "faction_skins/lssd/det/lssd_blackfield_120422.txd" ) ;
    SOLS_AddCharModel(303, 20270, "faction_skins/lssd/det/lssd_hispanicdetective_120422.dff", "faction_skins/lssd/det/lssd_hispanicdetective_120422.txd" ) ;
    SOLS_AddCharModel(303, 20272, "faction_skins/lssd/det/lssd_whitedetective_120422.dff", "faction_skins/lssd/det/lssd_whitedetective_120422.txd" ) ;
    SOLS_AddCharModel(303, 20273, "faction_skins/lssd/det/lssd_whitedetective1_120422.dff", "faction_skins/lssd/det/lssd_whitedetective1_120422.txd" ) ;
    SOLS_AddCharModel(303, 20275, "faction_skins/lssd/det/lssd_whitedetective3_120422.dff", "faction_skins/lssd/det/lssd_whitedetective3_120422.txd" ) ;
    SOLS_AddCharModel(303, 20276, "faction_skins/lssd/det/lssd_whitedetective3_120422.dff", "faction_skins/lssd/det/lssd_whitedetective3_120422.txd" ) ;
    SOLS_AddCharModel(303, 20278, "faction_skins/lssd/det/lssd_whtcaptaindetective_120422.dff", "faction_skins/lssd/det/lssd_whtcaptaindetective_120422.txd" ) ;
    */

    /*
    // lssd general
    SOLS_AddCharModel(283, 20283, "faction_skins/lssd/lssd_blackdeputy_120422.dff", "faction_skins/lssd/lssd_blackdeputy_120422.txd" ) ;
    SOLS_AddCharModel(283, 20284, "faction_skins/lssd/lssd_blackdeputy2_120422.dff", "faction_skins/lssd/lssd_blackdeputy2_120422.txd" ) ;
    SOLS_AddCharModel(283, 20285, "faction_skins/lssd/lssd_hispanicdeputy_120422.dff", "faction_skins/lssd/lssd_hispanicdeputy_120422.txd" ) ;
    SOLS_AddCharModel(283, 20286, "faction_skins/lssd/lssd_hispanicdeputy2_120422.dff", "faction_skins/lssd/lssd_hispanicdeputy2_120422.txd" ) ;
    SOLS_AddCharModel(283, 20287, "faction_skins/lssd/lssd_sgthispanic_120422.dff", "faction_skins/lssd/lssd_sgthispanic_120422.txd" ) ;
    SOLS_AddCharModel(283, 20288, "faction_skins/lssd/lssd_sgtwhite_120422.dff", "faction_skins/lssd/lssd_sgtwhite_120422.txd" ) ;
    SOLS_AddCharModel(283, 20289, "faction_skins/lssd/lssd_sgtwhite2_120422.dff", "faction_skins/lssd/lssd_sgtwhite2_120422.txd" ) ;
    SOLS_AddCharModel(283, 20290, "faction_skins/lssd/lssd_sgtwhite3_120422.dff", "faction_skins/lssd/lssd_sgtwhite3_120422.txd" ) ;
    SOLS_AddCharModel(283, 20291, "faction_skins/lssd/lssd_whitedeputy_120422.dff", "faction_skins/lssd/lssd_whitedeputy_120422.txd" ) ;
    */

    // lspd swat
    SOLS_AddCharModel(306, 20292, "faction_skins/lspd/swat/lspd_swatfb_190422.dff", "faction_skins/lspd/swat/lspd_swatfb_190422.txd" ) ;
    SOLS_AddCharModel(306, 20293, "faction_skins/lspd/swat/lspd_swatfw_190422.dff", "faction_skins/lspd/swat/lspd_swatfw_190422.txd" ) ;
    SOLS_AddCharModel(280, 20294, "faction_skins/lspd/swat/lspd_swatmb_190422.dff", "faction_skins/lspd/swat/lspd_swatmb_190422.txd" ) ;
    SOLS_AddCharModel(280, 20295, "faction_skins/lspd/swat/lspd_swatmw_190422.dff", "faction_skins/lspd/swat/lspd_swatmw_190422.txd" ) ;

    // DEA
    SOLS_AddCharModel(166, 20296, "faction_skins/dea/vance_dea.dff", "faction_skins/dea/vance_dea.txd" ) ;
    SOLS_AddCharModel(165, 20297, "faction_skins/dea/lapd1.dff", "faction_skins/dea/lapd1.txd" ) ;
    SOLS_AddCharModel(165, 20298, "faction_skins/dea/lvpd1.dff", "faction_skins/dea/lvpd1.txd" ) ;
    SOLS_AddCharModel(41, 20299, "faction_skins/dea/hfyst.dff", "faction_skins/dea/hfyst.txd" ) ;

    // New LSPD
    SOLS_AddCharModel(190, 20300, "faction_skins/lspd/c/bfypdc1.dff", "faction_skins/lspd/c/bfypdc1.txd");
    SOLS_AddCharModel(190, 20301, "faction_skins/lspd/c/bfypdc2.dff", "faction_skins/lspd/c/bfypdc2.txd");
    SOLS_AddCharModel(284, 20302, "faction_skins/lspd/c/bmypdc1.dff", "faction_skins/lspd/c/bmypdc1.txd");
    SOLS_AddCharModel(284, 20303, "faction_skins/lspd/c/bmypdc2.dff", "faction_skins/lspd/c/bmypdc2.txd");
    SOLS_AddCharModel(284, 20304, "faction_skins/lspd/c/bmypdc3.dff", "faction_skins/lspd/c/bmypdc3.txd");
    SOLS_AddCharModel(284, 20305, "faction_skins/lspd/c/bmypdc4.dff", "faction_skins/lspd/c/bmypdc4.txd");
    SOLS_AddCharModel(284, 20306, "faction_skins/lspd/c/bmypdc5.dff", "faction_skins/lspd/c/bmypdc5.txd");
    SOLS_AddCharModel(284, 20307, "faction_skins/lspd/c/bmypdc6.dff", "faction_skins/lspd/c/bmypdc6.txd");
    SOLS_AddCharModel(41,  20308, "faction_skins/lspd/c/hfypdc1.dff", "faction_skins/lspd/c/hfypdc1.txd");
    SOLS_AddCharModel(275, 20309, "faction_skins/lspd/c/hmypdc1.dff", "faction_skins/lspd/c/hmypdc1.txd");
    SOLS_AddCharModel(275, 20310, "faction_skins/lspd/c/hmypdc2.dff", "faction_skins/lspd/c/hmypdc2.txd");
    SOLS_AddCharModel(275, 20311, "faction_skins/lspd/c/hmypdc3.dff", "faction_skins/lspd/c/hmypdc3.txd");
    SOLS_AddCharModel(275, 20312, "faction_skins/lspd/c/hmypdc4.dff", "faction_skins/lspd/c/hmypdc4.txd");
    SOLS_AddCharModel(275, 20313, "faction_skins/lspd/c/hmypdc5.dff", "faction_skins/lspd/c/hmypdc5.txd");
    SOLS_AddCharModel(275, 20314, "faction_skins/lspd/c/hmypdc6.dff", "faction_skins/lspd/c/hmypdc6.txd");
    SOLS_AddCharModel(141, 20315, "faction_skins/lspd/c/ofypdc1.dff", "faction_skins/lspd/c/ofypdc1.txd");
    SOLS_AddCharModel(280, 20316, "faction_skins/lspd/c/omypdc1.dff", "faction_skins/lspd/c/omypdc1.txd");
    SOLS_AddCharModel(280, 20317, "faction_skins/lspd/c/omypdc2.dff", "faction_skins/lspd/c/omypdc2.txd");
    SOLS_AddCharModel(280, 20318, "faction_skins/lspd/c/omypdc3.dff", "faction_skins/lspd/c/omypdc3.txd");
    SOLS_AddCharModel(211, 20319, "faction_skins/lspd/c/wfypdc1.dff", "faction_skins/lspd/c/wfypdc1.txd");
    SOLS_AddCharModel(211, 20320, "faction_skins/lspd/c/wfypdc2.dff", "faction_skins/lspd/c/wfypdc2.txd");
    SOLS_AddCharModel(211, 20321, "faction_skins/lspd/c/wfypdc3.dff", "faction_skins/lspd/c/wfypdc3.txd");
    SOLS_AddCharModel(280, 20322, "faction_skins/lspd/c/wmopdc1.dff", "faction_skins/lspd/c/wmopdc1.txd");
    SOLS_AddCharModel(280, 20323, "faction_skins/lspd/c/wmopdc2.dff", "faction_skins/lspd/c/wmopdc2.txd");
    SOLS_AddCharModel(280, 20324, "faction_skins/lspd/c/wmypdc1.dff", "faction_skins/lspd/c/wmypdc1.txd");
    SOLS_AddCharModel(280, 20325, "faction_skins/lspd/c/wmypdc2.dff", "faction_skins/lspd/c/wmypdc2.txd");
    SOLS_AddCharModel(280, 20326, "faction_skins/lspd/c/wmypdc3.dff", "faction_skins/lspd/c/wmypdc3.txd");
    SOLS_AddCharModel(280, 20327, "faction_skins/lspd/c/wmypdc4.dff", "faction_skins/lspd/c/wmypdc4.txd");
    SOLS_AddCharModel(280, 20328, "faction_skins/lspd/c/wmypdc5.dff", "faction_skins/lspd/c/wmypdc5.txd");
    SOLS_AddCharModel(280, 20329, "faction_skins/lspd/c/wmypdc6.dff", "faction_skins/lspd/c/wmypdc6.txd");
    SOLS_AddCharModel(280, 20330, "faction_skins/lspd/c/wmypdc7.dff", "faction_skins/lspd/c/wmypdc7.txd");
    SOLS_AddCharModel(190, 20331, "faction_skins/lspd/mary/bfypdm1.dff", "faction_skins/lspd/mary/bfypdm1.txd"); 
    SOLS_AddCharModel(284, 20332, "faction_skins/lspd/mary/bmypdm1.dff", "faction_skins/lspd/mary/bmypdm1.txd"); 
    SOLS_AddCharModel(211, 20333, "faction_skins/lspd/mary/wfypdm1.dff", "faction_skins/lspd/mary/wfypdm1.txd"); 
    SOLS_AddCharModel(280, 20334, "faction_skins/lspd/mary/wmypdm1.dff", "faction_skins/lspd/mary/wmypdm1.txd"); 
    SOLS_AddCharModel(280, 20335, "faction_skins/lspd/pilot/wmypdplt.dff", "faction_skins/lspd/pilot/wmypdplt.txd"); 
    SOLS_AddCharModel(280, 20336, "faction_skins/lspd/a/wmypda1.dff", "faction_skins/lspd/a/wmypda1.txd");

    // new gov.

    //main
    //SOLS_AddCharModel(186, 20337, "faction_skins/gov/gov_johnkray.dff", "faction_skins/gov/gov_johnkray.txd");
    SOLS_AddCharModel(187, 20338, "faction_skins/gov/gov_ryansimmons.dff", "faction_skins/gov/gov_ryansimmons.txd");

    //main politicians
    //SOLS_AddCharModel(148, 20339, "faction_skins/gov/maingov/gov_blackfemale.dff", "faction_skins/gov/maingov/gov_blackfemale.txd");
    SOLS_AddCharModel(147, 20340, "faction_skins/gov/maingov/gov_politician1.dff", "faction_skins/gov/maingov/gov_politician1.txd");
    SOLS_AddCharModel(147, 20341, "faction_skins/gov/maingov/gov_politician2.dff", "faction_skins/gov/maingov/gov_politician2.txd");
    SOLS_AddCharModel(141, 20342, "faction_skins/gov/maingov/gov_politician3.dff", "faction_skins/gov/maingov/gov_politician3.txd");
    SOLS_AddCharModel(147, 20343, "faction_skins/gov/maingov/gov_politician4.dff", "faction_skins/gov/maingov/gov_politician4.txd");
    SOLS_AddCharModel(147, 20344, "faction_skins/gov/maingov/gov_politician5.dff", "faction_skins/gov/maingov/gov_politician5.txd");
    //SOLS_AddCharModel(141, 20345, "faction_skins/gov/maingov/gov_politician6.dff", "faction_skins/gov/maingov/gov_politician6.txd");
    SOLS_AddCharModel(141, 20346, "faction_skins/gov/maingov/gov_politician7.dff", "faction_skins/gov/maingov/gov_politician7.txd");
    SOLS_AddCharModel(141, 20347, "faction_skins/gov/maingov/gov_politician8.dff", "faction_skins/gov/maingov/gov_politician8.txd");
    //SOLS_AddCharModel(141, 20348, "faction_skins/gov/maingov/gov_politician9.dff", "faction_skins/gov/maingov/gov_politician9.txd");
    //SOLS_AddCharModel(141, 20349, "faction_skins/gov/maingov/gov_politician10.dff", "faction_skins/gov/maingov/gov_politician10.txd");
    SOLS_AddCharModel(147, 20350, "faction_skins/gov/maingov/gov_politician11.dff", "faction_skins/gov/maingov/gov_politician11.txd");
    SOLS_AddCharModel(147, 20351, "faction_skins/gov/maingov/gov_politician12.dff", "faction_skins/gov/maingov/gov_politician12.txd");

    // judges
    //SOLS_AddCharModel(147, 20352, "faction_skins/gov/judiciary/gov_johnwilson.dff", "faction_skins/gov/judiciary/gov_johnwilson.txd");
    //SOLS_AddCharModel(147, 20353, "faction_skins/gov/judiciary/gov_ericbreyer.dff", "faction_skins/gov/judiciary/gov_ericbreyer.txd");

    // public works
    SOLS_AddCharModel(303, 20354, "faction_skins/gov/pubworks/govpw_blackmaintenance.dff", "faction_skins/gov/pubworks/govpw_blackmaintenance.txd");
    SOLS_AddCharModel(303, 20355, "faction_skins/gov/pubworks/govpw_blackoperator1.dff", "faction_skins/gov/pubworks/govpw_blackoperator1.txd");
    SOLS_AddCharModel(141, 20356, "faction_skins/gov/pubworks/govpw_femaleoperator.dff", "faction_skins/gov/pubworks/govpw_femaleoperator.txd");
    SOLS_AddCharModel(303, 20357, "faction_skins/gov/pubworks/govpw_whitemaintenance.dff", "faction_skins/gov/pubworks/govpw_whitemaintenance.txd");
    SOLS_AddCharModel(303, 20358, "faction_skins/gov/pubworks/govpw_whiteoperator.dff", "faction_skins/gov/pubworks/govpw_whiteoperator.txd");

    // transport officers
    SOLS_AddCharModel(304, 20359, "faction_skins/gov/transport/govdot_blackofficer.dff", "faction_skins/gov/transport/govdot_blackofficer.txd");
    SOLS_AddCharModel(309, 20360, "faction_skins/gov/transport/govdot_femaleofficer.dff", "faction_skins/gov/transport/govdot_femaleofficer.txd");
    SOLS_AddCharModel(304, 20361, "faction_skins/gov/transport/govdot_whiteofficer.dff", "faction_skins/gov/transport/govdot_whiteofficer.txd");

    // LoadDynamicFactionSkins();

    // -- end faction skins
    // DONT PUT ANY MORE FACTION SKINS HERE!!!!
    // USE THE NEW DYNAMIC SYSTEM INGAME INSTEAD (NOT ADDED YET OOPS)


    AddSimpleModel(-1, 19325, LOGIN_TR_ALPHAS, "LoginTrailer/tr_alphas.dff", "LoginTrailer/tr_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LOGIN_TR_BASE, "LoginTrailer/tr_base.dff", "LoginTrailer/tr_base.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LOGIN_TR_BITS, "LoginTrailer/tr_bits.dff", "LoginTrailer/tr_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LOGIN_TR_INTBITS, "LoginTrailer/tr_intbits.dff", "LoginTrailer/tr_intbits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LOGIN_TR_MAIN, "LoginTrailer/tr_main.dff", "LoginTrailer/tr_main.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LOGIN_TR_STUDIOLIGHTSET, "LoginTrailer/tr_studiolightset.dff", "LoginTrailer/tr_studiolightset.txd");

    CreateLoginScreen();

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, NEW_AJAIL_MODEL, "ryhes/ajail.dff", "ryhes/ajail.txd");

    AddSimpleModel(-1,  5265, PDS_TELEWIRES, "pds_telewires.dff", "pds_telewires.txd");
	CreateDynamicObject(PDS_TELEWIRES, 2678.9688, -2003.8125, 21.5000, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //pds_telewires

	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, PDS_SKATEPARK, "pds_skatepark.dff", "pds_skatepark.txd");
	CreateDynamicObject(PDS_SKATEPARK, 2758.5391, -2104.8984, 18.2813, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //pds_skatepark

    // Kelly Park Telewires (train bridge) laejeffers06alphas
    AddSimpleModel(-1, 5265, KELLY_WIRES, "reyo/kellywires.dff", "reyo/kellywires.txd");
    CreateDynamicObject(KELLY_WIRES, 2263.52, -1312.63, 37.08, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); // kelly wires

    // AOD
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, AOD_mc_bits, "AOD/mc_bits.dff", "AOD/mc_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, AOD_mc_cage, "AOD/mc_cage.dff", "AOD/mc_cage.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, AOD_mc_exterior, "AOD/mc_exterior.dff", "AOD/mc_exterior.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, AOD_mc_gardoor, "AOD/mc_gardoor.dff", "AOD/mc_gardoor.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, AOD_mc_interior, "AOD/mc_interior.dff", "AOD/mc_interior.txd");
    // AOD
    CreateDynamicObject(AOD_mc_bits, 1330.3750, -1793.0781, 14.3329, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //mc_bits
    CreateDynamicObject(AOD_mc_cage, 1334.2303, -1782.1356, 14.2848, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //mc_cage
    CreateDynamicObject(AOD_mc_exterior, 1330.3750, -1793.0781, 22.9688, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //mc_exterior
    CreateDynamicObject(AOD_mc_gardoor, 1325.6749, -1794.2174, 14.1724, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //mc_gardoor
    CreateDynamicObject(AOD_mc_interior, 1330.3750, -1793.0781, 14.3329, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //mc_interior

    // IW TAXI
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DROSJE_taxi_base, "DROSJE/taxi_base.dff", "DROSJE/taxi_base.txd"); // modified iw_hoodroad.dff !!
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DROSJE_taxi_bits, "DROSJE/taxi_bits.dff", "DROSJE/taxi_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, DROSJE_taxi_bits_2, "DROSJE/taxi_bits_2.dff", "DROSJE/taxi_bits_2.txd");
    AddSimpleModel(-1, 19478, DROSJE_taxi_alphas, "DROSJE/taxi_alphas.dff", "DROSJE/taxi_alphas.txd");

    // TAXI DEPOT, IDLEWOOD
    CreateObject(DROSJE_taxi_base, 2021.6562, -1810.7264, 18.6016, 0.0000, 0.0000, 0.0000, 800.0); //DROSJE/taxi_base.dff REPLACES IW_HOODROAD.DFF !!
    CreateDynamicObject(DROSJE_taxi_bits, 2044.8703, -1830.7224, 16.1679, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //DROSJE/taxi_bits.dff
    CreateDynamicObject(DROSJE_taxi_bits_2, 2015.9934, -1822.3124, 12.5233, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //DROSJE/taxi_bits_2.dff
    CreateDynamicObject(DROSJE_taxi_alphas, 2029.4860, -1830.0266, 18.0213, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //DROSJE/taxi_alphas.dff

    // * ELS CARWASH / GARAGE
    AddSimpleModel(-1, 19478, ELScw_ELScw_alphas, "ELScw/ELScw_alphas.dff", "ELScw/ELScw_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_autoshpbloklae, "ELScw/ELScw_autoshpbloklae2.dff", "ELScw/ELScw_ext.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_cineblock1lae2, "ELScw/ELScw_cineblock1lae2.dff", "ELScw/ELScw_ext.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_cinemarklae2, "ELScw/ELScw_cinemarklae2.dff", "ELScw/ELScw_ext.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_int, "ELScw/ELScw_int.dff", "ELScw/ELScw_int.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_props_1, "ELScw/ELScw_props_1.dff", "ELScw/ELScw_props_1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ELScw_ELScw_props_2, "ELScw/ELScw_props_2.dff", "ELScw/ELScw_props_2.txd");
  	// ELS CARWASH / GARAGE
    CreateDynamicObject(ELScw_ELScw_alphas, 2487.1490, -1471.5900, 25.0890, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //ELScw/ELScw_alphas
    CreateDynamicObject(ELScw_ELScw_autoshpbloklae, 2490.9060, -1474.3440, 27.3440, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ELScw/ELScw_autoshpbloklae2
    CreateDynamicObject(ELScw_ELScw_cineblock1lae2, 2459.3590, -1486.1250, 34.1640, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ELScw/ELScw_cineblock1lae2
    CreateDynamicObject(ELScw_ELScw_cinemarklae2, 2492.3200, -1484.8050, 28.2660, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ELScw/ELScw_cinemarklae2
    CreateDynamicObject(ELScw_ELScw_int, 2487.6820, -1472.9780, 24.9210, 0.0000, 0.0000, 0.0000, -1, 0, -1, 250.00, 250.00); //ELScw/ELScw_int
    CreateDynamicObject(ELScw_ELScw_props_1, 2487.5320, -1472.6920, 24.9710, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //ELScw/ELScw_props_1
    CreateDynamicObject(ELScw_ELScw_props_2, 2491.5960, -1483.6870, 29.2670, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //ELScw_props_2

    // FAST FOODs ENEX
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, fastfood_cluck, "fastfood/cluck.dff", "fastfood/cluck.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, fastfood_cluck2, "fastfood/cluck2.dff", "fastfood/cluck2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, fastfood_pizzastacks, "fastfood/pizzastacks.dff", "fastfood/pizzastacks.txd");

    AddSimpleModel(-1, 19325, fastfood_cluck_alphas, "fastfood/cluck_alphas.dff", "fastfood/cluck.txd");
    AddSimpleModel(-1, 19325, fastfood_cluck2_alphas, "fastfood/cluck2_alphas.dff", "fastfood/cluck2.txd");
    AddSimpleModel(-1, 19325, fastfood_pizzastacks_alphas, "fastfood/pizzastacks_alphas.dff", "fastfood/pizzastacks.txd");

    AddSimpleModel(-1, 19479, fastfood_donutla_enex, "fastfood/donutla_enex.dff", "fastfood/donutla_enex.txd");
    AddSimpleModel(-1, 19479, fastfood_donutla_bits, "fastfood/donutla_bits.dff", "fastfood/donutla_bits.txd");

    // FAST FOODS
    CreateDynamicObject(fastfood_cluck, 2402.2970, -1503.6120, 29.0500, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //fastfood/cluck
    CreateObject(fastfood_cluck2, 2385.1875, -1906.5156, 18.4453, 0.0000, 0.0000, 0.0000, 800.00); //fastfood/cluck2
    CreateObject(fastfood_pizzastacks, 2112.9375, -1797.0938, 19.3359, 0.0000, 0.0000, 0.0000, 800.00); //fastfood/pizzastacks

    CreateDynamicObject(fastfood_cluck_alphas, 2419.0390, -1493.4800, 24.9900, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //fastfood/cluck_alphas
    CreateDynamicObject(fastfood_cluck2_alphas, 2381.4150, -1899.8350, 14.5060, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //fastfood/cluck2_alphas
    CreateDynamicObject(fastfood_pizzastacks_alphas, 2103.3430, -1794.5850, 14.5440, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //fastfood/pizzastacks_alphas

    CreateObject(fastfood_donutla_enex, 1014.0234, -1361.4609, 20.3516, 0.0000, 0.0000, 0.0000, 800.0); //fastfood/donutla_enex
    CreateDynamicObject(fastfood_donutla_bits, 1036.5775, -1348.8992, 14.6441, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //fastfood/donutla_bits


    // DEAD END EC GANG HOUSE
    AddSimpleModel(-1, 19478, ghouse_ghouse_alpha, "ghouse/ghouse_alpha.dff", "ghouse/ghouse_alpha.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ghouse_ghouse_in, "ghouse/ghouse_in.dff", "ghouse/ghouse_in.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ghouse_ghouse_int_bits, "ghouse/ghouse_int_bits.dff", "ghouse/ghouse_int_bits.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, ghouse_ghouse_out, "ghouse/ghouse_out.dff", "ghouse/ghouse_out.txd");

    // DEAD END EC GHOUSE
    CreateDynamicObject(ghouse_ghouse_alpha, 1755.4900, -2125.7422, 14.4949, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //ghouse_alpha
    CreateDynamicObject(ghouse_ghouse_in, 1759.9336, -2136.0400, 15.2843, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //ghouse_in
    CreateDynamicObject(ghouse_ghouse_int_bits, 1759.8796, -2130.9819, 14.1657, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //ghouse_int_bits
    CreateDynamicObject(ghouse_ghouse_out, 1759.9336, -2136.0400, 15.2843, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ghouse_out

    // IMPOUND LOT LS
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, impoundnew, "Impoundlot/impoundnew.dff", "Impoundlot/impoundnew.txd");
    // IMPOUNDLOT LS
    CreateDynamicObject(impoundnew, 1086.1781, -1756.4338, 14.9353, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //Impoundlot/impoundnew.dff

    // RANCHO APT COMPLEX
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_ext, "RCHCOMPLEX/rchcomplex_ext.dff", "RCHCOMPLEX/rchcomplex_ext.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_int, "RCHCOMPLEX/rchcomplex_int.dff", "RCHCOMPLEX/rchcomplex_int.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_int, "RCHCOMPLEX/rchcomplex_intNEW.dff", "RCHCOMPLEX/rchcomplex_int.txd");
    AddSimpleModel(-1, 19478, RCHCOMPLEX_rchcomplex_alphas, "RCHCOMPLEX/rchcomplex_alphas.dff", "RCHCOMPLEX/rchcomplex_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_apt_1, "RCHCOMPLEX/bits/rchcomplex_apt_1.dff", "RCHCOMPLEX/bits/rchcomplex_apt_1.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_apt_2, "RCHCOMPLEX/bits/rchcomplex_apt_2.dff", "RCHCOMPLEX/bits/rchcomplex_apt_2.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_apt_3, "RCHCOMPLEX/bits/rchcomplex_apt_3.dff", "RCHCOMPLEX/bits/rchcomplex_apt_3.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_apt_4, "RCHCOMPLEX/bits/rchcomplex_apt_4.dff", "RCHCOMPLEX/bits/rchcomplex_apt_4.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHCOMPLEX_rchcomplex_mBits, "RCHCOMPLEX/bits/rchcomplex_mBits.dff", "RCHCOMPLEX/bits/rchcomplex_mBits.txd");


    // RANCHO APT COMPLEX
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_ext, 1983.4536, -2085.3794, 18.6397, 0.0000, 0.0000, 0.0000, -1, -1, -1, 800.00, 800.00); //RCHCOMPLEX/rchcomplex_ext
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_int, 1981.1716, -2085.5361, 18.3002, 0.0000, 0.0000, 0.0000, -1, -1, -1, 300.00, 300.00); //RCHCOMPLEX/rchcomplex_int
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_alphas, 1983.4536, -2085.3794, 18.6397, 0.0000, 0.0000, 0.0000, -1, -1, -1, 300.00, 300.00); //RCHCOMPLEX/rchcomplex_alphas
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_apt_1, 1976.3156, -2076.7300, 20.1810, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.00, 200.00); //RCHCOMPLEX/bits/rchcomplex_apt_1
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_apt_2, 1988.4525, -2073.3555, 20.3897, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.00, 200.00); //RCHCOMPLEX/bits/rchcomplex_apt_2
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_apt_3, 1976.0215, -2096.8813, 20.4050, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.00, 200.00); //RCHCOMPLEX/bits/rchcomplex_apt_3
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_apt_4, 1988.0159, -2078.3999, 16.7134, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.00, 200.00); //RCHCOMPLEX/bits/rchcomplex_apt_4
    CreateDynamicObject(RCHCOMPLEX_rchcomplex_mBits, 1984.7211, -2089.6006, 16.6210, 0.0000, 0.0000, 0.0000, -1, -1, -1, 200.00, 200.00); //RCHCOMPLEX/bits/rchcomplex_mBits

    CreateDynamicObject(16779, 1989.1481, -2073.3212, 23.9118, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ufo_light02 rchcomplex
    CreateDynamicObject(16779, 1976.2082, -2076.7529, 23.9118, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ufo_light02 rchcomplex
    CreateDynamicObject(16779, 1975.7377, -2096.5148, 23.9118, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ufo_light02 rchcomplex
    CreateDynamicObject(16779, 1992.5385, -2077.2844, 19.8994, 0.0000, 0.0000, 0.0000, -1, -1, -1, 50.00, 50.00); //ufo_light02 rchcomplex

    // RANCHO SWAPMEET
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHSWP_rancho_swm, "RCHSWP/rancho_swm.dff", "RCHSWP/rancho_swm.txd");
    AddSimpleModel(-1, 19478, RCHSWP_rancho_swm_alphas, "RCHSWP/rancho_swm_alphas.dff", "RCHSWP/rancho_swm_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, RCHSWP_rancho_swm_bits, "RCHSWP/rancho_swm_bits.dff", "RCHSWP/rancho_swm_bits.txd");

    // RANCHO SWAPMEET
    CreateDynamicObject(RCHSWP_rancho_swm, 2031.2007, -2084.6394, 14.1897, 0.0000, 0.0000, 0.0000, -1, -1, -1, 800.00, 800.00); //RCHSWP/rancho_swm
    CreateDynamicObject(RCHSWP_rancho_swm_alphas, 2019.4980, -2089.7322, 20.2064, 0.0000, 0.0000, 0.0000, -1, -1, -1, 300.00, 300.00); //RCHSWP/rancho_swm_alphas
    CreateDynamicObject(RCHSWP_rancho_swm_bits, 2052.7512, -2086.9336, 15.3701, 0.0000, 0.0000, 0.0000, -1, -1, -1, 300.00, 300.00); //RCHSWP/rancho_swm_bits

    // MISC changes 26/02/22
   	CreateDynamicObject(16780, 2485.8254, -1485.6553, 31.6249, 0.0000, 0.0000, 0.0000, -1, -1, -1, 25.00, 25.00); //ufo_light03
    CreateDynamicObject(1492, 2497.1840, -1488.5794, 28.0216, 0.0000, 0.0000, 0.0000, -1, -1, -1, 100.00, 100.00); //Gen_doorINT02 ext
    CreateDynamicObject(1492, 2486.1430, -1488.5869, 28.0216, 0.0000, 0.0000, 0.0000, -1, -1, -1, 100.00, 100.00); //Gen_doorINT02 ext
    CreateDynamicObject(1492, 2492.7202, -1479.7751, 28.0316, 0.0000, 0.0000, 180.0000, -1, -1, -1, 100.00, 100.00); //Gen_doorINT02 int

    // New Kelly Park optimizations March 3rd 2022
    CreateObject(REYO_KYPARK, 2219.0134, -1342.2681, 23.0016, 0.0000, 0.0000, 0.0000, 600.0); //ky_park
    CreateDynamicObject(REYO_KYBITS, 2219.1187, -1342.4961, 25.2146, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ky_bits
    CreateDynamicObject(REYO_KYALPHA, 2210.6753, -1318.4878, 23.9770, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ky_alpha
    CreateDynamicObject(KY_VALPHA, 2210.6753, -1318.4878, 23.9770, 0.0000, 0.0000, 0.0000, -1, 0, -1, 150.00, 150.00); //ky_valpha
    CreateDynamicObject(KY_LAEALPHA3, 2182.2891, -1324.7500, 28.6016, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ky_laealpha3

    // Replacement tree at SAN
    CreateDynamicObject(700, 1807.62, -1625.68, 13.05,   0.00, 0.00, 322.08);

    // NEW IDLEWOOD TELEWIRES by Ryhes <3
    AddSimpleModel(-1, 5633, IW_Telewires, "ryhes/iw_telewires.dff", "ryhes/iw_telewires.txd");
    new twires = CreateDynamicObject(IW_Telewires, 2089.3594, -1643.9297, 18.2188,   0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
    printf("Idle Wires: %d", twires);
  
    // New el corona courts telewires by Spooks <3
    AddSimpleModel(-1, 4984, Jandro4_Telewires, "ryhes/jandro4wires.dff", "ryhes/jandro4wires.txd");
    twires = CreateDynamicObject(Jandro4_Telewires, 1880.7109, -2112.6328, 21.2578,   0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
    printf("EC Wires: %d", twires);

    AddSimpleModel(-1, 19325, -25268, "sporky/sirens/lightbeam.dff", "sporky/sirens/lightbeam.txd");
    
    // Test
    AddSimpleModel(-1, 18641, -25269, "sporky/props/pdtorch.dff", "sporky/props/pdtorch.txd");
    AddSimpleModel(-1, 18641, -25270, "sporky/props/pdtorch_on.dff", "sporky/props/pdtorch.txd");

    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, -25280, "sporky/ap/m16gl.dff", "sporky/ap/m16gl.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, -25281, "sporky/ap/p90.dff", "sporky/ap/p90.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, -25282, "sporky/ap/p90big.dff", "sporky/ap/p90.txd");

    AddSimpleModel(-1, 18641, -25283, "sporky/ap/turret_base2.dff", "sporky/ap/turret.txd");
    AddSimpleModel(-1, 18641, -25284, "sporky/ap/turret_minigun3.dff", "sporky/ap/turret.txd");

    // Temp gov stage thing
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, -5353, "sporky/wip/gov_stage.dff", "sporky/wip/gov_stage.txd");

    // Unity Temp Ryhes
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  UNITY_TEMP_INT,  "reyo/unitystation_int.dff",   "reyo/unitystation_int.txd" );
    AddSimpleModel(-1, 19325,  UNITY_TEMP_WIN,  "reyo/unityst_intwin.dff",   "reyo/unitystation_int.txd" );

    CreateDynamicObject(UNITY_TEMP_INT, 1762.4227, -1751.3560, 17.5944,   0.00, 0.00, 0.00, -1, -1, -1, 200.00, 200.00);
    CreateDynamicObject(UNITY_TEMP_WIN, 1762.3652, -1751.3559, 20.0430,   0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
    CreateDynamicObject(UNITY_TEMP_WIN, 1762.3652, -1751.3559, -10.1126,   0.00, 0.00, 0.00, -1, -1, -1, 100.00, 100.00);

    // Motorcycle blocks
    CreateDynamicObject(1345, 2581.92, -1462.28, 23.74,   0.00, 0.00, -86.88);
    CreateDynamicObject(1345, 2582.54, -1464.83, 23.74,   0.00, 0.00, -103.26);
    CreateDynamicObject(1440, 2579.09, -1458.60, 23.49,   0.00, 0.00, -181.26);
    CreateDynamicObject(3594, 2534.41, -1704.93, 13.18,   0.00, 0.00, -19.74);
    CreateDynamicObject(1438, 2533.09, -1701.21, 12.40,   0.00, 0.00, -96.54);
    CreateDynamicObject(1441, 2282.21, -1082.97, 47.32,   0.00, 0.00, -117.24);
    CreateDynamicObject(1440, 2284.10, -1081.14, 47.14,   0.00, 0.00, 164.58);
    CreateDynamicObject(1343, 2281.50, -1081.74, 47.47,   0.00, 0.00, 0.00);
    CreateDynamicObject(1343, 2279.81, -1082.36, 47.47,   0.00, 0.00, -59.28);
    CreateDynamicObject(1328, 2485.95, -1768.92, 12.84,   178.00, 90.00, -20.04);
    CreateDynamicObject(1328, 2484.79, -1769.70, 12.84,   178.00, 90.00, -168.12);
    CreateDynamicObject(1440, 2485.98, -1771.00, 13.04,   0.00, 0.00, 81.54);
    CreateDynamicObject(1345, 2504.86, -1880.06, 13.31,   0.00, 0.00, -21.48);
    CreateDynamicObject(1358, 2297.704, -1695.423, 13.729, 0.000, 0.000, -64.899); // Kate_Mercer (1358)
    CreateDynamicObject(849, 2236.754, -2058.564, 12.954, 0.000, 0.000, 33.099); // Kate_Mercer (849)
    CreateDynamicObject(19869, 2237.922, -2056.780, 12.577, 13.400, 0.899, 24.500); // Kate_Mercer (19869)
    CreateDynamicObject(850, 2237.618, -2056.165, 13.478, 0.100, 79.400, -44.300); // Kate_Mercer (850)
    CreateDynamicObject(1441, 2052.259, -1788.015, 13.343, 2.999, 0.000, 88.599); // Kate_Mercer (1441)
    CreateDynamicObject(1441, 2053.976, -1771.414, 13.192, -2.199, 0.000, -90.800); // Kate_Mercer (1441)
    CreateDynamicObject(1345, 2053.085, -1769.744, 13.324, 0.000, 0.000, 74.000); // Kate_Mercer (1345)
    CreateDynamicObject(1409, 2052.270, -1784.757, 13.008, 2.200, 87.900, 14.900); // Kate_Mercer (1409)
    CreateDynamicObject(1409, 2053.777, -1788.172, 12.716, 0.000, 0.000, -49.099); // Kate_Mercer (1409)
    CreateDynamicObject(1345, 2053.159, -1786.246, 13.411, -2.099, 0.000, -67.199); // Kate_Mercer (1345)

    // Biskit Black Magic Strip Club (Player Requested)
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,  REQ_BISKIT_BLACKMAGIC,  "reqs/biskit/blackMagic.dff",   "reqs/biskit/blackMagic.txd" );
    CreateDynamicObject(REQ_BISKIT_BLACKMAGIC, 1375.2734, -1452.3984, 23.0391, 0.0000, 0.0000, 0.0000, -1, -1, -1, 600.00, 600.00);

    // NEW SAN PEDRO (OPTIMIZED + PRELIGHT + SHERIFF STATION)
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_1,       "sanpedro/sanpedro_land_new.dff", "sanpedro/sanpedro_land.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_2,       "sanpedro/sanpedro_bits_new.dff", "sanpedro/sanpedro_bits.txd");
    AddSimpleModel(-1, 17863, 				 SANPEDRO_3,       "sanpedro/sanpedro_alphas_new.dff", "sanpedro/sanpedro_alphas.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_4,       "sanpedro/sanpedro_road.dff", "sanpedro/sanpedro_road.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, SANPEDRO_SOLIDS,       "sanpedro/sanpedro_solids.dff", "sanpedro/sanpedro_alphas.txd");
    AddSimpleModel(-1, 11680, 				 SANPEDRO_VALPHA,       "sanpedro/sanpedro_vAlpha.dff", "sanpedro/sanpedro_alphas.txd");
    
    CreateObject(SANPEDRO_1, 2510.4770, -1543.2730, 21.7110, 0.0000, 0.0000, 0.0000, 800.00); //sanpedro_land
    CreateDynamicObject(SANPEDRO_2, 2510.4770, -1543.2730, 21.7110, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //sanpedro_bits
    CreateDynamicObject(SANPEDRO_3, 2467.4609, -1538.2500, 27.6016, 0.0000, 0.0000, 0.0000, -1, 0, -1, 600.00, 600.00); //sanpedro_alphas
    CreateObject(SANPEDRO_4, 2490.9063, -1504.3281, 22.9219, 0.0000, 0.0000, 0.0000, 800.00); //sanpedro_road
    CreateDynamicObject(SANPEDRO_SOLIDS, 2467.4609, -1538.2500, 27.6016, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //sanpedro_solids
    CreateDynamicObject(SANPEDRO_VALPHA, 2467.4609, -1538.2500, 27.6016, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //sanpedro_vAlpha

    // SAN PEDRO TREES
    CreateDynamicObject(673, 2532.801, -1545.798, 22.436, 0.000, 0.000, -86.500); // Spooky (673)
	CreateDynamicObject(673, 2538.562, -1534.280, 22.496, 0.000, 0.000, -81.399); // Spooky (673)
	CreateDynamicObject(673, 2528.840, -1523.429, 22.681, 0.000, 0.000, -58.699); // Spooky (673)
	CreateDynamicObject(673, 2519.461, -1560.969, 22.621, 0.000, 0.000, -100.299); // Spooky (673)
	CreateDynamicObject(673, 2500.833, -1575.084, 22.643, 0.000, 0.000, -96.600); // Spooky (673)
	CreateDynamicObject(673, 2551.468, -1553.899, 22.557, 0.000, 0.000, -89.999); // Spooky (673)

    // EAST LS SHERIFF STATION
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,	SD_ELS_MAIN,		"sdels/sd_els.dff", "sdels/sd_elsPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_ELS_BBRD,		"sdels/sd_billboard_new.dff", "sdels/sd_billboard_PD.txd");
	AddSimpleModel(-1, 17863, 					SD_ELS_WIRE,		"sdels/sd_wires2.dff", "sdels/sd_wiresPD.txd");
    AddSimpleModel(-1, 1523, 					SD_ELS_GATEXL,		"sdels/sd_gatexr.dff", "sdels/sd_gatePD.txd");
    AddSimpleModel(-1, 1523, 					SD_ELS_GATEXR,		"sdels/sd_gatexl.dff", "sdels/sd_gatePD.txd");
    AddSimpleModel(-1, 17863, 					SD_ELS_FLAGS,		"sdels/sd_flags.dff", "sdels/sd_wiresPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_ELS_SIGN,		"sdels/sd_sign.dff", "sdels/sd_elsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_ELS_PSIGN1,		"sdels/sd_parkingsign1.dff", "sdels/sd_elsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_ELS_PSIGN2,		"sdels/sd_parkingsign2.dff", "sdels/sd_elsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_ELS_GATEBOX,		"sdels/sd_gatebox.dff", "sdels/sd_elsPD.txd");
    // NOTE: ^^^^ Objects for this are created in sheriff_els.pwn ^^^^

    // New Laurel Apts by Ryhes
    AddSimpleModel(-1, 19379, LAUREL_M, "LAUREL/elsapt_m.dff", "LAUREL/elsapt_m.txd");
    AddSimpleModel(-1, 19379, LAUREL_INT, "LAUREL/elsapt_int.dff", "LAUREL/elsapt_int.txd");
    AddSimpleModel(-1, 19379, LAUREL_STAIRS, "LAUREL/elsapt_stairs.dff", "LAUREL/elsapt_stairs.txd");
    AddSimpleModel(-1, 19478, LAUREL_ALPHAS, "LAUREL/elsapt_alphas.dff", "LAUREL/elsapt_alphas.txd"); //*
    AddSimpleModel(-1, 19325, LAUREL_WINDOWS, "LAUREL/elsapt_windows.dff", "LAUREL/elsapt_alphas.txd"); //*
    AddSimpleModel(-1, 19379, LAUREL_1F_BITS, "LAUREL/elsapt_1f_1bits.dff", "LAUREL/elsapt_1f_1bits.txd");
    AddSimpleModel(-1, 19379, LAUREL_1F_RUBBLE, "LAUREL/elsapt_1f_rubble.dff", "LAUREL/elsapt_1f_rubble.txd");
    AddSimpleModel(-1, 19379, LAUREL_1F_HALLBITS, "LAUREL/elsapt_1f_hallbits.dff", "LAUREL/elsapt_1f_hallbits.txd");
    AddSimpleModel(-1, 19379, LAUREL_2F_HALLBITS, "LAUREL/elsapt_2f_hallbits.dff", "LAUREL/elsapt_2f_hallbits.txd");
    AddSimpleModel(-1, 19379, LAUREL_3F_HALLBITS, "LAUREL/elsapt_3f_hallbits.dff", "LAUREL/elsapt_3f_hallbits.txd");
    AddSimpleModel(-1, 19379, LAUREL_3F_1BITS, "LAUREL/elsapt_3f_1bits.dff", "LAUREL/elsapt_3f_1bits.txd");
    AddSimpleModel(-1, 19379, LAUREL_3F_2BITS, "LAUREL/elsapt_3f_2bits.dff", "LAUREL/elsapt_3f_2bits.txd");
    AddSimpleModel(-1, 19379, LAUREL_3F_3BITS, "LAUREL/elsapt_3f_3bits.dff", "LAUREL/elsapt_3f_3bits.txd");

    // Laurel
    CreateDynamicObject(LAUREL_M, 2540.8281, -1350.5859, 40.8984, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //els_apts_m
    CreateDynamicObject(LAUREL_INT, 2549.4995, -1411.0126, 34.4984, 0.0000, 0.0000, 0.0000, -1, 0, -1, 200.00, 200.00); //elsapt_int
    CreateDynamicObject(LAUREL_STAIRS, 2548.5571, -1413.7032, 37.6382, 0.0000, 0.0000, 0.0000, -1, 0, -1, 50.00, 50.00); //elsapt_stairs
    CreateDynamicObject(LAUREL_ALPHAS, 2563.0127, -1416.3363, 37.1961, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //elsapt_alphas
    CreateDynamicObject(LAUREL_WINDOWS, 2561.0325, -1409.7738, 33.6966, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //elsapt_windows
    CreateDynamicObject(LAUREL_1F_BITS, 2556.2522, -1407.3519, 33.9761, 0.0000, 0.0000, 0.0000, -1, 0, -1, 30.00, 30.00); //LAUREL/elsapt_1f_1bits
    CreateDynamicObject(LAUREL_1F_RUBBLE, 2545.5181, -1401.5587, 34.4024, 0.0000, 0.0000, 0.0000, -1, 0, -1, 30.00, 30.00); //LAUREL/elsapt_1f_rubble
    CreateDynamicObject(LAUREL_1F_HALLBITS, 2548.2234, -1410.5703, 33.5429, 0.0000, 0.0000, 0.0000, -1, 0, -1, 30.00, 30.00); //LAUREL/elsapt_1f_hallbits
    CreateDynamicObject(LAUREL_2F_HALLBITS, 2548.3008, -1411.6577, 37.1633, 0.0000, 0.0000, 0.0000, -1, 0, -1, 15.00, 15.00); //LAUREL/elsapt_2f_hallbits
    CreateDynamicObject(LAUREL_3F_HALLBITS, 2547.6875, -1411.2302, 40.6159, 0.0000, 0.0000, 0.0000, -1, 0, -1, 25.00, 25.00); //LAUREL/elsapt_3f_hallbits
    CreateDynamicObject(LAUREL_3F_1BITS, 2555.0422, -1407.2258, 41.1124, 0.0000, 0.0000, 0.0000, -1, 0, -1, 15.00, 15.00); //LAUREL/elsapt_3f_1bits
    CreateDynamicObject(LAUREL_3F_2BITS, 2557.2151, -1423.3451, 40.8858, 0.0000, 0.0000, 0.0000, -1, 0, -1, 15.00, 15.00); //LAUREL/elsapt_3f_2bits
    CreateDynamicObject(LAUREL_3F_3BITS, 2539.5249, -1425.2834, 40.3884, 0.0000, 0.0000, 0.0000, -1, 0, -1, 15.00, 15.00); //LAUREL/elsapt_3f_3bits

    // New Spooky billboard/night light fix
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, LAE2_BILLBOARD, "sdels/lae2billbd.dff", "sdels/sd_billboard_new.txd");
    CreateDynamicObject(LAE2_BILLBOARD, 2364.05, -1391.53, 41.35, 0.00, 0.00, 315.00, -1, 0, -1, 450.00, 450.00);

    AddSimpleModel(-1, 1923, -5080, "sporky/wip/metrobillb.dff", "sporky/wip/metrobillb.txd");
    AddSimpleModel(-1, 1923, -5081, "sporky/wip/pdbillb1.dff", "sporky/wip/pdbillb.txd");
    AddSimpleModel(-1, 1923, -5082, "sporky/wip/pdbillb3.dff", "sporky/wip/pdbillb.txd");
    
    CreateDynamicObject(-5081, 1565.355, -1721.899, 31.152, 0.000, 0.000, 95.200, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5081)
    CreateDynamicObject(-5082, 1538.909, -1609.718, 25.925, 0.000, 0.000, 0.199, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5082)
    CreateDynamicObject(-5080, 2128.597, -1782.392, 30.568, 0.000, 0.000, -0.199, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5080)
    CreateDynamicObject(-5080, 356.653, -1719.179, 27.472, 0.000, 0.000, -0.199, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5080)
    CreateDynamicObject(-5081, 399.991, -1752.767, 23.290, 0.000, 0.000, 91.300, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5081)
    CreateDynamicObject(-5082, 932.766, -1363.182, 27.896, 0.000, 0.000, 56.599, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5082)
    CreateDynamicObject(-5080, 778.761, -1066.251, 36.604, 0.000, 0.000, -145.500, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5080)
    CreateDynamicObject(-5080, 1022.724, -2234.619, 22.439, 0.000, 0.000, 104.799, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5080)
    CreateDynamicObject(-5081, 2804.512, -1424.319, 58.060, 0.000, 0.000, -89.800, -1, 0, -1, 300.00, 300.00); // Kate_Mercer (-5081)

    // New Pecado Hill (Ryhes, 2022)
    AddSimpleModel(-1, 19379, PECADO_CIRCLE, "pecado/ep_circle.dff",        "pecado/ep_circle.txd");
    AddSimpleModel(-1, 19478, PECADO_CIRCLE_A, "pecado/ep_circle_A.dff",      "pecado/ep_alphas.txd"); //alpha
    AddSimpleModel(-1, 19379, PECADO_CIRCLE_BITS, "pecado/ep_circle_bits.dff",   "pecado/ep_circle_bits.txd");
    AddSimpleModel(-1, 19379, PECADO_GROUND, "pecado/ep_ground.dff",        "pecado/ep_ground.txd");
    AddSimpleModel(-1, 19478, PECADO_HILL_A, "pecado/ep_hill_A.dff",        "pecado/ep_alphas.txd"); //alpha
    AddSimpleModel(-1, 19379, PECADO_HILL_HOUSING, "pecado/ep_hill_housing.dff",  "pecado/ep_hill_housing.txd");
    AddSimpleModel(-1, 19379, PECADO_HILL1_BITS, "pecado/ep_hill1_bits.dff",    "pecado/ep_hill_bits.txd");
    AddSimpleModel(-1, 19379, PECADO_HILL2_BITS, "pecado/ep_hill2_bits.dff",    "pecado/ep_hill_bits.txd");
    AddSimpleModel(-1, 19379, PECADO_HILLFOREST, "pecado/ep_hillforest.dff",    "pecado/ep_hill_bits.txd");
    AddSimpleModel(-1, 19478, PECADO_HILLFOREST_A, "pecado/ep_hillforest_A.dff",  "pecado/ep_alphas.txd"); //alpha
    AddSimpleModel(-1, 19379, PECADO_HILLGROUND, "pecado/ep_hillGround.dff",    "pecado/ep_hillGround.txd");
    AddSimpleModel(-1, 19379, PECADO_PROJECTS, "pecado/ep_prjcts.dff",        "pecado/ep_prjcts.txd");
    AddSimpleModel(-1, 19478, PECADO_PROJECTS_A, "pecado/ep_prjcts_A.dff",      "pecado/ep_alphas.txd"); //alpha
    AddSimpleModel(-1, 19379, PECADO_PROJECTS_BITS, "pecado/ep_prjcts_bits.dff",   "pecado/ep_prjcts_bits.txd");
    AddSimpleModel(-1, 19379, PECADO_TUNNEL, "pecado/ep_tunnel.dff",        "pecado/ep_tunnel.txd");

    AddSimpleModel(-1, 19379, PECADO_MXFLAG, "pecado/ep_mxflag.dff",        "pecado/ep_mxflag.txd");
    AddSimpleModel(-1, 11680, PECADO_VALPHAS, "pecado/ep_vAlphas.dff",       "pecado/ep_alphas.txd"); //vertexalpha

    AddSimpleModel(-1, 19379, PECADO_VILLAGE_GROUND, "pecado/ep_villageGround.dff", "pecado/ep_villageGround.txd");
    AddSimpleModel(-1, 19478, PECADO_VILLAGE_A, "pecado/ep_village_A.dff",     "pecado/ep_alphas.txd");
    AddSimpleModel(-1, 19379, PECADO_FACTSIGN, "pecado/ep_factsign.dff",     "pecado/ep_factsign.txd");
    AddSimpleModel(-1, 19478, PECADO_FOLIAGE, "pecado/ep_snpedteew1_A.dff",     "pecado/ep_alphas.txd");

    CreateDynamicObject(PECADO_CIRCLE, 1771.9849, -1905.0929, 14.3769, 0.0000, 0.0000, 0.0000, -1, 0, -1, 400.00, 400.00); //ep_circle
	CreateDynamicObject(PECADO_CIRCLE_A, 1773.5060, -1908.1736, 15.3303, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_circle_A
	CreateDynamicObject(PECADO_CIRCLE_BITS, 1788.4736, -1914.5349, 13.4669, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_circle_bits

	//CreateDynamicObject(-4203, 1772.2646, -1958.1581, 13.0942, 0.0000, 0.0000, 0.0000, -1, -1, -1, 2000.00, 2000.00); //ep_ground
	CreateObject(PECADO_GROUND, 1772.2646, -1958.1581, 13.0942, 0.0000, 0.0000, 0.0000, 1250.0); //ep_ground

	CreateDynamicObject(PECADO_HILL_A, 1699.9823, -1946.4465, 46.8267, 0.0000, 0.0000, 0.0000, -1, 0, -1, 400.00, 400.00); //ep_hill_A
	CreateDynamicObject(PECADO_HILL_HOUSING, 1714.4185, -1941.8007, 47.0155, 0.0000, 0.0000, 0.0000, -1, 0, -1, 800.00, 800.00); //ep_hill_housing
	CreateDynamicObject(PECADO_HILL1_BITS, 1691.2295, -2007.7319, 38.3877, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_hill1_bits
	CreateDynamicObject(PECADO_HILL2_BITS, 1677.4519, -1936.1033, 51.1117, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_hill2_bits
	CreateDynamicObject(PECADO_HILLFOREST, 1592.6245, -1984.3678, 33.0185, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_hillforest
	CreateDynamicObject(PECADO_HILLFOREST_A, 1592.6245, -1984.3678, 33.0185, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_hillforest_A

	//CreateDynamicObject(-4210, 1706.5630, -1947.7192, 47.6652, 0.0000, 0.0000, 0.0000, -1, -1, -1, 2000.00, 2000.00); //ep_hillGround
	CreateObject(PECADO_HILLGROUND, 1706.5630, -1947.7192, 47.6652, 0.0000, 0.0000, 0.0000, 1250.0); //ep_hillGround

	CreateDynamicObject(PECADO_PROJECTS, 1772.9263, -2019.4185, 14.3557, 0.0000, 0.0000, 0.0000, -1, 0, -1, 400.00, 400.00); //ep_prjcts
	CreateDynamicObject(PECADO_PROJECTS_A, 1791.9921, -1993.1790, 21.9155, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_prjcts_A
	CreateDynamicObject(PECADO_PROJECTS_BITS, 1789.7473, -2026.9885, 13.7932, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_prjcts_bits

	CreateDynamicObject(PECADO_TUNNEL, 1654.8328, -1967.1459, 27.2864, 0.0000, 0.0000, 0.0000, -1, 0, -1, 350.00, 350.00); //ep_tunnel
	CreateDynamicObject(PECADO_MXFLAG, 1704.0823, -1928.9214, 71.1883, 0.0000, 0.0000, 0.0000, -1, 0, -1, 500.00, 500.00); //ep_mxflag
	CreateDynamicObject(PECADO_VALPHAS, 1679.9601, -2046.8998, 26.4583, 0.0000, 0.0000, 0.0000, -1, 0, -1, 100.00, 100.00); //ep_vAlphas

	//CreateDynamicObject(-4217, 1868.9531, -2003.6562, 13.7500, 0.0000, 0.0000, 0.0000, -1, 0, -1, 1250.00, 1250.00); //ep_villageGround
	CreateObject(PECADO_VILLAGE_GROUND, 1868.9531, -2003.6562, 13.7500, 0.0000, 0.0000, 0.0000, 1250.00); //ep_villageGround

	CreateDynamicObject(PECADO_VILLAGE_A, 1892.5391, -2012.8281, 21.3750, 0.0000, 0.0000, 0.0000, -1, 0, -1, 1250.00, 1250.00); //ep_village_A
	
	CreateDynamicObject(1297, 1669.6887, -1997.6752, 44.3204, 0.0000, 0.0000, -172.8002, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1806.7824, -2067.9277, 16.0203, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1790.7687, -2067.9277, 16.0603, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1781.1612, -2035.7059, 16.0803, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1800.6153, -2035.7059, 16.0803, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1742.7620, -2035.8460, 16.3703, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1718.0616, -2035.4957, 21.4203, 0.0000, 0.0000, 90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1682.3547, -2030.7459, 32.7403, 0.0000, 0.0000, -141.1001, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1807.4268, -1859.5270, 16.0316, 0.0000, 0.0000, -90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1776.9279, -1859.1267, 16.6616, 0.0000, 0.0000, -90.0000, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1667.4808, -1976.1452, 49.5705, 0.0000, 0.0000, -177.7004, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(1297, 1665.9201, -1947.1694, 52.7303, 0.0000, 0.0000, -176.7004, -1, 0, -1, 180.00, 180.00); //lamppost1
	CreateDynamicObject(620, 1834.6113, -2020.7310, 12.3534, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(620, 1834.6113, -2000.7309, 12.3534, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(620, 1834.6113, -1980.7309, 12.3534, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(620, 1805.0000, -1843.7707, 12.4301, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(620, 1790.0000, -1843.7707, 12.4301, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(620, 1775.0000, -1843.7707, 12.4301, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //veg_palm04
	CreateDynamicObject(705, 1713.7573, -1833.2281, 14.4325, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //sm_veg_tree7vbig

    CreateDynamicObject(PECADO_FACTSIGN, 1670.877, -1901.469, 22.815, 0.000, 0.000, 180.0, -1, 0, -1, 25.00, 25.00); // Kate_Mercer (PECADO_FACTSIGN)
    CreateDynamicObject(PECADO_FOLIAGE, 1898.3984, -1913.4063, 20.8203, 0.0000, 0.0000, 0.0000, -1, 0, -1, 300.00, 300.00); //ep_snpedteew1_A
    
    printf("PECADO_FACTSIGN is %d", PECADO_FACTSIGN);
    printf("PECADO_MXFLAG is %d", PECADO_MXFLAG);
    // End New Pecado Hill

    // New Ryhes Trailer Fix
    AddSimpleModel(-1, 19379, TRAILER_FIX, "ryhes/kb_tr_main_fix.dff", "ryhes/kb_tr_main_fix.txd");
    CreateDynamicObject(TRAILER_FIX, 0.30, 0.61, 1000.00,   0.00, 0.00, 0.00, -1, -1, -1, 200.0, 200.0);

    // New spraytags
    AddSimpleModel(-1, 18659, GRAF_38TH, "graffiti/graf_38th.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_ABZ, "graffiti/graf_abz.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_CCP, "graffiti/graf_ccp.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_DISS1, "graffiti/graf_diss1.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_DISS2, "graffiti/graf_diss2.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_DISS3, "graffiti/graf_diss3.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_ETGC, "graffiti/graf_etgc.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_FTP, "graffiti/graf_ftp.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_FYC, "graffiti/graf_fyc.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_GSC, "graffiti/graf_gsc.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_R90, "graffiti/graf_r90.dff", "graffiti/graffitinew.txd");
    AddSimpleModel(-1, 18659, GRAF_WBPS, "graffiti/graf_wbps.dff", "graffiti/graffitinew.txd");

    // Hotel WIP
    AddSimpleModel(-1, 1923, -25298, "sporky/wip/hotelconstruct1.dff", "sporky/wip/hotelconstruct.txd");
	AddSimpleModel(-1, 1923, -25299, "sporky/wip/hotelconstruct2.dff", "sporky/wip/hotelconstruct.txd");
	AddSimpleModel(-1, 1923, -5349, "sporky/wip/metroscreen.dff", "sporky/wip/metroscreen.txd");

    CreateDynamicObject(-25298, 1783.109, -1702.300, 14.050, 0.000, 0.000, 0.000, -1, 0, -1, 900.00, 900.00); // Spooky (-9990)
	CreateDynamicObject(-25299, 1783.109, -1702.300, 14.050, 0.000, 0.000, 0.000, -1, 0, -1, 200.00, 200.00); // Spooky (-9990)
	CreateDynamicObject(-5349, 1783.109, -1702.300, 14.050, 0.000, 0.000, 0.000, -1, 0, -1, 300.00, 300.00); // Spooky (-9990)
	CreateDynamicObject(1684, 1808.820, -1714.839, 14.081, 0.000, 0.000, -90.099, -1, 0, -1, 200.00, 200.00); // Spooky (1684)
	CreateDynamicObject(2984, 1808.663, -1720.911, 13.863, 0.000, 0.000, -178.999, -1, 0, -1, 200.00, 200.00); // Spooky (2984)
	CreateDynamicObject(2974, 1807.317, -1691.868, 12.772, 0.000, 0.000, 93.899, -1, 0, -1, 200.00, 200.00); // Spooky (2974)
	CreateDynamicObject(2974, 1803.416, -1692.134, 12.772, 0.000, 0.000, 88.099, -1, 0, -1, 200.00, 200.00); // Spooky (2974)
	CreateDynamicObject(2975, 1762.634, -1688.528, 12.400, 0.000, 0.000, 176.500, -1, 0, -1, 200.00, 200.00); // Spooky (2975)
	CreateDynamicObject(2975, 1764.517, -1688.362, 12.400, 0.000, 0.000, -175.999, -1, 0, -1, 200.00, 200.00); // Spooky (2975)
	CreateDynamicObject(12930, 1806.566, -1696.508, 13.352, 0.000, 0.000, 178.699, -1, 0, -1, 200.00, 200.00); // Spooky (12930)
	CreateDynamicObject(1684, 1772.008, -1689.161, 13.959, 0.000, 0.000, 0.000, -1, 0, -1, 200.00, 200.00); // Spooky (1684)
   
    // -------------------------------------------------------------------------------------
    
    
    printf("Faction Skins Added: %d", AddedSkinsCount);
    return true ;
}

// Sporky: new stuff to prevent model picker issues (and make sure all custom faction skins have a name)

//static skindbg[300];

static SOLS_AddCharModel(baseid, skinid, dff[64], txd[64], name[64]="")
{
    new i = AddedSkinsCount;

    if (i >= MAX_ADDED_FACTION_SKINS)
    {
        print("WARNING - MAX_ADDED_FACTION_SKINS LIMIT REACHED");
        return;
    }

    AddCharModel(baseid, skinid, dff, txd ) ;
    AddedSkins[i][E_ADDED_SKIN_BASE_ID] = baseid;
    AddedSkins[i][E_ADDED_SKIN_ID] = skinid;

    //printf("")
    /*
    mysql_format(mysql, skindbg, sizeof ( skindbg ), "UPDATE `faction_skins_dev` SET `faction_skin_baseid` = %d, `faction_skin_dff` = '%e', `faction_skin_txd` = '%e' WHERE `faction_skin_skinid` = %d", baseid, dff, txd, skinid);
    mysql_pquery(mysql, skindbg);
    print(skindbg);
    */

    GetSkinName(baseid, AddedSkins[i][E_ADDED_SKIN_NAME], 64 ) ;

    if (strlen(name) > 1)
    {
        // custom name
        format(AddedSkins[i][E_ADDED_SKIN_NAME], 64, "%s", name);
    }

    AddedSkinsCount ++;
}

static GetAddedSkinEnumId(skinid)
{
    for (new i = 0; i < AddedSkinsCount; i ++)
    {
        if (AddedSkins[i][E_ADDED_SKIN_ID] == skinid)
        {
            return i;
        }
    }

    return -1;
}

SOLS_GetBaseSkinID(skinid)
{
    if (skinid >= 20000)
    {
        new id = GetAddedSkinEnumId(skinid);
        if (id != -1)
        {
            return AddedSkins[id][E_ADDED_SKIN_BASE_ID];
        }
    }

    return skinid;
}

SOLS_GetCustomSkinName(skinid)
{
    new name[64];

    if (skinid > 0 && skinid <= 312)
    {
        GetSkinName(skinid, name, sizeof ( name ) ) ;
        return name;
    }

    format(name, sizeof(name), "%d", skinid);

    /*
    new id = GetAddedSkinEnumId(skinid);

    if (id != -1)
    {
        format(name, sizeof(name), "%s", AddedSkins[id][E_ADDED_SKIN_NAME]);
    }

    // uncomment this block to use the actual names instead of id (either uses base id name or custom name)

    */
    
    return name;
}

#pragma unused GetAddedSkinEnumId