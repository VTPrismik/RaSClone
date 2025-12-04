local inputs = require("inputs")
local player = {
    x = 0, -- Info
    y = 0,
    hitx = 0,
    hity = 0,
    timer = 0,
    invincible = false,

    speed = 500, -- Stats
    health = 5,
    statuseffects = {},
    invincibilitytime = 0.5,
    size = 50,
    hitsize = 10,
    damagemultiplier = 1
}

function player.takedamage(damage)
    if player.invincible == false and damage ~= nil then
        player.invincible = true
        player.timer = player.invincibilitytime
        player.health = player.health - damage * player.damagemultiplier
    end
end

function player.update(dt)
    local w, h = love.graphics.getDimensions()
    local _, direction = inputs.get_current_inputs(input_mode)

    player.x = player.x + direction.x * dt * player.speed -- Movement
    player.y = player.y + direction.y * dt * player.speed

    if player.x < 0 then -- Border collision
        player.x = 0
    end
    if player.x > w - player.size then
        player.x = w - player.size
    end
    if player.y < 0 then
        player.y = 0
    end
    if player.y > h - player.size then
        player.y = h - player.size
    end

    player.hitx = player.x + (player.size - player.hitsize) / 2
    player.hity = player.y + (player.size - player.hitsize) / 2

    if player.timer < 0 then -- Invincibilitytime
        player.invincible = false
    else
    end
    if player.invincible then
        player.timer = player.timer - dt
    end
end

function player.draw()
    love.graphics.circle("fill", player.x + player.size / 2, player.y + player.size / 2, player.size / 2)

    if debug then
        if inputs.button_pressed("basic", input_mode) then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif inputs.button_pressed("ability 1", input_mode) then
            love.graphics.setColor(1, 0, 0)
        elseif inputs.button_pressed("ability 2", input_mode) then
            love.graphics.setColor(0, 1, 0)
        elseif inputs.button_pressed("ability 3", input_mode) then
            love.graphics.setColor(0, 0, 1)
        elseif inputs.button_pressed("extra 1", input_mode) then
            love.graphics.setColor(1, 1, 0)
        elseif inputs.button_pressed("extra 2", input_mode) then
            love.graphics.setColor(1, 0, 1)
        elseif inputs.button_pressed("extra 3", input_mode) then
            love.graphics.setColor(0, 1, 1)
        elseif inputs.button_pressed("interact", input_mode) then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.8, 0.8, 0.8)
        end
        love.graphics.setLineWidth(player.hitsize/3)
        love.graphics.circle("line", player.x + player.size / 2, player.y + player.size / 2, player.hitsize)
        love.graphics.setColor(1, 1, 1)

        love.graphics.print("Player X: " .. player.x .. ", " .. "Player Y: " .. player.y, 0, 45)
        love.graphics.print("Player Hit X: " .. player.hitx .. ", " .. "Player Hit Y: " .. player.hity, 0, 60)
        love.graphics.print("Player Size: " .. player.size .. ", " .. "Player Speed: " .. player.speed, 0, 75)
        love.graphics.print("Player Health: " .. player.health .. ", " .. player.timer, 0, 90)
    end
end

return player