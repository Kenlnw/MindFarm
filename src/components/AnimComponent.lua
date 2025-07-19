local AnimComponent = {}
AnimComponent.__index = AnimComponent

function AnimComponent:load(sprite_sheet_src, columns, rows, duration, start_state)
    anim8 = require("libraries.anim8")

    local self = setmetatable({}, AnimComponent)

    self.sprite_sheet = love.graphics.newImage(sprite_sheet_src)
    self.columns = columns
    self.rows = rows
    self.sprite_scale = TILE_SCALE

    self.frame_width = self.sprite_sheet:getWidth() / self.columns
    self.frame_height = self.sprite_sheet:getHeight() / self.rows

    self.grid = anim8.newGrid(
        self.frame_width,
        self.frame_height,
        self.sprite_sheet:getWidth(),
        self.sprite_sheet:getHeight()
    )
    self.anim_duration = duration
    self.anims = {}

    self:create_frames(start_state)

    self.current_anim = self.anims[1]

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

function AnimComponent:draw_anim(parent)
    if self.current_anim then
        self.current_anim:draw(
            self.sprite_sheet,
            parent.x,
            parent.y,
            nil,
            self.sprite_scale * parent.flip.x,
            self.sprite_scale * parent.flip.y,
            parent.offset.x,
            parent.offset.y
        )
    end
end

return AnimComponent