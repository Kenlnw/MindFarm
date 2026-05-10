local Strawberry = {}
Strawberry.__index = Strawberry

Strawberry.id = "strawberry"

function Strawberry:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    CropComponent = require("src.components.items.CropComponent")

    local self = setmetatable({}, Strawberry)

    self.class = Strawberry
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 200

    self.properties = CropComponent:load(self.sell_price)

    return self
end

function Strawberry:update(dt)
    self.properties:update(dt)
end



function Strawberry:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Strawberry