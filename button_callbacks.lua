G.FUNCS.datapacks_button = function()
    -- open datapacks menu
    local packs = G.DATAPACKS or {}
    G.FUNCS.overlay_menu{
        definition = create_datapacks_menu(packs)
    }
end