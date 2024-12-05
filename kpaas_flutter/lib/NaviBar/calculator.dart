import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:kpaas_flutter/CalculatorPage/etBondCalculatorSearch.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:kpaas_flutter/CalculatorPage/etBondCalculatorDescription.dart';
import 'package:kpaas_flutter/CalculatorPage/otcBondCalculatorDescription.dart';
import 'package:kpaas_flutter/CalculatorPage/otcBondCalculatorSearch.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  List<Map<String, dynamic>> CalculateEtBondList = [];
  List<Map<String, dynamic>> CalculateOtcBondList = [];
  List<Map<String, dynamic>> etCalculatedResult = [];
  List<Map<String, dynamic>> otcCalculatedResult = [];
  int selectedOption = 1;
  double calculatedTotal = 0.00;
  String displayedDate = "(날짜를 입력하세요)";

  @override
  void initState() {
    super.initState();
  }

  void _addNewBond(bool isEtBond, bondCode) {
    setState(() {
      if (isEtBond) {
        CalculateEtBondList.add(bondCode);
      } else {
        CalculateOtcBondList.add(bondCode);
      }
    });
  }

  void _removeBond(bool isEtBond, int index) {
    setState(() {
      if (isEtBond) {
        etCalculatedResult.removeWhere((bond) => CalculateEtBondList[index]['code'] == etCalculatedResult[index]['code']);
        CalculateEtBondList.removeAt(index);
      } else {
        otcCalculatedResult.removeWhere((bond) => CalculateOtcBondList[index]['code'] == otcCalculatedResult[index]['code']);
        CalculateOtcBondList.removeAt(index);
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
                _buildCalculateSection("장내 채권 계산", CalculateEtBondList, true),
                const SizedBox(height: 10),
                _buildCalculateSection("장외 채권 계산", CalculateOtcBondList, false),
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
                                  value: 0,
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
                                  hintText: " YYYYMMDD",
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
                              "${selectedOption == 0 ? displayedDate : "2054 - 11 - 25"}까지의 수익은",
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              calculatedTotal.toString(),
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
                        double etTotal = etCalculatedResult.isNotEmpty
                        ? etCalculatedResult.map((bond) => bond['price'] as double).reduce((a, b) => a+b)
                        : 0.0;
                        double otcTotal = otcCalculatedResult.isNotEmpty
                        ? otcCalculatedResult.map((bond) => bond['price'] as double).reduce((a, b) => a+b)
                        : 0.0;
                        calculatedTotal = etTotal + otcTotal;
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

  Widget _buildCalculateSection(String title, List<Map<String, dynamic>> bondList, bool isEtBond) {
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
                  onPressed: () async {
                    final bondCode = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isEtBond
                        ? EtBondCalculatorSearch()
                        : OtcBondCalculatorSearch(),
                      ),
                    );
                    if (bondCode != null) {
                      _addNewBond(isEtBond, bondCode);
                    }
                  }
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
                    _removeBond(isEtBond, j);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    isEtBond
                    ? bond['issue_info_data']['prdt_name']
                    : bond['prdt_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isEtBond) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EtBondCalculatorPage(pdno: bond['issue_info_data']['pdno']),
                        ),
                      );
                      String purchasePriceString = result['purchasePrice'];
                      String purchaseQuantityString = result['purchaseQuantity'];
                      String expectedPurchaseDate = result['expectedPurchaseDate'];
                      String salePriceString = result['salePrice'];
                      String saleQuantityString = result['saleQuantity'];
                      String expectedSaleDate = result['expectedSaleDate'];

                      List<int> calculateMethod = [];
                      if (purchasePriceString.isNotEmpty &&
                          purchaseQuantityString.isNotEmpty &&
                          expectedPurchaseDate.isNotEmpty)
                      { calculateMethod.add(0); }
                      if (salePriceString.isNotEmpty &&
                          saleQuantityString.isNotEmpty &&
                          expectedSaleDate.isNotEmpty)
                      { calculateMethod.add(1); }

                      double purchasePrice = double.tryParse(purchasePriceString) ?? 0;
                      int purchaseQuantity = int.tryParse(purchaseQuantityString) ?? 0;
                      double salePrice = double.tryParse(salePriceString) ?? 0;
                      int saleQuantity = int.tryParse(saleQuantityString) ?? 0;

                      String code = result['code'];
                      double interestRate = double.tryParse(bond['inquire_asking_price_data']['shnu_ernn_rate5']) ?? 0.00;
                      String matDate = bond['issue_info_data']['expd_dt'];
                      String nxtInterestDate = bond['issue_info_data']['nxtm_int_dfrm_dt'];
                      int interestCyclePeriod = 1;

                      // double outcomeResult = 0;
                      // for (int i in calculateMethod) {
                      //   if (i == 0) {
                      //     double output = exptIncome(i, purchasePrice, purchaseQuantity, interestRate, matDate, nxtInterestDate, interestCyclePeriod, isMat);
                      //     outcomeResult = outcomeResult + output * 0.1 * purchaseQuantity;
                      //   }
                      //   else if (i == 1) {
                      //     double output = exptIncome(i, salePrice, saleQuantity, interestRate, matDate, nxtInterestDate, interestCyclePeriod, isMat, salePrice);
                      //     outcomeResult = outcomeResult + output * 0.1 * saleQuantity;
                      //   }
                      // }
                      //
                      // double outcomeResultRounded = double.tryParse(outcomeResult.toStringAsFixed(2)) ?? 0.00;
                      //
                      // etCalculatedResult.add(
                      //     {
                      //       "code": bond['issue_info_data']['pdno'],
                      //       "price": outcomeResultRounded
                      //     }
                      // );
                      // print(etCalculatedResult);
                      Map<String, dynamic> parseData = {
                        'purchasePrice': purchasePrice,
                        'purchaseQuantity': purchaseQuantity,
                        'salePrice': salePrice,
                        'saleQuantity': saleQuantity,
                        'code': code,
                        'interestRate': interestRate,
                        'matDate': matDate,
                        'nxtInterestDate': nxtInterestDate,
                        'interestCyclePeriod': interestCyclePeriod,
                      };

                      etCalculatedResult.add(parseData);

                    } else {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtcBondCalculatorPage(bondData: bond),
                        ),
                      );

                      String purchasePriceString = result['purchasePrice'];
                      String purchaseQuantityString = result['purchaseQuantity'];
                      String expectedPurchaseDate = result['expectedPurchaseDate'];
                      String salePriceString = result['salePrice'];
                      String saleQuantityString = result['saleQuantity'];
                      String expectedSaleDate = result['expectedSaleDate'];

                      List<int> calculateMethod = [];
                        if (purchasePriceString.isNotEmpty &&
                            purchaseQuantityString.isNotEmpty &&
                            expectedPurchaseDate.isNotEmpty)
                          { calculateMethod.add(0); }
                        if (salePriceString.isNotEmpty &&
                            saleQuantityString.isNotEmpty &&
                            expectedSaleDate.isNotEmpty)
                          { calculateMethod.add(1); }

                      double purchasePrice = double.tryParse(purchasePriceString) ?? 0;
                      int purchaseQuantity = int.tryParse(purchaseQuantityString) ?? 0;
                      double salePrice = double.tryParse(salePriceString) ?? 0;
                      int saleQuantity = int.tryParse(saleQuantityString) ?? 0;

                      String code = result["code"];
                      double interestRate = double.tryParse(bond['interest_percentage']) ?? 0.00;
                      String matDate = bond['expd_dt'];
                      String nxtInterestDate = bond['nxtm_int_dfrm_dt'];
                      int interestCyclePeriod = int.tryParse(bond['int_pay_cycle']) ?? 0;

                      double outcomeResult = 0;
                      for (int i in calculateMethod) {
                        if (i == 0) {
                          double output = exptIncome(i, purchasePrice, purchaseQuantity, interestRate, matDate, nxtInterestDate, interestCyclePeriod, true);
                          outcomeResult = outcomeResult + output * 0.1 * purchaseQuantity;
                        }
                        else if (i == 1) {
                          double output = exptIncome(i, salePrice, saleQuantity, interestRate, matDate, nxtInterestDate, interestCyclePeriod, true, salePrice);
                          outcomeResult = outcomeResult + output * 0.1 * saleQuantity;
                        }
                      }

                      double outcomeResultRounded = double.tryParse(outcomeResult.toStringAsFixed(2)) ?? 0.00;
                      otcCalculatedResult.add(
                          {
                            "code": bond['code'],
                            "price": outcomeResultRounded
                          }
                      );
                      print(otcCalculatedResult);
                      Map<String, dynamic> parseData = {
                        'purchasePrice': purchasePrice,
                        'purchaseQuantity': purchaseQuantity,
                        'salePrice': salePrice,
                        'saleQuantity': saleQuantity,
                        'code': code,
                        'interestRate': interestRate,
                        'matDate': matDate,
                        'nxtInterestDate': nxtInterestDate,
                        'interestCyclePeriod': interestCyclePeriod,
                      };
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

