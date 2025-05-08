function create_UIBox_datapacks_icon_button(args)
    local texture_path = "Mods/data_loader/assets/datapacks_button.png"
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
    return {
        n = G.UIT.R,
        config = { padding = 0, align = "cm" },
        nodes = {
            { n = G.UIT.T, config = { text = pack.name, align = "cm", colour = G.C.UI.TEXT_LIGHT, scale = 0.5 } },
            create_toggle({
                label = '',
                ref_table = G.ENABLED_DATAPACKS,
                ref_value = pack.name,
                col = true,
                w = 0,
                h = 0.5,
            }),
        }
    }
end

function create_datapack_list(packs)
    local list = {}
    G.ENABLED_DATAPACKS = G.ENABLED_DATAPACKS or {}
    for i, pack in ipairs(packs) do
        pack.should_enable = G.ENABLED_DATAPACKS[pack.name] or false
        local pack_button = create_UIBox_datapack_item(pack)
        table.insert(list, pack_button)
    end
    return {n=G.UIT.C, config={align = "cm", padding = 0, draw_layer = 1, minw = 4}, nodes=list}
end

function create_datapacks_menu(packs)
    local datapack_list = create_datapack_list(packs)
    return (create_UIBox_generic_options({
        padding = 0,
        back_func = "setup_run",
        contents = {
            {n = G.UIT.C, config={align = "cm", padding = 0}, nodes = {
                {n = G.UIT.R, config={align = "cm", padding = 0}, nodes = {
                    datapack_list
                }},
            }},
        }
    }))
end