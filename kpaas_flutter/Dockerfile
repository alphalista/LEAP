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

# Flutter 웹 활성화 및 설치 확인
RUN flutter channel stable && flutter upgrade && flutter config --enable-web && flutter doctor

# Flutter 웹 빌드
WORKDIR /app
COPY . .
RUN chown -R root:root /app && chmod -R 777 /app
RUN flutter build web --release

# Nginx로 서빙
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
