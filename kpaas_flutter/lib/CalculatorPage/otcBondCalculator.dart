import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:kpaas_flutter/NaviBar/calculator.dart';

class OtcBondCalculatorPage extends StatefulWidget {
  const OtcBondCalculatorPage({Key? key}) : super(key: key);

  @override
  _OtcBondCalculatorPageState createState() => _OtcBondCalculatorPageState();
}

class _OtcBondCalculatorPageState extends State<OtcBondCalculatorPage> {
  String selectedText = '정보';

  List<String> leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
  List<String> rightColumnData = ['23.12.17', '54.12.05', '국채', '무위험', '복리채', '24.11.03', '1개월'];

  final List<String> profitLeftColumnData = ['이자율', '세전 수익률', '세후 수익률', '예상 수익금'];
  final List<String> profitRightColumnData = ['4.63%', '3.94%', '3.27%', '12402.0'];

  @override
  void initState() {
    super.initState();
  }

  void _updateTextContent(String type) {
    setState(() {
      selectedText = type;
      if (type == '정보') {
        leftColumnData = ['발행일', '만기일', '채권 종류', '위험도', '이자 지급 구분', '차기 이자 지급일', '이자 지급 주기'];
        rightColumnData = ['23.12.17', '54.12.05', '국채', '무위험', '복리채', '24.11.03', '1개월'];
      } else if (type == '수익') {
        leftColumnData = profitLeftColumnData;
        rightColumnData = profitRightColumnData;
      }
    });
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '한국전력공사채권1204',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "(KR350114GC54)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "(미래에셋 증권)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "10,180.0",
                        style: TextStyle(
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
                              controller: TextEditingController(text: '10000.0'),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
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
                              controller: TextEditingController(text: '1000'),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
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
                              controller: TextEditingController(text: '2024-10-31'),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
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
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("매도 단가"),
                          SizedBox(width: 5,),
                          Expanded(
                            child: DottedLine(
                              dashColor: Colors.grey,
                              lineThickness: 1,
                              dashLength: 4,
                              dashGapLength: 3,
                            ),
                          ),
                          SizedBox(width: 5,),
                          SizedBox(
                            width: 50,  // 입력 칸의 너비
                            height: 20, // 입력 칸의 높이
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("매도 수량(단위: 천원)"),
                          SizedBox(width: 5,),
                          Expanded(
                            child: DottedLine(
                              dashColor: Colors.grey,
                              lineThickness: 1,  // 선의 두께
                              dashLength: 4,     // 점 길이
                              dashGapLength: 3,  // 점과 점 사이의 간격
                            ),
                          ),
                          SizedBox(width: 5,),
                          SizedBox(
                            width: 50,  // 입력 칸의 너비
                            height: 20, // 입력 칸의 높이
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("매도 예정일"),
                          SizedBox(width: 5,),
                          Expanded(
                            child: DottedLine(
                              dashColor: Colors.grey,
                              lineThickness: 1,  // 선의 두께
                              dashLength: 4,     // 점 길이
                              dashGapLength: 3,  // 점과 점 사이의 간격
                            ),
                          ),
                          SizedBox(width: 5,),
                          SizedBox(
                            width: 75,  // 입력 칸의 너비
                            height: 20, // 입력 칸의 높이
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
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
