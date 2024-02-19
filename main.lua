local p = {x = 400, y = 300, s = 200}

function love.load()
    love.window.setTitle("Player Movement")
    love.window.setMode(800, 600)
end

function love.update(dt)
    local dx, dy = 0, 0
    local k = love.keyboard.isDown

    if k("w") or k("up") then dy = -p.s * dt
    elseif k("s") or k("down") then dy = p.s * dt end

    if k("a") or k("left") then dx = -p.s * dt
    elseif k("d") or k("right") then dx = p.s * dt end

    p.x, p.y = p.x + dx, p.y + dy
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", p.x, p.y, 50, 50)
end
