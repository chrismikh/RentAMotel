local Config = require("modules/config")

local RoomDefinitions = {}

-- Helper function to check if player is within defined room boundaries
function RoomDefinitions.IsPlayerPhysicallyInsideRoom(playerPosition, roomBoundsMin, roomBoundsMax)
    if not playerPosition or not roomBoundsMin or not roomBoundsMax then
        return false
    end

    if type(roomBoundsMin.x) ~= "number" or type(roomBoundsMin.y) ~= "number" or type(roomBoundsMin.z) ~= "number" or
       type(roomBoundsMax.x) ~= "number" or type(roomBoundsMax.y) ~= "number" or type(roomBoundsMax.z) ~= "number" then
        return false
    end

    local isX = playerPosition.x >= roomBoundsMin.x and playerPosition.x <= roomBoundsMax.x
    local isY = playerPosition.y >= roomBoundsMin.y and playerPosition.y <= roomBoundsMax.y
    local isZ = playerPosition.z >= roomBoundsMin.z and playerPosition.z <= roomBoundsMax.z
    
    local result = isX and isY and isZ
    return result
end

-- Room definitions
-- This table contains all the data for the rentable rooms.
RoomDefinitions.ROOM_DEFINITIONS = {
    {
        roomId = "sunset_motel_room_102",
        locKeyRoomName = "RentMotel-Room-Sunset",
        doorHash = 10025113471746604205ULL,
        paymentTerminalHash = 2454332936290437600ULL,
        rentCost = Config.prices.sunset_motel_room_102 or 450,
        roomBoundsMin = { x = 1657.0, y = -796.3, z = 49.5 },
        roomBoundsMax = { x = 1666.6, y = -786.0, z = 52.9 }
    },
    {
        roomId = "kabuki_motel_room_203",
        locKeyRoomName = "RentMotel-Room-Kabuki",
        doorHash = 1867170616709106376ULL,
        backDoorHash = 14602689378209513153ULL,
        paymentTerminalHash = 8068600755530504000ULL,
        rentCost = Config.prices.kabuki_motel_room_203 or 700,
        roomBoundsMin = { x = -1248.5, y = 1969.0, z = 11.7 },
        roomBoundsMax = { x = -1238.0, y = 1982.3, z = 14.8 }
    },
    {
        roomId = "DewdropInn_motel_room_106",
        locKeyRoomName = "RentMotel-Room-Dewdrop",
        doorHash = 7178334462812897738ULL,
        paymentTerminalHash = 4029866856386479600ULL,
        rentCost = Config.prices.DewdropInn_motel_room_106 or 1000,
        roomBoundsMin = { x = -562.80, y = -821.5, z = 8.0 },
        roomBoundsMax = { x = -554.1, y = -812.1, z = 11.2 },
    },
    {
        roomId = "NoTell_motel_room_206",
        locKeyRoomName = "RentMotel-Room-NoTell",
        doorHash = 7494599788290938000ULL,
        paymentTerminalHash = 7352168567788151353ULL,
        rentCost = Config.prices.NoTell_motel_room_206 or 700,
        roomBoundsMin = { x = -1139.0, y = 1307.185,  z = 27.9 },
        roomBoundsMax = { x = -1127.6685, y = 1319.1003, z = 31.0 }
    }
}

-- Pre-computed lookup table for O(1) room definition access
RoomDefinitions.ROOM_DEFINITIONS_BY_ID = {}
for _, roomDef in ipairs(RoomDefinitions.ROOM_DEFINITIONS) do
    RoomDefinitions.ROOM_DEFINITIONS_BY_ID[roomDef.roomId] = roomDef
end

return RoomDefinitions
