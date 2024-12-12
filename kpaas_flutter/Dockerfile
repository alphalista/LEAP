FROM --platform=linux/amd64 ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# 공식 미러 변경 (예: kernel.org 미러 사용)
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.kernel.org/ubuntu/|g' /etc/apt/sources.list

# APT 캐시 초기화 및 압축 형태 지정 후 업데이트
RUN apt-get clean && rm -rf /var/lib/apt/lists/* \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       curl git wget unzip xz-utils libstdc++6 ca-certificates openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter
RUN chown -R root:root /usr/local/flutter && chmod -R 777 /usr/local/flutter
RUN git config --global --add safe.directory /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter precache
RUN flutter doctor

WORKDIR /app
COPY . /app

RUN flutter config --enable-web && flutter doctor
RUN flutter pub get
RUN flutter build web --release

FROM --platform=linux/amd64 nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

USER root
RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
