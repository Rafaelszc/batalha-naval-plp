local Board = {}
Board.__index = Board

function Board.new(width, height)
    local self = setmetatable({}, Board)
    self.width = width
    self.height = height
    self.grid = {}
    for y = 1, height do
        self.grid[y] = {}
        for x = 1, width do
            self.grid[y][x] = 0 -- 0: empty, 1: ship, 2: miss, 3: hit
        end
    end
    self.ships = {}
    return self
end

function Board:can_place_ship(ship, x, y, horizontal)
    if horizontal then
        if x + ship.size - 1 > self.width then return false end
        for i = 0, ship.size - 1 do
            if self.grid[y][x + i] ~= 0 then return false end
        end
    else
        if y + ship.size - 1 > self.height then return false end
        for i = 0, ship.size - 1 do
            if self.grid[y + i][x] ~= 0 then return false end
        end
    end
    return true
end

function Board:place_ship(ship, x, y, horizontal)
    if not self:can_place_ship(ship, x, y, horizontal) then return false end
    
    ship.x = x
    ship.y = y
    ship.horizontal = horizontal
    table.insert(self.ships, ship)
    
    if horizontal then
        for i = 0, ship.size - 1 do
            self.grid[y][x + i] = 1
        end
    else
        for i = 0, ship.size - 1 do
            self.grid[y + i][x] = 1
        end
    end
    return true
end

function Board:receive_shot(x, y)
    if self.grid[y][x] == 1 then
        self.grid[y][x] = 3
        for _, ship in ipairs(self.ships) do
            -- Logic to check if shot hit specific ship
            if ship.horizontal then
                if y == ship.y and x >= ship.x and x < ship.x + ship.size then
                    ship:register_hit()
                end
            else
                if x == ship.x and y >= ship.y and y < ship.y + ship.size then
                    ship:register_hit()
                end
            end
        end
        return "hit"
    elseif self.grid[y][x] == 0 then
        self.grid[y][x] = 2
        return "miss"
    end
    return "already_shot"
end

function Board:place_randomly(ships)
    for _, ship in ipairs(ships) do
        local placed = false
        while not placed do
            local x = love.math.random(1, self.width)
            local y = love.math.random(1, self.height)
            local horizontal = love.math.random(0, 1) == 1
            if self:place_ship(ship, x, y, horizontal) then
                placed = true
            end
        end
    end
end

function Board:receive_area_shot(x, y, radius)
    local hits = 0
    for dy = -radius + 1, radius do
        for dx = -radius + 1, radius do
            local tx, ty = x + dx, y + dy
            if tx >= 1 and tx <= self.width and ty >= 1 and ty <= self.height then
                if self:receive_shot(tx, ty) == "hit" then
                    hits = hits + 1
                end
            end
        end
    end
    return hits > 0 and "hit" or "miss"
end

function Board:receive_line_shot(x, y, is_horizontal)
    local hits = 0
    if is_horizontal then
        -- Attack the entire row y
        for tx = 1, self.width do
            if self:receive_shot(tx, y) == "hit" then
                hits = hits + 1
            end
        end
    else
        -- Attack the entire column x
        for ty = 1, self.height do
            if self:receive_shot(x, ty) == "hit" then
                hits = hits + 1
            end
        end
    end
    return hits > 0 and "hit" or "miss"
end

return Board
