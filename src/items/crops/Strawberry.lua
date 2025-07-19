local Strawberry = {}
Strawberry.__index = Strawberry

Strawberry.id = "strawberry"
Strawberry.is_eatable = true

function Strawberry:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")

    local self = setmetatable({}, Strawberry)
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.is_used = false

    return self
end

function Strawberry:update(dt)

end

function Strawberry:eat()
    self.is_used = true
end

function Strawberry:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Strawberry