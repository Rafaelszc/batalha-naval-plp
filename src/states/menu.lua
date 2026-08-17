local Button = require("src.utils.ui")
local Menu = {}

function Menu:enter()
    self.player_name = ""
    local screen_w = love.graphics.getWidth()
    local btn_w = 200
    local center_x = (screen_w - btn_w) / 2
    
    self.play_button = Button.new("Jogar", center_x, 300, btn_w, 50, function()
        if self.player_name ~= "" then
            _G.player_name = self.player_name
            require("src.core.state_manager").switch("map_selection")
        end
    end)
    self.ranking_button = Button.new("Ranking", center_x, 360, btn_w, 50, function()
        require("src.core.state_manager").switch("ranking")
    end)
    self.quit_button = Button.new("Sair", center_x, 420, btn_w, 50, function()
        love.event.quit()
    end)
end

function Menu:update(dt)
    local mx, my = love.mouse.getPosition()
    self.play_button:update(dt, mx, my)
    self.ranking_button:update(dt, mx, my)
    self.quit_button:update(dt, mx, my)
end

function Menu:draw()
    local screen_w = love.graphics.getWidth()
    local title = "Menu Principal"
    local name_text = self.player_name == "" and "Digite seu nome..." or "Nome: " .. self.player_name
    
    love.graphics.printf(title, 0, 20, screen_w, "center")
    love.graphics.printf(name_text, 0, 50, screen_w, "center")
    
    self.play_button:draw()
    self.ranking_button:draw()
    self.quit_button:draw()
end

function Menu:textinput(t)
    self.player_name = self.player_name .. t
end

function Menu:keypressed(key)
    if key == "backspace" then
        self.player_name = string.sub(self.player_name, 1, -2)
    end
end

function Menu:mousepressed(x, y, button)
    self.play_button:mousepressed(x, y, button)
    self.ranking_button:mousepressed(x, y, button)
    self.quit_button:mousepressed(x, y, button)
end

function Menu:leave()
end

return Menu
