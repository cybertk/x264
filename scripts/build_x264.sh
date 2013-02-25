#!/bin/bash -e

# Copyright (c) 2012 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Builds Chromium, Google Chrome and *OS FFmpeg binaries.
#
# For Windows it the script must be run from either a x64 or ia32 Visual Studio
# environment (i.e., cl.exe, lib.exe and editbin.exe are in $PATH).  Using the
# x64 environment will build the x64 version and vice versa.
#
# For MIPS it assumes that cross-toolchain bin directory is in $PATH.
#
# Instructions for setting up a MinGW/MSYS shell can be found here:
# http://src.chromium.org/viewvc/chrome/trunk/deps/third_party/mingw/README.chromium

if [ "$3" = "" ]; then
  echo "Usage:"
  echo "  $0 [TARGET_OS] [TARGET_ARCH] [path/to/ffmpeg] [config-only]"
  echo
  echo "Valid combinations are linux [ia32|x64|mipsel|arm|arm-neon]"
  echo "                       win   [ia32|x64]"
  echo "                       mac   [ia32|x64]"
  echo
  echo " linux ia32/x64 - script can be run on a normal Ubuntu box."
  echo " linux mipsel - script can be run on a normal Ubuntu box with MIPS"
  echo " cross-toolchain in \$PATH."
  echo " linux arm/arm-neon should be run inside of CrOS chroot."
  echo " mac and win have to be run on Mac and Windows 7 (under mingw)."
  echo
  echo " mac - ensure the Chromium (not Apple) version of clang is in the path,"
  echo " usually found under src/third_party/llvm-build/Release+Asserts/bin"
  echo
  echo "Specifying 'config-only' will skip the build step.  Useful when a"
  echo "given platform is not necessary for generate_gyp.py."
  echo
  echo "The path should be absolute and point at Chromium's copy of FFmpeg."
  echo "This corresponds to:"
  echo "  chrome/trunk/deps/third_party/ffmpeg"
  echo
  echo "Resulting binaries will be placed in:"
  echo "  build.TARGET_ARCH.TARGET_OS/Chromium/out/"
  echo "  build.TARGET_ARCH.TARGET_OS/Chrome/out/"
  echo "  build.TARGET_ARCH.TARGET_OS/ChromiumOS/out/"
  echo "  build.TARGET_ARCH.TARGET_OS/ChromeOS/out/"
  exit 1
fi

TARGET_OS=$1
TARGET_ARCH=$2
FFMPEG_PATH=$3
CONFIG_ONLY=$4
WORKING_PATH=$PWD

# Check TARGET_OS (TARGET_ARCH is checked during configuration).
if [[ "$TARGET_OS" != "linux" &&
      "$TARGET_OS" != "mac" &&
      "$TARGET_OS" != "win" ]]; then
  echo "Valid target OSes are: linux, mac, win"
  exit 1
fi

# Check FFMPEG_PATH to contain this script.
if [ ! -f "$WORKING_PATH/scripts/$(basename $0)" ]; then
  echo "$WORKING_PATH doesn't appear to contain FFmpeg"
#  exit 1
fi

# If configure & make works but this script doesn't, make sure to grep for
# these.
LIBX264_VERSION_MAJOR=2

case $(uname -sm) in
  # Linux i686 is returned on ArchLinux.
  Linux\ i386 | Linux\ i686)
    HOST_OS=linux
    HOST_ARCH=ia32
    JOBS=$(grep processor /proc/cpuinfo | wc -l)
    ;;
  Linux\ x86_64)
    HOST_OS=linux
    HOST_ARCH=x64
    JOBS=$(grep processor /proc/cpuinfo | wc -l)
    ;;
  Darwin\ i386)
    HOST_OS=mac
    HOST_ARCH=ia32
    JOBS=$(sysctl -n hw.ncpu)
    ;;
  Darwin\ x86_64)
    HOST_OS=mac
    HOST_ARCH=x64
    JOBS=$(sysctl -n hw.ncpu)
    ;;
  MINGW*)
    HOST_OS=win
    HOST_ARCH=ia32
    JOBS=$NUMBER_OF_PROCESSORS
    ;;
  *)
    echo "Unrecognized HOST_OS: $(uname)"
    echo "Patches welcome!"
    exit 1
    ;;
esac

# Print out system information.
echo "System information:"
echo "HOST_OS     = $HOST_OS"
echo "TARGET_OS   = $TARGET_OS"
echo "HOST_ARCH   = $HOST_ARCH"
echo "TARGET_ARCH = $TARGET_ARCH"
echo "JOBS        = $JOBS"
echo "LD          = $(ld --version | head -n1)"
echo

