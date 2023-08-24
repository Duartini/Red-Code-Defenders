#!/bin/bash

# Limpia todas las reglas
iptables -F

# Restaura las políticas por defecto
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

echo "Todas las reglas de iptables han sido borradas y restauradas a sus valores por defecto."

exit 0
