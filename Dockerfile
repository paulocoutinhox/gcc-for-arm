FROM ubuntu:latest

MAINTAINER Paulo Coutinho

# install dependencies
RUN apt-get update && apt-get install -y \
     build-essential \
     git \
	 python \
     wget \
	 nano \
	 curl \
	 unzip \
	 m4
	 
RUN apt-get clean

# versions
ENV GMP_VERSION=gmp-6.1.1
ENV MPFR_VERSION=mpfr-3.1.5
ENV MPC_VERSION=mpc-1.0.3
ENV ISL_VERSION=isl-0.16.1
ENV CLOOG_VERSION=cloog-0.18.1
ENV GCC_VERSION=gcc-6.2.0

# base paths
ENV BASE_DIR=/gcc-for-arm
ENV GCC_PREFIX=/gcc-for-arm/gcc-build
RUN mkdir -p ${BASE_DIR}
RUN mkdir -p ${GCC_PREFIX}

# download things here to prevent download everytime that Dockerfile is changed
RUN wget "ftp://ftp.gmplib.org/pub/$GMP_VERSION/${GMP_VERSION}.tar.bz2" -O ${BASE_DIR}/${GMP_VERSION}.tar.bz2
RUN wget "http://www.mpfr.org/mpfr-current/${MPFR_VERSION}.tar.gz" -O ${BASE_DIR}/${MPFR_VERSION}.tar.gz
RUN wget "ftp://ftp.gnu.org/gnu/mpc/${MPC_VERSION}.tar.gz" -O ${BASE_DIR}/${MPC_VERSION}.tar.gz
RUN wget "ftp://gcc.gnu.org/pub/gcc/infrastructure/${ISL_VERSION}.tar.bz2" -O ${BASE_DIR}/${ISL_VERSION}.tar.bz2
RUN wget "ftp://gcc.gnu.org/pub/gcc/infrastructure/${CLOOG_VERSION}.tar.gz" -O ${BASE_DIR}/${CLOOG_VERSION}.tar.gz
RUN wget "ftp://ftp.uvsq.fr/pub/gcc/releases/${GCC_VERSION}/${GCC_VERSION}.tar.bz2" -O ${BASE_DIR}/${GCC_VERSION}.tar.bz2

# android ndk
ENV ANDROID_API=15

RUN wget https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip -O ${BASE_DIR}/android-ndk-r13b-linux-x86_64.zip
RUN unzip ${BASE_DIR}/android-ndk-r13b-linux-x86_64.zip -d ${BASE_DIR}

ENV NDK_HOME=${BASE_DIR}/android-ndk-r13b
ENV NDK_GCC_VERSION=4.9

WORKDIR ${NDK_HOME}/build/tools
RUN ./make_standalone_toolchain.py --arch arm --install-dir ${BASE_DIR}/arm-toolchain
ENV ARM_TOOLCHAIN=${BASE_DIR}/arm-toolchain

ENV CROSS_COMPILER_PREFIX=${ARM_TOOLCHAIN}/bin/arm-linux-androideabi

ENV AR=${CROSS_COMPILER_PREFIX}-ar
ENV CC=${CROSS_COMPILER_PREFIX}-gcc
ENV CXX=${CROSS_COMPILER_PREFIX}-g++
ENV CPP=${CROSS_COMPILER_PREFIX}-cpp

ENV CONFIG_COMPILER_HOST=arm-android-eabi
ENV CONFIG_COMPILER_TARGET=arm-android-eabi
ENV CONFIG_COMPILER_BUILD=x86_64-linux-gnu

# ENV CROSS_COMPILER_PREFIX=${NDK_HOME}/toolchains/arm-linux-androideabi-${NDK_GCC_VERSION}/prebuilt/linux-x86_64/bin/arm-linux-androideabi
# ENV SYSROOT=${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm/usr

# ENV CONFIG_COMPILER_HOST=arm-android-eabi
# ENV CONFIG_COMPILER_TARGET=arm-android-eabi
# ENV CONFIG_COMPILER_BUILD=x86_64-linux-gnu

# ENV AR=${CROSS_COMPILER_PREFIX}-ar
# ENV CC=${CROSS_COMPILER_PREFIX}-gcc
# ENV CXX=${CROSS_COMPILER_PREFIX}-g++
# ENV CPP=${CROSS_COMPILER_PREFIX}-cpp
# ENV CXXPLUS="${NDK_HOME}/sources/cxx-stl/gnu-libstdc++/${NDK_GCC_VERSION}"
# ENV CXXCONFIGFLAGS="-I${CXXPLUS}/include -I{$CXXPLUS}/libs/armeabi/include"
# ENV CXXLIBPLUS="-L${CXXPLUS}/libs/armeabi"
# ENV CFLAGS="-I${NDK_HOME}/sources/android/support/include -I${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/include -I${SYSROOT}/include --sysroot=${SYSROOT} -Wno-error -fPIE"
# ENV CXXLAGS="-I${SYSROOT}/include --sysroot=${SYSROOT}"
# ENV CPPFLAGS="-I${SYSROOT}/include"
# ENV LDFLAGS="-L$SYSROOT/lib -pie"

