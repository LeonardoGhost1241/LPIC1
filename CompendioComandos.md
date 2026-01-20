Compendio de Comandos


## lspci
lspci - muestra los dispositivos conectados al bus PCI (Peripheral Component Interconnect), componentes conectados a la placa base, controlador de disco o una tarjeta de expansion lOs numeros hexadecimales al principio de cada linea son las direcciones unicas del dispositivo PCI correspondiente
        -s especificar la direccion 
        -v modo verbose 
            ejemplo: lspci -s 04:02.0 -v 
        -k (disponible en versiones mas resientes) verifica que el modulo del nucleo del SO esta e
n uso para el dispositivo

## lsusb 
lsusb - Enumera los dispositivos USB actualmente conectados a la maquina
    -v modo verbose 
	-d selecciona un dispositivo mediante su ID ejem:1d6b:0002
		ejem: lsusb -v -d 1d6b:0002
	-t muestra las asignaciones actuales de los dispositivos USB en forma de arbol jerarquico 
		ejem: lsusb -t [numero del bus]:[NUmero del Device]


## lsmod 
lsmod - muestra los modulos cargados actualmente, en formato (nombre del modulo) (cantidad de memoria ram ocupada por el modulo en bytes) (modulos dependientes) (Algunos modulos requieren de otros modulos para funcionar)


## modprobe 
modprpbe - usado para cargar como para descargar modulos especificos 
	-r eliminar un modulo

## modinfo 
modinfo - muestra informacion sobre un modulo de kernel
	-p muestra todos los parametros disponibles e ignora la otra inf


# grub-mkconfig 
grub-mkconfig -o /boot/grub/grub.cfg - para regenerar la configuración de GRUB



## dmesg
dmesg - Muestra mensajes actuales en el bufer (Mensajes del nucleo, enfocado en eventos de hardware y arranque, no persistente )
    --clear Se pierden todos los mensajes cuando se apaga el sistema
    -T Muestra las fechas y horas humanas en lugar del timestamps relativos 
    -k Filtra solo los mensajes del kernel (excluye usuarios)
    -l Filtra por nivel de severidad (warn, err, info, etc)


## journalctl 
journalctl - Muestra las entradas, registros del sistema, incluye mensajes de servicios y aplicacion, ersistente y organizado
    --list-boot: muestra una lista de numeros de arranque relativos al arranque actual, su hash de identificacion y las marcas de tiempo del primer y ultimo mensaje correspondiente
	-b 0  o  --boot=0 mensajes para el arranque actual
	-b 1  o  --boot=1 mostraran mensajes de la inicializacion anterior
	-D o --direcory se puede usar para leer mensajes de registros en directorios que no sean /var/log/journal, que es el lugar predeterminado para los mensajes de registro de systemd
		**Como los mensajes de registro de systemd se almacenan en texto sin formato, se requiere el comando journalctl para leerlos 

	-S -U: permite especificar desde (since) y/o hasta cuando (until)
		YYY-MM-DD [HH:MM:SS], yestedar, today, tomorrow, N day ago, -/+ NhMmin (-1h15min)
	-u unit: mensaje de una unidad en concreto
	-k mensaje del kernel
	-p: por tipo (emerg, alert, crit, err, warning, notice, info, debug)
	PARAM=VALUE: Parametros como _PID, _UID, _COMM (Man systemd.journal-fields), ejemplo de uso: journalctl _COMM=sshd


## Comandos de SysVinit 
runlevel - Muestra el nivel de ejecucion anterior y el actual (ejmplo de salida: N 3 , significa que nunca cambio N y esta en 3)
telinit - Ordena a init cambiar de runlevel 


## Comandos de Upstart
initctl list - muestra todos los jobs de upstart
start|stop servicio - inicia o detiene el servicio "servicio"
status tty6- muestra el estado 


## Comandos de Systemd 
1. Iniciar/Detener / Reiniciar servicio 
systemctl start nombre.service
systemctl stop nombre.service
systemctl restart nombre.service
systemctl status nombre.service

2. Comprobar esado 
systemctl is-active nombre.service
systemctl is-enabled nombre.service

3. Activar /Desactivat inicio automatico 
systemctl enable nombre.service
systemctl disable nombre.service

4. Ver archivo de configuracion de un servicio 
systemctl cat ssh

5. Ver dependencias 
systemctl list-dependencies ssh.service
systemctl list-dependencies        # dependencias del default.target

6. Listar unidades activas
systemctl 

7. Listar archivos de unidad 
systemctl list-unit-files
systemctl list-unit-files --type=service
systemctl list-unit-files --type=target

8. Cambiar de target 
systemctl isolate multi-user.target
systemctl isolate graphical.target

9. Ver el target por defecto 
systemctl get-default

10. Establecer el target por defecto 
systemctl set-default multi-user.target


systemctl suspend - suspende el equipo
systemctl hibernate - hiberna el equipo 


## shutdown 
shutdown - apaga el sistema temporizado y enviando un emnsaje a todos los usuartios conectados 

shutdown [option] time [message]
- solo se requiere el parametro time, el cual define cuando se ejecutara la accion y puede tener los siguiente formatos
	-> hh:mm	hora minutos
	-> +m	Especifica cuantos minutos esperar antes de la ejecucion 
	-> now o +0	Determina la ejecucion inmediata 


## wall 
wall - Enviar mensajes broadcast
mesg - Envia mensajes



## GRUB 2 
grub-install - Instala el gestor de arranque GRUB 2 

grub-install --boot-directory=/mnt/tmp /dev/sda -  Instalacion para una particion de arranque 
    /mnt/tmp - Ruta en donde esta montada la particion de arranque

grub-install --boot-directory=/boot /dev/sda - > Instalacion que no tiene una particion de arranque, sino solo un directorio /boot en el sistema de archivos raiz

update-grub - Comando usado para generar e lmenu.lst usado por /boot, cada cambio en la configuracion del grub, ejecutar este comando

#### Arranque del sistema desde la consola grub
    * Buscar la particion de arranque o donde este la carpeta /boot
    * set root=(hd0,msdos1)
    * linux /vmlinux root=/dev/sda1
    * initrd /initrd.img 
    * boot

####  Arranque desde la consola de rescate 
    * Descubrir que particion es la de arranque
    * set prefix=(hd0,msdos)/boot/grub
    * insmod  normal
    * insmod linux 
    * Despues de ello seguimos los pasos del anterior punto (set root=(hd0,msdos), linux.... , etc )


## GRUB LEGACY 
grub-install /dev/sda - instalador de grub legacy (tenga en cuante que debe de especificar el device donde se instalara, NO la particion /dev/sda1)

#### Instalacion grub legacy desde grub shell
    * Buscar la particion de arranque (puede usar: find /boot/grub/stage1)
    * root (hd0,0)
    * setup (hd0)
    * Cuando termine, reiniciar 

Nota: Puede omitir la instruccion root si  especifica el dispositivo de arranque antes de la ruta en el contenido kernel
    kernel (hd0,0)/vmlinuz root=/dev/hda1


## fdisk 
fdisk - manipulador de tablas de particiones para linux 



## ldconfig
ldconfig - Actualiza la cache de bibliotecas compartidad (/etc/ld.so.cache) y  crear enlaces simbolicos necesatios
    -v, --verbose muestra los numeros de version de la biblioteca, el nombre de cada directorio y los enlaces que se crean 
    -p, --print-cache Imprime las listas de directorios ybibliotecas candidatas almacenadas en la cache actual

