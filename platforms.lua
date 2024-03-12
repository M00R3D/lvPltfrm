-- platforms.lua

local platforms = {}

function platforms.generate(level)
    -- Lógica para generar las plataformas según el nivel
    if level == 1 then
        return {
            {x = 100, y = 400, l = 200, h = 20},
            {x = 500, y = 200, l = 150, h = 20},
            {x = 300, y = 600, l = 150, h = 20}
        }
    else
        -- Definir lógica para otros niveles si es necesario
        return {}
    end
end

return platforms
