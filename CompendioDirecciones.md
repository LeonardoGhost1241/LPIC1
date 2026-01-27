Compendio de direcciones utiles 


1. Rutas relacionadas con modulos del kernel 
    * /etc/modprobe.conf: Archivo tradicional de configuración de módulos del kernel (obsoleto en muchas distros modernas).
    * /etc/modprobe.d/: Directorio que contiene archivos .conf para configurar módulos del kernel.
    * /etc/modprobe.d/blacklist.conf: Archivo donde se listan módulos que NO deben cargarse.
    * /etc/modprobe.d/<module_name>.conf: Archivo recomendado para configurar un módulo específico (bloquearlo, opciones, alias, etc.) 


2. Directorios virtuales
    * /proc:  Sistema de archivos virtual. Expone informacion interna del kernel
    * /proc/cpuinfo: Informacion detallada de la cpu
    * /proc/interupts: Tabla  de interrupciones utilizadas por cada dispositivo
    * /proc/ioports: Puertos de E/S asignados
    * /proc/dma: Canales DMA en uso 

3. Dispositivos
    * /dev/: Contiene archivos especiales que representan dispositivos del sistema
    * /dev/sda: el primer disco
    * /dev/disk/by-uuid: Enlaces simbolicos a particiones identificadas por UUID

4. Gestion dinamica de dispositivos
    */etc/udev/rules.d: Reglas de udev personalizadas (para asignar nombres, permisos, ejecutar acciones, etc)

5. boot y Grub
    * /etc/default/grub: Archivo principal para configurar GRUB 2
    * /boot/grub/grub.cfg: Archivo autogenerado de GRUB. No debe editarse manualmente
    * /etc/grub.d: Scripts que usa GRUB para generar el grub.cfg
    * /etc/grub.d/40_custom: Archivo donde se añaden entradas personalizadas para grub o Menu entries 
    * /boot: Particion donde se guardan el kernel y archivos de arranque
    * /boot/efi: Particion EFI en sistemas UEFI
    * /boot/grub: Directorio con archivos internos de GRUB (modulos, temas, fuentes)
    * /boot/grub/i386-pc/: Modulos de GRUB para sistemas BIOS
    * /boot/grub/x86_64-efi:                      
    * /boot/grub/locale: archivos de traduccion 
    * /boot/grub/fonts: Fuentes utilizadas en el menu GRUB
    * /boot/initrd.img- : Imagen RAM inicial para arrancar el sistema
    * /boot/grub/menu.lst: Archivo de GRUB Legacy (Ya casi no se usa)


6. Niveles de ejecucion y SysV init 
    * /etc/inittab: Archivo usado por SySVinit para definir runlevels 
    * /etc/init.d/: Scripts de servicion de SysVinit
    * /etc/rc0.d, /etc/rc1.d,etc: Directorios con enlaces a scripts que se ejecutan al entrar a un runlevel
        - K = (kill) Detener servicio
        - S = (start) Iniciar servicio
    * /etc/rc1.d/K90network: Script que detiene la red al entrar al nivel 1 
    * /etc/init : Directorio de Upstart (Sistema init antiguooo)
    * /sbin/init : En systemd es un link a ../lib/systemd/systemd
    * /lib/systemd/systemd: Ejecutable principal de systemd 

7. Systemd 
    * /etc/systemd/system/default.target: Indica el target (equivalente a runlevel) por defecto
    * /lib/systemd/system: Donde se encuentran los archivos de configuracion con cada unidad 
    * /var/log/jounrnal: Ubicacion por defecto del journal de systemd

8. Filesystem & montaje
    * /etc/fstab: Tabla de sistemas de archivos a montar al iniciar
    * /mnt: Punto de montaje tradicional para discos
    * /mnt/tmp: Otro punto de montaje temporal
    * /media: Punto de montaje para unidades automaticas (USB,etc)
    *

9. Logs
    * /var/log/: Ubicacion estandar de logs tradiconales
    * /var/log/journal/: Logs de systemd

10. Bibliotecas
    * /etc/ld.so.conf : Ruta de bibliotecas 
    * /etc/ld.so.conf.d : Ruta de bibliotecas donde es mas comun encontrarlas en este directorio. (Archivos .conf adicionales para bibliotecas)
    * /etc/ld.so.cache: Cache de bibliotecas generad por ldconfig
    * /usr/lib/ : Bibliotecas estandar
    * /usr/lib64: Bibliotecaspara sistemas de 64 bits 
    * /lib/x86_64-linux-gnu/: Bibliotecas estándar del sistema.
    * /usr/lib/x86_64-linux-gnu/ : Más bibliotecas empaquetadas por la distro.


