local PlantableTileComponent = {}
PlantableTileComponent.__index = PlantableTileComponent

function PlantableTileComponent:load(world, x, y, width, height)
    local self = setmetatable({}, PlantableTileComponent)
    current_world = world
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.is_active = false
    self.is_planted = false
    self.is_watered = false
    self.plant = nil

    self.area = {}
    self:set_area()

    return self
end

function PlantableTileComponent:set_area()
    self.area.id = "plantable_area"
    self.area.body = love.physics.newBody(current_world, self.x, self.y, "static")
    self.area.shape = love.physics.newRectangleShape(self.width / 2, self.height / 2, self.width, self.height)
    self.area.fixture = love.physics.newFixture(self.area.body, self.area.shape)
    self.area.body:setFixedRotation(true)
    self.area.fixture:setSensor(true)
    self.area.fixture:setUserData(self.area)
end

function PlantableTileComponent:update()
    if self.is_watered and self.plant and not self.plant.properties.is_watered then
        self.plant.properties.is_watered = true
    end
    if day_changed and self.is_watered then
        self.is_watered = false
        if self.plant then
            self.plant.properties.is_watered = false
        end
    end
end

function PlantableTileComponent:plant_crop(seed)
    if not self.is_planted and seed then
        self.is_planted = true
        self.plant = seed.properties:plant_crop(self.x, self.y)
    end
end

function PlantableTileComponent:reset_area()
    self.is_planted = false
    self.is_watered = false
    self.plant = nil
end

return PlantableTileComponent
