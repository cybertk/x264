# Copyright (c) 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# NOTE: this file is autogenerated by ffmpeg/scripts/generate_gyp.py

{
  'variables': {
    'x264_source_dir': 'files/x264',
    'conditions': [
      ['(target_arch == "ia32" or target_arch == "x64") and (1) and (1)', {
        'c_sources': [
          'files/x264/common/bitstream.c',
          'files/x264/common/cabac.c',
          'files/x264/common/common.c',
          'files/x264/common/cpu.c',
          'files/x264/common/dct.c',
          'files/x264/common/deblock.c',
          'files/x264/common/frame.c',
          'files/x264/common/macroblock.c',
          'files/x264/common/mc.c',
          'files/x264/common/mvpred.c',
          'files/x264/common/osdep.c',
          'files/x264/common/pixel.c',
          'files/x264/common/predict.c',
          'files/x264/common/quant.c',
          'files/x264/common/rectangle.c',
          'files/x264/common/set.c',
          'files/x264/common/threadpool.c',
          'files/x264/common/vlc.c',
          'files/x264/common/x86/mc-c.c',
          'files/x264/common/x86/predict-c.c',
          'files/x264/encoder/analyse.c',
          'files/x264/encoder/cabac.c',
          'files/x264/encoder/cavlc.c',
          'files/x264/encoder/encoder.c',
          'files/x264/encoder/lookahead.c',
          'files/x264/encoder/macroblock.c',
          'files/x264/encoder/me.c',
          'files/x264/encoder/ratecontrol.c',
          'files/x264/encoder/set.c',
        ],
        'asm_sources': [
          'files/x264/common/x86/bitstream-a.asm',
          'files/x264/common/x86/cabac-a.asm',
          'files/x264/common/x86/const-a.asm',
          'files/x264/common/x86/cpu-a.asm',
          'files/x264/common/x86/dct-32.asm',
          'files/x264/common/x86/dct-a.asm',
          'files/x264/common/x86/deblock-a.asm',
          'files/x264/common/x86/mc-a.asm',
          'files/x264/common/x86/mc-a2.asm',
          'files/x264/common/x86/pixel-32.asm',
          'files/x264/common/x86/pixel-a.asm',
          'files/x264/common/x86/predict-a.asm',
          'files/x264/common/x86/quant-a.asm',
          'files/x264/common/x86/sad-a.asm',
        ],
        'converter_outputs': [
          '<(shared_generated_dir)/files/x264/common/bitstream.c',
          '<(shared_generated_dir)/files/x264/common/cabac.c',
          '<(shared_generated_dir)/files/x264/common/common.c',
          '<(shared_generated_dir)/files/x264/common/cpu.c',
          '<(shared_generated_dir)/files/x264/common/dct.c',
          '<(shared_generated_dir)/files/x264/common/deblock.c',
          '<(shared_generated_dir)/files/x264/common/frame.c',
          '<(shared_generated_dir)/files/x264/common/macroblock.c',
          '<(shared_generated_dir)/files/x264/common/mc.c',
          '<(shared_generated_dir)/files/x264/common/mvpred.c',
          '<(shared_generated_dir)/files/x264/common/osdep.c',
          '<(shared_generated_dir)/files/x264/common/pixel.c',
          '<(shared_generated_dir)/files/x264/common/predict.c',
          '<(shared_generated_dir)/files/x264/common/quant.c',
          '<(shared_generated_dir)/files/x264/common/rectangle.c',
          '<(shared_generated_dir)/files/x264/common/set.c',
          '<(shared_generated_dir)/files/x264/common/threadpool.c',
          '<(shared_generated_dir)/files/x264/common/vlc.c',
          '<(shared_generated_dir)/files/x264/common/x86/mc-c.c',
          '<(shared_generated_dir)/files/x264/common/x86/predict-c.c',
          '<(shared_generated_dir)/files/x264/encoder/analyse.c',
          '<(shared_generated_dir)/files/x264/encoder/cabac.c',
          '<(shared_generated_dir)/files/x264/encoder/cavlc.c',
          '<(shared_generated_dir)/files/x264/encoder/encoder.c',
          '<(shared_generated_dir)/files/x264/encoder/lookahead.c',
          '<(shared_generated_dir)/files/x264/encoder/macroblock.c',
          '<(shared_generated_dir)/files/x264/encoder/me.c',
          '<(shared_generated_dir)/files/x264/encoder/ratecontrol.c',
          '<(shared_generated_dir)/files/x264/encoder/set.c',
        ],
      }],  # (target_arch == "ia32" or target_arch == "x64") and (1) and (1)
    ],  # conditions
    'c_headers': [
      'files/x264/x264cli.h',
      'files/x264/x264.h',
      'files/x264/extras/stdint.h',
      'files/x264/extras/getopt.h',
      'files/x264/extras/inttypes.h',
      'files/x264/extras/avisynth_c.h',
      'files/x264/common/quant.h',
      'files/x264/common/predict.h',
      'files/x264/common/display.h',
      'files/x264/common/set.h',
      'files/x264/common/threadpool.h',
      'files/x264/common/mc.h',
      'files/x264/common/dct.h',
      'files/x264/common/macroblock.h',
      'files/x264/common/common.h',
      'files/x264/common/rectangle.h',
      'files/x264/common/pixel.h',
      'files/x264/common/cpu.h',
      'files/x264/common/cabac.h',
      'files/x264/common/bitstream.h',
      'files/x264/common/visualize.h',
      'files/x264/common/frame.h',
      'files/x264/common/osdep.h',
      'files/x264/common/win32thread.h',
      'files/x264/common/x86/quant.h',
      'files/x264/common/x86/predict.h',
      'files/x264/common/x86/mc.h',
      'files/x264/common/x86/dct.h',
      'files/x264/common/x86/pixel.h',
      'files/x264/common/x86/util.h',
      'files/x264/common/ppc/quant.h',
      'files/x264/common/ppc/predict.h',
      'files/x264/common/ppc/mc.h',
      'files/x264/common/ppc/dct.h',
      'files/x264/common/ppc/pixel.h',
      'files/x264/common/ppc/ppccommon.h',
      'files/x264/common/arm/quant.h',
      'files/x264/common/arm/predict.h',
      'files/x264/common/arm/mc.h',
      'files/x264/common/arm/dct.h',
      'files/x264/common/arm/pixel.h',
      'files/x264/common/sparc/pixel.h',
      'files/x264/filters/filters.h',
      'files/x264/filters/video/video.h',
      'files/x264/filters/video/internal.h',
      'files/x264/input/input.h',
      'files/x264/encoder/analyse.h',
      'files/x264/encoder/set.h',
      'files/x264/encoder/macroblock.h',
      'files/x264/encoder/ratecontrol.h',
      'files/x264/encoder/me.h',
      'files/x264/output/output.h',
      'files/x264/output/flv_bytestream.h',
      'files/x264/output/matroska_ebml.h',
      'build.ia32.linux/AvaConverter/config.h',
      'build.ia32.linux/AvaConverter/x264_config.h',
      'config/AvaConverter/linux/ia32/config.h',
      'config/AvaConverter/linux/ia32/x264_config.h',
    ],  # c_headers
  },
}
