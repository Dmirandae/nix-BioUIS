#!/bin/bash

# una sola conversión
# script de demostración
# para saber si funciona
# calcTree.sh < entrada  > salida

tr ',' ' ' | awk 'NR > 1 {  s=$3*3.14159265/180; print $1,$3*sin(s)/cos(s) }'

