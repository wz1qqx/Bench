cmake_minimum_required(VERSION 3.10)

if(BENCH_WITH_ARM)
  set(ARM_TARGET_OS_LIST "android" "armlinux" "ios" "ios64" "armmacos" "qnx")
  set(ARM_TARGET_ARCH_ABI_LIST "armv8" "armv7" "armv7hf" "arm64-v8a" "armeabi-v7a")
  set(ARM_TARGET_LANG_LIST "gcc" "clang")
  set(ARM_TARGET_LIB_TYPE_LIST "static" "shared")

  # OS check
  if(NOT DEFINED ARM_TARGET_OS)
    set(ARM_TARGET_OS "android")
  else()
    if(NOT ARM_TARGET_OS IN_LIST ARM_TARGET_OS_LIST)
      message(FATAL_ERROR "ARM_TARGET_OS should be one of ${ARM_TARGET_OS_LIST}")
    endif()
  endif()

  # ABI check
  if(NOT DEFINED ARM_TARGET_ARCH_ABI)
    set(ARM_TARGET_ARCH_ABI "armv8")
  else()
    if(NOT ARM_TARGET_ARCH_ABI IN_LIST ARM_TARGET_ARCH_ABI_LIST)
      message(FATAL_ERROR "ARM_TARGET_ARCH_ABI should be one of ${ARM_TARGET_ARCH_ABI_LIST}")
    endif()
  endif()
   
  # Toolchain check
  if(NOT DEFINED ARM_TARGET_LANG)
    set(ARM_TARGET_LANG "gcc")
  else()
    if(NOT ARM_TARGET_LANG IN_LIST ARM_TARGET_LANG_LIST)
      message(FATAL_ERROR "ARM_TARGET_LANG should be one of ${ARM_TARGET_LANG_LIST}")
    endif()
  endif()

  # Target lib check
  if(NOT DEFINED ARM_TARGET_LIB_TYPE)
    set(ARM_TARGET_LIB_TYPE "static")
  else()
    if(NOT ARM_TARGET_LIB_TYPE IN_LIST ARM_TARGET_LIB_TYPE_LIST)
      message(FATAL_ERROR "ARM_TARGET_LIB_TYPE should be one of ${ARM_TARGET_LIB_TYPE_LIST}")
    endif()
  endif()

  if(ARM_TARGET_LANG STREQUAL "gcc")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto")
  else()
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -flto=thin")
  endif()

  message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
  message(STATUS "CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")

  # OS settings
  if(ARM_TARGET_OS STREQUAL "android")
    include(os/android)
  endif()
  if(ARM_TARGET_OS STREQUAL "armlinux")
    include(os/armlinux)
  endif()

  # Detect origin host toolchain
  set(HOST_C_COMPILER $ENV{CC})
  set(HOST_CXX_COMPILER $ENV{CXX})
  if(IOS OR ARMMACOS)
    set(default_cc clang)
    set(default_cxx clang++)
  else()
    set(default_cc gcc)
    set(default_cxx g++)
  endif()
  if(NOT HOST_C_COMPILER)
    message(STATUS "cant Found host C compiler by ENV")
    find_program(HOST_C_COMPILER NAMES ${default_cc} PATH
      /usr/bin
      /usr/local/bin)
  endif()
  if(NOT HOST_CXX_COMPILER)
    message(STATUS "cant Found host CXX compiler by ENV")
    find_program(HOST_CXX_COMPILER NAMES ${default_cxx} PATH
      /usr/bin
      /usr/local/bin)
  endif()
  if(NOT HOST_C_COMPILER OR NOT EXISTS ${HOST_C_COMPILER})
    message(FATAL_ERROR "Cannot find host C compiler. export CC=/path/to/cc")
  endif()
  if(NOT HOST_CXX_COMPILER OR NOT EXISTS ${HOST_CXX_COMPILER})
    message(FATAL_ERROR "Cannot find host CXX compiler. export CXX=/path/to/cxx")
  endif()
  message(STATUS "Found host C compiler: " ${HOST_C_COMPILER})
  message(STATUS "Found host CXX compiler: " ${HOST_CXX_COMPILER})

  # Build type
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Default use Release in android" FORCE)
  endif()
  
  message(STATUS "Lite ARM Compile ${ARM_TARGET_OS} with ${ARM_TARGET_ARCH_ABI} ${ARM_TARGET_LANG}")
endif()

message(STATUS, "os/common.cmake run successed")
