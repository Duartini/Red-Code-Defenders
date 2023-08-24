#!/bin/bash

echo "Iniciando reglas para iptables"

# Políticas por defecto
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
echo "politicas por defecto listo"


# Evitar ataques de inundación (protección DoS)
iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT
echo "Proteccion DOS, listo"

# Bloquear ping externo
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
echo "Bloqueo de ping externo, listo"

# Regla 9: Limitar el número de conexiones SSH por IP
iptables -A INPUT -p tcp --dport 22 -m connlimit --connlimit-above 2 -j DROP
echo "limitacion deconexiones SSH, listo"


# Regla 10: Evitar escaneos de puertos (fragmentación)
iptables -A INPUT -f -j DROP
echo "Proteccion contra escaneos basicos,listo "

#Proteccion contra escaneos Xmas,Null y FIN
sudo iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Bloquear el puerto 80 (HTTP)
iptables -A INPUT -p tcp --dport 80 -j DROP

# Bloquear el puerto 22 (SSH)
iptables -A INPUT -p tcp --dport 22 -j DROP
echo "bloqueo de puerto 80 y 22"

echo "favor de abrir el script y modificar las ips de whitelist y ejecutar" 
# Regla de Whitelist
# Cambia las direcciones IP por las que deseas permitir
whitelist_ips=("192.168.1.100" "10.0.0.2")
for ip in "${whitelist_ips[@]}"; do
    iptables -A INPUT -s "$ip" -j ACCEPT
done
iptables -A INPUT -j DROP

echo "Reglas de iptables configuradas."

exit 0
