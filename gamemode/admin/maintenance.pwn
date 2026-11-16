#include <YSI_Coding\y_hooks>

static Text:UpdateText = Text:INVALID_TEXT_DRAW;
static SystemUpdate, SystemTimer;
static updatestring[128];

static STimeConvert(time)
{
    new h, m, s;
	h = floatround(time/3600);
	m = floatround(time -(3600*h))/60;
	s = floatround(time -(3600*h)-(m*60));

	if (time == 0) format(updatestring,sizeof(updatestring),"~r~~h~The server is now restarting...");
	else if (h) format(updatestring,sizeof(updatestring),"Server update in %02d~y~:~w~%02d~y~:~w~%02d",h, m, s);
	else format(updatestring,sizeof(updatestring),"Server update in %02d~y~:~w~%02d", m, s);
}

static CancelUpdate()
{
	SystemUpdate = 0;
	KillTimer(SystemTimer);
	TextDrawHideForAll(UpdateText);
}

static StartUpdate(seconds)
{
	if (SystemUpdate != 0) KillTimer(SystemTimer);

	SystemUpdate = seconds;
	STimeConvert(seconds);

	TextDrawSetString(UpdateText, updatestring);
	TextDrawShowForAll(UpdateText);
	SystemTimer = SetTimer("UpdateTimer", 1000, true);
}

hook OnGameModeInit() 
{
	UpdateText = TextDrawCreate(635.0, 431.007720, "Server_update_in");
	TextDrawLetterSize(UpdateText, 0.424666, 1.612444);
	TextDrawAlignment(UpdateText, 3);
	TextDrawColor(UpdateText, -1);
	TextDrawSetShadow(UpdateText, 0);
	TextDrawSetOutline(UpdateText, 1);
	TextDrawBackgroundColor(UpdateText, 255);
	TextDrawFont(UpdateText, 1);
	TextDrawSetProportional(UpdateText, 1);
	return 1;
}

hook OnPlayerConnect(playerid) 
{
	if (SystemUpdate > 0) 
	{
		TextDrawShowForPlayer(playerid, UpdateText);
	}

	return 1;
}

CMD:maintenance(playerid, params[]) 
{
	if ( GetPlayerAdminLevel ( playerid ) < ADMIN_LVL_ADVANCED ) 
	{
		return SendClientMessage ( playerid, COLOR_ERROR, "You're not authorized to perform this action." ) ;
	}

	inline MaintenanceHandler(pid, dialogid, response, listitem, string:inputtext[]) 
	{
		#pragma unused pid, dialogid, inputtext, listitem
		new string [ 256 ] ;

		if (response) 
		{
			if (isnull(inputtext) || !isnumeric(inputtext)) 
			{
				return SendClientMessage(playerid, COLOR_ERROR, "Enter a valid value." ) ;
			}

			new seconds = strval(inputtext);

			if (seconds == 0 && SystemUpdate != 0)
			{
				CancelUpdate();

				format ( string, sizeof ( string ), "[!!!] [AdmWarn] %s has cancelled the scheduled maintenance.", ReturnPlayerNameData ( playerid ) ) ;
				SendAdminMessage(string) ;
				return true;
			}

			if (seconds < 30 || seconds > 21600)
			{
				return SendClientMessage ( playerid, COLOR_ERROR, "Timer can't be less than 30 or longer than 21600.");
			}

			if (SystemUpdate == 0)
			{
				SendClientMessageToAll(COLOR_BLUE, "* The server will soon be restarting for an update (see bottom right of screen)");
				GameTextForAll("~n~~n~~n~~n~~y~] Server Maintenance Alert ]", 5000, 3);
			}

			StartUpdate(seconds);

	    	format ( string, sizeof ( string ), "[!!!] [AdmWarn] %s has scheduled server maintenance in %d seconds.", 
	 			ReturnPlayerNameData ( playerid ), strval(inputtext) ) ;

			SendAdminMessage(string) ;
		}
		else SendClientMessage(playerid, COLOR_WHITE, "You have cancelled doing a maintenance restart.");
	}

	Dialog_ShowCallback ( playerid, using inline MaintenanceHandler, DIALOG_STYLE_INPUT, "How long should the timer run?", "Please specify in seconds how long before the server kicks all users & shuts down?\n\nWARNING: This action can't be undone!", "Shutdown", "Exit");

    return 1;
}

forward UpdateTimer();
public UpdateTimer() 
{
	if (SystemUpdate <= 0) return 1;

	SystemUpdate --;
	STimeConvert(SystemUpdate);

	if(SystemUpdate == 15) GameTextForAll("~n~~n~~n~~n~~w~Please ~r~log out ~w~now to ensure ~y~account data ~w~has been ~g~saved~w~!", 10000, 3);
	
	if(SystemUpdate == 0)
	{
		KillTimer(SystemTimer);
		Maintenance();
	}

	TextDrawSetString(UpdateText, updatestring);
	TextDrawShowForAll(UpdateText);

	return 1;
}

forward Maintenance();
public Maintenance()
{
    foreach(new i: Player)
	{
		TogglePlayerControllable(i, false);
		GameTextForPlayer(i, "Scheduled Maintenance..~n~~n~~w~Please ~r~log out ~w~now to ensure ~y~account data ~w~has been ~g~saved~w~!", 66000, 5);
	}

	SendRconCommand(sprintf("password mnt%x%x", random(0x7FFFFFFF), GetTickCount()));
	SendRconCommand(sprintf("hostname [!] %s -> Restarting", SERVER_NAME));
	SetTimer("FinishMaintenance", 60000, false);

	return 1;
}

forward FinishMaintenance();
public FinishMaintenance()
{
    foreach(new i: Player) 
	{
    	SendClientMessage(i, COLOR_RED, "You've been kicked because the server is restarting." ) ;
    	KickPlayer(i);
   	}

	SetTimer("ShutDown", 5000, false);
	return 1;
}


forward ShutDown();
public ShutDown()
{
	return SendRconCommand("exit");
}