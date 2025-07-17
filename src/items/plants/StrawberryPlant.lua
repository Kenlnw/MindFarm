local StrawberryPlant = {}
StrawberryPlant.__index = StrawberryPlant

function StrawberryPlant:load(x, y, flip_x, flip_y)
    Strawberry = require("src.items.crops.Strawberry")
    AnimComponent = require("src.components.AnimComponent")
    
    local self = setmetatable({}, StrawberryPlant)
    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE
    self.state = state

    self.sprites = AnimComponent:load("sprites/Strawberry.png",6, 3, 1, "rows")
    self.sprites.current_anim = self.sprites.anims[2]

    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    self.is_watered = false
    self.days_to_grow = 6
    self.started_day = DAYS
    self.growing_state = 1

    self.can_harvest = false

    return self
end

function StrawberryPlant:update(dt)
    if self.growing_state == self.days_to_grow then
        self.can_harvest = true
    end

    if self.is_watered then
        self:grow()
    end

    self.sprites.current_anim:gotoFrame(self.growing_state)
end

function StrawberryPlant:grow()
    if DAYS - self.started_day < self.days_to_grow  then
        self.growing_state = DAYS - self.started_day + 1
    end
end

function StrawberryPlant:harvest(x, y, flip_x, flip_y)
    if self.can_harvest then
        return Strawberry:load(x, y, flip_x, flip_y)
    end
end

function StrawberryPlant:draw()
    if self.flip_x == -1 then
        self.offset_x = self.sprites.frame_width
    end
    if self.flip_y == -1 then
        self.offset_y = self.sprites.frame_height
    end

    self.sprites:draw_anim(self)
end

return StrawberryPlant