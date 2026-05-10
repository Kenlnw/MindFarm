local SellingTruckEntity = {}
SellingTruckEntity.__index = SellingTruckEntity

SellingTruckEntity.id = "selling_truck_entity"

function SellingTruckEntity:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    EntityComponent = require("src.components.items.EntityComponent")
    StorageComponent = require("src.components.ui.StorageComponent")
    TextBoxComponent = require("src.components.ui.TextboxComponent")

    local self = setmetatable({}, SellingTruckEntity)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/entities/SellingTruck.png", 1, 1, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = EntityComponent:load(self.sprite)

    self.storage = StorageComponent:load(
        "Selling Truck",
        5,
        1,
        { "crop", "seed" }
    )

    local panel_x = self.storage.x - height_scale(16)
    local panel_w = self.storage.cols * (self.storage.slot_width + self.storage.padding) - self.storage.padding + height_scale(32)
    local label_height = height_scale(50)
    self.cash_label = TextBoxComponent:load(
        "Total: 0 G",
        panel_x,
        self.storage.y + self.storage.total_height + height_scale(8),
        panel_w,
        label_height,
        6 * TILE_SCALE
    )
    self.cash_label:set_icon("sprites/items/Cash.png", TILE_SCALE/1.5)

    self.cash_per_day = 0

    return self
end

function SellingTruckEntity:cash_calculate()
    local total_cash = 0

    for _, slot in ipairs(self.storage.slots) do
        if slot and slot.item then
            total_cash = total_cash + (slot.item.properties.sell_price * slot.item_amount)
        end
    end

    return total_cash
end

function SellingTruckEntity:cash_update()
    if cash_updated then return end

    -- Increase player's money
    CASH = CASH + self.cash_per_day
    self.cash_per_day = 0
    cash_updated = true

    -- Delete all items in slorage
    for _, slot in ipairs(self.storage.slots) do
        if slot and slot.item then
            slot.item = nil
            slot.item_amount = 0
        end
    end
end

function SellingTruckEntity:update(dt, player)
    self.properties:update(dt, self.sprite, function()
        if is_mouse_down(2) then
            self.storage:open()
            mouse_clear_state(2)
        end
    end)
    self.storage:update(dt, player)

    self.cash_per_day = self:cash_calculate()
    self.cash_label:change_text(" " .. self.cash_per_day)
end

function SellingTruckEntity:draw()
    self.properties:draw(self.sprite)
end

function SellingTruckEntity:cash_label_draw()
    if not self.storage.is_open then return end
    self.cash_label:draw_with_icon(42, 28, 10, 255, 200, 80, 0.85, 1, 6, "left")
end

return SellingTruckEntity