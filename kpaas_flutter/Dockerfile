# 1. 기본 Ubuntu 이미지 사용
FROM ubuntu:20.04 AS build

# Flutter SDK 다운로드 및 환경 설정
RUN apt-get update && \
    apt-get install -y curl git wget unzip && \
    git clone https://github.com/flutter/flutter.git /usr/local/flutter

# 환경 경로 추가
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Flutter 권한 설정
RUN chown -R root:root /usr/local/flutter && chmod -R 777 /usr/local/flutter

# 일반 사용자 추가 및 flutteruser 권한으로 안전 디렉토리 설정
RUN useradd -ms /bin/bash flutteruser
USER flutteruser

# Flutter 디렉토리를 안전한 디렉토리로 설정
RUN git config --global --add safe.directory /usr/local/flutter

# Flutter 웹 활성화 및 설치 확인
RUN git -C /usr/local/flutter reset --hard && \
    flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web && \
    flutter doctor

# 앱 파일 복사 및 권한 설정
WORKDIR /app
COPY . /app
USER root
RUN chown -R flutteruser:flutteruser /app
USER flutteruser

# Flutter 웹 빌드
RUN flutter build web --release --base-href "/web/"

# 2. Nginx로 서빙
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html/web

# 커스텀 Nginx 설정 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
