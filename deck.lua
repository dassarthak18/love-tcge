-- deck/deck.lua

local Deck = {}
Deck.__index = Deck

-- Constructor
function Deck:new(num_decks, num_jokers, suits, ranks)
    local self = setmetatable({}, Deck)
    self.suits = suits
    self.ranks = ranks
    self.cards = {}

    -- Add suit–rank combinations
    for _ = 1, num_decks do
        for _, suit in ipairs(suits) do
            for _, rank in ipairs(ranks) do
                table.insert(self.cards, { suit, rank })
            end
        end
    end

    -- Add jokers (alternate black/red)
    for i = 1, num_jokers do
        local color = (i % 2 == 1) and "black" or "red"
        table.insert(self.cards, { color, "joker" })
    end

    return self
end

-- Shuffle in place
function Deck:shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

-- Convenience builder from a config table
local function build_deck_from_config(config_table, shuffle_flag)
    local N = config_table.num_decks or 1
    local J = config_table.jokers    or 0
    local suits = config_table.suits or {"clubs","diamonds","hearts","spades"}
    local ranks = config_table.ranks or {
        "ace","2","3","4","5","6","7","8","9","10","jack","queen","king"
    }

    local deck = Deck:new(N, J, suits, ranks)
    if shuffle_flag ~= false then
        deck:shuffle()
    end
    return deck
end

Deck.build_from_config = build_deck_from_config

return Deck
