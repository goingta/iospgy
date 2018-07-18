#!/bin/bash 

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source $HOME/xtool/profile

#修改工具链上App图标
flagIcon=./DoctorHealth/Scripts/flag_beta.png
iconvert $flagIcon

#编译打包
pkg -env distribution.cfg
fastlane pgy

exit 0
