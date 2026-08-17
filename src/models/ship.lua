local Ship = {}
Ship.__index = Ship

function Ship.new(name, size)
    local self = setmetatable({}, Ship)
    self.name = name
    self.size = size
    self.hits = 0
    self.x = nil
    self.y = nil
    self.horizontal = true
    return self
end

function Ship:is_sunk()
    return self.hits >= self.size
end

function Ship:register_hit()
    self.hits = self.hits + 1
end

return Ship
