function CardArea:change_highlighted_limit(delta)
    if delta ~= 0 then 
        G.E_MANAGER:add_event(Event({
            func = function() 
                self.config.highlighted_limit = math.max(0, self.config.highlighted_limit + delta)
        return true
        end}))
    end
end