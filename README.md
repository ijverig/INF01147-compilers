INF01147 - Compiladores
=======================

Stuff from my compilers class at UFRGS.

Steps for building and running the project
------------------------------
```
mkdir build
cd build
cmake -DETAPA_1=OFF -DETAPA_2=ON ..
make && echo "" && ./main < tests/e2/input/certa18.txt
```
