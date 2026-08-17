local Button = require("src.utils.ui")
local BoardView = require("src.views.board_view")
local Ship = require("src.models.ship")
local ShipPlacement = {}

function ShipPlacement:enter()
    local map = _G.selected_map or {width = 10, height = 10, fleet = {}}
    self.board = require("src.models.board").new(map.width, map.height)
    self.fleet = {}
    for _, ship_def in ipairs(map.fleet) do
        table.insert(self.fleet, Ship.new(ship_def.name, ship_def.size))
    end
    self.current_ship_index = 1
    self.horizontal = true
    self.view = BoardView.new(self.board, 100, 100, 30)
    
    self.auto_button = Button.new("Auto", 450, 50, 100, 40, function()
        self:auto_place()
    end)
end

function ShipPlacement:auto_place()
    -- Place remaining ships randomly
    for i = self.current_ship_index, #self.fleet do
        local placed = false
        while not placed do
            local x = love.math.random(1, self.board.width)
            local y = love.math.random(1, self.board.height)
            local horizontal = love.math.random(0, 1) == 1
            if self.board:place_ship(self.fleet[i], x, y, horizontal == 1) then
                placed = true
            end
        end
    end
    self:finish_placement()
end

function ShipPlacement:finish_placement()
    _G.player_fleet = self.fleet
    _G.player_board = self.board
    require("src.core.state_manager").switch("game")
end

function ShipPlacement:update(dt)
    local mx, my = love.mouse.getPosition()
    self.auto_button:update(dt, mx, my)
    self.mx, self.my = mx, my
end

function ShipPlacement:draw()
    love.graphics.print("Posicione seus navios:", 20, 20)
    love.graphics.print("Clique na grade para colocar. Pressione 'R' para girar.", 20, 40)
    
    if self.current_ship_index <= #self.fleet then
        local ship = self.fleet[self.current_ship_index]
        
        -- Draw preview if mouse is over board
        if self.mx >= self.view.x and self.mx < self.view.x + self.board.width * self.view.cell_size and
           self.my >= self.view.y and self.my < self.view.y + self.board.height * self.view.cell_size then
            
            local gx = math.floor((self.mx - self.view.x) / self.view.cell_size) + 1
            local gy = math.floor((self.my - self.view.y) / self.view.cell_size) + 1
            
            local can_place = self.board:can_place_ship(ship, gx, gy, self.horizontal)
            love.graphics.setColor(can_place and {0, 1, 0, 0.5} or {1, 0, 0, 0.5})
            
            -- Draw ghost ship
            local w, h = self.horizontal and ship.size * self.view.cell_size or self.view.cell_size,
                         self.horizontal and self.view.cell_size or ship.size * self.view.cell_size
            love.graphics.rectangle("fill", self.view.x + (gx - 1) * self.view.cell_size, self.view.y + (gy - 1) * self.view.cell_size, w, h)
            love.graphics.setColor(1, 1, 1, 1)
        end
    else
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("Todos os navios posicionados!", 20, 80)
        love.graphics.setColor(1, 1, 1)
    end
    
    self.view:draw()
    self.auto_button:draw()
end

function ShipPlacement:keypressed(key)
    if key == "r" then
        self.horizontal = not self.horizontal
    end
end

function ShipPlacement:mousepressed(x, y, button)
    self.auto_button:mousepressed(x, y, button)
    
    if button == 1 and self.current_ship_index <= #self.fleet then
        if x >= self.view.x and x < self.view.x + self.board.width * self.view.cell_size and
           y >= self.view.y and y < self.view.y + self.board.height * self.view.cell_size then
            
            local grid_x = math.floor((x - self.view.x) / self.view.cell_size) + 1
            local grid_y = math.floor((y - self.view.y) / self.view.cell_size) + 1
            
            if self.board:place_ship(self.fleet[self.current_ship_index], grid_x, grid_y, self.horizontal) then
                self.current_ship_index = self.current_ship_index + 1
                if self.current_ship_index > #self.fleet then
                    self:finish_placement()
                end
            end
        end
    end
end

return ShipPlacement
