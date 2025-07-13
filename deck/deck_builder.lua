local db_ui = require 'deck.db_ui'
local Deck = require 'deck.deck'

local SUIT_LIST = { "Hearts", "Diamonds", "Clubs", "Spades" }
local RANK_LIST = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }

local deckBuilder = {}

local deck_config = {
    suits = {},
    ranks = {},
    designIndex = 1,
    num_decks = 1,
    jokers = 0
}

for _, S in ipairs(SUIT_LIST) do deck_config.suits[S] = true end
for _, R in ipairs(RANK_LIST) do deck_config.ranks[R] = true end

local gameStarted = false
local deck = nil
local card_images = {}

local function onStart()
    local N = deck_config.num_decks or 1
    local J = deck_config.jokers or 0

    local chosen_suits, chosen_ranks = {}, {}

    for _, S in ipairs(SUIT_LIST) do
        if deck_config.suits[S] then table.insert(chosen_suits, S:lower()) end
    end

    for _, R in ipairs(RANK_LIST) do
        if deck_config.ranks[R] then table.insert(chosen_ranks, R:lower()) end
    end

    deck = Deck:new(N, J, chosen_suits, chosen_ranks)
    deck:shuffle()

    card_images = {}

    for _, c in ipairs(deck.cards) do
        local color, kind = c[1], c[2]
        local key = (kind == "joker") and ("joker_" .. color) or (color .. "_" .. kind)

        if not card_images[key] then
            local path = "assets/cards/fronts/" .. key .. ".png"
            if love.filesystem.getInfo(path) then
                card_images[key] = love.graphics.newImage(path)
            end
        end
    end

    gameStarted = true
end

function deckBuilder.load()
    love.graphics.setBackgroundColor(0.04, 0.15, 0.04)
    db_ui.init()
end

function deckBuilder.update(dt)
end

function deckBuilder.draw()
    if not gameStarted then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 20, 20, 450, love.graphics.getHeight() - 60, 10, 10)
        db_ui.draw(deck_config)
    else
        love.graphics.setColor(1, 1, 1)

        local screenW, screenH = love.graphics.getDimensions()
        local margin = 20
        local spacing = 4

        local sample_img = next(card_images) and card_images[next(card_images)]
        if not sample_img then return end

        local cardW, cardH = sample_img:getWidth(), sample_img:getHeight()
        local targetCardW = (screenW - 2 * margin - 11 * spacing) / 12
        local maxScale = screenW < 1000 and 0.4 or 0.5
        local scale = math.min(maxScale, targetCardW / cardW)
        local scaledW, scaledH = cardW * scale, cardH * scale

        local perRow = math.floor((screenW - 2 * margin + spacing) / (scaledW + spacing))
        local x0 = margin
        local y0 = margin

        for i, c in ipairs(deck.cards) do
            local color, kind = c[1], c[2]
            local key = (kind == "joker") and ("joker_" .. color) or (color .. "_" .. kind)
            local img = card_images[key]

            if img then
                local col = (i - 1) % perRow
                local row = math.floor((i - 1) / perRow)

                local x = x0 + col * (scaledW + spacing)
                local y = y0 + row * (scaledH + spacing)

                love.graphics.draw(img, x, y, 0, scale, scale)
            end
        end

        -- Draw selected back design in bottom-left, matching front card size
        local backName = deck_config.selectedDesign or "blue2.png"
        local backPath = "assets/cards/backs/" .. backName

        if love.filesystem.getInfo(backPath) then
            local backImg = love.graphics.newImage(backPath)

            local imgW, imgH = backImg:getWidth() * scale, backImg:getHeight() * scale
            local backX = 20
            local backY = screenH - imgH - 20

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(backImg, backX, backY, 0, scale, scale)

            -- Optional: add label below the back image
            -- love.graphics.setFont(love.graphics.newFont(14))
            -- love.graphics.setColor(1, 1, 1)
            -- love.graphics.print(backName, backX, backY + imgH + 5)
        end
    end
end

function deckBuilder.mousepressed(x, y, button)
    if not gameStarted then
        db_ui.mousepressed(x, y, deck_config, onStart)
    end
end

function deckBuilder.keypressed(key)
    if not gameStarted then
        db_ui.keypressed(key)
    end
end

function deckBuilder.textinput(t)
    if not gameStarted then
        db_ui.textinput(t)
    end
end

return deckBuilder

