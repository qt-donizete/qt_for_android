
REPO=$1

cd /opt/source/qt6/$REPO
cmake \
    -S . \
    -B host-build \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$HOST_PREFIX_PATH \
    -DCMAKE_INSTALL_PREFIX=$HOST_PREFIX_PATH \
    \
    \
    \
    \
    \
    \
    \
    -DQT_BUILD_TESTS=OFF \
    -DQT_BUILD_EXAMPLES=OFF
cmake --build host-build --parallel `nproc`
cmake --install host-build