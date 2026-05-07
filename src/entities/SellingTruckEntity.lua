local SellingTruckEntity = {}
SellingTruckEntity.__index = SellingTruckEntity

SellingTruckEntity.id = "selling_truck_entity"

function SellingTruckEntity:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    EntityComponent = require("src.components.items.EntityComponent")
    StorageComponent = require("src.components.ui.StorageComponent")

    local self = setmetatable({}, SellingTruckEntity)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/SellingTruck.png", 1, 1, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = EntityComponent:load(self.sprite)

    self.storage = StorageComponent:load(
        "Selling Truck",
        5,
        1,
        {
            "crop",
            "seed"
        })

    return self
end

function SellingTruckEntity:update(dt, player)
    self.properties:update(dt, self.sprite, function()
        if is_mouse_down(2) then
            self.storage:open()
            mouse_clear_state(2)
        end
    end)
    self.storage:update(dt, player)
end

function SellingTruckEntity:draw()
    self.properties:draw(self.sprite)
end

return SellingTruckEntity