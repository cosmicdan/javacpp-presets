#windows-x86_64)
javacppPresetsFFmpeg_build_zlib() {
    cd "$INSTALL_PATH/$ZLIB"
    make -j $MAKEJ install -fwin32/Makefile.gcc BINARY_PATH=$INSTALL_PATH/bin/ INCLUDE_PATH=$INSTALL_PATH/include/ LIBRARY_PATH=$INSTALL_PATH/lib/
}

javacppPresetsFFmpeg_build_LAME() {
    cd "$INSTALL_PATH/$LAME"
    ./configure --prefix=$INSTALL_PATH --disable-frontend --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_XML2() {
    echo ""
    echo "--------------------"
    echo "Building XML2"
    echo "--------------------"
    echo ""
    cd "$INSTALL_PATH/$XML2"
    ./configure --prefix=$INSTALL_PATH $LIBXML_CONFIG --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_speex() {
    echo ""
    echo "--------------------"
    echo "Building speex"
    echo "--------------------"
    echo ""
    cd "$INSTALL_PATH/$SPEEX"
    PKG_CONFIG= ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
}    
    
javacppPresetsFFmpeg_build_opus() {
    cd "$INSTALL_PATH/$OPUS"
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_amr() {
    cd "$INSTALL_PATH/$OPENCORE_AMR"
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64" CXXFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    cd "$INSTALL_PATH/$VO_AMRWBENC"
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64" CXXFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_openssl() {    
    cd "$INSTALL_PATH/$OPENSSL"
    ./Configure mingw64 -fPIC no-shared --prefix=$INSTALL_PATH --libdir=lib
    make -s -j $MAKEJ
    make install_sw
}

javacppPresetsFFmpeg_build_srt() {
    cd "$INSTALL_PATH/srt-$LIBSRT_VERSION"
    CC="gcc -m64" CXX="g++ -m64" CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SRT_CONFIG -DENABLE_STDCXX_SYNC=ON .
    make -j $MAKEJ V=0
    make install
}
    
javacppPresetsFFmpeg_build_openh264() {
    cd "$INSTALL_PATH/openh264-$OPENH264_VERSION"
    make -j $MAKEJ DESTDIR=./ PREFIX=.. AR=ar ARCH=x86_64 USE_ASM=No install-static
}

javacppPresetsFFmpeg_build_x264() {
    cd "$INSTALL_PATH/$X264"
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-opencl --host=x86_64-w64-mingw32
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_x265() {    
    cd "$INSTALL_PATH/x265-$X265/build/linux"
    # from x265 multilib.sh
    mkdir -p 8bit 10bit 12bit

    cd 12bit
    CC="gcc -m64" CXX="g++ -m64" $CMAKE -G "MSYS Makefiles" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON -DENABLE_LIBNUMA=OFF -DCMAKE_BUILD_TYPE=Release -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm.exe
    make -j $MAKEJ

    cd ../10bit
    CC="gcc -m64" CXX="g++ -m64" $CMAKE -G "MSYS Makefiles" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DENABLE_LIBNUMA=OFF -DCMAKE_BUILD_TYPE=Release -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm.exe
    make -j $MAKEJ

    cd ../8bit
    ln -sf ../10bit/libx265.a libx265_main10.a
    ln -sf ../12bit/libx265.a libx265_main12.a
    CC="gcc -m64" CXX="g++ -m64" $CMAKE -G "MSYS Makefiles" ../../../source -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DENABLE_SHARED:BOOL=OFF -DENABLE_LIBNUMA=OFF -DCMAKE_BUILD_TYPE=Release -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm.exe -DENABLE_CLI=OFF
    make -j $MAKEJ

    # rename the 8bit library, then combine all three into libx265.a
    mv libx265.a libx265_main.a
ar -M <<EOF
CREATE libx265.a
ADDLIB libx265_main.a
ADDLIB libx265_main10.a
ADDLIB libx265_main12.a
SAVE
END
EOF
    make install
    # ----
    cd ../../../
}

javacppPresetsFFmpeg_build_libvpx() {
    cd "$INSTALL_PATH/libvpx-$VPX_VERSION"
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-examples --disable-unit-tests --target=x86_64-win64-gcc --disable-avx512
    make -j $MAKEJ
    make install
}

javacppPresetsFFmpeg_build_libwebp() {    
    cd "$INSTALL_PATH/libwebp-$WEBP_VERSION"
    CC="gcc -m64" CXX="g++ -m64" CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $WEBP_CONFIG .
    make -j $MAKEJ V=0
    make install
}

javacppPresetsFFmpeg_build_freetype() {
    cd "$INSTALL_PATH/freetype-$FREETYPE_VERSION"
    ./configure --prefix=$INSTALL_PATH --with-bzip2=no --with-harfbuzz=no --with-png=no --with-brotli=no --enable-static --disable-shared --with-pic --host=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ
    make install
}

javacppPresetsFFmpeg_build_mfx() {
    cd "$INSTALL_PATH/mfx_dispatch-$MFX_VERSION"
    sedinplace 's:${SOURCES}:${SOURCES} src/mfx_driver_store_loader.cpp:g' CMakeLists.txt
    CC="gcc -m64" CXX="g++ -m64" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release .
    make -j $MAKEJ
    make install
}

javacppPresetsFFmpeg_build_nvcodec() {
    cd "$INSTALL_PATH/nv-codec-headers-n$NVCODEC_VERSION"
    make install PREFIX=$INSTALL_PATH
}

internalPlatformFfParams="--enable-cuda --enable-cuvid --enable-nvenc --enable-libmfx --enable-w32threads --enable-indev=dshow --target-os=mingw32"

javacppPresetsFFmpeg_build_ffmpeg() {
    cd "$INSTALL_PATH/ffmpeg-$FFMPEG_VERSION"
    PKG_CONFIG_PATH=../lib/pkgconfig/ ./configure --prefix=.. $DISABLE $ENABLE $internalPlatformFfParams --cc="gcc -m64" --extra-cflags="-DLIBXML_STATIC -I../include/ -I../include/libxml2/" --extra-ldflags="-L../lib/" --extra-libs="-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lgcc_eh -lWs2_32 -lcrypt32 -lpthread -lz -lm -Wl,-Bdynamic -lole32 -luuid"
    make -j $MAKEJ
    make install
}