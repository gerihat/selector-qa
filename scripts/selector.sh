#!/bin/bash
# Selector de preguntas y sus soluciones

#Colores
green='\033[0;32m'
blue='\033[1;34m'
red='\033[1;31m'
endColor='\033[0m'

#Configuracion inicial
package=c2
nrepeat=1
nlflag=false #flag para mostrar numeros de linea
ntflag=false #flag para mostrar nombre del fichero
npflag=true  #flag para mostrar contador de preguntas
mode=ran
qapath=$(dirname $(dirname ${BASH_SOURCE}))

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
#Funcion filenamecheck: Comprobar que se pasa nombre de fichero válido
#Parametros: #$1: nombre de fichero
function filenameCheck {
  if [[ $1 =~ \.!txt$ ]]; then
	ayuda
	exit 2;
  fi
  return 0
}
#Function fileExists: Comprobar que el fichero existe
function fileExists {
 if [[ ! -f $1 ]]; then
	echo "Selector (E): Fichero no encontrado"
	ayuda
	exit 1;
 fi
 return 0
}
#Mostrar ayuda
function ayuda {
	echo -e "Usage: selector [-m MODE] [-h] [-l] [-t] [-n NUM] <filename>.txt"\\n
	echo "MODES:"
	echo -e  "-m seq: Sequential Selector. Usage: selector -m seq <filename>.txt"
	echo -e  "-m test: Test Selector. Usage: selector -m test <filename>.txt"
	echo -e  "-m pat: Filtered Selector. Usage: selector -m pat PATTERN"
	echo -e  "-m ran: Random Selector. Usage: selector -m ran [-l] [-t] [-n NUM] <filename>.txt"
}

# Function selectSeq: Modo secuencial de seleccion de preguntas. Muestras todas las preguntas de un fichero
# Parámetros: #$1: nombre de fichero
function selectorSeq {
  filename=$1
  filenameCheck $filename
  fileExists $filename

  filename_solutions="${filename%.*}_s.${filename##*.}"

  total=$(wc -l < $filename)
  echo "Total de preguntas: ${total}"

  cat $filename | while read question; do

  #pregunta
  echo -en "Tema: ${green}$(basename ${filename})${endColor} "
  echo -e "Pregunta: (${green}$((++cont))${endColor})/${total}"
  #si es modo test, mostrar opciones separadas
  if [[ $2 =~ "test" ]] ; then
	q="${question%%a)*}"
	opa=$(echo "$question" | sed 's/.* a) \(.*\) b) .*/\1/')
	opb=$(echo "${red}b)$question" | sed 's/.* b) \(.*\) c) .*/\1/')
	opc=$(echo "${red}c)$question" | sed 's/.* c) \(.*\) d) .*/\1/')
	opd="${question##*d) }"
	echo -e "${q}\n${red}a)${endColor} ${opa}\n${red}b)${endColor} ${opb}\n${red}c)${endColor} ${opc}\n${red}d)${endColor} ${opd}"
	read -n 1 -s input < /dev/tty
  else
	echo -e "${question} " ; read -n 1 -s input </dev/tty
  fi

  #respuesta
  respuesta=$(sed "${cont}!d" ${filename_solutions})
  echo -e "${blue}${respuesta}${endColor}" 
  
  if [[ $2 =~ "test" ]] ; then
	read -n 1 -s input </dev/tty ; clear
  fi

  #salir
  if [[ $input = "q" ]] || [[ $input = "Q" ]] ; then exit 0
  fi
done
}
# Function selectFilter: Modo con filtro de patron. Muestras todas las preguntas en las que aparece patron
# Parámetros: #$1: patrón a buscar
function selectorFilter {
 
 path1="$qapath/$package/modulo1/*"
 path2="$qapath/$package/modulo2/*"
 cont=0

 total="$(grep -i $1 $path1 $path2 | wc -l)"
 echo "Total de preguntas: ${total}"

 grep -Hni --exclude={"tema*.txt","modulo?.txt"} $1 $path1 $path2 | while IFS=: read -r filename numline question ; do

	if [[ "${filename:${#filename}-6}" = "_s.txt" ]] ; then
	  filename_solutions=$filename
	  filename="${filename%%_s.*}.txt"
	  question=$(sed "${numline}!d" ${filename})
	else
	  filename_solutions="${filename%.*}_s.${filename##*.}"
	fi

	#pregunta
	echo -en "Tema: ${green}$(basename ${filename})${endColor} "
	echo -e "Pregunta: $((++cont))/${total} (${green}${numline}${endColor})"
	echo -e "${question} " ; read -n 1 -s input </dev/tty

	#respuesta
	respuesta=$(sed "${numline}!d" ${filename_solutions})
	echo -e "${blue}${respuesta}${endColor}"

	#salir
	if [[ $input = "q" ]] || [[ $input = "Q" ]] ; then exit 1
	fi
 done
}

function selectorRandom {
 #Comprobar nombre de fichero
 filenameCheck $1
 #Comprobar que fichero existe
 fileExists $1

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
}

# Main

# Parser de opciones
if [ "$#" -eq 0 ]; then
	ayuda
	exit 1
fi

while getopts m:hltn: opt; do
	case ${opt} in
		m ) # modo de funcionamiento
		    if [[ -z $OPTARG ]]; then
			ayuda;exit 2
		    else
	        	mode=$OPTARG
		    fi
		    ;;
		h ) # ayuda
			ayuda;exit 0;;
		l ) # mostrar numero de linea
			nlflag=true;;
		t ) # mostrar nombre de fichero (tema)
			ntflag=true;;
		n ) # numero de preguntas de un tema
			if [[ $OPTARG =~ ^[0-9]+$ ]]; then
				nrepeat=$OPTARG
			else
				ayuda;exit 2
			fi
			;;
	esac
done
shift $((OPTIND -1))


case ${mode} in
 "seq") #secuencial
    selectorSeq $1
    ;;
 "test") #secuencial modo test
	selectorSeq $1 "test"
	;;
 "pat") #filtro patron
    selectorFilter $1
    ;;
 "ran") #random
    selectorRandom "$@"
    ;;
esac
