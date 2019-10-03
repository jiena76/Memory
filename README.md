# Memory
is a Console-based Unix-compatible Card Game.

### To run the game
Go under the directory where the file `memory.sh` lives.
Type `./memory.sh` in your console, and press `Enter`!

### How the game works
When the game begins, you will see a 4x4 grid of cards. (Total of 16 cards, 8 pairs)
Your job is to flip the matching pairs until *ALL* cards have been flipped!

## Instructions
1. Choose the pair of cards to flip by typing the number sequence in the order of **Row1 Col1 Row2 Col2**.
   - Example: *1312* is Card 1 at (1, 3) and Card 2 at (1, 2)
2. *Do the cards match?*
   - **Yes**: the cards will be **flipped immediately**.
   - **No**: the values of the cards will be **displayed for 2 seconds**.
3. Once all cards have been flipped, you'll be redirected to the ending page where you have an option to play another.

### To quit the game
Press `ctrl+C` or `cmd+C` anytime to exit.

_____________________________________________________________________________________________
# Behind the Stage
Language: **Shell script**, because it's the most common language for console-based interactive games.

## {FUNCTIONS}
### initialize_board()
Call `shuffle_letters()` to fill in the board with pairs of random alphabets from {A...H}.
Fill in another boolean matrix for indicating whether the card has been flipped or not.
### print_matrix({opt: arg})
Prints either the card matrix or boolean matrix depending on the number of arguments.
   - 0 argument = card matrix
   - 1 or more arguments = boolean matrix
The card matrix will hide or show the value of the card depending on the boolean value of the corresponding index of the boolean matrix.
*(The code for the print_matrix() function has been obtained from: https://stackoverflow.com/a/16487733)*

### shuffle_letters()
Input letters {A...H} in random orders in the left half of the card matrix.
Shuffle the letters again in a different order and input into the other half of the card matrix.

### display_board()
Essentially the *main game page*.
Includes all components on what the screen of the game should include.

Composed of:
   - Current **number of moves** the user made
   - Newlines to make the UI prettier
   - The display of the **card matrix**

### title_screen()
Short intro page of the game **title** and **my name**.

### process_turn(row1, col1, row2, col2)
This function will only be called **IFF** the user enters a valid input, (so that invalid input doesn't count as a *turn*), increment the number of moves used by 1.
Since the `display_board()` function only reveals the card value if its corresponding boolean value is `True`, set chosen two cards' boolean values to `True`.
Reveal the board status.
Reverse the board status to its previous form within 2 seconds if the cards are not matching.
    - During the *2 seconds of the board display*, **disable interrupt** and **prevent user input**
If a match is found, decrement the *hidden pair count* by 1 and return.

### game_complete()
The ending page when the game is completed.
I wanted to make the game rather generous and encourage completion than frustration (better UX), so there is **no game over** or **time over**.

Print:
   - Number of moves used
   - Short celebration message
   - Instruction for playing again
If the user enters any character, prepare for a another game:
(The input value for *entering any character* is programmed to be hidden from the user)
   - Reset *hidden pair count* to 8 and *number of moves* to 0.
   - Call `start_game()` function.

### start_game()
Print the title screen by calling `title_screen()`.
Get the cards ready by initializing through `initialize_board()`.
Sleep for 0.7 seconds for the title screen display.
Then call `display_board()` to display the cards to start the game!

## the MAIN method
(Error handling)
If an error occurs, redirect error file descriptor to /dev/null.

Call `start_game()` to start the game!

A while loop will be running which includes:
   - Several prompts to guide the user to input the **ROW-COL** values
   - Validate the input: Did user input *numbers* between 1~4?
      - There are **4** different **if** statements for { Row-1 Col-1 Row-2 Col-2 }, to *specifically* indicate which input was invalid to the user.
   - Refresh the page by calling `display_board()`
   - Before the prompts for new inputs appear, output the warning messages:
      - Invalid input for: { Row-1 Col-1 Row-2 Col-2 } (**not numbers** or **out of bound**)
      - User has selected **2 of the same cards**!
      - User selected some cards that have **already been flipped**
   - If all passes, call `process_turn()`!

## Final Thoughts
This game has been programmed to be efficient and deliver the best user experience.
For example, starting a new game *continues* the while loop that has been running.
All validation for user input is done within the while loop to prevent calling the `process_turn()` function with invalid inputs.
User's *number of moves* only increment once valid input has been entered.

If I were to spend more time on this project in the future, I would like to create an interactive grid system where the user can *highlight* which card to flip instead of typing which row/col value of the card they would like to flip.
Additinally, keeping the records of highest score, or lowest moves for the *All-time high-score*.
As user plays each turn, saving previous inputs doesn't sound like a bad idea either.

This was a very unique and fun yet creative project that I had an opportunity to build.
In the future, I hope to seek for opportunities where I can thoroughly enjoy exploring my own potentials.

Jieun Lee, 10/3/2019