## lld
ldd $(which ls) - Usado para buscar las bibliotecas compartidas requeridas por un programa especifico, seguido de la ruta absoluta de un programa 
    -u, --unused imprime las dependencias directas no utilizadas (si existen)

## readelf 
readelf - muestra informacion sobre archivos ELF (ELF significa executable and linkable format)

## objdump
objdump - imprime informacion de archivos de objetos 




## Paquetes Debian 
dpkg [opciones] paquete.deb - utilidad especial para instalar, configurar, mantener y eliminar paquetes de softwrae en sistemas basados en debian 
    -i instalar un paquete 
    -r elimina un paquete 
    -P purga los archivos dejados por un paquete eliminado con -r
    --force forza la instalacion o eliminacion de un paquete a travez de dpkg 
    -I Obtiene informacion sobre un paquete
    --get-selections Obtener una lista de cada paquete instalado en su sistema
    -L Obtener una lista de cada archivo instalado por un paquete en el sistema

Nota:
    1. dkg verifica si las dependencias de un paquete estan instaladas, y no podra instalar el paquete si no lo estan. (No puede resolver las pedendencias por si mismo. Depende del usuario encontrar los paquetes .deb con las dependencias correspondientes  )
    2. La operacion de eliminacion tambien ejecuta una verificacion de dependencias y un paquete no se puede eliminar a menos que tambien se elimina cualquier otro paquete que dependeda de el 
    3. Cuando se elimina un paquete, los arhcivos de confiuracion correspondientes se dejan en el sistema, para eliminarlos se tienn que purgar


dpkg-query -S paquete -  Saber que paquete posee un arhcivo especifico en su sistema
    
dpkg-reconfigure paquete  - Volver a reconfigurar un paquete 



## Paqueteria avanzada (APT)

apt-get [opcion] paquete - Se utiliza para descargar, instalar, actualizar o eliminar paquetes del sistema
    update  Actualizar el indice de paquetes para recuperar informacion sobre paquetes nuevos y actualizados 
    install instalar un paquete 
    remove remover un pauete 
    --purge/purge elimina todos los arrchivos instalados por un paquete
    upgrade actualizar automaticamente cualquier paquete instalado a las ultimas versiones disponibles desde los repositorios (puede instalar un solo paquete agregando el nombre de este, seguido de upgrade )


apt-get install -f   -  Esto intentara arreglar los paquetes rotos instalando las dependencias que faltan, asegunrado que todos los paquetes sean consistentes nuevamente 


apt-cache  [opciones] paquete- Se utiliza para realizar operaciones, como busquedas, en el indice de paquetes
    search  se usa para buscar un paquete
    show mostrar la informacion completa de un paquete 

apt clean  -- para limpiar la cache de apt

apt-file  -  Se utiliza para buscar archivos dentro de los paquetes 
    update   Despues de instalarlo es bueno actualizar la cache
    list   Para enumerar el contenido de un paquete



Notas:
1. Tenga en cuenta que al instalar o eliminar paquetes, APT hará una resolución de dependencias automática. Esto significa que cualquier paquete adicional que necesite el paquete que está instalando también se instalará, y que los paquetes que dependen del paquete que está eliminando también se eliminarán. APT siempre mostrará lo que se instalará o eliminará y le preguntará si desea continuar
2. Tenga en cuenta que cuando se elimina un paquete, los archivos de configuracion correspondientes quedan en el sistema. Para eliminar cualquier archivo hay que purgarlo
3. A medida que instalar paquetes la cache en el archivo /var/cache/apt/archives o /var/cache/apt/archives/partial se hacen grandes, por lo que hay que limpiarlos 
4. En la busqueda de paquetes puede usar expresiones regulares
5. apt-file debe de instalarse ya que es posible que no este disponible en el dispositivo (apt-get install apt-file )



## RPM
### No solo se usa con Red Hat Enterprise Linux, sino tambien con Fedora, CentOS y Oracle Linux, y otras distribuciones como OpenSuse, incluso en sistemas operativos Como AIZ de IMB
rpm [opciones] paquete- herramienta para administrar paquetes de software en sistemas basdos en red hat
    -i instalar un paquete 
    -U Si hay una version anterior de un paqeute en el sistema, puede actualizar a una version mas nueva utilizando este parametro 
    -F Si no hay instalada una version anterior al paquete, se instalara una. Para evitar esto y solo actualizar un paquete, usaremos esta opcion 
    -v obtener una salida detallada
    -h para poder ver el progreso de la instalacion con signos "#"
    -e Para eliminar un paquete instalado (puede pasar varios parametros (paquetes))
    -qa obtener una lista de todos los paquetes instalados en el sistema (piense en query all)
    -qi obtener informacion de un paquete instalado (piense en query info)
    -ql Obtener una lista de todos los archivos que estan dentro de un paquete instalado
    -p ---> hacer un query a un paquetes AUN NO INSTALADO (Podemos usar esta opcion en los pasados 3 comandos como rpm -qip filename o rpm -qlp filename)
    -qf Averiguar que archivo posee un paquete instalado, piense en query file 


Nota:
1. Es lo mismo hacer rpm -i -v -h que rpm -ivh
2. Si un paquete instalado depende del paquete que se esta eliminando, recibira un mensaje de error, por lo que primero hay que eliminar los paquetes que dependen del que desea eliminar


## YellowDog Updater Modificado (YUM)
### Este administrador de paquetes evoluciono para administrar paquetes en otros sistemas basados en RPM, como Fedora, CentOS, RedHat Enterprise Linux y Oracle Linux (su funcion es similar a la utilidad apt)

yum [opciones] NombrePaquete/PATTERN
    search PATTERN Para buscar un paquete. El resultado es una lista de paquetes cuyos nombres o resumentes contienen el patron de busqueda especificado
    install para instalar un paquete 
    update Para actualizar un paquete (Si se omite el nombre del paquete, se actualizara cada paquete en el sistema si existen actualizacions disponibles)
    check-update Para verificar si hay actualizacion disponible para un paquete especifico
    remove  Para eliminar un paquete instalado
    whatprovides  (rpm muestra que archivos faltan, pero NNOO lista el nombre de los paquetes que los proporcionan), por lo que para ver que paquete proporciona una dependencia usamos esta opcion, seguido del nombre del archivo que se esta buscando (ESTO TAMBIEN FUNCIONA PARA ARCHIVOS QUE YA ESTAN EN SU SISTEMA, POR EJEMPLO, SI QUEREMOS SABER DE DONDE PROVIENE EL ARCHIVO /etc/host, usamos, yum whatprovides /etc/host)
    info Para buscar informacion sobre un paquete
    repolist all  Lista de todos los repositorios disponibles
        En este comando nos mostrara la lista de repositorios que estan hbailitados o deshabilitados, para poder activar o desactivar uno, usaremos yum-config-manager,y lo señalaremos con la parte que le antecede al "/" en la parte del repo id, ejemplo "yum-config-manager --disable updates" o "yum-config-manager --enable updates"

    clean  Se usa para limpiar la cache y recuperar espacio en el disco de los paquetes descargados y los metadatos en el directorio /var/cache/yum
        Los parametros mas utiles de este parametro son:
            packages  Elimina los paquetes descargados y  la metadata
            metadata  Para eliminar los metadatos asociados

yum-config-manager [opcion] URL  -  Nos permite agregar de forma correcta repositorios
     --add-repo  Agregara el repositorio a un archivo .repo en /etc/yum.repos.d/ o al final de /etc/yum.conf
    
     
