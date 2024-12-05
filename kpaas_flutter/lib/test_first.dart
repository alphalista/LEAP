import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
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

class KakaoLoginPage extends StatefulWidget {
  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  final String appKey = '!!'; // JavaScript 앱 키
  final String redirectUri = 'http://localhost:3000/auth/login/kakao-callback'; // 로그인 후 리디렉션될 URI

  @override
  void initState() {
    super.initState();
  }

  // 카카오 로그인 URL 생성
  String generateAuthUrl() {
    final authUrl = 'https://kauth.kakao.com/oauth/authorize?response_type=code'
        '&client_id=$appKey'
        '&redirect_uri=$redirectUri';
    return authUrl;
  }

  // 인증 코드로 accessToken 받기
  Future<void> getAccessToken(String code) async {
    final tokenUrl = 'https://kauth.kakao.com/oauth/token';
    final response = await html.HttpRequest.request(
      tokenUrl,
      method: 'POST',
      sendData: 'grant_type=authorization_code&client_id=$appKey&redirect_uri=$redirectUri&code=$code',
      requestHeaders: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.status == 200) {
      final data = json.decode(response.responseText!);
      final accessToken = data['access_token'];
      print('Access Token: $accessToken');
      // 이제 accessToken을 사용하여 추가적인 API 요청을 할 수 있습니다.
    } else {
      print('Token request failed with status: ${response.status}');
    }
  }

  // 로그인 버튼 클릭 시 실행
  void initiateLogin() {
    final authUrl = generateAuthUrl();

    // 웹 브라우저로 카카오 로그인 URL 열기
    launch(authUrl).then((_) {
      // 로그인 후 redirectUri로 리디렉션될 때 URL을 체크
      html.window.onHashChange.listen((e) {
        final url = html.window.location.href;
        final uri = Uri.parse(url);
        if (uri.queryParameters.containsKey('code')) {
          final code = uri.queryParameters['code'];
          if (code != null) {
            getAccessToken(code); // 인증 코드로 accessToken 받기
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kakao Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: initiateLogin,
          child: Text('카카오 로그인'),
        ),
      ),
    );
  }
}
