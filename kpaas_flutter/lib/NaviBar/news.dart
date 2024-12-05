import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // 날짜 포맷 변환에 필요한 intl 패키지
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:kpaas_flutter/apiconnectiontest/data_controller.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';

class NewsPage extends StatefulWidget {
  final List<dynamic> newsData;
  final String idToken;

  const NewsPage({Key? key, required this.newsData, required this.idToken}) : super(key: key);  // 생성자 추가

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> _newsData = [];
  final DataController dataController = Get.find<DataController>();  // GetX 컨트롤러 사용

  @override
  void initState() {
    super.initState();
    _newsData = widget.newsData;  // 처음에 받아온 뉴스 데이터를 설정
  }

  // HTML 태그와 특수 문자를 제거하는 필터 함수
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

  // URL을 여는 함수
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  // pubDate를 10.11 14:47 형식으로 변환하는 함수
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

  // 새로고침 기능 구현 (API 요청을 통해 뉴스 데이터를 다시 가져옴)
  Future<void> _refreshNews() async {
    List<dynamic> refreshedNewsData = await dataController.fetchNewsData();  // API 재요청

    setState(() {
      _newsData = refreshedNewsData;  // 새로 받아온 데이터로 업데이트
    });
  }

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
                '뉴스',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white, // 앱바 배경색
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black), // 사용자 아이콘 추가
            onPressed: () {
              // 사용자 아이콘 클릭 시 MyPage로 이동
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
      body: RefreshIndicator(
        onRefresh: _refreshNews,  // Pull-to-Refresh 동작 연결
        child: ListView.builder(
          itemCount: _newsData.length + 1,  // 아이템 수 + 첫 번째 위젯을 위한 공간
          itemBuilder: (context, index) {
            if (index == 0) {
              // 첫 번째 아이템 전에 SizedBox 추가 (앱바와 첫 번째 뉴스 아이템 사이의 공간)
              return const SizedBox(height: 20);  // 원하는 크기의 간격 설정
            }

            final actualIndex = index - 1;  // 실제 데이터 인덱스
            String filteredTitle = filterHtmlTags(_newsData[actualIndex]['title']);
            String filteredDescription = filterHtmlTags(_newsData[actualIndex]['description']);
            String originalLink = _newsData[actualIndex]['originallink'];  // 원본 링크
            String formattedPubDate = formatPubDate(_newsData[actualIndex]['pubDate']);  // 날짜 형식 변환

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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      filteredDescription,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Color(0xFF6c6c6d),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedPubDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
