#!/bin/bash

# Paperspace Dockerfile for Gradient base image
# Paperspace image is located in Dockerhub registry: paperspace/gradient_base

# ==================================================================
# Module list
# ------------------------------------------------------------------
# python                3.11.15           (apt)
# torch                 1.12.1           (pip)
# torchvision           0.13.1           (pip)
# torchaudio            0.12.1           (pip)
# tensorflow            2.9.2            (pip)
# jax                   0.3.23           (pip)
# transformers          4.21.3           (pip)
# datasets              2.4.0            (pip)
# jupyterlab            3.4.6            (pip)
# numpy                 1.23.4           (pip)
# scipy                 1.9.2            (pip)
# pandas                1.5.0            (pip)
# cloudpickle           2.2.0            (pip)
# scikit-image          0.19.3           (pip)
# scikit-learn          1.1.2            (pip)
# matplotlib            3.6.1            (pip)
# ipython               8.5.0            (pip)
# ipykernel             6.16.0           (pip)
# ipywidgets            8.0.2            (pip)
# cython                0.29.32          (pip)
# tqdm                  4.64.1           (pip)
# gdown                 4.5.1            (pip)
# xgboost               1.6.2            (pip)
# pillow                9.2.0            (pip)
# seaborn               0.12.0           (pip)
# sqlalchemy            1.4.41           (pip)
# spacy                 3.4.1            (pip)
# nltk                  3.7              (pip)
# boto3                 1.24.90          (pip)
# tabulate              0.9.0            (pip)
# future                0.18.2           (pip)
# gradient              2.0.6            (pip)
# jsonify               0.5              (pip)
# opencv-python         4.6.0.66         (pip)
# sentence-transformers 2.2.2            (pip)
# wandb                 0.13.4           (pip)
# nodejs                16.x latest      (apt)
# default-jre           latest           (apt)
# default-jdk           latest           (apt)


# ==================================================================
# Initial setup
# ------------------------------------------------------------------

    # Ubuntu 20.04 as base image
    FROM ubuntu:20.04
    RUN yes| unminimize

    # Set ENV variables
    ENV LANG C.UTF-8
    ENV SHELL=/bin/bash
    ENV DEBIAN_FRONTEND=noninteractive

    ENV APT_INSTALL="apt-get install -y --no-install-recommends"
    ENV PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade"
    ENV GIT_CLONE="git clone --depth 10"


# ==================================================================
# Tools
# ------------------------------------------------------------------

    RUN apt-get update && \
        $APT_INSTALL \
        apt-utils \
        gcc \
        make \
        pkg-config \
        apt-transport-https \
        build-essential \
        ca-certificates \
        wget \
        rsync \
        git \
        vim \
        mlocate \
        libssl-dev \
        curl \
        openssh-client \
        unzip \
        unrar \
        zip \
        csvkit \
        emacs \
        joe \
        jq \
        dialog \
        man-db \
        manpages \
        manpages-dev \
        manpages-posix \
        manpages-posix-dev \
        nano \
        iputils-ping \
        sudo \
        ffmpeg \
        libsm6 \
        libxext6 \
        libboost-all-dev \
        cifs-utils \
        software-properties-common


# ==================================================================
# Python
# ------------------------------------------------------------------

    #Based on https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa

    # Adding repository for python3.11
    RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    # Installing python3.11
        $APT_INSTALL \
        python3.11 \
        python3.11-dev \
        python3.11-venv \
        python3-distutils-extra

    # Add symlink so python and python3 commands use same python3.11 executable
    RUN ln -s /usr/bin/python3.11 /usr/local/bin/python3 && \
        ln -s /usr/bin/python3.11 /usr/local/bin/python

    # Installing pip
    RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
    ENV PATH=$PATH:/root/.local/bin


# ==================================================================
# Installing CUDA packages (CUDA Toolkit 12.1.2 & CUDNN 8.8.1)
# ------------------------------------------------------------------

    # Based on https://developer.nvidia.com/cuda-toolkit-archive
    # Based on https://developer.nvidia.com/rdp/cudnn-archive
    # Based on https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#package-manager-ubuntu-install

    # Installing CUDA Toolkit
    RUN wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda_12.1.0_530.30.02_linux.run && \
        bash cuda_12.1.0_530.30.02_linux.run --silent --toolkit && \
        rm cuda_12.1.0_530.30.02_linux.run
    ENV PATH=$PATH:/usr/local/cuda-12.1/bin
    ENV LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64

    # Installing CUDNN
    RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
        mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
        apt-get install dirmngr -y && \
        apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
        add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
        apt-get update && \
        apt-get install libcudnn8=8.8.1.3-1+cuda12.0 -y && \
        apt-get install libcudnn8-dev=8.8.1.3-1+cuda12.0 -y && \
        rm /etc/apt/preferences.d/cuda-repository-pin-600


# ==================================================================
# PyTorch
# ------------------------------------------------------------------

    # Based on https://pytorch.org/get-started/locally/

    RUN $PIP_INSTALL torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
# ==================================================================
# Hugging Face
# ------------------------------------------------------------------
    # Based on https://huggingface.co/docs/transformers/installation
    # Based on https://huggingface.co/docs/datasets/installation
    $PIP_INSTALL transformers datasets && \
# ==================================================================
# JupyterLab
# ------------------------------------------------------------------
    # Based on https://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html#pip
    $PIP_INSTALL jupyterlab && \
# ==================================================================
# Additional Python Packages
# ------------------------------------------------------------------
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-image \
        scikit-learn \
        matplotlib \
        ipython \
        ipykernel \
        ipywidgets \
        cython \
        tqdm \
        gdown \
        xgboost \
        pillow \
        seaborn \
        sqlalchemy \
        spacy \
        nltk \
        boto3 \
        tabulate \
        future \
        gradient \
        jsonify \
        opencv-python \
        sentence-transformers \
        wandb \
        awscli \
        ngrok \
        jupyterlab-snippets \
        tornado \
        tensorboard \
        fastai


# ==================================================================
# Installing JRE and JDK
# ------------------------------------------------------------------

    RUN $APT_INSTALL \
        default-jre \
        default-jdk


# ==================================================================
# CMake
# ------------------------------------------------------------------

    RUN $GIT_CLONE https://github.com/Kitware/CMake ~/cmake && \
        cd ~/cmake && \
        ./bootstrap && \
        make -j"$(nproc)" install


# ==================================================================
# Node.js and Jupyter Notebook Extensions
# ------------------------------------------------------------------

    RUN curl -sL https://deb.nodesource.com/setup_19.x | bash  && \
        $APT_INSTALL nodejs  && \
        $PIP_INSTALL jupyter_contrib_nbextensions jupyterlab-git && \
        jupyter contrib nbextension install --user
                

# ==================================================================
# Startup
# ------------------------------------------------------------------

    EXPOSE 8888 6006

    CMD jupyter lab --allow-root --ip=0.0.0.0 --no-browser --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False --ServerApp.allow_remote_access=True --ServerApp.allow_origin='*' --ServerApp.allow_credentials=True
