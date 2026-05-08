local SeedComponent = {}
SeedComponent.__index = SeedComponent

function SeedComponent:load(plant, target_id, sell_price)
    local self = setmetatable({}, SeedComponent)
    self.type = "seed"
    self.is_used = false
    self.plant = plant or nil
    self.target_id = target_id

    self.sell_price = sell_price
    
    return self
end

function SeedComponent:plant_crop(x, y, flip_x, flip_y)
    self.is_used = true
    return self.plant:load(x, y, flip_x, flip_y)
end

return SeedComponent