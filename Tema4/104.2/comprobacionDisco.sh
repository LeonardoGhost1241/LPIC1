#!/bin/bash

# 104.2 Mantener la integridad de los sistemas de archivos 

 

echo "######################################################"
echo "###	Comprobacion de espacio en disco	###"
echo "######################################################"


opcDu(){
	clear

	echo "Seleccione una opcion"
	opc=("ver peso de un directorio/archivo" "Ver peso de los archivos de un directorio (no de los subdirectorio -S)" "peso total del contenido de la carpeta" "Ver con nivel de profundidad" "regresar")
	select duoptione in ${opc[@]}; 
	do
		case $duoptione in
			"ver peso de un directorio/archivo")
				read -p  "Ingrese el directorio u archivo:  " path
				if [[ -d "$path" || -f "$path" ]]; then
					du -h $path
				else
					echo "[!] archivo no encontrado"
				fi
				;;
			"Ver peso de los archivos de un directorio (no de los subdirectorio -S)")
				read -p "ingrese ruta del directorio: " dir
				exc=()
				exc2=()
				exclude="--exclude="

				if [[ ! -d "$dir" ]]; then
					echo "No es un directorio"
				fi

				read -p "Desea excluir algun archivo y/n" excopc
				if [[ "$excopc" == "y" ]]; then
					echo "Ingresa los datos a exluir"
					
					while true; do
						read -p "patron: " pattern
						exc+=("$pattern")

						read -p "Agregar otro patron? y/n" opc
						if [[ "$opc" == "n" ]]; then
							for var in "${exc[@]}"; do
								exc2+=("${exclude}${var}")
							done
							du -aSh "$dir" "${exc2[@]}"
							break;	
						fi
					done
				elif [[ "$excopc" == "n" ]]; then
					du -aSh $dir
				fi		


				;;
			"peso total del contenido de la carpeta")
				read -e -p "Ingrese la carpeta: " dir

				if [[ ! -d "$dir" ]]; then
					echo "No es un directorio"
					break
				fi
				
				du -hc "$dir" | tail -n 1 
				;;
			"Ver con nivel de profundidad")
				read -p "Ingrese el direcotio: " dir
				if [[ ! -d "$dir" ]]; then
					echo "NO es un directorio"
					break
				fi

				read -p "Ingrese el nivel de profundidad al que ira el comando du: " number
				if [[ $number -ge 0 || $number -le 10 ]]; then
					du -a -c -h -d $number $dir
				else
					echo "opcion no encontrada"
				fi
				;;
			"regresar")
				return 
				;;
		esac 
	done
}


opcDf(){
	clear
	echo "Disk free"

	opc=("Mostrar todo (en Megas)" "Mostrar inodos" "Mostrar por sistema de archivos" "personalizada" "regresar")
	fs=()

	select dfoptions in ${opc[@]};
	do
		case $dfoptions in
			"Mostrar todo (en Megas)")
				df -h
				;;
			 "Mostrar inodos")
				df -ih
				;;
			"Mostrar por sistema de archivos")
				ioDf
				;;
			 "personalizada")
				customDf
				;;
			"regresar")
				return
				;;
			*)
				echo "OOOOOopcion no encontrada"
				;;

		esac
	done



}


ioDf(){
	param="" ##EL PROBLEMA DE QUE NO ME ESTABA IMPRIMIRNDO ES QUE ESTABA AGREGANDO UN ESPACIO AQUI
	read -p "Desea incluir o excluir? i/e " exc

	if [[ "$exc" == "i" ]]; then
        	param="-t" #ADEMAS DE AGREGAR UN ESPACIO AQUI PARA QUE QUEDARA COMO -X EXT4 O -T EXT4, PERO ME LE EJECUTO ASI -XEXT4 O -TEXT4
        elif [[ "$exc" == "e" ]]; then
        	param="-x"
               # df -h "${arr[@]}"
        else
                echo "opcion no encontrada"
        fi

	arrtmp=()
	arr=()

	while true; do
		read -p "Ingrese tipo de sistema de archivo: " arch
		arrtmp+=("$arch")

		read -p "Agregar otro mas? y/n " more
		if [[ "$more" == "n" ]]; then
			for include in "${arrtmp[@]}"; do
				arr+=("${param}""$include")
			done
#				echo -n "df -hT  ${arr[@]}"
				df -hT ${arr[@]}
			break
		fi
	done

}

