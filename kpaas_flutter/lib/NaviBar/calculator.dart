import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:kpaas_flutter/CalculatorPage/etBondCalculator.dart';
import 'package:kpaas_flutter/CalculatorPage/otcBondCalculator.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  List<Map<String, dynamic>> TrendingEtBondList = [];
  List<Map<String, dynamic>> TrendingOtcBondList = [];
  int selectedOption = 1;
  String? calculatedAmount;
  String displayedDate = "(날짜를 입력하세요)";


  @override
  void initState() {
    super.initState();
  }

  void _addNewBond(bool isEtBond) {
    setState(() {
      if (isEtBond) {
        TrendingEtBondList.add({'prdt_name': '새 채권'});
      } else {
        TrendingOtcBondList.add({'prdt_name': '새 채권'});
      }
    });
  }

  void _removeBond(bool isEtBond, int index) {
    setState(() {
      if (isEtBond) {
        TrendingEtBondList.removeAt(index);
      } else {
        TrendingOtcBondList.removeAt(index);
      }
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
                '계산기',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          color: const Color(0xFFF1F1F9),
          child: Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTrendingSection("장내 트렌딩 채권", TrendingEtBondList, true),
                const SizedBox(height: 10),
                _buildTrendingSection("장외 트렌딩 채권", TrendingOtcBondList, false),
                Container(
                  height: 120,
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
                            Row(
                              children: [
                                Radio<int>(
                                  value: 1,
                                  groupValue: selectedOption,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                ),
                                const Text("가장 먼 만기 자동 계산하기", style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
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
                            const Text("2054-11-25", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio<int>(
                                  value: 2,
                                  groupValue: selectedOption,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                ),
                                const Text("내가 원하는 날에 수익 계산하기", style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
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
                              width: 85,
                              height: 20,
                              child: TextField(
                                controller: dateController,
                                onChanged: (value) {
                                  if (selectedOption == 2) {
                                    setState(() {
                                      displayedDate = value;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: " YYYY-MM-DD",
                                  hintStyle: TextStyle(fontSize: 12),
                                  isDense: true,
                                  border: UnderlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                ),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  height: 120,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${selectedOption == 2 ? displayedDate : "2054 - 11 - 25"}까지의 수익은",
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              calculatedAmount != null ? '$calculatedAmount' : '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                            ),
                              const Text("원", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        calculatedAmount = "1,503,195.4";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("계산하기"),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(String title, List<Map<String, dynamic>> bondList, bool isEtBond) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 24,
                ),
                onPressed: () {
                  _addNewBond(isEtBond);  // 추가할 항목에 따라 함수 호출
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        bondList.isEmpty
            ? const SizedBox(
              height: 250,
              child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("채권 정보를 추가해주세요", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
            )
            : Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildBondItems(bondList, isEtBond),
              ),
            ),
          ),
        ),
      ],
    );
  }


  List<Widget> _buildBondItems(List<Map<String, dynamic>> bondList, bool isEtBond) {
    List<Widget> columns = [];
    int itemsPerColumn = 3;

    for (int i = 0; i < bondList.length; i += itemsPerColumn) {
      List<Widget> columnItems = [];

      for (int j = i; j < i + itemsPerColumn && j < bondList.length; j++) {
        var bond = bondList[j];
        columnItems.add(
          Container(
            width: 230,
            height: 70,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _removeBond(isEtBond, j);  // 리스트에서 항목 제거
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    bond['prdt_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isEtBond) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EtBondCalculatorPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtcBondCalculatorPage(),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.settings,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      columns.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          mainAxisSize: MainAxisSize.min,
          children: columnItems,
        ),
      );
    }

    return [
      Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: columns,
        ),
      ),
    ];
  }
}
