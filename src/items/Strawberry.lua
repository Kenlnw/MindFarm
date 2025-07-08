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

    self.sprites = {
        sprite_sheet = love.graphics.newImage("sprites/spring_crops.png"),
        columns = 14,
        rows = 8,
        duration = 0.2
    }
    self.sprites.anim = AnimComponent:load(self.sprites, "rows")

    self.current_sprite = self.sprites.anim.anims[2]
    self.frame = frame or 8
    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    return self
end

function Strawberry:update(dt)
    self.current_sprite:gotoFrame(self.frame)
    self.current_sprite:update(dt)
end

function Strawberry:draw()
    if self.flip_x == -1 then
        self.offset_x = self.sprites.anim.frame_width
    end
    if self.flip_y == -1 then
        self.offset_y = self.sprites.anim.frame_height        
    end

    self.current_sprite:draw(
        self.sprites.sprite_sheet, 
            self.x, 
            self.y, 
            nil, 
            self.sprite_scale * self.flip_x, 
            self.sprite_scale * self.flip_y, 
            self.offset_x,
            self.offset_y
    )
end

return Strawberry