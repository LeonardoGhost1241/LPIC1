#!/bin/bash
#Create File System (CFS)

# 104.1 Crear particiones y sistemas de archivos 

#ext2,3,4 -b -c -d -F -L -n -q -U -V
#xfs -b -m crc=VALUE -m uuid=VALUE -f -l logdev=DEVICE -l size=VALUE -q -L -N
#FAT VFAT -c -C FILENAME BLOCK_COUNT -F SIZE -n NAME -v 
#exFAT -i VOL_ID -n NAME -p SECTOR -s SECTOR
#
#


if [ $UID -ne 0 ]; then
	echo "[!] necesitas permisos"
	exit 1
fi 


if [ $# -eq 0 ]; then
	echo "No se ingreso particion a formatear"
	exit 0
elif [ -e $1 ]; then
	devicePartition=$1
else
	echo "No existe particion"
	exit 1
fi


device(){
	opc+=($devicePartition)
}

addMore(){

	read -p  "quiere agregar mas opciones: " add

	if [ "$add" == "S" -o "$add" == "s" ]; then
		echo "[!] verificar que las opciones sean correctas"
		read -p  "Ingrese las opciones:  " opciones
		opc+=("$opciones")
	fi

}

format(){
	${opc[@]}
}


showDetails(){
	echo -e  "--- Resumen: --- \n"
	echo ${opc[@]}
}

comprobatorUUID(){
	for (( i=1; i<=5; i++ )); do
		part=$(echo $1 | cut -d "-" -f $i)
		if [ $i -eq 1 ]; then
			if (( ${#part} != 8 )); then
				echo "El primer bloque de carcateres no tiene 8 caracteres"
				exit 1 #exit y break no dejan el mismo valor en $? en Bash. El comando exit finaliza la ejecución del script y establece el código de salida del proceso, mientras que break solo sale del bucle actual dentro del script, sin afectar el código de salida general del script
				break 
			fi
		elif [ $i -eq 2 ]; then
			if (( ${#part} != 4 )); then
				echo "El segundo bloque de carcateres no tiene 4 carcateres "
				exit 1
			fi
		elif [ $i -eq 3 ]; then
			if (( ${#part} != 4 )); then
				echo "El tercero bloque de carcateres no tiene 4 carcateres "
				exit 1
			fi
		elif [ $i -eq 4 ]; then
			if (( ${#part} != 4 )); then
				echo "El cuarto bloque de carcateres no tiene 4 carcateres "
				exit 1
			fi
		elif [ $i -eq 5 ]; then
			if (( ${#part} != 12 )); then
				echo "El quinto bloque de carcateres no tiene 12 carcateres "
				exit 1
			fi
		fi
	done
}



instalDep(){
	echo "Instalador de dependencias "

}

preFormat(){
	addMore
	device
	showDetails

	read -p "Confirmar s/n: " confirm
	if [[ "$confirm" == "s"  || "$confirm" == "S" ]]; then
		format
	elif [[ "$confirm" == "n"  || "$confirm" == "N" ]]; then
		exit
	else
		echo "No se encontro opcion"
	fi
}


ext(){
	echo "--- Sistema de archivos extendido ---"

	read -p "version 2/3/4: (default:ext2) " version
	case $version in
		2) version="ext2" ; opc+=("mkfs.ext2");;
		3) version="ext3" ; opc+=("mkfs.ext3");;
		4) version="ext4" ; opc+=("mkfs.ext4");;
		*) version="ext2" ; opc+=("mkfs.ext2");;
	esac

	read -p "Tamanio de bloques (multiplo de 1024)(default:4096): " sizeBlock 
	if [ -z $sizeBlock ]; then
		opc+=("-b 4096")
	else
		if (( $sizeBlock % 1024 != 0 )); then
			echo "Tamaño no aceptado. Multiplo de 1024"
			exit 1
		else
			opc+=("-b $sizeBlock")
		fi
	fi


	read -p "Etiqueta de volumen (max 16 carcateres): " label
	if (( ${#label} > 16 )); then 
		echo "Valor de etiqueta incorrecto"
		exit 1
	elif [ -z $label ]; then
		opc+=("-L test")
	else
		opc+=("-L $label")
	fi


#	read -p "Universal Uique Identifier (UUID) formato:8-4-4-4-12 (default:time): " uuid
#	opc+=("-U $uuid")


	read -p "modo detallado s/n: (default s)  " verbose
	if [[ "$verbose" == "s" || "$verbose" == "S" || -z $verbose  ]]; then
		opc+=("-v")
	fi


	read -p "Bucar bloques defectuosos (s/n): " searchBadBlocks
	if [[ "$searchBadBlocks" == "S" || "$searchBadBlocks" == "s" ]]; then
		opc+=("-c")
	fi


	read -p "Simular creacion de archivos (s/n)(default:s): " simulate
	if [[ "$simulate" == "s" || "$simulate" == "S" || -z $searchBadBlocks ]]; then
		opc+=("-n")
	fi

	preFormat
}



xfs(){
	echo "--- Sistema de archivos XFS ---"

	opc+=("mkfs.xfs")


	read -p "Tamanio de bloques (multiplo de 1024)(default:4096)(min:512 - max: 65536): " sizeBlock 
	if [ -z $sizeBlock ]; then
		opc+=("-b 4096")
	else
		if (( $sizeBlock % 1024 != 0 || $sizeBlock > 65536 || $sizeBlock < 512 )); then
			echo "Tamaño no aceptado. Multiplo de 1024"
			exit 1
		else
			opc+=("-b size=$sizeBlock")
		fi
	fi


	read -p "Etiqueta de volumen (max 16 carcateres): " label
        if (( ${#label} > 16 )); then 
                echo "Valor de etiqueta incorrecto"
                exit 1
        elif [ -z $label ]; then
                opc+=("-L test")
        else
            	opc+=("-L $label")
        fi


	read -p "modo silencioso s/n: (default s)  " verbose
        if [[ "$verbose" == "s" || "$verbose" == "S" || -z $verbose  ]]; then
                opc+=("-q")
        fi


	read -p "Simular creacion de archivos (s/n)(default:s): " simulate
        if [[ "$simulate" == "s" || "$simulate" == "S" || -z $searchBadBlocks ]]; then
                opc+=("-N")
        fi

	preFormat


}


fat(){
	echo "--- Sistema de archivos FAT/VFAT ---"

	opc+=("mkfs.fat")

	read -p "selecciona el tamaño del fat (12, 16 o 32)" sizeFat
	case $sizeFat in
		12) opc+=("-F 12");;
		16) opc+=("-F 16");;
		32) opc+=("-F 32");;
		*) echo "Opcion no encontrada " ; exit 1 ;;
	esac


	read -p "Etiqueta de volumen (max 11 carcateres): " label
        if (( ${#label} > 11 )); then 
                echo "Valor de etiqueta incorrecto"
                exit 1
        elif [ -z $label ]; then
                opc+=("-n test")
        else
            	opc+=("-n $label")
        fi

	read -p "modo detallado s/n: (default s)  " verbose
        if [[ "$verbose" == "s" || "$verbose" == "S" || -z $verbose  ]]; then
                opc+=("-v")
        fi

	preFormat

}

exfat(){
	echo "--- Sistema de archivos exFAT ---"

	read -p "Etiqueta de volumen (max 15 carcateres): " label
        if (( ${#label} > 15 )); then 
                echo "Valor de etiqueta incorrecto"
                exit 1
        elif [ -z $label ]; then
                opc+=("-n test")
        else
            	opc+=("-n $label")
        fi

}



btrfs(){
	echo "--- Sistema de archivos BTRFS ---"

	local choice device mountpoint label subvol snapname

	while true; do
        	echo "===== Menú Btrfs ====="
	        echo "1) Crear sistema de archivos Btrfs"
	        echo "2) Montar sistema Btrfs"
	        echo "3) Crear subvolumen"
	        echo "4) Crear snapshot"
	        echo "5) Listar subvolúmenes"
	        echo "6) Salir"
        	read -p "Seleccione una opción: " choise

		case $choice in
			1)
                		read -p "Dispositivo (ej: /dev/sdb1): " device
		                read -p "Etiqueta (ej: Datos): " label
		                mkfs.btrfs -f -L "$label" "$device" && echo "[+] FS Btrfs creado."
                		;;
		        2)
                		read -p "Dispositivo (ej: /dev/sdb1): " device
		                read -p "Punto de montaje (ej: /mnt/disk): " mountpoint
		                mkdir -p "$mountpoint"
		                mount -t btrfs "$device" "$mountpoint" && echo "[+] Montado en $mountpoint."
                		;;
		        3)
                		read -p "Ruta donde está montado el FS (ej: /mnt/disk): " mountpoint
		                read -p "Nombre del subvolumen: " subvol
		                btrfs subvolume create "$mountpoint/$subvol" && echo "[+] Subvolumen $subvol creado."
                		;;
			4)
		                read -p "Ruta origen (ej: /mnt/disk): " mountpoint
                		read -p "Nombre del snapshot: " snapname
		                btrfs subvolume snapshot "$mountpoint" "$mountpoint/$snapname" && echo "[+] Snapshot $snapname creado."
                		;;
            		5)
		                read -p "Ruta montada (ej: /mnt/disk): " mountpoint
                		btrfs subvolume list "$mountpoint"
		                ;;
            		6)
                		break
                		;;
            		*)
                		echo "Opción inválida."
                		;;
        	esac
  		echo 
	done
}

swap(){
	local choice device size label

    while true; do
        echo "===== Menú Swap ====="
        echo "1) Crear partición swap"
        echo "2) Crear archivo swap"
        echo "3) Activar swap"
        echo "4) Desactivar swap"
        echo "5) Ver swap activo"
        echo "6) Salir"
        read -p "Seleccione una opción: " choice

        case $choice in
            1)
                read -p "Dispositivo (ej: /dev/sdb2): " device
                read -p "Etiqueta: " label
                mkswap -L "$label" "$device" && echo "[+] Swap configurado en $device."
                ;;
            2)
                read -p "Ruta del archivo (ej: /swapfile): " device
                read -p "Tamaño (ej: 2G): " size
                fallocate -l "$size" "$device" || dd if=/dev/zero of="$device" bs=1M count=$(( ${size%G}*1024 ))
                chmod 600 "$device"
                mkswap "$device" && echo "[+] Archivo swap creado en $device."
                ;;
            3)
                read -p "Dispositivo o archivo swap: " device
                swapon "$device" && echo "[+] Swap activado en $device."
                ;;
            4)
                read -p "Dispositivo o archivo swap: " device
                swapoff "$device" && echo "[+] Swap desactivado en $device."
                ;;
            5)
                swapon --show
                free -h
                ;;
            6)
                break
                ;;
            *)
                echo "Opción inválida."
                ;;
        esac
        echo
    done
}


options="EXT:XFS:FAT/VFAT:exFAT:Btrfs:Swap:salir"
PS3="cfs> "

oldIFS=$IFS
IFS=":"

select fileSystem in $options;
do
	declare -a opc=()

	case "$fileSystem" in
		EXT|1)
			ext
			;;
		XFS|2)
			xfs
			;;
		FAT/VFAT|3)
			fat
			;;
		exFAT|4)
			xfs
			;;
		Btrfs|5)
			echo "btrfs"
			;;
		salir|6)
			"Bye "
			exit 0
			;;
		Swap)
			swap
			;;
		*)
			echo "Opcion no encontrada"
			exit 1
			;;
	esac

done

