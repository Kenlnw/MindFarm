local LeekPlant = {}
LeekPlant.__index = LeekPlant

LeekPlant.id = "leek_plant"

function LeekPlant:load(x, y, flip_x, flip_y)
    Leek = require("src.items.crops.Leek")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    PlantComponent = require("src.components.items.PlantComponent")

    local self = setmetatable({}, LeekPlant)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/Leek.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[2]

    self.properties = PlantComponent:load(Leek, 7)

    return self
end

function LeekPlant:update(dt)
    self.sprite.sprites.current_anim:gotoFrame(self.properties.growing_state)
    self.properties:update(dt)
end

function LeekPlant:draw()
    self.sprite:draw(self.sprite.sprites)
end

return LeekPlant