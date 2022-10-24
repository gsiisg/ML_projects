# ML_projects

## Setup Tensorflow on windows

### install WSL2
https://learn.microsoft.com/en-us/windows/wsl/install

### install docker desktop
https://www.docker.com/products/docker-desktop/

### enable docker for WSL
https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers

### build docker container

### set alias to start tf docker image
- create folder named alias
- create tf.bat with:
```
@echo off
echo.
docker run -it --name Geo_Container --rm --gpus all --mount type=bind,source=\\wsl$\Ubuntu-20.04\home\gso\data,target=/home/gso/data tf
```
- add folder to window's PATH environmental variable
