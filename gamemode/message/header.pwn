#if defined _inc_rpchat
    #undef _inc_rpchat
#endif


#include "message/local.pwn"
#include "message/action.pwn"
#include "message/annonated.pwn"
#include "message/ooc.pwn"

CMD:chathelp(playerid, params[]) {

	SendClientMessage(playerid, COLOR_SERVER, "[List of chat commands]");
	SendClientMessage(playerid, COLOR_GRAD0, " /me, /my, /do, /ame, /amy, /low, /s(hout), /w(hisper), /mic,");
	SendClientMessage(playerid, COLOR_GRAD1, " /b, /pm (/blockpm), /ooc, {FF000A}[use /noooc to hide OOC chat]");

	return true ;
}