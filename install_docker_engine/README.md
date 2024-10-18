
## Docker Installatioin on Ubuntu
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)
1. Uninstall all conflicting packages if you need:
``` bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

## Uninstall Docker Engine
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

```

2. Install using the convenience script
``` bash
curl -fsSL https://get.docker.com -o get-docker.sh

# test run
sudo sh ./get-docker.sh --dry-run

# install the latest stable release of Docker on Linux
sudo sh get-docker.sh
```

### Manage Docker as a non-root user
``` bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

### Log out and log back to activate or 
``` bash
newgrp docker
```

### Configure Docker to start on boot with system
``` bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

```

### useful command
``` bash
docker ps
docker image ls
docker network ls
docker exec -u username -it ${CONTAINER} /bin/bash

#if using PM2
docker exec -u username -it -e HOME=/config -e PM2_HOME=/config/.pm2 ${CONTAINER} /bin/bash

docker exec -u username -e HOME=/config -e PM2_HOME=/config/.pm2 ${CONTAINER} ls /etc
# or run script.sh
shift 1
docker exec -u username -e HOME=/config -e PM2_HOME=/config/.pm2  ${CONTAINER} $@

#logs
docker logs -f ${CONTAINER}

```
### get containers ip address
``` bash
#/bin/bash

DATETS=$(date '+%Y-%m-%dT%H%M%S')

# get all container name
CONTAINERS=$(docker ps --format "{{.Names}}")
# get all container ip address
if [ "$1" == "ip" ]; then
  for container in $CONTAINERS; do
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
    echo "$container: $ip"
  done
fi
# get all subnet of network
NETWORKS=$(docker network ls | awk '{print $2}')
if [ "$1" == "net" ]; then
  for brnet in $NETWORKS; do
    echo ">>> Netwokr: $brnet"
    docker network inspect -f '{{.Containers}}' "$brnet"
  done
fi
```

### JSON File logging driver for container (compose file)
[JSON File logging driver](https://docs.docker.com/engine/logging/drivers/json-file/)
``` yaml
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}

# compoise-file
appname:
    logging:
      driver: json-file
      options:
        max-size: 4m
        max-file: "1"

# Ex:  docker run -it --log-opt max-size=10m --log-opt max-file=3 alpine ash
```
