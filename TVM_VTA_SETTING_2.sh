#!/bin/bash

#Build TVM
cd ~/tvm/build
cmake ..
 #thread를 최대한 이용하는 방향으로 수정하는 것을 권장(시간이 오래걸림)
make -j128


#Install pip3
sudo apt install python3-pip


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