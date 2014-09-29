INF01147 - Compiladores
=======================

Stuff from my compilers class at UFRGS.

Steps for building and running the project
------------------------------
```
mkdir build
cd build
cmake -DETAPA_1=OFF -DETAPA_2=OFF -DETAPA_3=ON ..
make && echo "" && ctest -R e3
```

See the results in build/tests/e3/output/
