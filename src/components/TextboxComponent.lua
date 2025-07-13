local TextBoxComponent = {}
TextBoxComponent.__index = TextBoxComponent

function TextBoxComponent:load(text, x, y, width, height,text_size)
    require("src.utils")
    local self = setmetatable({}, TextBoxComponent)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.font = love.graphics.newFont(text_size)

    return self
end

function TextBoxComponent:change_text(new_text)
    self.text = new_text
end

function TextBoxComponent:draw(r1, g1, b1, r2, g2, b2)
    set_color(r1, g1, b1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    set_color(r2 , g2, b2)
    love.graphics.printf(self.text, self.font, self.x, self.y + (self.height - self.font:getHeight()) / 2  , self.width, "center")
    reset_color()
end

return TextBoxComponent