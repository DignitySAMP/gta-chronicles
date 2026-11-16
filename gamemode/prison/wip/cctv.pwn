//------------------------------------------------------------------------------
// Interactive CCTV Cameras with Moving Objects
// Written by Sporky (www.github.com/sporkyspork) for SOLS

// TODO: Add graphics/textdraws (Rusu?)

#include <YSI_Coding\y_hooks>

#define CCTV_BASE_MODEL -7526
#define CCTV_MOVE_MODEL -7527  

static enum E_CCTV_PLAYER_VARS
{
    bool:E_CCTV_PLAYER_ACTIVE,
    E_CCTV_PLAYER_NET_INDEX,
    E_CCTV_PLAYER_NET_NETWORK,
    E_CCTV_PLAYER_CCTV_INDEX,
    E_CCTV_PLAYER_LAST_SWITCHED,
    E_CCTV_PLAYER_CAM_OBJECT,
    bool:E_CCTV_PLAYER_IS_CREATING,
    E_CCTV_PLAYER_CREATE_NET,
    E_CCTV_PLAYER_CREATE_OBJ[2],
    E_CCTV_PLAYER_CREATE_NAME[32],
}

static CCTVPlayer[MAX_PLAYERS][E_CCTV_PLAYER_VARS];

static ClearVars(playerid)
{
 	new cvar_clear[E_CCTV_PLAYER_VARS];
	CCTVPlayer[playerid] = cvar_clear;
    DeletePVar(playerid, "CCTV");
}

enum E_CCTV_NETWORK_DATA
{
    Float:E_CCTV_NET_POS_X,
    Float:E_CCTV_NET_POS_Y,
    Float:E_CCTV_NET_POS_Z,
    Float:E_CCTV_NET_POS_A,
    E_CCTV_NET_NETWORK,
    E_CCTV_NET_NAME[32],
    E_CCTV_NET_USER,
    E_CCTV_NET_USING,
    STREAMER_TAG_AREA E_CCTV_NET_ZONE,
    STREAMER_TAG_3D_TEXT_LABEL E_CCTV_NET_LABEL
}

#define CCTV_NET_SECTOR1 0
#define CCTV_NET_SECTOR2 1

static const CCTVNetwork[][E_CCTV_NETWORK_DATA] = 
{
    {1786.0963, -1554.1460, 38.0304, 315.0, CCTV_NET_SECTOR1, "Sector 1"}, //CCTV_NET_SECTOR1
    {1786.2772, -1558.3503, 38.0304, 225.0, CCTV_NET_SECTOR2, "Sector 2"}  //CCTV_NET_SECTOR2
};

enum E_CCTV_DATA
{
    Float:E_CCTV_POS_X,
    Float:E_CCTV_POS_Y,
    Float:E_CCTV_POS_Z,
    Float:E_CCTV_POS_A,
    E_CCTV_NETWORK,
    E_CCTV_NAME[32],
    Float:E_CCTV_ROT_Z, // defaults to POS_A -15.0
    Float:E_CCTV_ROT_Y, // defaults to -17.5
    E_CCTV_BASE_OBJECT,
    E_CCTV_MOVE_OBJECT,
    E_CCTV_SPEC_OBJECT,
    STREAMER_TAG_3D_TEXT_LABEL E_CCTV_LABEL,
    E_CCTV_NETWORK_INDEX,
    E_CCTV_MOVE_STAGE,
    Float:E_CCTV_INTERP[6]
}

static const CCTV[][E_CCTV_DATA] = 
{
    { 1789.03, -1547.47, 37.69, 180.0, CCTV_NET_SECTOR1, "187 Main Pod" },
    { 1802.22, -1550.98, 38.79, -90.0, CCTV_NET_SECTOR1, "187 A Pod", 15.0 },
    { 1802.10, -1554.45, 38.85, 90.0, CCTV_NET_SECTOR1, "187 B Pod", 15.0 },
    { 1756.79, -1535.43, 37.63, 180.0, CCTV_NET_SECTOR1, "S1 Hallway" },
    { 1786.99, -1511.20, 35.50, 0.00, CCTV_NET_SECTOR1, "Kitchen", 40.0 },
    { 1770.92, -1533.67, 35.35, -90.0, CCTV_NET_SECTOR1, "Canteen", -22.5 },
    { 1779.92, -1541.20, 36.27, 90.0, CCTV_NET_SECTOR2, "Fitness", -30.0 },
    { 1760.00, -1533.72, 35.38, -90.0, CCTV_NET_SECTOR1, "Laundry", -22.5 },
    { 1764.63, -1541.23, 35.33, 90.0, CCTV_NET_SECTOR1, "Library", -35.0 }
};

