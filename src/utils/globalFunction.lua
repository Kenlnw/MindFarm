function set_color(r, g, b, a)
    local alpha = a or 1
    love.graphics.setColor(r/255, g/255, b/255, alpha)
end

function reset_color()
    set_color(255, 255, 255, 1)
end

function round(n)
    return math.floor(n + 0.5)
end

function is_inside(x, y, rec)
    return x >= rec.x  and x <= rec.x + rec.width and y >= rec.y  and y <= rec.y + rec.height
end

function is_rec_to_rec(rec1, rec2)
    return rec1.x + rec1.width >= rec2.x and rec1.x <= rec2.x + rec2.width and rec1.y + rec1.height >= rec2.y and rec1.y <= rec2.y + rec2.height
end

function key_set_state(key)
    key_states[key] = true
    key_current_state.is_using = true
    key_current_state.key = key
end

function is_key_down(key)
    return key_states[key] == true
end

function key_clear_state(key)
    key_states[key] = false
    key_current_state.is_using = false
    key_current_state.key = nil
end

function mouse_set_state(x, y, button)
    mouse_states[button] = true
    mouse_current_state.x = x
    mouse_current_state.y = y
    mouse_current_state.button = button
end

function is_mouse_down(button)
    return mouse_states[button] == true and not mouse_current_state.is_using
end

function mouse_clear_state(button)
    mouse_states[button] = false
    mouse_current_state.x = nil
    mouse_current_state.y = nil
    mouse_current_state.button = nil
    mouse_current_state.is_using = false
end

function change_game_states(state)
    game_states["menu"] = state == "menu"
    game_states["paused"] = state == "paused"
    game_states["running"] = state == "running"
    game_states["ended"] = state == "ended"
end

function distance_between(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function change_days()
    DAYS = DAYS + 1
    day_changed = true
end

function update_mouse_position(camera)
    if camera then
        mouse_position.x, mouse_position.y = camera:mousePosition()
    else
        mouse_position.x, mouse_position.y = nil, nil
    end
end