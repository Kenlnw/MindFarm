local StrawberryPlant = {}
StrawberryPlant.__index = StrawberryPlant

StrawberryPlant.id = "strawberry_plant"

function StrawberryPlant:load(x, y, flip_x, flip_y)
    Strawberry = require("src.items.crops.Strawberry")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    PlantComponent = require("src.components.items.PlantComponent")

    local self = setmetatable({}, StrawberryPlant)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Strawberry.png", 6, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[2]

    self.properties = PlantComponent:load(Strawberry)

    return self
end

function StrawberryPlant:update(dt)
    self.properties:update()

    self.sprite.sprites.current_anim:gotoFrame(self.properties.growing_state)
end

function StrawberryPlant:draw()
    self.sprite:draw(self.sprite.sprites)
end

return StrawberryPlant