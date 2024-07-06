#!/bin/bash

# Установка Yggdrasil на Debian/Ubuntu/аналогичные дистрибутивы

# Установка зависимостей, если они не установлены
sudo apt-get update
sudo apt-get install -y apt-transport-https dirmngr

# Импорт ключа репозитория
sudo mkdir -p /usr/local/apt-keys
gpg --fetch-keys https://neilalexander.s3.dualstack.eu-west-2.amazonaws.com/deb/key.txt
gpg --export BC1BF63BD10B8F1A | sudo tee /usr/local/apt-keys/yggdrasil-keyring.gpg > /dev/null

# Добавление репозитория в apt источники
echo 'deb [signed-by=/usr/local/apt-keys/yggdrasil-keyring.gpg] http://neilalexander.s3.dualstack.eu-west-2.amazonaws.com/deb/ debian yggdrasil' | sudo tee /etc/apt/sources.list.d/yggdrasil.list

# Обновление списка пакетов
sudo apt-get update

# Установка Yggdrasil
sudo apt-get install -y yggdrasil

# Проверка успешности установки
if [ $? -eq 0 ]; then
    echo "Yggdrasil успешно установлен."
else
    echo "Ошибка при установке Yggdrasil."
    exit 1
fi

# Автоматическая генерация конфигурационного файла и запуск службы
sudo systemctl enable yggdrasil
sudo systemctl start yggdrasil

# Проверка статуса службы
sudo systemctl status yggdrasil --no-pager

# Вывод информации об успешной установке
echo "Установка Yggdrasil завершена."

# Дополнительно, можно вывести информацию о конфигурации
echo "Конфигурационный файл: /etc/yggdrasil.conf"
echo "Для изменения конфигурации, отредактируйте /etc/yggdrasil.conf и перезапустите службу командой 'sudo systemctl restart yggdrasil'."
