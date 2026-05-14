local SlotBar = {}
SlotBar.__index = SlotBar

function SlotBar:load()
    StrawberrySeed = require("src.items.seeds.StrawberrySeed")
    Strawberry = require("src.items.crops.Strawberry")
    WaterCan = require("src.items.tools.WaterCan")
    Hoe = require("src.items.tools.Hoe")
    Bed = require("src.items.Bed")
    SlotComponent = require("src.components.ui.SlotComponent")

    local self = setmetatable({}, SlotBar)

    self.max_slots = 5
    self.slots = {}
    self.slot_width = 16*TILE_SCALE
    self.slot_height = 16*TILE_SCALE

    self.offset_x = height_scale(5)
    self.offset_y = height_scale(5)

    self.x = 0
    self.y = love.graphics.getHeight() - (self.slot_height + self.offset_y)

    self:load_slots()

    self.current_slot_id = self.slots[1].id
    self:find_slots()

    self.inventory_fulled = false

    return self
end

function SlotBar:find_slots()
    for _, slot in ipairs(self.slots) do
        if self.current_slot_id == slot.id then
            slot.is_selected = true
        else
            slot.is_selected = false
        end
    end
end

function SlotBar:load_slots()
    local slot_x = self.x + self.offset_x * 2

    for i = 1, self.max_slots do
        local id = i - 1
        self.slots[i] = SlotComponent:load(slot_x, self.y, self.slot_width, self.slot_height, id, nil)
        slot_x = slot_x + self.slots[i].width + self.offset_x
    end

    for idx, item in ipairs(items_for_player["Init"]) do
        local slot = self.slots[idx]
        if slot then
            slot:store_item(item.class:load(slot.x, slot.y), item.item_amount, item.capacity)
        end
    end
end

function SlotBar:update(dt)
    local slot_used_count = 0
    for _, slot in ipairs(self.slots) do
        slot:update(dt)
        if slot.item then
            slot_used_count = slot_used_count + 1
        end
    end

    if slot_used_count == self.max_slots then
        self.inventory_fulled = true
    else
        self.inventory_fulled = false
    end

    if is_key_down("right") then
        self:change_slot_slide("right")
        key_clear_state("right")
    elseif is_key_down("left") then
        self:change_slot_slide("left")
        key_clear_state("left")
    end

    if tonumber(key_current_state.key) ~= null then
        self:change_slot_at(tonumber(key_current_state.key))
        key_clear_state(key_current_state.key)
    end
end

function SlotBar:change_slot_slide(direction)
    if direction == "right" then
        self.current_slot_id = (self.current_slot_id + 1) % self.max_slots
    elseif direction == "left" then
        self.current_slot_id = (self.max_slots + (self.current_slot_id - 1)) % self.max_slots
    end
    self:find_slots()
end

function SlotBar:change_slot_at(num)
    if num <= self.max_slots then
        self.current_slot_id = num - 1
        self:find_slots()
    end
end

function SlotBar:draw()
    for i = 1, self.max_slots do
        self.slots[i]:draw()
    end
end

return SlotBar