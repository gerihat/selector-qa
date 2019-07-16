#!/bin/bash
#Selector de preguntas y soluciones con filtro de cadena

#Colores
green='\033[0;32m'
blue='\033[1;34m'
endColor='\033[0m'

#Configuración inicial
path1="$HOME/oposiciones/modulo1/*"
path2="$HOME/oposiciones/modulo2/*"

#Mostrar ayuda
function ayuda {
	echo "Usage: selector2 PATTERN"
}

#Parser de opciones
if [ "$#" -eq 0 ]; then
	ayuda
	exit 1
fi

grep -Hn $1 $path1 $path2 | while IFS=: read -r filename numline question ; do

	echo "Total de preguntas: ${total}";echo
	if [[ "${filename:${#filename}-6}" = "_s.txt" ]] ; then
	  filename_solutions=$filename
	  filename="${filename%%_s.*}.txt"
	  question=$(sed "${numline}!d" ${filename})
	else
	  filename_solutions="${filename%.*}_s.${filename##*.}"
	fi
	
	#pregunta
	echo -en "Tema: ${green}$(basename ${filename})${endColor} "
	echo -e "Pregunta: ${green}${numline}${endColor}"
	echo -e "${question} " ; read -n 1 -s input </dev/tty

	#respuesta
	respuesta=$(sed "${numline}!d" ${filename_solutions})
	echo -e "${blue}${respuesta}${endColor}"

	#salir
	if [[ $input = "q" ]] || [[ $input = "Q" ]] ; then exit 1
	fi
done
