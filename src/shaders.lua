Shaders = {}

-- Cria um shader que não faz nada, apenas renderiza a imagem original.
-- pera pq teria que fazer um shader que faz nada? thanks copilot
-- ah n precisa necessariamente
-- na minha cabeca ia ter tipo a imagem sem mudar nd (que usaria esse noop)
-- e uma imagem mudando cor
-- mas acho q n vai precisar tbh, mas a gente pode fazer como exemplo!
function Shaders.newNoOpShader()
    local shader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            return pixel;
        }
    ]])
    return shader
end

-- Cria um shader que transforma as cores da imagem `img` para a cor `color`.
-- Similar ao que a função `changeColor` fazia, exceto que ao invés de retornar uma imagem
-- alterada, retorna um shader que altera a imagem pra este estado!!
function Shaders.newChangeColorShader(colorsToChange, newColor)
    -- colorsToChange is a table of colors that will be changed to newColor

    local differentiatedColors = {}
    local dr, dg, db = differences_between_colors(colorsToChange[1], newColor)
    for i, color in ipairs(colorsToChange) do
        table.insert(differentiatedColors, {color[1] - dr, color[2] - dg, color[3] - db, color[4]})
    end

    local shader = love.graphics.newShader([[
        extern vec4 colors[ ]] .. #colorsToChange .. [[ ];
        extern vec4 newColors[ ]] .. #differentiatedColors .. [[ ];

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            vec4 newPixel = pixel;

            float closestLength = 1.0 / 0.0; // +Infinity

            for (int i = 0; i < ]] .. #colorsToChange .. [[; i++) {
                // Dai na proxima, a gente calcula a diferenca usando o pixel atualizado
                // sendo q a ideia era sempre comparar com o original...
                vec4 difference = pixel - colors[i];
                float differenceLength = length(difference);
                float epsilon = 0.2;

                // Ver se a cor é próxima o suficiente, e se é a melhor distancia que temos
                if (
                    differenceLength < closestLength
                    && abs(difference.r) < epsilon
                    && abs(difference.g) < epsilon
                    && abs(difference.b) < epsilon
                ) {
                    newPixel = newColors[i];

                    closestLength = differenceLength;
                }
            }

            return newPixel;
        }
    ]])

    shader:send("colors", unpack(colorsToChange))
    shader:send("newColors", unpack(differentiatedColors))
    return shader
end

-- Cria um shader que escurece a imagem. A intensidade do escurecimento é `intensity`, que vai de 0 a 1 (0 deixa a imagem como está, 1 deixa ela completamente escura).
function Shaders.newDarkenShader(intensity)
    local shader = love.graphics.newShader([[
        extern float intensity;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            vec4 newPixel = pixel;

            newPixel.rgb = mix(pixel.rgb, vec3(0.0, 0.0, 0.15), intensity);

            return newPixel;
        }
    ]])

    shader:send("intensity", intensity)
    return shader
end
