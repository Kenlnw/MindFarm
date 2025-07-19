local PlantableTileComponent = {}
PlantableTileComponent.__index = PlantableTileComponent

function PlantableTileComponent:load(world, x, y, width, height)
    local self = setmetatable({}, PlantableTileComponent)
    self.world = world
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.is_active = false
    self.is_planted = false
    self.is_watered = false
    self.crop = nil

    self.area = {}
    self:set_area()

    return self
end

function PlantableTileComponent:set_area()
    self.body = love.physics.newBody(self.world, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width / 2, self.height / 2, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)
    self.fixture:setSensor(true)
end

function PlantableTileComponent:plant_crop(seed)
    if not self.is_planted and seed then
        self.is_planted = true
        self.crop = seed:plant_crop(self.x, self.y)
    end
end

function PlantableTileComponent:reset_area()
    self.is_planted = false
    self.is_watered = false
    self.crop = nil
end

return PlantableTileComponent