customDf(){
	echo "Selecciona las opciones que quieres en el comando"

	showOptionsDf

	arr=()

	while true; do
		echo "[!] Volver a mostrar el menu (0) "
		read -p "Opcion: " opc

		case $opc in
			1)
				arr+=("source")
				arr+=(",")
				;;
			2)
				arr+=("fstype")
				arr+=(",")
				;;
			3)
				arr+=("size")
				arr+=(",")
				;;
			4)
				arr+=("used")
				arr+=(",")
				;;
			5)
				arr+=("avail")
				arr+=(",")
				;;
			6)
				arr+=("pcent")
				arr+=(",")
				;;
			7)
				arr+=("target")
				arr+=(",")
				;;
			8)
				arr+=("itotal")
				arr+=(",")
				;;
			9)
				arr+=("iused")
				arr+=(",")
				;;
			10)
				arr+=("iavail")
				arr+=(",")
				;;
			11)
				arr+=("ipcent")
				arr+=(",")
				;;
			0)
				showOptionsDf
				;;

			*)
				break
				;;
		esac

		read -p "agregar mas opciones? y/n " more

		if [[ "$more" == "n" ]]; then
			unset arr[-1]
			arr2=($(printf "%s" "${arr[@]}")) #NO QUIERE PASAR LA SALIDA AL ARRA2, PERO EL COMANDO PRINT.. ESTA BIEN
#			echo  "${arr2[*]}"
			df -h --output="${arr2[*]}" #LA SOLUCION FUE CAMBIAR EL @ POR UN *, ESTO ES EXPANSION DE ARREGLOS, USADO PARA EXPANDIR EL ARREGLO COMO UNA SOLA CADENA, Y NO COMO UN SOLO ELEMENTO CON EL @
			break
		fi

	done
}

showOptionsDf(){
	opc=("1)        source:El dispositivo correspondiente al sistema de archivos" 
             "2)        fstype: El tipo de sistema de archivos"
             "3)        size: El tamaño total del sistema de archivos" 
             "4)        used: Cuánto espacio se está utilizando" 
             "5)        avail: Cuánto espacio hay disponible" 
             "6)        pcent: El porcentaje de uso" 
             "7)        target: Dónde está montado el sistema de archivos (punto de montaje)"
             "8)        itotal: El número total de inodos en el sistema de archivos."
             "9)        iused: El número de inodos usados en el sistema de archivos."
             "10)       iavail: El número de inodos disponibles en el sistema de archivos."
             "11)       ipcent: El porcentaje de inodos usados en el sistema de archivos.")

	for options in "${opc[@]}"; do
        	echo "$options"
        done
}


fsckPartition(){

	isExt=$(sudo lsblk -f "$1" | grep "ext")

        if [[ ! -e "$1" ]]; then
                echo "No existe el directorio $fsys"
                exit 0
        fi


        if [[  $? -ne  0 ]]; then
                echo "NO es tipo ext2/3/4"
                exit 1 
        fi

}

fscheck(){
	clear
	echo "Comprobacion de sistemas de archivos (solo para sistemas ext2/3/4)"

	read -p "Ingrese la particion a verificar (Debe de ser ext2/3/4): " fsys
	fsckPartition "$fsys"

	fscheckOptions

	while true; do
		echo "Volver a mostrar menu (0)"

		read -p "Opcion: " ofck

		case $ofck in
			1) sudo fsck "$fsys" ;;
			2) sudo fsck -A ;;
			3) sudo e2fsck -p "$fsys" ;;
			4) sudo fsck -N "$fsys" ;;
			5) return ;;
			0) fscheckOptions ;;
			*) return ;;
		esac
	done
}

fscheckOptions(){

	opc=("1)	Verificar sistema de archivos (modo detallado -V)" 
	     "2)	Comprobar todos los sistemas de archvios listados en el /etc/fstab"         
             "3)	Correccion automatico de errores" 
	     "4)	Simular verificacion del sistema de archivos"
	     "5)	regresar") 

	for options in "${opc[@]}"; do
        	echo "$options"
        done 
}




