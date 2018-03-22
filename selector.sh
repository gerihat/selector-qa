#!/bin/bash
# Selector aleatorio de preguntas y sus solucones

#Colors
green='\033[0;32m'
blue='\033[1;34m'
endColor='\033[0m'

#Some configurations
nrepeat=1
nlflag=false #flag para mostrar numeros de linea
ntflag=false #flag para mostrar nombre del fichero


#Funcion selectlinea: Seleccion de una linea en fichero
#Parametros: #$1: Nombre de fichero
function selectlinea {
	max=$(wc -l < $1)
	echo $(( $RANDOM % $max +1))
	return 0
}

#Funcion echolinea: Mostrar linea del fichero en salida estandar
#Parametros: $1: filename, #$2: numlinea, #$3: nlflag, mostrar numero linea
function echolinea {
	default_command=$(sed "$2!d" $1)
	if [[ $4 = true ]]; then
		echo -e "Tema: ${green}${filename}${endColor}"
	fi
	if [[ $3 = true ]]; then
		echo "[$2] "$default_command
	else
		echo $default_command
	fi
	return 0		
}

# Parser de opciones
if [ "$#" -eq 0 ]; then
	echo "Usage: selector [-h] [-l] [-t] <filename>.txt"
	exit 1
fi

while getopts hltn: opt; do
	case ${opt} in
		h ) # ayuda
			echo "Usage: selector [-h] [-l] [-t] <filename>.txt"
			exit 0
			;;
		l ) # mostrar numero de linea
			nlflag=true
			;;
		t ) # mostrar nombre de fichero (tema)
			ntflag=true
			;;
		n ) # numero de preguntas de un tema
			nrepeat=$OPTARG
			;;
	esac
done

shift $((OPTIND -1))

# Main
case "$1" in 
	"modulo"*)
		filename_modulo=$1
		;;
	"tema"*)
		filename_tema=$1
		;;
	*)
		filename=$1
		filename_solutions="${filename%.*}_s.${filename##*.}"
		max=$(wc -l < $filename)
		;;
esac

echo -e "Iniciando test"

while [ true ] ; do
	if [[ ! -z "$filename_modulo" ]]; then
		#Elegir tema dentro de modulo*.txt
		numlinea_modulo=$(selectlinea $filename_modulo)		
		filename_tema=$(echolinea $filename_modulo $numlinea_modulo false)
	fi
	if [[ ! -z "$filename_tema" ]]; then
		#Elegir fichero dentro de tema*.txt
		numlinea_tema=$(selectlinea $filename_tema)		
		filename=$(echolinea $filename_tema $numlinea_tema false)
		filename_solutions="${filename%.*}_s.${filename##*.}"
	fi

	for ((i =1;i<=$nrepeat;i++))
	do

		numlinea=$(selectlinea $filename)
		echolinea $filename $numlinea $nlflag $ntflag
		read -n 1 -s input
		
		#repuesta
		respuesta=$(sed "${numlinea}!d" ${filename_solutions})
		echo -e "${blue}${respuesta}${endColor}"
		
		#salir
		if [[ $input = "q" ]] || [[ $input = "Q" ]] 
			then exit 1
		fi	
	done
done