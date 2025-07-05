local CollisionAreaComponent = {}
CollisionAreaComponent.__index = CollisionAreaComponent

function CollisionAreaComponent:load(world, layer, map_scale)
    local self = setmetatable({}, CollisionAreaComponent)

    self.world = world
    self.layer = layer
    self.map_scale = map_scale

    self.collision_areas = self:create_collisions(self.layer)

    return self
end

function CollisionAreaComponent:create_collisions(layer)
    local collision_areas = {}
    
    for _, obj in ipairs(layer.objects) do
        local collision_area  = {}
        collision_area.tag = "collision_area"
        collision_area.x = obj.x * self.map_scale
        collision_area.y = obj.y * self.map_scale
        collision_area.width = obj.width * self.map_scale
        collision_area.height = obj.height * self.map_scale

        collision_area.body = love.physics.newBody(self.world, collision_area.x, collision_area.y, "static")
        collision_area.shape = love.physics.newRectangleShape(collision_area.width/2 + 16, collision_area.height/2, collision_area.width, collision_area.height)
        collision_area.fixture = love.physics.newFixture(collision_area.body, collision_area.shape)
        collision_area.body:setFixedRotation(true)
        collision_area.fixture:setUserData(collision_area)

        table.insert(collision_areas, collision_area)
    end

    return collision_areas
end

return CollisionAreaComponent