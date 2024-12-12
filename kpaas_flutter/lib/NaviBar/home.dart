import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpaas_flutter/DescriptionPage/etBondDescription.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:kpaas_flutter/MyPage/myPage_main.dart';
import 'package:kpaas_flutter/DescriptionPage/otcBondDescription.dart';

class HomePage extends StatefulWidget {
  final String idToken;
  const HomePage({Key? key, required this.idToken}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? MarketEtBondInterestPrice;
  Map<String, dynamic>? MarketEtBondTrendingPrice;
  Map<String, dynamic>? MarketOtcBondInterestPrice;
  Map<String, dynamic>? MarketOtcBondTrendingPrice;
  List<Map<String, dynamic>> InterestEtBondList = [];
  List<Map<String, dynamic>> InterestOtcBondList = [];
  List<Map<String, dynamic>> TrendingEtBondList = [];
  List<Map<String, dynamic>> TrendingOtcBondList = [];
  List<Map<String, dynamic>> HoldingEtBondList = [];
  List<Map<String, dynamic>> HoldingOtcBondList = [];

  bool InterestEtBond = true;
  bool InterestOtcBond = false;
  bool TrendingEtBond = true;
  bool TrendingOtcBond = false;

  final ScrollController _TrendingScrollController = ScrollController();
  final ScrollController _InterestScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchEtBondInterestData(idToken: widget.idToken);
    _fetchEtBondTrendingData(idToken: widget.idToken);
    _fetchOtcBondInterestData(idToken: widget.idToken);
    _fetchOtcBondTrendingData(idToken: widget.idToken);
    _fetchEtBondHoldingData(idToken: widget.idToken);
    _fetchOtcBondHoldingData(idToken: widget.idToken);
  }

  Future<void> _fetchEtBondInterestData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final etInterestResponse = await dio.get(
        'http://localhost:8000/api/marketbond/interest',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );

