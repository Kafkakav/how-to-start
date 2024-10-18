
## Generate ssh key for nopassword login
1. Install openssh on Ubuntu
[OpenSSH Server](https://ubuntu.com/server/docs/openssh-server)
``` bash
sudo apt install openssh-server
sudo apt install openssh-client

```
Enabling the OpenSSH Client on Windows 10
```
1. Open the Settings -> Application -> search "Optional features"
2. Install optional features -> OpenSSH Client
3. check sshd configuration in the path C:\Users\{username}\.ssh

```

2. Configure OpenSSH
``` bash
# edit the config file
sudo nano /etc/ssh/sshd_config

# verify config file before restart it
sudo sshd -t -f /etc/ssh/sshd_config

```
## Connection Test
``` bash
# reverse tunnel using openssh 
# ssh -vv -p ${SSHD_SERVICE_PORT} -i ${SSHD_KEY_DEVUSR1} \
#    -4 -N -R ${REMOTE_LISTEN_PORT}:${LOCAL_SERVICE_IP_PORT} \
#    ${SSHD_SERVICE_ADDR}
ssh -v -p 22 -i ${SSH_KEY_OUTPUT_FILE}_rsa -4N -R 2222:localhost:22 ${SSH_KEY_USER}@192.168.166.12

# reverse tunnel using dropbear
dbclient -p 22 -y -K 3 -I 300 -i ${SSH_KEY_OUTPUT_FILE}_rsa -N -f -R 2222:localhost:22 ${SSH_KEY_USER}@192.168.166.12

```

### Client Configuration for multiple github accounts
1. Edit user/.ssh/config (/home/user/.ssh/config in Linux)
```
Host **github.com-gituserfoo**
  HostName github.com
  User git
  PreferredAuthentications publickey
  IdentityFile C:/Users/user/.ssh/userfoo_github.key
  IdentitiesOnly yes

Host **github.com-gituserbar**
  HostName github.com
  User git
  PreferredAuthentications publickey
  IdentityFile  C:/Users/user/.ssh/usrbar_ed25519_github.key
  IdentitiesOnly yes

```
2. How to checkout code
``` bash
git clone git@**github.com-gituserfoo**:gituserfoo/how-to-start.git

```


## Two factor authentication with U2F/FIDO (TBD)
``` 
$ ssh-keygen -t ecdsa-sk

Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation. <-- touch device
Enter file in which to save the key (/home/ubuntu/.ssh/id_ecdsa_sk): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ubuntu/.ssh/id_ecdsa_sk
Your public key has been saved in /home/ubuntu/.ssh/id_ecdsa_sk.pub
The key fingerprint is:
SHA256:V9PQ1MqaU8FODXdHqDiH9Mxb8XK3o5aVYDQLVl9IFRo ubuntu@focal

```
