local Interface = {}
Interface.__index = Interface

function Interface:load()
    SlotBar = require("src.classes.SlotBar")

    local self = setmetatable({}, Interface)

    self.slot_bar = SlotBar:load()

    return self
end

function Interface:update(dt)
    self.slot_bar:update(dt)
end

function Interface:draw()
    self.slot_bar:draw()
end

return Interface
