#!/bin/bash

# export TF_VAR_resource_id="~dddss"

cd 02-pipelineAMI/terraform
# cd terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo $"[ec2-img]" > ../ansible/hosts # cria arquivo
# echo $"15.228.79.86" >> ../ansible/hosts # cria arquivo
echo "$(terraform output | grep public_ip | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible/hosts # captura output faz split de espaco e replace de ",

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

cd ../ansible

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/key-private-turma3-dani-dev ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/key-private-turma3-dani-dev.pem