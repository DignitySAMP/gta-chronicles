#define MAX_CH_MEMBERS 	6
#define MAX_CHANNELS	36

static enum E_RADIO_CHANNEL
{
	E_RADIO_CH_NAME[64],
	E_RADIO_CH_TAG[10],
	bool:E_RADIO_CH_REPEATED,
	bool:E_RADIO_CH_ENCRYPTED,
	E_RADIO_CH_MEMBERS[MAX_CH_MEMBERS],
	E_RADIO_CH_SQUAD,
	bool:E_RADIO_CH_HIDDEN,
	bool:E_RADIO_CH_VEHICLE
}

#define CH_LSPD	10
#define CH_LSSD	16
#define CH_LSFD	25
#define CH_DEA	29
#define CH_SEC	32
#define CH_FBI	34
#define CH_AP   17
#define CH_GOV 	33
#define CH_TAXI 36

static const RadioChannels[MAX_CHANNELS][E_RADIO_CHANNEL] = 
{
	{ "LSPD Central Bureau Dispatch", "CENTRAL", true, false, { CH_LSPD } },
	{ "LSPD Citywide TAC #1", "CW-TAC1", false, false, { CH_LSPD } },
	{ "LSPD Citywide TAC #2", "CW-TAC2", false, false, { CH_LSPD } },
	{ "LSPD Citywide TAC #3", "CW-TAC3", false, false, { CH_LSPD } },

	{ "LSPD Central Traffic Dispatch", "24-CTD", true, false, { CH_LSPD }, FACTION_SQUAD_TRAFF },
	{ "LSPD Detective Bureau Dispatch", "53-DBU", true, false, { CH_LSPD }, FACTION_SQUAD_CRASH },
	{ "LSPD Gang & Narcotics Division", "54-GND", false, true, { CH_LSPD }, FACTION_SQUAD_CRASH },
	{ "LSPD Organized Crime & Vice Division", "55-OCVD", false, true, { CH_LSPD }, FACTION_SQUAD_CRASH },

	{ "LSPD Metropolitan Dispatch", "65-METRO", true, false, { CH_LSPD }, FACTION_SQUAD_SWAT },
	{ "LSPD SWAT Tactical", "66-SWAT", false, true, { CH_LSPD }, FACTION_SQUAD_SWAT },
	{ "LSPD Internal Affairs", "31-IAG", false, true, { CH_LSPD }, FACTION_SQUAD_IAG },

	{ "LSFD Central Dispatch", "LSFD-HQ", true, false, { CH_LSFD } },
	{ "LSFD Scene Tactical #1", "LSFD-T1", false, false, { CH_LSFD } },
	{ "LSFD Scene Tactical #2", "LSFD-T2", false, false, { CH_LSFD } },

	{ "Dillimore Sheriff's Dispatch", "DISP-15", true, false, { CH_LSSD } },
	{ "Sheriff's Local Tactical #1", "LTAC-1", false, false, { CH_LSSD } },
	{ "Sheriff's Local Tactical #2", "LTAC-2", false, false, { CH_LSSD } },

	{ "Countywide Mutual Aid Dispatch", "M-AID", true, false, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI } },
	{ "Countywide Mutual Tactical #1", "M-TAC1", false, false, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI } },
	{ "Countywide Mutual Tactical #2", "M-TAC2", false, false, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI } },
	{ "Countywide Emergency Dispatch", "M-EMRG", true, false, { CH_LSPD, CH_LSSD, CH_LSFD, CH_DEA, CH_FBI, CH_GOV } },
	{ "Countywide Emergency Tactical", "M-ETAC", false, false, { CH_LSPD, CH_LSSD, CH_LSFD, CH_DEA, CH_FBI, CH_GOV } },

	{ "Chuff Security Company Dispatch", "SEC-HQ", true, false, { CH_SEC } },
	{ "Chuff Security Rockford Plaza", "SEC-PL", false, false, { CH_SEC } },
	{ "Chuff Security Armed Protection", "SEC-AR", false, true, { CH_SEC }, FACTION_SQUAD_ARMED },

	//{ "Regional Interops Law Enforcement Relay", "I-LAW", true, false, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI, CH_AP } },
	//{ "Regional Interops Emergency Management Relay", "I-EMA", true, false, { CH_LSPD, CH_LSSD, CH_LSFD, CH_DEA, CH_FBI, CH_AP } },
	//{ "Regional Organized Crime Task Force", "R-OCTF", false, true, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI, CH_AP }, FACTION_SQUAD_CRASH },
	//{ "Regional Violent Crimes Task Force", "R-VCTF", false, true, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI, CH_AP }, FACTION_SQUAD_CRASH },
	//{ "Regional Public Corruption Task Force", "R-PCTF", false, true, { CH_LSPD, CH_LSSD, CH_DEA, CH_FBI, CH_AP }, FACTION_SQUAD_IAG },

	{ "City of Los Santos General Services", "GOV-GS", true, false, {CH_GOV} },
	{ "City of Los Santos Public Works", "GOV-PW", false, false, {CH_GOV} },
	{ "City of Los Santos Traffic Enforcement", "GOV-PW", false, false, {CH_GOV}, FACTION_SQUAD_GOV_TRAFFIC },
	{ "District Attorney's Office Investigations", "GOV-DA", false, true, {CH_GOV}, FACTION_SQUAD_GOV_DAO },
	{ "Cabbie & Co. Taxi Dispatch", "TAXI", true, false, {CH_TAXI}, 0, false, true },
	
	{ "Federal Bureau of Investigation", "F-FBI", true, true, {CH_FBI} },
	{ "Drug Enforcement Administration", "F-DEA", true, true, {CH_DEA} },
	{ "Federal Agencies Interops Relay", "F-MCOM", true, true, { CH_DEA, CH_FBI, CH_AP } },
	{ "Federal Agencies Interops Tactical", "F-MTAC", false, true, { CH_DEA, CH_FBI, CH_AP } },

	{ "Aperture Communications HQ", "X-APHQ", true, true, { CH_AP }, 0, true },
	{ "Aperture Pentagon Secure Link", "X-NMCC", false, true, { CH_AP }, 0, true }
};

