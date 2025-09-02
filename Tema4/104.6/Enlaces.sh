#!/bin/bash

advert="[!] Se recomienda ingresar la ruta absoluta del archivo para evitar problemas con el enlace"


Menu(){
	echo "============================================"
	echo "		    MENU DE ENLACES		  "
	echo "============================================"
	echo "1) Crear enlace simbolico"
	echo "2) Crear enlace duro"
	echo "3) Ver numeros de enlaces de un archivo"
	echo "4) Comprobar inodos de dos archivos"
	echo "5) Salir"
	echo "============================================"
}


enlaceSimbolico(){
	echo $advert
	read -p "Ingrese la direccion del archivo: " ifile
	read -p "Ingresa la direccion donde se alojara el enlace simbolico: " ofile
	ln -s "$ifile" "$ofile"
	if [[ $? -eq 0 ]]; then
		ls -l $ifile $ofile
	else
		echo "[!] Ocurrio un error"
		exit 1 
	fi
}

enlaceDuro(){
	echo $advert
	read -p "Ingrese la direccion del archivo: " ifile
	read -p "Ingresa la direccion donde se alojara el enlace simbolico: " ofile
	ln $ifile $ofile
	if [[ $? -eq 0 ]]; then
		ls -l $ifile $ofile
	else
		echo "[!] Ocurrio un error"
		exit 1 
	fi
}

verNumEnlaces(){
	read -p "Ingrese la ruta del archivo origen: " file
	ls -l "file"
	if [[ $? -ne 0 ]]; then
		echo "Algo salio mal"
		exit 1
	fi

}

compInodos(){
	read -p "Ingrese la direccion del archivo origen: " ifile
	read -p "Ingresa la direccion del enlace: " ofile

	inodo1="$(ls -li $ifile | cut -d " " -f 1 )"
	inodo2="$(ls -li $ofile | cut -d " " -f 1 )"

	if [[ "$inodo1" -eq "$inodo2" ]];then
		echo "Los inodos son iguales"
		ls -li $ifile $ofile
	else
		echo "Los inodos no son inguales"
		ls -li $ifile $ofile
	fi
}



while true; do
	Menu
	read -p "Seleccione una opcion: " option

	case $option in
		1) enlaceSimbolico  ;;
		2) enlaceDuro ;;
		3) verNumEnlaces ;;
		4) compInodos ;;
		5) exit 0;;
		*) exit 1 ;;
	esac
done

