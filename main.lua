local player={x = 400, y = 300, speed = 200}
function love.load()
    -- Set window properties
    love.window.setTitle("Player Movement")
    love.window.setMode(800, 600)
end

function love.update(dt)
    -- Handle player movement
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        dy = -player.speed * dt
    elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dy = player.speed * dt
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dx = -player.speed * dt
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dx = player.speed * dt
    end

    -- Update player position
    player.x = player.x + dx
    player.y = player.y + dy
end

function love.draw()
    -- Draw the player
    love.graphics.setColor(255, 255, 255)  -- Set color to white
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)  -- Draw a rectangle representing the player
end
