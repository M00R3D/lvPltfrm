-- physics.lua

local physics = {}

function physics.updatePlayer(player, platforms, floor, dt)
    local dx, dy = 0, 0                      -- Cambio en las coordenadas x e y del jugador
    local k = love.keyboard.isDown           -- Función para verificar si se presiona una tecla

    -- Aplicar gravedad al jugador
    player.vy = player.vy + 700 * dt         -- Aumentar la velocidad vertical del jugador debido a la gravedad
    player.y = player.y + player.vy * dt     -- Actualizar la posición vertical del jugador

    -- Colisión con el suelo
    if player.y + player.height > floor.y then
        player.y = floor.y - player.height    -- Reposicionar al jugador en la parte superior del suelo
        player.vy = 0                         -- Detener la velocidad vertical del jugador
    end

    -- Colisión con las plataformas
    for _, platform in ipairs(platforms) do
        if checkCollision(player.x, player.y, player.width, player.height, platform.x, platform.y, platform.l, platform.h) then
            -- Si hay colisión, ajustar la posición del jugador
            if player.vy > 0 then  -- Si está cayendo
                player.y = platform.y - player.height  -- Reposicionar al jugador en la parte superior de la plataforma
                player.vy = 0                          -- Detener la caída del jugador
            elseif player.vy < 0 then  -- Si está saltando
                player.y = platform.y + platform.h     -- Reposicionar al jugador en la parte inferior de la plataforma
                player.vy = 0                          -- Detener el salto del jugador
            end
        end
    end

    -- Movimiento horizontal del jugador
    if k("w", "up") then
        if player.vy == 0 then
            player.vy = player.jumpHeight    -- Asignar la altura del salto si el jugador está en el suelo
        end
    end

    if k("a", "left") then
        dx = -player.s * dt                   -- Mover hacia la izquierda
    elseif k("d", "right") then
        dx = player.s * dt                    -- Mover hacia la derecha
    end

    player.x = player.x + dx                 -- Actualizar la posición horizontal del jugador
end

-- Función para comprobar colisiones entre dos rectángulos
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

return physics
