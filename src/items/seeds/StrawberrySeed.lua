local StrawberrySeed = {}
StrawberrySeed.__index = StrawberrySeed

StrawberrySeed.id = "StrawberrySeed"
StrawberrySeed.is_plantable = true

function StrawberrySeed:load(x, y, flip_x, flip_y)
    StrawberryPlant = require("src.items.plants.StrawberryPlant")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")

    local self = setmetatable({}, StrawberrySeed)
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.is_used = false

    return self
end

function StrawberrySeed:plant_crop(x, y, flip_x, flip_y)
    self.is_used = true
    return StrawberryPlant:load(x, y, flip_x, flip_y)
end

function StrawberrySeed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return StrawberrySeed