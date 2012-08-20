#!/bin/sh

FILES="COPYING ChangeLog doc examples headers lisp othercas"
DATE="$(date +%F)"
VERSION="$(awk -f getversion.awk autoconf/configure.ac)"

ZIPFILE=/tmp/SymbolicC++3-${VERSION}.zip
TARBALL=/tmp/SymbolicC++3-${VERSION}.tar.gz
ACTARBALL=/tmp/SymbolicC++3-${VERSION}-ac.tar.gz
ACDIR=/tmp/SymbolicC++3-${VERSION}
VCZIP=/tmp/SymbolicC++3-${VERSION}-vc.zip
VCDIR=/tmp/SymbolicC++3-${VERSION}-vc

TOCOPY="${ZIPFILE} ${TARBALL} ${ACTARBALL} ${VCZIP}"

zip -9qr ${ZIPFILE} $FILES
tar czf ${TARBALL} $FILES

############ Autoconf tarball ###############

rm -Rf ${ACDIR}
cp -RL autoconf ${ACDIR}
mkdir -p ${ACDIR}/include/symbolic ${ACDIR}/src
cp headers/*.h ${ACDIR}/include

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
 awk -f makeinclude.awk $i > ${ACDIR}/include/$hdr
 echo Generating src/$src
 head -n 20 $i > ${ACDIR}/src/$src
 if [ "${i##headers/symbolic/}" != "${i}" ]; then
  symincludes="$symincludes include/$hdr"
  echo '#include "symbolic/symbolicc++.h"' >> ${ACDIR}/src/$src
 else
  includes="$includes include/$hdr"
  echo "#include \"$hdr\"" >> ${ACDIR}/src/$src
 fi
 echo >> ${ACDIR}/src/$src
 awk -f makesrc.awk $i >> ${ACDIR}/src/$src
done


cat > ${ACDIR}/Makefile.am << "EOM"
ACLOCAL_AMFLAGS=		-I m4
lib_LTLIBRARIES=		libsymbolicc++.la
libsymbolicc___la_CXXFLAGS=	-I include $(AM_CXXFLAGS)
libsymbolicc___la_LDFLAGS=	-version-info $(PACKAGE_VERSION) $(AM_LDFLAGS)

symbolicdir=			$(includedir)/symbolic

install-data-local:
	$(MKDIR_P) $(datadir)/doc
	$(INSTALL_DATA) README $(datadir)/doc/README.SymbolicC++
	$(INSTALL_DATA) doc/introsymb.pdf $(datadir)/doc/SymbolicC++.pdf
EOM
printf 'include_HEADERS=\n%s@\n' "$includes" \
 | fmt -r 70 78 | sed -e 's/@$//' -e t -e 's/$/ \\/' >> ${ACDIR}/Makefile.am
echo >> ${ACDIR}/Makefile.am
printf 'symbolic_HEADERS=\n%s@\n' "$symincludes" \
 | fmt -r 70 78 | sed -e 's/@$//' -e t -e 's/$/ \\/' >> ${ACDIR}/Makefile.am
echo >> ${ACDIR}/Makefile.am
printf 'libsymbolicc___la_SOURCES=\n%s@\n' "$srcs" \
 | fmt -r 70 78 | sed -e 's/@$//' -e t -e 's/$/ \\/' >> ${ACDIR}/Makefile.am

cat /usr/pkg/share/aclocal/libtool.m4 \
    /usr/pkg/share/aclocal/ltoptions.m4 \
    /usr/pkg/share/aclocal/ltversion.m4 \
    /usr/pkg/share/aclocal/ltsugar.m4 \
    /usr/pkg/share/aclocal/lt~obsolete.m4 > ${ACDIR}/aclocal.m4

(cd ${ACDIR} && libtoolize && aclocal && automake -a && autoconf && cd .. && \
 tar chzf ${ACTARBALL} SymbolicC++3-${VERSION})

############ Visual C++ ZIP #################

mkdir -p ${VCDIR}
cp -R ChangeLog COPYING doc autoconf/README ${ACDIR}/include ${ACDIR}/src \
      vc/SymbolicC++3 ${VCDIR}/

(cd ${VCDIR} && zip -9qr ${VCZIP} .)

#############################################

scp ${TOCOPY} issc.uj.ac.za:/srv/www/htdocs/issc/symbolic/sources/
rm -Rf ${ACDIR} ${VCDIR}
