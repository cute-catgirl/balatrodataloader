local json = require("json")

function loadDatapacks(self)
    print("Loading datapacks...")
    local folder = "datapacks"
    print("Loading datapacks from save directory: " .. love.filesystem.getSaveDirectory() .. "/" .. folder)

    -- Create the folder if it doesn't exist
    if not love.filesystem.getInfo(folder, "directory") then
        love.filesystem.createDirectory(folder)
        print("Created datapacks folder at: " .. love.filesystem.getSaveDirectory() .. "/" .. folder)
    end

    for _, namespace in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local nsPath = folder .. "/" .. namespace
        if love.filesystem.getInfo(nsPath, "directory") then
            print("Found datapack: " .. nsPath)
            loadDatapack(self, nsPath)
        end
    end
end

function loadDatapack(self, path)
    print("Loading datapack...")
    -- Get the metadata
    local metadataPath = path .. "/pack.json"
    if love.filesystem.getInfo(metadataPath, "file") then
        local metadata = json.decode(love.filesystem.read(metadataPath))
        if metadata and metadata.name then
            print("Datapack name: " .. metadata.name)
            G.DATAPACKS = G.DATAPACKS or {}
            table.insert(G.DATAPACKS, {
                name = metadata.name,
                description = metadata.description or "",
                author = metadata.author or "",
                version = metadata.version or "1.0",
                path = path,
            })
        else
            print("Invalid pack.json format in " .. path)
            -- Do not load the datapack if it doesn't have a valid pack.json
            return
        end
    else
        print("No pack.json found in " .. path)
        -- Do not load the datapack if it doesn't have a pack.json
        return
    end
    -- Load jokers
    local jokerPath = path .. "/data/jokers"
    if love.filesystem.getInfo(jokerPath, "directory") then
        for _, joker in ipairs(love.filesystem.getDirectoryItems(jokerPath)) do
            local jokerPath = jokerPath .. "/" .. joker
            if love.filesystem.getInfo(jokerPath, "file") then
                local jokerName = string.match(joker, "(.*)%.json")
                if jokerName then
                    local jokerData = json.decode(love.filesystem.read(jokerPath))
                    if jokerData then
                        loadJoker(self, jokerName, jokerData, path, G.DATAPACKS[#G.DATAPACKS])
                    end
                end
            end
        end
    end

    -- Load tarot cards
    local tarotPath = path .. "/data/tarot_cards"
    if love.filesystem.getInfo(tarotPath, "directory") then
        for _, tarot in ipairs(love.filesystem.getDirectoryItems(tarotPath)) do
            local tarotPath = tarotPath .. "/" .. tarot
            if love.filesystem.getInfo(tarotPath, "file") then
                local tarotName = string.match(tarot, "(.*)%.json")
                if tarotName then
                    local tarotData = json.decode(love.filesystem.read(tarotPath))
                    if tarotData then
                        loadTarot(self, tarotName, tarotData, path, G.DATAPACKS[#G.DATAPACKS])
                    end
                end
            end
        end
    end
end

function loadJoker(self, name, data, path, pack)
    print("Loading joker: " .. name)
    if not self.P_CENTERS then
        self.P_CENTERS = {}
    end

    local key = string.gsub(string.lower(name), " ", "_")
    key = "j_" .. key
    if self.P_CENTERS[key] then
        print("Joker " .. name .. " already exists, skipping.")
        return
    end
    
    -- Count existing jokers
    local joker_count = 0
    for k, v in pairs(self.P_CENTERS) do
        if k:sub(1, 2) == "j_" then
            joker_count = joker_count + 1
        end
    end

    -- Verify data has all required fields
    if not data.name or not data.rarity or not data.cost then
        print("Joker " .. name .. " is missing required fields, skipping.")
        return
    end

    local texture_img = nil
    if data.texture then
        local texture_path = path .. "/assets/jokers/" .. data.texture
        if love.filesystem.getInfo(texture_path, "file") then
            texture_img = {
                image = love.graphics.newImage(love.filesystem.newFileData(love.filesystem.read(texture_path), texture_path)),
                px = 142, -- width of your joker image
                py = 190  -- height of your joker image
            }
        else
            print("Texture not found: " .. texture_path)
        end
    end

    print(data.on_play)
    
    -- Create the joker
    local joker={
        order = (joker_count + 1),
        unlocked = true,
        start_alerted = true,
        discovered = true,
        blueprint_compat = data.blueprint_compatible or true,
        perishable_compat = data.perishable_compatible or true,
        eternal_compat = data.eternal_compatible or true,
        rarity = data.rarity,
        cost = data.cost,
        name = data.name,
        pos = {x=0,y=0},
        set = "Joker",
        effect = "",
        config = {extra = {on_play = data.on_play or {}}},
        data_driven = true,
        description = data.description or "",
        custom_texture = texture_img or "",
        datapack = pack.name
    }
    self.P_CENTERS[key] = joker
end

function loadTarot(self, name, data, path, pack)
    print("Loading tarot: " .. name)
    if not self.P_CENTERS then
        self.P_CENTERS = {}
    end
    local key = string.gsub(string.lower(name), " ", "_")
    key = "c_" .. key
    if self.P_CENTERS[key] then
        print("Tarot " .. name .. " already exists, skipping.")
        return
    end
    -- Count existing tarot cards
    local tarot_count = 0
    for k, v in pairs(self.P_CENTERS) do
        if k:sub(1, 2) == "c_" then
            -- Only include tarots, not other consumables (in tarot set)
            if v.set == "Tarot" then
                tarot_count = tarot_count + 1
            end
        end
    end
    -- Verify data has all required fields
    if not data.name or not data.cost then
        print("Tarot " .. name .. " is missing required fields, skipping.")
        return
    end

    local texture_img = nil
    if data.texture then
        local texture_path = path .. "/assets/tarot_cards/" .. data.texture
        if love.filesystem.getInfo(texture_path, "file") then
            texture_img = {
                image = love.graphics.newImage(love.filesystem.newFileData(love.filesystem.read(texture_path), texture_path)),
                px = 126, -- width of your tarot image
                py = 186  -- height of your tarot image
            }
        else
            print("Texture not found: " .. texture_path)
        end
    end
    -- Create the tarot
    local tarot = {
        order = (tarot_count + 1),
        discovered = true,
        cost = data.cost,
        consumeable = true,
        name = data.name,
        pos = {x=0,y=0},
        set = "Tarot",
        effect = "",
        cost_mult = 1.0,
        config = {},
        description = data.description or "",
        custom_texture = texture_img or "",
        data_driven = true,
        datapack = pack.name,
    }
    self.P_CENTERS[key] = tarot
end