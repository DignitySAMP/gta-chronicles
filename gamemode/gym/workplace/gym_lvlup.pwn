// TextDraw(s) developed using Gammix's TextDraw editor
#include <a_samp>

// variable decleration on top of script
/*
** textdarw group: "bar"
*/
new Text:barTD;
new PlayerText:barPTD[MAX_PLAYERS][3];

// creating global textdraw(s) under "OnGameModeInit" preferably
public OnGameModeInit() {
	/*
	** textdarw group: "bar"
	*/
	barTD = TextDrawCreate(19.5000, 170.0000, "_");
	TextDrawFont(barTD, 1);
	TextDrawLetterSize(barTD, 0.5000, 2.5000);
	TextDrawColor(barTD, 170);
	TextDrawSetShadow(barTD, 0);
	TextDrawSetOutline(barTD, 0);
	TextDrawBackgroundColor(barTD, 255);
	TextDrawSetProportional(barTD, 1);
	TextDrawUseBox(barTD, 1);
	TextDrawBoxColor(barTD, 170);
	TextDrawTextSize(barTD, 165.0000, 0.0000);

	return 1;
}

// creating player textdraw(s) under "OnPlayerConnect" preferably
public OnPlayerConnect(playerid) {
	/*
	** player textdarw group: "bar"
	*/
	barPTD[playerid][0] = CreatePlayerTextDraw(playerid, 43.5000, 171.5000, "Muscle");
	PlayerTextDrawFont(playerid, barPTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, barPTD[playerid][0], 0.4000, 1.5000);
	PlayerTextDrawAlignment(playerid, barPTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, barPTD[playerid][0], -555819265);
	PlayerTextDrawSetShadow(playerid, barPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, barPTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, barPTD[playerid][0], 255);
	PlayerTextDrawSetProportional(playerid, barPTD[playerid][0], 1);
	PlayerTextDrawTextSize(playerid, barPTD[playerid][0], 0.0000, 0.0000);

	barPTD[playerid][1] = CreatePlayerTextDraw(playerid, 71.0000, 173.5000, "mdl-30000:15");
	PlayerTextDrawFont(playerid, barPTD[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, barPTD[playerid][1], 0.5000, 1.0000);
	PlayerTextDrawColor(playerid, barPTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, barPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, barPTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, barPTD[playerid][1], 255);
	PlayerTextDrawSetProportional(playerid, barPTD[playerid][1], 1);
	PlayerTextDrawTextSize(playerid, barPTD[playerid][1], 75.0000, 12.5000);

	barPTD[playerid][2] = CreatePlayerTextDraw(playerid, 155.5000, 171.0000, "+");
	PlayerTextDrawFont(playerid, barPTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, barPTD[playerid][2], 0.5000, 1.7500);
	PlayerTextDrawAlignment(playerid, barPTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, barPTD[playerid][2], -555819265);
	PlayerTextDrawSetShadow(playerid, barPTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, barPTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, barPTD[playerid][2], 255);
	PlayerTextDrawSetProportional(playerid, barPTD[playerid][2], 1);
	PlayerTextDrawTextSize(playerid, barPTD[playerid][2], 0.0000, 0.0000);

	return 1;
}

