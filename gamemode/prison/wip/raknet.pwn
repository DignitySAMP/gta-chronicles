static const PLAYER_SYNC = 207;
static const Float:PRISON_SAFE_X = 1772.1333;
static const Float:PRISON_SAFE_Y = -1547.6040;
static const Float:PRISON_SAFE_Z = 13.2188;



static bool:SentTestMessage[MAX_PLAYERS];

OPacket:PLAYER_SYNC(playerid, BitStream:bs)
{
    if (!SentTestMessage[playerid])
    {
        SendClientMessage(playerid, -1, "TEST: OPacket:PLAYER_SYNC");
        SentTestMessage[playerid] = true;
    }

    // Check if the player the server is sending this packet to is NOT in prison
    if (!PlayerPrisonVar[playerid][E_PLAYER_PRISON_INSIDE])
    {
        new fromplayerid;
		BS_IgnoreBits(bs, 8);
	    BS_ReadUint16(bs, fromplayerid);

        // Then, if the player the server is sending this packet from is IN prison...
        if (PlayerPrisonVar[fromplayerid][E_PLAYER_PRISON_INSIDE])
        {
            // Rewrite the packet so they don't hover in mid-air around the prison and can't be seen
            new onFootData[PR_OnFootSync];

		    BS_ReadOnFootSync(bs, onFootData);
		    BS_SetWriteOffset(bs, 24);

		    onFootData[PR_position][0] = PRISON_SAFE_X;
		    onFootData[PR_position][1] = PRISON_SAFE_Y;
		    onFootData[PR_position][2] = PRISON_SAFE_Z;

	        BS_WriteOnFootSync(bs, onFootData, true);
        }
    }

    return 1;
}