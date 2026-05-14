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
    self.shop = StorageComponent:load("Shop", 4, 1)

    local panel_x = self.shop.x - height_scale(16)
    local panel_w = self.shop.cols * (self.shop.slot_width + self.shop.padding) - self.shop.padding + height_scale(32)
    local label_height = height_scale(50)
    self.cash_label = TextBoxComponent:load(
        " 0",
        panel_x,
        self.shop.y + self.shop.total_height + height_scale(8),
        panel_w,
        label_height,
        6 * TILE_SCALE
    )
    self.cash_label:set_icon("sprites/items/Cash.png", TILE_SCALE/1.5)


    return self
end

function ShopEntity:update(dt, player)
    self.shop:update(dt, player)
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

function ShopEntity:cash_label_draw()
    if not self.shop.is_open then return end
    self.cash_label:draw_with_icon(42, 28, 10, 255, 200, 80, 0.85, 1, 6, "left")
end

return ShopEntity