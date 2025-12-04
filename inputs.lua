local inputs = {}
local pressed_keys = {}
local pressed_buttons = {}
local joystick = love.joystick.getJoysticks()[1]

function normalize(vector)
    local length = math.sqrt(vector.x^2 + vector.y^2)
    if length > 0 then
        return {x = vector.x / length, y = vector.y / length}
    else
        return {x = 0, y = 0}
    end
end

function inputs.button_pressed (button, input_mode)
    for _, value in ipairs(inputs.get_current_inputs(input_mode)) do
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
        ["j"] = "ability 1",
        ["k"] = "ability 2",
        ["l"] = "ability 3",
        ["q"] = "extra 1",
        ["e"] = "extra 2",
        ["r"] = "extra 3",
        ["f"] = "interact",
        ["f11"] = "fullscreen",
        ["f10"] = "debug"
    }

    function love.keypressed(key)
        pressed_keys[key] = true
    end

    function love.keyreleased(key)
        pressed_keys[key] = nil
    end

    function keyboard_inputs()
        local current_direction = {x = 0, y = 0}
        local current_actions = {}

        for key, direction in pairs(keyboard_movement_map) do
            if pressed_keys[key] then
                current_direction.x = current_direction.x + direction.x
                current_direction.y = current_direction.y + direction.y
            end
        end

        for key, action in pairs(keyboard_action_map) do
            if pressed_keys[key] then
                table.insert(current_actions, action)
            end
        end

        return current_actions, normalize(current_direction)
    end

-- Controller Map
    local gamepad_action_map = {
        ["a"] = "basic",
        ["x"] = "ability 1",
        ["y"] = "ability 2",
        ["b"] = "ability 3",
        ["dpleft"] = "extra 1",
        ["dpup"] = "extra 2",
        ["dpright"] = "extra 3",
        ["dpdown"] = "interact",
    }

    function love.gamepadpressed(joystick_obj, button)
        if joystick_obj == joystick then
            pressed_buttons[button] = true
        end
    end

    function love.gamepadreleased(joystick_obj, button)
        if joystick_obj == joystick then
            pressed_buttons[button] = nil
        end
    end

    function gamepad_inputs()
        local current_actions = {}
        local current_direction = {x = 0, y = 0}
        local deadzone = 0.15

        if joystick and joystick:isConnected() and joystick:isGamepad() then

            local x = joystick:getGamepadAxis("leftx")
            local y = joystick:getGamepadAxis("lefty")

            if math.abs(x) < deadzone then x = 0 end
            if math.abs(y) < deadzone then y = 0 end

            current_direction.x = x
            current_direction.y = y

            for button, action in pairs(gamepad_action_map) do
                if pressed_buttons[button] then
                    table.insert(current_actions, action)
                end
            end
        end

        return current_actions, normalize(current_direction)
    end

function inputs.get_current_inputs(input_mode)
    if input_mode == "Keyboard" then
        return keyboard_inputs()
    elseif input_mode == "Controller" then
        return gamepad_inputs()
    else
        return keyboard_inputs()
    end
end

return inputs