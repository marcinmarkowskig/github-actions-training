#!/bin/bash
set -e
# Twój klucz API dla OpenWeatherMap
API_KEY=$2

# Sprawdzenie, czy podano miasto
if [ -z "$1" ]; then
    echo "Użycie: $0 nazwa_miasta"
    exit 1
fi

CITY="$1"
NEWCITY=$(echo "$CITY" | sed 's/ /%20/g')
URL="https://api.openweathermap.org/data/2.5/weather?q=$NEWCITY&appid=$API_KEY&units=metric"

# Pobieranie danych pogodowych za pomocą curl
response=$(curl -s "$URL")

# Sprawdzenie, czy zapytanie się powiodło
if echo "$response" | grep -q "404"; then
    echo "Nie znaleziono danych dla miasta: $CITY. Sprawdzam wttr.in..."
    echo "$CITY"
    curl "https://wttr.in/$NEWCITY?format=2"
    exit 1
elif echo "$response" | grep -q "main"; then
    # Wyświetlanie temperatury
    temperature=$(echo $response | jq -r '.main.temp')
    echo "Temperatura w $CITY wynosi: $temperature°C"
else
    echo "API nie odpowiedziało prawidłowo. Sprawdzam wttr.in..."
    curl "https://wttr.in/$NEWCITY?format=2"
    exit 1
fi