#!/bin/bash

set -ex

mkdir build
cd build

# workaround for cmake-vs-nvcc: make sure we pick up the our own c-compiler
ln -s $BUILD_PREFIX/bin/x86_64-conda-linux-gnu-cc $BUILD_PREFIX/bin/gcc
ln -s $BUILD_PREFIX/bin/x86_64-conda-linux-gnu-c++ $BUILD_PREFIX/bin/c++
ln -s $BUILD_PREFIX/bin/x86_64-conda-linux-gnu-g++ $BUILD_PREFIX/bin/g++

# avoid unnecessary components (i.e. examples; currently also not building profiler)
# no GPU in CI, so disable building the tests...
cmake \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCUTLASS_ENABLE_F16C=ON \
    -DCUTLASS_ENABLE_CUDNN=OFF \
    -DCUTLASS_ENABLE_CUBLAS=OFF \
    -DCUTLASS_REVISION=${PKG_VERSION} \
    -DCUTLASS_ENABLE_TOOLS=ON \
    -DCUTLASS_ENABLE_LIBRARY=OFF \
    -DCUTLASS_ENABLE_PROFILER=OFF \
    -DCUTLASS_ENABLE_TESTS=OFF \
    -DCUTLASS_ENABLE_EXAMPLES=OFF \
    -DCUTLASS_INSTALL_TESTS=OFF \
    ..  

# compile
make -j$CPU_COUNT

# install
make install

# remove unnecessary files
rm -rf $PREFIX/test
