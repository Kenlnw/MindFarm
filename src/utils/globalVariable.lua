TILE_SCALE = height_scale(3.5)
DAYS = 1
day_changed = false
SLOT_CAPACITY = 64
PREV_CASH = 0
CASH = 0

cash_updated = false

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

item_type_actions = {
    seed = { "Plant", "None" },
    tool = { "Use", "None" },
    crop = { "None", "None" },
    placeable_item = { "Place", "None" }
}

entity_id_actions = {
    chest = { "None",  "Open"  },
    selling_truck = { "None", "Sell"  },
    bed = { "None",  "Sleep" }
}