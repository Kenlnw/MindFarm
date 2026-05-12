local InfoTextComponent = {}
InfoTextComponent.__index = InfoTextComponent

function InfoTextComponent:load()
    TextBoxComponent = require("src.components.ui.TextBoxComponent")

    local self = setmetatable({}, InfoTextComponent)
    self.width = width_scale(120)
    self.height = height_scale(60)
    self.x = love.graphics.getWidth() - self.width - height_scale(10)
    self.y = love.graphics.getHeight() - self.height - height_scale(10)

    self.name_label = TextBoxComponent:load("", self.x, self.y, self.width, height_scale(30), 7 * TILE_SCALE)

    self.actions = {
        { icon = "sprites/items/LeftClickAction.png", text = "Use" },
        { icon = "sprites/items/RightClickAction.png", text = "Place" }
    }

    for _, action in ipairs(self.actions) do
        action.label = TextBoxComponent:load(action.text, 0, 0, width_scale(60), height_scale(30), 4 * TILE_SCALE)
        action.label:set_icon(action.icon, TILE_SCALE * 0.5)
    end

    return self
end

function InfoTextComponent:item_update(current_slot)
    if not current_slot or not current_slot.item then
        self.visible = false
        return
    end

    self.visible = true
    local item = current_slot.item
    self.name_label:change_text(item.name or "Unknown")

    local actions = item_type_actions[item.properties.type] or { "None", "None" }
    for idx, action in ipairs(self.actions) do
        action.label:change_text(actions[idx])
    end
end

function InfoTextComponent:draw()
    if not self.visible then return end

    self.width = self.name_label.width
    self.x = love.graphics.getWidth() - self.width - height_scale(10)

    self.name_label.x = self.x
    self.name_label.width = self.width
    self.name_label:resize_to_text()

    local action_x = self.x
    local action_y = self.y + self.name_label.height + height_scale(4)

    for _, action in ipairs(self.actions) do
        if action.label.text ~= "None" then
            action.label.x = action_x
            action.label.y = action_y
            action.label:resize_to_text()
            action.label:draw_with_icon(30, 20, 8, 220, 200, 150, 0.5, 1, 4)
            action_x = action_x + action.label.width + height_scale(4)
        end
    end


    self.name_label:draw(42, 28, 10, 255, 200, 80, 0.9, 1, 0)
end

return InfoTextComponent