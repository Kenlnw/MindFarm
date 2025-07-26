SpriteComponent = {}
SpriteComponent.__index = SpriteComponent

function SpriteComponent:load(x, y, flip_x, flip_y, offset_x, offset_y)
    AnimComponent = require("src.components.AnimComponent")

    local self = setmetatable({}, SpriteComponent)

    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE
    self.sprites = {}
    self.flip = { x = flip_x or 1, y = flip_y or 1 }
    self.offset = { x = offset_x or 0, y = offset_y or 0 }
    self.width = nil
    self.height = nil

    return self
end

function SpriteComponent:set_size(width, height)
    self.width, self.height = width, height
end

function SpriteComponent:update_position(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function SpriteComponent:draw(sprites)
    if sprites then
        sprites:draw_anim(self)
    end
end

return SpriteComponent