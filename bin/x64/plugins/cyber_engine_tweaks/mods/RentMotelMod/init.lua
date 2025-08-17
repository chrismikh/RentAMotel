local Cron = require("modules/Cron")
local GameSession = require("modules/GameSession")
local interactionUI = require("modules/interactionUI")

-- Hallway Door Configuration
local HALLWAY_DOOR_HASH = 10866749775532408022ULL
local hallwayDoorEntityID = nil
local isHallwayDoorInteractionActive = false
local isPlayerNearHallwayDoor = false
local lastKnownHallwayDoorOpen = false

-- Helper function to create Vector4 from a table
function ToVector4(tbl)
    return Vector4.new(tbl.x, tbl.y, tbl.z, tbl.w or 1.0)
end

-- Localization helper (Codeware texts are registered in native localization system)
function L(key, vars)
    local text = key
    local ok, result = pcall(function()
        if GetLocalizedTextByKey then
            return GetLocalizedTextByKey(CName.new(key))
        elseif Game and Game.GetLocalizedTextByKey then
            return Game.GetLocalizedTextByKey(CName.new(key))
        end
        return key
    end)
    if ok and type(result) == "string" and #result > 0 then
        text = result
    end
    if vars and type(vars) == "table" then
        for k, v in pairs(vars) do
            text = text:gsub("{" .. k .. "}", tostring(v))
        end
    end
    return text
end