// Sets players radio channel either to invalid or the first one found for their faction (used on login)
Radio_InitializePlayer(playerid)
{
	new fid = Character[playerid][E_CHARACTER_FACTIONID];
	PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL] = -1;

	if (fid)
	{
		for (new i = 0; i < MAX_CHANNELS; i ++)
		{
			if (RadioChannels[i][E_RADIO_CH_MEMBERS] && RadioChannels[i][E_RADIO_CH_MEMBERS][0] == fid)
			{
				PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL] = i;
				break;
			}
		}
	}
}

hook SOLS_OnLoadCharacter(playerid, character_id)
{
	Radio_InitializePlayer(playerid);
	new ch = PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL];
	
	if (ch != -1 && PlayerVar[playerid][E_PLAYER_FACTION_DUTY])
	{
		SendServerMessage(playerid, COLOR_FACTION, "Radio", "A3A3A3", sprintf("Your radio was automatically tuned to Channel %d \"%s\".", ch, RadioChannels[ch][E_RADIO_CH_TAG]));
	}

	return 1;
}

static bool:ArrayContains(const array[], size, value)
{
    for (new i = 0; i < size; i ++)
    {
        if (array[i] == value) return true;
    }

    return false;
}

PrintRadioChannelTag(playerid)
{
	new ch = PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL];
	new ret[16] = "N/A";

	if (ch != -1) format(ret, sizeof(ret), RadioChannels[ch][E_RADIO_CH_TAG]);
	return ret;
}

bool:IsRadioChannelMember(channel, factionid)
{
	if (!RadioChannels[channel][E_RADIO_CH_MEMBERS]) return true;
	return ArrayContains(RadioChannels[channel][E_RADIO_CH_MEMBERS], MAX_CH_MEMBERS, factionid);
}

bool:IsRadioChannelPlayer(channel, playerid)
{
	return Character[playerid][E_CHARACTER_FACTIONID] && IsRadioChannelMember(channel, Character[playerid][E_CHARACTER_FACTIONID]) 
		&& (!RadioChannels[channel][E_RADIO_CH_SQUAD] || Character[playerid][E_CHARACTER_FACTION_SQUAD] == RadioChannels[channel][E_RADIO_CH_SQUAD] || IsPlayerInDEAFaction(playerid));
}

