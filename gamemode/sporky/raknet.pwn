// This stops cars randomly respawning via OnVehicleDeath, etc.
// TAKEN FROM RAKNET EXAMPLES PAGE

static VehicleDestroyed = 136;

stock IsVehicleUpsideDown(vehicleid)
{
    new Float:quat_w, Float:quat_x, Float:quat_y, Float:quat_z;
    GetVehicleRotationQuat(vehicleid, quat_w, quat_x, quat_y, quat_z);
    return (
        floatabs(
            atan2(
                2 * (quat_y * quat_z + quat_w * quat_x),
                quat_w * quat_w - quat_x * quat_x - quat_y * quat_y + quat_z * quat_z
            )
        ) > 90.0
    );
}

IRPC:VehicleDestroyed(playerid, BitStream:bs)
{
    new vehicleid;

    BS_ReadUint16(bs, vehicleid);

    if (GetVehicleModel(vehicleid) < 400)
    {
        return 0;
    }

    return OnVehicleRequestDeath(vehicleid, playerid);
}

forward OnVehicleRequestDeath(vehicleid, killerid);
public OnVehicleRequestDeath(vehicleid, killerid)
{
    new Float:health;

    GetVehicleHealth(vehicleid, health);

    if (health >= 250.0 && !IsVehicleUpsideDown(vehicleid))
    {
        return 0;
    }

    return 1;
}

#if !defined IsNaN
    #define IsNaN(%0) ((%0) != (%0))
#endif

const UNOCCUPIED_SYNC = 209;

IPacket:UNOCCUPIED_SYNC(playerid, BitStream:bs)
{
    new unoccupiedData[PR_UnoccupiedSync];
 
    BS_IgnoreBits(bs, 8); // ignore packetid (byte)
    BS_ReadUnoccupiedSync(bs, unoccupiedData);

    if ((
            IsNaN(unoccupiedData[PR_position][0]) ||
            IsNaN(unoccupiedData[PR_position][1]) ||
            IsNaN(unoccupiedData[PR_position][2]) ||
            IsNaN(unoccupiedData[PR_angularVelocity][0]) ||
            IsNaN(unoccupiedData[PR_angularVelocity][1]) ||
            IsNaN(unoccupiedData[PR_angularVelocity][2]) ||
            IsNaN(unoccupiedData[PR_velocity][0]) ||
            IsNaN(unoccupiedData[PR_velocity][1]) ||
            IsNaN(unoccupiedData[PR_velocity][2]) ||
            floatabs(unoccupiedData[PR_position][0]) >= 20000.0 ||
            floatabs(unoccupiedData[PR_position][1]) >= 20000.0 ||
            floatabs(unoccupiedData[PR_position][2]) >= 20000.0 ||
            floatabs(unoccupiedData[PR_angularVelocity][0]) >= 1.0 ||
            floatabs(unoccupiedData[PR_angularVelocity][1]) >= 1.0 ||
            floatabs(unoccupiedData[PR_angularVelocity][2]) >= 1.0 ||
            floatabs(unoccupiedData[PR_velocity][0]) >= 100.0 ||
            floatabs(unoccupiedData[PR_velocity][1]) >= 100.0 ||
            floatabs(unoccupiedData[PR_velocity][2]) >= 100.0
        ) || (
            unoccupiedData[PR_roll][0] * unoccupiedData[PR_direction][0] +
            unoccupiedData[PR_roll][1] * unoccupiedData[PR_direction][1] +
            unoccupiedData[PR_roll][2] * unoccupiedData[PR_direction][2] >= 0.000001
        ) || (
            floatabs(
                1.0 - VectorSize(
                    unoccupiedData[PR_roll][0],
                    unoccupiedData[PR_roll][1],
                    unoccupiedData[PR_roll][2]
                )
            ) >= 0.000001
        ) || (
            floatabs(
                1.0 - VectorSize(
                    unoccupiedData[PR_direction][0],
                    unoccupiedData[PR_direction][1],
                    unoccupiedData[PR_direction][2]
                )
            ) >= 0.000001
        )
    ) {
        return 0; // ignore bad packet
    }

    return 1;
}

const AIM_SYNC = 203;

IPacket:AIM_SYNC(playerid, BitStream:bs)
{
    new aimData[PR_AimSync];
    
    BS_IgnoreBits(bs, 8); // ignore packetid (byte)
    BS_ReadAimSync(bs, aimData);

    if (IsNaN(aimData[PR_aimZ]))
    {
        aimData[PR_aimZ] = 0.0;

        BS_SetWriteOffset(bs, 8);
        BS_WriteAimSync(bs, aimData); // rewrite
    }

    return 1;
}