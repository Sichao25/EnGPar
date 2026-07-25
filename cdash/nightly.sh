#!/bin/bash -x

(

#cdash output root
d=/users/d_zxg06726/nightlyBuilds/EnGPar_build
exec > $d/nightly_log.txt 2>&1

source /etc/profile
# source /users/d_zxg06726/.bash_profile

#setup lmod
export PATH=/usr/share/lmod/lmod/libexec:$PATH

#setup spack modules
unset MODULEPATH

module use /opt/scorec/spack/rhel9/v0201_4/lmod/linux-rhel9-x86_64/Core/
module load gcc/12.3.0-iil3lno
module load mpich/4.1.1-xpoyz4t
module load cmake/3.26.3-2duxfcd

cd $d
#remove compilation directories created by previous nightly.cmake runs
[ -d build ] && rm -rf build/

#install kokkos
[ ! -d EnGPar-graphs ] && git clone https://github.com/SCOREC/EnGPar-graphs.git
cd EnGPar-graphs && git pull && cd -
[ ! -d pumi-meshes ] && git clone https://github.com/SCOREC/pumi-meshes.git
cd pumi-meshes && git pull && cd -

touch $d/startedCoreNightly
#run nightly.cmake script
ctest -V --script $d/nightly.cmake
touch $d/doneCoreNightly
)
