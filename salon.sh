#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) CUSTOMER_MENU ;;
    2) CUSTOMER_MENU ;;
    3) CUSTOMER_MENU ;;
    4) CUSTOMER_MENU ;;
    5) CUSTOMER_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
} 


CUSTOMER_MENU(){

  #get phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #if customer does not exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    #get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi


  #get appointment time
  SERVICE_SELECTION=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your$SERVICE_SELECTION, $CUSTOMER_NAME?"
  read SERVICE_TIME

  #populate appointment table
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME') ")

  echo -e "\nI have put you down for a$SERVICE_SELECTION at $SERVICE_TIME, $CUSTOMER_NAME."

  EXIT
}

EXIT() {
  
}

MAIN_MENU 
