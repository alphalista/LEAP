import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpaas_flutter/MyPage/MatureBondDisplay.dart';
import 'package:kpaas_flutter/MyPage/OwningBondDisplay.dart';
import 'package:kpaas_flutter/MyPage/InterestBondDisplay.dart';

import '../NaviBar/calculator.dart';
import '../NaviBar/news.dart';

class MyPage extends StatefulWidget {
  final String idToken;
  const MyPage({Key? key, required this.idToken}) : super(key: key);


  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: kIsWeb ? 0 : MediaQuery.of(context).size.height*0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const BackButton(),
                            Text(
                              '마이페이지',
                              style: TextStyle(fontSize: kIsWeb ? 15 : MediaQuery.of(context).size.height*0.02, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
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
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              "닉네임",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              "님 안녕하세요!",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Container(
                height: 200,
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
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InterestBondDisplay(
                                idToken: widget.idToken
                              )),
                            );
                          },
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage('assets/images/First.png'),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8,),
                              Text(
                                "관심있는 채권 목록",
                                style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OwningBondDisplay(
                              idToken: widget.idToken
                            )),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage('assets/images/Second.png'),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8,),
                              Text(
                                "보유 중인 채권 목록",
                                style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MatureBondDisplay(
                              idToken: widget.idToken
                            )),
                          );
                        },
                        child:  Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage('assets/images/Third.png'),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8,),
                              Text(
                                "만기된 채권 목록",
                                style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 0),
              // Container(
              //   height: 150,
              //   margin: const EdgeInsets.all(16.0),
              //   padding: const EdgeInsets.all(16.0),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 0,
              //         blurRadius: 6,
              //         offset: const Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         GestureDetector(
              //           onTap: () {
              //             final oldRoute = ModalRoute.of(context);
              //             if (oldRoute != null) {
              //               Navigator.of(context).replace(
              //                 oldRoute: oldRoute, // 기존 페이지(Route)
              //                 newRoute: MaterialPageRoute(builder: (context) => CalculatorPage(idToken: widget.idToken)),
              //               );
              //             }
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(13.0),
              //             child: Row(
              //               children: [
              //                 const Image(
              //                   image: AssetImage('assets/images/Fourth.png'),
              //                   width: 24,
              //                   height: 24,
              //                 ),
              //                 const SizedBox(width: 8,),
              //                 Text(
              //                   "내 수익 바로 계산해보기",
              //                   style: TextStyle(fontSize: kIsWeb
              //       ? 16 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             // final oldRoute = ModalRoute.of(context);
              //             // if (oldRoute != null) {
              //             //   Navigator.of(context).replace(
              //             //     oldRoute: oldRoute, // 기존 페이지(Route)
              //             //     newRoute: MaterialPageRoute(builder: (context) => NewsPage(idToken: widget.idToken, initialNextUrl: '', newsData: [],)),
              //             //   );
              //             // }
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(13.0),
              //             child: Row(
              //               children: [
              //                 const Image(
              //                   image: AssetImage('assets/images/Fifth.png'),
              //                   width: 24,
              //                   height: 24,
              //                 ),
              //                 const SizedBox(width: 8,),
              //                 Text(
              //                   "채권 뉴스 골라보기",
              //                   style: TextStyle(fontSize: kIsWeb
              //       ? 16 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Expanded(
                child: Container(
                  color: const Color(0xFFF1F1F9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
