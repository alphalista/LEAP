# 1. 기본 Ubuntu 이미지 사용
FROM --platform=linux/amd64 ubuntu:20.04 AS build

# 앱 파일 복사 및 권한 설정
WORKDIR /app
COPY . /app

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
RUN flutter config --enable-web && \
    flutter doctor

# 다시 root로 권한 전환하여 빌드 권한 문제 해결
USER root

# pubspec.lock 파일 및 전체 앱 디렉토리의 권한 수정
RUN chown -R flutteruser:flutteruser /app

# Flutter 웹 빌드
USER flutteruser
RUN flutter build web --release

# 2. Nginx로 서빙
FROM --platform=linux/amd64 nginx:alpine

# 빌드된 웹 파일 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# 커스텀 Nginx 설정 복사
COPY nginx.conf /etc/nginx/nginx.conf

# 퍼미션 수정 (추가적인 퍼미션 문제를 방지하기 위해)
USER root
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
