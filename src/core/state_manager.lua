local StateManager = {}
local current_state = nil
local states = {}

function StateManager.init(initial_state)
    states["boot"] = require("src.states.boot")
    states["loading"] = require("src.states.loading")
    states["menu"] = require("src.states.menu")
    states["map_selection"] = require("src.states.map_selection")
    states["ship_placement"] = require("src.states.ship_placement")
    states["game"] = require("src.states.game")
    states["ranking"] = require("src.states.ranking")
    StateManager.switch(initial_state)
end

function StateManager.switch(state_name)
    local next_state = states[state_name]
    if type(next_state) ~= "table" then
        error("StateManager: State '" .. state_name .. "' is not a table! It is: " .. type(next_state))
    end
    
    if current_state and current_state.leave then
        current_state:leave()
    end
    current_state = next_state
    if current_state and current_state.enter then
        current_state:enter()
    end
end

function StateManager.update(dt)
    if current_state and current_state.update then
        current_state:update(dt)
    end
end

function StateManager.draw()
    if current_state and current_state.draw then
        current_state:draw()
    end
end

function StateManager.mousepressed(x, y, button)
    if current_state and current_state.mousepressed then
        current_state:mousepressed(x, y, button)
    end
end

function StateManager.textinput(t)
    if current_state and current_state.textinput then
        current_state:textinput(t)
    end
end

function StateManager.keypressed(key)
    if current_state and current_state.keypressed then
        current_state:keypressed(key)
    end
end

return StateManager
