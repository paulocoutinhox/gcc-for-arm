# This is a attempt to compile GCC to run on Android (ARM)

Im trying compile the GCC and G++ to run inside Android to compile inside Android the **.c** and **.cpp** files.

## Instructions

> git clone git@github.com:prsolucoes/gcc-for-arm.git  
> cd gcc-for-arm  
> ./build.sh  

*Obs: You need docker to use it*

# Test

After build with success, you can execute:

> ./run.sh  

And inside the container, you can run:

> file [path-to-the-new-gcc]

And see if show ARM on file arch
  
 *Obs: You need docker to use it*

## Issues  

When i run the script "build.sh" it make everything but not build the GCC, see the error:

```
checking whether the C compiler works... configure: error: in `/gcc-for-arm/gcc-gcc-6_2_0-release/build':
configure: error: cannot run C compiled programs.
If you meant to cross compile, use `--host'.
See `config.log' for more details.
The command '/bin/sh -c ../configure 	--host=arm-linux-androideabi 	--target=arm-linux-androideabi 	--build=arm-linux-androideabi 	--disable-option-checking  	--disable-multilib  	--disable-bootstrap 	CC=${CROSS_COMPILER}-gcc 	CXX=${CROSS_COMPILER}-g++ 	CFLAGS="-g -I -O2 -mandroid -mbionic -I${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9/include -I${SYSROOT}/usr/include/ --sysroot=${SYSROOT} -Wno-error -fPIE" 	LDFLAGS="-L${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm/usr/lib -pie" 	CPP=${CROSS_COMPILER}-cpp 	CPPFLAGS="-I${NDK_HOME}/platforms/android-${ANDROID_API}/arch-arm/usr/include/" 	AR=${CROSS_COMPILER}-ar' returned a non-zero code: 1
```

## Some references

1. https://mssun.me/blog/build-android-toolchain.html
2. https://github.com/beurdouche/scripts/blob/master/build_gcc.sh
3. http://choccyhobnob.com/tutorials/gcc-6-on-raspberry-pi/
4. https://www.linux.com/blog/cross-compiling-arm
5. https://github.com/cmbant/docker-gcc-build/blob/master/Dockerfile
6. http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/

## Contact

Email, skype and hangout: paulo[AT]prsolucoes.com

