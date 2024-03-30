#!/bin/bash

# Certifique-se de que o script está sendo executado com privilégios de superusuário
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root" 1>&2
   exit 1
fi

# Remove ufw
echo "Removendo ufw..."
sudo apt remove ufw -y

# Install updates
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Install necessary packages for adding a GPG key
echo "Instalando pacotes necessários para adicionar a chave GPG do Docker..."
sudo apt-get update
sudo apt-get install ca-certificates curl -y

# Preparing Docker's GPG key directory
echo "Preparando diretório para a chave GPG do Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
echo "Adicionando o repositório do Docker às fontes do Apt..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install Docker
echo "Instalando Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add user to the Docker group
echo "Adicionando o usuário ao grupo do Docker..."
sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker


# Enable Docker services
echo "Habilitando serviços do Docker..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Script concluído. Docker instalado e configurado."

