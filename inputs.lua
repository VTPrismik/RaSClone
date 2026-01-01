local inputs = {}
local pressedkeys = {}
local pressedbuttons = {}
local joystick = love.joystick.getJoysticks()[1]

function normalize(vector)
    local length = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
    if length > 0.7 then
        return {x = vector.x / length, y = vector.y / length}
    else
        return vector
    end
end

function inputs.button_pressed (button, inputmode, id)
    for _, value in ipairs(inputs.get_current_inputs(inputmode, id)) do
        if value == button then
            return true
        else
            return false
        end
    end
end

-- Keyboard Map
    local keyboard_movement_map = {
        ["w"] = {x = 0, y = -1}, -- up
        ["s"] = {x = 0, y = 1}, -- down
        ["a"] = {x = -1, y = 0}, -- left
        ["d"] = {x = 1, y = 0}, -- right
    }

    local keyboard_action_map = {
        ["space"] = "basic",
        ["1"] = "ability 1",
        ["2"] = "ability 2",
        ["3"] = "ability 3",
        ["q"] = "extra 1",
        ["e"] = "extra 2",
        ["r"] = "ult",
        ["f"] = "interact",
        -- Keyboard Specific
        ["f11"] = "fullscreen",
        ["f10"] = "debug"
    }

    function love.keypressed(key)
        pressedkeys[key] = true
    end

    function love.keyreleased(key)
        pressedkeys[key] = nil
    end

    function keyboard_inputs()
        local currentdirection = {x = 0, y = 0}
        local currentactions = {}

        for key, direction in pairs(keyboard_movement_map) do
            if pressedkeys[key] then
                currentdirection.x = currentdirection.x + direction.x
                currentdirection.y = currentdirection.y + direction.y
            end
        end

        for key, action in pairs(keyboard_action_map) do
            if pressedkeys[key] then
                table.insert(currentactions, action)
            end
        end

        return currentactions, normalize(currentdirection)
    end

-- Controller Map
    local gamepad_action_map = {
        ["a"] = "basic",
        ["x"] = "ability 1",
        ["y"] = "ability 2",
        ["b"] = "ability 3",
        ["dpleft"] = "extra 1",
        ["dpup"] = "extra 2",
        ["dpright"] = "ult",
        ["dpdown"] = "interact",
    }

    function love.gamepadpressed(joystickobj, button)
        if joystickobj == joystick then
            pressedbuttons[button] = true
        end
    end

    function love.gamepadreleased(joystickobj, button)
        if joystickobj == joystick then
            pressedbuttons[button] = nil
        end
    end

    function gamepad_inputs()
        local currentactions = {}
        local currentdirection = {x = 0, y = 0}
        local deadzone = 0.15

        if joystick and joystick:isConnected() and joystick:isGamepad() then

            local x = joystick:getGamepadAxis("leftx")
            local y = joystick:getGamepadAxis("lefty")

            if math.abs(x) < deadzone then x = 0 end
            if math.abs(y) < deadzone then y = 0 end

            currentdirection.x = x
            currentdirection.y = y

            for button, action in pairs(gamepad_action_map) do
                if pressedbuttons[button] then
                    table.insert(currentactions, action)
                end
            end
        end

        return currentactions, normalize(currentdirection)
    end

function inputs.get_current_inputs(inputmode, id)
    inputlist = {}

    if inputmode == "Keyboard" then
        return keyboard_inputs()
    elseif inputmode == "Controller" then
        if id == 2 then -- temporary just to test 2 inputs without setting up networking
            print("AAA")
            return keyboard_inputs()
        end
        return gamepad_inputs()
    else
        print("Invalid input mode (" .. inputmode .. ")")
        return keyboard_inputs()
    end
end

return inputs