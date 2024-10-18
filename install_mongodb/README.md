
## Install MongoDB
1. [install-mongodb-community-with-docker](https://www.mongodb.com/zh-cn/docs/manual/tutorial/install-mongodb-community-with-docker/)
``` bash
docker pull mongodb/mongodb-community-server:latest

docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest

# myReplicaSet setttings
docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest  --replSet myRS

# For MondoDB 5.0
docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:5.0-ubuntu2004

```

### run mongod
``` bash
#/bin/sh
#

WORKING_DIR=/opt/mongodb
MONGOBIN_DIR=${WORKING_DIR}/mongodb-linux-x86_64-ubuntu2004-7.0.5/bin
MONGO_ADM=${MONGOBIN_DIR}/mongo
MONGOD=${MONGOBIN_DIR}/mongod
MONGOD_CONFILE=${WORKING_DIR}/mongodb7.conf
MONGOD_PID=${WORKING_DIR}/mongod.pid
MONGOD_AUTH=--auth
MONGOD_HOST="192.168.1.1"

if [ "$1" == "server" ]; then
    echo "mongod is starting..."
    ${MONGOD} ${MONGOD_AUTH} --replSet rs0 --quiet --config ${MONGOD_CONFILE} &
    exit 0
fi

if [ "$1" == "stop" ]; then
    kill $(<"$MONGOD_PID")
    echo "mongod stopped"
    exit 0
fi

if [ "$1" == "admin" ]; then
    echo "mongo admin"
    ${MONGO_ADM} --verbose -u "adminuser" -p "adminpass" --authenticationDatabase 'admin' --host ${MONGOD_HOST} --port   27017 ||  ${MONGO_ADM} -h
    exit 0
fi

if [ "$1" == "admin_nopw" ]; then
    echo "mongo admin"
    ${MONGO_ADM} --verbose --host ${MONGOD_HOST} --port 27017 || ${MONGO_ADM} -h
    exit 0
fi

#replica.key
if [ "$1" == "genkey" ]; then
    openssl rand -base64 741 > $2
    chmod 400 $2
fi

```

### mongodb.conf
``` yaml
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
storage:
  dbPath: /opt/mongodb/mongo_data
#deprecated from 6.1, remove 7.0
#  journal:
#    enabled: true
  engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 2

systemLog:
  destination: file
  logAppend: false
  path:  /opt/mongodb/logs/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1

processManagement:
  pidFilePath: /opt/mongodb/mongod.pid

security:
  # disable security before add a admin user
  authorization: enabled
  keyFile: /opt/mongodb/replica.key

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options:

#auditLog:

#snmp:

```

### some mongosh commands
``` bash

mongosh "mongodb+srv://YOUR_CLUSTER_NAME.YOUR_HASH.mongodb.net/" --apiVersion YOUR_API_VERSION --username YOUR_USERNAME

mongosh "mongodb://localhost:27017" --username alice --password "1234" --authenticationDatabase admin

#upgrade procedure in adminMode

db.adminCommand( { getParameter: 1, featureCompatibilityVersion: 1 } )
db.adminCommand( { setFeatureCompatibilityVersion: "4.4" } )
db.adminCommand( { setFeatureCompatibilityVersion: "5.0" } )
db.adminCommand( { setFeatureCompatibilityVersion: "6.0" } )
db.adminCommand( { setFeatureCompatibilityVersion: "7.0" } )

# 0. Initiate the replica set.
use admin;
rs.initiate()
# or 
rs.initiate( {
    _id : "rs0",
    members: [
       { _id: 0, host: "mongodb0.example.net:27017" },
       { _id: 1, host: "mongodb1.example.net:27017" }
    ]
 })

# 1. create a admin user with auth
use admin;
db.createUser({user: "newuser",pwd: "newpass", roles: [ { role: "userAdminAnyDatabase", db: "admin"} ]})
db.grantRolesToUser('newuser', [{ role: 'root', db: 'admin' }]);
# then try 
db.auth("newuser","newpass") 
# or
db.system.users.find();
db.changeUserPassword("newuser", "newpass");

# 2. create a dbOwner user
use vueapp;
db.createUser({user: "vueapp", pwd: "appdbpass", roles: ["dbOwner"]})

use reporting;
db.createUser(
  {
    user: "reportsUser",
    pwd: passwordPrompt(),  // or cleartext password
    roles: [
       { role: "read", db: "reporting" },
       { role: "read", db: "products" },
       { role: "read", db: "sales" },
       { role: "readWrite", db: "accounts" }
    ]
  }
)

# 3. create db and collectoins
use blog;
db.createCollection("posts")

# 4 create index
db.collection.createIndex(
  {
      "a": 1
  },
  {
      unique: true,
      sparse: true,
      expireAfterSeconds: 3600
  }
)

```

### Backup and Restore
[Back Up and Restore a Self-Managed MongoDB](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/)
``` shell

mongodump --db ${database_name} --out ${backup_directory}

mongorestore --db ${database_name} ${backup_directory}/${dump_file}

mongoexport -h mongo.example.com:42019 --db ${database_name} --username username --password userpass \
  --collection ${colName} --out ${outName}.json

mongoimport mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]

```

### MongoDB systemctl
``` yaml
# /etc/systemd/system/mongod.service
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongod
ExecStart=/opt/mongodb/mongodb-linux-x86_64-rhel70-4.4.5/bin/mongod --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target

```

``` bash
sudo systemctl start mongod
sudo systemctl stop mongod
sudo systemctl restart mongod
sudo systemctl enable mongod
```