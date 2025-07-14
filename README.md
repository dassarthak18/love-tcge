# The LÖVE2D Card Games Engine

This is a game engine written in Lua (LÖVE2D) for designing (classics as well as new ones) and playing card games over the internet using the standard 52-card French deck, or its derivatives. Card games can be saved, loaded and shared as JSON files. Think of it as Gary's mod -- but for playing cards.

## Game Types Supported

The following game types (2-6 players only) are supported:

* **Outplay Games.** Each player has a hand of cards and a move consists of playing out one or more cards to the table to achieve some effect. The play ends when some or all of the players have run out of cards to play.
  * **Trick-Taking Games.** A trick consists of each player in turn playing one card face up to the table.
  * **Beating Games.** At your turn you must either beat the card played by the previous player or pick it up (possibly with other cards) and add it to your hand.
  * **Fishing Games.** There is a pool of face-up cards on the table which can be captured by playing a matching card from your hand.
  * **Matching Games.** At your turn you must play a card which matches the previous play or fits into a layout according to some rule.
* **Card Exchange Games.** Each player has a hand of cards and a move consists of exchanging a card or cards. The objective is generally to collect certain cards or combinations of cards.
  * **Draw and Discard Games.** The basic move is to draw a card from the stock and discard one to the discard pile.
  * **Commerce Group.** There is a common pool of cards on the table, and at your turn you exchange one or more cards with the pool.
  * **Quartet Group.** At your turn you can ask another player for a card that you want, and if they have it they must give it to you.
* **Hand Comparison Games.** The result is determined simply by comparing the cards dealt to the players to see which is best, or sometimes simply on the turn of a card or cards to decide whether a player wins or loses.
  * **Showdown Games.** In these games the players' hands are compared with each other and the player with the best hand wins (or the one with the worst hand loses).
  * **Partition Games.** The players divide their hand into parts, which are compared separately.
  * **Banking Games.** The players do not play against each other, but each plays individually against a special player - the banker.

This is barely scratching at the surface of the vast possibilities a deck of cards brings. For example, the entire category of **Layout Games** (such as **Patience** and **Competitive Patience**) have been excluded -- but are in consideration for a possible future extension.

## Screenshots

![Deck Builder](screenshot/deck_builder.png)

![Example Deck](screenshot/example_deck.png)

## Credits

* The game engine is written in the [LÖVE2D framework for Lua](https://www.love2d.org/).
* The card designs are taken from [Tek Eye](https://tekeye.uk/playing_cards/svg-playing-cards).
* The fonts are sourced from [edX Fonts](https://github.com/clintonb/edx-fonts).
* [Pagat.com](https://www.pagat.com/class/) is perhaps the best source out there to consult when discussing card games.
