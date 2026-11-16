enum {

	MAX_GROUPS = 25,
	INVALID_GROUP_ID = -1,

	GROUP_TYPE_DEFAULT = 0,
	GROUP_TYPE_COMPANY = 1,

	GROUP_COLOR_DEFAULT = 0xbc2c2cFF
} ;


// Functionality
#include "groups/data.pwn"
#include "groups/chat.pwn"
#include "groups/func.pwn"

// Commands
#include "groups/admin.pwn" 
#include "groups/leader.pwn"
#include "groups/member.pwn"
#include "groups/vehicles.pwn"

Groups_CanUsePager(playerid) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return false ;
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return false ;
	}

	if ( Group [ group_enum_id ] [ E_GROUP_DATA_TYPE ] == GROUP_TYPE_COMPANY ) {

		return true ;
	}

	return false ;
}

Groups_OnPlayerLogin(playerid) {
	new groupid = Character [ playerid ] [ E_CHARACTER_GROUPID ] ;

	if ( ! groupid ) {

		return true ;
	}

	new group_enum_id = Group_GetEnumID(groupid ); 

	if ( group_enum_id == INVALID_GROUP_ID ) {

		return true ;
	}

	// Reset hiding group variable
	PlayerVar [ playerid ] [ E_PLAYER_HIDING_GROUP ] = false ;

	// Show MOTD
	new string [ 256 ], hexcolor = Group [ group_enum_id ] [ E_GROUP_DATA_HEX ] ;

	format ( string, sizeof ( string ), "Group MOTD: %s", Group [ group_enum_id ] [ E_GROUP_DATA_MOTD ] ) ;
	ZMsg_SendClientMessage(playerid, hexcolor, string );

	return true ;
}

CMD:groups(playerid) {

	if ( GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL ) {

		return cmd_companies(playerid);
	}

	SendClientMessage(playerid, COLOR_YELLOW, "You're viewing default groups. For a list of companies, use /companies.");
	Group_DisplayList(playerid, GROUP_TYPE_DEFAULT);
	return true ;
}

CMD:companies(playerid) {

	Group_DisplayList(playerid, GROUP_TYPE_COMPANY);
	return true ;
}

new GrpDlgStr [ 2048 ] ;
Group_DisplayList(playerid, type) {

	GrpDlgStr [ 0 ] = EOS ;
	new GrpDlgLine [ 256 ] ; 

	if (!GetPlayerAdminLevel(playerid)) format(GrpDlgStr, sizeof(GrpDlgStr), "ID\tName\tOnline");
	else format(GrpDlgStr, sizeof(GrpDlgStr), "ID [SQL]\tName\tOnline");
	
	new map[MAX_GROUPS], index = 0 ;
	new online[1000];

	foreach (new i: Player) 
	{
		if (Character [ i ] [ E_CHARACTER_GROUPID ] <= 0 || Character [ i ] [ E_CHARACTER_GROUPID ] >= sizeof(online)) continue;
		online[Character [ i ] [ E_CHARACTER_GROUPID ]] ++;
	}

	foreach(new groupid: Groups) {

		if ( Group [ groupid ] [ E_GROUP_DATA_TYPE ] == type ) {
			if (GetPlayerAdminLevel ( playerid ) > ADMIN_LVL_GENERAL){

				format(GrpDlgLine, sizeof(GrpDlgLine), "\n%d [%d]\t%s\t%d", groupid, Group [ groupid ] [ E_GROUP_DATA_SQLID ],  Group [ groupid ] [ E_GROUP_DATA_NAME ], online [ Group [ groupid ] [ E_GROUP_DATA_SQLID ] ] );
			} 
			else format(GrpDlgLine, sizeof(GrpDlgLine), "\n%d\t%s\t%d", groupid,  Group [ groupid ] [ E_GROUP_DATA_NAME ], online [ Group [ groupid ] [ E_GROUP_DATA_SQLID ] ] );
		

			strcat(GrpDlgStr, GrpDlgLine);

			map [ index ] = groupid;
			index ++ ;
		}

		else continue ;

	}

	inline DlgShowGroups(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, dialogid, inputtext, listitem
			
		if (response) {
			new groupindex = map[listitem];

			// Shows group members (only to admins or their own group)
			if (Character [ playerid ] [ E_CHARACTER_GROUPID ] == Group[groupindex][E_GROUP_DATA_SQLID] || GetPlayerAdminLevel(playerid) >= ADMIN_LVL_JUNIOR) {
				
				if ( type == GROUP_TYPE_COMPANY ) {
					Group_ShowOnlineMembers(playerid, groupindex, GROUP_TYPE_COMPANY);
				}
				else Group_ShowOnlineMembers(playerid, groupindex, GROUP_TYPE_DEFAULT);
			}
		}
	}

	if ( type == GROUP_TYPE_COMPANY ) {

		Dialog_ShowCallback ( playerid, using inline DlgShowGroups, DIALOG_STYLE_TABLIST_HEADERS, "Companies", GrpDlgStr, "View", "Close" );
	}
	else Dialog_ShowCallback ( playerid, using inline DlgShowGroups, DIALOG_STYLE_TABLIST_HEADERS, "Groups", GrpDlgStr, "View", "Close" );		
}


