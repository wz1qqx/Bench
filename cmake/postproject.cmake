if(NOT BENCH_WITH_ARM)
    return()
endif()
include(CheckCXXCompilerFlag)
if(ANDROID)
    include(findar)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -llog -fPIC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -llog -fPIC")
    if(BENCH_WITH_ARM82_FP16)
        if(${ANDROID_NDK_MAJOR})
            if(${ANDROID_NDK_MAJOR} GREATER "17")
                if (${ARM_TARGET_ARCH_ABI} STREQUAL "armv8")
                  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -march=armv8.2-a+fp16+nolse")
                  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.2-a+fp16+nolse")
                elseif(${ARM_TARGET_ARCH_ABI} STREQUAL "armv7")
                  if(${ANDROID_NDK_MAJOR} GREATER "21")
                    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8 -mfloat-abi=softfp")
                    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8 -mfloat-abi=softfp")
                  else()
                    # suggested to use ndk r22 or newer version to be compatible with armv7 fp16 intrinsic func compilation
                    message(FATAL_ERROR "NDK VERSION: ${ANDROID_NDK_MAJOR}, however it must be greater than 21 when arm v7 fp16 is ON")
                  endif()
                endif()
            else()
                message(FATAL_ERROR "NDK VERSION: ${ANDROID_NDK_MAJOR}, however it must be greater than 17 when arm fp16 is ON")
            endif()
        endif()
    endif()

    if(BENCH_WITH_ARM8_SVE2)
        if ((ARM_TARGET_ARCH_ABI STREQUAL "armv8"))
          if (${ANDROID_NDK_MAJOR})
            if(${ANDROID_NDK_MAJOR} GREATER_EQUAL "23")
                set(CMAKE_C_FLAGS    "${CMAKE_C_FLAGS} -march=armv8.2-a+sve2+fp16+dotprod+f32mm+i8mm+nolse")
                set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -march=armv8.2-a+sve2+fp16+dotprod+f32mm+i8mm+nolse")
            else()
                message(FATAL_ERROR "NDK VERSION: ${ANDROID_NDK_MAJOR}, however it must be greater equal 23 when sve2 is ON")
            endif()
          endif()
        else()
            message(FATAL_ERROR "The arm_abi is ${ARM_TARGET_ARCH_ABI}, the arm_abi must be armv8 when sve2 is ON")
        endif()
    endif()

    set(REMOVE_ATOMIC_GCC_SYMBOLS "-Wl,--exclude-libs,libatomic.a -Wl,--exclude-libs,libgcc.a")
    set(CMAKE_SHARED_LINKER_FLAGS "${REMOVE_ATOMIC_GCC_SYMBOLS} ${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS "${REMOVE_ATOMIC_GCC_SYMBOLS} ${CMAKE_MODULE_LINKER_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${REMOVE_ATOMIC_GCC_SYMBOLS} ${CMAKE_EXE_LINKER_FLAGS}")

    # Only the libunwind.a from clang(with libc++) provide C++ exception handling support for 32-bit ARM
    # Refer to https://android.googlesource.com/platform/ndk/+/master/docs/BuildSystemMaintainers.md#Unwinding
    if (ARM_TARGET_LANG STREQUAL "clang" AND ARM_TARGET_ARCH_ABI STREQUAL "armv7" AND ANDROID_STL_TYPE MATCHES "^c\\+\\+_")
        set(REMOVE_UNWIND_SYMBOLS "-Wl,--exclude-libs,libunwind.a")
        set(CMAKE_SHARED_LINKER_FLAGS "${REMOVE_UNWIND_SYMBOLS} ${CMAKE_SHARED_LINKER_FLAGS}")
        set(CMAKE_MODULE_LINKER_FLAGS "${REMOVE_UNWIND_SYMBOLS} ${CMAKE_MODULE_LINKER_FLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS "${REMOVE_UNWIND_SYMBOLS} ${CMAKE_EXE_LINKER_FLAGS}")
    endif()
endif()

if(ARMLINUX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    if(ARMLINUX_ARCH_ABI STREQUAL "armv8")
        set(CMAKE_CXX_FLAGS "-march=armv8-a ${CMAKE_CXX_FLAGS}")
        set(CMAKE_C_FLAGS "-march=armv8-a ${CMAKE_C_FLAGS}")
        message(STATUS "NEON is enabled on arm64-v8a")
        if (LITE_WITH_ARM82_FP16)
          set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.2-a+fp16")
          set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -march=armv8.2-a+fp16")
        endif()
    endif()

    if(ARMLINUX_ARCH_ABI STREQUAL "armv7")
        set(CMAKE_CXX_FLAGS "-march=armv7-a -mfloat-abi=softfp -mfpu=neon ${CMAKE_CXX_FLAGS}")
        set(CMAKE_C_FLAGS "-march=armv7-a -mfloat-abi=softfp -mfpu=neon ${CMAKE_C_FLAGS}")
        message(STATUS "NEON is enabled on arm-v7a with softfp")
        if (LITE_WITH_ARM82_FP16)
          set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8")
          set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8")
        endif()
    endif()

    if(ARMLINUX_ARCH_ABI STREQUAL "armv7hf")
        set(CMAKE_CXX_FLAGS "-march=armv7-a -mfloat-abi=hard -mfpu=neon ${CMAKE_CXX_FLAGS}")
        set(CMAKE_C_FLAGS "-march=armv7-a -mfloat-abi=hard -mfpu=neon ${CMAKE_C_FLAGS}" )
        message(STATUS "NEON is enabled on arm-v7a with hard float")
        if (LITE_WITH_ARM82_FP16)
          set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8")
          set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -march=armv8.2-a+fp16 -mfpu=neon-fp-armv8")
        endif()
    endif()
endif()

function(check_linker_flag)
    foreach(flag ${ARGN})
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${flag}")
        check_cxx_compiler_flag("" out_var)
        if(${out_var})
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${flag}")
        endif()
    endforeach()
    set(CMAKE_SHARED_LINKER_FLAGS ${CMAKE_SHARED_LINKER_FLAGS} PARENT_SCOPE)
endfunction()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
if(ARM_TARGET_LANG STREQUAL "clang")
    # note(ysh329): fix slow compilation for arm cpu, 
    #               and abnormal exit compilation for opencl due to lots of warning
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-inconsistent-missing-override -Wno-return-type")
endif()

message(STATUS "ANDROID_NDK_MAJOR: ${ANDROID_NDK_MAJOR}")

if (CMAKE_CXX_FLAGS)
    string(REGEX REPLACE " \\-g " " " CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
endif()

if (CMAKE_C_FLAGS)
    string(REGEX REPLACE " \\-g " " " CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
endif ()    

message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")

# third party cmake args
# for dependency project compile args, like gflags and glog eto
set(CROSS_COMPILE_CMAKE_ARGS
    "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}"
    "-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}") 
if(ANDROID)
    set(CROSS_COMPILE_CMAKE_ARGS ${CROSS_COMPILE_CMAKE_ARGS}
        "-DCMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}"
        "-DCMAKE_ANDROID_NDK=${CMAKE_ANDROID_NDK}"
        "-DCMAKE_ANDROID_STL_TYPE=${CMAKE_ANDROID_STL_TYPE}"
        "-DANDROID_ABI=${CMAKE_ANDROID_ARCH_ABI}"
        "-DANDROID_TOOLCHAIN=${ARM_TARGET_LANG}"
        "-DANDROID_STL=${CMAKE_ANDROID_STL_TYPE}"
        "-DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}"
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_ANDROID_NDK}/build/cmake/android.toolchain.cmake"
        "-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=${CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION}"
        "-DANDROID_PLATFORM=android-${ANDROID_NATIVE_API_LEVEL}"
        "-D__ANDROID_API__=${ANDROID_NATIVE_API_LEVEL}"
        )
endif()

message(STATUS, "postproject.cmake run successed")
