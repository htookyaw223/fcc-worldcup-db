#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# CSV file path
CSV_FILE="games.csv"
echo "$($PSQL "TRUNCATE games teams")"
# Read the CSV file line by line, skipping the header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  echo "$($PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT (name) DO NOTHING;")"
  echo "$($PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT (name) DO NOTHING;")"
done
# Read the CSV file line by line, skipping the header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  # Fetch the team IDs for the winner and opponent from the teams table
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';" )
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")

  echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
     VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")"
done