Group_ShowOnlineMembers(playerid, groupid, type) {
	new count = 0;

	GrpDlgStr [ 0 ] = EOS ;
	format(GrpDlgStr, sizeof(GrpDlgStr), "Player ID\tName\tTier");

	foreach (new i: Player) 
	{
		if (!IsPlayerConnected(i)) continue;
		if (Character[i][E_CHARACTER_GROUPID] != Group [groupid][E_GROUP_DATA_SQLID]) continue;

		count ++;
		format(GrpDlgStr, sizeof(GrpDlgStr), "%s\n%03d\t%s\tTier %d", GrpDlgStr, i, ReturnPlayerNameData(i, 0, true), Character[i][E_CHARACTER_GROUPTIER]);
	}

	inline DlgShowGroupMembers(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, dialogid, inputtext, listitem
		
		if (response)
		{
			if(type == GROUP_TYPE_DEFAULT) {

				cmd_groups(playerid);
			}
			else if ( type == GROUP_TYPE_COMPANY ) {
				cmd_companies(playerid);
			}
		}
	}

	Dialog_ShowCallback ( playerid, using inline DlgShowGroupMembers, DIALOG_STYLE_TABLIST_HEADERS, sprintf("%s Online Members (%d)", Group[groupid][E_GROUP_DATA_NAME], count), GrpDlgStr, "Back", "Close" );

}

CMD:grouphelp(playerid) {

	return Group_ShowCommands(playerid);
}

Group_ShowCommands(playerid) {

	SendClientMessage(playerid, 0xecb390FF, "[ ___________ Group Commands  ___________ ]");
	SendClientMessage(playerid, 0x7d9d9cFF, "[DEFAULT]{DEDEDE} /groups, /companies, /nogroup");

	if ( Character [ playerid ] [ E_CHARACTER_GROUPID ] ) {
		SendClientMessage(playerid, 0x7d9d9cFF, "[MEMBER]{DEDEDE} /groupchat, /grouponline, /groupoffline, /groupquit, /groupcars");
		
		if ( Character [ playerid ] [ E_CHARACTER_GROUPTIER ] < 3 || GetPlayerAdminLevel(playerid) >= ADMIN_LVL_ADVANCED ) {
			SendClientMessage(playerid, 0x7d9d9cFF, "[LEADER]{DEDEDE} /groupmotd, /groupsettier, /groupinvite, /groupuninvite /groupouninvite, /grouptogchat");
			SendClientMessage(playerid, 0x7d9d9cFF, "[LEADER]{DEDEDE} /grouptowcars, /groupcarcolor, /grouppark, /groupactivity");
		}
	}
	if ( GetPlayerAdminLevel ( playerid ) >= ADMIN_LVL_ADVANCED ) {
		SendClientMessage(playerid, 0x7d9d9cFF, "[ADMIN]{DEDEDE} /agjoin, /groupcreate, /groupname, /grouptype, /groupcolor");
	}

	return true ;
}