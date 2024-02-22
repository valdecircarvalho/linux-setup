#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root" 1>&2
   exit 1
fi

# Define o nome de usuário
username="valdecir"

# URL de onde a chave SSH pública será baixada
ssh_key_url="https://raw.githubusercontent.com/valdecircarvalho/linux-setup/main/id_rsa.pub"

# Cria o usuário sem senha
useradd -m -s /bin/bash "$username"

# Verifica se o comando anterior foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Usuário $username foi criado com sucesso."
else
    echo "Falha ao criar o usuário $username."
    exit 1
fi

# Baixa a chave SSH pública
mkdir -p /home/"$username"/.ssh
curl -s "$ssh_key_url" > /home/"$username"/.ssh/authorized_keys

# Verifica se a chave foi baixada com sucesso
if [ $? -eq 0 ]; then
    echo "Chave SSH pública baixada com sucesso."
else
    echo "Falha ao baixar a chave SSH pública."
    exit 1
fi

# Define as permissões adequadas
chown -R "$username":"$username" /home/"$username"/.ssh
chmod 700 /home/"$username"/.ssh
chmod 600 /home/"$username"/.ssh/authorized_keys

echo "Configuração concluída com sucesso para o usuário $username."