bool:IsRadioMessageReceiver(senderid, targetid)
{
	new channel = PlayerVar[senderid][E_PLAYER_PD_RADIO_CHANNEL];

	if (RadioChannels[channel][E_RADIO_CH_REPEATED] && Character[senderid][E_CHARACTER_FACTIONID] == Character[targetid][E_CHARACTER_FACTIONID])
	{
		// If this is a repeated channel and they are in the same faction + squad, always return true
		if (!RadioChannels[channel][E_RADIO_CH_SQUAD] || IsPlayerInDEAFaction(targetid) || RadioChannels[channel][E_RADIO_CH_SQUAD] == Character[targetid][E_CHARACTER_FACTION_SQUAD])
		{
			return true;
		}
	}
	else if (RadioChannels[channel][E_RADIO_CH_MEMBERS] && (RadioChannels[channel][E_RADIO_CH_REPEATED] || PlayerVar[targetid][E_PLAYER_PD_RADIO_CHANNEL] == PlayerVar[senderid][E_PLAYER_PD_RADIO_CHANNEL]))
	{
		if (!RadioChannels[channel][E_RADIO_CH_SQUAD] || IsPlayerInDEAFaction(targetid) || RadioChannels[channel][E_RADIO_CH_SQUAD] == Character[targetid][E_CHARACTER_FACTION_SQUAD])
		{
			// Otherwise, if they are in a member faction of the channel and either:
			// 1. it's a repeated channel, or
			// 2. they are tuned to the channel
			return ArrayContains(RadioChannels[channel][E_RADIO_CH_MEMBERS], MAX_CH_MEMBERS, Character[targetid][E_CHARACTER_FACTIONID]);
		}
	} 

	return false;
}

bool:IsRadioFaction(fac_enumid)
{
	new ftype = Faction_GetType(fac_enumid);
	return ftype == FACTION_TYPE_POLICE || ftype == FACTION_TYPE_EMS || ftype == FACTION_TYPE_DEA || ftype == FACTION_TYPE_SECURITY || ftype == FACTION_TYPE_GOV || ftype == FACTION_TYPE_TAXI;
}

bool:IsInRadioFaction(playerid)
{
	new factionid = Character[playerid][E_CHARACTER_FACTIONID];

	if (factionid)
	{
		return IsRadioFaction(Faction_GetEnumID(factionid));
	}

	return false;
}

static ChannelDlgStr[2048];

ShowRadioChannelDlg(playerid, channel)
{
	inline DlgChannel(pid, dialogid, response, listitem, string:inputtext[]) 
	{
        #pragma unused pid, dialogid, inputtext, listitem

        if (response)
		{
			cmd_channel(playerid, sprintf("%d", channel));
		}
		else
		{
			cmd_channels(playerid);
		}
    }

	format(ChannelDlgStr, sizeof(ChannelDlgStr), "{FFFFFF}You're viewing the {AA3333}\"%s\"{FFFFFF} radio channel.", RadioChannels[channel][E_RADIO_CH_NAME]);

	strcat(ChannelDlgStr, "\n\n{FFFFFF}Channel Members:{ADBEE6}");
	for (new i = 0; i < MAX_FACTIONS; i ++)
	{
		if (Faction[i][E_FACTION_ID] && IsRadioChannelMember(channel, Faction[i][E_FACTION_ID]))
		{
			strcat(ChannelDlgStr, sprintf("\n- %s (%s)", Faction[i][E_FACTION_NAME], Faction[i][E_FACTION_ABBREV]));
		}
	}

	strcat(ChannelDlgStr, "\n\n{FFFFFF}Channel Attributes:{ADBEE6}");
	if (RadioChannels[channel][E_RADIO_CH_REPEATED]) strcat(ChannelDlgStr, "\n- This channel is repeated to members across all frequencies.");
	else strcat(ChannelDlgStr, "\n- This channel is only broadcast to tuned listeners.");
	if (RadioChannels[channel][E_RADIO_CH_SQUAD]) strcat(ChannelDlgStr, sprintf("\n- Access to this channel is restricted to Squad %d.", RadioChannels[channel][E_RADIO_CH_SQUAD]));
	else strcat(ChannelDlgStr, sprintf("\n- Any member can access this channel."));
	if (RadioChannels[channel][E_RADIO_CH_ENCRYPTED]) strcat(ChannelDlgStr, "\n- Radio traffic on this channel is protected by encryption.");
	else strcat(ChannelDlgStr, "\n- Radio traffic on this channel is broadcasted without encryption.");

	strcat(ChannelDlgStr, "\n\n{FFFFFF}Press {AA3333}Tune{FFFFFF} to set your radio to this channel.");
	Dialog_ShowCallback ( playerid, using inline DlgChannel, DIALOG_STYLE_MSGBOX, sprintf("%s (%s)", RadioChannels[channel][E_RADIO_CH_NAME], RadioChannels[channel][E_RADIO_CH_TAG]), ChannelDlgStr, "Tune", "Back" );
}

