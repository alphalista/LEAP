import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/apiconnectiontest/data_controller.dart';

class OtcBondCalculatorSearch extends StatefulWidget {
  const OtcBondCalculatorSearch({Key? key,}) : super(key: key);

  @override
  _OtcBondCalculatorSearch createState() => _OtcBondCalculatorSearch();
}

class _OtcBondCalculatorSearch extends State<OtcBondCalculatorSearch> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> bondData = [];
  bool isLoading = false;
  String searchQuery = "";

  Future<void> _fetchBondData({String query = ""}) async {
    setState(() {
      isLoading = true; // 로딩 상태 설정
    });

    try {
      final dataController = Get.find<DataController>();
      final String url = query.isNotEmpty
          ? "http://localhost:8000/api/otcbond/otc-bond-all/?query=$query"
          : "";

      final response = await dataController.fetchOtcBondData(url);

      setState(() {
        bondData = response['results'] ?? [];
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


  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F9),
      body: Center(
        child: Container(
          width: 500,
          color: const Color(0xFFF1F1F9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 20,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            '장외 채권 추가',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '확인',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        selectedIndex = actualIndex;
                        Navigator.pop(context, bondData[selectedIndex]);
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
        ),
      ),
    );
  }
}
