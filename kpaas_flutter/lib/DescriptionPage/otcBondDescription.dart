import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OtcBondDescriptionPage extends StatefulWidget {
  final Map<String, dynamic> bondData;
  final String idToken;
  const OtcBondDescriptionPage({Key? key, required this.bondData, required this.idToken}) : super(key: key);


  @override
  _OtcBondDescriptionPageState createState() => _OtcBondDescriptionPageState();
}

class _OtcBondDescriptionPageState extends State<OtcBondDescriptionPage> {
  // 선택 상태 관리 변수
  String selectedText = '정보';
  String selectedChart = '시가';
  String selectedPeriod = '주별';

  // 정보와 수익 데이터
  List<String> leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
  List<String> rightColumnData = [];

  // 수익 데이터
  final List<String> profitLeftColumnData = ['이자율', '세전 수익률', '세후 수익률', '예상 수익금'];
  List<String> profitRightColumnData = [];
  bool isLoading = true;
  Map<String, dynamic> bondDailyData = {};

  List<_ChartData> chartData = [];

  final List<_ChartData> weeklyMarketPriceData = [
    _ChartData('일', 9410),
    _ChartData('월', 9370),
    _ChartData('화', 9381),
    _ChartData('수', 9354),
    _ChartData('목', 9402),
    _ChartData('금', 9362),
    _ChartData('토', 9287),
  ];


  final List<_ChartData> monthlyMarketPriceData = [
    _ChartData('11월', 11555),
    _ChartData('12월', 11539),
    _ChartData('1월', 11495),
    _ChartData('2월', 11513),
    _ChartData('3월', 11486),
    _ChartData('4월', 11494),
    _ChartData('5월', 11528),
    _ChartData('6월', 11526),
    _ChartData('7월', 11501),
    _ChartData('8월', 11508),
    _ChartData('9월', 11476),
    _ChartData('10월', 11500),
  ];

  final List<_ChartData> weeklyDurationData = [
    _ChartData('일', 7.49),
    _ChartData('월', 7.33),
    _ChartData('화', 7.04),
    _ChartData('수', 6.64),
    _ChartData('목', 6.86),
    _ChartData('금', 6.61),
    _ChartData('토', 6.36),
  ];

  final List<_ChartData> monthlyDurationData = [
    _ChartData('11월', 9.34),
    _ChartData('12월', 9.03),
    _ChartData('1월', 7.04),
    _ChartData('2월', 8.71),
    _ChartData('3월', 8.51),
    _ChartData('4월', 8.22),
    _ChartData('5월', 8.38),
    _ChartData('6월', 8.17),
    _ChartData('7월', 7.79),
    _ChartData('8월', 7.58),
    _ChartData('9월', 7.19),
    _ChartData('10월', 7.04),
  ];


