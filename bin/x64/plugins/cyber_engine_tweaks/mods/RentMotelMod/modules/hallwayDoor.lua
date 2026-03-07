local Cron = require("modules/Cron")
local interactionUI = require("modules/interactionUI")
local L = require("modules/localization").L

local HallwayDoor = {}

-- Hallway Door Configuration
local HALLWAY_DOOR_HASH = 10866749775532408022ULL
local hallwayDoorEntityID = nil
local isHallwayDoorInteractionActive = false
local lastKnownHallwayDoorOpen = false

-- Initialize the hallway door entity ID from the hash
function HallwayDoor.init()
    if HALLWAY_DOOR_HASH then
        hallwayDoorEntityID = EntityID.new({ hash = HALLWAY_DOOR_HASH })
    end
end

-- Returns the hallway door entity ID
function HallwayDoor.getEntityID()
    return hallwayDoorEntityID
end

-- Returns whether the hallway door interaction is currently active
function HallwayDoor.isActive()
    return isHallwayDoorInteractionActive
end

-- Updates the hallway door interaction hub choices
local function updateInteraction()
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
                Cron.After(0.1, updateInteraction)
            end
        end)
        interactionUI.showHub()
    end
end

-- Shows the hallway door interaction
function HallwayDoor.show()
    local RoomManager = require("modules/roomManager")
    if isHallwayDoorInteractionActive or RoomManager.activeInteractionRoomId then 
        return 
    end
    isHallwayDoorInteractionActive = true
    updateInteraction()
end

-- Hides the hallway door interaction
function HallwayDoor.hide()
    if isHallwayDoorInteractionActive then
        interactionUI.hideHub()
        interactionUI.clearCallbacks()
        isHallwayDoorInteractionActive = false
    end
end

return HallwayDoor
