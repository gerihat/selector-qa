# Selector

**Script BASH para la generación de cuestionarios en modo texto de línea de comandos**

## Consideraciones iniciales

Si tienes una máquina linux o de cualquier otro tipo que pueda correr un shell BASH, con Selector y uno o varios pares de ficheros preguntas-respuestas, este script irá seleccionando y mostrando preguntas aleatorias a modo de repaso de tu temario.

### Plataformas

* Linux / Raspbian (Raspberry PI)
* OS X
* Windows 10 (Linux Subsytem) or Windows (with [Cygwin] 32/64 bits)

## Instalación

No necesita instalación, tan solo asegúrate de dar estos dos pasos:

 * Tener los ficheros de preguntas y respuestas en la misma carpeta
 * Otorgarle permiso de ejecución al fichero selector.sh si no lo tuviera

	```
	$ chmod +x selector.sh
	```


En el caso de que tu equipo sea Windows, puedes utilizar [Cygwin] o el subsistema Linux que incluye [Windows10]

## Uso

* La sintaxis es la siguiente:
	```
	$ ./selector.sh -m [MODE:seq|test|pat|ran] [PATRON] [-h] [-l] [-t] [-n NUM] nombrefichero.txt
	```

* El script tiene cuatro modos de funcionamiento:
	
	* Modo Secuencial:
	
	Muestras todas las preguntas del fichero pasado como parámetro en orden secuencial
	```
	$ ./selector.sh -m seq nombrefichero.txt
	```
	
	* Modo Test:
	
	Muestra las preguntas y cuatro opciones de respuesta
	```
	$ ./selector.sh -m test nombrefichero.txt
	```
	
	* Modo Filtro de patrón:

	Muestra todas las preguntas en las que aparecen el patrón especificado como parámetro
	```
	$ ./selector.sh -m pat PATRON
	```

	* Modo Random:
	
	Muestras preguntas aleatorias del fichero especificado como parámetro. El fichero puede ser un módulo, un tema o fichero de preguntas.
	```
	$ ./selector.sh -m ran -t -l -n NUM nombrefichero.txt
	````

### MODO RANDOM

* El comando básico es:

	```
	$ ./selector.sh -m ran -t nombrefichero.txt
	```

	 ```nombrefichero.txt``` puede ser:

	Cualquier fichero con extensión .txt (por cada fichero ***nombrefichero.txt*** debe existir su pareja ***nombrefichero_s.txt*** con las respuestas)

* Selector de tema

	```
	$ ./selector.sh -m ran -t tema[n].txt
	```

	Selecciona preguntas de todos los ficheros incluidos en tema[n].txt. *Ejemplo:*	```$ ./selector.sh tema1.txt``` 

* Selector de módulo

	```
	$ ./selector.sh -m ran -t modulo[n].txt
	```

	Selecciona preguntas de todos los temas incluidos en modulo[n].txt. *Ejemplo:*	```$ ./selector.sh modulo1.txt```

### Parámetros opcionales

* -h: Muestra la ayuda
* -l: Muestra el número de línea (útil para usar el comando ***sed*** para búsquedas)
* -t: Muestra en cada pregunta el nombre del fichero al que corresponde. Recomendado, puesto que permite ver a qué tema corresponde la pregunta
* -n NUM: Muestra un número NUM de preguntas consecutivas de cada tema:

	*Ejemplo: ```$ ./selector.sh -t -n 4 tema10.txt``` siendo tema1.txt...*
	```
	1 procedimiento.txt
	2 legislacion.txt
	3 sanciones.txt
	4 indemnizaciones.txt
	```
	*...mostraría 4 preguntas consecutivas de cada uno de esos ficheros.*


## FAQ

### ¿Cómo creo ficheros de preguntas-respuestas?

* Con cualquier editor crea dos pares de ficheros. Uno para preguntas ***nombrefichero.txt*** y otro para sus respuestas ***nombrefichero\_s.txt*** (la terminación '\_s' en el nombre identifica al fichero de respuestas)
* Cada línea de estos ficheros representa una pregunta y una respuesta respectivamente. Por ejemplo la línea 6 en el fichero de preguntas, tiene como respuesta la línea 6 en el fichero de respuestas.
* Si las preguntas van a incluir opciones tipo test se debe seguir el formato de fichero siguiente para las preguntas:
	```
	1: pregunta número 1. a) opción a. b) opción b. c) opción c. d) opción d.
	2: pregunta número 2. a) opción a. b) opción b. c) opción c. d) opción d.
	...
	n: pregunta número n. a) opción a. b) opción b. c) opción c. d) opción d.
	```
	
### ¿Cómo se organizan los temas o grupos de preguntas?

* Hay tres tipos de ficheros para organizar el temario y las preguntas/respuestas
* **Secciones:** Son ficheros con cualquier nombre en los que se incluyen las preguntas y respuestas, siguiendo la regla anteriormente indicada
* **Temas:** Son ficheros sobre un tema concreto, en los que se indica el grupo de ficheros de preguntas que incluye ese tema. Cada línea en este ficheo representa una sección:

	*Ejemplo: tema10.txt*
	```
	1 procedimiento.txt
	2 legislacion.txt
	3 sanciones.txt
	4 indemnizaciones.txt
	```

* **Módulos:** Son ficheros que agrupan a temas. Cada línea del fichero representa un tema:

	*Ejemplo: modulo1.txt*
	```
	1 tema1.txt
	2 tema2.txt
	3 tema3.txt
	```

## Scripts extras
Estos scripts están incluídos en la carpeta scripts, y no son necesarios para poder usar el generador de cuestionarios. Sólo son pequeñas ayudas para al estudio o la búsqueda de preguntas y respuestas concretas dentro del temario.

* **ce:** Script para mostrar los artículos de la Constitución Española de 1978

	*Ejemplo: ```$ ce 5```*
	*mostraría el artítuclo 5 de la Constitución Española de 1978*
	
	*Ejemplo 2: ```$ ce libertad```*
	*mostraría todas los artículos de la Constitución que incluyen el término **libertad***	

* **verlinea:** Script para mostrar la línea pasada como parámetro de un fichero

	*Ejemplo ```$ verlinea 5 cederechos.txt```*
	*mostraría la línea 5 del fichero cederechos.txt, es decir, la pregunta nº 5 de ese fichero*

* **qa:** Script para mostrar la pregunta-respuesta de la línea pasada como parámetro

	*Ejemplo: ```$ qa 5 cederechos.txt```*
	*mostraría la respuesta correspondiente a la línea 5 del fichero cederechos.txt*

* **tabla:** Script para mostrar un fichero de tabla en formato texto

	*Ejemplo: ```$ tabla <ficherotabla.txt>```*
	*mostraría el fichero especificado a traves de **less**
	
	*Ejemplo 2: ```$tabla```* (sin argumentos)
	*mostraría el listado de tablas disponibles en la ruta /$HOME/oposiciones/extras*

*Se recomienda incluir la ruta a estos script en el PATH del sistema o del usuario para poder usarlos en cualquier directorio. Consulta cómo incluir una ruta al PATH del sistema o del usuario en la documentación de tu distribución Linux*

## Contribuciones

Si quieres contribuir a este script con alguna sugerencia o mejora, consulta el modo de realizarlo y el código de conducta.

## Versiones

v0.6 selector.sh 19/3/2018
v0.7 selector.sh 20/7/2019
v0.8 selector.sh 21/8/2019

*El temario que incluye este proyecto es de oposiciones de Auxiliar Administrativo del Estado 2017 y 2018*

## Autor

* **Miguel Angel Camacho** - [miguelangelcamacho.com]

## Licencia

Sin licencia

[Cygwin]: http://www.cygwin.com
[Windows10]:https://docs.microsoft.com/en-us/windows/wsl/install-win10
[miguelangelcamacho.com]:https://www.miguelangelcamacho.com
