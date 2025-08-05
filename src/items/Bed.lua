local Bed = {}
Bed.__index = Bed

function Bed:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    PlaceableItemComponent = require("src.components.items.PlaceableItemComponent")
    BedEntity = require("src.entities.BedEntity")

    local self = setmetatable({}, Bed)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 4, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[4]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = PlaceableItemComponent:load(BedEntity)

    return self
end

function Bed:update(dt)
    self.properties:update(dt)
end

function Bed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Bed