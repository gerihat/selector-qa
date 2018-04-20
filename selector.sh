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
npflag=true  #flag para mostrar contador de preguntas

#Funcion selectlinea: Seleccion de una linea en fichero
#Parametros: #$1: Nombre de fichero
function selectlinea {
	max=$(wc -l < $1)
	echo $(( $RANDOM % $max +1))
	return 0
}

#Funcion echolinea: Mostrar linea del fichero en salida estandar
#Parametros: $1: filename, $2: numlinea, 
#	$3: nlflag, mostrar numero linea, $4: ntflag, mostrar fichero tema, $5: npflag, mostrar numero pregunta
function echolinea {
	default_command=$(sed "$2!d" $1)
	if [[ $4 = true ]]; then
		echo -en "Tema: ${green}$(basename ${filename})${endColor} "
	fi
	if [[ $5 = true ]]; then
		echo -e "Pregunta: ${green}$((++cont))${endColor}"
	fi
	if [[ $3 = true ]]; then
		echo "[$2] "$default_command
	else
		echo $default_command
	fi
	return 0		
}

#Mostrar ayuda
function ayuda {
	echo "Usage: selector [-h] [-l] [-t] [-n NUM] <filename>.txt"
}

# Parser de opciones
if [ "$#" -eq 0 ]; then
	ayuda
	exit 1
fi

while getopts hltn: opt; do
	case ${opt} in
		h ) # ayuda
			ayuda
			exit 0
			;;
		l ) # mostrar numero de linea
			nlflag=true
			;;
		t ) # mostrar nombre de fichero (tema)
			ntflag=true
			;;
		n ) # numero de preguntas de un tema
			if [[ $OPTARG =~ ^[0-9]+$ ]]; then
				nrepeat=$OPTARG
			else
				ayuda
				exit 2
			fi
			;;
	esac
done

shift $((OPTIND -1))

# Main

# Comprobar que se pasa un nombre válido de fichero
if [[ $1 =~ \.!txt$ ]]; then
	ayuda
	exit 2;
fi
# Comprobar que el fichero pasado como parametro existe
if [[ ! -f $1 ]]; then
	echo "Selector (E): Fichero no encontrado"
	ayuda
	exit 1;
fi

# Extraer path
path=$(dirname $1)"/"
bname=$(basename $1)

case "$bname" in 
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

cont=0
while [ true ] ; do
	if [[ ! -z "$filename_modulo" ]]; then
		#Elegir tema dentro de modulo*.txt
		numlinea_modulo=$(selectlinea $filename_modulo)		
		filename_tema=$path$(echolinea $filename_modulo $numlinea_modulo false)		
		if [[ ! -f $filename_tema ]]; then
			echo "Selector (E) ${filename_tema}: Fichero no encontrado"
			ayuda
			exit 1;
		fi
	fi
	if [[ ! -z "$filename_tema" ]]; then
		#Elegir fichero dentro de tema*.txt
		numlinea_tema=$(selectlinea $filename_tema)		
		filename=$path$(echolinea $filename_tema $numlinea_tema)
		filename_solutions="${filename%.*}_s.${filename##*.}"
		if [[ ! -f $filename ]]; then
			echo "Selector (E) ${filename}: Fichero no encontrado"
			ayuda
			exit 1;
		fi
	fi
	for ((i =1;i<=$nrepeat;i++))
	do
		numlinea=$(selectlinea $filename)
		echolinea $filename $numlinea $nlflag $ntflag $npflag
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
