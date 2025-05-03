function create_UIBox_datapacks(args)
    return (create_UIBox_generic_options({
        back_func = "datapacks_button",
    }))
end

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