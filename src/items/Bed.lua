local Bed = {}
Bed.__index = Bed

function Bed:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    BedEntity = require("src.entities.BedEntity")

    local self = setmetatable({}, Bed)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 4, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[4]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = {}
    self.properties.type = "placeable_item"
    self.properties.can_show_entity = true
    self.properties.is_used = false
    self.properties.entity = BedEntity:load()

    return self
end

function Bed:show_object(x, y)
    self.properties.entity.sprite:update_position(x, y)
end

function Bed:place(x, y)
    self.properties.is_used = true
    self.properties.entity.sprite:update_position(x, y)

    return self.properties.entity.sprite
end

function Bed:update(dt)
end

function Bed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Bed