CMD:channels(playerid)
{
	format(ChannelDlgStr, sizeof(ChannelDlgStr), "Channel\tTag\tDescription\tRepeated");

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ], faction_enum_id;
	new map[MAX_CHANNELS], count;

	if (factionid)
	{
		faction_enum_id = Faction_GetEnumID(factionid);
		if (!IsPlayerInAnyGovFaction(playerid)) factionid = 0;
	}

	for (new i = 0; i < MAX_CHANNELS; i ++)
	{
		if (RadioChannels[i][E_RADIO_CH_HIDDEN] && !IsRadioChannelPlayer(i, playerid)) continue;

		if (RadioChannels[i][E_RADIO_CH_MEMBERS] || !factionid)
		{
			format(ChannelDlgStr, sizeof(ChannelDlgStr), "%s\n%d\t%s\t%s\t%s", ChannelDlgStr, i, RadioChannels[i][E_RADIO_CH_TAG], RadioChannels[i][E_RADIO_CH_NAME], RadioChannels[i][E_RADIO_CH_REPEATED] ? "Yes" : "No");
		}
		else
		{
			format(ChannelDlgStr, sizeof(ChannelDlgStr), "%s\n%d\t%s\t%s %s\t%s", ChannelDlgStr, i, RadioChannels[i][E_RADIO_CH_TAG], Faction[faction_enum_id][E_FACTION_ABBREV], RadioChannels[i][E_RADIO_CH_NAME], RadioChannels[i][E_RADIO_CH_REPEATED] ? "Yes" : "No");
		}

		map[count] = i;
		count ++;
	}

    inline DlgChannels(pid, dialogid, response, listitem, string:inputtext[]) 
	{
        #pragma unused pid, dialogid, inputtext, listitem

        if (response && listitem < MAX_CHANNELS && listitem >= 0)
		{
			ShowRadioChannelDlg(playerid, map[listitem]);
		}
    }

    Dialog_ShowCallback ( playerid, using inline DlgChannels, DIALOG_STYLE_TABLIST_HEADERS, "Radio Channels", ChannelDlgStr, "Select", "Back" );
	return true;
}

CMD:chs(playerid)
{
	return cmd_channels(playerid);
}

CMD:channel(playerid, params[]) 
{
	if (IsPlayerIncapacitated(playerid)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	if (!IsInRadioFaction(playerid))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction that can switch radio channels.");
	}

	// new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;
	// new faction_enum_id = Faction_GetEnumID( factionid ); 

	new option, current = PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL];

	if (sscanf(params, "d", option) || option < 0 || option >= MAX_CHANNELS) 
	{
		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/ch(annel) [number]" ) ;

		/*
		new index = 0;
		new helpstr[128];

		for (new i = 0; i < MAX_CHANNELS; i ++)
		{
			//if (!IsRadioChannelPlayer(i, playerid)) continue;
			if (!RadioChannels[i][E_RADIO_CH_MEMBERS] || !ArrayContains(RadioChannels[i][E_RADIO_CH_MEMBERS], MAX_CH_MEMBERS, factionid)) continue;

			if (index) strcat(helpstr, ", ");
			format(helpstr, sizeof(helpstr), "%s%d: %s", helpstr, i, RadioChannels[i][E_RADIO_CH_TAG]);
			index ++;
		}

		strcat(helpstr, ". Type /channels to view a full list.");*/

		if (current >= 0 && current < MAX_CHANNELS)
		{	
			new listeners = 0;

			SendClientMessage(playerid, 0xDEDEDEFF, sprintf("Current Channel: (%d) \"%s\", Units:", current, RadioChannels[current][E_RADIO_CH_TAG]));

			foreach(new targetid: Player) 
			{
				if (!IsPlayerPlaying(targetid)) continue;

				if (PlayerVar[targetid][E_PLAYER_PD_RADIO_CHANNEL] == current && targetid != playerid)
				{
					if (CAD_GetPlayerUnit(targetid))
					{
						SendClientMessage(playerid, 0xDEDEDEFF, sprintf("> [%s] (%d) %s", CAD_PrintPlayerUnit(targetid, true), targetid, SOLS_PlayerName(targetid, PLAYER_NAME_STYLE_CHARACTER)));
					}
					
					listeners ++;
				}
			}

			if (!listeners)
			{
				SendClientMessage(playerid, 0xDEDEDEFF, "There are no units on this channel.");
			}
		}
		else
		{
			SendClientMessage(playerid, 0xDEDEDEFF, sprintf("Type /channels to view a full list. Your current channel is %d (Invalid).", current));
		}

		return true;
	}

	if (!IsRadioChannelPlayer(option, playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have access to this radio channel.");
	}

	PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ] = option;
	SendServerMessage ( playerid, COLOR_FACTION, "Radio", "A3A3A3", sprintf("Channel changed to \"%s\" (%s).", RadioChannels[option][E_RADIO_CH_NAME], RadioChannels[option][E_RADIO_CH_TAG]) );

	return true ;
}

CMD:ch(playerid, params[])
{
	return cmd_channel(playerid, params);
}

