#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root" 1>&2
   exit 1
fi

# Define o nome de usuário e a URL da chave SSH pública
username="valdecir"
ssh_key_url="https://raw.githubusercontent.com/valdecircarvalho/linux-setup/main/id_rsa.pub"

# Cria o usuário sem definir uma senha
useradd -m -s /bin/bash "$username"

# Verifica se o usuário foi criado com sucesso
if [ $? -eq 0 ]; then
    echo "Usuário $username foi criado com sucesso."
else
    echo "Falha ao criar o usuário $username."
    exit 1
fi

# Baixa a chave SSH pública e configura as permissões
mkdir -p /home/"$username"/.ssh
curl -s "$ssh_key_url" > /home/"$username"/.ssh/authorized_keys
chown -R "$username":"$username" /home/"$username"/.ssh
chmod 700 /home/"$username"/.ssh
chmod 600 /home/"$username"/.ssh/authorized_keys

# Configura o usuário para executar comandos sudo sem senha
echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$username"
chmod 0440 /etc/sudoers.d/"$username"

echo "Chave SSH adicionada com sucesso para o usuário $username."
echo "Usuário $username configurado para executar comandos sudo sem senha."
