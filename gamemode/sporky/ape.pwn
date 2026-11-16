//------------------------------------------------------------------------------
// This file does not exist.

#include <YSI_Coding\y_hooks>

#define AP_GARAGE_X 1352.63
#define AP_GARAGE_Y -1647.34
#define AP_GARAGE_Z 14.70

#define AP_LABS_X (AP_GARAGE_X + -0.176)
#define AP_LABS_Y (AP_GARAGE_Y + 6.178)
#define AP_LABS_Z (AP_GARAGE_Z + -1.075)

#define AP_JAIL_TOP_X (AP_LABS_X + -3.251)
#define AP_JAIL_BOT_X (AP_LABS_X + 3.251)
#define AP_JAIL_Y (AP_LABS_Y + 7.317)
#define AP_JAIL_Z (AP_LABS_Z + 1.004)

static OBJ_AP_GARAGE_INT = -1;

enum
{
	AP_GARAGE = -5799,
	AP_GARAGEINT,
	AP_LABS,
	AP_LABGLASS,
	AP_JAIL,
	AP_JAILGLASS,
	AP_JAILDOOR,
	AP_GRGDOOR
}

static AddModels()
{
    AddSimpleModel(-1, 1923, AP_GARAGE, "sporky/ap/ap_garage.dff", "sporky/ap/apgarage.txd");
    AddSimpleModel(-1, 1923, AP_GARAGEINT, "sporky/ap/ap_garageint.dff", "sporky/ap/apgarage.txd");
    AddSimpleModel(-1, 1923, AP_LABS, "sporky/ap/ap_labs.dff", "sporky/ap/aplabs.txd");
    AddSimpleModel(-1, 16655, AP_LABGLASS, "sporky/ap/ap_labglass.dff", "sporky/ap/apjail.txd");
    AddSimpleModel(-1, 1923, AP_JAIL, "sporky/ap/ap_jail.dff", "sporky/ap/apjail.txd");
    AddSimpleModel(-1, 14883, AP_JAILGLASS, "sporky/ap/ap_jailglass.dff", "sporky/ap/apjail.txd");
    AddSimpleModel(-1, 14883, AP_JAILDOOR, "sporky/ap/ap_jaildoor.dff", "sporky/ap/apjail.txd");
    AddSimpleModel(-1, 14883, AP_GRGDOOR, "sporky/ap/ap_grgdoor.dff", "sporky/ap/apgarage.txd");
}

static CreateObjects()
{
    OBJ_AP_GARAGE_INT = CreateObject(AP_GARAGEINT, AP_GARAGE_X, AP_GARAGE_Y, AP_GARAGE_Z, 0.00, 0.00, 0.00, 300.0);

    CreateDynamicObject(AP_GARAGE, AP_GARAGE_X, AP_GARAGE_Y, AP_GARAGE_Z, 0.0, 0.0, 0.0, -1, 0, -1, 500.0);
	CreateDynamicObject(AP_LABS, AP_LABS_X, AP_LABS_Y, AP_LABS_Z, 0.0, 0.0, 0.0, -1, 0, -1, 100.0);
	CreateDynamicObject(AP_LABGLASS, AP_LABS_X, AP_LABS_Y, AP_LABS_Z, 0.0, 0.0, 0.0, -1, 0, -1, 50.0);
	CreateDynamicObject(AP_JAIL, AP_JAIL_TOP_X, AP_JAIL_Y, AP_JAIL_Z, 0.0, 0.0, 0.0, -1, 0, -1, 100.0);
	CreateDynamicObject(AP_JAILGLASS, AP_JAIL_TOP_X + -0.132, AP_JAIL_Y + -1.793, AP_JAIL_Z + -0.566, 0.0, 0.0, 0.0, -1, 0, -1, 100.0);
	CreateDynamicObject(AP_JAIL, AP_JAIL_BOT_X, AP_JAIL_Y, AP_JAIL_Z, 0.0, 0.0, 0.0, -1, 0, -1, 100.0);
	CreateDynamicObject(AP_JAILGLASS, AP_JAIL_BOT_X + -0.132, AP_JAIL_Y + -1.793, AP_JAIL_Z + -0.566, 0.0, 0.0, 0.0, -1, 0, -1, 100.0);
}

hook OnGameModeInit()
{
	printf("[AP] Loading and creating AP Garage: %d", OBJ_AP_GARAGE_INT);

	AddModels();
	CreateObjects();

	print("[AP] Loaded and created AP Garage");
	return 1;
}