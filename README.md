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
checking for C compiler default output file name... 
configure: error: in `/gcc-for-arm/gcc-gcc-6_2_0-release/build':
configure: error: C compiler cannot create executables
See `config.log' for more details.
The command '/bin/sh -c ../configure 	--host=arm-linux-androideabi 	--target=arm-linux-androideabi 	--build=arm-linux-androideabi 	--disable-option-checking  	--disable-multilib  	--disable-bootstrap 	CC=${CROSS_COMPILE}gcc 	CXX=${CROSS_COMPILE}g++ 	CFLAGS="-g -I -O2 -mandroid -mbionic -I${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.9/include -I${SYSROOT}/usr/include/ --sysroot=${SYSROOT} -Wno-error -fPIE" 	LDFLAGS="-L${NDK_HOME}/platforms/android-15/arch-arm/usr/lib -pie" 	CPP=${CROSS_COMPILE}cpp 	CPPFLAGS="-I${NDK_HOME}/platforms/android-15/arch-arm/usr/include/" 	AR=${CROSS_COMPILE}ar' returned a non-zero code: 77
```

## Contact

Email, skype and hangout: paulo[AT]prsolucoes.com

