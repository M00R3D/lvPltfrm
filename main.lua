-- Definición de las propiedades del jugador
player = {
    x = 400,             -- Posición inicial en el eje x
    y = 300,             -- Posición inicial en el eje y
    vy = 0,              -- Velocidad vertical inicial
    s = 200,             -- Velocidad de movimiento lateral
    jumpHeight = -500,   -- Altura del salto
    width = 32,          -- Ancho del jugador
    height = 32,          -- Altura del jugador 
    sprite = nil
}

-- Definición de las plataformas
local platforms = nil  -- Será definido después según el nivel seleccionado

-- Definición del suelo
local floor = {
    y = 500,   -- Posición en el eje y
    l = 800,   -- Longitud
    h = 20     -- Altura
}

-- Variable para controlar el estado del juego
local gameState = "startMenu"

-- Función para cargar el juego
function love.load()
    love.window.setTitle("Platformer Game")  -- Título de la ventana
    love.window.setMode(800, 600)            -- Tamaño de la ventana
    player.sprite = love.graphics.newImage('sprites/sprite_char_a_stand/sprite_char_a_stand.png')
    SPRITE_WIDTH,SPRITE_HEIGHT = 348,32
    QUAD_WIDTH=32
    QUAD_HEIGHT=SPRITE_HEIGHT
    
    quads={}
    for i=1,12 do
        quads[i]=love.graphics.newQuad(0,0,QUAD_WIDTH*(i-1),QUAD_HEIGHT,SPRITE_WIDTH,SPRITE_HEIGHT)
    end
   
end

-- Función para actualizar el estado del juego
function love.update(dt)
    if gameState == "startMenu" then
        if love.keyboard.isDown("return") then
            startGame()  -- Iniciar el juego al presionar Enter
        end
    elseif gameState == "gameplay" then
        updateGameplay(dt)  -- Actualizar el juego en el estado de gameplay
        
    end
end

-- Función para dibujar los elementos del juego en la pantalla
function love.draw()
    if gameState == "startMenu" then
        drawStartMenu()  -- Dibujar el menú de inicio
    elseif gameState == "gameplay" then
        drawGameplay()   -- Dibujar el gameplay
    end
end

-- Función para iniciar el juego
function startGame()
    gameState = "gameplay"  -- Cambiar al estado de gameplay
    -- Definir las plataformas según el nivel seleccionado
    platforms = {
        {x = 100, y = 400, l = 200, h = 20},  -- Primera plataforma
        {x = 500, y = 200, l = 150, h = 20},  -- Segunda plataforma
        {x = 300, y = 600, l = 150, h = 20},  -- Tercera plataforma
        -- Puedes añadir más plataformas aquí si lo deseas
    }
end

-- Función para dibujar el menú de inicio
function drawStartMenu()
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("Press Enter to Start", 0, 300, 800, "center")
end

-- Función para dibujar el gameplay
function drawGameplay()
    love.graphics.setColor(255, 255, 255)    -- Establecer el color blanco para dibujar el jugador

    -- Dibujar el jugador como un rectángulo blanco
    love.graphics.draw(player.sprite,quads[4], player.x, player.y)

    love.graphics.setColor(0, 255, 0)        -- Establecer el color verde para dibujar las plataformas

    -- Dibujar las plataformas como rectángulos verdes
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.l, platform.h)
    end

    love.graphics.setColor(0, 0, 255)        -- Establecer el color azul para dibujar el suelo

    -- Dibujar el suelo como un rectángulo azul
    love.graphics.rectangle("fill", 0, floor.y, floor.l, floor.h)
    love.graphics.draw(player.sprite,quads[1], player.x, player.y)
end

-- Función para actualizar el estado de gameplay
function updateGameplay(dt)
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
