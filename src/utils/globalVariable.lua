TILE_SCALE = height_scale(3.5)
DAYS = 1
day_changed = false
SLOT_CAPACITY = 64
PREV_CASH = 0
CASH = 0
TEXT_FONT = "fonts/Amasis MT Std Black.ttf"

cash_updated = false
shop_restock = true

game_states = {
    paused = false,
    running = false,
    menu = false
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
    button = nil,
    is_using = false
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
        { class =  require("src.items.seeds.PotatoSeed"), item_amount = 20, capacity = SLOT_CAPACITY }
    },
    Tools = {
        { class = require("src.items.tools.Hoe"), item_amount = 1, capacity = 1 },
        { class = require("src.items.tools.WaterCan"), item_amount = 1, capacity = 1 },
        { class = require("src.items.Bed"), item_amount = 1, capacity = 1 }
    }
}

items_for_player = {}

items_for_shop = {
    Init = {
        { class = require("src.items.seeds.StrawberrySeed") },
        { class =  require("src.items.seeds.PotatoSeed") },
        { class = require("src.items.seeds.LeekSeed") },
        { class = require("src.items.seeds.HotPepperSeed") },
        { class = require("src.items.crops.Strawberry") },
        { class =  require("src.items.crops.Potato") },
        { class = require("src.items.crops.Leek") },
        { class = require("src.items.crops.HotPepper") }
    }
}