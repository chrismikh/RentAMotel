local Localization = {}

-- Localization helper (Codeware texts are registered in native localization system)
-- This function retrieves localized text for the current language set in the game.
function Localization.L(key, vars)
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

return Localization
