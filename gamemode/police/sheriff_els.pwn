//------------------------------------------------------------------------------
// East Los Santos Sheriff's Station
// Created by Spooky (www.github.com/sporkyspork) for GTAC:RP
// Environments created by Spooky, Reyo and Ryhes

#include <YSI_Coding\y_hooks>

#define ELS_INT_ID   6
#define ELS_INT_VW  -1
#define ELS_HIGH_SD 200.0
#define ELS_MED_SD	100.0
#define ELS_LOW_SD	50.0

#define SD_INT_X 2458.38
#define SD_INT_Y -1532.44
#define SD_INT_Z 1000.0

//static OBJ_SD_INT = -1;

enum
{
	SD_INT_MAIN = -5770,
	SD_INT_CEILING,
	SD_INT_BITS,
	SD_INT_SIGNS,
	SD_INT_BITS2,
	SD_INT_BITS2GLASS,
    SD_INT_BITS5,
	SD_INT_STOREBITS,
	SD_INT_ARMBITS,
	SD_INT_MEDBITS,
	SD_INT_LOCKERBITS,
	SD_INT_INTERBITS,
	SD_INT_KITCHENBITS,
	SD_INT_BOOKINGBITS,
	SD_INT_ALPHA,
	SD_INT_DOOR_XL,
	SD_INT_DOOR_XR,
	SD_INT_SECDOOR,
	SD_INT_SECDOOR_STATIC,
	SD_INT_LOBBYD_XL,
	SD_INT_LOBBYD_XL_STATIC,
	SD_INT_LOBBYD_XR,
	SD_INT_LOBBYD_XR_STATIC,
	SD_INT_DOOR1,
	SD_INT_DOOR2,
	SD_INT_DOOR2_STATIC,
	SD_INT_DOOR3,
	SD_INT_CAPTDOOR,
	SD_INT_LOBBYGATE,
	SD_INT_LOBBYGLASS,
	SD_INT_LOBBYGLASS2,
	SD_INT_LOBBYCHAIR,
	SD_INT_WCDOOR,
	SD_INT_SHOWERFLR,
	SD_INT_SHOWERMIR,
	SD_INT_BRIEFROW,
	SD_INT_JAILBARS,
	SD_INT_JAILDOOR1,
	SD_INT_JAILDOOR2,
	SD_INT_BLINDSOPEN,
	SD_INT_BLINDSCLOSED,
	
	SD_INT_RADIOS,
	SD_INT_OFFCHAIR1,
	SD_INT_OFFCHAIR2,
	SD_INT_DESK3,
	SD_INT_COUNTER,
	SD_INT_AWARD,
	
	SD_INT_HAMRADIO,
	SD_INT_BINDER1,
	SD_INT_BINDER2,
	SD_INT_PAPERTRAY,
	SD_INT_TYPER,
	SD_INT_PC,
	SD_INT_PHONE,
	SD_INT_PINBOARD1,
	SD_INT_PINBOARD2,
	SD_INT_PAYPHONE,
	SD_INT_EVBAG,
	SD_INT_FOLDER,
	
	SD_INT_DESKFAN,
	SD_INT_TAPEREC,
	SD_INT_FLYERS,
	SD_INT_STOOL,
	
	SD_INT_NB1,
	SD_INT_NB2,
	SD_INT_NB3,

	SD_INT_NB4
}

