---TODO:reescribir el codigo y leerlo bien

local player = {x = 400, y = 300, vy = 0, s = 200, jumpHeight = -500}
local platforms = {
    {x = 100, y = 400, l = 200, h = 20}, -- Primer plataforma
    {x = 500, y = 200, l = 150, h = 20}, -- Segunda plataforma
    -- Puedes añadir más plataformas aquí si lo deseas
}
local floor = {y = 500, l = 800, h = 20} -- Suelo

function love.load()
    love.window.setTitle("Player Movement")
    love.window.setMode(800, 600)
end

function love.update(dt)
    local dx, dy = 0, 0
    local k = love.keyboard.isDown

    -- Aplicar gravedad al jugador
    player.vy = player.vy + 700 * dt
    player.y = player.y + player.vy * dt

    -- Colisión con el suelo
    if player.y + 50 > floor.y then
        player.y = floor.y - 50
        player.vy = 0
    end

    -- Colisión con las plataformas
    for _, platform in ipairs(platforms) do
        if checkCollision(player.x, player.y, 50, 50, platform.x, platform.y, platform.l, platform.h) then
            -- Si hay colisión, colocar al jugador en la parte superior de la plataforma
            player.y = platform.y - 50
            player.vy = 0
        end
    end

    -- Movimiento horizontal del jugador
    if k("w", "up") then
        if player.vy == 0 then
            player.vy = player.jumpHeight
        end
    end

    if k("a", "left") then
        dx = -player.s * dt
    elseif k("d", "right") then
        dx = player.s * dt
    end

    player.x = player.x + dx
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)

    love.graphics.setColor(0, 255, 0) -- Color verde para las plataformas
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.l, platform.h)
    end

    love.graphics.setColor(0, 0, 255) -- Color azul para el suelo
    love.graphics.rectangle("fill", 0, floor.y, floor.l, floor.h)
end

-- Función para comprobar colisiones entre dos rectángulos
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
