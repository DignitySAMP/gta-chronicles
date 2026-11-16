#if !defined PAWNRAKNET_INC_
    #include <Pawn.RakNet>
#endif

SetPlayerNameForPlayer(playerid, forplayerid, const name[]) {

    new BitStream:bs = BS_New(), size = strlen(name);

    BS_WriteValue(
        bs, 
        PR_UINT16, playerid, 
        PR_UINT8, size, 
        PR_STRING, name, 
        PR_UINT8, 1
    );

    BS_RPC(bs, forplayerid, 11);
    BS_Delete(bs);
    return 1;
}

SetPlayerColorForPlayer(playerid, toplayerid, color) {
    new BitStream:bs = BS_New();

    BS_WriteValue(
        bs,
        PR_UINT16, playerid,
        PR_UINT32, color
    );

    BS_RPC(bs, toplayerid, 72);
    BS_Delete(bs);
    return 1;
}


CMD:synctablist(playerid) {

    UpdateTabListForPlayers(playerid);
    return true ;
}

UpdatePlayerTablistForOthers () {

    foreach(new targetid: Player) {
        UpdateTabListForPlayers(targetid);
    }
}