bool:IsScannerVehicle(vehicleid)
{
	if (vehicleid)
	{
		new model = GetVehicleModel(vehicleid);
		if (model == 582 || model == 488) return true; // news vehicles
	}

	return false;
}

Has911Scanner(playerid)
{
	return PlayerVar[playerid][E_PLAYER_911_SCANNER] || PlayerVar[playerid][E_PLAYER_OP_SCANNER];
}

HasOPScanner(playerid)
{
	return PlayerVar[playerid][E_PLAYER_OP_SCANNER];
}

CMD:911s(playerid)
{
	if (!IsPlayerInDEAFaction(playerid) && !IsPlayerInNewsFaction(playerid))
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have access to this.");
	}

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be Tier 3 or higher to use this.");
	}

	if (!PlayerVar[playerid][E_PLAYER_911_SCANNER])
	{
		SendClientMessage(playerid, COLOR_FACTION, "911 Scanner Enabled: you will now receive notice of all 911 calls.");
		PlayerVar[playerid][E_PLAYER_911_SCANNER] = true;
	}
	else
	{	
		SendClientMessage(playerid, COLOR_FACTION, "911 Scanner Disabled: you will no longer receive notice of 911 calls.");
		PlayerVar[playerid][E_PLAYER_911_SCANNER] = false;
	}

	return true;
}

CMD:apscanner(playerid)
{
	if (!IsPlayerInAPFaction(playerid) && GetPlayerAdminLevel(playerid) < ADMIN_LVL_DEVELOPER)
	{
		return false;
	}

	if (!PlayerVar[playerid][E_PLAYER_OP_SCANNER])
	{
		SendClientMessage(playerid, COLOR_FACTION, "AP Scanner enabled: listening to all police frequencies and dispatches.");
		PlayerVar[playerid][E_PLAYER_OP_SCANNER] = true;
	}
	else
	{	
		SendClientMessage(playerid, COLOR_FACTION, "AP Scanner disabled.");
		PlayerVar[playerid][E_PLAYER_OP_SCANNER] = false;
	}

	return true;
}

CMD:scanner(playerid, params[])
{
	if (!IsPlayerInDEAFaction(playerid) && !IsPlayerInNewsFaction(playerid)) return false;

	if (IsPlayerIncapacitated(playerid)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID(vehicleid);
	
	if (!IsPlayerInAnyVehicle(playerid) || !vehicleid || veh_enum_id == -1 || (!IsPlayerInDEAFaction(playerid) && !IsScannerVehicle(vehicleid)))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be in a vehicle equipped with a radio scanner." ) ;
	}

	if (Character[playerid][E_CHARACTER_FACTIONTIER] > 3)
	{
		return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be Tier 3 or higher to use this.");
	}

	new channel, channelstr[5];
    sscanf(params, "s[5]", channelstr); 

	if (strlen(channelstr))
	{
		if (!strcmp(channelstr, "off", true))
		{
			SendClientMessage(playerid, COLOR_FACTION, "You turned the radio scanner off.");
			VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL] = 0;
			return true;
		}

		channel = strval(channelstr);
		if (IsNumeric(channelstr) && channel >= 0 && channel < MAX_CHANNELS)
		{
			if (RadioChannels[channel][E_RADIO_CH_ENCRYPTED])
			{
				return SendServerMessage(playerid, COLOR_ERROR, "Error", "A3A3A3", "This channel is encrypted.");
			}

			VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL] = channel + 1;
			SendClientMessage(playerid, COLOR_FACTION, sprintf("You tuned the scanner to the \"%s\" channel. It's now playing in the car.", RadioChannels[channel][E_RADIO_CH_NAME]));
			return true;
		}
	}

	// Otherwise show the syntax
	SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/scanner [channel number] (or \"off\" to disable)");
	SendClientMessage(playerid, 0xDEDEDEFF, "Type /channels to view a full list of radio channels.");
	return true;
}

