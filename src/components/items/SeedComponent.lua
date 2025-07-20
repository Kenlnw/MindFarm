local SeedComponent = {}
SeedComponent.__index = SeedComponent

function SeedComponent:load(plant, target_id)
    local self = setmetatable({}, SeedComponent)
    self.is_plantable = true
    self.is_used = false
    self.plant = plant or nil
    self.target_id = target_id

    return self
end

function SeedComponent:plant_crop(x, y, flip_x, flip_y)
    self.is_used = true
    return self.plant:load(x, y, flip_x, flip_y)
end

return SeedComponent