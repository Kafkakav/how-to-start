
## Nginx Installation

### useful management commands
``` bash 
# edit nginx.conf
nano /config/nginx/site-confs/default

# verify nginx.conf
nginx -t -c /config/nginx/nginx.conf

# ask nginx service reload configuration
nginx -s reload -c /config/nginx/nginx.conf

# run nginx servie with the specific configuratioin
nginx -g "daemon off;" -c /config/nginx/nginx.conf

# add a user of basic auth
sudo htpasswd /etc/nginx/.htpasswd {username}

```


1. [Install Nginx on Ubuntu](https://ubuntu.com/tutorials/install-and-configure-nginx#2-installing-nginx)
``` bash
sudo apt update
sudo apt install nginx

```

2. [Install Nginx Docker via Linuxserver.io](https://hub.docker.com/r/linuxserver/nginx)
#### Using docker-compose file: docker-compose -f nginx-compose.yml up -d 
``` yaml
# nginx-compose.yml
services:
  nginx:
    image: lscr.io/linuxserver/nginx:latest
    container_name: nginx
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/nginx/config:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
```
path of nginx.conf
```
/config/nginx/nginx.conf 
/config/nginx/site-confs/default
```

#### Using docker commands
``` bash
docker run -d \
  --name=nginx \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/nginx/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/nginx:latest

```
#### Building locally (user can customized here)
``` bash
git clone https://github.com/linuxserver/docker-nginx.git
cd docker-nginx
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/nginx:latest .

docker run --rm --privileged multiarch/qemu-user-static:register --reset

```

3. [Install Nginx Proxy Manager(NPM)](https://github.com/NginxProxyManager/nginx-proxy-manager)
``` yaml 
# npm.yml
services:
  nginx_npm:
    container_name: nginx_npm
    image: 'docker.io/jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    environment:
      PUID: 1500
      PGID: 1500
      DISABLE_IPV6: 'true'
networks:
  default:
    external: true
    name: the_created_network
```
#### 
``` bash
docker-compose -f ./pm.yml up -d
# If using docker-compose-plugin
docker compose f ./pm.yml up -d

```

[Full setup with database](https://nginxproxymanager.com/setup/)
``` yaml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
      # Add any other Stream port you want to expose
      # - '21:21' # FTP
    environment:
      PUID: 1000
      PGID: 1000
      # Mysql/Maria connection parameters:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm"
      DB_MYSQL_NAME: "npm"
      # Uncomment this if IPv6 is not enabled on your host
      # DISABLE_IPV6: 'true'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
#    depends_on:
#      - db
#  db:
#    image: 'jc21/mariadb-aria:latest'
#    restart: unless-stopped
#    environment:
#      MYSQL_ROOT_PASSWORD: 'npm'
#      MYSQL_DATABASE: 'npm'
#      MYSQL_USER: 'npm'
#      MYSQL_PASSWORD: 'npm'
#      MARIADB_AUTO_UPGRADE: '1'
#    volumes:
#      - ./mysql:/var/lib/mysql

```

### Exmaple of nginx.config (openwrt)
```
# UCI_CONF_VERSION=1.2
worker_processes 4;
user root;

include module.d/*.module;

events {
	worker_connections 1024;
}

http {
	access_log off;
	log_format openwrt
		'$request_method $scheme://$host$request_uri => $status'
		' (${body_bytes_sent}B in ${request_time}s) <- $http_referer';

	include mime.types;
	default_type application/octet-stream;
	sendfile on;
  charset utf-8;

	client_max_body_size 64M;
	large_client_header_buffers 2 1k;

	gzip on;
	gzip_vary on;
	gzip_proxied any;

 	## Proxy settings
 	proxy_set_header   Host $host:$server_port;
	proxy_set_header   X-Real-IP $remote_addr;
	proxy_set_header   X-Real-PORT $remote_port;
	proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header   X-Forwarded-Host $server_name;
 	proxy_set_header   X-Forwarded-Proto $scheme; 

 	## websocket settings
	map $http_upgrade $connection_upgrade {
 		default upgrade;
		'' close;
	}

	root /www;

	server { #see uci show 'nginx._lan'
		listen 444 ssl default_server;
		listen [::]:444 ssl default_server;
		server_name _lan;
		# include restrict_locally;
		include conf.d/*.locations;

		ssl_certificate /etc/nginx/conf.d/_lan.crt;
		ssl_certificate_key /etc/nginx/conf.d/_lan.key;
		# ssl_session_cache shared:SSL:32k;
		# ssl_session_timeout 64m;

		access_log off; # logd openwrt;
		
		include /etc/nginx/options-ssl-nginx.conf;
		location = /robots.txt { access_log off; log_not_found off; }
		location = /favicon.ico { access_log off; log_not_found off; }
    # Media: images, icons, video, audio, HTC
    location ~ \.(jpe?g|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
      expires 1M;
      access_log off;
      add_header Cache-Control "public";
    }

	}

	server { #see uci show 'nginx._redirect2ssl'
		listen 81;
		listen [::]:81;
		# server_name _redirect2ssl;
		# return 302 https://$host$request_uri;
		
		location /.well-known/ {
			allow all;
			root /www/acme_wellknown;
		}

		location / {
			#try_files $uri $uri/ /index.html /index.php?$args =404;
			#return 301 https://$host$request_uri;
			# simply close the connection without responding to it.
			return 444;
		}

	}

	include conf.d/*.conf;
}

```
### Exmaple of reverseproxy.locations
```
  # LIFF
  location ^~/LIFF/ { 
    #remoteComm
    proxy_pass  http://172.20.124.2:8080;
    proxy_redirect off; 
  }
  
  # LIFF stage
  location ^~/stage/LIFF/ {
    #rewrite /stage/(.*) /$1  break;
    proxy_pass  http://172.20.121.5:8080;
    proxy_redirect off; 
  }
  
```