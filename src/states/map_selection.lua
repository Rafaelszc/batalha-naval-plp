local Button = require("src.utils.ui")
local MapSelection = {}

function MapSelection:enter()
    local maps = {
        {
            name = "Poça (5x5)", width = 5, height = 5, 
            fleet = {{name = "Pequeno", size = 2}, {name = "Médio", size = 3}, {name = "Grande", size = 4}}
        },
        {
            name = "Lago (8x8)", width = 8, height = 8, 
            fleet = {{name = "Pequeno1", size = 2}, {name = "Pequeno2", size = 2}, {name = "Médio1", size = 3}, {name = "Médio2", size = 3}, {name = "Grande", size = 4}}
        },
        {
            name = "Oceano (10x10)", width = 10, height = 10, 
            fleet = {{name = "Pequeno1", size = 2}, {name = "Pequeno2", size = 2}, {name = "Pequeno3", size = 2}, {name = "Médio1", size = 3}, {name = "Médio2", size = 3}, {name = "Grande1", size = 4}, {name = "Grande2", size = 5}}
        }
    }
    
    self.buttons = {}
    for i, map in ipairs(maps) do
        table.insert(self.buttons, Button.new(map.name, 500, 200 + (i * 60), 200, 50, function()
            _G.selected_map = map
            require("src.core.state_manager").switch("ship_placement")
        end))
    end
end

function MapSelection:update(dt)
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(self.buttons) do
        btn:update(dt, mx, my)
    end
end

function MapSelection:draw()
    love.graphics.print("Selecione o Mapa:", 20, 20)
    for _, btn in ipairs(self.buttons) do
        btn:draw()
    end
end

function MapSelection:mousepressed(x, y, button)
    for _, btn in ipairs(self.buttons) do
        btn:mousepressed(x, y, button)
    end
end

return MapSelection
