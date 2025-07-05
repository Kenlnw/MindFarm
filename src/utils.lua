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


function distance_between(x1, x2, y1, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function debug_init()
    debug_text = ""
    debug_obj = nil
    debug_bool = nil
end

function debug_print()
    love.graphics.print(debug_text, 0, 0)
end