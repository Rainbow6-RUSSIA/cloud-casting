# sudo apt-get update 
apt-get update
# sudo apt-get -y install \
apt-get -y install \
autoconf automake build-essential cmake git libtool pkg-config texinfo wget nasm yasm libx264-dev libvpx-dev libopus-dev

cd $HOME
git clone https://github.com/FFmpeg/FFmpeg -b release/4.1 ./ffmpeg_sources
wget -c --output-document=ndi-sdk-installer.tar.gz http://new.tk/NDISDKLINUX
tar zxvf ./ndi-sdk-installer.tar.gz
export PAGER=echo
export NDISDKDIR="ndi-sdk"
echo Y | sh ./InstallNDISDK_v3_Linux.sh
mv "NDI SDK for Linux" $NDISDKDIR
# read -p "STOP" ABC
echo "Ready to build FFMPEG"
mkdir ./ffmpeg_build
mkdir ./bin
# export LIBRARY_PATH="$HOME/$NDISDKDIR/lib"
# export LD_LIBRARY_PATH="$HOME/$NDISDKDIR/lib/x86_64-linux-gnu"
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
  --enable-libx264 \
  --enable-libndi_newtek \
  --enable-gpl \
  --enable-nonfree \
  --enable-shared --disable-static
PATH="$HOME/bin:$PATH" make -j $(nproc)
make install -j $(nproc)
hash -r

# sudo bash -c "echo \"$HOME/ffmpeg_build/lib
# $HOME/$NDISDKDIR/lib/x86_64-linux-gnu\" > /etc/ld.so.conf.d/ffmpeg.conf"
# sudo ldconfig

bash -c "echo \"$HOME/ffmpeg_build/lib
$HOME/$NDISDKDIR/lib/x86_64-linux-gnu\" > /etc/ld.so.conf.d/ffmpeg.conf"
ldconfig