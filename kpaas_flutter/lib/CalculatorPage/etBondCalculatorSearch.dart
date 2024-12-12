import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/apiconnectiontest/data_controller.dart';
class EtBondCalculatorSearch extends StatefulWidget {
  const EtBondCalculatorSearch({super.key});

  @override
  State<EtBondCalculatorSearch> createState() => _EtBondCalculatorSearchState();
}

class _EtBondCalculatorSearchState extends State<EtBondCalculatorSearch> {
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
          ? "http://localhost:8000/api/marketbond/combined/?search=$query"
          : "";

      final response = await dataController.fetchEtBondData(url);

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
                child: Column(
                  children: [
                    SizedBox(height: kIsWeb ? 0 : MediaQuery.of(context).size.height*0.03),
                    Row(
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
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                '장내 채권 추가',
                                style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
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
                            child: Text(
                              '확인',
                              style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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
                              bondData[actualIndex]['issue_info_data']['prdt_name'] ?? 'N/A',
                              style: TextStyle(
                                fontSize:  kIsWeb
                            ? 30 : MediaQuery.of(context).size.height * 0.03,
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
                                        Text(
                                          '잔존 수량',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: const Color(0xFF696969),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${bondData[actualIndex]['inquire_asking_price_data']['total_askp_rsqn'] ??
                                              'N/A'}개월",
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '듀레이션',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Color(0xFF696969),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${bondData[actualIndex]['duration']['duration'] ??
                                              "N/A"}년",
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
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
                                        Text(
                                          '신용 등급',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Color(0xFF696969),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          (bondData[actualIndex]['issue_info_data']?['kbp_crdt_grad_text'] != null && bondData[actualIndex]['issue_info_data']!['kbp_crdt_grad_text'].toString().isNotEmpty)
                                              ? bondData[actualIndex]['issue_info_data']['kbp_crdt_grad_text']
                                              : '무위험',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '만기일',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Color(0xFF696969),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          formatDate(
                                              bondData[actualIndex]['issue_info_data']['expd_dt']) ??
                                              'N/A',
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '세후 수익률',
                                        style: TextStyle(
                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${((double.tryParse(bondData[actualIndex]['inquire_asking_price_data']?['seln_ernn_rate1']?.toString() ?? '0.0'))! * 0.846).toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '발행일',
                                        style: TextStyle(
                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                          color: const Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        formatDate(
                                            bondData[actualIndex]['issue_info_data']['issu_dt']) ??
                                            'N/A',
                                        style: TextStyle(
                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
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

