#!/bin/bash

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

sudo apt-get install -y docker-ce

sudo usermod -aG docker $USER

sudo docker swarm init --advertise-addr 192.168.56.50

sudo docker swarm join-token -q worker

sudo docker swarm join-token -q worker > /vagrant/my_token.txt

sudo chmod 644 /vagrant/my_token.txt 
