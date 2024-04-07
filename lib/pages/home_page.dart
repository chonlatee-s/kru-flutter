import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Container(
                      padding: const EdgeInsets.all(12),
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
                          Padding(
                            padding: EdgeInsets.only(right: 5, left: 5),
                            child: Text(
                              'ดาวน์โหลดข้อสอบฟรี',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สวัสดี, คู่หู',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color(0xff8921aa),
                                Color.fromARGB(255, 214, 69, 185),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                      Text(
                        'วันนี้เป็นอย่างไรบ้าง ?',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 39, 35, 40),
                                Color.fromARGB(255, 96, 83, 94),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 45, bottom: 10),
                    child: Text(
                      'รายการ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 19,
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
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(25),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              context.push('/predict');
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Color.fromRGBO(183, 153, 108, 1),
                                  size: 35,
                                ),
                                Text(
                                  'เสี่ยงเซียมซี',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/agenda');
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Color.fromRGBO(183, 153, 108, 1),
                                  size: 35,
                                ),
                                Text(
                                  'เกณฑ์สอบ',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/guideline');
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.article,
                                  color: Color.fromRGBO(183, 153, 108, 1),
                                  size: 35,
                                ),
                                Text(
                                  'แนวข้อสอบ',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => launchUrl(
                              Uri.parse(
                                  'https://www.youtube.com/@user-cj1wo4od5c/playlists'),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  color: Color.fromRGBO(183, 153, 108, 1),
                                  size: 35,
                                ),
                                Text(
                                  'เรียนออนไลน์',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            context.push('/pay');
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.coffee,
                                  color: Color.fromRGBO(183, 153, 108, 1),
                                  size: 35,
                                ),
                                Text(
                                  'เลี้ยงชาไข่มุก',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),
                              ],
                            ),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'ทำข้อสอบ',
        child: const Icon(
          Icons.edit_note,
          size: 40,
          color: Color.fromRGBO(138, 99, 0, 1),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'เกี่ยวกับเรา',
            ),
          ],
          onTap: (int index) {
            if (index == 1) context.go('/aboutUs');
          },
          selectedItemColor: const Color.fromARGB(255, 21, 84, 161),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
