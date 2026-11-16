new Text: td_fade = Text: INVALID_TEXT_DRAW ;

LoadFaderTextdraw () {
	td_fade = TextDrawCreate( -20.000000, 0.000000, "_" ); 
 	TextDrawUseBox( td_fade, 1 );
 	TextDrawBoxColor( td_fade, 0x000000FF );
 	TextDrawAlignment( td_fade, 0 );
 	TextDrawBackgroundColor( td_fade, 0x000000FF );
 	TextDrawFont( td_fade, 3 );
 	TextDrawLetterSize( td_fade, 1.000000, 52.200000 );
 	TextDrawColor( td_fade, 0x000000FF );
}

FadeIn ( playerid, freeze=true, delay=1000 ) 
{
	if ( ! PlayerVar [ playerid ] [ E_PLAYER_IS_FADING ] ) 
	{
		PlayerVar [ playerid ] [ E_PLAYER_FADING_STATUS ] = 10;
		PlayerVar [ playerid ] [ E_PLAYER_IS_FADING ] = true;

		if (freeze) TogglePlayerControllable(playerid, false);
		if (delay) defer FadeTimer[delay](playerid, freeze);
		else FadeTimer(playerid, freeze);
		
		Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	}
}

timer FadeTimer[100](playerid, freeze) 
{
	if (!PlayerVar[playerid][E_PLAYER_IS_FADING]) return false;

	PlayerVar[playerid][E_PLAYER_FADING_STATUS] --;

	if (PlayerVar[playerid][E_PLAYER_FADING_STATUS] > 0)
	{
		TextDrawHideForPlayer(playerid, td_fade);
		TextDrawBoxColor(td_fade, (0 << 24) | ((0 & 0xFF) << 16) | ((0 & 0xFF) << 8) | (PlayerVar[playerid][E_PLAYER_FADING_STATUS] * (255 / 10)) & 0xFF);
		TextDrawShowForPlayer(playerid, td_fade);

		defer FadeTimer(playerid, freeze);
	}
	else
	{
		TextDrawHideForPlayer(playerid, td_fade );

		if ( freeze ) 
		{
			TogglePlayerControllable(playerid, true);
		}

		PlayerVar[playerid][E_PLAYER_FADING_STATUS] = 0;
		PlayerVar[playerid][E_PLAYER_IS_FADING] = false;
	}
	
	return true ;
}

BlackScreen(playerid) 
{	
	PlayerVar [ playerid ] [ E_PLAYER_IS_FADING ] = false;
	TextDrawHideForPlayer(playerid, td_fade);
	TextDrawBoxColor(td_fade, 0x000000FF);
	TextDrawShowForPlayer(playerid, td_fade);
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