  String formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(0, 4)} - ${date.substring(4, 6)} - ${date.substring(6, 8)}';
    }
    return date;
  }

  // 초기화 및 데이터 변경 함수
  @override
  void initState() {
    super.initState();
    chartData = weeklyMarketPriceData; // 초기값 설정

    rightColumnData = [
      formatDate(widget.bondData['issu_dt']) ?? 'N/A',
      formatDate(widget.bondData['expd_dt']) ?? 'N/A',
      widget.bondData['prdt_type_cd'] ?? 'N/A',
      widget.bondData['nice_crdt_grad_text'] ?? 'N/A',
      widget.bondData['bond_int_dfrm_mthd_cd'] ?? 'N/A',
      formatDate(widget.bondData['nxtm_int_dfrm_dt']) ?? 'N/A',
      "${widget.bondData['int_pay_cycle']}개월" ?? 'N/A',
    ];
  }

  // 텍스트 데이터 변경 함수
  void _updateTextContent(String type) {
    setState(() {
      selectedText = type;
      if (type == '정보') {
        leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
        rightColumnData = [
          formatDate(widget.bondData['issu_dt']) ?? 'N/A',
          formatDate(widget.bondData['expd_dt']) ?? 'N/A',
          widget.bondData['prdt_type_cd'] ?? 'N/A',
          widget.bondData['nice_crdt_grad_text'] ?? 'N/A',
          widget.bondData['bond_int_dfrm_mthd_cd'] ?? 'N/A',
          formatDate(widget.bondData['nxtm_int_dfrm_dt']) ?? 'N/A',
          "${widget.bondData['int_pay_cycle']}개월" ?? 'N/A',
        ];
      } else if (type == '수익') {
        leftColumnData = profitLeftColumnData;
        rightColumnData = [
          "${widget.bondData['interest_percentage']}%" ?? 'N/A',
          "${widget.bondData['YTM']}%" ?? 'N/A',
          "${widget.bondData['YTM_after_tax']}%" ?? 'N/A',
          "${widget.bondData['expt_income']}원" ?? 'N/A',
        ];
      }
    });
  }

  // 기간과 차트 데이터 변경 함수
  void _updateChartData(String type) {
    setState(() {
      selectedChart = type;
      if (type == '시가') {
        chartData = selectedPeriod == '주별' ? weeklyMarketPriceData : monthlyMarketPriceData;
      } else if (type == '듀레이션') {
        chartData = selectedPeriod == '주별' ? weeklyDurationData : monthlyDurationData;
      }
    });
  }

  void _updatePeriod(String period) {
    setState(() {
      selectedPeriod = period;
      _updateChartData(selectedChart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF1F1F9),
        body: SingleChildScrollView(
          child: Center(
          child: Container(
          width: 500,
          color: const Color(0xFFF1F1F9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: kIsWeb ? 0 : MediaQuery.of(context).size.height*0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우에 붙이기 위해 설정
                      children: [
                        // 왼쪽 영역 (백 버튼 + 타이틀)
                        Row(
                          children: [
                            const SizedBox(width: 10,),
                            const BackButton(),
                            Text(
                              '장외채권',
                              style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String? buttonText;
                                    int currentPage = 0; // 현재 페이지 상태
                                    bool showFinalMessage = false; // 최종 메시지 표시 여부
          
                                    TextEditingController firstController = TextEditingController();
                                    TextEditingController secondController = TextEditingController();
                                    TextEditingController thirdController = TextEditingController();
                                    TextEditingController fourthController = TextEditingController();
          
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 470,
                                            height: 150,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: buttonText == null
                                                  ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (!showFinalMessage)
                                                    Text(
                                                      '어디에 추가할까요?',
                                                      style: TextStyle(
                                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  const SizedBox(height: 20),
                                                  if (!showFinalMessage)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            final dio = Dio();
                                                            await dio.post(
                                                              'http://localhost:8000/api/otcbond/interest/',
                                                              data: {
                                                                'bond_code': widget.bondData['code']
                                                              },
                                                              options: Options(
                                                                headers: {
                                                                  'Authorization': 'Bearer ${widget.idToken}',
                                                                },
                                                              ),
                                                            );
                                                            setState(() {
                                                              buttonText = "추가되었습니다!\n마이페이지의 '관심 채권'을 확인하세요!";
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                  (Set<MaterialState> states) {
                                                                return states.contains(MaterialState.hovered) ? Colors.white : Colors.black;
                                                              },
                                                            ),
                                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                  (Set<MaterialState> states) {
                                                                return states.contains(MaterialState.hovered) ? Colors.blueAccent : Colors.white;
                                                              },
                                                            ),
                                                            shape: MaterialStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                                side: const BorderSide(color: Colors.blue),
                                                              ),
                                                            ),
                                                            minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                                          ),
                                                          child: const Text('관심 채권'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              currentPage = 0;
                                                              showFinalMessage = true;
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                  (Set<MaterialState> states) {
                                                                return states.contains(MaterialState.hovered) ? Colors.white : Colors.black;
                                                              },
                                                            ),
                                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                  (Set<MaterialState> states) {
                                                                return states.contains(MaterialState.hovered) ? Colors.blueAccent : Colors.white;
                                                              },
                                                            ),
                                                            shape: MaterialStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                                side: const BorderSide(color: Colors.blue),
                                                              ),
                                                            ),
                                                            minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                                          ),
                                                          child: const Text('보유 채권'),
                                                        ),
                                                      ],
                                                    ),
                                                  if (showFinalMessage)
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        if (currentPage == 0)
                                                          Column(
                                                            children: [
                                                              Text(
                                                                '얼마나 추가할까요?',
                                                                style: TextStyle(
                                                                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              TextField(
                                                                controller: firstController, // 첫 번째 페이지 컨트롤러
                                                                decoration: const InputDecoration(
                                                                  labelText: '구매 갯수',
                                                                  hintText: '예: 1000',
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                                onSubmitted: (value) {
                                                                  setState(() {
                                                                    currentPage++; // 다음 페이지로 이동
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        else if (currentPage == 1)
                                                          Column(
                                                            children: [
                                                              Text(
                                                                '얼마에 구매하셨나요?',
                                                                style: TextStyle(
                                                                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              TextField(
                                                                controller: secondController, // 두 번째 페이지 컨트롤러
                                                                decoration: const InputDecoration(
                                                                  labelText: '구매 가격',
                                                                  hintText: '예: 10000',
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                                onSubmitted: (value) {
                                                                  setState(() {
                                                                    currentPage++; // 다음 페이지로 이동
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        else if (currentPage == 2)
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  '언제 구매하셨나요?',
                                                                  style: TextStyle(
                                                                    fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                TextField(
                                                                  controller: thirdController, // 두 번째 페이지 컨트롤러
                                                                  decoration: const InputDecoration(
                                                                    labelText: '구매 날짜',
                                                                    hintText: 'YYYY-MM-DD',
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                  onSubmitted: (value) {
                                                                    setState(() {
                                                                      currentPage++;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                        else if (currentPage == 3)
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  '채권의 닉네임을 지정해주세요!',
                                                                  style: TextStyle(
                                                                    fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                TextField(
                                                                  controller: fourthController,
                                                                  decoration: const InputDecoration(
                                                                    labelText: '닉네임',
                                                                    hintText: '5글자 이내',
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                  onSubmitted: (value) async {
                                                                    final dio = Dio();
                                                                    await dio.post(
                                                                      'http://localhost:8000/api/otcbond/holding/',
                                                                      data: {
                                                                        'price_per_10': secondController.text,
                                                                        'quantity': firstController.text,
                                                                        'purchase_date': thirdController.text,
                                                                        'expire_date': widget.bondData['expd_dt'],
                                                                        'bond_code': widget.bondData['code'],
                                                                        'nickname': fourthController.text
                                                                      },
                                                                      options: Options(
                                                                        headers: {
                                                                          'Authorization': 'Bearer ${widget.idToken}',
                                                                        },
                                                                      ),
                                                                    );
                                                                    setState(() {
                                                                      buttonText = "추가되었습니다!\n마이페이지의 '보유 채권'을 확인하세요!";
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                      ],
                                                    ),
                                                ],
                                              )
                                                  : Text(
                                                buttonText!,
                                                style: TextStyle(
                                                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  height: 1.5,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                             Text(
                              '추가',
                              style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(width: 20,),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.bondData['prdt_name'] ?? 'N/A',
                      style: TextStyle(
                        fontSize:  kIsWeb
                            ? 30 : MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "(${widget.bondData['issu_istt_name']})" ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "(${widget.bondData['code']})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.bondData['expt_income'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: kIsWeb ? 30 : MediaQuery.of(context).size.height * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                GestureDetector(
                  onTap: () => _updateTextContent('정보'),
                  child: Text(
                    '정보',
                    style: TextStyle(
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.bold,
                      color: selectedText == '정보' ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _updateTextContent('수익'),
                    child: Text(
                      '수익',
                      style: TextStyle(
                        fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.bold,
                        color: selectedText == '수익' ? Colors.black : Colors.grey,
                      ),
                    )
                  ),
                ],
              ),
            ),
              Container(
                height: 240,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: leftColumnData
                            .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(item, style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,)),
                        ))
                            .toList(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: rightColumnData
                            .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(item, style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,)),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Row 간의 공간을 균등하게 분배
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _updateChartData('시가');
                          },
                          child: Text(
                            '시가',
                            style: TextStyle(
                              fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                              fontWeight: FontWeight.bold,
                              color: selectedChart == '시가' ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _updateChartData('듀레이션');
                          },
                          child: Text(
                            '듀레이션',
                            style: TextStyle(
                              fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                              fontWeight: FontWeight.bold,
                              color: selectedChart == '듀레이션' ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _updatePeriod('주별'),
                          child: Text(
                            '주별',
                            style: TextStyle(
                              fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                              fontWeight: FontWeight.bold,
                              color: selectedPeriod == '주별' ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _updatePeriod('월별'),
                          child: Text(
                            '월별',
                            style: TextStyle(
                              fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                              fontWeight: FontWeight.bold,
                              color: selectedPeriod == '월별' ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  height: 300,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      LineSeries<_ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (_ChartData data, _) => data.label,
                        yValueMapper: (_ChartData data, _) => data.value,
                        markerSettings: const MarkerSettings(isVisible: true),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
          ),
        ),
    );
  }
}

// 그래프 데이터 클래스
class _ChartData {
  _ChartData(this.label, this.value);
  final String label;
  final double value;
}
