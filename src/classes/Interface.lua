local Interface = {}
Interface.__index = Interface

function Interface:load()
    SlotBar = require("src.classes.SlotBar")
    TextBox = require("src.components.TextboxComponent")

    local self = setmetatable({}, Interface)
    self.slot_bar = SlotBar:load()
    self.date_label = TextBox:load(DAYS, love.graphics.getWidth() - 100, 0, 100, 100, 40)
    self.time_label = TextBox:load("06:00", self.date_label.x, self.date_label.height, 100, 50, 20)
    self.t = 0
    self.time = 1400

    return self
end

function Interface:update(dt)
    self.t = self.t + dt

    if self.time >= 1440 then
        self.time = 0
    end

    if self.t >= 1 then
        self.time = self.time + 10
        self.t = 0
    end

    local hours = math.floor(self.time / 60)
    local mins = self.time % 60

    local time_text = hours
    if hours < 10 then
        time_text = "0".. hours
    end

    if mins == 0 then
        time_text = time_text ..":00"
    else
        time_text = time_text ..":".. mins
    end

    self.slot_bar:update(dt)
    self.date_label:change_text(DAYS)
    self.time_label:change_text(time_text)
end

function Interface:draw()
    self.slot_bar:draw()
    self.date_label:draw(138, 61, 83, 241, 172, 123)
    self.time_label:draw(49, 57, 119, 255, 255, 255)
end

return Interface
