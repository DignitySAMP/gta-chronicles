/*

  /strawmen viewpackages (optional: id)
    * Each package is stored in the database
    * Strawmen management can view all packages (default color), OR per player (optional id), a player can only view their own
    ** When viewing all packages, blue packages are assigned, yellow are unassigned, green is fully sold
    * Allows the strawmen to view the packages he currently owns (and which ones are available or not (greyed out))
    * Shows the strawmen's packages ,and which items are sold (add table "issold" to determine availability)
    * Logs who made the package and who the strawmen sold it to, which date and for how much


*/

enum E_PACKAGE_DATA {

    E_PACKAGE_INDEX,
    E_PACKAGE_OWNER, // char_id of owner
    E_PACKAGE_DESC [ 256 ], // info detailing where it came from

    E_PACKAGE_ITEM_ACTIVE [ 5 ], // 0: sold, 1: unsold
    E_PACKAGE_ITEM_TYPE [ 5 ],
    E_PACKAGE_ITEM_ID [ 5 ],
    E_PACKAGE_AMOUNT [ 5 ],
    E_PACKAGE_EXTRA_A [ 5 ],
    E_PACKAGE_EXTRA_B [ 5 ],

    E_PACKAGE_UNIX,
    E_PACKAGE_MADE_BY // char_id of creator
}

#define MAX_PACKAGES (MAX_PLAYERS * MAX_STRAWMEN )
#define INVALID_PACKAGE_ID  -1
new Package [ MAX_PACKAGES ] [ E_PACKAGE_DATA ] ; 

#include <YSI_Coding\y_hooks>

hook OnGameModeInit() {

    for_loop ( new i, j = MAX_PACKAGES; i < j ; i ++ ) {

        Package [ i ] [ E_PACKAGE_INDEX ] = INVALID_PACKAGE_ID ;
    }

    return 1;
}

enum {
    E_PACKAGE_TYPE_GUNS,
    E_PACKAGE_TYPE_AMMO,
    E_PACKAGE_TYPE_DRUGS
}

Package_GetName(constant) {

    new name [ 32 ] ;

    switch ( constant ) {
        case E_PACKAGE_TYPE_GUNS: strcat(name, "Guns", sizeof(name) ) ;
        case E_PACKAGE_TYPE_AMMO: strcat(name, "Ammo", sizeof(name) ) ;
        case E_PACKAGE_TYPE_DRUGS: strcat(name, "Drugs", sizeof(name) ) ;
        default: strcat(name, "Invalid", sizeof(name) ) ;
    }

    return name ;
}

/*
    /strawmen manage
    * (Open a list allowing managers to create a supply package)
    ** (Weapons) 5 guns per package, default ammo
    ** (Drugs) 5 drugs per package, free reign of type and params
    ** (Ammo) 5 ammo types per package


*/
Strawmen_ManageMenu(playerid) {
    inline Strawmen_MngMenuDlg(pid, dialogid, response, listitem, string:inputtext[]) {
        #pragma unused pid, dialogid, inputtext

        if(response) {

            switch ( listitem ) {

                case 0: Strawmen_ManageMenu_List(playerid, 0);// list active packages
                case 1:  Strawmen_ManageMenu_List(playerid, 1);// list inactive packages
                case 2: return true ;//Strawmen_ManageMenu_Create(playerid); // create package
                case 3:  Strawmen_ManageMenu_List(playerid, 2);// list all packages
            }
        }
    }

    Dialog_ShowCallback ( playerid, using inline Strawmen_MngMenuDlg, DIALOG_STYLE_LIST, "Strawmen: Manage", "List Active Packages\nList Depleted Packages\nCreate Package\nList All Packages", "Select", "Close" );
    return true ;
}


