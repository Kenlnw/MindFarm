local MapCollisionComponent = {}
MapCollisionComponent.__index = MapCollisionComponent

function MapCollisionComponent:load(world, layers, map_scale)
    require("src.utils")

    local self = setmetatable({}, MapCollisionComponent)

    self.world = world
    self.layers = layers
    self.scale = map_scale

    self.map_layers = layers
    self.collision_tiles = {}
    self:find_collision_layers()

    self.current_tile = nil
    self.player_collider = nil

    return self
end

function MapCollisionComponent:add_player_collider(player_collider)
    self.player_collider = player_collider
end

function MapCollisionComponent:find_collision_layers()
    for i, layer in ipairs(self.map_layers) do
        if layer.visible == false then
            if layer.name == "Wall" then
                self.world:addCollisionClass(layer.name)
                self.collision_tiles.wall = self:create_collisions(layer)
            elseif layer.name == "PlantableArea" then
                self.world:addCollisionClass(layer.name)
                self.collision_tiles.plantable_area = self:create_collisions(layer)
            end
        end
    end
end

function MapCollisionComponent:create_collisions(collision_layer)
    local collisions = {}
    for tile, obj in ipairs(collision_layer.objects) do
        collisions[tile] = self.world:newRectangleCollider(
            obj.x * self.scale, 
            obj.y * self.scale, 
            obj.width * self.scale, 
            obj.height * self.scale
        )
        collisions[tile]:setType("static")
        collisions[tile].width = obj.x * self.scale
        collisions[tile].height = obj.y * self.scale

        if collision_layer.name == "Wall" then
            collisions[tile]:setCollisionClass(collision_layer.name)
        elseif collision_layer.name == "PlantableArea" then
            collisions[tile]:setSensor(true)
            collisions[tile]:setCollisionClass(collision_layer.name)
        end
    end

    return collisions
end

function MapCollisionComponent:plantable_area_enter(col_1, col_2, contract)
    if col_1.collision_class == "Player" then
        self.current_tile = col_2
    elseif col_2.collision_class == "Player" then
        self.current_tile = col_1
    end
end

function MapCollisionComponent:plantable_area_exit(col_1, col_2, contract)
    self.current_tile = nil
end

function MapCollisionComponent:update(dt)
    for _, collider in ipairs(self.collision_tiles.plantable_area) do
        if is_overlap(self.player_collider, collider) then
            debug_text = "True"
            break
        else
            debug_text = "False"
        end
    end
end

function MapCollisionComponent:draw()
    if self.current_tile then
        debug_text = "collision at" .. self.current_tile.x .. ", " .. self.current_tile.y
    else
        debug_text = "No collision"
    end
end

return MapCollisionComponent