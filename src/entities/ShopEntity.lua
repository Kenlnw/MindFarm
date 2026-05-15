local ShopEntity = {}
ShopEntity.__index = ShopEntity

ShopEntity.id = "shop_entity"

function ShopEntity:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    EntityComponent = require("src.components.items.EntityComponent")
    StorageComponent = require("src.components.ui.StorageComponent")

    local self = setmetatable({}, ShopEntity)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/entities/Shop.png", 1, 1, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = EntityComponent:load(self.sprite)
    self.shop = StorageComponent:load("Shop", 4, 2)
    self.max_items_per_slot = 20
    self:init_items()

    local panel_x = self.shop.x - height_scale(16)
    local panel_w = self.shop.cols * (self.shop.slot_width + self.shop.padding) - self.shop.padding + height_scale(32)
    local label_height = height_scale(50)
    self.price_label = TextBoxComponent:load(
        " 0",
        panel_x,
        self.shop.y + self.shop.total_height + height_scale(8),
        panel_w,
        label_height,
        6 * TILE_SCALE
    )
    self.price_label:set_icon("sprites/items/Cash.png", TILE_SCALE/1.5)

    return self
end

function ShopEntity:init_items()
    for idx, item in ipairs(items_for_shop["Init"]) do
        local slot = self.shop.slots[idx]

        if slot then
            slot:clear_item()
            slot:store_item(item.class:load(slot.x, slot.y), math.random(self.max_items_per_slot), self.max_items_per_slot)
        end
    end
end

function ShopEntity:restore_items()
    if shop_restock then return end

    self:init_items()
    shop_restock = true
end

function ShopEntity:shop_update(dt, player)
    local shop = self.shop

    if not shop.is_open then return end

    -- close on E
    if is_key_down("e") then
        shop:close()
        key_clear_state("e")
        return
    end

    for _, slot in ipairs(shop.slots) do
        slot:update(dt)
    end

    cash_updated = false

    local mx, my = love.mouse.getPosition()

    -- Update the price_label
    for _, slot in ipairs(shop.slots) do
         if is_inside(mx, my, slot) and slot.item then
            self.price_label:change_text(" " .. slot.item.buy_price)
            break
         else
            self.price_label:change_text(" ")
         end
    end

    --
    for _, slot in ipairs(shop.slots) do
        if is_inside(mx, my, slot) and is_mouse_down(1) and slot.item and slot.item.buy_price <= CASH then
            mouse_clear_state(1)

            if cash_updated or player.interface.slot_bar.inventory_fulled then return end

            shop:withdraw(player, slot, false)
            CASH = CASH - slot.item.buy_price
            cash_updated = true

            return
        end
    end

    player.interface:cash_animation(dt)
end

function ShopEntity:update(dt, player)
    self:shop_update(dt, player)
    self.properties:update(dt, self.sprite, function()
        if is_mouse_down(2) or is_key_down("e") then
            self.shop:open()
            key_clear_state("e")
            mouse_clear_state(2)
        end
    end)
end

function ShopEntity:draw()
    self.properties:draw(self.sprite)
end

function ShopEntity:price_label_draw()
    if not self.shop.is_open then return end
    self.price_label:draw_with_icon(42, 28, 10, 255, 200, 80, 0.85, 1, 6, "left")
end

return ShopEntity