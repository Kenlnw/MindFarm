local CollisionComponent = {}
CollisionComponent.__index = CollisionComponent

function CollisionComponent:load(world, layer, map_scale)
    local self = setmetatable({}, CollisionComponent)

    self.world = world
    self.layer = layer
    self.scale = map_scale

    self.collisions = {}

    return self
end

function CollisionComponent:create_collisions()
    for tile, obj in ipairs(self.layer.objects) do
        self.collisions[tile] = self.world:newRectangleCollider(
            obj.x * self.scale, 
            obj.y * self.scale, 
            obj.width * self.scale, 
            obj.height * self.scale
        )
        self.collisions[tile]:setType("static")
    end
end

return CollisionComponent