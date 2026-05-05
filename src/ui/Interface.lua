local Interface = {}
Interface.__index = Interface

function Interface:load(time)
    SlotBar = require("src.ui.SlotBar")
    TextBox = require("src.components.ui.TextboxComponent")

    local self = setmetatable({}, Interface)
    self.slot_bar = SlotBar:load()
    self.date_label = TextBox:load("Day: " .. DAYS, love.graphics.getWidth() - 180, 0, 180, 80, 40)
    self.time = time
    self.time:set_label(love.graphics.getWidth() - 100, self.date_label.height, 100, 50, 20)

    return self
end

function Interface:update(dt)
    self.slot_bar:update(dt)
    self.date_label:change_text("Day: " .. DAYS)
end

function Interface:draw()
    self.slot_bar:draw()
    self.date_label:draw(138, 61, 83, 241, 172, 123)
    self.time:draw(49, 57, 119, 255, 255, 255)
end

return Interface
