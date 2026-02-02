ABI=$1
REPO=$2

cd /opt/source/qt6/$REPO
cmake \
    -S . \
    -B android-build-$ABI \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=$ANDROID_PREFIX_PATH-$ABI \
    -DCMAKE_INSTALL_PREFIX=$ANDROID_PREFIX_PATH-$ABI \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=NEVER \
    -DANDROID_ABI=$ABI \
    -DANDROID_PLATFORM=android-26 \
    -DANDROID_SDK_ROOT=$ANDROID_HOME \
    -DANDROID_STL=c++_shared \
    -DQT_HOST_PATH=$QT_HOST_PATH \
    -DQT_BUILD_TESTS=OFF \
    -DQT_BUILD_EXAMPLES=OFF
cmake --build android-build-$ABI --parallel `nproc`
cmake --install android-build-$ABI