# To build an executable binary file from some source files and
# dependent libraries:
#
#   cc_binary(example SRCS main.cc something.cc DEPS example1 example2)
#
# including binary directory for generated headers.
include_directories(${CMAKE_CURRENT_BINARY_DIR})

if(NOT APPLE)
  if(NOT QNX)
    set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE} -ldl")
  endif()
  if(NOT ANDROID AND NOT QNX)
    set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE} -lrt")
  endif()
endif(NOT APPLE)

set_property(GLOBAL PROPERTY FLUID_MODULES "")
# find all fluid modules is used for paddle fluid static library
# for building inference libs
function(find_fluid_modules TARGET_NAME)
  get_filename_component(__target_path ${TARGET_NAME} ABSOLUTE)
  string(REGEX REPLACE "^${PADDLE_SOURCE_DIR}/" "" __target_path ${__target_path})
  string(FIND "${__target_path}" "lite" pos)
  if((pos GREATER 0) OR (pos EQUAL 0))
    get_property(fluid_modules GLOBAL PROPERTY FLUID_MODULES)
    set(fluid_modules ${fluid_modules} ${TARGET_NAME})
    set_property(GLOBAL PROPERTY FLUID_MODULES "${fluid_modules}")
  endif()
endfunction(find_fluid_modules)

function(common_link TARGET_NAME)
  if (WITH_PROFILER)
    target_link_libraries(${TARGET_NAME} gperftools::profiler)
  endif()

  if (WITH_JEMALLOC)
    target_link_libraries(${TARGET_NAME} jemalloc::jemalloc)
  endif()
endfunction()

function(cc_binary TARGET_NAME)
  set(options "")
  set(oneValueArgs "")
  set(multiValueArgs SRCS DEPS)
  cmake_parse_arguments(cc_binary "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  add_executable(${TARGET_NAME} ${cc_binary_SRCS})
  if(cc_binary_DEPS)
    target_link_libraries(${TARGET_NAME} ${cc_binary_DEPS})
    add_dependencies(${TARGET_NAME} ${cc_binary_DEPS})
    common_link(${TARGET_NAME})
  endif()
  get_property(os_dependency_modules GLOBAL PROPERTY OS_DEPENDENCY_MODULES)
  target_link_libraries(${TARGET_NAME} ${os_dependency_modules})
  find_fluid_modules(${TARGET_NAME})
endfunction(cc_binary)

message(STATUS, "generic.cmake run successed")
