#!/bin/bash
# This file is meant to be included by the parent cppbuild.sh script
if [[ -z "$PLATFORM" ]]; then
    pushd ..
    bash cppbuild.sh "$@" ffmpeg
    popd
    exit
fi

# CosmicDan: Use presets
# Default if called with e.g.:
#   ~ MAKEJ=8 bash cppbuild.sh -platform windows-x86_64 install ffmpeg
# Other included examples:
#   ~ MAKEJ=8 bash cppbuild.sh -platform windows-x86_64 -extension "../ffmpeg_default_gpl.build" install ffmpeg
#   ~ MAKEJ=8 bash cppbuild.sh -platform windows-x86_64 -extension "../ffmpeg_minimal.build" install ffmpeg
presetFile=../ffmpeg_default.build
echo ""
echo ""
echo ""
echo "~~~~~~~~"
if [[ -z "$EXTENSION" ]]; then
    echo "[i] No preset file specified via -extension, using default: $presetFile"
elif [[ -f "$EXTENSION" ]]; then
    echo "[#] Attempting preset load at ${EXTENSION}..."
    presetFile="${EXTENSION}"
else
    echo "[!] Invalid or missing preset, using default: $presetFile"
fi

ENABLE=""
DISABLE=""
source $presetFile
# Might need to do this because it adds an actual extension to output jar...? Test!
EXTENSION=""

LIBXML_CONFIG="--enable-static --disable-shared --without-iconv --without-python --without-lzma --with-pic"
SRT_CONFIG="-DENABLE_APPS:BOOL=OFF -DENABLE_ENCRYPTION:BOOL=ON -DENABLE_SHARED:BOOL=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_INCLUDEDIR=include -DCMAKE_INSTALL_BINDIR=bin"
WEBP_CONFIG="-DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF -DWEBP_BUILD_EXTRAS=OFF -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_WEBP_JS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=lib"

NASM_VERSION=2.14
ZLIB=zlib-1.2.13
LAME=lame-3.100
SPEEX=speex-1.2.1
OPUS=opus-1.3.1
OPENCORE_AMR=opencore-amr-0.1.6
VO_AMRWBENC=vo-amrwbenc-0.1.3
OPENSSL=openssl-3.0.5
OPENH264_VERSION=2.3.0
X264=x264-stable
X265=3.4
VPX_VERSION=1.12.0
ALSA_VERSION=1.2.7.2
FREETYPE_VERSION=2.12.1
MFX_VERSION=1.35.1
NVCODEC_VERSION=11.1.5.1
XML2=libxml2-2.9.12
LIBSRT_VERSION=1.5.0
WEBP_VERSION=1.2.4
FFMPEG_VERSION=5.1.2

echo ""
echo ""
echo ""
echo "~~~~~~~~"
echo "[#] Downloading external libs..."
echo "~~~~~~~~"
echo ""

download https://download.videolan.org/contrib/nasm/nasm-$NASM_VERSION.tar.gz nasm-$NASM_VERSION.tar.gz
download http://zlib.net/$ZLIB.tar.gz $ZLIB.tar.gz
download http://downloads.sourceforge.net/project/lame/lame/3.100/$LAME.tar.gz $LAME.tar.gz
download https://ftp.osuosl.org/pub/xiph/releases/speex/$SPEEX.tar.gz $SPEEX.tar.gz
download https://archive.mozilla.org/pub/opus/$OPUS.tar.gz $OPUS.tar.gz
download http://sourceforge.net/projects/opencore-amr/files/opencore-amr/$OPENCORE_AMR.tar.gz/download $OPENCORE_AMR.tar.gz
download http://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/$VO_AMRWBENC.tar.gz/download $VO_AMRWBENC.tar.gz
download https://www.openssl.org/source/$OPENSSL.tar.gz $OPENSSL.tar.gz
download https://github.com/cisco/openh264/archive/v$OPENH264_VERSION.tar.gz openh264-$OPENH264_VERSION.tar.gz
download https://code.videolan.org/videolan/x264/-/archive/stable/$X264.tar.gz $X264.tar.gz
download https://github.com/videolan/x265/archive/$X265.tar.gz x265-$X265.tar.gz
download https://github.com/webmproject/libvpx/archive/v$VPX_VERSION.tar.gz libvpx-$VPX_VERSION.tar.gz
download https://ftp.osuosl.org/pub/blfs/conglomeration/alsa-lib/alsa-lib-$ALSA_VERSION.tar.bz2 alsa-lib-$ALSA_VERSION.tar.bz2
download https://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-$FREETYPE_VERSION.tar.xz freetype-$FREETYPE_VERSION.tar.xz
download https://github.com/lu-zero/mfx_dispatch/archive/$MFX_VERSION.tar.gz mfx_dispatch-$MFX_VERSION.tar.gz
download http://xmlsoft.org/sources/$XML2.tar.gz $XML2.tar.gz
download https://github.com/Haivision/srt/archive/refs/tags/v$LIBSRT_VERSION.tar.gz srt-$LIBSRT_VERSION.tar.gz
download https://github.com/FFmpeg/nv-codec-headers/archive/n$NVCODEC_VERSION.tar.gz nv-codec-headers-$NVCODEC_VERSION.tar.gz
download https://github.com/webmproject/libwebp/archive/refs/tags/v$WEBP_VERSION.tar.gz libwebp-$WEBP_VERSION.tar.gz
download http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2 ffmpeg-$FFMPEG_VERSION.tar.bz2

