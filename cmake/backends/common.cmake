# Add dependencies
include(generic)                # simplify cmake module
include(configure)              # add env configuration
if(BENCH_WITH_ARM)
  message(STATUS "Building for android devices")
  include(postproject)
  if(NOT LITE_ON_TINY_PUBLISH)
    # include(external/gflags)    # download, build, install gflags
    # include(external/gtest)     # download, build, install gtest
    include(ccache)
    # include(external/protobuf)  # download, build, install protobuf
  endif()
else()
  message(FATAL_ERROR "do not support this platform now!")
endif()

message(STATUS, "backends/common.cmake run successed")


