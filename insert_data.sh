#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
#pass first row
if [[ $WINNER == "winner" ]]
then
    continue
  fi
#get team_id for WINNER
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

#if not found 
if [[ -z $WINNER_ID ]]
then

#insert WINNER name 
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
echo "Inserted team: $WINNER"
#get new team_id for WINNER
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi

#get team_id for OPPONENT
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#if not found
if [[ -z $OPPONENT_ID ]] 
then
#insert OPPONENT name
INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo "Inserted team: $OPPONENT"
#get new team_id for OPPONENT
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
#insert info to GAMES table
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  echo "Inserted game: $YEAR $ROUND - $WINNER vs $OPPONENT"
done