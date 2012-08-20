#!/bin/sh

alias scp="echo scp"

VERSION=36

FILES="COPYING README ChangeLog doc examples headers lisp othercas"
DATE="$(date +%F)"

ZIPFILE=/tmp/SymbolicC++3-3.${VERSION}.zip
TARBALL=/tmp/SymbolicC++3-3.${VERSION}.tar.gz
LIBZIP=/tmp/SymbolicC++3-3.${VERSION}-lib.zip
LIBTARBALL=/tmp/SymbolicC++3-3.${VERSION}-lib.tar.gz
LIBDIR=/tmp/SymbolicC++3-3.${VERSION}

TOCOPY="${ZIPFILE} ${TARBALL} ${LIBZIP} ${LIBTARBALL}"

zip -9qr ${ZIPFILE} $FILES
tar czf ${TARBALL} $FILES

############ Library tarball ###############

rm -Rf ${LIBDIR}
cp -RL lib ${LIBDIR}
mkdir -p ${LIBDIR}/include/symbolic ${LIBDIR}/src
cp headers/*.h ${LIBDIR}/include

includes=
symincludes=
srcs=

for i in headers/*.h headers/symbolic/*.h; do
 base=${i##*/}
 hdr=${i##headers/}
 src=${base%h}cpp
 if [ "$hdr" !=  symbolicc++.h ]; then
  srcs="$srcs src/$src"
 fi
 echo Generating include/$hdr
 awk -f makeinclude.awk $i > ${LIBDIR}/include/$hdr
 echo Generating src/$src
 head -n 20 $i > ${LIBDIR}/src/$src
 if [ "${i##headers/symbolic/}" != "${i}" ]; then
  symincludes="$symincludes include/$hdr"
  echo '#include "symbolic/symbolicc++.h"' >> ${LIBDIR}/src/$src
 else
  includes="$includes include/$hdr"
  echo "#include \"$hdr\"" >> ${LIBDIR}/src/$src
 fi
 echo >> ${LIBDIR}/src/$src
 awk -f makesrc.awk $i >> ${LIBDIR}/src/$src
done

fmtscript() {
 fmt -r 70 78 | sed -e 's/@$//' -e t -e 's/$/ \\/'
}

echo $includes | fmtscript > ${LIBDIR}/includes.list.pre
echo $symincludes | fmtscript > ${LIBDIR}/symincludes.list.pre
echo $srcs | fmtscript > ${LIBDIR}/srcs.list.pre

for i in includes symincludes srcs; do
 sed '$s/\\$//' < ${LIBDIR}/${i}.list.pre > ${LIBDIR}/${i}.list
done

for i in lib/configure.ac lib/Makefile.am lib/CMakeLists.txt; do
 sed -e s/@VERSION@/${VERSION}/g \
     -e "/^@INCLUDES@\$/r${LIBDIR}/includes.list" -e /^@INCLUDES@\$/d \
     -e "/^@SYMINCLUDES@\$/r${LIBDIR}/symincludes.list" -e /^@SYMINCLUDES@\$/d \
     -e "/^@SOURCES@\$/r${LIBDIR}/srcs.list" -e /^@SOURCES@\$/d \
     < ${i} > ${LIBDIR}/${i##*/}
done

sed 's/\\$//' < ${LIBDIR}/CMakeLists.txt > ${LIBDIR}/CMakeLists.txt.fix
mv ${LIBDIR}/CMakeLists.txt.fix ${LIBDIR}/CMakeLists.txt

rm ${LIBDIR}/includes.list* ${LIBDIR}/symincludes.list* ${LIBDIR}/srcs.list*

cat /usr/pkg/share/aclocal/libtool.m4 \
    /usr/pkg/share/aclocal/ltoptions.m4 \
    /usr/pkg/share/aclocal/ltversion.m4 \
    /usr/pkg/share/aclocal/ltsugar.m4 \
    /usr/pkg/share/aclocal/lt~obsolete.m4 > ${LIBDIR}/aclocal.m4

(cd ${LIBDIR} && libtoolize && aclocal && automake -a && autoconf && cd .. && \
 tar chzf ${LIBTARBALL} ${LIBDIR##*/} && \
 zip -9qr ${LIBZIP} ${LIBDIR##*/})

#############################################

scp ${TOCOPY} issc.uj.ac.za:/srv/www/htdocs/issc/symbolic/sources/
rm -Rf ${LIBDIR}
