#!/bin/bash


##### VARIABLES #####
WIDTH=$(tput cols)
HEIGHT=$(tput lines)
HEIGHT=$[HEIGHT-2] # bottom 2 lines are used for user input
declare -A matrix
declare -A matrixBool
DIMENSION=4
HIDDEN=8
MOVES=0


##### FUNCTIONS #####
function print_lines() { for ((j=0;j<$1;j++)) do printf "\n"; done }
function print_spaces() { for ((j=0;j<$1;j++)) do echo -n " "; done }

# initialize the matrix
function initialize_board() {

  # add shuffled characters to the matrix
  shuffle_letters

  for ((i=1;i<=DIMENSION;i++)) do
    for ((j=1;j<=DIMENSION;j++)) do
      matrixBool[$i,$j]=false
    done
  done
}

# The code for the print_matrix() function has been obtained from:
# https://stackoverflow.com/a/16487733
function print_matrix() {
  f1="%$((${#DIMENSION}+1))s"
  f2=" %9s"

  printf "$f1" ''
  for ((i=1;i<=DIMENSION;i++)) do
    # column labels
    printf "$f2" $i
  done
  echo

  for ((j=1;j<=DIMENSION;j++)) do
    # row labels
    printf "$f1" $j
    for ((i=1;i<=DIMENSION;i++)) do
      if [ $# -eq 0 ]; then
        if [ ${matrixBool[$i,$j]} = false ]; then
          printf "$f2" "[-]"
        else
          printf "$f2" ${matrix[$i,$j]}
        fi
      else
        printf "$f2" ${matrixBool[$i,$j]}
      fi
    done
    echo
  done
  printf "\n"
}

function shuffle_letters() {
  LETTERS=($(echo {A..H} | tr ' ' "\n" | shuf | xargs))
  index=0
  for ((i=1;i<=$[DIMENSION/2];i++)) do
    for ((j=1;j<=DIMENSION;j++)) do
      matrix[$i,$j]=${LETTERS[index]}
      index=$(( $index + 1 ))
    done
  done
  
  LETTERS=($(echo {A..H} | tr ' ' "\n" | shuf | xargs))
  index=0
  echo
  for ((i=$[DIMENSION/2]+1;i<=$[DIMENSION];i++)) do
    for ((j=1;j<=DIMENSION;j++)) do
      matrix[$i,$j]=${LETTERS[index]}
      index=$(( $index + 1 ))
    done
  done

  echo
}

function display_board() {
  clear
  print_lines 3
  print_matrix
  # print_matrix 1
}

function title_screen() {
	clear
	# center on screen
  print_lines $[HEIGHT/2]
  print_spaces $[WIDTH/4]
  echo "Welcome to Jieun's Memory Card Game!"
}

function process_turn() {
  # Variables: row1 col1 row2 col2
  $row1=$1
  $col1=$2
  $row2=$3
  $col2=$4

  MOVES=$(( $MOVES + 1 ))

  # set true to display these indices
  matrixBool[$col1,$row1]=true
  matrixBool[$col2,$row2]=true

  trap : ALRM # disable interupt
  stty -echo # prevent input
  display_board
  printf " Displaying cards for: 2 second"
  sleep 1
  display_board
  printf " Displaying cards for: 1 second"
  sleep 1
  stty echo # enable input

  # echo "Selected ones: " "${matrix[$row1,$col1]}" "${matrix[$row2,$col2]}"
  if [ ${matrix[$col1,$row1]} != ${matrix[$col2,$row2]} ]; then
    matrixBool[$col1,$row1]=false
    matrixBool[$col2,$row2]=false
    display_board
  else
    HIDDEN=$(( $HIDDEN - 1 ))
    if [ $HIDDEN -eq 0 ]; then
      game_complete
    fi
  fi
}

function game_complete() {
  clear
	# center on screen
  print_lines $[HEIGHT/3]
  print_spaces $[WIDTH/4]
  printf "Congratulations, you've finished the game!\n\n\n"
  print_spaces $[WIDTH/4+5]
  printf "Total number of moves used: %s\n\n\n\n" $MOVES
  print_spaces $[WIDTH/4+3]
  printf "Please enter any key to play again\n"
  print_spaces $[WIDTH/2-2]
  printf "or\n"
  print_spaces $[WIDTH/4+2]
  echo "Press ctrl-C or cmd-C to end the game"
  read -sn1
  HIDDEN=8
  MOVES=0
  start_game
}

function start_game() {
  title_screen
  initialize_board
  sleep 0.7
  display_board
}


##### MAIN ######

exec 2>/dev/null
trap at_exit ERR EXIT 

start_game
# game_complete
echo

while :
do
  echo
  echo " Please type in the row-column pair for 2 cards."
  # read first pair of cards
  printf "\n Card 1\n\t%9s" "Row: "
	read -n1 row1
  printf "\n\t%9s" "Column: "
  read -n1 col1
  echo

  # read second pair of cards
  printf "\n Card 2\n\t%9s" "Row: "
  read -n1 row2
  printf "\n\t%9s" "Column: "
  read -n1 col2
  printf "\n\n"

  # check if the input is valid
  WARNING_STRING=""
  re='^[1-4]$'
  if [[ ! $row1 =~ $re ]]; then
    WARNING_STRING="${WARNING_STRING}Row-1 "
  fi
  if [[ ! $col1 =~ $re ]]; then
    WARNING_STRING="${WARNING_STRING}Col-1 "
  fi
  if [[ ! $row2 =~ $re ]]; then
    WARNING_STRING="${WARNING_STRING}Row-2 "
  fi
  if [[ ! $col2 =~ $re ]]; then
    WARNING_STRING="${WARNING_STRING}Col-2 "
  fi

  display_board

  # print warning messages as needed
  print_spaces 1
  if [ "$WARNING_STRING" != "" ]; then
    echo "Invalid input for: {" $WARNING_STRING "}"
  elif [ $row1 = $row2 ] && [ $col1 = $col2 ]; then
    echo "You've selected 2 of same cards."
  elif [ ${matrixBool[$col1,$row1]} = true ] || [ ${matrixBool[$col2,$row2]} = true ] ; then
    echo "You've selected some card(s) that have already been flipped!"
  else
    process_turn row1 col1 row2 col2
    echo $WARNING_STRING
  fi
    
done