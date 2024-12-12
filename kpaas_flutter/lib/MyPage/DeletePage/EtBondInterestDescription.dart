import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EtBondInterestDescriptionPage extends StatefulWidget {
  final String idToken;
  final String pdno;
  final int idCode;
  const EtBondInterestDescriptionPage({Key? key, required this.pdno, required this.idToken, required this.idCode}) : super(key: key);

  @override
  _EtBondInterestDescriptionPageState createState() => _EtBondInterestDescriptionPageState();
}

class _EtBondInterestDescriptionPageState extends State<EtBondInterestDescriptionPage> {
  String selectedText = '정보';
  String selectedChart = '시가';
  String selectedPeriod = '주별';
  bool isLoading = true;
  Map<String, dynamic> bondDetails = {};
  String getKbpCreditGradeText(Map<String, dynamic> data) {
    final value = data['issue_info_data']?['kbp_crdt_grad_text'];
    return (value == null || value == '') ? '무위험' : value;
  }

  String getBondInterestMethodText(String? code) {
    switch (code) {
      case '01':
        return '발행일';
      case '02':
        return '만기일';
      case '03':
        return '특정일';
      default:
        return 'N/A';
    }
  }

  List<String> leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
  List<String> rightColumnData = ['N/A', '54.12.05', '국채', '무위험', '복리채', '24.11.03', '1개월']; // 초기값 설정
  List<String> profitRightColumnData = ['4.63%', '3.94%', '3.27%', '12402.0'];

  late List<QuoteData> quoteData;
  late QuoteDataSource quoteDataSource;

  @override
  void initState() {
    super.initState();
    fetchBondDetails();
    chartData = weeklyMarketPriceData;
    quoteData = getQuoteData();
    quoteDataSource = QuoteDataSource(quoteData);
  }

