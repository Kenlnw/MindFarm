local AnimComponent = {}
AnimComponent.__index = AnimComponent

function AnimComponent:load(sprite)
    anim8 = require("libraries.anim8")

    local self = setmetatable({}, AnimComponent)

    self.sprite_sheet = sprite.sprite_sheet
    self.columns = sprite.columns
    self.rows = sprite.rows

    self.frame_width = self.sprite_sheet:getWidth() / self.columns
    self.frame_height = self.sprite_sheet:getHeight() / self.rows

    self.grid = anim8.newGrid(
        self.frame_width, 
        self.frame_height, 
        self.sprite_sheet:getWidth(), 
        self.sprite_sheet:getHeight()
    )
    self.anim_duration = sprite.duration
    self.anims = {}
    self.current_amin = nil

    return self
end

function AnimComponent:create_frames(start_state)
    if start_state == "rows" then
        local columns_range = "1-" .. self.columns
        for row = 1, self.rows do
            self.anims[row] = anim8.newAnimation(self.grid(columns_range, row), self.anim_duration)
        end
    elseif start_state == "columns" then
        local rows_range = "1-" .. self.rows
        for column = 1, self.columns do
            self.anims[column] = anim8.newAnimation(self.grid(column, rows_range), self.anim_duration)
        end
    end
end

return AnimComponent