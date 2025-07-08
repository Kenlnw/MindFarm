local items = {}
local path = "src/items"

for _, filename in ipairs(love.filesystem.getDirectoryItems("src/items")) do
    if filename:match("%.lua$") and filename ~= "init.lua" then
        local modulename = filename:sub(1, -5)
        local item = require(path .. "." .. modulename)
        table.insert(items, item)
    end
end

return items