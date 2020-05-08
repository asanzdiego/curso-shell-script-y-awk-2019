#!/bin/bash

set -o errexit  # the script ends if a command fails
set -o pipefail # the script ends if a command fails in a pipe
set -o nounset  # the script ends if it uses an undeclared variable

# script que procesa el fichero empleados.txt

if [ $# -ne 1 ]; then
    echo "Número de argumentos incorrecto"
    exit 1
fi

if [ "$1" == "dpto" ]; then
    posicion=10
elif [ "$1" == "estadocivil" ]; then
    posicion=13
else
    echo "Argumento incorrecto"
    exit 2
fi

numGrupos=0

listaGrupos=$(iconv -f utf8 -t ascii//TRANSLIT empleados.txt | \
    tail -n +2 | cut -d# -f ${posicion} | tr " " "_" | awk '{print tolower($0)}' | sort -u)

for i in $listaGrupos; do
    numGrupos=$((numGrupos + 1))
    # simulamos la creación del grupo
    echo "groupad g$i"
done

usuariosCreados=0
usuariosNoCreados=0

listaDNI=$(iconv -f utf8 -t ascii//TRANSLIT empleados.txt | tail -n +2 | cut -d# -f1)

for i in $listaDNI; do

    empleado=$(iconv -f utf8 -t ascii//TRANSLIT empleados.txt | grep -E "^$i" | awk '{print tolower($0)}')

    nombre=$(echo "$empleado" | cut -d# -f4 | tr -d " ")
    apellido1=$(echo "$empleado" | cut -d# -f2 | tr -d " ")
    apellido2=$(echo "$empleado" | cut -d# -f3 | tr -d " ")
    dia=$(echo "$empleado" | cut -d# -f5)
    mes=$(echo "$empleado" | cut -d# -f6)
    grupo=$(echo "$empleado" | cut -d# -f${posicion} | tr " " "_")

    milogin=$(echo "$nombre" | cut -c1).${apellido1}.${apellido2}

    # simulamos la creación del usuario
    echo "useradd -c \"$nombre $apellido1 $apellido2\" -g g$grupo -s /bin/bash -e \"2017/$mes/$dia\" $milogin 2>> log_creacion.txt"
    if [ $? -eq 0 ]; then
        usuariosCreados=$((usuariosCreados + 1))
    else
        usuariosNoCreados=$((usuariosNoCreados + 1))
    fi

    # simulamos la creación de la contraseña
    echo "passwd $milogin Op0s2016"
done

echo "Número de departamentos/estados: $numGrupos"
echo "Número de empleados creados correctamente: $usuariosCreados"
echo "Número de empleados no creados: $usuariosNoCreados"
