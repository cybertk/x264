#!/bin/bash -e

# Copyright (c) 2012 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

SUPPORTED_TARGETS="AvaConverter"

# Use this to copy all config files into the tree.
for os in linux mac win; do
  for target in $SUPPORTED_TARGETS; do
    # Copy config files for various architectures:
    #   - x264_config.h config.h
    for arch in arm arm-neon ia32 x64 mipsel; do
      # Don't waste time on non-existent configs, if no config.h then skip.
      [ ! -e "build.$arch.$os/$target/config.h" ] && continue
      for f in config.h x264_config.h; do
        FROM="build.$arch.$os/$target/$f"
        TO="config/$target/$os/$arch/$f"
        if [ "$(dirname $f)" != "" ]; then mkdir -p $(dirname $TO); fi
        [ -e $FROM ] && cp -v $FROM $TO
      done
    done
  done
done

echo "Copied all existing newer configs successfully."
