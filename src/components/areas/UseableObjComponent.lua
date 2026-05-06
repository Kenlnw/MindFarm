local UseableObjComponent = {}
UseableObjComponent.__index = UseableObjComponent

function UseableObjComponent:load(layer)
    ChestEntity = require("src.entities.ChestEntity")

    local self = setmetatable({}, UseableObjComponent)
    self.layer = layer
    self.map_scale = TILE_SCALE

    self.useable_objs = self:create_obj(self.layer)

    return self
end

function UseableObjComponent:create_obj(layer)
    local useable_objs = {}

    for _, obj in ipairs(layer.objects) do
        local useable_obj = nil
        if obj.name == "Chest" then
            useable_obj = ChestEntity:load(obj.x*self.map_scale, obj.y*self.map_scale)
            useable_obj.properties:update_collider_position(false, useable_obj.id)
            useable_obj.properties.is_placed = true
        end

        table.insert(useable_objs, useable_obj)
    end

    return useable_objs
end

function UseableObjComponent:update(dt)
    for _, useable_obj in ipairs(self.useable_objs) do
        useable_obj:update(dt)
    end
end

function UseableObjComponent:draw()
    for _, useable_obj in ipairs(self.useable_objs) do
        useable_obj:draw()
    end
end

return UseableObjComponent