# build GMP
WORKDIR ${BASE_DIR}
RUN tar xfjv "${GMP_VERSION}.tar.bz2"
RUN mkdir "${GMP_VERSION}/build"
WORKDIR "${GMP_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/gmp" \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

# build MPFR
WORKDIR ${BASE_DIR}
RUN tar xfvz "${MPFR_VERSION}.tar.gz"
RUN mkdir "${MPFR_VERSION}/build"
WORKDIR "${MPFR_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/mpfr" \
	--with-gmp="${GCC_PREFIX}/gmp" \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

# build MPC
WORKDIR ${BASE_DIR}
RUN tar xfvz "${MPC_VERSION}.tar.gz"
RUN mkdir "${MPC_VERSION}/build"
WORKDIR "${MPC_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/mpc" \
	--with-gmp="${GCC_PREFIX}/gmp" \
	--with-mpfr="${GCC_PREFIX}/mpfr" \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

# build ISL
WORKDIR ${BASE_DIR}
RUN tar xfvj "${ISL_VERSION}.tar.bz2"
RUN mkdir "${ISL_VERSION}/build"
WORKDIR "${ISL_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/isl" \
	--with-gmp-prefix="${GCC_PREFIX}/gmp" \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

# build CLOOG
WORKDIR ${BASE_DIR}
RUN tar xfvz "${CLOOG_VERSION}.tar.gz"
RUN mkdir "${CLOOG_VERSION}/build"
WORKDIR "${CLOOG_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/cloog" \
	--with-gmp-prefix="${GCC_PREFIX}/gmp" \
	--with-isl="${GCC_PREFIX}/isl" \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

# paths
ENV LD_LIBRARY_PATH=${GCC_PREFIX}/gmp/lib:${GCC_PREFIX}/mpfr/lib:${GCC_PREFIX}/mpc/lib:${GCC_PREFIX}/isl/lib:${GCC_PREFIX}/cloog/lib
ENV C_INCLUDE_PATH=${GCC_PREFIX}/gmp/include:${GCC_PREFIX}/mpfr/include:${GCC_PREFIX}/mpc/include:${GCC_PREFIX}/isl/include:${GCC_PREFIX}/cloog/include
ENV CPLUS_INCLUDE_PATH=${GCC_PREFIX}/gmp/include:${GCC_PREFIX}/mpfr/include:${GCC_PREFIX}/mpc/include:${GCC_PREFIX}/isl/include:${GCC_PREFIX}/cloog/include

# build GCC
WORKDIR ${BASE_DIR}
RUN tar xfvj "${GCC_VERSION}.tar.bz2"
RUN mkdir "${GCC_VERSION}/build"
WORKDIR "${GCC_VERSION}/build"
RUN ../configure \
	--prefix="${GCC_PREFIX}/gcc" \
	--with-gmp="${GCC_PREFIX}/gmp" \
	--with-mpfr="${GCC_PREFIX}/mpfr" \
	--with-mpc="${GCC_PREFIX}/mpc" \
	--with-isl="${GCC_PREFIX}/isl" \
	--with-cloog="${GCC_PREFIX}/cloog" \
	--enable-languages=c,c++ \
	--disable-multilib \
	--host=${CONFIG_COMPILER_HOST} \
 	--target=${CONFIG_COMPILER_TARGET} \
 	--build=${CONFIG_COMPILER_BUILD}

RUN make -j"$(nproc)"
RUN make install

CMD [bash]


# OLD

# RUN ../configure \
# 	--host=arm-android-eabi \
# 	--target=arm-android-eabi \
# 	--build=x86_64-linux-gnu \
# 	--disable-option-checking \
#  	--disable-multilib \
#  	--disable-bootstrap \
# 	--enable-languages=c,c++ \		
# 	AR=${CROSS_COMPILER}-ar \
# 	CC=${CROSS_COMPILER}-gcc \
# 	CXX=${CROSS_COMPILER}-g++ \
# 	CPP=${CROSS_COMPILER}-cpp \	
# 	CXXPLUS="${NDK_HOME}/sources/cxx-stl/gnu-libstdc++/${NDK_GCC_VERSION}" \
# 	CXXCONFIGFLAGS="-I${CXXPLUS}/include -I{$CXXPLUS}/libs/armeabi/include" \
# 	CXXLIBPLUS="-L${CXXPLUS}/libs/armeabi" \
# 	CFLAGS="-I${NDK_HOME}/sources/android/support/include -I${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/include -I${SYSROOT}/include --sysroot=${SYSROOT} -Wno-error -fPIE" \
# 	CXXLAGS="-I${SYSROOT}/include --sysroot=${SYSROOT}" \
# 	CPPFLAGS="-I${SYSROOT}/include" \
# 	LDFLAGS="-L$SYSROOT/lib -pie" \	
# 	--with-sysroot=$SYSROOT
