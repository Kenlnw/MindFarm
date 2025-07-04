local CollisionComponent = {}
CollisionComponent.__index = CollisionComponent

function CollisionComponent:load(world, layers, map_scale)
    local self = setmetatable({}, CollisionComponent)

    self.world = world
    self.layers = layers
    self.scale = map_scale

    self.map_layers = layers
    self.collision_tiles = {}
    self:find_collision_layers()

    return self
end

function CollisionComponent:find_collision_layers()
    for i, layer in ipairs(self.map_layers) do
        if layer.visible == false then
            if layer.name == "Collision" then
                self.world:addCollisionClass("Wall")
                self.collision_tiles.colision = self:create_collisions(layer)
            elseif layer.name == "PlantableArea" then
                self.world:addCollisionClass("PlantableArea")
                self.collision_tiles.plantable_area = self:create_collisions(layer)
            end
        end
    end
end

function CollisionComponent:create_collisions(collision_layer)
    local collisions = {}
    for tile, obj in ipairs(collision_layer.objects) do
        collisions[tile] = self.world:newRectangleCollider(
            obj.x * self.scale, 
            obj.y * self.scale, 
            obj.width * self.scale, 
            obj.height * self.scale
        )
        collisions[tile]:setType("static")

        if collision_layer.name == "Collision" then
            collisions[tile]:setCollisionClass("Wall")
        elseif collision_layer.name == "PlantableArea" then
            collisions[tile]:setSensor(true)
            collisions[tile]:setCollisionClass("PlantableArea")
        end
    end

    return collisions
end

function CollisionComponent:update()
    
end

return CollisionComponent