local WaterCan = {}
WaterCan.__index = WaterCan

function WaterCan:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    ToolComponent = require("src.components.items.ToolComponent")

    local self = setmetatable({}, WaterCan)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/WaterCan.png", 1, 1, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = ToolComponent:load()

    return self
end

function WaterCan:draw()
    self.sprite:draw(self.sprite.sprites)
end

return WaterCan