CMD:radio(playerid, params[]) 
{
	if (IsPlayerIncapacitated(playerid)) return SendServerMessage(playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this.");
	
	new factionid = Character[playerid][E_CHARACTER_FACTIONID];
	new faction_enum_id = Faction_GetEnumID(factionid); 
	
	if (!factionid || faction_enum_id == INVALID_FACTION_ID || !IsInRadioFaction(playerid)) 
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction with a radio.");
	}

	new text[144], string[256];
	new channel = PlayerVar[playerid][E_PLAYER_PD_RADIO_CHANNEL];

	if (channel < 0 || channel >= MAX_CHANNELS)
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Radio", "A3A3A3", "Your radio channel isn't set properly, type /channel to change it.");
	}

	if (!PlayerVar[playerid][E_PLAYER_FACTION_DUTY])
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Radio", "A3A3A3", "You must be on duty to use your faction radio.");
	}

	if (sscanf (params, "s[144]", text))
	{
		SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/r(adio) [message]" ) ;
		return true ;
	}

	if (CAD_GetPlayerUnit(playerid))
	{
		format(string, sizeof(string), "** [CH %d: %s] [%s] %s #%03d: %s", channel, RadioChannels[channel][E_RADIO_CH_TAG], CAD_PrintPlayerUnit(playerid, true), SOLS_PlayerName(playerid), Character[playerid][E_CHARACTER_FACTION_BADGE], text);
	}
	else
	{
		format(string, sizeof(string), "** [CH %d: %s] %s #%03d: %s", channel, RadioChannels[channel][E_RADIO_CH_TAG], SOLS_PlayerName(playerid), Character[playerid][E_CHARACTER_FACTION_BADGE], text);
	}

	new vehicleid, recipients;

	foreach(new targetid: Player) 
	{
		if (!IsPlayerPlaying(targetid)) continue;

		if (IsPlayerInAnyVehicle(targetid))
		{
			vehicleid = GetPlayerVehicleID(targetid);
			if (vehicleid && VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL])
			{
				if (VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL] == (channel + 1))
				{
					ZMsg_SendClientMessage(targetid, COLOR_POLICE, string);
				}
			}
		}

		if (!Character[targetid][E_CHARACTER_FACTIONID]) continue;
		else if (PlayerVar[targetid][E_PLAYER_FACTION_DUTY] && IsRadioMessageReceiver(playerid, targetid))
		{
			if (PlayerVar[targetid][E_PLAYER_PD_RADIO_CHANNEL] == channel) 
			{
				// Brighter if on same channel
				ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
			} 
			else
			{
				ZMsg_SendClientMessage(targetid, 0xDFD6A6FF, string);
			}

			if (targetid != playerid) recipients ++;
		}
		else if (HasOPScanner(targetid) && !RadioChannels[channel][E_RADIO_CH_ENCRYPTED] && RadioChannels[channel][E_RADIO_CH_REPEATED])
		{
			ZMsg_SendClientMessage(targetid, COLOR_POLICE, string);
		}
	}

	format(string, sizeof(string), "[CH: %s] %s", RadioChannels[channel][E_RADIO_CH_TAG], text);
	SetPlayerChatBubble(playerid, string, 0xFFEC8BFF, 15.0, (strlen(text) * 50) + 2500);

	if (!recipients && !RadioChannels[channel][E_RADIO_CH_REPEATED])
	{
		ShowPlayerSubtitle(playerid, "~r~Your transmission wasn't received by anyone.", .showtime = 3000);
	}

	// NEW LOGGING: Log this as a LOG_TYPE_RADIO for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_RADIO, string);

	return true;
}

CMD:r(playerid, params[])
{
	return cmd_radio(playerid, params);
}	


CMD:department(playerid, params[]) 
{
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	new text [ 128 ] ;

	if ( sscanf ( params, "s[128]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/dep(artment) [text]" ) ;
		return true ;
	}
	
	new string [ 144 ] ;
	new vehicleid;


	if ( IsPlayerInAnyGovFaction(playerid, true) ) {
		format ( string, sizeof ( string ),  "** [DEP] %s: %s", SOLS_PlayerName(playerid), text ) ;
	}
	else {
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not on duty in a government faction.");
	}

	foreach(new targetid: Player) 
	{
		if ( IsPlayerInAnyGovFaction(targetid, true)) 
		{
			ZMsg_SendClientMessage(targetid, 0x88D0C5FF, string);
		}
		else if (HasOPScanner(targetid))
		{
			ZMsg_SendClientMessage(targetid, COLOR_POLICE, string);
		}
		else
		{
			if (IsPlayerInAnyVehicle(playerid))
			{
				vehicleid = GetPlayerVehicleID(targetid);
				if (vehicleid && VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL])
				{
					if (VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL])
					{
						ZMsg_SendClientMessage(targetid, COLOR_POLICE, string);
					}
				}
			}
		}
	}

	// string [ 0 ] = EOS ;

	//format ( string, sizeof ( string ), "%s says (radio) %s", ReturnPlayerNameData ( playerid ), text ) ;
	//ProxDetector ( playerid,10.0, 0xA3A3A3FF, string) ;

	SetPlayerChatBubble(playerid, sprintf("[CH: DEP] %s", text), 0x88D0C5FF, 15.0, (strlen(text) * 50) + 2500) ;
	
	// NEW LOGGING: Log this as a LOG_TYPE_RADIO for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_RADIO, sprintf("[DEP/%s] %s", Faction[faction_enum_id][E_FACTION_ABBREV], text));

	return true ;
}

