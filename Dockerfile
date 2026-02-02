FROM ubuntu:24.04

ARG QT_VERSION=6.11
ARG NDK_VERSION=29.0.14206865
ARG SDK_PLATFORM=android-36
ARG SDK_BUILD_TOOLS=36.1.0
ARG SDK_PACKAGES="tools platform-tools"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/${NDK_VERSION}
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:/opt/scripts

ENV ANDROID_PREFIX_PATH=/opt/android
ENV HOST_PREFIX_PATH=/opt/host

RUN apt update
RUN apt install -y \
    git \
    cmake \
    curl \
    build-essential \
    ninja-build \
    python3 \
    openjdk-17-jdk \
    unzip \
    locales \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    mesa-common-dev \
    xorg-dev

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# ---------------------------- Android SDK --------------------------------
WORKDIR $ANDROID_HOME/cmdline-tools

RUN curl -Lo tools.zip https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
    && unzip tools.zip -d . && rm tools.zip && mv cmdline-tools latest \
    && yes | sdkmanager --licenses \
    && sdkmanager --verbose "platforms;${SDK_PLATFORM}" "build-tools;${SDK_BUILD_TOOLS}" "ndk;${NDK_VERSION}" ${SDK_PACKAGES} \
    && sdkmanager --uninstall --verbose emulator
# -------------------------------------------------------------------------

COPY scripts /opt/scripts

# ---------------------------- Compile host libs --------------------------
WORKDIR /opt/source

RUN git clone -b ${QT_VERSION} --recurse-submodules --depth=1 https://github.com/qt/qt5.git qt6

RUN /opt/scripts/compile-host.sh qtbase
RUN /opt/scripts/compile-host.sh qtshadertools

ENV QT_HOST_PATH=$HOST_PREFIX_PATH
# -------------------------------------------------------------------------

# ----------------------- Compile Android libs ----------------------------
RUN /opt/scripts/compile-android.sh arm64-v8a qtbase
RUN /opt/scripts/compile-android.sh arm64-v8a qtshadertools
RUN /opt/scripts/compile-android.sh arm64-v8a qtdeclarative
# -------------------------------------------------------------------------