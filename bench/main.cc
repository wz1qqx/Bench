#include <iostream>
#include <chrono>
#include <ctime> 
#include <sched.h>

int main (int argc, char** argv) {
    int cpu_id = atoi(argv[1]);
    cpu_set_t mask;
    CPU_ZERO(&mask);
    CPU_SET(cpu_id, &mask);
    int result = sched_setaffinity(0, sizeof(mask), &mask);
    //test fmla
    int times1 = 1000000000;
    auto start = std::chrono::system_clock::now();
    // Some computation here
    asm volatile (
        "mov x0, %0                \n"
        "1:                       \n"
        "fmla v2.4s, v1.4s, v0.s[0] \n"
        "fmla v3.4s, v4.4s, v0.s[1] \n"
        "fmla v5.4s, v6.4s, v0.s[2] \n"
        "fmla v7.4s, v8.4s, v0.s[3] \n"
        "fmla v2.4s, v1.4s, v9.s[0] \n"
        "fmla v3.4s, v4.4s, v9.s[1] \n"
        "fmla v5.4s, v6.4s, v9.s[2] \n"
        "fmla v7.4s, v8.4s, v9.s[3] \n"
        "fmla v2.4s, v1.4s, v10.s[0] \n"
        "fmla v3.4s, v4.4s, v10.s[1] \n"
        "fmla v5.4s, v6.4s, v10.s[2] \n"
        "fmla v7.4s, v8.4s, v10.s[3] \n"
        "fmla v2.4s, v1.4s, v11.s[0] \n"
        "fmla v3.4s, v4.4s, v11.s[1] \n"
        "fmla v5.4s, v6.4s, v11.s[2] \n"
        "fmla v7.4s, v8.4s, v11.s[3] \n"
        "subs x0, x0, #0x1          \n"
        "bne 1b                    \n"
        :"+r"(times1)
        :
        :"cc","memory","v0","v1","v2","v3","v4","v5","v6","v7","v8","v9","v10","v11","x0"
    );
    auto end = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed_seconds = end - start;
    std::time_t end_time = std::chrono::system_clock::to_time_t(end);
    std::cout << "fmla---finished computation at " << std::ctime(&end_time)
              << "elapsed time: " << elapsed_seconds.count() << "s"
              << std::endl;
    // test smla 
    // int times2 = 1000000000;
    // auto start2 = std::chrono::system_clock::now();
    // asm volatile (
    //     "mov x0, %0                \n"
    //     "1:                       \n"
    //     "smlal  v2.4s, v1.4h, v0.h[0] \n"
    //     "smlal2 v3.4s, v4.8h, v0.h[1] \n"
    //     "smlal  v5.4s, v6.4h, v0.h[2] \n"
    //     "smlal2 v7.4s, v8.8h, v0.h[3] \n"
    //     "smlal  v2.4s, v1.4h, v9.h[0] \n"
    //     "smlal2 v3.4s, v4.8h, v9.h[1] \n"
    //     "smlal  v5.4s, v6.4h, v9.h[2] \n"
    //     "smlal2 v7.4s, v8.8h, v9.h[3] \n"
    //     "smlal  v2.4s, v1.4h, v10.h[0] \n"
    //     "smlal2 v3.4s, v4.8h, v10.h[1] \n"
    //     "smlal  v5.4s, v6.4h, v10.h[2] \n"
    //     "smlal2 v7.4s, v8.8h, v10.h[3] \n"
    //     "smlal  v2.4s, v1.4h, v11.h[0] \n"
    //     "smlal2 v3.4s, v4.8h, v11.h[1] \n"
    //     "smlal  v5.4s, v6.4h, v11.h[2] \n"
    //     "smlal2 v7.4s, v8.8h, v11.h[3] \n"
    //     "subs x0, x0, #0x1          \n"
    //     "bne 1b                    \n"
    //     :"+r"(times2)
    //     :
    //     :"cc","memory","v0","v1","v2","v3","v4","v5","v6","v7","v8","v9","v10","v11","x0"
    // );
    // auto end2 = std::chrono::system_clock::now();
    // std::chrono::duration<double> elapsed_seconds_2 = end2 - start2;
    // std::time_t end2_time = std::chrono::system_clock::to_time_t(end2);
    // std::cout << "smla---finished computation at " << std::ctime(&end2_time)
    //           << "elapsed time: " << elapsed_seconds_2.count() << "s"
    //           << std::endl;
    // // test sdot
    // int times3 = 1000000000;
    // auto start3 = std::chrono::system_clock::now();
    // asm volatile (
    //     "mov x0, %0                \n"
    //     "1:                       \n"
    //     "sdot  v2.4s, v1.16b, v0.4b[0] \n"
    //     "sdot  v3.4s, v4.16b, v0.4b[1] \n"
    //     "sdot  v5.4s, v6.16b, v0.4b[2] \n"
    //     "sdot  v7.4s, v8.16b, v0.4b[3] \n"
    //     "sdot  v2.4s, v1.16b, v9.4b[0] \n"
    //     "sdot  v3.4s, v4.16b, v9.4b[1] \n"
    //     "sdot  v5.4s, v6.16b, v9.4b[2] \n"
    //     "sdot  v7.4s, v8.16b, v9.4b[3] \n"
    //     "sdot  v2.4s, v1.16b, v10.4b[0] \n"
    //     "sdot  v3.4s, v4.16b, v10.4b[1] \n"
    //     "sdot  v5.4s, v6.16b, v10.4b[2] \n"
    //     "sdot  v7.4s, v8.16b, v10.4b[3] \n"
    //     "sdot  v2.4s, v1.16b, v11.4b[0] \n"
    //     "sdot  v3.4s, v4.16b, v11.4b[1] \n"
    //     "sdot  v5.4s, v6.16b, v11.4b[2] \n"
    //     "sdot  v7.4s, v8.16b, v11.4b[3] \n"
    //     "subs x0, x0, #0x1          \n"
    //     "bne 1b                    \n"
    //     :"+r"(times3)
    //     :
    //     :"cc","memory","v0","v1","v2","v3","v4","v5","v6","v7","v8","v9","v10","v11","x0"
    // );
    // auto end3 = std::chrono::system_clock::now();
    // std::chrono::duration<double> elapsed_seconds_3 = end3 - start3;
    // std::time_t end3_time = std::chrono::system_clock::to_time_t(end3);
    // std::cout << "sdot---finished computation at " << std::ctime(&end3_time)
    //           << "elapsed time: " << elapsed_seconds_3.count() << "s"
    //           << std::endl;
    return 0;
}