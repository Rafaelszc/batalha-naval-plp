local Loading = {}

function Loading:enter()
    print("Loading State Entered")
    self.timer = 0
end

function Loading:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then -- Simulate loading time
        require("src.core.state_manager").switch("menu")
    end
end

function Loading:draw()
    love.graphics.print("Loading Assets: " .. math.floor(self.timer * 100) .. "%", 20, 20)
end

function Loading:leave()
end

return Loading
