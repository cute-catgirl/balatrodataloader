function calculate_data_driven_joker(effects, seed, context)
    -- Check if effects is a table
    if type(effects) ~= "table" then
        print("Effects is not a table")
        return nil
    end
    
    context = context or {}
    
    local return_value = {
        message = ""
    }
    local effect_count = 0
    
    for _, effect in ipairs(effects) do
        -- Handle conditional effects
        if effect.type == "conditional" then
            local condition_met = check_condition(effect.condition, effect.value, context, seed)
            local sub_effects = condition_met and effect.on_true or effect.on_false
            
            if sub_effects and #sub_effects > 0 then
                local sub_result = calculate_data_driven_joker(sub_effects, seed, context)
                if sub_result then
                    for k, v in pairs(sub_result) do
                        if k == "message" then
                            if return_value.message == "" then
                                return_value.message = sub_result.message
                            else
                                return_value.message = "!"
                            end
                        elseif k == "colour" then
                            return_value.colour = sub_result.colour
                        else
                            return_value[k] = (return_value[k] or 0) + v
                        end
                    end
                    effect_count = effect_count + 1
                end
            end
        else
            -- Handle regular effects
            local val = 0
            if type(effect.value) == "table" then
                if effect.value.type == "constant" then
                    val = effect.value.value
                elseif effect.value.type == "random" then
                    math.randomseed(seed)
                    val = math.random(effect.value.min, effect.value.max)
                else
                    print("Unknown effect value type: " .. effect.value.type)
                    val = 0
                end
            else
                val = tonumber(effect.value)
            end
            
            if effect.type == "add_mult" then
                return_value.mult_mod = (return_value.mult_mod or 0) + val
                return_value.message = localize{type='variable',key='a_mult',vars={val}}
                return_value.colour = G.C.MULT
                effect_count = effect_count + 1
            elseif effect.type == "mult_mult" then
                return_value.Xmult_mod = (return_value.Xmult_mod or 0) + val
                return_value.message = localize{type='variable',key='a_xmult',vars={val}}
                return_value.colour = G.C.MULT
                effect_count = effect_count + 1
            elseif effect.type == "add_chips" then
                return_value.chip_mod = (return_value.chip_mod or 0) + val
                return_value.message = localize{type='variable',key='a_chips',vars={val}}
                return_value.colour = G.C.CHIPS
                effect_count = effect_count + 1
            elseif effect.type == "add_money" then
                ease_dollars(val)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + val
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return_value.dollars = (return_value.dollars or 0) + val
                return_value.message = localize('$')..val
                return_value.colour = G.C.MONEY
                effect_count = effect_count + 1
            end
        end
    end
    
    if effect_count > 1 then
        return_value.message = "!"
    end

    return return_value
end

-- Check conditions
function check_condition(condition_type, value, context, seed)
    if condition_type == "random" then
        math.randomseed(seed)
        local rand_value = math.random(1, 100)
        return rand_value <= value
    end
    
    return false
end