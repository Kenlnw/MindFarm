function set_color(r, g, b, a)
    local alpha = a or 1
    love.graphics.setColor(r/255, g/255, b/255, alpha)
end

function reset_color()
    set_color(255, 255, 255, 1)
end

function round(n)
    return math.floor(n + 0.5)
end

function is_overlap(col1, col2)
    return col1:getX() < col2:getX() + col2.width and
           col1:getX() + col1.width > col2:getX() and
           col1:getY() < col2:getY() + col2.height and
           col1:getY() + col1.height > col2:getY()
end


-- function is_overlap(col1, col2)
--     local x1, y1 = col1:getPosition()
--     local x2, y2 = col2:getPosition()
--     return x1 < x2 + col2.width and
--            x1 + col1.width > x2 and
--            y1 < y2 + col2.height and
--            y1 + col1.height > y2
-- end

debug_text = "None"

function debug_print()
    love.graphics.print(debug_text, 0, 0)
end