# Memory
is a Console-based Unix-compatible Card Game.

## To run the game
Go under the directory where the file `memory.sh` lives.
Type `./memory.sh` in your console, and press `Enter`!

## How the game works
When the game begins, you will see a 4x4 grid of cards. (Total of 16 cards, 8 pairs)
Your job is to flip the matching pairs until *ALL* cards have been flipped!

## Instructions
1. Choose the pair of cards to flip by typing the number sequence in the order of **Row1 Col1 Row2 Col2**.
   - Example: *1312* is Card 1 at (1, 3) and Card 2 at (1, 2)
2. *Do the cards match?*
   - **Yes**: the cards will be **flipped immediately**.
   - **No**: the values of the cards will be **displayed for 2 seconds**.
3. Once all cards have been flipped, you'll be redirected to the ending page where you have an option to play another.

## To quit the game
Press `ctrl+C` or `cmd+C` anytime to exit.

_____________________________________________________________________________________________
### Behind the Curtain Stuff
*Language Used*: Bash script, because it's the most common language for console-based interactive games!

## Functions Used:
- print_lines
- print_spaces
- initialize_board
- shuffle_letters
- display_board
- title_screen
- process_turn
- game_complete
- start_game


<!-- A brief explanation of your design choices and any data structures or algorithms that you implemented
Choice of tooling (language, libraries, test runner, etc.) and rationale behind those choices. -->