-- Helper function to calculate 3D distance between two Vector4 points
function GetDistance3D(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end -- Return a large number if one of the positions is nil
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Helper function to check if player is within defined room boundaries
function IsPlayerPhysicallyInsideRoom(playerPosition, roomBoundsMin, roomBoundsMax)
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
local ROOM_DEFINITIONS = {
    {
        roomId = "sunset_motel_room_102",
        name = "Sunset Motel Room",
        locKeyRoomName = "RentMotel-Room-Sunset",
        doorHash = 10025113471746604205ULL,
        rentCost = 250,
        location = "Sunset Motel",
        roomBoundsMin = { x = 1657.0, y = -796.3, z = 49.5 },
        roomBoundsMax = { x = 1666.6, y = -785.2, z = 52.9 }
    },
    {
        roomId = "kabuki_motel_room_203",
        name = "Kabuki Motel Room",
        locKeyRoomName = "RentMotel-Room-Kabuki",
        doorHash = 1867170616709106376ULL,
        backDoorHash = 14602689378209513153ULL,
        rentCost = 500,
        location = "Kabuki Motel",
        roomBoundsMin = { x = -1247.9869, y = 1970.6674, z = 11.7 },
        roomBoundsMax = { x = -1243.4186, y = 1983.5032, z = 14.8 }
    },
    {
        roomId = "DewdropInn_motel_room_106",
        name = "Dewdrop Inn Motel Room",
        locKeyRoomName = "RentMotel-Room-Dewdrop",
        doorHash = 7178334462812897738ULL,
        rentCost = 800,
        location = "Dewdrop Inn Motel",
        roomBoundsMin = { x = -564.5563, y = -821.5, z = 8.0 },
        roomBoundsMax = { x = -554.1, y = -812.1, z = 11.2 }
    },
    {
        roomId = "NoTell_motel_room_204",
        name = "No Tell Motel Room",
        locKeyRoomName = "RentMotel-Room-NoTell",
        doorHash = 14087530378419798291ULL,
        rentCost = 400,
        location = "No Tell Motel",
        roomBoundsMin = { x = -1136.5, y = 1321.9, z = 27.9 },
	    roomBoundsMax = { x = -1126.0, y = 1333.3, z = 31.0 }
    }
}

-- Main table for managing the state of rentable motel rooms.
RentMotelManager = {
    ready = false,
    sessionKey = 0,
    rooms = {}, 
    isInitialLoad = true,
    lastLoadedSessionKey = nil,
    activeInteractionRoomId = nil, 
    hasRestoredData = false, 
    serializableForPersistence = {}, 
    heistCompleted = false
}

-- Populates the RentMotelManager.rooms table with initial data for each room
function RentMotelManager.initializeRooms()
    RentMotelManager.rooms = {}
    for _, roomDef in ipairs(ROOM_DEFINITIONS) do
        RentMotelManager.rooms[roomDef.roomId] = {
            roomId = roomDef.roomId,
            name = roomDef.name,
            locKeyRoomName = roomDef.locKeyRoomName,
            doorID = EntityID.new({ hash = roomDef.doorHash }),
            doorHash = roomDef.doorHash,
            config = {
                doorLockedByDefault = true,
                isDoorLocked = true,
                rentCost = roomDef.rentCost,
                doorUnlockExpirySeconds = nil,
                overstayFeeCharged = false,
                wasPhysicallyInsideRoomAtExpiry = false,
                physicalInsideCheckDoneAtExpiry = false
            },
            interactionActive = false,
            playerNearDoor = false,
            doorSynced = false,
            lastKnownDoorOpen = false
        }

        -- If a secondary door (backDoorHash) is defined, schedule it to be permanently locked.
        if roomDef.backDoorHash then
            RentMotelManager.rooms[roomDef.roomId].backDoorToLockHash = roomDef.backDoorHash
        end
    end
end

-- Schedules a delayed attempt to permanently lock a specified back door.
-- This is used for secondary doors that should not be interactable.
function RentMotelManager.ScheduleBackDoorLock(doorHash)
    if not doorHash then return end
    Cron.After(5.0, function()
        local doorEntityID = EntityID.new({ hash = doorHash })
        RentMotelManager.EnsureDoorPermanentlyLocked(doorEntityID)
    end)
end

-- Attempts to find a door by its entity ID and permanently lock and seal it.
function RentMotelManager.EnsureDoorPermanentlyLocked(doorEntityID)
    if not doorEntityID then 
        return 
    end

    local door = Game.FindEntityByID(doorEntityID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            door:CloseDoor()
            
            Cron.After(0.1, function()
                if not ps:IsSealed() then
                    ps:ToggleSealOnDoor()
                end
                if not ps:IsLocked() then
                    ps:ToggleLockOnDoor()
                end
            end)
        end
    end
end

-- Creates a simplified, serializable representation of the current state of all rooms.
-- This data is intended for persistence via the GameSession module.
function RentMotelManager.getSerializableRooms()
    local serializableRooms = {}
    for roomId, room in pairs(RentMotelManager.rooms) do
        serializableRooms[roomId] = {
            roomId = room.roomId,
            name = room.name,
            doorHash = room.doorHash,
            config = room.config,
        }
    end
    return serializableRooms
end

-- Helper function to get room definition by ID
local function getRoomDefinitionById(roomId)
    for _, roomDef in ipairs(ROOM_DEFINITIONS) do
        if roomDef.roomId == roomId then
            return roomDef
        end
    end
    return nil
end

-- Restores the state of rooms from previously serialized data.
-- This function also handles updating rent costs for rooms if the saved rent cost differs from the current definition in ROOM_DEFINITIONS
function RentMotelManager.restoreRoomsFromSerialized(serializedRooms)
    if not serializedRooms then 
        return 
    end
    
    for roomId, serializedRoom in pairs(serializedRooms) do
        if RentMotelManager.rooms[roomId] then -- Check if the room still exists in current definitions
            
            local currentRoomDef = getRoomDefinitionById(roomId)
            if not currentRoomDef then
            elseif serializedRoom.config and serializedRoom.config.rentCost ~= nil and currentRoomDef.rentCost ~= nil then
                if serializedRoom.config.rentCost ~= currentRoomDef.rentCost then
                    serializedRoom.config.rentCost = currentRoomDef.rentCost -- Update the cost in the data to be restored
                end
            end

            -- Restore all config values from the (potentially updated) serializedRoom.config
            if serializedRoom.config then
                for k, v in pairs(serializedRoom.config) do
                    RentMotelManager.rooms[roomId].config[k] = v
                end
            end
        end
    end
    RentMotelManager.hasRestoredData = true
end

-- Get room by ID helper
function RentMotelManager.getRoom(roomId)
    return RentMotelManager.rooms[roomId]
end

-- Resets all managed rooms to default states (locked, no expiry). Runs on initial load if no saved data exists.
function RentMotelManager.resetRoomsToDefault()
    if RentMotelManager.hasRestoredData then
        return
    end
    
    for roomId, room in pairs(RentMotelManager.rooms) do
        room.config.isDoorLocked = room.config.doorLockedByDefault
        room.config.doorUnlockExpirySeconds = nil
        room.doorSynced = false
        room.interactionActive = false
        room.playerNearDoor = false
    end
end

-- Door control functions

-- Updates room interaction state (marks inactive, checks player proximity)
local function interactionUpdateCallback(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    room.interactionActive = false
    room.playerNearDoor = false
    
    -- Check if player is near and show interaction
    local player = Game.GetPlayer()
    local freshDoor = Game.FindEntityByID(room.doorID)
    if player and freshDoor then
        local playerPos = player:GetWorldPosition()
        local doorPos = freshDoor:GetWorldPosition()
        local dx = playerPos.x - doorPos.x
        local dy = playerPos.y - doorPos.y
        local dz = playerPos.z - doorPos.z
        local distanceSquared = dx * dx + dy * dy + dz * dz
        
        if distanceSquared < 4.0 then
            room.playerNearDoor = true
            RentMotelManager.showInteraction(roomId)
        end
    end
end

-- Callback for final door locking
-- Seals door, saves session, updates UI
local function doorLockDelayCallback(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    local freshDoor = Game.FindEntityByID(room.doorID)
    if freshDoor then
        local freshPs = freshDoor:GetDevicePS()
        if freshPs then
            if not freshPs:IsSealed() then
                freshPs:ToggleSealOnDoor()
            end
            
            if not freshPs:IsLocked() then
                freshPs:ToggleLockOnDoor()
            end
            
            GameSession.TrySave()
            
            Cron.After(0.2, function()
                interactionUpdateCallback(roomId)
            end)
        end
    end
end

-- Locks room door, updates config, schedules final seal
function LockDoor(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    local door = Game.FindEntityByID(room.doorID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            room.config.isDoorLocked = true
            room.config.doorUnlockExpirySeconds = nil
            room.lastKnownDoorOpen = false
            
            door:CloseDoor()
            
            Cron.After(0.5, function()
                doorLockDelayCallback(roomId)
            end)
        end
    end
end

-- Unlocks room if player can pay rent, sets expiry, opens door
function UnlockDoor(roomId, durationInHours, costToCharge)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    local player = Game.GetPlayer()
    local door = Game.FindEntityByID(room.doorID)
    local ts = Game.GetTransactionSystem()
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())
    
    if door and player then
        local ps = door:GetDevicePS()
        if ps then
            local doorLocked = ps:IsLocked()
            
            -- Check if door should be unlockable (either physically locked or config says it's locked)
            if doorLocked or room.config.isDoorLocked then
                if playerMoney < costToCharge then
                    -- Not enough money for the chosen option
                    return
                end

                local success = ts:RemoveMoney(player, costToCharge, "money")
                if success then
                    -- Unseal the door first (if it's sealed)
                    if ps:IsSealed() then
                        ps:ToggleSealOnDoor()
                    end
                    
                    -- Then unlock it (if it's locked)
                    if ps:IsLocked() then
                        ps:ToggleLockOnDoor()
                    end
                    
                    room.config.isDoorLocked = false
                    local now = Game.GetTimeSystem():GetGameTime()
                    room.config.doorUnlockExpirySeconds = now:GetSeconds() + (durationInHours * 60 * 60)
                    room.config.overstayFeeCharged = false
                    room.config.wasPhysicallyInsideRoomAtExpiry = false
                    room.config.physicalInsideCheckDoneAtExpiry = false
                    GameSession.TrySave()
                    
                    -- Automatically open the door with a small delay
                    Cron.After(0.2, function()
                        door:OpenDoor()
                    end)
                    
                    RentMotelManager.hideInteraction(roomId)
                    -- If this is the No Tell Motel room, immediately present the door control hub
                    if roomId == "NoTell_motel_room_204" then
                        room.lastKnownDoorOpen = true
                        Cron.After(0.35, function()
                            RentMotelManager.showInteraction(roomId)
                        end)
                    end
                end
            end
        end
    end
end

-- Syncs physical door state with config (lock/seal status)
function SyncDoorStateWithSavedState(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    if not RentMotelManager.sessionKey or RentMotelManager.sessionKey == 0 then
        return
    end
    
    local door = Game.FindEntityByID(room.doorID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            local current = ps:IsLocked()
            
            if current ~= room.config.isDoorLocked then
                if room.config.isDoorLocked then
                    door:CloseDoor()
                    Cron.After(0.5, function()
                        if not ps:IsSealed() then
                            ps:ToggleSealOnDoor()
                        end
                        if not ps:IsLocked() then
                            ps:ToggleLockOnDoor()
                        end
                    end)
                else
                    if ps:IsSealed() then
                        ps:ToggleSealOnDoor()
                    end
                    if ps:IsLocked() then
                        ps:ToggleLockOnDoor()
                    end
                    door:OpenDoor()
                end
            else
                if room.config.isDoorLocked then
                    if not ps:IsSealed() then
                        ps:ToggleSealOnDoor()
                    end
                else
                    if ps:IsSealed() then
                        ps:ToggleSealOnDoor()
                    end
                end
            end
        end
    end
end

-- Gets physical door lock state (does not modify config)
function UpdateConfigFromDoorState(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    local door = Game.FindEntityByID(room.doorID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            -- Only update config if it doesn't match intended state
            local actualDoorState = ps:IsLocked()
            if room.config.isDoorLocked ~= actualDoorState then
                -- Don't automatically update config here - let the intended state persist
            end
        end
    end
end

-- Creates room interaction hub based on lock state/funds
function RentMotelManager.createInteractionHub(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return nil end
    
    local choices = {}
    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())

    local rentCost1Day = room.config.rentCost
    local rentCost7Days = math.floor(rentCost1Day * 7 * 0.9) -- 10% discount per day for 7 days (total 6.3 * daily rate)

    -- Gate No Tell Motel until "The Heist" is completed
    if roomId == "NoTell_motel_room_204" and not RentMotelManager.heistCompleted and room.config.isDoorLocked then
        return nil
    end

    if room.config.isDoorLocked then
        -- Option 1: 24 hours
        if playerMoney >= rentCost1Day then
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-24h", { price = rentCost1Day }), nil, gameinteractionsChoiceType.QuestImportant))
        else
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-24h-NoMoney", { price = rentCost1Day }), nil, gameinteractionsChoiceType.Disabled))
        end

        -- Option 2: 7 days
        if playerMoney >= rentCost7Days then
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-7d", { price = rentCost7Days }), nil, gameinteractionsChoiceType.QuestImportant))
        else
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-7d-NoMoney", { price = rentCost7Days }), nil, gameinteractionsChoiceType.Disabled))
        end
    end

    local hubTitle = room.locKeyRoomName and L(room.locKeyRoomName) or room.name
    return interactionUI.createHub(hubTitle, choices, gameinteractionsvisEVisualizerActivityState.Active)
end

-- Creates a simple door control interaction hub (Open/Close) for unlocked rooms
function RentMotelManager.createDoorControlHub(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return nil end

    local choices = {}
    -- Gate No Tell Motel door controls until "The Heist" is completed
    if roomId == "NoTell_motel_room_204" and not RentMotelManager.heistCompleted then
        return nil
    end

    if room.lastKnownDoorOpen then
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-CloseDoor"), nil, gameinteractionsChoiceType.Default))
    else
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-OpenDoor"), nil, gameinteractionsChoiceType.Default))
    end

    local hubTitle = room.locKeyRoomName and L(room.locKeyRoomName) or room.name
    return interactionUI.createHub(hubTitle, choices, gameinteractionsvisEVisualizerActivityState.Active)
end

-- Configures interaction callbacks
function RentMotelManager.setupInteractionCallbacks(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    interactionUI.clearCallbacks()

    -- Prevent renting No Tell Motel until "The Heist" is completed
    if roomId == "NoTell_motel_room_204" and room.config.isDoorLocked and not RentMotelManager.heistCompleted then
        return
    end

    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())

    local rentCost1Day = room.config.rentCost
    local rentCost7Days = math.floor(rentCost1Day * 7 * 0.9)

    if room.config.isDoorLocked then
        -- Callback for 24-hour rental (Choice 1)
        if playerMoney >= rentCost1Day then
            interactionUI.registerChoiceCallback(1, function()
                UnlockDoor(roomId, 24, rentCost1Day) -- durationInHours = 24, costToCharge = rentCost1Day
                RentMotelManager.hideInteraction(roomId)
            end)
        end

        -- Callback for 7-day rental (Choice 2)
        if playerMoney >= rentCost7Days then
            interactionUI.registerChoiceCallback(2, function()
                UnlockDoor(roomId, 7 * 24, rentCost7Days) -- durationInHours = 168, costToCharge = rentCost7Days
                RentMotelManager.hideInteraction(roomId)
            end)
        end
    else
        -- Door control callbacks for unlocked No Tell Motel room only
        if roomId == "NoTell_motel_room_204" then
            if room.lastKnownDoorOpen then
                -- Only one choice visible: Close door (index 1)
                interactionUI.registerChoiceCallback(1, function()
                    local door = Game.FindEntityByID(room.doorID)
                    if door then
                        door:CloseDoor()
                        room.lastKnownDoorOpen = false
                        RentMotelManager.updateInteractionHub(roomId)
                    end
                end)
            else
                -- Only one choice visible: Open door (index 1)
                interactionUI.registerChoiceCallback(1, function()
                    local door = Game.FindEntityByID(room.doorID)
                    if door then
                        local ps = door:GetDevicePS()
                        if ps then
                            if ps:IsSealed() then ps:ToggleSealOnDoor() end
                            if ps:IsLocked() then ps:ToggleLockOnDoor() end
                        end
                        Cron.After(0.1, function()
                            door:OpenDoor()
                        end)
                        room.lastKnownDoorOpen = true
                        Cron.After(0.15, function()
                            RentMotelManager.updateInteractionHub(roomId)
                        end)
                    end
                end)
            end
        end
    end
end

-- Updates and shows interaction hub if active
function RentMotelManager.updateInteractionHub(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    -- Do not show or update any interaction for No Tell until The Heist is completed
    if roomId == "NoTell_motel_room_204" and not RentMotelManager.heistCompleted then
        if room.interactionActive then
            RentMotelManager.hideInteraction(roomId)
        end
        return
    end
    
    if room.interactionActive then
        local hub = nil
        if room.config.isDoorLocked then
            hub = RentMotelManager.createInteractionHub(roomId)
        elseif roomId == "NoTell_motel_room_204" then
            hub = RentMotelManager.createDoorControlHub(roomId)
        end
        if hub then
            interactionUI.setupHub(hub)
            RentMotelManager.setupInteractionCallbacks(roomId)
            interactionUI.showHub()
        end
    end
end

-- Shows room interaction hub when near door (single hub only)
function RentMotelManager.showInteraction(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    -- If No Tell and The Heist isn't completed, do not show any interaction
    if roomId == "NoTell_motel_room_204" and not RentMotelManager.heistCompleted then
        if room.interactionActive then
            RentMotelManager.hideInteraction(roomId)
        end
        return
    end

    -- Do not show rent UI if the player is physically inside the same room bounds (applies to locked rooms)
    if room.config.isDoorLocked then
        local player = Game.GetPlayer()
        local playerPos = player and player:GetWorldPosition()
        local roomDef = getRoomDefinitionById(roomId)
        if playerPos and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
            if IsPlayerPhysicallyInsideRoom(playerPos, roomDef.roomBoundsMin, roomDef.roomBoundsMax) then
                if room.interactionActive then
                    RentMotelManager.hideInteraction(roomId)
                end
                return
            end
        end
    end

    if not room.config.isDoorLocked then
        -- By default, do not show a hub when unlocked, except for the No Tell Motel
        if roomId ~= "NoTell_motel_room_204" then
            if room.interactionActive then
                RentMotelManager.hideInteraction(roomId)
            end
            return
        end
    end

    -- Hide any other active interactions first
    if RentMotelManager.activeInteractionRoomId and RentMotelManager.activeInteractionRoomId ~= roomId then
        RentMotelManager.hideInteraction(RentMotelManager.activeInteractionRoomId)
    end

    if not room.interactionActive then
        room.interactionActive = true
        RentMotelManager.activeInteractionRoomId = roomId
        local hub = nil
        if room.config.isDoorLocked then
            hub = RentMotelManager.createInteractionHub(roomId)
        elseif roomId == "NoTell_motel_room_204" then
            hub = RentMotelManager.createDoorControlHub(roomId)
        end
        if hub then
            interactionUI.setupHub(hub)
            RentMotelManager.setupInteractionCallbacks(roomId)
            interactionUI.showHub()
        end
    end
end

-- Hides the currently active interaction hub for a specified room.
function RentMotelManager.hideInteraction(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    if room.interactionActive then
        room.interactionActive = false
        if RentMotelManager.activeInteractionRoomId == roomId then
            RentMotelManager.activeInteractionRoomId = nil
        end
        interactionUI.hideHub()
    end
end

-- Simple Hallway Door Interaction Functions
function OpenHallwayDoor()
    if not hallwayDoorEntityID then return end
    local door = Game.FindEntityByID(hallwayDoorEntityID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            if ps:IsSealed() then
                ps:ToggleSealOnDoor()
                Cron.After(0.1, function()
                    if ps:IsLocked() then
                        ps:ToggleLockOnDoor()
                    end
                    door:OpenDoor()
                    lastKnownHallwayDoorOpen = true
                    Cron.After(0.1, function()
                        UpdateHallwayDoorInteraction()
                    end)
                end)
                return
            end
            if ps:IsLocked() then
                ps:ToggleLockOnDoor()
                Cron.After(0.1, function()
                    door:OpenDoor()
                    lastKnownHallwayDoorOpen = true
                    Cron.After(0.1, function()
                        UpdateHallwayDoorInteraction()
                    end)
                end)
                return
            end
        end
        door:OpenDoor()
        lastKnownHallwayDoorOpen = true
        Cron.After(0.1, function()
            UpdateHallwayDoorInteraction()
        end)
    end
end

function CloseHallwayDoor()
    if not hallwayDoorEntityID then return end
    local door = Game.FindEntityByID(hallwayDoorEntityID)
    if door then
        door:CloseDoor()
        lastKnownHallwayDoorOpen = false
        Cron.After(0.05, function()
            UpdateHallwayDoorInteraction()
        end)
    end
end

function UpdateHallwayDoorInteraction()
    if not isHallwayDoorInteractionActive then return end
    interactionUI.clearCallbacks()
    local choices = {}
    if lastKnownHallwayDoorOpen then
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-CloseDoor"), nil, gameinteractionsChoiceType.Default))
    else
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-OpenDoor"), nil, gameinteractionsChoiceType.Default))
    end
    local hub = interactionUI.createHub(L("RentMotel-UI-HallwayDoor"), choices, gameinteractionsvisEVisualizerActivityState.Active)
    if hub then
        interactionUI.setupHub(hub)
        interactionUI.registerChoiceCallback(1, function()
            if lastKnownHallwayDoorOpen then
                CloseHallwayDoor()
            else
                OpenHallwayDoor()
            end
        end)
        interactionUI.showHub()
    end
end

function ShowHallwayDoorInteraction()
    if isHallwayDoorInteractionActive or (RentMotelManager and RentMotelManager.activeInteractionRoomId) then 
        return 
    end

    interactionUI.clearCallbacks()

    local choices = {}
    if lastKnownHallwayDoorOpen then
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-CloseDoor"), nil, gameinteractionsChoiceType.Default))
    else
        table.insert(choices, interactionUI.createChoice(L("RentMotel-UI-OpenDoor"), nil, gameinteractionsChoiceType.Default))
    end
    
    local hub = interactionUI.createHub(L("RentMotel-UI-HallwayDoor"), choices, gameinteractionsvisEVisualizerActivityState.Active)
    if hub then
        interactionUI.setupHub(hub)
        interactionUI.registerChoiceCallback(1, function()
            if lastKnownHallwayDoorOpen then
                CloseHallwayDoor()
            else
                OpenHallwayDoor()
            end
        end)
        interactionUI.showHub()
        isHallwayDoorInteractionActive = true
    end
end

function HideHallwayDoorInteraction()
    if isHallwayDoorInteractionActive then
        interactionUI.hideHub()
        interactionUI.clearCallbacks()
        isHallwayDoorInteractionActive = false
    end
end

-- Checks player proximity to all room doors
-- Manages interaction UI visibility and initial sync
function RentMotelManager.checkPlayerProximity()
    if not RentMotelManager.ready then 
        return 
    end
    
    local player = Game.GetPlayer()
    if not player then 
        return 
    end
    
    local playerPos = player:GetWorldPosition()
    
    -- Check each room
    for roomId, room in pairs(RentMotelManager.rooms) do
        local door = Game.FindEntityByID(room.doorID)
        if door then
            -- If this is the first time we've found the door after loading, sync it
            if not room.doorSynced then
                SyncDoorStateWithSavedState(roomId)
                room.doorSynced = true
            end
            
            local doorPos = door:GetWorldPosition()
            
            -- Distance calculation
            local dx = playerPos.x - doorPos.x
            local dy = playerPos.y - doorPos.y
            local dz = playerPos.z - doorPos.z
            local distanceSquared = dx * dx + dy * dy + dz * dz
            local interactionRangeSquared = 4.0 -- 2.0 squared
            
            -- Check if player is within interaction range
            local wasNearDoor = room.playerNearDoor
            room.playerNearDoor = distanceSquared < interactionRangeSquared

            -- Suppress rent UI if player is physically inside this room while it's locked
            local suppressRentUI = false
            if room.config.isDoorLocked then
                local roomDef = getRoomDefinitionById(roomId)
                if roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                    suppressRentUI = IsPlayerPhysicallyInsideRoom(playerPos, roomDef.roomBoundsMin, roomDef.roomBoundsMax)
                end
            end

            if room.playerNearDoor and not wasNearDoor then
                if not suppressRentUI then
                    RentMotelManager.showInteraction(roomId)
                end
            elseif wasNearDoor and not room.playerNearDoor then
                RentMotelManager.hideInteraction(roomId)
            elseif suppressRentUI and room.interactionActive then
                -- If inside while a rent interaction is active for this room, hide it
                RentMotelManager.hideInteraction(roomId)
            end
        end
    end

    -- Now, check for the hallway door, but only if no room interaction is active
    if not RentMotelManager.activeInteractionRoomId and hallwayDoorEntityID then
        local player = Game.GetPlayer()
        if not player then return end
        local playerPos = player:GetWorldPosition()

        local hallwayDoorEntity = Game.FindEntityByID(hallwayDoorEntityID)
        if hallwayDoorEntity then
            local hallwayDoorPos = hallwayDoorEntity:GetWorldPosition()
            local dx_hall = playerPos.x - hallwayDoorPos.x
            local dy_hall = playerPos.y - hallwayDoorPos.y
            local dz_hall = playerPos.z - hallwayDoorPos.z
            local distanceSquared_hall = dx_hall * dx_hall + dy_hall * dy_hall + dz_hall * dz_hall
            local interactionRangeSquared_hallway = 4.0 -- 2.0 squared

            local previouslyNearHallway = isPlayerNearHallwayDoor
            isPlayerNearHallwayDoor = distanceSquared_hall < interactionRangeSquared_hallway

            if isPlayerNearHallwayDoor and not previouslyNearHallway then
                ShowHallwayDoorInteraction()
            elseif previouslyNearHallway and not isPlayerNearHallwayDoor and isHallwayDoorInteractionActive then
                HideHallwayDoorInteraction()
            end
        else
            if isHallwayDoorInteractionActive then
                HideHallwayDoorInteraction()
            end
        end
    elseif isHallwayDoorInteractionActive and RentMotelManager.activeInteractionRoomId then 
        -- If a room interaction became active WHILE the hallway door one was active, hide the hallway door one.
        HideHallwayDoorInteraction()
    elseif isHallwayDoorInteractionActive and not isPlayerNearHallwayDoor then
        -- If player moved away from hallway door while its interaction was active (and no room interaction took over)
        HideHallwayDoorInteraction()
    end
end

-- Main mod initialization - handles room states, UI, and persistence
-- Handles save/load and session events
registerForEvent("onInit", function()
    RentMotelManager.initializeRooms()
    interactionUI.init()

    GameSession.IdentifyAs("RentMotel_session_key")
    GameSession.StoreInDir("sessions")

    -- Initialize Hallway Door Entity ID
    if HALLWAY_DOOR_HASH then
        hallwayDoorEntityID = EntityID.new({ hash = HALLWAY_DOOR_HASH })
    end

    -- Check Heist completion once after the player puppet attaches
    ObserveAfter('PlayerPuppet', 'OnGameAttached', function()
        -- Check heist status once on initialization
        local heistQuestFact = Game.GetQuestsSystem():GetFactStr("q005_done")
        if heistQuestFact == 1 then
            RentMotelManager.heistCompleted = true
            --print("[RentMotelMod] Heist mission is completed. No tell motel will be available.")
        else
            --print("[RentMotelMod] Heist mission not completed. No tell motel will be unavailable.")
        end
    end)

    -- Initialize persistent data store
    local initialSerializableData = RentMotelManager.getSerializableRooms()
    for k, v in pairs(initialSerializableData) do RentMotelManager.serializableForPersistence[k] = v end
    
    -- Establish persistent data container (called once)
    GameSession.Persist(RentMotelManager.serializableForPersistence) 
    
    -- New game session handler
    GameSession.OnStart(function(state)
        RentMotelManager.ready = true 
        RentMotelManager.sessionKey = state.sessionKey or GameSession.GetKey()
        
        -- Process any pending door locks
        if RentMotelManager.ready then 
            for roomId, roomData in pairs(RentMotelManager.rooms) do
                if roomData.backDoorToLockHash then
                    RentMotelManager.ScheduleBackDoorLock(roomData.backDoorToLockHash)
                    roomData.backDoorToLockHash = nil 
                end
            end
        end

        -- First-time setup if no saved data
        if RentMotelManager.isInitialLoad then
            RentMotelManager.resetRoomsToDefault()
            Cron.After(1.5, function()
                RentMotelManager.checkPlayerProximity()
            end)
        end
    end)

    -- Session cleanup handler
    GameSession.OnEnd(function()
        RentMotelManager.ready = false
        RentMotelManager.isInitialLoad = true
        RentMotelManager.hasRestoredData = false 
        
        -- Reset room tracking states
        for _, room in pairs(RentMotelManager.rooms) do
            room.doorSynced = false
        end
        
        -- Clear active UI
        if RentMotelManager.activeInteractionRoomId then
            RentMotelManager.hideInteraction(RentMotelManager.activeInteractionRoomId)
        end

        -- Reset persistence container
        for k in pairs(RentMotelManager.serializableForPersistence) do
            RentMotelManager.serializableForPersistence[k] = nil
        end
    end)

    -- Save data loader
    GameSession.OnLoad(function(state)
        RentMotelManager.hasRestoredData = false
        
        -- Reset then restore room states
        RentMotelManager.initializeRooms()
        RentMotelManager.restoreRoomsFromSerialized(RentMotelManager.serializableForPersistence)
        
        -- Mark doors for resync
        for _, room in pairs(RentMotelManager.rooms) do
            room.doorSynced = false
        end
    end)

    -- Pre-save handler
    GameSession.OnSave(function(state)
        local ts = state.timestamp or 0
        local key = state.sessionKey or 0
        if RentMotelManager.sessionKey == 0 and key ~= 0 then
            RentMotelManager.sessionKey = key
        end
        
        -- Update all door states
        for roomId, _ in pairs(RentMotelManager.rooms) do
            UpdateConfigFromDoorState(roomId)
        end
        
        -- Refresh persistence data
        local currentSerializableRooms = RentMotelManager.getSerializableRooms()
        for k in pairs(RentMotelManager.serializableForPersistence) do
            RentMotelManager.serializableForPersistence[k] = nil
        end
        for k, v in pairs(currentSerializableRooms) do
            RentMotelManager.serializableForPersistence[k] = v
        end
    end)

    -- Save system observers
    Observe('LoadListItem', 'SetMetadata', function(_, saveInfo) end)
    Observe('LoadGameMenuGameController', 'LoadSaveInGame', function(_, saveIndex) end)
end)

-- Final cleanup on shutdown - saves data and hides UI
registerForEvent("onShutdown", function()
    GameSession.TrySave()
    if RentMotelManager.activeInteractionRoomId then
        RentMotelManager.hideInteraction(RentMotelManager.activeInteractionRoomId)
    end
end)

-- Main game loop - handles cron jobs, UI updates, proximity checks, and rent expiry
registerForEvent("onUpdate", function(delta)
    Cron.Update(delta)
    interactionUI.update()
    RentMotelManager.checkPlayerProximity()

    -- Check all rooms for rent expiry
    for roomId, room in pairs(RentMotelManager.rooms) do
        if not room.config.isDoorLocked and room.config.doorUnlockExpirySeconds then
            local now = Game.GetTimeSystem():GetGameTime()

            -- Handle expired rent period
            if now:GetSeconds() >= room.config.doorUnlockExpirySeconds then
                --print("[RentMotelMod] Rent expired for room: " .. roomId .. ". Current time: " .. now:GetSeconds() .. ", Expiry time: " .. room.config.doorUnlockExpirySeconds)
                local player = Game.GetPlayer()
                local playerPosition = player and player:GetWorldPosition()
                local roomDef = getRoomDefinitionById(roomId)
                --print("[RentMotelMod] Player position: " .. (playerPosition and (playerPosition.x .. "," .. playerPosition.y .. "," .. playerPosition.z) or "nil"))
                if roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                    --print("[RentMotelMod] " .. roomId .. " BoundsMin: " .. roomDef.roomBoundsMin.x .. "," .. roomDef.roomBoundsMin.y .. "," .. roomDef.roomBoundsMin.z)
                    --print("[RentMotelMod] " .. roomId .. " BoundsMax: " .. roomDef.roomBoundsMax.x .. "," .. roomDef.roomBoundsMax.y .. "," .. roomDef.roomBoundsMax.z)
                end

                -- First-time physical position check at expiry
                if not room.config.physicalInsideCheckDoneAtExpiry then
                    local wasPhysicallyInside = false
                    if playerPosition and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                        wasPhysicallyInside = IsPlayerPhysicallyInsideRoom(playerPosition, roomDef.roomBoundsMin, roomDef.roomBoundsMax)
                        --print("[RentMotelMod] " .. roomId .. ": IsPlayerPhysicallyInsideRoom at expiry? " .. tostring(wasPhysicallyInside))
                    end
                    room.config.wasPhysicallyInsideRoomAtExpiry = wasPhysicallyInside
                    room.config.physicalInsideCheckDoneAtExpiry = true
                    --print("[RentMotelMod] " .. roomId .. ": wasPhysicallyInsideRoomAtExpiry set to " .. tostring(room.config.wasPhysicallyInsideRoomAtExpiry) .. ", physicalInsideCheckDoneAtExpiry set to true")
                end

                -- Handle different expiry scenarios
                if not room.config.wasPhysicallyInsideRoomAtExpiry then
                    --print("[RentMotelMod] " .. roomId .. ": Player was NOT inside at expiry. Locking door.")
                    -- Player was outside at expiry - immediate lock
                    LockDoor(roomId)
                    room.config.doorUnlockExpirySeconds = nil
                    GameSession.TrySave()
                else
                    -- Player was inside at expiry - check current position
                    --print("[RentMotelMod] " .. roomId .. ": Player WAS inside at expiry. Checking if still inside.")
                    local isPlayerCurrentlyStillInsideRoom = true 
                    if playerPosition and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                        isPlayerCurrentlyStillInsideRoom = IsPlayerPhysicallyInsideRoom(playerPosition, roomDef.roomBoundsMin, roomDef.roomBoundsMax)
                        --print("[RentMotelMod] " .. roomId .. ": IsPlayerPhysicallyInsideRoom (still inside check)? " .. tostring(isPlayerCurrentlyStillInsideRoom))
                    else
                        --print("[RentMotelMod] " .. roomId .. ": Cannot check if player still inside (missing playerPos or roomDef bounds).")
                    end

                    if not isPlayerCurrentlyStillInsideRoom then
                        -- Player has now exited - charge fee and lock
                        if not room.config.overstayFeeCharged and roomDef and roomDef.rentCost then
                            local overstayFee = math.floor(roomDef.rentCost * 0.20)
                            if overstayFee > 0 then
                                local ts = Game.GetTransactionSystem()
                                local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())
                                if playerMoney >= overstayFee and ts:RemoveMoney(player, overstayFee, "money") then
                                    --print("[RentMotelMod] " .. roomId .. ": Overstay fee " .. overstayFee .. " charged.")
                                    room.config.overstayFeeCharged = true
                                else
                                    --print("[RentMotelMod] " .. roomId .. ": Could not charge overstay fee " .. overstayFee .. ". Player money: " .. playerMoney)
                                end
                            else
                                --print("[RentMotelMod] " .. roomId .. ": Overstay fee is zero or less.")
                            end
                        else
                             --print("[RentMotelMod] " .. roomId .. ": Overstay fee already charged or no roomDef/rentCost.")
                        end
                        --print("[RentMotelMod] " .. roomId .. ": Player has exited after overstay. Locking door.")
                        LockDoor(roomId)
                        room.config.doorUnlockExpirySeconds = nil 
                        GameSession.TrySave()
                    else
                        --print("[RentMotelMod] " .. roomId .. ": Player still inside after expiry. Door remains unlocked.")
                    end
                    -- Else: Player still inside - door remains unlocked
                end
            end
        end
    end
end)
