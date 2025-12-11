local player = require("player")
local hitbox = {
}
local attacks = {
    rectanglehitboxes = {},
    circlehitboxes = {}
}

function attacks.createrectanglehitbox(x, y, sizex, sizey, chargetime, linger, invert)
    table.insert(attacks.rectanglehitboxes, {x = x, y = y, sizex = sizex, sizey = sizey, chargetime = chargetime, linger = linger, inverted = invert})
end

function attacks.createcirclehitbox(x, y, radius, chargetime, linger, invert)
    table.insert(attacks.circlehitboxes, {x = x, y = y, radius = radius, chargetime = chargetime, linger = linger, inverted = invert})
end

function attacks.createshearhitbox(direction)
    if direction == "left" then
        attacks.createrectanglehitbox(0, 0, player.hitx + player.hitsize / 2, 100, 0, 0)
    end
end

function attacks.isinhitbox()
    -- Rectangle
    for _, tab in ipairs(attacks.rectanglehitboxes) do
        if player.hitx + player.hitsize > tab.x and player.hitx < tab.x + tab.sizex and player.hity + player.hitsize > tab.y and player.hity < tab.y + tab.sizey then
            return true
        end
    end
    -- Circle
    for _, tab in ipairs(attacks.circlehitboxes) do
        local distance = math.sqrt((tab.x - player.hitx) ^ 2 + (tab.y - player.hity) ^ 2)
        if distance < tab.radius - player.hitsize / 2 then
            return true
        end
    end
    return false
end

function attacks.update(dt)
    if attacks.isinhitbox() then
        player.takedamage(1)
    end
end

function attacks.draw()
    -- Hitboxes
        if attacks.rectanglehitboxes == nil then
            return
        end
        for _, tab in ipairs(attacks.rectanglehitboxes) do
            love.graphics.rectangle("fill", tab.x, tab.y, tab.sizex, tab.sizey)
        end
        for _, tab in ipairs(attacks.circlehitboxes) do
            love.graphics.circle("fill", tab.x, tab.y, tab.radius)
        end

    love.graphics.setColor(1, 1, 1)
    if debug then
        love.graphics.print("Time: " .. elapsedtime, 0, 120)
    end
end

return attacks, hitbox