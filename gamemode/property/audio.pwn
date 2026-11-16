// Simple property interior audio system by Spooky

// bool:E_PROPERTY_INT_AUDIO_ON, // whether audio is turned on or off
// Float: E_PROPERTY_INT_AUDIO_X, // spatial position of stream/sound
// Float: E_PROPERTY_INT_AUDIO_Y, // spatial position of stream/sound
// Float: E_PROPERTY_INT_AUDIO_Z, // spatial position of stream/sound
// E_PROPERTY_INT_AUDIO_ID,       // if > 0, then game sound id to play
// E_PROPERTY_INT_AUDIO_URL[128], // otherwise, url to stream

#define PROPERTY_AUDIO_TYPE_NONE    0
#define PROPERTY_AUDIO_TYPE_SOUND   1
#define PROPERTY_AUDIO_TYPE_STREAM  2
#define PROPERTY_AUDIO_RADIUS   50.0

static PropAudioDlgStr[1024];

static PropertyAudio_SetURL(playerid, prop_enum_id, url[])
{   
    new query[256];

    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID] = 0;
    format(Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL], 128, "%s", url);

    mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_int_audio_id = %d, property_int_audio_url = '%e' WHERE property_id = %d", 
        Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL], Property[prop_enum_id][E_PROPERTY_ID]
    );

    mysql_tquery(mysql, query);
    print(query);

    SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3", sprintf("Audio URL set to: %s", Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL]));
}

static PropertyAudio_SetID(playerid, prop_enum_id, id)
{
    new query[256];

    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID] = id;
    mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_int_audio_id = %d WHERE property_id = %d", Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID], Property[prop_enum_id][E_PROPERTY_ID]);
    mysql_tquery(mysql, query);
    print(query);

    SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3", sprintf("Audio Sound ID set to: %d", Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID]));
}

static PropertyAudio_SetSource(playerid, prop_enum_id, Float:x, Float:y, Float:z)
{
    new query[256];

    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X] = x;
    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y] = y;
    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Z] = z;

    mysql_format(mysql, query, sizeof(query), "UPDATE properties SET property_int_audio_x = %f, property_int_audio_y = %f, property_int_audio_z = %f WHERE property_id = %d", 
        Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Z], Property[prop_enum_id][E_PROPERTY_ID]
    );

	mysql_tquery(mysql, query);
    print(query);

	if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X] && Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y])
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3", "You changed the audio source to your current position.");
	}
	else
	{
		SendServerMessage(playerid, COLOR_PROPERTY, "Property", "A3A3A3", "You changed the audio to play globally throughout the property.");
	}
}

static CheckPropertyPermission(playerid, prop_enum_id)
{
    if (prop_enum_id == INVALID_PROPERTY_ID) 
	{
		SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a property.");
        return false;
	}

    if (Property[prop_enum_id][E_PROPERTY_TYPE] == E_PROPERTY_TYPE_STATIC)
	{
		SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't use audio in a static property.");
        return false;
	}

	new access = Property[prop_enum_id][E_PROPERTY_OWNER] == Character[playerid][E_CHARACTER_ID] || Character[playerid][E_CHARACTER_RENTEDHOUSE] == Property[prop_enum_id][E_PROPERTY_ID] || Character[playerid][E_CHARACTER_PROP_DUP] == Property[prop_enum_id][E_PROPERTY_ID];

	if (!access)
	{
		if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR && PlayerVar[playerid][E_PLAYER_ADMIN_DUTY]) SendClientMessage(playerid, COLOR_YELLOW, "You're using your admin powers to do this." );
		else if (GetPlayerAdminLevel(playerid) > ADMIN_LVL_JUNIOR)
        {
            SendClientMessage(playerid, -1, "You don't have normal access to this property, but can go on admin duty to do this.");
            return false;
        } 
		else
        {
            SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't own or rent this property.");
            return false;
        } 
	}

    return true;
}

static GetPropertyAudioType(prop_enum_id)
{
    if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID])
    {
        return PROPERTY_AUDIO_TYPE_SOUND;
    }
    else if (strlen(Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL]) && strcmp(Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL], "NULL"))
    {   
        return PROPERTY_AUDIO_TYPE_STREAM;
    }

    return PROPERTY_AUDIO_TYPE_NONE;
}

static PropertyAudio_Play(playerid, prop_enum_id)
{
    new audio_type = PROPERTY_AUDIO_TYPE_NONE;
    
    if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON])
    {
        audio_type = GetPropertyAudioType(prop_enum_id);

        switch(audio_type)
        {
            case PROPERTY_AUDIO_TYPE_SOUND:
            {
                PlayerPlaySound(playerid, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Z]);
            }
            case PROPERTY_AUDIO_TYPE_STREAM:
            {
                if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X] && Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y])
                {
                    PlayAudioStreamForPlayer(playerid, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Z], PROPERTY_AUDIO_RADIUS, true);
                }
                else
                {
                    PlayAudioStreamForPlayer(playerid, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL], 0.0, 0.0, 0.0, PROPERTY_AUDIO_RADIUS, false);
                }
            }
        }
    }
    
    PlayerVar[playerid][E_PLAYER_PROPERTY_AUDIO] = audio_type;
    return true; 
}

