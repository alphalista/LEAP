import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KakaoLoginPage(),
    );
  }
}

class KakaoLoginPage extends StatelessWidget {
  final String _clientId = 'e6f2b2a8a151a1cf7ad6da34918997f5'; // 카카오 앱의 REST API 키
  final String _redirectUri = 'http://localhost:3000/auth/login/kakao-callback'; // 설정된 Redirect URI

  Future<void> _loginWithKakao(BuildContext context) async {
    final authUrl = Uri.https(
      "kauth.kakao.com",
      "/oauth/authorize",
      {
        "client_id": _clientId,
        "redirect_uri": _redirectUri,
        "response_type": "code",
      },
    ).toString();

    // 브라우저에서 URL 열기
    if (await canLaunch(authUrl)) {
      await launch(authUrl);
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  Future<void> _fetchAccessToken(String authCode) async {
    final tokenUrl = Uri.https(
      "kauth.kakao.com",
      "/oauth/token",
    );

    try {
      final response = await http.post(
        tokenUrl,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "authorization_code",
          "client_id": _clientId,
          "redirect_uri": _redirectUri,
          "code": authCode,
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final accessToken = body['access_token'];
        print("Access Token: $accessToken");

        // 추가: Access Token을 저장하거나 API 호출에 사용
      } else {
        print("Failed to fetch access token: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _handleRedirect(BuildContext context) {
    // TODO: Redirect된 URI를 처리하여 `code`를 추출하고 `_fetchAccessToken` 호출
    // 예: http://localhost:3000?code=AUTH_CODE
    final authCode = "AUTH_CODE_FROM_REDIRECT"; // 실제로는 리디렉션에서 가져와야 함
    _fetchAccessToken(authCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _loginWithKakao(context),
          child: Text("Login with Kakao"),
        ),
      ),
    );
  }
}
