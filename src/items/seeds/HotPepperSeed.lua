local HotPepperSeed = {}
HotPepperSeed.__index = HotPepperSeed

HotPepperSeed.id = "hot_pepper_seed"

function HotPepperSeed:load(x, y, flip_x, flip_y)
    HotPepperPlant = require("src.entities.plants.HotPepperPlant")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    SeedComponent = require("src.components.items.SeedComponent")

    local self = setmetatable({}, HotPepperSeed)

    self.name = "Hot Pepper Seed"

    self.class = HotPepperSeed
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/HotPepper.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.sell_price = 5

    self.properties = SeedComponent:load(HotPepperPlant, "plantable_area", self.sell_price)

    return self
end

function HotPepperSeed:update(dt)

end

function HotPepperSeed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return HotPepperSeed