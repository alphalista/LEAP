import 'package:flutter/material.dart';

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                '만기일',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedMaturity = 1;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedMaturity == 1 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '만기 5년 이내',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedMaturity == 1 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedMaturity = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedMaturity == 2 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '만기 3년 이내',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedMaturity == 2 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedMaturity = 3;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedMaturity == 3 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '만기 1년 이내',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedMaturity == 3 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedMaturity = 4;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedMaturity == 4 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        '만기 6개월 이내',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedMaturity == 4 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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


Future<String?> showEtBondDangerDialog(BuildContext context) async {
  int selectedDanger = 0;
  String errorText = "";

  final Map<int, String> dangerOptions = {
    1 : "AAA",
    2 : "AA",
    3 : "A",
    4 : "BBB",
    5 : "BB",
    6 : "B",
    7 : "CCC 이하",

  };

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                "신용등급",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                          selectedDanger = 1;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 1 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'AAA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 1 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 2 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'AA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 2 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 3;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 3 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 3 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 4;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 4 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'BBB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 4 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 5;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 5 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'BB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 5 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 6;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 6 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'B',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 6 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 7;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        backgroundColor: selectedDanger == 7 ? Colors.blueAccent : Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFD2E1FC),
                        ),
                      ),
                      child: Text(
                        'CCC 이하',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDanger == 7 ? Colors.white : Colors.blueAccent,
                        ),
                      ),
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
                      errorText = '모든 옵션을 선택해 주세요.'; // Set error message if options aren't selected
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                '수익율',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                          errorText = ""; // Clear error if option is selected
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
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
                        minimumSize: const Size(0, 50),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                '잔존수량',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                        minimumSize: const Size(0, 50),
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
                        minimumSize: const Size(0, 50),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                '이자율',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                          selectedInterestRate = 1;
                          errorText = ""; // Clear error if option is selected
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
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
                        minimumSize: const Size(0, 50),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                "신용등급",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
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
                          selectedDanger = 1;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 2;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 3;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 4;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 5;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDanger = 6;
                          errorText = "";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedDanger == 0) {
                    setState(() {
                      errorText = '모든 옵션을 선택해 주세요.'; // Set error message if options aren't selected
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