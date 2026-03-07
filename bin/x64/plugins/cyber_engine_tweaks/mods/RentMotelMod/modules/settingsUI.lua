local Config = require("modules/config")
local L = require("modules/localization").L

local SettingsUI = {}

-- Sets up Native Settings UI integration
-- Call this from onInit after checking GetMod("nativeSettings")
function SettingsUI.setup(nativeSettings)
    local RoomManager = require("modules/roomManager")
    
    -- Add mod tab
    nativeSettings.addTab("/RentMotel", L("RentMotel-Settings-TabName"))
    
    -- Add prices subcategory
    nativeSettings.addSubcategory("/RentMotel/Prices", L("RentMotel-Settings-PricesCategory"))
    
    -- Sunset Motel Room 102 price slider
    nativeSettings.addRangeInt("/RentMotel/Prices", L("RentMotel-Settings-SunsetPrice"), L("RentMotel-Settings-SunsetPriceDesc"), 10, 30000, 10, 
        Config.prices.sunset_motel_room_102 or 450, 450, function(value)
            Config.prices.sunset_motel_room_102 = value
            Config.Save()
            if RoomManager.rooms["sunset_motel_room_102"] then
                RoomManager.rooms["sunset_motel_room_102"].config.rentCost = value
            end
        end)
    
    -- Kabuki Motel Room 203 price slider
    nativeSettings.addRangeInt("/RentMotel/Prices", L("RentMotel-Settings-KabukiPrice"), L("RentMotel-Settings-KabukiPriceDesc"), 10, 30000, 10, 
        Config.prices.kabuki_motel_room_203 or 700, 700, function(value)
            Config.prices.kabuki_motel_room_203 = value
            Config.Save()
            if RoomManager.rooms["kabuki_motel_room_203"] then
                RoomManager.rooms["kabuki_motel_room_203"].config.rentCost = value
            end
        end)
    
    -- Dewdrop Inn Room 106 price slider
    nativeSettings.addRangeInt("/RentMotel/Prices", L("RentMotel-Settings-DewdropPrice"), L("RentMotel-Settings-DewdropPriceDesc"), 10, 30000, 10, 
        Config.prices.DewdropInn_motel_room_106 or 1000, 1000, function(value)
            Config.prices.DewdropInn_motel_room_106 = value
            Config.Save()
            if RoomManager.rooms["DewdropInn_motel_room_106"] then
                RoomManager.rooms["DewdropInn_motel_room_106"].config.rentCost = value
            end
        end)
    
    -- No-Tell Motel Room 206 price slider
    nativeSettings.addRangeInt("/RentMotel/Prices", L("RentMotel-Settings-NoTellPrice"), L("RentMotel-Settings-NoTellPriceDesc"), 10, 30000, 10, 
        Config.prices.NoTell_motel_room_206 or 700, 700, function(value)
            Config.prices.NoTell_motel_room_206 = value
            Config.Save()
            if RoomManager.rooms["NoTell_motel_room_206"] then
                RoomManager.rooms["NoTell_motel_room_206"].config.rentCost = value
            end
        end)
    
    -- Add rental options subcategory
    nativeSettings.addSubcategory("/RentMotel/RentalOptions", L("RentMotel-Settings-RentalOptionsCategory"))
    
    -- Extended rental duration slider
    nativeSettings.addRangeInt("/RentMotel/RentalOptions", L("RentMotel-Settings-ExtendedDays"), L("RentMotel-Settings-ExtendedDaysDesc"), 2, 30, 1, 
        Config.extendedRentalDays or 7, 7, function(value)
            Config.extendedRentalDays = value
            Config.Save()
        end)
    
    -- Add permanent renting subcategory
    nativeSettings.addSubcategory("/RentMotel/PermanentRenting", L("RentMotel-Settings-PermanentCategory"))
    
    -- Permanent renting toggle switch
    nativeSettings.addSwitch("/RentMotel/PermanentRenting", L("RentMotel-Settings-PermanentToggle"), L("RentMotel-Settings-PermanentToggleDesc"), 
        Config.permanentRentingEnabled or false, false, function(state)
            Config.permanentRentingEnabled = state
            Config.Save()
        end)
    
    -- Permanent price sliders for each room
    nativeSettings.addRangeInt("/RentMotel/PermanentRenting", L("RentMotel-Settings-SunsetPermanentPrice"), L("RentMotel-Settings-SunsetPermanentPriceDesc"), 1000, 500000, 1000, 
        Config.permanentPrices.sunset_motel_room_102 or 45000, 45000, function(value)
            Config.permanentPrices.sunset_motel_room_102 = value
            Config.Save()
        end)
    
    nativeSettings.addRangeInt("/RentMotel/PermanentRenting", L("RentMotel-Settings-KabukiPermanentPrice"), L("RentMotel-Settings-KabukiPermanentPriceDesc"), 1000, 500000, 1000, 
        Config.permanentPrices.kabuki_motel_room_203 or 70000, 70000, function(value)
            Config.permanentPrices.kabuki_motel_room_203 = value
            Config.Save()
        end)
    
    nativeSettings.addRangeInt("/RentMotel/PermanentRenting", L("RentMotel-Settings-DewdropPermanentPrice"), L("RentMotel-Settings-DewdropPermanentPriceDesc"), 1000, 500000, 1000, 
        Config.permanentPrices.DewdropInn_motel_room_106 or 100000, 100000, function(value)
            Config.permanentPrices.DewdropInn_motel_room_106 = value
            Config.Save()
        end)
    
    nativeSettings.addRangeInt("/RentMotel/PermanentRenting", L("RentMotel-Settings-NoTellPermanentPrice"), L("RentMotel-Settings-NoTellPermanentPriceDesc"), 1000, 500000, 1000, 
        Config.permanentPrices.NoTell_motel_room_206 or 70000, 70000, function(value)
            Config.permanentPrices.NoTell_motel_room_206 = value
            Config.Save()
        end)
end

return SettingsUI
