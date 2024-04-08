import 'package:flutter/material.dart';
import 'package:kru/store/app_store.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  var _index = 0;
  bool isVisibleNext = true;
  bool isVisiblePrev = false;
  final indexChanged = ChangeNotifier();
  bool isVisibleSentAnswer = false;
  var _progress = 0.0;
  var timeCount = '10.00 น.';
  late Timer _timer;
  final timeCountChanged = ChangeNotifier();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getTesting();
    getTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ทำข้อสอบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(183, 153, 108, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ListenableBuilder(
            listenable: Listenable.merge(
                [testingsChanged, indexChanged, timeCountChanged]),
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 249, 246, 242),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, left: 15, right: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //command
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Text.rich(
                          TextSpan(
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                color: Color.fromARGB(255, 21, 84, 161),
                              ),
                              children: [
                                TextSpan(
                                  text: 'คำชี้แจง',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    decorationColor:
                                        Color.fromARGB(255, 1, 101, 182),
                                    decorationThickness: 1,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' : เลือกคำตอบที่ถูกต้องที่สุดเพียงข้อเดียว',
                                )
                              ]),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 123, 123, 123),
                        height: 20,
                        thickness: 0.1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      // time
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ข้อ ${_index + 1} / ${testings.length}',
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 27, 121, 198),
                              ),
                            ),
                            Text(
                              timeCount,
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 27, 121, 198),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // progress
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 30,
                              lineHeight: 8.0,
                              percent: _progress,
                              backgroundColor:
                                  const Color.fromARGB(255, 199, 199, 199),
                              progressColor:
                                  const Color.fromARGB(255, 27, 121, 198),
                            )
                          ],
                        ),
                      ),

                      // question and choice
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 15, top: 15, bottom: 15, right: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: const Color.fromARGB(255, 222, 222, 222),
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color.fromRGBO(94, 93, 93, 0.2),
                                blurRadius: 5.0,
                                offset: Offset(0.0, 0.20))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //question
                            Text(
                              testings.isEmpty
                                  ? '?'
                                  : testings[_index]['question'],
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            //choice 1
                            InkWell(
                              onTap: () {
                                getAnswer('1');
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 5),
                                decoration: BoxDecoration(
                                  color: (testings.isNotEmpty &&
                                          testings[_index]['answer_user'] ==
                                              '1')
                                      ? const Color.fromARGB(255, 22, 143, 96)
                                      : const Color.fromARGB(
                                          255, 250, 248, 248),
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '1')
                                        ? const Color.fromARGB(
                                            255, 71, 161, 128)
                                        : const Color.fromARGB(
                                            255, 222, 222, 222),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(216, 216, 216, 0.2),
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 0.20))
                                  ],
                                ),
                                child: Text(
                                  testings.isEmpty
                                      ? '?'
                                      : 'ก. ${testings[_index]['ch1']}',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '1')
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //choice 2
                            InkWell(
                              onTap: () {
                                getAnswer('2');
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 5),
                                decoration: BoxDecoration(
                                  color: (testings.isNotEmpty &&
                                          testings[_index]['answer_user'] ==
                                              '2')
                                      ? const Color.fromARGB(255, 22, 143, 96)
                                      : const Color.fromARGB(
                                          255, 250, 248, 248),
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '2')
                                        ? const Color.fromARGB(
                                            255, 71, 161, 128)
                                        : const Color.fromARGB(
                                            255, 222, 222, 222),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(216, 216, 216, 0.2),
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 0.20))
                                  ],
                                ),
                                child: Text(
                                  testings.isEmpty
                                      ? '?'
                                      : 'ข. ${testings[_index]['ch2']}',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '2')
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //choice 3
                            InkWell(
                              onTap: () {
                                getAnswer('3');
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 5),
                                decoration: BoxDecoration(
                                  color: (testings.isNotEmpty &&
                                          testings[_index]['answer_user'] ==
                                              '3')
                                      ? const Color.fromARGB(255, 22, 143, 96)
                                      : const Color.fromARGB(
                                          255, 250, 248, 248),
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '3')
                                        ? const Color.fromARGB(
                                            255, 71, 161, 128)
                                        : const Color.fromARGB(
                                            255, 222, 222, 222),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(216, 216, 216, 0.2),
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 0.20))
                                  ],
                                ),
                                child: Text(
                                  testings.isEmpty
                                      ? '?'
                                      : 'ค. ${testings[_index]['ch3']}',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '3')
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //choice 4
                            InkWell(
                              onTap: () {
                                getAnswer('4');
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 5),
                                decoration: BoxDecoration(
                                  color: (testings.isNotEmpty &&
                                          testings[_index]['answer_user'] ==
                                              '4')
                                      ? const Color.fromARGB(255, 22, 143, 96)
                                      : const Color.fromARGB(
                                          255, 250, 248, 248),
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '4')
                                        ? const Color.fromARGB(
                                            255, 71, 161, 128)
                                        : const Color.fromARGB(
                                            255, 222, 222, 222),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(216, 216, 216, 0.2),
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 0.20))
                                  ],
                                ),
                                child: Text(
                                  testings.isEmpty
                                      ? '?'
                                      : 'ง. ${testings[_index]['ch4']}',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: (testings.isNotEmpty &&
                                            testings[_index]['answer_user'] ==
                                                '4')
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 40,
                            ),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: isVisiblePrev,
                                    child: IconButton(
                                      onPressed: () {
                                        prevStep();
                                      },
                                      icon: const Icon(Icons.arrow_back),
                                    ),
                                  ),
                                  const Text(
                                    'กดลูกศรเพื่อข้ามหรือย้อนกลับ',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(41, 41, 41, 1),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isVisibleNext,
                                    child: IconButton(
                                      onPressed: () {
                                        nextStep();
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ปุ่มส่งคำตอบ
                      Visibility(
                        visible: isVisibleSentAnswer,
                        child: InkWell(
                          onTap: () {
                            checkAnswer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 49, 162, 253),
                                    Color.fromARGB(255, 21, 84, 161),
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ตรวจคำตอบ',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void nextStep() {
    if (_index < testings.length - 1) {
      _index++;
      isVisiblePrev = true;
    }
    if (_index == testings.length - 1) isVisibleNext = false;
    indexChanged.notifyListeners();
  }

  void prevStep() {
    if (_index > 0) {
      _index--;
      isVisibleNext = true;
    }
    if (_index == 0) isVisiblePrev = false;

    indexChanged.notifyListeners();
  }

  void getAnswer(String ans) {
    // set คำตอบใหม่ทุกครั้ง
    testings[_index]['answer_user'] = ans;
    nextStep();
    checkProgress();
  }

  void checkProgress() {
    var check = 0;
    var progress = 0.0;
    for (int i = 0; i < testings.length; i++) {
      if (testings[i]['answer_user'] == '0') {
        check++;
      } else {
        progress += 0.1;
      }
    }
    if (check == 0) isVisibleSentAnswer = true;
    _progress = progress;
  }

  getTime() {
    const duration = Duration(minutes: 1); // กำหนดระยะเวลา 10 นาที
    int countdown = duration.inSeconds; // นับถอยหลังในหน่วยวินาที

    // เริ่มตัวนับเวลา
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        timer.cancel(); // หยุดตัวนับเวลาเมื่อนับถอยหลังเสร็จสิ้น
        // print('เวลาหมดแล้ว!');
        timeCount = 'หมดเวลา';
        timeCountChanged.notifyListeners();
        checkAnswer();
      } else {
        int minutes = countdown ~/ 60; // หานาที
        int seconds = countdown % 60; // หาวินาทีที่เหลือ
        // print('$minutes:${seconds.toString().padLeft(2, '0')}');
        timeCount = '$minutes:${seconds.toString().padLeft(2, '0')} น.';
        timeCountChanged.notifyListeners();
        countdown--;
      }
    });
    // print('เริ่มตัวนับเวลา...');
  }

  void checkAnswer() {
    print('ตรวจคำตอบ');
  }
}
