local HotPepper = {}
HotPepper.__index = HotPepper

HotPepper.id = "hot_pepper"

function HotPepper:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    CropComponent = require("src.components.items.CropComponent")

    local self = setmetatable({}, HotPepper)

    self.name = "Hot Pepper"

    self.class = HotPepper
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/HotPepper.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 85
    self.buy_price = 85

    self.properties = CropComponent:load(self.sell_price)

    return self
end

function HotPepper:update(dt)
    self.properties:update(dt)
end

function HotPepper:draw()
    self.sprite:draw(self.sprite.sprites)
end

return HotPepper