## DNF
### Herramienta de administracion usada en FEDORA y es una BIFURCACION de YUM
Buscar paquetes    dnf search PATTERN, donde PATTERN es lo que está buscando. Por ejemplo, dnf search unzip mostrará todos los paquetes que contienen la palabra unzip en el nombre o la descripción.
Obtener información de un paquete    dnf info PACKAGENAME
Instalar paquetes    dnf install PACKAGENAME, donde PACKAGENAME es el nombre del paquete que desea instalar. Puede encontrar el nombre realizando una búsqueda.
Eliminar paquetes    dnf remove PACKAGENAME
Actualizar paquetes     dnf upgrade PACKAGENAME para actualizar solo un paquete. Omita el nombre del paquete para actualizar todos los paquetes en el sistema.
Encontrar qué paquete proporciona un archivo específico    dnf provides FILENAME
Obtener una lista de todos los paquetes instalados en el sistema    dnf list --installed
Listar el contenido de un paquete    dnf repoquery -l PACKAGENAME

dnf tiene un sistema de ayuda incorporado, que muestra informacion, como dnf help install


dnf repolist   Para listar solo los repositorios habilitados/deshabilitados, agregamos la opcion (--enabled/--disabled)

dnf config-manager --add-repo URL    Agregar un repositorio
dnf config-manager --set-enabled REPO_ID   Para habilitar un repositorio
dnf config-manager --set-disabled REPO_ID   Para deshabilitar un repositorio
    ++ Los repositorios agregados estan habilitados por defecto
    ++ Los repositorios se almacenan en archivos .repo  en el directorio /etc/yum.repos.d/, con la misma sintaxis que yum


## Zypper
### Es la herramienta que utiliza en SUSE linux y OpenSUSE, es muy similar a apt y yum, con resolucion de dependencias automatizada

zypper [opciones] NAMEPAKAGE
    refresh  al igual que otras herramientas, zypper funciona con repositorios que contienen paquetes y metadatos, estos deben de actualizarse de vez en cuando
    search (o simplemente se)  busca un paquete
        search tambien se puede usar para obtener una lista de todos los paquetes instalados en el sistema, con la opcion -i, como zypper search -i o zypper se -i O simplemente para ver el paquete instalado
            Para buscar solo entre paquetes no-instalados, agregue el parametro -u al operador se 
            --provides para ver que paquetes contiene un archivo especifico, seguido del nombe del archivo (o la ruta completa)

    instalar (o simplemente in)
    update  para actualizar los paquetes instalados en el sistema 
    list-updates    Si solo deseas listar las actualizaciones disponibles, sin nada
    remove (o simplemente rm) Para eliminar un paquete (Tenga en cuenta que eliminar un paquete tambien elimina cualquier otro paquete que dependa de el )
    info    Para ver los metadatos asociados con un paquete
    repos   Para ver la lista de todos los repositorios actualmente registrados en su sistema
    modifyrepo  (-e|-d) Si quiere habilitar un repositorio, debera ocupar este comando, seguido del alias
    modifyrepo (-F|-f)  Cuando esta habilitado, este indicador hara que zypper ejecute una operacion de actualizacion (lo mismo que ejecutar zypper refresh)
            # zypper modifyrepo -F repo-non-oss
                Autorefresh has been disabled for repository 'repo-non-oss'.
            # zypper modifyrepo -f repo-non-oss
                Autorefresh has been enabled for repository 'repo-non-oss'.
    addrepo URL Para agregar un nuevo repositorio
        (Al gregar un repositorio, puede habilitar las actualizaciones con el parametro -f. Los repositorios agregados están habilitados de manera predeterminada, pero puede agregar y deshabilitar un repositorio al mismo tiempo utilizando el parámetro -d.)
    removerepo ALIASREPO Para eliminar el repositorio agregado


Nota:
    * zypper puede usarse para instalar un paquete RPM en disco, mientras intenta satisfacer sus dependencias usando paquetes de los repositorios 
    

# Tema 103
pwd - Obtener informacion de la ruta donde esta ubicado

touch - creacion de un archivo vacio 
    -a cambia solamente la hora de acceso
    -m solo cambia la hora de modificacion

cp - copiar archivos 

mv - mover archivos 
    -i pedir confirmacion
    -f sobreescribira forzosamente

mkdir - creacion de directorios
    -p creacion de directorios multiples

rmdir - borra un direcotrio SI esta vacio
    -p elimina un directorio con su subdirectorio SI esta vacio

rm - eliminar un arhcivo/direcotrio
    -r borrar de forma recursiva
    -i pedira confirmacion antes de eliminar un archivo

ls - listar
    -R listar de forma recursiva

history - ver historial de comandos 


---
#### wildcars
rm *    Elimina todos los archivos en el directorio de trabajo actual.
ls l? st    Lista todos los archivos con nombres que comienzan con l seguidos de cualquier caracter indiv
idual y terminan con st.
rmdir [a-z] *  Elimina todos los directorios cuyos nombres comienzan con una letra.


EL ASTERICSO (*)
coincide con cero, una o mas apariciones de cualquier carcater

