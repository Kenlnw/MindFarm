local Interface = {}
Interface.__index = Interface

function Interface:load()
    SlotBar = require("src.classes.SlotBar")
    TextBox = require("src.components.TextboxComponent")

    local self = setmetatable({}, Interface)

    self.slot_bar = SlotBar:load()
    self.date_label = TextBox:load(DAYS, love.graphics.getWidth() - 100, 0, 100, 100, 30)

    return self
end

function Interface:update(dt)
    self.slot_bar:update(dt)
    self.date_label:change_text(DAYS)
end

function Interface:draw()
    self.slot_bar:draw()
    self.date_label:draw(255, 255, 0, 0, 0, 0)
end

return Interface
