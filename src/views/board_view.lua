local BoardView = {}
BoardView.__index = BoardView

function BoardView.new(board, x, y, cell_size, hide_ships, is_fog)
    local self = setmetatable({}, BoardView)
    self.board = board
    self.x = x
    self.y = y
    self.cell_size = cell_size
    self.hide_ships = hide_ships or false
    self.is_fog = is_fog or false
    return self
end

function BoardView:draw()
    for y = 1, self.board.height do
        for x = 1, self.board.width do
            local cell_x = self.x + (x - 1) * self.cell_size
            local cell_y = self.y + (y - 1) * self.cell_size
            
            -- Draw cell border (Always visible)
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("line", cell_x, cell_y, self.cell_size, self.cell_size)
            
            if self.is_fog then
                -- Fill with dark color for fog
                love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
                love.graphics.rectangle("fill", cell_x + 1, cell_y + 1, self.cell_size - 2, self.cell_size - 2)
            else
                -- Draw cell content
                local cell_value = self.board.grid[y][x]
                if cell_value == 1 and not self.hide_ships then 
                    love.graphics.setColor(0.3, 0.3, 0.3)
                    love.graphics.rectangle("fill", cell_x + 2, cell_y + 2, self.cell_size - 4, self.cell_size - 4)
                elseif cell_value == 2 then -- Miss
                    love.graphics.setColor(0.2, 0.2, 0.8)
                    love.graphics.circle("fill", cell_x + self.cell_size/2, cell_y + self.cell_size/2, self.cell_size/4)
                elseif cell_value == 3 then -- Hit
                    love.graphics.setColor(0.8, 0.2, 0.2)
                    love.graphics.rectangle("fill", cell_x + 4, cell_y + 4, self.cell_size - 8, self.cell_size - 8)
                end
            end
            love.graphics.setColor(1, 1, 1, 1) -- Reset color
        end
    end
end

return BoardView
