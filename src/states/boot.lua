local Boot = {}

function Boot:enter()
    print("Boot State Entered")
    self.timer = 0
end

function Boot:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 then
        require("src.core.state_manager").switch("loading")
    end
end

function Boot:draw()
    love.graphics.print("Booting...", 20, 20)
end

function Boot:leave()
end

return Boot
