#!/bin/bash

echo "Hello TVM-VTA"

#Install TVM
cd ~
git clone --recursive https://github.com/apache/tvm tvm
sudo apt-get update
sudo apt-get install -y python3 python3-dev python3-setuptools gcc libtinfo-dev zlib1g-dev build-essential cmake libedit-dev libxml2-dev
cd tvm && mkdir build && cp ~/TVM_VTA/config.cmake build


#Install Anaconda ("tvm-build"라는 가상환경으로 TVM-VTA를 이용할 예정)
wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
echo "항상 yes로 대답 (마지막에 no로 응답하면 conda 명령어 사용 불가)"
bash Anaconda3-2022.10-Linux-x86_64.sh


#Install Clang-LLVM
cd ~
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar -xvf clang*.xz
cd /home/kookyungmo/tvm/build/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04
sudo cp -R * /usr/local/


#Setting environment for installing CMAKE tool
sudo apt-get install libssl-dev
sudo apt install mesa-common-dev libglu1-mesa-dev


#Install CMAKE
cd ~
wget https://github.com/Kitware/CMake/releases/download/v3.26.0-rc4/cmake-3.26.0-rc4.tar.gz
tar -xvzf cmake-3.26.0-rc4.tar.gz
cd cmake-3.26.0-rc4
./bootstrap
make -j40               #thread를 최대한 이용하는 방향으로 수정하는 것을 권장(시간이 오래걸림)
sudo make install -j40


#Add TVM path
echo 'export TVM_HOME=~/tvm/' >> ~/.bashrc
echo 'export TVM_PATH=~/tvm/' >> ~/.bashrc
echo 'export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}' >> ~/.bashrc

#Add VTA path
echo 'export PYTHONPATH=$TVM_HOME/vta/python:${PYTHONPATH}' >> ~/.bashrc
echo 'export VTA_HW_PATH=$TVM_PATH/3rdparty/vta-hw/' >> ~/.bashrc

#Apply bashrc
source ~/.bashrc


#Build TVM
cd ~/tvm/build
cmake ..
make -j40               #thread를 최대한 이용하는 방향으로 수정하는 것을 권장(시간이 오래걸림)

#"tvm-build" environment setting
cd ..
conda env create --file conda/build-environment.yaml
conda activate tvm-build
pip3 install --user numpy decorator attrs
pip3 install --user typing-extensions
pip3 install --user tornado
pip3 install --user tornado psutil 'xgboost>=1.1.0' cloudpickle
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get upgrade libstdc++6