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
 /gcc-for-arm/arm-toolchain/bin/arm-linux-androideabi-gcc -c -DHAVE_CONFIG_H -g -O2  -I. -I../../libiberty/../include  -W -Wall -Wwrite-strings -Wc++-compat -Wstrict-prototypes -pedantic  -D_GNU_SOURCE -fPIC ../../libiberty/getpagesize.c -o pic/getpagesize.o; \
else true; fi
../../libiberty/getpagesize.c:64:1: error: redefinition of 'getpagesize'
 getpagesize (void)
 ^
In file included from ../../libiberty/getpagesize.c:34:0:
/gcc-for-arm/arm-toolchain/sysroot/usr/include/unistd.h:171:23: note: previous definition of 'getpagesize' was here
 static __inline__ int getpagesize(void) {
                       ^
Makefile:829: recipe for target 'getpagesize.o' failed
make[2]: *** [getpagesize.o] Error 1
make[2]: Leaving directory '/gcc-for-arm/gcc-6.2.0/build/libiberty'
Makefile:7458: recipe for target 'all-libiberty' failed
/bin/bash ./libtool --tag=CC   --mode=compile /gcc-for-arm/arm-toolchain/bin/arm-linux-androideabi-gcc -DHAVE_CONFIG_H -I. -I../../libbacktrace  -I ../../libbacktrace/../include -I ../../libbacktrace/../libgcc -I ../libgcc  -funwind-tables -frandom-seed=fileline.lo -W -Wall -Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Wold-style-definition -Wmissing-format-attribute -Wcast-qual  -g -O2 -c -o fileline.lo ../../libbacktrace/fileline.c
make[1]: *** [all-libiberty] Error 2
make[1]: *** Waiting for unfinished jobs....
```

*You can see the full log inside "contents/build.log"*

## Some references

1. https://mssun.me/blog/build-android-toolchain.html
2. https://github.com/beurdouche/scripts/blob/master/build_gcc.sh
3. http://choccyhobnob.com/tutorials/gcc-6-on-raspberry-pi/
4. https://www.linux.com/blog/cross-compiling-arm
5. https://github.com/cmbant/docker-gcc-build/blob/master/Dockerfile
6. http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/

## Contact

Email, skype and hangout: paulo[AT]prsolucoes.com

