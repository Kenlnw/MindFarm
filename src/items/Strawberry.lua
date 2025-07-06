local Strawberry = {}
Strawberry.__index = Strawberry

function Strawberry:load(x, y)
    AnimComponent = require("src.components.AnimComponent")
    require("src.utils")
    local self = setmetatable({}, Strawberry)
    self.x = x
    self.y = y
    self.sprite_scale = TILE_SCALE

    self.sprites = {
        sprite_sheet = love.graphics.newImage("sprites/spring_crops.png"),
        columns = 14,
        rows = 4,
        duration = 0.2
    }
    self.sprites.anim = AnimComponent:load(self.sprites, "rows")

    self.current_sprite = self.sprites.anim.anims[1]

    return self
end

function Strawberry:update(dt)
    self.current_sprite:gotoFrame(8)
    self.current_sprite:update(dt)

end

function Strawberry:draw()
    self.current_sprite:draw(
        self.sprites.sprite_sheet, 
            self.x, 
            self.y, 
            nil, 
            self.sprite_scale, 
            self.sprite_scale, 
            self.sprites.anim.frame_width/2,
            self.sprites.anim.frame_height/2
    )
end

return Strawberry