ejemplos:
        $> find /home -name *.png
        $> ls lpic-*.txt
        $> cp -r animal/* forest
El asterisco, como cualquier otro wildcard, podria usarse repetitidamente en el mismo comando y el cualqu
ier posicion 
ejem: rm *ate* 


EL SIGNO DE INTERROGACION (?)
coincide con una UNICA aparicion de un carcater

si consideramos que en un directorio tengan:
last.txt    lest.txt    list.txt    third.txt   past.txt

ejemplos:
$> ls l?st.txt
        last.txt    lest.txt    list.txt

$> ls ??st.txt
        last.txt    lest.txt    list.txt    past.txt

LOS CARCATERES ENTRE CORCHETES ([])
Los wildcard entre corchetes coinciden con cualquier aparicion de los carcateres entre corchetes

$> ls l[aef]st.txt
        last.txt    lest.txt

tambien se puede usar rango 

$> l[a-z]st.txt
        last.txt    lest.txt    list.txt

tambien se pueden aplicar varios rangos de corchetes, como:
$> ls
        student-1A.txt  student-2A.txt  student-3.txt
$> ls student-[0-9][A-Z].txt
        student-1A.text student-2A.txt

---


echo - Imprime cadenas de entrada y variables.
env - Entiende y modifica sus variables de entorno.
export - Pasa una variable de entorno a los shells secundarios.
unset - Borra valores y atributos de variables y funciones de shell. (Para eliminar una variable, no debe de antecederle el "$", ejem: unset PATH)
et - generara todas las variables y funciones en el entorno


**(Tenga en cuenta que las comillas simples conservarán el valor literal de todos los caracteres, mientras que las comillas dobles conservarán todos los caracteres excepto para $, `, \ y, en ciertos casos, !.)** 

cat - Se usa para combinar o leer archivos de texto sin formato.
    cat > file    Redirigira toda entrada en el file
    > sobresscribe archivo
    >> agrega al final del archivo 

diff - compara dos archivos 

less - navegacion comoda dentro de archivos 

head - muestra las primeras 10 lineas
    -n N  Puede mostrar un numero exacto de lineas, donde N es el numero a mostrar

tail - muestra las ultimas 10 lineas 
    -n N  Puede mostrar un numero exacto de lineas, donde N es el numero a mostrar
    -f con esta opcion nos permite seguir al archivo mientras se agrega mas contenido 

nl - enumera las lineas

wc -l  - cuenta las lineas

zcat - leer archivos gzip sin descomprimirlos
bzcat - leer archivos bzip2 sin descomprimirlos
xzcat - leer archivos xz sin descomprimirlos


grep - muestra coincidencias de una string dentro de un archivo
     - facilita la inspeccion de archivos largos, usando la exprecion regular como filtro aplicado a cada linea 
    -v indica al comando que muestre las lineas que NO coinciden
    -c / --count Muestra cuabtas libneas tienen coincidencias ejem: fdisk -l | grep '^Disk /dev/sd[ab]' -c --> La puedes colocarr antes o despues de la expresion regular
    -i / --ignore-case Hace que la busqueda no distinga entre mayusculas o minusculas
    -f File / --file=FILE  Indica un archivo que contenga la expresion regular a utilizar
    -n / --line-number  Muestra el numero de la linea
    -v / --invert-match Selecciona todas las lineas, exepto las que contengan coincidencias
    -H / --with-filename Imprime tambien el nombre del archivo que contiene la linea
    -z / --null-data  En lugar de que grep trate los flujos de datos de entrada y salida como líneas separadas (usando newline por defecto), toma la entrada o salida como una secuencia de líneas. Cuando se combina la salida del comando find usando su opción -print0 con el comando grep, la opción -z o --null-data debe usarse para procesar el flujo de la misma manera
    -N donde N es un numero, este numero especifica que incluya N lineas antes o despues cuado encuentre una coincidencia, son lineas de contexto, se puede obtener el mismo resultado con -C 1 o --context=1 

egrep - es equivalente al comando grep -E, que incorpora carcateristicas adicionales ademas de las expresiones regulares basicas
    -o Para mostrar solo las partes de un flujo de texto que coinciden con la expresion utilizada por egrep 

fgrep - Es equivalente a grep -F, no analiza expresiones regulares, es util en busquedas simples donde el objetivo es hacer coincidir una expresion literal. Por lo tanto los carcateres especiales como el signo de dolar y el punto se tomaran literalmente y no por su significado en una expresion regular



sed - editor de glujo para filtrar u trasformar texto, se debe de redirigir el archivo al comando como sed .. < file
      su proposito es modificar datos basados en texto de una manera no interactiva, significa que toda la edicion se realiza mediante instrucciones predefinidas

    Su sintaxis basica es: sed -f SCRIPT Cuando las intrucciones de edicion se almacenan en el archivo SCRIPT
    sed -e COMMADS para ejecutar COMMADS directamente desde la linea de comandos
    Si no hay -e ni -f, sed utiliza el primer parametro que no es ina opcion de script
    -n instruye a sed para que no produzca salida (a menos por las instrucciones posteriores del comando p)
        (https://www.ionos.mx/digitalguide/servidores/configuracion/comando-sed-de-linux/)
    Ejemplos:
        - Eliminar la primera linea: ... | sed 1d
        - Eliminar un rango de lineas: ... | sed 1,7d
        - Ejecutar mas de una instruccion: ...|  sed "1,7d;11d"
        - ... | sed "1d;/:.*2.*/d"    La expresión regular :.*2.* coincide con cualquier aparición del número 2 en cualquier lugar después de dos puntos, lo que provoca la eliminación de las líneas correspondientes a los números con 2 como factor. Con sed, cualquier cosa colocada entre barras (/) se considera una expresión regular y, por defecto, se admiten todos los RE básicos





factor - numeros factores 



sort - Se utiliza para organizar la salida de una lista alfabéticamente, alfabéticamente inversa o en orden aleatorio.

uniq - Se usa para enumerar (y contar) cadenas coincidentes.

od - El comando “octal dump” se utiliza para mostrar un archivo binario en notación octal, decimal o hexadecimal.

tr - El comando traducir puede reemplazar caracteres y también elimina y comprime caracteres repetidos.

cut - Este comando puede imprimir columnas de archivos de texto como campos basados en el delimitador de caracteres de un archivo.

paste - Unir archivos en columnas según el uso de separadores de campo.

split - Este comando puede dividir archivos más grandes en archivos más pequeños según los criterios establecidos por las opciones del comando.



md5sum - Se utiliza para calcular el valor hash MD5 de un archivo. También se utiliza para verificar un archivo contra un valor hash existente para garantizar la integridad de un archivo.

sha256sum - Se utiliza para calcular el valor hash SHA256 de un archivo. También se utiliza para verificar un archivo contra un valor hash existente para garantizar la integridad de un archivo.

sha512sum - Se utiliza para calcular el valor hash SHA512 de un archivo. También se utiliza para verificar un archivo contra un valor hash existente para garantizar la integridad de un archivo.


ls - listar contenido de un directorio

touch - crear archivos nuevos vacios
        --> TAMBIEN PUEDE USARLO PARA CAMBIAR MARCAS DE TIEMPO, ES DECIR, LA HORA DE MODIFICACION DE LOS ARHIVOS Y DIRECTORIOS EXISTENTES 
        sin opciones, crear un archivo
        -a cambia solo la hora de acceso
        -m solo cambia la hora de modificacion 
            ejem: (touch -am file3)

cp - copiar un archivo a otro
    -r (-R o --recursive) permite copiar un directorio junto con todos sus subdirectorios y arhcivos 

Nota:
Cuando una ruta comienza con el carcater "/" es una ruta absoluta, de lo contrario es una ruta relativa 


mv - mover o renombrar archivos 
    De manera predeterminada, mv no buscara confirmacion
    -i hace que el sistema solicite confirmacion, utilizando la opcion -i
    -f sobreescribira forzosamente el archivo, sin pedir ningun permiso 

rm - elimina archivos
    -i hace que el sistema solicite confirmacion, utilizando la opcion -i ejem: rm -ri mydir/
    -f eliminara forzosamente el archivo, sin pedir ningun permiso 
    -r eliminacion recursiva 

mkdir - creacion de directorios 
    -p crear un directorio junto con sus subdirectorios ejem: mkdir -p parents/children

rmidr - borra un directorio SI esta vacio
    -p elimina un directorio con sus subdirectorios ejem: rmdir -p parents/children


En linux, las opciones -r o -R o --recursive generalmente estan asociadas con la recursividad


ls - listar contenido de un directorio
    -R enumerar contenido de undirectorio junto con sus subdirectorios y archivos 

nota: agregar una barra inclinada al final del directorio, no tiene ningun efecto, es lo mismo ls -R animal que ls -R animal/



\* - Coincide con 0 o mas carcateres de cualquier tipo 
    rm -rf * -> Todos los archivos 
    ls *.txt -> Todos los txt
    ls ab*cd  -> cualquier cosa que empiece con ab y termine con cd 

\? - Coincide con exactamente un carcater
    ls l?st.txt -> last.txt, lest.txt, list.txt
    ls ??st.txt -> Dos carcateres + "st.txt"
        perfecto para patrones de longitud fija

\[] - Conunto o rangos de carcateres
    Permite definir:
        - Un conjunto: [abc]
        - Un rango: [a-z]
        - Combinaciones: [0-9A-Z]
            ejemplos:
                ls l[aef]st.tx -> last.txt y lest.txt
                ls student-[0-9][A-Z].txt -> 1A, 2A, 3B, etc (Permite controlar exactamente que carcateres son validos en cada posicion )

