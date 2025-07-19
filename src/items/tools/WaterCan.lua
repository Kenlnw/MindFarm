local WaterCan = {}
WaterCan.__index = WaterCan

function WaterCan:load(x, y, flip_x, flip_y)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    ToolComponent = require("src.components.items.ToolComponent")

    local self = setmetatable({}, WaterCan)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)

    self.properties = ToolComponent:load()

    return self
end

return WaterCan