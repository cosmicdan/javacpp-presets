#macosx-x86_64)
    export AS="nasm"
    echo ""
    echo "--------------------"
    echo "Building zlib"
    echo "--------------------"
    echo ""
    cd $ZLIB
    CC="clang -fPIC" ./configure --prefix=$INSTALL_PATH --static
    make -j $MAKEJ V=0
    make install
    echo ""
    echo "--------------------"
    echo "Building LAME"
    echo "--------------------"
    echo ""
    cd ../$LAME
    ./configure --prefix=$INSTALL_PATH --disable-frontend --disable-shared --with-pic
    make -j $MAKEJ V=0
    make install
    echo ""
    echo "--------------------"
    echo "Building XML2"
    echo "--------------------"
    echo ""
    cd ../$XML2
    ./configure --prefix=$INSTALL_PATH $LIBXML_CONFIG
    make -j $MAKEJ V=0
    make install
    echo ""
    echo "--------------------"
    echo "Building speex"
    echo "--------------------"
    echo ""
    cd ../$SPEEX
    PKG_CONFIG= ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic
    make -j $MAKEJ V=0
    make install
    cd ../$OPUS
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic
    make -j $MAKEJ V=0
    make install
    cd ../$OPENCORE_AMR
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic
    make -j $MAKEJ V=0
    make install
    cd ../$VO_AMRWBENC
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic
    make -j $MAKEJ V=0
    make install
    cd ../$OPENSSL
    ./Configure darwin64-x86_64-cc -fPIC no-shared --prefix=$INSTALL_PATH --libdir=lib
    make -s -j $MAKEJ
    make install_sw
    cd ../srt-$LIBSRT_VERSION
    CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SRT_CONFIG .
    make -j $MAKEJ V=0
    make install
    cd ../openh264-$OPENH264_VERSION
    make -j $MAKEJ DESTDIR=./ PREFIX=.. AR=ar USE_ASM=No install-static
    cd ../$X264
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-opencl --disable-asm
    make -j $MAKEJ V=0
    make install
    cd ../x265-$X265/build/linux
    # from x265 multilib.sh
    mkdir -p 8bit 10bit 12bit

    cd 12bit
    $CMAKE ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm
    make -j $MAKEJ

    cd ../10bit
    $CMAKE ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm
    make -j $MAKEJ

    cd ../8bit
    ln -sf ../10bit/libx265.a libx265_main10.a
    ln -sf ../12bit/libx265.a libx265_main12.a
    $CMAKE ../../../source -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DENABLE_SHARED:BOOL=OFF -DNASM_EXECUTABLE:FILEPATH=$INSTALL_PATH/bin/nasm
    make -j $MAKEJ

    # rename the 8bit library, then combine all three into libx265.a
    mv libx265.a libx265_main.a
    /usr/bin/libtool -static -o libx265.a libx265_main.a libx265_main10.a libx265_main12.a 2>/dev/null

    make install
    # ----
    cd ../../../
    cd ../libvpx-$VPX_VERSION
    sedinplace '/avx512/d' configure
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-examples --disable-unit-tests
    make -j $MAKEJ
    sedinplace '/HAS_AVX512/d' vpx_dsp_rtcd.h
    make install
    cd ../libwebp-$WEBP_VERSION
    CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $WEBP_CONFIG .
    make -j $MAKEJ V=0
    make install
    cd ../freetype-$FREETYPE_VERSION
    ./configure --prefix=$INSTALL_PATH --with-bzip2=no --with-harfbuzz=no --with-png=no --with-brotli=no --enable-static --disable-shared --with-pic
    make -j $MAKEJ
    make install
    cd ../ffmpeg-$FFMPEG_VERSION
    patch -Np1 < ../../../ffmpeg-macosx.patch
    LDEXEFLAGS='-Wl,-rpath,@loader_path/' PKG_CONFIG_PATH=../lib/pkgconfig/ ./configure --prefix=.. $DISABLE $ENABLE --enable-pthreads --enable-indev=avfoundation --disable-libxcb --extra-cflags="-I../include/ -I../include/libxml2" --extra-ldflags="-L../lib/" --extra-libs="-lstdc++ -ldl -lz -lm"
    make -j $MAKEJ
    make install
    
    cd ../..

