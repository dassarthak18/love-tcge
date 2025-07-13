-- Stylish and Responsive UI for Deck Configuration
local ui = {}

local SUIT_LIST = { "Hearts", "Diamonds", "Clubs", "Spades" }
local RANK_LIST = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }

local DESIGN_DIR = "assets/cards/backs"
local designs = {}

local titleFont, labelFont, inputFont
local COLORS = {
    background = { 0.12, 0.12, 0.15 },
    text = { 1, 1, 1 },
    highlight = { 1, 0.85, 0.2 },
    button = { 0.2, 0.7, 0.3 },
    buttonText = { 0.05, 0.05, 0.05 },
    checkboxBorder = { 0.8, 0.8, 0.8 },
    checkboxFill = { 0.3, 0.85, 0.3 },
    inputBorder = { 0.7, 0.7, 0.8 },
}

local function loadDesigns()
    designs = {}
    for _, file in ipairs(love.filesystem.getDirectoryItems(DESIGN_DIR)) do
        if file:match("%.png$") then table.insert(designs, file) end
    end
    if #designs == 0 then designs = { "blue2.png" } end
end

function ui.init()
    loadDesigns()
    titleFont = love.graphics.newFont("assets/fonts/OpenSans-Bold.ttf", 32)
    labelFont = love.graphics.newFont("assets/fonts/OpenSans-Regular.ttf", 18)
    inputFont = love.graphics.newFont("assets/fonts/OpenSans-Regular.ttf", 22)
end

local active_input = nil
local focusIndex = 1
local inputs = { num_decks = "1", jokers = "2" }
local elements = {}
local currentConfig = {}

local function clearElements() elements = {} end
local function register(el) table.insert(elements, el) end

local function highlight(x, y, w, h)
    love.graphics.setColor(COLORS.highlight)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x - 2, y - 2, w + 4, h + 4, 6, 6)
    love.graphics.setLineWidth(1)
end

local function drawCheckbox(label, checked, x, y, size)
    local idx = #elements + 1
    local labelW = labelFont:getWidth(label)
    if idx == focusIndex then highlight(x, y, size + 8 + labelW, size) end

    love.graphics.setColor(COLORS.checkboxBorder)
    love.graphics.rectangle("line", x, y, size, size, 4, 4)

    if checked then
        love.graphics.setColor(COLORS.checkboxFill)
        love.graphics.rectangle("fill", x + 4, y + 4, size - 8, size - 8, 2, 2)
    end

    love.graphics.setColor(COLORS.text)
    love.graphics.setFont(labelFont)
    love.graphics.print(label, x + size + 8, y)
    register({ type = "checkbox", key = label, x = x, y = y, w = size + 8 + labelW, h = size })
end

local function drawInput(label, key, x, y, w, h)
    local idx = #elements + 1
    local labelW = labelFont:getWidth(label)
    local labelH = labelFont:getHeight()
    local bx, by = x + labelW + 20, y
    if idx == focusIndex then highlight(bx, by, w, h) end

    love.graphics.setFont(labelFont)
    love.graphics.setColor(COLORS.text)
    love.graphics.print(label, x, y + (h - labelH) / 2)

    love.graphics.setColor(COLORS.inputBorder)
    love.graphics.rectangle("line", bx, by, w, h, 6, 6)

    love.graphics.setFont(inputFont)
    local text = inputs[key] or ""
    local textW = inputFont:getWidth(text)
    local txtX = bx + (w - textW) / 2
    love.graphics.setColor(COLORS.text)
    love.graphics.print(text, txtX, by + (h - inputFont:getHeight()) / 2)

    if active_input == key then
        love.graphics.line(txtX + textW, by + 5, txtX + textW, by + h - 5)
    end
    register({ type = "input", key = key, x = bx, y = by, w = w, h = h })
end

local function drawDesign(x, y, h)
    local spacing, arrowW = 20, h
    local idx = #elements + 1
    currentConfig.designIndex = currentConfig.designIndex or 1
    local filename = designs[currentConfig.designIndex]

    if idx == focusIndex then highlight(x, y, 300 + spacing * 3, h) end

    love.graphics.setColor(COLORS.text)
    love.graphics.setFont(labelFont)
    love.graphics.print("Back Design:", x, y)

    local prevX = x + 150
    love.graphics.printf("<", prevX, y, arrowW, "center")
    register({ type = "design_prev", x = prevX, y = y, w = arrowW, h = h })

    local nameX = prevX + arrowW + spacing
    love.graphics.printf(filename, nameX, y, 150, "left")
    register({ type = "design_name", x = nameX, y = y, w = 150, h = h })

    local nextX = nameX + 150 + spacing
    love.graphics.printf(">", nextX, y, arrowW, "center")
    register({ type = "design_next", x = nextX, y = y, w = arrowW, h = h })

    local img = love.graphics.newImage(DESIGN_DIR .. "/" .. filename)
    local thumbSize = h * 2
    local scale = thumbSize / img:getHeight()
    love.graphics.draw(img, nextX + arrowW + spacing, y - (thumbSize - h) / 2, 0, scale, scale)
    register({ type = "design_thumb", x = nextX + arrowW + spacing, y = y - (thumbSize - h) / 2, w = thumbSize, h = thumbSize })
end

