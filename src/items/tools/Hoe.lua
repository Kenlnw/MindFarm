local Hoe = {}
Hoe.__index = Hoe

Hoe.id = "hoe"
Hoe.tool_id = "hoe"

function Hoe:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    ToolComponent = require("src.components.items.ToolComponent")

    local self = setmetatable({}, Hoe)

    self.name = "Hoe"

    self.class = Hoe
    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/tools/Hoe.png", 1, 1, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties =ToolComponent:load("plantable_area")

    return self
end

function Hoe:soil(target)
    if target and not target.is_soiled and not self.properties.is_used then
        self.properties.is_used = true
        target.is_soiled = true
        self.properties.is_used = false
    end
end

function Hoe:update(dt)

end

function Hoe:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Hoe