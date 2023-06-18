#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# truncate
$($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team id
    WINNER_ID=$($PSQL "SELECT * FROM teams WHERE name='$WINNER' ")
    # if winner not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner team
      INSERT_WINNER_TEAMS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAMS_RESULT ==  "INSERT 0 1" ]]
      then
         echo $WINNER
      fi
    fi
    # get winner team id
    OPPONENT_ID=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT' ")
    # if winner not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert winner team
      INSERT_OPPONENT_TEAMS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAMS_RESULT ==  "INSERT 0 1" ]]
      then
         echo $OPPONENT
      fi
    fi
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]] 
    then
      echo "$OPPONENT_ID vs $WINNER_ID"
    fi
  fi
done