  Future<void> fetchBondDetails() async {
    final url = 'http://localhost:8000/api/marketbond/marketbond/data/?pdno=${widget.pdno}';
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        setState(() {
          bondDetails = response.data;
          isLoading = false; // 데이터를 가져오면 로딩 상태를 false로 변경

          quoteData = getQuoteData();
          quoteDataSource = QuoteDataSource(quoteData);

          rightColumnData = [
            formatDate(bondDetails['issue_info_data']?['issu_dt']),  // 발행일
            formatDate(bondDetails['issue_info_data']?['expd_dt']),  // 만기일
            bondDetails['issue_info_data']?['bond_clsf_kor_name'] ?? 'N/A', // 채권 종류
            getKbpCreditGradeText(bondDetails),  // 위험도 (데이터 없음 예시로 설정)
            getBondInterestMethodText(bondDetails['issue_info_data']?['bond_int_dfrm_mthd_cd']),  // 이자 지급 구분
            formatDate(bondDetails['issue_info_data']?['nxtm_int_dfrm_dt']),  // 차기 이자 지급일
            "${bondDetails['issue_info_data']?['int_dfrm_mcnt']}개월" ?? 'N/A',
          ];

          profitRightColumnData = [
            "${(((double.parse(bondDetails['issue_info_data']?['srfc_inrt']?.toString() ?? '0.0'))).toStringAsFixed(2))}%",
            "${(((double.parse(bondDetails['inquire_asking_price_data']?['shnu_ernn_rate5']?.toString() ?? '0.0'))).toStringAsFixed(2))}%",
            "${(((double.parse(bondDetails['inquire_asking_price_data']?['shnu_ernn_rate5']?.toString() ?? '0.0')) * 0.846).toStringAsFixed(2))}%",
            "${bondDetails['inquire_price_data']?['bond_prpr']}원",
          ];
        });
      } else {
        print("Failed to fetch bond data: ${response.statusMessage}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (e is DioException) {
        print("Dio error: ${e.message}");
        print("Dio error type: ${e.type}");
      } else {
        print("Unknown error: $e");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<String> profitLeftColumnData = ['이자율', '세전 수익률', '세후 수익률', '예상 수익금'];

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
    _ChartData('11월', 10580),
    _ChartData('12월', 10614),
    _ChartData('1월', 10627),
    _ChartData('2월', 10611),
    _ChartData('3월', 10631),
    _ChartData('4월', 10602),
    _ChartData('5월', 10619),
    _ChartData('6월', 10616),
    _ChartData('7월', 10598),
    _ChartData('8월', 10603),
    _ChartData('9월', 10635),
    _ChartData('10월', 10590),
  ];

  final List<_ChartData> weeklyDurationData = [
    _ChartData('일', 6.83),
    _ChartData('월', 6.68),
    _ChartData('화', 6.56),
    _ChartData('수', 6.24),
    _ChartData('목', 6.08),
    _ChartData('금', 5.79),
    _ChartData('토', 5.67),
  ];

  final List<_ChartData> monthlyDurationData = [
    _ChartData('11월', 7.68),
    _ChartData('12월', 7.48),
    _ChartData('1월', 7.21),
    _ChartData('2월', 7.47),
    _ChartData('3월', 7.34),
    _ChartData('4월', 7.5),
    _ChartData('5월', 7.74),
    _ChartData('6월', 7.95),
    _ChartData('7월', 7.57),
    _ChartData('8월', 7.4),
    _ChartData('9월', 7.61),
    _ChartData('10월', 7.39),
  ];

  List<_ChartData> chartData = [];

  void _updateTextContent(String type) {
    setState(() {
      selectedText = type;
      if (type == '정보') {
        leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
        rightColumnData = [
          formatDate(bondDetails['issue_info_data']?['issu_dt']),  // 발행일
          formatDate(bondDetails['issue_info_data']?['expd_dt']),  // 만기일
          bondDetails['issue_info_data']?['bond_clsf_kor_name'] ?? 'N/A', // 채권 종류
          getKbpCreditGradeText(bondDetails),
          getBondInterestMethodText(bondDetails['issue_info_data']?['bond_int_dfrm_mthd_cd']),  // 이자 지급 구분
          formatDate(bondDetails['issue_info_data']?['nxtm_int_dfrm_dt']),  // 차기 이자 지급일
          bondDetails['issue_info_data']?['int_dfrm_mcnt'] ?? 'N/A',
        ];
      } else if (type == '수익') {
        leftColumnData = profitLeftColumnData;
        rightColumnData = profitRightColumnData;
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

  String formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(0, 4)} - ${date.substring(4, 6)} - ${date.substring(6, 8)}';
    }
    return date;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          width: 500,
          color: const Color(0xFFF1F1F9),
          child: isLoading
              ? const CircularProgressIndicator()
              :Column(
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
                              '장내채권',
                              style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                bool? confirmed = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text(
                                                "정말 삭제하시겠습니까?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: kIsWeb ? 15 : MediaQuery.of(context).size.height * 0.02, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false); // 취소 버튼 클릭 시 false 반환
                                                  },
                                                  child: Text(
                                                      "취소",
                                                      style: TextStyle(
                                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold, color: Colors.black)
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true); // 확인 버튼 클릭 시 true 반환
                                                  },
                                                  child: Text("삭제",
                                                      style: TextStyle(
                                                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold, color: Colors.black)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (confirmed == true) {
                                  final dio = Dio();
                                  try {
                                    await dio.delete(
                                      'http://localhost:8000/api/marketbond/interest/${widget.pdno}/',
                                      options: Options(
                                        headers: {
                                          'Authorization': 'Bearer ${widget.idToken}',
                                        },
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    print("삭제 실패: $e");
                                  }
                                }
                              },
                            ),
                            Text(
                              '삭제',
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
                        bondDetails['issue_info_data']?['prdt_name'] ?? 'N/A',
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
                          child: Text(
                            "(${widget.pdno})",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            bondDetails['inquire_price_data']['bond_prpr'],
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
                      onTap: () => _updateTextContent('호가'),
                      child: Text(
                        '호가',
                        style: TextStyle(
                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.bold,
                          color: selectedText == '호가' ? Colors.black : Colors.grey,
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
                      ),
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
                child: selectedText == '호가'
                    ? SfDataGrid(
                  source: QuoteDataSource(quoteData),
                  columnWidthMode: ColumnWidthMode.fill,
                  gridLinesVisibility: GridLinesVisibility.none,
                  headerGridLinesVisibility: GridLinesVisibility.none,
                  headerRowHeight: 30,
                  rowHeight: 22.0,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: '매도 수익율',
                        label: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Text(
                              '매도 수익율',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015),
                            ))),
                    GridColumn(
                        columnName: '매도 잔량',
                        label: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Text(
                              '매도 잔량',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015),
                            ))),
                    GridColumn(
                        columnName: '호가',
                        label: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Text(
                              '호가',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015),
                            ))),
                    GridColumn(
                        columnName: '매수 잔량',
                        label: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Text(
                              '매수 잔량',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015),
                            ))),
                    GridColumn(
                        columnName: '매수 수익율',
                        label: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Text(
                              '매수 수익율',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015),
                            ))),
                  ],
                )
                    : Row(
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
              Expanded(
                child: Container(
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
    );
  }
  List<QuoteData> getQuoteData() {
    final askingPriceData = bondDetails['inquire_asking_price_data'] ?? {};

    return [
      QuoteData(
        askingPriceData['seln_ernn_rate2'] ?? 'N/A',
        askingPriceData['askp_rsqn2'] ?? 'N/A',
        askingPriceData['bond_askp2'] ?? 'N/A',
        '',
        '',
      ),
      QuoteData(
        askingPriceData['seln_ernn_rate3'] ?? 'N/A',
        askingPriceData['askp_rsqn3'] ?? 'N/A',
        askingPriceData['bond_askp3'] ?? 'N/A',
        '',
        '',
      ),
      QuoteData(
        askingPriceData['seln_ernn_rate4'] ?? 'N/A',
        askingPriceData['askp_rsqn4'] ?? 'N/A',
        askingPriceData['bond_askp4'] ?? 'N/A',
        '',
        '',
      ),
      QuoteData(
        askingPriceData['seln_ernn_rate5'] ?? 'N/A',
        askingPriceData['askp_rsqn5'] ?? 'N/A',
        askingPriceData['bond_askp5'] ?? 'N/A',
        '',
        '',
      ),
      QuoteData(
        '',
        '',
        askingPriceData['bond_bidp2'] ?? 'N/A',
        askingPriceData['bidp_rsqn2'] ?? 'N/A',
        askingPriceData['shnu_ernn_rate2'] ?? 'N/A',
      ),
      QuoteData(
        '',
        '',
        askingPriceData['bond_bidp3'] ?? 'N/A',
        askingPriceData['bidp_rsqn3'] ?? 'N/A',
        askingPriceData['shnu_ernn_rate3'] ?? 'N/A',
      ),
      QuoteData(
        '',
        '',
        askingPriceData['bond_bidp4'] ?? 'N/A',
        askingPriceData['bidp_rsqn4'] ?? 'N/A',
        askingPriceData['shnu_ernn_rate4'] ?? 'N/A',
      ),
      QuoteData(
        '',
        '',
        askingPriceData['bond_bidp5'] ?? 'N/A',
        askingPriceData['bidp_rsqn5'] ?? 'N/A',
        askingPriceData['shnu_ernn_rate5'] ?? 'N/A',
      ),
    ];
  }
}


class QuoteData {
  QuoteData(this.sellProfit, this.sellAmount, this.price, this.buyAmount, this.buyProfit);
  final String sellProfit;
  final String sellAmount;
  final String price;
  final String buyAmount;
  final String buyProfit;
}

class QuoteDataSource extends DataGridSource {
  QuoteDataSource(List<QuoteData> quoteData) {
    dataGridRows = quoteData
        .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: '매도 수익율', value: data.sellProfit),
      DataGridCell<String>(columnName: '매도 잔량', value: data.sellAmount),
      DataGridCell<String>(columnName: '호가', value: data.price),
      DataGridCell<String>(columnName: '매수 잔량', value: data.buyAmount),
      DataGridCell<String>(columnName: '매수 수익율', value: data.buyProfit),
    ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

class _ChartData {
  _ChartData(this.label, this.value);
  final String label;
  final double value;
}