CMD:dep(playerid, params[]) {

	return cmd_department(playerid, params);
}

CMD:d(playerid, params[]) {

	return cmd_department(playerid, params);
}

/*
CMD:scanner(playerid, params[])
{
	if (!IsPlayerInDEAFaction(playerid) && !IsPlayerInNewsFaction(playerid)) return false;

	if (IsPlayerIncapacitated(playerid)) 
	{
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new vehicleid = GetPlayerVehicleID(playerid);
	new veh_enum_id = Vehicle_GetEnumID(vehicleid);
	
	if (!IsPlayerInAnyVehicle(playerid) || !vehicleid || veh_enum_id == -1 || (!IsPlayerInDEAFaction(playerid) && !IsScannerVehicle(vehicleid)))
	{
		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You must be in a vehicle equipped with a radio scanner." ) ;
	}

	new factionstr[5], fac_enumid = -1;
    sscanf(params, "s[5]", factionstr); 

	if (strlen(factionstr))
	{
		if (!strcmp(factionstr, "off", true))
		{
			SendClientMessage(playerid, COLOR_FACTION, "You turned the radio scanner off.");
			VehicleVar[veh_enum_id][E_VEHICLE_SCANNER_FACTION_ID] = 0;
			return true;
		}

		for_loop ( new i, j = sizeof ( Faction ); i < j ; i ++ ) 
		{
			if (!strcmp(Faction[i][E_FACTION_ABBREV], factionstr, true)) 
			{
				fac_enumid = i;
				break;
			}
		}
	}

	if (fac_enumid >= 0 && fac_enumid < sizeof(Faction))
	{
		if (Faction_GetType(fac_enumid) == FACTION_TYPE_POLICE || Faction_GetType(fac_enumid) == FACTION_TYPE_EMS)
		{
			VehicleVar[veh_enum_id][E_VEHICLE_SCANNER_FACTION_ID] = Faction[fac_enumid][E_FACTION_ID];
			SendClientMessage(playerid, COLOR_FACTION, sprintf("You tuned the radio scanner to the \"%s\" frequency. It is now broadcasting in the car.", Faction[fac_enumid][E_FACTION_ABBREV]));
			return true;
		}
	}

	// Otherwise show the syntax
	SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/scanner [channel]");
	new helpstr[128];
	new index = 0;

	format(helpstr, sizeof(helpstr), "Available Channels: \"Off\", ");

	for_loop ( new i, j = sizeof ( Faction ); i < j ; i ++ ) 
	{
		if (Faction[i][E_FACTION_ID] != INVALID_FACTION_ID && (Faction_GetType(i) == FACTION_TYPE_POLICE || Faction_GetType(i) == FACTION_TYPE_EMS))
		{
			if (index) strcat(helpstr, ", ");
			format(helpstr, sizeof(helpstr), "%s\"%s\"", helpstr, Faction[i][E_FACTION_ABBREV]);
			index ++;
		}
	}

	SendServerMessage(playerid, COLOR_ERROR, "Syntax", "A3A3A3", helpstr);
	return true;
}
*/

/*
	As per popular request...
	https://forum.streetzofls.com/index.php?threads/rlow-for-radio-communication.3514/#post-41483

	and more

*/

