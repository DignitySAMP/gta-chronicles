//------------------------------------------------------------------------------
// Custom LSPD Central Police Station Interior (Converted from Redwood RP Sheriff's Dept.)
// Developed by Spooky (www.github.com/sporkyspork) for Singleplayer Roleplay (www.stretzofls.com)
// Overhauled to 2.0 in July 2022 by Spooky with help from Ryhes and Reyo

#include <YSI_Coding\y_hooks>

#define MODELS_PATH "sporky/pd"
#define COP_INTERIOR 6
#define COP_WORLD -1
#define COP_BOT -25190
#define COP_TOP -25191
#define COP_SIGNS -25192
#define COP_GLASS -25193
#define COP_DOOR_GLASS -25194
#define COP_DOOR_DYNAMIC -25195
#define COP_DOOR_STATIC -25196

enum
{
	PD_BOT = -5600,
    PD_TOP,
    PD_TOPBITS,
    PD_CONFTABLE,
    PD_PODIUM,
    PD_FLAG_US,
    PD_FLAG_SA,
    PD_FLAG_LS,
    PD_LOGO,
    PD_OFFICEBITS,
    PD_OFFICEBITS2,
	PD_OFFICEBITS3,
	PD_DESKSTUFF,
    PD_PORTRAITS,
    PD_SWIVELCHAIR,
    PD_LOCKERBITS,
    PD_CELLGATES,
    PD_CEILING_BOT,
    PD_CEILING_TOP,
    PD_BOOKINGBITS,
    PD_INTERTABLE,
    PD_PAYPHONE,
    PD_CLOCK,
    PD_SIGNS,
    PD_SHOWERFLR,
    PD_MESH,
    PD_GLASS,
    PD_BRIEFGLASS,
    PD_BRIEFROW,
    PD_BRIEFBITS,
    PD_HALLBITS,
    PD_BLACKBOARD,
    PD_MAP1,
    PD_MAP2,
    PD_MAP3,
    PD_MAP4,
    PD_FLYERS,
	PD_FLYERS2,
    PD_PINBOARD1,
    PD_PINBOARD2,
    PD_PINBOARD3,
    PD_PINBOARD4,
	PD_PINBOARD5,
	PD_LOBBYBITS,
	PD_WATERCOOLER,
    PD_DOOR_L,
    PD_DOOR_R,
	PD_DOOR_STATIC,
    PD_OFFICEDOOR_L,
    PD_OFFICEDOOR_R,
	PD_HOLDGATE_L,
	PD_HOLDGATE_R,
}

