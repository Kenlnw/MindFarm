local SlotBar = {}
SlotBar.__index = SlotBar

function SlotBar:load()
    Strawberry = require("src.items.Strawberry")
    SlotComponent = require("src.components.SlotComponent")

    local self = setmetatable({}, SlotBar)

    self.max_slots = 5
    self.slots = {}
    self.slot_width = 64
    self.slot_height = 64

    self.offset_x = 5
    self.offset_y = 5

    self.x = 0
    self.y = love.graphics.getHeight() - (self.slot_height + self.offset_y)

    self:load_slots()

    self.current_slot_id = self.slots[1].id
    self:find_slots()

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

        local item = Strawberry:load(slot_x, self.y)
        if i ~= 1 then
            item = nil
        end

        self.slots[i] = SlotComponent:load(slot_x, self.y, self.slot_width, self.slot_height, id, item)

        slot_x = slot_x + self.slots[i].width + self.offset_x
    end
end

function SlotBar:update(dt)
    for _, slot in ipairs(self.slots) do
        slot:update(dt)
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