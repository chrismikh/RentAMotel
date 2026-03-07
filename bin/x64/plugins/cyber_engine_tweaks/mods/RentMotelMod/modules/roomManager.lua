local RoomDefs = require("modules/roomDefinitions")
local Cron = require("modules/Cron")
local GameSession = require("modules/GameSession")

local ROOM_DEFINITIONS = RoomDefs.ROOM_DEFINITIONS
local ROOM_DEFINITIONS_BY_ID = RoomDefs.ROOM_DEFINITIONS_BY_ID
local IsPlayerPhysicallyInsideRoom = RoomDefs.IsPlayerPhysicallyInsideRoom

-- Main table for managing the state of rentable motel rooms
local RoomManager = {
    ready = false,
    sessionKey = 0,
    rooms = {},
    isInitialLoad = true,
    activeInteractionRoomId = nil,
    hasRestoredData = false,
    serializableForPersistence = {},
    playerNearTerminal = false
}

-- Populates the rooms table with initial data for each room
function RoomManager.initializeRooms()
    RoomManager.rooms = {}
    for _, roomDef in ipairs(ROOM_DEFINITIONS) do
        RoomManager.rooms[roomDef.roomId] = {
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

        if roomDef.backDoorHash then
            RoomManager.rooms[roomDef.roomId].backDoorToLockHash = roomDef.backDoorHash
        end
    end
end

-- Schedules a delayed attempt to permanently lock a specified back door.
function RoomManager.ScheduleBackDoorLock(doorHash)
    if not doorHash then return end
    Cron.After(5.0, function()
        local doorEntityID = EntityID.new({ hash = doorHash })
        RoomManager.EnsureDoorPermanentlyLocked(doorEntityID)
    end)
end

-- Attempts to find a door by its entity ID and permanently lock and seal it.
function RoomManager.EnsureDoorPermanentlyLocked(doorEntityID)
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
function RoomManager.getSerializableRooms()
    local serializableRooms = {}
    for roomId, room in pairs(RoomManager.rooms) do
        serializableRooms[roomId] = {
            roomId = room.roomId,
            doorHash = room.doorHash,
            paymentTerminalHash = room.paymentTerminalHash,
            config = room.config,
        }
    end
    return serializableRooms
end

-- Restores the state of rooms from previously serialized data.
function RoomManager.restoreRoomsFromSerialized(serializedRooms)
    if not serializedRooms then 
        return 
    end
    
    for roomId, serializedRoom in pairs(serializedRooms) do
        if RoomManager.rooms[roomId] then
            local currentRoomDef = ROOM_DEFINITIONS_BY_ID[roomId]
            if not currentRoomDef then
            elseif serializedRoom.config and serializedRoom.config.rentCost ~= nil and currentRoomDef.rentCost ~= nil then
                if serializedRoom.config.rentCost ~= currentRoomDef.rentCost then
                    serializedRoom.config.rentCost = currentRoomDef.rentCost
                end
            end

            if serializedRoom.config then
                for k, v in pairs(serializedRoom.config) do
                    RoomManager.rooms[roomId].config[k] = v
                end
            end
        end
    end
    RoomManager.hasRestoredData = true
end

-- Get room by ID helper
function RoomManager.getRoom(roomId)
    return RoomManager.rooms[roomId]
end

-- Resets all managed rooms to default states (locked, no expiry).
function RoomManager.resetRoomsToDefault()
    if RoomManager.hasRestoredData then
        return
    end
    
    for roomId, room in pairs(RoomManager.rooms) do
        room.config.isDoorLocked = room.config.doorLockedByDefault
        room.config.doorUnlockExpirySeconds = nil
        room.doorSynced = false
        room.interactionActive = false
    end
end

-- Checks player proximity to all payment terminals and doors
-- Uses lazy require to avoid circular dependencies with rentalUI and hallwayDoor
function RoomManager.checkPlayerProximity()
    if not RoomManager.ready then return end
    
    local player = Game.GetPlayer()
    if not player then return end
    
    -- Lazy require to avoid circular deps
    local rentalUI = require("modules/rentalUI")
    local hallwayDoor = require("modules/hallwayDoor")
    local doorControl = require("modules/doorControl")
    
    local playerPos = player:GetWorldPosition()
    local activeProximityTargetType = nil
    local activeProximityTargetId = nil
    local isPlayerInsideAnyRoom = false

    for roomId, room in pairs(RoomManager.rooms) do
        local roomDef = ROOM_DEFINITIONS_BY_ID[roomId]
        
        -- Sync door state on first spawn
        if not room.doorSynced then
            local door = Game.FindEntityByID(room.doorID)
            if door then
                doorControl.SyncDoorStateWithSavedState(roomId)
                room.doorSynced = true
            end
        end
        
        -- Check if player is inside this room's boundaries
        if not isPlayerInsideAnyRoom and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
            if IsPlayerPhysicallyInsideRoom(playerPos, roomDef.roomBoundsMin, roomDef.roomBoundsMax) then
                isPlayerInsideAnyRoom = true
            end
        end
        
        -- Check payment terminal proximity
        if not isPlayerInsideAnyRoom and not activeProximityTargetType and room.paymentTerminalID then
            local terminal = Game.FindEntityByID(room.paymentTerminalID)
            if terminal then
                local termPos = terminal:GetWorldPosition()
                local dx, dy, dz = playerPos.x - termPos.x, playerPos.y - termPos.y, playerPos.z - termPos.z
                if dx*dx + dy*dy + dz*dz < 4.0 then
                    activeProximityTargetType = "room"
                    activeProximityTargetId = roomId
                end
            end
        end
    end

    -- Check for the hallway door
    if not isPlayerInsideAnyRoom and not activeProximityTargetType and hallwayDoor.getEntityID() then
        local hallwayDoorEntity = Game.FindEntityByID(hallwayDoor.getEntityID())
        if hallwayDoorEntity then
            local hallwayDoorPos = hallwayDoorEntity:GetWorldPosition()
            local dx, dy, dz = playerPos.x - hallwayDoorPos.x, playerPos.y - hallwayDoorPos.y, playerPos.z - hallwayDoorPos.z
            if dx*dx + dy*dy + dz*dz < 4.0 then
                activeProximityTargetType = "hallway"
            end
        end
    end

    -- Manage the active interactions based on the single target found
    local roomInteractionIsActive = RoomManager.activeInteractionRoomId ~= nil
    local hallwayIsActive = hallwayDoor.isActive()

    -- Hide interactions that should NOT be active
    if roomInteractionIsActive and (activeProximityTargetType ~= "room" or activeProximityTargetId ~= RoomManager.activeInteractionRoomId) then
        rentalUI.hideInteraction(RoomManager.activeInteractionRoomId)
    end
    if hallwayIsActive and activeProximityTargetType ~= "hallway" then
        hallwayDoor.hide()
    end

    -- Show the one interaction that SHOULD be active
    if activeProximityTargetType == "room" and not roomInteractionIsActive then
        rentalUI.showInteraction(activeProximityTargetId)
    elseif activeProximityTargetType == "hallway" and not hallwayIsActive then
        hallwayDoor.show()
    end
end

-- Checks all rooms for rent expiry and handles locking/overstay fees
function RoomManager.checkRentExpiry()
    local timeSystem = Game.GetTimeSystem()
    if not timeSystem then return end
    local now = timeSystem:GetGameTime()
    local nowSeconds = now:GetSeconds()
    local player = Game.GetPlayer()
    local playerPosition = player and player:GetWorldPosition()

    -- Lazy require to avoid circular deps
    local doorControl = require("modules/doorControl")

    for roomId, room in pairs(RoomManager.rooms) do
        if not room.config.isDoorLocked and room.config.doorUnlockExpirySeconds then
            if nowSeconds >= room.config.doorUnlockExpirySeconds then
                local roomDef = ROOM_DEFINITIONS_BY_ID[roomId]

                -- First-time physical position check at expiry
                if not room.config.physicalInsideCheckDoneAtExpiry then
                    local wasPhysicallyInside = false
                    if playerPosition and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                        wasPhysicallyInside = IsPlayerPhysicallyInsideRoom(playerPosition, roomDef.roomBoundsMin, roomDef.roomBoundsMax)
                    end
                    room.config.wasPhysicallyInsideRoomAtExpiry = wasPhysicallyInside
                    room.config.physicalInsideCheckDoneAtExpiry = true
                end

                if not room.config.wasPhysicallyInsideRoomAtExpiry then
                    -- Player was outside at expiry - immediate lock
                    doorControl.LockDoor(roomId)
                else
                    -- Player was inside at expiry - check current position
                    local isPlayerCurrentlyStillInsideRoom = true 
                    if playerPosition and roomDef and roomDef.roomBoundsMin and roomDef.roomBoundsMax then
                        isPlayerCurrentlyStillInsideRoom = IsPlayerPhysicallyInsideRoom(playerPosition, roomDef.roomBoundsMin, roomDef.roomBoundsMax)
                    end

                    if not isPlayerCurrentlyStillInsideRoom then
                        -- Player has now exited - charge fee and lock
                        if not room.config.overstayFeeCharged and roomDef and roomDef.rentCost then
                            local overstayFee = math.floor(roomDef.rentCost * 0.20)
                            if overstayFee > 0 then
                                local ts = Game.GetTransactionSystem()
                                local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())
                                if playerMoney >= overstayFee and ts:RemoveMoney(player, overstayFee, "money") then
                                    room.config.overstayFeeCharged = true
                                end
                            end
                        end
                        doorControl.LockDoor(roomId)
                    end
                    -- Else: Player still inside - door remains unlocked
                end
            end
        end
    end
end

return RoomManager
