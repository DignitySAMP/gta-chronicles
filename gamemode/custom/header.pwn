//#define CUSTOM_SKINS_DEVBUILD
#include"custom/wardrobe.pwn"
#include"custom/model-data.pwn"

new PlayerBody [ MAX_PLAYERS ] ;
new PlayerHead [ MAX_PLAYERS ] ;


Customization_OnPlayerSpawn(playerid) {

	ClothingStore_SetupParameters(playerid) ;
	Clothing_SetWardrobePosition(playerid);


	ShowCustomizationInfoDialog(playerid);
    return true ;
}

ShowCustomizationInfoDialog(playerid) {

	new customSkinInfo [ 1024 ] ;

    format(customSkinInfo, sizeof(customSkinInfo), "{FFFFFF}Introduction to Customization:{ADBEE6}\n");

    strcat(customSkinInfo, "- Character customization is the first introduction of singleplayer-like skin selection on SA-MP.\n");
    strcat(customSkinInfo, "- Like in singleplayer, the SIMS, or any modern roleplaying game you choose your character's head\n");
    strcat(customSkinInfo, "and clothes. This bundled with our attachments create an infinite array of customization options.\n");

    strcat(customSkinInfo, "\n{FFFFFF}Rules for Spawnables:{ADBEE6}\n");

    strcat(customSkinInfo, "- Do not use bodies and heads of which the skin colors collide (example black body, hispanic head).\n");
    strcat(customSkinInfo, "- When adjusting the head, do not use unrealistic or trolly porportions. This will get you banned.\n");

    strcat(customSkinInfo, "\n{FFFFFF}Having a custom (private) skin:{ADBEE6}\n");    

    strcat(customSkinInfo, "- Like the old skin system, you are able to get a skin that only you can use (and everyone can see).\n");
    strcat(customSkinInfo, "- This can be done through our submission platform {A3A3A3}(skins.streetzofls.com){ADBEE6}.\n");
    
    strcat(customSkinInfo, "\n{FFFFFF}Press {AA3333}OK{FFFFFF} to continue.\n{AA3333}By continuing, you agree to the rules above.");

    inline SkinCustomIntro(pid, dialogid, response, listitem, string:inputtext[]) {

        #pragma unused pid, dialogid, inputtext, listitem
    	if ( ! response ) {

        	return ShowCustomizationInfoDialog(playerid);
    	}

        if (response) {

        	if ( PlayerVar [ playerid ] [ E_PLAYER_FADING_STATUS ] ) {

        		return ShowCustomizationInfoDialog(playerid);
        	}

			ClothingStore_EnterWardrobe(playerid)  ;
            ClothingStore_ViewSelection(playerid);
        }
    }

    Dialog_ShowCallback ( playerid, using inline SkinCustomIntro, DIALOG_STYLE_MSGBOX, "Character Customization Info", customSkinInfo, "OK", "Back" );
    return true ;
}

ClothingStore_ViewSelection(playerid) {

    for ( new i, j = 9; i < j ; i ++ ) {

        RemovePlayerAttachedObject(playerid, i);
    }

    inline SkinCustomMenu(pid, dialogid, response, listitem, string:inputtext[]) {

        #pragma unused pid, dialogid, inputtext, listitem
        if ( ! response ) {

    		return ShowCustomizationInfoDialog(playerid);
        }
        if (response) {

        	switch ( listitem ) {
                case 0: { // change head
                    ModelBrowser_ClearData(playerid);

                    for ( new i, j = sizeof ( SkinCustomization ); i < j ; i ++ ) { 
                        if ( SkinCustomization [ i ] [ E_CUSTOM_SKIN_TYPE ] == E_CUSTOM_SKIN_HEAD ) {
                            ModelBrowser_AddData(playerid, -10000 - i, SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ] ) ;
                        }
                    }

                    ModelBrowser_SetupTiles(playerid, "Skin Customization: Heads", "skincustom_list_heads" );
                }
                case 1: { // change body
                    ModelBrowser_ClearData(playerid);

                    for ( new i, j = sizeof ( SkinCustomization ); i < j ; i ++ ) { 
                        if ( SkinCustomization [ i ] [ E_CUSTOM_SKIN_TYPE ] == E_CUSTOM_SKIN_BODY ) {
                            ModelBrowser_AddData(playerid, 22000 + i, SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ] ) ;
                        }
                    }

                    ModelBrowser_SetupTiles(playerid, "Skin Customization: Body", "skincustom_list_body" );
                }
        		case 2: {  // finish

        			SendClientMessage ( playerid, -1, "Finishing customization. Use /customskin to repeat.");

  
                    SetPlayerSkin(playerid, PlayerBody [ playerid ]);

                    RemovePlayerAttachedObject(playerid, 0);
                    SetPlayerAttachedObject(playerid, 0, PlayerHead [ playerid ], 2, 
                        0.000, 0.006, -0.005000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000

                    ) ;
     
                    EditAttachedObject(playerid, 0 );

                    ClothingStore_ExitWardrobe(playerid);
        		}
        	}


        }
    }

    Dialog_ShowCallback ( playerid, using inline SkinCustomMenu, DIALOG_STYLE_LIST, "Character Customization Menu", "Change Head\nChange Body\n>> Finish Customization", "OK", "Back" );

    return true ;
}


mBrowser:skincustom_list_heads(playerid, response, row, model, name[]) {

    if ( ! response ) {

        return true ;
    }

    else if ( response ) {

        PlayerHead [ playerid ] = model ;
        SendClientMessage ( playerid, -1, sprintf("Changed head to %s", name));
        ClothingStore_ViewSelection(playerid) ;
    }

    return true ;
}
mBrowser:skincustom_list_body(playerid, response, row, model, name[]) {

    if ( ! response ) {

        return true ;
    }

    else if ( response ) {

        PlayerBody [ playerid ] = model ;
        SendClientMessage ( playerid, -1, sprintf("Changed body to %s", name));
        ClothingStore_ViewSelection(playerid) ;

    }

    return true ;
}

CMD:editskin(playerid) {

    return Customization_OnPlayerSpawn(playerid) ;
}
CMD:test(playerid) {

    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    return true ;
}