/*
CMD:radiolow(playerid, params[]) {
	if ( IsPlayerIncapacitated(playerid) ) {
    
        return SendServerMessage ( playerid, COLOR_ERROR, "Incapacitated", "A3A3A3", "You're currently incapacitated and can't do this." ) ;
    }

	new factionid = Character [ playerid ] [ E_CHARACTER_FACTIONID ] ;

	if ( ! factionid ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "You're not in a faction!");
	}

	new faction_enum_id = Faction_GetEnumID(factionid ); 

	if ( faction_enum_id == INVALID_FACTION_ID ) {

		return SendServerMessage ( playerid, COLOR_ERROR, "Error", "A3A3A3", "Error fetching faction enumerator ID! Contact a DEV.");
	}

	new text [ 256 ] ;

	if ( sscanf ( params, "s[128]", text ) ) {

		SendServerMessage ( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/r(adio)l(ow) [text]" ) ;
		return true ;
	}
	
	new string [ 144 ] ;

    if ( IsPlayerInPoliceFaction(playerid, true)) 
	{
		new channel = PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ];

		if ( CAD_GetPlayerUnit(playerid))
		{
			format(string, sizeof(string), "** [CH: %s] [%s] %s #%03d: %s", PDChannels[channel], CAD_PrintPlayerUnit(playerid, true), ReturnPlayerNameData ( playerid, 0, true ), Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ], text);
		}
		else
		{
			format(string, sizeof(string), "** [CH: %s] %s #%03d: %s", PDChannels[channel], ReturnPlayerNameData ( playerid, 0, true ), Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ], text);
		}
		
		foreach(new targetid: Player) 
		{
			if ( Character [ targetid ] [ E_CHARACTER_FACTIONID ] == factionid && PlayerVar [ targetid ] [ E_PLAYER_FACTION_DUTY ]) 
			{
				switch ( PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ]  ) 
				{

					case 3: { // crash

						if (Character [ targetid ] [ E_CHARACTER_FACTION_SQUAD ] == FACTION_SQUAD_CRASH) {

							if ( PlayerVar [ targetid ] [ E_PLAYER_PD_RADIO_CHANNEL ] == PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ] ) {

								ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
							} 

							else ZMsg_SendClientMessage(targetid, 0xDFD6A6FF, string);
						}

						else continue ;
					}
					case 4: { // swat

						if (Character [ targetid ] [ E_CHARACTER_FACTION_SQUAD ] == FACTION_SQUAD_SWAT) {

							if ( PlayerVar [ targetid ] [ E_PLAYER_PD_RADIO_CHANNEL ] == PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ] ) {

								ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
							} 

							else ZMsg_SendClientMessage(targetid, 0xDFD6A6FF, string);
						}

						else continue ;
					}
					case 5: { // internal affairs

						if (Character [ targetid ] [ E_CHARACTER_FACTION_SQUAD ] == FACTION_SQUAD_IAG) {

							if ( PlayerVar [ targetid ] [ E_PLAYER_PD_RADIO_CHANNEL ] == PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ] ) {

								ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
							} 

							else ZMsg_SendClientMessage(targetid, 0xDFD6A6FF, string);
						}

						else continue ;
					}

					default: {
						if ( PlayerVar [ targetid ] [ E_PLAYER_PD_RADIO_CHANNEL ] == PlayerVar [ playerid ] [ E_PLAYER_PD_RADIO_CHANNEL ] ) {

							// Make target's radio channel show brighter than the rest.
							ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
						}

						else {

							ZMsg_SendClientMessage(targetid, 0xDFD6A6FF, string);
						}

						continue ;
					}
				}
			}

			else continue ;
		}
	}

	else if ( IsPlayerInMedicFaction(playerid, true) ) {
		format ( string, sizeof ( string ),  "** [CH: R-BASE] %s #%3d: %s", ReturnPlayerNameData ( playerid, 0, true ), Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ], text ) ;

		foreach(new targetid: Player) {

			if ( Character [ targetid ] [ E_CHARACTER_FACTIONID ] == factionid && PlayerVar [ targetid ] [ E_PLAYER_FACTION_DUTY ]) {

				// Make target's radio channel show brighter than the rest.
				ZMsg_SendClientMessage(targetid, 0xFF8B8BFF, string);
			}
		}
	}

	else if (IsPlayerInDEAFaction(playerid, true))
	{
		format ( string, sizeof ( string ),  "** [CH: R-DEA] %s #%3d: %s", ReturnPlayerNameData ( playerid, 0, true ), Character [ playerid ] [ E_CHARACTER_FACTION_BADGE ], text ) ;

		foreach(new targetid: Player) {

			if ( Character [ targetid ] [ E_CHARACTER_FACTIONID ] == factionid && PlayerVar [ targetid ] [ E_PLAYER_FACTION_DUTY ]) {

				// Make target's radio channel show brighter than the rest.
				ZMsg_SendClientMessage(targetid, 0xFFEC8BFF, string);
			}
		}
	}

	else {

        return SendServerMessage ( playerid, COLOR_ERROR, "Abuse", "A3A3A3", "You're not on duty in a government faction." ) ;
	}

	string [ 0 ] = EOS ;

	// format ( string, sizeof ( string ), "%s says (radio) %s", ReturnPlayerNameData ( playerid ), text ) ;
	// ProxDetector ( playerid,15.0, 0xA3A3A3FF, string) ;

	SetPlayerChatBubble(playerid, sprintf("(radio) [low] %s", text), 0xFFEC8BFF, 5.0, (strlen(text) * 50) + 2500) ;

	// NEW LOGGING: Log this as a LOG_TYPE_RADIO for sender (playerid)
	AddLogEntry(playerid, LOG_TYPE_RADIO, text);

	return true ;
}

CMD:rl(playerid, params[]) {

	return cmd_radiolow(playerid, params);
}
*/

Scanner_Reset(vehicleid)
{
	VehicleVar[vehicleid][E_VEHICLE_SCANNER_CHANNEL] = 0;
}