hook OnGameModeInit()
{
    print("  |--  Adding and creating Central Police Station.");

    AddSimpleModel(-1, 19353, PD_BOT, MODELS_PATH"/pd_bot.dff", MODELS_PATH"/pd_bot.txd");
    AddSimpleModel(-1, 19353, PD_TOP, MODELS_PATH"/pd_top.dff", MODELS_PATH"/pd_top.txd");
    AddSimpleModel(-1, 19353, PD_TOPBITS, MODELS_PATH"/pd_topbits.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_CONFTABLE, MODELS_PATH"/pd_conftable.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_PODIUM, MODELS_PATH"/pd_podium.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_FLAG_US, MODELS_PATH"/pd_officeflag_us.dff", MODELS_PATH"/pd_flags.txd");
    AddSimpleModel(-1, 19353, PD_FLAG_SA, MODELS_PATH"/pd_officeflag_sa.dff", MODELS_PATH"/pd_flags.txd");
    AddSimpleModel(-1, 19353, PD_FLAG_LS, MODELS_PATH"/pd_officeflag_ls.dff", MODELS_PATH"/pd_flags.txd");
    AddSimpleModel(-1, 19353, PD_LOGO, MODELS_PATH"/pd_logo.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_OFFICEBITS, MODELS_PATH"/pd_officebits.dff", MODELS_PATH"/pd_office.txd");
    AddSimpleModel(-1, 19353, PD_OFFICEBITS2, MODELS_PATH"/pd_officebits2.dff", MODELS_PATH"/pd_office.txd");
	AddSimpleModel(-1, 19353, PD_OFFICEBITS3, MODELS_PATH"/pd_officebits3.dff", MODELS_PATH"/pd_office3.txd");
	AddSimpleModel(-1, 1964, PD_DESKSTUFF, MODELS_PATH"/pd_deskstuff.dff", MODELS_PATH"/pd_office.txd");
    AddSimpleModel(-1, 19353, PD_PORTRAITS, MODELS_PATH"/pd_portraits.dff", MODELS_PATH"/pd_portraits.txd");
    AddSimpleModel(-1, 19353, PD_SWIVELCHAIR, MODELS_PATH"/pd_swivelchair.dff", MODELS_PATH"/pd_office.txd");
    AddSimpleModel(-1, 19353, PD_LOCKERBITS, MODELS_PATH"/pd_lockerbits.dff", MODELS_PATH"/pd_lockerbits.txd");
    AddSimpleModel(-1, 19302, PD_CELLGATES, MODELS_PATH"/pd_cellgates.dff", MODELS_PATH"/pd_alphas.txd");
    AddSimpleModel(-1, 19353, PD_CEILING_BOT, MODELS_PATH"/pd_ceiling_bot.dff", MODELS_PATH"/pd_ceiling.txd");
    AddSimpleModel(-1, 19353, PD_CEILING_TOP, MODELS_PATH"/pd_ceiling_top.dff", MODELS_PATH"/pd_ceiling.txd");
    AddSimpleModel(-1, 19353, PD_BOOKINGBITS, MODELS_PATH"/pd_bookingbits.dff", MODELS_PATH"/pd_bookingbits.txd");
    AddSimpleModel(-1, 19353, PD_INTERTABLE, MODELS_PATH"/pd_intertable.dff", MODELS_PATH"/pd_bookingbits.txd");
    AddSimpleModel(-1, 19353, PD_PAYPHONE, MODELS_PATH"/pd_payphone.dff", MODELS_PATH"/pd_bookingbits.txd");
    AddSimpleModel(-1, 19353, PD_CLOCK, MODELS_PATH"/pd_clock.dff", MODELS_PATH"/pd_bookingbits.txd");
    AddSimpleModel(-1, 18112, PD_SIGNS, MODELS_PATH"/pd_signs.dff", MODELS_PATH"/pd_signs.txd");
    AddSimpleModel(-1, 17863, PD_SHOWERFLR, MODELS_PATH"/pd_showerflr.dff", MODELS_PATH"/pd_alphas.txd");
    AddSimpleModel(-1, 14501, PD_MESH, MODELS_PATH"/pd_mesh.dff", MODELS_PATH"/pd_alphas.txd");
    AddSimpleModel(-1, 19466, PD_GLASS, MODELS_PATH"/pd_glass.dff", MODELS_PATH"/pd_alphas.txd");
    AddSimpleModel(-1, 19466, PD_BRIEFGLASS, MODELS_PATH"/pd_briefglass.dff", MODELS_PATH"/pd_alphas.txd");
    AddSimpleModel(-1, 19353, PD_BRIEFROW, MODELS_PATH"/pd_briefrow.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_BRIEFBITS, MODELS_PATH"/pd_briefbits.dff", MODELS_PATH"/pd_bits.txd");
    AddSimpleModel(-1, 19353, PD_HALLBITS, MODELS_PATH"/pd_hallbits.dff", MODELS_PATH"/pd_hallbits.txd");
    AddSimpleModel(-1, 19353, PD_BLACKBOARD, MODELS_PATH"/pd_blackboard.dff", MODELS_PATH"/pd_bits.txd");

    AddSimpleModel(-1, 19353, PD_MAP1, MODELS_PATH"/pd_map1.dff", MODELS_PATH"/pd_maps.txd");
    AddSimpleModel(-1, 19353, PD_MAP2, MODELS_PATH"/pd_map2.dff", MODELS_PATH"/pd_maps.txd");
    AddSimpleModel(-1, 19353, PD_MAP3, MODELS_PATH"/pd_map3.dff", MODELS_PATH"/pd_maps.txd");
    AddSimpleModel(-1, 19353, PD_MAP4, MODELS_PATH"/pd_map4.dff", MODELS_PATH"/pd_maps.txd");

    AddSimpleModel(-1, 19353, PD_FLYERS, MODELS_PATH"/pd_flyers.dff", MODELS_PATH"/pd_pinboard.txd");
	AddSimpleModel(-1, 19353, PD_FLYERS2, MODELS_PATH"/pd_flyers2.dff", MODELS_PATH"/pd_pinboard.txd");
    AddSimpleModel(-1, 19353, PD_PINBOARD1, MODELS_PATH"/pd_pinboard1.dff", MODELS_PATH"/pd_pinboard.txd");
    AddSimpleModel(-1, 19353, PD_PINBOARD2, MODELS_PATH"/pd_pinboard2.dff", MODELS_PATH"/pd_pinboard.txd");
    AddSimpleModel(-1, 19353, PD_PINBOARD3, MODELS_PATH"/pd_pinboard3.dff", MODELS_PATH"/pd_pinboard.txd");
    AddSimpleModel(-1, 19353, PD_PINBOARD4, MODELS_PATH"/pd_pinboard4.dff", MODELS_PATH"/pd_pinboard.txd");
	AddSimpleModel(-1, 19353, PD_PINBOARD5, MODELS_PATH"/pd_pinboard5.dff", MODELS_PATH"/pd_pinboard.txd");

	AddSimpleModel(-1, 19353, PD_LOBBYBITS, MODELS_PATH"/pd_lobbybits.dff", MODELS_PATH"/pd_bits.txd");
	AddSimpleModel(-1, 19353, PD_WATERCOOLER, MODELS_PATH"/pd_watercooler.dff", MODELS_PATH"/pd_office3.txd");

    AddSimpleModel(-1, 1523, PD_DOOR_L, MODELS_PATH"/pd_door_l.dff", MODELS_PATH"/pd_doors.txd");
    AddSimpleModel(-1, 1523, PD_DOOR_R, MODELS_PATH"/pd_door_r.dff", MODELS_PATH"/pd_doors.txd");

    AddSimpleModel(-1, 1523, PD_OFFICEDOOR_L, MODELS_PATH"/pd_officedoor_l.dff", MODELS_PATH"/pd_doors.txd");
    AddSimpleModel(-1, 1523, PD_OFFICEDOOR_R, MODELS_PATH"/pd_officedoor_r.dff", MODELS_PATH"/pd_doors.txd");

	AddSimpleModel(-1, 19302, PD_HOLDGATE_L, MODELS_PATH"/pd_holdgate_l.dff", MODELS_PATH"/pd_alphas.txd");
	AddSimpleModel(-1, 19302, PD_HOLDGATE_R, MODELS_PATH"/pd_holdgate_r.dff", MODELS_PATH"/pd_alphas.txd");
	AddSimpleModel(-1, 1495, PD_DOOR_STATIC, MODELS_PATH"/pd_door_r.dff", MODELS_PATH"/pd_doors.txd");

    CreatePoliceInterior();

    print("  |--  Created Central Police Station (July 22 update) by Spooky.");
    printf("  |--  PD_HOLDGATE_L: %d", PD_HOLDGATE_L);
    printf("  |--  PD_HOLDGATE_R: %d", PD_HOLDGATE_R);
    printf("  |--  PD_DOOR_STATIC: %d", PD_DOOR_STATIC);
	printf("  |--  PD_LOGO: %d, PD_FLAG_US: %d", PD_LOGO, PD_FLAG_US);

    return 1;
}

#undef MODELS_PATH

#define PD_BOT_X -14.211
#define PD_BOT_Y -99.601
#define PD_BOT_Z 898.931

#define PD_TOP_X -13.499
#define PD_TOP_Y -87.99
//#define PD_TOP_Z 902.461
#define PD_TOP_Z 903.041

// increased top by 0.58

// Greenish/Blue Light: 230/255/244
// Halogen: 255/228/197
// Warm: 255/209/163

static CreatePoliceInterior()
{
	// Base objects:
    CreateDynamicObject(PD_BOT, PD_BOT_X, PD_BOT_Y, PD_BOT_Z, 0.000000, 0.000000, 0.000000, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_LOCKERBITS, PD_BOT_X + 9.312, PD_BOT_Y + -1.549, PD_BOT_Z + 0.309, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_CELLGATES, PD_BOT_X + -11.286, PD_BOT_Y + -7.083, PD_BOT_Z + -0.115, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_CEILING_BOT, PD_BOT_X + -2.745, PD_BOT_Y + -6.83, PD_BOT_Z + 2.378, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_BOOKINGBITS, PD_BOT_X + -0.989, PD_BOT_Y + -3.069, PD_BOT_Z + -0.043, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_SHOWERFLR, PD_BOT_X + 9.312, PD_BOT_Y + -6.897, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_GLASS, PD_BOT_X + -3.586, PD_BOT_Y + 4.556, PD_BOT_Z + 2.271, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    
    CreateDynamicObject(PD_BRIEFGLASS, PD_BOT_X + 4.661, PD_BOT_Y + -15.204, PD_BOT_Z + 0.285, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_BRIEFBITS, PD_BOT_X + 6.386, PD_BOT_Y + -18.573, PD_BOT_Z + 0.428, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_HALLBITS, PD_BOT_X + 6.157, PD_BOT_Y + -10.389, PD_BOT_Z + -0.435, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);

	CreateDynamicObject(PD_TOP, PD_TOP_X, PD_TOP_Y, PD_TOP_Z, 0.000000, 0.000000, 0.000000, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_CEILING_TOP, PD_TOP_X + 0.183, PD_TOP_Y + -5.77, PD_TOP_Z + 2.932, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_TOPBITS, PD_TOP_X + 9.176, PD_TOP_Y + 0.637, PD_TOP_Z + 0.09, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_CONFTABLE, PD_TOP_X + -1.318, PD_TOP_Y + -7.041, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_OFFICEBITS, PD_TOP_X + -2.866, PD_TOP_Y + -17.359, PD_TOP_Z + 0.31, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_OFFICEBITS2, PD_TOP_X + -1.176, PD_TOP_Y + -2.875, PD_TOP_Z + 1.861, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(PD_OFFICEBITS3, PD_TOP_X + -9.899, PD_TOP_Y + -6.946, PD_TOP_Z + 0.089, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_PORTRAITS, PD_TOP_X + -7.340, PD_TOP_Y + 3.020, PD_TOP_Z + 2.143, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);

    CreateDynamicObject(PD_SIGNS, -10.7, -91.6, 902.148, 0.000000, 0.000000, 0.000000, COP_WORLD, COP_INTERIOR);

    CreateDynamicObject(PD_MESH, -17.183, -91.105, 899.252, 0.000000, 0.000000, 0.000000, COP_WORLD, COP_INTERIOR);

    // Lobby Stuff
    CreateDynamicObject(PD_FLYERS, -12.279, -89.519, 898.861, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5570)
	CreateDynamicObject(PD_FLYERS2, PD_BOT_X + 10.561, PD_BOT_Y + 19.026, PD_BOT_Z + -0.841, 0.000, 0.000, 127.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5570)
	CreateDynamicObject(PD_WATERCOOLER, PD_BOT_X + 6.447, PD_BOT_Y + 18.872, PD_BOT_Z + -1.367, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5570)
	CreateDynamicObject(PD_LOBBYBITS, PD_BOT_X + 7.318, PD_BOT_Y + 18.028, PD_BOT_Z + 0.108, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5570)
	CreateDynamicObject(PD_PINBOARD5, PD_BOT_X + 8.978, PD_BOT_Y + 19.233, PD_BOT_Z + 0.565, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5570)
	CreateDynamicObject(1209, -9.625, -80.628, 897.570, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1209)

	// Locker Room Pinboards
    CreateDynamicObject(PD_PINBOARD2, -9.126, -100.402, 899.442, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5568)
    CreateDynamicObject(PD_PINBOARD2, -9.126, -98.592, 899.442, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5568)
    CreateDynamicObject(PD_PINBOARD2, -0.687, -99.688, 899.442, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5568)
	
	// Inter A
	CreateDynamicObject(PD_INTERTABLE, -23.321, -97.547, 897.991, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5584)
	CreateDynamicObject(-5727, -25.012, -97.675, 897.560, 0.000, 0.000, 37.600, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5727)
	CreateDynamicObject(-5727, -21.675, -97.704, 897.560, 0.000, 0.000, 139.300, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5727)
	CreateDynamicObject(-5728, -24.131, -96.149, 897.610, 0.000, 0.000, -62.300, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5728)
	CreateDynamicObject(-5728, -22.934, -96.008, 897.610, 0.000, 0.000, -100.200, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5728)
	CreateDynamicObject(PD_PINBOARD4, -24.393, -94.485, 899.192, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5565)
	CreateDynamicObject(PD_CLOCK, -23.324, -98.166, 900.451, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (-5578)

	// Inter B
	CreateDynamicObject(PD_INTERTABLE, -23.456, -106.720, 897.981, 0.000, 0.000, 90.099, COP_WORLD, COP_INTERIOR); // Spooky (-5580)
	CreateDynamicObject(PD_PINBOARD4, -23.490, -106.189, 899.422, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (-5560)
	CreateDynamicObject(PD_CLOCK, -25.421, -108.035, 900.442, 0.000, 0.000, -90.0, COP_WORLD, COP_INTERIOR); // Spooky (-5578)
	CreateDynamicObject(19809, -23.200, -106.891, 898.421, 0.000, 0.000, -25.800, COP_WORLD, COP_INTERIOR); // Spooky (19809)

	// Booking Posters
    CreateDynamicObject(PD_PINBOARD4, -16.375, -104.789, 899.471, 0.000, 0.000, -90.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5567)
    CreateDynamicObject(PD_LOGO, -9.827, -97.809, 900.062, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
    CreateDynamicObject(PD_PINBOARD2, -11.902, -103.285, 899.471, 0.000, 0.000, 90.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5568)
    CreateDynamicObject(PD_PINBOARD3, -16.375, -108.942, 899.472, 0.000, 0.000, -90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5569)
    CreateDynamicObject(PD_MAP1, -12.643, -91.382, 899.442, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5573)

    CreateDynamicObject(2741, -14.755, -103.621, 899.151, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2741)
    CreateDynamicObject(PD_PINBOARD2, -14.429, -108.381, 899.451, 0.000, 0.000, -90.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5568)
    CreateDynamicObject(PD_FLAG_US, -11.160, -80.569, 897.560, 0.000, 0.000, 180.00, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5595)
    CreateDynamicObject(PD_FLAG_US, -3.716, -115.190, 897.560, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5595)

	// Cell Gates
    CreateDynamicObject(-5732, -22.471, -113.280, 898.801, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR);// Kate_Mercer (-5732)
    CreateDynamicObject(-5732, -27.162, -113.280, 898.801, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5732)
    CreateDynamicObject(-5732, -28.594, -109.905, 898.801, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5732)

    // Phones
    CreateDynamicObject(PD_PAYPHONE, -23.905, -110.050, 899.332, 0.000, 0.000, 90.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5714)
    CreateDynamicObject(PD_PAYPHONE, -22.695, -110.050, 899.332, 0.000, 0.000, 90.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5714)
    CreateDynamicObject(PD_PAYPHONE, -20.839, -97.844, 899.362, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5714)
    CreateDynamicObject(PD_PAYPHONE, -20.839, -106.538, 899.362, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5584)

    // Briefing Maps
    CreateDynamicObject(PD_MAP4, -12.816, -121.376, 899.402, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5574)
    CreateDynamicObject(PD_MAP3, -10.983, -121.376, 899.402, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5575)
    CreateDynamicObject(PD_MAP2, -9.159, -121.376, 899.402, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5576)
    CreateDynamicObject(PD_MAP1, -7.312, -121.376, 899.402, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5577)

    // Briefing Chairs
    CreateDynamicObject(PD_BRIEFROW, PD_BOT_X + 6.536, PD_BOT_Y + -18.565, PD_BOT_Z + -0.933, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_BRIEFROW, PD_BOT_X + 4.764, PD_BOT_Y + -18.565, PD_BOT_Z + -0.933, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_BRIEFROW, PD_BOT_X + 2.996, PD_BOT_Y + -18.565, PD_BOT_Z + -0.933, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);
    CreateDynamicObject(PD_BRIEFROW, PD_BOT_X + 1.198, PD_BOT_Y + -18.565, PD_BOT_Z + -0.933, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR);

    // Briefing Stuff
    CreateDynamicObject(PD_LOGO, -4.308, -121.417, 899.729, 0.000, 0.000, 90.00, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
    CreateDynamicObject(PD_MAP1, -3.465, -118.856, 899.450, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5575)
    CreateDynamicObject(PD_MAP2, -3.465, -116.936, 899.450, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5575)
    CreateDynamicObject(PD_BLACKBOARD, -3.796, -116.616, 898.571, 0.000, 0.000, 2.899, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5577)

	// Washroom
    CreateDynamicObject(2738, -11.974, -107.727, 898.171, 0.000, 0.000, 180.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2738)
    CreateDynamicObject(2515, -10.329, -104.726, 898.581, 0.000, 0.000, 270.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2515)
    CreateDynamicObject(2741, -10.489, -105.906, 899.152, 0.000, 0.000, 180.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2741)
    CreateDynamicObject(2742, -12.405, -103.758, 899.172, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2742)
    CreateDynamicObject(11706, -12.929, -103.863, 897.560, 0.000, 0.000, 11.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (11706)
    CreateDynamicObject(2674, -11.568, -103.572, 897.570, 0.000, 0.000, -172.399, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2674)

    // Downstairs Doors
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + -2.017, PD_BOT_Y + -10.543, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Lobby Double
    CreateDynamicObject(PD_DOOR_R, PD_BOT_X + -2.017, PD_BOT_Y + -13.538, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Lobby Double
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + 10.062, PD_BOT_Y + -15.223, PD_BOT_Z + -1.367, 0.0, 0.0, 270.0, COP_WORLD, COP_INTERIOR); // Briefing Left
    CreateDynamicObject(PD_DOOR_R, PD_BOT_X + -0.896, PD_BOT_Y + -15.223, PD_BOT_Z + -1.367, 0.0, 0.0, 270.0, COP_WORLD, COP_INTERIOR); // Briefing Right
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + 7.697, PD_BOT_Y + -11.097, PD_BOT_Z + -1.367, 0.0, 0.0, 180.0, COP_WORLD, COP_INTERIOR); // Storage
    CreateDynamicObject(PD_DOOR_R, PD_BOT_X + -6.750, PD_BOT_Y + -9.168, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Inter B
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + -6.750, PD_BOT_Y + 4.027, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Inter A
    CreateDynamicObject(PD_DOOR_R, PD_BOT_X + 8.563, PD_BOT_Y + -8.406, PD_BOT_Z + -1.367, 0.0, 0.0, 270.0, COP_WORLD, COP_INTERIOR); // Locker
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + 10.062, PD_BOT_Y + 5.100, PD_BOT_Z + -1.367, 0.0, 0.0, 270.0, COP_WORLD, COP_INTERIOR); // Locker
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + 3.962, PD_BOT_Y + 6.053, PD_BOT_Z + -1.367, 0.0, 0.0, 180.0, COP_WORLD, COP_INTERIOR); // Staff Lobby
    CreateDynamicObject(PD_DOOR_L, PD_BOT_X + -2.017, PD_BOT_Y + -6.658, PD_BOT_Z + -1.367, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Washroom
	CreateDynamicObject(PD_DOOR_L, PD_BOT_X + -9.841, PD_BOT_Y + 8.499, PD_BOT_Z + -1.367, 0.0, 0.0, 90.0, COP_WORLD, COP_INTERIOR); // Front Office
    CreateDynamicObject(-5738, -11.338, -106.061, 898.921, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5738) // Toilet Stall Door

    // Office Doors
	CreateDynamicObject(PD_OFFICEDOOR_L, PD_TOP_X + 3.689, PD_TOP_Y + -3.082, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Conference
	CreateDynamicObject(PD_OFFICEDOOR_R, PD_TOP_X + 3.689, PD_TOP_Y + -11.028, PD_TOP_Z + -1.041, 0.0, 0.0, 180.0, COP_WORLD, COP_INTERIOR); // Conference
	CreateDynamicObject(PD_OFFICEDOOR_R, PD_TOP_X + -6.574, PD_TOP_Y + -3.082, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Conference
	CreateDynamicObject(PD_OFFICEDOOR_L, PD_TOP_X + -6.574, PD_TOP_Y + -11.028, PD_TOP_Z + -1.041, 0.0, 0.0, 180.0, COP_WORLD, COP_INTERIOR); // Conference
	CreateDynamicObject(PD_OFFICEDOOR_L, PD_TOP_X + -8.285, PD_TOP_Y + -14.560, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Office 3
	CreateDynamicObject(PD_OFFICEDOOR_L, PD_TOP_X + -2.295, PD_TOP_Y + -14.560, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Watch Cmdr Office
	CreateDynamicObject(PD_OFFICEDOOR_L, PD_TOP_X + 3.695, PD_TOP_Y + -14.560, PD_TOP_Z + -1.041, 0.0, 0.0, 0.0, COP_WORLD, COP_INTERIOR); // Captain Office

	// Office Desk Stuff
	CreateDynamicObject(PD_DESKSTUFF, -11.315, -105.421, 902.921, 0.000, 0.000, -90.000, COP_WORLD, COP_INTERIOR); // Spooky (PD_DESKSTUFF)
	CreateDynamicObject(PD_DESKSTUFF, -16.464, -106.017, 902.921, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (PD_DESKSTUFF)
	CreateDynamicObject(PD_DESKSTUFF, -22.534, -105.886, 902.921, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (PD_DESKSTUFF)

	// Upstairs Blue Doors
	CreateDynamicObject(PD_DOOR_R, PD_TOP_X + 8.377, PD_TOP_Y + -20.199, PD_TOP_Z + -1.041, 0.0, 0.0, 90.0, COP_WORLD, COP_INTERIOR); // Back Stairs
	CreateDynamicObject(PD_DOOR_R, PD_TOP_X - 8.189, PD_TOP_Y + 7.873, PD_TOP_Z + -1.041, 0.0, 0.0, 180.0, COP_WORLD, COP_INTERIOR); // Front Stairs

	// Detective Maps
	CreateDynamicObject(PD_MAP1, -13.827, -105.981, 903.902, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP_1)
	CreateDynamicObject(PD_MAP3, -1.209, -84.283, 903.902, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP2)
	CreateDynamicObject(PD_MAP4, -1.204, -81.113, 903.902, 0.000, 0.000, 180.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP3)
	CreateDynamicObject(PD_MAP1, -2.216, -79.521, 903.902, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP_1)
	CreateDynamicObject(PD_MAP2, -4.036, -79.521, 903.902, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP2)
	CreateDynamicObject(PD_MAP1, -4.176, -93.299, 903.742, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP2)
	CreateDynamicObject(PD_MAP3, -5.890, -95.203, 903.822, 0.000, 0.000, 90.00, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_MAP2)

	// Office UFO Lights
	CreateDynamicObject(16779, PD_TOP_X + 2.957, PD_TOP_Y + -17.36, PD_TOP_Z + 2.950, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(16779, PD_TOP_X + -3.019, PD_TOP_Y + -17.36, PD_TOP_Z + 2.950, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(16779, PD_TOP_X + -9.009, PD_TOP_Y + -17.36, PD_TOP_Z + 2.950, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(16779, PD_TOP_X + 2.534, PD_TOP_Y + -7.055, PD_TOP_Z + 2.950, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(16779, PD_TOP_X + -3.927, PD_TOP_Y + -7.055, PD_TOP_Z + 2.950, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (1806)

	// Det Chairs
	CreateDynamicObject(1806, -2.326, -80.947, 901.999, 0.000, 0.000, 158.020, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(1806, -2.660, -84.438, 901.999, 0.000, 0.000, 1.620, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(1806, -2.579, -93.310, 901.999, 0.000, 0.000, 68.320, COP_WORLD, COP_INTERIOR); // Spooky (1806)
	CreateDynamicObject(1806, -6.119, -93.993, 901.999, 0.000, 0.000, -84.779, COP_WORLD, COP_INTERIOR); // Spooky (1806)

	// Upstairs Pinboards
	CreateDynamicObject(PD_PINBOARD1, -22.199, -87.691, 903.972, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Spooky (-5562)
	CreateDynamicObject(PD_PINBOARD2, -24.209, -87.731, 903.972, 0.000, 0.000, 270.000, COP_WORLD, COP_INTERIOR); // Spooky (-5562)

	// More upstairs
	CreateDynamicObject(PD_FLAG_US, -4.445, -96.190, 902.009, 0.000, 0.000, 175.099, COP_WORLD, COP_INTERIOR); // Spooky (-5595)
	CreateDynamicObject(PD_LOGO, -5.878, -95.955, 904.272, 0.000, 0.000, -90.000, COP_WORLD, COP_INTERIOR); // Spooky (-5592)

	// Flags
	CreateDynamicObject(PD_FLAG_US, -4.342, -91.192, 902.001, 0.000, 0.000, 1.899, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_FLAG_US)
	CreateDynamicObject(PD_FLAG_SA, -8.795, -98.735, 902.001, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5594)
	CreateDynamicObject(PD_FLAG_LS, -9.368, -98.754, 902.010, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5593)
	CreateDynamicObject(PD_FLAG_US, -8.256, -98.730, 902.010, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_FLAG_US)
	CreateDynamicObject(PD_FLAG_US, -21.398, -82.092, 902.000, 0.000, 0.000, -36.700, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_FLAG_US)
	CreateDynamicObject(PD_FLAG_US, -10.324, -95.642, 897.558, 0.000, 0.000, 88.800, COP_WORLD, COP_INTERIOR); // Kate_Mercer (PD_FLAG_US)
	CreateDynamicObject(PD_LOGO, -7.760, -95.062, 904.353, 0.000, 0.000, 180.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
	CreateDynamicObject(PD_LOGO, -13.420, -105.334, 904.272, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
	CreateDynamicObject(PD_LOGO, -19.761, -107.124, 904.192, 0.000, 0.000, 180.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
	CreateDynamicObject(PD_LOGO, -18.332, -102.669, 904.092, 0.000, 0.000, 270.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5592)
	CreateDynamicObject(PD_FLAG_US, -13.144, -107.792, 902.008, 0.000, 0.000, -90.000, COP_WORLD, COP_INTERIOR); // Spooky (-5595)
	CreateDynamicObject(PD_FLAG_US, -13.964, -107.794, 902.008, 0.000, 0.000, 0.00, COP_WORLD, COP_INTERIOR); // Spooky (-5595)
	CreateDynamicObject(PD_FLAG_US, -19.965, -107.809, 902.008, 0.000, 0.000, 0.00, COP_WORLD, COP_INTERIOR); // Spooky (-5595)

	// Office Stuff
	new copoffice[4];
	copoffice[0] = CreateDynamicObject(2199, -19.220, -104.867, 901.971, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2199)
	copoffice[1] = CreateDynamicObject(2199, -19.833, -105.662, 901.987, 0.000, 0.000, 270.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2199)
	copoffice[2] = CreateDynamicObject(2199, -7.437, -98.401, 901.908, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2199)
	copoffice[3] = CreateDynamicObject(2199, -9.007, -91.275, 901.981, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2199)

	for (new i = 0; i < sizeof(copoffice); i ++)
	{
		SetDynamicObjectMaterial(copoffice[i], 2, 2163, "cj_office", "CJ_WOOD5", 0);
	}

	new copdesk[3];
	copdesk[0] = CreateDynamicObject(2205, -11.330, -104.746, 901.981, 0.000, 0.000, 270.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2205)
	copdesk[1] = CreateDynamicObject(2205, -17.144, -106.035, 901.981, 0.000, 0.000, 0.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2205)
	copdesk[2] = CreateDynamicObject(2205, -23.214, -105.903, 901.981, 0.000, 0.000, 0.0, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2205)

	/*
	for (new i = 0; i < sizeof(copdesk); i ++)
	{
		SetDynamicObjectMaterial(copdesk[i], 1, 2163, "cj_office", "CJ_WOOD5", 0);
	}
	*/

	// Mayor Chair
	CreateDynamicObject(-5346, -12.849, -105.581, 901.991, 0.000, 0.000, 96.800, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, -16.487, -107.494, 901.991, 0.000, 0.000, 177.900, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5346)
	CreateDynamicObject(-5346, -22.513, -107.273, 901.991, 0.000, -0.699, -176.499, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5346)

	// Chairs
	CreateDynamicObject(PD_SWIVELCHAIR, -21.731, -104.314, 902.010, 0.000, 0.000, -19.100, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)
	CreateDynamicObject(PD_SWIVELCHAIR, -23.236, -104.285, 901.990, 0.000, 0.000, 8.199, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)
	CreateDynamicObject(PD_SWIVELCHAIR, -17.290, -104.293, 902.001, 0.000, 0.000, 20.100, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)
	CreateDynamicObject(PD_SWIVELCHAIR, -15.505, -104.420, 901.990, 0.000, 0.000, -31.600, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)
	CreateDynamicObject(PD_SWIVELCHAIR, -9.439, -106.313, 902.002, 0.000, 0.000, -113.699, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)
	CreateDynamicObject(PD_SWIVELCHAIR, -9.513, -104.600, 901.980, 0.000, 0.000, -72.899, COP_WORLD, COP_INTERIOR); // Kate_Mercer (1715)

	// Units/Printer
	CreateDynamicObject(2167, -7.467, -96.933, 901.988, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2167)
	CreateDynamicObject(2186, -4.544, -86.494, 901.990, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2186)

	// Podiums
	CreateDynamicObject(PD_PODIUM, -5.044, -119.880, 897.750, 0.000, 0.000, -41.699, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5596)
	CreateDynamicObject(PD_PODIUM, -9.076, -95.069, 902.211, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5596)

	// Conference Chairs
	CreateDynamicObject(PD_SWIVELCHAIR, -12.685, -92.915, 902.001, 0.000, 0.000, -15.800, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -13.939, -92.756, 901.990, 0.000, 0.000, -2.299, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -15.482, -92.842, 901.990, 0.000, 0.000, 6.599, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -16.828, -92.938, 901.990, 0.000, 0.000, 14.400, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -19.110, -95.808, 901.990, 0.000, 0.000, 99.500, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -19.178, -94.413, 901.990, 0.000, 0.000, 77.899, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -17.049, -97.190, 901.990, 0.000, 0.000, 167.999, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -15.747, -97.272, 901.990, 0.000, 0.000, 175.300, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -14.314, -97.270, 901.990, 0.000, 0.000, -177.099, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5590)
	CreateDynamicObject(PD_SWIVELCHAIR, -12.850, -97.047, 901.989, 0.000, 0.000, -166.098, COP_WORLD, COP_INTERIOR); // Spooky (-5586)

	// Det Desks
	CreateDynamicObject(2008, -1.703, -82.066, 901.991, 0.000, 0.000, 180.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2008)
	CreateDynamicObject(2008, -3.546, -83.278, 902.011, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2008)
	CreateDynamicObject(2008, -3.747, -93.853, 901.990, 0.000, 0.000, 90.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2008)
	CreateDynamicObject(2008, -4.914, -93.018, 902.020, 0.000, 0.000, 270.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (2008)

	// Textured:
	new copfolders[13];
	copfolders[0] = CreateDynamicObject(2162, -15.61, -83.00, 901.850,   0.00, 0.00, 181.20, COP_WORLD, COP_INTERIOR);
	copfolders[1] = CreateDynamicObject(2162, -18.59, -79.55, 901.960,   0.00, 0.00, 0.60, COP_WORLD, COP_INTERIOR);
	copfolders[2] = CreateDynamicObject(2162, -12.36, -94.62, 897.72,   0.00, 0.00, 365.82, COP_WORLD, COP_INTERIOR);
	copfolders[3] = CreateDynamicObject(2162, -15.52, -91.35, 897.71,   0.00, 0.00, 7.92, COP_WORLD, COP_INTERIOR);
	copfolders[4] = CreateDynamicObject(2162, -13.13, -100.14, 897.69,   0.00, 0.00, 552.12, COP_WORLD, COP_INTERIOR);
	copfolders[5] = CreateDynamicObject(2162, -9.99, -96.41, 898.02,   0.00, 0.00, 277.80, COP_WORLD, COP_INTERIOR);
	copfolders[6] = CreateDynamicObject(2162, -16.76, -90.51, 897.45,   0.00, 0.00, 182.10, COP_WORLD, COP_INTERIOR);
	copfolders[7] = CreateDynamicObject(2162, -13.61, -90.71, 898.04,   0.00, 0.00, 189.36, COP_WORLD, COP_INTERIOR);
	copfolders[8] = CreateDynamicObject(2162, -15.83, -82.06, 897.45,   0.00, 0.00, 182.10, COP_WORLD, COP_INTERIOR);
	copfolders[9] = CreateDynamicObject(2162, -16.49, -79.54, 901.960,   0.00, 0.00, 0.60, COP_WORLD, COP_INTERIOR);
	copfolders[10] = CreateDynamicObject(2162, -15.24, -79.60, 901.960,   0.00, 0.00, 6.36, COP_WORLD, COP_INTERIOR);
	copfolders[11] = CreateDynamicObject(2162, -13.58, -88.17, 901.850,   0.00, 0.00, 544.26, COP_WORLD, COP_INTERIOR);
	copfolders[12] = CreateDynamicObject(2162, -10.12, -85.43, 901.850,   0.00, 0.00, 633.72, COP_WORLD, COP_INTERIOR);

	for (new i = 0; i < sizeof(copfolders); i ++)
	{
		SetDynamicObjectMaterial(copfolders[i], 1, 18887, "forcefields", "white");
		SetDynamicObjectMaterial(copfolders[i], 2, 18887, "forcefields", "white");
	}

	new coprubbish[6];
	coprubbish[0] = CreateDynamicObject(2674, -10.97, -86.56, 902.010,   0.00, 0.00, -60.36, COP_WORLD, COP_INTERIOR);
	coprubbish[1] = CreateDynamicObject(2674, -15.50, -86.50, 902.010,   0.00, 0.00, -60.36, COP_WORLD, COP_INTERIOR);
	coprubbish[2] = CreateDynamicObject(2674, -4.44, -85.31, 902.010,   0.00, 0.00, -60.36, COP_WORLD, COP_INTERIOR);
	coprubbish[3] = CreateDynamicObject(2674, -10.48, -101.48, 897.57,   0.00, 0.00, 57.00, COP_WORLD, COP_INTERIOR);
	coprubbish[4] = CreateDynamicObject(2674, -12.40, -83.89, 902.010,   0.00, 0.00, 112.98, COP_WORLD, COP_INTERIOR);
	coprubbish[5] = CreateDynamicObject(2674, -12.13, -86.69, 902.010,   0.00, 0.00, 53.94, COP_WORLD, COP_INTERIOR);

	for (new i = 0; i < sizeof(coprubbish); i ++)
	{
		SetDynamicObjectMaterial(coprubbish[i], 0, 18887, "forcefields", "white");
	}

	new copmat = CreateDynamicObject(2261, -14.510, -103.183, 898.067, 270.000, 0.000, -2.500, COP_WORLD, COP_INTERIOR);// Apple_Mercer (2261)
	SetDynamicObjectMaterial(copmat, 0, 18646, "matcolours", "grey-70-percent");
	SetDynamicObjectMaterial(copmat, 1, 19362, "all_walls", "la_carp3");

	// Coffee Steam
	CreateDynamicObject(18673, -14.995626, -89.715026, 896.963684, 0.000000, 0.000000, 0.000000, COP_WORLD, COP_INTERIOR);

	new copkitchen[4];
	copkitchen[0] = CreateDynamicObject(2136, -20.33, -86.89, 902.000,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	copkitchen[1] = CreateDynamicObject(2139, -20.30, -84.92, 902.000,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	copkitchen[2] = CreateDynamicObject(2139, -20.30, -83.95, 902.000,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	copkitchen[3] = CreateDynamicObject(2139, -20.30, -82.96, 902.000,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);

	for (new i = 0; i < sizeof(copkitchen); i++)
	{
		SetDynamicObjectMaterial(copkitchen[i], 2, 2163, "cj_office", "CJ_WOOD5", 0);
		SetDynamicObjectMaterial(copkitchen[i], 3, 2163, "cj_office", "white32", 0);
	}

	SetDynamicObjectMaterial(copkitchen[0], 4, 2163, "cj_office", "white32", 0);

    // Misc shit I placed ingame
    CreateDynamicObject(SD_INT_TAPEREC, -22.838, -97.996, 898.561, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5710)
    CreateDynamicObject(SD_INT_TAPEREC, -23.972, -106.250, 898.541, 0.000, 0.000, -179.699, COP_WORLD, COP_INTERIOR);// Kate_Mercer (-5710)
    CreateDynamicObject(SD_INT_EVBAG, -12.862, -94.716, 898.651, 0.000, 0.000, -143.500, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5713)
    CreateDynamicObject(SD_INT_TYPER, -14.751, -98.534, 898.801, 0.000, 0.000, 103.200, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-5719)
    CreateDynamicObject(-25408, -20.522, -83.005, 903.252, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR); // Kate_Mercer (-25408)


	// The rest:
	CreateDynamicObject(11711, -18.566, -116.655, 900.49, 0.000, 0.000, 0.000, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -13.01, -97.46, 897.55,   0.00, 0.00, 448.08, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2604, -10.34, -100.31, 898.33,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2007, -10.46, -96.57, 897.56,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(11706, -11.02, -91.60, 897.52,   0.00, 0.00, -3.54, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(11713, -7.33, -91.31, 899.01,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19809, -15.05, -96.06, 898.75,   0.00, 0.00, -82.98, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19043, -14.98, -96.05, 898.73,   0.00, 0.00, 140.74, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2741, -13.52, -103.29, 899.10,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19903, -10.16, -102.77, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(11711, -3.48, -92.76, 900.49,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19809, -14.98, -95.62, 898.75,   0.00, 0.00, -59.28, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2690, -7.18, -91.40, 897.92,   0.00, 0.00, 369.06, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2690, -7.56, -91.42, 897.92,   0.00, 0.00, 356.10, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19809, -18.59, -91.53, 898.70,   0.00, 0.00, -81.42, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -15.07, -89.43, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -17.04, -90.43, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -16.57, -88.96, 897.54,   0.00, 0.00, 215.70, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -17.74, -89.03, 897.54,   0.00, 0.00, 170.64, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2342, -14.94, -89.59, 898.50,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2000, -13.49, -90.32, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2000, -14.01, -90.32, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2186, -20.34, -86.95, 897.56,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2186, -20.34, -85.04, 897.56,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2613, -20.07, -86.52, 897.56,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2197, -19.43, -82.53, 897.54,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2197, -19.44, -81.83, 897.54,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2197, -19.45, -81.12, 897.54,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -15.83, -81.92, 897.56,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -17.84, -80.90, 897.56,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -15.35, -80.56, 897.54,   0.00, 0.00, 116.10, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -18.58, -81.41, 897.54,   0.00, 0.00, 261.42, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1808, -20.04, -90.64, 897.56,   0.00, 0.00, 180.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2613, -20.30, -89.71, 897.56,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1808, -10.19, -97.36, 897.56,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1209, -8.51, -91.35, 897.54,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2811, -11.13, -90.53, 897.56,   0.00, 0.00, -40.62, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19835, -16.62, -81.56, 898.46,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2613, -10.20, -100.78, 897.56,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19805, -20.88, -83.69, 904.070,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19805, -20.88, -86.28, 904.070,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2149, -20.40, -82.97, 903.220,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2830, -20.45, -86.65, 903.060,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2647, -20.42, -86.97, 903.210,   0.00, 0.00, 202.02, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(19835, -20.41, -84.05, 903.140,   0.00, 0.00, -36.36, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2426, -20.50, -84.85, 903.080,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -10.25, -83.47, 901.980,   0.00, 0.00, 90.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -12.31, -82.46, 901.980,   0.00, 0.00, 270.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -13.66, -87.82, 901.980,   0.00, 0.00, 89.88, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -15.73, -86.83, 901.990,   0.00, 0.00, 269.76, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -16.70, -84.69, 901.980,   0.00, 0.00, -0.06, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -15.69, -82.65, 901.980,   0.00, 0.00, 179.94, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2008, -11.42, -87.48, 901.980,   0.00, 0.00, 359.76, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1998, -10.39, -85.45, 901.980,   0.00, 0.00, 179.70, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -17.10, -87.58, 902.000,   0.00, 0.00, -82.08, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -13.18, -86.62, 902.000,   0.00, 0.00, 118.32, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -12.60, -83.82, 902.000,   0.00, 0.00, -53.52, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -15.54, -85.23, 902.000,   0.00, 0.00, 16.50, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -16.42, -81.96, 902.000,   0.00, 0.00, 191.58, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -11.60, -85.02, 902.000,   0.00, 0.00, 219.06, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -10.72, -87.97, 902.000,   0.00, 0.00, 363.72, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(1806, -8.99, -82.39, 902.000,   0.00, 0.00, 475.32, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2186, -9.87, -79.95, 901.980,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2186, -11.77, -79.96, 901.980,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2163, -15.29, -79.49, 902.000,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2163, -17.09, -79.49, 902.000,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2163, -18.89, -79.49, 902.000,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2342, -10.79, -86.52, 902.910,   0.00, 0.00, -117.96, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2342, -12.25, -82.33, 902.910,   0.00, 0.00, -10.14, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2342, -16.58, -83.62, 902.910,   0.00, 0.00, -57.66, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2647, -11.17, -87.34, 902.980,   0.00, 0.00, 138.36, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(3017, -12.26, -82.54, 902.800,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2828, -10.50, -83.49, 902.790,   0.00, 0.00, -93.72, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2250, -16.30, -83.50, 903.220,   0.00, 0.00, 67.98, COP_WORLD, COP_INTERIOR);
	CreateDynamicObject(2613, -12.19, -78.78, 902.000,   0.00, 0.00, 0.00, COP_WORLD, COP_INTERIOR);
}