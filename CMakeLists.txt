cmake_minimum_required(VERSION 3.10)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
set(BENCH_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(BENCH_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 11)

include(system)
include(functions)
include(os/common)

project(bench CXX C)
message(STATUS "CXX compiler: ${CMAKE_CXX_COMPILER}, version: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}, version: ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "AR tools: ${CMAKE_AR}")
message(STATUS "CMAKE GENERATOR: ${CMAKE_GENERATOR}")


################################ Exposed Configurations #######################################
bench_option(BENCH_WITH_ARM                      "Enable ARM in lite mode"                                              ON)
bench_option(BENCH_WITH_ARM82_FP16               "when compile with arm v8.2 fp16, it's ON."                            OFF)
bench_option(BENCH_WITH_ARM8_SVE2                "Enable SVE2 instructions in ARMv8."                                   OFF)
bench_option(BENCH_WITH_ARM82_INT8_SDOT          "when compile with arm v8.2 int8, it's ON."                            OFF)

# # x86 Simd configurations
# include(simd)

# CMAKE_BUILD_TYPE
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
if(NOT CMAKE_BUILD_TYPE)
  if(WIN32)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel" FORCE)
  else()
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING
      "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel" FORCE)
  endif()
endif()

include(backends/common)
add_subdirectory(bench)