mkdir -p $PLATFORM$EXTENSION
cd $PLATFORM$EXTENSION
INSTALL_PATH=`pwd`

echo ""
echo ""
echo ""
echo "~~~~~~~~"
echo "[#] Extracting and building NASM..."
echo "~~~~~~~~"
echo ""
tar --totals -xzf ../nasm-$NASM_VERSION.tar.gz


if [[ "${ACLOCAL_PATH:-}" == C:\\msys64\\* ]]; then
    export ACLOCAL_PATH=/mingw64/share/aclocal:/usr/share/aclocal
fi

cd nasm-$NASM_VERSION
# fix for build with GCC 8.x
sedinplace 's/void pure_func/void/g' include/nasmlib.h
if [[ -f _INSTALLED ]]; then
    echo "~~~~~~~~"
    echo "[i] nasm previously installed"
    echo "    Remove _INSTALLED flag or do a cppbuild clean to rebuild and reinstall nasm."
    echo "~~~~~~~~"
    echo ""
else
    ./configure --prefix=$INSTALL_PATH
    make -j $MAKEJ V=0
    make install
    touch _INSTALLED
fi
cd ..

export PATH=$INSTALL_PATH/bin:$PATH
export PKG_CONFIG_PATH=$INSTALL_PATH/lib/pkgconfig/

echo ""
echo ""
echo ""
echo "~~~~~~~~"
echo "[#] Loading cppbuild-${PLATFORM}.sh..."
echo "~~~~~~~~"
echo ""

if [[ -f "../../cppbuild-${PLATFORM}.sh" ]]; then
    source "../../cppbuild-${PLATFORM}.sh"
else
    echo "Error: Platform \"$PLATFORM\" is not supported"
fi

echo ""
echo "~~~~~~~~"
echo "[#] Building enabled external libs..."
echo "~~~~~~~~"
echo ""
# build external libs if enabled via preset
if [ "${preset_enable_zlib-false}" = true ] ; then
    echo "    [#] zlib..."
    tar --totals -xzf ../$ZLIB.tar.gz
    ENABLE+=" --enable-zlib"
    javacppPresetsFFmpeg_build_zlib
fi
if [ "${preset_enable_LAME-false}" = true ] ; then
    echo "    [#] LAME..."
    tar --totals -xzf ../$LAME.tar.gz
    patch -Np1 -d $LAME < ../../lame.patch
    ENABLE+=" --enable-libmp3lame"
    javacppPresetsFFmpeg_build_LAME
fi
if [ "${preset_enable_xml2-false}" = true ] ; then
    echo "    [#] XML2..."
    tar --totals -xzf ../$XML2.tar.gz
    ENABLE+=" --enable-libxml2"
    javacppPresetsFFmpeg_build_XML2
fi
if [ "${preset_enable_speex-false}" = true ] ; then
    echo "    [#] speex..."
    tar --totals -xzf ../$SPEEX.tar.gz
    ENABLE+=" --enable-libspeex"
    javacppPresetsFFmpeg_build_speex
fi
if [ "${preset_enable_opus-false}" = true ] ; then
    echo "    [#] opus..."
    tar --totals -xzf ../$OPUS.tar.gz
    ENABLE+=" --enable-libopus"
    javacppPresetsFFmpeg_build_opus