# As of this writing gold 2.20.1-system.20100303 is unable to link FFmpeg.
if ld --version | grep -q gold; then
  echo "gold is unable to link FFmpeg"
  echo
  echo "Switch /usr/bin/ld to the regular binutils ld and try again"
  exit 1
fi

# We want to use a sufficiently recent version of yasm on Windows.
if [ "$TARGET_OS" == "win" ]; then
  if !(which yasm 2>&1 > /dev/null); then
    echo "Could not find yasm in \$PATH"
    exit 1
  fi

  if (yasm --version | head -1 | grep -q "^yasm 0\."); then
    echo "Must have yasm 1.0 or higher installed"
    exit 1
  fi
fi

# Returns the Dynamic Shared Object name given the module name and version.
function dso_name { dso_name_${TARGET_OS} $1 $2; }
function dso_name_win { echo "${1}-${2}.dll"; }
function dso_name_linux { echo "lib${1}.so.${2}"; }
function dso_name_mac { echo "lib${1}.${2}.dylib"; }

# Appends configure flags.
FLAGS_COMMON=

# Flags that are used in all projects.
function add_flag_common {
  FLAGS_COMMON="$FLAGS_COMMON $*"
}

# Builds using $1 as the output directory and all following arguments as
# configure script arguments.
function build {
  CONFIG=$1
  CONFIG_DIR="build.$TARGET_ARCH.$TARGET_OS/$CONFIG"
  shift

  # Create our working directory.
  echo "Creating build directory..."
  rm -rf $CONFIG_DIR
  mkdir -p $CONFIG_DIR
  pushd $CONFIG_DIR
  mkdir out

  # Configure and check for exit status.
  echo "Configuring $CONFIG..."
  CMD="$FFMPEG_PATH/configure $*"
  echo $CMD
  eval $CMD

  if [ ! -f config.h ]; then
    echo "Configure failed!"
    exit 1
  fi

  if [ $TARGET_OS = "mac" ]; then
    # Required to get Mac ia32 builds compiling with -fno-omit-frame-pointer,
    # which is required for accurate stack traces.  See http://crbug.com/115170.
    if [ $TARGET_ARCH = "ia32" ]; then
      echo "Forcing HAVE_EBP_AVAILABLE to 0 in config.h and config.asm"
      $FFMPEG_PATH/chromium/scripts/munge_config_optimizations.sh config.h
      $FFMPEG_PATH/chromium/scripts/munge_config_optimizations.sh config.asm
    fi
  fi

  if [[ "$HOST_OS" = "$TARGET_OS" && "$CONFIG_ONLY" = "" ]]; then
    # Build!
    LIBS="lib-shared"
    for lib in $LIBS; do
      echo "Building $lib for $CONFIG..."
      echo "make -j$JOBS $lib"
      make -j$JOBS $lib
      if [ -f $lib ]; then
        cp $lib out
      else
        echo "Build failed!"
        exit 1
      fi
    done
  elif [ ! "$CONFIG_ONLY" = "" ]; then
    echo "Skipping build step as requested."
  else
    echo "Skipping compile as host configuration differs from target."
    echo "Please compare the generated config.h with the previous version."
    echo "You may also patch the script to properly cross-compile."
    echo "host   OS  = $HOST_OS"
    echo "target OS  = $TARGET_OS"
    echo "host   ARCH= $HOST_ARCH"
    echo "target ARCH= $TARGET_ARCH"
  fi

  if [ "$TARGET_ARCH" = "arm" -o "$TARGET_ARCH" = "arm-neon" ]; then
    sed -i 's/^\(#define HAVE_VFP_ARGS [01]\)$/\/* \1 -- Disabled to allow softfp\/hardfp selection at gyp time *\//' config.h
  fi

  popd
}

# Common configuration.  Note: --disable-everything does not in fact disable

add_flag_common --disable-cli
add_flag_common --enable-shared
add_flag_common --enable-static
add_flag_common --enable-asm

# Disbale external lib support.
add_flag_common --disable-avs
add_flag_common --disable-swscale
add_flag_common --disable-lavf
add_flag_common --disable-ffms
add_flag_common --disable-gpac

echo "AvaConverter configure/build:"
build AvaConverter $FLAGS_COMMON $FLAGS_AVACONVERTER

echo "Done. If desired you may copy config.h/config.asm into the" \
     "source/config tree using copy_config.sh."
