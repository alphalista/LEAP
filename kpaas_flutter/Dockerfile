# 1. 기본 Ubuntu 이미지 사용
FROM ubuntu:20.04 AS build

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y curl git wget unzip

# Flutter SDK 다운로드 및 설치
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# 환경 경로 추가
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Flutter 웹 활성화 및 설치 확인
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web && \
    flutter doctor

# 앱 파일 복사 및 권한 설정
WORKDIR /app
COPY . /app

# Flutter 웹 빌드
RUN flutter build web --release

# 2. Nginx로 서빙
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# 커스텀 Nginx 설정 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
