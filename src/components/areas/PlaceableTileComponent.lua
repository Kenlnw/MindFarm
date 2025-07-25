local PlaceableTileComponent = {}
PlaceableTileComponent.__index = PlaceableTileComponent

function PlaceableTileComponent:load(world, x, y, width, height)
    local self = setmetatable({}, PlaceableTileComponent)
    self.world = world
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.is_active = false
    self.entity = nil
    -- self.is_planted = false
    -- self.is_watered = false
    -- self.plant = nil

    self.area = {}
    self:set_area()

    return self
end

function PlaceableTileComponent:set_area()
    self.body = love.physics.newBody(self.world, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width / 2, self.height / 2, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)
    self.fixture:setSensor(true)
end

function PlaceableTileComponent:update(dt)
    if self.entity then
        self.entity:update(dt)
    end
end

function PlaceableTileComponent:plant_crop(seed)
    -- if not self.is_planted and seed then
    --     self.is_planted = true
    --     self.plant = seed.properties:plant_crop(self.x, self.y)
    -- end
end

function PlaceableTileComponent:reset_area()
    -- self.is_planted = false
    -- self.is_watered = false
    -- self.plant = nil
end

return PlaceableTileComponent
