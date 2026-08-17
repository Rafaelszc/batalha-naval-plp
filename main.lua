local StateManager = require("src.core.state_manager")

function love.load()
    StateManager.init("boot")
end

function love.update(dt)
    StateManager.update(dt)
end

function love.draw()
    StateManager.draw()
end

function love.mousepressed(x, y, button)
    StateManager.mousepressed(x, y, button)
end

function love.textinput(t)
    if StateManager.textinput then
        StateManager.textinput(t)
    end
end

function love.keypressed(key)
    if StateManager.keypressed then
        StateManager.keypressed(key)
    end
end
