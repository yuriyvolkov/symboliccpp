project(SymbolicC++ CXX)

cmake_minimum_required(VERSION 2.8)
INCLUDE(TestCXXAcceptsFlag)

option(STATICLIB "Build a static SymbolicC++ library" OFF)

set(SYMBOLIC_SOURCES
@SOURCES@
)

set(HEADERS
@INCLUDES@
)

set(SYMBOLIC_HEADERS
@SYMINCLUDES@
)

include_directories("${PROJECT_SOURCE_DIR}/include")

if (${STATICLIB})
 add_library(symbolicc++ STATIC ${SYMBOLIC_SOURCES})
else (${STATICLIB})
 add_library(symbolicc++ SHARED ${SYMBOLIC_SOURCES})
endif (${STATICLIB})

set_property(TARGET symbolicc++ PROPERTY VERSION 3.@VERSION@)

if (${CMAKE_COMPILER_IS_GNUCXX})
 CHECK_CXX_ACCEPTS_FLAG(-fno-elide-constructors NO_ELIDE_CONSTRUCTORS)
endif (${CMAKE_COMPILER_IS_GNUCXX})

if (${NO_ELIDE_CONSTRUCTORS})
 set_property(TARGET symbolicc++ PROPERTY COMPILE_FLAGS -fno-elide-constructors)
endif (${NO_ELIDE_CONSTRUCTORS})

 install(TARGETS symbolicc++ DESTINATION lib)
install(FILES ${HEADERS} DESTINATION include)
install(FILES ${SYMBOLIC_HEADERS} DESTINATION include/symbolic)
install(FILES README DESTINATION share/doc RENAME README.SymbolicC++)
install(FILES doc/introsymb.pdf DESTINATION share/doc RENAME SymbolicC++.pdf)
