#!/bin/bash


#Variables para el comando find 
mdepth="" #Maximo de directorios
mount="" #

u="" #usuario
g="" #grupo     
r="" #legible
w="" #escritura
x="" #ejecutables
p="" #permisos

e="" #archivos y directorios vacios 
s="" #size (prefijos)

Menu(){
	echo "=================================================="
	echo "		          BUSCAR ARCHIVOS               "
	echo "================================================="
	echo " 1) Jerarquia del sistema de archivos   "
	echo " 2) Ubicacion para archivos temporales  "
	echo " 3) Buscar archivos (find)              "
	echo " 4) Buscar archivos (locate)            " 
	echo " 5) Modificar comportamiento de updatedb (locate)"
	echo " 6) Buscar binarios, paginas man y codigo fuente  "
	echo " 7) Salir"
}


fhs(){
	echo "========================Jerarquia del sistema de archivos (FHS Fylesystem Hierarchy Standard) ==========================="
echo -e ' 
        /       Directorio raíz
        /bin    Binarios esenciales, disponibles para todos los usuarios 
        /boot   Archivos necesarios para el proceso de arranque, incluido el disco RAM inicial (initrd) y el propio kernel de Linux 
        /dev    Archivos de dispositivo. Estos pueden ser dispositivos físicos conectados al sistema, como /dev/sda o dispositivos virtuales proporcionados por el kernel 
        /etc    Archivos de configuración específicos del host, aquí se encuentran los archivos de configuración, los programas instalados tienen aquí su configuración 
        /home
        /lib    Se necesitan bibliotecas compartidas para arrancar el sistema operativo y ejecutar los archivos binarios en /bin y /sbin
        /media  Los dispositivos extraíbles se montan aquí
        /opt    Paquetes de software de aplicación 
        /root   Directorio de inicio del superusuario (root)
        /run    Datos variables en tiempo de ejecución
        /sbin   Binarios del sistema 
        /srv    Datos servidos por el sistema. Por ejemplo, páginas servidas por un servidor web podrían almacenarse en /srv/www
        /tmp    Archivos temporales
        /usr    Datos de usuario de solo lectura, incluidos datos que necesitan algunas aplicaciones y utilidades secundarias 
        /proc   Sistema de archivos virtual que contiene datos relacionados con los procesos en ejecución
        /var    Datos variables escritos durante el funcionamiento del sistema, incluida la cola de impresión, datos de registro, buzones de correo, archivos temporales, caché del navegador, etc
'
}

tmpFiles(){
	echo "Los archivos temporales son archivos que utilizan los programas para almacenar datos que solo se necesitan durante un periodo breve"
	echo "Segun las convenciones establecidas por la FHS los archivos temporales se alojan en: "

	echo -e '
		/tmp		Este directorio se borra en cada arranque del sistema (no es obligatorio) 
		/var/tmp	En esta ubicacion no se debe borrarse durante el arranque del sistema. Los archivos almacenados aqui generalmente persistiran entre reinicios 
		/run		Contiene datos variables en tiempo de ejecucion que utilizan los procesos en ejecucion, como los archivos de identificacion de proceso (.pid). 
				Los programas que necesitan más de un archivo en tiempo de ejecución pueden crear subdirectorios aquí. 
				Esta ubicación debe borrarse durante el arranque del sistema. \"/var/run puede ser un enlace simbólico a /run.\"
	'
}





buscarFind(){
echo "================== Buscar Archivos con find =================="
	echo "Directorio donde buscar:"
    	read dir

# Opciones interactivas
	read -p "Nivel máximo de profundidad (ENTER para omitir): " val
    	read val
	[ -n "$val" ] && mdepth="-maxdepth $val" #-n verifica o es verdadero si la longitud de cadena no es cero

# Test en forma de comando, tiene relacion con la estrcutura donde evaluamos la dalida del comando: getent grup | cut -d " " -f 1 > /dev/null 2>&1 y la salida daba 0 o cualquier numero, en esta condicion se ejecutara mdepth="-maxdepth $val" si la condicion es verdadera por que 1 && 1 = true, otra forma de expresarlo es [ -n "$val" ] || mdepth="", dejara vacia la variable
#Ejemplo: mkdir /backup && echo "Directorio creado" || echo "Error al crear"

	read -p "Evitar sistemas de archivos montados? (y/n): " val
	[ "$val" = "y" ] && mount="-mount"

		read -p "Filtrar por usuario (ENTER para omitir): " val
	[ -n "$val" ] && u="-user $val"

	read -p "Filtrar por grupo (ENTER para omitir): " val
	[ -n "$val" ] && g="-group $val"

	read -p "Solo legibles por el usuario actual? (y/n): " val
	[ "$val" = "y" ] && r="-readable"

	read -p "Solo con permisos de escritura? (y/n): " val
	[ "$val" = "y" ] && w="-writable"

	read -p  "Solo ejecutables? (y/n): " val
	[ "$val" = "y" ] && x="-executable"

	read -p  "Permisos exactos (ej. 0644, ENTER para omitir): " val
	[ -n "$val" ] && p="-perm $val"

	read -p "Archivos o directorios vacíos? (y/n):" val
	[ "$val" = "y" ] && e="-empty"

	read -p "Tamaño (ej. +10M, -1G, ENTER para omitir): " val
	[ -n "$val" ] && s="-size $val"

	read -p  "Nombre o patrón (ej. *.txt, ENTER para omitir): " val
	[ -n "$val" ] && name="-name \"$val\"" || name=""

	#Construcción del comando con eval
	cmd="find \"$dir\" $mdepth $mount $u $g $r $w $x $p $e $s $name"

	echo "--------------------------------------------------------------"
	echo "Ejecutando: $cmd"
	echo "--------------------------------------------------------------"
	echo "eval $cmd"
	echo "=============================================================="
}


buscarLocateMultiples(){
	arr=()

	read -p "Ingresa el patron: " p1
	arr+=("$p1")

	while true; do
		read -p "Agregar mas? (y/n): " b1
		[ ! -n "$b1" ] || break

		read -p "Siguiente patron: " p2
		arr+=("$p2")
	done

	echo locate -i -A "${arr[*]}"

}


buscarLocate(){
	echo "[!] Actualizando la base de datos..."
	#funcion de actualizacion de base de datos

	read -p "Buscar multiples patrones: (y/ENTER) " var
	[ -n "$var" ] && buscarLocateMultiples || locate -i $var  ##-n Verdadero si la longitud de la cadena no es cero

#por defecto, locate distingue entre mayusculas o minusculas 
}

actualizarDB(){
	echo "Ubicacion  de las entradas presentes en la base de datos generada por updatedb (/var/lib/mlocate.db)"
	#Si la base de datos está desactualizada, la salida podría mostrar archivos que se han eliminado desde la última vez que se actualizó. Una forma de evitar esto es agregar el parámetro -e, que hará que verifique si el archivo todavía existe antes de mostrarlo en la salida.

	if [[ -e dbConfig.sh ]];then
		bash dbConfig.sh
	else
		echo "[!] Archivo no encontrado"
	fi

}


#buscarBinaryManCode(){}


while true; do
	Menu
	read -p "Seleccione una opcion: " opc

	case $opc in 
		1) fhs;;
		2) tmpFiles ;;
		3) buscarFind ;;
		4) buscarLocate;;
		5) actualizarDB;;
		6) ;;
		7) echo "Bye" ; exit 1;;
		*) exit 1 ;;
	esac


done
