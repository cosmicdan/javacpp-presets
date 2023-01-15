#windows-x86_64)
    echo ""
    echo "--------------------"
    echo "Building zlib"
    echo "--------------------"
    echo ""
    cd $ZLIB
    make -j $MAKEJ install -fwin32/Makefile.gcc BINARY_PATH=$INSTALL_PATH/bin/ INCLUDE_PATH=$INSTALL_PATH/include/ LIBRARY_PATH=$INSTALL_PATH/lib/
    echo ""
    echo "--------------------"
    echo "Building LAME"
    echo "--------------------"
    echo ""
    cd ../$LAME
    ./configure --prefix=$INSTALL_PATH --disable-frontend --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    echo ""
    echo "--------------------"
    echo "Building XML2"
    echo "--------------------"
    echo ""
    cd ../$XML2
    ./configure --prefix=$INSTALL_PATH $LIBXML_CONFIG --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    echo ""
    echo "--------------------"
    echo "Building speex"
    echo "--------------------"
    echo ""
    cd ../$SPEEX
    PKG_CONFIG= ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    cd ../$OPUS
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    cd ../$OPENCORE_AMR
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64" CXXFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    cd ../$VO_AMRWBENC
    ./configure --prefix=$INSTALL_PATH --disable-shared --with-pic --build=x86_64-w64-mingw32 CFLAGS="-m64" CXXFLAGS="-m64"
    make -j $MAKEJ V=0
    make install
    cd ../$OPENSSL
    ./Configure mingw64 -fPIC no-shared --prefix=$INSTALL_PATH --libdir=lib
    make -s -j $MAKEJ
    make install_sw
    cd ../srt-$LIBSRT_VERSION
    CC="gcc -m64" CXX="g++ -m64" CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SRT_CONFIG -DENABLE_STDCXX_SYNC=ON .
    make -j $MAKEJ V=0
    make install
    cd ../openh264-$OPENH264_VERSION
    make -j $MAKEJ DESTDIR=./ PREFIX=.. AR=ar ARCH=x86_64 USE_ASM=No install-static
    cd ../$X264
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-opencl --host=x86_64-w64-mingw32
    make -j $MAKEJ V=0
    make install
    cd ../x265-$X265/build/linux
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
    cd ../libvpx-$VPX_VERSION
    ./configure --prefix=$INSTALL_PATH --enable-static --enable-pic --disable-examples --disable-unit-tests --target=x86_64-win64-gcc --disable-avx512
    make -j $MAKEJ
    make install
    cd ../libwebp-$WEBP_VERSION
    CC="gcc -m64" CXX="g++ -m64" CFLAGS="-I$INSTALL_PATH/include/" CXXFLAGS="-I$INSTALL_PATH/include/" LDFLAGS="-L$INSTALL_PATH/lib/" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $WEBP_CONFIG .
    make -j $MAKEJ V=0
    make install
    cd ../freetype-$FREETYPE_VERSION
    ./configure --prefix=$INSTALL_PATH --with-bzip2=no --with-harfbuzz=no --with-png=no --with-brotli=no --enable-static --disable-shared --with-pic --host=x86_64-w64-mingw32 CFLAGS="-m64"
    make -j $MAKEJ
    make install
    cd ../mfx_dispatch-$MFX_VERSION
    sedinplace 's:${SOURCES}:${SOURCES} src/mfx_driver_store_loader.cpp:g' CMakeLists.txt
    CC="gcc -m64" CXX="g++ -m64" $CMAKE -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release .
    make -j $MAKEJ
    make install
    cd ../nv-codec-headers-n$NVCODEC_VERSION
    make install PREFIX=$INSTALL_PATH
    cd ../ffmpeg-$FFMPEG_VERSION
    PKG_CONFIG_PATH=../lib/pkgconfig/ ./configure --prefix=.. $DISABLE $ENABLE --enable-cuda --enable-cuvid --enable-nvenc --enable-libmfx --enable-w32threads --enable-indev=dshow --target-os=mingw32 --cc="gcc -m64" --extra-cflags="-DLIBXML_STATIC -I../include/ -I../include/libxml2/" --extra-ldflags="-L../lib/" --extra-libs="-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lgcc_eh -lWs2_32 -lcrypt32 -lpthread -lz -lm -Wl,-Bdynamic -lole32 -luuid"
    make -j $MAKEJ
    make install

    cd ../..

