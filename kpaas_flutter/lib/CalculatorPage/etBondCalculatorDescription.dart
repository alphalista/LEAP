import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EtBondCalculatorPage extends StatefulWidget {
  final String pdno;
  const EtBondCalculatorPage({Key? key, required this.pdno}) : super(key: key);

  @override
  _EtBondCalculatorPageState createState() => _EtBondCalculatorPageState();
}

class _EtBondCalculatorPageState extends State<EtBondCalculatorPage> {
  String selectedText = '정보';
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
  List<String> rightColumnData = ['23.12.17', '54.12.05', '국채', '무위험', '복리채', '24.11.03', '1개월'];
  late List<QuoteData> quoteData;
  late QuoteDataSource quoteDataSource;
  final List<String> profitLeftColumnData = ['이자율', '세전 수익률', '세후 수익률', '예상 수익금'];
  List<String> profitRightColumnData = ['4.63%', '3.94%', '3.27%', '12402.0'];

  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _purchaseQuantity = TextEditingController();
  final TextEditingController _expectedPurchaseDate = TextEditingController();
  final TextEditingController _salePrice = TextEditingController();
  final TextEditingController _saleQuantity = TextEditingController();
  final TextEditingController _expectedSaleDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBondDetails();
    quoteData = getQuoteData();
    quoteDataSource = QuoteDataSource(quoteData);

