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
    


