local Interface = {}
Interface.__index = Interface

function Interface:load()
    SlotBar = require("src.SlotBar")

    local self = setmetatable({}, Interface)

    self.slot_bar = SlotBar:load()

    return self
end

function Interface:update(dt)

end

function Interface:draw()
    self.slot_bar:draw()
end

return Interface