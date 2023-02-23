IF(EXISTS "/etc/issue")
    FILE(READ "/etc/issue" LINUX_ISSUE)
    IF(LINUX_ISSUE MATCHES "CentOS")
        SET(HOST_SYSTEM "centos")
    ELSEIF(LINUX_ISSUE MATCHES "Debian")
        SET(HOST_SYSTEM "debian")
    ELSEIF(LINUX_ISSUE MATCHES "Ubuntu")
        SET(HOST_SYSTEM "ubuntu")
    ELSEIF(LINUX_ISSUE MATCHES "Red Hat")
        SET(HOST_SYSTEM "redhat")
    ELSEIF(LINUX_ISSUE MATCHES "Fedora")
        SET(HOST_SYSTEM "fedora")
    ENDIF()

    STRING(REGEX MATCH "(([0-9]+)\\.)+([0-9]+)" HOST_SYSTEM_VERSION "${LINUX_ISSUE}")
ENDIF(EXISTS "/etc/issue")

IF(EXISTS "/etc/redhat-release")
    FILE(READ "/etc/redhat-release" LINUX_ISSUE)
    IF(LINUX_ISSUE MATCHES "CentOS")
        SET(HOST_SYSTEM "centos")
    ENDIF()
ENDIF(EXISTS "/etc/redhat-release")

IF(NOT HOST_SYSTEM)
    SET(HOST_SYSTEM ${CMAKE_SYSTEM_NAME})
ENDIF()

# query number of logical cores
CMAKE_HOST_SYSTEM_INFORMATION(RESULT CPU_CORES QUERY NUMBER_OF_LOGICAL_CORES)

MARK_AS_ADVANCED(HOST_SYSTEM CPU_CORES)

MESSAGE(STATUS "Found Project host system: ${HOST_SYSTEM}, version: ${HOST_SYSTEM_VERSION}")
MESSAGE(STATUS "Found Project host system's CPU: ${CPU_CORES} cores")
message(STATUS, "system.cmake run successed")
