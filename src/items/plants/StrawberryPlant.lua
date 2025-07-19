local StrawberryPlant = {}
StrawberryPlant.__index = StrawberryPlant

function StrawberryPlant:load(x, y, flip_x, flip_y)
    Strawberry = require("src.items.crops.Strawberry")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")

    local self = setmetatable({}, StrawberryPlant)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[2]

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

    self.sprite.sprites.current_anim:gotoFrame(self.growing_state)
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
    self.sprite:draw(self.sprite.sprites)
end

return StrawberryPlant