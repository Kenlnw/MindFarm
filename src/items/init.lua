local items = {}
local folder = "src/items"

local function search_files(folder)
        for _, filename in ipairs(love.filesystem.getDirectoryItems(folder)) do
            local item_path = folder .. "/" .. filename
            if love.filesystem.getInfo(item_path, "directory") then
                search_files(item_path)
            else
               if filename:match("%.lua$") and filename ~= "init.lua" then
                    local item = require(folder .. "." .. filename:sub(1, -5))
                    table.insert(items, item)
                end
            end
        end
    end
search_files(folder)
return items