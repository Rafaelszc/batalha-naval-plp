local DBManager = require("src.database.db_manager")
local Ranking = {}

function Ranking:enter()
    DBManager.init()
    self.data = DBManager.get_ranking()
end

function Ranking:draw()
    love.graphics.print("Ranking (Top 10)", 20, 20)
    for i, row in ipairs(self.data) do
        love.graphics.print(i .. ". " .. row.name .. " - " .. row.score, 20, 50 + (i * 30))
    end
end

function Ranking:keypressed(key)
    if key == "escape" then
        require("src.core.state_manager").switch("menu")
    end
end

return Ranking
