
### create a docker network
``` shell
docker network create --driver bridge graylog_bridge

```

### launch mongodb container
``` shell
# 1.check anohter how_tos_start/install_mongodb
# 2.create a new database: graylog
# 3.add a dbadmin user for database graylog

```

### launch opensearch container
``` shell

# generate a password for `OPENSEARCH_INITIAL_ADMIN_PASSWORD` in compose_opensearch.yml:
tr -dc A-Z-a-z-0-9_#%^-_=+ < /dev/urandom | head -c${1:-32}
# one uppercase letter, one lowercase letter, one digit, and one special character  at least
# => "OPENSEARCH_INITIAL_ADMIN_PASSWORD=${SET_YOUR_PASSWORD_HERE}"

docker-compose -p opsearch01 -f compose_opensearch.yml up -d

```

### launch graylog container
``` shell
# change the GRAYLOG_PASSWORD_SECRET and GRAYLOG_ROOT_PASSWORD_SHA2 as described below:
# must be at least 16 characters. Generate one by using for example: pwgen -N 1 -s 96
tr -dc A-Z-a-z-0-9_@#%^-_=+ < /dev/urandom | head -c${1:-32}
# => GRAYLOG_PASSWORD_SECRET=${CHANGE_ME}

# echo -n "Enter Password: " && head -1 < /dev/stdin | tr -d '\n' | sha256sum | cut -d " " -f1
# => GRAYLOG_ROOT_PASSWORD_SHA2=${CHANGE_ME}

docker-compose -p graylog01 -f compose_graylog.yml up -d

```

### graylog configuation file: graylog.conf
If the first start got wrong, update the settings and restart container again
Check and modify settings of graylog.conf for your environment
``` yaml
password_secret = xxxxx
root_password_sha2 = xxxx
root_timezone = Asia/Taipei
http_publish_uri = http://your.ip.or.domain:9000/
http_external_uri = http://your.ip.or.domain:9000/
elasticsearch_hosts = http://{username}:{password}@opsearch01.local:9200
mongodb_uri = mongodb://{username}:{password}@mongodb01:42019/graylog

```
