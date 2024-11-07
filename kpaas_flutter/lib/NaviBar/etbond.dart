import 'package:flutter/material.dart';
import 'package:kpaas_flutter/etBondDescription.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:get/get.dart';
import '../apiconnectiontest/data_controller.dart';

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

  @override
  void initState() {
    super.initState();
    bondData = widget.initialBondData;
    nextUrl = widget.initialNextUrl;

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
    _scrollController.dispose();  // 스크롤 컨트롤러 해제
    super.dispose();
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
                MaterialPageRoute(builder: (context) => MyPage()),
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
                  prefixIcon: Icon(Icons.search),
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
                children: buttonData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> button = entry.value;
                  bool isSelected = selectedButtonIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndex = index;
                          button['onPressed'](); // 각 버튼의 기능 호출
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        button['label'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.blueAccent,
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
                    height: 200,
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
                                      bondData[actualIndex]['bond_avrg_drtn_val'] ?? "N/A",  // 듀레이션
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
                                    '${((double.tryParse(bondData[actualIndex]['inquire_price_data']?['ernn_rate']?.toString() ?? '0.0'))! * 0.846).toStringAsFixed(2)}%',  // 세후 수익률
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

/// 주어진 액면가와 이자율 및 이자 지급 주기에 따른 회당 이자를 계산하는 함수입니다.
double interestMoney(double faceValue, double percent, int intCycle) {
  return faceValue * (percent * 0.01) / (12 / intCycle);
}

/// 차기 이자 지급일부터 만기일까지 남은 이자 지급 기간을 계산하는 함수입니다.
int getRemainingInterestPeriod(
    String nextInterestDate, String maturityDate, int interestCyclePeriod) {
  int count = 0;

  // 연, 월, 일을 넣습니다. 이자 지급일자와 만기일자는 같기 때문에 일수는 1로 가정합니다.
  DateTime nextInterestDateTime =
  DateTime.parse(nextInterestDate.substring(0, 6) + '01');
  DateTime maturityDateTime =
  DateTime.parse(maturityDate.substring(0, 6) + '01');

  // 만기 달을 넘어설 때까지 계속 더해나갑니다.
  while (nextInterestDateTime.isBefore(maturityDateTime) ||
      nextInterestDateTime.isAtSameMomentAs(maturityDateTime)) {
    nextInterestDateTime =
        nextInterestDateTime.add(Duration(days: 30 * interestCyclePeriod));
    count += 1;
  }
  return count;
}

/// 채권 하나 당 수익금을 계산하는 함수입니다.
///
/// - [positionMode]: 자료형: int, 매수 또는 매도 포지션을 말하며 0은 매수, 1은 매도 포지션입니다.
/// - [pricePer10]: 자료형: int, 채권 10,000원 수량, 즉 액면가 10,000원 당 매수 가격을 말합니다.
/// - [purCnt]: 자료형: int, 채권 수량(단위: 천원)을 말합니다.
/// - [interestPercent]: 자료형: double, 이자율을 말합니다.
/// - [matDate]: 자료형: String(YYYYmmdd 형식), 예) "20240103". 만기일 또는 계산 목표일을 말합니다.
/// - [nxtInterestDate]: 자료형: String(YYYYmmdd 형식), 예) "20240103". 차기 이자 지급일을 말합니다.
/// - [interestCyclePeriod]: 자료형: int, 이자 지급 주기를 월 단위로 말합니다.
/// - [isMat]: 자료형: bool, 만기일 기준으로 계산할지 여부를 나타냅니다.
/// - [sellPrice]: 자료형: int, 매도 포지션 한정 인수이며, 매도 가격을 말합니다.
///
/// @return 자료형: double, 소수점 2자리까지 표기된 예상 수익금이 반환됩니다.
double exptIncome(
    int positionMode,
    double pricePer10,
    int purCnt,
    double interestPercent,
    String matDate,
    String nxtInterestDate,
    int interestCyclePeriod,
    bool isMat,
    [double sellPrice = 0]) {
  double faceValue = purCnt * 1000;
  double price = pricePer10 * purCnt / 10;
  int remainingInterestPeriod =
  getRemainingInterestPeriod(nxtInterestDate, matDate, interestCyclePeriod);
  double interest =
  interestMoney(faceValue, interestPercent, interestCyclePeriod); // 회당 이자
  double totInterest = interest * remainingInterestPeriod;
  double tax = interest * 0.154 * remainingInterestPeriod;

  // 현재 대비 수익 계산
  if (positionMode == 0) {
    // 매수
    return double.parse(
        (isMat ? faceValue + totInterest - tax - price : totInterest - tax)
            .toStringAsFixed(2));
  } else {
    // 매도: 매매 차익 + 이자
    return double.parse(
        (sellPrice + totInterest - tax - price).toStringAsFixed(2));
  }
}

