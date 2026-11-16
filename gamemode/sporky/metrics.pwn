/*

static TotalObjects;
static TotalDynamicObjects;
static TotalAddSimpleModel;

static enum E_SIMPLE_MODEL
{
    E_SIMPLE_MODEL_ID,
    E_SIMPLE_MODEL_BASE_ID,
    E_SIMPLE_MODEL_DFF[128],
    E_SIMPLE_MODEL_TXD[128], 
    bool:E_SIMPLE_MODEL_EXISTS,
    bool:E_SIMPLE_MODEL_USED,
}

static SimpleModels[30000][E_SIMPLE_MODEL];
static id;

static CheckModelUsed(modelid)
{
    if (modelid >= 0) return 0;
    id = modelid * -1;

    if (SimpleModels[id][E_SIMPLE_MODEL_USED])
    {
        return 1;
    }
    
    if (SimpleModels[id][E_SIMPLE_MODEL_EXISTS])
    {
        SimpleModels[id][E_SIMPLE_MODEL_USED] = true;
        // printf("[ADDED MODEL INFO] %d: %s, %s (Base ID: %d)", modelid, SimpleModels[id][E_SIMPLE_MODEL_DFF], SimpleModels[id][E_SIMPLE_MODEL_TXD], SimpleModels[id][E_SIMPLE_MODEL_BASE_ID]);
    }
    else
    {
        printf("[METRICS WARNING] %d is created but doesn't exist?.", modelid);
    }

    return 1;
}

// CreateDynamicObject hook.
STREAMER_TAG_OBJECT AC_CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, STREAMER_TAG_AREA areaid = STREAMER_TAG_AREA -1, priority = 0) 
{
    CheckModelUsed(modelid);

	//printf("[CDO] %d", modelid);
    TotalDynamicObjects ++;
	return CreateDynamicObject(modelid, x, y, z, rx, ry, rz, worldid, interiorid, playerid, streamdistance, drawdistance, areaid, priority);
}

#if defined _ALS_CreateDynamicObject
  #undef CreateDynamicObject
#else
    #define _ALS_CreateDynamicObject
#endif

#define CreateDynamicObject AC_CreateDynamicObject

// CreateObject hook.
AC_CreateObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:DrawDistance = 0.0)
{
    CheckModelUsed(modelid);

	//printf("[CO] %d", modelid);
    TotalObjects ++;
	return CreateObject(modelid, X, Y, Z, rX, rY, rZ, DrawDistance);
}

#if defined _ALS_CreateObject
  #undef CreateObject
#else
    #define _ALS_CreateObject
#endif

#define CreateObject AC_CreateObject

// AddSimpleModel hook.
AC_AddSimpleModel(virtualworld, baseid, newid, dffname[], txdname[])
{
    TotalAddSimpleModel ++;

    id = newid * -1;
    SimpleModels[id][E_SIMPLE_MODEL_ID] = newid;
    SimpleModels[id][E_SIMPLE_MODEL_BASE_ID] = baseid;
    SimpleModels[id][E_SIMPLE_MODEL_EXISTS] = true;
    format(SimpleModels[id][E_SIMPLE_MODEL_DFF], 128, dffname);
    format(SimpleModels[id][E_SIMPLE_MODEL_TXD], 128, txdname);

	return AddSimpleModel(virtualworld, baseid, newid, dffname, txdname);
}

#if defined _ALS_AddSimpleModel
  #undef AddSimpleModel
#else
    #define _ALS_AddSimpleModel
#endif

#define AddSimpleModel AC_AddSimpleModel



Metrics_PrintMetrics()
{
    printf("[METRICS] Total Models Added via AddSimpleModel: %d", TotalAddSimpleModel);
    printf("[METRICS] Total Dynamic Objects Created: %d", TotalDynamicObjects);
    printf("[METRICS] Total Static Objects Created: %d", TotalObjects);

    for (new i = 0; i < sizeof(SimpleModels); i ++)
    {
        if (SimpleModels[i][E_SIMPLE_MODEL_EXISTS] && !SimpleModels[i][E_SIMPLE_MODEL_USED])
        {
            printf("[UNUSED SIMPLE MODEL] Model %d: %s, %s (Base ID: %d) is potentially unused.", SimpleModels[i][E_SIMPLE_MODEL_ID], SimpleModels[i][E_SIMPLE_MODEL_DFF], SimpleModels[i][E_SIMPLE_MODEL_TXD], SimpleModels[i][E_SIMPLE_MODEL_BASE_ID]);
        }
    }
}

Metrics_ReportModelUsed(modelid)
{
    if (modelid >= 0) return 0;
    id = modelid * -1;

    if (SimpleModels[id][E_SIMPLE_MODEL_EXISTS])
    {
        SimpleModels[id][E_SIMPLE_MODEL_USED] = true;
    }
    else
    {
        printf("[MODEL WARNING] %d is created but doesn't exist?.", modelid);
    }

    return 1;
}

*/


Metrics_ReportModelUsed(modelid)
{
    #pragma unused modelid
    return 1;
}

Metrics_PrintMetrics()
{
    return 1;
}


/*
CMD:gotomodel(playerid, params[])
{
    new modelid, index;

    if (sscanf(params, "dD(0)", modelid, index))
    {
        return SendClientMessage(playerid, -1, "/gotomodel [model id] [instance (0 is the first object found of that model)]")
    }

    new Float:x, Float:y, Float:z;

    for (new i = 0; i < 50000; i++)
    {
        if (!IsValidDynamicObject(i)) continue;

		GetDynamicObjectPos(i, x, y, z);
	    if (IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	    {
	        if (confirmed) DestroyDynamicObject(i);
	        count ++;
	    }
    }
}
*/