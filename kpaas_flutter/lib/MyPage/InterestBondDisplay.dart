import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../apiconnectiontest/data_controller.dart';
import 'DeletePage/EtBondInterestDescription.dart';
import 'DeletePage/OtcBondInterestDescription.dart';

class InterestBondDisplay extends StatefulWidget {
  final String idToken;
  const InterestBondDisplay({Key? key, required this.idToken}) : super(key: key);

  @override
  _InterestBondDisplayState createState() => _InterestBondDisplayState();
}

class _InterestBondDisplayState extends State<InterestBondDisplay> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> otcBondData = [];
  List<dynamic> etBondData = [];
  String? otcNextUrl;
  String? etNextUrl;
  bool isLoading = false;
  String searchQuery = "";
  bool EtBond = true;
  bool OtcBond = false;

  Future<void> _fetchOtcBondData({String query = '', required String idToken}) async {
    final dio = Dio();
    setState(() {
      isLoading = true;
    });
    try {
      final otcResponse = await dio.get(
        'http://localhost:8000/api/otcbond/interest/?query=$query',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (otcResponse.statusCode == 200) {
        List<dynamic> otcResults = otcResponse.data['results'];
        List<Map<String, dynamic>> finalOtcResults = otcResults.map((item) {
          dynamic metaValue = item['meta'] is String ? jsonDecode(item['meta']) : item['meta'];
          return {
            "id": item['id'],
            "value": metaValue
          };
        }).toList();


        setState(() {
          otcBondData = finalOtcResults;
          otcNextUrl = otcResponse.data['next']; // 다음 페이지 URL 설정
          isLoading = false;
        });
      } else {
        print('Failed to fetch OTC bond data: ${otcResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching OTC bond data: $e");
    }
  }

  Future<void> _fetchEtBondData({String query = '', required String idToken}) async {
    final dio = Dio();
    setState(() {
      isLoading = true;
    });
    try {
      final etResponse = await dio.get(
        'http://localhost:8000/api/marketbond/interest/?query=$query',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        ),
      );

      if (etResponse.statusCode == 200) {
        List<dynamic> etResults = etResponse.data['results'];
        List<Map<String, dynamic>> finalEtResults = etResults.map((item) {
          dynamic metaValue = item['meta'] is String ? jsonDecode(item['meta']) : item['meta'];
          return {
            "id": item['id'],
            "value": metaValue
          };
        }).toList();


        setState(() {
          etBondData = finalEtResults;
          etNextUrl = etResponse.data['next']; // 다음 페이지 URL 설정
          isLoading = false;
        });
      } else {
        print('Failed to fetch ET bond data: ${etResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching ET bond data: $e");
    }
  }


  Future<void> _fetchMoreOtcData() async {
    if (otcNextUrl == null || otcNextUrl!.isEmpty)
      return; // Check if there's a next URL

    setState(() {
      isLoading = true; // Start loading state
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchOtcBondData(otcNextUrl!);
      setState(() {
        otcBondData.addAll(
            response['results']['meta'] ?? []); // Append new data to bondData
        otcNextUrl = response['next']; // Update next URL
      });
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      setState(() {
        isLoading = false; // End loading state
      });
    }
  }

  Future<void> _fetchMoreEtData() async {
    if (etNextUrl == null || etNextUrl!.isEmpty)
      return; // Check if there's a next URL

    setState(() {
      isLoading = true; // Start loading state
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchEtBondData(etNextUrl!);
      setState(() {
        etBondData.addAll(
            response['results']['meta'] ?? []); // Append new data to bondData
        etNextUrl = response['next']; // Update next URL
      });
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      setState(() {
        isLoading = false; // End loading state
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEtBondData(idToken: widget.idToken);
    _fetchOtcBondData(idToken: widget.idToken);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !isLoading) {
        if (EtBond) {
          _fetchMoreEtData();
        } else {
          _fetchMoreOtcData();
        }
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                                '관심 채권',
                                style: TextStyle(
                                    fontSize:  kIsWeb
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
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                  fontWeight: FontWeight.bold),
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
                      searchQuery = query;
                      EtBond
                      ? _fetchEtBondData(query: searchQuery, idToken: widget.idToken)
                      : _fetchOtcBondData(query: searchQuery, idToken: widget.idToken);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              EtBond = true;
                              OtcBond = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: EtBond
                                  ? Colors.blueAccent
                                  : Colors.white,
                              side: const BorderSide(
                                color: Colors.blueAccent,
                              )
                          ),
                          child: Text(
                            "장내",
                            style: TextStyle(
                              color: EtBond ? Colors.white : Colors.blueAccent
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              EtBond = false;
                              OtcBond = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: OtcBond
                                  ? Colors.blueAccent
                                  : Colors.white,
                              side: const BorderSide(
                                color: Colors.blueAccent
                              )
                          ),
                          child: Text(
                            "장외",
                            style: TextStyle(
                              color: OtcBond ? Colors.white : Colors.blueAccent
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: (etBondData.isEmpty) && (otcBondData.isEmpty)
                    ? const Center(child: Text('등록된 채권이 없습니다'))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: EtBond
                      ? (etBondData.isNotEmpty ? etBondData.length + 1 : 0)
                      : (otcBondData.isNotEmpty ? otcBondData.length + 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(height: 0);
                    }

                    var actualIndex = index - 1;

                    if (EtBond && actualIndex >= etBondData.length) {
                      return _buildLoadingIndicator();
                    } else if (!EtBond && actualIndex >= otcBondData.length) {
                      return _buildLoadingIndicator();
                    }


                    return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                if (EtBond) {
                                  return EtBondInterestDescriptionPage(
                                    pdno: etBondData[actualIndex]["value"]['issue_info_data']['pdno'],
                                    idToken: widget.idToken,
                                    idCode: etBondData[actualIndex]['id'],
                                  );
                                } else {
                                  return OtcBondInterestDescriptionPage(
                                    bondData: otcBondData[actualIndex]["value"], // 선택한 bondData 전달
                                    idToken: widget.idToken,
                                    idCode: otcBondData[actualIndex]['id'],
                                  );
                                }
                              },
                            ),
                          );
                          _fetchEtBondData(idToken: widget.idToken);
                          _fetchOtcBondData(idToken: widget.idToken);
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
                              (EtBond
                                  ? "${etBondData[actualIndex]["value"]['issue_info_data']?['prdt_name']}"
                                  : "${otcBondData[actualIndex]["value"]['prdt_name']}"),
                              style: TextStyle(
                                fontSize:  kIsWeb
                            ? 30 : MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: EtBond
                              ? const EdgeInsets.symmetric(horizontal: 20.0)
                              : const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          (EtBond ? "잔존 수량" : "이자 지급 주기"),
                                          style: TextStyle(
                                            fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                            color: const Color(0xFF696969),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        Text(
                                          (EtBond
                                              ? "${etBondData[actualIndex]["value"]['inquire_asking_price_data']?['total_askp_rsqn']}"
                                              : "${otcBondData[actualIndex]["value"]['int_pay_cycle'] ??
                                              'N/A'}개월"),
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
                                          (EtBond
                                              ? "${etBondData[actualIndex]["value"]['duration']?['duration']}년"
                                              : "${otcBondData[actualIndex]["value"]['duration'] ??
                                              "N/A"}년"),
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
                                          (EtBond
                                              ? "${etBondData[actualIndex]["value"]['issue_info_data']?['kbp_crdt_grad_text'] !=
                                              null &&
                                              etBondData[actualIndex]['value']['issue_info_data']!['kbp_crdt_grad_text']
                                                  .toString()
                                                  .isNotEmpty
                                              ? etBondData[actualIndex]['value']['issue_info_data']!['kbp_crdt_grad_text']
                                              : '무위험'}"
                                              : "${otcBondData[actualIndex]["value"]['nice_crdt_grad_text'] ??
                                              'N/A'}"),
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
                                          (EtBond
                                              ? formatDate(
                                              etBondData[actualIndex]["value"]['issue_info_data']['expd_dt'])
                                              : formatDate(
                                              otcBondData[actualIndex]["value"]['expd_dt'])),
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
                                        (EtBond
                                            ? '${((double.tryParse(
                                            etBondData[actualIndex]["value"]['inquire_asking_price_data']?['shnu_ernn_rate5']
                                                ?.toString() ?? '0.0'))! *
                                            0.846).toStringAsFixed(2)}%'
                                            : "${otcBondData[actualIndex]["value"]['YTM_after_tax']}%"),
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
                                          color: Color(0xFF696969),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        (EtBond
                                            ? formatDate(
                                            etBondData[actualIndex]["value"]['issue_info_data']['issu_dt'])
                                            : formatDate(
                                            otcBondData[actualIndex]["value"]['issu_dt'])),
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