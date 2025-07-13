local deckBuilder = require 'deck.deck_builder'

function love.load()
    love.window.setMode(0, 0, { fullscreen = true })  -- Fullscreen on startup
    deckBuilder.load()
end

function love.update(dt)
    deckBuilder.update(dt)
end

function love.draw()
    deckBuilder.draw()
end

function love.mousepressed(x, y, button)
    if deckBuilder.mousepressed then
        deckBuilder.mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    if key == "f11" then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen)
    elseif key == "escape" then
        love.event.quit()
    end

    if deckBuilder.keypressed then
        deckBuilder.keypressed(key)
    end
end

function love.textinput(t)
    if deckBuilder.textinput then
        deckBuilder.textinput(t)
    end
end

