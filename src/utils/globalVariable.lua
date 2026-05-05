TILE_SCALE = height_scale(3.5)
DAYS = 1
day_changed = false
SLOT_CAPACITY = 64

game_states = {
    menu = true,
    paused = false,
    running = false,
    ended = false
}

key_states = {}
key_current_state = {
    is_using = false,
    key = nil
}

mouse_states = {}
mouse_current_state = {
    x = nil,
    y = nil,
    button = nil
}

mouse_position = {
    x = nil,
    y = nil
}

entities = {}