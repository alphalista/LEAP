import 'package:flutter/material.dart';
import 'package:kpaas_flutter/DescriptionPage/etBondDescription.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:get/get.dart';
import '../apiconnectiontest/data_controller.dart';
import 'package:kpaas_flutter/DescriptionPage/dialog.dart';

class EtBondPage extends StatefulWidget {
  final List<dynamic> initialBondData;
  final String initialNextUrl;

  const EtBondPage({Key? key, required this.initialBondData, required this.initialNextUrl}) : super(key: key);

  @override
  _EtBondPageState createState() => _EtBondPageState();
}

class _EtBondPageState extends State<EtBondPage> {

  final ScrollController _scrollController = ScrollController();
  List<dynamic> bondData = [];
  String? nextUrl;
  bool isLoading = false;
  String searchQuery = "";

  final List<Map<String, dynamic>> buttonData = [
    {
      'label': '전체',
      'onPressed': () {},
      'hasSelected': false,
    },
    {
      'label': '만기일',
      'onPressed': null,
      'hasSelected': false,
    },
    {
      'label': '신용등급',
      'onPressed': null,
      'hasSelected': false,
    },
    {
      'label': '수익율',
      'onPressed': () {},
      'hasSelected': false,
    },
    {
      'label': '잔존수량',
      'onPressed': () {},
      'hasSelected': false,
    },
    {
      'label': '이자율',
      'onPressed': () {},
      'hasSelected': false,
    },
  ];

  Future<void> _fetchBondData({String query = ""}) async {
    setState(() {
      isLoading = true; // 로딩 상태 설정
    });

    try {
      final dataController = Get.find<DataController>();
      final String url = query.isNotEmpty
          ? "http://localhost:8000/api/marketbond/combined/?search=$query"
          : "http://localhost:8000/api/marketbond/combined/";

      final response = await dataController.fetchEtBondData(url);

      setState(() {
        bondData = response['results'] ?? []; // 데이터를 업데이트
        nextUrl = response['next'] ?? ''; // 다음 URL 업데이트
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
  void initState() {
    super.initState();
    bondData = widget.initialBondData;
    nextUrl = widget.initialNextUrl;

    buttonData[1]['onPressed'] = () async {
      String? result = await showExpdDateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[1]['label'] = result;
          buttonData[1]['hasSelected'] = true;
        });
      }
    };

    buttonData[2]['onPressed'] = () async {
      String? result = await showEtBondDangerDialog(context);
      if (result != null) {
        setState(() {
          buttonData[2]['label'] = result;
          buttonData[2]['hasSelected'] = true;
        });
      }
    };

    buttonData[3]['onPressed'] = () async {
      String? result = await showEarnRateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[3]['label'] = result;
          buttonData[3]['hasSelected'] = true;
        });
      }
    };

    buttonData[4]['onPressed'] = () async {
      String? result = await showRemainderDialog(context);
      if (result != null) {
        setState(() {
          buttonData[4]['label'] = result;
          buttonData[4]['hasSelected'] = true;
        });
      }
    };

    buttonData[5]['onPressed'] = () async {
      String? result = await showInterestRateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[5]['label'] = result;
          buttonData[5]['hasSelected'] = true;
        });
      }
    };

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _fetchMoreData();
      }
    });
  }

  String formatDate(String? date) {
    if (date == null || date.length != 8) return 'N/A';
    return '${date.substring(2, 4)}.${date.substring(4, 6)}.${date.substring(6, 8)}';
  }

  Future<void> _fetchMoreData() async {
    if (nextUrl == null || nextUrl!.isEmpty) return; // Check if there's a next URL

    setState(() {
      isLoading = true;  // Start loading state
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchEtBondData(nextUrl!);
      setState(() {
        bondData.addAll(response['results'] ?? []); // Append new data to bondData
        nextUrl = response['next']; // Update next URL
      });
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      setState(() {
        isLoading = false;  // End loading state
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool anyButtonSelected = buttonData.skip(1).any((button) => button['hasSelected'] == true);
    final List<String> originalLabels = [
      '전체', '만기일', '신용등급', '수익율', '잔존수량', '이자율'
    ];
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
                '장내 채권',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                    _fetchBondData(query: searchQuery);
                  });
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buttonData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> button = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndex = index;
                          if (index == 0) {
                            // Reset all hasSelected values to false and restore original labels
                            for (int i = 0; i < buttonData.length; i++) {
                              buttonData[i]['hasSelected'] = false;
                              buttonData[i]['label'] = originalLabels[i];
                            }
                          }
                          button['onPressed']();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: index == 0
                            ? Colors.blueAccent
                            : (button['hasSelected'] == true ? Colors.blueAccent : Colors.white),
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: index == 0 && anyButtonSelected
                          ? const Icon(Icons.arrow_back, color: Colors.white)
                          : Text(
                        button['label'],
                        style: TextStyle(
                          color: index == 0 ? Colors.white : (button['hasSelected'] == true ? Colors.white : Colors.blueAccent),
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
                if (index == bondData.length) {
                  return _buildLoadingIndicator();
                }
                final actualIndex = index;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtBondDescriptionPage(
                          pdno: bondData[actualIndex]['issue_info_data']?['pdno'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 200),
                    margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경 색상
                      borderRadius: BorderRadius.circular(12), // 둥근 모서리
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // 그림자 색상
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
                          bondData[actualIndex]['issue_info_data']?['prdt_name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      '잔존 수량',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF696969),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      bondData[actualIndex]['inquire_asking_price_data']?['total_askp_rsqn']  ?? 'N/A',  // 잔존 수량
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
                                      "${bondData[actualIndex]['duration']['duration']}년" ?? "N/A",
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
                                      (bondData[actualIndex]['issue_info_data']?['kbp_crdt_grad_text'] != null && bondData[actualIndex]['issue_info_data']!['kbp_crdt_grad_text'].toString().isNotEmpty)
                                          ? bondData[actualIndex]['issue_info_data']['kbp_crdt_grad_text']
                                          : '무위험',
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
                                      formatDate(bondData[actualIndex]['issue_info_data']?['expd_dt']) ?? 'N/A',  // 만기일
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
                                    '${((double.tryParse(bondData[actualIndex]['inquire_asking_price_data']?['shnu_ernn_rate5']?.toString() ?? '0.0'))! * 0.846).toStringAsFixed(2)}%',  // 세후 수익률
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
                                    formatDate(bondData[actualIndex]['issue_info_data']?['issu_dt']),
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
}