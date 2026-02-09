local Cron = require("modules/Cron")
local GameSession = require("modules/GameSession")
local interactionUI = require("modules/interactionUI")
local Config = require("modules/config")

-- Load user settings (prices) from settings.json
Config.Load()

-- Native Settings reference (set in onInit if available)
local nativeSettings = nil

-- Hallway Door Configuration
-- This is for a generic, non-rentable door that the player can open and close.
local HALLWAY_DOOR_HASH = 10866749775532408022ULL
local hallwayDoorEntityID = nil
local isHallwayDoorInteractionActive = false
local lastKnownHallwayDoorOpen = false

-- Localization helper (Codeware texts are registered in native localization system)
-- This function retrieves localized text for the current language set in the game.
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

-- Helper function to check if player is within defined room boundaries
-- This is used to determine if the player is physically inside a rented room.
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
-- This table contains all the data for the rentable rooms.
local ROOM_DEFINITIONS = {
    {
        roomId = "sunset_motel_room_102",
        locKeyRoomName = "RentMotel-Room-Sunset",
        doorHash = 10025113471746604205ULL, -- The unique hash for the room's main door entity
        paymentTerminalHash = 2454332936290437600ULL, -- Payment terminal hash entity
        rentCost = Config.prices.sunset_motel_room_102 or 450,
        -- The 3D boundaries of the room's interior
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
local ROOM_DEFINITIONS_BY_ID = {}
for _, roomDef in ipairs(ROOM_DEFINITIONS) do
    ROOM_DEFINITIONS_BY_ID[roomDef.roomId] = roomDef
end

-- Throttle timers for performance
local proximityCheckInterval = 0.2 -- Check proximity every 200ms 
local proximityCheckTimer = 0
local expiryCheckInterval = 1.0 -- Check rent expiry every 1 second
local expiryCheckTimer = 0

-- Main table for managing the state of rentable motel rooms
RentMotelManager = {
    ready = false, -- Becomes true when a game session is active
    sessionKey = 0, -- Unique key for the current game session
    rooms = {}, -- Holds the dynamic state of all rooms
    isInitialLoad = true, -- Flag for the first time the mod loads in a session
    activeInteractionRoomId = nil, -- Tracks which room UI is currently displayed
    hasRestoredData = false, -- Flag indicating if data was loaded from a save
    serializableForPersistence = {}, -- Data that gets written to the save file
    playerNearTerminal = false -- Tracks if player is near any payment terminal
}

-- Populates the RentMotelManager.rooms table with initial data for each room
-- This runs when the mod first initializes.
function RentMotelManager.initializeRooms()
    RentMotelManager.rooms = {}
    for _, roomDef in ipairs(ROOM_DEFINITIONS) do
        RentMotelManager.rooms[roomDef.roomId] = {
            roomId = roomDef.roomId,
            locKeyRoomName = roomDef.locKeyRoomName,
            doorID = EntityID.new({ hash = roomDef.doorHash }),
            doorHash = roomDef.doorHash,
            paymentTerminalID = roomDef.paymentTerminalHash and EntityID.new({ hash = roomDef.paymentTerminalHash }) or nil,
            paymentTerminalHash = roomDef.paymentTerminalHash,
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
            playerNearTerminal = false,
            doorSynced = false
        }

        -- If a secondary door (backDoorHash) is defined, schedule it to be permanently locked
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
            doorHash = room.doorHash,
            paymentTerminalHash = room.paymentTerminalHash,
            config = room.config,
        }
    end
    return serializableRooms
end

-- Helper function to get room definition by ID (O(1) lookup using pre-computed table)
local function getRoomDefinitionById(roomId)
    return ROOM_DEFINITIONS_BY_ID[roomId]
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
    end
end

-- Door control functions

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
                RentMotelManager.checkPlayerProximity()
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

                if ts:RemoveMoney(player, costToCharge, "money") then
                    -- Hide interaction FIRST before unlocking
                    RentMotelManager.hideInteraction(roomId)
                    
                    -- Then proceed with unlocking
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
                end
            end
        end
    end
end

-- Syncs physical door state with config (lock/seal status)
-- This ensures the door's lock state matches the saved data when the player gets near.
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

-- Helper function to generate rental choices based on player funds
function createRentalChoices(roomId, rentCost1Day, rentCostExtended, playerMoney)
    local choices = {}
    local extendedDays = Config.extendedRentalDays
    local isPermanentMode = Config.permanentRentingEnabled
    
    -- Option 1: 24 hours
    if playerMoney >= rentCost1Day then
        table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-24h", { price = rentCost1Day }), nil, gameinteractionsChoiceType.QuestImportant))
    else
        table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-24h-NoMoney", { price = rentCost1Day }), nil, gameinteractionsChoiceType.Disabled))
    end

    -- Option 2: Extended days (always shown)
    if playerMoney >= rentCostExtended then
        table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-7d", { price = rentCostExtended, days = extendedDays }), nil, gameinteractionsChoiceType.QuestImportant))
    else
        table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-7d-NoMoney", { price = rentCostExtended, days = extendedDays }), nil, gameinteractionsChoiceType.Disabled))
    end

    -- Option 3: Permanent (only when enabled)
    if isPermanentMode then
        local permanentCost = Config.permanentPrices[roomId] or rentCostExtended
        if playerMoney >= permanentCost then
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-Permanent", { price = permanentCost }), nil, gameinteractionsChoiceType.QuestImportant))
        else
            table.insert(choices, interactionUI.createChoice(L("RentMotel-Choice-Permanent-NoMoney", { price = permanentCost }), nil, gameinteractionsChoiceType.Disabled))
        end
    end
    return choices
end

-- Creates room interaction hub based on lock state/funds
function RentMotelManager.createInteractionHub(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return nil end
    
    local choices = {}
    local player = Game.GetPlayer()
    if not player then return nil end
    
    local ts = Game.GetTransactionSystem()
    if not ts then return nil end
    
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())

    local rentCost1Day = room.config.rentCost
    local rentCostExtended = math.floor(rentCost1Day * Config.extendedRentalDays * 0.9) -- 10% discount for extended rental

    if room.config.isDoorLocked then
        choices = createRentalChoices(roomId, rentCost1Day, rentCostExtended, playerMoney)
    end

    local hubTitle = L(room.locKeyRoomName)
    local activityState = gameinteractionsvisEVisualizerActivityState.Active
    
    local hub = interactionUI.createHub(hubTitle, choices, activityState)
    
    return hub
end

-- Configures interaction callbacks
-- This function determines what happens when the player clicks a choice in the UI.
function RentMotelManager.setupInteractionCallbacks(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    interactionUI.clearCallbacks()

    local player = Game.GetPlayer()
    local ts = Game.GetTransactionSystem()
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())

    local rentCost1Day = room.config.rentCost
    local rentCostExtended = math.floor(rentCost1Day * Config.extendedRentalDays * 0.9)
    local isPermanentMode = Config.permanentRentingEnabled
    local permanentCost = Config.permanentPrices[roomId] or rentCostExtended

    if room.config.isDoorLocked then
        -- Callback for 24-hour rental (Choice 1)
        if playerMoney >= rentCost1Day then
            interactionUI.registerChoiceCallback(1, function()
                UnlockDoor(roomId, 24, rentCost1Day) -- durationInHours = 24, costToCharge = rentCost1Day
            end)
        end

        -- Callback for extended rental (Choice 2)
        if playerMoney >= rentCostExtended then
            interactionUI.registerChoiceCallback(2, function()
                UnlockDoor(roomId, Config.extendedRentalDays * 24, rentCostExtended) -- durationInHours = extendedDays * 24, costToCharge = rentCostExtended
            end)
        end

        -- Callback for permanent rental (Choice 3) - only when enabled
        if isPermanentMode then
            if playerMoney >= permanentCost then
                interactionUI.registerChoiceCallback(3, function()
                    UnlockDoor(roomId, 999999 * 24, permanentCost) -- durationInHours = 999999 days, costToCharge = permanentCost
                end)
            end
        end
    end
end

-- Updates and shows interaction hub if active
function RentMotelManager.updateInteractionHub(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end
    
    if room.interactionActive then
        local hub = RentMotelManager.createInteractionHub(roomId)
        if hub then
            interactionUI.setupHub(hub)
            RentMotelManager.setupInteractionCallbacks(roomId)
            interactionUI.showHub()
        end
    end
end

-- Shows room interaction hub when near payment terminal
function RentMotelManager.showInteraction(roomId)
    local room = RentMotelManager.getRoom(roomId)
    if not room then return end

    -- If the door is already unlocked, do not show any interaction hub.
    if not room.config.isDoorLocked then
        return
    end

    -- Hide any other active interactions first
    if RentMotelManager.activeInteractionRoomId and RentMotelManager.activeInteractionRoomId ~= roomId then
        RentMotelManager.hideInteraction(RentMotelManager.activeInteractionRoomId)
    end
    
    -- Also hide hallway door interaction if it's active
    if isHallwayDoorInteractionActive then
        HideHallwayDoorInteraction()
    end

    if not room.interactionActive then
        room.interactionActive = true
        RentMotelManager.activeInteractionRoomId = roomId
        
        local hub = RentMotelManager.createInteractionHub(roomId)
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
        -- Clear callbacks and hide hub FIRST
        interactionUI.clearCallbacks()
        interactionUI.hideHub()
        
        -- Then update state flags
        room.interactionActive = false
        if RentMotelManager.activeInteractionRoomId == roomId then
            RentMotelManager.activeInteractionRoomId = nil
        end
    end
end

-- Simple Hallway Door Interaction Functions
-- These functions manage the simple open/close interaction for the generic hallway door.
function UpdateHallwayDoorInteraction()
    if not isHallwayDoorInteractionActive then return end
    interactionUI.clearCallbacks()
    local choices = {}
    local choiceText = lastKnownHallwayDoorOpen and L("RentMotel-UI-CloseDoor") or L("RentMotel-UI-OpenDoor")
    table.insert(choices, interactionUI.createChoice(choiceText, nil, gameinteractionsChoiceType.Default))
    
    local hub = interactionUI.createHub(L("RentMotel-UI-HallwayDoor"), choices, gameinteractionsvisEVisualizerActivityState.Active)
    if hub then
        interactionUI.setupHub(hub)
        interactionUI.registerChoiceCallback(1, function()
            local door = Game.FindEntityByID(hallwayDoorEntityID)
            if door then
                if lastKnownHallwayDoorOpen then
                    door:CloseDoor()
                    lastKnownHallwayDoorOpen = false
                else
                    local ps = door:GetDevicePS()
                    if ps and ps:IsSealed() then ps:ToggleSealOnDoor() end
                    if ps and ps:IsLocked() then ps:ToggleLockOnDoor() end
                    door:OpenDoor()
                    lastKnownHallwayDoorOpen = true
                end
                Cron.After(0.1, UpdateHallwayDoorInteraction)
            end
        end)
        interactionUI.showHub()
    end
end

function ShowHallwayDoorInteraction()
    if isHallwayDoorInteractionActive or (RentMotelManager and RentMotelManager.activeInteractionRoomId) then 
        return 
    end
    isHallwayDoorInteractionActive = true
    UpdateHallwayDoorInteraction()
end

function HideHallwayDoorInteraction()
    if isHallwayDoorInteractionActive then
        interactionUI.hideHub()
        interactionUI.clearCallbacks()
        isHallwayDoorInteractionActive = false
    end
end

-- Checks player proximity to all payment terminals (and doors for sync)
-- Manages interaction UI visibility and initial sync
function RentMotelManager.checkPlayerProximity()
    if not RentMotelManager.ready then return end
    
    local player = Game.GetPlayer()
    if not player then return end
    
    local playerPos = player:GetWorldPosition()
    local activeProximityTargetType = nil
    local activeProximityTargetId = nil
    local isPlayerInsideAnyRoom = false

    -- Single optimized loop for all room checks
    for roomId, room in pairs(RentMotelManager.rooms) do
        local roomDef = ROOM_DEFINITIONS_BY_ID[roomId] -- Direct lookup instead of function call
        
        -- Sync door state on first spawn (always check this)
        if not room.doorSynced then
            local door = Game.FindEntityByID(room.doorID)
            if door then
                SyncDoorStateWithSavedState(roomId)
                room.doorSynced = true
            end
        end
        
        -- Check if player is inside this room's boundaries
        if not isPlayerInsideAnyRoom and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
            if IsPlayerPhysicallyInsideRoom(playerPos, roomDef.roomBoundsMin, roomDef.roomBoundsMax) then
                isPlayerInsideAnyRoom = true
            end
        end
        
        -- Check payment terminal proximity (only if not inside any room and no target found yet)
        if not isPlayerInsideAnyRoom and not activeProximityTargetType and room.paymentTerminalID then
            local terminal = Game.FindEntityByID(room.paymentTerminalID)
            if terminal then
                local termPos = terminal:GetWorldPosition()
                local dx, dy, dz = playerPos.x - termPos.x, playerPos.y - termPos.y, playerPos.z - termPos.z
                if dx*dx + dy*dy + dz*dz < 4.0 then -- Within 2 meters
                    activeProximityTargetType = "room"
                    activeProximityTargetId = roomId
                end
            end
        end
    end

    -- Check for the hallway door (only if player is NOT inside any room and no target found)
    if not isPlayerInsideAnyRoom and not activeProximityTargetType and hallwayDoorEntityID then
        local hallwayDoorEntity = Game.FindEntityByID(hallwayDoorEntityID)
        if hallwayDoorEntity then
            local hallwayDoorPos = hallwayDoorEntity:GetWorldPosition()
            local dx, dy, dz = playerPos.x - hallwayDoorPos.x, playerPos.y - hallwayDoorPos.y, playerPos.z - hallwayDoorPos.z
            if dx*dx + dy*dy + dz*dz < 4.0 then -- 2.0 squared
                activeProximityTargetType = "hallway"
            end
        end
    end

    -- Manage the active interactions based on the single target found
    local roomInteractionIsActive = RentMotelManager.activeInteractionRoomId ~= nil
    local hallwayIsActive = isHallwayDoorInteractionActive

    -- Hide interactions that should NOT be active
    if roomInteractionIsActive and (activeProximityTargetType ~= "room" or activeProximityTargetId ~= RentMotelManager.activeInteractionRoomId) then
        RentMotelManager.hideInteraction(RentMotelManager.activeInteractionRoomId)
    end
    if hallwayIsActive and activeProximityTargetType ~= "hallway" then
        HideHallwayDoorInteraction()
    end

    -- Show the one interaction that SHOULD be active
    if activeProximityTargetType == "room" and not roomInteractionIsActive then
        RentMotelManager.showInteraction(activeProximityTargetId)
    elseif activeProximityTargetType == "hallway" and not hallwayIsActive then
        ShowHallwayDoorInteraction()
    end
end

-- Main mod initialization - handles room states, UI, and persistence
-- Handles save/load and session events
registerForEvent("onInit", function()
    RentMotelManager.initializeRooms()
    interactionUI.init()

    -- Setup for the GameSession persistence library
    GameSession.IdentifyAs("RentMotel_session_key")
    GameSession.StoreInDir("sessions")

    -- Initialize Hallway Door Entity ID
    if HALLWAY_DOOR_HASH then
        hallwayDoorEntityID = EntityID.new({ hash = HALLWAY_DOOR_HASH })
    end

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

        -- Refresh persistence data
        local currentSerializableRooms = RentMotelManager.getSerializableRooms()
        for k in pairs(RentMotelManager.serializableForPersistence) do
            RentMotelManager.serializableForPersistence[k] = nil
        end
        for k, v in pairs(currentSerializableRooms) do
            RentMotelManager.serializableForPersistence[k] = v
        end
    end)

    -- Native Settings integration (optional dependency)
    nativeSettings = GetMod("nativeSettings")
    if nativeSettings then
        -- Add mod tab
        nativeSettings.addTab("/RentMotel", "Rent A Motel")
        
        -- Add prices subcategory
        nativeSettings.addSubcategory("/RentMotel/Prices", "Room Prices (€$)")
        
        -- Sunset Motel Room 102 price slider
        nativeSettings.addRangeInt("/RentMotel/Prices", "Sunset Motel Room 102", "Default: 450€$", 10, 30000, 10, 
            Config.prices.sunset_motel_room_102 or 450, 450, function(value)
                Config.prices.sunset_motel_room_102 = value
                Config.Save()
                -- Update runtime price if room is initialized
                if RentMotelManager.rooms["sunset_motel_room_102"] then
                    RentMotelManager.rooms["sunset_motel_room_102"].config.rentCost = value
                end
            end)
        
        -- Kabuki Motel Room 203 price slider
        nativeSettings.addRangeInt("/RentMotel/Prices", "Kabuki Motel Room 203", "Default: 700€$", 10, 30000, 10, 
            Config.prices.kabuki_motel_room_203 or 700, 700, function(value)
                Config.prices.kabuki_motel_room_203 = value
                Config.Save()
                -- Update runtime price if room is initialized
                if RentMotelManager.rooms["kabuki_motel_room_203"] then
                    RentMotelManager.rooms["kabuki_motel_room_203"].config.rentCost = value
                end
            end)
        
        -- Dewdrop Inn Room 106 price slider
        nativeSettings.addRangeInt("/RentMotel/Prices", "Dewdrop Inn Room 106", "Default: 1000€$", 10, 30000, 10, 
            Config.prices.DewdropInn_motel_room_106 or 1000, 1000, function(value)
                Config.prices.DewdropInn_motel_room_106 = value
                Config.Save()
                -- Update runtime price if room is initialized
                if RentMotelManager.rooms["DewdropInn_motel_room_106"] then
                    RentMotelManager.rooms["DewdropInn_motel_room_106"].config.rentCost = value
                end
            end)
        
        -- No-Tell Motel Room 206 price slider
        nativeSettings.addRangeInt("/RentMotel/Prices", "No-Tell Motel Room 206", "Default: 700€$", 10, 30000, 10, 
            Config.prices.NoTell_motel_room_206 or 700, 700, function(value)
                Config.prices.NoTell_motel_room_206 = value
                Config.Save()
                -- Update runtime price if room is initialized
                if RentMotelManager.rooms["NoTell_motel_room_206"] then
                    RentMotelManager.rooms["NoTell_motel_room_206"].config.rentCost = value
                end
            end)
        
        -- Add rental options subcategory
        nativeSettings.addSubcategory("/RentMotel/RentalOptions", "Rental Options")
        
        -- Extended rental duration slider
        nativeSettings.addRangeInt("/RentMotel/RentalOptions", "Extended Rental Duration (Days)", "Set the number of days for extended rental option. Default: 7 days. Price includes 10% discount.", 2, 30, 1, 
            Config.extendedRentalDays or 7, 7, function(value)
                Config.extendedRentalDays = value
                Config.Save()
            end)
        
        -- Add permanent renting subcategory
        nativeSettings.addSubcategory("/RentMotel/PermanentRenting", "Permanent Renting")
        
        -- Permanent renting toggle switch
        nativeSettings.addSwitch("/RentMotel/PermanentRenting", "Enable Permanent Renting", "When enabled, adds a third option for renting a motel room, with permanent ownership (999999 days). Default: Disabled.", 
            Config.permanentRentingEnabled or false, false, function(state)
                Config.permanentRentingEnabled = state
                Config.Save()
            end)
        
        -- Permanent price sliders for each room
        nativeSettings.addRangeInt("/RentMotel/PermanentRenting", "Sunset Motel Permanent Price", "Price for permanent ownership of Sunset Motel Room 102. Default: 45000€$", 1000, 500000, 1000, 
            Config.permanentPrices.sunset_motel_room_102 or 45000, 45000, function(value)
                Config.permanentPrices.sunset_motel_room_102 = value
                Config.Save()
            end)
        
        nativeSettings.addRangeInt("/RentMotel/PermanentRenting", "Kabuki Motel Permanent Price", "Price for permanent ownership of Kabuki Motel Room 203. Default: 70000€$", 1000, 500000, 1000, 
            Config.permanentPrices.kabuki_motel_room_203 or 70000, 70000, function(value)
                Config.permanentPrices.kabuki_motel_room_203 = value
                Config.Save()
            end)
        
        nativeSettings.addRangeInt("/RentMotel/PermanentRenting", "Dewdrop Inn Permanent Price", "Price for permanent ownership of Dewdrop Inn Room 106. Default: 100000€$", 1000, 500000, 1000, 
            Config.permanentPrices.DewdropInn_motel_room_106 or 100000, 100000, function(value)
                Config.permanentPrices.DewdropInn_motel_room_106 = value
                Config.Save()
            end)
        
        nativeSettings.addRangeInt("/RentMotel/PermanentRenting", "No-Tell Motel Permanent Price", "Price for permanent ownership of No-Tell Motel Room 206. Default: 70000€$", 1000, 500000, 1000, 
            Config.permanentPrices.NoTell_motel_room_206 or 70000, 70000, function(value)
                Config.permanentPrices.NoTell_motel_room_206 = value
                Config.Save()
            end)
    end
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
    if RentMotelManager.activeInteractionRoomId or isHallwayDoorInteractionActive then
        interactionUI.update()
    end
    
    -- Throttle proximity checks (runs every 200ms)
    proximityCheckTimer = proximityCheckTimer + delta
    if proximityCheckTimer >= proximityCheckInterval then
        proximityCheckTimer = 0
        RentMotelManager.checkPlayerProximity()
    end

    -- Throttle rent expiry checks (runs every 1 second)
    expiryCheckTimer = expiryCheckTimer + delta
    if expiryCheckTimer < expiryCheckInterval then
        return -- Skip expiry check this frame
    end
    expiryCheckTimer = 0

    -- Get time and player once outside the loop (performance optimization)
    local timeSystem = Game.GetTimeSystem()
    if not timeSystem then return end
    local now = timeSystem:GetGameTime()
    local nowSeconds = now:GetSeconds()
    local player = Game.GetPlayer()
    local playerPosition = player and player:GetWorldPosition()

    -- Check all rooms for rent expiry
    for roomId, room in pairs(RentMotelManager.rooms) do
        if not room.config.isDoorLocked and room.config.doorUnlockExpirySeconds then
            -- Handle expired rent period
            if nowSeconds >= room.config.doorUnlockExpirySeconds then
                --print("[RentMotelMod] Rent expired for room: " .. roomId .. ". Current time: " .. nowSeconds .. ", Expiry time: " .. room.config.doorUnlockExpirySeconds)
                local roomDef = ROOM_DEFINITIONS_BY_ID[roomId] -- Use lookup table
                --print("[RentMotelMod] Player position: " .. (playerPosition and (playerPosition.x .. "," .. playerPosition.y .. "," .. playerPosition.z) or "nil"))

                -- First-time physical position check at expiry
                -- This check determines if the player was inside the room at the exact moment the rent expired.
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