* Globbing no usa expresiones regulares
* Un wildcard puede usarse en cualquier parte del nombre
    ejemplo:
        *abc*
        [a-z]*.conf
        ???.txt
* Los wildcards trabajan con el nombre del archivo, no con el  contenido 
    Si quiees buscar dentro del archivo, usa grep

* Los patrones se expanden antes de ejecutar el comando
    ejemplo:
        rm *.png  -> El shell genera rm foto.png fondo.png icono.png, y esta lista se pasara al comando rm

* Si un patron no coincide con nada  
    En bash queda literal (a menos que tengas nullglob activado)
        Ejemplo: ls *.xyz --> Dara error porque "*.xyz" queda literal como argumento


Wildcard	Significa	Ejemplo	Resultado
\*	0 o más caracteres	*.txt	todos los .txt
?	1 carácter	file?.log	file1.log, fileX.log
[ ]	1 carácter del conjunto o rango	[a-z]*	archivos que empiezan con a–z



find - busca arhivos en todo el servidor 
    sintaxis: find starting\_path options expression
    -name "nombre" busqueda literalmente ejem: find / -name "*.png"
    -iname "Nombre" busca sin distinguir entre mayusculas y minusculas
    -type f/d/l busca archivos, directorios o enlaces simbolicos respectivamente
    -not  devuelve los resultados que no coinciden con el caso de prueba ejemplo: find . -iname "file*" -not -type d     ,   find . -type 
    -maxdepth N Busca en el directorio actual asi como en los subdirectorios N niveles de profundidad
    -mtime N Donde N representa el numero de dias desde la ultima modificacion  
    -size N(c/k/M/G) ejemplos:
        -size 100c archivos de exactamente 100 bytes
        -size +100k archivos de mas de 100 kylobytes
        -size -20M archivos de menos de 20 megabytes
        -size +2G archivos de mas de 2 gigabytes
        -size 0c  o simplemente find . -empty  para buscar archivos vacios
    -exec comand {} \;  donde command es el comando a ejecutar sobre los resultados y {} es el listado de find 
    -print usado para imprimir resultados que coincidan con considiones
        ejem: find . -type f -exec grep "lpi" '{}' \; -print  las llaves {} estan en comillas simples para evitar pasar archivos grep con nombres que contengan carcateres especiales
        ejem: find . -name "*.bak" -delete  -delete borrara los archivos que encuentre, para eso debe de estar seguro que las coincidencias de lo que busque sean los correctos
    -print0 se usa con xargs, y este se usa cuando las rutas tienen carcateres de espacion, le indica a find que use un carcater nulo entre cada entrada para que la lista pueda ser analizada correctamente por xargs      ejemplo: find . -name '*avi' -print0 -o -name '*mp4' -print0 -o -name '*mkv' -print0 | xargs -0 du | sort -n
    -regex permite probar cada ruta en una jerarquia de directorios contra una expresion regular, ejemplo: find $HOME -regex '.*/\..*' -size +100M (sólo en rutas dentro del directorio de inicio del usuario que contienen una coincidencia con .*/\..*, es decir, un /. rodeado por cualquier otro número de caracteres. En otras palabras, sólo se enumerarán los archivos ocultos o los archivos dentro de los directorios ocultos, independientemente de la posición de /. en la ruta correspondiente)
    -iregex Para expresiones regulares que no distinguen entre mayusculas y minusculas


tar - tape archive, se utiliza para crear archivos tar convirtiendo un grupo de archivos en un archivo 
    sintaxis: tar [operation_and_options] [archive_name] [file_names(s)]

OPERATION
    Solo se permite y requiere un argumento de operación. Las operaciones más utilizadas son:
    --create (-c)
        Crea un nuevo archivo tar.
    --extract (-x)
        Extrae todo el archivo o uno o más archivos de un archivo.
    --list (-t)
        Muestra una lista de los archivos incluidos en el archivo.

OPTIONS
    Las opciones más utilizadas son:
    --verbose (-v)
        Muestra los archivos que se están procesando con el comando tar.
    --file=archive-name (-f archive-name)
        Especifica el nombre del archivo de almacenamiento.

ARCHIVE_NAME
    El nombre del archivo.

FILE_NAME (S)
    Una lista de nombres de archivos separados por espacios que se extraerán. Si no se proporciona, se extrae todo el archivo


        ejem: tar -xvf archive.tar  este comando estraira los archivos en el directorio actuao
    -C extrae el contenido en un directorio diferente
        ejem: tar -xvf archive.tar -C /tmp
    
    Para comprimir con tar usamos cualquiera de las dos siguientes opciones
    -z para gzip  ejem: tar -czvf file.tar.gz file   
    -j para bzip2  ejem: tar -cjfv file.tar.bz file 
        --> para descomprimir, solo sustituimos c por x 
            gzip es más rápido, pero generalmente se comprime un poco menos, por lo que se obtiene un archivo algo más grande. bzip2 es más lento, pero se comprime un poco más, por lo que se obtiene un archivo algo más pequeño


gzip - compresion con algoritmo gzip 
    sintaxis: gzip Fike-to-Compress

nota:
    * gzip crea el arhcivo comprimido con el mismo nombre pero con un final .gz 
    * gzip elimina los archivos originales despues de crear el archivo comprimido 


bzip2 - compresion con algoritmo bgzip2
    sintaxis: bgzip2 Fike-to-Compress

nota:
    * bgzip2 crea el arhcivo comprimido con el mismo nombre pero con un final .bz2
    * bgzip2 elimina los archivos originales despues de crear el archivo comprimido 



cpio - significa  "copy in, copy out". Se utiliza para procesar archivos de almacenamiento como archivo *.cpio o *.tar
        Este comando realiza las siguientes acciones:
            - copiar archivos a un archivo
            - Extraer archivos de un archivo 
    -o le indica a cpio que cree una salida
    -i realiza un extracto 
    -d crea una carpeta destino 
    
    ejemplos:   
        ls | cpio -o > archivo.cpio  la salida de ls se archivara en el archivo archivo.cpio
        cpio -id < archive.cpio  se extraera la informacion creando al mismo tiempo un espacio para los mismos archiovs, el archivo .cpio se pasa por redireccion 





dd - copia datos de una ubicacion a otra
    sintaxis: dd if=oldfile of=newfile  --> esto copiara el contenido de oldfile a newfile
    status=progess muestra una barra de progreso



Por defecto > redirige el contenido que llea a stdout 
1> redirige la salida stdout, equivalente a  ">"
2> redirige la salida stdout 
&> o >& Se redirige tanto stdout como stderr 
1>&2 redirige stdout a stderr 
2>&1 redirige stderr a stdout 
< este simbolo tambien es una redireccion donde los datos fluyen hacia la derecha, este se usa para redirigir el contenido de un archivo al stdin de un proceso ejemplo: uniq -c < file.txt
Una redireccion sin doble ">>" sobreescribe un archivo, a menos que la opcion bash "noclobber" este habilitada, lo que puede hacer para la sesion actual con el comando set -o noclobber o set -C y para desactivarlo usamos set +o noclobber o set +C


Here document - Es una forma de redireccion de varias lineas
sintaxis: command <<EOF
>
>
> EOF 
	
ejemplo: 
wc -l <<EOF
> how may word I wrote?
> EOF


Here document - Es otra forma de redireccion de UNA sola linea
sintaxis: echo -n "Strings" | command 

ejemplo:
echo -n "How many characters in this here string?" | wc -l 


