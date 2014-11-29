INF01147 - Compiladores
=======================

Stuff from my compilers class at UFRGS.

Steps for building and running the project
------------------------------
```
mkdir build
cd build
cmake -DETAPA_1=OFF -DETAPA_2=OFF -DETAPA_3=OFF -DETAPA_4=ON ..
make && echo "" && ctest -R e4
```
