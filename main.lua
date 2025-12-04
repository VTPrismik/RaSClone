local inputs = require("inputs")
local player = require("player")
local attacks = require("attacks")

state = "Main"
input_mode = "Keyboard"
debug = true

function love.update(dt)
    if player.health <= 0 then
        state = "Dead"
    end
    if state == "Main" then
        state = "Game"
    elseif state == "Game" then
        attacks.update(dt)
        player.update(dt)
    elseif state == "Dead" then
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    local actions, direction = inputs.get_current_inputs(input_mode)
    local actions_str = table.concat(actions, ", ")

    if debug then
        love.graphics.print("Width: " .. w .. ", " .. "Height: " .. h, 0, 15)
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