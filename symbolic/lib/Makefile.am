ACLOCAL_AMFLAGS=		-I m4
lib_LTLIBRARIES=		libsymbolicc++.la
libsymbolicc___la_CXXFLAGS=	-I include $(AM_CXXFLAGS)
libsymbolicc___la_LDFLAGS=	-version-info $(PACKAGE_VERSION) $(AM_LDFLAGS)

symbolicdir=			$(includedir)/symbolic

install-data-local:
	$(MKDIR_P) $(datadir)/doc
	$(INSTALL_DATA) README $(datadir)/doc/README.SymbolicC++
	$(INSTALL_DATA) doc/introsymb.pdf $(datadir)/doc/SymbolicC++.pdf

include_HEADERS= \
@INCLUDES@

symbolic_HEADERS= \
@SYMINCLUDES@

libsymbolicc___la_SOURCES= \
@SOURCES@
