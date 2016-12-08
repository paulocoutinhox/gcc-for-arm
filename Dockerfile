FROM ubuntu:16.04

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
	 unzip \
	 bison \
	 flex \
	 libmpc-dev \
	 g++

RUN apt-get clean

# base paths
ENV BASE_DIR=/gcc-for-arm
RUN mkdir -p $BASE_DIR

# download things here to prevent download everytime that Dockerfile is changed
RUN wget https://github.com/gcc-mirror/gcc/archive/gcc-6_2_0-release.zip -O $BASE_DIR/gcc-6_2_0-release.zip
RUN wget https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip -O $BASE_DIR/android-ndk-r13b-linux-x86_64.zip

# unpack gcc 6.2
RUN unzip $BASE_DIR/gcc-6_2_0-release.zip -d $BASE_DIR
RUN rm -rf $BASE_DIR/gcc-6_2_0-release.zip
ENV GCC_ROOT=$BASE_DIR/gcc-gcc-6_2_0-release

# if you want use android ndk compiler, uncomment these lines
# RUN unzip $BASE_DIR/android-ndk-r13b-linux-x86_64.zip -d $BASE_DIR
# RUN rm -rf $BASE_DIR/android-ndk-r13b-linux-x86_64.zip
# ENV NDK_ROOT=$BASE_DIR/android-ndk-r13b
# WORKDIR $NDK_ROOT/build/tools
# RUN ./make_standalone_toolchain.py --arch arm --install-dir $BASE_DIR/arm-toolchain
# ENV ARM_TOOLCHAIN=$BASE_DIR/arm-toolchain
# ENV PATH=$PATH:$ARM_TOOLCHAIN/bin
# ENV CC=$ARM_TOOLCHAIN/bin/arm-linux-androideabi-gcc
# ENV LD=$ARM_TOOLCHAIN/bin/arm-linux-androideabi-ld

# compile gcc 6.2
RUN rm -rf $BASE_DIR/gcc-gcc-6_2_0-release/build
RUN mkdir -p $BASE_DIR/gcc-gcc-6_2_0-release/build
WORKDIR $BASE_DIR/gcc-gcc-6_2_0-release/build

# configure gcc
RUN ../configure \
	--enable-languages=c,c++ \
	--disable-multilib \
	--disable-bootstrap \
	--target=arm-linux-androideabi \
	--build=arm-linux-androideabi \
	--host=arm-linux-androideabi
	
# build gcc
RUN make -j"$(nproc)"
RUN make install
RUN make distclean