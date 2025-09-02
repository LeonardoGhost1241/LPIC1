#!/bin/bash
# Script interactivo para practicar permisos en Linux

title1="Permisos simbolicos (ej: u+rwx,g-w,o=rx): "
title2="Permisos octales (ej: 755, 644, 660): "


show_menu() {
    echo "==============================="
    echo "     MENÚ DE PERMISOS LINUX    "
    echo "==============================="
    echo "1) Ver información de un archivo/directorio"
    echo "2) Cambiar permisos (modo simbólico)"
    echo "3) Cambiar permisos (modo octal)"
    echo "4) Cambiar propietario/grupo"
    echo "5) Ver grupos y usuarios"
    echo "6) Probar permisos especiales (SUID, SGID, Sticky Bit)"
    echo "7) Ver/Modificar umask"
    echo "8) Salir"
    echo "==============================="
}

info_archivo() {
    read -p "Ingrese el archivo o directorio: " file
    ls -lhd "$file"
}


modo_Recursivo(){
	if [[ -d "$2" ]]; then	
		read -p "Cambiar permisos de todos los archivos? y/n: " opc
		if [[ "$opc" == "y" ]];then
			read -p "$1" permisos
			chmod -R $permisos "$2"
			ls -l "$file"
		else
			read -p "$1" permisos
			chmod  $permisos "$2"
			ls -ld "$file"
		fi
	else
		read -p "$title1" permisos
		echo "chmod $permisos "$file""
		ls -l "$file"
	fi

}

cambiar_permisos_simbolico() {
    read -p "Archivo: " file
    modo_Recursivo "$title1" "$file"
}

cambiar_permisos_octal() {
    read -p "Archivo: " file
    modo_Recursivo "$title" "$file"
}

cambiar_propietario() {
    read -p "Archivo: " file
    read -p "Nuevo usuario (Enter para omitir): " user
    read -p "Nuevo grupo (Enter para omitir): " group
    if [ -n "$user" ] && [ -n "$group" ]; then
        chown "$user:$group" "$file"
    elif [ -n "$user" ]; then
        chown "$user" "$file"
    elif [ -n "$group" ]; then
        chown ":$group" "$file"
    fi
    ls -l "$file"
}

ver_grupos_usuarios() {
    echo "1) Ver todos los grupos del sistema"
    echo "2) Ver grupos de un usuario"
    echo "3) Ver miembros de un grupo"
    read -p "Opción: " opt
    case $opt in
        1) getent group ;;
        2) read -p "Usuario: " user; groups $user ;;
        3) read -p "Grupo: " grp; sudo groupmems -g "$grp" -l ;;
    esac
}

permisos_especiales() {
    echo "1) Sticky Bit"
    echo "2) SGID"
    echo "3) SUID"
    read -p "Opción: " opt
    read -p "Archivo/Directorio: " file
    case $opt in
        1) chmod +t "$file"; echo "[+] Sticky Bit aplicado"; ls -ld "$file" ;;
        2) chmod g+s "$file"; echo "[+] SGID aplicado"; ls -ld "$file" ;;
        3) chmod u+s "$file"; echo "[+] SUID aplicado"; ls -ld "$file" ;;
    esac
}

umask_menu() {
    echo "Umask actual:"
    umask -S
    read -p "¿Desea modificarla? (y/n): " ans
    if [ "$ans" == "y" ]; then
        read -p "Nuevo valor (ej: 0022 o u=rwx,g=rx,o=): " val
        umask $val
        echo "Umask modificada. Nueva umask:"
        umask -S
    fi
}

#Bucle principal
while true; do
    show_menu
    read -p "Seleccione una opción: " option
    case $option in
        1) info_archivo ;;
        2) cambiar_permisos_simbolico ;;
        3) cambiar_permisos_octal ;;
        4) cambiar_propietario ;;
        5) ver_grupos_usuarios ;;
        6) permisos_especiales ;;
        7) umask_menu ;;
        8) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida." ;;
    esac
    echo
done
