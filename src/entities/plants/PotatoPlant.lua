local PotatoPlant = {}
PotatoPlant.__index = PotatoPlant

PotatoPlant.id = "potato_plant"

function PotatoPlant:load(x, y, flip_x, flip_y)
    Potato = require("src.items.crops.Potato")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    PlantComponent = require("src.components.items.PlantComponent")

    local self = setmetatable({}, PotatoPlant)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Potato.png", 4, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[2]

    self.properties = PlantComponent:load(Potato, 4)

    return self
end

function PotatoPlant:update(dt)
    self.sprite.sprites.current_anim:gotoFrame(self.properties.growing_state)

    self.properties:update(dt)
end

function PotatoPlant:draw()
    self.sprite:draw(self.sprite.sprites)
end

return PotatoPlant