/// 주어진 액면가와 이자율 및 이자 지급 주기에 따른 회당 이자를 계산하는 함수입니다.
double interestMoney(double faceValue, double percent, int intCycle) {
  return faceValue * (percent * 0.01) / (12 / intCycle);
}

/// 차기 이자 지급일부터 만기일까지 남은 이자 지급 기간을 계산하는 함수입니다.
int getRemainingInterestPeriod(
    String nextInterestDate, String maturityDate, int interestCyclePeriod) {
  int count = 0;

  // 연, 월, 일을 넣습니다. 이자 지급일자와 만기일자는 같기 때문에 일수는 1로 가정합니다.
  DateTime nextInterestDateTime =
  DateTime.parse(nextInterestDate.substring(0, 6) + '01');
  DateTime maturityDateTime =
  DateTime.parse(maturityDate.substring(0, 6) + '01');

  // 만기 달을 넘어설 때까지 계속 더해나갑니다.
  while (nextInterestDateTime.isBefore(maturityDateTime) ||
      nextInterestDateTime.isAtSameMomentAs(maturityDateTime)) {
    nextInterestDateTime =
        nextInterestDateTime.add(Duration(days: 30 * interestCyclePeriod));
    count += 1;
  }
  return count;
}

/// 채권 하나 당 수익금을 계산하는 함수입니다.
///
/// - [positionMode]: 자료형: int, 매수 또는 매도 포지션을 말하며 0은 매수, 1은 매도 포지션입니다.
/// - [pricePer10]: 자료형: int, 채권 10,000원 수량, 즉 액면가 10,000원 당 매수 가격을 말합니다.
/// - [purCnt]: 자료형: int, 채권 수량(단위: 천원)을 말합니다.
/// - [interestPercent]: 자료형: double, 이자율을 말합니다.
/// - [matDate]: 자료형: String(YYYYmmdd 형식), 예) "20240103". 만기일 또는 계산 목표일을 말합니다.
/// - [nxtInterestDate]: 자료형: String(YYYYmmdd 형식), 예) "20240103". 차기 이자 지급일을 말합니다.
/// - [interestCyclePeriod]: 자료형: int, 이자 지급 주기를 월 단위로 말합니다.
/// - [isMat]: 자료형: bool, 만기일 기준으로 계산할지 여부를 나타냅니다.
/// - [sellPrice]: 자료형: int, 매도 포지션 한정 인수이며, 매도 가격을 말합니다.
///
/// @return 자료형: double, 소수점 2자리까지 표기된 예상 수익금이 반환됩니다.

double exptIncome(
    int positionMode,
    double pricePer10,
    int purCnt,
    double interestPercent,
    String matDate,
    String nxtInterestDate,
    int interestCyclePeriod,
    bool isMat,
    [double sellPrice = 0]) {
  double faceValue = purCnt * 1000;
  double price = pricePer10 * purCnt / 10;
  int remainingInterestPeriod =
  getRemainingInterestPeriod(nxtInterestDate, matDate, interestCyclePeriod);
  double interest =
  interestMoney(faceValue, interestPercent, interestCyclePeriod); // 회당 이자
  double totInterest = interest * remainingInterestPeriod;
  double tax = interest * 0.154 * remainingInterestPeriod;

  // 현재 대비 수익 계산
  if (positionMode == 0) {
    // 매수
    return double.parse(
        (isMat ? faceValue + totInterest - tax - price : totInterest - tax)
            .toStringAsFixed(2));
  } else {
    // 매도: 매매 차익 + 이자
    return double.parse(
        (sellPrice + totInterest - tax - price).toStringAsFixed(2));
  }
}