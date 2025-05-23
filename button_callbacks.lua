-- luacheck: globals G

G.FUNCS.datapacks_button = function()
    -- open datapacks menu
    local packs = G.DATAPACKS or {}
    G.FUNCS.overlay_menu{
        definition = create_datapacks_menu(packs)
    }
end

G.FUNCS.update_packs = function()
    print(G.TEMP_DATAPACKS["example_pack"])
    G.PROFILES[G.focused_profile].datapacks = G.TEMP_DATAPACKS or {}
    print(G.PROFILES[G.focused_profile].datapacks["example_pack"])
    -- persist updated profile to disk so load_profile doesn't overwrite it
    G.SAVE_MANAGER.channel:push({
        type = 'save_settings',
        save_settings = G.SETTINGS,
        profile_num = G.focused_profile,
        save_profile = G.PROFILES[G.focused_profile]
    })
    -- Reload the game with the new packs
    G.FUNCS.load_profile()
end