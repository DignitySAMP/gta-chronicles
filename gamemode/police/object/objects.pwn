
/*
enum E_PD_OBJECT_LIST_DATA {

	E_PD_OBJ_DESC [ 128 ],
	E_PD_OBJ_MODELID
} ;

new PoliceObjectList [ ] [ E_PD_OBJECT_LIST_DATA ] = {
	{"Spike Strip", 2899},
	{"Traffic Cone", 1238 },

	{ "Warning Barrier (small)", 1427 },
	{ "Detour Barrier (small)", 1425 },

	{ "Maintenance Barrier 1", 1228 },
	{ "Maintenance Barrier 2", 1459 },
	{ "Maintenance Barrier 2", 3091 },

	{ "Concrete Road Block (Single)", 1434 },
	{ "Concrete Road Block (Double)", 1422 },

	{ "Roadblock Barrier 1", 1423 },


	{ "Street Sign: Road Closed", 19972 },
	{ "Street Sign: Work Zone", 19972 },
	{ "Street Sign: Work Zone (small)", 19974 },
	{ "Street Sign: Do Not Enter", 19967 }
} ;

CMD:fobj(playerid, params[]) {

	return cmd_factionobject(playerid, params);
}
CMD:factionobject(playerid, params[]) {
    if ( ! PlayerVar [ playerid ] [ E_PLAYER_POLICE_DUTY ] ) {

        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty and can't do this." ) ;
    }
    
	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	if ( Faction [ faction_enum_id ] [ E_FACTION_TYPE ] != 0 ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a police faction.");
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] == 0 ) {
		PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] = 1 ;
	}

	// Pagination stuff
	new MAX_ITEMS_ON_PAGE = 10, string [ 1024 ], bool: nextpage ;
    new resultcount = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] ) - MAX_ITEMS_ON_PAGE ) ;


	strcat(string, "Index \t Model ID \t Description\n" ) ;

    for_loop ( new i = resultcount; i < sizeof ( PoliceObjectList ); i ++ ) {

		resultcount ++ ;

        if ( resultcount <= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] ) {


			format(string, sizeof(string), "%s[ID: %d] \t  [%d] \t [%s]\n", string, 
				i, PoliceObjectList [ i ] [ E_PD_OBJ_MODELID ], PoliceObjectList [ i ] [ E_PD_OBJ_DESC ]
			);
        }

     	if ( resultcount >= MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] ) {

            nextpage = true;
            break;
        }
	}

	new pages = floatround ( resultcount / MAX_ITEMS_ON_PAGE, floatround_floor ) + 1 ;

    if ( nextpage ) {
    	strcat(string, "Next Page >>" ) ;
    }
 
	inline pdobj_showlist(pid, dialogid, response, listitem, string: inputtext[]) {
		#pragma unused pid, dialogid, inputtext

		new selection = ( ( MAX_ITEMS_ON_PAGE * PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] ) - MAX_ITEMS_ON_PAGE ) + listitem;

		if ( ! response ) {

			if ( PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] > 1 ) {

				PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] -- ;
				return cmd_fobj(playerid, params);
			}
		}

		if ( response ) {

			if ( listitem >= MAX_ITEMS_ON_PAGE) {

				PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] ++ ;
				return cmd_fobj(playerid, params);
			}

			else if ( listitem < MAX_ITEMS_ON_PAGE ) {

				if ( ! response ) {
					return cmd_fobj(playerid, params);
				}

				else if ( response ) {

					SendClientMessage(playerid, -1, sprintf("Selected: (%d) %s with model %d.", 
						selection,  PoliceObjectList [ selection ] [ E_PD_OBJ_DESC ],  PoliceObjectList [ selection ] [ E_PD_OBJ_MODELID ] 
					) ) ;

					PoliceObject_CreateEntity(playerid, PoliceObjectList [ selection ] [ E_PD_OBJ_MODELID ] ) ;
				}

 				return true ;
			}
		}
	}

	if ( PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ] > 1 ) {
		Dialog_ShowCallback ( playerid, using inline pdobj_showlist, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Police Object: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ], pages), string, "Select", "Previous" ) ;
	}

	else Dialog_ShowCallback ( playerid, using inline pdobj_showlist, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Police Object: Page %d of %d", PlayerVar [ playerid ] [ E_PLAYER_PDOBJ_PAGE ], pages), string, "Select", "Close" ) ;

	return true ;
}
*/