local Board = require("src.models.board")
local Ship = require("src.models.ship")
local EasyAI = require("src.services.ai.easy_ai")
local Missile = require("src.services.weapons.missile")
local Torpedo = require("src.services.weapons.torpedo")

local GameController = {}
GameController.__index = GameController

function GameController.new(width, height, fleet_defs)
    local self = setmetatable({}, GameController)
    self.player_board = Board.new(width, height)
    self.enemy_board = Board.new(width, height)
    
    local function create_fleet(defs)
        local fleet = {}
        for _, def in ipairs(defs) do
            table.insert(fleet, Ship.new(def.name, def.size))
        end
        return fleet
    end
    
    self.player_board:place_randomly(create_fleet(fleet_defs))
    self.enemy_board:place_randomly(create_fleet(fleet_defs))
    
    self.turn = "player"
    self.ai = EasyAI.new()
    
    self.player_score = 0
    self.used_weapons = {missile = false, torpedo = false}
    self.fog_turns = 0
    return self
end

function GameController:is_fog_active()
    return self.fog_turns > 0
end

function GameController:process_shot(board_type, x, y)
    -- RF07: Validate bounds
    local target_board = (board_type == "enemy") and self.enemy_board or self.player_board
    if x < 1 or x > target_board.width or y < 1 or y > target_board.height then
        return "out_of_bounds", nil
    end
    
    local result = target_board:receive_shot(x, y)
    local event_msg = nil
    
    if result ~= "already_shot" then
        if board_type == "enemy" and result == "hit" then
            self.player_score = self.player_score + 1
        elseif board_type == "player" and result == "hit" then
            self.player_score = self.player_score - 1
        end
        
        self.turn = (self.turn == "player") and "enemy" or "player"
        
        -- Reduce fog turns
        if self.fog_turns > 0 then self.fog_turns = self.fog_turns - 1 end
        
        -- Eventos aleatórios (5% de chance cada)
        local roll = love.math.random()
        if roll < 0.05 then
            self.fog_turns = 3
            event_msg = "Névoa de Guerra Ativada!"
        elseif roll < 0.10 then
            event_msg = self:trigger_rough_sea(target_board)
        end
    end
    
    return result, event_msg
end

function GameController:trigger_rough_sea(board)
    local rx = love.math.random(1, board.width)
    local ry = love.math.random(1, board.height)
    return "Mar Agitado! A água revelou posições em (" .. rx .. "," .. ry .. ")"
end

function GameController:fire_weapon(weapon_type, board_type, x, y, extra_param)
    -- Check if weapon was already used
    if weapon_type ~= "normal" and self.used_weapons[weapon_type] then
        return "already_used", nil
    end
    
    local target_board = (board_type == "enemy") and self.enemy_board or self.player_board
    local result
    
    if weapon_type == "missile" then
        local missile = Missile.new()
        result = missile:fire(target_board, x, y)
        self.used_weapons.missile = true
    elseif weapon_type == "torpedo" then
        local torpedo = Torpedo.new()
        result = torpedo:fire(target_board, x, y, extra_param)
        self.used_weapons.torpedo = true
    else
        return self:process_shot(board_type, x, y)
    end
    
    self.turn = (self.turn == "player") and "enemy" or "player"
    return result, nil
end

function GameController:check_game_over()
    -- RF09: Check if all ships are sunk
    local function all_sunk(board)
        if #board.ships == 0 then return false end -- Board with no ships shouldn't trigger game over
        for _, ship in ipairs(board.ships) do
            if not ship:is_sunk() then return false end
        end
        return true
    end
    
    if all_sunk(self.enemy_board) then return "player_win" end
    if all_sunk(self.player_board) then return "enemy_win" end
    return nil
end

function GameController:run_ai_turn()
    if self.turn == "enemy" then
        local x, y = self.ai:get_move(self.player_board)
        return self:process_shot("player", x, y)
    end
    return nil
end

return GameController
