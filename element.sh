#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1;"
  else
    QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol ILIKE '$1' OR name ILIKE '$1';"
  fi

  RESULT=$($PSQL "$QUERY")

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING BOILING
    do
      # إزالة الفراغات الزائدة لتتطابق المخرجات مع اختبار الموقع حرفياً
      ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | xargs)
      NAME=$(echo $NAME | xargs)
      SYMBOL=$(echo $SYMBOL | xargs)
      TYPE=$(echo $TYPE | xargs)
      ATOMIC_MASS=$(echo $ATOMIC_MASS | xargs)
      MELTING=$(echo $MELTING | xargs)
      BOILING=$(echo $BOILING | xargs)

      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
