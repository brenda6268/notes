# cross compiling on android


wp_id: 536
Status: publish
Date: 2017-05-29 13:27:00
Modified: 2017-05-29 13:27:00


basic knowledge
------

first, we need a cross compiler, which you can download from the source or somewhere.

second, when we use gcc to build stuff, actually we are implicitly linking to the stdlib of c, if we are cross compiling programs for another platform, then we need another platform's filesystem to be accessible to us. However, we only need the target's /usr directory, because that's where the header files lives in. 

we place target's header files in a directory called *sysroot*, and gcc supports the argument `--sysroot`

gcc config parameters
------

```
|options  | explaination                                    |
|---------|-------------------------------------------------|
|--build  |the machine which you build on                   |
|--host	  |the machine which your binary will be running on |
|--target |the machine that GCC will produce code for       |

|--build |--host |--target|result |
|--------|-------|--------|-------|
|-	 |-	 | -      |native |
|-	 |-      | x      |cross complie|
```

`LDFLAGS="$LDFLAGS -m32 ?`
Argument `--target` makes sense only when building compiler (e.g. GCC).


How to
------

Let's assume you have directory called ~/x-compile

1. You have your tool-chain installed, that it is the correct tool-chain and the PATH environment variable is correctly set, so that the cross-compiler and all other cross-tools binaries can be called from any folder.
2. You have the sysroot installed in ~/x-compile/sysroot
3. Your code depends on a library for which you have the source code in ~/x-compile/depsrc/
4. You have the source code to be cross-compiled in ~/x-compile/src


1. compile you dependency lib, if your dependency lib don't need stdlib

```
./configure CC=arm-linux-gnueabihf-gcc --prefix=~/x-compile/deps --host=arm-linux-gnueabihf
make
make install
```

if your dependency needs system libs, then you need `--sysroot` as below

2. compile your program

compile python on android
------

在安卓上编译python

compiling 2.7.2

https://mdqinc.com/blog/2011/09/cross-compiling-python-for-android/

another tutorial

http://www.srplab.com/en/files/others/compile/cross_compiling_python_for_android.html

best tutorial

http://joaoventura.net/blog/2014/python-android-5/


Reference
------

http://www.fabriziodini.eu/posts/cross_compile_tutorial/
https://landley.net/writing/docs/cross-compiling.html
http://stackoverflow.com/questions/5139403/whats-the-difference-of-configure-option-build-host-and-target  

very confusing, the second answer is better