PropertyAudio_Stop(playerid)
{
    switch(PlayerVar[playerid][E_PLAYER_PROPERTY_AUDIO])
    {
        case PROPERTY_AUDIO_TYPE_SOUND:
        {
            PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
        }
        case PROPERTY_AUDIO_TYPE_STREAM:
        {
            StopAudioStreamForPlayer(playerid);
        }   
    }

    PlayerVar[playerid][E_PLAYER_PROPERTY_AUDIO] = PROPERTY_AUDIO_TYPE_NONE;
    return true;
}

static PropertyAudio_Update(prop_enum_id)
{
    foreach(new inhabitant: Player) 
	{
        if (IsPlayerInsideProperty(inhabitant) != prop_enum_id) continue;

        PropertyAudio_Stop(inhabitant);

        if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON])
        {
            PropertyAudio_Play(inhabitant, prop_enum_id);
        }
	}

    return true; 
}

static PropertyAudio_Toggle(playerid, prop_enum_id)
{
    if (GetPropertyAudioType(prop_enum_id) == PROPERTY_AUDIO_TYPE_NONE)
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You haven't set a sound to play yet.");

    Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON] = !Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON];
    PropertyAudio_Update(prop_enum_id);

    return true;
}

static bool:URL_DISABLED;

CMD:blocksoundurls(playerid)
{
    if (!IsPlayerAdmin(playerid)) return 0;

    if (URL_DISABLED)
    {
        URL_DISABLED = false;
        SendClientMessage(playerid, -1, "You unblocked sound URLs in property audio.");
    }
    else
    {
        URL_DISABLED = true;
        SendClientMessage(playerid, -1, "You blocked sound URLs in property audio.");
    }

    return 1;
}

static PropertyAudio_URL(playerid, prop_enum_id)
{
    if (URL_DISABLED)
    {
        return SendClientMessage(playerid, -1, "Disabled because people can't listen. Will be re-enabled in GTAC 2.0.");
    }

    inline DlgAudioInput(pid, dialogid, response, listitem, string: inputtext[]) 
    {
 		#pragma unused pid, dialogid, response, listitem, inputtext

 		if (response) 
        {
            if (strlen(inputtext) < 10 || strlen(inputtext) > 100 || isnumeric(inputtext)) SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "The Sound URL must be between 10 and 100 characters.");

            new Regex:regex = Regex_New("[(http(s)?):\\/\\/(www\\.)?a-zA-Z0-9@:._\\+=]{2,100}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:_\\+.?&//=]*)");
            if (strlen(inputtext) < 10 || strlen(inputtext) > 100 || isnumeric(inputtext)) {}
            else if (!Regex_Check(inputtext, regex)) SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "The Sound URL was invalid.");
            else PropertyAudio_SetURL(playerid, prop_enum_id, inputtext);
            Regex_Delete(regex);
 		}

        ShowPropertyAudioMenu(playerid, prop_enum_id);
    }

    Dialog_ShowCallback(playerid, using inline DlgAudioInput, DIALOG_STYLE_INPUT, "Property Sound URL", "{FFFFFF}Enter the URL for the custom sound below:\n{ADBEE6}This should link to either a normal audio file (.mp3) or a playlist (.pls)", "OK", "Back");
    return true;
}

static PropertyAudio_SoundID(playerid, prop_enum_id)
{
    inline DlgAudioInput(pid, dialogid, response, listitem, string: inputtext[]) 
    {
 		#pragma unused pid, dialogid, response, listitem, inputtext

 		if (response) 
        {
            new soundid = strval(inputtext);
            if (soundid < 1 || (soundid > 999 && GetPlayerAdminLevel(playerid) < 6)) SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "The Sound ID must be between 1 and 999.");
            else PropertyAudio_SetID(playerid, prop_enum_id, soundid);
 		}

        ShowPropertyAudioMenu(playerid, prop_enum_id);
    }

    Dialog_ShowCallback(playerid, using inline DlgAudioInput, DIALOG_STYLE_INPUT, "Property Sound ID", "{FFFFFF}Enter your chosen Sound ID below:\n{ADBEE6}(https://open.mp/docs/scripting/resources/sound-ids)", "OK", "Back");
    return true;
}

