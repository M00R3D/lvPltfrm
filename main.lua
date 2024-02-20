-- Definición de las propiedades del jugador
local player = {
    x = 400,             -- Posición inicial en el eje x
    y = 300,             -- Posición inicial en el eje y
    vy = 0,              -- Velocidad vertical inicial
    s = 200,             -- Velocidad de movimiento lateral
    jumpHeight = -500,    -- Altura del salto
    vFlag=1
}

-- Definición de las plataformas
local platforms = {
    {x = 100, y = 400, l = 200, h = 20},  -- Primera plataforma
    {x = 500, y = 200, l = 150, h = 20},  -- Segunda plataforma
    {x = 300, y = 400, l = 150, h = 20}  -- Tercera plataforma
    -- Puedes añadir más plataformas aquí si lo deseas
}

-- Definición del suelo
local floor = {
    y = 500,   -- Posición en el eje y
    l = 800,   -- Longitud
    h = 20     -- Altura
}

-- Función para cargar el juego
function love.load()
    love.window.setTitle("Player Movement")  -- Título de la ventana
    love.window.setMode(800, 600)            -- Tamaño de la ventana
end

-- Función para actualizar el estado del juego
function love.update(dt)
    local dx, dy = 0, 0                      -- Cambio en las coordenadas x e y del jugador
    local k = love.keyboard.isDown           -- Función para verificar si se presiona una tecla

    -- Aplicar gravedad al jugador
    player.vy = player.vy + (700*player.vFlag) * dt         -- Aumentar la velocidad vertical del jugador debido a la gravedad
    player.y = player.y + player.vy * dt     -- Actualizar la posición vertical del jugador

    -- Colisión con el suelo
    if player.y + 50 > floor.y then
        player.y = floor.y - 50               -- Reposicionar al jugador en la parte superior del suelo
        player.vy = 0                         -- Detener la velocidad vertical del jugador
    end

    -- Colisión con las plataformas
    for _, platform in ipairs(platforms) do
        if checkCollision(player.x, player.y, 50, 50, platform.x, platform.y, platform.l, platform.h) then
            player.vy = 0                     -- Detener la velocidad vertical del jugador
            player.vFlag=0
            else
                 player.vFlag=1 
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

-- Función para dibujar los elementos del juego en la pantalla
function love.draw()
    love.graphics.setColor(255, 255, 255)    -- Establecer el color blanco para dibujar el jugador

    -- Dibujar el jugador como un rectángulo blanco
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)

    love.graphics.setColor(0, 255, 0)        -- Establecer el color verde para dibujar las plataformas

    -- Dibujar las plataformas como rectángulos verdes
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.l, platform.h)
    end

    love.graphics.setColor(0, 0, 255)        -- Establecer el color azul para dibujar el suelo

    -- Dibujar el suelo como un rectángulo azul
    love.graphics.rectangle("fill", 0, floor.y, floor.l, floor.h)
end

-- Función para comprobar colisiones entre dos rectángulos
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
