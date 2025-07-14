# The LÖVE2D Card Games Engine

This is a game engine written in Lua (LÖVE2D) for designing (classics as well as new ones) and playing card games over the internet using the standard 52-card French deck, or its derivatives. Card games can be saved, loaded and shared as JSON files. Think of it as Gary's mod -- but for playing cards.

## Game Types Supported

The engine currently supports 2 to 6 player games. Game types are grouped by structure and objective:

* **Outplay Games.** Players hold a hand of cards and take turns playing cards to a shared table area. The game ends when players exhaust their hands.
  * **Trick-Taking Games.** Each player plays one card per turn into a "trick"; the best card wins the trick. (Example: _Spades_, _Hearts_, _Bridge_, _Callbreak_, _29_)
  * **Shedding Games.** Players try to get rid of their cards; the fastest player wins. Variants with the inverted objective of amassing all cards also supported. (Example: _Bluff_, _Crazy Eights_, _Rang Milanti_)
* **Card Exchange Games.** The focus is on trading cards to build specific sets or combinations.
  * **Draw and Discard Games.** Each turn consists of drawing a card from the stock and discarding one. (Example: _Rummy_, _Gin Rummy_, _Paplu_)
  * **Quartet Group.** Ask opponents for specific cards; if they have them, they must give them to you. (Example: _Go Fish_)
* **Hand Comparison Games.** Victory is determined by comparing hands, not by sequential play.
  * **Showdown Games.** Players reveal their hands; best hand wins. (Example: _No Limit Texas Hold'em_, _Teen Patti_, _5-Card Draw_)
  * **Banking Games.** Players compete against a designated banker, not against each other. (Example: _Blackjack_, _Caribbean Stud Poker_)

This is barely scratching at the surface of the vast possibilities a deck of cards brings. For example, the entire category of **Layout Games** (with subcategories such as **Patience** and **Competitive Patience**) are currently not included, but planned for future expansion. Another unfortunate exclusion is the **War Group**.

## Screenshots

![Deck Builder](screenshot/deck_builder.png)

![Example Deck](screenshot/example_deck.png)

## Credits

* The game engine is written in the [LÖVE2D framework for Lua](https://www.love2d.org/).
* The card designs are taken from [Tek Eye](https://tekeye.uk/playing_cards/svg-playing-cards).
* The fonts are sourced from [edX Fonts](https://github.com/clintonb/edx-fonts).
* [Pagat.com](https://www.pagat.com/class/) is perhaps the best source out there to consult when discussing card games.
