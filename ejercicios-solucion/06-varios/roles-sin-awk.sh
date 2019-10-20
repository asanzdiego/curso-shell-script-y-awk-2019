#! /bin/bash

set -o errexit  # the script ends if a command fails
set -o pipefail # the script ends if a command fails in a pipe
set -o nounset  # the script ends if it uses an undeclared variable

roles_file=./roles.csv

roles=$(cut -d : -f 2 $roles_file | sed 's/,/\n/g' | sort | uniq)

for rol in $roles; do
    echo -n "${rol} -> "
    personas="$(sort ${roles_file} | grep -E "\b${rol}\b" | cut -d : -f 1 | tr '\n' ' ')"
    echo "$personas"
done
