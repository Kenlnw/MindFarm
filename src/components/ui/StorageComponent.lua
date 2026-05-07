local StorageComponent = {}
StorageComponent.__index = StorageComponent

function StorageComponent:load(title, cols, rows, allowed_types)
    SlotComponent = require("src.components.ui.SlotComponent")
    TextBoxComponent = require("src.components.ui.TextboxComponent")

    local self = setmetatable({}, StorageComponent)

    self.title = title or "Storage"

    self.cols = cols or 5
    self.rows = rows or 3
    self.max_slots = self.cols * self.rows

    self.slot_width = 16 * TILE_SCALE
    self.slot_height = 16 * TILE_SCALE
    self.padding = height_scale(8)
    self.is_open = false

    -- center the storage UI on screen
    local total_width = self.cols * (self.slot_width + self.padding) - self.padding
    local total_height = self.rows * (self.slot_height + self.padding) - self.padding
    self.x = math.floor((love.graphics.getWidth() - total_width) / 2)
    self.y = math.floor((love.graphics.getHeight() - total_height) / 2)

    local panel_x = self.x - height_scale(16)
    local panel_w = self.cols * (self.slot_width + self.padding) - self.padding + height_scale(32)
    local label_height = height_scale(24)
    self.title_label = TextBoxComponent:load(
        self.title,
        panel_x,
        self.y - height_scale(16) - label_height,
        panel_w,
        label_height,
        5 * TILE_SCALE
    )

    self.slots = self:create_slots()

    self.allowed_types = allowed_types or nil

    return self
end

function StorageComponent:create_slots()
    local id = 0
    local slots = {}
    for row = 0, self.rows - 1 do
        for column = 0, self.cols - 1 do
            local sx = self.x + column * (self.slot_width + self.padding)
            local sy = self.y + row * (self.slot_height + self.padding)
            slots[id + 1] = SlotComponent:load(sx, sy, self.slot_width, self.slot_height, id, nil)
            id = id + 1
        end
    end

    return slots
end

function StorageComponent:open()
    self.is_open = true
    change_game_states("paused")
end

function StorageComponent:close()
    self.is_open = false
    change_game_states("running")
end

function StorageComponent:toggle()
    self.is_open = not self.is_open
end

-- transfer item from slot "b" into first available slots "a"
function StorageComponent:transfer(slots_a, slot_b, shift_held)
    if not slot_b.item then return end

    for _, slot_a in ipairs(slots_a) do
        if slot_a.item and slot_a.item.id == slot_b.item.id and slot_a.item_amount < slot_a.capacity then
            slot_a.item_amount = slot_a.item_amount + 1
            slot_b.item_amount = slot_b.item_amount - 1

            if slot_b.item_amount == 0 then
                slot_b.item = nil
            end
            return
        end
    end

    -- place in empty slot
    for _, slot_a in ipairs(slots_a) do
        if not slot_a.item then
            slot_a:store_item(slot_b.item.class:load(slot_a.x, slot_a.y), 1, slot_b.capacity)
            slot_b.item_amount = slot_b.item_amount - 1

            if slot_b.item_amount == 0 then
                slot_b.item = nil
            end
            return
        end
    end
end

function StorageComponent:compact()
    local stored_items = {}

    for _, slot in ipairs(self.slots) do
        if slot.item then
            table.insert(stored_items, {
                item = slot.item,
                item_amount = slot.item_amount,
                capacity = slot.capacity
            })
            slot.item = nil
            slot.item_amount = 0
        end
    end

    for idx, stored_item in ipairs(stored_items) do
        local slot = self.slots[idx]
        slot:store_item(stored_item.item.class:load(slot.x, slot.y), stored_item.item_amount, stored_item.capacity)
    end
end

function StorageComponent:deposit(player_slot)
    self:transfer(self.slots, player_slot)
end

function StorageComponent:withdraw(player, storage_slot)
    self:transfer(player.slot_bar.slots, storage_slot)
    self:compact()
end

function StorageComponent:filter(selected_slot)
    if self.allowed_types then
        if not selected_slot.item then return false end
        for _, allowed_type in ipairs(self.allowed_types) do
            if selected_slot.item.properties.type == allowed_type then
                return true
            end
        end
        return false
    else
        return true
    end
end

function StorageComponent:update(dt, player)
    if not self.is_open then return end

    -- close on E
    if is_key_down("e") then
        self:close()
        key_clear_state("e")
        return
    end

    for _, slot in ipairs(self.slots) do
        slot:update(dt)
    end

    if is_mouse_down(1) then
        local mx, my = love.mouse.getPosition()

        -- click on storage slot -> withdraw to player
        for _, storage_slot in ipairs(self.slots) do
            if is_inside(mx, my, storage_slot)then
                self:withdraw(player, storage_slot)
                mouse_clear_state(1)
                return
            end
        end

        -- click on player slot -> deposit to storage
        for _, player_slot in ipairs(player.slot_bar.slots) do
            if is_inside(mx, my, player_slot) and self:filter(player_slot) then
                self:deposit(player_slot)
                mouse_clear_state(1)
                return
            end
        end
    end
end

function StorageComponent:draw(player)
    if not self.is_open then return end

    local total_width = self.cols * (self.slot_width + self.padding) - self.padding
    local total_height = self.rows * (self.slot_height + self.padding) - self.padding
    local bg_padding = height_scale(16)

    -- background panel
    set_color(0, 0, 0, 0.5)
    love.graphics.rectangle(
        "fill",
        self.x - bg_padding,
        self.y - bg_padding,
        total_width + bg_padding * 2,
        total_height + bg_padding * 2,
        10
    )
    reset_color()

    -- title above panel
    self.title_label:draw(0, 0, 0, 255, 255, 255, 0, 1, 0)

    -- storage slots
    for _, slot in ipairs(self.slots) do
        slot:draw()
    end

    if self.allowed_types then
        for _, player_slot in ipairs(player.slot_bar.slots) do
            if not self:filter(player_slot) then
                set_color(255, 255, 100, 0.25)
                love.graphics.rectangle("fill", player_slot.x, player_slot.y, player_slot.width, player_slot.height)
                reset_color()
            end
        end
    end
end

return StorageComponent