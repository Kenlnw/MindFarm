items = require("src.items")

crops = {}

for _, item in pairs(items) do
    if item.is_plantable then
        crops[item.id] = item
    end
end