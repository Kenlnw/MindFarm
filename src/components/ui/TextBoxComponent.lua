local TextBoxComponent = {}
TextBoxComponent.__index = TextBoxComponent

function TextBoxComponent:load(text, x, y, width, height,text_size)
    local self = setmetatable({}, TextBoxComponent)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.font = love.graphics.newFont(TEXT_FONT, text_size)
    self.icon = nil
    self.icon_scale = nil

    return self
end

function TextBoxComponent:set_icon(image_path, scale)
    self.icon = love.graphics.newImage(image_path)
    self.icon_scale = scale or TILE_SCALE
end

function TextBoxComponent:change_text(new_text)
    self.text = new_text
end

function TextBoxComponent:resize_to_text(padding)
    padding = padding or love.graphics.getWidth()/25
    local text_width = self.font:getWidth(tostring(self.text))

    if self.icon then
        text_width = self.font:getWidth(tostring(self.text)) + TILE_SCALE
    end
    self.width = text_width + padding * 2
end

function TextBoxComponent:draw(r1, g1, b1, r2, g2, b2, a1, a2, corner_segment, align)
    -- background
    set_color(r1, g1, b1, a1 or 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, corner_segment or 0)
    -- a text that aligned to center
    set_color(r2 , g2, b2, a2 or 1)
    love.graphics.printf(self.text, self.font, self.x, self.y + (self.height - self.font:getHeight()) / 2  , self.width, align or "center")
    reset_color()
end

function TextBoxComponent:draw_with_icon(r1, g1, b1, r2, g2, b2, a1, a2, corner_segment, align)
    -- background
    set_color(r1, g1, b1, a1 or 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, corner_segment or 0)

    local icon_w = 0
    if self.icon then
        icon_w = 16 * self.icon_scale
        local icon_x = self.x + height_scale(4)
        local icon_y = self.y + (self.height - icon_w) / 2
        reset_color()
        love.graphics.draw(self.icon, icon_x, icon_y, 0, self.icon_scale, self.icon_scale)
    end

    -- a text with icon that aligned to left
    set_color(r2, g2, b2, a2 or 1)
    love.graphics.printf(
        self.text,
        self.font,
        self.x + icon_w + height_scale(8),
        self.y + (self.height - self.font:getHeight()) / 2,
        self.width - icon_w - height_scale(8),
        align or "center"
    )
    reset_color()
end

return TextBoxComponent