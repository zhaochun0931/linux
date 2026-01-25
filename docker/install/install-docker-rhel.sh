# https://docs.docker.com/engine/install/centos/


yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


systemctl enable docker
systemctl start docker


docker run hello-world
