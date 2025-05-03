-- Adds or overrides custom localization entries.
-- @param localization The original localization table to modify.
-- @return The modified localization table.
function add_custom_localization(localization)
    localization["misc"]["dictionary"]["b_datapacks"] = "Datapacks"
    localization["misc"]["dictionary"]["b_datapacks_cap"] = "DATAPACKS"
    localization["misc"]["dictionary"]["b_datapacks_small"] = "D"
    
    if G and G.P_CENTERS then
        for key, joker in pairs(G.P_CENTERS) do
            if key:sub(1, 2) == "j_" and joker.data_driven then
                print(key)
                localization["descriptions"]["Joker"][key] = {
                    name = joker.name,
                    text = {
                        joker.description
                    },
                }
            end
        end
    end

    return localization
end