TILE_SCALE = height_scale(3.5)
DAYS = 1
day_changed = false
SLOT_CAPACITY = 64
PREV_CASH = 0
CASH = 0
TEXT_FONT = "fonts/Amasis MT Std Black.ttf"

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

items_for_chest = {
    Seeds = {
        { class = require("src.items.seeds.StrawberrySeed"), item_amount = 20, capacity = SLOT_CAPACITY },
        { class =  require("src.items.seeds.PotatoSeed"), item_amount = 20, capacity = SLOT_CAPACITY },
        { class = require("src.items.seeds.LeekSeed"), item_amount = 20, capacity = SLOT_CAPACITY },
        { class = require("src.items.seeds.HotPepperSeed"), item_amount = 20, capacity = SLOT_CAPACITY }
    },
    Tools = {
        { class = require("src.items.tools.Hoe"), item_amount = 1, capacity = 1 },
        { class = require("src.items.tools.WaterCan"), item_amount = 1, capacity = 1 },
        { class = require("src.items.Bed"), item_amount = 1, capacity = 1 }
    }
}

items_for_player = {
    Start = {
        { class = require("src.items.seeds.StrawberrySeed"), item_amount = SLOT_CAPACITY, capacity = SLOT_CAPACITY }
    }
}