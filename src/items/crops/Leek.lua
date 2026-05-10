local Leek = {}
Leek.__index = Leek

Leek.id = "leek"

function Leek:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    CropComponent = require("src.components.items.CropComponent")

    local self = setmetatable({}, Leek)

    self.name = "Leek"

    self.class = Leek
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/Leek.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 250

    self.properties = CropComponent:load(self.sell_price)

    return self
end

function Leek:update(dt)
    self.properties:update(dt)
end

function Leek:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Leek