# Blackjack

This game was implemented solely by using the **_ASSEMBLY_** language.

It runs in the **_command window_**.

## How does it work?

1. The player has to choose the corresponding option to start the game
2. The Dealer's drawn cards along with the score are displayed. 
3. The player's first card is shown.
4. The player has the choice to either draw a new card or stand.
5. After the player decides to stand, the Dealer will automatically draw cards according to the BlackJack set of rules.

## Who wins?

The one with the highest score that's lower or equal to 21 is the winner. If any of the sides draws cards and the score exceeds 21, the other side wins and the BUST message is displayed, along with the side that went bust.

## Status / To-do list

- [x] Randomly shuffle deck
- [x] Implement function to generate card label based on number in card list
- [x] Calculate score correctly
- [x] Implement Player logic
- [x] Implement Dealer logic
- [ ] Implement betting system
