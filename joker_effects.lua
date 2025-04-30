function calculate_data_driven_joker(effects)
    print(effects)
    -- Check if effects is a table
    if type(effects) ~= "table" then
        print("Effects is not a table")
        return nil
    end
    local return_value = {}
    for _, effect in ipairs(effects) do
        if effect.type == "add_mult" then
            return_value.mult_mod = effect.value
        end
        if effect.type == "mult_mult" then
            return_value.Xmult_mod = effect.value
        end
        if effect.type == "add_chips" then
            return_value.chip_mod = effect.value
        end
    end

    return return_value
end