local Strawberry = {}
Strawberry.__index = Strawberry

Strawberry.id = "strawberry"
Strawberry.is_plantable = true

function Strawberry:load(x, y, frame, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    require("src.utils")
    local self = setmetatable({}, Strawberry)
    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE

    self.sprites = AnimComponent:load("sprites/spring_crops.png", 14, 8, 1, "rows")

    self.sprites.current_anim = self.sprites.anims[2]
    self.frame = frame or 8
    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    return self
end

function Strawberry:update(dt)
    self.sprites.current_anim:gotoFrame(self.frame)
    self.sprites.current_anim:update(dt)
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