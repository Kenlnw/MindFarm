local ChestEntity = {}
ChestEntity.__index = ChestEntity

ChestEntity.id = "chest_entity"

function ChestEntity:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    EntityComponent = require("src.components.items.EntityComponent")
    StorageComponent = require("src.components.ui.StorageComponent")

    local self = setmetatable({}, ChestEntity)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Chest.png", 1, 1, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = EntityComponent:load(self.sprite)

    self.storage = StorageComponent:load("Chest", 5, 3)

    return self
end

function ChestEntity:init_items(type)
    if type then
        local items = {}
        if type == "Starter" then
            StrawberrySeed = require("src.items.seeds.StrawberrySeed")
            PotatoSeed = require("src.items.seeds.PotatoSeed")
            Hoe = require("src.items.tools.Hoe")
            WaterCan = require("src.items.tools.WaterCan")
            Bed = require("src.items.Bed")

            items = {
                { class = StrawberrySeed, item_amount = 10, capacity = SLOT_CAPACITY },
                { class =  PotatoSeed, item_amount = 20, capacity = SLOT_CAPACITY },
                { class = Hoe, item_amount = 1, capacity = 1 },
                { class = WaterCan, item_amount = 1, capacity = 1 },
                { class = Bed, item_amount = 1, capacity = 1 }
            }
        end

        for idx, item in ipairs(items) do
            local slot = self.storage.slots[idx]
            if slot then
                slot:store_item(item.class:load(slot.x, slot.y), item.item_amount, item.capacity)
            end
        end
    end
end

function ChestEntity:update(dt, player)
    self.properties:update(dt, self.sprite, function()
        if is_mouse_down(2) then
            self.storage:open()
            mouse_clear_state(2)
        end
    end)
    self.storage:update(dt, player)
end

function ChestEntity:draw()
    self.properties:draw(self.sprite)
end


return ChestEntity