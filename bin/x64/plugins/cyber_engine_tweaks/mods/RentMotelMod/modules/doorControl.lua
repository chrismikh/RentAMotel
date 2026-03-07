local Cron = require("modules/Cron")
local GameSession = require("modules/GameSession")

local DoorControl = {}

-- Callback for final door locking
-- Seals door, saves session, updates UI
local function doorLockDelayCallback(roomId)
    local RoomManager = require("modules/roomManager")
    local room = RoomManager.getRoom(roomId)
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
                RoomManager.checkPlayerProximity()
            end)
        end
    end
end

-- Locks room door, updates config, schedules final seal
-- Config state is ALWAYS updated even if the door entity is not loaded (player far away).
function DoorControl.LockDoor(roomId)
    local RoomManager = require("modules/roomManager")
    local room = RoomManager.getRoom(roomId)
    if not room then return end
    
    -- Always update config state first, regardless of door entity availability
    room.config.isDoorLocked = true
    room.config.doorUnlockExpirySeconds = nil
    room.config.overstayFeeCharged = false
    room.config.wasPhysicallyInsideRoomAtExpiry = false
    room.config.physicalInsideCheckDoneAtExpiry = false
    room.doorSynced = false
    
    local door = Game.FindEntityByID(room.doorID)
    if door then
        local ps = door:GetDevicePS()
        if ps then
            door:CloseDoor()
            
            Cron.After(0.5, function()
                doorLockDelayCallback(roomId)
            end)
            return
        end
    end
    
    -- Door entity not loaded — just save the updated config state
    GameSession.TrySave()
end

-- Unlocks room if player can pay rent, sets expiry, opens door
function DoorControl.UnlockDoor(roomId, durationInHours, costToCharge)
    local RoomManager = require("modules/roomManager")
    local rentalUI = require("modules/rentalUI")
    local room = RoomManager.getRoom(roomId)
    if not room then return end
    
    local player = Game.GetPlayer()
    local door = Game.FindEntityByID(room.doorID)
    local ts = Game.GetTransactionSystem()
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())
    
    if door and player then
        local ps = door:GetDevicePS()
        if ps then
            local doorLocked = ps:IsLocked()
            
            if doorLocked or room.config.isDoorLocked then
                if playerMoney < costToCharge then
                    return
                end

                if ts:RemoveMoney(player, costToCharge, "money") then
                    -- Hide interaction FIRST before unlocking
                    rentalUI.hideInteraction(roomId)
                    
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
function DoorControl.SyncDoorStateWithSavedState(roomId)
    local RoomManager = require("modules/roomManager")
    local room = RoomManager.getRoom(roomId)
    if not room then return end
    
    if not RoomManager.sessionKey or RoomManager.sessionKey == 0 then
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

return DoorControl
