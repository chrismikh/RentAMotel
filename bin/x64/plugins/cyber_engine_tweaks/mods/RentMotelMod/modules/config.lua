-- Config module for RentMotelMod
-- Handles loading and saving of user settings to settings.json

local Config = {}

-- Default prices for each motel room
Config.defaults = {
    sunset_motel_room_102 = 450,
    kabuki_motel_room_203 = 700,
    DewdropInn_motel_room_106 = 1000,
    NoTell_motel_room_206 = 700
}

-- Default extended rental duration (in days)
Config.defaultExtendedRentalDays = 7

-- Default permanent renting setting
Config.defaultPermanentRentingEnabled = false

-- Default permanent prices (~100x daily rate)
Config.defaultPermanentPrices = {
    sunset_motel_room_102 = 45000,
    kabuki_motel_room_203 = 70000,
    DewdropInn_motel_room_106 = 100000,
    NoTell_motel_room_206 = 70000
}

-- Runtime prices (loaded from file or defaults)
Config.prices = {}

-- Runtime extended rental days (loaded from file or default)
Config.extendedRentalDays = Config.defaultExtendedRentalDays

-- Runtime permanent renting enabled (loaded from file or default)
Config.permanentRentingEnabled = Config.defaultPermanentRentingEnabled

-- Runtime permanent prices (loaded from file or defaults)
Config.permanentPrices = {}

-- Path to settings file (relative to mod folder)
local settingsFileName = "settings.json"

-- Get the full path to the settings file
local function getSettingsPath()
    return settingsFileName
end

-- Load settings from JSON file
function Config.Load()
    -- Start with defaults
    for k, v in pairs(Config.defaults) do
        Config.prices[k] = v
    end
    Config.extendedRentalDays = Config.defaultExtendedRentalDays
    Config.permanentRentingEnabled = Config.defaultPermanentRentingEnabled
    for k, v in pairs(Config.defaultPermanentPrices) do
        Config.permanentPrices[k] = v
    end
    
    -- Try to load from file
    local file = io.open(getSettingsPath(), "r")
    if file then
        local content = file:read("*all")
        file:close()
        
        if content and #content > 0 then
            local success, data = pcall(function()
                return json.decode(content)
            end)
            
            if success and data then
                -- Load prices
                if data.prices then
                    -- Merge loaded prices with defaults (in case new rooms are added)
                    for k, v in pairs(data.prices) do
                        if Config.defaults[k] ~= nil then -- Only load known room IDs
                            Config.prices[k] = v
                        end
                    end
                end
                
                -- Load extended rental days
                if data.extendedRentalDays and type(data.extendedRentalDays) == "number" then
                    Config.extendedRentalDays = data.extendedRentalDays
                end
                
                -- Load permanent renting enabled
                if data.permanentRentingEnabled ~= nil and type(data.permanentRentingEnabled) == "boolean" then
                    Config.permanentRentingEnabled = data.permanentRentingEnabled
                end
                
                -- Load permanent prices
                if data.permanentPrices then
                    for k, v in pairs(data.permanentPrices) do
                        if Config.defaultPermanentPrices[k] ~= nil then
                            Config.permanentPrices[k] = v
                        end
                    end
                end
            end
        end
    end
    
    return Config.prices
end

-- Save settings to JSON file
function Config.Save()
    local data = {
        prices = Config.prices,
        extendedRentalDays = Config.extendedRentalDays,
        permanentRentingEnabled = Config.permanentRentingEnabled,
        permanentPrices = Config.permanentPrices
    }
    
    local success, content = pcall(function()
        return json.encode(data)
    end)
    
    if success and content then
        local file = io.open(getSettingsPath(), "w")
        if file then
            file:write(content)
            file:close()
            return true
        end
    end
    
    return false
end

return Config
