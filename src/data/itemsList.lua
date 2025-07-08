items = require("src.items")

plantable_items = {}

for _, item in pairs(items) do
    if item.is_plantable then
        plantable_items[item.id] = item
    end
end