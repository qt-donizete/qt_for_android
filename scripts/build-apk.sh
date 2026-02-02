#!/bin/bash

ABIS=(arm64-v8a x86_64)

ABI=$1
BUILD_TYPE=${2:-Release}

if [[ ! " ${ABIS[*]} " =~ " ${ABI} " ]]; then
  echo "Invalid ABI: $ABI"
  echo "Available ABIs: ${ABIS[*]}"
  exit 1
fi

cmake \
  -S . \
  -B android-build \
  -GNinja \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=$ABI \
  -DANDROID_PLATFORM=android-26 \
  -DANDROID_SDK_ROOT=$ANDROID_HOME \
  -DCMAKE_PREFIX_PATH=$ANDROID_PREFIX_PATH-$ABI \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=NEVER \
  -DQT_HOST_PATH=$HOST_PREFIX_PATH
cmake --build android-build
