import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../apiconnectiontest/data_controller.dart';
import 'package:kpaas_flutter/DescriptionPage/otcBondDescription.dart';

class OwningBondDisplay extends StatefulWidget {
  final String idToken;
  const OwningBondDisplay({Key? key, required this.idToken}) : super(key: key);

  @override
  _OwningBondDisplayState createState() => _OwningBondDisplayState();
}

class _OwningBondDisplayState extends State<OwningBondDisplay> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> bondData = [];
  String? nextUrl;
  bool isLoading = false;
  String searchQuery = "";

  Future<void> _fetchBondData({String query = '', required String idToken}) async {
    final dio = Dio();
    setState(() {
      isLoading = true;
    });
    try {
      print(idToken);
      final response = await dio.get(
        'http://localhost:8000/api/otcbond/holding/?query=$query',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> results = response.data['results'];

        List<dynamic> metaValues = results.map((item) {
          if (item['meta'] is String) {
            return jsonDecode(item['meta']);
          }
          return item['meta'];
        }).toList();

        setState(() {
          bondData = metaValues; // 데이터 업데이트
          nextUrl = response.data['next']; // 다음 페이지 URL 설정
        });
        print('Bond data fetched successfully: $bondData');
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
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
        bondData.addAll(response['results']['meta'] ?? []); // Append new data to bondData
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

  @override
  void initState() {
    super.initState();
    String idToken = "eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJlNmYyYjJhOGExNTFhMWNmN2FkNmRhMzQ5MTg5OTdmNSIsInN1YiI6IjM3Nzc1MTM2MTAiLCJhdXRoX3RpbWUiOjE3MzMzNzAyNTQsImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwiZXhwIjoxNzMzMzkxODU0LCJpYXQiOjE3MzMzNzAyNTQsImVtYWlsIjoiZGxlZUBzdHUuaWljcy5rMTIudHIifQ.oz4zdLoO14JklujYkc5tGXzabe-iRqNfWG3bMCHYzhbN0Tm8ic7YQZDfGVEohYwMH8vORDLgCf22aYrNQ2rjyvvkvlVg4vjN6uAT2QPn8dAyok3cDlUUr7pal6Am7T4zd8JRUzsqpkn2uBvIa1uI33LFqPsXBTfdd13So0KRxlS3JCWFRBi5tdNQcDNAK6-D9AzCqBiF6H-6fyeDucF9Lv9seNJEc1HOHja_BlLgLP67g5vLV0zONkfnxT145JO8GkwgHa0WEZqnMR8tBN0L2XRv7yycG9vFQUNs0hjN-esvh9VDX4PkSJWWEsT7MEPQ3xqxvAZ4f7RVGXbm5gEWPQ";
    _fetchBondData(idToken: idToken);

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
                            '보유 채권',
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
                      searchQuery = query;
                      _fetchBondData(query: searchQuery, idToken: 'eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9');
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtcBondDescriptionPage(
                              bondData: bondData[actualIndex], // 선택한 bondData 전달
                              idToken: widget.idToken,
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
        ),
      ),
    );
  }
}
