#!/usr/bin/env python3
#zhanghaolong v0.1

import os
import sys

def convert():
    print()
    with open(sys.argv[1]) as l:
        lines = l.readlines()

    pack_args = []
    path = ''
    arguments = []
    find_path = False
    for line in lines:
        f = line.strip()
        if f.find(" -o ") >= 0  and f.find(" -c ") >= 0:
            print("find handle args line:")
            arguments = f.split()
            if find_path:
                tmp_d = {'arguments':arguments, 'path':path}
                pack_args.append(tmp_d)
                find_path = False
            else:
                print("ERR: issue happended, do not find path")
                exit(-1)
        elif f.find("cd ") >= 0 and f.find(" && ") >= 0:
            print("find path line:")
            path = line[f.find("cd ") + 3: f.find(" && ")]
            find_path = True
        else:
            print("find strip line:")
        print(f)

    #create compile_commands.json
    jason_f = "compile_commands.json"
    with open(jason_f, "w") as file:
        file.write("[\n")

        pack_end = pack_args[-1]
        for i in pack_args:
            #print(i)
            file.write("    {\n")
            file.write("        \"arguments\": [\n")
            args_end = i['arguments'][-1]
            for args in i['arguments']:
                if args == args_end:
                    file.write("             \"%s\"\n" % args.replace('\'', '').replace('\"', '').replace(')', ''))
                else:
                    file.write("             \"%s\",\n" % args.replace('\'', '').replace('\"', '').replace(')', ''))
            file.write("        ],\n")
            file.write("        \"directory\": \"%s\",\n" % i['path'])
            file.write("        \"file\": \"%s\"\n" % i['arguments'][-3])
            if i == pack_end:
                file.write("    }\n")
            else:
                file.write("    },\n")

        file.write("]\n")
    print("")
    print("")
    print("")
    print("success create compile_commands file: compile_commands.json")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print('ERR: need a bazel build log')
        print('HOW to create a  bazel log:')
        print('add string: -s 2>&1 |tee  bazel_build.log')
        print('eg:')
        print('old bazel build command is: bazel ....')
        print('new bazel build command is: bazel .... -s 2>&1 |tee  bazel_build.log')
        print('WARMING: may need a full build, which means need clear project bazel cache dir firstly')
        exit(-1)
    convert()
