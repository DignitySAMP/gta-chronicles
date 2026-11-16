// this is pretty basic but should help a little. could expand on it in the future when i learn more abt how to use this.

forward MyHttpResponse(playerid, response_code, data[]);

CMD:checkvpn(playerid, params[]){

	if(GetPlayerAdminLevel(playerid) < ADMIN_LVL_GENERAL) {

		SendServerMessage( playerid, COLOR_ERROR, "Error", "A3A3A3", "You don't have access to this command." ) ;
		return true;
	}

	new string[64], ip[32];

	if(sscanf(params, "s[32]", ip)) {
		SendServerMessage( playerid, COLOR_ERROR, "Syntax", "A3A3A3", "/checkvpn [ip-address]" ) ;
		SendServerMessage( playerid, COLOR_ERROR, "Warning", "A3A3A3", "This is an experimental feature. If you find someone with a VPN, you should double-check it." ) ;
		SendServerMessage( playerid, COLOR_ERROR, "Warning", "A3A3A3", "Please report accuracy results to the development team." ) ;
		return true;
	}

	if(!IsValidIP(ip))
		return SendServerMessage( playerid, COLOR_ERROR, "Warning", "A3A3A3", "This isn't a valid IPv4 format. Are you writing it correctly?" ) ;

	format(string, sizeof(string), "blackbox.ipinfo.app/lookup/%s", ip);

	SendServerMessage( playerid, COLOR_SECURITY, "VPN", "FFFFFF", "Getting results..." ) ;
	HTTP(playerid, HTTP_GET, string, "", "MyHttpResponse");

	return true;
}

public MyHttpResponse(playerid, response_code, data[]) {

	if(response_code == 200) {	
		if(data[0] == 'Y'){
			// found vpn
			SendServerMessage( playerid, COLOR_RED, "VPN DETECTED", "A3A3A3", "Detected a VPN on this IP! Make sure to double-check." ) ;

		} else if(data[0] == 'N') {
			// no vpn
			SendServerMessage( playerid, COLOR_GREEN, "NO VPN DETECTED", "A3A3A3", "This IP doesn't seem to belong to a VPN." ) ;

		} else if(data[0] == 'E') {
			// bad ip
			SendServerMessage( playerid, COLOR_SECURITY, "VPN", "A3A3A3", "Something went wrong, the IP address might be bad." ) ;
		}
		else
		{
			// failed request
			SendServerMessage( playerid, COLOR_SECURITY, "VPN", "A3A3A3", "Your request failed, try again later or contact a developer." ) ;
		}
	} else {
		SendServerMessage( playerid, COLOR_SECURITY, "VPN", "A3A3A3", sprintf("Request wasn't sucessful (response code %d). Contact a dev.", response_code)) ;
	}

	return true;
}

stock IsValidIP(const ip[])
{
  static Regex:regex;
  if (!regex) regex = Regex_New("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$");

  return Regex_Check(ip, regex);
}

