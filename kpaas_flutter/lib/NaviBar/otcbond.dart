import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/otcBondDescription.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';

import '../apiconnectiontest/data_controller.dart';

class OtcBondPage extends StatefulWidget {
  final List<dynamic> initialBondData;
  final String initialNextUrl;

  const OtcBondPage({Key? key, required this.initialBondData, required this.initialNextUrl}) : super(key: key);

  @override
  _OtcBondPageState createState() => _OtcBondPageState();
}

class _OtcBondPageState extends State<OtcBondPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> bondData = [];
  String? nextUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bondData = widget.initialBondData;
    nextUrl = widget.initialNextUrl;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !isLoading) {
        _fetchMoreData();
      }
    });
  }

  String formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(2, 4)}.${date.substring(4, 6)}.${date.substring(
          6, 8)}';
    }
    return date;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _fetchMoreData() async {
    if (nextUrl == null || nextUrl!.isEmpty) return; // Check if there's a next URL

    setState(() {
      isLoading = true; // Start loading state
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchOtcBondData(nextUrl!);
      setState(() {
        bondData.addAll(response['results'] ?? []); // Append new data to bondData
        nextUrl = response['next']; // Update next URL
      });
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      setState(() {
        isLoading = false; // End loading state
      });
    }
  }


    final List<Map<String, dynamic>> buttonData = [
      {'label': '전체', 'onPressed': () => print("채권 종류 1 선택")},
      {'label': '위험도', 'onPressed': () => print("채권 종류 2 선택")},
      {'label': '신용 등급', 'onPressed': () => print("채권 종류 3 선택")},
      {'label': '수익율', 'onPressed': () => print("채권 종류 4 선택")},
      {'label': '잔존 수량', 'onPressed': () => print("채권 종류 5 선택")},
    ];

    int selectedButtonIndex = 0;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F1F9),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '장외 채권',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '채권 검색...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (query) {},
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buttonData
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> button = entry.value;
                    bool isSelected = selectedButtonIndex == index;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,
                          vertical: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButtonIndex = index;
                            button['onPressed'](); // 각 버튼의 기능 호출
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          backgroundColor: isSelected
                              ? Colors.blueAccent
                              : Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFD2E1FC),
                          ),
                        ),
                        child: Text(
                          button['label'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors
                                .blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: bondData.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 0);
                  }

                  final actualIndex = index - 1;

                  if (actualIndex == bondData.length) {
                    return _buildLoadingIndicator();
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtcBondDescriptionPage(
                            bondData: bondData[actualIndex], // 선택한 bondData 전달
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 30),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bondData[actualIndex]['prdt_name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '이자 지급 주기',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${bondData[actualIndex]['int_pay_cycle'] ??
                                            'N/A'}개월",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        '듀레이션',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${bondData[actualIndex]['duration'] ??
                                            "N/A"}년",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '신용 등급',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        bondData[actualIndex]['nice_crdt_grad_text'] ??
                                            'N/A',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        '만기일',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        formatDate(
                                            bondData[actualIndex]['expd_dt']) ??
                                            'N/A',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      '세후 수익률',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF696969),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${bondData[actualIndex]['YTM_after_tax'] ??
                                          'N/A'}%',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      '발행일',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF696969),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      formatDate(
                                          bondData[actualIndex]['issu_dt']) ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }