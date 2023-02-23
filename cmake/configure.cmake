if(NOT WITH_PYTHON)
    add_definitions(-DPADDLE_NO_PYTHON)
endif(NOT WITH_PYTHON)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SIMD_FLAG}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SIMD_FLAG}")

if (BENCH_WITH_ARM)
    add_definitions("-DBENCH_WITH_ARM")
endif()

if(BENCH_WITH_ARM82_FP16)
    add_definitions("-DENABLE_ARM_FP16")
endif()

if(BENCH_WITH_ARM82_FP16)
  add_definitions("-DBENCH_WITH_ARM82_FP16")
endif()

if(BENCH_WITH_ARM8_SVE2)
  add_definitions("-DBENCH_WITH_ARM8_SVE2")
endif()

message(STATUS, "configure.cmake run successed")
