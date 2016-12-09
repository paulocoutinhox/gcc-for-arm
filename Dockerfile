FROM ubuntu:14.04

MAINTAINER Paulo Coutinho

# install dependencies
RUN apt-get update && apt-get install -y \
     build-essential \
     git \
	 python \
     liblapack-dev \
     libopenblas-dev \
     openmpi-bin \
     libopenmpi-dev \
	 wget \
	 nano \
	 curl \
	 unzip \
	 bison \
	 flex \
	 libmpc-dev \
	 g++

RUN apt-get clean

# base paths
ENV BASE_DIR=/gcc-for-arm
RUN mkdir -p ${BASE_DIR}

# download things here to prevent download everytime that Dockerfile is changed
WORKDIR ${BASE_DIR}
RUN wget https://github.com/gcc-mirror/gcc/archive/gcc-6_2_0-release.zip -O ${BASE_DIR}/gcc-6_2_0-release.zip
RUN wget https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip -O ${BASE_DIR}/android-ndk-r13b-linux-x86_64.zip

# unpack gcc
RUN unzip ${BASE_DIR}/gcc-6_2_0-release.zip -d ${BASE_DIR}
RUN rm -rf ${BASE_DIR}/gcc-6_2_0-release.zip
ENV GCC_HOME=${BASE_DIR}/gcc-gcc-6_2_0-release

# android ndk
ENV ANDROID_API=15
RUN unzip ${BASE_DIR}/android-ndk-r13b-linux-x86_64.zip -d ${BASE_DIR}
RUN rm -rf ${BASE_DIR}/android-ndk-r13b-linux-x86_64.zip
ENV NDK_HOME=${BASE_DIR}/android-ndk-r13b
ENV SYSROOT=${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm
ENV CROSS_COMPILER=${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi

# compile gcc
RUN rm -rf ${BASE_DIR}/gcc-gcc-6_2_0-release/build
RUN mkdir -p ${BASE_DIR}/gcc-gcc-6_2_0-release/build
WORKDIR ${BASE_DIR}/gcc-gcc-6_2_0-release/build

# configure gcc
RUN ../configure \
	--host=arm-linux-androideabi \
	--target=arm-linux-androideabi \
	--build=arm-linux-androideabi \
	--disable-option-checking \
 	--disable-multilib \
 	--disable-bootstrap \	
	CC=${CROSS_COMPILER}-gcc \
	CXX=${CROSS_COMPILER}-g++ \
	CFLAGS="-g -I -O2 -mandroid -mbionic -I${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9/include -I${SYSROOT}/usr/include/ --sysroot=${SYSROOT} -Wno-error -fPIE" \
	LDFLAGS="-L${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm/usr/lib -pie" \
	CPP=${CROSS_COMPILER}-cpp \
	CPPFLAGS="-I${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm/usr/include/" \
	AR=${CROSS_COMPILER}-ar

# build gcc
RUN make -j"$(nproc)"
RUN make install
RUN make distclean