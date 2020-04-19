set(CMAKE_CONFIGURATION_TYPES "Release;RelWithDebInfo;Debug" CACHE STRING "Build type selections" FORCE)

include(CheckFortranCompilerFlag)

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    add_compile_options(/arch:native)
    string(APPEND CMAKE_Fortran_FLAGS " /stand:f18 /traceback /warn /heap-arrays")
  else()
    add_compile_options(-march=native)
    string(APPEND CMAKE_Fortran_FLAGS " -stand f18 -traceback -warn -heap-arrays")
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native -Wall -Wextra)
  string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")
  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -fcheck=all -Werror=array-bounds")

  check_fortran_compiler_flag(-std=f2018 f18flag)
  if(f18flag)
    string(APPEND CMAKE_Fortran_FLAGS " -std=f2018")
  endif()

  if(CMAKE_Fortran_COMPILER_VERSION VERSION_EQUAL 9.3.0)
    # makes a lot of spurious warnngs on alloctable scalar character
    string(APPEND CMAKE_Fortran_FLAGS " -Wno-maybe-uninitialized")
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  string(APPEND CMAKE_Fortran_FLAGS " -C -Mdclchk")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)
  string(APPEND CMAKE_Fortran_FLAGS " -W")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL NAG)
  string(APPEND CMAKE_Fortran_FLAGS " -f2018 -u -C=all")
endif()

include(CheckFortranSourceCompiles)
check_fortran_source_compiles("implicit none (type, external); end" f2018impnone SRC_EXT f90)
if(NOT f2018impnone)
  message(FATAL_ERROR "Compiler does not support Fortran 2018 implicit none (type, external): ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
endif()
