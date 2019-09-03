FROM node:dubnium

WORKDIR /app

COPY . /app

ARG package_name=frontend
ENV PACKAGE_NAME=$package_name

RUN if [ "$PACKAGE_NAME" = "backend" ]; then sh ./packages/backend/ffmpeg-build.sh; fi

RUN yarn install

RUN yarn start