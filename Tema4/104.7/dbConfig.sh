#!/bin/bash

# Ruta al archivo de configuración
CONFIG_FILE="/etc/updatedb.conf"

# Leer el archivo de configuración línea por línea
while IFS= read -r line; do
    # Ignorar líneas en blanco y comentarios
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Usar eval para ejecutar la línea como un comando
    eval "$line"
done < "$CONFIG_FILE"

#p1="holaaaaaaaaaaaaaaaaa"
PRUNEFS=""
PRUNENAMES=""
PRUNEPATHS=""
PRUNE_BIND_MOUNTS=""


# Ahora puedes usar las variables configuradas
#echo "PRUNEFS: $p1"
echo "PRUNEFS: $PRUNEFS"
echo "PRUNENAMES: $PRUNENAMES"
echo "PRUNEPATHS: $PRUNEPATHS"
echo "PRUNE_BIND_MOUNTS: $PRUNE_BIND_MOUNTS"

