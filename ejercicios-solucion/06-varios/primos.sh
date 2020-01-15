#! /bin/bash

set -o errexit  # the script ends if a command fails
set -o pipefail # the script ends if a command fails in a pipe
set -o nounset  # the script ends if it uses an undeclared variable
# set -o xtrace # if you want to debug

# función de ayuda
function ayuda() {

cat << DESCRIPCION_AYUDA
SYNOPSIS
    $0 NUMERO_1 NUMERO_2

DESCRIPCIÓN
    Retorna los primos entre NUMERO_1 y NUMERO_2

CÓDIGOS DE RETORNO
    1 Si el número de parámetros es distinto de 2.
    2 Si algún parámetro no es un número.
DESCRIPCION_AYUDA

}

function comprobarQueNoEsNumero() {

    if [ -n "$1" ] \
        && [ "$1" != "0" ] \
        && [ "$(echo "$1" | awk '{ print $1*1 }')" != "$1" ]; then

        echo "El parámetro '$1' no es un número"
        ayuda
        exit 2
    fi
}

if [ $# -ne 2 ]; then
    echo "El número de parámetros debe de ser igual a 2"
    ayuda
    exit 1
fi

comprobarQueNoEsNumero "$1"
comprobarQueNoEsNumero "$2"

if [ "$1" -gt "$2" ]; then
  INCIO="$2"
  FIN="$1"
else
  INCIO="$1"
  FIN="$2"
fi

for ((INDICE="$INCIO"; "$INDICE" <= "$FIN"; INDICE++ )); do
  if [ "$(factor "$INDICE")" == "$INDICE: $INDICE" ]; then
    echo "$INDICE"
  fi
done