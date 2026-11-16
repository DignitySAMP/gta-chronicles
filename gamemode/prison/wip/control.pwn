//------------------------------------------------------------------------------
// Loudspeaker/Tannoy PA System
// Written by Sporky (www.github.com/sporkyspork) for SOLS

// TODO: Make the prison controls into commands
// TODO: Make the dialog box call the commands
// TODO: Control for the sector gates
// TODO: Control for the tannoy
// TODO: Control for the shower

#include <YSI_Coding\y_hooks>

#define PRISON_CONTROL_X 1786.6075
#define PRISON_CONTROL_Y -1556.0742
#define PRISON_CONTROL_Z 38.0304

static STREAMER_TAG_3D_TEXT_LABEL PrisonControlLabel;

enum E_CONTROL_OPTION_IDX
{
    E_CONTROL_OPTION_A_POD,
    E_CONTROL_OPTION_B_POD,
    E_CONTROL_OPTION_CELL,
    E_CONTROL_OPTION_OPEN_ALL,
    E_CONTROL_OPTION_CLOSE_ALL,
    E_CONTROL_OPTION_SHOWER,
    E_CONTROL_OPTION_LOCKDOWN
}

static enum E_CONTROL_OPTION
{
    E_CONTROL_OPTION_IDX:E_CONTROL_OPTION_INDEX,
    E_CONTROL_OPTION_NAME[32],
    E_PRISON_SETTING:E_CONTROL_TOGGLE_SETTING
}

static const PrisonControlOptions[][E_CONTROL_OPTION] = 
{
    {E_CONTROL_OPTION_A_POD, "Open/Close A Pod"},
    {E_CONTROL_OPTION_B_POD, "Open/Close B Pod"},
    {E_CONTROL_OPTION_CELL, "Open/Close Specific Cell"},
    {E_CONTROL_OPTION_OPEN_ALL, "Open All Doors"},
    {E_CONTROL_OPTION_CLOSE_ALL, "Close All Doors"},
    {E_CONTROL_OPTION_SHOWER, "Showers", E_PRISON_SETTING_SHOWERS},
    {E_CONTROL_OPTION_LOCKDOWN, "Lockdown", E_PRISON_SETTING_LOCKDOWN}
};

static GetControlOptionIdx(enum_idx)
{
    for (new i = 0; i < sizeof(PrisonControlOptions); i ++)
    {
        if (PrisonControlOptions[i][E_CONTROL_OPTION_INDEX] == enum_idx)
        {
            return i;
        }
    }

    return -1;
}

CMD:prisoncontrol(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 2.5, PRISON_CONTROL_X, PRISON_CONTROL_Y, PRISON_CONTROL_Z))
    {
        return SendClientMessage(playerid, -1, "You're not at the Master Control Panel.");
    }

    ShowPrisonControlDlg(playerid);
    return 1;
}

static CtrlDlgStr[2048];

static ShowPrisonControlDlg(playerid)
{

    CtrlDlgStr[0] = EOS;
    for (new i = 0; i < sizeof(PrisonControlOptions); i ++)
    {
        if (PrisonControlOptions[i][E_CONTROL_TOGGLE_SETTING])
        {
            format(CtrlDlgStr, sizeof(CtrlDlgStr), "%s\n%s [%s]", CtrlDlgStr, PrisonControlOptions[i][E_CONTROL_OPTION_NAME], GetPrisonSetting(PrisonControlOptions[i][E_CONTROL_TOGGLE_SETTING]) ? "ON" : "OFF");
        }
        else
        {
            format(CtrlDlgStr, sizeof(CtrlDlgStr), "%s\n%s", CtrlDlgStr, PrisonControlOptions[i][E_CONTROL_OPTION_NAME]);
        }
    }

    inline DlgMasterControl(pid, dialogid, response, listitem, string:inputtext[]) 
    {
        #pragma unused pid, dialogid, inputtext, listitem
        
        if (response)
        {
            CallLocalFunction("OnPrisonControlSelected", "dd", playerid, _:PrisonControlOptions[listitem][E_CONTROL_OPTION_INDEX]);
        }
    }

    Dialog_ShowCallback(playerid, using inline DlgMasterControl, DIALOG_STYLE_LIST, "Master Control Panel", CtrlDlgStr, "Select", "Close");
    return 1;
}

forward OnPrisonControlSelected(playerid, E_CONTROL_OPTION_IDX:option);
public OnPrisonControlSelected(playerid, E_CONTROL_OPTION_IDX:option)
{  
    // Show ze menu again
    ShowPrisonControlDlg(playerid);

    /*
    if (option == E_CONTROL_OPTION_A_POD == 0) SetPrisonDoorsByGroup(0, true);
    else if (listitem == 1) SetPrisonDoorsByGroup(0, false);
    else if (listitem == 2) SetPrisonDoorsByGroup(1, true);
    else if (listitem == 3) SetPrisonDoorsByGroup(1, false);
    else if (listitem == 4) ShowPrisonDoorDlg(pid, true);
    else if (listitem == 5) ShowPrisonDoorDlg(pid, false);
    else if (listitem == 6) SetPrisonDoorsByType(0, 1);
    else if (listitem == 7) SetPrisonDoorsByType(0, 0);
    */

    // TODO: Add notifcations and logging
    // Intended to be hooked elsewhere (like to turn off the showers)   
    return 1;
}

hook OnPrisonLoad()
{
    // Add text
    PrisonControlLabel = CreateDynamic3DTextLabel("[Master Control Panel]{DEDEDE}\nType {c4a656}/prisoncontrol {DEDEDE}for options.", 0x3479E3FF, PRISON_CONTROL_X, PRISON_CONTROL_Y, PRISON_CONTROL_Z, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

    print("Prison: Loaded Control");
    return 1;
}