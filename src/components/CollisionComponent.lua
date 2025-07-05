local CollisionComponent = {}
CollisionComponent.__index = CollisionComponent

function CollisionComponent:load(world, layer, map_scale)
    local self = setmetatable({}, CollisionComponent)

    self.world = world
    self.layer = layer
    self.map_scale = map_scale

    self.collision_areas = self:create_collisions(self.layer)

    return self
end

function CollisionComponent:create_collisions(layer)
    local collision_areas = {}
    
    for _, obj in ipairs(layer.objects) do
        local collision_area = self.world:newRectangleCollider(
            obj.x * self.map_scale, 
            obj.y * self.map_scale, 
            obj.width * self.map_scale, 
            obj.height * self.map_scale
        )
        collision_area:setType("static")
        collision_area:setCollisionClass(layer.class)

        table.insert(collision_areas, collision_area)
    end

    return collision_areas
end

function CollisionComponent:update()
    
end

return CollisionComponent