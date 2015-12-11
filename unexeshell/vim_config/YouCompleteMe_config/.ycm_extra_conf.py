# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

import os
import ycm_core

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wc++98-compat',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',
# You 100% do NOT need -DUSE_CLANG_COMPLETER in your flags; only the YCM
# source code needs it.
'-DUSE_CLANG_COMPLETER',
# THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
# language to use when compiling headers. So it will guess. Badly. So C++
# headers will be compiled as C headers. You don't want that so ALWAYS specify
# a "-std=<something>".
# For a C project, you would set this to something like 'c99' instead of
# 'c++11'.
'-std=c99',
# ...and the same thing goes for the magic -x option which specifies the
# language that the files to be compiled are written in. This is mostly
# relevant for c++ headers.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c',
'-isystem',
'../BoostParts',
'-isystem',
# This path will only work on OS X, but extra paths that don't exist are not
# harmful
'/System/Library/Frameworks/Python.framework/Headers',
'-isystem',
'../llvm/include',
'-isystem',
'../llvm/tools/clang/include',
'-I',
'.',
'-I',
'./ClangCompleter',
'-isystem',
'./tests/gmock/gtest',
'-isystem',
'./tests/gmock/gtest/include',
'-isystem',
'./tests/gmock',
'-isystem',
'./tests/gmock/include',
'-isystem',
'~/mycode/linux/include/linux',
'-isystem',
'~/mycode/linux/include/acpi',
'-isystem',
'~/mycode/linux/include/acpi/platform',
'-isystem',
'~/mycode/linux/include/asm-generic',
'-isystem',
'~/mycode/linux/include/asm-generic/bitops',
'-isystem',
'~/mycode/linux/include/clocksource',
'-isystem',
'~/mycode/linux/include/drm',
'-isystem',
'~/mycode/linux/include/drm/i2c',
'-isystem',
'~/mycode/linux/include/drm/ttm',
'-isystem',
'~/mycode/linux/include/drm/bridge',
'-isystem',
'~/mycode/linux/include/dt-bindings',
'-isystem',
'~/mycode/linux/include/kvm',
'-isystem',
'~/mycode/linux/include/keys',
'-isystem',
'~/mycode/linux/include/linux',
'-isystem',
'~/mycode/linux/include/linux/lockd',
'-isystem',
'~/mycode/linux/include/linux/qed',
'-isystem',
'~/mycode/linux/include/linux/netfilter_arp',
'-isystem',
'~/mycode/linux/include/linux/can',
'-isystem',
'~/mycode/linux/include/linux/can/platform',
'-isystem',
'~/mycode/linux/include/linux/raid',
'-isystem',
'~/mycode/linux/include/linux/byteorder',
'-isystem',
'~/mycode/linux/include/linux/unaligned',
'-isystem',
'~/mycode/linux/include/linux/clk',
'-isystem',
'~/mycode/linux/include/linux/ulpi',
'-isystem',
'~/mycode/linux/include/linux/isdn',
'-isystem',
'~/mycode/linux/include/linux/spi',
'-isystem',
'~/mycode/linux/include/linux/pinctrl',
'-isystem',
'~/mycode/linux/include/linux/perf',
'-isystem',
'~/mycode/linux/include/linux/netfilter',
'-isystem',
'~/mycode/linux/include/linux/netfilter/ipset',
'-isystem',
'~/mycode/linux/include/linux/decompress',
'-isystem',
'~/mycode/linux/include/linux/reset',
'-isystem',
'~/mycode/linux/include/linux/soc/mediatek',
'-isystem',
'~/mycode/linux/include/linux/soc/ti',
'-isystem',
'~/mycode/linux/include/linux/soc/qcom',
'-isystem',
'~/mycode/linux/include/linux/soc/brcmstb',
'-isystem',
'~/mycode/linux/include/linux/soc/sunxi',
'-isystem',
'~/mycode/linux/include/linux/soc/dove',
'-isystem',
'~/mycode/linux/include/linux/dma',
'-isystem',
'~/mycode/linux/include/linux/iio',
'-isystem',
'~/mycode/linux/include/linux/iio/imu',
'-isystem',
'~/mycode/linux/include/linux/iio/adc',
'-isystem',
'~/mycode/linux/include/linux/iio/accel',
'-isystem',
'~/mycode/linux/include/linux/iio/dac',
'-isystem',
'~/mycode/linux/include/linux/iio/frequency',
'-isystem',
'~/mycode/linux/include/linux/iio/gyro',
'-isystem',
'~/mycode/linux/include/linux/iio/common',
'-isystem',
'~/mycode/linux/include/linux/wimax',
'-isystem',
'~/mycode/linux/include/linux/fpga',
'-isystem',
'~/mycode/linux/include/linux/i2c',
'-isystem',
'~/mycode/linux/include/linux/platform_data',
'-isystem',
'~/mycode/linux/include/linux/phy',
'-isystem',
'~/mycode/linux/include/linux/ceph',
'-isystem',
'~/mycode/linux/include/linux/crush',
'-isystem',
'~/mycode/linux/include/linux/irqchip',
'-isystem',
'~/mycode/linux/include/linux/input',
'-isystem',
'~/mycode/linux/include/linux/extcon',
'-isystem',
'~/mycode/linux/include/linux/sunrpc',
'-isystem',
'~/mycode/linux/include/linux/mlx4',
'-isystem',
'~/mycode/linux/include/linux/mlx5',
'-isystem',
'~/mycode/linux/include/linux/fsl',
'-isystem',
'~/mycode/linux/include/linux/fsl/bestcomm',
'-isystem',
'~/mycode/linux/include/linux/mtd',
'-isystem',
'~/mycode/linux/include/linux/netfilter_bridge',
'-isystem',
'~/mycode/linux/include/linux/uwb',
'-isystem',
'~/mycode/linux/include/linux/bcma',
'-isystem',
'~/mycode/linux/include/linux/sched',
'-isystem',
'~/mycode/linux/include/linux/mmc',
'-isystem',
'~/mycode/linux/include/linux/rtc',
'-isystem',
'~/mycode/linux/include/linux/netfilter_ipv4',
'-isystem',
'~/mycode/linux/include/linux/gpio',
'-isystem',
'~/mycode/linux/include/linux/usb',
'-isystem',
'~/mycode/linux/include/linux/ssb',
'-isystem',
'~/mycode/linux/include/linux/mfd',
'-isystem',
'~/mycode/linux/include/linux/mfd/arizona',
'-isystem',
'~/mycode/linux/include/linux/mfd/samsung',
'-isystem',
'~/mycode/linux/include/linux/mfd/wm8994',
'-isystem',
'~/mycode/linux/include/linux/mfd/da9062',
'-isystem',
'~/mycode/linux/include/linux/mfd/abx500',
'-isystem',
'~/mycode/linux/include/linux/amba',
'-isystem',
'~/mycode/linux/include/linux/netfilter_ipv6',
'-isystem',
'~/mycode/linux/include/linux/power',
'-isystem',
'~/mycode/linux/include/linux/regulator',
'-isystem',
'~/mycode/linux/include/linux/hsi',
'-isystem',
'~/mycode/linux/include/math-emu',
'-isystem',
'~/mycode/linux/include/media',
'-isystem',
'~/mycode/linux/include/memory',
'-isystem',
'~/mycode/linux/include/misc',
'-isystem',
'~/mycode/linux/include/net',
'-isystem',
'~/mycode/linux/include/pcmcia',
'-isystem',
'~/mycode/linux/include/ras',
'-isystem',
'~/mycode/linux/include/rdma',
'-isystem',
'~/mycode/linux/include/rxrpc',
'-isystem',
'~/mycode/linux/include/scsi',
'-isystem',
'~/mycode/linux/include/soc',
'-isystem',
'~/mycode/linux/include/sound',
]


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ''

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def GetCompilationInfoForFile( filename ):
  # The compilation_commands.json file generated by CMake does not have entries
  # for header files. So we do our best by asking the db for flags for a
  # corresponding source file, if any. If one exists, the flags for that file
  # should be good enough.
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        compilation_info = database.GetCompilationInfoForFile(
          replacement_file )
        if compilation_info.compiler_flags_:
          return compilation_info
    return None
  return database.GetCompilationInfoForFile( filename )


def FlagsForFile( filename, **kwargs ):
  if database:
    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object
    compilation_info = GetCompilationInfoForFile( filename )
    if not compilation_info:
      return None

    final_flags = MakeRelativePathsInFlagsAbsolute(
      compilation_info.compiler_flags_,
      compilation_info.compiler_working_dir_ )

    # NOTE: This is just for YouCompleteMe; it's highly likely that your project
    # does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
    # ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
    try:
      final_flags.remove( '-stdlib=libc++' )
    except ValueError:
      pass
  else:
    relative_to = DirectoryOfThisScript()
    final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

  return {
    'flags': final_flags,
    'do_cache': True
  }
