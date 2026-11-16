#if defined _inc_maploader
    #undef _inc_maploader
#endif

#define MAX_MPARSE_PREFIX (128+1)

enum MPARSE_PREFIX_DATA {
    MPARSE_PREFIX_NAME[MAX_MPARSE_PREFIX char],
    MPARSE_PREFIX_ID
} ;

new g_ObjectVariables[MAX_OBJECTS][MPARSE_PREFIX_DATA], g_ObjectsAdded ;

static enum E_MAP_DATA
{
    E_MAP_NAME[128],
    bool:E_MAP_LOADED,
    bool:E_MAP_EXISTS
}

#define MAX_MAPS 100

static MapData[MAX_MAPS][E_MAP_DATA];

static const StaticModels[] =
{
    -1224, // westmont
    -1149, //rancho swap
    -1165, // miranda flats
    -990, // ryhes el corona
    -1046, -1052, -1041, // park hill
    -1146, -1144, -1138, -1137, // idlewood
    -1243, // pecado
    -1111, // lil mex
    -1134, -1207, // kelly park projects and kelly park itself
    -1074, // san pedro
    -1071, -1017, // car wash
    -1163, -1162, -1161, // toledo roads
    -1222 // seville ball court
};

static bool:IsStaticModel(modelid)
{
    for (new i = 0, j = sizeof(StaticModels); i < j; i ++)
    {
        if (modelid == StaticModels[i])
        {
            return true;
        }
    }

    return false;
}

CMD:listmaps(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < 6) return false;

    for (new i = 0; i < MAX_MAPS; i ++)
    {
        if (!MapData[i][E_MAP_EXISTS]) continue;
        SendClientMessage(playerid, -1, sprintf("%d: Map: %s | Loaded: %s", i, MapData[i][E_MAP_NAME], MapData[i][E_MAP_LOADED] ? "Yes" : "No"));
    }

    return true;
}

CMD:loadmap(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < 6) return false;

    new i;

	if ( sscanf ( params, "d", i ) || i < 0 || i >= MAX_MAPS || !MapData[i][E_MAP_EXISTS]) 
    {
		return SendServerMessage( playerid, COLOR_RED, "Syntax", "A3A3A3",  "/loadmap [map index] (taken from /listmaps)" );
	}

    if (MapData[i][E_MAP_LOADED])
    {
        return SendServerMessage( playerid, COLOR_RED, "Error", "A3A3A3",  "This map is already loaded." );
    }

    LoadMap(MapData[i][E_MAP_NAME]);
    SendClientMessage(playerid, -1, sprintf("Loaded Map: (%d) %s", i, MapData[i][E_MAP_NAME]));
    MapData[i][E_MAP_LOADED] = true;

    return true;
}



CMD:loadallmaps(playerid)
{
    if (GetPlayerAdminLevel(playerid) < 6) return false;

    for (new i = 0; i < MAX_MAPS; i ++)
    {
        // SendClientMessage(playerid, -1, sprintf("%d: Map: %s | Loaded: %s", i, MapData[i][E_MAP_NAME], MapData[i][E_MAP_LOADED] ? "Yes" : "No"));
        if (MapData[i][E_MAP_LOADED] || !MapData[i][E_MAP_EXISTS]) continue;

        cmd_loadmap(playerid, sprintf("%d", i));
    }

    return true;
}

MapHandler () {

    new count ;

    print("\n[map] Starting map import\n") ;

    new Directory:MapsDir = OpenDir("scriptfiles/maps"), fname[128], ENTRY_TYPE:ftype;

    new filename [ 64 ], str_remove [ 18 ] = "scriptfiles/maps/" ;

    while_loop( DirNext ( MapsDir, ftype, fname ) ) {

        if(ftype == E_DIRECTORY) continue;

        if ( count >= MAX_MAPS ) break;

        strcat(filename, fname);
        strdel(fname, 0, strlen(str_remove));

        printf("\n[map] Started loading %s", fname ) ;


        MapData[count][E_MAP_LOADED] = true;
        MapData[count][E_MAP_EXISTS] = true;
        format(MapData[count][E_MAP_NAME], 128, "%s", fname);

        LoadMap(fname);

        count ++ ;
    }

    new ret = CloseDir(MapsDir);

    printf("\n[map] Finished map import: loaded %d maps (%d)\n", count, ret ) ;

    MapHandler_Interiors ();
}
MapHandler_Interiors () {

    new count ;

    print("\n[map] Starting map interior import\n") ;

    new Directory:MapsDir = OpenDir("scriptfiles/maps/interiors"), fname[128], ENTRY_TYPE:ftype;

    new filename [ 64 ], str_remove [ 28 ] = "scriptfiles/maps/" ;

    while_loop( DirNext ( MapsDir, ftype, fname ) ) {

        if (ftype == E_DIRECTORY) continue;
        new int = 127;

        strdel(fname, 0, strlen(str_remove));
        strcat(filename, fname);
        printf("\n[map] Started loading Interior %s", fname ) ;


        // These need to exist in all virtual worlds as every property is in a different world
        // The only important thing is that they are in an interior world instead of the normal game world to avoid the airport madness
        // Interior world 127 will help us to distinguish properties etc that use custom mapped interiors

        if (!strcmp(fname, "interiors/ryhes_mybar001.map"))
        {
            int = 126;
        }

        LoadMap(fname, .interior=int, .virtualworld=-1);

        count ++ ;
    }

    new ret = CloseDir(MapsDir);

    printf("\n[map] Finished map interior import: loaded %d maps (%d)\n", count, ret ) ;
}

