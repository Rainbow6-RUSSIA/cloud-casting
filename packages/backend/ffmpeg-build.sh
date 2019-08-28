git clone https://github.com/FFmpeg/FFmpeg -b release/4.1 ffmpeg_sources
wget http://new.tk/NDISDKLINUX
export LIBRARY_PATH=$HOME/ndi/lib
cd ~/ffmpeg_sources && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libopus \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libndi_newtek \
  --enable-nonfree \
  --enable-shared --disable-static && \
PATH="$HOME/bin:$PATH" make -j 3 && \
make install -j 3 && \
hash -r