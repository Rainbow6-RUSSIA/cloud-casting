cd $HOME

wget -q -c --output-document=ffmpeg_sources.zip https://codeload.github.com/FFmpeg/FFmpeg/zip/release/4.1
unzip ./ffmpeg_sources.zip
# git clone https://github.com/FFmpeg/FFmpeg.git -b release/4.1 ./ffmpeg_sources

cd $HOME/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install

cd $HOME/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make && \
make install

wget -q -c --output-document=ndi-sdk-installer.tar.gz http://new.tk/NDISDKLINUX
tar zxvf ./ndi-sdk-installer.tar.gz
export PAGER=echo
export NDISDKDIR="ndi-sdk"
echo Y | sh ./InstallNDISDK_v3_Linux.sh
mv "NDI SDK for Linux" $NDISDKDIR
echo "Ready to build FFMPEG"
mkdir ./ffmpeg_build
mkdir ./bin
cd $HOME/ffmpeg_sources && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib -L$HOME/$NDISDKDIR/lib/x86_64-linux-gnu" \
  --extra-cflags="-I$HOME/ffmpeg_build/include -I$HOME/$NDISDKDIR/include" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --disable-doc \
  --enable-libopus \
  --enable-libvpx \
  --enable-libndi_newtek \
  --enable-gpl \
  --enable-nonfree \
  --enable-shared --disable-static \
  --disable-x86asm
PATH="$HOME/bin:$PATH" make -j $(nproc)
make install -j $(nproc)
hash -r

# sudo bash -c "echo \"$HOME/ffmpeg_build/lib
# $HOME/$NDISDKDIR/lib/x86_64-linux-gnu\" > /etc/ld.so.conf.d/ffmpeg.conf"
# sudo ldconfig

echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/ffmpeg_build/lib:$HOME/$NDISDKDIR/lib/x86_64-linux-gnu" > "$HOME/.profile.d/ffmpeg.sh"
