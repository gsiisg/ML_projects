# the variable imagease will provide the imagebase to pull from and whether or not GPU or CPU sections will be used
# imagebase must be passed from linux shell because you can't do if/else logic before "From", so the if/else is in build script 
ARG IMAGEBASE

From $IMAGEBASE

# the following must be declared after "From" or they will not be accessible later
# read from build lines these following dummy initialized variables
ARG GPU
ARG UID
ARG GID
ARG USER
ARG HOST_TZ
ARG TFVERSION
ARG NBPORT
# non-interactive is needed or else during build it will ask for time zone info
ARG DEBIAN_FRONTEND=noninteractive

# sets user to host user, avoid using root
RUN groupadd --gid $GID $USER && useradd --create-home --uid=$UID --gid=$GID --shell /bin/bash $USER 
RUN chown $UID:$GID /home/$USER

# get key from nvidia, needed to download ML packages
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

# sets time zone as host time zone
# need wget for installation of Anaconda
# lets jupyter assign port automatically and print hostname to be pasted into browser if on ethernet (on wifi add .engba.symantec.com to hostname)
# adapted for GCP
RUN apt-get update && \
    apt-get install -y tzdata \
    wget \
    nano \
    lsof \
    libsm6 \
    libxext6 \
    libxrender-dev \
	curl \
    git \
	python3.9 \
	python3.9-distutils 

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.9 get-pip.py

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone; \
    dpkg-reconfigure -f noninteractive tzdata

# CANNOT get anaconda to install properly -- too many conflicts

# this should install gcloud for the container from Javier, have not tested it, will test next time I run this                                         
# added sdk to PATH
#RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-324.0.0-linux-x86_64.tar.gz && \
#    cd /home/$USER && tar xfvz /google-cloud-sdk-324.0.0-linux-x86_64.tar.gz > /dev/null && \
#    rm /google-cloud-sdk-324.0.0-linux-x86_64.tar.gz && \
#    /home/$USER/google-cloud-sdk/install.sh && \
#    /home/$USER/google-cloud-sdk/bin/gcloud components update && \
#    chown $UID:$GID -R /home/$USER/google-cloud-sdk


# set thse paths so that even though gcloud sdk requires root to install, $USER can access
#ENV CLOUDSDK_INSTALL_DIR /home/$USER/
#RUN curl -sSL https://sdk.cloud.google.com | bash &&\
#    chown $UID:$GID -R /home/$USER/google-cloud-sdk
#ENV PATH /home/$USER/google-cloud-sdk/bin:$PATH


# watch the careful use of \" to enable the use of $NBPORT variable within quoted string
RUN echo "alias nb=\"jupyter notebook --port=$NBPORT\"" > /home/$USER/.bashrc

ENV PATH /home/$USER/.local/bin:$PATH
# new version of cuda uses /cuda instead of /nvidia

#RUN if [ "$GPU" = "1" ]; then \
#    export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH; \
#    export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:LD_LIBRARY_PATH; \
#    export NVIDIA_VISIBLE_DEVICES=all; \
#    export NVIDIA_DRIVER_CAPABILITIES=compute,utility; \
#    export NVIDIA_REQUIRE_CUDA=cuda>=11.0; \
#fi

# copy the requirements into /home in container
# install pip packages from requirements.txt
COPY requirements.txt /home/$USER/requirements.txt
# switch to /home as working directory
# this must be done before calling pip install with requirements.txt
WORKDIR /home/$USER


# for picks the GPU or CPU version of tensorflow to install
USER $UID:$GID

RUN python3.9 -m pip install --user -q --upgrade pip && \
    #pip install --user -q $TFVERSION && \
    python3.9 -m pip install --user -q -r requirements.txt; 

CMD ["/bin/bash"]


