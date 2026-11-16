#include "player/auth/noclass.pwn"
#include "player/auth/data.pwn"
//#include "player/auth/select.pwn"
#include "player/auth/auth.pwn"
#include "sporky/tempselect.pwn"
#include "player/auth/ucp.pwn"

CMD:newplayers(playerid) {

	new string [ 128 ] ;

	SendClientMessage(playerid, COLOUR_HELPER, "[List of new players online]:" ) ;

	foreach(new targetid: Player) {

		if ( IsPlayerNewbie(targetid) ) {
			format ( string, sizeof ( string ), "(%d) %s - Level %d (%d hours)", 
				targetid, ReturnPlayerNameData(targetid), 
				Character [ targetid ] [ E_CHARACTER_LEVEL ], 
				Character [ targetid ] [ E_CHARACTER_HOURS ] 
			) ; 

			SendClientMessage(playerid, 0xDEDEDEFF, string);
		}
	}

	return true ;
}

/*
Player_NametagChoice(playerid) {
	new string [ 1024 ] ;

	format ( string, sizeof ( string ), 
		"{DEDEDE}Our server was originally created for nostalgia. As time went on\n\
		we have decided to aim for a wider RP public and generalised\n\
		a lot of things.\n\n\
		The original oldschool server led by TheGame (2007-2011) used\n\
		gang tags to display gang affiliation. After many community\n\
		discussions on whether we should implement either FN_LN or tags\n\
		we have decided to add a switch system so everyone can choose\n\
		what they prefer.\n\n\
		If you are a new player who is new to roleplay and wants to try\n\
		the out the server, we encourage you to pick Gang Tags.\n\
		Example: \"{43B941}[GSF]Hades{DEDEDE}\"\n\n\
		If you are an experienced roleplayer who wants a normal roleplaying\n\
		 experience, we encourage you to pick FN_LN.\n\
		 Example: \"{FFFFFF}Addison_Barrington\"{DEDEDE}"
	) ;

	inline NameTagChoiceInfo(pid, dialogid, response, listitem, string:inputtext[]) {
		#pragma unused pid, inputtext, listitem, dialogid, response

		inline NameTagSelect(pidx, dialogidx, responsex, listitemx, string:inputtextx[]) {
			#pragma unused pidx, inputtextx, responsex, dialogidx

			string [ 0 ] = EOS ;

			switch ( listitemx ) {

				case 0: {
					mysql_format(mysql, string, sizeof(string), "UPDATE accounts SET account_namestyle = 1 WHERE account_id=%d", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
					SendClientMessage(playerid, COLOR_YELLOW, "You've chosen Firstname_Listname as your nametag preference. You can change it in /settings.");
					Account [ playerid ] [ E_PLAYER_ACCOUNT_NAMESTYLE ] = 1 ;
				}
				case 1: {					
					mysql_format(mysql, string, sizeof(string), "UPDATE accounts SET account_namestyle = 2 WHERE account_id=%d", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ] ) ;
					SendClientMessage(playerid, COLOR_YELLOW, "You've chosen the Oldschool Gang Tags as your nametag preference. You can change it in /settings.");
					Account [ playerid ] [ E_PLAYER_ACCOUNT_NAMESTYLE ] = 2 ;
				}
			}

			mysql_tquery(mysql, string);
		}

	   	Dialog_ShowCallback ( playerid, using inline NameTagSelect, DIALOG_STYLE_LIST, "Nametag Preference", "Firstname Lastname\nOldschool Gang Tags", "Continue" );
	}

   	Dialog_ShowCallback ( playerid, using inline NameTagChoiceInfo, DIALOG_STYLE_MSGBOX, "Nametag Preference", string, "Continue" );

	return true ;
}
*/

SetPlayerSkinEx ( playerid, skinid, bool:add_wardrobe = false ) {

	Character [ playerid ] [ E_CHARACTER_SKINID ] = skinid ;
	SetPlayerSkin(playerid, skinid);

	new query [ 256 ] ;

	mysql_format ( mysql, query, sizeof ( query ), "UPDATE characters SET player_skinid = %d WHERE player_id = %d",
	Character [ playerid ] [ E_CHARACTER_SKINID ], Character [ playerid ] [ E_CHARACTER_ID ] ) ;
	mysql_tquery ( mysql, query);

	if (add_wardrobe)
	{
		mysql_format(mysql, query, sizeof(query), "INSERT INTO player_wardrobes (`player_wardrobe_char_id`, `player_wardrobe_skin_id`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `player_wardrobe_skin_lastused` = CURRENT_TIMESTAMP", Character[playerid][E_CHARACTER_ID], skinid);
		mysql_tquery(mysql, query);
		print(query);
	}

	// We also need to update the last used stats if it's a player skin
	if (skinid > 21000)
	{
		mysql_format(mysql, query, sizeof ( query ), "UPDATE player_skins SET player_skin_lastused = %d WHERE player_skin_id = %d AND player_skin_charid = %d", gettime(), 21000 - skinid, Character[playerid][E_CHARACTER_ID]);
		mysql_tquery(mysql, query);
		print(query);
	}

	// Likewise update the last used in the wardrobe, too
	mysql_format(mysql, query, sizeof ( query ), "UPDATE player_wardrobes SET player_wardrobe_skin_lastused = CURRENT_TIMESTAMP WHERE player_wardrobe_skin_id = %d AND player_wardrobe_char_id = %d", skinid, Character[playerid][E_CHARACTER_ID]);
	mysql_tquery(mysql, query);
	print(query);
}


