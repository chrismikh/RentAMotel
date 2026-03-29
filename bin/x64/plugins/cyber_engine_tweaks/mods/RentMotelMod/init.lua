local Cron = require("modules/Cron")
local GameSession = require("modules/GameSession")
local interactionUI = require("modules/interactionUI")
local Config = require("modules/config")
local RoomManager = require("modules/roomManager")
local doorControl = require("modules/doorControl")
local rentalUI = require("modules/rentalUI")
local hallwayDoor = require("modules/hallwayDoor")
local settingsUI = require("modules/settingsUI")

-- Load user settings (prices) from settings.json
Config.Load()

-- Expose RoomManager as global for CET console access
RentMotelManager = RoomManager

-- Throttle timers for performance
local proximityCheckInterval = 0.2
local proximityCheckTimer = 0
local expiryCheckInterval = 1.0
local expiryCheckTimer = 0

-- Main mod initialization
registerForEvent("onInit", function()
    RoomManager.initializeRooms()
    interactionUI.init()
    hallwayDoor.init()

    -- Setup for the GameSession persistence library
    GameSession.IdentifyAs("RentMotel_session_key")
    GameSession.StoreInDir("sessions")

    -- Initialize persistent data store
    local initialSerializableData = RoomManager.getSerializableRooms()
    for k, v in pairs(initialSerializableData) do RoomManager.serializableForPersistence[k] = v end
    GameSession.Persist(RoomManager.serializableForPersistence) 
    
    -- New game session handler
    GameSession.OnStart(function(state)
        RoomManager.ready = true 
        RoomManager.sessionKey = state.sessionKey or GameSession.GetKey()
        
        if RoomManager.ready then 
            for roomId, roomData in pairs(RoomManager.rooms) do
                if roomData.backDoorToLockHash then
                    RoomManager.ScheduleBackDoorLock(roomData.backDoorToLockHash)
                    roomData.backDoorToLockHash = nil 
                end
            end
        end

        if RoomManager.isInitialLoad then
            RoomManager.resetRoomsToDefault()
            Cron.After(1.5, function()
                RoomManager.checkPlayerProximity()
            end)
        end
    end)

    -- Session cleanup handler
    GameSession.OnEnd(function()
        RoomManager.ready = false
        RoomManager.isInitialLoad = true
        RoomManager.hasRestoredData = false 
        
        for _, room in pairs(RoomManager.rooms) do
            room.doorSynced = false
        end
        
        if RoomManager.activeInteractionRoomId then
            rentalUI.hideInteraction(RoomManager.activeInteractionRoomId)
        end

        for k in pairs(RoomManager.serializableForPersistence) do
            RoomManager.serializableForPersistence[k] = nil
        end
    end)

    -- Save data loader
    GameSession.OnLoad(function(state)
        RoomManager.hasRestoredData = false
        RoomManager.initializeRooms()
        RoomManager.restoreRoomsFromSerialized(RoomManager.serializableForPersistence)
        
        for _, room in pairs(RoomManager.rooms) do
            room.doorSynced = false
        end
    end)

    -- Pre-save handler
    GameSession.OnSave(function(state)
        local key = state.sessionKey or 0
        if RoomManager.sessionKey == 0 and key ~= 0 then
            RoomManager.sessionKey = key
        end

        local currentSerializableRooms = RoomManager.getSerializableRooms()
        for k in pairs(RoomManager.serializableForPersistence) do
            RoomManager.serializableForPersistence[k] = nil
        end
        for k, v in pairs(currentSerializableRooms) do
            RoomManager.serializableForPersistence[k] = v
        end
    end)

    -- Native Settings integration (optional dependency)
    local nativeSettings = GetMod("nativeSettings")
    if nativeSettings then
        settingsUI.setup(nativeSettings)
    end
end)

-- CET Console Command/hotkey: Reset all rooms to default locked state
function RentMotelReset()
    print("[RentMotelMod] Resetting all rooms to default locked state...")
    for roomId, room in pairs(RoomManager.rooms) do
        room.config.isDoorLocked = true
        room.config.doorUnlockExpirySeconds = nil
        room.config.overstayFeeCharged = false
        room.config.wasPhysicallyInsideRoomAtExpiry = false
        room.config.physicalInsideCheckDoneAtExpiry = false
        room.doorSynced = false
        room.interactionActive = false
        
        local door = Game.FindEntityByID(room.doorID)
        if door then
            local ps = door:GetDevicePS()
            if ps then
                door:CloseDoor()
                Cron.After(0.3, function()
                    local freshDoor = Game.FindEntityByID(room.doorID)
                    if freshDoor then
                        local freshPs = freshDoor:GetDevicePS()
                        if freshPs then
                            if not freshPs:IsSealed() then freshPs:ToggleSealOnDoor() end
                            if not freshPs:IsLocked() then freshPs:ToggleLockOnDoor() end
                        end
                    end
                end)
            end
            print("[RentMotelMod]   " .. roomId .. ": Door found and locked.")
        else
            print("[RentMotelMod]   " .. roomId .. ": Door entity not loaded (will sync when nearby).")
        end
    end
    
    if RoomManager.activeInteractionRoomId then
        rentalUI.hideInteraction(RoomManager.activeInteractionRoomId)
    end
    if hallwayDoor.isActive() then
        hallwayDoor.hide()
    end
    
    GameSession.TrySave()
    
    Cron.After(1.0, function()
        RoomManager.checkPlayerProximity()
    end)
    
    print("[RentMotelMod] All rooms have been reset. Doors will sync when you get close.")
end

registerHotkey('ResetMod', 'Reset All Rooms', function()
    RentMotelReset()
end)

-- Final cleanup on shutdown
registerForEvent("onShutdown", function()
    GameSession.TrySave()
    if RoomManager.activeInteractionRoomId then
        rentalUI.hideInteraction(RoomManager.activeInteractionRoomId)
    end
end)

-- Main game loop
registerForEvent("onUpdate", function(delta)
    Cron.Update(delta)
    if RoomManager.activeInteractionRoomId or hallwayDoor.isActive() then
        interactionUI.update()
    end
    
    -- Throttle proximity checks (runs every 200ms)
    proximityCheckTimer = proximityCheckTimer + delta
    if proximityCheckTimer >= proximityCheckInterval then
        proximityCheckTimer = 0
        RoomManager.checkPlayerProximity()
    end

    -- Throttle rent expiry checks (runs every 1 second)
    expiryCheckTimer = expiryCheckTimer + delta
    if expiryCheckTimer < expiryCheckInterval then
        return
    end
    expiryCheckTimer = 0

    RoomManager.checkRentExpiry()
end)
