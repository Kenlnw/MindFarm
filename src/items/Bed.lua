local Bed = {}
Bed.__index = Bed

function Bed:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")

    local self = setmetatable({}, Bed)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[3]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = {}

    return self
end

function Bed:update(dt)

end

function Bed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Bed