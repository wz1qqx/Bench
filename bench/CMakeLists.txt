include(bench)

message(STATUS "BENCH_WITH_ARM:\t${BENCH_WITH_ARM}")

cc_binary(bench SRCS main.cc)