static GetCCTVNetIndex(cctv)
{
    return CCTV[cctv][E_CCTV_NETWORK_INDEX];
}

static ViewCCTV(playerid, cam)
{
    CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX] = cam;
    CCTVPlayer[playerid][E_CCTV_PLAYER_LAST_SWITCHED] = gettime();

    new Float:x, Float:y, Float:z;
    // if (IsValidDynamicObject(CCTV[cam][E_CCTV_SPEC_OBJECT])) DestroyDynamicObject(CCTV[cam][E_CCTV_SPEC_OBJECT]);
    GetDynObjRelativePos(CCTV[cam][E_CCTV_BASE_OBJECT], x, y, z, -0.3, 0.0, 0.1);
    SetPlayerCameraPos(playerid, x, y, z);

    GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -1.0, 0.0, 0.0);
    SetPlayerCameraLookAt(playerid, x, y, z);

    CCTV[cam][E_CCTV_INTERP][0] = x;
    CCTV[cam][E_CCTV_INTERP][1] = y;
    CCTV[cam][E_CCTV_INTERP][2] = z;

    //CCTV[nextcam][E_CCTV_SPEC_OBJECT] = CreateDynamicObject(19300, x, y, z, 0.0, 0.0, rz);
    ShowPlayerFooter(playerid, sprintf("~b~%s", CCTV[cam][E_CCTV_NAME]));
}

static StopCCTV(playerid)
{
    new index = CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX];
    new netindex = CCTVPlayer[playerid][E_CCTV_PLAYER_NET_INDEX];

    DestroyDynamicObject(CCTV[index][E_CCTV_SPEC_OBJECT]);
    SetCameraBehindPlayer(playerid);
    SendClientMessage(playerid, -1, sprintf("You are no longer using the \"%s\" CCTV Network Access Point.", CCTVNetwork[netindex][E_CCTV_NET_NAME]));

    SetPlayerPos(playerid, CCTVNetwork[netindex][E_CCTV_NET_POS_X], CCTVNetwork[netindex][E_CCTV_NET_POS_Y], CCTVNetwork[netindex][E_CCTV_NET_POS_Z]);
    SetPlayerFacingAngle(playerid, CCTVNetwork[netindex][E_CCTV_NET_POS_A]);
    ClearAnimations(playerid);

    CCTVNetwork[CCTVPlayer[playerid][E_CCTV_PLAYER_NET_INDEX]][E_CCTV_NET_USER] = INVALID_PLAYER_ID;
    ClearVars(playerid);
    CallRemoteFunction("RefreshPrison", "d", playerid);
}

