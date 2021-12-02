CCLS
====

```bash
# clone my fork
git clone https://github.com/brenns10/ccls
pacman -S base-devel clang llvm rapidjson
cmake -Bbuild
cd build
make -jN
cp ccls ~/.local/bin/
```