NewPlayer_CountRegistrations(playerid) {
	#pragma unused playerid

	/*
		This stores basic data of new registrations. Useful for data.
	*/

	new year, month, day, hour, minute, second ;
	stamp2datetime(gettime(), year, month, day, hour, minute, second ) ;

	new query [ 256 ] ;

	mysql_format(mysql, query, sizeof ( query ), "INSERT INTO registrations (account_id, day, month, year, unix) \
		VALUES (%d, %d, %d, %d, %d)", Account [ playerid ] [ E_PLAYER_ACCOUNT_ID ], day, month, year, gettime()
	) ;

	mysql_tquery(mysql, query);

}
 

// To avoid stack size stuff
static EmailDlgStr[1024];
static EmailQueryStr[256];

GetPlayerEmail(playerid){

	inline GetEmail(pid, dialogid, response, listitem, string:inputtext[]) 
	{
	    #pragma unused pid, dialogid, listitem

		if ( ! response ) {
			SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "For safety reasons, you MUST set an email address.");
			return GetPlayerEmail(playerid);
		}

		if ( response ) {

			if(!IsValidEmail(inputtext)){
				SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Please enter a valid email!");
				return GetPlayerEmail(playerid);
			}
 	
 			new query [ 512 ] ;

			mysql_format(mysql, query, sizeof ( query ),  "SELECT account_email FROM accounts WHERE account_email='%e'", inputtext ) ;

			inline CheckEmailValidity() {

				new rows, fields;
				cache_get_data ( rows, fields, mysql ) ;

				if ( rows ) {

					SendServerMessage( playerid, COLOR_ERROR, "Security", "A3A3A3", "This email is already used by someone else! Enter a new one, or visit our UCP to reset it!");
					return GetPlayerEmail(playerid);
				}

				else if (!rows) {

					mysql_format(mysql, EmailQueryStr, sizeof(EmailQueryStr), "UPDATE accounts SET account_email = '%e' WHERE account_id = %d", inputtext, Account[playerid][E_PLAYER_ACCOUNT_ID]);
					mysql_tquery(mysql, EmailQueryStr);
					
					Account [ playerid ] [ E_PLAYER_ACCOUNT_EMAIL ] [ 0 ] = EOS ;
					strcat(Account [ playerid ] [ E_PLAYER_ACCOUNT_EMAIL ], inputtext);

					SendServerMessage( playerid, COLOR_SECURITY, "Security", "A3A3A3", sprintf("You have set your email to {adadad}%s{dedede}.", Account[playerid][E_PLAYER_ACCOUNT_EMAIL]));
					SendServerMessage( playerid, COLOR_SECURITY, "Security", "A3A3A3", "If you have entered the wrong email, contact a staff member to reset it."); // REMOVE / EDIT ON UCP!!
					return true ;
				}
			} 

			mysql_tquery_inline(mysql, query, using inline CheckEmailValidity, "");
		}

		return true ;
	}

	format(EmailDlgStr, sizeof(EmailDlgStr), "{FFFFFF}We need you to {AA3333}enter an e-mail address{FFFFFF} before continuing.");

	strcat(EmailDlgStr, "\n\n{FFFFFF}Why do you need to do this?{ADBEE6}");
	strcat(EmailDlgStr, "\n- To let you reset your password incase you forget it.");
	strcat(EmailDlgStr, "\n- To let you know when you have refunds waiting.");
	strcat(EmailDlgStr, "\n- To let you know of unauthorized attempts to access your account.");
	strcat(EmailDlgStr, "\n- To prepare your account ahead of our new User Control Panel (UCP) launching.\n\n");

	strcat(EmailDlgStr, "{FFFFFF}Please enter your e-mail address below and press {AA3333}Confirm{FFFFFF} to continue.");
	strcat(EmailDlgStr, "\n{ADBEE6}Note that your e-mail address will never be visible to other players or moderators.");

	Dialog_ShowCallback ( playerid, using inline GetEmail, DIALOG_STYLE_INPUT, "Enter an Email Address", EmailDlgStr, "Continue" );
	return true;
}

stock IsValidEmail(const email[])
{
  static Regex:regex;
  if (!regex) regex = Regex_New("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");

  return Regex_Check(email, regex);
}

