if(NOT ARM_TARGET_LANG STREQUAL "clang")
    # only clang need find ar tool
    return()
endif()

if(NOT EXISTS "${CMAKE_CXX_COMPILER}")
    message(ERROR "Can not find CMAKE_CXX_COMPILER ${CMAKE_CXX_COMPILER}")
endif()

get_filename_component(AR_PATH ${CMAKE_CXX_COMPILER} PATH)

find_file(AR_TOOL NAMES llvm-ar PATHS ${AR_PATH} NO_DEFAULT_PATH)

if(NOT AR_TOOL)
    message(ERROR "Failed to find AR_TOOL in ${AR_PATH}")
else()
    set(CMAKE_AR ${AR_TOOL})
    message(STATUS "Found CMAKE_AR : " ${CMAKE_AR})
endif()

message(STATUS, "findar.cmake run successed")
