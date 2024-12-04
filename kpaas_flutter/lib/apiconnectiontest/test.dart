import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiRequestPage(),
    );
  }
}

class ApiRequestPage extends StatefulWidget {
  @override
  _ApiRequestPageState createState() => _ApiRequestPageState();
}

class _ApiRequestPageState extends State<ApiRequestPage> {
  String apiResponse = "데이터를 로드 중입니다...";

  Future<void> fetchApiData(String idToken) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://localhost:8000/api/otcbond/interest',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken', // 헤더에 Authorization 추가
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          apiResponse = response.data.toString(); // 받아온 데이터를 화면에 출력
        });
      } else {
        setState(() {
          apiResponse = '요청 실패: ${response.statusCode}';
        });
      }
    } on DioError catch (dioError) {
      setState(() {
        apiResponse = '오류 발생: ${dioError.message}';
      });
    } catch (error) {
      setState(() {
        apiResponse = '예기치 못한 오류 발생: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API 데이터 요청")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // idToken을 전달해 데이터 요청
                const idToken = "eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJlNmYyYjJhOGExNTFhMWNmN2FkNmRhMzQ5MTg5OTdmNSIsInN1YiI6IjM3Nzc1MTM2MTAiLCJhdXRoX3RpbWUiOjE3MzMyODUyMTAsImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwiZXhwIjoxNzMzMzA2ODEwLCJpYXQiOjE3MzMyODUyMTAsImVtYWlsIjoiZGxlZUBzdHUuaWljcy5rMTIudHIifQ.VYMCPQNBYi4tAKnBM8pI2wHKd13DPN1Gw154Gfe4f0pDApJHe1JnocTFpzWanXgW4HwI5bDIiCVduiqkhTEOUP5X0xBtSjsynX529WOF2SEl-xgbvZAVRIKoShTdtxyfL5584vgVh3h8fidgYqWTAcHfYJdE6ZrU4ySubut0rK7J7juhmvirC5UHrd8PP3eyThy0TcCB9nAdqbOuGHpzMhXb0mqo3S18UVAwVbU0zsqNdD_TeXBLtBxuq1tA_9bTJYBEzg1Vir5NvYNAcXB-fr5krNoSLVCbqP9oLFkx5FwlfgG8C7rhb30JaQscIi3hGnGG-wVNsfw_yKpW_oN1xA"; // 실제 토큰 값으로 대체
                fetchApiData(idToken);
              },
              child: Text("API 데이터 요청"),
            ),
            SizedBox(height: 20),
            Text(apiResponse, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
