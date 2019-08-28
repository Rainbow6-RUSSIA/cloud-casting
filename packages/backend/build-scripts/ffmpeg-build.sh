cd $HOME

git clone git@github.com:FFmpeg/FFmpeg.git -b release/4.1 ./ffmpeg_sources

# sh `dirname $0`/nasm.sh
# sh `dirname $0`/yasm.sh
sh `dirname $0`/libopus.sh
sh `dirname $0`/libvpx.sh

wget -c --output-document=ndi-sdk-installer.tar.gz http://new.tk/NDISDKLINUX
tar zxvf ./ndi-sdk-installer.tar.gz
export PAGER=echo
export NDISDKDIR="ndi-sdk"
echo Y | sh ./InstallNDISDK_v3_Linux.sh
mv "NDI SDK for Linux" $NDISDKDIR
echo "Ready to build FFMPEG"
mkdir ./ffmpeg_build
mkdir ./bin
cd ./ffmpeg_sources && \
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
