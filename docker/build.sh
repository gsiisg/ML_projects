#!/bin/bash

STARTTIME=$(date +%s)

# GPU=1 taes about 7 minutes
GPU=1
NBPORT=8899

#IMAGEBASE="rapidsai/rapidsai-dev:21.10-cuda11.0-devel-ubuntu20.04-py3.8"
IMAGEBASE="nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04"

#TFVERSION="tf-nightly-gpu"
#IMAGETAG="rapid"
IMAGETAG="tf"


time docker build \
     --build-arg UID=$(id -u) \
     --build-arg GID=$(id -g) \
     --build-arg USER=$USER \
     --build-arg HOST_TZ=$(cat /etc/timezone) \
     --build-arg GPU=$GPU \
     --build-arg IMAGEBASE=$IMAGEBASE \
     --build-arg TFVERSION=$TFVERSION \
     --build-arg NBPORT=$NBPORT \
     -t $IMAGETAG . \
	 -f Dockerfile
#     -f RapidDockerfile

ENDTIME=$(date +%s)
echo "It takes $(($ENDTIME - $STARTTIME)) seconds to build" $IMAGETAG

echo "### MUST ADD VOLUME ~/.config/gcloud to inside CONTAINER FOR GCLOUD TO GET PERMISSION ###"