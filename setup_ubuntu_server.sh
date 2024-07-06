#!/bin/bash

# Обновление списка пакетов и установка net-tools
sudo apt update
sudo apt install -y net-tools

# Установка пароля для пользователя root
echo "Установка пароля для пользователя root..."
sudo passwd root

# Получение текущего IP-адреса интерфейса enp0s8
INTERFACE="enp0s8"
CURRENT_IP=$(ip -f inet addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Если IP-адрес не назначен, назначаем статический IP
if [ -z "$CURRENT_IP" ]; then
    IP_ADDRESS="192.168.56.102"
    sudo ifconfig $INTERFACE $IP_ADDRESS
    echo "Назначен IP-адрес $IP_ADDRESS для интерфейса $INTERFACE."
else
    IP_ADDRESS=$CURRENT_IP
    echo "Интерфейс $INTERFACE уже имеет IP-адрес $IP_ADDRESS."
fi

# Разрешение root-доступа по SSH
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' $SSH_CONFIG_FILE

# Увеличение времени SSH-сессии
sudo sed -i '/TCPKeepAlive/c\TCPKeepAlive yes' $SSH_CONFIG_FILE
sudo sed -i '/ClientAliveInterval/c\ClientAliveInterval 300' $SSH_CONFIG_FILE
sudo sed -i '/ClientAliveCountMax/c\ClientAliveCountMax 60' $SSH_CONFIG_FILE

# Перезапуск SSH сервиса
sudo service ssh restart

# Вывод информации об успешном выполнении
echo "Скрипт выполнен успешно. IP-адрес $IP_ADDRESS назначен интерфейсу $INTERFACE."
