import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/img/logo_home.png',
                width: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ครูผู้ช่วย',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(183, 153, 108, 1),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         Color.fromARGB(255, 49, 162, 253),
        //         Color.fromARGB(255, 49, 162, 253)
        //       ],
        //     ),
        //   ),
        // ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Color.fromARGB(255, 49, 162, 253),
            //     Color.fromARGB(255, 255, 255, 255),
            //     Color.fromARGB(255, 255, 255, 255),
            //     Color.fromARGB(255, 255, 255, 255)
            //   ],
            // ),
            ),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          size: 30,
                          Icons.notifications_active,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        Text(
                          'ดาวน์โหลดข้อสอบฟรี กดเลย',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        Icon(
                          size: 25,
                          Icons.arrow_forward,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สวัสดี,',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(41, 41, 41, 1),
                      ),
                    ),
                    Text(
                      'วันนี้เป็นอย่างไรบ้าง ?',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(41, 41, 41, 1),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Text(
                    'รายการ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(41, 41, 41, 1),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromRGBO(183, 153, 108, 1),
                ),
              ),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.apps,
                              color: Color.fromRGBO(183, 153, 108, 1),
                              size: 40,
                            ),
                            Text(
                              'แนวข้อสอบ',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.abc,
                              color: Color.fromRGBO(183, 153, 108, 1),
                              size: 40,
                            ),
                            Text(
                              'เกณฑ์สอบ',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color.fromRGBO(183, 153, 108, 1),
                              size: 40,
                            ),
                            Text(
                              'เสี่ยงดวง',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.rocket_launch,
                              color: Color.fromRGBO(183, 153, 108, 1),
                              size: 40,
                            ),
                            Text(
                              'เรียนออนไลน์',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.coffee,
                              color: Color.fromRGBO(183, 153, 108, 1),
                              size: 40,
                            ),
                            Text(
                              'เลี้ยงชาเย็น',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(41, 41, 41, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'ทำข้อสอบ',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'เกี่ยวกับเรา',
          ),
        ],
        onTap: (int index) {},
        selectedItemColor: const Color.fromARGB(255, 21, 84, 161),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