static MoveCCTV(cam)
{
    new Float:x, Float:y, Float:z;
    GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -0.5, 0.0, 0.0);

    if (CCTV[cam][E_CCTV_MOVE_STAGE] == 0) 
    {
        MoveDynamicObject(CCTV[cam][E_CCTV_MOVE_OBJECT], CCTV[cam][E_CCTV_POS_X] + 0.01, CCTV[cam][E_CCTV_POS_Y] - 0.01, CCTV[cam][E_CCTV_POS_Z], 0.01, 0.0, CCTV[cam][E_CCTV_ROT_Y], CCTV[cam][E_CCTV_ROT_Z]);
        CCTV[cam][E_CCTV_MOVE_STAGE] = 1;
    }
    else if (CCTV[cam][E_CCTV_MOVE_STAGE] == 1)
    {
        MoveDynamicObject(CCTV[cam][E_CCTV_MOVE_OBJECT], CCTV[cam][E_CCTV_POS_X] - 0.01, CCTV[cam][E_CCTV_POS_Y] + 0.01, CCTV[cam][E_CCTV_POS_Z], 0.01, 0.0, CCTV[cam][E_CCTV_ROT_Y], CCTV[cam][E_CCTV_ROT_Z] + 45.0);
        CCTV[cam][E_CCTV_MOVE_STAGE] = 2;
    }
    else if (CCTV[cam][E_CCTV_MOVE_STAGE] == 2)
    {
        MoveDynamicObject(CCTV[cam][E_CCTV_MOVE_OBJECT], CCTV[cam][E_CCTV_POS_X] + 0.01, CCTV[cam][E_CCTV_POS_Y] - 0.01, CCTV[cam][E_CCTV_POS_Z], 0.01, 0.0, CCTV[cam][E_CCTV_ROT_Y], CCTV[cam][E_CCTV_ROT_Z]);
        CCTV[cam][E_CCTV_MOVE_STAGE] = 3;
    } 
    else if (CCTV[cam][E_CCTV_MOVE_STAGE] == 3)
    {
        MoveDynamicObject(CCTV[cam][E_CCTV_MOVE_OBJECT], CCTV[cam][E_CCTV_POS_X] - 0.01, CCTV[cam][E_CCTV_POS_Y] + 0.01, CCTV[cam][E_CCTV_POS_Z], 0.01, 0.0, CCTV[cam][E_CCTV_ROT_Y], CCTV[cam][E_CCTV_ROT_Z] - 45.0);
        CCTV[cam][E_CCTV_MOVE_STAGE] = 0;
    }

    foreach (new playerid : Player)
    {
        if (!CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE]) continue;
        if (CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX] == cam)
        {
            InterpolateCameraLookAt(playerid, CCTV[cam][E_CCTV_INTERP][0], CCTV[cam][E_CCTV_INTERP][1], CCTV[cam][E_CCTV_INTERP][2], x, y, z, 2500, CAMERA_MOVE);
            CCTV[cam][E_CCTV_INTERP][0] = x;
            CCTV[cam][E_CCTV_INTERP][1] = y;
            CCTV[cam][E_CCTV_INTERP][2] = z;
            break;
        }
    }
}

// -------------------------------------------------------------

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA areaid)
{
    if (CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE])
    {
        new netindex = CCTVPlayer[playerid][E_CCTV_PLAYER_NET_INDEX];
        if (areaid == CCTVNetwork[netindex][E_CCTV_NET_ZONE])
        {
            // Stop CCTV if they leave the area.
            StopCCTV(playerid);
        }
    }

    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE] && newstate != PLAYER_STATE_ONFOOT)
    {
        // Stop CCTV if they do something else
        StopCCTV(playerid);
    }

    return 1;
}

