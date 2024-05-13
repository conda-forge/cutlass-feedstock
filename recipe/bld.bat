@echo on
setlocal enableextensions enabledelayedexpansion || goto :error

mkdir build
cd build

:: avoid unnecessary components (i.e. examples; currently also not building profiler)
:: no GPU in CI, so disable building the tests...
cmake \
    %CMAKE_ARGS% \
    -G=Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCUTLASS_ENABLE_F16C=ON \
    -DCUTLASS_ENABLE_CUDNN=ON \
    -DCUTLASS_ENABLE_CUBLAS=ON \
    -DCUTLASS_REVISION=%PKG_VERSION% \
    -DCUTLASS_ENABLE_TOOLS=ON \
    -DCUTLASS_ENABLE_LIBRARY=OFF \
    -DCUTLASS_ENABLE_PROFILER=OFF \
    -DCUTLASS_ENABLE_TESTS=OFF \
    -DCUTLASS_ENABLE_EXAMPLES=OFF \
    ..  
if errorlevel 1 exit 1

:: install
make install
if errorlevel 1 exit 1