fi
if [ "${preset_enable_amr-false}" = true ] ; then
    echo "    [#] AMR..."
    tar --totals -xzf ../$OPENCORE_AMR.tar.gz
    tar --totals -xzf ../$VO_AMRWBENC.tar.gz
    ENABLE+=" --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc"
    javacppPresetsFFmpeg_build_amr
fi
if [ "${preset_enable_openssl-false}" = true ] ; then
    echo "    [#] openssl..."
    tar --totals -xzf ../$OPENSSL.tar.gz
    patch -Np1 -d $OPENSSL < ../../openssl-android.patch
    ENABLE+=" --enable-openssl"
    javacppPresetsFFmpeg_build_openssl
fi
if [ "${preset_enable_srt-false}" = true ] ; then
    echo "    [#] srt..."
    tar --totals -xzf ../srt-$LIBSRT_VERSION.tar.gz
    ENABLE+=" --enable-libsrt"
    javacppPresetsFFmpeg_build_srt
fi
if [ "${preset_enable_openh264-false}" = true ] ; then
    echo "    [#] OpenH264..."
    tar --totals -xzf ../openh264-$OPENH264_VERSION.tar.gz
    ENABLE+=" --enable-libopenh264"
    javacppPresetsFFmpeg_build_openh264
fi
if [ "${preset_enable_x264-false}" = true ] ; then
    echo "    [#] x264..."
    tar --totals -xzf ../$X264.tar.gz
    ENABLE+=" --enable-libx264"
    javacppPresetsFFmpeg_build_x264
fi
if [ "${preset_enable_x265-false}" = true ] ; then
    echo "    [#] x265..."
    tar --totals -xzf ../x265-$X265.tar.gz
    sedinplace 's/bool bEnableavx512/bool bEnableavx512 = false/g' x265-*/source/common/param.h
    sedinplace 's/detect512()/false/g' x265-*/source/common/quant.cpp
    ENABLE+=" --enable-libx265"
    javacppPresetsFFmpeg_build_x265
fi
if [ "${preset_enable_libvpx-false}" = true ] ; then
    echo "    [#] libvpx..."
    tar --totals -xzf ../libvpx-$VPX_VERSION.tar.gz
    ENABLE+=" --enable-libvpx"
    javacppPresetsFFmpeg_build_libvpx
fi
if [ "${preset_enable_webp-false}" = true ] ; then
    echo "    [#] webp..."
    tar --totals -xzf ../libwebp-$WEBP_VERSION.tar.gz
    ENABLE+=" --enable-libwebp"
    javacppPresetsFFmpeg_build_libwebp
fi
if [ "${preset_enable_freetype-false}" = true ] ; then
    echo "    [#] freetype..."
    tar --totals -xJf ../freetype-$FREETYPE_VERSION.tar.xz
    ENABLE+=" --enable-libfreetype"
    javacppPresetsFFmpeg_build_freetype
fi

echo "    [#] mfx [Intel MediaSDK]..."
tar --totals -xzf ../mfx_dispatch-$MFX_VERSION.tar.gz
javacppPresetsFFmpeg_build_mfx

echo "    [#] nvcodec [NVENC/NVDEC/CUVID]..."
tar --totals -xzf ../nv-codec-headers-$NVCODEC_VERSION.tar.gz
javacppPresetsFFmpeg_build_nvcodec

echo ""
echo ""
echo ""
echo "~~~~~~~~"
echo "[#] Building FFmpeg"
echo "[i] Preset params:"
echo "$DISABLE" "$ENABLE"
echo "[i] Additional params via $PLATFORM:"
echo $internalPlatformFfParams
echo "~~~~~~~~"
echo ""
echo ""
echo ""
tar --totals -xjf ../ffmpeg-$FFMPEG_VERSION.tar.bz2
patch -Np1 -d ffmpeg-$FFMPEG_VERSION < ../../ffmpeg.patch
patch -Np1 -d ffmpeg-$FFMPEG_VERSION < ../../ffmpeg-flv-support-hevc-opus.patch
javacppPresetsFFmpeg_build_ffmpeg


# rest doesn't really matter, parent cppbuild popd's
# back to javacpp-presets/ffmpeg/cppbuild/$PLATFORM
cd "$INSTALL_PATH"
# back to javacpp-presets/ffmpeg
cd ../..
