local EasyAI = {}
EasyAI.__index = EasyAI

function EasyAI.new()
    return setmetatable({}, EasyAI)
end

function EasyAI:get_move(board)
    -- Random move
    local x, y
    repeat
        x = love.math.random(1, board.width)
        y = love.math.random(1, board.height)
    until board.grid[y][x] == 0 or board.grid[y][x] == 1
    return x, y
end

return EasyAI