hook OnPlayerUpdate(playerid)
{
    if (CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE])
    {
        //new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
        new cam = CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX];

        //GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -0.5, 0.0, 0.1);
        //SetPlayerCameraPos(playerid, x, y, z);
        //GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -1.0, 0.0, 0.0);
        //SetPlayerCameraLookAt(playerid, x, y, z);

        if (GetPlayerAnimationIndex(playerid) != 305)
        {
            ApplyAnimation(playerid, "CASINO", "SLOT_WAIT", 4.1, 1, 0, 0, 0, 0, 0);
        }

        if (CCTVPlayer[playerid][E_CCTV_PLAYER_LAST_SWITCHED] && gettime() == CCTVPlayer[playerid][E_CCTV_PLAYER_LAST_SWITCHED])
        {
            // make them wait
            return 1;
        }

        new Keys, ud, lr;
        GetPlayerKeys(playerid, Keys, ud, lr);
        
        if (lr == KEY_RIGHT)
        {
            new nextcam = 0;
            new firstcam = -1;
           
            for (new i = 0; i < sizeof(CCTV); i ++)
            {
                if (CCTV[i][E_CCTV_NETWORK] != CCTVPlayer[playerid][E_CCTV_PLAYER_NET_NETWORK]) continue;
                if (firstcam == -1) firstcam = i;
                if (i > cam)
                {
                    nextcam = i;
                    break;
                }
            }

            if (!nextcam) nextcam = firstcam;
            ViewCCTV(playerid, nextcam);
            ApplyAnimation(playerid, "CASINO", "SLOT_BET_02", 4.1, 0, 0, 0, 0, 0, 0);

            // GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -0.5, 0.0, 0.1);
            //SetPlayerCameraPos(playerid, x, y, z);
            //GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -1.0, 0.0, 0.0);
            ///SetPlayerCameraLookAt(playerid, x, y, z);

            //GetDynObjRelativePos(CCTV[nextcam][E_CCTV_MOVE_OBJECT], x, y, z, 0.0, -1.0, 0.0);
            //SetPlayerCameraLookAt(playerid, x, y, z);
            //AttachCameraToDynamicObject(playerid, CCTV[nextcam][E_CCTV_SPEC_OBJECT]);
        }
        else if (lr == KEY_LEFT)
        {
            new prevcam = 0;
            new lastcam = -1;

            for (new i = sizeof(CCTV) - 1; i >= 0; i --)
            {
                if (CCTV[i][E_CCTV_NETWORK] != CCTVPlayer[playerid][E_CCTV_PLAYER_NET_NETWORK]) continue;
                if (lastcam == -1) lastcam = i;
                if (i < CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX])
                {
                    prevcam = i;
                    break;
                }
            }

            if (!prevcam) prevcam = lastcam;
            ViewCCTV(playerid, prevcam);
            ApplyAnimation(playerid, "CASINO", "SLOT_BET_02", 4.1, 0, 0, 0, 0, 0, 0);

            //GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -0.5, 0.0, 0.1);
            //SetPlayerCameraPos(playerid, x, y, z);
            //GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -1.0, 0.0, 0.0);
            //SetPlayerCameraLookAt(playerid, x, y, z);
            
            //GetDynObjRelativePos(CCTV[prevcam][E_CCTV_MOVE_OBJECT], x, y, z, 0.0, 1.0, 0.0);
            //SetPlayerCameraLookAt(playerid, x, y, z);
            //AttachCameraToDynamicObject(playerid, CCTV[prevcam][E_CCTV_SPEC_OBJECT]);
        }
    }

    return 1;
}

hook OnPlayerConnect(playerid)
{
    ClearVars(playerid);
    return 1;
}

