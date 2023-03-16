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
cd ~/clang+llvm-15.0.6-x86_64-linux-gnu-ubuntu-18.04
sudo cp -R * /usr/local/


#Setting environment for installing CMAKE tool
sudo apt-get install libssl-dev
sudo apt install mesa-common-dev libglu1-mesa-dev


#Install sbt&verilator
sudo apt-get update
sudo apt-get install apt-transport-https curl gnupg -yqq
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
sudo apt-get update
sudo apt-get install sbt verilator


#Install CMAKE
cd ~
wget https://github.com/Kitware/CMake/releases/download/v3.26.0-rc4/cmake-3.26.0-rc4.tar.gz
tar -xvzf cmake-3.26.0-rc4.tar.gz
cd cmake-3.26.0-rc4
./bootstrap
#thread를 최대한 이용하는 방향으로 수정하는 것을 권장(시간이 오래걸림)
make -j128
sudo make install -j128


#Add TVM path
echo 'export TVM_HOME=~/tvm/' >> ~/.bashrc
echo 'export TVM_PATH=~/tvm/' >> ~/.bashrc
echo 'export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}' >> ~/.bashrc
#Add VTA path
echo 'export PYTHONPATH=$TVM_HOME/vta/python:${PYTHONPATH}' >> ~/.bashrc
echo 'export VTA_HW_PATH=$TVM_PATH/3rdparty/vta-hw/' >> ~/.bashrc


#Comment
echo "type 'source ~/.bashrc'"
echo "change {HOME} to '$HOME' at 145th line of '$HOME/tvm/build/config.cmake:145'"