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


## fdisk 
fdisk - manipulador de tablas de particiones para linux 






























