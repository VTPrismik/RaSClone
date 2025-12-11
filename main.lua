local inputs = require("inputs")
local player = require("player")
local attacks = require("attacks")

elapsedtime = 0
state = "Game"
input_mode = "Controller"
debug = true

main = {
    winw = 0,
    winh = 0,
}

assets = {
    count = 0,
    effect = {},
    player = {},
    attacks = {}
}

local function loadasset(name, type)
    assets.count = assets.count + 1
    if type == "effect" then
        local image = "assets/" .. type .. "/" .. name .. ".png"
        imagedata = love.graphics.newImage(image)
        table.insert(assets.effect, {name = name, image = imagedata, id = assets.count})
    end

end

function love.load()
    loadasset("testeffect", "effect")
    loadasset("testeffect", "effect")
    for _ , assettype in pairs(assets) do
        if type(assettype) == "table" then
            for _, asset in ipairs(assettype) do
                if debug then
                    print("Loaded: " .. asset.name .. " (" .. asset.id .. ")")
                end
            end
        end
    end
end

function love.update(dt)
    elapsedtime = elapsedtime + dt
    if inputs.button_pressed("debug", "Keyboard") and not debugheld then
        debugheld = true
        debug = not debug
    end
    if not inputs.button_pressed("debug", "Keyboard") and debugheld then
        debugheld = false
    end
    --if player.health <= 0 then
    --    state = "Dead"
    --end

    if state == "AssetLoading" then
        --love.graphics.newImage("assets/effects/")
    elseif state == "Game" then
        attacks.update(dt)
        player.update(dt)
    elseif state == "Dead" then
    end
end

function love.draw()
    main.winw, main.winh = love.graphics.getDimensions()
    local actions, direction = inputs.get_current_inputs(input_mode)
    local actions_str = table.concat(actions, ", ")

    love.graphics.setColor(0, 0.5, 0)
    love.graphics.rectangle("fill", 0, 0, main.winw, main.winh)
    love.graphics.setColor(1, 1, 1)

    if debug then
        love.graphics.print("Width: " .. main.winw .. ", " .. "Height: " .. main.winh, 0, 15)
        love.graphics.print("Actions: " .. actions_str, 0, 45)
        love.graphics.print("Direction: (" .. direction.x .. ", " .. direction.y .. ")", 0, 30)
        fps = love.timer.getFPS()
        love.graphics.print(fps, 0, 0)
    end

    if state == "Main" then

    elseif state == "Game" then
        attacks.draw()
        player.draw()

    elseif state == "Dead" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, w, h)
    end
end