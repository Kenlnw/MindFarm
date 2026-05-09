local Potato = {}
Potato.__index = Potato

Potato.id = "potato"

function Potato:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    CropComponent = require("src.components.items.CropComponent")

    local self = setmetatable({}, Potato)

    self.class = Potato
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Potato.png", 4, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 100

    self.properties = CropComponent:load(self.sell_price)

    return self
end

function Potato:update(dt)
    self.properties:update(dt)
end

function Potato:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Potato