hook OnPrisonLoad()
{
    // Add models
    AddSimpleModel(-1, 1923, CCTV_BASE_MODEL, "twin/int/cctvbase.dff", "twin/int/cctvcam.txd");
    AddSimpleModel(-1, 1616, CCTV_MOVE_MODEL, "twin/int/cctvmove.dff", "twin/int/cctvcam.txd");
    
    new Float:x, Float:y, Float:z, text[64], netindex;
    //new Float:rx, Float:ry, Float:rz;

    for (new i = 0; i < sizeof(CCTVNetwork); i ++)
    {
        format(text, sizeof(text), "[CCTV: %s]{DEDEDE}\nType {c4a656}/cctv {DEDEDE}to use.", CCTVNetwork[i][E_CCTV_NET_NAME]);
        CCTVNetwork[i][E_CCTV_NET_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, CCTVNetwork[i][E_CCTV_NET_POS_X], CCTVNetwork[i][E_CCTV_NET_POS_Y], CCTVNetwork[i][E_CCTV_NET_POS_Z], 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
        CCTVNetwork[i][E_CCTV_NET_USER] = INVALID_PLAYER_ID;
        CCTVNetwork[i][E_CCTV_NET_ZONE] = CreateDynamicSphere(CCTVNetwork[i][E_CCTV_NET_POS_X], CCTVNetwork[i][E_CCTV_NET_POS_Y], CCTVNetwork[i][E_CCTV_NET_POS_Z], 3.0);
    }

    for (new i = 0; i < sizeof(CCTV); i ++)
    {
        CCTV[i][E_CCTV_BASE_OBJECT] = CreateDynamicObject(CCTV_BASE_MODEL, CCTV[i][E_CCTV_POS_X], CCTV[i][E_CCTV_POS_Y], CCTV[i][E_CCTV_POS_Z], 0.0, 0.0, CCTV[i][E_CCTV_POS_A]);

        if (!CCTV[i][E_CCTV_ROT_Z]) CCTV[i][E_CCTV_ROT_Z] = -15.0;
        CCTV[i][E_CCTV_ROT_Z] = CCTV[i][E_CCTV_POS_A] + CCTV[i][E_CCTV_ROT_Z];
        
        if (!CCTV[i][E_CCTV_ROT_Y]) CCTV[i][E_CCTV_ROT_Y] = - 17.5;
        CCTV[i][E_CCTV_MOVE_OBJECT] = CreateDynamicObject(CCTV_MOVE_MODEL, CCTV[i][E_CCTV_POS_X], CCTV[i][E_CCTV_POS_Y], CCTV[i][E_CCTV_POS_Z], 0.0, CCTV[i][E_CCTV_ROT_Y], CCTV[i][E_CCTV_ROT_Z]);
        
        CCTV[i][E_CCTV_MOVE_STAGE] = random(4);
        MoveCCTV(i);

        for (new j = 0; j < sizeof(CCTVNetwork); j ++)
        {
            if (CCTV[i][E_CCTV_NETWORK] == CCTVNetwork[j][E_CCTV_NET_NETWORK])
            {
                netindex = j;
                break;
            } 
        }

        CCTV[i][E_CCTV_NETWORK_INDEX] = netindex;

        GetDynObjRelativePos(CCTV[i][E_CCTV_BASE_OBJECT], x, y, z, 0, 0.0, -0.175);
        format(text, sizeof(text), "[CCTV: %s]{DEDEDE}\n%s", CCTVNetwork[netindex][E_CCTV_NET_NAME], CCTV[i][E_CCTV_NAME]);
        CCTV[i][E_CCTV_LABEL] = CreateDynamic3DTextLabel(text, 0x3479E3FF, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

        new netcam = CCTVNetwork[netindex][E_CCTV_NET_USING];

        if (CCTV[netcam][E_CCTV_NETWORK] != CCTVNetwork[netindex][E_CCTV_NET_NETWORK])
        {
            CCTVNetwork[netindex][E_CCTV_NET_USING] = i;
        }
    }

    print("Prison: Loaded CCTV");
    return 1;
}

hook OnDynamicObjectMoved(STREAMER_TAG_OBJECT objectid)
{
    if (GetDynamicObjectModel(objectid) == CCTV_MOVE_MODEL)
    {
        for (new i = 0; i < sizeof(CCTV); i ++)
        {
            if (CCTV[i][E_CCTV_MOVE_OBJECT] == objectid)
            {
                MoveCCTV(i);
                break;
            }
        }
    }

    return 1;
}

// ----------------------------------------------------------------
#warning "CCTV dev code"

CMD:createcctv(playerid, params[])
{
    if (CCTVPlayer[playerid][E_CCTV_PLAYER_IS_CREATING]) return 1;

    new network, name[32];
    if (sscanf(params, "ds[32]", network, name)) return SendClientMessage(playerid, -1, "/createcctv [network] [name]");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    CCTVPlayer[playerid][E_CCTV_PLAYER_IS_CREATING] = true;
    CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][0] = CreateDynamicObject(CCTV_BASE_MODEL, x, y, z, 0.0, 0.0, 0.0);
    CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][1] = CreateDynamicObject(CCTV_MOVE_MODEL, x, y, z, 0.0, 0.0, 0.0);
    CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_NET] = network;
    format(CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_NAME], 32, "%s", name);
    
    EditDynamicObject(playerid, CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][0]);
    return 1;
}

