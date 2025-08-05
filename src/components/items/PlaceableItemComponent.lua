local PlaceableItemComponent = {}
PlaceableItemComponent.__index = PlaceableItemComponent

function PlaceableItemComponent:load(entity, entity_id)
    local self = setmetatable({}, PlaceableItemComponent)
    self.type = "placeable_item"
    self.can_show_entity = true
    self.is_used = false
    self.entity_blueprint = entity or nil
    self.entity_id = entity_id or nil
    self.entity = self.entity_blueprint:load() or nil

    return self
end

function PlaceableItemComponent:show_object(x, y)
    if self.entity then
        self.entity.sprite:update_position(x, y)
        self.entity.properties:update_collider_position(true, self.entity_id)
    end
end

function PlaceableItemComponent:place(x, y)
    if self.entity.properties.is_cannot_place then
        return nil
    end

    self.is_used = true
    local entity = self.entity_blueprint:load(x, y)
    entity.properties:update_collider_position(false, self.entity_id)
    entity.properties.is_placed = true
    return entity
end

function PlaceableItemComponent:update(dt)
    self.entity:update(dt)
end

return PlaceableItemComponent