
forward bool:GetMapZoneName(MapZone:id, name[], size = sizeof(name)) ;
forward MapZone:GetMapZoneAtPoint2D(Float:x, Float:y) ;

#include "config/data/skins.pwn"
#include "config/data/streets.pwn"
#include "config/data/zones.pwn"
#include "config/data/area.pwn"
#include "config/data/calendar.pwn"


forward Float: frandom(Float:min, Float:max, dp = 4)  ;

enum {

    NAME_FULLNAME,
    NAME_FIRSTNAME,
    NAME_LASTNAME
} ;



#define LS_GYM_EXT_X (2359.5649)
#define LS_GYM_EXT_Y (-1312.1975)
#define LS_GYM_EXT_Z (24.0063)

#define SF_GYM_EXT_X (1670.2826)
#define SF_GYM_EXT_Y (-1582.8108)
#define SF_GYM_EXT_Z (13.5469)


#define LV_GYM_EXT_X (2095.1321)
#define LV_GYM_EXT_Y (-1995.8071)
#define LV_GYM_EXT_Z (13.9765)

// Non enterable

#define GANTON_GYM_EXT_X (2238.9714)
#define GANTON_GYM_EXT_Y (-1694.6267)
#define GANTON_GYM_EXT_Z (13.5250)

#define BEACH_GYM_EXT_X (666.3855)
#define BEACH_GYM_EXT_Y (-1879.8040)
#define BEACH_GYM_EXT_Z (5.1545)
