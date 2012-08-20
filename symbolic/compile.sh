#!/bin/sh

if [ $# = 0 ]; then
 set lisp/*.cpp examples/*.cpp
fi
 
srcdir="$PWD"
cd /tmp

for i in "$@"; do
 files="$files ${srcdir}/$i"
done

#for i in "${srcdir}"/lisp/*.cpp "${srcdir}"/examples/*.cpp; do
for i in $files; do
 c++ -o sym -I "${srcdir}"/headers -I "${srcdir}"/headers/symbolic "$i"
done