static AddModels()
{
    // Main Parts
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,	SD_INT_MAIN,		"sdels/sd_int.dff", "sdels/sd_intPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID,	SD_INT_CEILING,		"sdels/sd_int_ceiling.dff", "sdels/sd_intPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BITS,		"sdels/sd_int_bitsPD.dff", "sdels/sd_int_bitsPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_SIGNS,		"sdels/sd_int_signs.dff", "sdels/sd_int_signsPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_ARMBITS,		"sdels/sd_int_armbits.dff", "sdels/sd_bits_armoryPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_STOREBITS,		"sdels/sd_int_storagebits.dff", "sdels/sd_bits_reyo_5.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_MEDBITS,		"sdels/sd_int_medbits.dff", "sdels/sd_medbits.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_LOCKERBITS,	"sdels/sd_int_lockerbitsPD.dff", "sdels/sd_bits_lockerPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_INTERBITS,	"sdels/sd_int_interbits.dff", "sdels/sd_bits_inter.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_KITCHENBITS,	"sdels/sd_int_kitchenbits.dff", "sdels/sd_bits_kitchen.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BOOKINGBITS,	"sdels/sd_int_bookingbits.dff", "sdels/sd_bits_bookingPD.txd");
	AddSimpleModel(-1, 17863, 					SD_INT_BITS2GLASS,	"sdels/sd_int_bits2glass.dff", "sdels/sd_int_bitsPD.txd");
	AddSimpleModel(-1, 17863, 					SD_INT_ALPHA,		"sdels/sd_int_alpha.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, 17863, 					SD_INT_SHOWERFLR,	"sdels/sd_int_showerflr.dff", "sdels/sd_intPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_SHOWERMIR,	"sdels/sd_int_showermir.dff", "sdels/sd_intPD.txd");
    AddSimpleModel(-1, 18665, 					SD_INT_LOBBYGLASS,	"sdels/sd_int_lobbyglass_bk.dff", "sdels/sd_int_doorsPD.txd");

    // Doors (you read right motherfucker, there's 18 custom doors in this shit)
	AddSimpleModel(-1, 1523, 					SD_INT_DOOR_XL,		"sdels/sd_int_doorxl.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1523, 					SD_INT_DOOR_XR,		"sdels/sd_int_doorxr.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1491, 					SD_INT_WCDOOR,		"sdels/sd_int_wcdoor.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1495, 					SD_INT_SECDOOR_STATIC,		"sdels/sd_int_secdoor.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1523, 					SD_INT_SECDOOR,		"sdels/sd_int_secdoor.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1523, 					SD_INT_DOOR1,		"sdels/sd_int_door1.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1491, 					SD_INT_DOOR2,		"sdels/sd_int_door2.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_DOOR2_STATIC,	"sdels/sd_int_door2.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1491, 					SD_INT_DOOR3,		"sdels/sd_int_door3NEW.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1491, 					SD_INT_LOBBYGATE,	"sdels/sd_int_lobbygate.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1491, 					SD_INT_CAPTDOOR,	"sdels/sd_int_captdoor.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1523, 					SD_INT_LOBBYD_XL,	"sdels/sd_int_lobbydxl.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1495, 					SD_INT_LOBBYD_XL_STATIC,	"sdels/sd_int_lobbydxl.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1523, 					SD_INT_LOBBYD_XR,	"sdels/sd_int_lobbydxr.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 1495, 					SD_INT_LOBBYD_XR_STATIC,	"sdels/sd_int_lobbydxr.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 19302, 	                SD_INT_JAILBARS,	"sdels/sd_int_jailbars.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 19302, 	                SD_INT_JAILDOOR1,	"sdels/sd_int_jaildoor1.dff", "sdels/sd_int_doorsPD.txd");
    AddSimpleModel(-1, 19302, 	                SD_INT_JAILDOOR2,	"sdels/sd_int_jaildoor2.dff", "sdels/sd_int_doorsPD.txd");

    // Blinds (currently unused)
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BLINDSOPEN,		"sdels/blinds_open.dff", "sdels/blinds.txd");
    // AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BLINDSCLOSED,	"sdels/blinds_closed.dff", "sdels/blinds.txd");


    // The rest...
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_LOBBYCHAIR,	"sdels/sd_int_lobbychair.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BRIEFROW,	"sdels/sd_int_briefrow.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_OFFCHAIR1,	"sdels/sd_int_offchair1.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_OFFCHAIR2,	"sdels/sd_int_offchair2.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_RADIOS,	    "sdels/sd_int_radios.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_DESK3,	    "sdels/sd_int_desk3.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_COUNTER,	    "sdels/sd_int_counter.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_AWARD,	    "sdels/sd_int_award.dff", "sdels/sd_int_signsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_STOOL,	    "sdels/sd_int_stool.dff", "sdels/sd_stool.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_FLYERS,	    "sdels/sd_int_flyers.dff", "sdels/sd_flyersPD.txd");

    // Props
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_HAMRADIO,	"sdels/sd_int_hamradio.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BINDER1,		"sdels/sd_int_binder1.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_BINDER2,		"sdels/sd_int_binder2.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PAPERTRAY,	"sdels/sd_int_papertray.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_TYPER,		"sdels/sd_int_typer.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PC,			"sdels/sd_int_pcPD.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PHONE,		"sdels/sd_int_phone.dff", "sdels/sd_int_bitsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PINBOARD1,	"sdels/sd_int_pinboard1.dff", "sdels/sd_int_signsPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PINBOARD2,	"sdels/sd_int_pinboard2.dff", "sdels/sd_int_signsPD.txd");
    //AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_DESKFAN,		"sdels/deskfan.dff", "sdels/deskfan.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_TAPEREC,		"sdels/sd_int_taperec.dff", "sdels/sd_bits_bookingPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_PAYPHONE,	"sdels/sd_int_payphone.dff", "sdels/sd_bits_bookingPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_EVBAG,		"sdels/sd_int_evbag.dff", "sdels/sd_bits_bookingPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_FOLDER,		"sdels/sd_int_folder.dff", "sdels/sd_bits_bookingPD.txd");
    
    // Noticeboards
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_NB1,		"sdels/sd_int_nb1.dff", "sdels/sd_noticeboardPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_NB2,		"sdels/sd_int_nb2.dff", "sdels/sd_noticeboardPD.txd");
    AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_NB3,		"sdels/sd_int_nb3.dff", "sdels/sd_noticeboardPD.txd");
	AddSimpleModel(-1, CUSTOM_OBJECT_BASEID, 	SD_INT_NB4,		"sdels/sd_pinboardels.dff", "sdels/sd_noticeboardPD.txd");
}

