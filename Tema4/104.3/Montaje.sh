#!/bin/bash

# 104.3 Controlar el montaje y desmontaje de sistemas de archivos

# Función para montar un sistema de archivos
montar() {
    echo "Ingrese el tipo de sistema de archivos (ej. ext4, btrfs, exfat):"
    read tipo
    echo "Ingrese el dispositivo (ej. /dev/sdb1):"
    read dispositivo
    echo "Ingrese el punto de montaje (ej. ~/flash):"
    read punto_montaje

    # Montar el sistema de archivos
    mount -t "$tipo" "$dispositivo" "$punto_montaje"
    echo "Sistema de archivos montado en $punto_montaje."
}

# Función para montar con opciones
montar_con_opciones() {
    echo "Ingrese el tipo de sistema de archivos (ej. ext4, btrfs, exfat):"
    read tipo
    echo "Ingrese el dispositivo (ej. /dev/sdb1):"
    read dispositivo
    echo "Ingrese el punto de montaje (ej. ~/flash):"
    read punto_montaje
    echo "Ingrese las opciones de montaje (ej. rw,noatime):"
    read opciones

    # Montar el sistema de archivos con opciones
    mount -t "$tipo" -o "$opciones" "$dispositivo" "$punto_montaje"
    echo "Sistema de archivos montado en $punto_montaje con opciones: $opciones."
}

# Función para desmontar un sistema de archivos
desmontar() {
    echo "Ingrese el dispositivo o punto de montaje a desmontar (ej. /dev/sdb1 o ~/flash):"
    read objetivo

    # Desmontar el sistema de archivos
    umount "$objetivo"
    echo "Sistema de archivos desmontado de $objetivo."
}

# Función para desmontar todos los sistemas de archivos
desmontar_todo() {
    umount -a
    echo "Todos los sistemas de archivos desmontados."
}

# Función para agregar entrada a /etc/fstab
agregar_fstab() {
    echo "Ingrese el dispositivo (ej. /dev/sdb1):"
    read dispositivo
    echo "Ingrese el punto de montaje (ej. /mnt/external):"
    read punto_montaje
    echo "Ingrese el tipo de sistema de archivos (ej. ext4):"
    read tipo
    echo "Ingrese las opciones de montaje (ej. defaults):"
    read opciones

    # Agregar entrada al archivo /etc/fstab
    echo "$dispositivo $punto_montaje $tipo $opciones 0 0" | sudo tee -a /etc/fstab
    echo "Entrada agregada a /etc/fstab."
}

# Función para crear una unidad .mount en systemd
crear_unidad_mount() {
    echo "Ingrese el UUID del dispositivo (ej. 56C11DCC5D2E1334):"
    read uuid
    echo "Ingrese el punto de montaje (ej. /mnt/external):"
    read punto_montaje
    echo "Ingrese el tipo de sistema de archivos (ej. ntfs):"
    read tipo
    echo "Ingrese las opciones de montaje (ej. defaults):"
    read opciones

    # Crear archivo de unidad .mount
    unidad="/etc/systemd/system/mnt-$(basename "$punto_montaje").mount"
    echo "[Unit]" > "$unidad"
    echo "Description=Mount for $(basename "$punto_montaje")" >> "$unidad"
    echo "[Mount]" >> "$unidad"
    echo "What=/dev/disk/by-uuid/$uuid" >> "$unidad"
    echo "Where=$punto_montaje" >> "$unidad"
    echo "Type=$tipo" >> "$unidad"
    echo "Options=$opciones" >> "$unidad"
    echo "[Install]" >> "$unidad"
    echo "WantedBy=multi-user.target" >> "$unidad"

    # Recargar systemd y habilitar la unidad
    systemctl daemon-reload
    systemctl enable "$(basename "$unidad")"
    echo "Unidad .mount creada y habilitada."
}

# Menú principal
while true; do
    echo "Seleccione una opción:"
    echo "1. Montar un sistema de archivos"
    echo "2. Montar un sistema de archivos con opciones"
    echo "3. Desmontar un sistema de archivos"
    echo "4. Desmontar todos los sistemas de archivos"
    echo "5. Agregar entrada a /etc/fstab"
    echo "6. Crear una unidad .mount en systemd"
    echo "
    echo "7. Salir"
    read opcion

    case $opcion in
        1)
            montar
            ;;
        2)
            montar_con_opciones
            ;;
        3)
            desmontar
            ;;
        4)
            desmontar_todo
            ;;
        5)
            agregar_fstab
            ;;
        6)
            crear_unidad_mount
            ;;
        7)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente de nuevo."
            ;;
    esac
done