static PropertyAudio_Change(playerid, prop_enum_id)
{
    if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON])
    {
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't change the audio settings while it's playing.");
    }

    inline DlgAudioType(pid, dialogid, response, listitem, string: inputtext[]) 
    {
 		#pragma unused pid, dialogid, response, listitem, inputtext

        if (!response)
        {
            return ShowPropertyAudioMenu(playerid, prop_enum_id);
        }
        
 		if (response) 
        {
            if (listitem == 0) return PropertyAudio_SoundID(playerid, prop_enum_id);
            else if (listitem == 1) return PropertyAudio_URL(playerid, prop_enum_id);
 		}
    }

    Dialog_ShowCallback(playerid, using inline DlgAudioType, DIALOG_STYLE_LIST, "Select audio type", "Game Sound ID\nCustom Audio URL", "Select", "Back");
    return true;
}

static ShowPropertyAudioMenu(playerid, prop_enum_id)
{
    format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "Setting\tValue");
    format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nEnabled\t%s", PropAudioDlgStr, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON] ? "Yes" : "No");

    if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X] && Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y])
    {
        format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nSource\tSpatial (%.03f, %.03f, %.03f)", PropAudioDlgStr, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_X], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Y], Property[prop_enum_id][E_PROPERTY_INT_AUDIO_Z]);
    }
    else
    {
        format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nSource\t%s", PropAudioDlgStr, "Global");
    }

    switch (GetPropertyAudioType(prop_enum_id))
    {
        case PROPERTY_AUDIO_TYPE_SOUND:
        {
            format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nType\t%s", PropAudioDlgStr, "Game Sound ID");
            format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nSound ID\t%d", PropAudioDlgStr, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ID]);
        }
        case PROPERTY_AUDIO_TYPE_STREAM:
        {
            format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nType\t%s", PropAudioDlgStr, "Custom Audio Stream (URL)");

            if (strlen(Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL]) > 50)
            {
                format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nURL\t%.47s...", PropAudioDlgStr, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL]);
            }
            else
            {
                format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nURL\t%s", PropAudioDlgStr, Property[prop_enum_id][E_PROPERTY_INT_AUDIO_URL]);
            }
        }
        default:
        {
            format(PropAudioDlgStr, sizeof(PropAudioDlgStr), "%s\nType\t%s", PropAudioDlgStr, "None");
        }
    }

    inline DlgAudioMenu(pid, dialogid, response, listitem, string: inputtext[]) 
    {
 		#pragma unused pid, dialogid, response, listitem, inputtext

        if (!response)
        {
            return true;
        }
        
 		if (response) 
        {
            if (listitem == 0)
            {
                PropertyAudio_Toggle(playerid, prop_enum_id);
                return ShowPropertyAudioMenu(playerid, prop_enum_id);
            }
            else if (listitem == 1)
            {
                SendClientMessage(playerid, COLOR_PROPERTY, "Type \"/propaudiosource\" to change the sound's source position.");
            }
            else
            {
                PropertyAudio_Change(playerid, prop_enum_id);
            } 
 		}
    }

    Dialog_ShowCallback(playerid, using inline DlgAudioMenu, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Audio Panel - %s", ReturnPropEnterText(prop_enum_id, false)), PropAudioDlgStr, "Select", "Back");
    return true;
}

CMD:propertyaudio(playerid, params[]) 
{
	new prop_enum_id = IsPlayerInsideProperty(playerid);
    if (!CheckPropertyPermission(playerid, prop_enum_id)) return true;

	ShowPropertyAudioMenu(playerid, prop_enum_id);
	return true ;
}

CMD:propaudio(playerid, params[])
{
	return cmd_propertyaudio(playerid, params);
}

CMD:propertyaudiosource(playerid, params[]) 
{
	new prop_enum_id = IsPlayerInsideProperty(playerid);
    if (!CheckPropertyPermission(playerid, prop_enum_id)) return true;

    if (Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON])
    {
        return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You can't change the audio settings while it's playing.");
    }	

	new option[12];
    sscanf(params, "s[12]", option);

    if (strlen(option))
    {
        if (!strcmp(option, "position", true))
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            PropertyAudio_SetSource(playerid, prop_enum_id, x, y, z);
            return true;
        }
        else if (!strcmp(option, "global", true))
        {
            PropertyAudio_SetSource(playerid, prop_enum_id, 0, 0, 0);
            return true;
        }
    }

    SendServerMessage(playerid, COLOR_PROPERTY, "Usage", "DEDEDE", "/propertyaudiosource [position/global]");
    return true;
}

CMD:propaudiosource(playerid, params[])
{
	return cmd_propertyaudiosource(playerid, params);
}

// Should really be hooked, but fuck it for now
PropertyAudio_Sync(playerid, prop_enum_id = -1)
{
    if (PlayerVar[playerid][E_PLAYER_PROPERTY_AUDIO])
    {
        PropertyAudio_Stop(playerid);
    }

    if (prop_enum_id == -1) prop_enum_id = IsPlayerInsideProperty(playerid);

    if (prop_enum_id != -1 && Property[prop_enum_id][E_PROPERTY_INT_AUDIO_ON])
    {
        PropertyAudio_Play(playerid, prop_enum_id);
    }

    return true;
}