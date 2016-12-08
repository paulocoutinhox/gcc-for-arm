# This is a attempt to compile GCC to run on Android (Armv7 and Armv6)

Im trying compile the GCC and G++ to run inside my Android and compile inside my Android the **.c** and **.cpp** files.

In this repository you have the Dockerfile that try use the Android NDK compiler to do it, but is commented now, because when i try, i got error:

```
checking for C compiler default output file name... 
configure: error: in `/gcc-for-arm/gcc-gcc-6_2_0-release/build':
configure: error: C compiler cannot create executables
See `config.log' for more details.
The command '/bin/sh -c ../configure 	--enable-languages=c,c++ 	--disable-multilib 	--disable-bootstrap 	--target=arm-linux-androideabi 	--build=arm-linux-androideabi 	--host=arm-linux-androideabi' returned a non-zero code: 77
```

If we need the NDK, only need uncomment that lines inside Dockerfile

So, when you run script "build.sh" the Dockerfile will try generate the GCC without NDK by default, but without success too.

```
Building GCC requires GMP 4.2+, MPFR 2.4.0+ and MPC 0.8.0+.
```

Im trying solve it now.

Can you help me with it?

Thanks.

Email, skype and hangout: paulo[AT]prsolucoes.com