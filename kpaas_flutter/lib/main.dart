import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'NaviBar/home.dart';
import 'NaviBar/etbond.dart';
import 'NaviBar/otcbond.dart';
import 'NaviBar/calculator.dart';
import 'NaviBar/news.dart';
import 'apiconnectiontest/data_controller.dart';
import 'apiconnectiontest/dummy_data.dart';

void main() {
  runApp(MainPage());
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
  final DataController dataController = Get.put(DataController());
  List<dynamic> etBondData = [];
  List<dynamic> otcBondData = [];
  String nextEtBondUrl = '';
  String nextOtcBondUrl = '';
  List<dynamic> newsData = [];

  @override
  void initState() {
    super.initState();
    fetchBondData();
    fetchNewsData();
  }

  Future<void> fetchBondData() async {
    try {
      final etResponse = await dataController.fetchEtBondData("https://leapbond.com/api/marketbond/issue-info/");
      etBondData = etResponse['results'] ?? [];
      nextEtBondUrl = etResponse['next'] ?? '';

      final otcResponse = await dataController.fetchOtcBondData("https://leapbond.com/api/otcbond/otc-bond-all/");
      otcBondData = otcResponse['results'] ?? [];
      nextOtcBondUrl = otcResponse['next'] ?? "";

      setState(() {});
    } catch (e) {
      print('Error fetching bond data: $e');
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