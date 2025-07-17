local Strawberry = {}
Strawberry.__index = Strawberry

function Strawberry:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    
    local self = setmetatable({}, Strawberry)
    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE

    self.sprites = AnimComponent:load("sprites/Strawberry.png",6, 3, 1, "rows")

    self.sprites.current_anim = self.sprites.anims[3]
    self.sprites.current_anim:gotoFrame(1)

    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    return self
end

function Strawberry:update(dt)

end

function Strawberry:draw()
    if self.flip_x == -1 then
        self.offset_x = self.sprites.frame_width
    end
    if self.flip_y == -1 then
        self.offset_y = self.sprites.frame_height
    end

    self.sprites:draw_anim(self)
end

return Strawberry