local function drawButton(label, x, y, w, h)
    local idx = #elements + 1
    if idx == focusIndex then highlight(x, y, w, h) end

    love.graphics.setColor(COLORS.button)
    love.graphics.rectangle("fill", x, y, w, h, 12, 12)

    love.graphics.setColor(COLORS.buttonText)
    love.graphics.setFont(titleFont)
    love.graphics.printf(label, x, y + (h - titleFont:getHeight()) / 2, w, "center")

    register({ type = "button", key = "start", x = x, y = y, w = w, h = h })
end

function ui.draw(deck_config)
    currentConfig = deck_config or {}
    clearElements()
    local w, h = love.graphics.getDimensions()
    local inputW = math.floor(w * 0.08)
    local inputH = math.floor(h * 0.05)
    local checkboxSize = math.floor(h * 0.025)
    local spacing = math.floor(h * 0.015)

    love.graphics.setColor(COLORS.background)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setFont(titleFont)
    love.graphics.setColor(COLORS.highlight)
    love.graphics.printf("Deck Configuration", 0, spacing, w, "center")

    local x = w * 0.1
    local y = spacing * 3 + titleFont:getHeight()

    drawInput("Number of Decks:", "num_decks", x, y, inputW, inputH)
    y = y + inputH + spacing
    drawInput("Number of Jokers:", "jokers", x, y, inputW, inputH)
    y = y + inputH + spacing * 2

    love.graphics.setColor(COLORS.text)
    love.graphics.setFont(labelFont)
    love.graphics.print("Suits:", x, y)
    y = y + spacing * 2

    local sx, sy = x, y
    local colW = w * 0.15
    for i, s in ipairs(SUIT_LIST) do
        drawCheckbox(s, deck_config.suits and deck_config.suits[s], sx, sy, checkboxSize)
        sy = sy + checkboxSize + spacing
        if i % 2 == 0 then
            sx = sx + colW
            sy = y
        end
    end
    y = y + checkboxSize * 2 + spacing * 4
    love.graphics.print("Ranks:", x, y)
    y = y + spacing * 2

    sx, sy = x, y
    for i, r in ipairs(RANK_LIST) do
        drawCheckbox(r, deck_config.ranks and deck_config.ranks[r], sx, sy, checkboxSize)
        sy = sy + checkboxSize + spacing
        if i % 7 == 0 then
            sx = sx + colW
            sy = y
        end
    end

    local bottomY = h - (inputH * 2 + spacing * 5 + h * 0.07)
    drawDesign(x, bottomY, inputH)

    local bw, bh = math.floor(w * 0.25), math.floor(h * 0.07)
    local bx = (w - bw) / 2
    drawButton("Build Deck", bx, h - bh - spacing * 2, bw, bh)
end

function ui.mousepressed(x, y, deck_config, onStart)
    for i, el in ipairs(elements) do
        if x >= el.x and x <= el.x + el.w and y >= el.y and y <= el.y + el.h then
            focusIndex = i
            active_input = nil
            if el.type == "input" then
                active_input = el.key
            elseif el.type == "checkbox" then
                if deck_config.suits and deck_config.suits[el.key] ~= nil then
                    deck_config.suits[el.key] = not deck_config.suits[el.key]
                elseif deck_config.ranks and deck_config.ranks[el.key] ~= nil then
                    deck_config.ranks[el.key] = not deck_config.ranks[el.key]
                end
            elseif el.type == "design_prev" then
                deck_config.designIndex = ((deck_config.designIndex or 1) - 2) % #designs + 1
            elseif el.type == "design_next" or el.type == "design_thumb" then
                deck_config.designIndex = ((deck_config.designIndex or 1) % #designs) + 1
            elseif el.type == "button" then
                deck_config.num_decks = tonumber(inputs.num_decks) or 1
                deck_config.jokers = tonumber(inputs.jokers) or 0
                deck_config.selectedDesign = designs[deck_config.designIndex or 1]
                onStart()
            end
            return
        end
    end
end

function ui.keypressed(key)
    if key == "tab" then
        local isShift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
        local dir = isShift and -1 or 1
        focusIndex = ((focusIndex - 1 + dir + #elements) % #elements) + 1
        local el = elements[focusIndex]
        if el.type == "input" then active_input = el.key else active_input = nil end
    end
    if key == "space" then
        local el = elements[focusIndex]
        if el and el.type == "checkbox" then
            if currentConfig.suits and currentConfig.suits[el.key] ~= nil then
                currentConfig.suits[el.key] = not currentConfig.suits[el.key]
            elseif currentConfig.ranks and currentConfig.ranks[el.key] ~= nil then
                currentConfig.ranks[el.key] = not currentConfig.ranks[el.key]
            end
        elseif el and (el.type == "design_prev" or el.type == "design_next" or el.type == "design_thumb") then
            if el.type == "design_prev" then
                currentConfig.designIndex = ((currentConfig.designIndex or 1) - 2) % #designs + 1
            else
                currentConfig.designIndex = ((currentConfig.designIndex or 1) % #designs) + 1
            end
        end
    end
    if active_input and key == "backspace" then
        inputs[active_input] = inputs[active_input]:sub(1, -2)
    end
end

function ui.textinput(t)
    if active_input and t:match("%d") then
        inputs[active_input] = inputs[active_input] .. t
    end
end

return ui

