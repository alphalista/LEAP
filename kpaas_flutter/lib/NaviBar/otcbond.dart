import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/DescriptionPage/otcBondDescription.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:kpaas_flutter/DescriptionPage/dialog.dart';
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
          ? "http://localhost:8000/api/otcbond/otc-bond-all/?query=$query"
          : "http://localhost:8000/api/otcbond/otc-bond-all/";

      final response = await dataController.fetchOtcBondData(url);

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

  Future<void> _fetchOtcBondDataFilteredList(String url) async {
    setState(() {
      isLoading = true; // 로딩 상태 시작
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchOtcBondData(url);

      setState(() {
        bondData = response['results'] ?? []; // 데이터를 업데이트
        nextUrl = response['next'] ?? ''; // 다음 URL 업데이트
      });
    } catch (e) {
      print("Error fetching bond data from endpoint: $e");
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

    buttonData[0]['onPressed'] = () async {
      setState(() {
        isLoading = true; // 로딩 상태 활성화
      });

      try {
        String apiUrl = 'http://localhost:8000/api/otcbond/otc-bond-all/';
        await _fetchOtcBondDataFilteredList(apiUrl); // API 호출
      } catch (e) {
        print("Error fetching all bond data: $e");
      } finally {
        setState(() {
          isLoading = false; // 로딩 상태 비활성화
        });
      }
    };

    buttonData[1]['onPressed'] = () async {
      String? result = await showExpdDateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[1]['label'] = result;
          buttonData[1]['hasSelected'] = true;
        });

        String newEndPoint;
        if (result == "만기 5년 이내") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?expd=5';
        } else if (result == "만기 3년 이내") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?expd=3';
        } else if (result == "만기 1년 이내") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?expd=1';
        } else if (result == "만기 6개월 이내") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?expd=6';
        } else {
          print('잘못된 만기 선택: $result');
          return;
        }
        await _fetchOtcBondDataFilteredList(newEndPoint);
      }
    };

    buttonData[2]['onPressed'] = () async {
      String? result = await showOtcBondDangerDialog(context);
      if (result != null) {
        setState(() {
          buttonData[2]['label'] = result;
          buttonData[2]['hasSelected'] = true;
        });
        String newEndPoint;
        if (result == "매우낮은위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=매우낮은위험';
        } else if (result == "낮은위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=낮은위험';
        } else if (result == "보통위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=보통위험';
        } else if (result == "다소높은위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=다소높은위험';
        } else if (result == "높은위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=높은위험';
        } else if (result == "매우높은위험") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?danger=매우높은위험';
        }else {
          print('잘못된 만기 선택: $result');
          return;
        }
        await _fetchOtcBondDataFilteredList(newEndPoint);
      }
    };

    buttonData[3]['onPressed'] = () async {
      String? result = await showEarnRateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[3]['label'] = result;
          buttonData[3]['hasSelected'] = true;
        });
        String newEndPoint;
        if (result == "오름차순") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?YTM_after_tax=asc&ordering=YTM_after_tax';
        } else if (result == "내림차순") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?YTM_after_tax=asc&ordering=-YTM_after_tax';
        } else {
          print('잘못된 만기 선택: $result');
          return;
        }
        await _fetchOtcBondDataFilteredList(newEndPoint);
      }
    };

    buttonData[4]['onPressed'] = () async {
      String? result = await showInterestRateDialog(context);
      if (result != null) {
        setState(() {
          buttonData[4]['label'] = result;
          buttonData[4]['hasSelected'] = true;
        });
        String newEndPoint;
        if (result == "오름차순") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?ordering=interest_percentage';
        } else if (result == "내림차순") {
          newEndPoint = 'http://localhost:8000/api/otcbond/filter/?ordering=-interest_percentage';
        } else {
          print('잘못된 만기 선택: $result');
          return;
        }
        await _fetchOtcBondDataFilteredList(newEndPoint);
      }
    };

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

    int selectedButtonIndex = 0;

    @override
    Widget build(BuildContext context) {
      bool anyButtonSelected = buttonData.skip(1).any((button) => button['hasSelected'] == true);
      final List<String> originalLabels = [
        '전체', '만기일', '신용등급', '수익율', '이자율'
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
                            if (index == 0) {
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
                      constraints: const BoxConstraints(minHeight: 200),
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