mparse_SetPrefixData ( prefix [], id ) {
    strtrim ( prefix, " " ) ;

    //if ( g_ObjectsAdded == MAX_OBJECTS ) return 0;
    if ( g_ObjectsAdded >= MAX_OBJECTS ) return 0;

    strpack ( g_ObjectVariables [ g_ObjectsAdded ] [ MPARSE_PREFIX_NAME], prefix, MAX_MPARSE_PREFIX ) ;
    g_ObjectVariables [ g_ObjectsAdded ++ ] [ MPARSE_PREFIX_ID ] = id ;

    return 1;
}

mparse_GetPrefixData ( prefix [] ) {

    new prefix_packed[MAX_MPARSE_PREFIX] ;

    strtrim(prefix, " ");
    strpack(prefix_packed, prefix, MAX_MPARSE_PREFIX);

    for_loop ( new index = g_ObjectsAdded - 1; index >= 0; index -- ) {

        if(strcmp(g_ObjectVariables[index][MPARSE_PREFIX_NAME], prefix_packed) == 0)
            return g_ObjectVariables[index][MPARSE_PREFIX_ID];
    }

    return INVALID_OBJECT_ID;
}

LoadMap(map[], interior=0, virtualworld=0) {
    new path[128], count, gatecount;

    format(path, sizeof path, "maps/%s", map);
    if(!fexist(path)) {
        
        printf(" * [ERROR] Called to load map \"%s\", couldn't find path \"%s\"", map, path );

        return 0;
    }

    new File:file_handle = fopen(path, io_read), buffer[512] ;
    if ( !file_handle ) return 0;

    while_loop(fread(file_handle, buffer))
    {
        new start_index;
        if((start_index = strfind(buffer, "SetObjectMaterialText")) != -1)
        {
            new
                prefix[MAX_MPARSE_PREFIX],
                text[50],
                materialindex,
                materialsize,
                fontface[50],
                fontsize,
                bold,
                fontcolor,
                backcolor,
                alignment
            ;

            if(
                sscanf(buffer[start_index], "p<(>{s[32]}p<,>s[31]s[50]iis[50]iixxp<)>i", prefix, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, alignment) &&
                sscanf(buffer[start_index], "p<(>{s[32]}p<,>s[31]s[50]iis[50]iiiip<)>i", prefix, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, alignment)
            ){
                continue;
            }

            new objectid = mparse_GetPrefixData(prefix);
            if(objectid == INVALID_OBJECT_ID)
                continue;

            strtrim(text, "\"");
            strtrim(fontface, "\"");

            SetDynamicObjectMaterialText(
                objectid,
                materialindex,
                text,
                materialsize,
                fontface,
                fontsize,
                bold,
                fontcolor,
                backcolor,
                alignment
            );
        }
        else if((start_index = strfind(buffer, "SetObjectMaterial")) != -1)
        {
            new
                prefix[MAX_MPARSE_PREFIX],
                materialindex,
                modelid,
                txd[50],
                texture[50],
                color
            ;

            if(
                sscanf(buffer[start_index], "p<(>{s[18]}p<,>s[31]iis[50]s[50]p<)>x", prefix, materialindex, modelid, txd, texture, color) &&
                sscanf(buffer[start_index], "p<(>{s[18]}p<,>s[31]iis[50]s[50]p<)>i", prefix, materialindex, modelid, txd, texture, color)
            ){
                continue;
            }

            new objectid = mparse_GetPrefixData(prefix);
            if(objectid == INVALID_OBJECT_ID)
                continue;

            strtrim(txd, "\"");
            strtrim(texture, "\"");

            SetDynamicObjectMaterial(
                objectid,
                materialindex,
                modelid,
                txd,
                texture,
                color
            );
        }

        else if((start_index = strfind(buffer, "CreateObject")) != -1)
        {
            new
                bool:prefix_found,
                prefix[MAX_MPARSE_PREFIX],
                modelid,
                Float:x,
                Float:y,
                Float:z,
                Float:rx,
                Float:ry,
                Float:rz,
                Float:stream_distance
            ;

            if(start_index > 0 && !sscanf(buffer, "p<=>s[31]p<(>{s[14]}p<,>ifffffp<)>f", prefix, modelid, x, y, z, rx, ry, rz))
                prefix_found = true, stream_distance = 25.0;
            else if(start_index > 0 && !sscanf(buffer, "p<=>s[31]p<(>{s[14]}p<,>iffffffp<)>f", prefix, modelid, x, y, z, rx, ry, rz, stream_distance))
                prefix_found = true;
            else if(!sscanf(buffer[start_index], "p<(>{s[13]}p<,>ifffffp<)>f", modelid, x, y, z, rx, ry, rz))
                prefix_found = false, stream_distance = 25.0;
            else if(!sscanf(buffer[start_index], "p<(>{s[13]}p<,>iffffffp<)>f", modelid, x, y, z, rx, ry, rz, stream_distance))
                prefix_found = false;
            else
                continue;

            
            new objectid = INVALID_OBJECT_ID;

            if (IsStaticModel(modelid))
            {
                // use CreateObject for things like roads to stop cars ever falling through
                objectid = CA_CreateObject_SC(modelid, x, y, z, rx, ry, rz, stream_distance);
                printf("[map] Created STATIC object (%d) for Model ID: %d", objectid, modelid);
            }
            else
            {
                objectid = CA_CreateDynamicObject_SC(modelid, x, y, z, rx, ry, rz, -1, -1, -1, stream_distance, stream_distance);
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_STREAM_DISTANCE, stream_distance);
                Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_DRAW_DISTANCE, stream_distance);

                if (interior) Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID, interior);
                if (virtualworld) Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID, virtualworld);
            }

            Metrics_ReportModelUsed(modelid);
            count ++;

            if(prefix_found && objectid != INVALID_OBJECT_ID)
                mparse_SetPrefixData(prefix, objectid);
        }

        else if((start_index = strfind(buffer, "RemoveBuilding")) != -1)
        {
            new modelid,
                Float:x,
                Float:y,
                Float:z,
                Float: range
            ;

            if(sscanf(buffer[start_index], "p<(>{s[24]}p<,>ifffp<)>f", modelid, x, y, z, range)) {
              
                continue;
            }

            printf("RemoveBuilding(%d, %f, %f, %f, %f);", modelid, x, y, z, range ) ;
            //RemoveBuildingForPlayerEx(modelid, modelid, x, y, z, range);

            /*new objectid = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, -1, -1, -1, stream_distance );

            if(objectid == ERROR_MAXOBJ_EXC) {

                return ERROR_MAXOBJ_EXC ;
            }

            if(prefix_found && objectid != INVALID_OBJECT_ID)
                mparse_SetPrefixData(prefix, objectid);*/
        }

        /////////////////////////////////////////////////////////
        //////////////////////////////////////////////////

        if((start_index = strfind(buffer, "SetDynamicObjectMaterialText")) != -1)
        {
            new
                prefix[MAX_MPARSE_PREFIX],
                text[50],
                materialindex,
                materialsize,
                fontface[50],
                fontsize,
                bold,
                fontcolor,
                backcolor,
                alignment
            ;

            if(
                sscanf(buffer[start_index], "p<(>{s[32]}p<,>s[31]is[50]is[50]iixxp<)>i", prefix, materialindex, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, alignment) &&
                sscanf(buffer[start_index], "p<(>{s[32]}p<,>s[31]is[50]is[50]iiiip<)>i", prefix, materialindex, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, alignment)
            ){
                continue;
            }

            new objectid = mparse_GetPrefixData(prefix);
            if(objectid == INVALID_OBJECT_ID)
                continue;

            strtrim(text, "\"");
            strtrim(fontface, "\"");

            SetDynamicObjectMaterialText(
                objectid,
                materialindex,
                text,
                materialsize,
                fontface,
                fontsize,
                bold,
                fontcolor,
                backcolor,
                alignment
            );
        }
        else if((start_index = strfind(buffer, "SetDynamicObjectMaterial")) != -1)
        {
            new
                prefix[MAX_MPARSE_PREFIX],
                materialindex,
                modelid,
                txd[50],
                texture[50],
                color
            ;

            if(
                sscanf(buffer[start_index], "p<(>{s[18]}p<,>s[31]iis[50]s[50]p<)>x", prefix, materialindex, modelid, txd, texture, color) &&
                sscanf(buffer[start_index], "p<(>{s[18]}p<,>s[31]iis[50]s[50]p<)>i", prefix, materialindex, modelid, txd, texture, color)
            ){
                continue;
            }

            new objectid = mparse_GetPrefixData(prefix);
            if(objectid == INVALID_OBJECT_ID)
                continue;

            strtrim(txd, "\"");
            strtrim(texture, "\"");

            SetDynamicObjectMaterial(
                objectid,
                materialindex,
                modelid,
                txd,
                texture,
                color
            );
        }

        else if((start_index = strfind(buffer, "CreateDynamicObject")) != -1)
        {
            new
                bool:prefix_found,
                prefix[MAX_MPARSE_PREFIX],
                modelid,
                Float:x,
                Float:y,
                Float:z,
                Float:rx,
                Float:ry,
                Float:rz,
                Float:stream_distance
            ;

            if(start_index > 0 && !sscanf(buffer, "p<=>s[31]p<(>{s[14]}p<,>ifffffp<)>f", prefix, modelid, x, y, z, rx, ry, rz))
                prefix_found = true, stream_distance = 0.0;
            else if(start_index > 0 && !sscanf(buffer, "p<=>s[31]p<(>{s[14]}p<,>iffffffp<)>f", prefix, modelid, x, y, z, rx, ry, rz, stream_distance))
                prefix_found = true;
            else if(!sscanf(buffer[start_index], "p<(>{s[13]}p<,>ifffffp<)>f", modelid, x, y, z, rx, ry, rz))
                prefix_found = false, stream_distance = 0.0;
            else if(!sscanf(buffer[start_index], "p<(>{s[13]}p<,>iffffffp<)>f", modelid, x, y, z, rx, ry, rz, stream_distance))
                prefix_found = false;
            else
                continue;

            new objectid = CA_CreateDynamicObject_SC(modelid, x, y, z, rx, ry, rz, -1, -1, -1, stream_distance, stream_distance);
            count ++;
            
            Metrics_ReportModelUsed(modelid);
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_STREAM_DISTANCE, stream_distance);
            Streamer_SetFloatData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_DRAW_DISTANCE, stream_distance);

            if (interior) Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID, interior);
            if (virtualworld) Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID, virtualworld);

            if(prefix_found && objectid != INVALID_OBJECT_ID)
                mparse_SetPrefixData(prefix, objectid);
        }

        ///////////////////////////////////////////////////////// //////////////////////////////////////////////////

        else if ( ( start_index = strfind ( buffer, "CreateGate" ) ) != -1 ) {

        
            new g_model, g_type, g_owner, g_int, g_vw, g_move, Float: g_speed, 
                Float: g_shut_x, Float: g_shut_y, Float: g_shut_z, Float: g_shut_rx, Float: g_shut_ry, Float: g_shut_rz,
                Float: g_open_x, Float: g_open_y, Float: g_open_z, Float: g_open_rx, Float: g_open_ry, Float: g_open_rz
            ;


            new bool:prefix_found, prefix[MAX_MPARSE_PREFIX] ;

            if(start_index > 0 && !sscanf(buffer, "p<=>s[128]p<(>{s[128]}p<,>iiiiifffffffffffffp<)>i", prefix, g_model, g_type, g_owner, g_int, g_vw, g_speed, g_shut_x, g_shut_y, g_shut_z, g_shut_rx, g_shut_ry, g_shut_rz,  g_open_x, g_open_y, g_open_z, g_open_rx, g_open_ry, g_open_rz, g_move ) ) {
                prefix_found = true;
            }

            else if(!sscanf(buffer[start_index], "p<(>{s[128]}p<,>iiiiifffffffffffffp<)>i", g_model, g_type, g_owner, g_int, g_vw, g_speed, g_shut_x, g_shut_y, g_shut_z, g_shut_rx, g_shut_ry, g_shut_rz,  g_open_x, g_open_y, g_open_z, g_open_rx, g_open_ry, g_open_rz, g_move ) ) {
                prefix_found = false;
            }

            else continue;

            ++ gatecount ;

            printf("CreateGate(%d, %d, %d, %d, %d,%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d);", g_model, g_type, g_owner, g_int, g_vw, g_speed,
                g_shut_x, g_shut_y, g_shut_z, g_shut_rx, g_shut_ry, g_shut_rz, g_open_x, g_open_y, g_open_z, g_open_rx, g_open_ry, g_open_rz, g_move
            );

            #pragma unused prefix_found // remove this wehn readding

            /*
            new objectid = CreateGate ( g_model, g_type, g_owner, g_int, g_vw, g_speed,
                g_shut_x, g_shut_y, g_shut_z, g_shut_rx, g_shut_ry, g_shut_rz, g_open_x, g_open_y, g_open_z, g_open_rx, g_open_ry, g_open_rz, g_move ) ;

            if(prefix_found && objectid != INVALID_OBJECT_ID) {

                mparse_SetPrefixData ( prefix, objectid ) ;
            }*/
        }
    }

    printf("[map] Loaded map \"%s\". %d objects and %d gates", map, count, gatecount ) ;

    g_ObjectsAdded = 0;
    count = 0 ;

    fclose(file_handle);

    return 1;
}
