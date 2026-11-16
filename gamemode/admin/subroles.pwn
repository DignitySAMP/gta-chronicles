// Admin "sub roles" like property admin, faction admin, refunds admin
// You can give an admin multiple endorsements, using bitflags

/* -- this is in player/auth
enum (<<= 1) E_ADMIN_ROLE
{
	ADMIN_ROLE_NONE,
	ADMIN_ROLE_FACTION = 0b1,
    ADMIN_ROLE_PROPERTY,
    ADMIN_ROLE_REFUND,
    ADMIN_ROLE_HELPER
}
*/

static enum E_ADMIN_ROLE_DATA
{
    E_ADMIN_ROLE:E_ADMIN_ROLE_BITFLAG,
    E_ADMIN_ROLE_NAME[16],
    E_ADMIN_ROLE_RANK_BYPASS // unused atm
}

static const AdminSubrole[][E_ADMIN_ROLE_DATA] = 
{
    { ADMIN_ROLE_NONE, "None", 0 },
    { ADMIN_ROLE_FACTION, "Factions", ADMIN_LVL_MANAGER },
    { ADMIN_ROLE_PROPERTY, "Properties", ADMIN_LVL_SENIOR },
    { ADMIN_ROLE_REFUND, "Refunds", ADMIN_LVL_MANAGER },
    { ADMIN_ROLE_HELPER, "Helpers", ADMIN_LVL_MANAGER }
};

static HasAdminRole(playerid, E_ADMIN_ROLE:role)
{
    return (Account[playerid][E_PLAYER_ACCOUNT_STAFFROLE] & role) == role;
}

// publlic functions
HasAnyAdminRole(playerid)
{
    return Account[playerid][E_PLAYER_ACCOUNT_STAFFROLE] != ADMIN_ROLE_NONE;
}

IsFactionAdmin(playerid)
{
    new rank = GetPlayerAdminLevel(playerid);
    return rank && (HasAdminRole(playerid, ADMIN_ROLE_FACTION) || rank >= ADMIN_LVL_MANAGER);
}

IsPropertyAdmin(playerid)
{
    new rank = GetPlayerAdminLevel(playerid);
    return rank && (HasAdminRole(playerid, ADMIN_ROLE_PROPERTY) || rank >= ADMIN_LVL_SENIOR);
}

IsRefundAdmin(playerid)
{
    new rank = GetPlayerAdminLevel(playerid);
    return rank && (HasAdminRole(playerid, ADMIN_ROLE_REFUND) || rank >= ADMIN_LVL_ADVANCED);
}

IsHelperAdmin(playerid)
{
    new rank = GetPlayerAdminLevel(playerid);
    new helper = GetPlayerHelperLevel(playerid);
    return (rank || helper) && (HasAdminRole(playerid, ADMIN_ROLE_HELPER) || rank >= ADMIN_LVL_MANAGER);
}

PrintAdminRoles(playerid)
{
    new str[128], count;

    for (new i, j = sizeof(AdminSubrole); i < j; i ++) 
    {
        if (AdminSubrole[i][E_ADMIN_ROLE_BITFLAG] == ADMIN_ROLE_NONE) continue;
        
        if (HasAdminRole(playerid, AdminSubrole[i][E_ADMIN_ROLE_BITFLAG]))
        {
            if (count) strcat(str, ", ");
            strcat(str, AdminSubrole[i][E_ADMIN_ROLE_NAME]);
            count ++;
        } 
    }

    return str;
}

PrintAdminRoleCmds(playerid)
{
    if (IsFactionAdmin(playerid)) PrintFactionAdminCmds(playerid);
    if (IsPropertyAdmin(playerid)) PrintPropertyAdminCmds(playerid);
    if (IsRefundAdmin(playerid)) SendClientMessage(playerid, COLOR_BLUE, "[REFUNDS] /(o)addrefund, /checkrefunds");
    if (IsHelperAdmin(playerid)) SendClientMessage(playerid, COLOR_HELPER, "[HELPERS] /(o)makehelper");
}

CMD:setadminrole(playerid, params[])
{
    if (GetPlayerAdminLevel(playerid) < ADMIN_LVL_MANAGER)
    {
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have access to this command.");
    }

	new user, count, index, rolestr[16], str[128] = "Available roles: ";
    sscanf(params, "k<player>s[16]", user, rolestr);

    if (!IsPlayerConnected(user) || !IsPlayerPlaying(user)) return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "Target isn't connected.");
    
    for (new i, j = sizeof(AdminSubrole); i < j; i ++) 
    {
        if (AdminSubrole[i][E_ADMIN_ROLE_BITFLAG] == ADMIN_ROLE_NONE) continue;

        if (count) strcat(str, ", ");
        format(str, sizeof(str), "%s\"%s\"", str, AdminSubrole[i][E_ADMIN_ROLE_NAME]);

        if (strlen(rolestr) && !strcmp(AdminSubrole[i][E_ADMIN_ROLE_NAME], rolestr, true)) 
        {
            index = i;
            break;
        }

        count ++;
    }

    if (!index)
    {
        SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/setadminrole [player] [role]");
	    SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", str);
        return true;
    }

    // Toggle the role flag
    Account[user][E_PLAYER_ACCOUNT_STAFFROLE] ^= AdminSubrole[index][E_ADMIN_ROLE_BITFLAG];
    
    if ((Account[user][E_PLAYER_ACCOUNT_STAFFROLE] & AdminSubrole[index][E_ADMIN_ROLE_BITFLAG]) == AdminSubrole[index][E_ADMIN_ROLE_BITFLAG])
    {
        format(str, sizeof(str), "{[ (%d) %s has given the \"%s\" role to (%d) %s ]}", playerid, ReturnPlayerNameData(playerid), AdminSubrole[index][E_ADMIN_ROLE_NAME], user, ReturnPlayerNameData(user));
    }
    else
    {
        format(str, sizeof(str), "{[ (%d) %s has taken the \"%s\" role from (%d) %s ]}", playerid, ReturnPlayerNameData(playerid), AdminSubrole[index][E_ADMIN_ROLE_NAME], user, ReturnPlayerNameData(user));
    }
    
    SendAdminMessage(str, true);

	mysql_format(mysql, str, sizeof(str), "UPDATE accounts SET account_staffrole = %d WHERE account_id = %d", _:Account[user][E_PLAYER_ACCOUNT_STAFFROLE], Account[user][E_PLAYER_ACCOUNT_ID]);
	mysql_tquery(mysql, str);

    return true;
}