import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'NaviBar/home.dart';
import 'NaviBar/etbond.dart';
import 'NaviBar/otcbond.dart';
import 'NaviBar/calculator.dart';
import 'NaviBar/news.dart';
import 'apiconnectiontest/data_controller.dart';
import 'package:kpaas_flutter/first.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/config/.env");
  final kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  final javaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'];
  final idToken = dotenv.env['ID_TOKEN'];

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey!,
    javaScriptAppKey: javaScriptAppKey!,
  );
  runApp(MaterialApp(home: MainPage(
    // nativeAppKey: kakaoNativeAppKey,
    // javaScriptAppKey: javaScriptAppKey
      idToken: idToken!
  )));
}

class MainPage extends StatelessWidget {
  final String idToken;
  const MainPage({Key? key, required this.idToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Container(
            width: 500,
            color: Colors.white,
            child: MyHomePage(
              idToken: idToken
            ),
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final String idToken;
  const MyHomePage({Key? key, required this.idToken}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool isLoading = true;
  final DataController dataController = Get.put(DataController());
  List<dynamic> etBondData = [];
  List<dynamic> otcBondData = [];
  String nextEtBondUrl = '';
  String nextOtcBondUrl = '';
  List<dynamic> newsData = [];
  List<dynamic> bondData = [];
  String nextUrl = '';
  String nextNewsUrl = '';

  @override
  void initState() {
    super.initState();
    fetchBondData();
  }

  Future<void> fetchBondData() async {
    setState(() {
      isLoading = true; // 로딩 상태 설정
    });

    try {
      final dataController = Get.find<DataController>();
      final otcResponse = await dataController.fetchOtcBondData(
        "http://localhost:8000/api/otcbond/otc-bond-all/",
      );
      final etResponse = await dataController.fetchEtBondData(
        "http://localhost:8000/api/marketbond/combined/",
      );
      final newsResponse = await dataController.fetchNewsBondData(
          "http://localhost:8000/api/news/data/"
      );

      setState(() {
        newsData = newsResponse['results'] ?? [];
        nextNewsUrl = newsResponse['next'];
        etBondData = etResponse['results'] ?? [];
        nextEtBondUrl = etResponse['next'] ?? "";
        otcBondData = otcResponse['results'] ?? []; // 장외 채권 데이터 저장
        nextOtcBondUrl = otcResponse['next'] ?? ''; // 다음 URL 저장
      });
    } catch (e) {
      print("Error fetching bond data: $e");
    } finally {
      setState(() {
        isLoading = false; // 로딩 상태 해제
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 0
          ? HomePage(
          idToken: widget.idToken
      )
          : _selectedIndex == 1
          ? EtBondPage(
        initialBondData: etBondData,
        initialNextUrl: nextEtBondUrl,
          idToken: widget.idToken
      )
          : _selectedIndex == 2
          ? OtcBondPage(
        initialBondData: otcBondData,
        initialNextUrl: nextOtcBondUrl,
          idToken: widget.idToken
      )
          : _selectedIndex == 3
          ? CalculatorPage(
          idToken: widget.idToken
      )
          : NewsPage(
          newsData: newsData,
          idToken: widget.idToken,
          initialNextUrl: nextNewsUrl,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '장내 채권',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: '장외 채권',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: '투자 계산기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: '뉴스',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}