Strawmen_ManageMenu_List(playerid, filter) {
    #warning Add pagination and sort DESC!

    new listitem_index [ MAX_PACKAGES ], listitem_index_count ;
    new package_count, player_offline_name [ MAX_PLAYER_NAME * 2 ], creator_offline_name [ MAX_PLAYER_NAME * 2 ], package_progress_color [ 12 ]  ;

    inline Strawmen_MngMenuDlg_2(pid, dialogid, response, listitem, string:inputtext[]) {
        #pragma unused pid, dialogid, inputtext

        if ( response ) {

            new selection = listitem_index [ listitem ] ; // use this for accessing the array.

            inline Strawmen_MngMenuDlg_3(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
                #pragma unused pidx, dialogidx, inputtextx, listitemx

                if(!responsex || responsex) {
                    Strawmen_ManageMenu_List(playerid, filter);
                }
            }

            StrawmenDlgString [ 0 ] = EOS ;
            player_offline_name [ 0 ] = EOS ;
            creator_offline_name [ 0 ] = EOS ;

            Strawmen_GetOfflineName(Package [ selection ] [ E_PACKAGE_OWNER ], player_offline_name ) ;
            Strawmen_GetOfflineName(Package [ selection ] [ E_PACKAGE_MADE_BY ], creator_offline_name ) ;

            format ( StrawmenDlgString, sizeof ( StrawmenDlgString ), 
                "{DEDEDE}Package ID: %d\
                \nPackage Owner: %s (charid %d)\
                \nPackage Item 1 (%s): %s (%d amount), (extra_a: %d, extra_b: %d)\
                \nPackage Item 2: %s: %d (%d amount), (extra_a: %d, extra_b: %d)\
                \nPackage Item 3: %s: %d (%d amount), (extra_a: %d, extra_b: %d)\
                \nPackage Item 4: %s: %d (%d amount), (extra_a: %d, extra_b: %d)\
                \nPackage Item 5: %s: %d (%d amount), (extra_a: %d, extra_b: %d)\
                \n{DEDEDE}Package Time: %d\
                \nPackage Made By: %s",
                Package [ selection ] [ E_PACKAGE_INDEX ], 
                player_offline_name, Package [ selection ] [ E_PACKAGE_OWNER ],
                Strawmen_GetActiveColor(Package [ selection ] [ E_PACKAGE_ITEM_ACTIVE ] [ 0 ]), Package_GetName(Package [ selection ] [ E_PACKAGE_ITEM_TYPE ] [ 0 ]), Package [ selection ] [ E_PACKAGE_ITEM_ID ] [ 0 ], Package [ selection ] [ E_PACKAGE_AMOUNT ] [ 0 ], Package [ selection ] [ E_PACKAGE_EXTRA_A ] [ 0 ], Package [ selection ] [ E_PACKAGE_EXTRA_B ] [ 0 ], 
                Strawmen_GetActiveColor(Package [ selection ] [ E_PACKAGE_ITEM_ACTIVE ] [ 1 ]), Package_GetName(Package [ selection ] [ E_PACKAGE_ITEM_TYPE ] [ 1 ]), Package [ selection ] [ E_PACKAGE_ITEM_ID ] [ 1 ], Package [ selection ] [ E_PACKAGE_AMOUNT ] [ 1 ], Package [ selection ] [ E_PACKAGE_EXTRA_A ] [ 1 ], Package [ selection ] [ E_PACKAGE_EXTRA_B ] [ 1 ], 
                Strawmen_GetActiveColor(Package [ selection ] [ E_PACKAGE_ITEM_ACTIVE ] [ 2 ]), Package_GetName(Package [ selection ] [ E_PACKAGE_ITEM_TYPE ] [ 2 ]), Package [ selection ] [ E_PACKAGE_ITEM_ID ] [ 2 ], Package [ selection ] [ E_PACKAGE_AMOUNT ] [ 2 ], Package [ selection ] [ E_PACKAGE_EXTRA_A ] [ 2 ], Package [ selection ] [ E_PACKAGE_EXTRA_B ] [ 2 ], 
                Strawmen_GetActiveColor(Package [ selection ] [ E_PACKAGE_ITEM_ACTIVE ] [ 3 ]), Package_GetName(Package [ selection ] [ E_PACKAGE_ITEM_TYPE ] [ 3 ]), Package [ selection ] [ E_PACKAGE_ITEM_ID ] [ 3 ], Package [ selection ] [ E_PACKAGE_AMOUNT ] [ 3 ], Package [ selection ] [ E_PACKAGE_EXTRA_A ] [ 3 ], Package [ selection ] [ E_PACKAGE_EXTRA_B ] [ 3 ], 
                Strawmen_GetActiveColor(Package [ selection ] [ E_PACKAGE_ITEM_ACTIVE ] [ 4 ]), Package_GetName(Package [ selection ] [ E_PACKAGE_ITEM_TYPE ] [ 4 ]), Package [ selection ] [ E_PACKAGE_ITEM_ID ] [ 4 ], Package [ selection ] [ E_PACKAGE_AMOUNT ] [ 4 ], Package [ selection ] [ E_PACKAGE_EXTRA_A ] [ 4 ], Package [ selection ] [ E_PACKAGE_EXTRA_B ] [ 4 ], 
                Package [ selection ] [ E_PACKAGE_UNIX ], 
                creator_offline_name
            ) ;


            Dialog_ShowCallback ( playerid, using inline Strawmen_MngMenuDlg_3, DIALOG_STYLE_MSGBOX, "Strawmen: Manage (View)", StrawmenDlgString, "Go back", "" );
        }
    }

    StrawmenDlgString [ 0 ] = EOS ;
    player_offline_name [ 0 ] = EOS ;
    creator_offline_name [ 0 ] = EOS ;

    format ( StrawmenDlgString, sizeof ( StrawmenDlgString), "ID \t Strawman \t Progress \t Date" ) ;
    format ( StrawmenDlgString, sizeof ( StrawmenDlgString), "%s{DEDEDE}", StrawmenDlgString ) ;

    for ( new i, j = MAX_PACKAGES; i < j ; i ++ ) {

        if ( Package [ i ] [ E_PACKAGE_INDEX ] != INVALID_PACKAGE_ID ) {

            // Used for accessing IDs that are potentially skipped.
            listitem_index [ listitem_index_count ] = i ;
            listitem_index_count ++ ;

            for ( new x, y = 5; x < y ; x ++ ) {
                if ( Package [ i ] [ E_PACKAGE_ITEM_ACTIVE ] [ x ] ) {
                    package_count ++ ;
                }    
            }

            Strawmen_GetOfflineName(Package [ i ] [ E_PACKAGE_OWNER ], player_offline_name ) ;

            if ( package_count > 1 && filter==0 || filter==2) { // not fully sold
                Strawmen_GetProgressColor(package_count, package_progress_color);

                format ( StrawmenDlgString, sizeof ( StrawmenDlgString ), "%s\n%d \t %s \t %s%d/5{DEDEDE} \t %s", StrawmenDlgString,
                    Package [ i ] [ E_PACKAGE_INDEX ], 
                    player_offline_name, 
                    package_progress_color, package_count, 
                    GetDuration(Package [ i ] [ E_PACKAGE_UNIX ])  
                ) ;
            }
            else { // sold

                if( filter==1 || filter==2) {
                    format ( StrawmenDlgString, sizeof ( StrawmenDlgString ), "%s\n{808080}%d \t %s \t Depleted \t %s{DEDEDE}", StrawmenDlgString,
                        Package [ i ] [ E_PACKAGE_INDEX ], player_offline_name, GetDuration(Package [ i ] [ E_PACKAGE_UNIX ])  
                    ) ;
                }
            }

        }
    }

    Dialog_ShowCallback ( playerid, using inline Strawmen_MngMenuDlg_2, DIALOG_STYLE_LIST, "Strawmen: Manage (List)", StrawmenDlgString, "Select", "Close" );
 

    return true ;
}

