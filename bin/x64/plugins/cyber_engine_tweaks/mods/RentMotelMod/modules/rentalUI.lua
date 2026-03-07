local interactionUI = require("modules/interactionUI")
local Config = require("modules/config")
local L = require("modules/localization").L

local RentalUI = {}

-- Helper function to generate rental choices based on player funds
local function createRentalChoices(roomId, rentCost1Day, rentCostExtended, playerMoney)
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
local function createInteractionHub(roomId)
    local RoomManager = require("modules/roomManager")
    local room = RoomManager.getRoom(roomId)
    if not room then return nil end
    
    local choices = {}
    local player = Game.GetPlayer()
    if not player then return nil end
    
    local ts = Game.GetTransactionSystem()
    if not ts then return nil end
    
    local playerMoney = ts:GetItemQuantity(player, MarketSystem.Money())

    local rentCost1Day = room.config.rentCost
    local rentCostExtended = math.floor(rentCost1Day * Config.extendedRentalDays * 0.9)

    if room.config.isDoorLocked then
        choices = createRentalChoices(roomId, rentCost1Day, rentCostExtended, playerMoney)
    end

    local hubTitle = L(room.locKeyRoomName)
    local activityState = gameinteractionsvisEVisualizerActivityState.Active
    
    local hub = interactionUI.createHub(hubTitle, choices, activityState)
    
    return hub
end

-- Configures interaction callbacks
local function setupInteractionCallbacks(roomId)
    local RoomManager = require("modules/roomManager")
    local doorControl = require("modules/doorControl")
    local room = RoomManager.getRoom(roomId)
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
                doorControl.UnlockDoor(roomId, 24, rentCost1Day)
            end)
        end

        -- Callback for extended rental (Choice 2)
        if playerMoney >= rentCostExtended then
            interactionUI.registerChoiceCallback(2, function()
                doorControl.UnlockDoor(roomId, Config.extendedRentalDays * 24, rentCostExtended)
            end)
        end

        -- Callback for permanent rental (Choice 3) - only when enabled
        if isPermanentMode then
            if playerMoney >= permanentCost then
                interactionUI.registerChoiceCallback(3, function()
                    doorControl.UnlockDoor(roomId, 999999 * 24, permanentCost)
                end)
            end
        end
    end
end

-- Shows room interaction hub when near payment terminal
function RentalUI.showInteraction(roomId)
    local RoomManager = require("modules/roomManager")
    local hallwayDoor = require("modules/hallwayDoor")
    local room = RoomManager.getRoom(roomId)
    if not room then return end

    -- If the door is already unlocked, do not show any interaction hub.
    if not room.config.isDoorLocked then
        return
    end

    -- Hide any other active interactions first
    if RoomManager.activeInteractionRoomId and RoomManager.activeInteractionRoomId ~= roomId then
        RentalUI.hideInteraction(RoomManager.activeInteractionRoomId)
    end
    
    -- Also hide hallway door interaction if it's active
    if hallwayDoor.isActive() then
        hallwayDoor.hide()
    end

    if not room.interactionActive then
        room.interactionActive = true
        RoomManager.activeInteractionRoomId = roomId
        
        local hub = createInteractionHub(roomId)
        if hub then
            interactionUI.setupHub(hub)
            setupInteractionCallbacks(roomId)
            interactionUI.showHub()
        end
    end
end

-- Hides the currently active interaction hub for a specified room.
function RentalUI.hideInteraction(roomId)
    local RoomManager = require("modules/roomManager")
    local room = RoomManager.getRoom(roomId)
    if not room then return end
    
    if room.interactionActive then
        -- Clear callbacks and hide hub FIRST
        interactionUI.clearCallbacks()
        interactionUI.hideHub()
        
        -- Then update state flags
        room.interactionActive = false
        if RoomManager.activeInteractionRoomId == roomId then
            RoomManager.activeInteractionRoomId = nil
        end
    end
end

return RentalUI
