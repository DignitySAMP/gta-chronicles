// TextDraw(s) developed using Gammix's TextDraw editor
#include <a_samp>

// variable decleration on top of script
/*
** textdarw group: "box"
*/
new Text:boxTD[8];

// creating global textdraw(s) under "OnGameModeInit" preferably
public OnGameModeInit() {
	/*
	** textdarw group: "box"
	*/
	boxTD[0] = TextDrawCreate(10.0000, 334.5000, "_");
	TextDrawFont(boxTD[0], 1);
	TextDrawLetterSize(boxTD[0], 0.5000, 9.7500);
	TextDrawColor(boxTD[0], -1);
	TextDrawSetShadow(boxTD[0], 0);
	TextDrawSetOutline(boxTD[0], 0);
	TextDrawBackgroundColor(boxTD[0], 255);
	TextDrawSetProportional(boxTD[0], 1);
	TextDrawUseBox(boxTD[0], 1);
	TextDrawBoxColor(boxTD[0], 153);
	TextDrawTextSize(boxTD[0], 150.0000, 0.0000);

	boxTD[1] = TextDrawCreate(18.0000, 316.5000, "Stats");
	TextDrawFont(boxTD[1], 0);
	TextDrawLetterSize(boxTD[1], 0.8999, 2.5000);
	TextDrawColor(boxTD[1], -555819265);
	TextDrawSetShadow(boxTD[1], 0);
	TextDrawSetOutline(boxTD[1], 2);
	TextDrawBackgroundColor(boxTD[1], 255);
	TextDrawSetProportional(boxTD[1], 1);
	TextDrawTextSize(boxTD[1], 0.0000, 0.0000);

	boxTD[2] = TextDrawCreate(16.0000, 344.5000, "Muscle");
	TextDrawFont(boxTD[2], 1);
	TextDrawLetterSize(boxTD[2], 0.3499, 1.2500);
	TextDrawColor(boxTD[2], -555819265);
	TextDrawSetShadow(boxTD[2], 0);
	TextDrawSetOutline(boxTD[2], 0);
	TextDrawBackgroundColor(boxTD[2], 255);
	TextDrawSetProportional(boxTD[2], 1);
	TextDrawTextSize(boxTD[2], 0.0000, 0.0000);

	boxTD[3] = TextDrawCreate(16.0000, 356.5000, "Weight");
	TextDrawFont(boxTD[3], 1);
	TextDrawLetterSize(boxTD[3], 0.3499, 1.2500);
	TextDrawColor(boxTD[3], -555819265);
	TextDrawSetShadow(boxTD[3], 0);
	TextDrawSetOutline(boxTD[3], 0);
	TextDrawBackgroundColor(boxTD[3], 255);
	TextDrawSetProportional(boxTD[3], 1);
	TextDrawTextSize(boxTD[3], 0.0000, 0.0000);

	boxTD[4] = TextDrawCreate(16.0000, 367.5000, "Hunger");
	TextDrawFont(boxTD[4], 1);
	TextDrawLetterSize(boxTD[4], 0.3499, 1.2500);
	TextDrawColor(boxTD[4], -555819265);
	TextDrawSetShadow(boxTD[4], 0);
	TextDrawSetOutline(boxTD[4], 0);
	TextDrawBackgroundColor(boxTD[4], 255);
	TextDrawSetProportional(boxTD[4], 1);
	TextDrawTextSize(boxTD[4], 0.0000, 0.0000);

	boxTD[5] = TextDrawCreate(16.0000, 379.5000, "Thirst");
	TextDrawFont(boxTD[5], 1);
	TextDrawLetterSize(boxTD[5], 0.3499, 1.2500);
	TextDrawColor(boxTD[5], -555819265);
	TextDrawSetShadow(boxTD[5], 0);
	TextDrawSetOutline(boxTD[5], 0);
	TextDrawBackgroundColor(boxTD[5], 255);
	TextDrawSetProportional(boxTD[5], 1);
	TextDrawTextSize(boxTD[5], 0.0000, 0.0000);

	boxTD[6] = TextDrawCreate(16.0000, 391.5000, "Energy");
	TextDrawFont(boxTD[6], 1);
	TextDrawLetterSize(boxTD[6], 0.3499, 1.2500);
	TextDrawColor(boxTD[6], -555819265);
	TextDrawSetShadow(boxTD[6], 0);
	TextDrawSetOutline(boxTD[6], 0);
	TextDrawBackgroundColor(boxTD[6], 255);
	TextDrawSetProportional(boxTD[6], 1);
	TextDrawTextSize(boxTD[6], 0.0000, 0.0000);

	boxTD[7] = TextDrawCreate(143.5000, 404.5000, "Saturday");
	TextDrawFont(boxTD[7], 3);
	TextDrawLetterSize(boxTD[7], 0.3499, 1.2500);
	TextDrawAlignment(boxTD[7], 3);
	TextDrawColor(boxTD[7], -555819265);
	TextDrawSetShadow(boxTD[7], 0);
	TextDrawSetOutline(boxTD[7], 1);
	TextDrawBackgroundColor(boxTD[7], 255);
	TextDrawSetProportional(boxTD[7], 1);
	TextDrawTextSize(boxTD[7], 0.0000, 0.0000);

	return 1;
}

