LOCAL_PATH := $(call my-dir)
SF_SRC_FILES := \
	benchmark.cpp bitboard.cpp engine.cpp evaluate.cpp main.cpp memory.cpp \
	misc.cpp movegen.cpp movepick.cpp position.cpp score.cpp search.cpp \
	thread.cpp timeman.cpp tt.cpp tune.cpp uci.cpp ucioption.cpp \
	syzygy/tbprobe.cpp \
	nnue/network.cpp nnue/nnue_misc.cpp nnue/nnue_accumulator.cpp \
	nnue/features/half_ka_v2_hm.cpp nnue/features/full_threats.cpp
MY_ARCH_DEF :=
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  MY_ARCH_DEF += -DUSE_NEON=8 -mthumb -march=armv7-a -mfloat-abi=softfp -mfpu=neon
  LOCAL_ARM_NEON := true
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  MY_ARCH_DEF += -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8 -march=armv8.2-a+dotprod -DUSE_NEON_DOTPROD
endif
ifeq ($(TARGET_ARCH_ABI),x86_64)
  MY_ARCH_DEF += -DIS_64BIT -DUSE_SSE41 -msse4.1
endif
ifeq ($(TARGET_ARCH_ABI),x86)
  MY_ARCH_DEF += -DUSE_SSE41 -msse4.1
endif
include $(CLEAR_VARS)
LOCAL_MODULE    := stockfish
include $(LOCAL_PATH)/build_sf.mk
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  MY_ARCH_DEF := -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8
  include $(CLEAR_VARS)
  LOCAL_ARM_NEON := true
  LOCAL_MODULE    := stockfish_nosimd
  include $(LOCAL_PATH)/build_sf.mk
  stockfish : stockfish_nosimd
endif
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  MY_ARCH_DEF := -mthumb -march=armv7-a -mfloat-abi=softfp
  include $(CLEAR_VARS)
  LOCAL_ARM_NEON  := false
  LOCAL_MODULE    := stockfish_nosimd
  include $(LOCAL_PATH)/build_sf.mk
  stockfish : stockfish_nosimd
endif
ifeq ($(TARGET_ARCH_ABI),x86)
  MY_ARCH_DEF :=
  include $(CLEAR_VARS)
  LOCAL_MODULE    := stockfish_nosimd
  include $(LOCAL_PATH)/build_sf.mk
  stockfish : stockfish_nosimd
endif
