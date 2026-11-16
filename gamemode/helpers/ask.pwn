
CMD:accepthelp ( playerid, params [] ) {

	if ( ! IsPlayerHelper ( playerid ) ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Helper", "A3A3A3", "You need to be a supporter in order to be able to do this!" ) ;
	}

	new targetid ;

	if ( sscanf ( params, "k<player>", targetid ) ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3","/a(ccept)h(elp) [targetid]" ) ;
	}

	if ( ! IsPlayerConnected ( targetid ) ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3","That player doesn't seem to be connected anymore." ) ;
	}

	if ( ! PlayerVar [ targetid ] [ E_PLAYER_QUESTION_PENDING ] ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3","That player doesn't seem to have a pending question." ) ;
	}

	PlayerVar [ targetid ] [ E_PLAYER_QUESTION_PENDING ] = false ;
	Account [ playerid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ] ++ ;

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE accounts SET account_questions_done = %d WHERE account_id = %d", 
		Account [ playerid ] [ E_PLAYER_ACCOUNT_QUESTIONS_DONE ], 
		Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] 
	) ;
	mysql_tquery ( mysql, query ) ;

	query [ 0 ] = EOS ;

	format ( query, sizeof ( query ), "Your question has been selected by (%d) %s. They will contact you shortly.", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER) ) ;
	SendServerMessage ( targetid, RGBA_DARKER ( Server [ E_SERVER_HELPER_HEX ] ), "Question", "A3A3A3", query ) ;

	format ( query, sizeof ( query ), "[Question] {A3A3A3}(%d) %s has selected question of (%d) %s:", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), targetid, SOLS_PlayerName(targetid)  ) ;
	SendHelperMessage(query);

	format ( query, sizeof ( query ), "\"%s\"", PlayerVar [ targetid ] [ E_PLAYER_QUESTION_ASKED ]) ;
	SendHelperMessage(query);

	AddLogEntry(playerid, LOG_TYPE_ADMIN, sprintf("Selected question of %s: %s", SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_LEGACY), PlayerVar [ targetid ] [ E_PLAYER_QUESTION_ASKED ]));
	//WriteLog ( playerid, "supporter/ah", sprintf("(%d) %s selected question of (%d) %s: %s", playerid, ReturnPlayerNameData(playerid), targetid, ReturnPlayerNameData(targetid), PlayerVar [ targetid ] [ E_PLAYER_QUESTION_ASKED ] ) ) ;

	return true ;
}

CMD:ah ( playerid, params [] ) {

	return cmd_accepthelp ( playerid, params ) ;
}

CMD:questions ( playerid, params [] ) {
	if ( ! IsPlayerHelper ( playerid ) ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Helper", "A3A3A3", "You need to be a helper in order to be able to do this!" ) ;
	}

	new string [ 1024 ], count;

	inline DisplayQuestions(pid, dialogid, response, listitem, string:inputtext[]) {
	    #pragma unused pid, response, dialogid, listitem, inputtext

	}

	foreach(new i: Player) 
	{
		if ( PlayerVar [ i ] [ E_PLAYER_QUESTION_PENDING ] ) 
		{
			if (strlen(PlayerVar [ i ] [ E_PLAYER_QUESTION_ASKED ]) > 50)
			{
				format ( string, sizeof ( string ), "%s\n(%d) %s: %.50s...", string, i, ReturnPlayerNameData ( i ), PlayerVar [ i ] [ E_PLAYER_QUESTION_ASKED ]) ;
			}
			else
			{
				format ( string, sizeof ( string ), "%s\n(%d) %s: %s", string, i, ReturnPlayerNameData ( i ), PlayerVar [ i ] [ E_PLAYER_QUESTION_ASKED ]) ;
			}

			count ++ ;
		}
	}

	if ( count == 0 ) {

		string = "No questions to display." ;
	}

	Dialog_ShowCallback ( playerid, using inline DisplayQuestions, DIALOG_STYLE_LIST, "Questions", string, "Continue");

	return true ;
}

CMD:helpme(playerid, params[]) {

	return cmd_ask(playerid, params);
}
CMD:question(playerid, params[]) {

	return cmd_ask(playerid, params);
}
CMD:askq(playerid, params[]) {

	return cmd_ask(playerid, params);
}
CMD:ask ( playerid, params [] ) 
{
	if (!IsPlayerPlaying(playerid)) return true;

	if ( PlayerVar [ playerid ] [ E_PLAYER_QUESTION_COOLDOWN ]  >= gettime ()) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3", sprintf("You need to wait %d seconds before asking another question.", PlayerVar [ playerid ] [ E_PLAYER_QUESTION_COOLDOWN ] - gettime ()) ) ;
	}

	new question [ 128 ] ;

	if ( sscanf ( params, "s[128]", question ) ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3", "/ask [question]" ) ;
	}

	if ( strlen ( question ) >= 100 ) {

		return SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3", "Keep questions to the point, no more than 100 characters please.");
	}

	format ( PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ASKED ], 100, "%s", question ) ;
	//printf("%s, %s", question, PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ASKED ]) ;

	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_PENDING ] = true ;
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_COOLDOWN ] = gettime () + 30 ;
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ALERT_TIME] = gettime (); 
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_TIME] = gettime (); 

	new string [ 256 ] ;

	SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3", "Your request has been sent. A helper will contact you soon. You asked:" );
	format(string, sizeof ( string ), "\"%s\"", PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ASKED ] ) ;
	SendServerMessage ( playerid, COLOUR_HELPER, "Question", "A3A3A3", string );

	format ( string, sizeof ( string ), "[Ask] {A3A3A3}(%d) %s asks: {FFFFFF}%s", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_LEGACY), question  ) ;
	SendHelperMessage(string);

	format ( string, sizeof ( string ), "[Helper]{DEDEDE} To answer this question type /accepthelp %d (/ah)", playerid );
	SendHelperMessage(string);

	return true ;
}

Question_PlayerTick(playerid)
{
	if ( PlayerVar [ playerid ] [ E_PLAYER_QUESTION_PENDING ] && gettime() - PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ALERT_TIME] > 300)
	{
		new str[144];

		if (strlen(PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ASKED ]) > 50)
		{
			format(str, sizeof(str), "[Ask] {A3A3A3}(%d) %s asked %s:{FFFFFF} \"%.50s...\"", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), GetDuration(gettime() - PlayerVar[playerid][E_PLAYER_QUESTION_TIME]), PlayerVar[playerid][E_PLAYER_QUESTION_ASKED]);
		}
		else
		{
			format(str, sizeof(str), "[Ask] {A3A3A3}(%d) %s asked %s:{FFFFFF} \"%s\"", playerid, SOLS_PlayerName(playerid, PLAYER_NAME_STYLE_CHARACTER), GetDuration(gettime() - PlayerVar[playerid][E_PLAYER_QUESTION_TIME]), PlayerVar[playerid][E_PLAYER_QUESTION_ASKED]);
		}
		
		SendHelperMessage(str);

		PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ALERT_TIME ] = gettime();
	}
}

#include <YSI_Coding\y_hooks>

hook SOLS_OnCloseConnection(playerid, reason)
{
	// Apparently these were never reset...?
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_ASKED ][0] = EOS ;
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_PENDING ] = 0 ;
	PlayerVar [ playerid ] [ E_PLAYER_QUESTION_COOLDOWN ] = 0 ;
    return 1;
}