11. Paquetes y repositorios 
    * /etc/yum.repos.d/: Archivos .repo para repositorios YUM (El usuario puede agregar repositorios adicionales agregando un archivo .repo en el directorio mencionado anteriormente, o al final de /etc/yum.conf. Sin embargo, la forma recomendada de agregar o administrar repositorios es con la herramienta yum-config-manager)
    * /etc/yum.conf : Configuracion global de YUM
    * /var/cache/yum: Cache de paquetes descargados por YUM
    * /etc/apt: Configuracion de apt
    * /etc/apt/sources.list: Repositorios principales en debian y ubuntu
    * /etc/apt/sources.list.d: Repositorios adicionales
    * /var/cache/apt/archives:  Donde apt guarda paquetes descargados
    * /var/cache/apt/archives/partial/: Descargas incompletas


12. Virtualizacion (KVM/libvirt/QEMU)
    * /etc/libvirt/qemu: Config de máquinas virtuales.
    * /var/lib/libvirt/images/: Ubicación de imágenes de disco (.qcow2, etc).
    * /var/lib/dbus/machine-id: ID única de máquina (enlaza a /etc/machine-id).
    * /etc/machine-id: Identificador único del sistema






30. Montaje de sistemas
    * /etc/fstab: Contiene descripciones sobre los sistemas de archivos que se pueden montar, donde cada linea describe un sistema de archivos que se va a montar, con 6 campos por linea, el formato es:
        FILESYSTEM  MOUNTPOINT  TYPE    OPTIONS DUMP    PASS
    
        (filesystem, mountpoint, type) : El dispositivo de archivos, en donde se montara y el tipo de sistema de archivos
        (OPTIONS) : Opciones de montaje que se pasaran a mount
        (DUMP) : Indica si cualquier sistema de archivos ext2, ext3 o ext4 debe considerarse para la copia de seguridad mediante el comando dump, por lo general es 0, lo que significa que debe de ignorarse
        (PASS) : Cuando es distinto de cero, define el orden en el que se comprobaran los sistemas de arhivos dirante el arranque. Normalmente es 0 cuando no es particion de arranque o alguna importante

        Algunas de las opciones(OPTIONS) son:
            atime y noatime         Por defecto, cada vez que se lee un archivo, se actualiza la información de tiempo de acceso. Deshabilitar esto (con noatime) puede acelerar la E/S del disco. No confunda esto con la hora de modificación, que se actualiza cada vez que se escribe un archivo.
            auto y noauto           Si el sistema de archivos puede (o no) montarse automáticamente con mount -a.
            defaults                Esto pasará las opciones rw, suid, dev, exec, auto, nouser y async a mount.
            dev y nodev             Si deben interpretarse los dispositivos de caracteres o bloques en el sistema de archivos montado.
            exec y noexec           Permitir o denegar el permiso para ejecutar binarios en el sistema de archivos.
            user y nouser   Permite (o no) a un usuario normal montar el sistema de archivos.
            group           Permite a un usuario montar el sistema de archivos si el usuario pertenece al mismo grupo que posee el dispositivo que lo contiene.
            owner           Permite a un usuario montar un sistema de archivos si el usuario posee el dispositivo que lo contiene.
            suid y nosuid   Permite, o no, que los bits SETUID y SETGID surtan efecto.
            ro y rw         Montan un sistema de archivos como de solo lectura o de escritura.
            remount         Esto intentará volver a montar un sistema de archivos ya montado. Esto no se usa en /etc/fstab, sino como un parámetro para mount -o. Por ejemplo, para volver a montar la partición /dev/sdb1 ya montada como de solo lectura, puede usar el comando mount -o remount,ro /dev/sdb1. Al volver a montar, no es necesario especificar el tipo de sistema de archivos, solo el nombre del dispositivo o el punto de montaje.
            sync y async    Realizar todas las operaciones de E/S en el sistema de archivos de forma sincrónica o asincrónica. async suele ser el predeterminado. La página del manual de mount advierte que el uso de sync en medios con un número limitado de ciclos de escritura (como unidades flash o tarjetas de memoria) puede acortar la vida útil del dispositivo
        

        (FILESYSTEM)
        En algunas ocaciones es mejor usar el UUID ya que puede que un dispositivo tengga un mismo nombre, para definirlo, usamos:
                UUID=11111111-1111-1111-1111-123456789012
        O podemos usar el LABEL como:
                LABEL=

















