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
checking host system type... Invalid configuration `none-unknown-linux-androideabi': machine `none-unknown-linux' not recognized
configure: error: /bin/bash ../../gmp/config.sub none-unknown-linux-androideabi failed
no
checking for strerror... make[1]: *** [configure-gmp] Error 1
Makefile:4539: recipe for target 'configure-gmp' failed
make[1]: *** Waiting for unfinished jobs....
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

