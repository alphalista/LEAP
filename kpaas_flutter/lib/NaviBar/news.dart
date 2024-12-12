import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // 날짜 포맷 변환에 필요한 intl 패키지
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/apiconnectiontest/data_controller.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';

class NewsPage extends StatefulWidget {
  final List<dynamic> newsData;
  final String initialNextUrl;
  final String idToken;

  const NewsPage({Key? key, required this.initialNextUrl, required this.newsData, required this.idToken}) : super(key: key);  // 생성자 추가

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> newsData = [];
  String nextUrl = "";
  final DataController dataController = Get.find<DataController>();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    newsData = widget.newsData;
    nextUrl = widget.initialNextUrl;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _fetchMoreData();
      }
    });
  }

  Future<void> _fetchMoreData() async {
    if (nextUrl.isEmpty) return; // Check if there's a next URL

    setState(() {
      isLoading = true;  // Start loading state
    });

    try {
      final dataController = Get.find<DataController>();
      final response = await dataController.fetchNewsBondData(nextUrl);
      setState(() {
        newsData.addAll(response['results'] ?? []); // Append new data to bondData
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

  String filterHtmlTags(String input) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    String cleanedText = input.replaceAll(htmlTagRegExp, '');
    cleanedText = cleanedText.replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&apos;', "'");
    return cleanedText;
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  String formatPubDate(String pubDate) {
    try {
      DateTime dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z", "en_US").parse(pubDate);
      String formattedDate = DateFormat("MM.dd HH:mm", "ko_KR").format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Date parsing error: $e');
      return pubDate;  // 변환에 실패하면 원래 값을 반환
    }
  }

  // Future<void> _refreshNews() async {
  //   List<dynamic> refreshedNewsData = await dataController.fetchNewsData();
  //   setState(() {
  //     _newsData = refreshedNewsData;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F9),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '뉴스',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white, // 앱바 배경색
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage(
                  idToken: widget.idToken,
                )), // MyPage로 이동
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: newsData.length + 1,  // 아이템 수 + 첫 번째 위젯을 위한 공간
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 20);
          }
          if (index == newsData.length) {
            return _buildLoadingIndicator();
          }

          final actualIndex = index - 1;  // 실제 데이터 인덱스
          String filteredTitle = filterHtmlTags(newsData[actualIndex]['title']);
          String filteredDescription = filterHtmlTags(newsData[actualIndex]['description']);
          String originalLink = newsData[actualIndex]['originallink'];  // 원본 링크
          String formattedPubDate = formatPubDate(newsData[actualIndex]['pubDate']);  // 날짜 형식 변환

          return GestureDetector(
            onTap: () => _launchURL(originalLink),  // 제목 클릭 시 URL 열기
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // 배경 색상
                borderRadius: BorderRadius.circular(12), // 둥근 모서리
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 그림자 색상
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 0), // 그림자의 위치
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filteredTitle,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filteredDescription,
                    maxLines: 3,
                    style: TextStyle(
                      color: Color(0xFF6c6c6d),
                      fontSize: kIsWeb ? 15 : MediaQuery.of(context).size.height * 0.015,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedPubDate,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.01,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
