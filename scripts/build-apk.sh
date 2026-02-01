#!/bin/bash

ABIS=(armeabi-v7a arm64-v8a x86 x86_64)

ABI=$1

if [[ ! " ${ABIS[*]} " =~ " ${ABI} " ]]; then
  echo "Invalid ABI: $ABI"
  echo "Available ABIs: ${ABIS[*]}"
  exit 1
fi

cmake \
  -S . \
  -B android-build \
  -GNinja \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-26 \
  -DANDROID_SDK_ROOT=$ANDROID_HOME \
  -DCMAKE_PREFIX_PATH=/opt/android \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=NEVER \
  -DQT_HOST_PATH=/opt/host \
  -DCMAKE_BUILD_TYPE=Release
cmake --build android-build