tee - lee desde la salida estandar y escribe en un archivo la salida estandar
    sintaxis: ... | tee name.File.txt
    -a Para agregar en un archivo y no sobreescribirlo 



Sustitucion de comando
Puede sustituir la salida estandar de un comando encerrandolo entre comillas simples inversas
    ejemplo: mkdir 'date +%Y-%m-%d'
Se puede obtener un resultado similar con $()
    ejemplo:mkdir $(date +%Y-%m-%d)
    

xargs - usa la salida de un comando como argumento de otro programa 
    -n N esta opcion hace que xargs ejecute el comando dado con N argumentos a la vez
    -L puede usarse para limitar cuantas lineas se usaran como argumentos por ejecucion de comando 
    -0 le dice a xargs que el carcater nulo debe usarse como separador

notas:
    por defecto xargs coloca los argumentos del comando ejecutado en ultimo lugar, para cambiar ese comportamiento debe usar la opcion -I 
        ejemplo: find . -mindepth 2 -name '*avi' -print0 -o -name '*mp4' -print0 -o -name '*mkv' -print0 | xargs -0 -I PATH mv PATH ./





jobs - muestra los procesos que se han iniciado de forma interactiva a travez de un terminal
    -l se muestran los ID del proceso (PID) justo antes del estado
    -n muestra solo los procesos que han cambiado desde la ultima notificacion (posibles estados, Running, Stopped, Terminated o Done)
    -r lista los procesos en ejecucion
    -s lista solamente los trabajos detenido 


notas: 
    si el comando no muestra ninguna salida, no hay trabajos en segundo plano 
    ejemplo de salida:
        jobs 
        [1]+ Stopped    sleep 60
            [1] es el ID del trabajo y se puede utilizar, precedido por un simbolo de porcentaje (%) 
            +/- si es +, es el trabajo actual predeterminado (el ultimo suspendido), el trabajo anterior esta marcado con un signo menos -
            Stop Descripcion del estado del trabajo
            sleep 60  comando o trabajo en ejecucion
    Especificar trabajos:
        %n  trabajo cuyo numero de identificacion es n 
        %str    trabajo cuya linea de comando comienza con str
        %?str   trabajo cuya linea de comando contiene str
        %+ o %% trabajo actual (el ultimo que se inicio o suspendio del primer plano)
        %-  Trabajo anterior

Despues de poner en segundo plano 

fg - llevar el proceso a primer plano
    ejemplo: fg %1

bg - llevar el proceso a segundo plano
    ejemplo: bg %1
notas:
    El simbolo & se usa para poner en segundo plano un comando, como: sleep 100 & 

kill  - mata un proceso en ejecucion
    ejemplo: kill %2
    Las señales se pueden especificar por:
        kill -SIGHUP 1234  nombre
        kill -1 1234   numero
        kill -s SIGHUP 1234  opciones
    puede hacer la misma funcion que killall, como kill -1 $(pgrep sleep)


notas(fg, bg y kill): 
    Si no se especifica ningun trabajo, fg y bg actuaran sobre el actual, predeterminado, mientras que kill necesita una especificacion de trabajo 


nohup - sepra los trabajos de las sesiones y hace que se ejecuten incluso despues de cerrar la sesion
    sintaxis: nohup COMMAND &

notas: 
    nohup.out es el nombre del archivo predeterminado donde se guardan stdout y stderr


watch - nos permite mirar el cambio de salida del programa con el tiempo
    -n N  o  --interval donde N es el intervalo de segundos para el cual watch se actualizara

notas:
    Por defecto el tiempo periodico se ejecuta 2 segundos



pgrep - Averigua el PID de un proceso
    sintaxis: pgrep comando
    El identificador de un proceso se puede cubrir a travez del comando pidof ejemplo: pidof sleep

pkill - mata un proceso en su nombre 

killall  -  matar varias instancias del mismo proceso
    ejemplo: killall sleep


top  - herramienta que monitorea los procesos de forma dinamica
Ya dentro de l ainterfaz de top podemos usar alguna de las sisguientes opciones:
    M   Ordena por uso de memoria
    N   Ordena por numero de ID
    T   Ordena por porcentaje de uso en CPU
    R   Ordena entr orden descendente/ascendente 
    ? o h    Ayuda.
    k    Mata un proceso. top solicitará que se elimine el PID del proceso y que se envíe la señal (por defecto, SIGTERM o 15).
    r    Cambiar la prioridad de un proceso (renice). top le pedirá el valor nice. Los valores posibles oscilan entre -20 y 19, pero solo el superusuario (root) puede establecerlo en un valor negativo o inferior al actual.
    u    Lista de procesos de un usuario en particular (de forma predeterminada se muestran los procesos de todos los usuarios).
    c    Muestra las rutas absolutas de los programas y diferencia entre procesos de espacio de usuario y procesos de espacio de kernel (entre corchetes).
    V    Vista de bosque/jerarquía de procesos.
    t y m    Cambia el aspecto de las lecturas de CPU y memoria respectivamente en un ciclo de cuatro etapas: las dos primeras pulsaciones muestran barras de progreso, la tercera oculta la barra y la cuarta la recupera.
    W   Guardar ajustes de configuración en ~/.toprc.


ps  - herramienta que monitorea los procesos de forma estatica      
    a   mostrar procesos que estan conectados a un tty o terminal
    u   Mostrar formato orientado al usuario
    x   Mostrar procesos que no estan conectados a un tty o terminal


Puede aceptar tres estilos diferentes:
    BSD
        ps p 811 (las opciones no siguen ningun guion inicial)
    UNIX
        ps -p 811 (las opciones siguen un guion inicial)
    GNU
        ps --pid 811 (las opciones van seguidas de guiones dobles iniciales)

por ejemplo:
    ps U carol 
    ps -u carol
    ps --user carol

Notas:
    USER    Dueño del proceso.
    PID    Identificador de proceso.
    %CPU    Porcentaje de CPU utilizado.
    %MEM    Porcentaje de memoria física utilizado.
    VSZ    Memoria virtual de procesos en KiB.
    RSS    Memoria física no intercambiada utilizada por el proceso en KiB.
    TT    Terminal (tty) que controla el proceso.
    STAT    Código que representa el estado del proceso. Además de S, R y Z (que vimos al describir la salida de top), otros valores posibles incluyen: D (suspensión ininterrumpida — generalmente esperando E/S), T (detenido — normalmente por una señal de control). Algunos modificadores adicionales incluyen: < (alta prioridad — no agradable para otros procesos), N (baja prioridad — agradable para otros procesos) o + (en el grupo de procesos en primer plano).
    STARTED    Hora a la que comenzó el proceso.
    TIME    Tiempo de CPU acumulado.
    COMMAND    Comando que inició el proceso.



