#!/usr/bin/env python
#use for tuning kmp best param for speic bin
#only for kmp: llvm-project/openmp, not support gnu omp
#2019.09.02 v0.1

import sys
import os
import time

#config here
os.system("adb connect 10.235.68.25:5555")
bin_exe = " /data/local/tmp/zhanghaolong/test_clang_omp.bin"

KMP_DEVICE_THREAD_LIMIT=[" ",
        " KMP_DEVICE_THREAD_LIMIT=4",
        " KMP_DEVICE_THREAD_LIMIT=8",
        " KMP_DEVICE_THREAD_LIMIT=16",
        " KMP_DEVICE_THREAD_LIMIT=32",
        " KMP_DEVICE_THREAD_LIMIT=64",
        " KMP_DEVICE_THREAD_LIMIT=128",
        " KMP_DEVICE_THREAD_LIMIT=256"
        ]

KMP_BLOCKTIME=[" ",
        " KMP_BLOCKTIME=0",
        " KMP_BLOCKTIME=50",
        " KMP_BLOCKTIME=200",
        " KMP_BLOCKTIME=500"
        ]
KMP_USE_YIELD=[" ",
        " KMP_USE_YIELD=0",
        " KMP_USE_YIELD=1"
        ]
KMP_LIBRARY=[" ",
        " KMP_LIBRARY=ACTIVE",
        " KMP_LIBRARY=PASSIVE"
        ]
KMP_MONITOR_STACKSIZE=[" ",
        " KMP_MONITOR_STACKSIZE=8K",
        " KMP_MONITOR_STACKSIZE=64K",
        " KMP_MONITOR_STACKSIZE=4M"
        ]
KMP_STACKSIZE=[" ",
        " KMP_STACKSIZE=8K",
        " KMP_STACKSIZE=64K",
        " KMP_STACKSIZE=4M"
        ]
#KMP_STACKPAD
OMP_NESTED=[" ",
        " OMP_NESTED=0",
        " OMP_NESTED=1"
        ]
OMP_NUM_THREADS=[" ",
        " OMP_NUM_THREADS=4",
        " OMP_NUM_THREADS=6",
        " OMP_NUM_THREADS=8",
        " OMP_NUM_THREADS=16",
        " OMP_NUM_THREADS=32", 
        " OMP_NUM_THREADS=64"
        ]
OMP_PLACES=[" ",
        " OMP_PLACES=threads",
        " OMP_PLACES=cores",
        " OMP_PLACES=sockets"
        #need omp support KMP_USE_HWLOC
        " OMP_PLACES=tiles",
        ]
KMP_TOPOLOGY_METHOD=[" ",
        " KMP_TOPOLOGY_METHOD=flat"
        ]
OMP_SCHEDULE=[" ",
        " OMP_SCHEDULE=dynamic",
        " OMP_SCHEDULE=guided",
        " OMP_SCHEDULE=trapezoidal",
        " OMP_SCHEDULE=static",
        " OMP_SCHEDULE=static_steal",
        " OMP_SCHEDULE=auto"
        ]
KMP_ATOMIC_MODE=[" ",
        " KMP_ATOMIC_MODE=0",
        " KMP_ATOMIC_MODE=1",
        " KMP_ATOMIC_MODE=2"
        ]
KMP_MALLOC_POOL_INCR=[" ",
        " KMP_MALLOC_POOL_INCR=4M",
        " KMP_MALLOC_POOL_INCR=10M",
        " KMP_MALLOC_POOL_INCR=20M", 
        " KMP_MALLOC_POOL_INCR=100M"]
KMP_ENABLE_TASK_THROTTLING=[" ",
        " KMP_ENABLE_TASK_THROTTLING=0",
        " KMP_ENABLE_TASK_THROTTLING=1"
        ]

#need omp support https://github.com/memkind/memkind
#detail check: llvm-project/openmp/runtime/src/kmp_alloc.cpp
OMP_ALLOCATOR=[" ",
        " OMP_ALLOCATOR=1",
        " OMP_ALLOCATOR=2",
        " OMP_ALLOCATOR=3",
        " OMP_ALLOCATOR=4",
        " OMP_ALLOCATOR=5",
        " OMP_ALLOCATOR=6",
        " OMP_ALLOCATOR=7",
        " OMP_ALLOCATOR=8"
        ]
KMP_AFFINITY=[" "
        " KMP_AFFINITY=verbose,granularity=fine,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=fine,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=default,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=default,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=thread,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=thread,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=core,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=core,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=package,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=package,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=node,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=node,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=group,proclist=[{0,1,2,3}],explicit",
        " KMP_AFFINITY=verbose,granularity=group,proclist=[{4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=fine,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=default,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=thread,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=core,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=package,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=node,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        " KMP_AFFINITY=verbose,granularity=package,proclist=[{0,1,2,3,4,5,6,7}],explicit",
        ]

all_check_type = [
        KMP_DEVICE_THREAD_LIMIT,
        KMP_BLOCKTIME,
        KMP_USE_YIELD,
        KMP_LIBRARY,
        KMP_MONITOR_STACKSIZE,
        KMP_STACKSIZE,
        OMP_NESTED,
        OMP_NUM_THREADS,
        OMP_PLACES,
        KMP_TOPOLOGY_METHOD,
        OMP_SCHEDULE,
        KMP_ATOMIC_MODE,
        KMP_MALLOC_POOL_INCR,
        KMP_ENABLE_TASK_THROTTLING,
        OMP_ALLOCATOR,
        KMP_AFFINITY,
        ]

final_best_args = []

def tuning(arg):
    for i in all_check_type:
        all_args = []
        for a in i:
            all_args.append(a)
        sub_find_best_args(all_args)

def sub_find_best_args(args):
    best_time = float("inf")
    best_args = ""
    for i in args:
        print(i)
        run_exe = "adb shell "
        run_exe = run_exe + "\""
        run_exe = run_exe + i
        run_exe = run_exe + bin_exe
        run_exe = run_exe + "\""
        start_time = time.time()
        os.system(run_exe)
        end_time = time.time()
        use_time = end_time - start_time
        print("use time: " + str(use_time))
        if use_time < best_time:
            best_time = use_time
            best_args = i
            print("--------------------------------tmp best args----------------------")
            print(use_time)
            print(best_args)
            print("-------------------------------------------------------------------")
    print("===============================================================")
    print("best args:" + best_args)
    print("===============================================================")
    final_best_args.append(best_args)

if __name__ == "__main__":
    tuning(sys.argv)
    print("test find best args")
    run_exe = "adb shell "
    run_exe = run_exe + "\""
    for i in final_best_args:
        run_exe = run_exe + i
    run_exe = run_exe + bin_exe
    run_exe = run_exe + "\""
    print(run_exe)
    start_time = time.time()
    os.system(run_exe)
    end_time = time.time()
    use_time = end_time - start_time
    print("use time: " + str(use_time))

    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    print("final best args")
    for i in final_best_args:
        print(i)
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
