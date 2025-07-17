local StrawberrySeed = {}
StrawberrySeed.__index = StrawberrySeed

StrawberrySeed.id = "StrawberrySeed"
StrawberrySeed.is_plantable = true

function StrawberrySeed:load(x, y, flip_x, flip_y)
    StrawberryPlant = require("src.items.plants.StrawberryPlant")
    AnimComponent = require("src.components.AnimComponent")
    
    local self = setmetatable({}, StrawberrySeed)
    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE

    self.sprite = AnimComponent:load("sprites/Strawberry.png",6, 3, 1, "rows")
    self.sprite.current_anim = self.sprite.anims[1]
    self.sprite.current_anim:gotoFrame(1)

    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    self.is_used = false

    return self
end

function StrawberrySeed:plant_crop(x, y, flip_x, flip_y)
    self.is_used = true
    return StrawberryPlant:load(x, y, flip_x, flip_y)
end

function StrawberrySeed:draw()
    if self.flip_x == -1 then
        self.offset_x = self.sprites.frame_width
    end
    if self.flip_y == -1 then
        self.offset_y = self.sprites.frame_height
    end

    self.sprite:draw_anim(self)
end

return StrawberrySeed