| Accion | tmux | screen |
|--------|------|--------|
|iniciar | tmux | screen |
|iniciar sesion con nombre | tmux  new -s session (agregamos -n para dar nombre a la primera pestaña)| screen -S session |
|Listar sesiones | tmux ls  | screen  -ls|
|Adjuntarse a una sesion | tmux attach-session -t  session | screen -r  session |
|Adjuntarse a una sesion (cuando es la unica sesion) | tmux  attach-sessipm | screen -r |
| Matar una sesion | tmux kill-session -t session  | screen -S session -X quit|
| Desadjuntarse de la sesion  | ctrl+b d | ctrl+a d  |
|  | **VENTANAS** | |
|ver todas las ventanas | ctrl+b w | ctrl+a w |
| Crear una nueva ventana | ctrl+b c | ctrl+a c |
|Pasar a la siguiente ventana | ctrl+b n | ctrl+a n |
|Pasar a la anterior ventana | ctrl+b p (Podemos cambiar de numero de ventana con los numeros, como ctrl+a N, donde N es numero) | ctrl+a p (Podemos cambiar de numero de ventana con los numeros, como ctrl+a N, donde N es numero) |
|Renombrar ventana actual | ctrl+b ,  | ctrl+a A |
|Ver las sesiones en forma de lista (podemos usar las flechas en ambos casos) | ctrl+b w | ctrl+a " |
|Deshacer una ventana | ctrl+b & | screen |
| | **Regiones(screen)/Paneles(tmux)** | |
| Division (horizontal) | ctrl+b " | ctrl+a S |
|Division (vertical) | ctrl+b % | ctrl+a | |
|Terminar todas las regiones exepto la actual | ctrl+b ! | ctrl+a Q |
|--- | tmux | screen |


nice - Establce el valor de prioridad antes de que se ejecute el comando
    -n rango de -20 a 19 ejem: nice -n 15 tar -czvf files.tar.gz dir/

nota: 
- Todo proceso normal comienza con un valor nice predeterminado de 0 (prioridad 120)
- -20 (menis agradable) y 19 (mas agradable, consumo menos de cpu)
- Solo root puede disminuir el valor nice de un proceso por debajo de cero

renice - Establece el valor de priioridad despues de que haya ejecutado el comando
    Sintaxis: renice -N -p PID, ejemplo: renice -10 -p 2164
    -g se usa para modificar todos los procesos de un grupo
    -u se utiliza para modificar todos los procesos de un usuario en especifico 
        ejemplo: renice +5 -g users (el valor nice de los procesos propiedad de los usuarios del grupo users se elevara en cinco)


Nota: 
- En el programa top, se puede modifcar la prioridad de los procesos presionando r y luego el numero del PID del proceso

. Coincide con cualquier carcater
^ Coincide con el comienzo de una linea
$ coincide con el final de una linea
[] Usado para especificar rangos de carcateres 
* Cuantificador, el atomo aparece cero o mas veces, y es un carcater literal si aparece al principio
{} Usado para especificar limites 






vim - Es un editor estandar en el entorno shell
    Para saltar a una linea especifica: vim +N file.txt, donde N es el numero

Hay diferentes modos de comportamiento, pero los mas comunes son: modo insercion y modo normal (Para regresar al modo "normal"(modo predeterminado) hay que apretar la tecla ESC)

Modo normal (modo predeterminado)
0,$ Va al principio o al final respectivamente
1G,G Val al principio o al final del documento
( , ) Vaya al principio y al final de la oracion
{ , } Vaya al principio y al final del parrafo
w , W Saltar palabra y saltar palabra, incluida la puntucacion
Modo insercion: el texto aparece en pantalla a medida que se escribe en el teclado
h,j,k,l izquierda, abajo, arriba, derecha
e , E ir al final de la palabra actual
/ , ? Busca hacia adelante y hacia atras
i, I    Ingrese al modo de inserción antes de la posición actual del cursor y al comienzo de la línea actual.
a, A    Ingrese al modo de inserción después de la posición actual del cursor y al final de la línea actual.
o, O    Agregue una nueva línea e ingrese al modo de inserción en la línea siguiente o en la línea anterior.
s, S    Borre el carácter debajo del cursor o toda la línea e ingrese al modo de inserción.
c    Cambie el (los) carácter (es) debajo del cursor.
r    Reemplaza el carácter debajo del cursor.
x    Elimina los caracteres seleccionados o el carácter debajo del cursor.
v, V    Inicie una nueva selección con el carácter actual o la línea completa.
y, yy    Copia (tira) los caracteres o la línea completa.
p, P    Pega el contenido copiado, antes o después de la posición actual.
u    Deshace la última acción.
Ctrl-R    Rehace la última acción.
ZZ    Cerrar y guardar.
ZQ    Cerrar y no guardar.


Si esta precedido por un numero, el comando se ejecutara el mismo numero de veces, ejemplo: 3yy para copiar la linea actual 3 veces, o d5w para eliminar la palabra actual y las 4 palabras siguientes

Comando Colon (los comandos de dos puntos)
Estos comandos permiten al usuario realizar busquedas, guardar, salir, ejecutar comandos de shell, cambiar la configuracion de vi, algunos comandos mas comunes son:
:s/REGEX/TEXT/g     Reemplaza todas las apariciones de la expresión regular REGEX por TEXT en la línea actual. Acepta la misma sintaxis del comando sed, incluidas las direcciones.
:!    Ejecutar el comando de shell especificado a continuación.
:quit o :q    Salir del programa.
:quit! o :q!     Salir del programa sin guardar.
:wq    Guardar y Salir.
:exit o :x o :e    Guardar y salir, si es necesario.
:visual    Volver al modo de navegación


fdisk - administrar articiones mbr en linux 
    Sintaxis: fidisk /dev/sda (Debe especificar el dispositivo correspondiente al disco, no una de sus particiones como /dev/sda1)
    -w Escribir los cambios realizados
    -q para salir sin guardar cambios 
    -p imprimir la tabla de particiones actual
    -n crear una particion
    -F mostrar el espacio no asignado
    -d eliminar particion (en caso de que solamente haya una particion en el disco, esta particion sera eliminada inmediatamente)
    -t cambiar el tipo de particion que deseamos cambiar
    -l ver lista de todos los codigos validos (No confunda el tipo de partición con el sistema de archivos que se utiliza en ella) 

Notas:
- Puede crear, editar, o eliminar particiones a voluntad pero no se escribira nada en el disco, a menos que utilice el comando write (w)
- Las particiones de linux son del tipo 83(linux). Las particiones de intercambio son del tipo 82(linux swap)


gdisk - administrar particiones GUID en linux 
    -p imprimir la tabla de particiones actual
    -n Crear una particion (Pude especificar el tipo de particion durante la creacion)
    -l ver lista de todos los tipos
    -d Eliminar particion del disco (A diferencia de fdisk, la primera particion no se seleccionara automaticamente si es la unica en el disco)
    -s reordenar la numeracion de las particiones (util si se elimina una particion y se quiere mantener el ornden dentro de ella)
    -r acceder a la reconstruccion de un encabezado GPT corrupto o una tabla de particiones con b y c respectivamente
        -Usar el encabezado
    -f Convertir un MBR a GPT
    -g Convertir GPT a MBR 

Nota:
- El espacio libre aparece en la ultima linea, por lo que no es necesario un equivalente del comando F
- Las particiones se pueden reordenar u ordenar facilmente para evitar huecos en la secuencia de numeracion, para ello solamente usar "s"




