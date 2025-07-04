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