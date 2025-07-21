local TimeComponent = {}
TimeComponent.__index = TimeComponent

function TimeComponent:load(max_time, current_time, timer_speed)
    TextBox = require("src.components.ui.TextboxComponent")

    local self = setmetatable({}, TimeComponent)
    self.time_elapsed = 0
    self.max_time = max_time or 1440
    self.current_time = current_time or 1400
    self.time_speed = timer_speed or 2
    self.label = nil


    return self
end

function TimeComponent:set_label(x, y, width, height, font_size)
    self.label = TextBox:load(self:show_time(), x or 0, y or 0, width or 100, height or 100, font_size or 20)
end

function TimeComponent:show_time()
    local hours = math.floor(self.current_time / 60)
    local mins = self.current_time % 60

    local time_text = hours
    if hours < 10 then
        time_text = "0".. hours
    end

    if mins == 0 then
        time_text = time_text ..":00"
    else
        time_text = time_text ..":".. mins
    end

    return time_text
end

function TimeComponent:update(dt)
    self.time_elapsed = self.time_elapsed + dt

    if self.current_time >= 1440 then
        day_changed = true
        self.current_time = 1400
        DAYS = DAYS + 1
    end

    if self.time_elapsed >= self.time_speed then
        if day_changed then
            day_changed = false
        end
        self.current_time = self.current_time + 10
        self.time_elapsed = 0

        if self.label then
            self.label:change_text(self:show_time())
        end
    end
end

function TimeComponent:draw(r1, g1, b1, r2, g2, b2, a1, a2)
    if self.label then
        self.label:draw(r1, g1, b1, r2, g2, b2, a1, a2)
    end
end


return TimeComponent