static CreateObjects()
{
    // Main shell
    CreateDynamicObject(SD_INT_MAIN, SD_INT_X, SD_INT_Y, SD_INT_Z, 0.00, 0.00, 0.00, ELS_INT_VW, ELS_INT_ID, -1, ELS_HIGH_SD, ELS_HIGH_SD); // The main shell
    //OBJ_SD_INT = CreateObject(SD_INT_MAIN, SD_INT_X, SD_INT_Y, SD_INT_Z, 0.00, 0.00, 0.00, 200.0);
	
    // Bits/etc
    CreateDynamicObject(SD_INT_SHOWERFLR, SD_INT_X + 14.856, SD_INT_Y - 4.124, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // The shower floor with alpha
    CreateDynamicObject(SD_INT_SHOWERMIR, SD_INT_X + 14.781, SD_INT_Y - 4.239, SD_INT_Z + -3.544,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Fake shower reflection
    CreateDynamicObject(SD_INT_LOBBYGLASS, SD_INT_X + -2.492, SD_INT_Y + -2.260, SD_INT_Z + 0.424,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // The glass in the lobby
    CreateDynamicObject(SD_INT_CEILING, SD_INT_X, SD_INT_Y, SD_INT_Z,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_HIGH_SD, ELS_HIGH_SD); // The ceiling with 2dfx
	CreateDynamicObject(SD_INT_BITS, SD_INT_X, SD_INT_Y, SD_INT_Z,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_HIGH_SD, ELS_HIGH_SD); // Misc bits/desks/counters
	CreateDynamicObject(SD_INT_SIGNS, SD_INT_X, SD_INT_Y, SD_INT_Z,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_HIGH_SD, ELS_HIGH_SD); // Signs and whiteboards etc
	CreateDynamicObject(SD_INT_BITS2GLASS, SD_INT_X + -14.125, SD_INT_Y + -3.502, SD_INT_Z + -0.46,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_STOREBITS, SD_INT_X + -21.845, SD_INT_Y + -5.315, SD_INT_Z + -0.445,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Util
	CreateDynamicObject(SD_INT_MEDBITS, SD_INT_X + -9.850, SD_INT_Y + 24.048, SD_INT_Z + -0.448,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Medbits
	CreateDynamicObject(SD_INT_LOCKERBITS, SD_INT_X + 11.842, SD_INT_Y - 7.356, SD_INT_Z - 1.602,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Locker Room
	CreateDynamicObject(SD_INT_ARMBITS, SD_INT_X + 14.744, SD_INT_Y + 15.028, SD_INT_Z + -0.462,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Armory
	CreateDynamicObject(SD_INT_INTERBITS, SD_INT_X + 8.564, SD_INT_Y + 21.459, SD_INT_Z + -0.148,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Inter Rooms
	CreateDynamicObject(SD_INT_KITCHENBITS, SD_INT_X + 14.710, SD_INT_Y + 2.682, SD_INT_Z + -0.488,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Kitchen
	CreateDynamicObject(SD_INT_BOOKINGBITS, SD_INT_X + 1.964, SD_INT_Y + 15.109, SD_INT_Z + -0.609,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Booking
	CreateDynamicObject(SD_INT_ALPHA, SD_INT_X + 5.793, SD_INT_Y + 12.723, SD_INT_Z + 0.097,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Amrory Windows

    // Furniture
    CreateDynamicObject(SD_INT_DESK3, SD_INT_X + -0.928, SD_INT_Y + 4.913, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_DESK3, SD_INT_X + -6.803, SD_INT_Y + 1.254, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_DESK3, SD_INT_X + -3.944, SD_INT_Y + 5.788, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_COUNTER, SD_INT_X + -2.476, SD_INT_Y + 0.396, SD_INT_Z + -0.93,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_AWARD, SD_INT_X + 2.828, SD_INT_Y + 3.974, SD_INT_Z + -0.18,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_FLYERS, SD_INT_X - 4.486, SD_INT_Y + -5.336, SD_INT_Z + -0.886,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD);

    // Doors
    //CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + -7.393, SD_INT_Y + 11.003, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // To Booking
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 10.493, SD_INT_Y + 19.271, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Interview
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 1.398, SD_INT_Y + 19.271, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Interview
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 6.921, SD_INT_Y + 19.271, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Interview
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 8.437, SD_INT_Y + 15.528, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Booking 1
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 3.474, SD_INT_Y + 13.415, SD_INT_Z + -1.772,   0.00, 0.00, 00.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Booking 2
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 8.492, SD_INT_Y + 7.475, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Brieifng
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 3.474, SD_INT_Y + -0.187, SD_INT_Z + -1.772,   0.00, 0.00, 180.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Briefing
    CreateDynamicObject(SD_INT_DOOR2, SD_INT_X + -19.205, SD_INT_Y + -4.833, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Storage
    CreateDynamicObject(SD_INT_DOOR1, SD_INT_X + 13.021, SD_INT_Y + 2.306, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Kitchen
    CreateDynamicObject(SD_INT_DOOR2, SD_INT_X + 10.498, SD_INT_Y + -5.948, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Locker
    //CreateDynamicObject(SD_INT_DOOR2, SD_INT_X + -8.228, SD_INT_Y + -4.832, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Lobby
    CreateDynamicObject(SD_INT_LOBBYGATE, SD_INT_X + -5.278, SD_INT_Y + -5.703, SD_INT_Z + -1.329,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Lobby Gate
    CreateDynamicObject(SD_INT_LOBBYGATE, SD_INT_X + -7.117, SD_INT_Y + 13.468, SD_INT_Z + -1.329,   0.00, 0.00, 180.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Booking Gate
    CreateDynamicObject(SD_INT_DOOR3, SD_INT_X + 4.669, SD_INT_Y + -5.948, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Toilet Door (Outside)
    CreateDynamicObject(SD_INT_DOOR3, SD_INT_X + -11.987, SD_INT_Y + 21.913, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Booking Toilet Door (Outside)
    CreateDynamicObject(SD_INT_CAPTDOOR, 2445.395, -1538.381, 998.210, 0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Captain's Door
    CreateDynamicObject(SD_INT_WCDOOR, SD_INT_X + 6.977, SD_INT_Y + -3.926, SD_INT_Z + -0.404,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Toilet Stall Door
    CreateDynamicObject(SD_INT_WCDOOR, SD_INT_X + -12.567, SD_INT_Y + 21.241, SD_INT_Z + -0.404,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Booking Toilet Stall Door

	// Double Doors
	CreateDynamicObject(SD_INT_DOOR_XL, SD_INT_X + 3.474, SD_INT_Y + 10.549, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_DOOR_XR, SD_INT_X + 3.474, SD_INT_Y + 7.929, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

	CreateDynamicObject(SD_INT_DOOR_XL, SD_INT_X + 9.486, SD_INT_Y + 10.549, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_DOOR_XR, SD_INT_X + 9.486, SD_INT_Y + 7.929, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

	CreateDynamicObject(SD_INT_DOOR_XL, SD_INT_X + 12.561, SD_INT_Y + -2.275, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_DOOR_XR, SD_INT_X + 9.942, SD_INT_Y + -2.275, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

	CreateDynamicObject(SD_INT_DOOR_XL, SD_INT_X + 12.561, SD_INT_Y + 10.964, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_DOOR_XR, SD_INT_X + 9.942, SD_INT_Y + 10.964, SD_INT_Z + -1.772,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

	// Sec Doors
    //CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + 13.015, SD_INT_Y + 18.05, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Armory
    //CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + 7.169, SD_INT_Y + -8.832, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Lockers

    // Lobby Glass Doors
    //CreateDynamicObject(SD_INT_LOBBYD_XL, SD_INT_X + -6.77, SD_INT_Y + -2.262, SD_INT_Z + -1.778,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	//CreateDynamicObject(SD_INT_LOBBYD_XR, SD_INT_X + 1.786, SD_INT_Y + -2.262, SD_INT_Z + -1.778,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

	// Briefing
	CreateDynamicObject(SD_INT_BRIEFROW, 2466.190, -1530.976, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)
	CreateDynamicObject(SD_INT_BRIEFROW, 2466.190, -1529.134, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)
	CreateDynamicObject(SD_INT_BRIEFROW, 2466.190, -1527.373, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)
	CreateDynamicObject(SD_INT_BRIEFROW, 2463.547, -1529.973, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)
	CreateDynamicObject(SD_INT_BRIEFROW, 2463.547, -1528.052, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)
	CreateDynamicObject(SD_INT_BRIEFROW, 2463.547, -1526.281, 998.243, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5724)

	// Jail Doors
	CreateDynamicObject(SD_INT_JAILBARS, SD_INT_X + -1.785, SD_INT_Y + 19.186, SD_INT_Z + -0.519,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_JAILDOOR2, SD_INT_X + -5.043, SD_INT_Y + 19.246, SD_INT_Z + -0.522,   0.00, 0.00, 180.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
	CreateDynamicObject(SD_INT_JAILDOOR2, SD_INT_X + -11.962, SD_INT_Y + 17.807, SD_INT_Z + -0.522,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);
    CreateDynamicObject(SD_INT_JAILDOOR2, SD_INT_X + -11.962, SD_INT_Y + 13.904, SD_INT_Z + -0.522,   0.00, 0.00, 270.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD);

    // Mapped Filler Objects Lobby
	CreateDynamicObject(2515, 2463.780, -1535.341, 999.244, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2515)
	CreateDynamicObject(2742, 2462.323, -1537.450, 999.714, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2742)
	CreateDynamicObject(11706, 2462.484, -1537.983, 998.223, 0.000, 0.000, 130.399, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (11706)
	CreateDynamicObject(2674, 2462.767, -1538.089, 998.243, 0.000, 0.000, 12.799, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2674)
	CreateDynamicObject(2738, 2467.264, -1537.038, 998.843, 0.000, 0.000, 270.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2738)
	CreateDynamicObject(19873, 2467.666, -1538.029, 998.283, 0.000, 0.000, 297.947, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (19873)
	CreateDynamicObject(19873, 2467.638, -1538.168, 998.283, 0.000, 0.000, -137.452, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (19873)
	CreateDynamicObject(19873, 2467.676, -1538.106, 998.403, 0.000, 0.000, 155.447, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (19873)
	CreateDynamicObject(2741, 2464.556, -1534.942, 999.774, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2741)
	CreateDynamicObject(2685, 2464.908, -1534.885, 999.814, 0.000, 2.999, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2685)
	CreateDynamicObject(SD_INT_LOBBYCHAIR, 2451.345, -1542.836, 998.701, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5720)
	CreateDynamicObject(SD_INT_LOBBYCHAIR, 2451.345, -1542.005, 998.701, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5720)
	CreateDynamicObject(SD_INT_LOBBYCHAIR, 2451.345, -1541.194, 998.701, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5720)
	CreateDynamicObject(SD_INT_LOBBYCHAIR, 2451.345, -1540.374, 998.701, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5720)
	CreateDynamicObject(SD_INT_LOBBYCHAIR, 2451.345, -1539.563, 998.701, 0.000, 0.000, 0.001, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5720)

	// Mapped Main Room
	CreateDynamicObject(SD_INT_RADIOS, 2450.559, -1526.401, 999.154, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (-5709)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2454.150, -1525.793, 998.194, 0.000, 0.000, -59.800, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (-5708)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2455.395, -1528.567, 998.203, 0.000, 0.000, 93.199, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2454.340, -1528.557, 998.203, 0.000, 0.000, 85.700, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2451.758, -1532.003, 998.233, 0.000, 0.000, 133.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2457.484, -1528.395, 998.233, 0.000, 0.000, 116.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2456.660, -1525.620, 998.223, 0.000, 0.000, -87.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2457.570, -1525.628, 998.223, 0.000, 0.000, -91.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_RADIOS, 2456.584, -1529.240, 999.014, 0.000, 0.000, -92.700, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2457.030, -1530.871, 998.233, 0.000, 0.000, -70.300, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2455.358, -1531.781, 998.233, 0.000, 0.000, -103.300, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)

	// More mapped stuff
	CreateDynamicObject(SD_INT_PC, 2455.458, -1526.995, 999.014, 0.000, 0.000, -138.799, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_PC, 2450.628, -1530.711, 999.014, 0.000, 0.000, 36.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (-5707)
	CreateDynamicObject(SD_INT_PC, 2456.722, -1527.075, 999.014, 0.000, 0.000, 8.700, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5707)
	CreateDynamicObject(SD_INT_TYPER, 2454.338, -1526.871, 999.164, 0.000, 0.000, 167.400, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_TYPER, 2456.393, -1528.650, 999.164, 0.000, 0.000, 175.699, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_TYPER, 2442.864, -1529.286, 999.134, 0.000, 0.000, 86.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2455.409, -1525.507, 999.074, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2451.692, -1530.959, 999.074, 0.000, 0.000, 173.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2451.692, -1530.959, 999.184, 0.000, 0.000, 173.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2457.468, -1527.293, 999.074, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2456.023, -1538.014, 999.524, 0.000, 0.000, 9.199, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2442.681, -1540.473, 999.104, 0.000, 0.000, -89.399, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2442.681, -1540.473, 999.204, 0.000, 0.000, -89.399, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_HAMRADIO, 2450.619, -1532.165, 999.114, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (-5712)
	CreateDynamicObject(SD_INT_BINDER1, 2441.304, -1540.337, 999.124, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5710)
	CreateDynamicObject(SD_INT_BINDER2, 2439.862, -1539.677, 999.124, 0.000, 0.000, -66.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5711)
	CreateDynamicObject(SD_INT_TYPER, 2439.866, -1539.090, 999.174, 0.000, 0.000, 85.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_HAMRADIO, 2440.410, -1540.250, 999.144, 0.000, 0.000, -48.399, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5712)
	CreateDynamicObject(SD_INT_HAMRADIO, 2457.724, -1531.893, 999.244, 0.000, 0.000, 15.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5712)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2450.705, -1529.395, 998.203, 0.000, 0.000, -69.100, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5716)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2451.663, -1529.315, 998.203, 0.000, 0.000, -97.900, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5716)

	// More
	CreateDynamicObject(SD_INT_PHONE, 2455.458, -1525.975, 999.094, 0.000, 0.000, 90.599, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2456.279, -1527.936, 999.084, 0.000, 0.000, -123.300, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2450.718, -1531.865, 999.094, 0.000, 0.000, -68.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2456.754, -1531.758, 999.204, 0.000, 0.000, -20.500, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2456.868, -1537.403, 999.204, 0.000, 0.000, 8.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2443.079, -1525.556, 999.094, 0.000, 0.000, -177.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PHONE, 2443.015, -1524.035, 999.094, 0.000, 0.000, -9.799, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_PAPERTRAY, 2444.185, -1524.237, 999.154, 0.000, 0.000, 171.500, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5704)
	CreateDynamicObject(SD_INT_TYPER, 2445.362, -1524.264, 999.094, 0.000, 0.000, -90.500, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5705)
	CreateDynamicObject(SD_INT_BINDER1, 2444.994, -1525.105, 999.114, 0.000, 0.000, -169.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_BINDER1)
	CreateDynamicObject(SD_INT_HAMRADIO, 2444.284, -1525.315, 999.144, 0.000, 0.000, 176.800, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_HAMRADIO)
	CreateDynamicObject(SD_INT_BINDER2, 2444.999, -1525.119, 999.264, 0.000, 0.000, -159.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_BINDER2)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2444.966, -1522.976, 998.233, 0.000, 0.000, -97.900, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR1)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2443.130, -1523.328, 998.173, 0.000, 0.000, 6.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR2)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2443.200, -1530.705, 998.223, 0.000, 0.000, -9.600, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR1)
	CreateDynamicObject(SD_INT_HAMRADIO, 2444.324, -1530.143, 999.154, 0.000, 0.000, 104.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_HAMRADIO)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2443.790, -1533.790, 998.203, 0.000, 0.000, -95.600, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR2)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2454.908, -1536.351, 998.214, 0.000, 0.000, -95.799, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR1)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2462.332, -1533.158, 998.203, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR2)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2462.332, -1533.968, 998.203, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR2)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2472.883, -1519.812, 998.233, 0.000, 0.000, -72.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR1)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2446.246, -1525.354, 998.213, 0.000, 0.000, -104.299, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (SD_INT_OFFCHAIR2)
	CreateDynamicObject(SD_INT_PHONE, 2444.445, -1531.404, 999.094, 0.000, 0.000, 53.799, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (SD_INT_PHONE)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2443.592, -1526.676, 998.233, 0.000, 0.000, 58.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5713)

	// Inter rooms
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2464.872, -1512.367, 998.204, 0.000, 0.000, 30.199, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5721)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2466.269, -1508.609, 998.233, 0.000, 0.000, -100.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5722)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2466.176, -1511.442, 998.203, 0.000, 0.000, 113.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5721)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2460.608, -1508.906, 998.203, 0.000, 0.000, -95.899, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5721)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2459.070, -1508.471, 998.203, 0.000, 0.000, -38.299, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5721)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2459.974, -1511.560, 998.233, 0.000, 0.000, 72.800, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5722)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2461.302, -1511.604, 998.233, 0.000, 0.000, 109.900, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5722)

	// Med Props
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2449.064, -1509.526, 998.231, 0.000, 0.000, 17.900, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5717)
	CreateDynamicObject(SD_INT_TYPER, 2450.174, -1509.281, 999.404, 0.000, 0.000, -91.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5708)
	CreateDynamicObject(SD_INT_PHONE, 2450.169, -1509.689, 999.354, 0.000, 0.000, 84.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5706)
	CreateDynamicObject(SD_INT_PINBOARD1, 2450.565, -1509.872, 1000.044, 0.000, 0.000, 270.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5705)
	CreateDynamicObject(SD_INT_BINDER1, 2450.179, -1510.179, 999.344, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5710)
	CreateDynamicObject(SD_INT_BINDER2, 2450.187, -1510.169, 999.494, 0.000, 0.000, 97.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5711)
	CreateDynamicObject(2515, 2443.313, -1509.687, 999.234, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (2515)
	CreateDynamicObject(2738, 2445.104, -1512.947, 998.843, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (2738)
	CreateDynamicObject(SD_INT_OFFCHAIR2, 2448.303, -1512.767, 998.220, 0.000, 0.000, 94.200, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5716)

	// Redone Lobby ones
	CreateDynamicObject(1776, 2462.303, -1543.331, 999.314, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (1776)
	CreateDynamicObject(11706, 2461.247, -1543.461, 998.224, 0.000, 0.000, 165.899, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (11706)
	CreateDynamicObject(2673, 2461.075, -1543.357, 998.314, 0.000, 0.000, 50.699, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (2673)
	CreateDynamicObject(11706, 2451.277, -1538.709, 998.223, 0.000, 0.000, 82.701, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (11706)
	CreateDynamicObject(2673, 2451.088, -1538.874, 998.320, 0.000, 0.000, 146.699, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (2673)

	// Filler Pinboards
	CreateDynamicObject(SD_INT_PINBOARD1, 2447.862, -1521.544, 999.925, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5705)
	CreateDynamicObject(SD_INT_PINBOARD2, 2443.678, -1524.680, 999.904, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5704)
	CreateDynamicObject(SD_INT_PINBOARD1, 2460.067, -1525.086, 999.875, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5705)
	CreateDynamicObject(SD_INT_PINBOARD2, 2468.056, -1511.069, 1000.045, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5704)
	CreateDynamicObject(SD_INT_PINBOARD1, 2467.961, -1525.395, 999.964, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5705)
	CreateDynamicObject(SD_INT_PINBOARD2, 2467.949, -1526.965, 999.964, 0.000, 0.000, 90.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5704)

	// Booking Stuff
	CreateDynamicObject(SD_INT_HAMRADIO, 2457.047, -1519.546, 999.221, 0.000, 0.000, 101.600, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5712)
	CreateDynamicObject(SD_INT_PHONE, 2455.397, -1518.885, 999.184, 0.000, 0.000, -170.899, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5706)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2455.979, -1520.070, 998.223, 0.000, 0.000, 99.999, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5717)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2453.363, -1518.996, 998.223, 0.000, 0.000, 77.099, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5717)
	CreateDynamicObject(SD_INT_STOOL, 2454.094, -1516.927, 998.231, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5699)
	CreateDynamicObject(SD_INT_STOOL, 2455.406, -1516.927, 998.231, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5699)
	CreateDynamicObject(SD_INT_STOOL, 2456.657, -1516.927, 998.231, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5699)
	CreateDynamicObject(SD_INT_OFFCHAIR1, 2456.420, -1536.404, 998.213, 0.000, 0.000, -114.599, ELS_INT_VW, ELS_INT_ID, -1, ELS_MED_SD, ELS_MED_SD); // Spooky (-5716)
	
	// Payphones
	CreateDynamicObject(SD_INT_PAYPHONE, 2449.840, -1519.613, 999.905, 0.000, 0.000, 0.00, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAYPHONE, 2449.840, -1520.824, 999.905, 0.000, 0.000, 0.00, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAYPHONE, 2463.866, -1516.794, 999.905, 0.000, 0.000, -90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)
	CreateDynamicObject(SD_INT_PAYPHONE, 2462.645, -1516.793, 999.905, 0.000, 0.000, -90.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (-5709)

	// New Noticeboards
	CreateDynamicObject(SD_INT_NB1, SD_INT_X + -7.356, SD_INT_Y + -10.289, SD_INT_Z + -0.109,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD);
	CreateDynamicObject(SD_INT_NB2, SD_INT_X + -7.356, SD_INT_Y + -7.094, SD_INT_Z + -0.109,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD);
	CreateDynamicObject(SD_INT_NB3, SD_INT_X + 8.482, SD_INT_Y + -11.529, SD_INT_Z + -0.258,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD);
	CreateDynamicObject(SD_INT_NB4, SD_INT_X + 2.151, SD_INT_Y + -9.960, SD_INT_Z + -0.029,   0.00, 0.00, 0.0, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD);

	// Medbits
	CreateDynamicObject(11706, 2445.930, -1508.402, 998.213, 0.000, 0.000, -12.800, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (11706)
	CreateDynamicObject(2742, 2444.742, -1508.297, 999.774, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2742)
	CreateDynamicObject(2613, 2450.529, -1507.461, 998.223, 0.000, 0.000, 0.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2613)
	CreateDynamicObject(2674, 2449.644, -1508.434, 998.233, 0.000, 0.000, 9.100, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2674)
	CreateDynamicObject(19897, 2472.205, -1543.600, 999.774, 0.000, 0.000, 139.800, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Reyo (19897)
	CreateDynamicObject(2674, 2445.551, -1508.058, 998.235, 0.000, 0.000, -156.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // Spooky (2674)

	// PD Shit
	CreateDynamicObject(-5592, 2460.516, -1538.246, 1000.095, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // PD_LOGO
	CreateDynamicObject(-5592, 2446.272, -1542.396, 1000.445, 0.000, 0.000, 180.000, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // PD_LOGO
	CreateDynamicObject(-5595, 2467.527, -1534.407, 998.393, 0.000, 0.000, 16.594, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // PD_FLAG_US
	CreateDynamicObject(-5595, 2442.878, -1538.656, 998.233, 0.000, 0.000, 179.492, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // PD_FLAG_US
	CreateDynamicObject(-5595, 2450.248, -1521.067, 998.233, 0.000, 0.000, -51.205, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // PD_FLAG_US
	CreateDynamicObject(-5346, 2441.869, -1539.043, 998.253, 0.000, 0.000, 10.499, ELS_INT_VW, ELS_INT_ID, -1, ELS_LOW_SD, ELS_LOW_SD); // mayors chair
}

// Exterior pos
#define SD_ELS_X 2458.38
#define SD_ELS_Y -1532.44
#define SD_ELS_Z 22.99

static CreateExterior()
{
    CreateObject(SD_ELS_MAIN, SD_ELS_X, SD_ELS_Y, SD_ELS_Z, 0.00, 0.00, 0.00, 800.0); // SHERIFF STATION
	CreateDynamicObject(SD_ELS_BBRD, 2366.81, -1537.54, 39.47,   0.00, 0.00, 50.50, -1, 0, -1, 600.0, 600.0); // billboard
    CreateDynamicObject(SD_ELS_WIRE, 2467.46, -1538.25, 27.60,   0.00, 0.00, 0.00, -1, 0, -1, 300.0, 300.0); // wires
    CreateDynamicObject(SD_ELS_GATEXL, SD_ELS_X + 24.516, SD_ELS_Y + 17.96, SD_ELS_Z + 0.91,   0.00, 0.00, 0.00, -1, 0, -1, 150.0, 150.0); // gates
    CreateDynamicObject(SD_ELS_GATEXR, SD_ELS_X + 31.113, SD_ELS_Y + 17.96, SD_ELS_Z + 0.91,   0.00, 0.00, 0.00, -1, 0, -1, 150.0, 150.0); // gates
    CreateDynamicObject(SD_ELS_FLAGS, SD_ELS_X + 18.497, SD_ELS_Y - 12.043, SD_ELS_Z + 9.711,   0.00, 0.00, 0.00, -1, 0, -1, 300.0, 300.0); // flags

    // sd lamps
    CreateDynamicObject(1297, 2494.406, -1527.494, 26.470, 0.000, 0.000, 0.000); // Spooky (1297)
    CreateDynamicObject(1297, 2494.406, -1544.895, 26.470, 0.000, 0.000, 0.000); // Spooky (1297)
    CreateDynamicObject(1297, 2459.238, -1559.440, 26.452, 0.000, 0.000, 270.0); // Spooky (1297)
    CreateDynamicObject(1297, 2480.436, -1559.489, 26.390, 0.000, 0.000, 270.0); // Spooky (1297)

    // sd mast

    CreateDynamicObject(FIRESTAT_MAST, 2467.869, -1528.065, 33.068, 0.000, 0.000, 0.000, -1, 0, -1, 300.0, 300.0); // Spooky (-3003)
    // sd sign
    CreateDynamicObject(SD_ELS_SIGN, 2440.831, -1556.204, 23.304, 0.000, 0.000, 0.000); // Spooky (-5064)

    // sd gatebox
    CreateDynamicObject(SD_ELS_GATEBOX, SD_ELS_X + 33.847, SD_ELS_Y + 15.434, SD_ELS_Z + 0.001,   0.00, 0.00, 0.00, -1, 0, -1, 200.0, 200.0);
    
	// sd parking sign 1
    CreateDynamicObject(SD_ELS_PSIGN1, 2482.642, -1546.162, 23.059, 0.000, 0.000, 179.400); // Spooky (-5065)
    CreateDynamicObject(SD_ELS_PSIGN1, 2479.894, -1559.981, 23.159, 0.000, 0.000, 0.000); // Spooky (-5065)
    
    // sd parking sign 2
    CreateDynamicObject(SD_ELS_PSIGN2, 2455.906, -1559.942, 23.129, 0.000, 0.000, 0.000); // Spooky (-5066)
    CreateDynamicObject(SD_ELS_PSIGN2, 2448.405, -1559.942, 23.129, 0.000, 0.000, 0.000); // Spooky (-5066)
    CreateDynamicObject(1308, 2495.69, -1515.00, 23.41,   -354.00, 0.00, 0.00); // sd telepole
}

static enum E_DYN_DOOR
{
	E_DYN_DOOR_NAME[32],
    E_DYN_DOOR_CLOSED_ID,
	E_DYN_DOOR_OPEN_ID,
	Float:E_DYN_DOOR_X,
	Float:E_DYN_DOOR_Y,
	Float:E_DYN_DOOR_Z,
	Float:E_DYN_DOOR_RX,
	Float:E_DYN_DOOR_RY,
	Float:E_DYN_DOOR_RZ,
	bool:E_DYN_DOOR_RELATIVE,
    E_DYN_DOOR_VW,
    E_DYN_DOOR_INT,
	STREAMER_TAG_OBJECT:E_DYN_DOOR_OBJ,
	STREAMER_TAG_AREA:E_DYN_DOOR_AREA,
	bool:E_DYN_DOOR_OPEN,
    E_DYN_DOOR_OPENED_AT,
}

//CreateDynamicObject(SD_INT_LOBBYD_XL, SD_INT_X + -6.77, SD_INT_Y + -2.262, SD_INT_Z + -1.778,   0.00, 0.00, 0.0, -1, -1, -1, 100.0, 100.0);
//CreateDynamicObject(SD_INT_LOBBYD_XR, SD_INT_X + 1.786, SD_INT_Y + -2.262, SD_INT_Z + -1.778,   0.00, 0.00, 0.0, -1, -1, -1, 100.0, 100.0);
//CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + 13.015, SD_INT_Y + 18.05, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, -1, -1, -1, 100.0, 100.0); // Armory
//CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + 7.169, SD_INT_Y + -8.832, SD_INT_Z + -1.772,   0.00, 0.00, 0.0, -1, -1, -1, 100.0, 100.0); // Lockers
//CreateDynamicObject(SD_INT_DOOR2, SD_INT_X + -8.228, SD_INT_Y + -4.832, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, -1, -1, -1, 100.0, 100.0); // Lobby
//CreateDynamicObject(SD_INT_SECDOOR, SD_INT_X + -7.393, SD_INT_Y + 11.003, SD_INT_Z + -1.772,   0.00, 0.00, 90.0, -1, -1, -1, 100.0, 100.0); // To Booking

static DynamicDoor[][E_DYN_DOOR] =
{
	{ "Glass Lobby Door L", SD_INT_LOBBYD_XL_STATIC, SD_INT_LOBBYD_XL, -6.77, -2.262, -1.778, 0.00, 0.00, 0.00, true, ELS_INT_VW, ELS_INT_ID },
	{ "Glass Lobby Door R", SD_INT_LOBBYD_XR_STATIC, SD_INT_LOBBYD_XR, 1.786, -2.262, -1.778, 0.00, 0.00, 0.00, true, ELS_INT_VW, ELS_INT_ID },
    { "Armory SecDoor", SD_INT_SECDOOR_STATIC, SD_INT_SECDOOR, 13.015, 18.05, -1.772, 0.00, 0.00, 0.00, true, ELS_INT_VW, ELS_INT_ID },
	{ "Locker SecDoor", SD_INT_SECDOOR_STATIC, SD_INT_SECDOOR, 7.169, -8.832, -1.772, 0.00, 0.00, 0.00, true, ELS_INT_VW, ELS_INT_ID },
	{ "Solid Lobby Door", SD_INT_DOOR2_STATIC, SD_INT_DOOR2, -8.228, -4.832, -1.772, 0.00, 0.00, 90.00, true, ELS_INT_VW, ELS_INT_ID },
	{ "Booking SecDoor", SD_INT_SECDOOR_STATIC, SD_INT_SECDOOR, -7.393, 11.003, -1.772, 0.0, 0.0, 90.0, true, ELS_INT_VW, ELS_INT_ID }
};

static CreateDynamicDoors()
{
	for (new i = 0; i < sizeof(DynamicDoor); i++)
	{
	    if (DynamicDoor[i][E_DYN_DOOR_RELATIVE])
		{
	 		DynamicDoor[i][E_DYN_DOOR_X] += SD_INT_X;
	 		DynamicDoor[i][E_DYN_DOOR_Y] += SD_INT_Y;
	 		DynamicDoor[i][E_DYN_DOOR_Z] += SD_INT_Z;
	 	}
	 	
        DynamicDoor[i][E_DYN_DOOR_AREA] = CreateDynamicSphere(DynamicDoor[i][E_DYN_DOOR_X], DynamicDoor[i][E_DYN_DOOR_Y], DynamicDoor[i][E_DYN_DOOR_Z], 5.0);
        RefreshDynamicDoor(i, false);
	}
	
	return 1;
}

hook OnGameModeInit()
{
	print("[SD_ELS] Loading and creating East LS Sheriff's Station");

	AddModels();
	CreateObjects();
    CreateDynamicDoors();
    CreateExterior();

	print("[SD_ELS] Loaded and created East LS Sheriff's Station");
	return 1;
}

static GetPlayerClosestDynamicDoor(playerid)
{
    new closest = -1;
    new Float:current;
    new Float:last = 2.5; // 2.5 max radius for a door
    new int = GetPlayerInterior(playerid);
    new vw = GetPlayerVirtualWorld(playerid);

    for (new i = 0; i < sizeof(DynamicDoor); i++)
	{
        if (DynamicDoor[i][E_DYN_DOOR_INT] != -1 && DynamicDoor[i][E_DYN_DOOR_INT] != int) continue;
        if (DynamicDoor[i][E_DYN_DOOR_VW] != -1 && DynamicDoor[i][E_DYN_DOOR_VW] != vw) continue;

        current = GetPlayerDistanceFromPoint(playerid, DynamicDoor[i][E_DYN_DOOR_X], DynamicDoor[i][E_DYN_DOOR_Y], DynamicDoor[i][E_DYN_DOOR_Z]);

        if (current < last)
        {
            closest = i;
            last = current;
        }
    }
    
    return closest;
}

static SetDynamicDoor(i, bool:newstate)
{
	if (DynamicDoor[i][E_DYN_DOOR_OPEN] == newstate) return 0;

	DynamicDoor[i][E_DYN_DOOR_OPEN] = newstate;

    if (DynamicDoor[i][E_DYN_DOOR_OPEN])
    {
        DynamicDoor[i][E_DYN_DOOR_OPENED_AT] = gettime();
    }

	RefreshDynamicDoor(i, true);
	return 1;
}

static RefreshDynamicDoor(i, bool:update=false)
{
	if (DynamicDoor[i][E_DYN_DOOR_OBJ])
	{
	    DestroyDynamicObject(DynamicDoor[i][E_DYN_DOOR_OBJ]);
	}
	
	new modelid = DynamicDoor[i][E_DYN_DOOR_OPEN] ? DynamicDoor[i][E_DYN_DOOR_OPEN_ID] : DynamicDoor[i][E_DYN_DOOR_CLOSED_ID];
	DynamicDoor[i][E_DYN_DOOR_OBJ] = CreateDynamicObject(modelid, DynamicDoor[i][E_DYN_DOOR_X], DynamicDoor[i][E_DYN_DOOR_Y], DynamicDoor[i][E_DYN_DOOR_Z], DynamicDoor[i][E_DYN_DOOR_RX], DynamicDoor[i][E_DYN_DOOR_RY], DynamicDoor[i][E_DYN_DOOR_RZ], -1, -1, -1, 100.0, 100.0); // Door
	
	if (update)
	{
	    foreach (new playerid : Player)
	    {
		    if (IsPlayerInRangeOfPoint(playerid, 25.0, DynamicDoor[i][E_DYN_DOOR_X], DynamicDoor[i][E_DYN_DOOR_Y], DynamicDoor[i][E_DYN_DOOR_Z]))
		    {
		        Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		    }
		}
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Check if the player is not in a vehicle and pressed the F key
    if (PRESSED(KEY_SECONDARY_ATTACK))
	{
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;
        if (!IsPlayerInPoliceFaction(playerid) && !PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) return 0;

	    new door = PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR];
	
	    if (door != -1)
	    {
	        PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = -1;
	    
			if (IsPlayerInDynamicArea(playerid, DynamicDoor[door][E_DYN_DOOR_AREA], true))
		    {
		        SetDynamicDoor(door, false);
		        return 1;
		    }
		}
	
	    door = GetPlayerClosestDynamicDoor(playerid);
	    
	    if (door != -1 && (!DynamicDoor[door][E_DYN_DOOR_OPENED_AT] || gettime() - DynamicDoor[door][E_DYN_DOOR_OPENED_AT] > 1))
	    {
	        SetDynamicDoor(door, !DynamicDoor[door][E_DYN_DOOR_OPEN]);
	        PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = door;
	    }
	}

    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if (PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] == -1) return 1;
	
    new door = PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR];
	if (DynamicDoor[door][E_DYN_DOOR_AREA] == areaid)
    {
        SetDynamicDoor(door, false);
        PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = -1;
    }
    
	return 1;
}

hook OnPlayerConnect(playerid)
{
	PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = -1;
    return 1;
}

hook SOLS_OnCharacterSpawn(playerid, isrespawn)
{
    PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = -1;
    return 1;
}

hook SOLS_OnCloseConnection(playerid, reason)
{
	if (PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] != -1)
    {
        SetDynamicDoor(PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR], false);
    }

    PlayerVar[playerid][E_PLAYER_DYNAMIC_DOOR] = -1;
    return 1;
}