import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class OtcBondCalculatorPage extends StatefulWidget {
  final Map<String, dynamic> bondData;
  final String idToken;
  const OtcBondCalculatorPage({Key? key, required this.bondData, required this.idToken}) : super(key: key);

  @override
  _OtcBondCalculatorPageState createState() => _OtcBondCalculatorPageState();
}

class _OtcBondCalculatorPageState extends State<OtcBondCalculatorPage> {
  String selectedText = '정보';
  List<dynamic> fetchBondData = [];
  String? nextUrl;
  String price_per_10 ='';
  String quantity = '';
  String expectedPurchase = '';

  List<String> leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
  List<String> rightColumnData = [];

  final List<String> profitLeftColumnData = ['이자율', '세전 수익률', '세후 수익률', '예상 수익금'];
  final List<String> profitRightColumnData = [];

  String formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(0, 4)} - ${date.substring(4, 6)} - ${date.substring(6, 8)}';
    }
    return date;
  }

  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _purchaseQuantity = TextEditingController();
  final TextEditingController _expectedPurchaseDate = TextEditingController();
  final TextEditingController _salePrice = TextEditingController();
  final TextEditingController _saleQuantity = TextEditingController();
  final TextEditingController _expectedSaleDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBondData(idToken: 'eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9');
    rightColumnData = [
      formatDate(widget.bondData['issu_dt']) ?? 'N/A',
      formatDate(widget.bondData['expd_dt']) ?? 'N/A',
      widget.bondData['prdt_type_cd'] ?? 'N/A',
      widget.bondData['nice_crdt_grad_text'] ?? 'N/A',
      widget.bondData['bond_int_dfrm_mthd_cd'] ?? 'N/A',
      formatDate(widget.bondData['nxtm_int_dfrm_dt']) ?? 'N/A',
      "${widget.bondData['int_pay_cycle']}개월" ?? 'N/A',
    ];
    _purchasePriceController.text = '';
    _purchaseQuantity.text = '';
    _expectedPurchaseDate.text = '';
    _salePrice.text = '';
    _saleQuantity.text = '';
    _expectedSaleDate.text = '';
  }

  Future<void> _fetchBondData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final response = await dio.get(
        'http://localhost:8000/api/otcbond/holding/?query=${widget.bondData['code']}',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['results'];

        setState(() {
          fetchBondData = results;
          nextUrl = response.data['next'];
          _purchasePriceController.text = results[0]['price_per_10'] ?? '';
          _purchaseQuantity.text = results[0]['quantity'] ?? '';
          _expectedPurchaseDate.text = results[0]['purchase_date'] ?? '';
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

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

  @override
  void dispose() {
    super.dispose();
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
                              Icons.arrow_back, // 원하는 아이콘 (BackButton과 동일한 모양)
                              size: 20, // 아이콘 크기 조정
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            '장외 채권 설정',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            'code': widget.bondData['code'],
                            'purchasePrice': purchasePrice,
                            'purchaseQuantity': purchaseQuantity,
                            'expectedPurchaseDate': expectedPurchaseDate,
                            'salePrice': salePrice,
                            'saleQuantity': saleQuantity,
                            'expectedSaleDate': expectedSaleDate,
                          });
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
                margin: const EdgeInsets.all(14.0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bondData['prdt_name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "(${widget.bondData['code']})" ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "(${widget.bondData['issu_istt_name']})" ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.bondData['expt_income'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
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
                      onTap: () => _updateTextContent('정보'),
                      child: Text(
                        '정보',
                        style: TextStyle(
                          fontSize: 18,
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
                          fontSize: 18,
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
                child:
                    Row(
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
                          child: Text(item, style: const TextStyle(fontSize: 15)),
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
                          child: Text(item, style: const TextStyle(fontSize: 15)),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "매수 정보",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Tooltip(
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
                          const Text("매수 단가"),
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
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("매수 수량 (단위: 천원)"),
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
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("매수 예정일"),
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
                            width: 75,  // 입력 칸의 너비
                            height: 20, // 입력 칸의 높이
                            child: TextField(
                              controller: _expectedPurchaseDate,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "매도 예측",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Tooltip(
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
                          const Text("매도 단가"),
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
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("매도 수량(단위: 천원)"),
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
                              style: const TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("매도 예정일"),
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
                            width: 75,  // 입력 칸의 너비
                            height: 20, // 입력 칸의 높이
                            child: TextField(
                              controller: _expectedSaleDate,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: const TextStyle(fontSize: 12),
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
      ),
    );
  }
}