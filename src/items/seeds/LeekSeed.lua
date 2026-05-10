local LeekSeed = {}
LeekSeed.__index = LeekSeed

LeekSeed.id = "leek_seed"

function LeekSeed:load(x, y, flip_x, flip_y)
    LeekPlant = require("src.entities.plants.LeekPlant")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    SeedComponent = require("src.components.items.SeedComponent")

    local self = setmetatable({}, LeekSeed)

    self.class = LeekSeed
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/Leek.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 10

    self.properties = SeedComponent:load(LeekPlant, "plantable_area", self.sell_price)

    return self
end

function LeekSeed:update(dt)

end

function LeekSeed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return LeekSeed