CMD:cctv(playerid)
{
    if (CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE])
    {
        StopCCTV(playerid);
        return true;
    }

    // Find closest CCTV point
    new closest = -1;
    new Float:current;
    new Float:last = 2.5; // 2.50 radius for it

    for (new i = 0; i < sizeof(CCTVNetwork); i ++)
    {
        current = GetPlayerDistanceFromPoint(playerid, CCTVNetwork[i][E_CCTV_NET_POS_X], CCTVNetwork[i][E_CCTV_NET_POS_Y], CCTVNetwork[i][E_CCTV_NET_POS_Z]);
        if (current < last)
        {
            closest = i;
            last = current;
        }
    }

    if (closest == -1) return SendClientMessage(playerid, -1, "You are not at a CCTV Network Access Point.");
    if (IsPlayerConnected(CCTVNetwork[closest][E_CCTV_NET_USER])) return SendClientMessage(playerid, -1, "This CCTV Network Access Point is already in use.");

    CCTVNetwork[closest][E_CCTV_NET_USER] = playerid;
    SendClientMessage(playerid, -1, sprintf("You are now using the \"%s\" CCTV Network Access Point.", CCTVNetwork[closest][E_CCTV_NET_NAME]));

    // Attach the players camera to the created object
    // TogglePlayerSpectating(playerid, true);

    // new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE] = true;
    new cam = CCTVNetwork[closest][E_CCTV_NET_USING];
    ViewCCTV(playerid, cam);

    CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX] = cam;
    CCTVPlayer[playerid][E_CCTV_PLAYER_NET_INDEX] = closest;
    CCTVPlayer[playerid][E_CCTV_PLAYER_NET_NETWORK] = CCTVNetwork[closest][E_CCTV_NET_NETWORK];
    
    SetPlayerPos(playerid, CCTVNetwork[closest][E_CCTV_NET_POS_X], CCTVNetwork[closest][E_CCTV_NET_POS_Y], CCTVNetwork[closest][E_CCTV_NET_POS_Z]);
    SetPlayerFacingAngle(playerid, CCTVNetwork[closest][E_CCTV_NET_POS_A]);

    /*
    GetDynObjRelativePos(CCTV[cam][E_CCTV_MOVE_OBJECT], x, y, z, -0.3, 0.0, 0.1);
    GetDynamicObjectRot(CCTV[cam][E_CCTV_MOVE_OBJECT], rx, ry, rz);

    CCTV[cam][E_CCTV_SPEC_OBJECT] = CreateDynamicObject(19300, x, y, z, 0.0, 0.0, rz);
    CCTVPlayer[playerid][E_CCTV_PLAYER_ACTIVE] = true;
    CCTVPlayer[playerid][E_CCTV_PLAYER_CCTV_INDEX] = cam;
    CCTVPlayer[playerid][E_CCTV_PLAYER_NET_INDEX] = closest;
    CCTVPlayer[playerid][E_CCTV_PLAYER_NET_NETWORK] = CCTVNetwork[closest][E_CCTV_NET_NETWORK];
    
    SetPlayerPos(playerid, CCTVNetwork[closest][E_CCTV_NET_POS_X], CCTVNetwork[closest][E_CCTV_NET_POS_Y], CCTVNetwork[closest][E_CCTV_NET_POS_Z]);
    SetPlayerFacingAngle(playerid, CCTVNetwork[closest][E_CCTV_NET_POS_A]);
    */
   
    SetPVarInt(playerid, "CCTV", 1);
    CallLocalFunction("RefreshPrison", "d", playerid);

	//AttachCameraToDynamicObject(playerid, CCTV[cam][E_CCTV_SPEC_OBJECT]);

    return true;
}

hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz) 
{
    if (!CCTVPlayer[playerid][E_CCTV_PLAYER_IS_CREATING]) return 0;

    SetDynamicObjectPos(CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][1], x, y, z);
    SetDynamicObjectRot(CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][1], rx, ry, rz);
     
    if (response == EDIT_RESPONSE_FINAL)
    {
        printf("{ %.02f, %.02f, %.02f, %.02f, %d, \"%s\" },", x, y, z, rz, CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_NET], CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_NAME]);
        CCTVPlayer[playerid][E_CCTV_PLAYER_IS_CREATING] = false;
    }
    else if (response == EDIT_RESPONSE_CANCEL)
    {
        DestroyDynamicObject(CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][0]);
        DestroyDynamicObject(CCTVPlayer[playerid][E_CCTV_PLAYER_CREATE_OBJ][1]);
        CCTVPlayer[playerid][E_CCTV_PLAYER_IS_CREATING] = false;
    }

    return 1;
}

hook OnPlayerPrisonUpdate(playerid)
{
    // Hide/unhide depending on whether they are in the interior or not

    for (new i = 0; i < sizeof(CCTV); i ++)
    {
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, CCTV[i][E_CCTV_BASE_OBJECT], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, CCTV[i][E_CCTV_MOVE_OBJECT], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
        Streamer_ToggleItem(playerid, STREAMER_TYPE_3D_TEXT_LABEL, CCTV[i][E_CCTV_LABEL], PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE]);
    }

    return 1;
}