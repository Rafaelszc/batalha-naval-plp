local Button = {}
Button.__index = Button

function Button.new(text, x, y, width, height, callback)
    local self = setmetatable({}, Button)
    self.text = text
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.callback = callback
    self.is_hovered = false
    return self
end

function Button:update(dt, mx, my)
    self.is_hovered = mx >= self.x and mx <= self.x + self.width and
                      my >= self.y and my <= self.y + self.height
end

function Button:draw()
    if self.is_hovered then
        love.graphics.setColor(0.2, 0.6, 1) -- Hover color
    else
        love.graphics.setColor(0.1, 0.4, 0.8) -- Normal color
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.text, self.x, self.y + self.height/4, self.width, "center")
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.is_hovered then
        self.callback()
    end
end

return Button
