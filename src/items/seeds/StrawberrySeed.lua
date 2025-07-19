local StrawberrySeed = {}
StrawberrySeed.__index = StrawberrySeed

StrawberrySeed.id = "StrawberrySeed"

function StrawberrySeed:load(x, y, flip_x, flip_y)
    StrawberryPlant = require("src.items.plants.StrawberryPlant")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    SeedComponent = require("src.components.items.SeedComponent")

    local self = setmetatable({}, StrawberrySeed)
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)
    self.properties = SeedComponent:load(StrawberryPlant)

    return self
end

function StrawberrySeed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return StrawberrySeed