Strawmen_GetProgressColor(count, color[], len=sizeof(color)) {

    switch ( count ) {

        case 1: strcat(color, "{bf8e4d}", len);
        case 2: strcat(color, "{bfb94d}", len);
        case 3: strcat(color, "{82bf4d}", len);
        case 4: strcat(color, "{4dbf5c}", len);
        default: strcat(color, "{bf4d4d}", len);
    }
}
Strawmen_GetActiveColor(active) {
    new color [ 12 ] ;

    switch ( active ) {

        case 1: strcat(color, "{DEDEDE}");
        default: strcat(color, "{808080}");
    }
    return color ;
}

Strawmen_GetOfflineName(char_id, offline_name[], len=sizeof(offline_name)) {

    new query [ 512 ];

    mysql_format ( mysql, query, sizeof ( query ), "SELECT `player_id`, `player_name`, `account_name` FROM `characters` JOIN `accounts` ON `accounts`.`account_id` = `characters`.`account_id` WHERE `player_id` = '%d'",
        char_id
    ) ; 

    new player_id, player_off_name [ MAX_PLAYER_NAME ], player_acc[32] ;

    inline OnOfflineMemberCheck() {

        new rows, fields ;
        cache_get_data ( rows, fields, mysql ) ;
        if ( rows ) 
        {
            for_loop ( new i; i < rows; i ++ ) { 

                player_id = cache_get_field_int (i, "player_id");
                
                if ( Player_IsPlayerConnected ( player_id ) ) {

                    continue ;
                }

                cache_get_field_content ( i, "player_name", player_off_name, mysql, MAX_PLAYER_NAME ) ;
                cache_get_field_content ( i, "account_name", player_acc, mysql, 32 ) ;

                format ( offline_name, len, "%s (%s)", player_off_name, player_acc);
            }   
        }
        else if(!rows) {
            format ( offline_name, len, "Unknown (NULL)");
        }
    }

    mysql_tquery_inline(mysql, query, using inline OnOfflineMemberCheck, "");
}