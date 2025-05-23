function create_UIBox_datapacks_icon_button(args)
    local texture_path = "Mods/balatrodataloader/assets/datapacks_button.png"
    local texture_img = nil
    print(texture_path)
    if love.filesystem.getInfo(texture_path, "file") then
        texture_img = {
            image = love.graphics.newImage(love.filesystem.newFileData(love.filesystem.read(texture_path), texture_path)),
            px = 34,
            py = 34
        }
    else
        print("Texture not found: " .. texture_path)
    end
    local datapacks = Sprite(0,0,0.6,0.6, texture_img, {x=0, y=0})
    return ({n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = 'datapacks_button', shadow = true}, nodes={
        {n=G.UIT.O, config={object = datapacks}},
    }})
end

function create_UIBox_datapack_item(pack)
    print("uibox id: " .. pack.id)
    return {
        n = G.UIT.R,
        config = { padding = 0, align = "cm" },
        nodes = {
            {n = G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05, minw = 6, minh = 1 }, nodes = {
                {n = G.UIT.C, config = { align = "cl", padding = 0.1, r = 0.1, colour = G.C.RED, emboss = 0.05 }, nodes = {
                    { n = G.UIT.T, config = { text = pack.name, align = "cm", colour = G.C.UI.TEXT_LIGHT, scale = 0.5 } }
                }},
                create_toggle({
                    label = '',
                    ref_table = G.TEMP_DATAPACKS,
                    ref_value = pack.id,
                    col = true,
                    w = 0,
                    h = 0.5,
                    align = "cr"
                })
            }}
        }
    }
end

function create_datapack_list(packs)
    print("Creating datapack list")
    local list = {}
    G.TEMP_DATAPACKS = {}

    if not G.PROFILES[G.focused_profile] then
        print("No focused profile")
        return nil
    end

    if not G.PROFILES[G.focused_profile].datapacks then
        print("nope!")
        G.PROFILES[G.focused_profile].datapacks = {}
    end
    
    print("Iterating through packs")
    -- Iterate through packs which is a table with keys
    for id, pack in pairs(packs) do
        print("Pack ID: " .. id)
        if G.PROFILES[G.focused_profile].datapacks[id] and G.PROFILES[G.focused_profile].datapacks[id] == true then
            print("true!")
            G.TEMP_DATAPACKS[id] = true
        else
            print("false!")
            G.TEMP_DATAPACKS[id] = false
        end
        local pack_button = create_UIBox_datapack_item(pack)
        table.insert(list, pack_button)
    end
    
    return {n=G.UIT.R, config={align = "cm", padding = 0.1, draw_layer = 1}, nodes=list}
end

function create_datapacks_menu(packs)
    local datapack_list = create_datapack_list(packs)
    return (create_UIBox_generic_options({
        padding = 0,
        back_func = "profile_select",
        contents = {
            {n = G.UIT.C, config={align = "cm", padding = 0}, nodes = {
                datapack_list,
                { n = G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.RED, shadow = true, hover = true, button = "update_packs" }, nodes = {
                        { n = G.UIT.T, config = { text = "Save", align = "cm", colour = G.C.UI.TEXT_LIGHT, scale = 0.5 } }
                }},
            }},
        }
    }))
end