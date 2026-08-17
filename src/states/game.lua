local GameController = require("src.controllers.game_controller")
local BoardView = require("src.views.board_view")
local DBManager = require("src.database.db_manager")
local Button = require("src.utils.ui")
local Game = {}

function Game:enter()
    print("Game State Entered")
    local map = _G.selected_map or {width = 10, height = 10, fleet = {}}
    self.controller = GameController.new(map.width, map.height, map.fleet)
    
    self.controller.player_board = _G.player_board or self.controller.player_board
    self.controller.player_board.ships = _G.player_fleet or {}
    
    self.player_view = BoardView.new(self.controller.player_board, 50, 100, 30, false)
    self.enemy_view = BoardView.new(self.controller.enemy_board, 450, 100, 30, true)
    self.player_name = _G.player_name or "Jogador"
    
    self.selected_weapon = "normal"
    self.weapon_buttons = {
        Button.new("Tiro", 50, 500, 80, 40, function() self.selected_weapon = "normal" end),
        Button.new("Míssil", 140, 500, 80, 40, function() self.selected_weapon = "missile" end),
        Button.new("Torpedo", 230, 500, 80, 40, function() self.selected_weapon = "torpedo" end)
    }
    self.event_message = ""
end

function Game:update(dt)
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(self.weapon_buttons) do
        btn:update(dt, mx, my)
    end
    
    if self.event_message ~= "" then
        self.message_timer = (self.message_timer or 0) + dt
        if self.message_timer > 3 then
            self.event_message = ""
            self.message_timer = 0
        end
    end

    if self.controller.turn == "enemy" then
        self.ai_timer = (self.ai_timer or 0) + dt
        if self.ai_timer > 0.5 then
            self.controller:run_ai_turn()
            self.ai_timer = 0
            
            self:check_game_over()
        end
    end
end

function Game:check_game_over()
    local result = self.controller:check_game_over()
    
    if result then
        DBManager.init()
        DBManager.save_score(self.player_name, self.controller.player_score)
        require("src.core.state_manager").switch("menu")
    end
end

function Game:mousepressed(x, y, button)
    for _, btn in ipairs(self.weapon_buttons) do
        btn:mousepressed(x, y, button)
    end

    if button == 1 and self.controller.turn == "player" then
        if x >= self.enemy_view.x and x < self.enemy_view.x + self.enemy_view.board.width * self.enemy_view.cell_size and
           y >= self.enemy_view.y and y < self.enemy_view.y + self.enemy_view.board.height * self.enemy_view.cell_size then
            
            local grid_x = math.floor((x - self.enemy_view.x) / self.enemy_view.cell_size) + 1
            local grid_y = math.floor((y - self.enemy_view.y) / self.enemy_view.cell_size) + 1
            
            local result, event_msg = self.controller:fire_weapon(self.selected_weapon, "enemy", grid_x, grid_y, true)
            
            if event_msg then self.event_message = event_msg end
            
            if result ~= "already_shot" and result ~= "out_of_bounds" then
                self:check_game_over()
            end
        end
    end
end

function Game:draw()
    love.graphics.print("Game State - Turno: " .. self.controller.turn, 20, 20)
    love.graphics.print("Pontuação: " .. self.controller.player_score, 20, 40)
    love.graphics.print("Arma Selecionada: " .. self.selected_weapon, 450, 40)
    
    if self.event_message ~= "" then
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf(self.event_message, 0, 80, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
    end
    
    self.enemy_view.is_fog = self.controller:is_fog_active()
    
    self.player_view:draw()
    self.enemy_view:draw()
    
    for _, btn in ipairs(self.weapon_buttons) do
        local is_used = false
        if btn.text == "Míssil" and self.controller.used_weapons.missile then is_used = true end
        if btn.text == "Torpedo" and self.controller.used_weapons.torpedo then is_used = true end
        
        if is_used then
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height, 10, 10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(btn.text, btn.x, btn.y + btn.height/4, btn.width, "center")
        else
            btn:draw()
        end
    end
end

function Game:leave()
end

return Game
