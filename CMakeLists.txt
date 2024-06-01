cmake_minimum_required(VERSION 3.14)
project(utf8f VERSION 0.0.0)

cmake_policy(SET CMP0076 NEW)

enable_testing()
include(CTest)

include(CMakePrintHelpers)
enable_language(Fortran)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_subdirectory(src)
if(CMAKE_BUILD_TYPE MATCHES "Debug")
  add_subdirectory(test)
endif()
