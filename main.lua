-- main.lua

-- Requiere los archivos modulares
local physics = require("physics")
local platforms = require("platforms")
local floorModule = require("floor")

-- Definición de las propiedades del jugador
local player = {
    x = 400,             -- Posición inicial en el eje x
    y = 300,             -- Posición inicial en el eje y
    vy = 0,              -- Velocidad vertical inicial
    s = 200,             -- Velocidad de movimiento lateral
    jumpHeight = -500,   -- Altura del salto
    width = 32,          -- Ancho del jugador
    height = 32,          -- Altura del jugador 
    sprite = love.graphics.newImage('sprites/sprite_char_a_stand/spr_a.png')
}

-- Variables para controlar el estado del juego y los datos del nivel
local gameState = "startMenu"
local platformsData = nil
local floorData = nil

-- Función para cargar el juego
function love.load()
    love.window.setTitle("Platformer Game")  -- Título de la ventana
    love.window.setMode(800, 600)            -- Tamaño de la ventana
end

-- Función para actualizar el estado del juego
function love.update(dt)
    if gameState == "startMenu" then
        if love.keyboard.isDown("return") then
            startGame()  -- Iniciar el juego al presionar Enter
        end
    elseif gameState == "gameplay" then
        physics.updatePlayer(player, platformsData, floorData, dt)  -- Actualizar el juego en el estado de gameplay
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
    -- Cargar las plataformas según el nivel seleccionado
    platformsData = platforms.generate(1)  -- Se carga el nivel 1 como ejemplo
    -- Cargar el suelo
    floorData = floorModule.generate()
end

-- Función para dibujar el menú de inicio
function drawStartMenu()
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("Press Enter to Start", 0, 300, 800, "center")
end

-- Función para dibujar el gameplay
function drawGameplay()
    love.graphics.setColor(255, 255, 255)    -- Establecer el color blanco para dibujar el jugador

    love.graphics.setColor(0, 255, 0)        -- Establecer el color verde para dibujar las plataformas

    -- Dibujar las plataformas como rectángulos verdes
    for _, platform in ipairs(platformsData) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.l, platform.h)
    end

    love.graphics.setColor(0, 0, 255)        -- Establecer el color azul para dibujar el suelo

    -- Dibujar el suelo como un rectángulo azul
    love.graphics.rectangle("fill", 0, floorData.y, floorData.l, floorData.h)
    love.graphics.draw(player.sprite, player.x, player.y)
end

-- Función para comprobar colisiones entre dos rectángulos
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
