# Install ollama on Windows WSL

## Install/Enable WSL2 in Windows
1. Check if WSL is supported:
``` shell
wsl --version
```
2. Enable WSL:
``` shell
wsl --install
```
[How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

## Docker Desktop Installation
1. Visit the official Docker website: https://docs.docker.com/desktop/
[Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
2. Verify the installation
``` shell
docker --version
```

## Ollama Installation
[Visit Ollama Docker image](https://hub.docker.com/r/ollama/ollama)
[ollama⁠ github](https://github.com/ollama/ollama⁠)
``` shell
# with GPU-supported
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
# or
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:0.3.13

# test ollama in CLI with the model llama3 ()
docker exec -it ollama ollama run llama3

# Multiline input
$ ollama
>>> """Hello,
... world!
... """
I'm a basic program that prints the famous "Hello, world!" message to the console.

$ ollama run llama3.2 "Summarize this file: $(cat README.md)"
 Ollama is a lightweight, extensible framework for building and running language models on the local machine. It provides a simple API for creating, running, and managing models, as well as a library of pre-built models that can be easily used in a variety of applications.

```

### CLI Reference
``` bash
ollama pull llama3.2
ollama rm llama3.2
ollama cp llama3.2 my-model
ollama list
ollama ps


curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt":"Why is the sky blue?"
}'

curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    { "role": "user", "content": "why is the sky blue?" }
  ]
}'

```

### (optional for Linux) Install the NVIDIA Container Toolkit packages in Linux environment
``` shell
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo yum install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

```

## Open WebUI Installation
[openwebui getting start](https://docs.openwebui.com/getting-started/)
``` shell
# If Ollama is on your computer, use this command:
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

# Nvida command to check the versions of driver and CUDA
docker exec ollama nvidia-smi

# If Ollama is on a Different Server, use this command:
# To modify OLLAMA_BASE_URL for your enviroment. 
docker run -d -p 3000:8080 -e OLLAMA_BASE_URL=http://192.168.10.10:11434 -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

# To run Open WebUI with Nvidia GPU support, use this command:
docker run -d -p 3000:8080 --gpus all OLLAMA_BASE_URL=http://192.168.10.10:11434 -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda

```
Using browser to visit the GUI of Open WebUI http://192.168.10.10:3000 then enjoy.


### Upgrading the docker image
``` shell
docker pull ollama/ollama
docker stop ollama

# Checking the location of the files
docker inspect ollama | grep -i volume

docker rm ollama

docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:0.3.13

```
