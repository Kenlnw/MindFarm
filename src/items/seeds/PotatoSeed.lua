local PotatoSeed = {}
PotatoSeed.__index = PotatoSeed

PotatoSeed.id = "potato_seed"

function PotatoSeed:load(x, y, flip_x, flip_y)
    PotatoPlant = require("src.entities.plants.PotatoPlant")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    SeedComponent = require("src.components.items.SeedComponent")


    local self = setmetatable({}, PotatoSeed)

    self.class = PotatoSeed
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/Potato.png", 4, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 10

    self.properties = SeedComponent:load(PotatoPlant, "plantable_area", self.sell_price)

    return self
end

function PotatoSeed:update(dt)

end

function PotatoSeed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return PotatoSeed