tune2fs(){
	clear

	read -p "Ingrese la particion a verificar (Debe de ser ext2/3/4): " fsys

	fsckPartition $fsys

	echo "En caso de error, tune2fs tiene -f para forzar al sistema, en caso de ser asi, modificar este script"

	options=("listar conenido del sistema de archivos" "Establecer numero de montajes sin comprobar el sistema" "Intervalo de comprobacion del sistema de archivos" 
		 "Comportamiento del kernel ante un error en el sistema de archivos" "Agregar journal a ext2 (conversion de ext2 a ext3)" "regresar")

	while true; do
		select var in "${options[@]}"; do
			case $var in 
				"listar conenido del sistema de archivos")
					sudo tune2fs -l "$fsys"
					;;
				"Establecer numero de montajes sin comprobar el sistema")
					read -p "Ingresa N, donde N es el numero permitidos, antes de comprobar el sistema: " check
					sudo tune2fs -c "$check" "$fsys"
					;;
				"Intervalo de comprobacion del sistema de archivos")
					echo "seleccione entre dias(d), meses(m) o años(y)"
					read -p "selecciona el tiempo: " time

					case $time in
						d)
							read -p "Seleccione el numero de dias entre cada comprobacion: " days
							sudo tune2fs -i "$days"d "$fsys"
							;;
						m)
							read -p "Seleccione el numero de meses entre cada comprobacion: " months
							sudo tune2fs -i "$months"m "$fsys"
							;;
						y)
							read -p "Seleccione el numero de anios entre cada comprobacion: " year
							sudo tune2fs -i "$year"y "$fsys"
							;;
						*)
							echo "Opcion no encontrada"
							exit 1
							;;
					esac
					;;
				"Comportamiento del kernel ante un error en el sistema de archivos")
					echo "Seleccione el comportamiento del kernel cuando haya algun error en el sistema de archivos"

					echo -e "1)	Continue\n2)	remount-ro\n3)	panic\n4)	Info"
					read -p "Comportamiento: " behaviour 

					case $behaviour in 
						1)
							sudo tune2fs -e continue  "$fsys"
							;;
						2)
							sudo tune2fs -e remount-ro "$fsys"
							;;
						3)
							sudo tune2fs -e panic "$fsys"
							;;
						4)
							echo -e "1)     Continue:Continua la ejecucion normalmente\n2)    remount-ro:Volvera a montar el sistema de archivos como de solo lectura\n3)  panic:Causara un kernel panic"
							;;
						*)
							exit 1
							;;
					esac
					;;
				"Agregar journal a ext2 (conversion de ext2 a ext3)")
					#read -p "Ingrese la particion ext2 a agregar journaling" partition
					isExt=$(sudo lsblk -f "$fsys" | grep "ext2")

					if [[ $? -eq 0 ]]; then
						sudo tune2fs -j "$fsys"
					else
						echo "la particion no es ext2"
						exit 1
					fi

					;;
				"salir")
					return
					;;
				*)
					exit 1
					;;
			esac
		done
	done
}

#opt="du:df:Comprobar Sistema de archivos:Info de sistemas ext:salir"
opt=("du" "df" "Comprobar Sistema de archivos" "Ajustes de un sistema ext" "salir")

#oldIFS=$IFS
IFS=","

export PS3="ComDisco> "
echo "seleccione el numero: "

select opcion in ${opt[@]};
do
	case $opcion in 
		"du")
			opcDu
			;;
		"df")
			opcDf
			;;
		"Comprobar Sistema de archivos")
			echo "[!] ASEGURESE DE QUE LA PARTICION A COMPROBAR ESTE DESMONTADA, RIESGO DE PERDIDA DE DATOS"
			fscheck
			exit 1
			;;
		"Ajustes de un sistema ext")
			tune2fs
			exit 0
			;;
		"salir")
			echo "[!] saliendo..."
			exit 0
			;;
		*)
			exit 0;;
	esac 
##	clear
done 