    _purchasePriceController.text = '';
    _purchaseQuantity.text = '';
    _expectedPurchaseDate.text = '';
    _salePrice.text = '';
    _saleQuantity.text = '';
    _expectedSaleDate.text = '';
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
  void _updateTextContent(String type) {
    setState(() {
      selectedText = type;
      if (type == '정보') {
        leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
        rightColumnData = [
          formatDate(bondDetails['issue_info_data']?['issu_dt']),  // 발행일
          formatDate(bondDetails['issue_info_data']?['expd_dt']),  // 만기일
          bondDetails['issue_info_data']?['bond_clsf_kor_name'] ?? 'N/A', // 채권 종류
          getKbpCreditGradeText(bondDetails),  // 위험도 (데이터 없음 예시로 설정)
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
          : Column(
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
                                  Icons.arrow_back, // 원하는 아이콘 (BackButton과 동일한 모양)
                                  size: 20, // 아이콘 크기 조정
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                '장내 채권 설정',
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
                              String purchasePrice = _purchasePriceController.text;
                              String purchaseQuantity = _purchaseQuantity.text;
                              String expectedPurchaseDate = _expectedPurchaseDate.text;
                              String salePrice = _salePrice.text;
                              String saleQuantity = _saleQuantity.text;
                              String expectedSaleDate = _expectedSaleDate.text;

                              Navigator.pop(context, {
                                'code': widget.pdno,
                                'purchasePrice': purchasePrice,
                                'purchaseQuantity': purchaseQuantity,
                                'expectedPurchaseDate': expectedPurchaseDate,
                                'salePrice': salePrice,
                                'saleQuantity': saleQuantity,
                                'expectedSaleDate': expectedSaleDate,
                              });
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
              Expanded(
                child: ListView(
                  children: [
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
                                fontWeight: FontWeight.bold,
                                fontSize: kIsWeb
                                    ? 20 : MediaQuery.of(context).size.height * 0.018,
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
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                  ))),
                          GridColumn(
                              columnName: '매도 잔량',
                              label: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '매도 잔량',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                  ))),
                          GridColumn(
                              columnName: '호가',
                              label: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '호가',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                  ))),
                          GridColumn(
                              columnName: '매수 잔량',
                              label: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '매수 잔량',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                  ))),
                          GridColumn(
                              columnName: '매수 수익율',
                              label: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '매수 수익율',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "매수 정보",
                              style: TextStyle(
                                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const Tooltip(
                              message: "매수 단가: 채권 매수 희망 가격을 말합니다\n매수 수량: 매수 희망 채권의 액면가를 말하는 것으로\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t단위는 천원 입니다\n매도 예정일: 채권을 매수할 시점을 입력합니다", // 매수 정보 설명
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
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
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("매수 단가",
                                      style: TextStyle(
                                        fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                      )),
                                  const SizedBox(width: 5,),
                                  const Expanded(
                                    child: DottedLine(
                                      dashColor: Colors.grey,
                                      lineThickness: 1,  // 선의 두께
                                      dashLength: 4,     // 점 길이
                                      dashGapLength: 3,  // 점과 점 사이의 간격
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  SizedBox(
                                    width: 50,  // 입력 칸의 너비
                                    height: 20, // 입력 칸의 높이
                                    child: TextField(
                                      controller: _purchasePriceController,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      ),
                                      style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "매수 수량 (단위: 천원)",
                                      style: TextStyle(
                                        fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                      )
                                  ),
                                  const SizedBox(width: 5,),
                                  const Expanded(
                                    child: DottedLine(
                                      dashColor: Colors.grey,
                                      lineThickness: 1,
                                      dashLength: 4,
                                      dashGapLength: 3,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  SizedBox(
                                    width: 50,  // 입력 칸의 너비
                                    height: 20, // 입력 칸의 높이
                                    child: TextField(
                                      controller: _purchaseQuantity,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      ),
                                      style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("매수 예정일", style: TextStyle(
                                    fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                  )),
                                  const SizedBox(width: 5,),
                                  const Expanded(
                                    child: DottedLine(
                                      dashColor: Colors.grey,
                                      lineThickness: 1,
                                      dashLength: 4,
                                      dashGapLength: 3,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  SizedBox(
                                    width: 80,  // 입력 칸의 너비
                                    height: 20, // 입력 칸의 높이
                                    child: TextField(
                                      controller: _expectedPurchaseDate,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      ),
                                      style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "매도 예측",
                                style: TextStyle(
                                    fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const Tooltip(
                                message: "중도 매도 단가: 채권을 매도 희망 가격을 말합니다\n중도 매도 수량: 사용자가 보유하고 있는 채권 수량 중\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t팔고자 하는 수량을 말하는 것으로,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t분할하여 중도에 매도하면차기 이자 지급가가 변경될 수 있습니다\n중도 매도 예정일: 채권을 매도할 시점을 입력합니다.",
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    Container(
                      height: 100,
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("매도 단가", style: TextStyle(
                                  fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                )),
                                const SizedBox(width: 5,),
                                const Expanded(
                                  child: DottedLine(
                                    dashColor: Colors.grey,
                                    lineThickness: 1,
                                    dashLength: 4,
                                    dashGapLength: 3,
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                SizedBox(
                                  width: 50,  // 입력 칸의 너비
                                  height: 20, // 입력 칸의 높이
                                  child: TextField(
                                    controller: _salePrice,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    ),
                                    style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("매도 수량(단위: 천원)", style: TextStyle(
                                  fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                )),
                                const SizedBox(width: 5,),
                                const Expanded(
                                  child: DottedLine(
                                    dashColor: Colors.grey,
                                    lineThickness: 1,  // 선의 두께
                                    dashLength: 4,     // 점 길이
                                    dashGapLength: 3,  // 점과 점 사이의 간격
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                SizedBox(
                                  width: 50,  // 입력 칸의 너비
                                  height: 20, // 입력 칸의 높이
                                  child: TextField(
                                    controller: _saleQuantity,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    ),
                                    style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("매도 예정일", style: TextStyle(
                                  fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,
                                )),
                                const SizedBox(width: 5,),
                                const Expanded(
                                  child: DottedLine(
                                    dashColor: Colors.grey,
                                    lineThickness: 1,  // 선의 두께
                                    dashLength: 4,     // 점 길이
                                    dashGapLength: 3,  // 점과 점 사이의 간격
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                SizedBox(
                                  width: 80,  // 입력 칸의 너비
                                  height: 20, // 입력 칸의 높이
                                  child: TextField(
                                    controller: _expectedSaleDate,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    ),
                                    style: TextStyle(fontSize: kIsWeb ? 12 : MediaQuery.of(context).size.height * 0.015,),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF1F1F9),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<QuoteData> getQuoteData() {
    return [
      QuoteData('6.415', '67000', '10025.0', '', ''),
      QuoteData('6.422', '25677', '10024.0', '', ''),
      QuoteData('6.424', '115000', '10023.0', '', ''),
      QuoteData('6.430', '28945', '10020.0', '', ''),
      QuoteData('', '', '10019.9', '93', '6.439'),
      QuoteData('', '', '10019.0', '2200', '6.445'),
      QuoteData('', '', '10018.9', '6000', '6.450'),
      QuoteData('', '', '10018.8', '200', '6.451'),
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