      if (etInterestResponse.statusCode == 200) {
        List<dynamic> results = etInterestResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          InterestEtBondList.add({
            "prdt_name": value['meta']['issue_info_data']['prdt_name'] ?? "Unknown",
            "code": value['meta']['issue_info_data']['pdno'] ?? "Unknown",
            'bond_prpr': value['meta']['inquire_price_data']['bond_prpr'] ?? "0000.0",
            'srfc_inrt': value['meta']['issue_info_data']['srfc_inrt'] ?? "0.00%",
            'shnu_ernn_rate5': value['meta']['inquire_asking_price_data']['shnu_ernn_rate5'] ?? "0.00%",
            'expd_dt': value['meta']['issue_info_data']['expd_dt'] ?? "Unknown"
          });
        });
      }

      else {
        print('Failed to fetch data: ${etInterestResponse.statusCode}');
      }

    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  Future<void> _fetchEtBondTrendingData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final etTrendingResponse = await dio.get(
        'http://localhost:8000/api/marketbond/trending',
      );

      if (etTrendingResponse.statusCode == 200) {
        List<dynamic> results = etTrendingResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          TrendingEtBondList.add({
            "prdt_name": value['bond_name'] ?? "Unknown",
            'expd_asrc_erng_rt': value['YTM'] ?? "0.0%",
          });
        });
        print(TrendingEtBondList[0]["expd_asrc_erng_rt"]);
      }

      else {
        print('Failed to fetch data: ${etTrendingResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  Future<void> _fetchOtcBondInterestData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final otcInterestResponse = await dio.get(
        'http://localhost:8000/api/otcbond/interest/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );

      if (otcInterestResponse.statusCode == 200) {
        List<dynamic> results = otcInterestResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          InterestOtcBondList.add({
            "code": value['meta']["code"],
            "issu_istt_name": value['meta']["issu_istt_name"],
            "prdt_name": value['meta']?["prdt_name"] ?? "뚱인데요",
            "nice_crdt_grad_text": value['meta']["nice_crdt_grad_text"],
            "issu_dt": value['meta']["issu_dt"],
            "expd_dt": value['meta']["expd_dt"],
            "YTM": value['meta']["YTM"],
            "YTM_after_tax": value['meta']["YTM_after_tax"],
            "price_per_10": value['meta']["price_per_10"],
            "prdt_type_cd": value['meta']["prdt_type_cd"],
            "bond_int_dfrm_mthd_cd": value['meta']["bond_int_dfrm_mthd_cd"],
            "int_pay_cycle": value['meta']["int_pay_cycle"],
            "interest_percentage": value['meta']["interest_percentage"],
            "nxtm_int_dfrm_dt": value['meta']["nxtm_int_dfrm_dt"],
            "expt_income": value['meta']["expt_income"],
            "duration": value['meta']["duration"]
          });
        });
      }

      else {
        print('Failed to fetch data: ${otcInterestResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  Future<void> _fetchOtcBondTrendingData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final otcTrendingResponse = await dio.get(
        'http://localhost:8000/api/otcbond/trending',
      );

      if (otcTrendingResponse.statusCode == 200) {
        List<dynamic> results = otcTrendingResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          TrendingOtcBondList.add({
                "prdt_name": value['bond_name'] ?? "Unknown",
                'expd_asrc_erng_rt': value['YTM'] ?? "0.0%"
          });
        });
        print(TrendingOtcBondList[0]["expd_asrc_erng_rt"]);
      }

      else {
        print('Failed to fetch data: ${otcTrendingResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  Future<void> _fetchEtBondHoldingData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final etHoldingResponse = await dio.get(
        'http://localhost:8000/api/marketbond/holding',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );

      if (etHoldingResponse.statusCode == 200) {
        List<dynamic> results = etHoldingResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          HoldingEtBondList.add({
            "expire_date": value['meta']['issue_info_data']['expd_dt'] ?? "Unknown",
            "nxtm_int_dfrm_dt": value['meta']['issue_info_data']['nxtm_int_dfrm_dt'] ?? "Unknown",
            'nickname': value['nickname'] ?? "0.0%"
          });
        });
      }

      else {
        print('Failed to fetch data: ${etHoldingResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  Future<void> _fetchOtcBondHoldingData({required String idToken}) async {
    final dio = Dio();
    setState(() {
    });
    try {
      final otcHoldingResponse = await dio.get(
        'http://localhost:8000/api/otcbond/holding',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.idToken}',
          },
        ),
      );

      if (otcHoldingResponse.statusCode == 200) {
        List<dynamic> results = otcHoldingResponse.data['results'];
        setState(() {});
        results.forEach((value) {
          HoldingOtcBondList.add({
            "expire_date": value['meta']['expd_dt'] ?? "Unknown",
            "nxtm_int_dfrm_dt": value['meta']['nxtm_int_dfrm_dt'] ?? "Unknown",
            'nickname': value['nickname'] ?? "0.0%"
          });
        });
      }

      else {
        print('Failed to fetch data: ${otcHoldingResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching bond data: $e");
    }
  }

  String formatDate(String? date) {
    if (date == null || date.length != 8) return 'N/A';
    return '${date.substring(2, 4)}/${date.substring(4, 6)}/${date.substring(6, 8)}';
  }

   Future<bool> isEtTrending () async {
    return (double.parse(TrendingEtBondList[0]["expd_asrc_erng_rt"]) > double.parse(TrendingOtcBondList[0]["expd_asrc_erng_rt"]));
  }

  @override
  void dispose() {
    super.dispose();
    _TrendingScrollController.dispose();
    _InterestScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF1F1F9),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '홈페이지',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                      fontSize: kIsWeb ? 15 : MediaQuery.of(context).size.height * 0.02
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
                  MaterialPageRoute(builder: (context) => MyPage(
                    idToken: widget.idToken,
                  )),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
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
                    children: [
                      Icon(Icons.whatshot, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        // "${(double.parse(TrendingEtBondList[0]['expd_asrc_erng_rt']) > double.parse(TrendingOtcBondList[0]['expd_asrc_erng_rt']))
                        //     ? TrendingEtBondList[0]['prdt_name']
                        //     : TrendingOtcBondList[0]['prdt_name']}가 트렌드에 올랐어요",
                        // 로딩해결하고 다시 구현
                        "효성화학이12가 트렌드에 올랐어요",
                        style: TextStyle(
                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 달력
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 400,
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
                    child: SfCalendar(
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(_getDataSource(HoldingEtBondList, HoldingOtcBondList)),
                      headerHeight: 0,
                      monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                        numberOfWeeksInView: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "관심채권",
                        style: TextStyle(
                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                InterestEtBond = true;
                                InterestOtcBond = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: InterestEtBond ? const Color(0xFF03C75A) : Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF03C75A),
                              )
                            ),
                            child: Text(
                                "장내",
                              style: TextStyle(
                                color: InterestEtBond ? Colors.white : const Color(0xFF03C75A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                InterestEtBond = false;
                                InterestOtcBond = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: InterestOtcBond ? const Color(0xFF03C75A) : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF03C75A),
                                )
                            ),
                            child: Text(
                                "장외",
                              style: TextStyle(
                                color: InterestOtcBond ? Colors.white : const Color(0xFF03C75A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 3),
                Scrollbar(
                  controller: _InterestScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _InterestScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: InterestEtBond
                          ? InterestEtBondList.map((bond) {
                        return _buildInterestBondItem(bond);
                      }).toList()
                          : InterestOtcBondList.map((bond) {
                        return _buildInterestBondItem(bond);
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "트렌딩 채권",
                        style: TextStyle(
                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                TrendingEtBond = true;
                                TrendingOtcBond = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: TrendingEtBond ? const Color(0xFF03C75A) : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF03C75A),
                                )
                            ),
                            child: Text(
                              "장내",
                              style: TextStyle(
                                color: TrendingEtBond ? Colors.white : const Color(0xFF03C75A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                TrendingEtBond = false;
                                TrendingOtcBond = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: TrendingOtcBond ? const Color(0xFF03C75A) : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF03C75A),
                                )
                            ),
                            child: Text(
                              "장외",
                              style: TextStyle(
                                color: TrendingOtcBond ? Colors.white : const Color(0xFF03C75A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Scrollbar(
                  thumbVisibility: true,
                  controller: _TrendingScrollController,
                  child: SingleChildScrollView(
                    controller: _TrendingScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: _buildTrendingBondRows(),
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

  Widget _buildInterestBondItem(Map<String, dynamic> bond) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 3,),
          Container(
            child: GestureDetector(
              onTap: () { InterestEtBond
                ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EtBondDescriptionPage(pdno: bond['code'], idToken: widget.idToken,),
                  ),
                ) :Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtcBondDescriptionPage(idToken: widget.idToken, bondData: bond,),
                ),
              );
              },
              child: Text(
                bond['prdt_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  InterestEtBond
                      ? double.parse(bond['bond_prpr']).toStringAsFixed(2)
                      : double.parse(bond['price_per_10']).toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 30 : MediaQuery.of(context).size.height * 0.03,
                    color: Colors.red
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "수익률",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "이자율",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text( InterestEtBond
                    ? "만기일"
                    : "위험도",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${ InterestEtBond
                        ? double.parse(bond['srfc_inrt']).toStringAsFixed(2)
                        : double.parse(bond['YTM_after_tax']).toStringAsFixed(2)
                    }%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    "${
                      InterestEtBond
                          ? double.parse(bond['shnu_ernn_rate5'])
                              .toStringAsFixed(2)
                          : double.parse(bond['interest_percentage'])
                              .toStringAsFixed(2)
                    }%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text( InterestEtBond

                    ? formatDate(bond['expd_dt'])
                    : bond['nice_crdt_grad_text'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTrendingBondRows() {
    List<Widget> rows = [];

    List<Map<String, dynamic>> currentBondList = TrendingEtBond ? TrendingEtBondList : TrendingOtcBondList;

    if (currentBondList.isEmpty) {
      rows.add(
        const Center(
          child: Text(
            "No data available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    } else {
      for (var i = 0; i < currentBondList.length; i += 5) {
        List<Widget> rowChildren = [];

        for (var j = i; j < i + 5 && j < currentBondList.length; j++) {
          var bond = currentBondList[j];
          rowChildren.add(
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
                  Container(
                    width: 120,
                    child: GestureDetector(
                      child: Text(
                        bond['prdt_name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => OtcBondDescriptionPage(bondData: bond, idToken: widget.idToken,))
                        // );
                      },
                    ),
                  ),
                  Text(
                    "${bond['expd_asrc_erng_rt']}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: kIsWeb ? 15 : MediaQuery.of(context).size.height * 0.02,
                      color: Colors.red
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowChildren,
        ));
      }
    }
    return rows;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List<Appointment> _getDataSource(List<Map<String, dynamic>> bondList1, List<Map<String, dynamic>> bondList2) {
  final List<Appointment> meetings = <Appointment>[];

  List bondLists = [...bondList1, ...bondList2];

  for (var bond in bondLists) {
    String? nextInterestDate = bond['nxtm_int_dfrm_dt'];
    if (nextInterestDate != null && nextInterestDate.length == 8) {
      DateTime nextInterest = DateTime.parse(
          '${nextInterestDate.substring(0, 4)}-${nextInterestDate.substring(4, 6)}-${nextInterestDate.substring(6, 8)}'
      );

      meetings.add(Appointment(
        startTime: nextInterest,
        endTime: nextInterest.add(const Duration(hours: 1)),
        subject: '${bond['nickname'] ?? 'No Name'}',
        color: Colors.blue,
      ));
    }

    String? expdDate = bond['expire_date'];
    if (expdDate != null && expdDate.length == 8) {
      DateTime expd = DateTime.parse(
          '${expdDate.substring(0, 4)}-${expdDate.substring(4, 6)}-${expdDate.substring(6, 8)}'
      );

      meetings.add(Appointment(
        startTime: expd,
        endTime: expd.add(const Duration(hours: 1)),
        subject: '${bond['nickname'] ?? 'No Name'}',
        color: Colors.red,
      ));
    }
  }
  return meetings;
}