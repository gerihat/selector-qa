# Selector

**Sencillo Script BASH para la generación de cuestionarios en modo texto**

## Getting Started

Si tienes una máquina linux o de cualquier otro tipo que pueda correr un shell BASH, con Selector y uno o varios pares de fichero preguntas-respuestas. El script irá presentando preguntas aleatorias a modo de repaso de tu temario. No plantea preguntas tipo test, sino respuestas concretas.

### Plataformas

* Linux / Raspbian (Raspberry PI)
* OS X
* Windows 10 (Linux Subsytem) or Windows (with [Cygwin] 32/64 bits)

### Instalación

No necesita instalación, tan solo asegúrate de dar estos dos pasos:

 * Tener todos los ficheros en la misma carpeta
 * Otorgarle permiso de ejecución al fichero selector.sh si no lo tuviera

	```
	$ chmod +x selector.sh
	```


En el caso de que tu equipo sea Windows, puedes utilizar [Cygwin] o el subsistema Linux que incluye [Windows10]

## FAQ

### ¿Cómo se utiliza?

* El comando básico es

	```
	$ ./selector.sh [-t] nombrefichero.txt
	```

	 ```nombrefichero.txt``` puede ser:

	1. Cualquier fichero con extensión txt (y su pareja *nombrefichero_s.txt*)
	2. La opción *-t* muestra por pantalla en cada pregunta, el nombre del fichero al que corresponde

* Selector de tema

	```
	$ ./selector.sh [-t] tema[n].txt
	```

	Selecciona preguntas de todos los ficheros incluidos en tema[n].txt. *Ejemplo:*	```$ ./selector.sh tema1.txt``

* Selector de módulo

	```
	$ ./selector.sh [-t] modulo[n].txt
	```

	Selecciona preguntas de todos los temas incluidos en modulo[n].txt. *Ejemplo:*	```$ ./selector.sh modulo1.txt``


### ¿Cómo creo ficheros de preguntas-respuestas?

* Con cualquier editor crear dos pares de ficheros. Uno para preguntas ***nombrefichero.txt*** y otro para sus respuestas ***nombrefichero_s.txt*** (la terminación '_s' en el nombre identifica al fichero de respuestas)
* En el fichero de preguntas, cada línea del fichero es una pregunta. Y lo mismo ocurre para en el de respuestas.
* Deja una línea en blanco al final del fichero

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

## Contribuciones

Si quieres contribuir a este script con alguna sugerencia o mejora, consulta el modo de realizarlo y el código de conducta.

## Versión

v0.6 Selector.sh 19/3/2018

*El temario que incluye este proyecto es de oposiciones de Auxiliar Administrativo del Estado 2017*

## Autor

* **Miguel Angel Camacho** - [miguelangelcamacho.com]

## Licencia

Sin licencia

[Cygwin]: http://www.cygwin.com
[Windows10]:https://docs.microsoft.com/en-us/windows/wsl/install-win10
[miguelangelcamacho.com]:https://www.miguelangelcamacho.com
