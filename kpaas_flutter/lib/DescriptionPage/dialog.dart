import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpaas_flutter/main.dart';

Future<String?> showExpdDateDialog(BuildContext context) async {
  int selectedMaturity = 0;
  String errorText = "";

  final Map<int, String> maturityOptions = {
    1: '만기 5년 이내',
    2: '만기 3년 이내',
    3: '만기 1년 이내',
    4: '만기 6개월 이내',
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Center(
              child: Text(
                '만기일',
                style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
              ),
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorText.isNotEmpty) // 에러 메시지 표시
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOptionButton(
                                context,
                                label: '만기 5년 이내',
                                isSelected: selectedMaturity == 1,
                                onPressed: () {
                                  setState(() {
                                    selectedMaturity = 1;
                                    errorText = "";
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildOptionButton(
                                context,
                                label: '만기 3년 이내',
                                isSelected: selectedMaturity == 2,
                                onPressed: () {
                                  setState(() {
                                    selectedMaturity = 2;
                                    errorText = "";
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildOptionButton(
                                context,
                                label: '만기 1년 이내',
                                isSelected: selectedMaturity == 3,
                                onPressed: () {
                                  setState(() {
                                    selectedMaturity = 3;
                                    errorText = "";
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildOptionButton(
                                context,
                                label: '만기 6개월 이내',
                                isSelected: selectedMaturity == 4,
                                onPressed: () {
                                  setState(() {
                                    selectedMaturity = 4;
                                    errorText = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedMaturity == 0) {
                    setState(() {
                      errorText = '옵션을 선택해 주세요.'; // 옵션 선택이 안 되었을 때 에러 메시지
                    });
                  } else {
                    Navigator.of(context).pop(maturityOptions[selectedMaturity]);
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildOptionButton(BuildContext context,
    {required String label, required bool isSelected, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(100, 50), // 버튼 크기
      backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
      side: BorderSide(color: isSelected ? Colors.blueAccent : const Color(0xFFD2E1FC)),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.white : Colors.blueAccent,
      ),
    ),
  );
}


Future<String?> showEtBondDangerDialog(BuildContext context) async {
  int selectedDanger = 0;
  String errorText = "";

  final Map<int, String> dangerOptions = {
    1: "AAA",
    2: "AA",
    3: "A",
    4: "BBB",
    5: "BB",
    6: "B",
    7: "CCC 이하",
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  "신용등급",
                  style: TextStyle(
                    fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: dangerOptions.entries.map((entry) {
                    if (entry.key == 7) {
                      return Padding(
                        padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.035),
                        child: _buildDangerButton(
                          context,
                          entry.value,
                          entry.key,
                          selectedDanger,
                              (int value) {
                            setState(() {
                              selectedDanger = value;
                              errorText = "";
                            });
                          },
                        ),
                      );
                    }
                    return _buildDangerButton(
                      context,
                      entry.value,
                      entry.key,
                      selectedDanger,
                          (int value) {
                        setState(() {
                          selectedDanger = value;
                          errorText = "";
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedDanger == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.';
                    });
                  } else {
                    Navigator.of(context).pop(dangerOptions[selectedDanger]);
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildDangerButton(
    BuildContext context,
    String label,
    int value,
    int selectedValue,
    void Function(int) onPressed,
    ) {
  return TextButton(
    onPressed: () => onPressed(value),
    style: ElevatedButton.styleFrom(
      minimumSize: Size(MediaQuery.of(context).size.width * 0.1, 50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      backgroundColor: selectedValue == value ? Colors.blueAccent : Colors.white,
      side: const BorderSide(
        color: Color(0xFFD2E1FC),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: selectedValue == value ? Colors.white : Colors.blueAccent,
      ),
    ),
  );
}

Future<String?> showEarnRateDialog(BuildContext context) async {
  int selectedEarnRate = 0; // Variable for tracking selected maturity option
  String errorText = "";

  final Map<int, String> earnRateOptions = {
    1: '오름차순',
    2: '내림차순',
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  '수익율',
                  style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorText.isNotEmpty) // Show error text if it's set
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedEarnRate = 1;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedEarnRate == 1 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '오름차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedEarnRate == 1 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedEarnRate = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedEarnRate == 2 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '내림차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedEarnRate == 2 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedEarnRate == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.';
                    });
                  } else {
                    Navigator.of(context).pop(
                        '${earnRateOptions[selectedEarnRate]}'
                    );
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<String?> showRemainderDialog(BuildContext context) async {
  int selectedRemainder = 0;
  String errorText = "";

  final Map<int, String> remainderOptions = {
    1: '오름차순',
    2: '내림차순',
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  '잔존수량',
                  style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorText.isNotEmpty) // Show error text if it's set
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRemainder = 1;
                          errorText = ""; // Clear error if option is selected
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedRemainder == 1 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '오름차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedRemainder == 1 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRemainder = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedRemainder == 2 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '내림차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedRemainder == 2 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedRemainder == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.';
                    });
                  } else {
                    Navigator.of(context).pop(
                        '${remainderOptions[selectedRemainder]}'
                    );
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<String?> showInterestRateDialog(BuildContext context) async {
  int selectedInterestRate = 0; // Variable for tracking selected maturity option
  String errorText = "";

  final Map<int, String> interestOptions = {
    1: '오름차순',
    2: '내림차순',
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  '이자율',
                  style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedInterestRate = 1;
                          errorText = ""; // Clear error if option is selected
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedInterestRate == 1 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '오름차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedInterestRate == 1 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedInterestRate = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedInterestRate == 2 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '내림차순',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedInterestRate == 2 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedInterestRate == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.';
                    });
                  } else {
                    Navigator.of(context).pop(
                        '${interestOptions[selectedInterestRate]}'
                    );
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<String?> showOtcBondDangerDialog(BuildContext context) async {
  int selectedDanger = 0;
  String errorText = "";

  final Map<int, String> dangerOptions = {
    1 : "매우낮은위험",
    2 : "낮은위험",
    3 : "보통위험",
    4 : "다소높은위험",
    5 : "높은위험",
    6 : "매우높은위험",
  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF1F1F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  "신용등급",
                  style: TextStyle(fontSize:  kIsWeb
                            ? 18 : MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorText.isNotEmpty) // Show error text if it's set
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 1;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 1 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '매우낮은위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 1 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 2;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 2 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '낮은위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 2 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 3;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 3 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '보통위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 3 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 5;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 5 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '높은위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 5 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 4;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 4 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '다소높은위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 4 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedDanger = 6;
                              errorText = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: selectedDanger == 6 ? Colors.blueAccent : Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD2E1FC),
                            ),
                          ),
                          child: Text(
                            '매우높은위험',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedDanger == 6 ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedDanger == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.';
                    });
                  } else {
                    Navigator.of(context).pop(
                        '${dangerOptions[selectedDanger]}'
                    );
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}