mke2fs - Las utilidades mkfs.ext2, mkfs.ext3 y mkfs.ext4 se utilizan para crear sistemas de archivos ext2, ext3 y ext4 respectivamente. De hecho, todas estas “utilidades” existen sólo como enlaces simbólicos a otra utilidad llamada mke2fs
    Ejemplo de compatibilidad: mkfs.ext4 /dev/sdb1 y mke2fs -t et4 /dev/sdb1 harian la misma funcion
    Los siguientes parametros se aplican a las utilidades mkfs.ext{2..4}
    -b SIZE Establece el tamaño de los bloques de datos en el dispositivo en  SIZEm, que puede ser de 1024, 2048 o 4096 bytes por bloque
    -c Comprueba el dispositivo de destino en busca de bloques defectuosos antes de crear el sistema de archivos, puede parar el parametro varias veces para una comprobacion completa pero mucho mas lenta, como mkfs.ext4 -c -c TARGET
    -d Copia el cntenido del directorio especificado en la raiz del nuevo sistema de archivos. Util si necesita rellenar previamente el disco con un conjunto predefinido de archivos
    Establece el tamaño de los bloques de datos en el dispositivo en  SIZEm, que puede ser de 1024, 2048 o 4096 bytes por bloque
    -c Comprueba el dispositivo de destino en busca de bloques defectuosos antes de crear el sistema de archivos, puede parar el parametro varias veces para una comprobacion completa pero mucho mas lenta, como mkfs.ext4 -c -c TARGET
    -d Copia el cntenido del directorio especificado en la raiz del nuevo sistema de archivos. Util si necesita rellenar previamente el disco con un conjunto predefinido de archivos
    -F Forzara mke2fs a crear un sistema de archivos, incluso si las otras opciones pasadas a el o al objetivo son peligrosas o no tienen ningun sentido, se puede pasar el parametro varias veces, incluso si este esta montado
    -L Establece la etiqueta de volumen, esta etiqueda debera tener un maximo de 16 carcateres
    -n Esta opcion SIMULA la creacion de archivos
    -q Modo silencioso. me2fs se ejecutara normalmente, pero no producira ninguna salida en la terminal
    -U ID Establecera un UUID de una particion en el valor especificado como ID, el formato sera 8-4-4-4-12 donde los numeros son los digitos, de igual manera,  en lugar de un UUID se puede especificar clear para borrar el UUID, random para generar un UUID o time para crear un UUID basado en el tiempo
    -V modo detallado, imprime mucha informacion

    
Nota:
- Cuando se ejecuta el comando sin especificar un tipo, el tipo por defecto sera mkfs.ext2



mkfs.xfs - creacion de un sistema de archivos XFS 
    -b size=VALUE Establece el tamaño de bloque en el sistema de archivos, en bytes, al especificar en VALUE. EL valor predeterminado es 4096 (4KiB), el minimo es 512 y el maximo es 65536 (64 KiB)
    -m crc=VALUE    Los parámetros que comienzan con -m son opciones de metadatos. Éste habilita (si VALUE es 1) o deshabilita (si VALUE es 0) el uso de comprobaciones CRC32c para verificar la integridad de todos los metadatos en el disco. Esto permite una mejor detección de errores y recuperación de fallas relacionadas con problemas de hardware, por lo que está habilitado de forma predeterminada. El impacto en el rendimiento de esta comprobación debería ser mínimo, por lo que normalmente no hay razón para desactivarlo
    -m uuid=VALUE   Establece el UUID de la partición al especificado como VALUE. Recuerde que los UUID son números de 32 caracteres (128 bits) en base hexadecimal, especificados en grupos de 8, 4, 4, 4 y 12 dígitos separados por guiones, como 1E83E3A3-3AE9-4AAC-BF7E-29DFFECD36C0
    -f Forza la creacion de un sistema de archivos en el dispositivo de destino inclus si se detecta un sistema de archivos en el
    -l logdev=DEVICE  Esto colocara la seccion de registro del sistema de archivos en el dispositivo especificado, en lugar de dentro de la seccion de datos
    -q Modo silencioso, no imprimira nada de informacion
    -L LABEL  Establece la etiqueta del sistema de arhcivos, que puede tener un maximo de 12 carcateres
    -N Similar al parametro -n de mke2fs, hara qe mkfs.xfs imprima todos los parametros para la creacion del sistema de archivos, sin crearlo realmente

Nota:
- La herramientas para administrar sistemas de archivos XFS son parte del paquete xfsprogs,
- Los sistemas de archivos XFS se dividen en almenos 2 partes, una seccion de registro donde se mantiene un registro de toda las operaciones del sistema de archivos (comunmente llamado Journal) y la seccion de datos. La sección de registro puede estar ubicada dentro de la sección de datos (el comportamiento predeterminado), o incluso en un disco separado por completo, para un mejor rendimiento y confiabilidad



mkfs.fat - Es el comando basico para la creacion de un sistema de archivos FAT
    -c Comprueba el dispositivo de destino en busca de bloques defectuosos antes de crear el sistema de archivos 
    -C FILENAME BLOCK_COUNT   Creará el archivo especificado en FILENAME y luego creará un sistema de archivos FAT dentro de él, creando efectivamente una “imagen de disco” vacía, que luego puede escribirse en un dispositivo usando una utilidad como dd o montarse como un loopback dispositivo.   
    -F SIZE  Selecciona el tamaño de la FAT, entre 12, 16 o 32, es decir, entre FAT12, FAT16 o FAT32
    -n NAME  Establece la etiqueta de volumen o el nombre para el sistema de archivos 
    -v Modo detallado, imprime mucha informacion 
 
Nota:
- VFAT es una extension del formato FAT16 que admite nombres de archivo largos (hasta 255 carcateres). Ambos sistemas de archivos sistemas de arhcivos son manejados por la misma utilidad, mkfs.fat. mkfs.vfat es un alias
- El sistema de archivos FAT tiene importantes inconvenientes que restringen su uso en discos grandes. FAT16, por ejemplo, admite volúmenes de 4 GB como máximo y un tamaño de archivo máximo de 2 GB




mkfs.exfat - utilidad para la creacion de archivos exFAT
    Sintaxis: mkfs.extfat TARGET
    -i VOL_ID  Establece el ID de volumen en el valor especificado en VOL_ID, Este es un numero hexadecimal de 32 bits. Si no esta definido, se establece una ID basada en la hora actual
    -n NAME  Establece la etiqueta de volumen o el nombre. Puede tener hasta 15 carcateres y el valor predeterminado es sin nombre
    -p SECTOR  Especifica el primer sector de la primera particion del disco. Este es un valor opcional y el predeterminado es cero
    -s SECTORS Define el numero de sectores fisicos por grupo de asignacion. Debe ser una potencia de dos, como 1,2,4,8,etc

Nota:
- Es un sistema de archivos creado por Microsoft que aborda una de las limitaciones mas importantes de FAT32: el tamaño del archivo y el disco
- La utilidad predeterminada para crear sistemas de archivos exFAT es mkfs.exfat, que es un enlace a mkexfatfs


mkfs.btrfs - Sistema de archivos Butter FS o Butterfuss
    -L para establecer una etiqueta (o nombre) para su sistema de archvos
    -m Para establecer como se distribuiran los metadatos en la matriz del disco, use el parametro -m, los parametros validos, son raid0, raid1, raid5, raid6, raid10, single y dup
    - manejo de subvolumenes
    -manejo de instantaneas

Nota:
- Con este sistema, se puede encontrar el soporte para multiples dispositivos (incluyendo la creacion de bandas, la duplicacion y la creacion de bandas+duplicacion, como en una configuracion RAID), compresion transparente, optimizaciones de SSD, copias de seguridad incrementales, instantaneas, desfragmentacion en linea, comprobaciones fuera de linea, compatibilidad con subvolumenes (con cuotas), deduplicacion y mucho mas
- Es muy resistente a los bloqueos 
- Si no tienes la utilidad, se instala con el paquete btrfs.progsi
- puede manejar subvolumenes



parted - es un editor de particiones muy poderoso, que se puede usar para crear, eliminar, mover, redimensionar, rescatar y copiar particiones













