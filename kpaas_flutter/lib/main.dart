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
import 'apiconnectiontest/dummy_data.dart';
import 'package:kpaas_flutter/first.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/config/.env");
  final kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  final javaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'];

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey!,
    javaScriptAppKey: javaScriptAppKey!,
  );
  runApp(MaterialApp(home: MainPage(
    // nativeAppKey: kakaoNativeAppKey,
    // javaScriptAppKey: javaScriptAppKey
  )));
}

class MainPage extends StatelessWidget {
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
            child: MyHomePage(),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    fetchBondData();
    fetchNewsData();
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

      setState(() {
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



  Future<void> fetchNewsData() async {
    newsData = await dataController.fetchNewsData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 0
          ? HomePage()
          : _selectedIndex == 1
          ? EtBondPage(
        initialBondData: etBondData,
        initialNextUrl: nextEtBondUrl,
      )
          : _selectedIndex == 2
          ? OtcBondPage(
        initialBondData: otcBondData,
        initialNextUrl: nextOtcBondUrl,
      )
          : _selectedIndex == 3
          ? CalculatorPage()
          : NewsPage(newsData: newsData),
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