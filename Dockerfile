FROM node:dubnium

WORKDIR /app

COPY . /app

# RUN if [ "$PACKAGE_NAME" == "backend" ]; \
RUN sh packages/backend/build-scripts/ffmpeg-build.sh
# ; \
#     fi

RUN yarn install

RUN yarn start