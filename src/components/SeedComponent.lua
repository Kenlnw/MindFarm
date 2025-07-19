local SeedComponent = {}
SeedComponent.__index = SeedComponent

function SeedComponent:load(plant)
    local self = setmetatable({}, SeedComponent)
    self.is_plantable = true
    self.is_used = false
    self.plant = plant or nil

    return self
end

function SeedComponent:plant_crop(x, y, flip_x, flip_y)
    self.is_used = true
    return self.plant:load(x, y, flip_x, flip_y)
end

return SeedComponent